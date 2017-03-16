cd $1
################################################################################
# Cloning if needed
################################################################################
#echo "Cloning the frontend..."
chmod -R 777 portal_frontend/
rm -R portal_frontend/
git clone https://github.com/Puzzlout/PortalFront.git
mv PortalFront portal_frontend

################################################################################
# First install script of API
# 
# Input $1: the deploy folder
# Input $2: dev or prod
#
################################################################################
cd portal_frontend/
git pull
#last_release=$(git describe --tags)
#git checkout tags/$last_release -b v$last_release
echo "Run composer..."
composer install
composer update
echo "IMPORTANT: Require a mysql root user with no password"
php bin/console doctrine:database:create --if-not-exists
php bin/console doctrine:schema:update --force
php bin/console doctrine:schema:update --dump-sql
php bin/console doctrine:schema:update --force
php bin/console lexik:translations:import AppBundle --cache-clear
php bin/console assets:install --env=$2 --symlink
php bin/console assetic:dump --env=$2 --no-debug
cd ../..
