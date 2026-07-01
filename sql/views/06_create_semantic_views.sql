-- =====================================================
-- Kraken Intelligence Agent
-- Step 6: Semantic Views for Cortex Analyst
-- =====================================================

USE DATABASE KRAKEN_DB;
USE SCHEMA ANALYTICS;
USE WAREHOUSE KRAKEN_WH;

-- =====================================================
-- KRAKEN_TRADING_SV - Trading and market semantic view
-- Covers: Trades, Orders, Market Data, Revenue
-- =====================================================
CREATE OR REPLACE SEMANTIC VIEW KRAKEN_TRADING_SV
  COMMENT = 'Semantic view for Kraken trading operations. Covers spot/margin trades, orders, market prices, fees, and revenue analysis. Use for questions about trading volume, revenue, market performance, and customer trading behavior.'
AS
SELECT
    -- Trade dimensions
    T.TRADE_ID
        COMMENT 'Unique trade identifier',
    T.CUSTOMER_ID
        COMMENT 'Customer who executed the trade',
    T.TRADING_PAIR
        WITH SYNONYMS ('pair', 'market', 'symbol', 'asset pair', 'crypto pair')
        COMMENT 'Trading pair like BTC/USD or ETH/EUR',
    T.TRADE_TYPE
        WITH SYNONYMS ('type', 'spot or margin')
        COMMENT 'Whether trade is Spot or Margin',
    T.SIDE
        WITH SYNONYMS ('buy or sell', 'direction')
        COMMENT 'Trade side: Buy or Sell',
    T.ORDER_TYPE
        WITH SYNONYMS ('order kind')
        COMMENT 'Order type: Market, Limit, StopLoss, TakeProfit',
    T.PLATFORM
        WITH SYNONYMS ('app', 'channel', 'interface')
        COMMENT 'Platform used: Web, Mobile, API, or Pro',
    T.SETTLEMENT_STATUS
        WITH SYNONYMS ('settlement', 'trade status')
        COMMENT 'Settlement status: Settled, Pending, Failed',
    DATE_TRUNC('day', T.EXECUTED_AT) AS TRADE_DATE
        WITH SYNONYMS ('date', 'when', 'day')
        COMMENT 'Date the trade was executed',
    -- Trade metrics
    T.PRICE
        WITH SYNONYMS ('execution price', 'trade price')
        COMMENT 'Price at which the trade was executed',
    T.QUANTITY
        WITH SYNONYMS ('amount', 'size', 'units')
        COMMENT 'Quantity of asset traded',
    T.TOTAL_VALUE_USD
        WITH SYNONYMS ('trade value', 'notional', 'volume', 'dollar amount')
        COMMENT 'Total trade value in USD (price x quantity)',
    T.FEE_USD
        WITH SYNONYMS ('fee', 'commission', 'trading fee', 'revenue')
        COMMENT 'Fee charged for the trade in USD',
    T.FEE_RATE
        WITH SYNONYMS ('fee percentage', 'fee rate', 'commission rate')
        COMMENT 'Fee rate as a decimal (0.0026 = 0.26%)',
    T.LEVERAGE
        WITH SYNONYMS ('margin leverage', 'multiplier')
        COMMENT 'Leverage used (1.0 for spot, up to 5x for margin)',
    -- Customer context
    C.ACCOUNT_TIER
        WITH SYNONYMS ('tier', 'customer tier', 'membership level')
        COMMENT 'Customer tier: Standard, Pro, VIP, or Institutional',
    C.COUNTRY_CODE
        WITH SYNONYMS ('country', 'region', 'geography')
        COMMENT 'Customer country code'
FROM KRAKEN_DB.RAW.TRADES T
JOIN KRAKEN_DB.RAW.CUSTOMERS C ON T.CUSTOMER_ID = C.CUSTOMER_ID;

-- =====================================================
-- KRAKEN_OPERATIONS_SV - Support and Compliance view
-- Covers: Support Tickets, Compliance Events, Customer data
-- =====================================================
CREATE OR REPLACE SEMANTIC VIEW KRAKEN_OPERATIONS_SV
  COMMENT = 'Semantic view for Kraken operations. Covers customer support tickets, compliance events, AML monitoring, and customer satisfaction. Use for questions about support performance, compliance risk, SLAs, and customer issues.'
