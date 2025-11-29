[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=21090506&assignment_repo_type=AssignmentRepo)

---

# University Performance Dashboard: Feasibility Analysis

---
# Part 1
## Title & Executive Summary

### **Title**
**School Enrollment and Performance Dashboard**

### **Project Goal**
A university wants to track enrollment and academic performance trends to improve curriculum planning and identify struggling departments. To build a live, interactive dashboard tracking enrollment trends and academic performance, enabling data-driven curriculum planning.

### **Technical Stack**
PySpark → DataBricks (Datawarehousing) → PowerBi

### **Feasibility Verdict**
**Highly Feasible.**  
The open-source, free-tier stack provides a scalable, live, and shareable solution that meets all project requirements without licensing costs.

---

## The Data Pipeline — PySpark to DataBricks

**Purpose:**  
To ingest raw, public academic data and load a clean, analytical schema into a resilient database.

### 1. Data Ingestion (PETL)

**PETL (Python ETL)** is the chosen lightweight, code-based transformation layer.

- **Input Data:** Public datasets (e.g., Kaggle/UCI Student Performance) simulating enrollment records, student demographics, and course grades.
- **Transformation Focus:**
  - **Data Cleaning:** Handling nulls, standardizing course names/codes.
  - **Data Enrichment:** Calculating `is_passing` (boolean) and numeric `gpa_points` for performance tracking.
  - **Aggregation (Critical):** Calculating departmental averages and retention rates using Python prior to loading.
- **Code Example:** Uses `petl.fromcsv()` for extraction and `petl.todb()` (via psycopg2 driver) for loading.

---

## Data Warehouse Implementation & Optimization (DataBricks)

**Objective:**  
Design and optimize DataBricks to function as the analytical presentation layer (DW).

### 1. Data Warehouse Architecture

