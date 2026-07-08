/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 09_ml_model_functions.sql
  Purpose: ML prediction functions for the Cortex Agent
  Execution Order: 9 of 10
  
  Functions:
    1. PREDICT_PX_FAILURE() - Predict device failures within 30 days
    2. SCORE_ENERGY_EFFICIENCY() - Score device energy recovery efficiency
    3. FORECAST_DEMAND() - Forecast product demand by region/quarter
    4. CALCULATE_EQUIPMENT_HEALTH() - Composite equipment health score
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE SCHEMA ML_MODELS;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- FUNCTION 1: Predict PX Device Failure (next 30 days)
-- Returns devices at risk based on vibration, efficiency, temperature trends
-- ============================================================================
CREATE OR REPLACE FUNCTION PREDICT_PX_FAILURE()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'device_id', DEVICE_ID,
    'serial_number', SERIAL_NUMBER,
    'device_model', DEVICE_MODEL,
    'installation_site', INSTALLATION_SITE,
    'customer_name', CUSTOMER_NAME,
    'risk_score', RISK_SCORE,
    'risk_level', CASE
        WHEN RISK_SCORE >= 80 THEN 'Critical'
        WHEN RISK_SCORE >= 60 THEN 'High'
        WHEN RISK_SCORE >= 40 THEN 'Medium'
        ELSE 'Low'
    END,
    'primary_risk_factor', PRIMARY_RISK_FACTOR,
    'recommended_action', RECOMMENDED_ACTION,
    'operating_hours', OPERATING_HOURS,
    'days_since_last_service', DAYS_SINCE_SERVICE
)) FROM (
    SELECT
        dr.DEVICE_ID,
        dr.SERIAL_NUMBER,
        dr.DEVICE_MODEL,
        dr.INSTALLATION_SITE,
        dr.CUSTOMER_NAME,
        dr.OPERATING_HOURS,
        DATEDIFF('day', dr.LAST_SERVICE_DATE, CURRENT_DATE()) AS DAYS_SINCE_SERVICE,
        ROUND(
            LEAST(100,
                CASE WHEN t.AVG_VIBRATION > 5.0 THEN 40 WHEN t.AVG_VIBRATION > 3.5 THEN 20 ELSE 0 END +
                CASE WHEN t.AVG_EFFICIENCY < 94 THEN 30 WHEN t.AVG_EFFICIENCY < 96 THEN 15 ELSE 0 END +
                CASE WHEN t.AVG_TEMP > 38 THEN 20 WHEN t.AVG_TEMP > 35 THEN 10 ELSE 0 END +
                CASE WHEN dr.OPERATING_HOURS > 100000 THEN 15 WHEN dr.OPERATING_HOURS > 75000 THEN 8 ELSE 0 END +
                CASE WHEN DAYS_SINCE_SERVICE > 365 THEN 10 ELSE 0 END
            ), 2
        ) AS RISK_SCORE,
        CASE
            WHEN t.AVG_VIBRATION > 5.0 THEN 'High vibration - possible bearing wear'
            WHEN t.AVG_EFFICIENCY < 94 THEN 'Low efficiency - possible seal degradation'
            WHEN t.AVG_TEMP > 38 THEN 'Elevated temperature - cooling issue'
            WHEN dr.OPERATING_HOURS > 100000 THEN 'High operating hours - scheduled overhaul needed'
            ELSE 'Multiple minor factors'
        END AS PRIMARY_RISK_FACTOR,
        CASE
            WHEN t.AVG_VIBRATION > 5.0 THEN 'Schedule bearing inspection and replacement within 14 days'
            WHEN t.AVG_EFFICIENCY < 94 THEN 'Schedule seal kit replacement within 30 days'
            WHEN t.AVG_TEMP > 38 THEN 'Inspect cooling system and verify operating conditions'
            WHEN dr.OPERATING_HOURS > 100000 THEN 'Plan major overhaul during next scheduled shutdown'
            ELSE 'Continue monitoring, increase inspection frequency'
        END AS RECOMMENDED_ACTION
    FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_REGISTRY dr
    JOIN (
        SELECT
            DEVICE_ID,
            AVG(VIBRATION_MM_S) AS AVG_VIBRATION,
            AVG(ENERGY_RECOVERY_PCT) AS AVG_EFFICIENCY,
            AVG(TEMPERATURE_C) AS AVG_TEMP
        FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_TELEMETRY
        GROUP BY DEVICE_ID
    ) t ON dr.DEVICE_ID = t.DEVICE_ID
    WHERE dr.STATUS = 'Active'
    QUALIFY RISK_SCORE >= 40
    ORDER BY RISK_SCORE DESC
    LIMIT 50
)
$$;

