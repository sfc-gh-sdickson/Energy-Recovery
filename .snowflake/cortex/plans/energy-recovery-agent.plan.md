---
name: "energy recovery agent"
created: "2026-07-08T04:46:16.489Z"
status: pending
---

# Plan: Energy Recovery Snowflake Intelligence Agent

## Overview

Build a complete Snowflake Intelligence architecture for Energy Recovery, Inc. — a manufacturer of PX Pressure Exchanger devices for desalination, wastewater treatment, and CO2 refrigeration. The agent will enable natural language queries across Financial Operations (from Microsoft Dynamics), CRM data (Dynamics CRM), and IoT/SCADA telemetry from 40,000+ installed PX devices.

## Architecture

The system follows a streaming-first Scalable ELT Pipeline pattern:

- **Source Systems**: Microsoft Dynamics (Finance + CRM), SCADA/IoT (device telemetry), Oracle ERP (manufacturing/supply chain)
- **Landing**: RAW schema with source-system-specific schemas
- **Transformation**: ANALYTICS schema with cross-domain views
- **Intelligence**: Semantic Views → Cortex Analyst, Cortex Search, ML UDFs → Cortex Agent
- **Ontology**: ISA-95-aligned hierarchy (Enterprise → Site → Area → Work Center → Work Unit)

## Database Schema Design

```
ENERGY_RECOVERY_DB
├── RAW                    # Raw ingestion landing zone
├── DYNAMICS_CRM           # Microsoft Dynamics CRM data
│   ├── ACCOUNTS
│   ├── CONTACTS
│   ├── OPPORTUNITIES
│   └── ACTIVITIES
├── DYNAMICS_FINANCE       # Microsoft Dynamics Finance & Operations
│   ├── GENERAL_LEDGER
│   ├── ACCOUNTS_RECEIVABLE
│   ├── ACCOUNTS_PAYABLE
│   ├── SALES_ORDERS
│   └── INVOICES
├── SCADA_IOT              # SCADA/IoT device telemetry
│   ├── DEVICE_REGISTRY
│   ├── DEVICE_TELEMETRY
│   ├── ALARMS
│   └── MAINTENANCE_LOGS
├── ORACLE_ERP             # Oracle ERP manufacturing data
│   ├── PRODUCTION_ORDERS
│   ├── BILL_OF_MATERIALS
│   ├── INVENTORY
│   ├── SUPPLIERS
│   └── PURCHASE_ORDERS
├── ONTOLOGY               # ISA-95 Ontology
│   ├── ENTERPRISE
│   ├── SITE
│   ├── AREA
│   ├── WORK_CENTER
│   ├── WORK_UNIT
│   ├── MATERIAL_CLASS
│   ├── EQUIPMENT_CLASS
│   └── PROCESS_SEGMENT
├── ANALYTICS              # Transformed analytical views
│   ├── V_FINANCIAL_SUMMARY
│   ├── V_SALES_PIPELINE
│   ├── V_DEVICE_HEALTH
│   ├── V_PRODUCTION_EFFICIENCY
│   └── V_SUPPLY_CHAIN
├── ML_MODELS              # ML prediction functions
│   ├── PREDICT_PX_FAILURE()
│   ├── SCORE_ENERGY_EFFICIENCY()
│   ├── FORECAST_DEMAND()
│   └── CALCULATE_EQUIPMENT_HEALTH()
└── AGENT                  # Agent-related objects
    ├── SV_FINANCIAL_OPS (Semantic View)
    ├── SV_CRM_PIPELINE (Semantic View)
    ├── SV_IOT_PERFORMANCE (Semantic View)
    ├── KNOWLEDGE_SEARCH (Cortex Search)
    └── ENERGY_RECOVERY_AGENT (Agent)
```

## ISA-95 Ontology Design

The ontology maps Energy Recovery's manufacturing hierarchy:

| Level | ISA-95      | Energy Recovery Mapping                           |
| ----- | ----------- | ------------------------------------------------- |
| 0     | Enterprise  | Energy Recovery, Inc.                             |
| 1     | Site        | San Leandro HQ, International Sites               |
| 2     | Area        | PX Manufacturing, Assembly, Testing, Packaging    |
| 3     | Work Center | CNC Machining, Ceramic Processing, Rotor Assembly |
| 4     | Work Unit   | Individual machines/stations                      |

Material classes: Ceramic rotors, End covers, Sleeves, Bearings, Seals Equipment classes: CNC machines, Kilns, Assembly robots, Test benches Process segments: Raw material prep → Ceramic forming → Sintering → Machining → Assembly → Testing → Packaging

## Semantic Views (3 views for Cortex Analyst)

### 1. SV\_FINANCIAL\_OPS

- **Tables**: GENERAL\_LEDGER, SALES\_ORDERS, INVOICES, AR, AP
- **Metrics**: Total revenue, Gross margin, AR aging, AP turnover, Revenue by product line, Revenue by region
- **Dimensions**: Fiscal period, Product line, Region, Customer segment, Cost center

### 2. SV\_CRM\_PIPELINE

