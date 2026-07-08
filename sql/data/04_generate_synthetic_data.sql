/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 04_generate_synthetic_data.sql
  Purpose: Generate realistic synthetic data for all source systems
  Execution Order: 4 of 10
  
  Generates ~173,000+ rows across all tables. No table is left empty.
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- DYNAMICS CRM: Accounts (520)
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
    CASE MOD(SEQ4(), 8) WHEN 0 THEN 'Water & Desalination' WHEN 1 THEN 'Utilities' WHEN 2 THEN 'Industrial Manufacturing' WHEN 3 THEN 'Oil & Gas' WHEN 4 THEN 'Food & Beverage' WHEN 5 THEN 'Refrigeration & HVAC' WHEN 6 THEN 'Mining' WHEN 7 THEN 'Chemical Processing' END AS INDUSTRY,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Customer' WHEN 1 THEN 'Customer' WHEN 2 THEN 'Prospect' WHEN 3 THEN 'Partner' END AS ACCOUNT_TYPE,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Tier 1' WHEN 1 THEN 'Tier 2' WHEN 2 THEN 'Tier 3' END AS ACCOUNT_TIER,
    ROUND(UNIFORM(5000000, 500000000, RANDOM())::NUMBER, 2) AS ANNUAL_REVENUE,
    UNIFORM(50, 50000, RANDOM()) AS EMPLOYEE_COUNT,
    CASE MOD(SEQ4(), 6) WHEN 0 THEN 'MENA' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Europe' WHEN 3 THEN 'Americas' WHEN 4 THEN 'Africa' WHEN 5 THEN 'MENA' END AS REGION,
    CASE MOD(SEQ4(), 12) WHEN 0 THEN 'Saudi Arabia' WHEN 1 THEN 'UAE' WHEN 2 THEN 'China' WHEN 3 THEN 'India' WHEN 4 THEN 'Spain' WHEN 5 THEN 'USA' WHEN 6 THEN 'Australia' WHEN 7 THEN 'Israel' WHEN 8 THEN 'South Korea' WHEN 9 THEN 'Singapore' WHEN 10 THEN 'Chile' WHEN 11 THEN 'Oman' END AS COUNTRY,
    CASE MOD(SEQ4(), 12) WHEN 0 THEN 'Riyadh' WHEN 1 THEN 'Dubai' WHEN 2 THEN 'Shanghai' WHEN 3 THEN 'Mumbai' WHEN 4 THEN 'Madrid' WHEN 5 THEN 'Houston' WHEN 6 THEN 'Perth' WHEN 7 THEN 'Tel Aviv' WHEN 8 THEN 'Seoul' WHEN 9 THEN 'Singapore' WHEN 10 THEN 'Santiago' WHEN 11 THEN 'Muscat' END AS CITY,
    NULL AS WEBSITE,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber' WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison' END AS OWNER_NAME,
    NULL AS PARENT_ACCOUNT_ID,
    DATEADD('day', -UNIFORM(30, 2000, RANDOM()), CURRENT_TIMESTAMP()) AS CREATED_DATE,
    DATEADD('day', -UNIFORM(1, 30, RANDOM()), CURRENT_TIMESTAMP()) AS MODIFIED_DATE,
    TRUE AS IS_ACTIVE
FROM TABLE(GENERATOR(ROWCOUNT => 520));

-- ============================================================================
-- DYNAMICS CRM: Contacts (1500) - distributed across accounts
-- ============================================================================
INSERT INTO CONTACTS
SELECT UUID_STRING(),
    a.ACCOUNT_ID,
    CASE MOD(SEQ4(), 20) WHEN 0 THEN 'Mohammed' WHEN 1 THEN 'Chen' WHEN 2 THEN 'David' WHEN 3 THEN 'Maria' WHEN 4 THEN 'Raj' WHEN 5 THEN 'Sophie' WHEN 6 THEN 'Ahmed' WHEN 7 THEN 'Jun' WHEN 8 THEN 'Carlos' WHEN 9 THEN 'Anna' WHEN 10 THEN 'Robert' WHEN 11 THEN 'Fatima' WHEN 12 THEN 'Wei' WHEN 13 THEN 'James' WHEN 14 THEN 'Aisha' WHEN 15 THEN 'Thomas' WHEN 16 THEN 'Yuki' WHEN 17 THEN 'Omar' WHEN 18 THEN 'Priya' WHEN 19 THEN 'Hans' END,
    CASE MOD(SEQ4(), 15) WHEN 0 THEN 'Al-Rashid' WHEN 1 THEN 'Wong' WHEN 2 THEN 'Schmidt' WHEN 3 THEN 'Garcia' WHEN 4 THEN 'Patel' WHEN 5 THEN 'Martin' WHEN 6 THEN 'Hassan' WHEN 7 THEN 'Nakamura' WHEN 8 THEN 'Rodriguez' WHEN 9 THEN 'Jensen' WHEN 10 THEN 'Kumar' WHEN 11 THEN 'Kim' WHEN 12 THEN 'Santos' WHEN 13 THEN 'Mueller' WHEN 14 THEN 'Singh' END,
    'contact' || SEQ4() || '@example.com',
    '+1-555-' || LPAD(UNIFORM(1000, 9999, RANDOM())::VARCHAR, 4, '0'),
    CASE MOD(SEQ4(), 10) WHEN 0 THEN 'VP Engineering' WHEN 1 THEN 'CTO' WHEN 2 THEN 'Plant Manager' WHEN 3 THEN 'Procurement Director' WHEN 4 THEN 'Process Engineer' WHEN 5 THEN 'Operations Manager' WHEN 6 THEN 'Project Director' WHEN 7 THEN 'Maintenance Manager' WHEN 8 THEN 'Technical Director' WHEN 9 THEN 'CEO' END,
    CASE MOD(SEQ4(), 6) WHEN 0 THEN 'Engineering' WHEN 1 THEN 'Operations' WHEN 2 THEN 'Procurement' WHEN 3 THEN 'Executive' WHEN 4 THEN 'Maintenance' WHEN 5 THEN 'Project Management' END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Decision Maker' WHEN 1 THEN 'Influencer' WHEN 2 THEN 'Champion' WHEN 3 THEN 'End User' END,
    CASE WHEN MOD(SEQ4(), 5) = 0 THEN TRUE ELSE FALSE END,
    DATEADD('day', -UNIFORM(30, 1500, RANDOM()), CURRENT_TIMESTAMP()),
    DATEADD('day', -UNIFORM(1, 60, RANDOM()), CURRENT_TIMESTAMP())
