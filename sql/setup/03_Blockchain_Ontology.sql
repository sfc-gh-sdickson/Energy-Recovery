-- =====================================================
-- Kraken Intelligence Agent
-- Step 3: Blockchain Ontology (ISO/TS 23258:2021)
-- Based on provided DLT Ontology in /Ontology directory
-- =====================================================

USE DATABASE KRAKEN_DB;
USE SCHEMA ONTOLOGY;
USE WAREHOUSE KRAKEN_WH;

-- =====================================================
-- PHYSICAL TABLES (Relational Foundation - Layer 1-2)
-- Based on ISO/TS 23258 Taxonomy and Ontology
-- =====================================================

-- Blockchain / Ledger entities
CREATE OR REPLACE TABLE BLOCKCHAIN (
    BLOCKCHAIN_ID VARCHAR(50) PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    CHAIN_TYPE VARCHAR(20),
    CONSENSUS_MECHANISM VARCHAR(50),
    CREATION_DATE TIMESTAMP_NTZ,
    DESCRIPTION VARCHAR(500),
    IS_ACTIVE BOOLEAN DEFAULT TRUE
);

CREATE OR REPLACE TABLE DISTRIBUTED_LEDGER (
    LEDGER_ID VARCHAR(50) PRIMARY KEY,
    BLOCKCHAIN_ID VARCHAR(50) REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    LEDGER_TYPE VARCHAR(50),
    CONTROL_ARCHITECTURE VARCHAR(50),
    PRIVILEGE_MODEL VARCHAR(50),
    STORAGE_ARCHITECTURE VARCHAR(50)
);

-- Block entity (core from ISO ontology)
CREATE OR REPLACE TABLE BLOCK (
    BLOCK_ID VARCHAR(100) PRIMARY KEY,
    BLOCKCHAIN_ID VARCHAR(50) REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    BLOCK_NUMBER BIGINT NOT NULL,
    BLOCK_HASH VARCHAR(200) NOT NULL,
    PREVIOUS_BLOCK_HASH VARCHAR(200),
    MERKLE_ROOT VARCHAR(200),
    NONCE VARCHAR(50),
    TIMESTAMP TIMESTAMP_NTZ NOT NULL,
    BLOCK_SIZE_BYTES BIGINT,
    TRANSACTION_COUNT INT,
    STATUS VARCHAR(20) DEFAULT 'Confirmed',
    IS_GENESIS BOOLEAN DEFAULT FALSE
);

-- Transaction (core to blocks)
CREATE OR REPLACE TABLE BLOCK_TRANSACTION (
    TRANSACTION_ID VARCHAR(100) PRIMARY KEY,
    BLOCK_ID VARCHAR(100) REFERENCES BLOCK(BLOCK_ID),
    TX_HASH VARCHAR(200) NOT NULL,
    FROM_ADDRESS VARCHAR(200),
    TO_ADDRESS VARCHAR(200),
    VALUE DECIMAL(38,18),
    FEE DECIMAL(38,18),
    TIMESTAMP TIMESTAMP_NTZ,
    STATUS VARCHAR(20),
    TX_TYPE VARCHAR(50)
);

-- Node / Validator
CREATE OR REPLACE TABLE DLT_NODE (
    NODE_ID VARCHAR(100) PRIMARY KEY,
    BLOCKCHAIN_ID VARCHAR(50) REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    NODE_TYPE VARCHAR(50),
    ADDRESS VARCHAR(200),
    STAKE_AMOUNT DECIMAL(38,18),
    IS_ACTIVE BOOLEAN DEFAULT TRUE,
    LAST_SEEN TIMESTAMP_NTZ
);

-- Consensus Mechanism (from taxonomy)
CREATE OR REPLACE TABLE CONSENSUS_MECHANISM (
    CONSENSUS_ID VARCHAR(50) PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    DESCRIPTION VARCHAR(500),
    ENERGY_EFFICIENCY VARCHAR(20),
    SECURITY_MODEL VARCHAR(50),
    FINALITY_TYPE VARCHAR(30)
);

