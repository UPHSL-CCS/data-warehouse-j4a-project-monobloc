[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=21090506&assignment_repo_type=AssignmentRepo)

---

# University Performance Dashboard: Feasibility Analysis

---

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
