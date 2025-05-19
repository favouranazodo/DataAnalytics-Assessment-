## **1. High-Value Customers with Multiple Products**

**Scenario**:  
Identify customers who have both a **funded savings account** and a **funded investment plan**, sorted by total deposits.

**Approach**:
- Joined `savings_savingsaccount` and `plans_plan` on `owner_id` and filtered for accounts with non-zero balances using the new_balance column where I assume is the final balance available if any transaction was made.
- Grouped data by user and calculated total deposits.
- Sorted results in descending order of deposits.

**Challenges**:
- There was no particular challenge as DISTINCT helps with duplicates.
- Ensuring we only consider “funded” (i.e., `amount > 0`) accounts but this is also based on assumption that all investments fall under the plans_plan table and the amount column is what represents funded accounts.

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
- Looking at a single owner_id sometimes the frequency of transaction was high in some months but low in some other months but this is where AVG (average) comes into play as it gives an approximate mid amount of times a customer transacts.

---

## **3. Account Inactivity Alert**

**Scenario**:  
Flag accounts with no activity in the past 365 days.

**Approach**:
- Combined data from `savings_savingsaccount` and `plans_plan` using a `UNION ALL`.
- Retrieved each account’s last transaction date using `MAX(transaction_date)` or `created_on`.
- Filtered for records where the last activity was over 365 days ago using today (19/05/2025) as reference which is CURDATE
- Included calculated inactivity duration in days.

**Challenges**:
- Normalizing different transaction fields (`created_on` vs `transaction_date`) across tables.
- Preserving account-specific identifiers while unifying savings and investment records.
- Assumption that type (investments or savings) is based of on which table data was extracted from
- owner_id had duplicates because same customer could have multiple plan types and even time of inactivity for same customer could vary.

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
- Assumed that the verification_call_amount column was the transaction value for each transaction but it would have been better if there are three levels of transaction status so as to know when the 0.1% really goes through because that would not work for a failed transaction but our data has multiple like having both "success" and "successful".

---
