FROM centos:latest
MAINTAINER Jijeesh <silentheartbeat@gmail.com>
#DOMAIN INFORMATION
ENV servn example.com
ENV cname piwik
ENV dir /var/www/
ENV user apache
ENV listen *
#Virtual hosting
RUN yum install -y httpd
RUN yum install -y --skip-broken php php-devel php-mysqlnd php-common php-pdo php-mbstring php-xml php-imap php-curl
RUN yum install -y GeoIP-devel php-pear php-pecl-geoip
RUN mkdir -p $dir${cname}_$servn
RUN chown -R ${user}:${user}  $dir${cname}_$servn
RUN chmod -R 755  $dir${cname}_$servn
RUN mkdir /var/log/${cname}_$servn
RUN mkdir /etc/httpd/sites-available
RUN mkdir /etc/httpd/sites-enabled
RUN mkdir -p ${dir}${cname}_${servn}/logs
RUN mkdir -p ${dir}${cname}_${servn}/public_html
RUN printf "IncludeOptional sites-enabled/${cname}_$servn.conf" >> /etc/httpd/conf/httpd.conf
####
RUN printf "#### $cname $servn \n\
<VirtualHost ${listen}:80> \n\
ServerName ${cname}.${servn} \n\
ServerAlias ${cname} \n\
DocumentRoot ${dir}${cname}_${servn}/public_html \n\
ErrorLog ${dir}${cname}_${servn}/logs/error.log \n\
CustomLog ${dir}${cname}_${servn}/logs/requests.log combined \n\
<Directory ${dir}${cname}_${servn}/public_html> \n\
Options Indexes FollowSymLinks MultiViews \n\
AllowOverride All \n\
Order allow,deny \n\
Allow from all \n\
Require all granted \n\
</Directory> \n\
</VirtualHost>\n" \
 > /etc/httpd/sites-available/${cname}_$servn.conf
RUN ln -s /etc/httpd/sites-available/${cname}_$servn.conf /etc/httpd/sites-enabled/${cname}_$servn.conf


RUN sed -i \
        -e 's/^expose_php = .*/expose_php = Off/' \
        -e 's/^display_errors = .*/display_errors = On/' \
        -e 's/^log_errors = .*/log_errors = Off/' \
        -e 's/^short_open_tag = .*/short_open_tag = On/' \
        -e 's/^error_reporting = .*/error_reporting = E_WARNING \& ~E_NOTICE \& ~E_DEPRECATED/' \
        -e 's/^memory_limit = .*/memory_limit = 512M/' \
        -e 's/^max_execution_time = .*/max_execution_time = 0/' \
        -e 's#^;error_log = syslog#;error_log = syslog\nerror_log = /data/php/log/scripts-error.log#' \
        -e 's/^file_uploads = .*/file_uploads = On/' \
        -e 's/^upload_max_filesize = .*/upload_max_filesize = 4M/' \
        -e 's/^allow_url_fopen = .*/allow_url_fopen = Off/' \
        -e 's/^allow_url_include = .*/allow_url_include  = Off/' \
        -e 's/^sql.safe_mode = .*/sql.safe_mode = On/' \
        -e 's/^post_max_size = .*/post_max_size = 5K/' \
        -e 's/^session.name = .*/session.name = PSID/' \
        -e 's#^;session.save_path = .*#session.save_path = /data/php/session#' \
        -e 's/^session.cookie_httponly.*/session.cookie_httponly = On/' \
        -e 's#^;upload_tmp_dir.*#upload_tmp_dir = /data/php/tmp#' \
        /etc/php.ini


#RUN RUN echo "extension=geoip.so" >> /etc/php.d/geoip.ini
RUN printf "extension=geoip.so \n\
geoip.custom_directory=${dir}${cname}_${servn}/public_html/misc \n" \
 > /etc/php.d/geoip.ini

EXPOSE 80
EXPOSE 443

RUN rm -rf /run/httpd/* /tmp/httpd*
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]


