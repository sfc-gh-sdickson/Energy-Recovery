-- =====================================================
-- Kraken Intelligence Agent
-- Step 2: Create Operational Tables
-- =====================================================

USE DATABASE KRAKEN_DB;
USE SCHEMA RAW;
USE WAREHOUSE KRAKEN_WH;

-- =====================================================
-- CUSTOMERS - Trader profiles and account information
-- =====================================================
CREATE OR REPLACE TABLE CUSTOMERS (
    CUSTOMER_ID VARCHAR(36) PRIMARY KEY,
    EMAIL VARCHAR(255) NOT NULL,
    USERNAME VARCHAR(100) NOT NULL,
    FULL_NAME VARCHAR(200),
    ACCOUNT_TIER VARCHAR(20) NOT NULL,          -- 'Standard', 'Pro', 'VIP', 'Institutional'
    KYC_STATUS VARCHAR(20) NOT NULL,            -- 'Pending', 'Verified', 'Enhanced', 'Rejected'
    KYC_LEVEL INT DEFAULT 1,                    -- 1=Basic, 2=Intermediate, 3=Pro, 4=Institutional
    COUNTRY_CODE VARCHAR(3),
    STATE_PROVINCE VARCHAR(100),
    REGISTRATION_DATE TIMESTAMP_NTZ NOT NULL,
    LAST_LOGIN_DATE TIMESTAMP_NTZ,
    IS_ACTIVE BOOLEAN DEFAULT TRUE,
    TWO_FACTOR_ENABLED BOOLEAN DEFAULT FALSE,
    PREFERRED_CURRENCY VARCHAR(10) DEFAULT 'USD',
    REFERRAL_SOURCE VARCHAR(50),                -- 'Organic', 'Referral', 'Social', 'Affiliate', 'Paid'
    TOTAL_DEPOSITS_USD DECIMAL(18,2) DEFAULT 0,
    TOTAL_WITHDRAWALS_USD DECIMAL(18,2) DEFAULT 0,
    ACCOUNT_BALANCE_USD DECIMAL(18,2) DEFAULT 0,
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- TRADES - Spot and margin trade execution records
-- =====================================================
CREATE OR REPLACE TABLE TRADES (
    TRADE_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    TRADING_PAIR VARCHAR(20) NOT NULL,           -- e.g., 'BTC/USD', 'ETH/USD', 'SOL/USDT'
    TRADE_TYPE VARCHAR(10) NOT NULL,             -- 'Spot', 'Margin'
    SIDE VARCHAR(4) NOT NULL,                    -- 'Buy', 'Sell'
    ORDER_TYPE VARCHAR(15) NOT NULL,             -- 'Market', 'Limit', 'StopLoss', 'TakeProfit'
    PRICE DECIMAL(18,8) NOT NULL,
    QUANTITY DECIMAL(18,8) NOT NULL,
    TOTAL_VALUE_USD DECIMAL(18,2) NOT NULL,
    FEE_USD DECIMAL(18,4) NOT NULL,
    FEE_RATE DECIMAL(8,6),                      -- Fee percentage (e.g., 0.0026 = 0.26%)
    LEVERAGE DECIMAL(5,2) DEFAULT 1.0,          -- 1.0 for spot, up to 5x margin
    EXECUTED_AT TIMESTAMP_NTZ NOT NULL,
    SETTLEMENT_STATUS VARCHAR(15) DEFAULT 'Settled',  -- 'Pending', 'Settled', 'Failed'
    PLATFORM VARCHAR(20) DEFAULT 'Web',         -- 'Web', 'Mobile', 'API', 'Pro'
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- ORDERS - Open and historical order book
-- =====================================================
CREATE OR REPLACE TABLE ORDERS (
    ORDER_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    TRADING_PAIR VARCHAR(20) NOT NULL,
    ORDER_TYPE VARCHAR(15) NOT NULL,             -- 'Market', 'Limit', 'StopLoss', 'TakeProfit', 'TrailingStop'
    SIDE VARCHAR(4) NOT NULL,                    -- 'Buy', 'Sell'
    PRICE DECIMAL(18,8),
    QUANTITY DECIMAL(18,8) NOT NULL,
    FILLED_QUANTITY DECIMAL(18,8) DEFAULT 0,
    STATUS VARCHAR(15) NOT NULL,                 -- 'Open', 'Filled', 'Partially Filled', 'Cancelled', 'Expired'
    TIME_IN_FORCE VARCHAR(10) DEFAULT 'GTC',    -- 'GTC', 'IOC', 'FOK', 'GTD'
    CREATED_AT TIMESTAMP_NTZ NOT NULL,
    UPDATED_AT TIMESTAMP_NTZ,
    EXPIRES_AT TIMESTAMP_NTZ
);

-- =====================================================
-- WALLETS - Customer asset balances
-- =====================================================
CREATE OR REPLACE TABLE WALLETS (
    WALLET_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    ASSET_SYMBOL VARCHAR(20) NOT NULL,          -- 'BTC', 'ETH', 'USD', 'USDT', etc.
    ASSET_NAME VARCHAR(100),
    BALANCE DECIMAL(24,8) NOT NULL DEFAULT 0,
    AVAILABLE_BALANCE DECIMAL(24,8) NOT NULL DEFAULT 0,
    LOCKED_BALANCE DECIMAL(24,8) DEFAULT 0,     -- In open orders or staking
    ESTIMATED_VALUE_USD DECIMAL(18,2),
    LAST_UPDATED TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- SUPPORT_TICKETS - Customer support interactions
-- =====================================================
CREATE OR REPLACE TABLE SUPPORT_TICKETS (
    TICKET_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    CATEGORY VARCHAR(50) NOT NULL,              -- 'Account', 'Trading', 'Deposits', 'Withdrawals', 'Security', 'Staking', 'Verification', 'Billing', 'API', 'Other'
    SUBCATEGORY VARCHAR(100),
    PRIORITY VARCHAR(10) NOT NULL,             -- 'Critical', 'High', 'Medium', 'Low'
    STATUS VARCHAR(15) NOT NULL,               -- 'Open', 'In Progress', 'Waiting', 'Resolved', 'Closed'
    SUBJECT VARCHAR(500) NOT NULL,
    DESCRIPTION VARCHAR(5000) NOT NULL,
    RESOLUTION_NOTES VARCHAR(5000),
    ASSIGNED_TEAM VARCHAR(50),                 -- 'Tier1', 'Tier2', 'Tier3', 'Compliance', 'Engineering'
    SATISFACTION_SCORE INT,                    -- 1-5 CSAT
    FIRST_RESPONSE_MINUTES INT,
    RESOLUTION_MINUTES INT,
    CREATED_AT TIMESTAMP_NTZ NOT NULL,
    RESOLVED_AT TIMESTAMP_NTZ,
    PLATFORM VARCHAR(20) DEFAULT 'Web'         -- 'Web', 'Email', 'Chat', 'Phone'
);

-- =====================================================
-- COMPLIANCE_EVENTS - AML/KYC compliance monitoring
-- =====================================================
CREATE OR REPLACE TABLE COMPLIANCE_EVENTS (
    EVENT_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    EVENT_TYPE VARCHAR(50) NOT NULL,            -- 'SAR_Filed', 'Large_Transaction', 'Velocity_Alert', 'Sanctions_Screen', 'PEP_Check', 'Identity_Mismatch', 'Unusual_Pattern'
    RISK_SCORE INT NOT NULL,                   -- 0-100
    RISK_LEVEL VARCHAR(10) NOT NULL,           -- 'Low', 'Medium', 'High', 'Critical'
    IS_FLAGGED BOOLEAN DEFAULT FALSE,
    DESCRIPTION VARCHAR(2000),
    TRANSACTION_IDS ARRAY,                     -- Related transaction IDs
    REVIEW_STATUS VARCHAR(20) NOT NULL,        -- 'Pending', 'Under Review', 'Escalated', 'Cleared', 'Confirmed'
    REVIEWED_BY VARCHAR(100),
    REVIEW_NOTES VARCHAR(2000),
    REGULATORY_REPORT_FILED BOOLEAN DEFAULT FALSE,
    JURISDICTION VARCHAR(50),
    CREATED_AT TIMESTAMP_NTZ NOT NULL,
    REVIEWED_AT TIMESTAMP_NTZ
);

-- =====================================================
-- STAKING_POSITIONS - Staking and earn positions
-- =====================================================
CREATE OR REPLACE TABLE STAKING_POSITIONS (
    POSITION_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    ASSET_SYMBOL VARCHAR(20) NOT NULL,         -- 'ETH', 'SOL', 'DOT', 'ADA', 'ATOM'
    STAKED_AMOUNT DECIMAL(24,8) NOT NULL,
    STAKED_VALUE_USD DECIMAL(18,2),
    APY_RATE DECIMAL(8,4) NOT NULL,            -- e.g., 4.5000 = 4.5%
    REWARDS_EARNED DECIMAL(24,8) DEFAULT 0,
    REWARDS_VALUE_USD DECIMAL(18,2) DEFAULT 0,
    STATUS VARCHAR(15) NOT NULL,               -- 'Active', 'Unbonding', 'Completed', 'Cancelled'
    LOCK_PERIOD_DAYS INT,                      -- NULL for flexible, else 30/60/90/120
    STARTED_AT TIMESTAMP_NTZ NOT NULL,
    UNBONDING_AT TIMESTAMP_NTZ,
    COMPLETED_AT TIMESTAMP_NTZ
);

-- =====================================================
-- MARKET_DATA - OHLCV price data for trading pairs
-- =====================================================
CREATE OR REPLACE TABLE MARKET_DATA (
    MARKET_DATA_ID VARCHAR(36) PRIMARY KEY,
    TRADING_PAIR VARCHAR(20) NOT NULL,
    TIMESTAMP TIMESTAMP_NTZ NOT NULL,
    INTERVAL VARCHAR(5) NOT NULL,              -- '1h', '4h', '1d'
    OPEN_PRICE DECIMAL(18,8) NOT NULL,
    HIGH_PRICE DECIMAL(18,8) NOT NULL,
    LOW_PRICE DECIMAL(18,8) NOT NULL,
    CLOSE_PRICE DECIMAL(18,8) NOT NULL,
    VOLUME DECIMAL(24,8) NOT NULL,
    VOLUME_USD DECIMAL(18,2),
    TRADE_COUNT INT,
    VWAP DECIMAL(18,8)                         -- Volume-weighted average price
);

-- =====================================================
-- FUTURES_POSITIONS - Derivatives/futures trading
-- =====================================================
CREATE OR REPLACE TABLE FUTURES_POSITIONS (
    POSITION_ID VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(36) NOT NULL,
    CONTRACT_PAIR VARCHAR(30) NOT NULL,         -- 'BTC-PERP', 'ETH-PERP', 'SOL-0930'
    CONTRACT_TYPE VARCHAR(15) NOT NULL,         -- 'Perpetual', 'Quarterly', 'Monthly'
    SIDE VARCHAR(5) NOT NULL,                   -- 'Long', 'Short'
    LEVERAGE DECIMAL(5,2) NOT NULL,             -- 1x to 50x
    ENTRY_PRICE DECIMAL(18,8) NOT NULL,
    MARK_PRICE DECIMAL(18,8),
    LIQUIDATION_PRICE DECIMAL(18,8),
    POSITION_SIZE DECIMAL(18,8) NOT NULL,
    NOTIONAL_VALUE_USD DECIMAL(18,2),
    UNREALIZED_PNL_USD DECIMAL(18,2),
    REALIZED_PNL_USD DECIMAL(18,2) DEFAULT 0,
    MARGIN_USED_USD DECIMAL(18,2),
    STATUS VARCHAR(10) NOT NULL,                -- 'Open', 'Closed', 'Liquidated'
    OPENED_AT TIMESTAMP_NTZ NOT NULL,
    CLOSED_AT TIMESTAMP_NTZ
);

SELECT 'Step 2 Complete: All operational tables created in KRAKEN_DB.RAW schema.' AS STATUS;
