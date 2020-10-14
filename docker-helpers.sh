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
alias postgres-docker='docker run -d --rm --name postgres -e POSTGRES_HOST_AUTH_METHOD=trust -p 5432:5432 --volume postgres_data:/var/lib/postgresql/data postgres:alpine'
alias postgres-cli-docker='docker exec -it postgres psql --user postgres'

# MySQL
alias mysql-docker='docker run -d --rm --name mysql -e MYSQL_ROOT_PASSWORD=test -p 3306:3306 --volume mysql_data:/var/lib/mysql mysql'
alias mysql-cli-docker='docker exec -it mysql /bin/sh -c "mysql -uroot -p\"$MYSQL_ROOT_PASSWORD\""'

# Influxdb
alias influxdb-docker='docker run -d --rm --name influxdb -p 8086:8086 --volume influxdb_data:/var/lib/influxdb influxdb:alpine'

# Keycloak
alias keycloak-docker='docker run -d --rm --name keycloak -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -p 8080:8080 --volume keycloak_data:/opt/jboss/keycloak/standalone/data jboss/keycloak:5.0.0'

# Grafana
alias grafana-docker='docker run -d --rm --name grafana -p 3000:3000 -v grafana-storage:/var/lib/grafana grafana/grafana'

# Jaeger
alias jaeger-docker=' docker run -d --name jaeger -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 -p 5775:5775/udp -p 6831:6831/udp -p 6832:6832/udp -p 5778:5778 -p 16686:16686 -p 14268:14268 -p 14250:14250 -p 9411:9411 jaegertracing/all-in-one:1'

# Minio
alias minio-docker='docker run -d --rm --name minio -p 9000:9000 -v "${HOME}/srv/minio:/data" minio/minio server /data'

genisoimage() {
  docker run -it --rm -v "$(pwd):/work" mhutter/genisoimage $@
}
