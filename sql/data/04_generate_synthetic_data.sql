/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 04_generate_synthetic_data.sql
  Purpose: Generate realistic synthetic data for all source systems
  Execution Order: 4 of 10
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- DYNAMICS CRM: Accounts (500+)
-- ============================================================================
USE SCHEMA DYNAMICS_CRM;

INSERT INTO ACCOUNTS
SELECT
    UUID_STRING() AS ACCOUNT_ID,
    CASE MOD(SEQ4(), 50)
        WHEN 0 THEN 'ACWA Power' WHEN 1 THEN 'IDE Technologies' WHEN 2 THEN 'Veolia Water'
        WHEN 3 THEN 'SUEZ Water' WHEN 4 THEN 'Doosan Heavy Industries' WHEN 5 THEN 'Fisia Italimpianti'
        WHEN 6 THEN 'Acciona Agua' WHEN 7 THEN 'Abengoa Water' WHEN 8 THEN 'Hyflux'
        WHEN 9 THEN 'Tedagua' WHEN 10 THEN 'Metito' WHEN 11 THEN 'Aqualia'
        WHEN 12 THEN 'Saline Water Conversion Corp' WHEN 13 THEN 'Dubai Electricity & Water'
        WHEN 14 THEN 'Abu Dhabi National Energy' WHEN 15 THEN 'Samsung Engineering'
        WHEN 16 THEN 'Hitachi Zosen' WHEN 17 THEN 'Toray Industries' WHEN 18 THEN 'Nitto Denko'
        WHEN 19 THEN 'Koch Membrane Systems' WHEN 20 THEN 'Porifera' WHEN 21 THEN 'Consolidated Water'
        WHEN 22 THEN 'Cadagua' WHEN 23 THEN 'Befesa' WHEN 24 THEN 'Valoriza Agua'
        WHEN 25 THEN 'Biwater' WHEN 26 THEN 'Hyflux Engineering' WHEN 27 THEN 'Xylem Inc'
        WHEN 28 THEN 'Pentair' WHEN 29 THEN 'Evoqua Water' WHEN 30 THEN 'Pall Corporation'
        WHEN 31 THEN 'GE Water' WHEN 32 THEN 'Dow Water Solutions' WHEN 33 THEN 'LG Water Solutions'
        WHEN 34 THEN 'Lanxess' WHEN 35 THEN 'Grundfos' WHEN 36 THEN 'Danfoss HPP'
        WHEN 37 THEN 'Flowserve Corporation' WHEN 38 THEN 'Sulzer Pumps' WHEN 39 THEN 'KSB Group'
        WHEN 40 THEN 'Carrier Global' WHEN 41 THEN 'Johnson Controls' WHEN 42 THEN 'Emerson Electric'
        WHEN 43 THEN 'Alfa Laval' WHEN 44 THEN 'SPX Flow' WHEN 45 THEN 'IDEX Corporation'
        WHEN 46 THEN 'Roper Technologies' WHEN 47 THEN 'Watts Water' WHEN 48 THEN 'Mueller Water'
        WHEN 49 THEN 'Aegion Corporation'
    END || ' - ' || LPAD(SEQ4()::VARCHAR, 3, '0') AS ACCOUNT_NAME,
    'ACC-' || LPAD(SEQ4()::VARCHAR, 6, '0') AS ACCOUNT_NUMBER,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Water & Desalination' WHEN 1 THEN 'Utilities' WHEN 2 THEN 'Industrial Manufacturing'
        WHEN 3 THEN 'Oil & Gas' WHEN 4 THEN 'Food & Beverage' WHEN 5 THEN 'Refrigeration & HVAC'
        WHEN 6 THEN 'Mining' WHEN 7 THEN 'Chemical Processing'
    END AS INDUSTRY,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Customer' WHEN 1 THEN 'Customer' WHEN 2 THEN 'Prospect' WHEN 3 THEN 'Partner'
    END AS ACCOUNT_TYPE,
    CASE MOD(SEQ4(), 3)
        WHEN 0 THEN 'Tier 1' WHEN 1 THEN 'Tier 2' WHEN 2 THEN 'Tier 3'
    END AS ACCOUNT_TIER,
    ROUND(UNIFORM(5000000, 500000000, RANDOM())::NUMBER, 2) AS ANNUAL_REVENUE,
    UNIFORM(50, 50000, RANDOM()) AS EMPLOYEE_COUNT,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'MENA' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Europe'
        WHEN 3 THEN 'Americas' WHEN 4 THEN 'Africa' WHEN 5 THEN 'MENA'
    END AS REGION,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Saudi Arabia' WHEN 1 THEN 'UAE' WHEN 2 THEN 'China'
        WHEN 3 THEN 'India' WHEN 4 THEN 'Spain' WHEN 5 THEN 'USA'
        WHEN 6 THEN 'Australia' WHEN 7 THEN 'Israel' WHEN 8 THEN 'South Korea'
        WHEN 9 THEN 'Singapore' WHEN 10 THEN 'Chile' WHEN 11 THEN 'Oman'
    END AS COUNTRY,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Riyadh' WHEN 1 THEN 'Dubai' WHEN 2 THEN 'Shanghai'
        WHEN 3 THEN 'Mumbai' WHEN 4 THEN 'Madrid' WHEN 5 THEN 'Houston'
        WHEN 6 THEN 'Perth' WHEN 7 THEN 'Tel Aviv' WHEN 8 THEN 'Seoul'
        WHEN 9 THEN 'Singapore' WHEN 10 THEN 'Santiago' WHEN 11 THEN 'Muscat'
    END AS CITY,
    NULL AS WEBSITE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber'
        WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison'
    END AS OWNER_NAME,
    NULL AS PARENT_ACCOUNT_ID,
    DATEADD('day', -UNIFORM(30, 2000, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE,
    DATEADD('day', -UNIFORM(1, 30, RANDOM()), CURRENT_TIMESTAMP()) AS MODIFIED_DATE,
    TRUE AS IS_ACTIVE
FROM TABLE(GENERATOR(ROWCOUNT => 520));

-- ============================================================================
-- DYNAMICS CRM: Contacts (1500+)
-- ============================================================================
INSERT INTO CONTACTS
SELECT
    UUID_STRING() AS CONTACT_ID,
    (SELECT ACCOUNT_ID FROM ACCOUNTS ORDER BY RANDOM() LIMIT 1) AS ACCOUNT_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Mohammed' WHEN 1 THEN 'Chen' WHEN 2 THEN 'David' WHEN 3 THEN 'Maria'
        WHEN 4 THEN 'Raj' WHEN 5 THEN 'Sophie' WHEN 6 THEN 'Ahmed' WHEN 7 THEN 'Jun'
        WHEN 8 THEN 'Carlos' WHEN 9 THEN 'Anna' WHEN 10 THEN 'Robert' WHEN 11 THEN 'Fatima'
        WHEN 12 THEN 'Wei' WHEN 13 THEN 'James' WHEN 14 THEN 'Aisha' WHEN 15 THEN 'Thomas'
        WHEN 16 THEN 'Yuki' WHEN 17 THEN 'Omar' WHEN 18 THEN 'Priya' WHEN 19 THEN 'Hans'
    END AS FIRST_NAME,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Al-Rashid' WHEN 1 THEN 'Wong' WHEN 2 THEN 'Schmidt' WHEN 3 THEN 'Garcia'
        WHEN 4 THEN 'Patel' WHEN 5 THEN 'Martin' WHEN 6 THEN 'Hassan' WHEN 7 THEN 'Nakamura'
        WHEN 8 THEN 'Rodriguez' WHEN 9 THEN 'Jensen' WHEN 10 THEN 'Kumar' WHEN 11 THEN 'Kim'
        WHEN 12 THEN 'Santos' WHEN 13 THEN 'Mueller' WHEN 14 THEN 'Singh'
    END AS LAST_NAME,
    NULL AS EMAIL,
    NULL AS PHONE,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'VP Engineering' WHEN 1 THEN 'Chief Technology Officer' WHEN 2 THEN 'Plant Manager'
        WHEN 3 THEN 'Procurement Director' WHEN 4 THEN 'Process Engineer'
        WHEN 5 THEN 'Operations Manager' WHEN 6 THEN 'Project Director'
        WHEN 7 THEN 'Maintenance Manager' WHEN 8 THEN 'Technical Director'
        WHEN 9 THEN 'CEO'
    END AS JOB_TITLE,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'Engineering' WHEN 1 THEN 'Operations' WHEN 2 THEN 'Procurement'
        WHEN 3 THEN 'Executive' WHEN 4 THEN 'Maintenance' WHEN 5 THEN 'Project Management'
    END AS DEPARTMENT,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Decision Maker' WHEN 1 THEN 'Influencer' WHEN 2 THEN 'Champion' WHEN 3 THEN 'End User'
    END AS DECISION_ROLE,
    CASE WHEN MOD(SEQ4(), 5) = 0 THEN TRUE ELSE FALSE END AS IS_PRIMARY,
    DATEADD('day', -UNIFORM(30, 1500, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE,
    DATEADD('day', -UNIFORM(1, 60, RANDOM()), CURRENT_TIMESTAMP()) AS MODIFIED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 1500));

-- Fix account references to be valid
UPDATE CONTACTS c
SET ACCOUNT_ID = (SELECT ACCOUNT_ID FROM ACCOUNTS ORDER BY RANDOM() LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM ACCOUNTS a WHERE a.ACCOUNT_ID = c.ACCOUNT_ID);

-- ============================================================================
-- DYNAMICS CRM: Opportunities (2000+)
-- ============================================================================
INSERT INTO OPPORTUNITIES
SELECT
    UUID_STRING() AS OPPORTUNITY_ID,
    a.ACCOUNT_ID,
    a.ACCOUNT_NAME || ' - ' ||
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'SWRO Plant ERD Package' WHEN 1 THEN 'PX Upgrade Project'
        WHEN 2 THEN 'New Desalination Facility' WHEN 3 THEN 'Aftermarket Service Contract'
        WHEN 4 THEN 'Wastewater Treatment ERD' WHEN 5 THEN 'CO2 Refrigeration Pilot'
        WHEN 6 THEN 'Expansion Phase II' WHEN 7 THEN 'Replacement Units'
    END AS OPPORTUNITY_NAME,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 'Qualify' WHEN 1 THEN 'Develop' WHEN 2 THEN 'Develop'
        WHEN 3 THEN 'Propose' WHEN 4 THEN 'Negotiate' WHEN 5 THEN 'Close Won' WHEN 6 THEN 'Close Lost'
    END AS STAGE,
    ROUND(UNIFORM(50000, 15000000, RANDOM())::NUMBER, 2) AS AMOUNT,
    DATEADD('day', UNIFORM(-90, 365, RANDOM()), CURRENT_DATE()) AS CLOSE_DATE,
    CASE MOD(SEQ4(), 7)
        WHEN 0 THEN 10 WHEN 1 THEN 25 WHEN 2 THEN 25 WHEN 3 THEN 50
        WHEN 4 THEN 75 WHEN 5 THEN 100 WHEN 6 THEN 0
    END AS PROBABILITY,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'PX Pressure Exchanger' WHEN 1 THEN 'PX Q650'
        WHEN 2 THEN 'PX G1300' WHEN 3 THEN 'Aftermarket Services' WHEN 4 THEN 'Wastewater PX'
    END AS PRODUCT_INTEREST,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Desalination' WHEN 1 THEN 'Wastewater' WHEN 2 THEN 'CO2 Refrigeration' WHEN 3 THEN 'Desalination'
    END AS APPLICATION,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Trade Show' WHEN 1 THEN 'Referral' WHEN 2 THEN 'Web Inquiry'
        WHEN 3 THEN 'Existing Customer' WHEN 4 THEN 'Partner'
    END AS LEAD_SOURCE,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Danfoss' WHEN 1 THEN 'Flowserve' WHEN 2 THEN 'Sulzer' WHEN 3 THEN NULL
    END AS COMPETITOR,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber'
        WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison'
    END AS SALES_REP,
    a.REGION,
    DATEADD('day', -UNIFORM(30, 730, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE,
    DATEADD('day', -UNIFORM(1, 30, RANDOM()), CURRENT_TIMESTAMP()) AS MODIFIED_DATE,
    CASE
        WHEN MOD(SEQ4(), 7) IN (5, 6) THEN DATEADD('day', -UNIFORM(1, 180, RANDOM()), CURRENT_TIMESTAMP())
        ELSE NULL
    END AS CLOSED_DATE,
    CASE
        WHEN MOD(SEQ4(), 7) = 6 THEN
            CASE MOD(SEQ4(), 4)
                WHEN 0 THEN 'Price - competitor offered lower price'
                WHEN 1 THEN 'Timing - project delayed indefinitely'
                WHEN 2 THEN 'Technical - chose alternative technology'
                WHEN 3 THEN 'Budget - funding not approved'
            END
        ELSE NULL
    END AS LOSS_REASON,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Schedule technical review meeting'
        WHEN 1 THEN 'Send revised proposal'
        WHEN 2 THEN 'Arrange site visit'
        WHEN 3 THEN 'Follow up on RFQ response'
        WHEN 4 THEN 'Executive sponsor meeting'
    END AS NEXT_STEP
FROM TABLE(GENERATOR(ROWCOUNT => 2200)) g
JOIN (SELECT ACCOUNT_ID, ACCOUNT_NAME, REGION, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM ACCOUNTS) a
    ON MOD(SEQ4(), 520) + 1 = a.RN;

-- ============================================================================
-- DYNAMICS FINANCE: General Ledger (5000+ entries)
-- ============================================================================
USE SCHEMA DYNAMICS_FINANCE;

INSERT INTO GENERAL_LEDGER
SELECT
    UUID_STRING() AS JOURNAL_ENTRY_ID,
    DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE()) AS POSTING_DATE,
    YEAR(DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE())) AS FISCAL_YEAR,
    QUARTER(DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE())) AS FISCAL_QUARTER,
    MONTH(DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE())) AS FISCAL_PERIOD,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN '4100-001' WHEN 1 THEN '4100-002' WHEN 2 THEN '4100-003'
        WHEN 3 THEN '5100-001' WHEN 4 THEN '5100-002' WHEN 5 THEN '6100-001'
        WHEN 6 THEN '6200-001' WHEN 7 THEN '6300-001' WHEN 8 THEN '6400-001'
        WHEN 9 THEN '4200-001' WHEN 10 THEN '5200-001' WHEN 11 THEN '6500-001'
    END AS ACCOUNT_NUMBER,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Product Revenue - Desalination' WHEN 1 THEN 'Product Revenue - Wastewater'
        WHEN 2 THEN 'Product Revenue - Refrigeration' WHEN 3 THEN 'Cost of Goods Sold - Materials'
        WHEN 4 THEN 'Cost of Goods Sold - Labor' WHEN 5 THEN 'Research & Development'
        WHEN 6 THEN 'Sales & Marketing' WHEN 7 THEN 'General & Administrative'
        WHEN 8 THEN 'Depreciation & Amortization' WHEN 9 THEN 'Service Revenue'
        WHEN 10 THEN 'Manufacturing Overhead' WHEN 11 THEN 'Facilities & Utilities'
    END AS ACCOUNT_NAME,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Revenue' WHEN 1 THEN 'Revenue' WHEN 2 THEN 'Revenue'
        WHEN 3 THEN 'COGS' WHEN 4 THEN 'COGS' WHEN 5 THEN 'Operating Expense'
        WHEN 6 THEN 'Operating Expense' WHEN 7 THEN 'Operating Expense'
        WHEN 8 THEN 'Operating Expense' WHEN 9 THEN 'Revenue' WHEN 10 THEN 'COGS'
        WHEN 11 THEN 'Operating Expense'
    END AS ACCOUNT_CATEGORY,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Engineering' WHEN 1 THEN 'Manufacturing' WHEN 2 THEN 'Sales'
        WHEN 3 THEN 'Corporate' WHEN 4 THEN 'Service'
    END AS DEPARTMENT,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'CC-100' WHEN 1 THEN 'CC-200' WHEN 2 THEN 'CC-300' WHEN 3 THEN 'CC-400'
    END AS COST_CENTER,
    CASE WHEN MOD(SEQ4(), 12) IN (0,1,2,9) THEN 0 ELSE ROUND(UNIFORM(1000, 2000000, RANDOM())::NUMBER, 2) END AS DEBIT_AMOUNT,
    CASE WHEN MOD(SEQ4(), 12) IN (0,1,2,9) THEN ROUND(UNIFORM(50000, 5000000, RANDOM())::NUMBER, 2) ELSE 0 END AS CREDIT_AMOUNT,
    CASE
        WHEN MOD(SEQ4(), 12) IN (0,1,2,9) THEN ROUND(UNIFORM(50000, 5000000, RANDOM())::NUMBER, 2)
        ELSE -ROUND(UNIFORM(1000, 2000000, RANDOM())::NUMBER, 2)
    END AS NET_AMOUNT,
    'USD' AS CURRENCY,
    'Monthly posting - ' || CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Desalination product revenue' WHEN 1 THEN 'Wastewater product revenue'
        WHEN 2 THEN 'Refrigeration product revenue' WHEN 3 THEN 'Raw material costs'
        WHEN 4 THEN 'Direct labor costs' WHEN 5 THEN 'R&D expenses'
        WHEN 6 THEN 'Sales & marketing spend' WHEN 7 THEN 'G&A expenses'
        WHEN 8 THEN 'Depreciation' WHEN 9 THEN 'Service contract revenue'
        WHEN 10 THEN 'Manufacturing overhead' WHEN 11 THEN 'Facilities costs'
    END AS DESCRIPTION,
    'Microsoft Dynamics 365 F&O' AS SOURCE_SYSTEM,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

