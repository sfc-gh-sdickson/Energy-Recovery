/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 02_create_tables.sql
  Purpose: Create all table definitions organized by source system
  Execution Order: 2 of 10
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- DYNAMICS CRM TABLES (Microsoft Dynamics 365 CRM)
-- ============================================================================
USE SCHEMA DYNAMICS_CRM;

CREATE OR REPLACE TABLE ACCOUNTS (
    ACCOUNT_ID          VARCHAR(36) PRIMARY KEY,
    ACCOUNT_NAME        VARCHAR(255) NOT NULL,
    ACCOUNT_NUMBER      VARCHAR(50),
    INDUSTRY            VARCHAR(100),
    ACCOUNT_TYPE        VARCHAR(50),       -- Customer, Prospect, Partner
    ACCOUNT_TIER        VARCHAR(20),       -- Tier 1, Tier 2, Tier 3
    ANNUAL_REVENUE      NUMBER(18,2),
    EMPLOYEE_COUNT      NUMBER(10,0),
    REGION              VARCHAR(100),
    COUNTRY             VARCHAR(100),
    CITY                VARCHAR(100),
    WEBSITE             VARCHAR(500),
    OWNER_NAME          VARCHAR(255),
    PARENT_ACCOUNT_ID   VARCHAR(36),
    CREATED_DATE        TIMESTAMP_NTZ,
    MODIFIED_DATE       TIMESTAMP_NTZ,
    IS_ACTIVE           BOOLEAN DEFAULT TRUE
);

