<img src="Snowflake_Logo.svg" width="200">

# Energy Recovery - Snowflake Intelligence Agent

## Overview

A complete Snowflake Intelligence architecture for **Energy Recovery, Inc.** (NASDAQ: ERII) — a global leader in energy recovery devices for industrial fluid flow applications. This agent enables natural language queries across Financial Operations, CRM/Sales Pipeline, IoT Device Performance, and Manufacturing data using Snowflake Cortex AI.

<html>
<table>
<tr><th>Component</th><th>Description</th></tr>
<tr><td>Database</td><td>ENERGY_RECOVERY_DB</td></tr>
<tr><td>Warehouse</td><td>ENERGY_RECOVERY_WH (Medium)</td></tr>
<tr><td>Agent</td><td>ENERGY_RECOVERY_AGENT</td></tr>
<tr><td>Semantic Views</td><td>3 (Financial, CRM, IoT)</td></tr>
<tr><td>Cortex Search</td><td>1 (Knowledge Base)</td></tr>
<tr><td>ML Functions</td><td>4 (Failure, Efficiency, Demand, Health)</td></tr>
<tr><td>Source Systems</td><td>Microsoft Dynamics, SCADA/IoT, Oracle ERP</td></tr>
</table>
</html>

## Architecture

![System Architecture](docs/images/architecture.svg)

## Company Context

Energy Recovery designs and manufactures PX Pressure Exchanger devices that recover up to 98% of otherwise wasted pressure energy in reverse osmosis desalination plants. Key facts:

- **Founded**: 1992, San Leandro, California
- **Revenue**: ~$135M (FY2025), Guidance $135M-$145M (FY2026)
- **Market Cap**: ~$1.15B
- **Employees**: ~230
- **Installed Base**: 42,000+ PX devices globally
- **Products**: PX Q650, PX Q400, PX G1300 (CO2 Refrigeration), Aftermarket Services

## Project Structure

```
/
├── README.md                           # This file
├── docs/
│   ├── AGENT_SETUP.md                 # Step-by-step agent configuration guide
│   ├── DEPLOYMENT_SUMMARY.md          # Current deployment status
│   ├── questions.md                   # 30+ complex test questions
│   └── images/
│       ├── architecture.svg           # System architecture diagram
│       ├── deployment_flow.svg        # Deployment workflow diagram
│       ├── ml_models.svg              # ML pipeline visualization
│       └── query_tool_chain.svg       # Query routing examples
├── notebooks/
│   └── 08_ml_models.ipynb             # ML model training notebook
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql # Database, schemas, warehouse
    │   ├── 02_create_tables.sql       # All table definitions
    │   └── 03_ISA_95_Ontology.sql     # ISA-95 Ontology tables and data
    ├── data/
    │   └── 04_generate_synthetic_data.sql # Synthetic data generation
    ├── views/
    │   ├── 05_create_views.sql        # Analytical views
    │   └── 06_create_semantic_views.sql # Semantic views for Cortex Analyst
    ├── search/
    │   └── 07_create_cortex_search.sql # Cortex Search services
    ├── models/
    │   └── 09_ml_model_functions.sql  # ML prediction UDFs
    └── agent/
        └── 10_create_agent.sql        # Agent creation script
```

## Quick Start

```sql
-- Execute files in order:
-- 1. sql/setup/01_database_and_schema.sql
-- 2. sql/setup/02_create_tables.sql
-- 3. sql/setup/03_ISA_95_Ontology.sql
-- 4. sql/data/04_generate_synthetic_data.sql
-- 5. sql/views/05_create_views.sql
-- 6. sql/views/06_create_semantic_views.sql
-- 7. sql/search/07_create_cortex_search.sql
-- 8. notebooks/08_ml_models.ipynb (optional)
-- 9. sql/models/09_ml_model_functions.sql
-- 10. sql/agent/10_create_agent.sql
```

## Data Sources

<html>
<table>
<tr><th>Source System</th><th>Schema</th><th>Data Domain</th><th>Key Tables</th></tr>
<tr><td>Microsoft Dynamics CRM</td><td>DYNAMICS_CRM</td><td>Sales & Accounts</td><td>ACCOUNTS, CONTACTS, OPPORTUNITIES, ACTIVITIES</td></tr>
<tr><td>Microsoft Dynamics F&O</td><td>DYNAMICS_FINANCE</td><td>Financial Operations</td><td>GENERAL_LEDGER, SALES_ORDERS, INVOICES, AR, AP</td></tr>
<tr><td>SCADA / IoT Systems</td><td>SCADA_IOT</td><td>Device Telemetry</td><td>DEVICE_REGISTRY, DEVICE_TELEMETRY, ALARMS, MAINTENANCE_LOGS</td></tr>
<tr><td>Oracle ERP</td><td>ORACLE_ERP</td><td>Manufacturing</td><td>PRODUCTION_ORDERS, BOM, INVENTORY, SUPPLIERS, PO</td></tr>
</table>
</html>

## ISA-95 Ontology

The manufacturing data model follows the ISA-95 (IEC 62264) standard:

<html>
<table>
<tr><th>Level</th><th>ISA-95 Entity</th><th>Energy Recovery Mapping</th></tr>
<tr><td>0</td><td>Enterprise</td><td>Energy Recovery, Inc.</td></tr>
<tr><td>1</td><td>Site</td><td>San Leandro HQ, Dubai, Shanghai, Madrid</td></tr>
<tr><td>2</td><td>Area</td><td>Ceramic Manufacturing, CNC Machining, Assembly, Testing, Packaging</td></tr>
<tr><td>3</td><td>Work Center</td><td>Ceramic Forming, Sintering, CNC Turning, Final Assembly, etc.</td></tr>
<tr><td>4</td><td>Work Unit</td><td>Individual machines (Kilns, CNC Lathes, Test Benches)</td></tr>
</table>
</html>

## Agent Capabilities

The Energy Recovery Agent answers questions across these domains:

1. **Financial Operations** — Revenue, margins, orders, invoices, AR/AP aging, cost analysis
2. **CRM / Sales Pipeline** — Pipeline value, win rates, deal stages, account analysis
3. **IoT / Device Performance** — Telemetry, efficiency, alarms, maintenance, uptime
4. **Knowledge Base** — Product specs, maintenance procedures, ISA-95 ontology
5. **ML Predictions** — Failure prediction, efficiency scoring, demand forecast, health scores

## Requirements

- Snowflake account with Cortex AI features enabled
- ACCOUNTADMIN or role with CREATE DATABASE, CREATE WAREHOUSE privileges
- Cortex Agent, Cortex Analyst, and Cortex Search services enabled
