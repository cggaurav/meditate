
all: build

clean:
	rm -rf ionic/www

install:
	npm install && ./node_modules/.bin/bower install

build:
	mkdir -p ionic/www \
	&& gulp watch \
	&& cd ionic \
	&& ../node_modules/.bin/ionic serve

.PHONY: clean install build