-- ============================================================================
-- DYNAMICS FINANCE: Sales Orders (800+)
-- ============================================================================
INSERT INTO SALES_ORDERS
SELECT
    UUID_STRING() AS ORDER_ID,
    'SO-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS ORDER_NUMBER,
    UUID_STRING() AS CUSTOMER_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'ACWA Power' WHEN 1 THEN 'IDE Technologies' WHEN 2 THEN 'Veolia Water'
        WHEN 3 THEN 'SUEZ Water' WHEN 4 THEN 'Doosan Heavy Industries'
        WHEN 5 THEN 'Saline Water Conversion Corp' WHEN 6 THEN 'Dubai Electricity & Water'
        WHEN 7 THEN 'Samsung Engineering' WHEN 8 THEN 'Hitachi Zosen' WHEN 9 THEN 'Acciona Agua'
        WHEN 10 THEN 'Metito' WHEN 11 THEN 'Abengoa Water' WHEN 12 THEN 'Biwater'
        WHEN 13 THEN 'Consolidated Water' WHEN 14 THEN 'Carrier Global'
        WHEN 15 THEN 'Johnson Controls' WHEN 16 THEN 'Xylem Inc' WHEN 17 THEN 'Toray Industries'
        WHEN 18 THEN 'Koch Membrane Systems' WHEN 19 THEN 'Befesa'
    END AS CUSTOMER_NAME,
    DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE()) AS ORDER_DATE,
    DATEADD('day', UNIFORM(30, 180, RANDOM()), CURRENT_DATE()) AS REQUESTED_DATE,
    CASE WHEN MOD(SEQ4(), 4) IN (2,3) THEN DATEADD('day', -UNIFORM(0, 90, RANDOM()), CURRENT_DATE()) ELSE NULL END AS SHIP_DATE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Open' WHEN 1 THEN 'Confirmed' WHEN 2 THEN 'Shipped'
        WHEN 3 THEN 'Invoiced' WHEN 4 THEN 'Open'
    END AS STATUS,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Desalination' WHEN 1 THEN 'Desalination' WHEN 2 THEN 'Aftermarket' WHEN 3 THEN 'Wastewater'
    END AS PRODUCT_LINE,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'PX Q650 Pressure Exchanger' WHEN 1 THEN 'PX Q400 Pressure Exchanger'
        WHEN 2 THEN 'PX-220 Pressure Exchanger' WHEN 3 THEN 'Aftermarket Seal Kit'
        WHEN 4 THEN 'PX G1300 CO2 Unit' WHEN 5 THEN 'Wastewater PX System'
    END AS PRODUCT_NAME,
    UNIFORM(1, 48, RANDOM()) AS QUANTITY,
    ROUND(UNIFORM(5000, 350000, RANDOM())::NUMBER, 2) AS UNIT_PRICE,
    NULL AS TOTAL_AMOUNT,
    ROUND(UNIFORM(0, 15, RANDOM())::NUMBER, 2) AS DISCOUNT_PERCENT,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'MENA' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Europe'
        WHEN 3 THEN 'Americas' WHEN 4 THEN 'Africa' WHEN 5 THEN 'MENA'
    END AS REGION,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Saudi Arabia' WHEN 1 THEN 'UAE' WHEN 2 THEN 'China'
        WHEN 3 THEN 'Australia' WHEN 4 THEN 'Spain' WHEN 5 THEN 'USA'
        WHEN 6 THEN 'India' WHEN 7 THEN 'Oman'
    END AS COUNTRY,
    'USD' AS CURRENCY,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber'
        WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison'
    END AS SALES_REP,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 850));

