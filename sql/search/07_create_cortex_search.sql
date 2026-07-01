-- =====================================================
-- Kraken Intelligence Agent
-- Step 7: Cortex Search Services
-- =====================================================

USE DATABASE KRAKEN_DB;
USE SCHEMA SEARCH;
USE WAREHOUSE KRAKEN_WH;

-- =====================================================
-- Prepare searchable content for Support Tickets
-- =====================================================
CREATE OR REPLACE TABLE SEARCH_SUPPORT_TICKETS AS
SELECT
    ST.TICKET_ID,
    ST.CUSTOMER_ID,
    ST.CATEGORY,
    ST.SUBCATEGORY,
    ST.PRIORITY,
    ST.STATUS,
    ST.ASSIGNED_TEAM,
    ST.PLATFORM,
    ST.SATISFACTION_SCORE,
    ST.CREATED_AT,
    -- Combine subject + description for full-text search
    ST.SUBJECT || ' ' || ST.DESCRIPTION || 
        COALESCE(' Resolution: ' || ST.RESOLUTION_NOTES, '') AS SEARCHABLE_TEXT
FROM KRAKEN_DB.RAW.SUPPORT_TICKETS ST;

-- =====================================================
-- Prepare searchable content for Compliance Documentation
-- =====================================================
CREATE OR REPLACE TABLE SEARCH_COMPLIANCE_DOCS AS
SELECT
    CE.EVENT_ID,
    CE.CUSTOMER_ID,
    CE.EVENT_TYPE,
    CE.RISK_LEVEL,
    CE.RISK_SCORE,
    CE.IS_FLAGGED,
    CE.REVIEW_STATUS,
    CE.JURISDICTION,
    CE.CREATED_AT,
    -- Searchable content
    CE.EVENT_TYPE || ': ' || CE.DESCRIPTION || 
        COALESCE(' Review: ' || CE.REVIEW_NOTES, '') AS SEARCHABLE_TEXT
FROM KRAKEN_DB.RAW.COMPLIANCE_EVENTS CE;

-- =====================================================
-- SUPPORT_TICKET_SEARCH - Search over support tickets
-- =====================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE SUPPORT_TICKET_SEARCH
  ON SEARCHABLE_TEXT
  ATTRIBUTES CATEGORY, PRIORITY, STATUS, ASSIGNED_TEAM, PLATFORM
  WAREHOUSE = KRAKEN_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Full-text semantic search over Kraken support tickets. Enables natural language queries to find tickets by issue description, resolution, category, and priority.'
AS
  SELECT
    TICKET_ID,
    CUSTOMER_ID,
    CATEGORY,
    SUBCATEGORY,
    PRIORITY,
    STATUS,
    ASSIGNED_TEAM,
    PLATFORM,
    SATISFACTION_SCORE,
    CREATED_AT,
    SEARCHABLE_TEXT
  FROM SEARCH_SUPPORT_TICKETS;

-- =====================================================
-- COMPLIANCE_DOC_SEARCH - Search over compliance events
-- =====================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE COMPLIANCE_DOC_SEARCH
  ON SEARCHABLE_TEXT
  ATTRIBUTES EVENT_TYPE, RISK_LEVEL, REVIEW_STATUS, JURISDICTION
  WAREHOUSE = KRAKEN_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Full-text semantic search over compliance events and AML documentation. Enables natural language queries to find compliance alerts, SARs, and regulatory filings.'
AS
  SELECT
    EVENT_ID,
    CUSTOMER_ID,
    EVENT_TYPE,
    RISK_LEVEL,
    RISK_SCORE,
    IS_FLAGGED,
    REVIEW_STATUS,
    JURISDICTION,
    CREATED_AT,
    SEARCHABLE_TEXT
  FROM SEARCH_COMPLIANCE_DOCS;

SELECT 'Step 7 Complete: Cortex Search services created (SUPPORT_TICKET_SEARCH, COMPLIANCE_DOC_SEARCH).' AS STATUS;
