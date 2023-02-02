#!/bin/bash

# run from project root directory
bash ./install/setup-env.sh

# import variables from .env file
. ./.env

echo "Containers creating..."
docker-compose up -d
echo "Containers created."

echo -e "Composers installation... Yes, there are two composers ${RYELLOW}:-D${COLOR_OFF}"
docker-compose exec php sh -c "composer install"
docker-compose exec php sh -c "cd ./cf7-telegram && composer install"

echo "WP setup preparing..."
# prepare file structure

# Now we have to clone plugin into WP plugins directory
make sync

[ ! -f ./index.php ] && echo "<?php
define( 'WP_USE_THEMES', true );
require( './wordpress/wp-blog-header.php' );" > index.php

if [ ! -f wp-config.php ]; then
  WPCONFIG=$(< ./install/.example/wp-config.php.template)
  printf "$WPCONFIG" $DB_NAME $DB_USER $DB_PASSWORD $DB_HOST > ./wp-config.php
fi

# install WP
echo "WP database init"
echo -e -n "${ICYAN}Would you init new instance (y), or do nothing (n)? ${RYELLOW}(y/n)${COLOR_OFF}"

read -r item
case "$item" in
    y|Y)
    echo "WP database init new instance..."
    docker-compose exec php sh -c "wp core install --url=$PROJECT_BASE_URL --title=\"$WP_TITLE\" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email"
    printf "${RGREEN}WP User Admin: ${RYELLOW}%s \n${RGREEN}WP User Pass: ${RYELLOW}%s${COLOR_OFF}\n" $WP_ADMIN $WP_ADMIN_PASS
      ;;

    *)
      echo "WP database has not been touched."
      ;;
esac

echo -e "${RRED}Do not forget update the hosts file with line:"
echo -e "${RGREEN}127.0.0.1 cf7tgdev.loc${COLOR_OFF}"
echo "Done."