cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

up:
	sudo docker-compose --env-file ./.env up -d
config:
	sudo docker-compose config
ps:
	sudo docker-compose ps
db:
	sudo docker-compose --env-file ./.env exec db psql -U postgres -c "CREATE DATABASE ${POSTGRES_DB};"
stop:
	sudo docker-compose down
clear:
	sudo docker system prune -a
	sudo docker rm -f $(docker ps -a -q)
	sudo docker volume rm $(docker volume ls -q)
drop:
	sudo docker-compose --env-file ./.env exec db psql -U postgres -c "DROP DATABASE ${POSTGRES_DB};"
run:
	python3 main.py