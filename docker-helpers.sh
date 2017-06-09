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
alias mongo-docker='docker run -d --name mongo -p 27017:27017 --volume ${HOME}/srv/mongo:/data/db mongo'
alias mongo-cli-docker="docker run -it --link mongo:mongo --rm mongo sh -c 'exec mongo \"\$MONGO_PORT_27017_TCP_ADDR:\$MONGO_PORT_27017_TCP_PORT/test\"'"

# Redis
alias redis-docker='docker run -d --name redis -p 6379:6379/tcp redis:alpine'
alias redis-cli-docker="docker run -it --link redis:redis --rm redis:alpine sh -c 'exec redis-cli -h \"\$REDIS_PORT_6379_TCP_ADDR\" -p \"\$REDIS_PORT_6379_TCP_PORT\"'"

# Postgres
alias postgres-docker='docker run -d --name postgres -p 5432:5432 --volume ${HOME}/srv/postgres:/var/lib/postgresql/db postgres:alpine'
alias postgres-cli-docker="docker run -it --rm --link postgres:postgres postgres:alpine psql -h postgres -U postgres"

# MySQL
alias mysql-docker='docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=test -p 3306:3306 --volume ${HOME}/srv/mysql:/var/lib/mysql mysql'
alias mysql-cli-docker="docker run -it --rm --link mysql:mysql mysql sh -c 'exec mysql -h\"\$MYSQL_PORT_3306_TCP_ADDR\" -P\"\$MYSQL_PORT_3306_TCP_PORT\" -uroot -p\"\$MYSQL_ENV_MYSQL_ROOT_PASSWORD\"'"



# Create a volume-container
function docker-create-datacontainer {
  if [ $# -ne 3 ]; then
    echo "Usage: $0 <path> <name> <image>"
    return 1
  else
    docker create -v "$1" --name "${2}-data" "$3" /bin/true
  fi
}
