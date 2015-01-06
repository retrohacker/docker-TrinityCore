![TrinityCore](http://www.trinitycore.org/f/public/style_images/1_trinitycore.png) TrinityCore/db
===

[![docker.ico](http://dockeri.co/image/trinitycore/db)](https://registry.hub.docker.com/u/trinitycore/db/)

The TrinityCore database, built with [mariadb](https://registry.hub.docker.com/_/mariadb/). This is one of the three images required to have a functioning TrinityCore server. This page will instruct you on setting up all three.

# Prerequisite

You must have already run trinitycore/extractor. If not, please follow the instructions [here](https://registry.hub.docker.com/u/trinitycore/extractor/) and then return to this page when you are finished.

# Usage

## DataBase

To run the TrinityCore server, you must run three images: `trinitycore/db`, `trinitycore/authserver`, and `trinitycore/worldserver`.

To setup the database, simply run:

`docker run -d -e "MYSQL_ROOT_PASSWORD=GreatBeyond" --name tc-db`

### Description

* The `-d` instructs docker to run this as a daemon.
* `-e "MYSQL_ROOT_PASSWORD=GreatBeyond"` the password for our database. This *CAN NOT* be changed, it must remain `GreatBeyond`. Case matters.
* `--name` gives us a static name that we will use later on when linking this container to other docker containers.

*NOTE* do not expose any ports on local host unless you know what you are doing, we can greatly limit access to our database using docker.

### Persistant data

With the above command, everytime you delete the container you will loose *all* of your server data. It will start from scratch on reboot. This is probably not what you want. We strongly recommend that you mount your own data volue to `/var/lib/mysql`. This folder can be downloaded as a zip archive from [here](). To use your own volume, use this extended command in place of the one above:

`docker run -d -v "/path/to/data":/var/lib/mysql --name tc-db`

where `/path/to/data` is the path to the unzipped file you downloaded.

## AuthServer


