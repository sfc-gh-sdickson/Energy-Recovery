/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 05_create_views.sql
  Purpose: Create analytical views for cross-domain analysis
  Execution Order: 5 of 10
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- V_FINANCIAL_SUMMARY: Consolidated financial performance view
-- ============================================================================
CREATE OR REPLACE VIEW V_FINANCIAL_SUMMARY AS
SELECT
    gl.FISCAL_YEAR,
    gl.FISCAL_QUARTER,
    gl.FISCAL_PERIOD,
    gl.ACCOUNT_CATEGORY,
    gl.ACCOUNT_NAME,
    gl.DEPARTMENT,
    gl.COST_CENTER,
    SUM(gl.CREDIT_AMOUNT) AS TOTAL_CREDITS,
    SUM(gl.DEBIT_AMOUNT) AS TOTAL_DEBITS,
    SUM(gl.NET_AMOUNT) AS NET_AMOUNT,
    COUNT(*) AS TRANSACTION_COUNT
FROM ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.GENERAL_LEDGER gl
GROUP BY 1,2,3,4,5,6,7;

-- ============================================================================
-- V_REVENUE_BY_PRODUCT: Revenue breakdown by product line and region
-- ============================================================================
CREATE OR REPLACE VIEW V_REVENUE_BY_PRODUCT AS
SELECT
    YEAR(so.ORDER_DATE) AS ORDER_YEAR,
    QUARTER(so.ORDER_DATE) AS ORDER_QUARTER,
    MONTH(so.ORDER_DATE) AS ORDER_MONTH,
    so.PRODUCT_LINE,
    so.PRODUCT_NAME,
    so.REGION,
    so.COUNTRY,
    so.SALES_REP,
    COUNT(*) AS ORDER_COUNT,
    SUM(so.QUANTITY) AS TOTAL_UNITS,
    SUM(so.TOTAL_AMOUNT) AS TOTAL_REVENUE,
    AVG(so.TOTAL_AMOUNT) AS AVG_ORDER_VALUE,
    AVG(so.DISCOUNT_PERCENT) AS AVG_DISCOUNT
FROM ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.SALES_ORDERS so
GROUP BY 1,2,3,4,5,6,7,8;

-- ============================================================================
-- V_AR_AGING: Accounts receivable aging analysis
-- ============================================================================
CREATE OR REPLACE VIEW V_AR_AGING AS
SELECT
    ar.AGING_BUCKET,
    ar.REGION,
    ar.STATUS,
    COUNT(*) AS INVOICE_COUNT,
    SUM(ar.ORIGINAL_AMOUNT) AS TOTAL_ORIGINAL,
    SUM(ar.BALANCE) AS TOTAL_OUTSTANDING,
    AVG(ar.BALANCE) AS AVG_BALANCE
FROM ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.ACCOUNTS_RECEIVABLE ar
GROUP BY 1,2,3;

-- ============================================================================
-- V_SALES_PIPELINE: CRM pipeline analysis
-- ============================================================================
CREATE OR REPLACE VIEW V_SALES_PIPELINE AS
SELECT
    o.STAGE,
    o.PRODUCT_INTEREST,
    o.APPLICATION,
    o.REGION,
    o.SALES_REP,
    o.LEAD_SOURCE,
    o.COMPETITOR,
    YEAR(o.CLOSE_DATE) AS EXPECTED_CLOSE_YEAR,
    QUARTER(o.CLOSE_DATE) AS EXPECTED_CLOSE_QUARTER,
    COUNT(*) AS OPPORTUNITY_COUNT,
    SUM(o.AMOUNT) AS TOTAL_PIPELINE_VALUE,
    AVG(o.AMOUNT) AS AVG_DEAL_SIZE,
    AVG(o.PROBABILITY) AS AVG_PROBABILITY,
    SUM(o.AMOUNT * o.PROBABILITY / 100) AS WEIGHTED_PIPELINE
FROM ENERGY_RECOVERY_DB.DYNAMICS_CRM.OPPORTUNITIES o
GROUP BY 1,2,3,4,5,6,7,8,9;

-- ============================================================================
-- V_DEVICE_HEALTH: IoT device health and performance
-- ============================================================================
CREATE OR REPLACE VIEW V_DEVICE_HEALTH AS
SELECT
    dr.DEVICE_MODEL,
    dr.PRODUCT_LINE,
    dr.INSTALLATION_SITE,
    dr.SITE_COUNTRY,
    dr.SITE_REGION,
    dr.CUSTOMER_NAME,
    dr.STATUS AS DEVICE_STATUS,
    dr.OPERATING_HOURS,
    t.AVG_ENERGY_RECOVERY_PCT,
    t.AVG_VIBRATION,
    t.AVG_PRESSURE_DIFF,
    t.AVG_TEMPERATURE,
    t.READING_COUNT,
    a.ALARM_COUNT,
    a.CRITICAL_ALARM_COUNT,
    m.MAINTENANCE_COUNT,
    m.TOTAL_MAINTENANCE_COST,
    m.TOTAL_DOWNTIME_HOURS
FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_REGISTRY dr
LEFT JOIN (
    SELECT
        DEVICE_ID,
        ROUND(AVG(ENERGY_RECOVERY_PCT), 2) AS AVG_ENERGY_RECOVERY_PCT,
        ROUND(AVG(VIBRATION_MM_S), 3) AS AVG_VIBRATION,
        ROUND(AVG(PRESSURE_DIFFERENTIAL), 2) AS AVG_PRESSURE_DIFF,
        ROUND(AVG(TEMPERATURE_C), 2) AS AVG_TEMPERATURE,
        COUNT(*) AS READING_COUNT
    FROM ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_TELEMETRY
    GROUP BY DEVICE_ID
) t ON dr.DEVICE_ID = t.DEVICE_ID
LEFT JOIN (
    SELECT
        DEVICE_ID,
        COUNT(*) AS ALARM_COUNT,
        SUM(CASE WHEN ALARM_SEVERITY = 'Critical' THEN 1 ELSE 0 END) AS CRITICAL_ALARM_COUNT
    FROM ENERGY_RECOVERY_DB.SCADA_IOT.ALARMS
    GROUP BY DEVICE_ID
) a ON dr.DEVICE_ID = a.DEVICE_ID
LEFT JOIN (
    SELECT
        DEVICE_ID,
        COUNT(*) AS MAINTENANCE_COUNT,
        SUM(TOTAL_COST) AS TOTAL_MAINTENANCE_COST,
        SUM(DOWNTIME_HOURS) AS TOTAL_DOWNTIME_HOURS
    FROM ENERGY_RECOVERY_DB.SCADA_IOT.MAINTENANCE_LOGS
    GROUP BY DEVICE_ID
) m ON dr.DEVICE_ID = m.DEVICE_ID;

-- ============================================================================
-- V_PRODUCTION_EFFICIENCY: Manufacturing performance
-- ============================================================================
CREATE OR REPLACE VIEW V_PRODUCTION_EFFICIENCY AS
SELECT
    po.PRODUCT_MODEL,
    po.PRODUCT_NAME,
    po.WORK_CENTER,
    po.STATUS,
    po.PRIORITY,
    po.SITE,
    YEAR(po.START_DATE) AS PRODUCTION_YEAR,
    QUARTER(po.START_DATE) AS PRODUCTION_QUARTER,
    COUNT(*) AS ORDER_COUNT,
    SUM(po.QUANTITY_ORDERED) AS TOTAL_ORDERED,
    SUM(po.QUANTITY_COMPLETED) AS TOTAL_COMPLETED,
    SUM(po.QUANTITY_SCRAPPED) AS TOTAL_SCRAPPED,
    AVG(po.YIELD_PERCENT) AS AVG_YIELD,
    AVG(po.CYCLE_TIME_HOURS) AS AVG_CYCLE_TIME
FROM ENERGY_RECOVERY_DB.ORACLE_ERP.PRODUCTION_ORDERS po
GROUP BY 1,2,3,4,5,6,7,8;

-- ============================================================================
-- V_SUPPLY_CHAIN: Supply chain health overview
-- ============================================================================
CREATE OR REPLACE VIEW V_SUPPLY_CHAIN AS
SELECT
    s.SUPPLIER_NAME,
    s.SUPPLIER_TYPE,
    s.CATEGORY,
    s.COUNTRY AS SUPPLIER_COUNTRY,
    s.REGION AS SUPPLIER_REGION,
    s.LEAD_TIME_DAYS,
    s.ON_TIME_DELIVERY_PCT,
    s.QUALITY_RATING,
    s.ANNUAL_SPEND,
    s.IS_CERTIFIED,
    COALESCE(po.TOTAL_PO_VALUE, 0) AS TOTAL_PO_VALUE,
    COALESCE(po.PO_COUNT, 0) AS PO_COUNT,
    COALESCE(po.AVG_FULFILLMENT_DAYS, 0) AS AVG_FULFILLMENT_DAYS
FROM ENERGY_RECOVERY_DB.ORACLE_ERP.SUPPLIERS s
LEFT JOIN (
    SELECT
        SUPPLIER_ID,
        SUM(TOTAL_AMOUNT) AS TOTAL_PO_VALUE,
        COUNT(*) AS PO_COUNT,
        AVG(DATEDIFF('day', ORDER_DATE, COALESCE(RECEIVED_DATE, CURRENT_DATE()))) AS AVG_FULFILLMENT_DAYS
    FROM ENERGY_RECOVERY_DB.ORACLE_ERP.PURCHASE_ORDERS
    GROUP BY SUPPLIER_ID
) po ON s.SUPPLIER_ID = po.SUPPLIER_ID;
