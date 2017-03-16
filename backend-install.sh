cd $1                                                                                                              

################################################################################
# Cloning if needed
################################################################################
#echo "Cloning the backend..."
#chmod -R 777 portal_backend/                                                                                                
#rm -R portal_backend/
#git clone https://github.com/Puzzlout/PortalApi.git
#mv PortalApi portal_backend

################################################################################
# First install script of API
# 
# Input $1: the deploy folder
# Input $2: dev or prod
#
################################################################################
cd portal_backend/
git pull
#last_release=$(git describe --tags)
#git checkout tags/$last_release -b v$last_release
echo "Run composer..."
#cp ../composer.phar composer.phar
composer install
composer update
echo "IMPORTANT: Require a mysql root user with no password"
php bin/console doctrine:database:create --if-not-exists
php bin/console doctrine:schema:update --dump-sql
php bin/console doctrine:schema:update --force
echo "IMPORTANT: Admin user created with user admin, pass admin"
php bin/console fos:user:create jeremie contact@puzzlout.com "Puzzl0ut%2017" --super-admin
php bin/console assets:install --env=$2 --symlink
php bin/console cache:warmup --env=$2
cd ../..


