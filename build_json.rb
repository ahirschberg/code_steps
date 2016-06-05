#!/usr/bin/ruby
# this script builds the code and html steps files from their folder into json

require 'json'

def load_code_snippet(base_path)
  File.open(Dir.glob("#{base_path}/code.*").first) do |f|
    f.read
  end
end

def load_steps(base_path)
  File.open("#{base_path}/steps.html") do |f|
    f
      .read
      .scan(/<step-ex[^>]*>((?:.(?!<\/step-ex>))*)/mi)
      .flatten
  end
end

def build_json(code: nil, steps: [])
  {
    code: code,
    steps: steps.each_with_index.map do |step, i|
      {
        "index": i,
        "html": step
          .gsub(/(?:\s{2,}|\n)/, '') # remove HTML ignored whitespace
      }
    end
  }.to_json
end


if __FILE__ == $0
  Dir.foreach('lessons') do |filename|
    next if filename == '.' or filename == '..' 
    path = "lessons/#{filename}"
    if File.directory? path
      File.open("web/static/lesson-#{filename}.json", 'w') do |output|
        output << build_json(code: load_code_snippet(path), steps: load_steps(path))
      end
    end
  end
end
