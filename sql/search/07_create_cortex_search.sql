/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 07_create_cortex_search.sql
  Purpose: Create Cortex Search service for knowledge retrieval
  Execution Order: 7 of 10
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE SCHEMA AGENT;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- CORTEX SEARCH SERVICE: Knowledge Base
-- Searches product docs, maintenance procedures, ISA-95 ontology, and policies
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE ENERGY_RECOVERY_KNOWLEDGE_SEARCH
  ON CONTENT
  ATTRIBUTES TITLE, CATEGORY, SUBCATEGORY, PRODUCT_MODEL, KEYWORDS
  WAREHOUSE = ENERGY_RECOVERY_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Searches Energy Recovery knowledge base: product specs, maintenance procedures, process documentation, and ISA-95 ontology descriptions'
AS
  SELECT
    ARTICLE_ID,
    TITLE,
    CATEGORY,
    SUBCATEGORY,
    CONTENT,
    PRODUCT_MODEL,
    APPLICABLE_AREA,
    KEYWORDS,
    AUTHOR,
    PUBLISH_DATE
  FROM ENERGY_RECOVERY_DB.ONTOLOGY.KNOWLEDGE_ARTICLES;
