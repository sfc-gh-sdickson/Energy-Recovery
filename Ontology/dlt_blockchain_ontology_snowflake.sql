-- =====================================================
-- DLT / Blockchain Ontology for Snowflake Agentic Demo
-- Based on ISO/TS 23258:2021 Taxonomy and Ontology
-- Designed for Snowflake Cortex Agents + Semantic Views
-- =====================================================

-- Create Database and Schema (adjust as needed)
CREATE DATABASE IF NOT EXISTS DLT_ONTOLOGY_DEMO;
USE DATABASE DLT_ONTOLOGY_DEMO;
CREATE SCHEMA IF NOT EXISTS CORE;
USE SCHEMA CORE;

-- =====================================================
-- PHYSICAL TABLES (Relational Foundation - Layer 1-2)
-- =====================================================

-- Blockchain / Ledger entities
CREATE OR REPLACE TABLE BLOCKCHAIN (
    BLOCKCHAIN_ID STRING PRIMARY KEY,
    NAME STRING NOT NULL,                    -- e.g., 'Ethereum', 'Bitcoin'
    CHAIN_TYPE STRING,                       -- 'Public', 'Private', 'Consortium'
    CONSENSUS_MECHANISM STRING,              -- e.g., 'Proof of Stake', 'Proof of Work'
    CREATION_DATE TIMESTAMP,
    DESCRIPTION STRING,
    IS_ACTIVE BOOLEAN DEFAULT TRUE
);

CREATE OR REPLACE TABLE DISTRIBUTED_LEDGER (
    LEDGER_ID STRING PRIMARY KEY,
    BLOCKCHAIN_ID STRING REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    LEDGER_TYPE STRING,                      -- 'Distributed Ledger', 'Shared Ledger'
    CONTROL_ARCHITECTURE STRING,
    PRIVILEGE_MODEL STRING,
    STORAGE_ARCHITECTURE STRING
);

-- Block entity (core from ISO ontology)
CREATE OR REPLACE TABLE BLOCK (
    BLOCK_ID STRING PRIMARY KEY,
    BLOCKCHAIN_ID STRING REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    BLOCK_NUMBER BIGINT NOT NULL,            -- Block Height
    BLOCK_HASH STRING NOT NULL UNIQUE,
    PREVIOUS_BLOCK_HASH STRING,
    MERKLE_ROOT STRING,
    NONCE STRING,
    TIMESTAMP TIMESTAMP NOT NULL,
    BLOCK_SIZE_BYTES BIGINT,
    TRANSACTION_COUNT INT,
    STATUS STRING DEFAULT 'Confirmed',       -- Confirmed, Validated, Pending
    IS_GENESIS BOOLEAN DEFAULT FALSE
);

-- Transaction (implied in taxonomy, core to blocks)
CREATE OR REPLACE TABLE TRANSACTION (
    TRANSACTION_ID STRING PRIMARY KEY,
    BLOCK_ID STRING REFERENCES BLOCK(BLOCK_ID),
    TX_HASH STRING NOT NULL UNIQUE,
    FROM_ADDRESS STRING,
    TO_ADDRESS STRING,
    VALUE DECIMAL(38,18),                    -- In native token units
    FEE DECIMAL(38,18),
    TIMESTAMP TIMESTAMP,
    STATUS STRING,
    TX_TYPE STRING                           -- 'Transfer', 'Smart Contract Call', etc.
);

-- Node / Validator
CREATE OR REPLACE TABLE DLT_NODE (
    NODE_ID STRING PRIMARY KEY,
    BLOCKCHAIN_ID STRING REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    NODE_TYPE STRING,                        -- 'Validator', 'Miner', 'Full Node', 'Light Node'
    ADDRESS STRING,
    STAKE_AMOUNT DECIMAL(38,18),             -- For PoS
    IS_ACTIVE BOOLEAN DEFAULT TRUE,
    LAST_SEEN TIMESTAMP
);

-- Consensus Mechanism (from taxonomy)
CREATE OR REPLACE TABLE CONSENSUS_MECHANISM (
    CONSENSUS_ID STRING PRIMARY KEY,
    NAME STRING NOT NULL,                    -- 'Proof of Work (PoW)', 'Proof of Stake (PoS)', 'BFT'
    DESCRIPTION STRING,
    ENERGY_EFFICIENCY STRING,
    SECURITY_MODEL STRING,
    FINALITY_TYPE STRING                     -- 'Probabilistic', 'Deterministic'
);

