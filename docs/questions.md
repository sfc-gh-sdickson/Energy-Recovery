<img src="Snowflake_Logo.svg" width="200">

# Energy Recovery - Test Questions (30+)

## Financial Operations Questions

1. **What was our total revenue for Q1 2026?**
   - Expected tools: FinancialAnalyst
   - Tests: Revenue aggregation by quarter

2. **How does gross margin compare across product lines (Desalination vs Wastewater vs Refrigeration)?**
   - Expected tools: FinancialAnalyst
   - Tests: Revenue minus COGS by product line

3. **What is our current AR aging breakdown by region?**
   - Expected tools: FinancialAnalyst
   - Tests: Aging bucket distribution with regional segmentation

4. **Show me month-over-month revenue trends for the last 12 months**
   - Expected tools: FinancialAnalyst
   - Tests: Time series aggregation with trend

5. **What are our top 10 customers by revenue this year?**
   - Expected tools: FinancialAnalyst
   - Tests: Customer ranking by order total

6. **What percentage of our invoices are overdue and what is the total overdue amount?**
   - Expected tools: FinancialAnalyst
   - Tests: Invoice status filtering and aggregation

7. **How much did we spend on R&D vs Sales & Marketing last quarter?**
   - Expected tools: FinancialAnalyst
   - Tests: GL account category filtering

8. **What is our average order value by product line and how has it changed year-over-year?**
   - Expected tools: FinancialAnalyst
   - Tests: AVG calculation with YoY comparison

9. **Which sales rep has the highest total revenue this fiscal year?**
   - Expected tools: FinancialAnalyst
   - Tests: Sales rep ranking

10. **What is our revenue concentration risk? How much revenue comes from the top 5 customers?**
    - Expected tools: FinancialAnalyst
    - Tests: Pareto/concentration analysis

## CRM / Sales Pipeline Questions

11. **What is our current pipeline value by stage?**
    - Expected tools: PipelineAnalyst
    - Tests: Pipeline segmentation excluding closed

12. **Which opportunities are expected to close this quarter with amount > $1M?**
    - Expected tools: PipelineAnalyst
    - Tests: Date filtering and amount threshold

13. **What is our win rate by region over the past year?**
    - Expected tools: PipelineAnalyst
    - Tests: Win rate calculation (won / (won + lost))

14. **Show me the pipeline for PX G1300 CO2 Refrigeration products**
    - Expected tools: PipelineAnalyst
    - Tests: Product interest filtering

15. **Who are our top prospects in the MENA region by deal size?**
    - Expected tools: PipelineAnalyst
    - Tests: Region + stage filtering + ranking

16. **What is our average sales cycle length by product interest?**
    - Expected tools: PipelineAnalyst
    - Tests: Date difference calculation

17. **How does our win rate against Danfoss compare to Flowserve and Sulzer?**
    - Expected tools: PipelineAnalyst
    - Tests: Competitor-specific win rate comparison

18. **Which accounts have the most open opportunities right now?**
    - Expected tools: PipelineAnalyst
    - Tests: Account grouping with open stage filter

19. **What are the most common loss reasons for deals we lost this year?**
    - Expected tools: PipelineAnalyst
    - Tests: Loss reason aggregation on closed-lost deals

20. **What is our weighted pipeline forecast for next quarter?**
    - Expected tools: PipelineAnalyst
    - Tests: Amount * probability calculation with date filter

## IoT / Device Performance Questions

21. **Which PX devices are at risk of failure in the next 30 days?**
    - Expected tools: PredictFailure
    - Tests: ML function invocation and result interpretation

22. **What is the average energy recovery efficiency across our installed base by device model?**
    - Expected tools: DeviceAnalyst
    - Tests: AVG efficiency grouped by model

23. **Show me alarm frequency trends by severity for the past 6 months**
    - Expected tools: DeviceAnalyst
    - Tests: Time series alarm count by severity

24. **Which installation sites have the highest uptime?**
    - Expected tools: DeviceAnalyst
    - Tests: Uptime calculation from device status

25. **What is the equipment health score distribution across our fleet?**
    - Expected tools: EquipmentHealth
    - Tests: ML function with distribution analysis

26. **How many devices have vibration levels above 5 mm/s (indicating bearing issues)?**
    - Expected tools: DeviceAnalyst
    - Tests: Threshold filtering on telemetry

27. **What is the total maintenance cost by device model and maintenance type?**
    - Expected tools: DeviceAnalyst
    - Tests: Cost aggregation with two-level grouping

28. **Which regions have the most critical alarms in the past month?**
    - Expected tools: DeviceAnalyst
    - Tests: Severity + date + region filtering

29. **What is the average downtime per maintenance event by failure mode?**
    - Expected tools: DeviceAnalyst
    - Tests: AVG downtime grouped by failure mode

30. **How does the PX-Q650 efficiency compare to the PX-Q400 across different regions?**
    - Expected tools: DeviceAnalyst
    - Tests: Model comparison with regional breakdown

## Cross-Domain & Knowledge Questions

31. **How does our sales pipeline correlate with installed base growth in MENA?**
    - Expected tools: PipelineAnalyst + DeviceAnalyst
    - Tests: Multi-tool cross-domain synthesis

32. **What maintenance procedures apply to PX Q650 devices?**
    - Expected tools: KnowledgeSearch
    - Tests: Product-specific knowledge retrieval

33. **What is the PX G1300 and what applications is it designed for?**
    - Expected tools: KnowledgeSearch
    - Tests: Product specification retrieval

34. **How does our ISA-95 hierarchy map to production capacity at San Leandro?**
    - Expected tools: KnowledgeSearch
    - Tests: Ontology-specific query

35. **What is the demand forecast for next quarter by product line?**
    - Expected tools: ForecastDemand
    - Tests: ML function for forecasting

36. **What energy efficiency improvements could we achieve and what are the potential savings?**
    - Expected tools: ScoreEfficiency
    - Tests: Efficiency gap and savings calculation

37. **Compare our financial performance to our FY2026 guidance of $135M-$145M**
    - Expected tools: FinancialAnalyst + KnowledgeSearch
    - Tests: Actual vs target comparison

38. **What troubleshooting steps should I follow for a PX device showing low efficiency?**
    - Expected tools: KnowledgeSearch
    - Tests: Procedural knowledge retrieval

## Tool Routing Verification

<html>
<table>
<tr><th>Question Category</th><th>Expected Primary Tool</th><th>Uses Ontology?</th></tr>
<tr><td>Revenue/Financial</td><td>FinancialAnalyst</td><td>No</td></tr>
<tr><td>Pipeline/CRM</td><td>PipelineAnalyst</td><td>No</td></tr>
<tr><td>Device Performance</td><td>DeviceAnalyst</td><td>No</td></tr>
<tr><td>Failure Prediction</td><td>PredictFailure</td><td>No</td></tr>
<tr><td>Efficiency Scoring</td><td>ScoreEfficiency</td><td>No</td></tr>
<tr><td>Demand Forecast</td><td>ForecastDemand</td><td>No</td></tr>
<tr><td>Equipment Health</td><td>EquipmentHealth</td><td>No</td></tr>
<tr><td>Product Specs</td><td>KnowledgeSearch</td><td>Yes (via articles)</td></tr>
<tr><td>Maintenance Procedures</td><td>KnowledgeSearch</td><td>Yes (via articles)</td></tr>
<tr><td>Manufacturing Hierarchy</td><td>KnowledgeSearch</td><td>Yes (ISA-95 article)</td></tr>
<tr><td>Cross-Domain</td><td>Multiple tools</td><td>Depends on question</td></tr>
</table>
</html>