AS
SELECT
    -- Ticket dimensions
    ST.TICKET_ID
        COMMENT 'Unique support ticket identifier',
    ST.CUSTOMER_ID
        COMMENT 'Customer who submitted the ticket',
    ST.CATEGORY
        WITH SYNONYMS ('ticket type', 'issue category', 'problem type')
        COMMENT 'Ticket category: Withdrawals, Trading, Account, Security, etc.',
    ST.SUBCATEGORY
        WITH SYNONYMS ('sub-category', 'specific issue')
        COMMENT 'Specific subcategory of the issue',
    ST.PRIORITY
        WITH SYNONYMS ('urgency', 'severity')
        COMMENT 'Ticket priority: Critical, High, Medium, Low',
    ST.STATUS AS TICKET_STATUS
        WITH SYNONYMS ('ticket status', 'state')
        COMMENT 'Current status: Open, In Progress, Waiting, Resolved, Closed',
    ST.SUBJECT
        WITH SYNONYMS ('title', 'summary', 'issue title')
        COMMENT 'Brief subject line of the support ticket',
    ST.ASSIGNED_TEAM
        WITH SYNONYMS ('team', 'support team', 'handler')
        COMMENT 'Team handling the ticket: Tier1, Tier2, Tier3, Compliance, Engineering',
    ST.PLATFORM AS TICKET_PLATFORM
        WITH SYNONYMS ('channel', 'contact method')
        COMMENT 'How the ticket was submitted: Web, Email, Chat, Phone',
    DATE_TRUNC('day', ST.CREATED_AT) AS TICKET_DATE
        WITH SYNONYMS ('date', 'when opened', 'created date')
        COMMENT 'Date the ticket was created',
    -- Ticket metrics
    ST.FIRST_RESPONSE_MINUTES
        WITH SYNONYMS ('first response time', 'FRT', 'response time')
        COMMENT 'Minutes until first agent response',
    ST.RESOLUTION_MINUTES
        WITH SYNONYMS ('resolution time', 'time to resolve', 'TTR')
        COMMENT 'Total minutes from creation to resolution',
    ST.SATISFACTION_SCORE
        WITH SYNONYMS ('CSAT', 'satisfaction', 'customer rating', 'score')
        COMMENT 'Customer satisfaction rating 1-5',
    -- Compliance dimensions
    CE.EVENT_ID AS COMPLIANCE_EVENT_ID
        COMMENT 'Unique compliance event identifier',
    CE.EVENT_TYPE AS COMPLIANCE_EVENT_TYPE
        WITH SYNONYMS ('alert type', 'compliance type', 'AML type')
        COMMENT 'Type of compliance event: SAR_Filed, Large_Transaction, Velocity_Alert, etc.',
    CE.RISK_SCORE
        WITH SYNONYMS ('risk score', 'AML score', 'compliance score')
        COMMENT 'Numerical risk score 0-100',
    CE.RISK_LEVEL
        WITH SYNONYMS ('risk level', 'severity', 'risk category')
        COMMENT 'Risk classification: Low, Medium, High, Critical',
    CE.IS_FLAGGED
        WITH SYNONYMS ('flagged', 'suspicious', 'alert')
        COMMENT 'Whether the event was flagged for review',
    CE.REVIEW_STATUS
        WITH SYNONYMS ('compliance status', 'review state')
        COMMENT 'Review status: Pending, Under Review, Escalated, Cleared, Confirmed',
    CE.JURISDICTION
        WITH SYNONYMS ('regulatory region', 'compliance region')
        COMMENT 'Regulatory jurisdiction of the compliance event',
    CE.REGULATORY_REPORT_FILED
        WITH SYNONYMS ('SAR filed', 'report filed', 'regulatory filing')
        COMMENT 'Whether a regulatory report was filed for this event',
    -- Customer context
    C.ACCOUNT_TIER AS CUSTOMER_TIER
        WITH SYNONYMS ('tier', 'customer level')
        COMMENT 'Customer account tier',
    C.KYC_STATUS
        WITH SYNONYMS ('verification status', 'identity status')
        COMMENT 'KYC verification status'
FROM KRAKEN_DB.RAW.SUPPORT_TICKETS ST
FULL OUTER JOIN KRAKEN_DB.RAW.COMPLIANCE_EVENTS CE ON ST.CUSTOMER_ID = CE.CUSTOMER_ID
JOIN KRAKEN_DB.RAW.CUSTOMERS C ON COALESCE(ST.CUSTOMER_ID, CE.CUSTOMER_ID) = C.CUSTOMER_ID;

