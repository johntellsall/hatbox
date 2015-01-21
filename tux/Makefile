SHELL := /bin/bash
ACK := /usr/local/bin/ack
CTAGS := /usr/local/bin/ctags
PROJ := ~/src/theblacktux
# TODO: allow env override
VIRTUAL_ENV := /Users/johnm/src/venv
VBIN := $(VIRTUAL_ENV)/bin
VENV_SITE := $(VIRTUAL_ENV)/lib/*/site*

# cd ~/src/theblacktux ; REUSE_DB=1 ./bin/python ./manage.py test tests.test_models:TestUser_SendWelcomeEmailAsGroomsman -s
# cd ~/src/theblacktux ; REUSE_DB=1 ./bin/python ./manage.py test tests.test_integrations -s
# clear; time ./bin/python ./manage.py test --with-flaky --nose-verbosity=3

all:

# X: todo: logs
# zap 'virtualenv' artifacts
distclean:
	$(RM) -r lib/ bin/

zoot:
	REUSE_DB=1 coverage run ./manage.py test `ls -1t tests/test_*.py | head -1`
	coverage report -m app/mandrill.py

mlist:
	./manage.py migrate --list

firsttest:
	../johnm/resetdb
	yes yes | $(VBIN)/python ./manage.py test --nose-verbosity=3 $(TESTARG)
test:
	yes yes | REUSE_DB=1 $(VBIN)/python ./manage.py test --nose-verbosity=3 $(TESTARG)

last:
	cd $(PROJ) ; REUSE_DB=1 $(VBIN)/python \
	./manage.py test \
	`ls -1t tests/test_*.py | head -1`

clean:
	find . -name '*.pyc' -exec rm  {} \;
	$(RM) -r htmlcov cover.txt


# TODO: stop 'compass' not ruby
stop:
	-kill `lsof -ti :5000`
	-killall ruby

start: stop
	compass watch &
	./manage.py runserver 0:5000

# find lib/*/site*/{dbf,django,lionheart,nose}* -name '*.py' >> $@


.PHONY: .srcpaths
.srcpaths:
	$(ACK) --py -l . > $@
	find $(VENV_SITE)/{django,lionheart,raven,static}* -name '*.py' >> $@
	find ../fig -name '*.py' >> $@
	wc -l $@

# brew install ctags-exuberant
.PHONY: tags
tags:	.srcpaths
	$(CTAGS) -e -L .srcpaths
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