| Layer | Tool | Role in DW Architecture |
|-------|------|--------------------------|
| Source | CSV/Kaggle Files | Raw input files (Enrollment, Grades) |
| Integration/ETL | PETL (Python) | Cleansing, transformation, and dimensional key creation (using DataBricks's UUID primary keys) |
| Presentation (DW) | DataBricks | Stores the final dimensional (Star) schema; utilized by Superset for live querying |

---

### 2. Data Warehouse Schema Implementation

- **Fact Table:** `fact_performance` — contains metric values like `final_grade`, `gpa_points`, `enrollment_date`.
- **Dimension Tables:**  
  - `dim_student`  
  - `dim_course`  
  - `dim_semester`  
  (Contain descriptive attributes for filtering and grouping.)

---

### 3. Performance Optimization Techniques

| Technique | DataBricks Implementation | Goal |
|------------|-----------------------------|------|
| **Indexing** | Secondary Indexes on frequently queried dimension attributes (e.g., `dim_student.major`, `dim_course.department_name`) and all Foreign Keys. | Accelerate lookups (JOINs) from fact to dimension tables. |
| **Time-Series Partitioning** | `PARTITION BY RANGE` (on `enrollment_date` or `semester_id`). | Improve performance by scanning only relevant time periods (e.g., "last 3 semesters"). |
| **Caching** | Client-Side Caching via Superset’s Redis cache. | Reduce unnecessary RU consumption and dashboard load latency. |
| **Query Tuning** | Materialized Views (future phase) for complex aggregated metrics like retention rate. | Offload complex calculations from BI tool to database. |

---

## Front-Runner Tool Review & Feasibility

### **Apache Superset: The BI Frontend**

| Feature Requirement | Superset Solution | Feasibility |
|----------------------|------------------|-------------|
| **Live Data** | Direct Live Querying via PostgreSQL connector (no static extracts required). | High |
| **Cost** | 100% Open Source; free sharing when self-hosted (via Docker). | High |
| **Rich Dashboard** | 40+ visualization types, SQL Lab, and cross-filtering. | High |
| **Deployment** | Easy setup with Docker Compose. | High |

---

### **Data Model & Key Dashboards**

1. **Enrollment Monitor:** Time-series charts on total enrollment and retention rates.  
2. **Performance Deep-Dive:** Scatter plot of Department GPA vs. Enrollment Count to flag struggling departments.  
3. **Risk Analysis:** Breakdown of pass/fail rates by student demographics (gender, entry year).

---

## Tool Alternatives — ETL & Database

### **ETL/Data Prep Alternatives**

| Alternative | License | Pros | Cons |
|--------------|----------|------|------|
| **pandas** | Open Source | Unrivaled data manipulation features; large community support. | Memory-intensive; not designed for ETL staging. |
| **Apache Airflow** | Open Source | Industry standard for scheduling complex pipelines (DAGs). | Orchestration-only; requires another tool like PETL; steep learning curve for small projects. |

---

### **Database Alternatives**

| Alternative | Free Tier | Pros | Cons |
|--------------|------------|------|------|
| **PostgreSQL (Self-Managed)** | Open Source | Rock-solid SQL engine; free forever. | No managed cloud tier; manual setup and replication required. |
| **YugabyteDB** | Open Source | Fully distributed SQL with Postgres compatibility. | Steeper setup; more complex cluster management than DataBricks Cloud Free Tier. |

---

## Tool Alternatives — Business Intelligence (BI)

| Alternative | License / Tier | Pros | Con (Why Superset Was Chosen) |
|--------------|----------------|------|-------------------------------|
| **Power BI Free Desktop** | Free | Industry-leading data modeling; high visual polish. | No free web sharing/refresh; Pro license required for publishing. |
| **Metabase** | Open Source | Extremely easy UI for non-technical reporting. | Limited visualization options vs. Superset. |
| **Tableau Public** | Free Cloud | Best-in-class visualization and storytelling. | No live database connection (only static extracts). |
| **Looker Studio (Google)** | Free Cloud | Easy sharing; seamless with Google Sheets/Analytics. | Complex DataBricks connectivity; requires JDBC/ODBC middleware. |

---

## **Final Conclusion**

**Power Bi** is the optimal BI choice.  
It uniquely delivers:
- Seamless connectivity 
- Supports logical schema  
- Free desktop version
- in-depth customizability options

Essential for a successful and scalable University Performance Dashboard demo.

---

# Part 2
## Objectives:
●	Design and implement a data warehouse using a preferred Data Warehousing tool.

●	Apply and analyze optimization techniques (e.g., indexing, partitioning, caching) to improve performance.

●	Develop a complete data warehouse architecture covering the source, integration, and presentation layers. 

●	Implement a data warehouse schema, including:

●	Fact and Dimension tables

●	Primary and Foreign Key relationships

●	Perform ETL or ELT processes and data quality and governance.

●	Demonstrate collaborative development and version control through GitHub Classroom.

---
## Goal for Finals:

●	For the finals submission, each group must accomplish the following:
-	Implement the end to end warehouse requirements.
-	Present the data warehouse implementation:


---

## School Enrollment and Performance Dashboard

### A university wants to track enrollment and academic performance trends to improve curriculum planning and identify struggling departments.

#### Business Questions
●	Which programs have the highest and lowest enrollment over the past 5 years?
- Analysis of the five-year enrollment trend identifies a dominant preference for two academic units: Business and Accountancy and Engineering and Architecture. Together, these departments represent a substantial portion of the university's student population, indicating a market-driven alignment of student interests and the institution's program offerings
- While the university boasts strength in high-demand fields, The Maritime and Aviation programs represent a niche but specialized segment of our academic portfolio. Their consistently lower enrollment figures over the past five years present a strategic consideration for targeted recruitment, enhanced marketing, or program review to explore potential for growth

●	What’s the pass rate per course or department?
- The mid-tier passing rates of high-enrollment programs like Business and Engineering suggest that student choice is driven by career prospects, not academic ease. Conversely, Maritime's low enrollment and low pass rate indicate a challenging cycle where small size and lower success may reinforce each other, requiring targeted support.

●	Are there gender-based or year-level performance trends?
- Students generally perform higher in lower year levels, and performance gradually declines as academic difficulty increases. This indicates increasing curricular rigor, course load, or potential support gaps in upper years.
- Male students consistently perform slightly higher than females across all year levels, but the gaps are extremely small (ranging from 0.02 to 0.12 points). These differences are not large enough to indicate any meaningful gender-based performance trend. Both genders follow the same pattern of gradual grade decline through higher years.

---
### Implemented tools and technologies
#### Core Technology Stack:

---

#### Apache Spark: Distributed Data Processing & Transformation

***Distributed Procesisng Architecture***: Efficiently handles large-scale educational datasets through parallel processing across clusters

***Star Schema Optimization****: Built-in capabilities for creating and managing dimensional models with optimal performance

***Big Data Compatibility***: Native support for processing massive volumes of student records, course data, and historical trends

***ETL Excellence***: Robust data transformation capabilities for cleaning, enriching, and preparing academic data

---

#### Databricks: Unified Data Platform & Lakehouse Architecture

***Accessible Entry Point***: Free community edition provides full-featured platform for development and prototyping

***Power BI Native Connectivity***: Built-in connectors and optimized integration for real-time dashboard connectivity

***Unified Analytics Platform***: Combines data engineering, data science, and business analytics in single environment

***Collaborative Workspace***: Shared notebooks, version control, and team collaboration features for academic teams

---

#### Power BI: Business Intelligence & Visualization

***Advanced Data Modeling***: Robust relationship management and calculated measures using DAX language

***Business User Alignment***: Intuitive interface perfectly suited for university administrators and department heads

***Enterprise Reporting Standards***: Industry-leading visualization capabilities meeting institutional reporting requirements

***Interactive Dashboarding***: Cross-filtering, drill-through, and natural language query capabilities

---

### Challenges encountered