-- Smart Contract (from taxonomy)
CREATE OR REPLACE TABLE SMART_CONTRACT (
    CONTRACT_ID VARCHAR(100) PRIMARY KEY,
    BLOCKCHAIN_ID VARCHAR(50) REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    CONTRACT_ADDRESS VARCHAR(200) NOT NULL,
    NAME VARCHAR(200),
    CONTRACT_TYPE VARCHAR(20),
    DEPLOYMENT_BLOCK_ID VARCHAR(100) REFERENCES BLOCK(BLOCK_ID),
    ABI VARCHAR(5000),
    IS_VERIFIED BOOLEAN DEFAULT FALSE,
    CREATION_TIMESTAMP TIMESTAMP_NTZ
);

-- Asset / Token (from taxonomy)
CREATE OR REPLACE TABLE TOKEN (
    TOKEN_ID VARCHAR(100) PRIMARY KEY,
    BLOCKCHAIN_ID VARCHAR(50) REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    TOKEN_SYMBOL VARCHAR(20) NOT NULL,
    TOKEN_NAME VARCHAR(100),
    TOKEN_TYPE VARCHAR(50),
    TOTAL_SUPPLY DECIMAL(38,18),
    DECIMALS INT DEFAULT 18,
    CONTRACT_ADDRESS VARCHAR(200)
);

-- Junction table for many-to-many
CREATE OR REPLACE TABLE BLOCKCHAIN_CONSENSUS (
    BLOCKCHAIN_ID VARCHAR(50) REFERENCES BLOCKCHAIN(BLOCKCHAIN_ID),
    CONSENSUS_ID VARCHAR(50) REFERENCES CONSENSUS_MECHANISM(CONSENSUS_ID),
    PRIMARY KEY (BLOCKCHAIN_ID, CONSENSUS_ID)
);

-- =====================================================
-- SAMPLE DATA (Kraken-supported chains and tokens)
-- =====================================================

INSERT INTO BLOCKCHAIN (BLOCKCHAIN_ID, NAME, CHAIN_TYPE, CONSENSUS_MECHANISM, CREATION_DATE, DESCRIPTION) VALUES
('btc', 'Bitcoin', 'Public', 'Proof of Work (PoW)', '2009-01-03', 'The original cryptocurrency blockchain, peer-to-peer electronic cash system'),
('eth', 'Ethereum', 'Public', 'Proof of Stake (PoS)', '2015-07-30', 'Smart contract platform, transitioned to PoS via The Merge in Sept 2022'),
('sol', 'Solana', 'Public', 'Proof of History + PoS', '2020-03-16', 'High-performance blockchain optimized for speed and low costs'),
('dot', 'Polkadot', 'Public', 'Nominated Proof of Stake', '2020-05-26', 'Multi-chain protocol enabling cross-blockchain transfers'),
('ada', 'Cardano', 'Public', 'Ouroboros PoS', '2017-09-29', 'Research-driven blockchain platform with formal verification'),
('avax', 'Avalanche', 'Public', 'Snowball Consensus', '2020-09-21', 'Platform for decentralized apps with sub-second finality'),
('atom', 'Cosmos', 'Public', 'Tendermint BFT', '2019-03-14', 'Internet of Blockchains enabling interoperability via IBC'),
('matic', 'Polygon', 'Public', 'PoS Sidechain', '2020-05-30', 'Ethereum scaling solution and multi-chain ecosystem'),
('xrp', 'XRP Ledger', 'Public', 'Federated Consensus', '2012-06-02', 'Payment-focused distributed ledger for cross-border transactions'),
('link', 'Chainlink', 'Public', 'Oracle Network', '2017-09-19', 'Decentralized oracle network bridging blockchains to real-world data');

