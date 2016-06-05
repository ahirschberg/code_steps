#!/usr/bin/ruby
# this script builds the code and html steps files from their folder into json


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
  # todo: clean this up / use JSON.parse instead
  <<HEREDOC
{
  "code": "#{code.gsub("\n", '\n').gsub('"', '\"') }",
  "steps": [#{steps.each_with_index.map do |step, i|
    %Q|{
      "index": #{i},
      "html": "#{step.gsub("\n", '\n')}"
    }|
      end.join(',')}]
}
HEREDOC
  .gsub("\n", '')
  # end HEREDOC
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
