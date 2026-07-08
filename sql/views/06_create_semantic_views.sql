/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 06_create_semantic_views.sql
  Purpose: Create semantic views for Cortex Analyst (text-to-SQL)
  Execution Order: 6 of 10
  
  Three semantic views:
    1. SV_FINANCIAL_OPS - Financial operations and revenue analysis
    2. SV_CRM_PIPELINE - CRM sales pipeline and account analysis
    3. SV_IOT_PERFORMANCE - IoT device performance and maintenance
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE SCHEMA AGENT;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- SEMANTIC VIEW 1: Financial Operations
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_FINANCIAL_OPS

  TABLES (
    sales_orders AS ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.SALES_ORDERS
      PRIMARY KEY (ORDER_ID)
      WITH SYNONYMS ('orders', 'sales', 'revenue')
      COMMENT = 'Sales orders for all product lines - desalination, wastewater, refrigeration, aftermarket',

    invoices AS ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.INVOICES
      PRIMARY KEY (INVOICE_ID)
      WITH SYNONYMS ('bills', 'billing')
      COMMENT = 'Customer invoices with payment status and aging',

    accounts_receivable AS ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.ACCOUNTS_RECEIVABLE
      PRIMARY KEY (AR_ID)
      WITH SYNONYMS ('AR', 'receivables', 'outstanding')
      COMMENT = 'Accounts receivable aging and outstanding balances',

    general_ledger AS ENERGY_RECOVERY_DB.DYNAMICS_FINANCE.GENERAL_LEDGER
      PRIMARY KEY (JOURNAL_ENTRY_ID)
      WITH SYNONYMS ('GL', 'financials', 'accounting')
      COMMENT = 'General ledger with revenue, COGS, and operating expenses'
  )

  RELATIONSHIPS (
    invoices_to_orders AS
      invoices (ORDER_ID) REFERENCES sales_orders (ORDER_ID)
  )

  FACTS (
    sales_orders.order_amount AS TOTAL_AMOUNT
      COMMENT = 'Total order value after discounts',
    sales_orders.unit_price_fact AS UNIT_PRICE
      COMMENT = 'Unit price per item',
    sales_orders.quantity_fact AS QUANTITY
      COMMENT = 'Quantity ordered',
    sales_orders.discount_fact AS DISCOUNT_PERCENT
      COMMENT = 'Discount percentage applied',
    invoices.invoice_total AS TOTAL_AMOUNT
      COMMENT = 'Total invoice amount including tax',
    invoices.balance_due_fact AS BALANCE_DUE
      COMMENT = 'Remaining balance owed on invoice',
    accounts_receivable.ar_balance AS BALANCE
      COMMENT = 'Outstanding AR balance',
    accounts_receivable.ar_original AS ORIGINAL_AMOUNT
      COMMENT = 'Original invoice amount',
    general_ledger.gl_credit AS CREDIT_AMOUNT
      COMMENT = 'Credit (revenue) amount',
    general_ledger.gl_debit AS DEBIT_AMOUNT
      COMMENT = 'Debit (expense) amount',
    general_ledger.gl_net AS NET_AMOUNT
      COMMENT = 'Net amount (credits minus debits)'
  )

  DIMENSIONS (
    sales_orders.order_date AS ORDER_DATE
      COMMENT = 'Date the sales order was placed',
    sales_orders.order_year AS YEAR(ORDER_DATE)
      COMMENT = 'Year the order was placed',
    sales_orders.order_quarter AS QUARTER(ORDER_DATE)
      COMMENT = 'Quarter the order was placed',
    sales_orders.order_month AS MONTH(ORDER_DATE)
      COMMENT = 'Month the order was placed',
    sales_orders.product_line AS PRODUCT_LINE
      WITH SYNONYMS ('product category', 'business segment')
      COMMENT = 'Product line: Desalination, Wastewater, Refrigeration, Aftermarket'
      SAMPLE_VALUES ('Desalination', 'Wastewater', 'Aftermarket', 'Refrigeration')
      IS_ENUM,
    sales_orders.product_name_dim AS PRODUCT_NAME
      WITH SYNONYMS ('product', 'item')
      COMMENT = 'Specific product name',
    sales_orders.region AS REGION
      WITH SYNONYMS ('geography', 'territory')
      COMMENT = 'Sales region'
      SAMPLE_VALUES ('MENA', 'Asia-Pacific', 'Europe', 'Americas', 'Africa')
      IS_ENUM,
    sales_orders.country AS COUNTRY
      COMMENT = 'Customer country',
    sales_orders.customer_name_dim AS CUSTOMER_NAME
      WITH SYNONYMS ('customer', 'client', 'buyer')
      COMMENT = 'Customer name',
    sales_orders.sales_rep_dim AS SALES_REP
      WITH SYNONYMS ('salesperson', 'rep', 'account executive')
      COMMENT = 'Sales representative name',
    sales_orders.order_status AS STATUS
      COMMENT = 'Order status: Open, Confirmed, Shipped, Invoiced, Cancelled'
      SAMPLE_VALUES ('Open', 'Confirmed', 'Shipped', 'Invoiced', 'Cancelled')
      IS_ENUM,
    invoices.invoice_status AS STATUS
      COMMENT = 'Invoice payment status: Open, Paid, Overdue, Partially Paid'
      SAMPLE_VALUES ('Open', 'Paid', 'Overdue', 'Partially Paid')
      IS_ENUM,
    invoices.payment_terms_dim AS PAYMENT_TERMS
      COMMENT = 'Payment terms: Net 30, Net 60, Net 90'
      SAMPLE_VALUES ('Net 30', 'Net 60', 'Net 90')
      IS_ENUM,
    accounts_receivable.aging_bucket_dim AS AGING_BUCKET
      WITH SYNONYMS ('aging', 'days outstanding')
      COMMENT = 'AR aging category'
      SAMPLE_VALUES ('Current', '1-30 Days', '31-60 Days', '61-90 Days', '90+ Days')
      IS_ENUM,
    accounts_receivable.ar_region AS REGION
      COMMENT = 'AR region',
    general_ledger.fiscal_year_dim AS FISCAL_YEAR
      COMMENT = 'Fiscal year',
    general_ledger.fiscal_quarter_dim AS FISCAL_QUARTER
      COMMENT = 'Fiscal quarter (1-4)',
    general_ledger.account_category_dim AS ACCOUNT_CATEGORY
      WITH SYNONYMS ('expense type', 'category')
      COMMENT = 'GL account category: Revenue, COGS, Operating Expense'
      SAMPLE_VALUES ('Revenue', 'COGS', 'Operating Expense')
      IS_ENUM,
    general_ledger.account_name_dim AS ACCOUNT_NAME
      COMMENT = 'GL account name',
    general_ledger.department_dim AS DEPARTMENT
      COMMENT = 'Department: Engineering, Manufacturing, Sales, Corporate, Service'
      SAMPLE_VALUES ('Engineering', 'Manufacturing', 'Sales', 'Corporate', 'Service')
      IS_ENUM
  )

  METRICS (
    sales_orders.total_revenue AS SUM(sales_orders.order_amount)
      WITH SYNONYMS ('revenue', 'sales', 'bookings')
      COMMENT = 'Total revenue from sales orders',
    sales_orders.order_count AS COUNT(ORDER_ID)
      COMMENT = 'Number of sales orders',
    sales_orders.avg_order_value AS AVG(sales_orders.order_amount)
      WITH SYNONYMS ('average deal size', 'AOV')
      COMMENT = 'Average order value',
    sales_orders.total_units_sold AS SUM(sales_orders.quantity_fact)
      COMMENT = 'Total units sold',
    invoices.total_invoiced AS SUM(invoices.invoice_total)
      COMMENT = 'Total amount invoiced',
    invoices.total_outstanding AS SUM(invoices.balance_due_fact)
      WITH SYNONYMS ('amount owed', 'unpaid')
      COMMENT = 'Total outstanding invoice balance',
    accounts_receivable.total_ar_balance AS SUM(accounts_receivable.ar_balance)
      WITH SYNONYMS ('total receivables', 'AR total')
      COMMENT = 'Total accounts receivable balance',
    accounts_receivable.ar_invoice_count AS COUNT(AR_ID)
      COMMENT = 'Number of outstanding AR items',
    general_ledger.total_credits AS SUM(general_ledger.gl_credit)
      COMMENT = 'Total GL credit (revenue) amounts',
    general_ledger.total_debits AS SUM(general_ledger.gl_debit)
      COMMENT = 'Total GL debit (expense) amounts',
    general_ledger.net_income AS SUM(general_ledger.gl_net)
      WITH SYNONYMS ('profit', 'bottom line', 'earnings')
      COMMENT = 'Net income (total credits minus total debits)'
  )

  AI_SQL_GENERATION 'When calculating revenue or financial metrics, always include the fiscal year and quarter for context. Round all monetary values to 2 decimal places. For year-over-year comparisons, use YEAR(ORDER_DATE) to group. The company fiscal year aligns with calendar year. Revenue guidance for FY2026 is $135M-$145M.'

  AI_QUESTION_CATEGORIZATION 'This view handles questions about revenue, sales orders, invoices, accounts receivable, financial performance, margins, and general ledger data for Energy Recovery. Questions about CRM pipeline or device performance should be directed to other tools.'

  COMMENT = 'Financial operations semantic view for Energy Recovery - covers revenue, orders, invoices, AR, and GL data from Microsoft Dynamics Finance & Operations';

