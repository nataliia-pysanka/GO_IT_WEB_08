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
table:
	sudo docker cp ./create_tables.sql db-${APP_NAME}:/usr/src/create_tables.sql
	sudo docker-compose --env-file ./.env exec db psql -U postgres -d ${POSTGRES_DB} -f /usr/src/create_tables.sql
insert:
	sudo docker cp ./DB_function.sql db-${APP_NAME}:/usr/src/DB_function.sql
	sudo docker-compose --env-file ./.env exec db psql -U postgres -d ${POSTGRES_DB} -f /usr/src/DB_function.sql

	sudo docker cp ./cs_insert_data.sql database_db_1:/usr/src/cs_insert_data.sql
	sudo docker-compose --env-file ./.env exec db psql -U postgres -d cs -f /usr/src/cs_insert_data.sql
stop:
	sudo docker-compose down
clear:
	sudo docker system prune -a
	sudo docker rm -f $(docker ps -a -q)
	sudo docker volume rm $(docker volume ls -q)
drop:
	sudo docker-compose --env-file ./.env exec db psql -U postgres -c "DROP DATABASE ${POSTGRES_DB};"