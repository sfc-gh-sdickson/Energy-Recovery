/*=============================================================================
  ENERGY RECOVERY - SNOWFLAKE INTELLIGENCE AGENT
  File: 03_ISA_95_Ontology.sql
  Purpose: ISA-95 aligned ontology for Energy Recovery manufacturing hierarchy
  Execution Order: 3 of 10
  
  ISA-95 Levels:
    Level 0: Enterprise (Energy Recovery, Inc.)
    Level 1: Site (Manufacturing plants, offices)
    Level 2: Area (Functional areas within a site)
    Level 3: Work Center (Production lines, cells)
    Level 4: Work Unit (Individual machines/stations)
  
  Additional ISA-95 Models:
    - Material Model (raw materials, intermediates, finished goods)
    - Equipment Model (machines, tools, instruments)
    - Personnel Model (roles, qualifications)
    - Process Segment Model (manufacturing steps)
=============================================================================*/

USE DATABASE ENERGY_RECOVERY_DB;
USE SCHEMA ONTOLOGY;
USE WAREHOUSE ENERGY_RECOVERY_WH;

-- ============================================================================
-- PHYSICAL MODEL: Enterprise → Site → Area → Work Center → Work Unit
-- ============================================================================

CREATE OR REPLACE TABLE ENTERPRISE (
    ENTERPRISE_ID       VARCHAR(36) PRIMARY KEY,
    ENTERPRISE_NAME     VARCHAR(255) NOT NULL,
    DESCRIPTION         VARCHAR(2000),
    INDUSTRY            VARCHAR(100),
    HEADQUARTERS        VARCHAR(255),
    FOUNDED_YEAR        NUMBER(4,0),
    STOCK_TICKER        VARCHAR(10),
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SITE (
    SITE_ID             VARCHAR(36) PRIMARY KEY,
    ENTERPRISE_ID       VARCHAR(36) REFERENCES ENTERPRISE(ENTERPRISE_ID),
    SITE_NAME           VARCHAR(255) NOT NULL,
    SITE_TYPE           VARCHAR(100),      -- Manufacturing, R&D, Office, Warehouse, Service Center
    ADDRESS             VARCHAR(500),
    CITY                VARCHAR(100),
    STATE_PROVINCE      VARCHAR(100),
    COUNTRY             VARCHAR(100),
    REGION              VARCHAR(100),
    TIMEZONE            VARCHAR(50),
    CAPACITY_UNITS_YEAR NUMBER(10,0),
    IS_ACTIVE           BOOLEAN DEFAULT TRUE,
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE AREA (
    AREA_ID             VARCHAR(36) PRIMARY KEY,
    SITE_ID             VARCHAR(36) REFERENCES SITE(SITE_ID),
    AREA_NAME           VARCHAR(255) NOT NULL,
    AREA_TYPE           VARCHAR(100),      -- Production, Assembly, Testing, Packaging, Warehouse, R&D
    DESCRIPTION         VARCHAR(2000),
    FLOOR_SPACE_SQM     NUMBER(10,2),
    MAX_PERSONNEL       NUMBER(5,0),
    IS_CLEAN_ROOM       BOOLEAN DEFAULT FALSE,
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE WORK_CENTER (
    WORK_CENTER_ID      VARCHAR(36) PRIMARY KEY,
    AREA_ID             VARCHAR(36) REFERENCES AREA(AREA_ID),
    WORK_CENTER_NAME    VARCHAR(255) NOT NULL,
    WORK_CENTER_TYPE    VARCHAR(100),      -- CNC Machining, Ceramic Processing, Assembly, Testing, Packaging
    DESCRIPTION         VARCHAR(2000),
    CAPACITY_PER_SHIFT  NUMBER(8,0),
    SHIFTS_PER_DAY      NUMBER(1,0) DEFAULT 2,
    OEE_TARGET_PCT      NUMBER(5,2),
    IS_BOTTLENECK       BOOLEAN DEFAULT FALSE,
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE WORK_UNIT (
    WORK_UNIT_ID        VARCHAR(36) PRIMARY KEY,
    WORK_CENTER_ID      VARCHAR(36) REFERENCES WORK_CENTER(WORK_CENTER_ID),
    WORK_UNIT_NAME      VARCHAR(255) NOT NULL,
    EQUIPMENT_TYPE      VARCHAR(100),
    MANUFACTURER        VARCHAR(255),
    MODEL_NUMBER        VARCHAR(100),
    SERIAL_NUMBER       VARCHAR(100),
    INSTALLATION_DATE   DATE,
    STATUS              VARCHAR(50),       -- Operational, Maintenance, Idle, Decommissioned
    MAINTENANCE_SCHEDULE VARCHAR(100),     -- Weekly, Monthly, Quarterly, Annual
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- MATERIAL MODEL
-- ============================================================================

CREATE OR REPLACE TABLE MATERIAL_CLASS (
    MATERIAL_CLASS_ID   VARCHAR(36) PRIMARY KEY,
    CLASS_NAME          VARCHAR(255) NOT NULL,
    CLASS_TYPE          VARCHAR(100),      -- Raw Material, Intermediate, Finished Good, Consumable
    DESCRIPTION         VARCHAR(2000),
    UNIT_OF_MEASURE     VARCHAR(50),
    IS_HAZARDOUS        BOOLEAN DEFAULT FALSE,
    STORAGE_CONDITIONS  VARCHAR(500),
    SHELF_LIFE_DAYS     NUMBER(5,0),
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE MATERIAL_DEFINITION (
    MATERIAL_ID         VARCHAR(36) PRIMARY KEY,
    MATERIAL_CLASS_ID   VARCHAR(36) REFERENCES MATERIAL_CLASS(MATERIAL_CLASS_ID),
    MATERIAL_NAME       VARCHAR(255) NOT NULL,
    PART_NUMBER         VARCHAR(100),
    SPECIFICATION       VARCHAR(2000),
    GRADE               VARCHAR(50),
    SUPPLIER_ID         VARCHAR(36),
    UNIT_COST           NUMBER(12,4),
    LEAD_TIME_DAYS      NUMBER(5,0),
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- EQUIPMENT MODEL
-- ============================================================================

CREATE OR REPLACE TABLE EQUIPMENT_CLASS (
    EQUIPMENT_CLASS_ID  VARCHAR(36) PRIMARY KEY,
    CLASS_NAME          VARCHAR(255) NOT NULL,
    CLASS_TYPE          VARCHAR(100),      -- Machine, Tool, Instrument, Transport, Storage
    DESCRIPTION         VARCHAR(2000),
    MAINTENANCE_INTERVAL_HOURS NUMBER(8,0),
    EXPECTED_LIFESPAN_YEARS    NUMBER(3,0),
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- PERSONNEL MODEL
-- ============================================================================

CREATE OR REPLACE TABLE PERSONNEL_CLASS (
    PERSONNEL_CLASS_ID  VARCHAR(36) PRIMARY KEY,
    CLASS_NAME          VARCHAR(255) NOT NULL,
    DEPARTMENT          VARCHAR(100),
    DESCRIPTION         VARCHAR(2000),
    REQUIRED_CERTIFICATIONS VARCHAR(1000),
    SHIFT_ELIGIBLE      BOOLEAN DEFAULT TRUE,
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- PROCESS SEGMENT MODEL
-- ============================================================================

CREATE OR REPLACE TABLE PROCESS_SEGMENT (
    SEGMENT_ID          VARCHAR(36) PRIMARY KEY,
    SEGMENT_NAME        VARCHAR(255) NOT NULL,
    SEGMENT_TYPE        VARCHAR(100),      -- Production, Quality, Logistics, Maintenance
    DESCRIPTION         VARCHAR(2000),
    SEQUENCE_ORDER      NUMBER(3,0),
    PRODUCT_LINE        VARCHAR(100),      -- Desalination, Wastewater, Refrigeration, All
    DURATION_HOURS      NUMBER(8,2),
    PREDECESSOR_ID      VARCHAR(36),
    WORK_CENTER_TYPE    VARCHAR(100),
    QUALITY_CHECKPOINT  BOOLEAN DEFAULT FALSE,
    CREATED_DATE        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- KNOWLEDGE BASE (for Cortex Search)
-- ============================================================================

CREATE OR REPLACE TABLE KNOWLEDGE_ARTICLES (
    ARTICLE_ID          VARCHAR(36) PRIMARY KEY,
    TITLE               VARCHAR(500) NOT NULL,
    CATEGORY            VARCHAR(100),      -- Product, Maintenance, Process, Safety, Policy
    SUBCATEGORY         VARCHAR(100),
    CONTENT             VARCHAR(16000) NOT NULL,
    PRODUCT_MODEL       VARCHAR(100),
    APPLICABLE_AREA     VARCHAR(200),
    KEYWORDS            VARCHAR(1000),
    AUTHOR              VARCHAR(255),
    PUBLISH_DATE        DATE,
    LAST_UPDATED        TIMESTAMP_NTZ,
    VERSION             VARCHAR(20) DEFAULT '1.0'
);

-- ============================================================================
-- LOAD ISA-95 ONTOLOGY DATA
-- ============================================================================

-- Enterprise
INSERT INTO ENTERPRISE VALUES (
    'ENT-001', 'Energy Recovery, Inc.',
    'Global leader in the design and manufacturing of energy recovery devices for industrial fluid flow applications. Core technology is the PX Pressure Exchanger which recovers up to 98% of otherwise wasted pressure energy in reverse osmosis desalination plants.',
    'Industrial Technology / Water Treatment / Environmental Services',
    'San Leandro, California, USA',
    1992, 'ERII',
    CURRENT_TIMESTAMP()
);

-- Sites
INSERT INTO SITE VALUES
    ('SITE-001', 'ENT-001', 'San Leandro Headquarters & Manufacturing', 'Manufacturing', '1717 Doolittle Dr', 'San Leandro', 'California', 'United States', 'Americas', 'America/Los_Angeles', 5000, TRUE, CURRENT_TIMESTAMP()),
    ('SITE-002', 'ENT-001', 'San Leandro R&D Center', 'R&D', '1908 Doolittle Dr', 'San Leandro', 'California', 'United States', 'Americas', 'America/Los_Angeles', NULL, TRUE, CURRENT_TIMESTAMP()),
    ('SITE-003', 'ENT-001', 'Dubai Regional Office', 'Office', 'Dubai Silicon Oasis', 'Dubai', 'Dubai', 'United Arab Emirates', 'MENA', 'Asia/Dubai', NULL, TRUE, CURRENT_TIMESTAMP()),
    ('SITE-004', 'ENT-001', 'Shanghai Service Center', 'Service Center', 'Pudong New Area', 'Shanghai', 'Shanghai', 'China', 'Asia-Pacific', 'Asia/Shanghai', NULL, TRUE, CURRENT_TIMESTAMP()),
    ('SITE-005', 'ENT-001', 'Madrid European Office', 'Office', 'Paseo de la Castellana', 'Madrid', 'Madrid', 'Spain', 'Europe', 'Europe/Madrid', NULL, TRUE, CURRENT_TIMESTAMP());

-- Areas (within San Leandro Manufacturing)
INSERT INTO AREA VALUES
    ('AREA-001', 'SITE-001', 'Ceramic Manufacturing', 'Production', 'High-purity alumina ceramic rotor and sleeve production area with controlled atmosphere kilns', 2500.00, 25, TRUE, CURRENT_TIMESTAMP()),
    ('AREA-002', 'SITE-001', 'CNC Machining', 'Production', 'Precision CNC machining of metal components including end covers, thrust bearings, and housings', 1800.00, 15, FALSE, CURRENT_TIMESTAMP()),
    ('AREA-003', 'SITE-001', 'Assembly', 'Assembly', 'Final assembly of PX Pressure Exchanger units combining ceramic and metal components', 2000.00, 30, TRUE, CURRENT_TIMESTAMP()),
    ('AREA-004', 'SITE-001', 'Testing & QC', 'Testing', 'Hydraulic testing, performance validation, and quality control for all finished products', 1200.00, 10, FALSE, CURRENT_TIMESTAMP()),
    ('AREA-005', 'SITE-001', 'Packaging & Shipping', 'Packaging', 'Product packaging, crating, and outbound logistics coordination', 1500.00, 12, FALSE, CURRENT_TIMESTAMP()),
    ('AREA-006', 'SITE-001', 'Warehouse & Receiving', 'Warehouse', 'Raw material receiving, storage, and inventory management', 3000.00, 8, FALSE, CURRENT_TIMESTAMP());

-- Work Centers
INSERT INTO WORK_CENTER VALUES
    ('WC-001', 'AREA-001', 'Ceramic Forming', 'Ceramic Processing', 'Isostatic pressing and extrusion of alumina ceramic blanks for PX rotors', 20, 2, 85.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-002', 'AREA-001', 'Sintering', 'Ceramic Processing', 'High-temperature sintering kilns for ceramic densification (1600-1700°C)', 15, 1, 90.00, TRUE, CURRENT_TIMESTAMP()),
    ('WC-003', 'AREA-001', 'Ceramic Grinding', 'Ceramic Processing', 'Diamond grinding and lapping of ceramic rotors to micron-level tolerances', 25, 2, 88.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-004', 'AREA-002', 'CNC Turning', 'CNC Machining', '5-axis CNC turning of stainless steel and duplex steel end covers', 40, 2, 92.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-005', 'AREA-002', 'CNC Milling', 'CNC Machining', 'CNC milling of housing components and mounting brackets', 35, 2, 90.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-006', 'AREA-003', 'Sub-Assembly', 'Assembly', 'Sub-assembly of rotor cartridges with bearings and seals', 30, 2, 87.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-007', 'AREA-003', 'Final Assembly', 'Assembly', 'Final PX unit assembly, torque verification, and seal testing', 20, 2, 85.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-008', 'AREA-004', 'Hydrostatic Testing', 'Testing', 'Pressure testing at 1.5x rated pressure for leak detection', 15, 2, 95.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-009', 'AREA-004', 'Performance Testing', 'Testing', 'Full performance validation measuring energy transfer efficiency', 10, 2, 95.00, FALSE, CURRENT_TIMESTAMP()),
    ('WC-010', 'AREA-005', 'Packaging Line', 'Packaging', 'Automated packaging, labeling, and crating for shipment', 50, 1, 92.00, FALSE, CURRENT_TIMESTAMP());

-- Work Units (machines/stations within Work Centers)
INSERT INTO WORK_UNIT VALUES
    ('WU-001', 'WC-001', 'Isostatic Press #1', 'Isostatic Press', 'EPSI', 'CIP-400', 'IP-2018-001', '2018-03-15', 'Operational', 'Monthly', CURRENT_TIMESTAMP()),
    ('WU-002', 'WC-001', 'Isostatic Press #2', 'Isostatic Press', 'EPSI', 'CIP-400', 'IP-2020-002', '2020-06-20', 'Operational', 'Monthly', CURRENT_TIMESTAMP()),
    ('WU-003', 'WC-002', 'Kiln A - High Temp', 'Sintering Kiln', 'Nabertherm', 'HT-1700', 'KN-2016-001', '2016-01-10', 'Operational', 'Quarterly', CURRENT_TIMESTAMP()),
    ('WU-004', 'WC-002', 'Kiln B - High Temp', 'Sintering Kiln', 'Nabertherm', 'HT-1700', 'KN-2019-002', '2019-08-22', 'Operational', 'Quarterly', CURRENT_TIMESTAMP()),
    ('WU-005', 'WC-003', 'Diamond Grinder CG-1', 'Surface Grinder', 'Studer', 'S41', 'SG-2017-001', '2017-04-01', 'Operational', 'Weekly', CURRENT_TIMESTAMP()),
    ('WU-006', 'WC-004', 'CNC Lathe T-1', 'CNC Lathe', 'DMG Mori', 'NLX-2500', 'DM-2019-001', '2019-02-14', 'Operational', 'Weekly', CURRENT_TIMESTAMP()),
    ('WU-007', 'WC-004', 'CNC Lathe T-2', 'CNC Lathe', 'DMG Mori', 'NLX-2500', 'DM-2021-002', '2021-09-01', 'Operational', 'Weekly', CURRENT_TIMESTAMP()),
    ('WU-008', 'WC-005', 'Mill M-1', '5-Axis Mill', 'Haas', 'UMC-750', 'HM-2020-001', '2020-11-30', 'Operational', 'Weekly', CURRENT_TIMESTAMP()),
    ('WU-009', 'WC-008', 'Hydro Test Bench #1', 'Test Bench', 'Custom', 'HTP-3000', 'HT-2018-001', '2018-07-15', 'Operational', 'Monthly', CURRENT_TIMESTAMP()),
    ('WU-010', 'WC-009', 'Performance Rig #1', 'Performance Test Rig', 'Custom', 'PTR-5000', 'PR-2019-001', '2019-05-20', 'Operational', 'Monthly', CURRENT_TIMESTAMP());

-- Material Classes
INSERT INTO MATERIAL_CLASS VALUES
    ('MC-001', 'High-Purity Alumina Ceramic', 'Raw Material', 'Al2O3 ceramic powder (99.7%+ purity) for PX rotor and sleeve manufacturing', 'kg', FALSE, 'Dry, temperature controlled 15-25°C', 365, CURRENT_TIMESTAMP()),
    ('MC-002', 'Duplex Stainless Steel', 'Raw Material', 'SAF 2507 super duplex stainless steel bar stock for end covers and thrust rings', 'kg', FALSE, 'Indoor, dry storage', NULL, CURRENT_TIMESTAMP()),
    ('MC-003', 'Ceramic Rotor', 'Intermediate', 'Sintered and ground alumina ceramic rotor - core PX component', 'each', FALSE, 'Clean room, padded storage', NULL, CURRENT_TIMESTAMP()),
    ('MC-004', 'End Cover Assembly', 'Intermediate', 'Machined duplex steel end cover with integrated bearing seats', 'each', FALSE, 'Indoor, protected from impact', NULL, CURRENT_TIMESTAMP()),
    ('MC-005', 'Elastomer Seals', 'Raw Material', 'EPDM and Viton O-rings and sealing elements for PX assemblies', 'each', FALSE, 'Cool, dark storage, 10-25°C', 730, CURRENT_TIMESTAMP()),
    ('MC-006', 'Ceramic Sleeve/Liner', 'Intermediate', 'Precision ground ceramic sleeve that houses the rotor', 'each', FALSE, 'Clean room, padded storage', NULL, CURRENT_TIMESTAMP()),
    ('MC-007', 'Thrust Bearing', 'Raw Material', 'Silicon carbide or tungsten carbide thrust bearings', 'each', FALSE, 'Clean, dry storage', NULL, CURRENT_TIMESTAMP()),
    ('MC-008', 'PX Pressure Exchanger (Finished)', 'Finished Good', 'Complete assembled and tested PX Pressure Exchanger unit', 'each', FALSE, 'Warehouse, temperature controlled', NULL, CURRENT_TIMESTAMP()),
    ('MC-009', 'PX G1300 (Finished)', 'Finished Good', 'Complete PX G1300 for CO2 transcritical refrigeration', 'each', FALSE, 'Warehouse, temperature controlled', NULL, CURRENT_TIMESTAMP()),
    ('MC-010', 'Aftermarket Spare Parts Kit', 'Finished Good', 'Service kit containing seals, bearings, and wear components', 'each', FALSE, 'Warehouse', 1095, CURRENT_TIMESTAMP());

-- Equipment Classes
INSERT INTO EQUIPMENT_CLASS VALUES
    ('EC-001', 'Isostatic Press', 'Machine', 'Cold isostatic pressing equipment for ceramic green body formation', 2000, 25, CURRENT_TIMESTAMP()),
    ('EC-002', 'Sintering Kiln', 'Machine', 'High-temperature kiln for ceramic sintering up to 1700°C', 4000, 20, CURRENT_TIMESTAMP()),
    ('EC-003', 'CNC Lathe', 'Machine', 'Computer numerical control lathe for precision metal turning', 3000, 15, CURRENT_TIMESTAMP()),
    ('EC-004', '5-Axis CNC Mill', 'Machine', '5-axis CNC milling center for complex geometry machining', 3000, 15, CURRENT_TIMESTAMP()),
    ('EC-005', 'Diamond Surface Grinder', 'Machine', 'Precision diamond grinding machine for ceramic finishing', 1500, 12, CURRENT_TIMESTAMP()),
    ('EC-006', 'Assembly Robot', 'Machine', 'Automated assembly robot for PX component positioning', 5000, 10, CURRENT_TIMESTAMP()),
    ('EC-007', 'Hydrostatic Test Bench', 'Instrument', 'High-pressure test bench for leak and burst testing', 2000, 20, CURRENT_TIMESTAMP()),
    ('EC-008', 'Performance Test Rig', 'Instrument', 'Full-scale performance validation rig measuring energy transfer efficiency', 4000, 20, CURRENT_TIMESTAMP()),
    ('EC-009', 'CMM (Coordinate Measuring Machine)', 'Instrument', 'Precision measurement system for dimensional inspection', 4000, 15, CURRENT_TIMESTAMP()),
    ('EC-010', 'Packaging Robot', 'Machine', 'Automated packaging and palletizing system', 5000, 12, CURRENT_TIMESTAMP());

-- Personnel Classes
INSERT INTO PERSONNEL_CLASS VALUES
    ('PC-001', 'Ceramic Technician', 'Manufacturing', 'Operates ceramic forming, sintering, and grinding equipment', 'Ceramic Processing Cert, Clean Room Training', TRUE, CURRENT_TIMESTAMP()),
    ('PC-002', 'CNC Machinist', 'Manufacturing', 'Programs and operates CNC lathes and mills', 'CNC Programming Cert, GD&T Training', TRUE, CURRENT_TIMESTAMP()),
    ('PC-003', 'Assembly Technician', 'Manufacturing', 'Performs PX assembly, torque procedures, and seal verification', 'Assembly Cert, Torque Training, Clean Room', TRUE, CURRENT_TIMESTAMP()),
    ('PC-004', 'Test Engineer', 'Quality', 'Conducts hydrostatic and performance testing of finished products', 'Test Engineering Cert, Safety Training', TRUE, CURRENT_TIMESTAMP()),
    ('PC-005', 'Quality Inspector', 'Quality', 'Performs dimensional inspection and quality audits', 'CMM Cert, ISO 9001 Auditor', TRUE, CURRENT_TIMESTAMP()),
    ('PC-006', 'Maintenance Technician', 'Maintenance', 'Performs preventive and corrective maintenance on production equipment', 'Electrical Safety, Mechanical Maintenance Cert', TRUE, CURRENT_TIMESTAMP()),
    ('PC-007', 'Process Engineer', 'Engineering', 'Designs and optimizes manufacturing processes', 'Six Sigma Green Belt, Process Engineering', FALSE, CURRENT_TIMESTAMP()),
    ('PC-008', 'Field Service Engineer', 'Service', 'Installs, commissions, and services PX devices at customer sites worldwide', 'PX Service Cert, Travel Required, Confined Space', FALSE, CURRENT_TIMESTAMP());

-- Process Segments (PX Manufacturing Flow)
INSERT INTO PROCESS_SEGMENT VALUES
    ('PS-001', 'Raw Material Preparation', 'Production', 'Incoming inspection and preparation of alumina powder and steel bar stock', 1, 'All', 4.0, NULL, 'Warehouse', TRUE, CURRENT_TIMESTAMP()),
    ('PS-002', 'Ceramic Forming', 'Production', 'Cold isostatic pressing of alumina powder into green body rotor blanks', 2, 'All', 2.0, 'PS-001', 'Ceramic Processing', FALSE, CURRENT_TIMESTAMP()),
    ('PS-003', 'Green Machining', 'Production', 'Initial machining of ceramic green bodies to near-net shape', 3, 'All', 3.0, 'PS-002', 'Ceramic Processing', FALSE, CURRENT_TIMESTAMP()),
    ('PS-004', 'Sintering', 'Production', 'High-temperature sintering at 1600-1700°C for ceramic densification (24-48hr cycle)', 4, 'All', 36.0, 'PS-003', 'Ceramic Processing', TRUE, CURRENT_TIMESTAMP()),
    ('PS-005', 'Ceramic Finish Grinding', 'Production', 'Precision diamond grinding of sintered rotors to final dimensions (micron tolerances)', 5, 'All', 8.0, 'PS-004', 'Ceramic Processing', TRUE, CURRENT_TIMESTAMP()),
    ('PS-006', 'Metal Component Machining', 'Production', 'CNC turning and milling of duplex stainless steel end covers and housings', 6, 'All', 6.0, 'PS-001', 'CNC Machining', FALSE, CURRENT_TIMESTAMP()),
    ('PS-007', 'Sub-Assembly', 'Production', 'Assembly of rotor cartridge with bearings, seals, and end covers', 7, 'All', 4.0, 'PS-005', 'Assembly', FALSE, CURRENT_TIMESTAMP()),
    ('PS-008', 'Final Assembly', 'Production', 'Complete PX unit assembly with housing, connections, and final torque', 8, 'All', 3.0, 'PS-007', 'Assembly', FALSE, CURRENT_TIMESTAMP()),
    ('PS-009', 'Hydrostatic Testing', 'Quality', 'Pressure testing at 1.5x rated pressure for leak and structural integrity', 9, 'All', 2.0, 'PS-008', 'Testing', TRUE, CURRENT_TIMESTAMP()),
    ('PS-010', 'Performance Validation', 'Quality', 'Full performance test measuring energy transfer efficiency under design conditions', 10, 'All', 4.0, 'PS-009', 'Testing', TRUE, CURRENT_TIMESTAMP()),
    ('PS-011', 'Final Inspection & Documentation', 'Quality', 'Dimensional verification, documentation package, and release to ship', 11, 'All', 2.0, 'PS-010', 'Testing', TRUE, CURRENT_TIMESTAMP()),
    ('PS-012', 'Packaging & Shipping', 'Logistics', 'Custom crating, preservation, and shipment preparation', 12, 'All', 3.0, 'PS-011', 'Packaging', FALSE, CURRENT_TIMESTAMP());

-- Knowledge Articles (for Cortex Search)
INSERT INTO KNOWLEDGE_ARTICLES VALUES
    ('KA-001', 'PX Pressure Exchanger Technology Overview', 'Product', 'Technology', 'The PX Pressure Exchanger is an isobaric energy recovery device that transfers pressure energy from a high-pressure reject stream to a low-pressure feed stream. The core component is a ceramic rotor that spins freely between two end covers, creating sealed ducts that allow direct pressure transfer between fluids. The PX achieves up to 98% energy transfer efficiency, making it the most efficient energy recovery device for reverse osmosis desalination. The ceramic rotor is made from high-purity alumina (Al2O3) and is engineered for corrosion resistance and dimensional stability in seawater environments. The PX operates without external power, requiring only the differential pressure between the HP and LP streams to rotate the rotor.', NULL, 'Engineering', 'PX, pressure exchanger, isobaric, energy recovery, ceramic rotor, desalination', 'Engineering Team', '2024-01-15', CURRENT_TIMESTAMP(), '3.0'),
    ('KA-002', 'PX Q650 Specifications and Performance', 'Product', 'Specifications', 'The PX Q650 is Energy Recovery''s highest capacity pressure exchanger for seawater reverse osmosis (SWRO) desalination. Key specifications: Flow rate up to 68.2 m³/h per device, operating pressure up to 82.7 bar (1200 psi), energy transfer efficiency up to 98.7% peak / 97.5% average, design life 25+ years, weight 460 kg, dimensions 762mm diameter x 1270mm length. The Q650 is designed for mega-scale desalination plants (100,000+ m³/day) and offers the lowest lifecycle cost of any ERD in its class. Each Q650 can save approximately 2.5 kWh per cubic meter of permeate produced compared to no energy recovery.', 'PX-Q650', 'Engineering', 'Q650, specifications, SWRO, high capacity, 68.2 m3/h, 82.7 bar', 'Product Management', '2025-06-01', CURRENT_TIMESTAMP(), '2.0'),
    ('KA-003', 'PX Q400 Specifications and Performance', 'Product', 'Specifications', 'The PX Q400 is Energy Recovery''s mid-range pressure exchanger for seawater reverse osmosis. Key specifications: Flow rate up to 45.4 m³/h per device, operating pressure up to 82.7 bar (1200 psi), energy transfer efficiency up to 98% peak, design life 25+ years. The Q400 is ideal for medium-scale desalination plants (25,000-100,000 m³/day) and provides excellent performance in a compact footprint.', 'PX-Q400', 'Engineering', 'Q400, specifications, SWRO, mid-range', 'Product Management', '2024-09-15', CURRENT_TIMESTAMP(), '2.0'),
    ('KA-004', 'PX G1300 CO2 Refrigeration Product Guide', 'Product', 'Specifications', 'The PX G1300 is Energy Recovery''s pressure exchanger designed for industrial CO2 transcritical refrigeration systems. Commercially launched April 2026, it recovers energy from high-pressure CO2 gas cooler discharge, reducing compressor work by up to 50%. Key applications include industrial cold storage, food processing, and commercial HVAC. Operating conditions: CO2 working fluid, pressures up to 130 bar, temperatures from -40°C to +50°C. The device enables natural refrigerant systems to achieve energy efficiency competitive with HFC systems while meeting F-gas regulation compliance.', 'PX-G1300', 'Engineering', 'G1300, CO2, refrigeration, transcritical, natural refrigerant, F-gas', 'Product Management', '2026-04-15', CURRENT_TIMESTAMP(), '1.0'),
    ('KA-005', 'PX Maintenance Procedure - Annual Service', 'Maintenance', 'Procedure', 'Annual maintenance procedure for PX Pressure Exchanger devices: 1) Shut down and isolate the PX unit per LOTO procedures. 2) Drain residual fluid from all ports. 3) Remove end covers using calibrated torque wrench (refer to model-specific torque table). 4) Inspect ceramic rotor for wear, scoring, or damage - measure clearances with feeler gauge. 5) Inspect and replace all elastomer seals (O-rings, lip seals). 6) Check thrust bearings for wear - replace if wear exceeds 0.1mm. 7) Clean all mating surfaces and apply new lubrication to seal grooves. 8) Reassemble with new seals and torque to specification. 9) Perform hydrostatic test at 1.25x operating pressure. 10) Return to service and verify performance parameters within specification.', NULL, 'Service', 'maintenance, annual, service, seals, bearings, inspection, LOTO', 'Service Engineering', '2025-03-01', CURRENT_TIMESTAMP(), '4.0'),
    ('KA-006', 'Troubleshooting: Low Energy Recovery Efficiency', 'Maintenance', 'Troubleshooting', 'When PX energy recovery efficiency drops below design specification: Root causes: 1) Worn or damaged seals causing internal leakage - Solution: Replace seal kit. 2) Bearing wear increasing clearances - Solution: Replace thrust bearings. 3) Rotor scoring from abrasive particles - Solution: Inspect/replace rotor, verify pre-filtration. 4) Incorrect operating point (flow/pressure mismatch) - Solution: Adjust to design conditions. 5) Air/gas entrainment in feed - Solution: Check deaeration system. Diagnostic steps: Check differential pressure across device, measure mixing rate, verify inlet conditions match design. Contact Energy Recovery technical support for rotor-related issues.', NULL, 'Service', 'troubleshooting, efficiency, low performance, seals, bearings, mixing', 'Service Engineering', '2025-01-20', CURRENT_TIMESTAMP(), '3.0'),
    ('KA-007', 'ISA-95 Manufacturing Hierarchy - Energy Recovery', 'Process', 'Ontology', 'Energy Recovery''s manufacturing operations follow the ISA-95 (IEC 62264) standard for enterprise-control system integration. The hierarchy maps as follows: Level 4 (Enterprise) = Energy Recovery, Inc. Level 3 (Site) = San Leandro Manufacturing. Level 2 (Areas) = Ceramic Manufacturing, CNC Machining, Assembly, Testing & QC, Packaging. Level 1 (Work Centers) = Specific production cells (e.g., Ceramic Forming, Sintering, CNC Turning). Level 0 (Work Units) = Individual machines and equipment. This structure enables traceability from finished product back to individual process steps, material lots, and equipment used.', NULL, 'Manufacturing', 'ISA-95, hierarchy, manufacturing, ontology, traceability', 'Process Engineering', '2025-06-01', CURRENT_TIMESTAMP(), '2.0'),
    ('KA-008', 'Desalination Industry Overview', 'Product', 'Market', 'The global desalination market is projected to grow from $18.2B in 2024 to $32.5B by 2030, driven by increasing water scarcity affecting 2B+ people globally. Reverse osmosis (RO) accounts for 69% of global desalination capacity. Key markets: Middle East & North Africa (MENA) - largest installed base, Asia-Pacific - fastest growing, Americas - emerging opportunities. Energy is the largest operating cost in RO desalination (30-50% of total cost). Energy Recovery''s PX technology reduces energy consumption by up to 60% in SWRO plants, making desalination economically viable in water-stressed regions. The company holds dominant market share in the ERD segment.', NULL, 'Sales', 'desalination, market, growth, MENA, Asia-Pacific, RO, reverse osmosis', 'Market Intelligence', '2026-01-15', CURRENT_TIMESTAMP(), '1.0'),
    ('KA-009', 'Wastewater Treatment Applications', 'Product', 'Applications', 'Energy Recovery''s PX technology is expanding into industrial wastewater treatment applications including: Minimal Liquid Discharge (MLD), Zero Liquid Discharge (ZLD), brine concentration, produced water treatment in oil & gas, and mining wastewater. In these applications, the PX recovers energy from high-pressure concentrate streams, reducing the energy required for membrane-based treatment. Key industries: Semiconductor manufacturing, pharmaceuticals, food & beverage, power generation, mining, and oil & gas. The wastewater market represents a significant growth opportunity as regulations tighten globally.', NULL, 'Sales', 'wastewater, MLD, ZLD, brine, treatment, industrial', 'Product Management', '2025-11-01', CURRENT_TIMESTAMP(), '1.0'),
    ('KA-010', 'Quality Management System Overview', 'Process', 'Quality', 'Energy Recovery maintains ISO 9001:2015 certified quality management system. Key quality processes: Incoming material inspection (AQL sampling per ANSI/ASQ Z1.4), In-process inspection at critical quality checkpoints (post-sintering, post-grinding, post-assembly), Final inspection including dimensional verification (CMM), hydrostatic testing, and performance validation. Quality metrics tracked: First pass yield, scrap rate, customer complaints (PPM), on-time delivery, and cost of quality. Continuous improvement driven by 8D problem solving, statistical process control (SPC), and regular management review.', NULL, 'Quality', 'ISO 9001, quality, inspection, SPC, yield, CMM', 'Quality Assurance', '2025-08-01', CURRENT_TIMESTAMP(), '2.0');
