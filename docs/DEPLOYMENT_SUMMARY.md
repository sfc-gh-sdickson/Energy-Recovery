<img src="Snowflake_Logo.svg" width="200">

# Deployment Summary — Kraken Intelligence Agent

---

## Project Status: DEPLOYING

<html>
<table>
<tr><th>Component</th><th>Status</th><th>Objects Created</th></tr>
<tr><td>Database and Schemas</td><td>Pending</td><td>1 database, 5 schemas, 1 warehouse</td></tr>
<tr><td>Operational Tables</td><td>Pending</td><td>9 tables in RAW schema</td></tr>
<tr><td>Blockchain Ontology</td><td>Pending</td><td>8 tables in ONTOLOGY schema + seed data</td></tr>
<tr><td>Synthetic Data</td><td>Pending</td><td>~700K rows across all tables</td></tr>
<tr><td>Analytical Views</td><td>Pending</td><td>7 views in ANALYTICS schema</td></tr>
<tr><td>Semantic Views</td><td>Pending</td><td>3 semantic views</td></tr>
<tr><td>Cortex Search</td><td>Pending</td><td>2 search services + 2 staging tables</td></tr>
<tr><td>ML Functions</td><td>Pending</td><td>6 UDFs in ML schema</td></tr>
<tr><td>Agent</td><td>Pending</td><td>KRAKEN_AGENT (11 tools)</td></tr>
</table>
</html>

---

## Connection Details

<html>
<table>
<tr><th>Parameter</th><th>Value</th></tr>
<tr><td>Account</td><td>AWS161</td></tr>
<tr><td>Database</td><td>KRAKEN_DB</td></tr>
<tr><td>Warehouse</td><td>KRAKEN_WH</td></tr>
<tr><td>Agent</td><td>KRAKEN_DB.RAW.KRAKEN_AGENT</td></tr>
<tr><td>Schemas</td><td>RAW, ANALYTICS, ML, ONTOLOGY, SEARCH</td></tr>
</table>
</html>

---

## Data Summary

<html>
<table>
<tr><th>Table</th><th>Row Count</th><th>Key Attributes</th></tr>
<tr><td>CUSTOMERS</td><td>10,000</td><td>4 tiers, 20 countries, KYC levels 1-4</td></tr>
<tr><td>TRADES</td><td>500,000</td><td>15 pairs, spot/margin, 4 platforms</td></tr>
<tr><td>ORDERS</td><td>50,000</td><td>5 order types, 5 statuses</td></tr>
<tr><td>WALLETS</td><td>30,000</td><td>10 assets, balance tracking</td></tr>
<tr><td>SUPPORT_TICKETS</td><td>25,000</td><td>10 categories, full text descriptions</td></tr>
<tr><td>COMPLIANCE_EVENTS</td><td>15,000</td><td>7 event types, 4 risk levels</td></tr>
<tr><td>STAKING_POSITIONS</td><td>8,000</td><td>7 assets, flexible + locked</td></tr>
<tr><td>MARKET_DATA</td><td>50,000</td><td>10 pairs, hourly OHLCV</td></tr>
<tr><td>FUTURES_POSITIONS</td><td>20,000</td><td>8 contracts, 1-50x leverage</td></tr>
<tr><td>ONTOLOGY (8 tables)</td><td>~100</td><td>10 chains, 14 tokens, ISO standard</td></tr>
</table>
</html>

---

## Agent Tool Configuration

<html>
<table>
<tr><th>Tool Name</th><th>Type</th><th>Resource</th></tr>
<tr><td>KrakenTrading</td><td>cortex_analyst_text_to_sql</td><td>KRAKEN_DB.ANALYTICS.KRAKEN_TRADING_SV</td></tr>
<tr><td>KrakenOperations</td><td>cortex_analyst_text_to_sql</td><td>KRAKEN_DB.ANALYTICS.KRAKEN_OPERATIONS_SV</td></tr>
<tr><td>BlockchainOntology</td><td>cortex_analyst_text_to_sql</td><td>KRAKEN_DB.ANALYTICS.DLT_BLOCKCHAIN_ONTOLOGY_SV</td></tr>
<tr><td>TicketSearch</td><td>cortex_search</td><td>KRAKEN_DB.SEARCH.SUPPORT_TICKET_SEARCH</td></tr>
<tr><td>ComplianceSearch</td><td>cortex_search</td><td>KRAKEN_DB.SEARCH.COMPLIANCE_DOC_SEARCH</td></tr>
<tr><td>FraudAlerts</td><td>generic (function)</td><td>KRAKEN_DB.ML.AGENT_GET_FRAUD_ALERTS</td></tr>
<tr><td>ChurnRisk</td><td>generic (function)</td><td>KRAKEN_DB.ML.AGENT_GET_CHURN_RISK</td></tr>
<tr><td>VolumeForecast</td><td>generic (function)</td><td>KRAKEN_DB.ML.AGENT_GET_VOLUME_FORECAST</td></tr>
<tr><td>CustomerLTV</td><td>generic (function)</td><td>KRAKEN_DB.ML.AGENT_GET_CUSTOMER_LTV</td></tr>
<tr><td>RiskScores</td><td>generic (function)</td><td>KRAKEN_DB.ML.AGENT_GET_RISK_SCORES</td></tr>
<tr><td>TicketClassifier</td><td>generic (function)</td><td>KRAKEN_DB.ML.AGENT_CLASSIFY_TICKETS</td></tr>
</table>
</html>