-- ============================================================================
-- SEMANTIC VIEW 2: CRM / Sales Pipeline
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_CRM_PIPELINE

  TABLES (
    opportunities AS ENERGY_RECOVERY_DB.DYNAMICS_CRM.OPPORTUNITIES
      PRIMARY KEY (OPPORTUNITY_ID)
      WITH SYNONYMS ('deals', 'pipeline', 'prospects')
      COMMENT = 'Sales opportunities at all stages from Qualify through Close',

    accounts AS ENERGY_RECOVERY_DB.DYNAMICS_CRM.ACCOUNTS
      PRIMARY KEY (ACCOUNT_ID)
      WITH SYNONYMS ('customers', 'companies', 'clients')
      COMMENT = 'Customer and prospect accounts',

    activities AS ENERGY_RECOVERY_DB.DYNAMICS_CRM.ACTIVITIES
      PRIMARY KEY (ACTIVITY_ID)
      WITH SYNONYMS ('engagements', 'interactions', 'touchpoints')
      COMMENT = 'Sales activities: emails, calls, meetings, demos, site visits'
  )

  RELATIONSHIPS (
    opportunities_to_accounts AS
      opportunities (ACCOUNT_ID) REFERENCES accounts (ACCOUNT_ID),
    activities_to_accounts AS
      activities (ACCOUNT_ID) REFERENCES accounts (ACCOUNT_ID)
  )

  FACTS (
    opportunities.deal_amount AS AMOUNT
      COMMENT = 'Opportunity value in USD',
    opportunities.win_probability AS PROBABILITY
      COMMENT = 'Probability of winning (0-100%)',
    opportunities.weighted_value AS AMOUNT * PROBABILITY / 100
      COMMENT = 'Probability-weighted deal value',
    accounts.annual_revenue_fact AS ANNUAL_REVENUE
      COMMENT = 'Account annual revenue',
    accounts.employee_count_fact AS EMPLOYEE_COUNT
      COMMENT = 'Number of employees at account',
    activities.duration_fact AS DURATION_MINUTES
      COMMENT = 'Activity duration in minutes'
  )

  DIMENSIONS (
    opportunities.stage AS STAGE
      WITH SYNONYMS ('pipeline stage', 'deal stage', 'phase')
      COMMENT = 'Sales stage: Qualify, Develop, Propose, Negotiate, Close Won, Close Lost'
      SAMPLE_VALUES ('Qualify', 'Develop', 'Propose', 'Negotiate', 'Close Won', 'Close Lost')
      IS_ENUM,
    opportunities.product_interest AS PRODUCT_INTEREST
      WITH SYNONYMS ('product', 'solution')
      COMMENT = 'Product the customer is interested in'
      SAMPLE_VALUES ('PX Pressure Exchanger', 'PX Q650', 'PX G1300', 'Aftermarket Services', 'Wastewater PX')
      IS_ENUM,
    opportunities.application AS APPLICATION
      WITH SYNONYMS ('use case', 'industry application')
      COMMENT = 'Target application'
      SAMPLE_VALUES ('Desalination', 'Wastewater', 'CO2 Refrigeration')
      IS_ENUM,
    opportunities.opp_region AS REGION
      WITH SYNONYMS ('territory', 'geography')
      COMMENT = 'Opportunity region'
      SAMPLE_VALUES ('MENA', 'Asia-Pacific', 'Europe', 'Americas', 'Africa')
      IS_ENUM,
    opportunities.sales_rep_dim AS SALES_REP
      WITH SYNONYMS ('rep', 'salesperson', 'owner')
      COMMENT = 'Sales representative owning the opportunity',
    opportunities.lead_source AS LEAD_SOURCE
      COMMENT = 'How the lead was generated'
      SAMPLE_VALUES ('Trade Show', 'Referral', 'Web Inquiry', 'Existing Customer', 'Partner')
      IS_ENUM,
    opportunities.competitor_dim AS COMPETITOR
      COMMENT = 'Primary competitor on the deal'
      SAMPLE_VALUES ('Danfoss', 'Flowserve', 'Sulzer'),
    opportunities.close_date_dim AS CLOSE_DATE
      COMMENT = 'Expected or actual close date',
    opportunities.close_year AS YEAR(CLOSE_DATE)
      COMMENT = 'Expected close year',
    opportunities.close_quarter AS QUARTER(CLOSE_DATE)
      COMMENT = 'Expected close quarter',
    opportunities.loss_reason_dim AS LOSS_REASON
      COMMENT = 'Reason for lost deals',
    accounts.account_name_dim AS ACCOUNT_NAME
      WITH SYNONYMS ('company name', 'customer name')
      COMMENT = 'Account name',
    accounts.industry AS INDUSTRY
      COMMENT = 'Account industry segment'
      SAMPLE_VALUES ('Water & Desalination', 'Utilities', 'Industrial Manufacturing', 'Oil & Gas', 'Food & Beverage', 'Refrigeration & HVAC')
      IS_ENUM,
    accounts.account_type AS ACCOUNT_TYPE
      COMMENT = 'Account type: Customer, Prospect, Partner'
      SAMPLE_VALUES ('Customer', 'Prospect', 'Partner')
      IS_ENUM,
    accounts.account_tier AS ACCOUNT_TIER
      COMMENT = 'Account tier: Tier 1, Tier 2, Tier 3'
      SAMPLE_VALUES ('Tier 1', 'Tier 2', 'Tier 3')
      IS_ENUM,
    accounts.account_region AS REGION
      COMMENT = 'Account region',
    accounts.account_country AS COUNTRY
      COMMENT = 'Account country',
    activities.activity_type AS ACTIVITY_TYPE
      COMMENT = 'Type of sales activity'
      SAMPLE_VALUES ('Email', 'Call', 'Meeting', 'Demo', 'Site Visit')
      IS_ENUM,
    activities.activity_status AS STATUS
      COMMENT = 'Activity status'
      SAMPLE_VALUES ('Completed', 'Scheduled', 'Cancelled')
      IS_ENUM
  )

  METRICS (
    opportunities.total_pipeline AS SUM(opportunities.deal_amount)
      WITH SYNONYMS ('pipeline value', 'total deals', 'pipeline size')
      COMMENT = 'Total pipeline value across all opportunities',
    opportunities.weighted_pipeline AS SUM(opportunities.weighted_value)
      WITH SYNONYMS ('expected revenue', 'forecast')
      COMMENT = 'Probability-weighted pipeline value',
    opportunities.opportunity_count AS COUNT(OPPORTUNITY_ID)
      WITH SYNONYMS ('deal count', 'number of deals')
      COMMENT = 'Number of opportunities',
    opportunities.avg_deal_size AS AVG(opportunities.deal_amount)
      WITH SYNONYMS ('average deal value', 'average opportunity size')
      COMMENT = 'Average deal value',
    opportunities.win_rate AS AVG(CASE WHEN STAGE = 'Close Won' THEN 100.0 WHEN STAGE = 'Close Lost' THEN 0.0 END)
      WITH SYNONYMS ('close rate', 'conversion rate')
      COMMENT = 'Win rate percentage for closed opportunities',
    accounts.account_count AS COUNT(ACCOUNT_ID)
      COMMENT = 'Number of accounts',
    activities.activity_count AS COUNT(ACTIVITY_ID)
      WITH SYNONYMS ('engagements', 'touchpoints')
      COMMENT = 'Number of sales activities'
  )

  AI_SQL_GENERATION 'For pipeline analysis, exclude Close Won and Close Lost stages unless specifically asked about win rates or historical performance. When calculating win rate, only consider opportunities in Close Won or Close Lost stages. For forecast questions, use weighted pipeline (amount * probability). Always include stage breakdown when showing pipeline data.'

  AI_QUESTION_CATEGORIZATION 'This view handles questions about sales pipeline, opportunities, accounts, win rates, CRM activities, and customer relationships for Energy Recovery. Questions about financial actuals or device IoT data should be directed to other tools.'

  COMMENT = 'CRM and sales pipeline semantic view for Energy Recovery - covers opportunities, accounts, and activities from Microsoft Dynamics CRM';

