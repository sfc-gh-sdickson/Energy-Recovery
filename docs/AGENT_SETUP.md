<img src="Snowflake_Logo.svg" width="200">

# Agent Setup Guide — Kraken Intelligence Agent

Step-by-step guide to deploy the Kraken Intelligence Agent on Snowflake.

---

## Prerequisites

<html>
<table>
<tr><th>Requirement</th><th>Details</th></tr>
<tr><td>Snowflake Account</td><td>Enterprise Edition or higher with Cortex features enabled</td></tr>
<tr><td>Role</td><td>SYSADMIN (for database/warehouse creation) or equivalent</td></tr>
<tr><td>Cortex Agent</td><td>Snowflake Intelligence / Cortex Agent preview enabled</td></tr>
<tr><td>Cortex Search</td><td>Cortex Search Services enabled in your region</td></tr>
<tr><td>Warehouse</td><td>KRAKEN_WH (created in Step 1, X-Small is sufficient)</td></tr>
</table>
</html>

---

## Deployment Steps

### Step 1: Database and Schema Setup

```sql
-- File: sql/setup/01_database_and_schema.sql
-- Creates: KRAKEN_DB database, RAW/ANALYTICS/ML/ONTOLOGY/SEARCH schemas, KRAKEN_WH warehouse
```

Run this file first. It establishes the complete namespace for the project.

### Step 2: Create Operational Tables

```sql
-- File: sql/setup/02_create_tables.sql
-- Creates: 9 tables in RAW schema (CUSTOMERS, TRADES, ORDERS, WALLETS, etc.)
```

### Step 3: Load Blockchain Ontology

```sql
-- File: sql/setup/03_Blockchain_Ontology.sql
-- Creates: 8 tables in ONTOLOGY schema with ISO/TS 23258 data
-- Loads: 10 blockchains, 6 consensus mechanisms, 14 tokens, validators, smart contracts
```

### Step 4: Generate Synthetic Data

```sql
-- File: sql/data/04_generate_synthetic_data.sql
-- Generates: ~700K+ rows of realistic trading data
-- Runtime: ~2-5 minutes on X-Small warehouse
```

This step takes the longest. It generates:
- 10,000 customers with varied tiers, geographies, and KYC statuses
- 500,000 trade executions across 15 pairs
- 50,000 orders (open + historical)
- 30,000 wallet balances
- 25,000 support tickets with realistic text
- 15,000 compliance events
- 8,000 staking positions
- 50,000 market data OHLCV records
- 20,000 futures positions

### Step 5: Create Analytical Views

```sql
-- File: sql/views/05_create_views.sql
-- Creates: 7 views in ANALYTICS schema
```

These views pre-aggregate common analytical patterns used by the semantic views and agent.

### Step 6: Create Semantic Views

```sql
-- File: sql/views/06_create_semantic_views.sql
-- Creates: 3 semantic views (KRAKEN_TRADING_SV, KRAKEN_OPERATIONS_SV, DLT_BLOCKCHAIN_ONTOLOGY_SV)
```

Semantic views enable Cortex Analyst to translate natural language to SQL. They include:
- Column synonyms for flexible vocabulary
- Business-friendly comments for context
- Proper joins for multi-table queries

### Step 7: Create Cortex Search Services

```sql
-- File: sql/search/07_create_cortex_search.sql
-- Creates: 2 search services (SUPPORT_TICKET_SEARCH, COMPLIANCE_DOC_SEARCH)
-- Plus: 2 staging tables with combined searchable text
```

Search services provide semantic (vector) search over unstructured text content.

### Step 8: ML Model Training (Optional)

```
-- File: notebooks/08_ml_models.ipynb
-- This notebook is optional — the UDFs in Step 9 use SQL-based scoring
```

### Step 9: ML Prediction Functions

```sql
-- File: sql/models/09_ml_model_functions.sql
-- Creates: 6 SQL UDFs in ML schema
```

These UDFs implement scoring logic directly in SQL for real-time agent access.

### Step 10: Create the Agent

```sql
-- File: sql/agent/10_create_agent.sql
-- Creates: KRAKEN_AGENT with 11 tools (3 Analyst, 2 Search, 6 Functions)
```

---

## Verification

After deployment, verify the agent works:

```sql
-- Check tables exist
SELECT TABLE_SCHEMA, TABLE_NAME, ROW_COUNT 
FROM KRAKEN_DB.INFORMATION_SCHEMA.TABLES 
WHERE TABLE_CATALOG = 'KRAKEN_DB' 
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Test a semantic view
SELECT * FROM KRAKEN_DB.ANALYTICS.KRAKEN_TRADING_SV LIMIT 10;

-- Test a UDF
SELECT KRAKEN_DB.ML.AGENT_GET_FRAUD_ALERTS();

-- Verify agent exists
SHOW AGENTS IN SCHEMA KRAKEN_DB.RAW;
```

---

## Troubleshooting

<html>
<table>
<tr><th>Issue</th><th>Solution</th></tr>
<tr><td>Cortex Search fails to create</td><td>Verify your region supports Cortex Search. Check warehouse is not suspended.</td></tr>
<tr><td>Semantic view errors</td><td>Ensure tables have data (run Step 4 first). Check column names match.</td></tr>
<tr><td>Agent creation fails</td><td>Verify YAML syntax. Check all tool_resources reference valid objects.</td></tr>
<tr><td>UDF returns NULL</td><td>Ensure data exists in source tables. Check date filters are not too restrictive.</td></tr>
<tr><td>Slow data generation</td><td>Increase warehouse size to Small or Medium for Step 4.</td></tr>
</table>
</html>
