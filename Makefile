.PHONY: all lessons

all: lessons

lessons: build_json.rb
	./build_json.rb web/static
