FROM mageai/mageai:latest

ARG PROJECT_NAME=traffic_counting_paris

# Note: this overwrites the requirements.txt file in your new project on first run. 
# You can delete this line for the second run :) 
COPY requirements.txt /home/src/${PROJECT_NAME}/requirements.txt 

RUN pip3 install -r /home/src/${PROJECT_NAME}/requirements.txt

# Copying pipelines + config 
ADD mage_pipeline/ /home/src/${PROJECT_NAME} 

# Copy json GCP key
ADD secret /home/src/${PROJECT_NAME}/secret/
