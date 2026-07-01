-- =====================================================
-- Kraken Intelligence Agent
-- Step 4: Synthetic Data Generation
-- Generates realistic test data for all tables
-- =====================================================

USE DATABASE KRAKEN_DB;
USE SCHEMA RAW;
USE WAREHOUSE KRAKEN_WH;

-- =====================================================
-- CUSTOMERS (10,000 records)
-- =====================================================
INSERT INTO CUSTOMERS (
    CUSTOMER_ID, EMAIL, USERNAME, FULL_NAME, ACCOUNT_TIER, KYC_STATUS, KYC_LEVEL,
    COUNTRY_CODE, STATE_PROVINCE, REGISTRATION_DATE, LAST_LOGIN_DATE, IS_ACTIVE,
    TWO_FACTOR_ENABLED, PREFERRED_CURRENCY, REFERRAL_SOURCE,
    TOTAL_DEPOSITS_USD, TOTAL_WITHDRAWALS_USD, ACCOUNT_BALANCE_USD
)
SELECT
    UUID_STRING() AS CUSTOMER_ID,
    LOWER(CONCAT(
        ARRAY_CONSTRUCT('alex','sam','jordan','taylor','casey','morgan','riley','quinn','avery','blake','drew','logan','reese','sky','kai','nova','remy','sage','ari','cam')[MOD(SEQ4(), 20)],
        '.',
        ARRAY_CONSTRUCT('smith','johnson','williams','brown','jones','garcia','miller','davis','rodriguez','martinez','hernandez','lopez','gonzalez','wilson','anderson','thomas','taylor','moore','jackson','martin')[MOD(SEQ4() + 7, 20)],
        SEQ4(),
        '@',
        ARRAY_CONSTRUCT('gmail.com','yahoo.com','outlook.com','protonmail.com','icloud.com')[MOD(SEQ4(), 5)]
    )) AS EMAIL,
    CONCAT(
        ARRAY_CONSTRUCT('crypto','trader','hodl','moon','whale','degen','alpha','bull','bear','sat','stack','chain','block','node','validator','miner','yield','stake','swap','pool')[MOD(SEQ4(), 20)],
        '_',
        ARRAY_CONSTRUCT('king','master','pro','elite','guru','wizard','ninja','boss','chief','lord')[MOD(SEQ4() + 3, 10)],
        MOD(SEQ4(), 9999)
    ) AS USERNAME,
    CONCAT(
        ARRAY_CONSTRUCT('Alex','Sam','Jordan','Taylor','Casey','Morgan','Riley','Quinn','Avery','Blake','Drew','Logan','Reese','Sky','Kai','Nova','Remy','Sage','Ari','Cameron')[MOD(SEQ4(), 20)],
        ' ',
        ARRAY_CONSTRUCT('Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Rodriguez','Martinez','Hernandez','Lopez','Gonzalez','Wilson','Anderson','Thomas','Taylor','Moore','Jackson','Martin')[MOD(SEQ4() + 7, 20)]
    ) AS FULL_NAME,
    CASE 
        WHEN MOD(SEQ4(), 100) < 60 THEN 'Standard'
        WHEN MOD(SEQ4(), 100) < 85 THEN 'Pro'
        WHEN MOD(SEQ4(), 100) < 97 THEN 'VIP'
        ELSE 'Institutional'
    END AS ACCOUNT_TIER,
    CASE 
        WHEN MOD(SEQ4(), 100) < 5 THEN 'Pending'
        WHEN MOD(SEQ4(), 100) < 90 THEN 'Verified'
        WHEN MOD(SEQ4(), 100) < 98 THEN 'Enhanced'
        ELSE 'Rejected'
    END AS KYC_STATUS,
    CASE 
        WHEN MOD(SEQ4(), 100) < 5 THEN 1
        WHEN MOD(SEQ4(), 100) < 60 THEN 2
        WHEN MOD(SEQ4(), 100) < 97 THEN 3
        ELSE 4
    END AS KYC_LEVEL,
    ARRAY_CONSTRUCT('US','GB','DE','CA','AU','JP','SG','CH','NL','FR','KR','BR','IN','AE','HK','ES','IT','SE','NO','NZ')[MOD(SEQ4(), 20)] AS COUNTRY_CODE,
    CASE 
        WHEN MOD(SEQ4(), 20) = 0 THEN ARRAY_CONSTRUCT('California','New York','Texas','Florida','Illinois','Washington','Colorado','Massachusetts','Virginia','Georgia')[MOD(SEQ4(), 10)]
        ELSE NULL
    END AS STATE_PROVINCE,
    DATEADD('day', -UNIFORM(30, 2000, RANDOM(SEQ4())), CURRENT_TIMESTAMP()) AS REGISTRATION_DATE,
    DATEADD('hour', -UNIFORM(1, 720, RANDOM(SEQ4() + 1)), CURRENT_TIMESTAMP()) AS LAST_LOGIN_DATE,
    CASE WHEN MOD(SEQ4(), 100) < 92 THEN TRUE ELSE FALSE END AS IS_ACTIVE,
    CASE WHEN MOD(SEQ4(), 100) < 75 THEN TRUE ELSE FALSE END AS TWO_FACTOR_ENABLED,
    ARRAY_CONSTRUCT('USD','EUR','GBP','CAD','AUD','JPY','CHF','SGD')[MOD(SEQ4(), 8)] AS PREFERRED_CURRENCY,
    ARRAY_CONSTRUCT('Organic','Organic','Referral','Social','Affiliate','Paid','Organic','Referral')[MOD(SEQ4(), 8)] AS REFERRAL_SOURCE,
    ROUND(UNIFORM(100, 5000000, RANDOM(SEQ4() + 2))::DECIMAL(18,2) * 
        CASE 
            WHEN MOD(SEQ4(), 100) >= 97 THEN 50  -- Institutional
            WHEN MOD(SEQ4(), 100) >= 85 THEN 10  -- VIP
            WHEN MOD(SEQ4(), 100) >= 60 THEN 3   -- Pro
            ELSE 1
        END, 2) AS TOTAL_DEPOSITS_USD,
    ROUND(UNIFORM(50, 3000000, RANDOM(SEQ4() + 3))::DECIMAL(18,2) * 
        CASE 
            WHEN MOD(SEQ4(), 100) >= 97 THEN 40
            WHEN MOD(SEQ4(), 100) >= 85 THEN 8
            WHEN MOD(SEQ4(), 100) >= 60 THEN 2.5
            ELSE 0.8
        END, 2) AS TOTAL_WITHDRAWALS_USD,
    ROUND(UNIFORM(0, 2000000, RANDOM(SEQ4() + 4))::DECIMAL(18,2) * 
        CASE 
            WHEN MOD(SEQ4(), 100) >= 97 THEN 20
            WHEN MOD(SEQ4(), 100) >= 85 THEN 5
            WHEN MOD(SEQ4(), 100) >= 60 THEN 2
            ELSE 1
        END, 2) AS ACCOUNT_BALANCE_USD
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

