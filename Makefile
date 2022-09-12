cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))
venv:
	python3 -m venv venv
req:
	pip install -r requirements.txt
up:
	docker-compose --env-file ./.env up -d
config:
	docker-compose config
ps:
	docker-compose ps
db:
	docker-compose --env-file ./.env exec db psql -U postgres -c "CREATE DATABASE ${POSTGRES_DB};"
stop:
	docker-compose down
clear:
	docker system prune -a
	docker rm -f $(docker ps -a -q)
	docker volume rm $(docker volume ls -q)
drop:
	docker-compose --env-file ./.env exec db psql -U postgres -c "DROP DATABASE ${POSTGRES_DB};"
run:
	python3 main.py