FROM TABLE(GENERATOR(ROWCOUNT => 1500)) g
JOIN (SELECT ACCOUNT_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM ACCOUNTS) a
    ON MOD(SEQ4(), 520) + 1 = a.RN;

-- ============================================================================
-- DYNAMICS CRM: Opportunities (2200)
-- ============================================================================
INSERT INTO OPPORTUNITIES
SELECT UUID_STRING(), a.ACCOUNT_ID,
    a.ACCOUNT_NAME || ' - ' || CASE MOD(SEQ4(), 8) WHEN 0 THEN 'SWRO Plant ERD Package' WHEN 1 THEN 'PX Upgrade Project' WHEN 2 THEN 'New Desalination Facility' WHEN 3 THEN 'Aftermarket Service Contract' WHEN 4 THEN 'Wastewater Treatment ERD' WHEN 5 THEN 'CO2 Refrigeration Pilot' WHEN 6 THEN 'Expansion Phase II' WHEN 7 THEN 'Replacement Units' END,
    CASE MOD(SEQ4(), 7) WHEN 0 THEN 'Qualify' WHEN 1 THEN 'Develop' WHEN 2 THEN 'Develop' WHEN 3 THEN 'Propose' WHEN 4 THEN 'Negotiate' WHEN 5 THEN 'Close Won' WHEN 6 THEN 'Close Lost' END,
    ROUND(UNIFORM(50000, 15000000, RANDOM())::NUMBER, 2),
    DATEADD('day', UNIFORM(-90, 365, RANDOM()), CURRENT_DATE()),
    CASE MOD(SEQ4(), 7) WHEN 0 THEN 10 WHEN 1 THEN 25 WHEN 2 THEN 25 WHEN 3 THEN 50 WHEN 4 THEN 75 WHEN 5 THEN 100 WHEN 6 THEN 0 END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'PX Pressure Exchanger' WHEN 1 THEN 'PX Q650' WHEN 2 THEN 'PX G1300' WHEN 3 THEN 'Aftermarket Services' WHEN 4 THEN 'Wastewater PX' END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Desalination' WHEN 1 THEN 'Wastewater' WHEN 2 THEN 'CO2 Refrigeration' WHEN 3 THEN 'Desalination' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Trade Show' WHEN 1 THEN 'Referral' WHEN 2 THEN 'Web Inquiry' WHEN 3 THEN 'Existing Customer' WHEN 4 THEN 'Partner' END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Danfoss' WHEN 1 THEN 'Flowserve' WHEN 2 THEN 'Sulzer' WHEN 3 THEN NULL END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber' WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison' END,
    a.REGION,
    DATEADD('day', -UNIFORM(30, 730, RANDOM()), CURRENT_TIMESTAMP()),
    DATEADD('day', -UNIFORM(1, 30, RANDOM()), CURRENT_TIMESTAMP()),
    CASE WHEN MOD(SEQ4(), 7) IN (5, 6) THEN DATEADD('day', -UNIFORM(1, 180, RANDOM()), CURRENT_TIMESTAMP()) ELSE NULL END,
    CASE WHEN MOD(SEQ4(), 7) = 6 THEN CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Price' WHEN 1 THEN 'Timing' WHEN 2 THEN 'Technical' WHEN 3 THEN 'Budget' END ELSE NULL END,
    'Follow up next week'
FROM TABLE(GENERATOR(ROWCOUNT => 2200)) g
JOIN (SELECT ACCOUNT_ID, ACCOUNT_NAME, REGION, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM ACCOUNTS) a
    ON MOD(SEQ4(), 520) + 1 = a.RN;

-- ============================================================================
-- DYNAMICS CRM: Activities (3000) - distributed across accounts/contacts/opps
-- ============================================================================
INSERT INTO ACTIVITIES
SELECT UUID_STRING(),
    a.ACCOUNT_ID,
    c.CONTACT_ID,
    o.OPPORTUNITY_ID,
    CASE MOD(a.RN, 5) WHEN 0 THEN 'Email' WHEN 1 THEN 'Call' WHEN 2 THEN 'Meeting' WHEN 3 THEN 'Demo' WHEN 4 THEN 'Site Visit' END,
    CASE MOD(a.RN, 10) WHEN 0 THEN 'Follow-up on PX Q650 proposal' WHEN 1 THEN 'Technical review meeting' WHEN 2 THEN 'Quarterly business review' WHEN 3 THEN 'Product demo - desalination ERD' WHEN 4 THEN 'Site visit - new plant assessment' WHEN 5 THEN 'Pricing discussion' WHEN 6 THEN 'Contract negotiation call' WHEN 7 THEN 'PX G1300 introduction' WHEN 8 THEN 'Aftermarket service review' WHEN 9 THEN 'Competitive displacement meeting' END,
    'Engagement with customer regarding Energy Recovery solutions',
    DATEADD('day', -UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()),
    CASE MOD(a.RN, 5) WHEN 0 THEN 5 WHEN 1 THEN 15 WHEN 2 THEN 60 WHEN 3 THEN 90 WHEN 4 THEN 480 END,
    CASE MOD(a.RN, 3) WHEN 0 THEN 'Completed' WHEN 1 THEN 'Completed' WHEN 2 THEN 'Scheduled' END,
    CASE MOD(a.RN, 5) WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber' WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison' END,
    CURRENT_TIMESTAMP()
