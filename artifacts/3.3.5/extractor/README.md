![TrinityCore](http://www.trinitycore.org/f/public/style_images/1_trinitycore.png) TrinityCore/extractor
===

[![docker.ico](http://dockeri.co/image/trinitycore/extractor)](https://registry.hub.docker.com/u/trinitycore/extractor/)

This is a collection of tools that will generate the vmaps, mmaps, dbc, and map files. Generating these files is a necessary step for running the TrinityCore server.

## Prerequisite

This tool requires a valid version of the game be present on your machine that matches the version of TrinityCore that you wish to run before proceeding. If you do not have the game on your system, please stop reading this, download it and then return. It also requires that you have docker installed, if you do not please follow the instructions [here](https://docs.docker.com/installation/#installation) before proceeding.

## Usage

Using the tool is as simple as:
`docker run -it -v "/path/to/client":/input -v "/path/to/output":/output trinitycore/extractor`

### Details

* `-it` means we are directing input/output to/from our container from/to our terminal window.
* `-v` means we are mounting a folder on our system inside of our container. The left hand side of the `:` is the folder on the host and the right hand side is the folder on the client.
* `"/path/to/client"` the location of the game files on your system. Example: `/home/user/Downloads/3.3.5`
* `"/path/to/output"` the location we wish to store generated files.

## What to do from here?

Once you have generated the necessary files for TrinityCore to run, you start up the TrinityCore server. For directions, check out the other images [here](https://registry.hub.docker.com/u/trinitycore/authserver/)
