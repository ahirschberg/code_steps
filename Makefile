.PHONY: all lessons install

all: lessons

lessons:
	./build_json.rb web/static

install:
	bundle install
	pub get