FROM (SELECT ACCOUNT_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM ACCOUNTS LIMIT 520) a
CROSS JOIN (SELECT SEQ4() AS N FROM TABLE(GENERATOR(ROWCOUNT => 6))) g2
JOIN (SELECT CONTACT_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM CONTACTS) c ON MOD(a.RN * 6 + g2.N, 1500) + 1 = c.RN
JOIN (SELECT OPPORTUNITY_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM OPPORTUNITIES) o ON MOD(a.RN * 6 + g2.N, (SELECT COUNT(*) FROM OPPORTUNITIES)) + 1 = o.RN
LIMIT 3000;

-- ============================================================================
-- DYNAMICS FINANCE: General Ledger (5000)
-- ============================================================================
USE SCHEMA DYNAMICS_FINANCE;

INSERT INTO GENERAL_LEDGER
SELECT UUID_STRING(),
    DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE()),
    YEAR(DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE())),
    QUARTER(DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE())),
    MONTH(DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE())),
    CASE MOD(SEQ4(), 12) WHEN 0 THEN '4100-001' WHEN 1 THEN '4100-002' WHEN 2 THEN '4100-003' WHEN 3 THEN '5100-001' WHEN 4 THEN '5100-002' WHEN 5 THEN '6100-001' WHEN 6 THEN '6200-001' WHEN 7 THEN '6300-001' WHEN 8 THEN '6400-001' WHEN 9 THEN '4200-001' WHEN 10 THEN '5200-001' WHEN 11 THEN '6500-001' END,
    CASE MOD(SEQ4(), 12) WHEN 0 THEN 'Product Revenue - Desalination' WHEN 1 THEN 'Product Revenue - Wastewater' WHEN 2 THEN 'Product Revenue - Refrigeration' WHEN 3 THEN 'COGS - Materials' WHEN 4 THEN 'COGS - Labor' WHEN 5 THEN 'R&D' WHEN 6 THEN 'Sales & Marketing' WHEN 7 THEN 'G&A' WHEN 8 THEN 'Depreciation' WHEN 9 THEN 'Service Revenue' WHEN 10 THEN 'Manufacturing Overhead' WHEN 11 THEN 'Facilities' END,
    CASE MOD(SEQ4(), 12) WHEN 0 THEN 'Revenue' WHEN 1 THEN 'Revenue' WHEN 2 THEN 'Revenue' WHEN 3 THEN 'COGS' WHEN 4 THEN 'COGS' WHEN 5 THEN 'Operating Expense' WHEN 6 THEN 'Operating Expense' WHEN 7 THEN 'Operating Expense' WHEN 8 THEN 'Operating Expense' WHEN 9 THEN 'Revenue' WHEN 10 THEN 'COGS' WHEN 11 THEN 'Operating Expense' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Engineering' WHEN 1 THEN 'Manufacturing' WHEN 2 THEN 'Sales' WHEN 3 THEN 'Corporate' WHEN 4 THEN 'Service' END,
    'CC-' || (MOD(SEQ4(), 4) + 1) * 100,
    CASE WHEN MOD(SEQ4(), 12) IN (0,1,2,9) THEN 0 ELSE ROUND(UNIFORM(1000, 2000000, RANDOM())::NUMBER, 2) END,
    CASE WHEN MOD(SEQ4(), 12) IN (0,1,2,9) THEN ROUND(UNIFORM(50000, 5000000, RANDOM())::NUMBER, 2) ELSE 0 END,
    CASE WHEN MOD(SEQ4(), 12) IN (0,1,2,9) THEN ROUND(UNIFORM(50000, 5000000, RANDOM())::NUMBER, 2) ELSE -ROUND(UNIFORM(1000, 2000000, RANDOM())::NUMBER, 2) END,
    'USD', 'Monthly posting', 'Microsoft Dynamics 365 F&O', CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