- **Tables**: ACCOUNTS, CONTACTS, OPPORTUNITIES, ACTIVITIES
- **Metrics**: Pipeline value, Win rate, Average deal size, Sales cycle length, Conversion rates
- **Dimensions**: Stage, Region, Industry, Account tier, Sales rep, Product interest

### 3. SV\_IOT\_PERFORMANCE

- **Tables**: DEVICE\_REGISTRY, DEVICE\_TELEMETRY, ALARMS, MAINTENANCE\_LOGS
- **Metrics**: Avg energy recovery %, Uptime %, Mean time between failures, Alarm frequency
- **Dimensions**: Device model, Installation site, Region, Operating mode, Date

## ML Models (4 UDF functions)

1. **PREDICT\_PX\_FAILURE()** — Analyzes vibration, pressure differential, flow rate, and temperature patterns to predict device failures within 30 days
2. **SCORE\_ENERGY\_EFFICIENCY()** — Scores each PX device's energy recovery efficiency (0-100) based on current operating parameters vs. design specs
3. **FORECAST\_DEMAND()** — Forecasts PX device and aftermarket parts demand by region/quarter using historical orders and backlog
4. **CALCULATE\_EQUIPMENT\_HEALTH()** — Composite health score combining sensor inputs, maintenance history, operating hours, and alarm patterns

## Cortex Search Service

**ENERGY\_RECOVERY\_KNOWLEDGE\_SEARCH** — Searches across:

- Product documentation (PX Q400, Q650, G1300 specs)
- Installation guides and best practices
- Maintenance procedures and troubleshooting
- ISA-95 ontology descriptions
- Company policies and procedures

## Agent Configuration

The agent (`ENERGY_RECOVERY_AGENT`) will have:

- **3 Cortex Analyst tools** (one per semantic view) for text-to-SQL
- **1 Cortex Search tool** for knowledge retrieval
- **4 Generic function tools** for ML predictions
- **Orchestration instructions** that route financial questions to Financial Ops, CRM questions to Pipeline, device/IoT questions to IoT Performance, and general knowledge to Search

## File Execution Order

1. `sql/setup/01_database_and_schema.sql` — Database, schemas, warehouse
2. `sql/setup/02_create_tables.sql` — All table DDL by source system
3. `sql/setup/03_ISA_95_Ontology.sql` — Ontology tables + seed data
4. `sql/data/04_generate_synthetic_data.sql` — Synthetic data generation
5. `sql/views/05_create_views.sql` — Analytical views
6. `sql/views/06_create_semantic_views.sql` — 3 Semantic views
7. `sql/search/07_create_cortex_search.sql` — Cortex Search service
8. `notebooks/08_ml_models.ipynb` — ML model training notebook
9. `sql/models/09_ml_model_functions.sql` — ML UDF functions
10. `sql/agent/10_create_agent.sql` — Agent creation

## SVG Diagrams Required

1. **architecture.svg** — End-to-end system architecture showing source systems → Snowflake schemas → semantic views → agent
2. **deployment\_flow\.svg** — SQL execution order with dependencies
3. **ml\_models.svg** — ML pipeline showing feature engineering → model training → UDF deployment
4. **query\_tool\_chain.svg** — Example questions mapped to tool routing paths (showing when ontology is used)

## Test Questions (30+ across all domains)

### Financial Operations (10)

- What was our total revenue for Q1 2026?
- How does gross margin compare across product lines?
- What is our current AR aging breakdown?
- Show me month-over-month revenue trends for desalination products
- What are our top 10 customers by revenue?
- (+ 5 more covering AP, cost analysis, backlog, guidance tracking)

### CRM / Sales Pipeline (10)

- What is our current pipeline value by stage?
- Which opportunities are expected to close this quarter?
- What is our win rate by region?
- Show me the sales cycle length trend over the past year
- Who are our top prospects in the MENA region?
- (+ 5 more covering activities, contacts, competitive deals)

### IoT / Device Performance (10)

- Which PX devices are at risk of failure in the next 30 days?
- What is the average energy recovery efficiency across our installed base?
- Show me alarm frequency trends for the MENA region
- Which sites have the highest uptime?
- What is the equipment health score distribution?
- (+ 5 more covering maintenance, telemetry anomalies, efficiency optimization)

### Cross-Domain & Knowledge (5+)

- How does our sales pipeline correlate with installed base growth?
- What maintenance procedures apply to PX Q650 devices?
- How does our ISA-95 hierarchy map to production capacity?
- What is the relationship between device performance and customer satisfaction?
- Which product lines are growing fastest and why?

## Key Implementation Decisions

1. **Synthetic data approach**: Model realistic source system schemas with proper foreign keys and referential integrity
2. **ISA-95 ontology**: Full 5-level hierarchy with material, equipment, and process segment classifications
3. **Semantic views use DDL syntax** (not YAML) per Snowflake best practices for SQL-first deployments
4. **Agent uses YAML specification** format (not JSON) per verified working syntax
5. **ML UDFs return ARRAY or OBJECT** (never VARIANT) per lessons learned
6. **All SVG diagrams** are proper vector graphics (no text-based ASCII art)
7. **Documentation uses HTML tables** per requirements
