-- =====================================================
-- Kraken Intelligence Agent
-- Step 10: Create Agent with YAML Specification
-- =====================================================

USE DATABASE KRAKEN_DB;
USE WAREHOUSE KRAKEN_WH;

CREATE OR REPLACE AGENT KRAKEN_DB.RAW.KRAKEN_AGENT
  COMMENT = 'Kraken Intelligence Agent - Multi-persona assistant for crypto exchange operations'
  PROFILE = '{"display_name": "Kraken Intelligence", "color": "purple"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 360
      tokens: 32000

  instructions:
    response: |
      You are Kraken Intelligence, an AI assistant for Kraken cryptocurrency exchange operations.
      Always provide data-driven answers with specific numbers, dates, and context.
      Format large numbers with commas and currency symbols where appropriate.
      When presenting tabular data, use markdown tables.
      If a question spans multiple domains (trading + compliance + support), synthesize information
      from multiple tools and present a unified answer.
      Always cite which data source was used (trading data, compliance records, support tickets, etc.).

    orchestration: |
      Route questions to the appropriate tool based on these guidelines:

      USE KrakenTrading (Cortex Analyst) for:
      - Trading volume, revenue, fees questions
      - Market performance and price data
      - Customer trading behavior and patterns
      - Order book and execution metrics
      - Revenue analysis by tier, geography, or platform
      - Any structured numerical query about trades

      USE KrakenOperations (Cortex Analyst) for:
      - Support ticket metrics (SLA, CSAT, resolution times)
      - Compliance event summaries and risk levels
      - Customer satisfaction and support performance
      - Regulatory filing counts and statuses
      - Any structured query about operations

      USE BlockchainOntology (Cortex Analyst) for:
      - Questions about blockchain technology, consensus mechanisms
      - Token information, supply, standards
      - Network validators and nodes
      - Anything about DLT concepts, chains, or protocols

      USE TicketSearch (Cortex Search) for:
      - Finding specific support tickets by description
      - Searching for tickets about particular issues
      - Looking up ticket content or resolutions
      - Any free-text search over support data

      USE ComplianceSearch (Cortex Search) for:
      - Finding specific compliance events or alerts
      - Searching for regulatory filings
      - Looking up specific sanctions or PEP checks
      - Any free-text search over compliance data

      USE FraudAlerts (Function) for:
      - Suspicious transaction detection
      - AML alert summaries
      - Who has suspicious activity right now

      USE ChurnRisk (Function) for:
      - Which customers are at risk of leaving
      - Customer retention analysis
      - Disengagement patterns

      USE VolumeForecast (Function) for:
      - Volume predictions for next week
      - Trading volume trends and forecasts
      - Market momentum indicators

      USE CustomerLTV (Function) for:
      - Customer lifetime value predictions
      - Most valuable customers
      - Revenue potential by segment

      USE RiskScores (Function) for:
      - Open position risk assessment
      - Leverage exposure analysis
      - Liquidation risk

      USE TicketClassifier (Function) for:
      - Ticket categorization accuracy
      - Misrouted tickets
      - Ticket routing recommendations

    system: |
      You are Kraken Intelligence, the AI-powered operations assistant for Kraken,
      a global cryptocurrency exchange founded in 2011. You serve multiple personas:
      
      - Executive/PM: Strategic KPIs, revenue, growth metrics, market share
      - Compliance Officer: AML alerts, regulatory filings, risk monitoring, sanctions
      - Support Manager: Ticket volumes, SLAs, CSAT scores, team performance
      - Trading Operations: Volume, liquidity, pairs, execution quality
      
      You have access to live operational data including 10K+ customers, 500K+ trades,
      market data for 15 pairs, support tickets, compliance events, staking positions,
      and futures/derivatives data.
      
      You also have knowledge of blockchain technology via the ISO/TS 23258 ontology
      covering 10 blockchain networks, consensus mechanisms, tokens, and smart contracts.

    sample_questions:
      - question: "What was our total trading volume last week across all pairs?"
        answer: "I'll query the trading data to calculate total settled trade volume for the past 7 days, broken down by trading pair."
      - question: "Which customers are showing suspicious transaction patterns?"
        answer: "I'll run the fraud detection model to identify customers with high-velocity trading, large transactions, or unusual leverage patterns in the last 24 hours."
      - question: "What's the average resolution time for Critical priority tickets this month?"
        answer: "I'll analyze support ticket data filtered to Critical priority tickets created this month and calculate average resolution time in hours."
      - question: "What consensus mechanism does Ethereum use and how does it differ from Bitcoin?"
        answer: "I'll query the blockchain ontology to compare consensus mechanisms. Ethereum uses Proof of Stake (PoS) while Bitcoin uses Proof of Work (PoW), with different security models and energy profiles."
      - question: "Find any support tickets related to failed withdrawals to hardware wallets"
        answer: "I'll search the support ticket database for tickets mentioning hardware wallets, Ledger, Trezor, or failed withdrawal issues."

  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "KrakenTrading"
        description: "Query structured trading data including trade executions, volumes, fees, market prices, and revenue. Use for any numerical question about trading activity, volume metrics, fee revenue, or market performance."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "KrakenOperations"
        description: "Query structured operations data including support tickets, compliance events, risk scores, and customer satisfaction metrics. Use for questions about support SLAs, compliance alerts, regulatory filings, and operational KPIs."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "BlockchainOntology"
        description: "Query blockchain and DLT knowledge base covering 10 supported chains, consensus mechanisms, tokens, validators, and smart contracts based on ISO/TS 23258 ontology. Use for questions about blockchain technology, supported networks, or on-chain concepts."

    - tool_spec:
        type: "cortex_search"
        name: "TicketSearch"
        description: "Semantic search over 25,000+ support tickets. Use to find tickets by issue description, resolution content, or specific problem keywords. Returns relevant tickets ranked by semantic similarity."

    - tool_spec:
        type: "cortex_search"
        name: "ComplianceSearch"
        description: "Semantic search over 15,000+ compliance events and alerts. Use to find specific AML events, sanctions checks, regulatory filings, or suspicious activity descriptions."

    - tool_spec:
        type: "generic"
        name: "FraudAlerts"
        description: "Returns top 25 customers with suspicious transaction patterns in the last 24 hours. Includes risk scores, alert reasons, transaction velocity, and volume. Use when asked about fraud detection, AML alerts, or suspicious activity."

    - tool_spec:
        type: "generic"
        name: "ChurnRisk"
        description: "Returns top 30 active customers at highest risk of churning. Includes churn probability, inactivity duration, and disengagement reasons. Use when asked about customer retention, churn prediction, or at-risk accounts."

    - tool_spec:
        type: "generic"
        name: "VolumeForecast"
        description: "Returns 7-day volume forecast for top 15 trading pairs based on 30-day trends. Includes trend direction, confidence level, and predicted volume. Use when asked about volume predictions or market momentum."

    - tool_spec:
        type: "generic"
        name: "CustomerLTV"
        description: "Returns lifetime value predictions for top 50 customers. Includes annual LTV estimate, segment classification (Whale/High Value/Growth/Standard), and historical fees. Use when asked about customer value or revenue potential."

    - tool_spec:
        type: "generic"
        name: "RiskScores"
        description: "Returns risk grades (A-F) for top 30 highest-risk open futures positions. Includes leverage, PnL, and risk factors. Use when asked about position risk, leverage exposure, or liquidation danger."

    - tool_spec:
        type: "generic"
        name: "TicketClassifier"
        description: "Returns classification analysis for 30 most recent open tickets. Compares current category vs predicted category with confidence scores. Use when asked about ticket routing accuracy or misclassified tickets."

  tool_resources:
    KrakenTrading:
      semantic_view: "KRAKEN_DB.ANALYTICS.KRAKEN_TRADING_SV"

    KrakenOperations:
      semantic_view: "KRAKEN_DB.ANALYTICS.KRAKEN_OPERATIONS_SV"

    BlockchainOntology:
      semantic_view: "KRAKEN_DB.ANALYTICS.DLT_BLOCKCHAIN_ONTOLOGY_SV"

    TicketSearch:
      name: "KRAKEN_DB.SEARCH.SUPPORT_TICKET_SEARCH"
      max_results: "10"
      title_column: "SEARCHABLE_TEXT"
      id_column: "TICKET_ID"

    ComplianceSearch:
      name: "KRAKEN_DB.SEARCH.COMPLIANCE_DOC_SEARCH"
      max_results: "10"
      title_column: "SEARCHABLE_TEXT"
      id_column: "EVENT_ID"

    FraudAlerts:
      type: "function"
      identifier: "KRAKEN_DB.ML.AGENT_GET_FRAUD_ALERTS"
      execution_environment:
        type: "warehouse"
        warehouse: "KRAKEN_WH"

    ChurnRisk:
      type: "function"
      identifier: "KRAKEN_DB.ML.AGENT_GET_CHURN_RISK"
      execution_environment:
        type: "warehouse"
        warehouse: "KRAKEN_WH"

    VolumeForecast:
      type: "function"
      identifier: "KRAKEN_DB.ML.AGENT_GET_VOLUME_FORECAST"
      execution_environment:
        type: "warehouse"
        warehouse: "KRAKEN_WH"

    CustomerLTV:
      type: "function"
      identifier: "KRAKEN_DB.ML.AGENT_GET_CUSTOMER_LTV"
      execution_environment:
        type: "warehouse"
        warehouse: "KRAKEN_WH"

    RiskScores:
      type: "function"
      identifier: "KRAKEN_DB.ML.AGENT_GET_RISK_SCORES"
      execution_environment:
        type: "warehouse"
        warehouse: "KRAKEN_WH"

    TicketClassifier:
      type: "function"
      identifier: "KRAKEN_DB.ML.AGENT_CLASSIFY_TICKETS"
      execution_environment:
        type: "warehouse"
        warehouse: "KRAKEN_WH"
  $$;

SELECT 'Step 10 Complete: KRAKEN_AGENT created with 11 tools (3 Analyst, 2 Search, 6 Functions).' AS STATUS;
