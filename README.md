<img src="Snowflake_Logo.svg" width="200">

# Kraken Intelligence Agent

A Snowflake Intelligence (CoWork) Agent for Kraken cryptocurrency exchange, enabling natural language access to trading data, compliance monitoring, support operations, and blockchain knowledge.

## Architecture

<img src="docs/images/architecture.svg" width="100%">

## Overview

This project implements a multi-persona AI agent powered by Snowflake Cortex that serves:

<html>
<table>
<tr><th>Persona</th><th>Use Cases</th><th>Primary Tools</th></tr>
<tr><td>Executive / PM</td><td>Revenue, trading volume, growth KPIs, market share</td><td>Cortex Analyst (Trading SV)</td></tr>
<tr><td>Compliance Officer</td><td>AML alerts, risk scores, regulatory filings, sanctions</td><td>Cortex Analyst (Ops SV) + ML Functions</td></tr>
<tr><td>Support Manager</td><td>Ticket volumes, SLAs, CSAT, team performance</td><td>Cortex Analyst (Ops SV) + Cortex Search</td></tr>
<tr><td>Trading Operations</td><td>Volume, liquidity, pairs, execution quality</td><td>Cortex Analyst (Trading SV) + ML Functions</td></tr>
</table>
</html>

## Agent Capabilities

The KRAKEN_AGENT leverages 11 tools:

<html>
<table>
<tr><th>Tool Type</th><th>Tool Name</th><th>Purpose</th></tr>
<tr><td>Cortex Analyst</td><td>KrakenTrading</td><td>Text-to-SQL for trades, orders, market data, revenue</td></tr>
<tr><td>Cortex Analyst</td><td>KrakenOperations</td><td>Text-to-SQL for support tickets, compliance events</td></tr>
<tr><td>Cortex Analyst</td><td>BlockchainOntology</td><td>Text-to-SQL for blockchain/DLT knowledge (ISO/TS 23258)</td></tr>
<tr><td>Cortex Search</td><td>TicketSearch</td><td>Semantic search over 25K+ support tickets</td></tr>
<tr><td>Cortex Search</td><td>ComplianceSearch</td><td>Semantic search over 15K+ compliance events</td></tr>
<tr><td>ML Function</td><td>FraudAlerts</td><td>Real-time fraud/AML anomaly detection</td></tr>
<tr><td>ML Function</td><td>ChurnRisk</td><td>Customer churn probability prediction</td></tr>
<tr><td>ML Function</td><td>VolumeForecast</td><td>7-day trading volume forecast per pair</td></tr>
<tr><td>ML Function</td><td>CustomerLTV</td><td>Lifetime value prediction and segmentation</td></tr>
<tr><td>ML Function</td><td>RiskScores</td><td>Open position risk grading (A-F)</td></tr>
<tr><td>ML Function</td><td>TicketClassifier</td><td>Support ticket auto-classification</td></tr>
</table>
</html>

## Data Model

<html>
<table>
<tr><th>Schema</th><th>Table</th><th>Records</th><th>Description</th></tr>
<tr><td>RAW</td><td>CUSTOMERS</td><td>10,000</td><td>Trader profiles with KYC, tier, geography</td></tr>
<tr><td>RAW</td><td>TRADES</td><td>500,000</td><td>Spot and margin trade executions</td></tr>
<tr><td>RAW</td><td>ORDERS</td><td>50,000</td><td>Open and historical order book</td></tr>
<tr><td>RAW</td><td>WALLETS</td><td>30,000</td><td>Multi-asset balance records</td></tr>
<tr><td>RAW</td><td>SUPPORT_TICKETS</td><td>25,000</td><td>Customer support interactions with text</td></tr>
<tr><td>RAW</td><td>COMPLIANCE_EVENTS</td><td>15,000</td><td>AML/KYC compliance monitoring events</td></tr>
<tr><td>RAW</td><td>STAKING_POSITIONS</td><td>8,000</td><td>Staking and earn positions</td></tr>
<tr><td>RAW</td><td>MARKET_DATA</td><td>50,000</td><td>OHLCV price data (hourly, 10 pairs)</td></tr>
<tr><td>RAW</td><td>FUTURES_POSITIONS</td><td>20,000</td><td>Derivatives/perpetual positions</td></tr>
<tr><td>ONTOLOGY</td><td>BLOCKCHAIN + 7 tables</td><td>~100</td><td>ISO/TS 23258 DLT Ontology (10 chains)</td></tr>
</table>
</html>

## Deployment Flow

<img src="docs/images/deployment_flow.svg" width="100%">

## Quick Start

```sql
-- Execute in order:
-- 1. sql/setup/01_database_and_schema.sql
-- 2. sql/setup/02_create_tables.sql
-- 3. sql/setup/03_Blockchain_Ontology.sql
-- 4. sql/data/04_generate_synthetic_data.sql
-- 5. sql/views/05_create_views.sql
-- 6. sql/views/06_create_semantic_views.sql
-- 7. sql/search/07_create_cortex_search.sql
-- 8. notebooks/08_ml_models.ipynb (optional)
-- 9. sql/models/09_ml_model_functions.sql
-- 10. sql/agent/10_create_agent.sql
```

## ML Pipeline

<img src="docs/images/ml_models.svg" width="100%">

## Query Tool Chain

<img src="docs/images/query_tool_chain.svg" width="100%">

## Technology Stack

- **Snowflake Cortex Agent** — Multi-tool orchestration with intelligent routing
- **Cortex Analyst** — Text-to-SQL via Semantic Views
- **Cortex Search** — Vector-based semantic search over unstructured data
- **Snowflake ML Functions** — SQL UDFs for real-time predictions
- **ISO/TS 23258 Ontology** — Standards-based blockchain knowledge graph

## Sample Questions

See [docs/questions.md](docs/questions.md) for 30+ test questions spanning all personas and tool paths.