UPDATE SALES_ORDERS SET TOTAL_AMOUNT = QUANTITY * UNIT_PRICE * (1 - DISCOUNT_PERCENT/100);

-- ============================================================================
-- DYNAMICS FINANCE: Invoices (700+)
-- ============================================================================
INSERT INTO INVOICES
SELECT
    UUID_STRING() AS INVOICE_ID,
    'INV-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS INVOICE_NUMBER,
    ORDER_ID,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), ORDER_DATE) AS INVOICE_DATE,
    DATEADD('day', UNIFORM(30, 90, RANDOM()), ORDER_DATE) AS DUE_DATE,
    CASE WHEN MOD(SEQ4(), 3) IN (0,1) THEN DATEADD('day', UNIFORM(20, 75, RANDOM()), ORDER_DATE) ELSE NULL END AS PAYMENT_DATE,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Paid' WHEN 1 THEN 'Paid' WHEN 2 THEN 'Open' WHEN 3 THEN 'Overdue'
    END AS STATUS,
    TOTAL_AMOUNT AS SUBTOTAL,
    ROUND(TOTAL_AMOUNT * 0.05, 2) AS TAX_AMOUNT,
    ROUND(TOTAL_AMOUNT * 1.05, 2) AS TOTAL_AMOUNT,
    CASE WHEN MOD(SEQ4(), 4) IN (0,1) THEN ROUND(TOTAL_AMOUNT * 1.05, 2) ELSE ROUND(TOTAL_AMOUNT * UNIFORM(0, 80, RANDOM()) / 100.0, 2) END AS AMOUNT_PAID,
    NULL AS BALANCE_DUE,
    PRODUCT_LINE,
    'USD' AS CURRENCY,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Net 30' WHEN 1 THEN 'Net 60' WHEN 2 THEN 'Net 90' END AS PAYMENT_TERMS,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM SALES_ORDERS