-- ============================================================================
-- FUNCTION 2: Score Energy Efficiency
-- Returns efficiency scores for devices compared to design specifications
-- ============================================================================
CREATE OR REPLACE FUNCTION SCORE_ENERGY_EFFICIENCY()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'device_model', DEVICE_MODEL,
    'site_region', SITE_REGION,
    'device_count', DEVICE_COUNT,
    'avg_efficiency_pct', AVG_EFFICIENCY,
    'design_efficiency_pct', DESIGN_EFFICIENCY,
    'efficiency_gap_pct', ROUND(DESIGN_EFFICIENCY - AVG_EFFICIENCY, 2),
    'efficiency_score', EFFICIENCY_SCORE,
    'rating', CASE
        WHEN EFFICIENCY_SCORE >= 95 THEN 'Excellent'
        WHEN EFFICIENCY_SCORE >= 85 THEN 'Good'
        WHEN EFFICIENCY_SCORE >= 70 THEN 'Fair'
        ELSE 'Poor - Action Required'
    END,
    'potential_energy_savings_kwh', POTENTIAL_SAVINGS
)) FROM (
    SELECT
        dr.DEVICE_MODEL,
        dr.SITE_REGION,
        COUNT(*) AS DEVICE_COUNT,
        ROUND(AVG(t.AVG_EFF), 2) AS AVG_EFFICIENCY,
        CASE
            WHEN dr.DEVICE_MODEL = 'PX-Q650' THEN 98.7
            WHEN dr.DEVICE_MODEL = 'PX-Q400' THEN 98.0
            WHEN dr.DEVICE_MODEL = 'PX-220' THEN 96.5
            WHEN dr.DEVICE_MODEL = 'PX-G1300' THEN 95.0
            ELSE 96.0
        END AS DESIGN_EFFICIENCY,
        ROUND(AVG(t.AVG_EFF) / CASE
            WHEN dr.DEVICE_MODEL = 'PX-Q650' THEN 98.7
            WHEN dr.DEVICE_MODEL = 'PX-Q400' THEN 98.0
            WHEN dr.DEVICE_MODEL = 'PX-220' THEN 96.5
            WHEN dr.DEVICE_MODEL = 'PX-G1300' THEN 95.0
            ELSE 96.0
        END * 100, 1) AS EFFICIENCY_SCORE,
        ROUND(COUNT(*) * (CASE
            WHEN dr.DEVICE_MODEL = 'PX-Q650' THEN 98.7
            WHEN dr.DEVICE_MODEL = 'PX-Q400' THEN 98.0
            WHEN dr.DEVICE_MODEL = 'PX-220' THEN 96.5
            ELSE 95.0
        END - AVG(t.AVG_EFF)) * 250, 0) AS POTENTIAL_SAVINGS
    FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_REGISTRY dr
    JOIN (
        SELECT DEVICE_ID, AVG(ENERGY_RECOVERY_PCT) AS AVG_EFF
        FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_TELEMETRY
        GROUP BY DEVICE_ID
    ) t ON dr.DEVICE_ID = t.DEVICE_ID
    WHERE dr.STATUS = 'Active'
    GROUP BY dr.DEVICE_MODEL, dr.SITE_REGION
    ORDER BY AVG_EFFICIENCY ASC
    LIMIT 30
)
$$;

