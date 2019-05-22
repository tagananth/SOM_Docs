docker start zookeeper
echo "Waiting for 10 secs, Zookeeper services to start."
sleep 10

docker start kafka
echo "Waiting for 15 secs,Kafa services to start."
sleep 15

docker run --rm -e JAVA_OPTS='-Xmx128m' -p 8761:8761 -d tagsomsivisoft/som2.0:som-eureka-server
echo "Eureka Server Started for UAT"
sleep 5

docker run --rm -e JAVA_OPTS='-Xmx128m' -p 8090:8090 -d tagsomsivisoft/som2.0:som-oauth-server
echo "SOM Authentication Services Started for UAT"

docker run --rm -e JAVA_OPTS='-Xmx256m' \
-e somEnvironment=' \
-e somDomainUrl='http://ec2-52-22-83-229.compute-1.amazonaws.com' \
-e somUiServerUrl='http://ec2-52-22-83-229.compute-1.amazonaws.com' \
-e somAdminPort='8100' \
-e somAdminContext='som-admin-service' \
-e somOauthPort='8090' \
-e somOauthContext='som-oauth-server' \
-e somSenderPort='8200' \
-e somSenderContext='som-sender-service' \
-e somEurekaPort='8761' \
-e somEurekaContext='som-eureka-server' \
-e LOG4J.DIR='/home/ec2-user/logs' \
-p 8100:8100 -d tagsomsivisoft/som2.0:som-admin

echo "SOM Admin Services Started for UAT"

docker run --rm -e JAVA_OPTS='-Xmx256m' -p 8200:8200 -d tagsomsivisoft/som2.0:som-sender
echo "SOM Sender Services Started for UAT"

docker run --rm -e JAVA_OPTS='-Xmx128m' -p 8300:8300 -d tagsomsivisoft/som2.0:som-view
echo "SOM View Services Started for UAT"

docker run -p 80:80 -d tagsomsivisoft/som2.0:somui
echo "SOM2.0 Application UI Started for UAT"

cd som2.0-DashboardService
pm2 start index.js

cd ..

docker ps