INSERT INTO CONSENSUS_MECHANISM (CONSENSUS_ID, NAME, DESCRIPTION, ENERGY_EFFICIENCY, SECURITY_MODEL, FINALITY_TYPE) VALUES
('pow', 'Proof of Work (PoW)', 'Miners compete to solve cryptographic puzzles to validate blocks', 'Low', 'Computational', 'Probabilistic'),
('pos', 'Proof of Stake (PoS)', 'Validators stake tokens to propose and validate blocks', 'High', 'Economic', 'Deterministic'),
('dpos', 'Delegated Proof of Stake', 'Token holders vote for block producers/validators', 'High', 'Economic + Social', 'Deterministic'),
('poh', 'Proof of History', 'Cryptographic timestamp ordering combined with PoS', 'High', 'Temporal', 'Optimistic'),
('bft', 'Byzantine Fault Tolerance', 'Nodes achieve consensus through multiple voting rounds', 'High', 'Mathematical', 'Deterministic'),
('npos', 'Nominated Proof of Stake', 'Nominators back validators with stake, shared rewards/penalties', 'High', 'Economic + Social', 'Deterministic');

INSERT INTO BLOCKCHAIN_CONSENSUS VALUES 
('btc', 'pow'), ('eth', 'pos'), ('sol', 'poh'), ('dot', 'npos'), 
('ada', 'pos'), ('avax', 'bft'), ('atom', 'bft'), ('matic', 'pos'),
('xrp', 'bft'), ('link', 'pos');

-- Sample Blocks
INSERT INTO BLOCK (BLOCK_ID, BLOCKCHAIN_ID, BLOCK_NUMBER, BLOCK_HASH, PREVIOUS_BLOCK_HASH, MERKLE_ROOT, NONCE, TIMESTAMP, TRANSACTION_COUNT, STATUS, IS_GENESIS) VALUES
('btc_genesis', 'btc', 0, '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f', NULL, '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b', '2083236893', '2009-01-03 18:15:05', 1, 'Confirmed', TRUE),
('btc_850000', 'btc', 850000, '00000000000000000002a7c4c1e48d76c5a37902165a270156b7a8d72f6af40c', '00000000000000000001abc23def456789', '7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a', '1234567890', '2024-06-15 14:30:00', 3200, 'Confirmed', FALSE),
('eth_genesis', 'eth', 0, '0xd4e56740f876aef8c010b86a40d5f56745a118d0906a34e69aec8c0db1cb8fa3', NULL, '0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421', '0', '2015-07-30 15:26:13', 0, 'Confirmed', TRUE),
('eth_20500000', 'eth', 20500000, '0xabc123def456789012345678901234567890abcd', '0xdef456789012345678901234567890abcdef1234', '0xmerkle_20500000', '0', '2024-08-01 12:00:00', 185, 'Confirmed', FALSE),
('sol_280000000', 'sol', 280000000, 'SolBlock280M_hash_abc123', 'SolBlock279999999_hash', 'merkle_sol_280M', '0', '2024-07-20 09:15:00', 4500, 'Confirmed', FALSE);

-- Sample Transactions
INSERT INTO BLOCK_TRANSACTION (TRANSACTION_ID, BLOCK_ID, TX_HASH, FROM_ADDRESS, TO_ADDRESS, VALUE, FEE, TIMESTAMP, STATUS, TX_TYPE) VALUES
('tx_btc_genesis', 'btc_genesis', '4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b', 'Coinbase', '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa', 50.0, 0, '2009-01-03 18:15:05', 'Confirmed', 'Coinbase'),
('tx_eth_1', 'eth_20500000', '0xtxhash_eth_1_abc123', '0xSenderAddress123', '0xReceiverAddress456', 2.5, 0.002, '2024-08-01 12:01:00', 'Confirmed', 'Transfer'),
('tx_eth_2', 'eth_20500000', '0xtxhash_eth_2_def456', '0xUserAddress789', '0xUniswapRouter', 0.0, 0.008, '2024-08-01 12:02:00', 'Confirmed', 'Smart Contract Call'),
('tx_sol_1', 'sol_280000000', 'SolTx_1_hash_abc', 'SolSender123', 'SolReceiver456', 100.0, 0.000005, '2024-07-20 09:15:01', 'Confirmed', 'Transfer');

