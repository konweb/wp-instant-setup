#!/usr/bin/env bash

set -ex;

if ! mysql -V ; then
    brew install mysql
    if [ $? -ne 0 ]; then
        mysql.server start
    fi
fi

DB_USER=${1-root}
DB_PASS=$2
DB_NAME=${3-wpdev}
PORT=${4-8080}
WP_PATH=$(pwd)/www
WP_TITLE='Welcome to the WordPress'
WP_DESC='Hello World!'

if [ -e "$WP_PATH/wp-config.php" ]; then
    open http://127.0.0.1:$PORT
    bin/wp server --host=0.0.0.0 --port=$PORT --docroot=$WP_PATH
    exit 0
fi

if ! bin/wp --info ; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar
    rm -fr bin && mkdir bin
    mv wp-cli-nightly.phar bin/wp
    chmod 755 bin/wp
fi

echo "path: www" > $(pwd)/wp-cli.yml

if [ $DB_PASS ]; then
    echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u$DB_USER -p$DB_PASS
    echo "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u$DB_USER -p$DB_PASS
else
    echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u$DB_USER
    echo "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u$DB_USER
fi

bin/wp core download --path=$WP_PATH --locale=en_US --force

if [ $DB_PASS ]; then
bin/wp core config \
--dbhost=localhost \
--dbname="$DB_NAME" \
--dbuser="$DB_USER" \
--dbpass="$DB_PASS" \
--dbprefix=wp_ \
--locale=en_US \
--extra-php <<PHP
define( 'JETPACK_DEV_DEBUG', true );
define( 'WP_DEBUG', false );
PHP
else
bin/wp core config \
--dbhost=localhost \
--dbname=$DB_NAME \
--dbuser=$DB_USER \
--dbprefix=wp_ \
--locale=en_US \
--extra-php <<PHP
define( 'JETPACK_DEV_DEBUG', true );
define( 'WP_DEBUG', false );
PHP
fi

bin/wp core install \
--url=http://127.0.0.1:$PORT \
--title="WordPress" \
--admin_user="admin" \
--admin_password="admin" \
--admin_email="admin@example.com"

bin/wp rewrite structure "/archives/%post_id%"

bin/wp option update blogname "$WP_TITLE"
bin/wp option update blogdescription "$WP_DESC"
bin/wp core language install ja && bin/wp core language activate ja

if [ -e "provision-post.sh" ]; then
    bash provision-post.sh
fi

# clone wp-instant-setup complated
if [ $? = 0 ]; then
    bash install-plugin.sh
fi

wp scaffold _s origin
wp theme delete twentyfifteen twentyfourteen

if [ $? = 0 ]; then
    curl http://loripsum.net/api/10/short/decorate/headers/ul/ol/dl/bq/code/link | wp post generate --post_type=post --post_content --count=10
    curl http://loripsum.net/api/10/short/decorate/headers/ul/ol/dl/bq/code/link | wp post generate --post_type=page --post_content --count=10
fi

if [ $? = 0 ]; then
    open http://127.0.0.1:$PORT
    bin/wp server --host=0.0.0.0 --port=$PORT --docroot=$WP_PATH
fi