.PHONY: all lessons

all: lessons

lessons:
	./build_json.rb web/static

install:
	bundle install
	pub get