-- Smart Contract (from taxonomy)
CREATE OR REPLACE TABLE SMART_CONTRACT (
    CONTRACT_ID STRING PRIMARY KEY,
    BLOCKCHAIN_ID STRING REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    CONTRACT_ADDRESS STRING NOT NULL UNIQUE,
    NAME STRING,
    CONTRACT_TYPE STRING,                    -- 'Stateful', 'Stateless'
    DEPLOYMENT_BLOCK_ID STRING REFERENCES BLOCK(BLOCK_ID),
    ABI STRING,                              -- JSON ABI or simplified
    IS_VERIFIED BOOLEAN DEFAULT FALSE,
    CREATION_TIMESTAMP TIMESTAMP
);

-- Asset / Token (from taxonomy - Cryptocurrency, Token)
CREATE OR REPLACE TABLE TOKEN (
    TOKEN_ID STRING PRIMARY KEY,
    BLOCKCHAIN_ID STRING REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    TOKEN_SYMBOL STRING NOT NULL,
    TOKEN_NAME STRING,
    TOKEN_TYPE STRING,                       -- 'Native', 'Fungible (ERC-20)', 'Non-Fungible (ERC-721)'
    TOTAL_SUPPLY DECIMAL(38,18),
    DECIMALS INT DEFAULT 18,
    CONTRACT_ADDRESS STRING                  -- For non-native tokens
);

-- =====================================================
-- RELATIONSHIPS / JUNCTION TABLES (for many-to-many)
-- =====================================================

CREATE OR REPLACE TABLE BLOCKCHAIN_CONSENSUS (
    BLOCKCHAIN_ID STRING REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    CONSENSUS_ID STRING REFERENCES CONSENSUS_MECHANISM(CONSENSUS_ID),
    PRIMARY KEY (BLOCKCHAIN_ID, CONSENSUS_ID)
);

-- =====================================================
-- SEMANTIC VIEW for Cortex Analyst / Agents (Layer 4)
-- This exposes the ontology in business-friendly terms
-- =====================================================

CREATE OR REPLACE SEMANTIC VIEW DLT_BLOCKCHAIN_ONTOLOGY_SV
TABLES (
    BLOCKCHAIN primary key (BLOCKCHAIN_ID),
    BLOCK primary key (BLOCK_ID) with foreign key (BLOCKCHAIN_ID) references BLOCKCHAIN(BLOCKCHAIN_ID),
    TRANSACTION primary key (TRANSACTION_ID) with foreign key (BLOCK_ID) references BLOCK(BLOCK_ID),
    DLT_NODE primary key (NODE_ID) with foreign key (BLOCKCHAIN_ID) references BLOCKCHAIN(BLOCKCHAIN_ID),
    SMART_CONTRACT primary key (CONTRACT_ID) with foreign key (BLOCKCHAIN_ID) references BLOCKCHAIN(BLOCKCHAIN_ID),
    TOKEN primary key (TOKEN_ID) with foreign key (BLOCKCHAIN_ID) references BLOCKCHAIN(BLOCKCHAIN_ID),
    CONSENSUS_MECHANISM primary key (CONSENSUS_ID)
)
RELATIONSHIPS (
    BLOCKCHAIN_HAS_BLOCKS as BLOCKCHAIN to BLOCK on BLOCKCHAIN_ID,
    BLOCK_HAS_TRANSACTIONS as BLOCK to TRANSACTION on BLOCK_ID,
    BLOCKCHAIN_HAS_NODES as BLOCKCHAIN to DLT_NODE on BLOCKCHAIN_ID,
    BLOCKCHAIN_HAS_CONTRACTS as BLOCKCHAIN to SMART_CONTRACT on BLOCKCHAIN_ID,
    BLOCKCHAIN_HAS_TOKENS as BLOCKCHAIN to TOKEN on BLOCKCHAIN_ID,
    BLOCKCHAIN_USES_CONSENSUS as BLOCKCHAIN to CONSENSUS_MECHANISM via BLOCKCHAIN_CONSENSUS
)
METRICS (
    TOTAL_BLOCKS as COUNT(BLOCK.BLOCK_ID),
    AVG_BLOCK_TIME_SECONDS as AVG(DATEDIFF('second', LAG(BLOCK.TIMESTAMP) OVER (PARTITION BY BLOCK.BLOCKCHAIN_ID ORDER BY BLOCK.BLOCK_NUMBER), BLOCK.TIMESTAMP)),
    TOTAL_TRANSACTIONS as COUNT(TRANSACTION.TRANSACTION_ID),
    TOTAL_VALUE_TRANSFERRED as SUM(TRANSACTION.VALUE),
    ACTIVE_VALIDATORS as COUNT(DISTINCT DLT_NODE.NODE_ID) WHERE DLT_NODE.IS_ACTIVE = TRUE
)
DIMENSIONS (
    BLOCKCHAIN_NAME as BLOCKCHAIN.NAME,
    BLOCK_STATUS as BLOCK.STATUS,
    TOKEN_SYMBOL as TOKEN.TOKEN_SYMBOL,
    CONSENSUS_NAME as CONSENSUS_MECHANISM.NAME,
    TX_TYPE as TRANSACTION.TX_TYPE
)
COMMENT = 'Semantic view implementing ISO/TS 23258 DLT/Blockchain ontology for Snowflake Cortex Agents. Enables natural language queries over blockchain structure, blocks, transactions, consensus, and tokens.';

