-- =====================================================
-- Kraken Intelligence Agent
-- Step 9: ML Model Prediction Functions (UDFs)
-- These functions are called by the agent for predictions
-- =====================================================

USE DATABASE KRAKEN_DB;
USE SCHEMA ML;
USE WAREHOUSE KRAKEN_WH;

-- =====================================================
-- 1. FRAUD/AML DETECTION
-- Returns customers with suspicious transaction patterns
-- =====================================================
CREATE OR REPLACE FUNCTION AGENT_GET_FRAUD_ALERTS()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'customer_id', CUSTOMER_ID,
    'username', USERNAME,
    'risk_score', RISK_SCORE,
    'alert_reason', ALERT_REASON,
    'transaction_count_24h', TX_COUNT_24H,
    'volume_24h_usd', VOLUME_24H_USD,
    'country', COUNTRY_CODE
)) FROM (
    SELECT 
        C.CUSTOMER_ID,
        C.USERNAME,
        GREATEST(
            -- Velocity score: many trades in short time
            LEAST(100, (COUNT(T.TRADE_ID) / 50.0) * 100),
            -- Large single transaction score
            LEAST(100, (MAX(T.TOTAL_VALUE_USD) / 100000.0) * 100),
            -- High leverage + volume
            LEAST(100, (AVG(T.LEVERAGE) * SUM(T.TOTAL_VALUE_USD) / 500000.0) * 100)
        )::INT AS RISK_SCORE,
        CASE 
            WHEN COUNT(T.TRADE_ID) > 100 THEN 'High-velocity trading: ' || COUNT(T.TRADE_ID) || ' trades in 24h'
            WHEN MAX(T.TOTAL_VALUE_USD) > 100000 THEN 'Large single transaction: $' || ROUND(MAX(T.TOTAL_VALUE_USD), 2)
            WHEN AVG(T.LEVERAGE) > 3 THEN 'High-leverage pattern with elevated volume'
            ELSE 'Multiple minor risk indicators'
        END AS ALERT_REASON,
        COUNT(T.TRADE_ID) AS TX_COUNT_24H,
        ROUND(SUM(T.TOTAL_VALUE_USD), 2) AS VOLUME_24H_USD,
        C.COUNTRY_CODE
    FROM KRAKEN_DB.RAW.CUSTOMERS C
    JOIN KRAKEN_DB.RAW.TRADES T ON C.CUSTOMER_ID = T.CUSTOMER_ID
    WHERE T.EXECUTED_AT >= DATEADD('hour', -24, CURRENT_TIMESTAMP())
    GROUP BY C.CUSTOMER_ID, C.USERNAME, C.COUNTRY_CODE
    HAVING RISK_SCORE > 60
    ORDER BY RISK_SCORE DESC
    LIMIT 25
)
$$;

