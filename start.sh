docker-compose -f mysql-compose.yml up -d

until docker exec mysql-master sh -c 'mysql -u root -pP@ssw0rd-master -e "show databases;"'
do
    echo "Waiting for mysql_master database connection..."
    sleep 4
done

docker exec -ti mysql-master 'mysql' -uroot -pP@ssw0rd-master -vvv -e "CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'slavepass';"
docker exec -ti mysql-master 'mysql' -uroot -pP@ssw0rd-master -vvv -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';"
docker exec -ti mysql-master 'mysql' -uroot -pP@ssw0rd-master -vvv -e "FLUSH PRIVILEGES;"

MASTER_POSITION="$(docker exec mysql-master sh -c 'mysql -u root -pP@ssw0rd-master -e "show master status \G" | grep Position | grep -o '[0-9]*'' 2>/dev/null)"
MASTER_FILE="$(docker exec mysql-master sh -c 'mysql -u root -pP@ssw0rd-master -e "show master status \G" | grep File | sed 's/File://g' | xargs' 2>/dev/null)"

echo $MASTER_POSITION
echo $MASTER_FILE

until docker exec mysql-slave sh -c 'mysql -u root -pP@ssw0rd-slave -e "show databases;"'
do
    echo "Waiting for mysql_slave database connection..."
    sleep 4
done

docker exec -ti mysql-slave 'mysql' -uroot -pP@ssw0rd-slave -vvv -e "stop slave;"
docker exec -ti mysql-slave 'mysql' -uroot -pP@ssw0rd-slave -vvv -e "reset slave all;"

docker exec -ti mysql-slave 'mysql' -uroot -pP@ssw0rd-slave -vvv -e "change master to master_host='master',master_user='repl',master_password='slavepass',master_log_file='$MASTER_FILE',master_log_pos=$MASTER_POSITION;"

docker exec -ti mysql-slave 'mysql' -uroot -pP@ssw0rd-slave -vvv -e "start slave;"
docker exec -ti mysql-slave 'mysql' -uroot -pP@ssw0rd-slave -vvv -e "show slave status \G;"

docker-compose -f flyway_adminer-compose.yml up -d