-- ============================================================================
-- SEMANTIC VIEW 3: IoT Device Performance
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_IOT_PERFORMANCE

  TABLES (
    devices AS ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_REGISTRY
      PRIMARY KEY (DEVICE_ID)
      WITH SYNONYMS ('PX devices', 'equipment', 'installed base', 'units')
      COMMENT = '42,000+ PX Pressure Exchanger devices installed globally',

    telemetry AS ENERGY_RECOVERY_DB.SCADA_IOT.DEVICE_TELEMETRY
      PRIMARY KEY (TELEMETRY_ID)
      WITH SYNONYMS ('sensor data', 'readings', 'measurements', 'IoT data')
      COMMENT = 'Real-time telemetry from PX devices: pressure, flow, vibration, temperature, efficiency',

    alarms AS ENERGY_RECOVERY_DB.SCADA_IOT.ALARMS
      PRIMARY KEY (ALARM_ID)
      WITH SYNONYMS ('alerts', 'warnings', 'notifications')
      COMMENT = 'Device alarms and alerts with severity levels',

    maintenance AS ENERGY_RECOVERY_DB.SCADA_IOT.MAINTENANCE_LOGS
      PRIMARY KEY (MAINTENANCE_ID)
      WITH SYNONYMS ('service', 'repairs', 'work orders')
      COMMENT = 'Maintenance history: preventive, corrective, predictive, emergency'
  )

  RELATIONSHIPS (
    telemetry_to_devices AS
      telemetry (DEVICE_ID) REFERENCES devices (DEVICE_ID),
    alarms_to_devices AS
      alarms (DEVICE_ID) REFERENCES devices (DEVICE_ID),
    maintenance_to_devices AS
      maintenance (DEVICE_ID) REFERENCES devices (DEVICE_ID)
  )

  FACTS (
    telemetry.energy_recovery_reading AS ENERGY_RECOVERY_PCT
      COMMENT = 'Energy recovery efficiency percentage per reading',
    telemetry.vibration_reading AS VIBRATION_MM_S
      COMMENT = 'Vibration level in mm/s',
    telemetry.pressure_diff_reading AS PRESSURE_DIFFERENTIAL
      COMMENT = 'Pressure differential across the PX device in bar',
    telemetry.flow_reading AS FLOW_RATE_M3H
      COMMENT = 'Flow rate in cubic meters per hour',
    telemetry.temperature_reading AS TEMPERATURE_C
      COMMENT = 'Operating temperature in Celsius',
    telemetry.rotor_speed_reading AS ROTOR_SPEED_RPM
      COMMENT = 'Rotor speed in RPM',
    devices.operating_hours_fact AS OPERATING_HOURS
      COMMENT = 'Total operating hours since commissioning',
    maintenance.labor_hours_fact AS LABOR_HOURS
      COMMENT = 'Labor hours spent on maintenance',
    maintenance.parts_cost_fact AS PARTS_COST
      COMMENT = 'Cost of replacement parts',
    maintenance.total_cost_fact AS TOTAL_COST
      COMMENT = 'Total maintenance cost (parts + labor)',
    maintenance.downtime_fact AS DOWNTIME_HOURS
      COMMENT = 'Hours of downtime during maintenance'
  )

  DIMENSIONS (
    devices.device_model AS DEVICE_MODEL
      WITH SYNONYMS ('model', 'PX model', 'product model')
      COMMENT = 'PX device model'
      SAMPLE_VALUES ('PX-Q650', 'PX-Q400', 'PX-220', 'PX-G1300')
      IS_ENUM,
    devices.product_line_dim AS PRODUCT_LINE
      COMMENT = 'Product line'
      SAMPLE_VALUES ('Desalination', 'Wastewater', 'Refrigeration')
      IS_ENUM,
    devices.installation_site_dim AS INSTALLATION_SITE
      WITH SYNONYMS ('plant', 'facility', 'location')
      COMMENT = 'Name of the installation site/plant',
    devices.site_country_dim AS SITE_COUNTRY
      WITH SYNONYMS ('country')
      COMMENT = 'Country where device is installed',
    devices.site_region_dim AS SITE_REGION
      WITH SYNONYMS ('region')
      COMMENT = 'Geographic region'
      SAMPLE_VALUES ('MENA', 'Asia-Pacific', 'Europe', 'Americas')
      IS_ENUM,
    devices.customer_name_dim AS CUSTOMER_NAME
      COMMENT = 'Customer who owns/operates the device',
    devices.device_status AS STATUS
      COMMENT = 'Device operational status'
      SAMPLE_VALUES ('Active', 'Maintenance', 'Standby', 'Decommissioned')
      IS_ENUM,
    telemetry.operating_mode_dim AS OPERATING_MODE
      COMMENT = 'Current operating mode'
      SAMPLE_VALUES ('Normal', 'High Load', 'Low Load', 'Standby', 'Startup')
      IS_ENUM,
    telemetry.reading_date_dim AS READING_DATE
      COMMENT = 'Date of telemetry reading',
    alarms.alarm_severity_dim AS ALARM_SEVERITY
      WITH SYNONYMS ('severity', 'priority')
      COMMENT = 'Alarm severity level'
      SAMPLE_VALUES ('Critical', 'High', 'Medium', 'Low', 'Info')
      IS_ENUM,
    alarms.alarm_type_dim AS ALARM_TYPE
      COMMENT = 'Type of alarm'
      SAMPLE_VALUES ('Vibration', 'Pressure', 'Temperature', 'Flow', 'Efficiency', 'Mechanical', 'Seal Integrity')
      IS_ENUM,
    maintenance.maintenance_type_dim AS MAINTENANCE_TYPE
      COMMENT = 'Type of maintenance performed'
      SAMPLE_VALUES ('Preventive', 'Corrective', 'Predictive', 'Emergency')
      IS_ENUM,
    maintenance.failure_mode_dim AS FAILURE_MODE
      COMMENT = 'Failure mode that triggered maintenance'
      SAMPLE_VALUES ('Seal wear', 'Bearing failure', 'Normal wear', 'Vibration anomaly', 'Efficiency degradation')
      IS_ENUM,
    maintenance.maintenance_status AS MAINTENANCE_STATUS
      COMMENT = 'Maintenance work order status'
      SAMPLE_VALUES ('Planned', 'In Progress', 'Completed', 'Cancelled')
      IS_ENUM
  )

  METRICS (
    telemetry.avg_energy_recovery AS AVG(telemetry.energy_recovery_reading)
      WITH SYNONYMS ('average efficiency', 'mean efficiency', 'avg recovery')
      COMMENT = 'Average energy recovery efficiency percentage',
    telemetry.avg_vibration AS AVG(telemetry.vibration_reading)
      COMMENT = 'Average vibration level in mm/s',
    telemetry.avg_flow_rate AS AVG(telemetry.flow_reading)
      COMMENT = 'Average flow rate in m³/h',
    telemetry.avg_pressure_differential AS AVG(telemetry.pressure_diff_reading)
      COMMENT = 'Average pressure differential in bar',
    telemetry.reading_count AS COUNT(TELEMETRY_ID)
      COMMENT = 'Number of telemetry readings',
    devices.device_count AS COUNT(DEVICE_ID)
      WITH SYNONYMS ('installed base', 'unit count', 'fleet size')
      COMMENT = 'Number of devices',
    devices.avg_operating_hours AS AVG(devices.operating_hours_fact)
      COMMENT = 'Average operating hours across devices',
    alarms.alarm_count AS COUNT(ALARM_ID)
      WITH SYNONYMS ('alert count', 'number of alarms')
      COMMENT = 'Number of alarms triggered',
    maintenance.maintenance_count AS COUNT(MAINTENANCE_ID)
      WITH SYNONYMS ('service count', 'work order count')
      COMMENT = 'Number of maintenance events',
    maintenance.total_maintenance_cost AS SUM(maintenance.total_cost_fact)
      WITH SYNONYMS ('service cost', 'repair cost')
      COMMENT = 'Total maintenance cost',
    maintenance.total_downtime AS SUM(maintenance.downtime_fact)
      WITH SYNONYMS ('downtime hours', 'lost production hours')
      COMMENT = 'Total downtime hours from maintenance',
    maintenance.avg_maintenance_cost AS AVG(maintenance.total_cost_fact)
      COMMENT = 'Average cost per maintenance event'
  )

  AI_SQL_GENERATION 'Energy Recovery has 42,000+ PX devices installed globally. Normal energy recovery efficiency is 95-98%. Vibration above 5.0 mm/s indicates potential bearing issues. Temperature above 40°C is elevated. When asked about devices at risk, look for high vibration, low efficiency, or elevated temperature. For uptime calculations, consider Active status devices and factor in downtime hours from maintenance logs.'

  AI_QUESTION_CATEGORIZATION 'This view handles questions about PX device performance, IoT telemetry, alarms, maintenance history, equipment health, energy efficiency, and the installed base. Questions about financial data or CRM pipeline should be directed to other tools.'

  COMMENT = 'IoT device performance semantic view for Energy Recovery - covers 42,000+ PX devices with telemetry, alarms, and maintenance data from SCADA systems';