-- =====================================================
-- 2. CUSTOMER CHURN PREDICTION
-- Returns customers at high risk of becoming inactive
-- =====================================================
CREATE OR REPLACE FUNCTION AGENT_GET_CHURN_RISK()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'customer_id', CUSTOMER_ID,
    'username', USERNAME,
    'account_tier', ACCOUNT_TIER,
    'churn_probability', CHURN_PROBABILITY,
    'churn_reason', CHURN_REASON,
    'days_since_last_trade', DAYS_INACTIVE,
    'total_lifetime_volume_usd', LIFETIME_VOLUME,
    'open_support_tickets', OPEN_TICKETS
)) FROM (
    SELECT
        C.CUSTOMER_ID,
        C.USERNAME,
        C.ACCOUNT_TIER,
        ROUND(
            (LEAST(1.0, COALESCE(DATEDIFF('day', MAX(T.EXECUTED_AT), CURRENT_TIMESTAMP()), 365) / 90.0) * 0.4) +
            (CASE WHEN COALESCE(COUNT(ST.TICKET_ID), 0) > 3 THEN 0.3 ELSE COALESCE(COUNT(ST.TICKET_ID), 0) * 0.1 END) +
            (CASE WHEN C.TWO_FACTOR_ENABLED = FALSE THEN 0.15 ELSE 0 END) +
            (CASE WHEN DATEDIFF('day', C.LAST_LOGIN_DATE, CURRENT_TIMESTAMP()) > 30 THEN 0.15 ELSE 0 END)
        , 2) AS CHURN_PROBABILITY,
        CASE 
            WHEN COALESCE(DATEDIFF('day', MAX(T.EXECUTED_AT), CURRENT_TIMESTAMP()), 365) > 60 THEN 'Extended inactivity: ' || COALESCE(DATEDIFF('day', MAX(T.EXECUTED_AT), CURRENT_TIMESTAMP()), 365) || ' days since last trade'
            WHEN COALESCE(COUNT(ST.TICKET_ID), 0) > 3 THEN 'High support friction: ' || COUNT(ST.TICKET_ID) || ' tickets filed'
            WHEN DATEDIFF('day', C.LAST_LOGIN_DATE, CURRENT_TIMESTAMP()) > 30 THEN 'Login abandonment: ' || DATEDIFF('day', C.LAST_LOGIN_DATE, CURRENT_TIMESTAMP()) || ' days since login'
            ELSE 'Multiple disengagement signals'
        END AS CHURN_REASON,
        COALESCE(DATEDIFF('day', MAX(T.EXECUTED_AT), CURRENT_TIMESTAMP()), 365) AS DAYS_INACTIVE,
        ROUND(COALESCE(SUM(T.TOTAL_VALUE_USD), 0), 2) AS LIFETIME_VOLUME,
        SUM(CASE WHEN ST.STATUS IN ('Open','In Progress','Waiting') THEN 1 ELSE 0 END) AS OPEN_TICKETS
    FROM KRAKEN_DB.RAW.CUSTOMERS C
    LEFT JOIN KRAKEN_DB.RAW.TRADES T ON C.CUSTOMER_ID = T.CUSTOMER_ID
    LEFT JOIN KRAKEN_DB.RAW.SUPPORT_TICKETS ST ON C.CUSTOMER_ID = ST.CUSTOMER_ID
    WHERE C.IS_ACTIVE = TRUE
    GROUP BY C.CUSTOMER_ID, C.USERNAME, C.ACCOUNT_TIER, C.TWO_FACTOR_ENABLED, C.LAST_LOGIN_DATE
    HAVING CHURN_PROBABILITY > 0.60
    ORDER BY CHURN_PROBABILITY DESC
    LIMIT 30
)
$$;

-- =====================================================
-- 3. TRADING VOLUME FORECAST
-- Returns 7-day volume predictions for top pairs
-- =====================================================
CREATE OR REPLACE FUNCTION AGENT_GET_VOLUME_FORECAST()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'trading_pair', TRADING_PAIR,
    'avg_daily_volume_30d_usd', AVG_DAILY_VOLUME,
    'volume_trend', VOLUME_TREND,
    'predicted_next_7d_volume_usd', PREDICTED_7D_VOLUME,
    'confidence', CONFIDENCE
)) FROM (
    SELECT
        T.TRADING_PAIR,
        ROUND(SUM(T.TOTAL_VALUE_USD) / 30.0, 2) AS AVG_DAILY_VOLUME,
        CASE 
            WHEN SUM(CASE WHEN T.EXECUTED_AT >= DATEADD('day', -7, CURRENT_TIMESTAMP()) THEN T.TOTAL_VALUE_USD ELSE 0 END) >
                 SUM(CASE WHEN T.EXECUTED_AT BETWEEN DATEADD('day', -14, CURRENT_TIMESTAMP()) AND DATEADD('day', -7, CURRENT_TIMESTAMP()) THEN T.TOTAL_VALUE_USD ELSE 0 END)
            THEN 'Increasing'
            ELSE 'Decreasing'
        END AS VOLUME_TREND,
        ROUND(
            SUM(CASE WHEN T.EXECUTED_AT >= DATEADD('day', -7, CURRENT_TIMESTAMP()) THEN T.TOTAL_VALUE_USD ELSE 0 END) *
            CASE 
                WHEN SUM(CASE WHEN T.EXECUTED_AT >= DATEADD('day', -7, CURRENT_TIMESTAMP()) THEN T.TOTAL_VALUE_USD ELSE 0 END) >
                     SUM(CASE WHEN T.EXECUTED_AT BETWEEN DATEADD('day', -14, CURRENT_TIMESTAMP()) AND DATEADD('day', -7, CURRENT_TIMESTAMP()) THEN T.TOTAL_VALUE_USD ELSE 0 END)
                THEN 1.08
                ELSE 0.95
            END
        , 2) AS PREDICTED_7D_VOLUME,
        CASE 
            WHEN COUNT(T.TRADE_ID) > 10000 THEN 'High'
            WHEN COUNT(T.TRADE_ID) > 1000 THEN 'Medium'
            ELSE 'Low'
        END AS CONFIDENCE
    FROM KRAKEN_DB.RAW.TRADES T
    WHERE T.EXECUTED_AT >= DATEADD('day', -30, CURRENT_TIMESTAMP())
      AND T.SETTLEMENT_STATUS = 'Settled'
    GROUP BY T.TRADING_PAIR
    ORDER BY AVG_DAILY_VOLUME DESC
    LIMIT 15
)
$$;

