#!/bin/bash
set -ex

OS_VERSION=$(lsb_release -i|awk '{print $NF}')
NGINX_VERSION=1.12.2

have_nginx() {
  if which nginx &> /dev/null;then
    NGINX_BIN=$(which nginx)
    return  0
  fi
}

nginx_is_new_ver() {
  if have_nginx;then
     local CURRENT_VER=$(/usr/sbin/nginx -v 2>&1|awk -F / '{print $NF}')
     if [[ $CURRENT_VER  =~ "$NGINX_VERSION" ]];then
         echo "current nginx version is new version."
         exit 0
     fi
  fi
}

down_nginx() {
  if have_nginx ;then
    if ! [ -f /tmp/nginx-${NGINX_VERSION}.tar.gz ];then
       curl -L -o /tmp/nginx-${NGINX_VERSION}.tar.gz http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
       #rm  -f /tmp/nginx-${NGINX_VERSION}.tar.gz
    fi
    cd /tmp
    if [ -d /tmp/nginx-${NGINX_VERSION} ];then
       rm -rf /tmp/nginx-${NGINX_VERSION}
    fi
    tar -xf nginx-${NGINX_VERSION}.tar.gz
  fi
}

ng_build_parameter() {
  if have_nginx ;then
    NGINX_BUILD_PARAMETER=$($NGINX_BIN -V  2>&1| awk  -F':' '$0~/configure arguments:/{print $NF}')
    echo "$NGINX_BUILD_PARAMETER" > /data/scripts/nginx-old-parameter.log
    PARAMETER_LOOP=$(echo "$NGINX_BUILD_PARAMETER"|sed 's@ --@\n--@g'|sed 's@=.*@@g'|sed 's@--@@g')

    cd  /tmp/nginx-${NGINX_VERSION}
    for i in ${PARAMETER_LOOP};do
        if  ./configure --help|grep "$i" &> /dev/null ;then
           :
        else
          NGINX_BUILD_PARAMETER=$(echo "$NGINX_BUILD_PARAMETER"|sed -r "s@[^[:space:]]+${i}[^[:space:]]*@@g")
        fi
    done
  fi
}

make_nginx() {
  if have_nginx ;then
    cd /tmp/nginx-${NGINX_VERSION}
    if [[ $OS_VERSION =~ 'CentOS' ]] ;then
      echo "CENTOS"
      #yum install -y xxx
      #make
    elif [[ $OS_VERSION =~ 'Ubuntu' ]] ;then
      apt-get update
      apt-get install -y libpcre3-dev libgd-dev libgeoip-dev libssl-dev libxml2-dev libxslt-dev
      cd /tmp/nginx-${NGINX_VERSION}
      echo "./configure $NGINX_BUILD_PARAMETER"|sudo /bin/bash
      make
      echo "Ubuntu"
    fi
  fi
}

upgrade_nginx() {
  if have_nginx ;then
     cd /tmp/nginx-${NGINX_VERSION}
     mv $NGINX_BIN ${NGINX_BIN%/*}/nginx-old
     cp objs/nginx ${NGINX_BIN%/*}
     ${NGINX_BIN} -t
     if [ $? -eq 0 ];then
       if  [[ $OS_VERSION =~ 'Ubuntu' ]];then
         kill -USR2 `cat /run/nginx.pid`
         sleep 1
         test -f /run/nginx.pid.oldbin
         kill -QUIT `cat /run/nginx.pid.oldbin`
         echo "nginx update success."
         ${NGINX_BIN} -v
       elif [[ $OS_VERSION =~ 'CentOS' ]] ;then
         kill -USR2 `cat /var/run/nginx.pid`
         sleep 1
         test -f /var/run/nginx.pid.oldbin
         kill -QUIT `cat /var/run/nginx.pid.oldbin`
         echo "nginx update success."
         ${NGINX_BIN} -v
       fi
     else
       /bin/cp ${NGINX_BIN%/*}/nginx-old $NGINX_BIN
       echo "nginx update failed. rolling back."
     fi
  fi
}

main() {
nginx_is_new_ver
down_nginx
ng_build_parameter
make_nginx
upgrade_nginx
}

main