-- ============================================================================
-- FUNCTION 3: Forecast Demand by Region and Quarter
-- Returns demand forecast based on historical orders and pipeline
-- ============================================================================
CREATE OR REPLACE FUNCTION FORECAST_DEMAND()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'product_line', PRODUCT_LINE,
    'region', REGION,
    'forecast_quarter', FORECAST_QUARTER,
    'historical_units', HISTORICAL_UNITS,
    'pipeline_units', PIPELINE_UNITS,
    'forecast_units', FORECAST_UNITS,
    'forecast_revenue', FORECAST_REVENUE,
    'confidence', CONFIDENCE,
    'growth_rate_pct', GROWTH_RATE
)) FROM (
    SELECT
        so.PRODUCT_LINE,
        so.REGION,
        'Q' || QUARTER(DATEADD('quarter', 1, CURRENT_DATE())) || ' ' || YEAR(DATEADD('quarter', 1, CURRENT_DATE())) AS FORECAST_QUARTER,
        SUM(so.QUANTITY) AS HISTORICAL_UNITS,
        COALESCE(p.PIPELINE_UNITS, 0) AS PIPELINE_UNITS,
        ROUND(SUM(so.QUANTITY) * 1.08 + COALESCE(p.PIPELINE_UNITS, 0) * 0.3, 0) AS FORECAST_UNITS,
        ROUND((SUM(so.QUANTITY) * 1.08 + COALESCE(p.PIPELINE_UNITS, 0) * 0.3) * AVG(so.UNIT_PRICE), 2) AS FORECAST_REVENUE,
        CASE
            WHEN COALESCE(p.PIPELINE_UNITS, 0) > SUM(so.QUANTITY) * 0.5 THEN 'High'
            WHEN COALESCE(p.PIPELINE_UNITS, 0) > SUM(so.QUANTITY) * 0.25 THEN 'Medium'
            ELSE 'Low'
        END AS CONFIDENCE,
        ROUND((SUM(so.QUANTITY) * 1.08 - SUM(so.QUANTITY)) / NULLIF(SUM(so.QUANTITY), 0) * 100, 1) AS GROWTH_RATE
    FROM ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.SALES_ORDERS so
    LEFT JOIN (
        SELECT
            PRODUCT_INTEREST AS PRODUCT_LINE,
            REGION,
            SUM(AMOUNT / 200000) AS PIPELINE_UNITS
        FROM ENERGY_RECOVERY_DB.DYNAMICS_CRM.OPPORTUNITIES
        WHERE STAGE NOT IN ('Close Won', 'Close Lost')
        GROUP BY 1, 2
    ) p ON so.PRODUCT_LINE = p.PRODUCT_LINE AND so.REGION = p.REGION
    WHERE so.ORDER_DATE >= DATEADD('year', -1, CURRENT_DATE())
    GROUP BY so.PRODUCT_LINE, so.REGION, p.PIPELINE_UNITS
    ORDER BY FORECAST_REVENUE DESC
    LIMIT 25
)
$$;