-- =====================================================
-- TRADES (500,000 records)
-- =====================================================
INSERT INTO TRADES (
    TRADE_ID, CUSTOMER_ID, TRADING_PAIR, TRADE_TYPE, SIDE, ORDER_TYPE,
    PRICE, QUANTITY, TOTAL_VALUE_USD, FEE_USD, FEE_RATE, LEVERAGE,
    EXECUTED_AT, SETTLEMENT_STATUS, PLATFORM
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ACCOUNT_TIER, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS WHERE IS_ACTIVE = TRUE
)
SELECT
    UUID_STRING() AS TRADE_ID,
    CP.CUSTOMER_ID,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'BTC/USD'
        WHEN 1 THEN 'ETH/USD'
        WHEN 2 THEN 'SOL/USD'
        WHEN 3 THEN 'XRP/USD'
        WHEN 4 THEN 'ADA/USD'
        WHEN 5 THEN 'DOT/USD'
        WHEN 6 THEN 'AVAX/USD'
        WHEN 7 THEN 'LINK/USD'
        WHEN 8 THEN 'BTC/EUR'
        WHEN 9 THEN 'ETH/EUR'
        WHEN 10 THEN 'SOL/USDT'
        WHEN 11 THEN 'ATOM/USD'
        WHEN 12 THEN 'MATIC/USD'
        WHEN 13 THEN 'UNI/USD'
        ELSE 'AAVE/USD'
    END AS TRADING_PAIR,
    CASE WHEN MOD(SEQ4(), 10) < 8 THEN 'Spot' ELSE 'Margin' END AS TRADE_TYPE,
    CASE WHEN MOD(SEQ4(), 2) = 0 THEN 'Buy' ELSE 'Sell' END AS SIDE,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Market'
        WHEN 1 THEN 'Market'
        WHEN 2 THEN 'Market'
        WHEN 3 THEN 'Limit'
        WHEN 4 THEN 'Limit'
        WHEN 5 THEN 'Limit'
        WHEN 6 THEN 'Limit'
        WHEN 7 THEN 'StopLoss'
        WHEN 8 THEN 'StopLoss'
        ELSE 'TakeProfit'
    END AS ORDER_TYPE,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN UNIFORM(25000, 70000, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 1 THEN UNIFORM(1200, 4500, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 2 THEN UNIFORM(15, 250, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 3 THEN UNIFORM(0.3, 2.5, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 4 THEN UNIFORM(0.2, 1.2, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 5 THEN UNIFORM(3, 50, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 6 THEN UNIFORM(10, 100, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 7 THEN UNIFORM(5, 30, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 8 THEN UNIFORM(25000, 70000, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 9 THEN UNIFORM(1200, 4500, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 10 THEN UNIFORM(15, 250, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 11 THEN UNIFORM(5, 20, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 12 THEN UNIFORM(0.5, 2, RANDOM(SEQ4()))::DECIMAL(18,8)
        WHEN 13 THEN UNIFORM(3, 15, RANDOM(SEQ4()))::DECIMAL(18,8)
        ELSE UNIFORM(50, 400, RANDOM(SEQ4()))::DECIMAL(18,8)
    END AS PRICE,
    CASE 
        WHEN CP.ACCOUNT_TIER = 'Institutional' THEN UNIFORM(1, 100, RANDOM(SEQ4() + 10))::DECIMAL(18,8)
        WHEN CP.ACCOUNT_TIER = 'VIP' THEN UNIFORM(0.1, 20, RANDOM(SEQ4() + 10))::DECIMAL(18,8)
        WHEN CP.ACCOUNT_TIER = 'Pro' THEN UNIFORM(0.01, 5, RANDOM(SEQ4() + 10))::DECIMAL(18,8)
        ELSE UNIFORM(0.001, 1, RANDOM(SEQ4() + 10))::DECIMAL(18,8)
    END AS QUANTITY,
    0 AS TOTAL_VALUE_USD,  -- Will be calculated
    0 AS FEE_USD,          -- Will be calculated
    CASE 
        WHEN CP.ACCOUNT_TIER = 'Institutional' THEN 0.0008
        WHEN CP.ACCOUNT_TIER = 'VIP' THEN 0.0012
        WHEN CP.ACCOUNT_TIER = 'Pro' THEN 0.0020
        ELSE 0.0026
    END AS FEE_RATE,
    CASE WHEN MOD(SEQ4(), 10) >= 8 THEN UNIFORM(2, 5, RANDOM(SEQ4() + 5))::DECIMAL(5,2) ELSE 1.0 END AS LEVERAGE,
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM(SEQ4() + 6)), CURRENT_TIMESTAMP()) AS EXECUTED_AT,
    CASE WHEN MOD(SEQ4(), 1000) < 998 THEN 'Settled' ELSE 'Failed' END AS SETTLEMENT_STATUS,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Web'
        WHEN 1 THEN 'Web'
        WHEN 2 THEN 'Mobile'
        WHEN 3 THEN 'Mobile'
        WHEN 4 THEN 'Mobile'
        WHEN 5 THEN 'API'
        WHEN 6 THEN 'API'
        WHEN 7 THEN 'API'
        WHEN 8 THEN 'Pro'
        ELSE 'Pro'
    END AS PLATFORM
FROM TABLE(GENERATOR(ROWCOUNT => 500000)) G
JOIN CUSTOMER_POOL CP ON CP.RN = MOD(SEQ4(), (SELECT COUNT(*) FROM CUSTOMER_POOL)) + 1;

-- Update calculated fields
UPDATE TRADES SET
    TOTAL_VALUE_USD = ROUND(PRICE * QUANTITY, 2),
    FEE_USD = ROUND(PRICE * QUANTITY * FEE_RATE, 4);

-- =====================================================
-- ORDERS (50,000 records)
-- =====================================================
INSERT INTO ORDERS (
    ORDER_ID, CUSTOMER_ID, TRADING_PAIR, ORDER_TYPE, SIDE, PRICE, QUANTITY,
    FILLED_QUANTITY, STATUS, TIME_IN_FORCE, CREATED_AT, UPDATED_AT
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS WHERE IS_ACTIVE = TRUE
)
SELECT
    UUID_STRING(),
    CP.CUSTOMER_ID,
    ARRAY_CONSTRUCT('BTC/USD','ETH/USD','SOL/USD','XRP/USD','ADA/USD','DOT/USD','AVAX/USD','LINK/USD','ATOM/USD','MATIC/USD')[MOD(SEQ4(), 10)] AS TRADING_PAIR,
    ARRAY_CONSTRUCT('Limit','Limit','Limit','StopLoss','StopLoss','TakeProfit','TrailingStop','Market')[MOD(SEQ4(), 8)] AS ORDER_TYPE,
    CASE WHEN MOD(SEQ4(), 2) = 0 THEN 'Buy' ELSE 'Sell' END AS SIDE,
    UNIFORM(100, 70000, RANDOM(SEQ4()))::DECIMAL(18,8) AS PRICE,
    UNIFORM(0.001, 10, RANDOM(SEQ4() + 1))::DECIMAL(18,8) AS QUANTITY,
    CASE 
        WHEN MOD(SEQ4(), 5) < 2 THEN UNIFORM(0.001, 10, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN MOD(SEQ4(), 5) = 2 THEN UNIFORM(0.0001, 5, RANDOM(SEQ4() + 2))::DECIMAL(18,8)
        ELSE 0
    END AS FILLED_QUANTITY,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Filled'
        WHEN 1 THEN 'Filled'
        WHEN 2 THEN 'Partially Filled'
        WHEN 3 THEN 'Open'
        ELSE 'Cancelled'
    END AS STATUS,
    ARRAY_CONSTRUCT('GTC','GTC','GTC','IOC','FOK','GTD')[MOD(SEQ4(), 6)] AS TIME_IN_FORCE,
    DATEADD('minute', -UNIFORM(1, 43200, RANDOM(SEQ4() + 3)), CURRENT_TIMESTAMP()) AS CREATED_AT,
    DATEADD('minute', -UNIFORM(1, 43000, RANDOM(SEQ4() + 4)), CURRENT_TIMESTAMP()) AS UPDATED_AT
FROM TABLE(GENERATOR(ROWCOUNT => 50000)) G
JOIN CUSTOMER_POOL CP ON CP.RN = MOD(SEQ4(), (SELECT COUNT(*) FROM CUSTOMER_POOL)) + 1;

-- =====================================================
-- WALLETS (30,000 records - ~3 assets per customer)
-- =====================================================
INSERT INTO WALLETS (
    WALLET_ID, CUSTOMER_ID, ASSET_SYMBOL, ASSET_NAME, BALANCE, AVAILABLE_BALANCE,
    LOCKED_BALANCE, ESTIMATED_VALUE_USD
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ACCOUNT_TIER, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS
),
ASSETS AS (
    SELECT COLUMN1 AS ASSET_SYMBOL, COLUMN2 AS ASSET_NAME, COLUMN3 AS USD_PRICE
    FROM VALUES 
        ('BTC', 'Bitcoin', 60000), ('ETH', 'Ethereum', 3200), ('SOL', 'Solana', 150),
        ('USD', 'US Dollar', 1), ('USDT', 'Tether', 1), ('XRP', 'XRP', 1.5),
        ('ADA', 'Cardano', 0.6), ('DOT', 'Polkadot', 8), ('AVAX', 'Avalanche', 40),
        ('LINK', 'Chainlink', 18)
)
SELECT
    UUID_STRING(),
    CP.CUSTOMER_ID,
    A.ASSET_SYMBOL,
    A.ASSET_NAME,
    ROUND(UNIFORM(0.0001, 100, RANDOM(SEQ4()))::DECIMAL(24,8) * 
        CASE WHEN CP.ACCOUNT_TIER IN ('VIP','Institutional') THEN 50 ELSE 1 END, 8) AS BALANCE,
    ROUND(UNIFORM(0.0001, 80, RANDOM(SEQ4() + 1))::DECIMAL(24,8) * 
        CASE WHEN CP.ACCOUNT_TIER IN ('VIP','Institutional') THEN 50 ELSE 1 END, 8) AS AVAILABLE_BALANCE,
    ROUND(UNIFORM(0, 20, RANDOM(SEQ4() + 2))::DECIMAL(24,8), 8) AS LOCKED_BALANCE,
    0 AS ESTIMATED_VALUE_USD
FROM CUSTOMER_POOL CP
CROSS JOIN ASSETS A
WHERE MOD(HASH(CP.CUSTOMER_ID || A.ASSET_SYMBOL), 3) = 0
LIMIT 30000;

-- =====================================================
-- SUPPORT_TICKETS (25,000 records)
-- =====================================================
INSERT INTO SUPPORT_TICKETS (
    TICKET_ID, CUSTOMER_ID, CATEGORY, SUBCATEGORY, PRIORITY, STATUS, SUBJECT,
    DESCRIPTION, RESOLUTION_NOTES, ASSIGNED_TEAM, SATISFACTION_SCORE,
    FIRST_RESPONSE_MINUTES, RESOLUTION_MINUTES, CREATED_AT, RESOLVED_AT, PLATFORM
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS
)
SELECT
    UUID_STRING(),
    CP.CUSTOMER_ID,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Withdrawals'
        WHEN 1 THEN 'Withdrawals'
        WHEN 2 THEN 'Trading'
        WHEN 3 THEN 'Trading'
        WHEN 4 THEN 'Account'
        WHEN 5 THEN 'Verification'
        WHEN 6 THEN 'Security'
        WHEN 7 THEN 'Deposits'
        WHEN 8 THEN 'Staking'
        ELSE 'API'
    END AS CATEGORY,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Withdrawal Pending'
        WHEN 1 THEN 'Withdrawal Failed'
        WHEN 2 THEN 'Order Not Executing'
        WHEN 3 THEN 'Margin Call'
        WHEN 4 THEN 'Account Locked'
        WHEN 5 THEN 'KYC Document Issues'
        WHEN 6 THEN '2FA Lost'
        WHEN 7 THEN 'Deposit Not Credited'
        WHEN 8 THEN 'Staking Rewards Missing'
        ELSE 'API Key Issues'
    END AS SUBCATEGORY,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Critical'
        WHEN 1 THEN 'Critical'
        WHEN 2 THEN 'High'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'High'
        ELSE CASE WHEN MOD(SEQ4(), 3) = 0 THEN 'Medium' ELSE 'Low' END
    END AS PRIORITY,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Open'
        WHEN 1 THEN 'In Progress'
        WHEN 2 THEN 'Waiting'
        ELSE CASE WHEN MOD(SEQ4(), 2) = 0 THEN 'Resolved' ELSE 'Closed' END
    END AS STATUS,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'My BTC withdrawal has been pending for 48 hours'
        WHEN 1 THEN 'Cannot withdraw ETH to my Ledger hardware wallet'
        WHEN 2 THEN 'Limit order not filling despite price being met'
        WHEN 3 THEN 'Unexpected margin call on my SOL position'
        WHEN 4 THEN 'Account locked after password reset attempt'
        WHEN 5 THEN 'KYC verification rejected but documents are valid'
        WHEN 6 THEN 'Lost my 2FA device and cannot access account'
        WHEN 7 THEN 'Wire transfer deposit not credited after 5 business days'
        WHEN 8 THEN 'Staking rewards not appearing for DOT position'
        WHEN 9 THEN 'API key permissions not working for trading'
        WHEN 10 THEN 'Futures position liquidated without proper notification'
        WHEN 11 THEN 'Withdrawal to wrong network - need recovery'
        WHEN 12 THEN 'Trading fees seem higher than my tier should allow'
        WHEN 13 THEN 'Mobile app crashing when trying to place orders'
        WHEN 14 THEN 'Need to increase withdrawal limits for business account'
        WHEN 15 THEN 'Suspicious login notification but it was me'
        WHEN 16 THEN 'Cannot find my ATOM staking rewards from last month'
        WHEN 17 THEN 'Price execution was significantly different from displayed'
        WHEN 18 THEN 'Need to link new bank account for fiat deposits'
        ELSE 'General inquiry about platform features and fees'
    END AS SUBJECT,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'I initiated a BTC withdrawal to my external wallet but it has been stuck in pending status for over 48 hours. The transaction hash is not showing on the blockchain explorer. My account is fully verified and I have not exceeded any daily limits. Please investigate and process this withdrawal urgently.'
        WHEN 1 THEN 'I am trying to withdraw ETH to my Ledger Nano X hardware wallet but the transaction keeps failing with error code WD-403. I have verified the address multiple times and the network is Ethereum mainnet. Previous withdrawals to this same address worked fine last month.'
        WHEN 2 THEN 'I placed a limit buy order for SOL at $145.00 three hours ago. The price has dropped to $143.50 multiple times since then but my order has not been filled. The order shows as Open in my order history. This is affecting my trading strategy.'
        WHEN 3 THEN 'I received a margin call notification on my SOL/USD position but the market has not moved significantly. My margin ratio should still be above maintenance requirements. Please review the liquidation engine calculations for my account.'
        WHEN 4 THEN 'My account was locked after I attempted to reset my password. I am receiving an error that says access is temporarily restricted. I need urgent access as I have open positions that need management.'
        WHEN 5 THEN 'My KYC verification was rejected stating document quality issues but I submitted high-resolution scans of my valid passport. The document is not expired and all details are clearly visible. This is my third attempt and I need to resolve this to increase my trading limits.'
        WHEN 6 THEN 'I lost my phone which had my Google Authenticator 2FA. I cannot access my account at all. I have my recovery codes but they are not being accepted. I need assistance to disable 2FA so I can set it up on my new device.'
        WHEN 7 THEN 'I sent a wire transfer of $50,000 from my bank to Kraken 5 business days ago. The funds have left my bank account but are not showing as credited in my Kraken balance. Wire reference number: WR-2024-08-12345.'
        WHEN 8 THEN 'I staked 500 DOT in the flexible staking program 30 days ago but I have not received any staking rewards. The dashboard shows my position is active but the rewards earned column shows zero. Other users in forums report receiving rewards within the first week.'
        ELSE 'I am having issues with my API key configuration. I created a key with trading permissions but when I try to place orders via the API I get a permission denied error. I have verified the key and secret are correct in my application.'
    END AS DESCRIPTION,
    CASE 
        WHEN MOD(SEQ4(), 10) >= 3 THEN 'Issue has been resolved. ' || 
            ARRAY_CONSTRUCT(
                'Withdrawal was processed after blockchain confirmation.',
                'Network congestion cleared and transaction went through.',
                'Order filled after market conditions were met.',
                'Margin calculation was corrected and position restored.',
                'Account unlocked after identity verification.',
                'Documents re-reviewed and verification approved.',
                '2FA reset completed with identity verification.',
                'Wire deposit credited after bank confirmation received.',
                'Staking rewards recalculated and credited retroactively.',
                'API permissions updated and tested successfully.'
            )[MOD(SEQ4(), 10)]
        ELSE NULL
    END AS RESOLUTION_NOTES,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Tier1'
        WHEN 1 THEN 'Tier1'
        WHEN 2 THEN 'Tier1'
        WHEN 3 THEN 'Tier2'
        WHEN 4 THEN 'Tier2'
        WHEN 5 THEN 'Tier3'
        WHEN 6 THEN 'Compliance'
        ELSE 'Engineering'
    END AS ASSIGNED_TEAM,
    CASE WHEN MOD(SEQ4(), 10) >= 3 THEN UNIFORM(1, 5, RANDOM(SEQ4())) ELSE NULL END AS SATISFACTION_SCORE,
    UNIFORM(5, 1440, RANDOM(SEQ4() + 1)) AS FIRST_RESPONSE_MINUTES,
    CASE WHEN MOD(SEQ4(), 10) >= 3 THEN UNIFORM(60, 10080, RANDOM(SEQ4() + 2)) ELSE NULL END AS RESOLUTION_MINUTES,
    DATEADD('minute', -UNIFORM(1, 262800, RANDOM(SEQ4() + 3)), CURRENT_TIMESTAMP()) AS CREATED_AT,
    CASE WHEN MOD(SEQ4(), 10) >= 3 THEN DATEADD('minute', -UNIFORM(1, 200000, RANDOM(SEQ4() + 4)), CURRENT_TIMESTAMP()) ELSE NULL END AS RESOLVED_AT,
    ARRAY_CONSTRUCT('Web','Web','Email','Email','Chat','Chat','Chat','Phone')[MOD(SEQ4(), 8)] AS PLATFORM
FROM TABLE(GENERATOR(ROWCOUNT => 25000)) G
JOIN CUSTOMER_POOL CP ON CP.RN = MOD(SEQ4(), (SELECT COUNT(*) FROM CUSTOMER_POOL)) + 1;

-- =====================================================
-- COMPLIANCE_EVENTS (15,000 records)
-- =====================================================
INSERT INTO COMPLIANCE_EVENTS (
    EVENT_ID, CUSTOMER_ID, EVENT_TYPE, RISK_SCORE, RISK_LEVEL, IS_FLAGGED,
    DESCRIPTION, REVIEW_STATUS, REVIEWED_BY, REGULATORY_REPORT_FILED,
    JURISDICTION, CREATED_AT, REVIEWED_AT
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS
)
SELECT
    UUID_STRING(),
    CP.CUSTOMER_ID,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 'Large_Transaction'
        WHEN 1 THEN 'Velocity_Alert'
        WHEN 2 THEN 'Sanctions_Screen'
        WHEN 3 THEN 'PEP_Check'
        WHEN 4 THEN 'Identity_Mismatch'
        WHEN 5 THEN 'Unusual_Pattern'
        ELSE 'SAR_Filed'
    END AS EVENT_TYPE,
    UNIFORM(1, 100, RANDOM(SEQ4())) AS RISK_SCORE,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM(SEQ4())) <= 40 THEN 'Low'
        WHEN UNIFORM(1, 100, RANDOM(SEQ4())) <= 70 THEN 'Medium'
        WHEN UNIFORM(1, 100, RANDOM(SEQ4())) <= 90 THEN 'High'
        ELSE 'Critical'
    END AS RISK_LEVEL,
    CASE WHEN UNIFORM(1, 100, RANDOM(SEQ4() + 1)) > 75 THEN TRUE ELSE FALSE END AS IS_FLAGGED,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 'Transaction exceeding $10,000 threshold detected. Customer initiated single transfer of ' || UNIFORM(10000, 500000, RANDOM(SEQ4()))::VARCHAR || ' USD equivalent.'
        WHEN 1 THEN 'Multiple rapid transactions detected within 1-hour window. ' || UNIFORM(5, 50, RANDOM(SEQ4()))::VARCHAR || ' transactions totaling significant volume.'
        WHEN 2 THEN 'Automated sanctions screening flagged potential match with OFAC/EU sanctions list entity. Requires manual review of customer identity.'
        WHEN 3 THEN 'Politically Exposed Person (PEP) screening returned positive result. Enhanced due diligence required per regulatory guidelines.'
        WHEN 4 THEN 'Identity document metadata inconsistency detected during periodic re-verification process. Document hash differs from original submission.'
        WHEN 5 THEN 'Unusual trading pattern identified: customer typically trades spot but initiated multiple high-leverage futures positions outside normal behavior.'
        ELSE 'Suspicious Activity Report criteria met. Multiple risk indicators triggered simultaneously. Filing SAR with FinCEN per BSA requirements.'
    END AS DESCRIPTION,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Pending'
        WHEN 1 THEN 'Under Review'
        WHEN 2 THEN 'Cleared'
        WHEN 3 THEN 'Cleared'
        ELSE 'Escalated'
    END AS REVIEW_STATUS,
    CASE WHEN MOD(SEQ4(), 5) >= 2 THEN 
        ARRAY_CONSTRUCT('ComplianceAnalyst_A','ComplianceAnalyst_B','ComplianceOfficer_1','ComplianceOfficer_2','MLRO')[MOD(SEQ4(), 5)]
    ELSE NULL END AS REVIEWED_BY,
    CASE WHEN MOD(SEQ4(), 20) = 0 THEN TRUE ELSE FALSE END AS REGULATORY_REPORT_FILED,
    ARRAY_CONSTRUCT('US','UK','EU','SG','JP','AU','CA','CH')[MOD(SEQ4(), 8)] AS JURISDICTION,
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM(SEQ4() + 5)), CURRENT_TIMESTAMP()) AS CREATED_AT,
    CASE WHEN MOD(SEQ4(), 5) >= 2 THEN DATEADD('minute', -UNIFORM(1, 400000, RANDOM(SEQ4() + 6)), CURRENT_TIMESTAMP()) ELSE NULL END AS REVIEWED_AT
FROM TABLE(GENERATOR(ROWCOUNT => 15000)) G
JOIN CUSTOMER_POOL CP ON CP.RN = MOD(SEQ4(), (SELECT COUNT(*) FROM CUSTOMER_POOL)) + 1;

-- =====================================================
-- STAKING_POSITIONS (8,000 records)
-- =====================================================
INSERT INTO STAKING_POSITIONS (
    POSITION_ID, CUSTOMER_ID, ASSET_SYMBOL, STAKED_AMOUNT, STAKED_VALUE_USD,
    APY_RATE, REWARDS_EARNED, REWARDS_VALUE_USD, STATUS, LOCK_PERIOD_DAYS,
    STARTED_AT, COMPLETED_AT
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ACCOUNT_TIER, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS WHERE IS_ACTIVE = TRUE
)
SELECT
    UUID_STRING(),
    CP.CUSTOMER_ID,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 'ETH'
        WHEN 1 THEN 'SOL'
        WHEN 2 THEN 'DOT'
        WHEN 3 THEN 'ADA'
        WHEN 4 THEN 'ATOM'
        WHEN 5 THEN 'AVAX'
        ELSE 'MATIC'
    END AS ASSET_SYMBOL,
    ROUND(UNIFORM(10, 100000, RANDOM(SEQ4()))::DECIMAL(24,8) *
        CASE WHEN CP.ACCOUNT_TIER IN ('VIP','Institutional') THEN 10 ELSE 1 END, 8) AS STAKED_AMOUNT,
    ROUND(UNIFORM(100, 5000000, RANDOM(SEQ4() + 1))::DECIMAL(18,2), 2) AS STAKED_VALUE_USD,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 3.5
        WHEN 1 THEN 6.8
        WHEN 2 THEN 12.0
        WHEN 3 THEN 3.2
        WHEN 4 THEN 15.5
        WHEN 5 THEN 8.2
        ELSE 4.5
    END AS APY_RATE,
    ROUND(UNIFORM(0.1, 5000, RANDOM(SEQ4() + 2))::DECIMAL(24,8), 8) AS REWARDS_EARNED,
    ROUND(UNIFORM(1, 50000, RANDOM(SEQ4() + 3))::DECIMAL(18,2), 2) AS REWARDS_VALUE_USD,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Unbonding'
        WHEN 1 THEN 'Completed'
        ELSE 'Active'
    END AS STATUS,
    CASE WHEN MOD(SEQ4(), 3) = 0 THEN NULL ELSE ARRAY_CONSTRUCT(30, 60, 90, 120)[MOD(SEQ4(), 4)] END AS LOCK_PERIOD_DAYS,
    DATEADD('day', -UNIFORM(7, 365, RANDOM(SEQ4() + 4)), CURRENT_TIMESTAMP()) AS STARTED_AT,
    CASE WHEN MOD(SEQ4(), 10) = 1 THEN DATEADD('day', -UNIFORM(1, 30, RANDOM(SEQ4() + 5)), CURRENT_TIMESTAMP()) ELSE NULL END AS COMPLETED_AT
FROM TABLE(GENERATOR(ROWCOUNT => 8000)) G
JOIN CUSTOMER_POOL CP ON CP.RN = MOD(SEQ4(), (SELECT COUNT(*) FROM CUSTOMER_POOL)) + 1;

-- =====================================================
-- MARKET_DATA (hourly for top pairs, ~50,000 records)
-- =====================================================
INSERT INTO MARKET_DATA (
    MARKET_DATA_ID, TRADING_PAIR, TIMESTAMP, INTERVAL, OPEN_PRICE, HIGH_PRICE,
    LOW_PRICE, CLOSE_PRICE, VOLUME, VOLUME_USD, TRADE_COUNT, VWAP
)
WITH PAIRS AS (
    SELECT COLUMN1 AS PAIR, COLUMN2 AS BASE_PRICE
    FROM VALUES ('BTC/USD', 60000), ('ETH/USD', 3200), ('SOL/USD', 150),
               ('XRP/USD', 1.5), ('ADA/USD', 0.6), ('DOT/USD', 8),
               ('AVAX/USD', 40), ('LINK/USD', 18), ('ATOM/USD', 10), ('MATIC/USD', 1)
),
HOURS AS (
    SELECT DATEADD('hour', -SEQ4(), CURRENT_TIMESTAMP()) AS TS
    FROM TABLE(GENERATOR(ROWCOUNT => 5000))
)
SELECT
    UUID_STRING(),
    P.PAIR,
    H.TS,
    '1h' AS INTERVAL,
    ROUND(P.BASE_PRICE * (1 + UNIFORM(-5, 5, RANDOM(HASH(P.PAIR || H.TS::VARCHAR)))/100.0), 8) AS OPEN_PRICE,
    ROUND(P.BASE_PRICE * (1 + UNIFORM(0, 8, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 1))/100.0), 8) AS HIGH_PRICE,
    ROUND(P.BASE_PRICE * (1 - UNIFORM(0, 8, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 2))/100.0), 8) AS LOW_PRICE,
    ROUND(P.BASE_PRICE * (1 + UNIFORM(-5, 5, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 3))/100.0), 8) AS CLOSE_PRICE,
    ROUND(UNIFORM(100, 50000, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 4))::DECIMAL(24,8), 8) AS VOLUME,
    ROUND(UNIFORM(100, 50000, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 4)) * P.BASE_PRICE, 2) AS VOLUME_USD,
    UNIFORM(500, 50000, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 5)) AS TRADE_COUNT,
    ROUND(P.BASE_PRICE * (1 + UNIFORM(-3, 3, RANDOM(HASH(P.PAIR || H.TS::VARCHAR) + 6))/100.0), 8) AS VWAP
FROM PAIRS P
CROSS JOIN HOURS H;

-- =====================================================
-- FUTURES_POSITIONS (20,000 records)
-- =====================================================
INSERT INTO FUTURES_POSITIONS (
    POSITION_ID, CUSTOMER_ID, CONTRACT_PAIR, CONTRACT_TYPE, SIDE, LEVERAGE,
    ENTRY_PRICE, MARK_PRICE, LIQUIDATION_PRICE, POSITION_SIZE,
    NOTIONAL_VALUE_USD, UNREALIZED_PNL_USD, REALIZED_PNL_USD, MARGIN_USED_USD,
    STATUS, OPENED_AT, CLOSED_AT
)
WITH CUSTOMER_POOL AS (
    SELECT CUSTOMER_ID, ACCOUNT_TIER, ROW_NUMBER() OVER (ORDER BY CUSTOMER_ID) AS RN
    FROM CUSTOMERS WHERE ACCOUNT_TIER IN ('Pro', 'VIP', 'Institutional')
)
SELECT
    UUID_STRING(),
    CP.CUSTOMER_ID,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'BTC-PERP'
        WHEN 1 THEN 'ETH-PERP'
        WHEN 2 THEN 'SOL-PERP'
        WHEN 3 THEN 'XRP-PERP'
        WHEN 4 THEN 'BTC-0930'
        WHEN 5 THEN 'ETH-0930'
        WHEN 6 THEN 'AVAX-PERP'
        ELSE 'DOT-PERP'
    END AS CONTRACT_PAIR,
    CASE WHEN MOD(SEQ4(), 8) >= 4 AND MOD(SEQ4(), 8) <= 5 THEN 'Quarterly' ELSE 'Perpetual' END AS CONTRACT_TYPE,
    CASE WHEN MOD(SEQ4(), 2) = 0 THEN 'Long' ELSE 'Short' END AS SIDE,
    CASE 
        WHEN CP.ACCOUNT_TIER = 'Institutional' THEN UNIFORM(1, 20, RANDOM(SEQ4()))::DECIMAL(5,2)
        WHEN CP.ACCOUNT_TIER = 'VIP' THEN UNIFORM(1, 25, RANDOM(SEQ4()))::DECIMAL(5,2)
        ELSE UNIFORM(2, 50, RANDOM(SEQ4()))::DECIMAL(5,2)
    END AS LEVERAGE,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN UNIFORM(25000, 70000, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN 1 THEN UNIFORM(1200, 4500, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN 2 THEN UNIFORM(15, 250, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN 3 THEN UNIFORM(0.3, 2.5, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN 4 THEN UNIFORM(25000, 70000, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN 5 THEN UNIFORM(1200, 4500, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        WHEN 6 THEN UNIFORM(10, 100, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
        ELSE UNIFORM(3, 50, RANDOM(SEQ4() + 1))::DECIMAL(18,8)
    END AS ENTRY_PRICE,
    NULL AS MARK_PRICE,
    NULL AS LIQUIDATION_PRICE,
    UNIFORM(0.01, 50, RANDOM(SEQ4() + 2))::DECIMAL(18,8) AS POSITION_SIZE,
    ROUND(UNIFORM(1000, 5000000, RANDOM(SEQ4() + 3))::DECIMAL(18,2), 2) AS NOTIONAL_VALUE_USD,
    ROUND(UNIFORM(-100000, 200000, RANDOM(SEQ4() + 4))::DECIMAL(18,2), 2) AS UNREALIZED_PNL_USD,
    ROUND(UNIFORM(-50000, 100000, RANDOM(SEQ4() + 5))::DECIMAL(18,2), 2) AS REALIZED_PNL_USD,
    ROUND(UNIFORM(100, 500000, RANDOM(SEQ4() + 6))::DECIMAL(18,2), 2) AS MARGIN_USED_USD,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Liquidated'
        WHEN 1 THEN 'Closed'
        WHEN 2 THEN 'Closed'
        WHEN 3 THEN 'Closed'
        ELSE 'Open'
    END AS STATUS,
    DATEADD('minute', -UNIFORM(1, 262800, RANDOM(SEQ4() + 7)), CURRENT_TIMESTAMP()) AS OPENED_AT,
    CASE WHEN MOD(SEQ4(), 10) BETWEEN 0 AND 3 THEN DATEADD('minute', -UNIFORM(1, 100000, RANDOM(SEQ4() + 8)), CURRENT_TIMESTAMP()) ELSE NULL END AS CLOSED_AT
FROM TABLE(GENERATOR(ROWCOUNT => 20000)) G
JOIN CUSTOMER_POOL CP ON CP.RN = MOD(SEQ4(), (SELECT COUNT(*) FROM CUSTOMER_POOL)) + 1;

SELECT 'Step 4 Complete: Synthetic data generated - 10K customers, 500K trades, 50K orders, 30K wallets, 25K tickets, 15K compliance events, 8K staking positions, 50K market data, 20K futures.' AS STATUS;
