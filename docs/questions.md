<img src="Snowflake_Logo.svg" width="200">

# Test Questions — Kraken Intelligence Agent

30+ complex questions organized by persona and tool path. These questions validate that the agent correctly routes to the appropriate tool and synthesizes multi-source answers.

---

## Executive / PM Persona (Cortex Analyst — Trading)

1. What was our total trading volume in USD for the past 7 days across all pairs?
2. Which trading pair generated the most fee revenue this month?
3. What percentage of our trades come from Mobile vs Web vs API vs Pro platforms?
4. How many unique active traders do we have per day this week?
5. What is the average trade size in USD for Institutional vs VIP vs Pro vs Standard tier customers?
6. Show me daily revenue (fees collected) for the past 30 days broken down by account tier.
7. Which country has the highest trading volume and how does it compare to the top 5?
8. What is the buy/sell ratio for BTC/USD over the last 14 days?

## Compliance Officer Persona (Cortex Analyst — Operations)

9. How many compliance events were flagged as Critical risk level this month?
10. What is the breakdown of compliance event types (SAR, velocity alert, sanctions, etc.) in the last 30 days?
11. How many regulatory reports have been filed this quarter, broken down by jurisdiction?
12. Which customers have the highest cumulative risk scores across all their compliance events?
13. What percentage of compliance events are still in Pending review status?
14. Show me the trend of flagged events per week over the past 3 months.
15. What is the average time from event creation to review completion?

## Support Manager Persona (Cortex Analyst + Search)

16. What is the average first response time and resolution time for Critical priority tickets this month?
17. Which support category has the lowest CSAT (customer satisfaction) score?
18. How many tickets are currently Open or In Progress, grouped by assigned team?
19. What is the P95 resolution time for Tier1 vs Tier2 vs Tier3 teams?
20. Show ticket volume trends by category for the past 30 days.
21. Which day of the week has the highest ticket submission rate?

## Cortex Search Questions (Ticket/Compliance Search)

22. Find support tickets about failed withdrawals to Ledger hardware wallets.
23. Search for compliance events related to sanctions screening failures.
24. Find tickets where customers reported unexpected margin calls.
25. Search for any compliance alerts involving politically exposed persons in the EU jurisdiction.
26. Find support tickets about staking rewards not appearing.
27. Search compliance events for large transactions over $100,000 from US customers.

## ML Function Questions (Predictions)

28. Which customers are showing the most suspicious transaction patterns right now?
29. What is the predicted trading volume for BTC/USD and ETH/USD for next week?
30. Show me the top 10 customers most likely to churn and what we could do to retain them.
31. Who are our highest lifetime value customers and what segment are they in?
32. Which open futures positions have the worst risk grades and why?
33. Are there any recently submitted support tickets that appear to be misrouted to the wrong category?

## Blockchain Ontology Questions (DLT Knowledge)

34. What consensus mechanism does Ethereum use and how does it differ from Bitcoin?
35. How many active validators does Kraken operate across all supported chains?
36. List all ERC-20 tokens in the system with their total supply.
37. What is the difference between Proof of Work and Proof of Stake in terms of energy efficiency?
38. Which blockchains use some form of BFT (Byzantine Fault Tolerance) consensus?

## Multi-Tool Complex Questions

39. Show me high-LTV customers who also have open Critical support tickets — are we at risk of losing valuable customers?
40. Compare the trading volume trend with support ticket volume — do volume spikes correlate with more tickets?
41. Which customers have both high churn risk AND multiple compliance flags — could compliance friction be driving them away?
42. What is the total staked value for chains that use Proof of Stake consensus?
43. Find any VIP or Institutional customers with suspicious transaction patterns who also have unresolved compliance events.
