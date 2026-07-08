# Snowflake Intelligence Agent Project Template

## Purpose
Building a Snowflake CoWork Agent for a business like Energy Recovery is the ability to democratize data access and automate complex, cross-functional workflows while maintaining strict security and governance.1. Company Insights
Energy Recovery, Inc. (NASDAQ: ERII) is a publicly traded global leader in the design and manufacturing of energy recovery devices for industrial fluid flow applications, founded in 1992 and headquartered in San Leandro, California. The company's core technology — the PX Pressure Exchanger — recovers up to 98% of otherwise wasted pressure energy in reverse osmosis desalination plants. Energy Recovery holds a dominant market position in desalination energy recovery and is strategically expanding into industrial wastewater treatment and CO2 refrigeration. The company employs approximately 230 people and generated ~$135M in annual revenue in FY2025.

Products & Services:

PX Pressure Exchanger (Desalination) — Isobaric energy recovery devices for large-scale seawater and brackish water RO plants, reducing energy consumption by up to 98%
Industrial Fluid Flow Products — Pumps and energy recovery devices for wastewater treatment and industrial processes
PX G1300 (Refrigeration) — Energy recovery for industrial CO2 transcritical refrigeration systems, commercially launched April 2026
Aftermarket Services — Maintenance, support, and component replacement for installed base
Financial Insights:

Market Cap: ~$1.15B (as of July 2026)
Stock: ERII trading ~$19.50 | 52-week range: $13.50–$22.75
FY2025 Revenue: $135.2M (+5.1% YoY from $128.6M in FY2024)
FY2026 Guidance: $135M–$145M revenue, 67%–69% gross margin
Q1 2026: Revenue reported on May 8, 2026; management reiterated full-year guidance citing strong backlog
Tech Stack (Verified via Sumble):

Cloud: AWS, Azure, GCP
Databases: Microsoft SQL Server, Oracle
Data Warehouses: BigQuery, Redshift
Analytics/BI: Looker, Power BI, Tableau
Languages: R

2. Industry Insights
Energy Recovery operates in the Industrial Technology / Water Treatment / Environmental Services sector. The global desalination market is growing rapidly, driven by increasing water scarcity affecting 2B+ people globally, population growth in arid regions, and stricter environmental regulations. The industrial wastewater treatment market is expanding due to regulations requiring reduced water footprints. The CO2 refrigeration market is accelerating as HFC phase-outs drive adoption of natural refrigerants.

Trends & Challenges:

Accelerating desalination adoption — Growing water stress in MENA, Asia-Pacific, and the Americas driving massive RO plant construction and demand for energy-efficient components
Stricter environmental regulations — Industrial wastewater discharge limits and F-gas regulations pushing companies toward advanced treatment and natural refrigerant systems
Digitalization & predictive maintenance — Industrial OEMs adopting IoT sensors, AI-driven analytics, and digital twins to optimize equipment performance and reduce downtime
Sustainability mandates — Manufacturers facing increasing pressure to demonstrate ESG compliance, reduce carbon footprint, and optimize energy use across operations
Data & AI Use Cases in Manufacturing/Industrial:

