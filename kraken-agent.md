# Snowflake Intelligence Agent Project Template

## Purpose
Building a Snowflake CoWork Agent for a business like Kraken is the ability to democratize data access and automate complex, cross-functional workflows while maintaining strict security and governance.Because Kraken operates in a highly regulated, high-velocity, and data-intensive industry, the main value proposition of a CoWork Agent is shifting from "asking for a report" to "taking an action."Here are the most impactful reasons for implementing this technology at a company like Kraken:1. Accelerating Decision-Making Across SilosCryptocurrency exchanges manage massive amounts of disparate data, ranging from structured trade volumes and order book depth to unstructured customer support tickets, compliance logs, and market sentiment.The Problem: Currently, getting an answer to a complex question (e.g., "Why did our support ticket volume spike for a specific trading pair last week?") often requires multiple departments, manual SQL queries, and days of back-and-forth.The CoWork Solution: A CoWork Agent can synthesize structured data (from Snowflake) and unstructured data (from support tickets or external market reports) to provide an immediate, natural-language answer. This allows non-technical team members—such as Product Managers or Compliance Officers—to gain insights instantly without waiting on data analysts.2. Operationalizing Compliance and Risk ManagementKraken operates in a space where regulatory compliance is paramount.The Benefit: A Snowflake CoWork Agent is built with enterprise-grade governance. It operates within the organization's existing security perimeter, meaning it respects role-based access controls (RBAC) and data masking.The Use Case: You could build an agent that proactively monitors for anomalous patterns in transaction data or customer activity, immediately surfacing these to the compliance team with a summary of the context, the data source, and the specific policy violation, significantly reducing the "time-to-detection" for potential issues.3. Automating Routine "Knowledge Work"Knowledge workers at a global firm like Kraken spend significant time on repetitive, high-context tasks that aren't easily automated by simple scripts.Automated Briefings: Employees could trigger an agent to prepare a "morning briefing" that aggregates overnight market volatility, top customer queries, and system performance metrics, formatted exactly for their role.Tool Integration: Using Model Context Protocol (MCP) connectors, these agents can bridge the gap between Snowflake and external tools like Slack, Jira, or Salesforce. For instance, an agent could identify a recurring technical error from support logs (unstructured data) and automatically draft a Jira ticket for the engineering team, including the relevant data context from Snowflake.4. Improving "Time-to-Insight" for StrategyFor a business that relies on rapid execution, having a "personal agent" for every employee reduces the friction of manual data exploration.Self-Service Analytics: Instead of navigating rigid dashboards, leadership can ask "What if" questions (e.g., "How would a 5% increase in fee structure for [Asset] impact our monthly revenue based on last quarter’s volume?") and receive data-grounded forecasts immediately. This allows for faster, more informed strategic pivots in a volatile market.Summary: Why it fits KrakenThe core advantage of using Snowflake CoWork specifically—rather than a generic LLM—is that it is grounded in your enterprise data from day one. It doesn't just "chat"; it understands how Kraken defines its business metrics, follows your specific governance rules, and can be configured to take actions that actually move the business forward within the systems you already use.

## Customer details
Kraken is a prominent, global cryptocurrency exchange that provides a platform for individuals and institutions to buy, sell, and trade digital assets. Founded in 2011, it has grown from a specialized Bitcoin platform into a comprehensive multi-asset financial services company.While it is widely known as a crypto exchange, Kraken's operations have expanded to include derivatives, staking services, and, in some regions, access to traditional financial assets like stocks and ETFs.How Kraken Makes MoneyKraken’s revenue model is diversified across several streams:Trading Fees (Transaction Fees): This is the core of Kraken's business. The platform charges a percentage fee on trades executed on its exchange. These fees vary based on the user's trading volume, the specific market (e.g., spot, margin, or futures), and whether the user is an individual or an institutional client. Higher-volume traders typically benefit from lower, tiered fee structures.Staking and Earn Services: Kraken allows users to "stake" or hold certain cryptocurrencies to help secure blockchain networks. In return, users earn rewards. Kraken generates revenue by taking a commission or percentage of the staking rewards generated by the assets held on its platform.Asset-Based and Service Revenue: Beyond trading, Kraken earns through various financial services, such as:Custody Services: Managing the secure storage of assets for institutional clients.Payment and Financing Services: Providing infrastructure for payments and capital efficiency tools.Over-the-Counter (OTC) Trading: Kraken operates an OTC desk for large-volume traders. Unlike its standard exchange, the OTC desk often acts as the counterparty to the trade, which can involve different risk-and-revenue dynamics.Expansion into Traditional Finance: Increasingly, Kraken has diversified into non-crypto areas, such as offering commission-free trading for stocks and ETFs in certain jurisdictions and facilitating tokenized equities. These initiatives create additional revenue channels independent of pure cryptocurrency trading volume.Key Aspects of Their BusinessNot a Bank or Broker: Kraken emphasizes that it operates as a venue where users trade directly with one another. It is not an investment advisor or a traditional bank, and it does not manage or "undo" user trades.Infrastructure-Focused: The parent company, Payward, Inc., manages a unified infrastructure that supports multiple products (such as Kraken, Kraken Pro, and various institutional tools) on shared systems for liquidity, compliance, and risk management. This allows the company to launch new services efficiently.