-- =====================================================
-- 4. CUSTOMER LIFETIME VALUE
-- Returns LTV predictions for customer segments
-- =====================================================
CREATE OR REPLACE FUNCTION AGENT_GET_CUSTOMER_LTV()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'customer_id', CUSTOMER_ID,
    'username', USERNAME,
    'account_tier', ACCOUNT_TIER,
    'account_age_days', ACCOUNT_AGE_DAYS,
    'historical_fees_usd', HISTORICAL_FEES,
    'predicted_annual_ltv_usd', PREDICTED_LTV,
    'ltv_segment', LTV_SEGMENT
)) FROM (
    SELECT
        C.CUSTOMER_ID,
        C.USERNAME,
        C.ACCOUNT_TIER,
        DATEDIFF('day', C.REGISTRATION_DATE, CURRENT_TIMESTAMP()) AS ACCOUNT_AGE_DAYS,
        ROUND(COALESCE(SUM(T.FEE_USD), 0), 2) AS HISTORICAL_FEES,
        ROUND(
            COALESCE(SUM(T.FEE_USD), 0) / GREATEST(DATEDIFF('day', C.REGISTRATION_DATE, CURRENT_TIMESTAMP()), 1) * 365 *
            CASE 
                WHEN C.ACCOUNT_TIER = 'Institutional' THEN 1.2
                WHEN C.ACCOUNT_TIER = 'VIP' THEN 1.1
                WHEN C.ACCOUNT_TIER = 'Pro' THEN 1.05
                ELSE 0.9
            END
        , 2) AS PREDICTED_LTV,
        CASE 
            WHEN COALESCE(SUM(T.FEE_USD), 0) / GREATEST(DATEDIFF('day', C.REGISTRATION_DATE, CURRENT_TIMESTAMP()), 1) * 365 > 50000 THEN 'Whale'
            WHEN COALESCE(SUM(T.FEE_USD), 0) / GREATEST(DATEDIFF('day', C.REGISTRATION_DATE, CURRENT_TIMESTAMP()), 1) * 365 > 10000 THEN 'High Value'
            WHEN COALESCE(SUM(T.FEE_USD), 0) / GREATEST(DATEDIFF('day', C.REGISTRATION_DATE, CURRENT_TIMESTAMP()), 1) * 365 > 1000 THEN 'Growth'
            ELSE 'Standard'
        END AS LTV_SEGMENT
    FROM KRAKEN_DB.RAW.CUSTOMERS C
    LEFT JOIN KRAKEN_DB.RAW.TRADES T ON C.CUSTOMER_ID = T.CUSTOMER_ID
    WHERE C.IS_ACTIVE = TRUE
    GROUP BY C.CUSTOMER_ID, C.USERNAME, C.ACCOUNT_TIER, C.REGISTRATION_DATE
    ORDER BY PREDICTED_LTV DESC
    LIMIT 50
)
$$;

-- =====================================================
-- 5. MARKET RISK SCORING
-- Returns risk grades for open futures positions
-- =====================================================
CREATE OR REPLACE FUNCTION AGENT_GET_RISK_SCORES()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'customer_id', CUSTOMER_ID,
    'username', USERNAME,
    'contract_pair', CONTRACT_PAIR,
    'side', SIDE,
    'leverage', LEVERAGE,
    'notional_value_usd', NOTIONAL_VALUE_USD,
    'unrealized_pnl_usd', UNREALIZED_PNL_USD,
    'risk_grade', RISK_GRADE,
    'risk_factors', RISK_FACTORS
)) FROM (
    SELECT
        C.CUSTOMER_ID,
        C.USERNAME,
        FP.CONTRACT_PAIR,
        FP.SIDE,
        FP.LEVERAGE,
        FP.NOTIONAL_VALUE_USD,
        FP.UNREALIZED_PNL_USD,
        CASE 
            WHEN FP.LEVERAGE >= 20 AND FP.UNREALIZED_PNL_USD < -10000 THEN 'F'
            WHEN FP.LEVERAGE >= 15 OR FP.UNREALIZED_PNL_USD < -50000 THEN 'D'
            WHEN FP.LEVERAGE >= 10 OR FP.UNREALIZED_PNL_USD < -20000 THEN 'C'
            WHEN FP.LEVERAGE >= 5 OR FP.UNREALIZED_PNL_USD < -5000 THEN 'B'
            ELSE 'A'
        END AS RISK_GRADE,
        CASE 
            WHEN FP.LEVERAGE >= 20 THEN 'Extreme leverage (' || FP.LEVERAGE || 'x) with significant unrealized loss'
            WHEN FP.LEVERAGE >= 10 THEN 'High leverage (' || FP.LEVERAGE || 'x) position'
            WHEN FP.UNREALIZED_PNL_USD < -20000 THEN 'Large unrealized loss: $' || ABS(FP.UNREALIZED_PNL_USD)
            ELSE 'Moderate position risk'
        END AS RISK_FACTORS
    FROM KRAKEN_DB.RAW.FUTURES_POSITIONS FP
    JOIN KRAKEN_DB.RAW.CUSTOMERS C ON FP.CUSTOMER_ID = C.CUSTOMER_ID
    WHERE FP.STATUS = 'Open'
    ORDER BY 
        CASE RISK_GRADE 
            WHEN 'F' THEN 1 WHEN 'D' THEN 2 WHEN 'C' THEN 3 WHEN 'B' THEN 4 ELSE 5 
        END,
        FP.NOTIONAL_VALUE_USD DESC
    LIMIT 30
)
$$;

