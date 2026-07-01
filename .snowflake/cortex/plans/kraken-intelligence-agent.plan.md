---
name: "kraken intelligence agent"
created: "2026-07-01T20:45:30.893Z"
status: pending
---

# Plan: Kraken Intelligence Agent

## Overview

Build a complete Snowflake Intelligence (CoWork) Agent for Kraken, the cryptocurrency exchange. The agent will serve multiple personas (Executive/PM, Compliance Officer, Support Manager) and leverage 6 ML models, the ISO/TS 23258 blockchain ontology, semantic views, and Cortex Search.

## Architecture Summary

The system follows a **streaming-first Scalable ELT** architecture:

- **Layer 1-2**: Physical tables (operational + blockchain ontology)
- **Layer 3**: Analytical views aggregating business KPIs
- **Layer 4**: Semantic views for natural language query (Cortex Analyst)
- **Layer 5**: Cortex Search for unstructured data (support tickets, compliance docs)
- **Layer 6**: ML models (Fraud/AML, Churn, Volume Forecast, LTV, Risk, Support Classification)
- **Layer 7**: Cortex Agent orchestrating all tools with multi-persona routing

## Data Model (Synthetic)

### Core Operational Tables (02\_create\_tables.sql)

| Table              | Purpose                | Key Columns                                                                     |
| ------------------ | ---------------------- | ------------------------------------------------------------------------------- |
| CUSTOMERS          | Trader profiles        | customer\_id, tier (VIP/Pro/Standard), kyc\_status, registration\_date, country |
| TRADES             | Spot/margin trades     | trade\_id, customer\_id, pair, side, price, quantity, fee, timestamp            |
| ORDERS             | Open/historical orders | order\_id, customer\_id, type (limit/market/stop), status, pair                 |
| WALLETS            | Asset balances         | wallet\_id, customer\_id, asset, balance, last\_updated                         |
| SUPPORT\_TICKETS   | Customer support       | ticket\_id, customer\_id, category, priority, status, description, resolution   |
| COMPLIANCE\_EVENTS | AML/KYC events         | event\_id, customer\_id, event\_type, risk\_score, flagged, details             |
| STAKING\_POSITIONS | Staking/earn           | position\_id, customer\_id, asset, amount, apy, start\_date                     |
| MARKET\_DATA       | OHLCV price data       | pair, timestamp, open, high, low, close, volume                                 |
| FUTURES\_POSITIONS | Derivatives            | position\_id, customer\_id, pair, side, leverage, entry\_price, pnl             |

### Blockchain Ontology Tables (03\_Blockchain\_Ontology.sql)

Adapted from the provided ISO/TS 23258 ontology:

- BLOCKCHAIN, DISTRIBUTED\_LEDGER, BLOCK, TRANSACTION, DLT\_NODE
- CONSENSUS\_MECHANISM, SMART\_CONTRACT, TOKEN, BLOCKCHAIN\_CONSENSUS

## ML Models (All 6)

| Model                         | Type               | Input                                              | Output                                            |
| ----------------------------- | ------------------ | -------------------------------------------------- | ------------------------------------------------- |
| Fraud/AML Detection           | Anomaly Detection  | Transaction patterns, velocity, amounts            | Risk score 0-100, flagged boolean                 |
| Customer Churn                | Classification     | Activity recency, trade frequency, support tickets | Churn probability 0-1                             |
| Trading Volume Forecast       | Time Series        | Historical daily volumes per pair                  | 7-day forward forecast                            |
| Customer LTV                  | Regression         | Trade history, fees paid, account age, tier        | Predicted lifetime value USD                      |
| Market Risk Scoring           | Scoring            | Position concentration, leverage, volatility       | Risk grade A-F                                    |
| Support Ticket Classification | NLP Classification | Ticket text                                        | Category (billing/trading/security/account/other) |

## Agent Tool Routing (Multi-Persona)

```
User Question → KRAKEN_AGENT
    ├─ Structured data questions → Cortex Analyst (Semantic View)
    │   "What was our trading volume last week?"
    │   "Top 10 customers by fees paid this month?"
    │   "Average resolution time for priority 1 tickets?"
    │
    ├─ Unstructured/search questions → Cortex Search
    │   "Find support tickets about withdrawal issues"
    │   "What compliance policies mention high-frequency trading?"
    │   "Search for tickets related to API key problems"
    │
    └─ Predictive/analytical questions → Custom Functions (UDFs)
        "Which customers are at risk of churning?"
        "What's the predicted BTC volume for next week?"
        "Flag any suspicious transactions in the last 24 hours"
```

## File Execution Order

1. `sql/setup/01_database_and_schema.sql` — Database, schemas, warehouse
2. `sql/setup/02_create_tables.sql` — All operational table DDL
3. `sql/setup/03_Blockchain_Ontology.sql` — Ontology tables + seed data
4. `sql/data/04_generate_synthetic_data.sql` — Synthetic data (10K+ rows per table)
5. `sql/views/05_create_views.sql` — Analytical views
6. `sql/views/06_create_semantic_views.sql` — Semantic views for Cortex Analyst
7. `sql/search/07_create_cortex_search.sql` — Cortex Search services
8. `notebooks/08_ml_models.ipynb` — ML model training
9. `sql/models/09_ml_model_functions.sql` — ML prediction UDFs
10. `sql/agent/10_create_agent.sql` — Agent with YAML specification

## SVG Diagrams Required

1. **architecture.svg** — Full system architecture showing data flow from sources → Snowflake → Agent → Users
2. **deployment\_flow\.svg** — Execution order diagram with dependencies
3. **ml\_models.svg** — ML pipeline: data → feature engineering → training → prediction → agent
4. **query\_tool\_chain.svg** — Example questions mapped to tool paths (Analyst vs Search vs Function)

## Key Technical Decisions

- **YAML agent specification** (not JSON) per verified syntax
- **RETURNS ARRAY/OBJECT** for UDFs (never VARIANT)
- **No LANGUAGE SQL** clause in SQL UDFs
- All documentation uses HTML tables and starts with `<img src="Snowflake_Logo.svg" width="200">`
- All graphics are SVG (never text-based diagrams)
- Semantic views use proper SYNONYMS and COMMENT annotations for NL2SQL accuracy

## Implementation Sequence

### Phase 1: Foundation (Tasks 1-2)

Create directory structure, documentation files, and SVG diagrams.

### Phase 2: Data Layer (Tasks 3-5)

Database setup, table creation, ontology integration, and synthetic data generation.

### Phase 3: Intelligence Layer (Tasks 6-7)

Analytical views, semantic views, Cortex Search, ML models, and prediction functions.

### Phase 4: Agent Layer (Task 8)

Agent creation with multi-tool YAML specification and verified syntax.