CREATE OR REPLACE TABLE CONTACTS (
    CONTACT_ID          VARCHAR(36) PRIMARY KEY,
    ACCOUNT_ID          VARCHAR(36) REFERENCES ACCOUNTS(ACCOUNT_ID),
    FIRST_NAME          VARCHAR(100),
    LAST_NAME           VARCHAR(100),
    EMAIL               VARCHAR(255),
    PHONE               VARCHAR(50),
    JOB_TITLE           VARCHAR(200),
    DEPARTMENT          VARCHAR(100),
    DECISION_ROLE       VARCHAR(50),       -- Decision Maker, Influencer, Champion, End User
    IS_PRIMARY          BOOLEAN DEFAULT FALSE,
    CREATED_DATE        TIMESTAMP_NTZ,
    MODIFIED_DATE       TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE OPPORTUNITIES (
    OPPORTUNITY_ID      VARCHAR(36) PRIMARY KEY,
    ACCOUNT_ID          VARCHAR(36) REFERENCES ACCOUNTS(ACCOUNT_ID),
    OPPORTUNITY_NAME    VARCHAR(500),
    STAGE               VARCHAR(100),      -- Qualify, Develop, Propose, Negotiate, Close Won, Close Lost
    AMOUNT              NUMBER(18,2),
    CLOSE_DATE          DATE,
    PROBABILITY         NUMBER(5,2),
    PRODUCT_INTEREST    VARCHAR(200),      -- PX Pressure Exchanger, PX G1300, Aftermarket, Wastewater
    APPLICATION         VARCHAR(200),      -- Desalination, Wastewater, CO2 Refrigeration
    LEAD_SOURCE         VARCHAR(100),
    COMPETITOR          VARCHAR(200),
    SALES_REP           VARCHAR(255),
    REGION              VARCHAR(100),
    CREATED_DATE        TIMESTAMP_NTZ,
    MODIFIED_DATE       TIMESTAMP_NTZ,
    CLOSED_DATE         TIMESTAMP_NTZ,
    LOSS_REASON         VARCHAR(500),
    NEXT_STEP           VARCHAR(500)
);

CREATE OR REPLACE TABLE ACTIVITIES (
    ACTIVITY_ID         VARCHAR(36) PRIMARY KEY,
    ACCOUNT_ID          VARCHAR(36) REFERENCES ACCOUNTS(ACCOUNT_ID),
    CONTACT_ID          VARCHAR(36),
    OPPORTUNITY_ID      VARCHAR(36),
    ACTIVITY_TYPE       VARCHAR(50),       -- Email, Call, Meeting, Demo, Site Visit
    SUBJECT             VARCHAR(500),
    DESCRIPTION         VARCHAR(4000),
    ACTIVITY_DATE       TIMESTAMP_NTZ,
    DURATION_MINUTES    NUMBER(10,0),
    STATUS              VARCHAR(50),       -- Completed, Scheduled, Cancelled
    OWNER_NAME          VARCHAR(255),
    CREATED_DATE        TIMESTAMP_NTZ
);

-- ============================================================================
-- DYNAMICS FINANCE TABLES (Microsoft Dynamics 365 Finance & Operations)
-- ============================================================================
USE SCHEMA DYNAMICS_FINANCE;

CREATE OR REPLACE TABLE GENERAL_LEDGER (
    JOURNAL_ENTRY_ID    VARCHAR(36) PRIMARY KEY,
    POSTING_DATE        DATE NOT NULL,
    FISCAL_YEAR         NUMBER(4,0),
    FISCAL_QUARTER      NUMBER(1,0),
    FISCAL_PERIOD       NUMBER(2,0),
    ACCOUNT_NUMBER      VARCHAR(50),
    ACCOUNT_NAME        VARCHAR(255),
    ACCOUNT_CATEGORY    VARCHAR(100),      -- Revenue, COGS, Operating Expense, Asset, Liability
    DEPARTMENT          VARCHAR(100),
    COST_CENTER         VARCHAR(50),
    DEBIT_AMOUNT        NUMBER(18,2) DEFAULT 0,
    CREDIT_AMOUNT       NUMBER(18,2) DEFAULT 0,
    NET_AMOUNT          NUMBER(18,2),
    CURRENCY            VARCHAR(3) DEFAULT 'USD',
    DESCRIPTION         VARCHAR(1000),
    SOURCE_SYSTEM       VARCHAR(50),
    CREATED_DATE        TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE SALES_ORDERS (
    ORDER_ID            VARCHAR(36) PRIMARY KEY,
    ORDER_NUMBER        VARCHAR(50) NOT NULL,
    CUSTOMER_ID         VARCHAR(36),
    CUSTOMER_NAME       VARCHAR(255),
    ORDER_DATE          DATE,
    REQUESTED_DATE      DATE,
    SHIP_DATE           DATE,
    STATUS              VARCHAR(50),       -- Open, Confirmed, Shipped, Invoiced, Cancelled
    PRODUCT_LINE        VARCHAR(100),      -- Desalination, Wastewater, Refrigeration, Aftermarket
    PRODUCT_NAME        VARCHAR(255),
    QUANTITY            NUMBER(10,0),
    UNIT_PRICE          NUMBER(18,2),
    TOTAL_AMOUNT        NUMBER(18,2),
    DISCOUNT_PERCENT    NUMBER(5,2) DEFAULT 0,
    REGION              VARCHAR(100),
    COUNTRY             VARCHAR(100),
    CURRENCY            VARCHAR(3) DEFAULT 'USD',
    SALES_REP           VARCHAR(255),
    CREATED_DATE        TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE INVOICES (
    INVOICE_ID          VARCHAR(36) PRIMARY KEY,
    INVOICE_NUMBER      VARCHAR(50) NOT NULL,
    ORDER_ID            VARCHAR(36),
    CUSTOMER_ID         VARCHAR(36),
    CUSTOMER_NAME       VARCHAR(255),
    INVOICE_DATE        DATE,
    DUE_DATE            DATE,
    PAYMENT_DATE        DATE,
    STATUS              VARCHAR(50),       -- Open, Paid, Overdue, Partially Paid
    SUBTOTAL            NUMBER(18,2),
    TAX_AMOUNT          NUMBER(18,2),
    TOTAL_AMOUNT        NUMBER(18,2),
    AMOUNT_PAID         NUMBER(18,2) DEFAULT 0,
    BALANCE_DUE         NUMBER(18,2),
    PRODUCT_LINE        VARCHAR(100),
    CURRENCY            VARCHAR(3) DEFAULT 'USD',
    PAYMENT_TERMS       VARCHAR(50),       -- Net 30, Net 60, Net 90
    CREATED_DATE        TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE ACCOUNTS_RECEIVABLE (
    AR_ID               VARCHAR(36) PRIMARY KEY,
    CUSTOMER_ID         VARCHAR(36),
    CUSTOMER_NAME       VARCHAR(255),
    INVOICE_ID          VARCHAR(36),
    INVOICE_DATE        DATE,
    DUE_DATE            DATE,
    ORIGINAL_AMOUNT     NUMBER(18,2),
    BALANCE             NUMBER(18,2),
    AGING_BUCKET        VARCHAR(50),       -- Current, 1-30 Days, 31-60 Days, 61-90 Days, 90+ Days
    STATUS              VARCHAR(50),
    REGION              VARCHAR(100),
    CURRENCY            VARCHAR(3) DEFAULT 'USD',
    AS_OF_DATE          DATE
);

CREATE OR REPLACE TABLE ACCOUNTS_PAYABLE (
    AP_ID               VARCHAR(36) PRIMARY KEY,
    SUPPLIER_ID         VARCHAR(36),
    SUPPLIER_NAME       VARCHAR(255),
    INVOICE_NUMBER      VARCHAR(50),
    INVOICE_DATE        DATE,
    DUE_DATE            DATE,
    PAYMENT_DATE        DATE,
    AMOUNT              NUMBER(18,2),
    BALANCE             NUMBER(18,2),
    STATUS              VARCHAR(50),       -- Open, Paid, Overdue
    CATEGORY            VARCHAR(100),      -- Raw Materials, Services, Equipment, Utilities
    CURRENCY            VARCHAR(3) DEFAULT 'USD',
    AS_OF_DATE          DATE
);

-- ============================================================================
-- SCADA / IoT TABLES (SCADA Systems & IoT Sensors)
-- ============================================================================
USE SCHEMA SCADA_IOT;

CREATE OR REPLACE TABLE DEVICE_REGISTRY (
    DEVICE_ID           VARCHAR(36) PRIMARY KEY,
    SERIAL_NUMBER       VARCHAR(50) NOT NULL,
    DEVICE_MODEL        VARCHAR(100),      -- PX-Q400, PX-Q650, PX-G1300, PX-220
    DEVICE_TYPE         VARCHAR(50),       -- Pressure Exchanger, Turbocharger, Pump
    PRODUCT_LINE        VARCHAR(100),      -- Desalination, Wastewater, Refrigeration
    INSTALLATION_SITE   VARCHAR(255),
    SITE_COUNTRY        VARCHAR(100),
    SITE_REGION         VARCHAR(100),
    CUSTOMER_ID         VARCHAR(36),
    CUSTOMER_NAME       VARCHAR(255),
    INSTALLATION_DATE   DATE,
    WARRANTY_EXPIRY     DATE,
    COMMISSIONING_DATE  DATE,
    OPERATING_HOURS     NUMBER(12,0) DEFAULT 0,
    STATUS              VARCHAR(50),       -- Active, Maintenance, Decommissioned, Standby
    FIRMWARE_VERSION    VARCHAR(50),
    LAST_SERVICE_DATE   DATE,
    NEXT_SERVICE_DATE   DATE,
    CREATED_DATE        TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE DEVICE_TELEMETRY (
    TELEMETRY_ID        VARCHAR(36) PRIMARY KEY,
    DEVICE_ID           VARCHAR(36) REFERENCES DEVICE_REGISTRY(DEVICE_ID),
    TIMESTAMP           TIMESTAMP_NTZ NOT NULL,
    READING_DATE        DATE,
    INLET_PRESSURE_BAR  NUMBER(8,2),
    OUTLET_PRESSURE_BAR NUMBER(8,2),
    PRESSURE_DIFFERENTIAL NUMBER(8,2),
    FLOW_RATE_M3H       NUMBER(8,2),
    ENERGY_RECOVERY_PCT NUMBER(5,2),
    VIBRATION_MM_S      NUMBER(8,3),
    TEMPERATURE_C       NUMBER(6,2),
    ROTOR_SPEED_RPM     NUMBER(8,0),
    POWER_CONSUMPTION_KW NUMBER(8,2),
    SALINITY_PPM        NUMBER(10,0),
    OPERATING_MODE      VARCHAR(50),       -- Normal, High Load, Low Load, Standby, Startup
    DATA_QUALITY        VARCHAR(20)        -- Good, Suspect, Bad
);

CREATE OR REPLACE TABLE ALARMS (
    ALARM_ID            VARCHAR(36) PRIMARY KEY,
    DEVICE_ID           VARCHAR(36) REFERENCES DEVICE_REGISTRY(DEVICE_ID),
    ALARM_TIMESTAMP     TIMESTAMP_NTZ NOT NULL,
    ALARM_CODE          VARCHAR(50),
    ALARM_SEVERITY      VARCHAR(20),       -- Critical, High, Medium, Low, Info
    ALARM_TYPE          VARCHAR(100),      -- Vibration, Pressure, Temperature, Flow, System
    DESCRIPTION         VARCHAR(1000),
    ACKNOWLEDGED        BOOLEAN DEFAULT FALSE,
    ACKNOWLEDGED_BY     VARCHAR(255),
    RESOLVED_TIMESTAMP  TIMESTAMP_NTZ,
    ROOT_CAUSE          VARCHAR(500),
    ACTION_TAKEN        VARCHAR(1000)
);

CREATE OR REPLACE TABLE MAINTENANCE_LOGS (
    MAINTENANCE_ID      VARCHAR(36) PRIMARY KEY,
    DEVICE_ID           VARCHAR(36) REFERENCES DEVICE_REGISTRY(DEVICE_ID),
    MAINTENANCE_TYPE    VARCHAR(50),       -- Preventive, Corrective, Predictive, Emergency
    WORK_ORDER_NUMBER   VARCHAR(50),
    START_DATE          TIMESTAMP_NTZ,
    END_DATE            TIMESTAMP_NTZ,
    DESCRIPTION         VARCHAR(2000),
    PARTS_REPLACED      VARCHAR(1000),
    LABOR_HOURS         NUMBER(6,2),
    PARTS_COST          NUMBER(12,2),
    LABOR_COST          NUMBER(12,2),
    TOTAL_COST          NUMBER(12,2),
    TECHNICIAN          VARCHAR(255),
    STATUS              VARCHAR(50),       -- Planned, In Progress, Completed, Cancelled
    DOWNTIME_HOURS      NUMBER(8,2),
    FAILURE_MODE        VARCHAR(200)
);

-- ============================================================================
-- ORACLE ERP TABLES (Manufacturing & Supply Chain)
-- ============================================================================
USE SCHEMA ORACLE_ERP;

CREATE OR REPLACE TABLE PRODUCTION_ORDERS (
    PRODUCTION_ORDER_ID VARCHAR(36) PRIMARY KEY,
    ORDER_NUMBER        VARCHAR(50) NOT NULL,
    PRODUCT_ID          VARCHAR(36),
    PRODUCT_NAME        VARCHAR(255),
    PRODUCT_MODEL       VARCHAR(100),      -- PX-Q400, PX-Q650, PX-G1300
    QUANTITY_ORDERED    NUMBER(10,0),
    QUANTITY_COMPLETED  NUMBER(10,0) DEFAULT 0,
    QUANTITY_SCRAPPED   NUMBER(10,0) DEFAULT 0,
    START_DATE          DATE,
    END_DATE            DATE,
    DUE_DATE            DATE,
    STATUS              VARCHAR(50),       -- Planned, Released, In Progress, Completed, Closed
    WORK_CENTER         VARCHAR(100),
    PRIORITY            VARCHAR(20),       -- High, Medium, Low
    YIELD_PERCENT       NUMBER(5,2),
    CYCLE_TIME_HOURS    NUMBER(8,2),
    SITE                VARCHAR(100),
    CREATED_DATE        TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE BILL_OF_MATERIALS (
    BOM_ID              VARCHAR(36) PRIMARY KEY,
    PRODUCT_ID          VARCHAR(36),
    PRODUCT_NAME        VARCHAR(255),
    PRODUCT_MODEL       VARCHAR(100),
    COMPONENT_ID        VARCHAR(36),
    COMPONENT_NAME      VARCHAR(255),
    COMPONENT_CATEGORY  VARCHAR(100),      -- Ceramic, Metal, Seal, Bearing, Electronic
    QUANTITY_PER_UNIT   NUMBER(8,3),
    UNIT_OF_MEASURE     VARCHAR(20),
    UNIT_COST           NUMBER(12,4),
    LEAD_TIME_DAYS      NUMBER(5,0),
    SUPPLIER_ID         VARCHAR(36),
    IS_CRITICAL         BOOLEAN DEFAULT FALSE,
    REVISION            VARCHAR(20),
    EFFECTIVE_DATE      DATE
);

CREATE OR REPLACE TABLE INVENTORY (
    INVENTORY_ID        VARCHAR(36) PRIMARY KEY,
    ITEM_ID             VARCHAR(36),
    ITEM_NAME           VARCHAR(255),
    ITEM_CATEGORY       VARCHAR(100),      -- Raw Material, WIP, Finished Good, Spare Part
    WAREHOUSE           VARCHAR(100),
    LOCATION            VARCHAR(50),
    QUANTITY_ON_HAND    NUMBER(12,0),
    QUANTITY_RESERVED   NUMBER(12,0) DEFAULT 0,
    QUANTITY_AVAILABLE  NUMBER(12,0),
    REORDER_POINT       NUMBER(12,0),
    REORDER_QUANTITY    NUMBER(12,0),
    UNIT_COST           NUMBER(12,4),
    TOTAL_VALUE         NUMBER(18,2),
    LAST_RECEIPT_DATE   DATE,
    LAST_ISSUE_DATE     DATE,
    AS_OF_DATE          DATE
);

CREATE OR REPLACE TABLE SUPPLIERS (
    SUPPLIER_ID         VARCHAR(36) PRIMARY KEY,
    SUPPLIER_NAME       VARCHAR(255) NOT NULL,
    SUPPLIER_TYPE       VARCHAR(100),      -- Raw Material, Component, Service, Logistics
    CATEGORY            VARCHAR(100),      -- Ceramics, Metals, Seals, Electronics, Packaging
    COUNTRY             VARCHAR(100),
    REGION              VARCHAR(100),
    LEAD_TIME_DAYS      NUMBER(5,0),
    ON_TIME_DELIVERY_PCT NUMBER(5,2),
    QUALITY_RATING      NUMBER(3,1),       -- 1.0 to 5.0
    PAYMENT_TERMS       VARCHAR(50),
    ANNUAL_SPEND        NUMBER(18,2),
    IS_CERTIFIED        BOOLEAN DEFAULT TRUE,
    CONTRACT_EXPIRY     DATE,
    CREATED_DATE        TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE PURCHASE_ORDERS (
    PO_ID               VARCHAR(36) PRIMARY KEY,
    PO_NUMBER           VARCHAR(50) NOT NULL,
    SUPPLIER_ID         VARCHAR(36) REFERENCES SUPPLIERS(SUPPLIER_ID),
    ITEM_ID             VARCHAR(36),
    ITEM_NAME           VARCHAR(255),
    QUANTITY_ORDERED    NUMBER(10,0),
    QUANTITY_RECEIVED   NUMBER(10,0) DEFAULT 0,
    UNIT_PRICE          NUMBER(12,4),
    TOTAL_AMOUNT        NUMBER(18,2),
    ORDER_DATE          DATE,
    EXPECTED_DATE       DATE,
    RECEIVED_DATE       DATE,
    STATUS              VARCHAR(50),       -- Draft, Approved, Sent, Partially Received, Received, Closed
    CATEGORY            VARCHAR(100),
    WAREHOUSE           VARCHAR(100),
    CREATED_DATE        TIMESTAMP_NTZ
);
