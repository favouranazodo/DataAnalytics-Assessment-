## **1. High-Value Customers with Multiple Products**

**Scenario**:  
Identify customers who have both a **funded savings account** and a **funded investment plan**, sorted by total deposits.

**Approach**:
- Joined `savings_savingsaccount` and `plans_plan` on `owner_id` and filtered for accounts with non-zero balances.
- Grouped data by user and calculated total deposits.
- Sorted results in descending order of deposits.

**Challenges**:
- Matching savings and investment records on a common customer while avoiding duplicates.
- Ensuring we only consider “funded” (i.e., `amount > 0`) accounts.

---

## **2. Transaction Frequency Analysis**

**Scenario**:  
Classify users based on how often they transact monthly.

**Approach**:
- Calculated the **average transactions per month** for each customer using `COUNT(DISTINCT transaction_reference)` over months.
- Applied conditional logic to categorize frequency:
  - ≥10: High Frequency
  - 3–9: Medium Frequency
  - ≤2: Low Frequency
- Aggregated by frequency category for insights.

**Challenges**:
- Computing per-customer monthly averages required normalization over month counts.
- Needed to remove timestamp precision for grouping months effectively.

---

## **3. Account Inactivity Alert**

**Scenario**:  
Flag accounts with no activity in the past 365 days.

**Approach**:
- Combined data from `savings_savingsaccount` and `plans_plan` using a `UNION ALL`.
- Retrieved each account’s last transaction date using `MAX(transaction_date)` or `created_on`.
- Filtered for records where the last activity was over 365 days ago.
- Included calculated inactivity duration in days.

**Challenges**:
- Normalizing different transaction fields (`created_on` vs `transaction_date`) across tables.
- Preserving account-specific identifiers while unifying savings and investment records.

---

## **4. Customer Lifetime Value (CLV) Estimation**

**Scenario**:  
Estimate the potential value of each customer based on tenure and activity.

**Approach**:
- Calculated tenure as `TIMESTAMPDIFF(MONTH, created_on, CURDATE())`.
- Summed transaction amounts to get total volume.
- Used the formula:  
  `CLV = (Total Transactions / Tenure) * 12 * Average Profit per Transaction`  
  Where profit is 0.1% (`0.001`) of transaction value.
- Ordered by highest CLV.

**Challenges**:
- Prevented division by zero when tenure is 0 by rounding months and checking logic.
- Combined per-customer metrics while maintaining readability.

---