-- ============================================================================
-- DYNAMICS FINANCE: Sales Orders (850)
-- ============================================================================
INSERT INTO SALES_ORDERS
SELECT UUID_STRING(), 'SO-' || LPAD(SEQ4()::VARCHAR, 7, '0'), UUID_STRING(),
    CASE MOD(SEQ4(), 10) WHEN 0 THEN 'ACWA Power' WHEN 1 THEN 'IDE Technologies' WHEN 2 THEN 'Veolia Water' WHEN 3 THEN 'SUEZ Water' WHEN 4 THEN 'Doosan' WHEN 5 THEN 'SWCC' WHEN 6 THEN 'DEWA' WHEN 7 THEN 'Samsung Engineering' WHEN 8 THEN 'Acciona Agua' WHEN 9 THEN 'Carrier Global' END,
    DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_DATE()),
    DATEADD('day', UNIFORM(30, 180, RANDOM()), CURRENT_DATE()), NULL,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Open' WHEN 1 THEN 'Confirmed' WHEN 2 THEN 'Shipped' WHEN 3 THEN 'Invoiced' WHEN 4 THEN 'Open' END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Desalination' WHEN 1 THEN 'Desalination' WHEN 2 THEN 'Aftermarket' WHEN 3 THEN 'Wastewater' END,
    CASE MOD(SEQ4(), 6) WHEN 0 THEN 'PX Q650' WHEN 1 THEN 'PX Q400' WHEN 2 THEN 'PX-220' WHEN 3 THEN 'Aftermarket Seal Kit' WHEN 4 THEN 'PX G1300' WHEN 5 THEN 'Wastewater PX' END,
    UNIFORM(1, 48, RANDOM()), ROUND(UNIFORM(5000, 350000, RANDOM())::NUMBER, 2), NULL,
    ROUND(UNIFORM(0, 15, RANDOM())::NUMBER, 2),
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'MENA' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Europe' WHEN 3 THEN 'Americas' WHEN 4 THEN 'MENA' END,
    CASE MOD(SEQ4(), 6) WHEN 0 THEN 'Saudi Arabia' WHEN 1 THEN 'UAE' WHEN 2 THEN 'China' WHEN 3 THEN 'USA' WHEN 4 THEN 'Spain' WHEN 5 THEN 'India' END,
    'USD',
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Sarah Chen' WHEN 1 THEN 'Ahmed Al-Rashid' WHEN 2 THEN 'Marcus Weber' WHEN 3 THEN 'Priya Sharma' WHEN 4 THEN 'James Morrison' END,
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 850));

UPDATE SALES_ORDERS SET TOTAL_AMOUNT = QUANTITY * UNIT_PRICE * (1 - DISCOUNT_PERCENT/100);

-- ============================================================================
-- DYNAMICS FINANCE: Invoices (from shipped/invoiced orders)
-- ============================================================================
INSERT INTO INVOICES
SELECT UUID_STRING(), 'INV-' || LPAD(ROW_NUMBER() OVER (ORDER BY ORDER_DATE)::VARCHAR, 7, '0'),
    so.ORDER_ID, so.CUSTOMER_ID, so.CUSTOMER_NAME,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), so.ORDER_DATE),
    DATEADD('day', UNIFORM(30, 90, RANDOM()), so.ORDER_DATE),
    CASE WHEN MOD(ABS(HASH(so.ORDER_ID)), 3) IN (0,1) THEN DATEADD('day', UNIFORM(20, 75, RANDOM()), so.ORDER_DATE) ELSE NULL END,
    CASE MOD(ABS(HASH(so.ORDER_ID)), 4) WHEN 0 THEN 'Paid' WHEN 1 THEN 'Paid' WHEN 2 THEN 'Open' WHEN 3 THEN 'Overdue' END,
    so.TOTAL_AMOUNT,
    ROUND(so.TOTAL_AMOUNT * 0.05, 2),
    ROUND(so.TOTAL_AMOUNT * 1.05, 2),
    CASE WHEN MOD(ABS(HASH(so.ORDER_ID)), 4) IN (0,1) THEN ROUND(so.TOTAL_AMOUNT * 1.05, 2) ELSE ROUND(so.TOTAL_AMOUNT * UNIFORM(0, 50, RANDOM()) / 100.0, 2) END,
    NULL, so.PRODUCT_LINE, 'USD',
    CASE MOD(ABS(HASH(so.ORDER_ID)), 3) WHEN 0 THEN 'Net 30' WHEN 1 THEN 'Net 60' WHEN 2 THEN 'Net 90' END,
    CURRENT_TIMESTAMP()
FROM SALES_ORDERS so
WHERE so.STATUS IN ('Shipped', 'Invoiced');

UPDATE INVOICES SET BALANCE_DUE = TOTAL_AMOUNT - AMOUNT_PAID;

-- ============================================================================
-- DYNAMICS FINANCE: Accounts Receivable (from open/overdue invoices)
-- ============================================================================
INSERT INTO ACCOUNTS_RECEIVABLE
SELECT UUID_STRING(), i.CUSTOMER_ID, i.CUSTOMER_NAME, i.INVOICE_ID,
    i.INVOICE_DATE, i.DUE_DATE, i.TOTAL_AMOUNT, i.BALANCE_DUE,
    CASE
        WHEN i.BALANCE_DUE <= 0 THEN 'Current'
        WHEN DATEDIFF('day', i.DUE_DATE, CURRENT_DATE()) <= 0 THEN 'Current'
        WHEN DATEDIFF('day', i.DUE_DATE, CURRENT_DATE()) <= 30 THEN '1-30 Days'
        WHEN DATEDIFF('day', i.DUE_DATE, CURRENT_DATE()) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF('day', i.DUE_DATE, CURRENT_DATE()) <= 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END,
    i.STATUS,
    CASE MOD(ABS(HASH(i.INVOICE_ID)), 5) WHEN 0 THEN 'MENA' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Europe' WHEN 3 THEN 'Americas' WHEN 4 THEN 'MENA' END,
    'USD', CURRENT_DATE()
FROM INVOICES i
WHERE i.STATUS IN ('Open', 'Overdue');

