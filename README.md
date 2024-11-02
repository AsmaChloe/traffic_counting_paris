# Traffic Counting Paris

This capstone project is part of the [Data Engineer Zoomcamp by DataTalksClub](https://github.com/DataTalksClub/data-engineering-zoomcamp). It automates traffic data collection and analysis for Paris, providing insights into the city’s traffic patterns.

## Project Overview

The project builds a fully automated data pipeline that retrieves traffic data from Paris's Traffic Counting sensors every hour. It orchestrates the data flow from ingestion to dashboard visualization to provide timely updates on traffic conditions.

### Objectives
1. **Infrastructure Setup**: Managed via Terraform, the project infrastructure is deployed to Google Cloud.
2. **Data Ingestion**: Using Mage AI, data is ingested hourly from the Paris traffic API into a Google Cloud Storage bucket.
3. **Data Transformation**: Data is then loaded into BigQuery, where DBT transformations are applied to clean, structure, and enhance the data.
4. **Dashboard**: A dashboard, built in Looker/Google Data Studio, enables monitoring of traffic conditions across Paris in near real-time.

## Dataset Details

The data originates from the [Paris Open Data Portal](https://opendata.paris.fr/explore/dataset/comptages-routiers-permanents/information). The dataset, updated daily, provides traffic sensor readings from across the city. Due to API limits (10,000 records per call), the data is ingested hourly to stay within the cap.

### Key Attributes
| Attribute         | Type      | Description                                                                                       |
|-------------------|-----------|---------------------------------------------------------------------------------------------------|
| iu_ac            | INTEGER   | Unique identifier for the traffic data arc, matching the "iu_ac" in the reference dataset.        |
| libelle          | TEXT      | Name of the road or road segment measured by the arc.                                             |
| iu_nd_amont      | INTEGER   | Unique identifier for the upstream node of the arc.                                               |
| libelle_nd_amont | TEXT      | Name of the upstream node of the arc.                                                             |
| iu_nd_aval       | INTEGER   | Identifier for the downstream node of the arc.                                                    |
| libelle_nd_aval  | TEXT      | Name of the downstream node of the arc.                                                           |
| t_1h             | TIMESTAMP | Hourly timestamp marking the end of the measurement period (e.g., "2019-01-01 01:00:00").        |
| q                | REAL      | Vehicle count during the hour.                                                                    |
| k                | REAL      | Occupancy rate, indicating the percentage of time vehicles occupy the measurement point.          |
| etat_trafic      | INTEGER   | Traffic status: Unknown, Fluid, Pre-saturated, Saturated, Blocked.                                |
| etat_barre       | INTEGER   | Arc availability for traffic (Open, Barred, Invalid).                                             |
| Dessin           | TEXT      | Schematic representation of the arc for the given "iu_ac" and "t_1h" values.                     |

**Additional Geographical Dataset**: A secondary dataset provides geographical data for the sensors. Since updates are rare, this is added as a static seed in DBT.

## Technology Stack

- **Infrastructure & Deployment**: Docker, Terraform
- **Orchestration**: Mage AI
- **Storage & Warehousing**: Google Cloud Storage (data lake), BigQuery (data warehouse)
- **Data Transformation**: DBT
- **Visualization**: Looker/Google Data Studio

## Pipeline Overview

![Pipeline Diagram](/images/data_pipeline.drawio.png)

### Infrastructure
Using Terraform, all necessary Google Cloud resources (such as Storage buckets and BigQuery datasets) are provisioned automatically.

### Data Ingestion
Mage AI schedules hourly data pulls from the API. Since daily ingestion exceeds the API’s record limit, an hourly batch ingestion is optimal, avoiding overflow and ensuring all data is ingested.

### Data Warehousing
Data is stored in BigQuery, partitioned by the `t_1h` timestamp and clustered by road name (`libelle`). This setup optimizes storage efficiency and retrieval speed for date-based queries.

### Data Transformation
With DBT, data is cleaned, validated, and enriched. A geographic column is created to enable map-based visualization, and the sensor and referential data are joined to produce a comprehensive final table.

### Dashboard
The interactive [dashboard](https://lookerstudio.google.com/reporting/ec19f889-5750-4f6b-af04-e4fada89543d) presents the following visualizations:
- Current traffic state
- Heat map of traffic count by road
- Roads ranked by occupancy rate
- Hourly traffic volume trends
- Hourly occupancy rate trends
- Traffic status distribution by hour

The dashboard provides insights into high-traffic areas, particularly on the city's main thoroughfares, such as the Boulevard Périphérique, where congestion is typically high during rush hours.

## Reproducibility

### Prerequisites
- Linux environment (WSL or native)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Terraform](https://developer.hashicorp.com/terraform/install)

### Setup Instructions

1. **Create a Google Cloud Account** and [set up a new project](https://developers.google.com/workspace/guides/create-project?hl=fr).
2. **Configure Environment**:
   - Copy your project ID into a `.env` file as `GOOGLE_PROJECT_ID`.
   - Set up a service account with **BigQuery Admin** and **Storage Admin** roles.
   - Add the service account’s JSON key to the `secret` folder and specify its path as `GOOGLE_SERVICE_ACC_KEY_NAME` in `.env`.

3. **Infrastructure Setup**:
   - Start Docker Desktop.
   - From the project root, run `make terraform up` to deploy resources.
   - Run `make docker` to build and start the Docker container.

4. **Tear Down**:
   - To remove resources, run `make terraform down`.

### Data Collection

The initial Docker run triggers the first data collection, capturing data from the previous day (in UTC) at the current hour. The pipeline continues to fetch updates hourly.

To gather historical data:
1. Access the [Mage AI Pipeline Dashboard](http://localhost:6789/pipelines).
2. Select the `get_historical_data` pipeline and configure the date range (`date_start` and `date_end`) in the pipeline’s trigger settings.
3. Be cautious with date ranges to avoid API rate limits and system overload.

## Reflection

This project provided valuable hands-on experience in data engineering. Potential improvements include:
- Fully migrating the solution to the cloud to remove dependency on Docker.
- Exploring optimizations to handle larger data batches daily, despite the API limitations.

