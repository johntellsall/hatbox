SHELL := /bin/bash
PROJ := ~/src/theblacktux

# VENV := . $(VIRTUAL_ENV)/bin/activate
all:

last:
	cd $(PROJ) ; REUSE_DB=1 ./bin/python \
	./manage.py test \
	`ls -1t tests/*.py | head -1`

clean:
	find . -name '*.pyc' | xargs rm

test:
	$(VIRTUAL_ENV)/bin/python manage.py test

stop:
	-kill `lsof -ti :5000`
	-killall compass

start: stop
	compass watch &
	./manage.py runserver 5000

#	ctags-exuberant -e `ack --py -l .`

.PHONY: .srcpaths
.srcpaths:
	ack --py -l . > $@
	find lib/*/site*/{dbf,django}* -name '*.py' >> $@
	wc -l $@

# brew install ctags-exuberant
.PHONY: tags
tags:	.srcpaths
	ctags -e -L .srcpaths
	@wc -l TAGS


# USAGE: make TESTARG=tests.test_cmd_sync autotest 
_autotest:
	@/bin/echo
	@/bin/echo
	@/bin/echo '::::::::::::::::::::::::::::::::::::::::::::::::::'
	time ./manage.py test $(TESTARG) -s 2>&1

autotest:
	watchmedo shell-command -p '*.py' -R -c 'make _autotest' \
	| grcat ~/.grc/tux.conf


# mkcover:
# 	./manage.py test --with-coverage --cover-package=app \
# 	2>&1 | egrep -v '^app.migrations'

# COVER_OMIT := app/management/*,app/migrations/*,lib/*,tests/*
# cover:
# 	coverage report --omit='$(COVER_OMIT)'
# 	coverage html --omit='$(COVER_OMIT)' --directory=$${CIRCLE_ARTIFACTS-.}/htmlcov



# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# TODO: ./manage.py test --nose-verbosity=3 --with-flaky
