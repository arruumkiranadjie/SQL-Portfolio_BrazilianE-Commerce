# SQL-Portfolio_BrazilianE-Commerce

# 🛒 Brazilian E-Commerce — Business Intelligence Analysis

> **Analytical case study on Olist's 100K marketplace orders — covering customer value, retention, seller performance, logistics risk, and payment anomalies, grounded in real 2016–2018 transaction data.**

[![Made With SQL](https://img.shields.io/badge/Made%20with-SQL-blue?style=flat-square&logo=postgresql)](https://www.postgresql.org/)
[![Dataset](https://img.shields.io/badge/Dataset-Olist%20Brazilian%20E--Commerce-orange?style=flat-square&logo=kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
[![Analyses](https://img.shields.io/badge/Analyses-10-green?style=flat-square)]()
[![Orders](https://img.shields.io/badge/Orders-100K%2B-purple?style=flat-square)]()
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Arruum%20Kiranadjie-0A66C2?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/arruumkiranadjie/)

---

## 📌 Overview

This project is a business-first, end-to-end SQL analysis of **Olist** — Brazil's largest e-commerce marketplace — using its publicly available transaction dataset from Kaggle. The dataset spans **2016 to 2018** and covers over **100,000 orders** across multiple relational tables, capturing the full commercial lifecycle from customer purchase through to delivery, payment, and review.

Each of the **10 analyses** in this project follows a structured analytical framework:

1. **Business Context** — why this question matters commercially
2. **Hypothesis** — the assumptions and definitions underpinning the query logic
3. **SQL Query** — the complete, production-quality query using advanced techniques
4. **Key Insight** — what the data actually reveals
5. **Business Recommendation** — prioritised, actionable next steps for the platform

Rather than treating SQL as an end in itself, this project uses data as a lens for strategic decision-making — the kind of thinking that drives real business value.

---

## 📂 Repository Structure

```
SQL-Portfolio_BrazilianE-Commerce
│
├── README.md                               ← README
│
├── queries                                 ← All SQL Query Files by Analysis
│   ├── 01_true_clv.sql
│   ├── 02_repeat_purchase_behaviour.sql    
│   ├── 03_order_funnel_dropoff.sql
│   ├── 04_late_delivery_impact.sql
│   ├── 05_seller_revenue_stability.sql
│   ├── 06_seller_sla_compliance.sql
│   ├── 07_category_profitability_vs_volume.sql
│   ├── 08_category_seasonality.sql
│   ├── 09_installment_risk.sql
│   └── 10_abnormal_payment_detection.sql
│
├── analysis                                 ← Full Analysis Report with Insights and Recommendations  
│   ├── BrazilianE-Commerce_Analysis.docx
│   └── BrazilianE-Commerce_Analysis.pdf
│
└── src                                      ← Source For This Project
    └── data                                 ← Datasets Used For This Project
        ├── olist_customers_dataset.csv
        ├── olist_order_items_dataset.csv
        ├── olist_order_payments_dataset.csv
        ├── olist_order_reviews_dataset.csv
        ├── olist_orders_dataset.csv
        ├── olist_products_dataset.csv
        ├── olist_sellers_dataset.csv
        └── product_category_name_translation.csv
```

---

## 🗄️ Dataset

The dataset is sourced from the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) on Kaggle. It is a real, anonymised commercial dataset covering the operations of Olist, a marketplace that connects small businesses across Brazil to customers through a single contract.

| Table | Description |
|---|---|
| `olist_orders_dataset` | Order lifecycle, statuses, and all key timestamps |
| `olist_customers_dataset` | Customer unique identity and geolocation |
| `olist_order_payments_dataset` | Payment values, types, and installment counts |
| `olist_order_reviews_dataset` | Customer review scores (1–5) and comments |
| `olist_order_items_dataset` | Item-level price, freight value, and seller mapping |
| `olist_products_dataset` | Product attributes and raw category names |
| `olist_sellers_dataset` | Seller identity and geolocation |
| `product_category_name_translation` | Portuguese-to-English category name mapping |

---

## 🔍 Analyses

### Domain 1 — Customer Intelligence

#### Analysis 01 · True Customer Lifetime Value (CLV)
**Business Goal:** Identify the most valuable customers not just by total spend, but by *how quickly* they generate value — because two customers spending R$5,000 over one month versus two years are not equally valuable.

**Approach:** Uses a multi-layer CTE to compute cumulative revenue per customer in chronological order, then identifies the exact timestamp each customer crossed 50% of their total lifetime spend — their `days_to_50pct_clv` milestone.

**Key Insight:** The majority of customers are single-purchase shoppers, meaning they reach 50% CLV on day zero. Within the multi-purchase segment, high-engagement customers reach 50% CLV within 30–45 days, while low-engagement customers take several months or longer — revealing a clear velocity gap that standard CLV metrics would flatten.

**SQL Techniques:** `SUM() OVER (PARTITION BY ... ORDER BY)` for cumulative revenue, `MIN()` with filtered window for milestone detection, `TIMESTAMPDIFF()` for days-to-event calculation.

---

#### Analysis 02 · Repeat Purchase Behaviour
**Business Goal:** Measure how quickly customers return for a second purchase — a critical early signal of retention health and lifetime value potential.

**Approach:** Uses `ROW_NUMBER()` to rank each customer's orders chronologically, isolates first and second purchase dates, then applies conditional aggregation to count customers returning within 30, 60, and 90-day windows.

**Key Insight:** Only **1.52%** of customers return within 30 days, rising to **1.84%** at 60 days and **2.05%** at 90 days — indicating critically low repeat purchase penetration. Customers who do not return within 90 days are unlikely to ever become repeat buyers, making the 30-day activation window the highest-leverage intervention point.

**SQL Techniques:** `ROW_NUMBER() OVER (PARTITION BY ...)`, `MAX(CASE WHEN ...)` for pivot logic, `TIMESTAMPDIFF()` with multi-bucket `CASE WHEN` aggregation.

---

### Domain 2 — Operations & Logistics

#### Analysis 03 · Order Funnel Drop-Off
**Business Goal:** Pinpoint exactly where in the order lifecycle — payment approval, seller shipment, or final delivery — the platform loses the most orders.

**Approach:** Models the full order funnel as four sequential stages using `CASE WHEN` logic against `order_status`, then computes stage-to-stage conversion rates.

**Key Insight:** **98.44%** of orders progress from placement to payment approval, confirming a low-friction checkout experience. The critical bottleneck lies between payment approval and shipment — a gap caused by seller confirmation delays, inventory allocation issues, and logistics handoff friction — representing the greatest operational risk in the entire funnel.

**SQL Techniques:** Multi-condition `CASE WHEN` within `SUM()`, stage-to-stage percentage calculations using nested aggregates.

---

#### Analysis 04 · Late Delivery Impact on Reviews
**Business Goal:** Quantify exactly how much delivery lateness damages customer satisfaction scores — moving the conversation from intuition to measurable reputational risk.

**Approach:** Flags each delivered order as late or on-time by comparing `order_delivered_customer_date` against `order_estimated_delivery_date`, then joins to review scores to compute average ratings and low-score (≤2 star) rates by delivery status.

**Key Insight:** Late deliveries receive significantly lower average review scores and generate a disproportionately high rate of 1–2 star reviews. More than half of customers who receive a late order leave a negative review — confirming delivery lateness as the primary driver of reputational damage on the platform.

**SQL Techniques:** Binary `CASE WHEN` flag for late detection, `AVG()` and conditional `SUM()/COUNT()` for comparative scoring, `GROUP BY is_late` for clean A/B output.

---

### Domain 3 — Seller Performance

#### Analysis 05 · Seller Revenue Stability
**Business Goal:** Distinguish stable, reliable sellers from volatile ones — because high average revenue with extreme month-to-month swings creates forecasting risk, dependency risk, and operational burden for the platform.

**Approach:** Computes monthly revenue per seller, filters to sellers active for at least 3 months to reduce noise, then derives a **Revenue Volatility Ratio** (`STDDEV / AVG`) as the primary stability metric.

**Key Insight:** A small subset of sellers show extreme volatility despite high average revenue, driven by seasonal spikes, promotional dependency, and unstable inventory pipelines. Sellers with lower average revenue but low volatility ratios are demonstrably more valuable to platform stability than high-revenue volatile counterparts.

**SQL Techniques:** `STDDEV()`, `AVG()`, `NULLIF()` to prevent division-by-zero, `HAVING COUNT(DISTINCT revenue_month) >= 3` for quality filtering, `DATE_FORMAT()` for monthly aggregation.

---

#### Analysis 06 · Seller SLA Compliance
**Business Goal:** Measure how reliably each seller ships orders within the committed timeframe, and identify underperformers before their non-compliance cascades into late deliveries, poor reviews, and customer churn.

**Approach:** Defines SLA compliance as `order_delivered_carrier_date <= order_estimated_delivery_date`, computes a compliance rate per seller, and filters to sellers with ≥20 orders to ensure statistical meaningfulness.

**Key Insight:** SLA compliance varies widely across the seller base. While most sellers maintain strong compliance, a significant subset consistently misses shipment deadlines. Volume does not guarantee compliance — some high-volume sellers exhibit the weakest SLA performance, indicating operational strain and logistics scaling failures.

**SQL Techniques:** Binary `CASE WHEN` SLA flag, `COUNT(DISTINCT order_id)` for deduplication, `WHERE total_orders >= 20` threshold filtering, `ORDER BY sla_compliance_rate ASC` to surface worst performers first.

---

### Domain 4 — Product & Payment Strategy

#### Analysis 07 · Category Profitability vs Volume
**Business Goal:** Expose the misalignment between order volume and revenue contribution across product categories — because high-volume categories are not always high-value, and the platform may be over-investing in low-ROI segments.

**Approach:** Computes total orders, total items, total revenue, and average order value per translated category, then uses `NTILE(4)` window functions to assign volume and revenue quartile rankings simultaneously — enabling 2×2 matrix-style categorisation.

**Key Insight:** Several top-volume categories fall into lower revenue quartiles, consuming disproportionate logistics and support resources per dollar earned. Conversely, low-volume, high-revenue categories signal premium pricing opportunity and untapped upsell potential. The category portfolio is unbalanced, with revenue concentration in a handful of categories creating demand shock and seasonality risk.

**SQL Techniques:** `NTILE(4) OVER (ORDER BY ...)` for dual-dimension quartile ranking, `COUNT(DISTINCT o.order_id)` vs `COUNT(oi.order_item_id)` for order vs item-level distinction, multi-table JOIN chain with translation mapping.

---

#### Analysis 08 · Category Seasonality Detection
**Business Goal:** Detect which product categories exhibit predictable seasonal demand patterns, enabling proactive inventory planning, targeted promotions, and logistics capacity management.

**Approach:** Two-query design — first computes absolute monthly order volumes by category over time; second derives a **Seasonality Index** (`monthly_orders / avg_monthly_orders`) to normalise demand relative to each category's own baseline.

**Seasonality Index Scale:**

| Index Value | Classification |
|---|---|
| > 1.2 | Strong seasonal peak |
| 0.9 – 1.2 | Normal demand |
| 0.5 – 0.8 | Seasonal low |
| < 0.5 | Severe demand drop |

**Key Insight:** Multiple categories show clear, consistent monthly peaks, while others maintain stable demand year-round — making them ideal candidates for baseline revenue forecasting. Peak months differ significantly across categories, meaning platform-wide promotions are inefficient without category-level targeting.

**SQL Techniques:** `DATE_FORMAT()` and `MONTH()` for temporal extraction, `AVG()` in a separate CTE for baseline computation, `NULLIF()` for safe division in index calculation.

---

#### Analysis 09 · Installment Risk Analysis
**Business Goal:** Assess whether installment payments — a common conversion lever in Brazilian e-commerce — introduce measurable risk to customer satisfaction and platform revenue quality.

**Approach:** Aggregates max installment count per order, segments orders into `installment` vs `single_payment` groups, and compares average review scores and low-rating rates (≤2 stars) across both segments.

**Key Insight:** Installment orders represent a meaningful share of total transactions and carry slightly lower average review scores alongside a higher proportion of 1–2 star reviews. Customers paying over time are more sensitive to delivery delays and product quality issues — dissatisfaction persists across billing cycles, amplifying negative sentiment even after successful delivery.

**SQL Techniques:** `MAX(payment_installments)` aggregated at order level, `CASE WHEN` for binary segmentation, `AVG()` and conditional `SUM()/COUNT()` for comparative review analysis.

---

#### Analysis 10 · Abnormal Payment Detection
**Business Goal:** Flag orders with suspicious or operationally anomalous payment characteristics to support fraud monitoring, dispute reduction, and payment system integrity.

**Approach:** Builds an order-level payment profile covering payment attempt count, total value, max installments, and payment type diversity. A rule-based anomaly flagging layer then classifies orders into four risk categories using logical thresholds.

**Anomaly Flags:**

| Flag | Threshold |
|---|---|
| Multiple Payments | `payment_attempts >= 3` |
| High Installments | `max_installments >= 10` |
| Mixed Payment Types | `payment_type_count > 1` |
| Overpayment | `total_payment_value > order_value × 1.2` |

**Key Insight:** Most orders follow simple payment patterns, but a small fraction exhibit combinations of these risk signals. Payment-to-order value mismatches are the strongest fraud signal. These anomalies should not be auto-blocked but routed for prioritised review — integrating with delivery performance and review history for a unified risk score.

**SQL Techniques:** `COUNT(DISTINCT payment_type)` for type diversity, `NULLIF()` for safe ratio calculation, multi-condition `CASE WHEN` for rule-based anomaly classification, `WHERE` clause with `OR` conditions for targeted flagging.

---

## 🛠️ SQL Techniques Reference

| Technique | Analyses Used |
|---|---|
| Common Table Expressions (CTEs) | All 10 analyses |
| Window Functions (`SUM OVER`, `ROW_NUMBER`, `NTILE`) | 01, 02, 07 |
| Conditional Aggregation (`CASE WHEN` in `SUM`/`AVG`) | 02, 03, 04, 09, 10 |
| Statistical Functions (`STDDEV`, `AVG`, `NULLIF`) | 05, 08 |
| Date Arithmetic (`TIMESTAMPDIFF`, `DATE_FORMAT`, `MONTH`) | 01, 02, 05, 08 |
| Multi-table JOINs (3–4 tables per query) | All 10 analyses |
| Threshold & Rule-based Flagging | 06, 10 |

---

## 💡 Key Findings Summary

- **Customer retention is critically low** — only 2.05% of customers make a second purchase within 90 days, making early activation campaigns the highest-ROI retention investment.
- **The funnel bottleneck is post-payment, not checkout** — 98.44% of orders pass payment approval, but the gap between payment and shipment is where the platform loses the most value.
- **Late delivery is the #1 review score killer** — more than half of customers who receive a late order leave a negative review, with disproportionate 1–2 star rates vs on-time deliveries.
- **Revenue stability matters more than revenue size** — sellers with moderate but consistent revenue outperform high-revenue volatile sellers on platform risk metrics.
- **High order volume ≠ high profitability** — several top-volume product categories fall in the bottom revenue quartile, consuming logistics resources that outpace their commercial contribution.

---

## 👤 About the Author

**Arruum Pratistha Kiranadjie**
Data Analyst | Quantitative Analyst

Mathematics graduate with a focus on applied analytics, business intelligence, and data-driven decision-making. Proficient in SQL, Python, Microsoft Power BI, and Microsoft Excel.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/arruumkiranadjie/)
[![GitHub](https://img.shields.io/badge/GitHub-arruumkiranadjie-181717?style=flat-square&logo=github)](https://github.com/arruumkiranadjie)

---

## 📄 License

This project is licensed under the MIT License. The dataset is publicly available via [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) under its original terms of use.

---

*If you found this project useful or insightful, feel free to ⭐ the repository.*
