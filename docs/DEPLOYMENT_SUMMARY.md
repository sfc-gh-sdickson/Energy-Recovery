<img src="Snowflake_Logo.svg" width="200">

# Energy Recovery - Deployment Summary

## Deployment Status

<html>
<table>
<tr><th>Component</th><th>Status</th><th>Object Name</th></tr>
<tr><td>Database</td><td>Ready</td><td>ENERGY_RECOVERY_DB</td></tr>
<tr><td>Warehouse</td><td>Ready</td><td>ENERGY_RECOVERY_WH (Medium)</td></tr>
<tr><td>Schemas (9)</td><td>Ready</td><td>RAW, DYNAMICS_CRM, DYNAMICS_FINANCE, SCADA_IOT, ORACLE_ERP, ONTOLOGY, ANALYTICS, ML_MODELS, AGENT</td></tr>
<tr><td>Tables (22)</td><td>Ready</td><td>See table inventory below</td></tr>
<tr><td>ISA-95 Ontology</td><td>Ready</td><td>8 tables with seed data</td></tr>
<tr><td>Synthetic Data</td><td>Ready</td><td>~107,000+ rows across all tables</td></tr>
<tr><td>Analytical Views (6)</td><td>Ready</td><td>V_FINANCIAL_SUMMARY, V_REVENUE_BY_PRODUCT, V_AR_AGING, V_SALES_PIPELINE, V_DEVICE_HEALTH, V_SUPPLY_CHAIN</td></tr>
<tr><td>Semantic Views (3)</td><td>Ready</td><td>SV_FINANCIAL_OPS, SV_CRM_PIPELINE, SV_IOT_PERFORMANCE</td></tr>
<tr><td>Cortex Search (1)</td><td>Ready</td><td>ENERGY_RECOVERY_KNOWLEDGE_SEARCH</td></tr>
<tr><td>ML Functions (4)</td><td>Ready</td><td>PREDICT_PX_FAILURE, SCORE_ENERGY_EFFICIENCY, FORECAST_DEMAND, CALCULATE_EQUIPMENT_HEALTH</td></tr>
<tr><td>Cortex Agent</td><td>Ready</td><td>ENERGY_RECOVERY_AGENT</td></tr>
</table>
</html>

## Architecture Diagram

![Architecture](images/architecture.svg)

## Deployment Flow

![Deployment Flow](images/deployment_flow.svg)

## Data Volume Summary

<html>
<table>
<tr><th>Schema</th><th>Table</th><th>Approximate Rows</th></tr>
<tr><td>DYNAMICS_CRM</td><td>ACCOUNTS</td><td>520</td></tr>
<tr><td>DYNAMICS_CRM</td><td>CONTACTS</td><td>1,500</td></tr>
<tr><td>DYNAMICS_CRM</td><td>OPPORTUNITIES</td><td>2,200</td></tr>
<tr><td>DYNAMICS_CRM</td><td>ACTIVITIES</td><td>0 (streaming ready)</td></tr>
<tr><td>DYNAMICS_FINANCE</td><td>GENERAL_LEDGER</td><td>5,000</td></tr>
<tr><td>DYNAMICS_FINANCE</td><td>SALES_ORDERS</td><td>850</td></tr>
<tr><td>DYNAMICS_FINANCE</td><td>INVOICES</td><td>700</td></tr>
<tr><td>DYNAMICS_FINANCE</td><td>ACCOUNTS_RECEIVABLE</td><td>~250</td></tr>
<tr><td>DYNAMICS_FINANCE</td><td>ACCOUNTS_PAYABLE</td><td>0 (streaming ready)</td></tr>
<tr><td>SCADA_IOT</td><td>DEVICE_REGISTRY</td><td>42,000</td></tr>
<tr><td>SCADA_IOT</td><td>DEVICE_TELEMETRY</td><td>50,000</td></tr>
<tr><td>SCADA_IOT</td><td>ALARMS</td><td>2,500</td></tr>
<tr><td>SCADA_IOT</td><td>MAINTENANCE_LOGS</td><td>3,200</td></tr>
<tr><td>ORACLE_ERP</td><td>PRODUCTION_ORDERS</td><td>1,200</td></tr>
<tr><td>ORACLE_ERP</td><td>INVENTORY</td><td>500</td></tr>
<tr><td>ORACLE_ERP</td><td>SUPPLIERS</td><td>120</td></tr>
<tr><td>ONTOLOGY</td><td>KNOWLEDGE_ARTICLES</td><td>10</td></tr>
</table>
</html>

## Agent Tool Configuration

<html>
<table>
<tr><th>Tool Name</th><th>Type</th><th>Target Object</th><th>Purpose</th></tr>
<tr><td>FinancialAnalyst</td><td>cortex_analyst_text_to_sql</td><td>SV_FINANCIAL_OPS</td><td>Revenue, orders, invoices, AR/AP, GL</td></tr>
<tr><td>PipelineAnalyst</td><td>cortex_analyst_text_to_sql</td><td>SV_CRM_PIPELINE</td><td>Opportunities, accounts, win rates</td></tr>
<tr><td>DeviceAnalyst</td><td>cortex_analyst_text_to_sql</td><td>SV_IOT_PERFORMANCE</td><td>Device telemetry, alarms, maintenance</td></tr>
<tr><td>KnowledgeSearch</td><td>cortex_search</td><td>ENERGY_RECOVERY_KNOWLEDGE_SEARCH</td><td>Product specs, procedures, ontology</td></tr>
<tr><td>PredictFailure</td><td>generic (function)</td><td>PREDICT_PX_FAILURE()</td><td>30-day failure risk prediction</td></tr>
<tr><td>ScoreEfficiency</td><td>generic (function)</td><td>SCORE_ENERGY_EFFICIENCY()</td><td>Efficiency gap analysis</td></tr>
<tr><td>ForecastDemand</td><td>generic (function)</td><td>FORECAST_DEMAND()</td><td>Quarterly demand forecast</td></tr>
<tr><td>EquipmentHealth</td><td>generic (function)</td><td>CALCULATE_EQUIPMENT_HEALTH()</td><td>Composite health scoring</td></tr>
</table>
</html>

## ML Models Pipeline

![ML Models](images/ml_models.svg)

## Query Tool Chain

![Query Tool Chain](images/query_tool_chain.svg)
