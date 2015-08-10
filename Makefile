# vim: set noet:

.PHONY: all
all:
	docker build --rm -t jumanjiman/downer src/
