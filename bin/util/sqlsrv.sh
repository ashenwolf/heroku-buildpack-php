#!/bin/bash
# Build Path: /app/.heroku/php/

install_sqlsrv_ext() {
	echo "-----> Building SqlSrv Extension..."

	###########################################################################
	# SQL SERVER:
	###########################################################################

	###########################################################################
	# Ref from https://github.com/Microsoft/msphpsql/wiki/Dockerfile-for-adding-pdo_sqlsrv-and-sqlsrv-to-official-php-image
	###########################################################################
	# Add Microsoft repo for Microsoft ODBC Driver 13 for Linux
	set -eux
	apt-get install -y apt-transport-https gnupg
	curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
	curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list
	apt-get update -yqq
	# Install Dependencies
	ACCEPT_EULA=Y apt-get install -y unixodbc unixodbc-dev libgss3 odbcinst msodbcsql locales
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen
	# Install pdo_sqlsrv and sqlsrv from PECL. Replace pdo_sqlsrv-4.1.8preview with preferred version.
	pecl install pdo_sqlsrv-4.1.8preview sqlsrv-4.1.8preview
	docker-php-ext-enable pdo_sqlsrv sqlsrv
	php -m | grep -q 'pdo_sqlsrv'
	php -m | grep -q 'sqlsrv'
}
