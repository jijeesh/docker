FROM centos:latest
MAINTAINER Jijeesh <silentheartbeat@gmail.com>
#DOMAIN INFORMATION
ENV servn example.com
ENV cname www
ENV dir /var/www/
ENV user apache
ENV listen *
#Virtual hosting
RUN yum install -y httpd
RUN mkdir -p $dir${cname}_$servn
RUN chown -R ${user}:${user}  $dir${cname}_$servn
RUN chmod -R 755  $dir${cname}_$servn
RUN mkdir /var/log/${cname}_$servn
####
RUN printf "#### $cname $servn \n\
<VirtualHost ${listen}:80> \n\
ServerName ${servn} \n\
ServerAlias ${alias} \n\
DocumentRoot ${dir}${cname}_${servn} \n\
<Directory ${dir}${cname}_${servn}> \n\
Options Indexes FollowSymLinks MultiViews \n\
AllowOverride All \n\
Order allow,deny \n\
Allow from all \n\
Require all granted \n\
</Directory> \n\
</VirtualHost>\n" \
 > /etc/httpd/conf.d/${cname}_$servn.conf

EXPOSE 80
EXPOSE 443

RUN rm -rf /run/httpd/* /tmp/httpd*
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

