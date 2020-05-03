#!/bin/bash
set -e

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
source ${CURRENT_DIR}/../common/common.sh

[ $(id -u) != "0" ] && { ansi -n --bold --bg-red "please run by root"; exit 1; }

MYSQL_ROOT_PASSWORD=`random_string`

function init_system {
    export LC_ALL="en_US.UTF-8"
    echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
    locale-gen en_US.UTF-8
    locale-gen zh_CN.UTF-8

    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

    apt-get update
    apt-get install -y software-properties-common

    init_alias
}

function init_alias {
    alias sudowww > /dev/null 2>&1 || {
        echo "alias sudowww='sudo -H -u ${WWW_USER} sh -c'" >> ~/.bash_aliases
    }
}

function init_repositories {
    add-apt-repository -y ppa:ondrej/php
    add-apt-repository -y ppa:nginx/stable
    grep -rl ppa.launchpad.net /etc/apt/sources.list.d/ | xargs sed -i 's/ppa.launchpad.net/launchpad.proxy.ustclug.org/g'

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
    echo 'deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_8.x xenial main' > /etc/apt/sources.list.d/nodesource.list
    echo 'deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_8.x xenial main' >> /etc/apt/sources.list.d/nodesource.list

    apt-get update
}

function install_basic_softwares {
    apt-get install -y curl git build-essential unzip supervisor
}

function install_node_yarn {
    apt-get install -y nodejs yarn
    sudo -H -u ${WWW_USER} sh -c 'cd ~ && yarn config set registry https://registry.npm.taobao.org'
}

function install_php {
    apt-get install -y php7.2-bcmath php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-pgsql php7.2-readline php7.2-xml php7.2-zip php7.2-sqlite3
}

function install_others {
    apt-get remove -y apache2
    debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}"
    apt-get install -y nginx mysql-server redis-server memcached beanstalkd sqlite3
    chown -R ${WWW_USER}.${WWW_USER_GROUP} /var/www/
    systemctl enable nginx.service
}

function install_composer {
    curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
    chmod +x /usr/local/bin/composer
    sudo -H -u ${WWW_USER} sh -c  'cd ~ && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/'
}

call_function init_system "init system" ${LOG_PATH}
call_function init_repositories "init repositories" ${LOG_PATH}
call_function install_basic_softwares "install basic softwares" ${LOG_PATH}
call_function install_php "install PHP" ${LOG_PATH}
call_function install_others "install Mysql / Nginx / Redis / Memcached / Beanstalkd / Sqlite3" ${LOG_PATH}
call_function install_node_yarn "install Nodejs / Yarn" ${LOG_PATH}
call_function install_composer "install Composer" ${LOG_PATH}

ansi --green --bold -n "All done"
ansi --green --bold "Mysql root password:"; ansi -n --bold --bg-yellow --black ${MYSQL_ROOT_PASSWORD}
ansi --green --bold -n "Please run source ~/.bash_aliases to enable alias"
