[ -z "$__DOCKER_HELPERS" ] || return
export __DOCKER_HELPERS=loaded

alias docker-rm-all='docker ps -aq | xargs docker rm'
alias docker-cleanup='docker images -f dangling=true -q | xargs docker rmi'

docker-build() { docker build -t="mhutter/$(basename "$(pwd)")" .; }
dri() { docker run -it --rm "$1" bash; }

#
# Docker Services
#

# MongoDB
alias mongo-docker='docker run -d --rm --name mongo -p 27017:27017 --volume mongo_data:/data/db mongo'
alias mongo-cli-docker='docker exec -it mongo mongo'

# Redis
alias redis-docker='docker run -d --rm --name redis -p 6379:6379/tcp redis:alpine'
alias redis-cli-docker='docker exec -it redis redis-cli'

# Postgres
alias postgres-docker='docker run -d --rm --name postgres -p 5432:5432 --volume postgres_data:/var/lib/postgresql/data postgres:alpine'
alias postgres-cli-docker='docker exec -it postgres psql --user postgres'

# MySQL
alias mysql-docker='docker run -d --rm --name mysql -e MYSQL_ROOT_PASSWORD=test -p 3306:3306 --volume mysql_data:/var/lib/mysql mysql'
alias mysql-cli-docker='docker exec -it mysql mysql'

# Influxdb
alias influxdb-docker='docker run -d --rm --name influxdb -p 8086:8086 --volume influxdb_data:/var/lib/influxdb influxdb:alpine'