-- =====================================================
-- 6. SUPPORT TICKET CLASSIFICATION
-- Returns recent unclassified or misrouted tickets
-- =====================================================
CREATE OR REPLACE FUNCTION AGENT_CLASSIFY_TICKETS()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'ticket_id', TICKET_ID,
    'current_category', CATEGORY,
    'predicted_category', PREDICTED_CATEGORY,
    'confidence', CONFIDENCE,
    'priority_recommendation', PRIORITY_REC,
    'subject', SUBJECT
)) FROM (
    SELECT
        ST.TICKET_ID,
        ST.CATEGORY,
        CASE 
            WHEN LOWER(ST.SUBJECT) LIKE '%withdraw%' OR LOWER(ST.DESCRIPTION) LIKE '%withdraw%' THEN 'Withdrawals'
            WHEN LOWER(ST.SUBJECT) LIKE '%deposit%' OR LOWER(ST.DESCRIPTION) LIKE '%deposit%' THEN 'Deposits'
            WHEN LOWER(ST.SUBJECT) LIKE '%2fa%' OR LOWER(ST.DESCRIPTION) LIKE '%authenticator%' OR LOWER(ST.DESCRIPTION) LIKE '%security%' THEN 'Security'
            WHEN LOWER(ST.SUBJECT) LIKE '%kyc%' OR LOWER(ST.DESCRIPTION) LIKE '%verification%' OR LOWER(ST.DESCRIPTION) LIKE '%identity%' THEN 'Verification'
            WHEN LOWER(ST.SUBJECT) LIKE '%order%' OR LOWER(ST.DESCRIPTION) LIKE '%trade%' OR LOWER(ST.DESCRIPTION) LIKE '%margin%' THEN 'Trading'
            WHEN LOWER(ST.SUBJECT) LIKE '%stake%' OR LOWER(ST.DESCRIPTION) LIKE '%reward%' THEN 'Staking'
            WHEN LOWER(ST.SUBJECT) LIKE '%api%' OR LOWER(ST.DESCRIPTION) LIKE '%api%' THEN 'API'
            ELSE 'Account'
        END AS PREDICTED_CATEGORY,
        CASE 
            WHEN LOWER(ST.SUBJECT) LIKE '%withdraw%' AND LOWER(ST.DESCRIPTION) LIKE '%withdraw%' THEN 0.95
            WHEN LOWER(ST.SUBJECT) LIKE '%2fa%' OR LOWER(ST.SUBJECT) LIKE '%locked%' THEN 0.90
            ELSE 0.75
        END AS CONFIDENCE,
        CASE 
            WHEN LOWER(ST.DESCRIPTION) LIKE '%locked%' OR LOWER(ST.DESCRIPTION) LIKE '%cannot access%' THEN 'Critical'
            WHEN LOWER(ST.DESCRIPTION) LIKE '%fund%' OR LOWER(ST.DESCRIPTION) LIKE '%liquidat%' THEN 'High'
            ELSE ST.PRIORITY
        END AS PRIORITY_REC,
        ST.SUBJECT
    FROM KRAKEN_DB.RAW.SUPPORT_TICKETS ST
    WHERE ST.STATUS IN ('Open', 'In Progress')
    ORDER BY ST.CREATED_AT DESC
    LIMIT 30
)
$$;

SELECT 'Step 9 Complete: All 6 ML prediction UDFs created in KRAKEN_DB.ML schema.' AS STATUS;
