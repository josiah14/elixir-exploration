#!/bin/bash -
#===============================================================================
#
#          FILE: start-postgres.sh
#
#         USAGE: ./start-postgres.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 12/16/2017 03:42:17 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

sudo docker run -it --rm --name pg1 -p 5432:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres postgres:9.6.6