-- Sample Nodes
INSERT INTO DLT_NODE (NODE_ID, BLOCKCHAIN_ID, NODE_TYPE, ADDRESS, STAKE_AMOUNT, IS_ACTIVE, LAST_SEEN) VALUES
('node_btc_1', 'btc', 'Full Node', 'btc-fullnode-1.kraken.com', NULL, TRUE, '2024-08-01 12:00:00'),
('node_btc_2', 'btc', 'Mining Pool Node', 'btc-pool-1.kraken.com', NULL, TRUE, '2024-08-01 12:00:00'),
('validator_eth_1', 'eth', 'Validator', '0xKrakenValidator001', 32.0, TRUE, '2024-08-01 12:00:00'),
('validator_eth_2', 'eth', 'Validator', '0xKrakenValidator002', 32.0, TRUE, '2024-08-01 12:00:00'),
('validator_sol_1', 'sol', 'Validator', 'KrakenSolValidator1', 50000.0, TRUE, '2024-08-01 12:00:00'),
('validator_dot_1', 'dot', 'Validator', 'KrakenDotValidator1', 1000000.0, TRUE, '2024-08-01 12:00:00');

-- Tokens (Kraken-listed assets)
INSERT INTO TOKEN (TOKEN_ID, BLOCKCHAIN_ID, TOKEN_SYMBOL, TOKEN_NAME, TOKEN_TYPE, TOTAL_SUPPLY, DECIMALS, CONTRACT_ADDRESS) VALUES
('btc_native', 'btc', 'BTC', 'Bitcoin', 'Native', 21000000, 8, NULL),
('eth_native', 'eth', 'ETH', 'Ethereum', 'Native', NULL, 18, NULL),
('sol_native', 'sol', 'SOL', 'Solana', 'Native', NULL, 9, NULL),
('dot_native', 'dot', 'DOT', 'Polkadot', 'Native', NULL, 10, NULL),
('ada_native', 'ada', 'ADA', 'Cardano', 'Native', 45000000000, 6, NULL),
('avax_native', 'avax', 'AVAX', 'Avalanche', 'Native', 720000000, 18, NULL),
('atom_native', 'atom', 'ATOM', 'Cosmos', 'Native', NULL, 6, NULL),
('matic_native', 'matic', 'MATIC', 'Polygon', 'Native', 10000000000, 18, NULL),
('xrp_native', 'xrp', 'XRP', 'XRP', 'Native', 100000000000, 6, NULL),
('link_native', 'link', 'LINK', 'Chainlink', 'Fungible (ERC-20)', 1000000000, 18, '0x514910771af9ca656af840dff83e8264ecf986ca'),
('usdt_eth', 'eth', 'USDT', 'Tether', 'Fungible (ERC-20)', 100000000000, 6, '0xdac17f958d2ee523a2206206994597c13d831ec7'),
('usdc_eth', 'eth', 'USDC', 'USD Coin', 'Fungible (ERC-20)', 30000000000, 6, '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'),
('uni_eth', 'eth', 'UNI', 'Uniswap', 'Fungible (ERC-20)', 1000000000, 18, '0x1f9840a85d5af5bf1d1762f925bdaddc4201f984'),
('aave_eth', 'eth', 'AAVE', 'Aave', 'Fungible (ERC-20)', 16000000, 18, '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9');

-- Smart Contracts
INSERT INTO SMART_CONTRACT (CONTRACT_ID, BLOCKCHAIN_ID, CONTRACT_ADDRESS, NAME, CONTRACT_TYPE, IS_VERIFIED, CREATION_TIMESTAMP) VALUES
('uniswap_v3_router', 'eth', '0xE592427A0AEce92De3Edee1F18E0157C05861564', 'Uniswap V3 Router', 'Stateful', TRUE, '2021-05-05 00:00:00'),
('aave_v3_pool', 'eth', '0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2', 'Aave V3 Pool', 'Stateful', TRUE, '2023-01-27 00:00:00'),
('weth', 'eth', '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', 'Wrapped ETH (WETH)', 'Stateful', TRUE, '2017-12-12 00:00:00');

SELECT 'Step 3 Complete: Blockchain Ontology (ISO/TS 23258) tables created and populated in KRAKEN_DB.ONTOLOGY schema.' AS STATUS;