Predictive maintenance — AI analyzing sensor data from pumps, motors, and PX devices to predict failures before they occur
Process optimization — ML models optimizing desalination/refrigeration cycle parameters to minimize energy consumption in real-time
Supply chain analytics — Demand forecasting, inventory optimization, and logistics planning across global operations
Energy management — AI-powered monitoring of facility energy consumption with real-time optimization recommendations
3. Recent News
Q1 2026 Earnings (May 8, 2026) — Energy Recovery reported Q1 results and reaffirmed full-year FY2026 guidance of $135M–$145M, citing strong backlog and anticipated H2 recovery from large water-segment project shipments
PX G1300 Commercial Launch (April 15, 2026) — Launched new pressure exchanger for large-scale industrial fluid flow applications, expanding beyond desalination into chemical processing and oil & gas
New CTO Appointed (March 1, 2026) — Dr. Emily Chen named CTO, bringing 20+ years in fluid dynamics and materials science, expected to drive product innovation
Strategic Engineering Partnership (June 1, 2026) — Partnered with a major global engineering firm to integrate PX technology into industrial wastewater treatment and chemical processing plant designs
4. Competitors
Competitor	Description	Competitive Positioning vs. Energy Recovery
Danfoss	Global leader in climate and energy-efficient solutions; offers APP pumps and iSave energy recovery devices	Larger and more diversified; broader product portfolio and global presence, but less specialized in PX-style isobaric recovery
Flowserve	Major flow control systems manufacturer (pumps, valves, seals)	Comprehensive system solutions for desalination and industrial processes; competes on breadth rather than energy recovery specialization
Sulzer	Fluid engineering company (pumps, agitators, mixers) for water, oil/gas, and power sectors	Long-standing industry presence and global service network; broad portfolio but lacks Energy Recovery's specialized PX efficiency
Energy Recovery differentiates through its proprietary PX technology with 98% energy recovery efficiency, specialized niche focus, and proven reliability — while competitors offer broader but less specialized industrial solutions.

## Customer details
Energy Recovery Potential Snowflake Value Proposition
Given Energy Recovery's multi-cloud data landscape (BigQuery, Redshift, SQL Server, Oracle) and growing strategic needs, key Snowflake value propositions include:

Data Warehouse Consolidation — Energy Recovery runs BigQuery, Redshift, AND has Snowflake exposure. Consolidating onto Snowflake would simplify their analytics stack, reduce operational overhead, and provide a single platform across AWS, Azure, and GCP
IoT & Predictive Maintenance Analytics — With 40,000+ PX devices installed globally generating sensor data, Snowflake's scalable architecture can power predictive maintenance models and real-time operational monitoring at scale
Supply Chain & Manufacturing Analytics — As the company expands into new markets (refrigeration, wastewater), Snowflake can serve as the unified data platform for demand forecasting, inventory optimization, and production planning
AI/ML Workloads — Snowflake's Cortex AI capabilities can accelerate Energy Recovery's process optimization and quality control initiatives without requiring a separate ML infrastructure

## Customer Configuration

**To create a new project, replace these variables throughout:**

| Variable | Description | Example (Energy Recovery) |
|----------|-------------|-------------------|
| `{CUSTOMER_NAME}` | Customer name | Energy Recovery |
| `{CUSTOMER_NAME_UPPER}` | Uppercase for SQL objects | ENERGY_RECOVERY |
| `{DATABASE_NAME}` | Main database name | Energy_Recovery_DB |
| `{WAREHOUSE_NAME}` | Warehouse name | Energy_Recovery_WH |
| `{AGENT_NAME}` | Agent identifier | Energy_Recovery_AGENT |
| `{BUSINESS_DOMAIN}` | Customer's business focus | Manufacturing of energy recovery devices |
| `{WEB_PRESENCE}`  | Web Address | https://www.EnergyRecovery.com/

---

## Project Instructions

```Build a complete Snowflake Intelligence architecture and implementation plan for `{CUSTOMER_NAME_UPPER}`.

The proposed architecture is a modern, streaming-first Scalable ELT Pipeline designed for near real-time data availability, scalability, and maintainability.  All of the data will stream data into Snowflake, from Microsoft Dynamics, Oracle, SCADA Systems, etc, and they have the desire to be able to ask questions of their data with Natural Language Queries. They are especially interested in the integration of Financial Operations data and their MSFT Dynamics CRM data.

(Note: All project images should be SVG graphics and as you can see in the "Agent Project Structure" section, there should always be architecture.svg, deployment_flow.svg, ml_models.svg at a minimum)
 This Project should encompass all aspects of the details identified on their website @https://www.EnergyRecovery.com. The Agent Project Structure directories should be created in the root github repo directory. Use ISA-95-aligned Ontology to build the Ontology for this project.
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
    |   └── 03_ISA_95_Ontology.sql # Create all tables and load the ISA 95 Ontology
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
3. `sql/data/03_ISA_95_Ontology.sql `
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
