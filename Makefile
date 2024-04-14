include .env
export
.PHONY: docker start

terraform up :
	@echo "Creating ressources..."

	cd terraform && terraform init

	cd terraform && export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)" && terraform plan

	cd terraform && export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)" && terraform apply

terraform down : 
	@echo "Deleting ressources..."

	cd terraform && export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)" && terraform destroy

docker:	
	@echo "Pulling MAGE AI image"

	docker build -t mageai/mageai:latest --build-arg PROJECT_NAME=$(PROJECT_NAME) --build-arg GOOGLE_SERVICE_ACC_KEY_NAME=$(GOOGLE_SERVICE_ACC_KEY_NAME) -f ./docker/Dockerfile .
	cd docker && docker-compose up 