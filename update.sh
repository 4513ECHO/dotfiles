#!/bin/sh

git pull origin main
git submodule init
git submodule update
git submodule foreach git pull origin main
