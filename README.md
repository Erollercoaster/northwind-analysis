# Northwind Traders — SQL Exploratory Data Analysis

## Overview
This project performs exploratory data analysis on the Northwind Traders database, a fictional specialty food import/export company. The dataset spans 1996–1998 and covers sales transactions, customer relationships, employee performance, product inventory, and shipping logistics across a properly normalized 13-table relational schema.

Unlike previous projects built from flat Kaggle CSV files, this dataset arrives as a fully structured relational database, allowing analysis through multi-table JOINs across a real-world schema rather than querying a single denormalized table.

**Dataset:** [Northwind PostgreSQL](https://github.com/pthom/northwind_psql) — imported directly into PostgreSQL by running the provided `northwind.sql` file against a local database instance, no CSV import required.

**Tool:** PostgreSQL 14 + VSCode (SQLTools extension)

---

## Project Structure

```
northwind-analysis/
├── README.md
├── scripts/
│   ├── 01_explore_schema.sql
│   └── 02_eda_revenue.sql
```

---

## Schema Overview

The Northwind database consists of 13 tables organized around a central fact table (`order_details`) with dimension tables covering customers, products, employees, suppliers, shippers, categories, and geographic territories.

```
categories → products → order_details → orders → customers
                                       → employees
                                       → shippers
suppliers  → products
```

| Table | Description |
|---|---|
| `order_details` | Central fact table — line items per order with unit price, quantity, and discount |
| `orders` | Order headers — dates, shipping info, customer and employee references |
| `customers` | 91 customer companies across multiple countries |
| `products` | 77 products with pricing, stock levels, and reorder thresholds |
| `employees` | 9 sales employees with territory and reporting structure |
| `categories` | 8 product categories |
| `suppliers` | 29 product suppliers |
| `shippers` | 3 freight companies |
| `territories` | Sales territories mapped to employees and regions |
| `customer_demographics` | Empty in this dataset — excluded from analysis |
| `us_states` | Reference table for US state data |

---

## Key Questions & Findings

*To be completed upon finishing EDA.*

---

## Data Quality Notes

*To be completed upon finishing EDA.*

---

## Key SQL Concepts Applied

*To be completed upon finishing EDA.*

---

## Lessons Learned

*To be completed upon finishing EDA.*