## Customer Configuration

**To create a new project, replace these variables throughout:**

| Variable | Description | Example (Cathay Bank) |
|----------|-------------|-------------------|
| `{CUSTOMER_NAME}` | Customer name | Kraken |
| `{CUSTOMER_NAME_UPPER}` | Uppercase for SQL objects | Kraken |
| `{DATABASE_NAME}` | Main database name | Kraken_DB |
| `{WAREHOUSE_NAME}` | Warehouse name | Kraken_WH |
| `{AGENT_NAME}` | Agent identifier | Kraken_AGENT |
| `{BUSINESS_DOMAIN}` | Customer's business focus | Crypto Currency Exchange |
| `{WEB_PRESENCE}`  | Web Address | https://www.Kraken.com/

---

## Project Instructions

```Build a complete Snowflake Intelligence architecture and implementation plan for `{CUSTOMER_NAME_UPPER}`.

The proposed architecture is a modern, streaming-first Scalable ELT Pipeline designed for near real-time data availability, scalability, and maintainability.  All of the ESG data will stream data into Snowflake and they have the desire to be able to ask questions of their data with Natural Language Queries.

(Note: All project images should be SVG graphics and as you can see in the "Agent Project Structure" section, there should always be architecture.svg, deployment_flow.svg, ml_models.svg at a minimum)
 This Project should encompass all aspects of the details identified on their website @https://www.Kraken.com. The Agent Project Structure directories should be created in the root github repo directory. Use these files in the Ontology Directory to build the Ontology for this project.
 Additionally, create a "Query Tool Chain" SVG diagram.  This should show examples of the questions and the tool path used to answer.  I am trying to identify when each tool is used and whether the agent used the ontology.
 ```

## Agent Project Structure

```
/
├── README.md                           # Project overview and setup instructions
├── docs/
│   ├── AGENT_SETUP.md                 # Step-by-step agent configuration guide
│   ├── DEPLOYMENT_SUMMARY.md          # Current deployment status
│   ├── questions.md                   # 30+ complex test questions
│   └── images/
│       ├── architecture.svg           # System architecture diagram
│       ├── deployment_flow.svg        # Deployment workflow diagram
│       └── ml_models.svg              # ML pipeline visualization
├── notebooks/
│   └── 08_ml_models.ipynb      # ML model training (optional)
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql # Database, schemas, warehouse
    │   └── 02_create_tables.sql       # All table definitions
    |   └── 03_Blockchain_Ontology.sql # Create all tables and load the Blockchain Ontology
    ├── data/
    │   └── 04_generate_synthetic_data.sql # Test data generation
    ├── views/
    │   ├── 05_create_views.sql        # Analytical views
    │   └── 06_create_semantic_views.sql # Semantic views for Cortex Analyst
    ├── search/
    │   └── 07_create_cortex_search.sql # Cortex Search services
    ├── models/
    │   └── 09_ml_model_functions.sql  # ML prediction views and agent functions
    └── agent/
        └── 10_create_agent.sql # Agent creation script
```

---

## File Execution Order

**MUST be executed in this exact order:**

These are examples of what is required.  You may need to add more project defined project.  The documentation should have an SVG image showing the project flow.

1. `sql/setup/01_database_and_schema.sql`
2. `sql/setup/02_create_tables.sql`
3. `sql/data/03_Blockchain_Ontology.sql`
4. `sql/data/04_generate_synthetic_data.sql`
5. `sql/views/05_create_views.sql`
6. `sql/views/06_create_semantic_views.sql`
7. `sql/search/07_create_cortex_search.sql`
8. `notebooks/08_ml_models.ipynb`
9. `sql/models/09_ml_model_functions.sql`
10. `sql/agent/10_create_agent.sql`

