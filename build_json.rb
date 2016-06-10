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
    yield f
  end
  nil
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
    code: ParseHelper.decorate_code_fancy(code).string,
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
    '-': 'hl-fail',
    '*': 'hl-focus'
  })

  def self.decorate_code_fancy(code_file)
    strio = StringIO.new
    last_whitespace = ''
    code_file.read.split(/(?<=\s)/).each do |token|
      if /^(.*?){{(\d+)(\+|-|\*)/m =~ token
        match = Regexp.last_match
        strio << last_whitespace
        strio << match[1]
        strio << %Q{<c-frm f-step="#{match[2]}" class="#{MODE_MAP[match[3].to_sym]}">}
        last_whitespace = ''
      elsif /^~}}(.*)/m =~ token
        match = Regexp.last_match
        strio << "</c-frm>#{match[1]}"
        last_whitespace = ''
      else
        strio << last_whitespace
        match = /^(\S+)?(\s+)$/m.match(token)
        last_whitespace = match[2]
        strio << CGI.escapeHTML(match[1]) if match[1]
      end
    end
    strio
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
        load_code_snippet(path) do |f| 
          output << build_json(code: f, steps: load_steps(path))
        end
      end
    end
  end
end
