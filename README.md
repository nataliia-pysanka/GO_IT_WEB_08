# Work with database
Create database which consist of:
* table of students
* table of subjects
* table of professors


## Synopsis

* `faker==14.2.0`
* `psycopg2-binary==2.9.3`
* `python-dateutil==2.8.2`
* `python-dotenv==0.21.0`
* `six==1.16.0`

## Installation

### Requirements

Docker-compose (https://docs.docker.com/compose/)

### Deploy

```bash
# Clone this repository using git
git clone git@github.com:nataliia-pysanka/GO_IT_WEB_08.git
# Change the directory
cd GO_IT_WEB_08
# Build and run the container
make up
# Create database
make db
# Run the script
make run
```

### Destroy

```bash
# Delete database
make drop
# Stop docker-container
make stop
# Clear the container
make clear
```

