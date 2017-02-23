# docker-centos7-php5-phalcon
create phalcon with centos7 and php5
run example
docker run -d -v /projects/webroot:/var/www/www_example.com/public_html -v /project/phptmp:/data/php/ -p 81:80 phalconsilentheartbeat/centos7-php5-phalcon


/projects/webroot is a your local path web root directory /project/phptmp is a php log, tmp and session directory

