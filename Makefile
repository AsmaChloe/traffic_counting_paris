include .env
export
.PHONY: setup start

setup:
	@echo $(PROJECT_NAME)
	@echo "Pulling MAGE AI image"

	docker build -t mageai/mageai:latest --build-arg PROJECT_NAME=$(PROJECT_NAME) --build-arg GOOGLE_SERVICE_ACC_KEY_NAME=$(GOOGLE_SERVICE_ACC_KEY_NAME) .
	docker-compose up 