-- =====================================================
-- DLT_BLOCKCHAIN_ONTOLOGY_SV - Blockchain knowledge view
-- Covers: Blockchain structure, consensus, tokens, nodes
-- =====================================================
CREATE OR REPLACE SEMANTIC VIEW DLT_BLOCKCHAIN_ONTOLOGY_SV
  COMMENT = 'Semantic view implementing ISO/TS 23258 DLT/Blockchain ontology. Covers blockchain networks, consensus mechanisms, blocks, transactions, tokens, and validator nodes. Use for questions about blockchain technology, supported chains, and on-chain data.'
AS
SELECT
    B.BLOCKCHAIN_ID
        COMMENT 'Unique identifier for the blockchain network',
    B.NAME AS BLOCKCHAIN_NAME
        WITH SYNONYMS ('chain', 'network', 'blockchain', 'protocol')
        COMMENT 'Name of the blockchain (Bitcoin, Ethereum, Solana, etc.)',
    B.CHAIN_TYPE
        WITH SYNONYMS ('type', 'network type', 'public or private')
        COMMENT 'Chain type: Public, Private, or Consortium',
    B.CONSENSUS_MECHANISM AS CONSENSUS_NAME
        WITH SYNONYMS ('consensus', 'consensus algorithm', 'validation method')
        COMMENT 'Consensus mechanism used (PoW, PoS, BFT, etc.)',
    B.IS_ACTIVE AS CHAIN_IS_ACTIVE
        COMMENT 'Whether the blockchain is currently active',
    -- Token info
    TK.TOKEN_SYMBOL
        WITH SYNONYMS ('symbol', 'ticker', 'coin')
        COMMENT 'Token ticker symbol (BTC, ETH, SOL, etc.)',
    TK.TOKEN_NAME
        WITH SYNONYMS ('token', 'asset', 'cryptocurrency', 'coin name')
        COMMENT 'Full name of the token',
    TK.TOKEN_TYPE
        WITH SYNONYMS ('token standard', 'asset type')
        COMMENT 'Token type: Native, Fungible (ERC-20), Non-Fungible (ERC-721)',
    TK.TOTAL_SUPPLY
        WITH SYNONYMS ('supply', 'max supply', 'circulating supply')
        COMMENT 'Total token supply (NULL if unlimited)',
    -- Block info
    BL.BLOCK_NUMBER
        WITH SYNONYMS ('block height', 'height')
        COMMENT 'Block number/height in the chain',
    BL.BLOCK_HASH
        WITH SYNONYMS ('hash')
        COMMENT 'Cryptographic hash of the block',
    BL.TRANSACTION_COUNT AS BLOCK_TX_COUNT
        WITH SYNONYMS ('transactions in block', 'tx count')
        COMMENT 'Number of transactions in the block',
    BL.STATUS AS BLOCK_STATUS
        WITH SYNONYMS ('block status', 'confirmation')
        COMMENT 'Block status: Confirmed, Validated, Pending',
    BL.IS_GENESIS
        COMMENT 'Whether this is the genesis (first) block',
    -- Node info
    N.NODE_TYPE
        WITH SYNONYMS ('validator type', 'node kind')
        COMMENT 'Type of network node: Validator, Miner, Full Node, Light Node',
    N.STAKE_AMOUNT
        WITH SYNONYMS ('staked', 'validator stake')
        COMMENT 'Amount staked by the node/validator',
    N.IS_ACTIVE AS NODE_IS_ACTIVE
        COMMENT 'Whether the node is currently active'
FROM KRAKEN_DB.ONTOLOGY.BLOCKCHAIN B
LEFT JOIN KRAKEN_DB.ONTOLOGY.TOKEN TK ON B.BLOCKCHAIN_ID = TK.BLOCKCHAIN_ID
LEFT JOIN KRAKEN_DB.ONTOLOGY.BLOCK BL ON B.BLOCKCHAIN_ID = BL.BLOCKCHAIN_ID
LEFT JOIN KRAKEN_DB.ONTOLOGY.DLT_NODE N ON B.BLOCKCHAIN_ID = N.BLOCKCHAIN_ID;

SELECT 'Step 6 Complete: Semantic views created (KRAKEN_TRADING_SV, KRAKEN_OPERATIONS_SV, DLT_BLOCKCHAIN_ONTOLOGY_SV).' AS STATUS;