WHERE STATUS IN ('Shipped', 'Invoiced')
LIMIT 700;

UPDATE INVOICES SET BALANCE_DUE = TOTAL_AMOUNT - AMOUNT_PAID;

-- ============================================================================
-- DYNAMICS FINANCE: Accounts Receivable
-- ============================================================================
INSERT INTO ACCOUNTS_RECEIVABLE
SELECT
    UUID_STRING() AS AR_ID,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    INVOICE_ID,
    INVOICE_DATE,
    DUE_DATE,
    TOTAL_AMOUNT AS ORIGINAL_AMOUNT,
    BALANCE_DUE AS BALANCE,
    CASE
        WHEN BALANCE_DUE <= 0 THEN 'Current'
        WHEN DATEDIFF('day', DUE_DATE, CURRENT_DATE()) <= 0 THEN 'Current'
        WHEN DATEDIFF('day', DUE_DATE, CURRENT_DATE()) <= 30 THEN '1-30 Days'
        WHEN DATEDIFF('day', DUE_DATE, CURRENT_DATE()) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF('day', DUE_DATE, CURRENT_DATE()) <= 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END AS AGING_BUCKET,
    STATUS,
    CASE MOD(ABS(HASH(INVOICE_ID)), 5)
        WHEN 0 THEN 'MENA' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Europe'
        WHEN 3 THEN 'Americas' WHEN 4 THEN 'MENA'
    END AS REGION,
    'USD' AS CURRENCY,
    CURRENT_DATE() AS AS_OF_DATE
