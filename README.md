# flight-project
This project analyzes airline traffic from **Houston (IAH & HOU)** to major U.S. destinations between **2007–2009** using SQL and Power BI.

I focused on routes from Houston to:
- Los Angeles area: LAX, BUR, SNA, LGB  
- Seattle: SEA  
- New York City area: JFK, LGA, EWR  

The goal is to understand:
1. **Which routes are the busiest** from Houston (by passengers & flights)  
2. **How traffic changes by month** (busiest vs quietest months per route)  
3. **How traffic evolved from 2007 → 2009** for each route

## Data

- Source: [USA Airport Dataset on Kaggle](https://www.kaggle.com/datasets/flashgordon/usa-airport-dataset)  
- Granularity: flight aggregates by *origin–destination–date*, with counts of:
  - `passengers`
  - `seats`
  - `flights`
  - plus airport/city metadata and populations
 
## Tech Stack

- **Database:** PostgreSQL
- **Querying & transforms:** SQL (CTEs, views, window functions)
- **Visualization:** Power BI
- **Language:** SQL (optionally Python later for modeling)