-- =====================================================
-- SAMPLE DATA for Demo (Bitcoin + Ethereum-like)
-- =====================================================

INSERT INTO BLOCKCHAIN (BLOCKCHAIN_ID, NAME, CHAIN_TYPE, CONSENSUS_MECHANISM, CREATION_DATE, DESCRIPTION) VALUES
('btc', 'Bitcoin', 'Public', 'Proof of Work (PoW)', '2009-01-03', 'The original cryptocurrency blockchain'),
('eth', 'Ethereum', 'Public', 'Proof of Stake (PoS)', '2015-07-30', 'Smart contract platform, transitioned to PoS');

INSERT INTO CONSENSUS_MECHANISM (CONSENSUS_ID, NAME, DESCRIPTION, ENERGY_EFFICIENCY, SECURITY_MODEL, FINALITY_TYPE) VALUES
('pow', 'Proof of Work (PoW)', 'Miners compete to solve cryptographic puzzles', 'Low', 'Computational', 'Probabilistic'),
('pos', 'Proof of Stake (PoS)', 'Validators stake tokens to propose/validate blocks', 'High', 'Economic', 'Deterministic (with Casper)');

INSERT INTO BLOCKCHAIN_CONSENSUS VALUES ('btc', 'pow'), ('eth', 'pos');

INSERT INTO BLOCK (BLOCK_ID, BLOCKCHAIN_ID, BLOCK_NUMBER, BLOCK_HASH, PREVIOUS_BLOCK_HASH, MERKLE_ROOT, NONCE, TIMESTAMP, TRANSACTION_COUNT, STATUS, IS_GENESIS) VALUES
('btc_genesis', 'btc', 0, '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f', NULL, '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b', '2083236893', '2009-01-03 18:15:05', 1, 'Confirmed', TRUE),
('eth_recent', 'eth', 20500000, '0xabc123def456...', '0xprevhash...', '0xmerkle...', '0', CURRENT_TIMESTAMP(), 150, 'Confirmed', FALSE);

INSERT INTO TRANSACTION (TRANSACTION_ID, BLOCK_ID, TX_HASH, FROM_ADDRESS, TO_ADDRESS, VALUE, FEE, TIMESTAMP, STATUS, TX_TYPE) VALUES
('tx1', 'btc_genesis', '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b', 'Satoshi', 'Hal Finney', 50.0, 0, '2009-01-03 18:15:05', 'Confirmed', 'Coinbase'),
('tx_eth1', 'eth_recent', '0xtxhash123', '0xfrom...', '0xto...', 1.5, 0.002, CURRENT_TIMESTAMP(), 'Confirmed', 'Transfer');

INSERT INTO DLT_NODE (NODE_ID, BLOCKCHAIN_ID, NODE_TYPE, ADDRESS, IS_ACTIVE) VALUES
('node_btc_1', 'btc', 'Full Node', 'btc-node-1.example.com', TRUE),
('validator_eth_1', 'eth', 'Validator', '0xvalidator1...', TRUE);

INSERT INTO TOKEN (TOKEN_ID, BLOCKCHAIN_ID, TOKEN_SYMBOL, TOKEN_NAME, TOKEN_TYPE, TOTAL_SUPPLY, DECIMALS) VALUES
('btc_native', 'btc', 'BTC', 'Bitcoin', 'Native', 21000000, 8),
('eth_native', 'eth', 'ETH', 'Ethereum', 'Native', NULL, 18),
('usdc_eth', 'eth', 'USDC', 'USD Coin', 'Fungible (ERC-20)', 30000000000, 6);

-- Grant usage for demo (adjust roles)
-- GRANT USAGE ON DATABASE DLT_ONTOLOGY_DEMO TO ROLE PUBLIC;
-- GRANT USAGE ON SCHEMA CORE TO ROLE PUBLIC;
-- GRANT SELECT ON ALL TABLES IN SCHEMA CORE TO ROLE PUBLIC;
-- GRANT SELECT ON SEMANTIC VIEW DLT_BLOCKCHAIN_ONTOLOGY_SV TO ROLE PUBLIC;

SELECT 'DLT Blockchain Ontology for Snowflake Agentic Demo created successfully!' AS STATUS;