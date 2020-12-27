# https://www.grafikart.fr/tutoriels/makefile-953
domain := "example.com"
server := "debian@$(domain)"
user := $(shell id -u)
group := $(shell id -g)

.DEFAULT_GOAL := help
.PHONY: help
help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deploy
deploy:
	ssh -A $(server) 'cd $(domain) && git pull origin master && make install'

.PHONY: install
install: vendor/autoload.php public/assets/manifest.json ## Installe les différentes dépendances
	APP_ENV=prod APP_DEBUG=0 $(php) composer install --no-dev --optimize-autoloader
	make migrate
	sudo service php7.4-fpm reload

.PHONY: dev
dev: vendor/autoload.php node_modules/time ## Lance le serveur de développement
	$(dc) up

.PHONY: test
test: vendor/autoload.php node_modules/time ## Execute les tests
	$(node) yarn run test

.PHONY: tt
tt: vendor/autoload.php ## Lance le watcher phpunit
	$(drtest) phptest bin/console cache:clear --env=test
	$(drtest) phptest vendor/bin/phpunit-watcher watch --filter="nothing"

.PHONY: lint
lint: vendor/autoload.php ## Analyse le code
	docker run -v $(PWD):/app -w /app --rm php:7.4-cli-alpine php -d memory_limit=-1 ./vendor/bin/phpstan analyse

.PHONY: format
format: ## Formate le code
	npx prettier-standard --lint --changed "assets/**/*.{js,css,jsx}"
	./vendor/bin/phpcbf
	./vendor/bin/php-cs-fixer fix

.PHONY: doc
doc: ## Génère le sommaire de la documentation
	npx doctoc ./README.md
