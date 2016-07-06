.PHONY: all lessons

all: lessons

lessons: build_json.rb
	ruby build_json.rb static