-- ============================================================================
-- DYNAMICS FINANCE: Accounts Payable (600) - distributed across suppliers
-- ============================================================================
INSERT INTO ACCOUNTS_PAYABLE
SELECT UUID_STRING(),
    s.SUPPLIER_ID,
    s.SUPPLIER_NAME,
    'SINV-' || LPAD(s.RN::VARCHAR, 6, '0'),
    DATEADD('day', -UNIFORM(0, 180, RANDOM()), CURRENT_DATE()),
    DATEADD('day', -UNIFORM(-60, 120, RANDOM()), CURRENT_DATE()),
    CASE WHEN MOD(s.RN, 3) IN (0,1) THEN DATEADD('day', -UNIFORM(0, 60, RANDOM()), CURRENT_DATE()) ELSE NULL END,
    ROUND(UNIFORM(5000, 500000, RANDOM())::NUMBER, 2),
    CASE WHEN MOD(s.RN, 3) IN (0,1) THEN 0 ELSE ROUND(UNIFORM(5000, 500000, RANDOM())::NUMBER, 2) END,
    CASE MOD(s.RN, 3) WHEN 0 THEN 'Paid' WHEN 1 THEN 'Paid' WHEN 2 THEN 'Open' END,
    CASE MOD(s.RN, 5) WHEN 0 THEN 'Raw Materials' WHEN 1 THEN 'Components' WHEN 2 THEN 'Services' WHEN 3 THEN 'Equipment' WHEN 4 THEN 'Utilities' END,
    'USD', CURRENT_DATE()
FROM (
    SELECT SUPPLIER_ID, SUPPLIER_NAME, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN
    FROM ENERGY_RECOVERY_DB.ORACLE_ERP.SUPPLIERS
) s
CROSS JOIN (SELECT SEQ4() AS N FROM TABLE(GENERATOR(ROWCOUNT => 5))) g
LIMIT 600;

-- ============================================================================
-- SCADA/IoT: Device Registry (42,000 devices)
-- ============================================================================
USE SCHEMA SCADA_IOT;

INSERT INTO DEVICE_REGISTRY
SELECT UUID_STRING(), 'PX-' || LPAD(SEQ4()::VARCHAR, 7, '0'),
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'PX-Q650' WHEN 1 THEN 'PX-Q400' WHEN 2 THEN 'PX-Q400' WHEN 3 THEN 'PX-220' WHEN 4 THEN 'PX-G1300' END,
    'Pressure Exchanger',
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Desalination' WHEN 1 THEN 'Desalination' WHEN 2 THEN 'Desalination' WHEN 3 THEN 'Wastewater' WHEN 4 THEN 'Refrigeration' END,
    CASE MOD(SEQ4(), 15) WHEN 0 THEN 'Rabigh 3 IWP' WHEN 1 THEN 'Jubail 3A IWP' WHEN 2 THEN 'Taweelah IWP' WHEN 3 THEN 'Hassyan IWP' WHEN 4 THEN 'Sorek B' WHEN 5 THEN 'Carlsbad Desalination' WHEN 6 THEN 'Perth SWRO' WHEN 7 THEN 'Barcelona SWRO' WHEN 8 THEN 'Chennai SWRO' WHEN 9 THEN 'Barka 5 IWP' WHEN 10 THEN 'Al Ghubrah 3' WHEN 11 THEN 'Yanbu 4' WHEN 12 THEN 'Ras Al Khair' WHEN 13 THEN 'Fujairah F3' WHEN 14 THEN 'Tianjin Dagang' END,
    CASE MOD(SEQ4(), 8) WHEN 0 THEN 'Saudi Arabia' WHEN 1 THEN 'Saudi Arabia' WHEN 2 THEN 'UAE' WHEN 3 THEN 'UAE' WHEN 4 THEN 'Israel' WHEN 5 THEN 'USA' WHEN 6 THEN 'Australia' WHEN 7 THEN 'India' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'MENA' WHEN 1 THEN 'MENA' WHEN 2 THEN 'MENA' WHEN 3 THEN 'Asia-Pacific' WHEN 4 THEN 'Americas' END,
    UUID_STRING(),
    CASE MOD(SEQ4(), 8) WHEN 0 THEN 'ACWA Power' WHEN 1 THEN 'SWCC' WHEN 2 THEN 'DEWA' WHEN 3 THEN 'IDE Technologies' WHEN 4 THEN 'Veolia' WHEN 5 THEN 'Acciona Agua' WHEN 6 THEN 'Water Corp Australia' WHEN 7 THEN 'Doosan' END,
    DATEADD('day', -UNIFORM(365, 7300, RANDOM()), CURRENT_DATE()),
    DATEADD('year', 5, DATEADD('day', -UNIFORM(365, 7300, RANDOM()), CURRENT_DATE())),
    DATEADD('day', -UNIFORM(300, 7200, RANDOM()), CURRENT_DATE()),
    UNIFORM(1000, 150000, RANDOM()),
    CASE WHEN MOD(SEQ4(), 20) = 19 THEN 'Maintenance' WHEN MOD(SEQ4(), 20) = 18 THEN 'Standby' ELSE 'Active' END,
    'v' || UNIFORM(2, 5, RANDOM()) || '.' || UNIFORM(0, 9, RANDOM()),
    DATEADD('day', -UNIFORM(30, 365, RANDOM()), CURRENT_DATE()),
    DATEADD('day', UNIFORM(30, 365, RANDOM()), CURRENT_DATE()),
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 42000));

