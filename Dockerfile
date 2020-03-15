FROM centos:6.8

RUN yum install -y ntpdate crontabs
RUN service crond start
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN ntpdate ntp6.aliyun.com
RUN echo "*/3 * * * * /usr/sbin/ntpdate ntp6.aliyun.com  &> /dev/null" > /tmp/crontab
RUN crontab /tmp/crontab

RUN yum install -y krb5-libs krb5-deve krb5-workstation pam_krb5
RUN yum install -y samba samba-client samba-winbind-clients samba-winbind samba-common samba4-libs samba-swat

RUN echo '123456' |passwd root --stdin

RUN sed -i 's/only_from.*=.*/only_from = 0.0.0.0/g' /etc/xinetd.d/swat
RUN sed -i 's/disable.*=.*/disable = no/g' /etc/xinetd.d/swat
#RUN sed -i 's/user.*=.*/user = root/g' /etc/xinetd.d/swat

RUN chkconfig crond on && chkconfig smb on && chkconfig xinetd on

EXPOSE 137
EXPOSE 138
EXPOSE 139
EXPOSE 445
EXPOSE 901

CMD smbd && service  xinetd restart
