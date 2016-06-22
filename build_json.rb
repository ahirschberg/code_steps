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
    return f.read
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

  def self.decorate_code_fancy(code_str)
    strio = StringIO.new
    code_lines = code_str.split "\n"
    line_lookahead = false

    code_lines.each_with_index do |line, i|
      (line_lookahead = false; next) if line_lookahead # line already processed
      prev_match_end = 0
      if line =~ /^\/\/#/
        next_line = code_lines[i + 1]
        line_lookahead = true
        line.scan(/(?:(\w+)|\|\s*(\w+)\s*\|)/) do |s|
          match = Regexp.last_match
          matched_id = match[1] || match[2]
          strio << next_line[prev_match_end...match.begin(0)]
          strio << add_frame_tags(
            next_line[match.begin(0)...match.end(0)], matched_id)
          prev_match_end = match.end 0
        end
        strio << "\n"
      else
        strio << line << "\n"
      end
    end
    strio
  end

  def self.add_frame_tags(substring, frame_id)
    %Q{<c-frm f-id="#{frame_id}">#{
      CGI.escapeHTML(substring)}</c-frm>}
  end

  def self.strip_html_ignored_whitespace(str)
    str.gsub(/(?:\s{2,}|\n)/, '') # remove HTML ignored whitespace
  end

  def self.jsonify_step_cmds(step_header_str)
    step_cmds = step_header_str.match(/# ?({.*})/)[1]
    step_cmds_obj = JSON.parse(step_cmds
      .gsub(/(\w+)\s*:/, '"\1":') # surround all keys with quotes
      .gsub(/(?<=\[).*?(?=\])/) do |text| # add quotes to ids inside [  ]
        text.gsub(/(\w+),?/, '"\1",')[0..-2]
      end
    )
    JSON.generate(step_cmds_obj) # is json parse then generate bad practice?
  end
end

exit

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
