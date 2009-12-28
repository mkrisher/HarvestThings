#!/bin/sh

if [ ! -f ~/.harvestthingsrc ]
then
  echo "Installing Harvest Things sync tool..."
  gem sources -a http://gemcutter.org
  sudo gem install harvestthings
  echo "Done installing Harvest Things sync tool"
fi


# Ruby gems always available
export RUBYOPT="rubygems"

echo "Syncing Things with Harvest..."
ruby -e "require 'harvestthings'; harvestthings"