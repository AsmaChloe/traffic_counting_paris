include .env
export
.PHONY: docker start

terraform up :
	@echo "Creating ressources..."

	cd terraform && terraform init

	cd terraform && export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)" && export TF_VAR_project=$(GOOGLE_PROJECT_ID) && export TF_VAR_data_lake_bucket_name="$(GOOGLE_PROJECT_ID)-data-late-bucket" && terraform plan

	cd terraform && export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)" && export TF_VAR_project=$(GOOGLE_PROJECT_ID) && export TF_VAR_data_lake_bucket_name="$(GOOGLE_PROJECT_ID)-data-late-bucket" && terraform apply

terraform down : 
	@echo "Deleting ressources..."

	cd terraform && export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)" && export TF_VAR_project=$(GOOGLE_PROJECT_ID) && export TF_VAR_data_lake_bucket_name="$(GOOGLE_PROJECT_ID)-data-late-bucket" && terraform destroy

docker:	
	@echo "Pulling MAGE AI image"

	docker build -t mageai/mageai:latest --build-arg PROJECT_NAME=$(PROJECT_NAME) --build-arg GOOGLE_SERVICE_ACC_KEY_NAME=$(GOOGLE_SERVICE_ACC_KEY_NAME) --build-arg GOOGLE_PROJECT_ID=$(GOOGLE_PROJECT_ID) -f ./docker/Dockerfile .
	cd docker && docker-compose up 