FROM INVOICES
WHERE STATUS IN ('Open', 'Overdue');

-- ============================================================================
-- SCADA/IoT: Device Registry (40,000+ devices)
-- ============================================================================
USE SCHEMA SCADA_IOT;

INSERT INTO DEVICE_REGISTRY
SELECT
    UUID_STRING() AS DEVICE_ID,
    'PX-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS SERIAL_NUMBER,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'PX-Q650' WHEN 1 THEN 'PX-Q400' WHEN 2 THEN 'PX-Q400'
        WHEN 3 THEN 'PX-220' WHEN 4 THEN 'PX-G1300'
    END AS DEVICE_MODEL,
    'Pressure Exchanger' AS DEVICE_TYPE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Desalination' WHEN 1 THEN 'Desalination' WHEN 2 THEN 'Desalination'
        WHEN 3 THEN 'Wastewater' WHEN 4 THEN 'Refrigeration'
    END AS PRODUCT_LINE,
    CASE MOD(SEQ4(), 25)
        WHEN 0 THEN 'Rabigh 3 IWP' WHEN 1 THEN 'Jubail 3A IWP' WHEN 2 THEN 'Taweelah IWP'
        WHEN 3 THEN 'Hassyan IWP' WHEN 4 THEN 'Shuaibah 3 IWPP' WHEN 5 THEN 'Sorek B'
        WHEN 6 THEN 'Carlsbad Desalination' WHEN 7 THEN 'Perth SWRO' WHEN 8 THEN 'Barcelona SWRO'
        WHEN 9 THEN 'Chennai SWRO' WHEN 10 THEN 'Barka 5 IWP' WHEN 11 THEN 'Al Ghubrah 3'
        WHEN 12 THEN 'Yanbu 4' WHEN 13 THEN 'Umm Al Quwain' WHEN 14 THEN 'Dammam West'
        WHEN 15 THEN 'Shoaiba 4' WHEN 16 THEN 'Jubail 2' WHEN 17 THEN 'Ras Al Khair'
        WHEN 18 THEN 'Fujairah F3' WHEN 19 THEN 'Ain Sokhna' WHEN 20 THEN 'Tianjin Dagang'
        WHEN 21 THEN 'Qingdao Baifa' WHEN 22 THEN 'Nemmeli SWRO' WHEN 23 THEN 'Adelaide SWRO'
        WHEN 24 THEN 'Gold Coast SWRO'
    END AS INSTALLATION_SITE,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Saudi Arabia' WHEN 1 THEN 'Saudi Arabia' WHEN 2 THEN 'UAE'
        WHEN 3 THEN 'UAE' WHEN 4 THEN 'Saudi Arabia' WHEN 5 THEN 'Israel'
        WHEN 6 THEN 'USA' WHEN 7 THEN 'Australia' WHEN 8 THEN 'Spain'
        WHEN 9 THEN 'India' WHEN 10 THEN 'Oman' WHEN 11 THEN 'China'
    END AS SITE_COUNTRY,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'MENA' WHEN 1 THEN 'MENA' WHEN 2 THEN 'MENA'
        WHEN 3 THEN 'Asia-Pacific' WHEN 4 THEN 'Americas' WHEN 5 THEN 'Europe'
    END AS SITE_REGION,
    UUID_STRING() AS CUSTOMER_ID,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'ACWA Power' WHEN 1 THEN 'SWCC' WHEN 2 THEN 'DEWA'
        WHEN 3 THEN 'IDE Technologies' WHEN 4 THEN 'Veolia' WHEN 5 THEN 'Acciona Agua'
        WHEN 6 THEN 'Poseidon Water' WHEN 7 THEN 'Water Corp Australia'
        WHEN 8 THEN 'Doosan' WHEN 9 THEN 'Metito'
    END AS CUSTOMER_NAME,
    DATEADD('day', -UNIFORM(365, 7300, RANDOM()), CURRENT_DATE()) AS INSTALLATION_DATE,
    DATEADD('year', 5, DATEADD('day', -UNIFORM(365, 7300, RANDOM()), CURRENT_DATE())) AS WARRANTY_EXPIRY,
    DATEADD('day', -UNIFORM(300, 7200, RANDOM()), CURRENT_DATE()) AS COMMISSIONING_DATE,
    UNIFORM(1000, 150000, RANDOM()) AS OPERATING_HOURS,
    CASE MOD(SEQ4(), 20)
        WHEN 19 THEN 'Maintenance' WHEN 18 THEN 'Standby'
        ELSE 'Active'
    END AS STATUS,
    'v' || UNIFORM(2, 5, RANDOM()) || '.' || UNIFORM(0, 9, RANDOM()) || '.' || UNIFORM(0, 9, RANDOM()) AS FIRMWARE_VERSION,
    DATEADD('day', -UNIFORM(30, 365, RANDOM()), CURRENT_DATE()) AS LAST_SERVICE_DATE,
    DATEADD('day', UNIFORM(30, 365, RANDOM()), CURRENT_DATE()) AS NEXT_SERVICE_DATE,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 42000));