-- ============================================================================
-- SCADA/IoT: Device Telemetry (50,000 readings)
-- Uses CROSS JOIN to ensure proper distribution across 5000 devices x 10 readings
-- ============================================================================
INSERT INTO DEVICE_TELEMETRY
SELECT UUID_STRING(),
    d.DEVICE_ID,
    DATEADD('minute', -UNIFORM(0, 43200, RANDOM()), CURRENT_TIMESTAMP()),
    CURRENT_DATE(),
    ROUND(UNIFORM(55, 82, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(54, 81, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(0.5, 3.0, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(20, 70, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(92, 99, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(0.5, 8.0, RANDOM())::FLOAT, 3),
    ROUND(UNIFORM(18, 42, RANDOM())::FLOAT, 2),
    UNIFORM(800, 1800, RANDOM()),
    ROUND(UNIFORM(0.5, 5.0, RANDOM())::FLOAT, 2),
    UNIFORM(25000, 45000, RANDOM()),
    CASE MOD(ROW_NUMBER() OVER (ORDER BY d.DEVICE_ID), 10) WHEN 0 THEN 'High Load' WHEN 9 THEN 'Low Load' ELSE 'Normal' END,
    'Good'
FROM (
    SELECT DEVICE_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN
    FROM DEVICE_REGISTRY
    WHERE STATUS = 'Active'
    LIMIT 5000
) d
CROSS JOIN (SELECT SEQ4() AS N FROM TABLE(GENERATOR(ROWCOUNT => 10))) g;

-- ============================================================================
-- SCADA/IoT: Alarms (2500) - one alarm per device for even distribution
-- ============================================================================
INSERT INTO ALARMS
SELECT UUID_STRING(),
    d.DEVICE_ID,
    DATEADD('hour', -UNIFORM(0, 8760, RANDOM()), CURRENT_TIMESTAMP()),
    CASE MOD(d.RN, 8) WHEN 0 THEN 'VIB-HIGH' WHEN 1 THEN 'PRESS-DIFF-HIGH' WHEN 2 THEN 'TEMP-HIGH' WHEN 3 THEN 'FLOW-LOW' WHEN 4 THEN 'EFF-LOW' WHEN 5 THEN 'ROTOR-SPEED' WHEN 6 THEN 'SEAL-LEAK' WHEN 7 THEN 'COMM-FAIL' END,
    CASE MOD(d.RN, 5) WHEN 0 THEN 'Critical' WHEN 1 THEN 'High' WHEN 2 THEN 'Medium' WHEN 3 THEN 'Medium' WHEN 4 THEN 'Low' END,
    CASE MOD(d.RN, 8) WHEN 0 THEN 'Vibration' WHEN 1 THEN 'Pressure' WHEN 2 THEN 'Temperature' WHEN 3 THEN 'Flow' WHEN 4 THEN 'Efficiency' WHEN 5 THEN 'Mechanical' WHEN 6 THEN 'Seal Integrity' WHEN 7 THEN 'Communication' END,
    'Alarm triggered - threshold exceeded',
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN TRUE ELSE FALSE END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Operations Center' ELSE NULL END,
    NULL,
    CASE MOD(d.RN, 5) WHEN 0 THEN 'Bearing wear' WHEN 1 THEN 'Fouling' WHEN 2 THEN 'Seal degradation' WHEN 3 THEN 'Process upset' WHEN 4 THEN 'Sensor drift' END,
    'Investigated and resolved'
FROM (SELECT DEVICE_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM DEVICE_REGISTRY LIMIT 2500) d;

-- ============================================================================
-- SCADA/IoT: Maintenance Logs (3200) - one per device for even distribution
-- ============================================================================
INSERT INTO MAINTENANCE_LOGS
SELECT UUID_STRING(),
    d.DEVICE_ID,
    CASE MOD(d.RN, 4) WHEN 0 THEN 'Preventive' WHEN 1 THEN 'Corrective' WHEN 2 THEN 'Preventive' WHEN 3 THEN 'Predictive' END,
    'WO-' || LPAD(d.RN::VARCHAR, 7, '0'),
    DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_TIMESTAMP()),
    DATEADD('hour', UNIFORM(4, 72, RANDOM()), DATEADD('day', -UNIFORM(1, 730, RANDOM()), CURRENT_TIMESTAMP())),
    'Scheduled maintenance - inspection and parts replacement',
    CASE MOD(d.RN, 5) WHEN 0 THEN 'Seal kit, thrust bearings' WHEN 1 THEN 'Thrust bearings' WHEN 2 THEN 'Seal kit only' WHEN 3 THEN 'Rotor, seals, bearings' WHEN 4 THEN 'End cover gaskets' END,
    ROUND(UNIFORM(4, 40, RANDOM())::NUMBER, 2),
    ROUND(UNIFORM(500, 15000, RANDOM())::NUMBER, 2),
    ROUND(UNIFORM(400, 8000, RANDOM())::NUMBER, 2),
    NULL,
    CASE MOD(d.RN, 6) WHEN 0 THEN 'John Smith' WHEN 1 THEN 'Ahmed Khalil' WHEN 2 THEN 'Wei Zhang' WHEN 3 THEN 'Carlos Ruiz' WHEN 4 THEN 'Raj Patel' WHEN 5 THEN 'Tom Anderson' END,
    'Completed',
    ROUND(UNIFORM(4, 72, RANDOM())::NUMBER, 2),
    CASE MOD(d.RN, 6) WHEN 0 THEN 'Seal wear' WHEN 1 THEN 'Bearing failure' WHEN 2 THEN 'Normal wear' WHEN 3 THEN 'Vibration anomaly' WHEN 4 THEN 'Scheduled replacement' WHEN 5 THEN 'Efficiency degradation' END
FROM (SELECT DEVICE_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM DEVICE_REGISTRY LIMIT 3200) d;

UPDATE MAINTENANCE_LOGS SET TOTAL_COST = PARTS_COST + LABOR_COST;

-- ============================================================================
-- ORACLE ERP: Production Orders (1200)
-- ============================================================================
USE SCHEMA ORACLE_ERP;

INSERT INTO PRODUCTION_ORDERS
SELECT UUID_STRING(), 'PO-' || LPAD(SEQ4()::VARCHAR, 7, '0'), UUID_STRING(),
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'PX Q650' WHEN 1 THEN 'PX Q400' WHEN 2 THEN 'PX-220' WHEN 3 THEN 'PX G1300' WHEN 4 THEN 'Aftermarket Seal Kit' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'PX-Q650' WHEN 1 THEN 'PX-Q400' WHEN 2 THEN 'PX-220' WHEN 3 THEN 'PX-G1300' WHEN 4 THEN 'AMS-KIT' END,
    UNIFORM(1, 24, RANDOM()), UNIFORM(0, 20, RANDOM()), UNIFORM(0, 2, RANDOM()),
    DATEADD('day', -UNIFORM(0, 365, RANDOM()), CURRENT_DATE()),
    DATEADD('day', UNIFORM(14, 90, RANDOM()), CURRENT_DATE()),
    DATEADD('day', UNIFORM(30, 120, RANDOM()), CURRENT_DATE()),
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Planned' WHEN 1 THEN 'Released' WHEN 2 THEN 'In Progress' WHEN 3 THEN 'Completed' WHEN 4 THEN 'In Progress' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Ceramic Forming' WHEN 1 THEN 'CNC Machining' WHEN 2 THEN 'Assembly' WHEN 3 THEN 'Final Assembly' WHEN 4 THEN 'Packaging' END,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'High' WHEN 1 THEN 'Medium' WHEN 2 THEN 'Low' END,
    ROUND(UNIFORM(85, 99, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(8, 120, RANDOM())::FLOAT, 2),
    'San Leandro', CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 1200));

-- ============================================================================
-- ORACLE ERP: Bill of Materials (400)
-- ============================================================================
INSERT INTO BILL_OF_MATERIALS
SELECT UUID_STRING(), UUID_STRING(),
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'PX Q650 Pressure Exchanger' WHEN 1 THEN 'PX Q400 Pressure Exchanger' WHEN 2 THEN 'PX-220 Pressure Exchanger' WHEN 3 THEN 'PX G1300 CO2 Unit' WHEN 4 THEN 'Aftermarket Seal Kit' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'PX-Q650' WHEN 1 THEN 'PX-Q400' WHEN 2 THEN 'PX-220' WHEN 3 THEN 'PX-G1300' WHEN 4 THEN 'AMS-KIT' END,
    UUID_STRING(),
    CASE MOD(SEQ4(), 20) WHEN 0 THEN 'Alumina Ceramic Rotor' WHEN 1 THEN 'Ceramic Sleeve/Liner' WHEN 2 THEN 'End Cover - Drive Side' WHEN 3 THEN 'End Cover - Non-Drive Side' WHEN 4 THEN 'Thrust Bearing - SiC' WHEN 5 THEN 'EPDM O-Ring Kit' WHEN 6 THEN 'Viton Lip Seal' WHEN 7 THEN 'Housing Assembly - SS316' WHEN 8 THEN 'Duplex Steel Bar Stock' WHEN 9 THEN 'Inlet Manifold' WHEN 10 THEN 'Outlet Manifold' WHEN 11 THEN 'Mounting Bracket' WHEN 12 THEN 'Fastener Kit - A4-80' WHEN 13 THEN 'Lubrication Port Assembly' WHEN 14 THEN 'Pressure Gauge' WHEN 15 THEN 'Flow Sensor' WHEN 16 THEN 'Vibration Sensor' WHEN 17 THEN 'Temperature Probe' WHEN 18 THEN 'Nameplate & Labels' WHEN 19 THEN 'Documentation Package' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Ceramic' WHEN 1 THEN 'Metal' WHEN 2 THEN 'Seal' WHEN 3 THEN 'Bearing' WHEN 4 THEN 'Electronic' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 1.0 WHEN 1 THEN 1.0 WHEN 2 THEN 2.0 WHEN 3 THEN 4.0 WHEN 4 THEN 1.0 END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'each' WHEN 1 THEN 'kg' WHEN 2 THEN 'set' WHEN 3 THEN 'each' END,
    ROUND(UNIFORM(5, 25000, RANDOM())::NUMBER, 4),
    UNIFORM(7, 90, RANDOM()),
    (SELECT SUPPLIER_ID FROM SUPPLIERS LIMIT 1),
    CASE WHEN MOD(SEQ4(), 5) IN (0,1,4) THEN TRUE ELSE FALSE END,
    'Rev ' || CHR(65 + MOD(SEQ4(), 5)),
    DATEADD('day', -UNIFORM(0, 365, RANDOM()), CURRENT_DATE())
FROM TABLE(GENERATOR(ROWCOUNT => 400));

-- ============================================================================
-- ORACLE ERP: Inventory (500)
-- ============================================================================
INSERT INTO INVENTORY
SELECT UUID_STRING(), UUID_STRING(),
    CASE MOD(SEQ4(), 10) WHEN 0 THEN 'Alumina Ceramic Powder' WHEN 1 THEN 'Duplex Steel Bar' WHEN 2 THEN 'EPDM O-Ring Set' WHEN 3 THEN 'Silicon Carbide Bearing' WHEN 4 THEN 'Ceramic Rotor - Q650' WHEN 5 THEN 'End Cover Assembly' WHEN 6 THEN 'Viton Seal Kit' WHEN 7 THEN 'PX Q650 (Finished)' WHEN 8 THEN 'Diamond Grinding Wheel' WHEN 9 THEN 'Packaging Crate' END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Raw Material' WHEN 1 THEN 'WIP' WHEN 2 THEN 'Finished Good' WHEN 3 THEN 'Spare Part' END,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Main Warehouse' WHEN 1 THEN 'Production Floor' WHEN 2 THEN 'Finished Goods' END,
    'BIN-' || LPAD(MOD(SEQ4(), 200)::VARCHAR, 4, '0'),
    UNIFORM(10, 5000, RANDOM()), UNIFORM(0, 500, RANDOM()), NULL,
    UNIFORM(5, 1000, RANDOM()), UNIFORM(50, 2000, RANDOM()),
    ROUND(UNIFORM(5, 50000, RANDOM())::NUMBER / 100.0, 4), NULL,
    DATEADD('day', -UNIFORM(1, 90, RANDOM()), CURRENT_DATE()),
    DATEADD('day', -UNIFORM(1, 30, RANDOM()), CURRENT_DATE()), CURRENT_DATE()
FROM TABLE(GENERATOR(ROWCOUNT => 500));

UPDATE INVENTORY SET QUANTITY_AVAILABLE = QUANTITY_ON_HAND - QUANTITY_RESERVED, TOTAL_VALUE = QUANTITY_ON_HAND * UNIT_COST;

-- ============================================================================
-- ORACLE ERP: Suppliers (120)
-- ============================================================================
INSERT INTO SUPPLIERS
SELECT UUID_STRING(),
    CASE MOD(SEQ4(), 10) WHEN 0 THEN 'CeramTec GmbH' WHEN 1 THEN 'Kyocera Corporation' WHEN 2 THEN 'Morgan Advanced Materials' WHEN 3 THEN 'Sandvik AB' WHEN 4 THEN 'Parker Hannifin' WHEN 5 THEN 'Trelleborg Sealing' WHEN 6 THEN 'SKF Group' WHEN 7 THEN 'Saint-Gobain' WHEN 8 THEN 'CoorsTek Inc' WHEN 9 THEN 'Kennametal' END || ' - ' || LPAD(SEQ4()::VARCHAR, 3, '0'),
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Raw Material' WHEN 1 THEN 'Component' WHEN 2 THEN 'Service' WHEN 3 THEN 'Logistics' END,
    CASE MOD(SEQ4(), 5) WHEN 0 THEN 'Ceramics' WHEN 1 THEN 'Metals' WHEN 2 THEN 'Seals' WHEN 3 THEN 'Electronics' WHEN 4 THEN 'Packaging' END,
    CASE MOD(SEQ4(), 6) WHEN 0 THEN 'Germany' WHEN 1 THEN 'Japan' WHEN 2 THEN 'USA' WHEN 3 THEN 'Sweden' WHEN 4 THEN 'UK' WHEN 5 THEN 'China' END,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Europe' WHEN 1 THEN 'Asia-Pacific' WHEN 2 THEN 'Americas' END,
    UNIFORM(14, 90, RANDOM()),
    ROUND(UNIFORM(80, 99, RANDOM())::FLOAT, 2),
    ROUND(UNIFORM(30, 50, RANDOM()) / 10.0, 1),
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Net 30' WHEN 1 THEN 'Net 45' WHEN 2 THEN 'Net 60' END,
    ROUND(UNIFORM(100000, 10000000, RANDOM())::NUMBER, 2),
    TRUE, DATEADD('day', UNIFORM(90, 730, RANDOM()), CURRENT_DATE()), CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 120));

-- ============================================================================
-- ORACLE ERP: Purchase Orders (500)
-- ============================================================================
INSERT INTO PURCHASE_ORDERS
SELECT UUID_STRING(), 'PO-' || LPAD((s.RN + 5000)::VARCHAR, 7, '0'),
    s.SUPPLIER_ID,
    UUID_STRING(),
    CASE MOD(s.RN, 10) WHEN 0 THEN 'Alumina Powder 99.7%' WHEN 1 THEN 'Duplex Steel Bar SAF 2507' WHEN 2 THEN 'EPDM O-Ring Set' WHEN 3 THEN 'SiC Thrust Bearing' WHEN 4 THEN 'Viton Seal Kit' WHEN 5 THEN 'SS316 Housing Blank' WHEN 6 THEN 'Diamond Grinding Wheel' WHEN 7 THEN 'Packaging Crates' WHEN 8 THEN 'Lubricant - Food Grade' WHEN 9 THEN 'Electronic Sensors' END,
    UNIFORM(10, 500, RANDOM()),
    UNIFORM(0, 400, RANDOM()),
    ROUND(UNIFORM(10, 5000, RANDOM())::NUMBER, 4),
    ROUND(UNIFORM(5000, 500000, RANDOM())::NUMBER, 2),
    DATEADD('day', -UNIFORM(0, 365, RANDOM()), CURRENT_DATE()),
    DATEADD('day', UNIFORM(14, 90, RANDOM()), CURRENT_DATE()),
    CASE WHEN MOD(s.RN, 3) IN (0,1) THEN DATEADD('day', -UNIFORM(0, 60, RANDOM()), CURRENT_DATE()) ELSE NULL END,
    CASE MOD(s.RN, 5) WHEN 0 THEN 'Received' WHEN 1 THEN 'Received' WHEN 2 THEN 'Sent' WHEN 3 THEN 'Partially Received' WHEN 4 THEN 'Approved' END,
    CASE MOD(s.RN, 5) WHEN 0 THEN 'Ceramics' WHEN 1 THEN 'Metals' WHEN 2 THEN 'Seals' WHEN 3 THEN 'Electronics' WHEN 4 THEN 'Packaging' END,
    'Main Warehouse', CURRENT_TIMESTAMP()
FROM (SELECT SUPPLIER_ID, ROW_NUMBER() OVER (ORDER BY RANDOM()) AS RN FROM SUPPLIERS) s
CROSS JOIN (SELECT SEQ4() AS N FROM TABLE(GENERATOR(ROWCOUNT => 5))) g
LIMIT 500;
