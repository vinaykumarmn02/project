docker run -d -p  8080:80 -v /data/server/app:/var/www/site/app -v /data/server/log:/var/log/apache2 --name app2 web1.1:latest