-- ============================================================================
-- SCADA/IoT: Device Telemetry (sample - latest readings, 50K rows)
-- ============================================================================
INSERT INTO DEVICE_TELEMETRY
SELECT
    UUID_STRING() AS TELEMETRY_ID,
    d.DEVICE_ID,
    DATEADD('minute', -UNIFORM(0, 43200, RANDOM()), CURRENT_TIMESTAMP()) AS TIMESTAMP,
    CURRENT_DATE() AS READING_DATE,
    ROUND(UNIFORM(55, 82, RANDOM()) + RANDOM() / 1e18, 2) AS INLET_PRESSURE_BAR,
    ROUND(UNIFORM(54, 81, RANDOM()) + RANDOM() / 1e18, 2) AS OUTLET_PRESSURE_BAR,
    ROUND(UNIFORM(0.5, 3.0, RANDOM()) + RANDOM() / 1e18, 2) AS PRESSURE_DIFFERENTIAL,
    ROUND(UNIFORM(20, 70, RANDOM()) + RANDOM() / 1e18, 2) AS FLOW_RATE_M3H,
    ROUND(UNIFORM(92, 99, RANDOM()) + RANDOM() / 1e18, 2) AS ENERGY_RECOVERY_PCT,
    ROUND(UNIFORM(0.5, 8.0, RANDOM()) + RANDOM() / 1e18, 3) AS VIBRATION_MM_S,
    ROUND(UNIFORM(18, 42, RANDOM()) + RANDOM() / 1e18, 2) AS TEMPERATURE_C,
    UNIFORM(800, 1800, RANDOM()) AS ROTOR_SPEED_RPM,
    ROUND(UNIFORM(0.5, 5.0, RANDOM()) + RANDOM() / 1e18, 2) AS POWER_CONSUMPTION_KW,
    UNIFORM(25000, 45000, RANDOM()) AS SALINITY_PPM,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'High Load' WHEN 9 THEN 'Low Load' WHEN 8 THEN 'Startup'
        ELSE 'Normal'
    END AS OPERATING_MODE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Good' WHEN UNIFORM(1, 100, RANDOM()) <= 98 THEN 'Suspect' ELSE 'Bad' END AS DATA_QUALITY
FROM TABLE(GENERATOR(ROWCOUNT => 50000)) g
JOIN (SELECT DEVICE_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM DEVICE_REGISTRY WHERE STATUS = 'Active' LIMIT 5000) d
    ON MOD(SEQ4(), 5000) + 1 = d.RN;

-- ============================================================================
-- SCADA/IoT: Alarms (2000+)
-- ============================================================================
INSERT INTO ALARMS
SELECT
    UUID_STRING() AS ALARM_ID,
    d.DEVICE_ID,
    DATEADD('hour', -UNIFORM(0, 8760, RANDOM()), CURRENT_TIMESTAMP()) AS ALARM_TIMESTAMP,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'VIB-HIGH' WHEN 1 THEN 'PRESS-DIFF-HIGH' WHEN 2 THEN 'TEMP-HIGH'
        WHEN 3 THEN 'FLOW-LOW' WHEN 4 THEN 'EFF-LOW' WHEN 5 THEN 'ROTOR-SPEED'
        WHEN 6 THEN 'SEAL-LEAK' WHEN 7 THEN 'COMM-FAIL'
    END AS ALARM_CODE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Critical' WHEN 1 THEN 'High' WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Medium' WHEN 4 THEN 'Low'
    END AS ALARM_SEVERITY,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Vibration' WHEN 1 THEN 'Pressure' WHEN 2 THEN 'Temperature'
        WHEN 3 THEN 'Flow' WHEN 4 THEN 'Efficiency' WHEN 5 THEN 'Mechanical'
        WHEN 6 THEN 'Seal Integrity' WHEN 7 THEN 'Communication'
    END AS ALARM_TYPE,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Vibration level exceeded threshold - possible bearing wear or rotor imbalance'
        WHEN 1 THEN 'Pressure differential across PX exceeded normal operating range'
        WHEN 2 THEN 'Outlet temperature above normal - check cooling system'
        WHEN 3 THEN 'Flow rate below minimum threshold - possible blockage or valve issue'
        WHEN 4 THEN 'Energy recovery efficiency below 94% threshold'
        WHEN 5 THEN 'Rotor speed outside normal operating range'
        WHEN 6 THEN 'Possible seal leak detected - increased mixing observed'
        WHEN 7 THEN 'Communication timeout with device controller'
    END AS DESCRIPTION,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN TRUE ELSE FALSE END AS ACKNOWLEDGED,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Operations Control Center' ELSE NULL END AS ACKNOWLEDGED_BY,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN DATEADD('hour', UNIFORM(1, 48, RANDOM()), DATEADD('hour', -UNIFORM(0, 8760, RANDOM()), CURRENT_TIMESTAMP())) ELSE NULL END AS RESOLVED_TIMESTAMP,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Bearing wear' WHEN 1 THEN 'Fouling' WHEN 2 THEN 'Seal degradation'
        WHEN 3 THEN 'Process upset' WHEN 4 THEN 'Sensor drift'
    END AS ROOT_CAUSE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Scheduled maintenance for bearing replacement'
        WHEN 1 THEN 'Chemical cleaning performed'
        WHEN 2 THEN 'Seal kit replaced during next service window'
        WHEN 3 THEN 'Operating parameters adjusted'
        WHEN 4 THEN 'Sensor recalibrated'
    END AS ACTION_TAKEN
FROM TABLE(GENERATOR(ROWCOUNT => 2500)) g
JOIN (SELECT DEVICE_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM DEVICE_REGISTRY LIMIT 1000) d
    ON MOD(SEQ4(), 1000) + 1 = d.RN;

