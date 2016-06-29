#!/usr/bin/ruby
# this script builds the code and html steps files from their folder into json

require 'json'
require 'cgi'
require 'redcarpet'



class StepsParser
  def initialize(markdown_parser)
    @md_parser = markdown_parser
  end

  def generate_steps(lesson_path)
    File.open("#{lesson_path}/steps.md") do |steps_file|
      steps_data = parse steps_file.read
      steps_data.sort
    end
  end

  private
  StepData = Struct.new :index, :cmds, :text do
    def <=>(other)
      self.index <=> other.index
    end
  end

  def parse(raw_steps)

    steps_data = []
    raw_steps.scan(/# ?({.*?})(.*?)(?=# ?{.*}|\z)/m) do |step_cmds, text|
      cmd_hash = parse_step_cmds step_cmds
      step_id = cmd_hash.delete 'step'
      steps_data << StepData.new(step_id, cmd_hash, @md_parser.render(text))
    end

    steps_data
  end

  def parse_step_cmds(step_cmds)
    JSON.parse convert_cmds_to_valid_json(step_cmds)
  end

  def convert_cmds_to_valid_json(step_cmds)
    fixed = step_cmds
      .gsub(/(\w+)\s*:/, '"\1":') # surround all keys with quotes
      .gsub(/(?<="step":) *(\w+)/, '"\1"') # surround step value with quotes
      .gsub(/(?<=\[).*?(?=\])/) do |text| # add quotes to frame ids inside [  ]
        text.gsub(/(\w+),?/, '"\1",')[0..-2]
      end
    p fixed
    fixed
  end
end

class CodeParser
  def self.generate_code(lesson_name)
    raw_code = load_code_snippet lesson_name
    CodeParser.decorate_code_fancy(raw_code).string
  end

  private
  def self.load_code_snippet(base_path)
    File.open(Dir.glob("#{base_path}/code.*").first) do |f|
      return f.read
    end
  end

  def self.decorate_code_fancy(code_str)
    strio = StringIO.new
    code_lines = code_str.split "\n"
    line_lookahead = false

    code_lines.each_with_index do |line, i|
      (line_lookahead = false; next) if line_lookahead
      prev_match_end = 0
      if line =~ /^\/\/#/
        next_line = code_lines[i + 1]
        line_lookahead = true
        line.scan(/(?:(\w)|\|\s*(\w+)\s*\|)/) do |s| # match x or | x |
          match = Regexp.last_match
          matched_id = match[1] || match[2]
          strio << next_line[prev_match_end...match.begin(0)]
          strio << add_frame_tags(
            next_line[match.begin(0)...match.end(0)], matched_id)
          prev_match_end = match.end 0
        end
        strio << next_line[prev_match_end..-1] << ?\n
      else
        strio << CGI.escapeHTML(line) << ?\n
      end
    end
    strio
  end

  def self.add_frame_tags(substring, frame_id)
    %Q{<c-frm f-id="#{frame_id}">#{
      CGI.escapeHTML(substring)}</c-frm>}
  end
end

def build_json(code: nil, steps: nil)
  {
    code: code,
    steps: steps.map do |step_data|
      {
        "index": step_data.index,
        "cmds": step_data.cmds,
        "html": step_data.text
      }
    end
  }.to_json
end

if __FILE__ == $0
  renderer = Redcarpet::Render::HTML.new(
    safe_links_only: true, prettify: true, hard_wrap: true)
  markdown_parser = Redcarpet::Markdown.new(renderer,
                                      autolink: true, fenced_code_blocks: true)
  Dir.foreach('lessons') do |filename|
    next if filename == '.' or filename == '..'
    path = "lessons/#{filename}"
    if File.directory? path
      steps_parser = StepsParser.new markdown_parser
      File.open("web/static/lesson-#{filename}.json", 'w') do |output|
        output << build_json(code: CodeParser.generate_code(path),
                             steps: steps_parser.generate_steps(path))
      end
    end
  end
end
