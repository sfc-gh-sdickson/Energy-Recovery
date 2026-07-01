-- =====================================================
-- Kraken Intelligence Agent
-- Step 1: Database, Schemas, and Warehouse Setup
-- =====================================================

USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS KRAKEN_DB;
USE DATABASE KRAKEN_DB;

-- Create schemas for logical separation
CREATE SCHEMA IF NOT EXISTS KRAKEN_DB.RAW
    COMMENT = 'Raw operational data from Kraken exchange systems';

CREATE SCHEMA IF NOT EXISTS KRAKEN_DB.ANALYTICS
    COMMENT = 'Analytical views and aggregated metrics';

CREATE SCHEMA IF NOT EXISTS KRAKEN_DB.ML
    COMMENT = 'Machine learning models, features, and predictions';

CREATE SCHEMA IF NOT EXISTS KRAKEN_DB.ONTOLOGY
    COMMENT = 'ISO/TS 23258 DLT/Blockchain ontology tables';

CREATE SCHEMA IF NOT EXISTS KRAKEN_DB.SEARCH
    COMMENT = 'Cortex Search service source tables and configurations';

-- Create warehouse
CREATE OR REPLACE WAREHOUSE KRAKEN_WH WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Kraken Intelligence Agent workloads';

USE WAREHOUSE KRAKEN_WH;
USE SCHEMA KRAKEN_DB.RAW;

SELECT 'Step 1 Complete: Database KRAKEN_DB, Schemas (RAW, ANALYTICS, ML, ONTOLOGY, SEARCH), and Warehouse KRAKEN_WH created successfully.' AS STATUS;