-- ============================================================================
-- SCADA/IoT: Maintenance Logs (3000+)
-- ============================================================================
INSERT INTO MAINTENANCE_LOGS
SELECT
    UUID_STRING() AS MAINTENANCE_ID,
    d.DEVICE_ID,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Preventive' WHEN 1 THEN 'Corrective' WHEN 2 THEN 'Preventive' WHEN 3 THEN 'Predictive'
    END AS MAINTENANCE_TYPE,
    'WO-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS WORK_ORDER_NUMBER,
    DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_TIMESTAMP()) AS START_DATE,
    DATEADD('hour', UNIFORM(4, 72, RANDOM()), DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_TIMESTAMP())) AS END_DATE,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'Annual preventive maintenance - seal and bearing inspection and replacement'
        WHEN 1 THEN 'Corrective maintenance - vibration alarm investigation and bearing replacement'
        WHEN 2 THEN 'Scheduled rotor inspection and clearance measurement'
        WHEN 3 THEN 'Predictive maintenance - bearing replacement based on vibration trend analysis'
        WHEN 4 THEN 'Seal kit replacement per maintenance schedule'
        WHEN 5 THEN 'Performance optimization - rotor rebalancing and seal replacement'
    END AS DESCRIPTION,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Seal kit, thrust bearings' WHEN 1 THEN 'Thrust bearings, O-rings'
        WHEN 2 THEN 'Seal kit only' WHEN 3 THEN 'Rotor, seals, bearings'
        WHEN 4 THEN 'End cover gaskets, seals'
    END AS PARTS_REPLACED,
    ROUND(UNIFORM(4, 40, RANDOM())::NUMBER, 2) AS LABOR_HOURS,
    ROUND(UNIFORM(500, 15000, RANDOM())::NUMBER, 2) AS PARTS_COST,
    ROUND(UNIFORM(400, 8000, RANDOM())::NUMBER, 2) AS LABOR_COST,
    NULL AS TOTAL_COST,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'John Smith' WHEN 1 THEN 'Ahmed Khalil' WHEN 2 THEN 'Wei Zhang'
        WHEN 3 THEN 'Carlos Ruiz' WHEN 4 THEN 'Raj Patel' WHEN 5 THEN 'Tom Anderson'
    END AS TECHNICIAN,
    CASE MOD(SEQ4(), 5)
        WHEN 4 THEN 'Planned' ELSE 'Completed'
    END AS STATUS,
    ROUND(UNIFORM(4, 72, RANDOM())::NUMBER, 2) AS DOWNTIME_HOURS,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'Seal wear' WHEN 1 THEN 'Bearing failure' WHEN 2 THEN 'Normal wear'
        WHEN 3 THEN 'Vibration anomaly' WHEN 4 THEN 'Scheduled replacement' WHEN 5 THEN 'Efficiency degradation'
    END AS FAILURE_MODE
FROM TABLE(GENERATOR(ROWCOUNT => 3200)) g
JOIN (SELECT DEVICE_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM DEVICE_REGISTRY LIMIT 2000) d
    ON MOD(SEQ4(), 2000) + 1 = d.RN;

UPDATE MAINTENANCE_LOGS SET TOTAL_COST = PARTS_COST + LABOR_COST;

-- ============================================================================
-- ORACLE ERP: Production Orders (1200+)
-- ============================================================================
USE SCHEMA ORACLE_ERP;

INSERT INTO PRODUCTION_ORDERS
SELECT
    UUID_STRING() AS PRODUCTION_ORDER_ID,
    'PO-' || LPAD(SEQ4()::VARCHAR, 7, '0') AS ORDER_NUMBER,
    UUID_STRING() AS PRODUCT_ID,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'PX Q650 Pressure Exchanger' WHEN 1 THEN 'PX Q400 Pressure Exchanger'
        WHEN 2 THEN 'PX-220 Pressure Exchanger' WHEN 3 THEN 'PX G1300 CO2 Unit'
        WHEN 4 THEN 'Aftermarket Seal Kit'
    END AS PRODUCT_NAME,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'PX-Q650' WHEN 1 THEN 'PX-Q400' WHEN 2 THEN 'PX-220'
        WHEN 3 THEN 'PX-G1300' WHEN 4 THEN 'AMS-KIT'
    END AS PRODUCT_MODEL,
    UNIFORM(1, 24, RANDOM()) AS QUANTITY_ORDERED,
    UNIFORM(0, 20, RANDOM()) AS QUANTITY_COMPLETED,
    UNIFORM(0, 2, RANDOM()) AS QUANTITY_SCRAPPED,
    DATEADD('day', -UNIFORM(0, 365, RANDOM()), CURRENT_DATE()) AS START_DATE,
    DATEADD('day', UNIFORM(14, 90, RANDOM()), CURRENT_DATE()) AS END_DATE,
    DATEADD('day', UNIFORM(30, 120, RANDOM()), CURRENT_DATE()) AS DUE_DATE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Planned' WHEN 1 THEN 'Released' WHEN 2 THEN 'In Progress'
        WHEN 3 THEN 'Completed' WHEN 4 THEN 'In Progress'
    END AS STATUS,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Ceramic Forming' WHEN 1 THEN 'CNC Machining' WHEN 2 THEN 'Assembly'
        WHEN 3 THEN 'Final Assembly' WHEN 4 THEN 'Packaging'
    END AS WORK_CENTER,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'High' WHEN 1 THEN 'Medium' WHEN 2 THEN 'Low' END AS PRIORITY,
    ROUND(UNIFORM(85, 99, RANDOM()) + RANDOM() / 1e18, 2) AS YIELD_PERCENT,
    ROUND(UNIFORM(8, 120, RANDOM()) + RANDOM() / 1e18, 2) AS CYCLE_TIME_HOURS,
    'San Leandro' AS SITE,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 1200));

