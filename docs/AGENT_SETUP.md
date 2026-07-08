<img src="Snowflake_Logo.svg" width="200">

# Energy Recovery - Agent Setup Guide

## Prerequisites

<html>
<table>
<tr><th>Requirement</th><th>Details</th></tr>
<tr><td>Snowflake Account</td><td>Enterprise edition or higher with Cortex AI enabled</td></tr>
<tr><td>Role</td><td>ACCOUNTADMIN or custom role with CREATE DATABASE, CREATE WAREHOUSE, CREATE AGENT</td></tr>
<tr><td>Warehouse</td><td>MEDIUM size recommended for data generation</td></tr>
<tr><td>Region</td><td>AWS US-West-2 or US-East-1 (Cortex AI availability)</td></tr>
</table>
</html>

## Step-by-Step Setup

### Step 1: Create Database and Schemas

Execute `sql/setup/01_database_and_schema.sql`

This creates:
- `ENERGY_RECOVERY_DB` database
- `ENERGY_RECOVERY_WH` warehouse (Medium, auto-suspend 5 min)
- 9 schemas: RAW, DYNAMICS_CRM, DYNAMICS_FINANCE, SCADA_IOT, ORACLE_ERP, ONTOLOGY, ANALYTICS, ML_MODELS, AGENT

### Step 2: Create Tables

Execute `sql/setup/02_create_tables.sql`

Creates all table definitions organized by source system:
- **DYNAMICS_CRM**: ACCOUNTS, CONTACTS, OPPORTUNITIES, ACTIVITIES
- **DYNAMICS_FINANCE**: GENERAL_LEDGER, SALES_ORDERS, INVOICES, ACCOUNTS_RECEIVABLE, ACCOUNTS_PAYABLE
- **SCADA_IOT**: DEVICE_REGISTRY, DEVICE_TELEMETRY, ALARMS, MAINTENANCE_LOGS
- **ORACLE_ERP**: PRODUCTION_ORDERS, BILL_OF_MATERIALS, INVENTORY, SUPPLIERS, PURCHASE_ORDERS

### Step 3: Load ISA-95 Ontology

Execute `sql/setup/03_ISA_95_Ontology.sql`

Creates and populates:
- Physical hierarchy: ENTERPRISE → SITE → AREA → WORK_CENTER → WORK_UNIT
- Material model: MATERIAL_CLASS, MATERIAL_DEFINITION
- Equipment model: EQUIPMENT_CLASS
- Personnel model: PERSONNEL_CLASS
- Process segments: 12-step PX manufacturing flow
- Knowledge articles: 10 base articles for Cortex Search

### Step 4: Generate Synthetic Data

Execute `sql/data/04_generate_synthetic_data.sql`

Generates realistic data volumes:

<html>
<table>
<tr><th>Table</th><th>Row Count</th><th>Notes</th></tr>
<tr><td>ACCOUNTS</td><td>520+</td><td>Real desalination company names</td></tr>
<tr><td>CONTACTS</td><td>1,500+</td><td>International names and roles</td></tr>
<tr><td>OPPORTUNITIES</td><td>2,200+</td><td>All pipeline stages</td></tr>
<tr><td>GENERAL_LEDGER</td><td>5,000+</td><td>2 years of financial data</td></tr>
<tr><td>SALES_ORDERS</td><td>850+</td><td>All product lines</td></tr>
<tr><td>INVOICES</td><td>700+</td><td>Various payment statuses</td></tr>
<tr><td>DEVICE_REGISTRY</td><td>42,000+</td><td>Global installed base</td></tr>
<tr><td>DEVICE_TELEMETRY</td><td>50,000+</td><td>Recent sensor readings</td></tr>
<tr><td>ALARMS</td><td>2,500+</td><td>Various severity levels</td></tr>
<tr><td>MAINTENANCE_LOGS</td><td>3,200+</td><td>All maintenance types</td></tr>
<tr><td>PRODUCTION_ORDERS</td><td>1,200+</td><td>All product models</td></tr>
<tr><td>INVENTORY</td><td>500+</td><td>Raw materials to finished goods</td></tr>
<tr><td>SUPPLIERS</td><td>120+</td><td>Global supplier network</td></tr>
</table>
</html>

### Step 5: Create Analytical Views

Execute `sql/views/05_create_views.sql`

Creates cross-domain analytical views in the ANALYTICS schema.

### Step 6: Create Semantic Views

Execute `sql/views/06_create_semantic_views.sql`

Creates 3 semantic views in the AGENT schema:
1. **SV_FINANCIAL_OPS** — Revenue, orders, invoices, AR, GL
2. **SV_CRM_PIPELINE** — Opportunities, accounts, activities
3. **SV_IOT_PERFORMANCE** — Devices, telemetry, alarms, maintenance

### Step 7: Create Cortex Search

Execute `sql/search/07_create_cortex_search.sql`

Creates `ENERGY_RECOVERY_KNOWLEDGE_SEARCH` service indexing knowledge articles.

### Step 8: ML Models (Optional)

Run `notebooks/08_ml_models.ipynb` if you want to train actual ML models. The UDFs in Step 9 use rule-based scoring that works without this step.

### Step 9: Create ML Functions

Execute `sql/models/09_ml_model_functions.sql`

Creates 4 UDF functions:
1. `PREDICT_PX_FAILURE()` — Devices at risk of failure
2. `SCORE_ENERGY_EFFICIENCY()` — Efficiency gap analysis
3. `FORECAST_DEMAND()` — Next quarter demand forecast
4. `CALCULATE_EQUIPMENT_HEALTH()` — Composite health scores

### Step 10: Create Agent

Execute `sql/agent/10_create_agent.sql`

Creates `ENERGY_RECOVERY_AGENT` with 8 tools:
- 3 Cortex Analyst tools (text-to-SQL)
- 1 Cortex Search tool (knowledge retrieval)
- 4 Generic function tools (ML predictions)

## Verification

After setup, verify the agent works:

```sql
-- Check agent exists
SHOW AGENTS IN SCHEMA ENERGY_RECOVERY_DB.AGENT;

-- Describe agent configuration
DESCRIBE AGENT ENERGY_RECOVERY_DB.AGENT.ENERGY_RECOVERY_AGENT;

-- Test the agent
SELECT SNOWFLAKE.CORTEX.DATA_AGENT_RUN(
    'ENERGY_RECOVERY_DB.AGENT.ENERGY_RECOVERY_AGENT',
    'What was our total revenue last quarter?'
);
```

## Troubleshooting

<html>
<table>
<tr><th>Issue</th><th>Solution</th></tr>
<tr><td>Agent creation fails</td><td>Verify Cortex Agent is enabled for your account region</td></tr>
<tr><td>Semantic view errors</td><td>Ensure tables have data before creating semantic views</td></tr>
<tr><td>Search returns no results</td><td>Wait for TARGET_LAG (1 hour) for search index to build</td></tr>
<tr><td>ML functions return NULL</td><td>Verify telemetry data exists in DEVICE_TELEMETRY table</td></tr>
</table>
</html>
