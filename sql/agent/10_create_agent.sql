/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 10_create_agent.sql
  Purpose: Create the Energy Recovery Cortex Agent
  Execution Order: 10 of 10
  
  Tools:
    - FinancialAnalyst (Cortex Analyst - SV_FINANCIAL_OPS)
    - PipelineAnalyst (Cortex Analyst - SV_CRM_PIPELINE)
    - DeviceAnalyst (Cortex Analyst - SV_IOT_PERFORMANCE)
    - KnowledgeSearch (Cortex Search - Knowledge Base)
    - PredictFailure (Generic - ML failure prediction)
    - ScoreEfficiency (Generic - ML efficiency scoring)
    - ForecastDemand (Generic - ML demand forecast)
    - EquipmentHealth (Generic - ML health scoring)
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE SCHEMA AGENT;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- CREATE AGENT
-- ============================================================================
CREATE OR REPLACE AGENT ENERGY_RECOVERY_AGENT
  COMMENT = 'Energy Recovery Intelligence Agent - unified access to financial, CRM, IoT, and ML insights'
  PROFILE = '{"display_name": "Energy Recovery Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 360
      tokens: 32000

  instructions:
    response: "You are the Energy Recovery Intelligence Assistant, providing insights across financial operations, sales pipeline, device performance, and manufacturing. Always provide specific data with context. When presenting financial data, include fiscal year/quarter context. When discussing devices, reference specific models (PX-Q650, PX-Q400, PX-G1300). Format numbers clearly with appropriate units (USD for currency, % for percentages, bar for pressure, m³/h for flow rates). If data spans multiple domains, synthesize insights across tools."

    orchestration: "Route questions as follows:
      - Revenue, orders, invoices, AR/AP, margins, financial performance → FinancialAnalyst
      - Pipeline, opportunities, accounts, win rates, CRM, sales activities → PipelineAnalyst
      - Device performance, telemetry, alarms, uptime, efficiency, IoT → DeviceAnalyst
      - Product specifications, maintenance procedures, company info, ISA-95 → KnowledgeSearch
      - Device failure risk, at-risk devices, predictive maintenance → PredictFailure
      - Energy efficiency scores, efficiency gaps, savings potential → ScoreEfficiency
      - Demand forecast, market growth, future orders → ForecastDemand
      - Equipment health scores, fleet health, condition assessment → EquipmentHealth
      
      For cross-domain questions, use multiple tools and synthesize results. Always check the ISA-95 ontology via KnowledgeSearch when questions involve manufacturing hierarchy, process flows, or organizational structure."

    sample_questions:
      - question: "What was our total revenue for Q1 2026?"
      - question: "How does gross margin compare across product lines?"
      - question: "What is our current AR aging breakdown by region?"
      - question: "Show me month-over-month revenue trends for the last 12 months"
      - question: "What are our top 10 customers by revenue this year?"
      - question: "What percentage of our invoices are overdue?"
      - question: "How much did we spend on R&D vs Sales & Marketing last quarter?"
      - question: "What is our current pipeline value by stage?"
      - question: "Which opportunities are expected to close this quarter with amount over 1M?"
      - question: "What is our win rate by region over the past year?"
      - question: "Show me the pipeline for PX G1300 CO2 Refrigeration products"
      - question: "How does our win rate against Danfoss compare to Flowserve and Sulzer?"
      - question: "What is our weighted pipeline forecast for next quarter?"
      - question: "Which PX devices are at risk of failure in the next 30 days?"
      - question: "What is the average energy recovery efficiency across our installed base by device model?"
      - question: "Show me alarm frequency trends by severity for the past 6 months"
      - question: "Which installation sites have the highest uptime?"
      - question: "What is the equipment health score distribution across our fleet?"
      - question: "How many devices have vibration levels above 5 mm/s?"
      - question: "What is the total maintenance cost by device model and maintenance type?"
      - question: "What maintenance procedures apply to PX Q650 devices?"
      - question: "What is the PX G1300 and what applications is it designed for?"
      - question: "How does our ISA-95 hierarchy map to production capacity?"
      - question: "What is the demand forecast for next quarter by product line?"
      - question: "What energy efficiency improvements could we achieve and what are the potential savings?"
      - question: "How does our sales pipeline correlate with installed base growth in MENA?"
      - question: "What troubleshooting steps should I follow for a PX device showing low efficiency?"
      - question: "Which regions are showing the strongest demand growth?"

  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "FinancialAnalyst"
        description: "Queries financial data including revenue, sales orders, invoices, accounts receivable, accounts payable, and general ledger entries from Microsoft Dynamics Finance & Operations. Use for questions about revenue, margins, costs, financial performance, orders, and billing."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "PipelineAnalyst"
        description: "Queries CRM data including sales opportunities, accounts, contacts, and activities from Microsoft Dynamics CRM. Use for questions about pipeline value, win rates, deal stages, customer accounts, sales rep performance, and sales activities."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "DeviceAnalyst"
        description: "Queries IoT device data including telemetry readings (pressure, flow, vibration, temperature, efficiency), alarms, and maintenance history from SCADA systems. Covers 42,000+ PX Pressure Exchanger devices installed globally. Use for questions about device performance, uptime, alarms, and maintenance."

    - tool_spec:
        type: "cortex_search"
        name: "KnowledgeSearch"
        description: "Searches the Energy Recovery knowledge base containing product specifications (PX Q650, Q400, G1300), maintenance procedures, troubleshooting guides, ISA-95 manufacturing ontology documentation, desalination market information, and company processes. Use for questions about how things work, specifications, procedures, or company information."

    - tool_spec:
        type: "generic"
        name: "PredictFailure"
        description: "Returns a list of PX devices predicted to be at risk of failure within the next 30 days, including risk score (0-100), primary risk factor, and recommended maintenance action. Based on vibration levels, efficiency trends, temperature, operating hours, and service history."

    - tool_spec:
        type: "generic"
        name: "ScoreEfficiency"
        description: "Returns energy efficiency scores for PX devices grouped by model and region, comparing actual efficiency to design specifications. Includes efficiency gap analysis and potential energy savings in kWh."

    - tool_spec:
        type: "generic"
        name: "ForecastDemand"
        description: "Returns demand forecasts by product line and region for the next quarter, based on historical order trends and current pipeline. Includes forecast units, revenue, confidence level, and growth rate."

    - tool_spec:
        type: "generic"
        name: "EquipmentHealth"
        description: "Returns composite equipment health scores (0-100) for PX devices, combining efficiency, vibration, maintenance history, and operating hours. Identifies top concerns and categorizes devices as Excellent, Good, Fair, Poor, or Critical."

  tool_resources:
    FinancialAnalyst:
      semantic_view: "ENERGY_RECOVERY_DB.AGENT.SV_FINANCIAL_OPS"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"

    PipelineAnalyst:
      semantic_view: "ENERGY_RECOVERY_DB.AGENT.SV_CRM_PIPELINE"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"

    DeviceAnalyst:
      semantic_view: "ENERGY_RECOVERY_DB.AGENT.SV_IOT_PERFORMANCE"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"

    KnowledgeSearch:
      name: "ENERGY_RECOVERY_DB.AGENT.ENERGY_RECOVERY_KNOWLEDGE_SEARCH"
      max_results: "10"
      title_column: "TITLE"
      id_column: "ARTICLE_ID"

    PredictFailure:
      type: "function"
      identifier: "ENERGY_RECOVERY_DB.ML_MODELS.PREDICT_PX_FAILURE"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"

    ScoreEfficiency:
      type: "function"
      identifier: "ENERGY_RECOVERY_DB.ML_MODELS.SCORE_ENERGY_EFFICIENCY"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"

    ForecastDemand:
      type: "function"
      identifier: "ENERGY_RECOVERY_DB.ML_MODELS.FORECAST_DEMAND"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"

    EquipmentHealth:
      type: "function"
      identifier: "ENERGY_RECOVERY_DB.ML_MODELS.CALCULATE_EQUIPMENT_HEALTH"
      execution_environment:
        type: "warehouse"
        warehouse: "ENERGY_RECOVERY_WH"
  $$;
