SHELL := /bin/bash
# VENV := . $(VIRTUAL_ENV)/bin/activate
all:

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
.PHONY: tags
tags:
	etags `ack --py -l .`
	etags --append `ack --noenv --py -l . \
	lib/*/site*/{dbf,django}*`
	@wc -l TAGS

_autotest:
	@/bin/echo
	@/bin/echo
	@/bin/echo '::::::::::::::::::::::::::::::::::::::::::::::::::'
	time ./manage.py test $(TESTARG) -s 2>&1

# USAGE: make TESTARG=tests.test_cmd_sync autotest
autotest:
	watchmedo shell-command -p '*.py' -R -c 'make _autotest' \
	| grcat ~/.grc/tux.conf

# TODO: ./manage.py test --nose-verbosity=3 --with-flaky
