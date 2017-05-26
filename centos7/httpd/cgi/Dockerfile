FROM centos:latest
MAINTAINER Jijeesh <silentheartbeat@gmail.com>
#DOMAIN INFORMATION
ENV servn example.com
ENV cname www
ENV dir /var/www/
ENV user apache
ENV listen *
#Virtual hosting
RUN yum install -y httpd epel-release wget

RUN yum install -y httpd
RUN yum install -y --skip-broken perl-CPAN perl-CGI
RUN yum install -y mod_perl perl-CPAN perl-Archive-Zip  perl-Net-IP perl-XML-Simple perl-SOAP-Lite.noarch perl-ExtUtils-Embed perl-XML-Entities
RUN yum install -y perl-Jcode
RUN yum install -y perl-LWP*
RUN yum install -y perl-LWP-Protocol-https
RUN yum install -y perl-Crypt-SSLeay
RUN yum install -y perl-libwww-perl

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p $dir${cname}_$servn
RUN chown -R ${user}:${user}  $dir${cname}_$servn
RUN chmod -R 755  $dir${cname}_$servn
RUN mkdir /var/log/${cname}_$servn
RUN mkdir /etc/httpd/sites-available
RUN mkdir /etc/httpd/sites-enabled
RUN mkdir -p ${dir}${cname}_${servn}/logs
RUN mkdir -p ${dir}${cname}_${servn}/public_html


RUN printf '# * Hardening Apache \n\
ServerTokens Prod \n\
ServerSignature Off \n\
Header append X-FRAME-OPTIONS "SAMEORIGIN" \n\
FileETag None \n\
' \
>> /etc/httpd/conf/httpd.conf



RUN printf "IncludeOptional sites-enabled/${cname}_$servn.conf" >> /etc/httpd/conf/httpd.conf
####
RUN printf "#### $cname $servn \n\
<VirtualHost ${listen}:80> \n\
ServerName ${servn} \n\
ServerAlias ${alias} \n\
DocumentRoot ${dir}${cname}_${servn}/public_html \n\
ErrorLog ${dir}${cname}_${servn}/logs/error.log \n\
CustomLog ${dir}${cname}_${servn}/logs/requests.log combined \n\
<Directory ${dir}${cname}_${servn}/public_html> \n\
Options +ExecCGI \n\
LimitRequestBody 204800 \n\
AllowOverride All \n\
Order allow,deny \n\
Allow from all \n\
Require all granted \n\
AddLanguage en .en \n\
AddLanguage ja .ja \n\
AddCharset EUC-JP .euc \n\
AddCharset ISO-2022-JP .jis \n\
AddCharset SHIFT_JIS .sjis \n\
AddCharset UTF-8 .utf8 \n\
   AddHandler cgi-script .cgi .pl \n\
AddHandler application/x-httpd-php .html .php \n\
AddHandler application/x-httpd-cgi .env \n\
DirectoryIndex index.php index.php3 index.html index.htm index.cgi index.pl \n\
<LimitExcept GET POST HEAD> \n\
    deny from all \n\
</LimitExcept> \n\
<IfModule mod_headers.c> \n\
    Header set X-XSS-Protection \"1; mode=block\" \n\
    Header edit Set-Cookie ^(.*)$ $1;HttpOnly;Secure \n\
</IfModule> \n\

</Directory> \n\
</VirtualHost>\n" \
 > /etc/httpd/sites-available/${cname}_$servn.conf
RUN ln -s /etc/httpd/sites-available/${cname}_$servn.conf /etc/httpd/sites-enabled/${cname}_$servn.conf
########################################################

RUN ln -s /usr/bin/perl /usr/local/bin/perl

EXPOSE 80

RUN rm -rf /run/httpd/* /tmp/httpd*
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

