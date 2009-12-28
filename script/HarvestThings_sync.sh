#!/bin/sh

# Ruby gems always available
export RUBYOPT="rubygems"

echo "Syncing Things with Harvest..."
ruby -e "require 'harvestthings'; harvestthings"