---

## Critical Syntax Reference

### Snowflake Agent YAML Specification (VERIFIED WORKING)

```yaml
CREATE OR REPLACE AGENT {AGENT_NAME}
  COMMENT = '{Customer} intelligence agent'
  PROFILE = '{"display_name": "{Customer} Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 360
      tokens: 32000

  instructions:
    response: "Response instructions..."
    orchestration: "Tool routing instructions..."
    system: "System role description..."
    sample_questions:
      - question: "Sample question?"
        answer: "How the agent should respond."

  tools:
    # Cortex Analyst (text-to-SQL)
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ToolName"
        description: "Description of what this tool does"

    # Cortex Search
    - tool_spec:
        type: "cortex_search"
        name: "SearchName"
        description: "Description of search capability"

    # Custom Function (generic)
    - tool_spec:
        type: "generic"
        name: "FunctionName"
        description: "Description of function output"

  tool_resources:
    # Cortex Analyst resource
    ToolName:
      semantic_view: "{DATABASE}.{SCHEMA}.{SEMANTIC_VIEW_NAME}"

    # Cortex Search resource
    SearchName:
      name: "{DATABASE}.{SCHEMA}.{SEARCH_SERVICE_NAME}"
      max_results: "10"
      title_column: "column_name"
      id_column: "id_column"

    # Custom Function resource
    FunctionName:
      type: "function"
      identifier: "{DATABASE}.{SCHEMA}.{FUNCTION_NAME}"
      execution_environment:
        type: "warehouse"
        warehouse: "{WAREHOUSE_NAME}"
  $$;
```

### SQL UDF Return Types (VERIFIED)

| Function Returns | Correct Return Type |
|------------------|---------------------|
| `ARRAY_AGG(...)` | `RETURNS ARRAY` |
| `OBJECT_CONSTRUCT(...)` | `RETURNS OBJECT` |
| Single scalar value | `RETURNS VARCHAR/NUMBER/etc` |

**DO NOT USE:**
- `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
- `LANGUAGE SQL` clause in SQL UDFs

### SQL UDF Syntax (VERIFIED)

```sql
-- Correct syntax for scalar UDF returning ARRAY
CREATE OR REPLACE FUNCTION AGENT_GET_DATA()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'key1', COLUMN1,
    'key2', COLUMN2
)) FROM (SELECT * FROM TABLE LIMIT 50)
$$;

-- Correct syntax for scalar UDF returning OBJECT
CREATE OR REPLACE FUNCTION AGENT_GET_SUMMARY()
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'metric1', (SELECT COUNT(*) FROM TABLE1),
    'metric2', (SELECT AVG(COLUMN) FROM TABLE2)
)
$$;
```

---

## Lessons Learned (CRITICAL)

### 1. ALWAYS VERIFY SNOWFLAKE SYNTAX BEFORE WRITING CODE

**What went wrong:** Multiple syntax errors because I guessed at syntax instead of verifying against Snowflake documentation.

**Correct approach:**
- Use `snowflake_product_docs` tool to look up syntax BEFORE writing any SQL
- Use `system_instructions` tool for Cortex Agent, Analyst, and other Snowflake products
- Reference working examples

**Specific errors made:**
- Used `RETURNS VARIANT` instead of `RETURNS ARRAY` for `ARRAY_AGG`
- Used `RETURNS VARIANT` instead of `RETURNS OBJECT` for `OBJECT_CONSTRUCT`
- Used `LANGUAGE SQL` clause which is invalid for SQL UDFs
- Used `type: "procedure"` instead of `type: "function"` for agent tools
- Used `search_service:` instead of `name:` for Cortex Search resources
- Used JSON format instead of YAML for agent specification

### 2. COMPLETE ALL FILES BEFORE STOPPING

**What went wrong:** Generated partial files and stopped without completing the project, leaving merge conflicts and incomplete code.

**Correct approach:**
- Review ALL files in the project at the start
- Create a TODO list for every file that needs to be created/modified
- Do not mark a task complete until the file is verified to compile/run
- Verify file completeness before moving to the next task

### 3. NEVER GUESS - ASK OR RESEARCH

**What went wrong:** Made assumptions about:
- Agent YAML syntax
- SQL UDF return types
- Function naming conventions
- Tool resource configuration

**Correct approach:**
- If unsure about syntax, use documentation tools first
- If documentation is unclear, ask the user for clarification
- Reference working examples from similar projects
- Test small pieces of code before combining them

### 4. ASK QUESTIONS WHEN UNCLEAR

**What went wrong:** Proceeded with assumptions instead of asking for clarification on requirements.

**Questions to ask upfront:**
- What business domain/industry is this for?
- What specific ML models or predictions are needed?
- What data sources exist or need to be created?
- What sample questions should the agent answer?
- Are there any existing working examples to reference?

### 5. VERIFY GIT MERGE CONFLICTS

**What went wrong:** Left merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in SQL files.

**Correct approach:**
- After any file operations, verify no merge conflicts exist
- Search for conflict markers before marking files complete
- Test SQL files compile before considering them done

---

## Component Templates

### Database Setup (01_database_and_schema.sql)

```sql
CREATE DATABASE IF NOT EXISTS {DATABASE_NAME};
USE DATABASE {DATABASE_NAME};

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

