FROM mageai/mageai:latest

ARG PROJECT_NAME=traffic_counting_paris

# Copying pipelines + config 
ADD mage_pipeline/ /home/src/${PROJECT_NAME} 

# Copy json GCP key
ADD secret /home/src/${PROJECT_NAME}/secret/

# Copy DBT project
ADD dbt /home/src/${PROJECT_NAME}/dbt/