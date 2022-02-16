#! /bin/sh

REPOS="
adventofcode2021
api-mongo-restify
carnet-de-suivi
conkyweb
copropriete
dotfiles
flux-rss
lite-api-crud-go
lite-api-crud-js
md2pdf
newsboat-utils
progressbar
quick-scripts
reference-css
reference-go
reference-javascript
rss-reader
rtfm
selfie-gallery
startpage
template-backend-ts
template-expressjs
template-frontend-ts
template-minimalist-js
textgen-algo-js
trainjs-api
trainjs-mess
wikipedia-xml-parser-and-visualdata
"

TESTPROJECT="
fizzbuzz-go
fizzbuzz-php
fizzbuzz-ts
gestion-de-projet
order-tag-erik
read-binary
"

mkdir backup-git-repos
cd backup-git-repos

for repo in $REPOS
do
    echo $repo
    git clone git@gitlab.com:franckf/$repo.git
    tar -cf $repo.tar $repo
    rm -Rf $repo
done

for testrepo in $TESTPROJECT
do
    echo $testrepo
    git clone git@gitlab.com:test-repos-ff/$testrepo.git
    tar -cf $testrepo.tar $testrepo
    rm -Rf $testrepo
done