CREATE OR REPLACE WAREHOUSE {WAREHOUSE_NAME} WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for {CUSTOMER_NAME} Intelligence Agent';

USE WAREHOUSE {WAREHOUSE_NAME};
```

### Cortex Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE {SEARCH_SERVICE_NAME}
  ON {text_column}
  ATTRIBUTES {attr1}, {attr2}, {attr3}
  WAREHOUSE = {WAREHOUSE_NAME}
  TARGET_LAG = '1 hour'
  COMMENT = 'Description of search service'
AS
  SELECT
    {columns}
  FROM {TABLE};
```

### Semantic View

```sql
CREATE OR REPLACE SEMANTIC VIEW {SEMANTIC_VIEW_NAME}
  COMMENT = 'Semantic view description'
AS
  SELECT
    {table}.{column} AS {alias}
      WITH SYNONYMS ('{synonym1}', '{synonym2}')
      COMMENT = '{Column description}',
    ...
  FROM {database}.{schema}.{table}
  ...;
```

---

## Checklist for New Projects

### Before Starting
- [ ] Confirm customer name and business domain
- [ ] Identify data sources (existing tables or need synthetic data)
- [ ] Determine ML models needed (LTV, churn, risk, etc.)
- [ ] Collect sample questions the agent should answer
- [ ] Get working example project for reference

### During Development
- [ ] Verify ALL SQL syntax against Snowflake docs before writing
- [ ] Test each SQL file compiles before moving to next
- [ ] Check for merge conflicts after any file operations
- [ ] Complete TODO list for every component

### Before Delivery
- [ ] Run all SQL files in order (01-08)
- [ ] Test agent creation succeeds
- [ ] Verify agent responds to sample questions
- [ ] Update documentation with customer-specific details
- [ ] Remove any placeholder values

---

## Reference Links

- Snowflake Agent Docs: `snowflake_product_docs` → "Cortex Agent"
- SQL UDF Reference: `snowflake_product_docs` → "CREATE FUNCTION SQL"
- Cortex Search: `snowflake_product_docs` → "CREATE CORTEX SEARCH SERVICE"
- Semantic Views: `snowflake_product_docs` → "CREATE SEMANTIC VIEW"

---

## Version History

- **v1.0** - Initial template based on previous Intelligence Agent project
- **Created:** March 2026
- **Lessons Learned:** Documented from previous project issues

---

## DO NOT:
1. Guess at syntax - VERIFY FIRST
2. Use `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
3. Use `LANGUAGE SQL` in SQL UDFs
4. Use JSON format for Agent specification (use YAML)
5. Leave merge conflicts in files
6. Mark tasks complete before verifying they work
7. Assume you know Snowflake syntax without checking
8. Use text based graphic

## DO:
1. Use `snowflake_product_docs` before writing SQL
2. Use `system_instructions` for Cortex products
3. Reference working examples
4. Ask questions when requirements are unclear
5. Test each file compiles before moving on
6. Complete ALL files before stopping
7. Verify no merge conflicts exist
8. Always generate documentation
9. Always generate SVG images for the documentation.
10. Always use html for tables when generating documentation
11. Always generate all files and never placeholders
12. Always put this line of code at the top of all documentation files: <img src="Snowflake_Logo.svg" width="200">
