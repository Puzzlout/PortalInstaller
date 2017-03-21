cd $1
################################################################################
# Cloning if needed
################################################################################
#echo "Cloning the frontend..."
chmod -R 777 public/
rm -R public/
git clone https://github.com/Puzzlout/PortalFront.git
mv PortalFront public

################################################################################
# First install script of API
# 
# Input $1: the deploy folder
# Input $2: dev or prod
#
################################################################################
cd public/
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
