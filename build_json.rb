#!/usr/bin/ruby
# this script builds the code and html steps files from their folder into json

require 'json'
require 'cgi'
require 'redcarpet'

renderer = Redcarpet::Render::HTML.new(
  safe_links_only: true, prettify: true, hard_wrap: true)
$markdown = Redcarpet::Markdown.new(renderer,
                                   autolink: true, fenced_code_blocks: true)

def load_code_snippet(base_path)
  File.open(Dir.glob("#{base_path}/code.*").first) do |f|
    f.read
  end
end

def load_steps(base_path)
  File.open("#{base_path}/steps.md") do |f|
    f
      .read
      .scan(/{{ \d+ }}(.*?)(?={{ \d+ }}|\z)/m)
      .flatten
  end
end

def build_json(code: nil, steps: [])
  {
    code: ParseHelper.decorate_code(code),
    steps: steps.each_with_index.map do |step, i|
      {
        "index": i,
        "html": $markdown.render(step)

      }
    end
  }.to_json
end

class ParseHelper
  DECORATOR_REGEX = /{{(?<step_i>\d+) (?<text>.*?) (?<mode>\+|-)}}/

  MODE_MAP = Hash.new { |hash, key| raise "The mode #{key} is not a valid mode for step highlighting."}
  MODE_MAP.merge!({
    '+': 'hl-pass',
    '-': 'hl-fail'
  })

  def self.decorate_code(raw_code)
    raw_code.gsub(DECORATOR_REGEX) do
      m = Regexp.last_match
      strip_html_ignored_whitespace(%Q{
        <c-frm f-step="#{ m['step_i'] }"
            class="#{ MODE_MAP[m['mode'].to_sym] }">
            #{ CGI.escapeHTML m['text'] }
          </c-frm>
      })
    end
  end

  def self.strip_html_ignored_whitespace(str)
    str.gsub(/(?:\s{2,}|\n)/, '') # remove HTML ignored whitespace
  end
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
