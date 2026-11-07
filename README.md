Hotel Bookings Data Engineering Project
Project Overview:
An end-to-end data engineering project that transforms raw hotel booking data into trusted business insights using Databricks Medallion Architecture.

Tech Stack:
Databricks
Databricks SQL
Lakeflow Spark Declarative Pipelines
Unity Catalog
SQL
GitHub
Databricks AI/BI Dashboard (or Power BI)

Architecture
Bronze → Silver → Gold → Dashboard

Bronze: Ingested and stored raw hotel booking data.
Silver: Cleaned data, handled missing values, removed duplicates and separated invalid bookings.
Gold: Created business-ready summary tables.
Dashboard: Visualised hotel performance, revenue, bookings and data quality.

Dataset:
1,316 raw booking records
20 columns
Synthetic hotel booking data
Covers hotel stays in 2025
Data Cleaning
Removed duplicate booking IDs.
Standardised text using TRIM and INITCAP.
Handled missing values.
Calculated missing nights using DATEDIFF.
Calculated missing total amounts.
Rejected invalid stay dates
Rejected negative room rates.
Retained cancelled bookings.

Gold Tables
gold_monthly_bookings
gold_hotel_summary
gold_room_type_summary
gold_channel_summary
gold_data_quality

Business Metrics
Total bookings
Cancelled bookings
Net revenue
Room nights
Average Daily Rate (ADR)
Cancellation rate
Average guest rating

Data Quality and Reconciliation
Validated the relationship:

Bronze Rows = Clean Rows + Rejected Rows + Duplicate Rows Removed

Dashboard
The dashboard contains three pages:
Overview
Hotels, Rooms & Channels
Data Quality
Project Structure
sql/ – SQL scripts for Bronze, Silver and Gold layers.
screenshots/ – Pipeline, tables and dashboard screenshots.
docs/ – Project documentation.
data/ – Dataset, if redistribution is permitted.

How to Run
Create a Databricks catalog and schema.
Create a Unity Catalog Volume.
Upload the source CSV.
Execute the SQL pipeline.
Run the Lakeflow pipeline.
Validate the Gold tables and reconciliation.
Connect the Gold tables to the dashboard.
Project Outcome
Built a repeatable data pipeline that converts messy hotel booking records into clean, trusted and business-ready analytical data.
