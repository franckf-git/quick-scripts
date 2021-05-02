#! /bin/bash

# quick script to test incremental backup of a database with git

newsboat

mkdir ~/Documents/dump-rss
cd ~/Documents/dump-rss
git init .

nomcommit=$(date +%m%d-%H%M)

sqlite3 ~/.local/share/newsboat/cache.db ".dump" > dump.sql

git add dump.sql
git commit -am "$nomcommit"
