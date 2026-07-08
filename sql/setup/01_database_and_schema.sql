/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 01_database_and_schema.sql
  Purpose: Create database, schemas, and warehouse for Energy Recovery
  Execution Order: 1 of 10
=============================================================================*/

-- ============================================================================
-- DATABASE
-- ============================================================================
CREATE DATABASE IF NOT EXISTS ENERGY_RECOVERY_DB;
USE DATABASE ENERGY_RECOVERY_DB;

-- ============================================================================
-- WAREHOUSE
-- ============================================================================
CREATE OR REPLACE WAREHOUSE ENERGY_RECOVERY_WH WITH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Energy Recovery Intelligence Agent';

USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- SCHEMAS - Organized by source system and function
-- ============================================================================

-- Raw ingestion landing zone
CREATE SCHEMA IF NOT EXISTS RAW
    COMMENT = 'Raw data landing zone for all source systems';

-- Microsoft Dynamics CRM source
CREATE SCHEMA IF NOT EXISTS DYNAMICS_CRM
    COMMENT = 'Microsoft Dynamics CRM data - Accounts, Contacts, Opportunities, Activities';

-- Microsoft Dynamics Finance & Operations source
CREATE SCHEMA IF NOT EXISTS DYNAMICS_FINANCE
    COMMENT = 'Microsoft Dynamics Finance & Operations - GL, AR, AP, Sales Orders, Invoices';

-- SCADA/IoT telemetry source
CREATE SCHEMA IF NOT EXISTS SCADA_IOT
    COMMENT = 'SCADA and IoT telemetry from 40,000+ installed PX devices worldwide';

-- Oracle ERP manufacturing source
CREATE SCHEMA IF NOT EXISTS ORACLE_ERP
    COMMENT = 'Oracle ERP manufacturing data - Production, BOM, Inventory, Suppliers';

-- ISA-95 aligned ontology
CREATE SCHEMA IF NOT EXISTS ONTOLOGY
    COMMENT = 'ISA-95 aligned ontology for manufacturing hierarchy and process segments';

-- Analytical views and transformations
CREATE SCHEMA IF NOT EXISTS ANALYTICS
    COMMENT = 'Transformed analytical views for cross-domain analysis';

-- ML models and prediction functions
CREATE SCHEMA IF NOT EXISTS ML_MODELS
    COMMENT = 'Machine learning prediction functions and scoring models';

-- Agent-related objects (semantic views, search, agent)
CREATE SCHEMA IF NOT EXISTS AGENT
    COMMENT = 'Cortex Agent objects - Semantic Views, Search Services, Agent definition';
