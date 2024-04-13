include .env
export
.PHONY: docker start

terraform up :
	@echo "Creating ressources..."

	export TF_VAR_credentials="./../secret/$(GOOGLE_SERVICE_ACC_KEY_NAME)"
	
	cd "old terraform" && terraform init

	cd "old terraform" && terraform plan

	cd "old terraform" && terraform apply

terraform down : 
	@echo "Deleting ressources..."

	cd "old terraform" && terraform destroy

docker:	
	@echo "Pulling MAGE AI image"

	docker build -t mageai/mageai:latest --build-arg PROJECT_NAME=$(PROJECT_NAME) --build-arg GOOGLE_SERVICE_ACC_KEY_NAME=$(GOOGLE_SERVICE_ACC_KEY_NAME) -f ./docker/Dockerfile .
	cd docker && docker-compose up 