-- ============================================================================
-- ORACLE ERP: Inventory (500+ items)
-- ============================================================================
INSERT INTO INVENTORY
SELECT
    UUID_STRING() AS INVENTORY_ID,
    UUID_STRING() AS ITEM_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Alumina Ceramic Powder - 99.7%' WHEN 1 THEN 'Duplex Steel Bar - SAF 2507'
        WHEN 2 THEN 'EPDM O-Ring Set' WHEN 3 THEN 'Silicon Carbide Bearing'
        WHEN 4 THEN 'Ceramic Rotor - Q650' WHEN 5 THEN 'Ceramic Rotor - Q400'
        WHEN 6 THEN 'End Cover Assembly - Q650' WHEN 7 THEN 'End Cover Assembly - Q400'
        WHEN 8 THEN 'Ceramic Sleeve - Q650' WHEN 9 THEN 'Ceramic Sleeve - Q400'
        WHEN 10 THEN 'Stainless Steel Housing' WHEN 11 THEN 'Viton Seal Kit'
        WHEN 12 THEN 'Thrust Ring Assembly' WHEN 13 THEN 'PX Q650 (Finished)'
        WHEN 14 THEN 'PX Q400 (Finished)' WHEN 15 THEN 'PX G1300 (Finished)'
        WHEN 16 THEN 'Aftermarket Seal Kit - Standard' WHEN 17 THEN 'Packaging Crate - Large'
        WHEN 18 THEN 'Diamond Grinding Wheel' WHEN 19 THEN 'Lubricant - Food Grade'
    END AS ITEM_NAME,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Raw Material' WHEN 1 THEN 'WIP' WHEN 2 THEN 'Finished Good' WHEN 3 THEN 'Spare Part'
    END AS ITEM_CATEGORY,
    CASE MOD(SEQ4(), 3)
        WHEN 0 THEN 'Main Warehouse' WHEN 1 THEN 'Production Floor' WHEN 2 THEN 'Finished Goods'
    END AS WAREHOUSE,
    'BIN-' || LPAD(MOD(SEQ4(), 200)::VARCHAR, 4, '0') AS LOCATION,
    UNIFORM(10, 5000, RANDOM()) AS QUANTITY_ON_HAND,
    UNIFORM(0, 500, RANDOM()) AS QUANTITY_RESERVED,
    NULL AS QUANTITY_AVAILABLE,
    UNIFORM(5, 1000, RANDOM()) AS REORDER_POINT,
    UNIFORM(50, 2000, RANDOM()) AS REORDER_QUANTITY,
    ROUND(UNIFORM(5, 50000, RANDOM())::NUMBER / 100.0, 4) AS UNIT_COST,
    NULL AS TOTAL_VALUE,
    DATEADD('day', -UNIFORM(1, 90, RANDOM()), CURRENT_DATE()) AS LAST_RECEIPT_DATE,
    DATEADD('day', -UNIFORM(1, 30, RANDOM()), CURRENT_DATE()) AS LAST_ISSUE_DATE,
    CURRENT_DATE() AS AS_OF_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 500));

UPDATE INVENTORY SET
    QUANTITY_AVAILABLE = QUANTITY_ON_HAND - QUANTITY_RESERVED,
    TOTAL_VALUE = QUANTITY_ON_HAND * UNIT_COST;

-- ============================================================================
-- ORACLE ERP: Suppliers (100+)
-- ============================================================================
INSERT INTO SUPPLIERS
SELECT
    UUID_STRING() AS SUPPLIER_ID,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'CeramTec GmbH' WHEN 1 THEN 'Kyocera Corporation'
        WHEN 2 THEN 'Morgan Advanced Materials' WHEN 3 THEN 'Sandvik AB'
        WHEN 4 THEN 'Outokumpu Oyj' WHEN 5 THEN 'Parker Hannifin'
        WHEN 6 THEN 'Trelleborg Sealing Solutions' WHEN 7 THEN 'SKF Group'
        WHEN 8 THEN 'Saint-Gobain Ceramics' WHEN 9 THEN 'CoorsTek Inc'
        WHEN 10 THEN 'Kennametal Inc' WHEN 11 THEN 'Regal Rexnord'
        WHEN 12 THEN 'Gates Corporation' WHEN 13 THEN 'Freudenberg Group'
        WHEN 14 THEN 'NOK Corporation' WHEN 15 THEN 'Precision Castparts'
        WHEN 16 THEN 'Bodycote plc' WHEN 17 THEN 'Materion Corporation'
        WHEN 18 THEN 'II-VI Incorporated' WHEN 19 THEN 'Corning Incorporated'
    END || ' - ' || LPAD(SEQ4()::VARCHAR, 3, '0') AS SUPPLIER_NAME,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Raw Material' WHEN 1 THEN 'Component' WHEN 2 THEN 'Service' WHEN 3 THEN 'Logistics'
    END AS SUPPLIER_TYPE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Ceramics' WHEN 1 THEN 'Metals' WHEN 2 THEN 'Seals'
        WHEN 3 THEN 'Electronics' WHEN 4 THEN 'Packaging'
    END AS CATEGORY,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Germany' WHEN 1 THEN 'Japan' WHEN 2 THEN 'USA' WHEN 3 THEN 'Sweden'
        WHEN 4 THEN 'Finland' WHEN 5 THEN 'UK' WHEN 6 THEN 'France' WHEN 7 THEN 'China'
    END AS COUNTRY,
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Europe' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Americas' WHEN 3 THEN 'Europe'
    END AS REGION,
    UNIFORM(14, 90, RANDOM()) AS LEAD_TIME_DAYS,
    ROUND(UNIFORM(80, 99, RANDOM()) + RANDOM() / 1e18, 2) AS ON_TIME_DELIVERY_PCT,
    ROUND(UNIFORM(30, 50, RANDOM()) / 10.0, 1) AS QUALITY_RATING,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Net 30' WHEN 1 THEN 'Net 45' WHEN 2 THEN 'Net 60' END AS PAYMENT_TERMS,
    ROUND(UNIFORM(100000, 10000000, RANDOM())::NUMBER, 2) AS ANNUAL_SPEND,
    TRUE AS IS_CERTIFIED,
    DATEADD('day', UNIFORM(90, 730, RANDOM()), CURRENT_DATE()) AS CONTRACT_EXPIRY,
    CURRENT_TIMESTAMP() AS CREATED_DATE
FROM TABLE(GENERATOR(ROWCOUNT => 120));
