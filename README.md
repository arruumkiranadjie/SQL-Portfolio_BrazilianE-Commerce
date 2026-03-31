# Brazilian E-Commerce Analysis - SQL Project

[![Query](https://img.shields.io/badge/Query%20-MySQL-0A66C2?style=for-the-badge&logo=mysql)](https://www.mysql.com/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle:%20Brazilian%20E--Commerce%20Olist-0A66C2?style=for-the-badge&logo=kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Arruum%20Kiranadjie-0A66C2?style=for-the-badge&logo=linkedIn)](https://www.linkedin.com/in/arruumkiranadjie/)

## 📌 Overview

This project is a business-first, end-to-end SQL analysis of **Olist** — Brazil's largest e-commerce marketplace — using its publicly available transaction dataset from Kaggle. The dataset spans **2016 to 2018** and covers over **100,000 orders** across multiple relational tables, capturing the full commercial lifecycle from customer purchase through to delivery, payment, and review.

Each of the **10 analyses** in this project follows a structured analytical framework:

1. **Business Context:**  Why this question matters commercially
2. **Hypothesis:**  the assumptions and definitions underpinning the query logic
3. **SQL Query:**  the complete, production-quality query using advanced techniques
4. **Key Insight:**  what the data actually reveals
5. **Business Recommendation:**  prioritised, actionable next steps for the platform

Rather than treating SQL as an end in itself, this project uses data as a lens for strategic decision-making — the kind of thinking that drives real business value.

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

## 📊 Dataset 

The Dataset is sourced from the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) on Kaggle. It is a real, anonymised commercial dataset covering the operations of Olist, a marketplace that connects small businesses across Brazil to customers through a single contract.

| Table | Description |
|---|---|
| `olist_orders_dataset` | Order lifecycle, statuses, and all key timestamps |
| `olist_customers_dataset` | Customer unique identity and geolocation |
| `olist_order_payments_dataset` | Payment values, types, and installment counts |
| `olist_order_reviews_dataset` | Customer review scores and key timestamps |
| `olist_order_items_dataset` | Item-level price, freight value, and seller mapping |
| `olist_products_dataset` | Product attributes and raw category names |
| `olist_sellers_dataset` | Seller identity and geolocation |
| `product_category_name_translation` | Portuguese-to-English category name mapping |

## 🧠 Analyses


1.    **True Customer Lifetime Value (CLV):** Identifies top-tier customers by measuring total spend and the velocity of value generation to prioritize high-impact retention.

2.    **Repeat Purchase Behaviour:** Quantifies how quickly customers return within 30-90 days to optimize early engagement and remarketing timing.

3.    **Order Funnel Drop-Off:** Maps the lifecycle from payment to delivery to pinpoint operational bottlenecks and reduce friction in the fulfillment chain.

4.    **Late Delivery Impact on Reviews:** Quantifies how shipping delays damage customer sentiment and review scores to treat lateness as a primary reputational risk.

5.    **Seller Revenue Stability:** Measures monthly volatility and concentration at the seller level to identify reliable partners and predict platform cash flow.

6.    **Seller SLA Compliance:** Tracks shipment speed against promised deadlines to identify underperforming sellers and mitigate platform trust erosion.

7.    **Category Profitability vs Volume:** Evaluates product categories to distinguish between high-effort/low-margin items and strategic high-value growth areas.

8.    **Category Seasonality Detection:** Uses historical order patterns to detect demand spikes, allowing for better inventory planning and targeted promotions.

9.    **Installment Risk Analysis:** Examines how payment flexibility impacts review scores and long-term financial risk across multiple billing cycles.

10.   **Abnormal Payment Detection:** Identifies suspicious payment characteristics and mismatches to mitigate fraud, disputes, and operational anomalies.

## 🛠️ SQL Techniques Reference

| Technique | Implementation |
|---|---|
| Common Table Expressions (CTEs) | `WITH` |
| Window Functions | `SUM OVER`, `ROW_NUMBER`, `NTILE` |
| Conditional Aggregation | `CASE WHEN`, `HAVING` in `GROUP BY`|
| Statistical Functions | `STDDEV`, `AVG`, `NULLIF` |
| Date Arithmetic | `TIMESTAMPDIFF`, `DATE_FORMAT`, `MONTH` |
| Multi-table JOINs | `JOIN` |

## 💡 Key Findings Summary

- **Customer retention is critically low** — only 2.05% of customers make a second purchase within 90 days, making early activation campaigns the highest-ROI retention investment.
- **The funnel bottleneck is post-payment, not checkout** — 98.44% of orders pass payment approval, but the gap between payment and shipment is where the platform loses the most value.
- **Late delivery is the #1 review score killer** — more than half of customers who receive a late order leave a negative review, with disproportionate 1–2 star rates vs on-time deliveries.
- **Revenue stability matters more than revenue size** — sellers with moderate but consistent revenue outperform high-revenue volatile sellers on platform risk metrics.
- **High order volume ≠ high profitability** — several top-volume product categories fall in the bottom revenue quartile, consuming logistics resources that outpace their commercial contribution.

## 👤 About the Author

**Arruum Pratistha Kiranadjie**
Data Analyst | Quantitative Analyst

Mathematics graduate with a focus on applied analytics, business intelligence, and data-driven decision-making. Proficient in SQL, Python, Microsoft Power BI, and Microsoft Excel.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/arruumkiranadjie/)
[![GitHub](https://img.shields.io/badge/GitHub-arruumkiranadjie-181717?style=flat-square&logo=github)](https://github.com/arruumkiranadjie)

## 📄 License

This project is licensed under the MIT License. The dataset is publicly available via [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) under its original terms of use.

---

*If you found this project useful or insightful, feel free to ⭐ the repository.*