-- ============================================================================
-- FUNCTION 4: Calculate Equipment Health Score
-- Returns composite health score combining multiple factors
-- ============================================================================
CREATE OR REPLACE FUNCTION CALCULATE_EQUIPMENT_HEALTH()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'device_id', DEVICE_ID,
    'serial_number', SERIAL_NUMBER,
    'device_model', DEVICE_MODEL,
    'installation_site', INSTALLATION_SITE,
    'health_score', HEALTH_SCORE,
    'health_status', CASE
        WHEN HEALTH_SCORE >= 90 THEN 'Excellent'
        WHEN HEALTH_SCORE >= 75 THEN 'Good'
        WHEN HEALTH_SCORE >= 60 THEN 'Fair'
        WHEN HEALTH_SCORE >= 40 THEN 'Poor'
        ELSE 'Critical'
    END,
    'efficiency_score', EFFICIENCY_COMPONENT,
    'vibration_score', VIBRATION_COMPONENT,
    'maintenance_score', MAINTENANCE_COMPONENT,
    'age_score', AGE_COMPONENT,
    'top_concern', TOP_CONCERN
)) FROM (
    SELECT
        dr.DEVICE_ID,
        dr.SERIAL_NUMBER,
        dr.DEVICE_MODEL,
        dr.INSTALLATION_SITE,
        ROUND(
            t.EFFICIENCY_COMPONENT * 0.35 +
            t.VIBRATION_COMPONENT * 0.30 +
            m.MAINTENANCE_COMPONENT * 0.20 +
            CASE
                WHEN dr.OPERATING_HOURS < 25000 THEN 100
                WHEN dr.OPERATING_HOURS < 50000 THEN 90
                WHEN dr.OPERATING_HOURS < 75000 THEN 75
                WHEN dr.OPERATING_HOURS < 100000 THEN 60
                ELSE 40
            END * 0.15
        , 1) AS HEALTH_SCORE,
        ROUND(t.EFFICIENCY_COMPONENT, 1) AS EFFICIENCY_COMPONENT,
        ROUND(t.VIBRATION_COMPONENT, 1) AS VIBRATION_COMPONENT,
        ROUND(m.MAINTENANCE_COMPONENT, 1) AS MAINTENANCE_COMPONENT,
        ROUND(CASE
            WHEN dr.OPERATING_HOURS < 25000 THEN 100
            WHEN dr.OPERATING_HOURS < 50000 THEN 90
            WHEN dr.OPERATING_HOURS < 75000 THEN 75
            WHEN dr.OPERATING_HOURS < 100000 THEN 60
            ELSE 40
        END, 1) AS AGE_COMPONENT,
        CASE
            WHEN t.VIBRATION_COMPONENT < 50 THEN 'High vibration - bearing inspection needed'
            WHEN t.EFFICIENCY_COMPONENT < 60 THEN 'Low efficiency - seal replacement recommended'
            WHEN m.MAINTENANCE_COMPONENT < 50 THEN 'Overdue for maintenance'
            WHEN dr.OPERATING_HOURS > 100000 THEN 'High operating hours - plan overhaul'
            ELSE 'No immediate concerns'
        END AS TOP_CONCERN
    FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_REGISTRY dr
    JOIN (
        SELECT
            DEVICE_ID,
            CASE
                WHEN AVG(ENERGY_RECOVERY_PCT) >= 97 THEN 100
                WHEN AVG(ENERGY_RECOVERY_PCT) >= 95 THEN 85
                WHEN AVG(ENERGY_RECOVERY_PCT) >= 93 THEN 65
                ELSE 40
            END AS EFFICIENCY_COMPONENT,
            CASE
                WHEN AVG(VIBRATION_MM_S) < 2.0 THEN 100
                WHEN AVG(VIBRATION_MM_S) < 3.5 THEN 80
                WHEN AVG(VIBRATION_MM_S) < 5.0 THEN 55
                ELSE 30
            END AS VIBRATION_COMPONENT
        FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_TELEMETRY
        GROUP BY DEVICE_ID
    ) t ON dr.DEVICE_ID = t.DEVICE_ID
    LEFT JOIN (
        SELECT
            DEVICE_ID,
            CASE
                WHEN MAX(END_DATE) >= DATEADD('month', -6, CURRENT_TIMESTAMP()) THEN 90
                WHEN MAX(END_DATE) >= DATEADD('year', -1, CURRENT_TIMESTAMP()) THEN 70
                ELSE 40
            END AS MAINTENANCE_COMPONENT
        FROM ENERGY_RECOVERY_DB.SCADA_IOT.MAINTENANCE_LOGS
        WHERE STATUS = 'Completed'
        GROUP BY DEVICE_ID
    ) m ON dr.DEVICE_ID = m.DEVICE_ID
    WHERE dr.STATUS = 'Active'
    ORDER BY HEALTH_SCORE ASC
    LIMIT 50
)
$$;
