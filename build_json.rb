#!/usr/bin/env ruby
# this script builds the code and html steps files from their folder into json

require 'json'
require 'cgi'
require 'fileutils'
require 'redcarpet'


class StepsParser
  def initialize(markdown_parser)
    @md_parser = markdown_parser
  end

  def generate_steps(lesson_path)
    File.open("#{lesson_path}/steps.md") do |steps_file|
      parse steps_file.read
    end
  end

  private
  StepData = Struct.new :cmds, :text

  STEP_HEADER = /#step ?(?<step_meta>{.*?})?/
  STEP_FULL   = /#{STEP_HEADER}[ ]*$      # step header on its own line
                 (?<text>.*?)
                 (?=#{STEP_HEADER}|\z)    # match text until next header or EOF
                /omx

  def parse(raw_steps)
    steps_data = []
    raw_steps.scan(STEP_FULL) do |step_data, text|
      cmd_hash = parse_step_cmds(step_data)
      cmd_hash = validate_cmds(cmd_hash)
      steps_data << StepData.new(cmd_hash, @md_parser.render(text))
    end

    steps_data
  end

  def parse_step_cmds(step_cmds)
    return {} if step_cmds.nil?
    JSON.parse convert_cmds_to_valid_json(step_cmds)
  end

  def convert_cmds_to_valid_json(step_cmds)
    fixed = step_cmds
      .gsub(/([A-z\-]+)\s*:/, '"\1":') # surround all keys with quotes
      .gsub(/(?<=\[).*?(?=\])/) do |text| # add quotes to frame ids inside [  ]
        text.gsub(/(\w+),?/, '"\1",')[0..-2]
      end
    fixed
  end

  VALID_KEYS = %I[fail pass spotlight show hide spotlight-line]
  # todo make more robust! check values too...
  def validate_cmds(step_cmds)
    invalid_keys = step_cmds.keys.reject {|key| VALID_KEYS.include? key.to_sym}
    puts "WARN: The following keys are not valid and were removed: " \
      "#{invalid_keys}" if !invalid_keys.empty?
    step_cmds.reject {|k, v| invalid_keys.include? k}
  end
end

class CodeParser
  LANG_ESCAPE_SEQS = {
    'java': %r{//~},
    'py': %r{#~}
  }


  def self.decorate_code(lesson_name)
    File.open(Dir.glob("#{lesson_name}/code.*").first) do |f|
      cp = CodeParser.new File.extname(f.path)[1..-1] # remove leading dot from filepath
      cp.decorate_code(f.read).string
    end
  end

  def initialize(file_ext)
    @directive_esc_seq = LANG_ESCAPE_SEQS[file_ext.to_sym]
  end

  def decorate_code(code_str)
    strio = StringIO.new
    code_lines = code_str.split "\n"
    line_lookahead = false
    num_lines_enhanced = 0;

    code_lines.each_with_index do |line, i|
      (line_lookahead = false; next) if line_lookahead
      if line =~ @directive_esc_seq
        line_lookahead = true
        strio << enhance_line(line, code_lines, i, num_lines_enhanced)
        num_lines_enhanced += 1
      else
        strio << CGI.escapeHTML(line)
      end
      strio << ?\n
    end
    strio
  end

  def enhance_line(line, all_lines, index, enhancement_index)
    line_builder = StringIO.new
    prev_match_end = 0
    next_line = all_lines[index + 1]

    line_builder << line_highlight_marker(enhancement_index)

    line.scan(/(?:(\w)|\|\s*(\w+)\s*\|)/) do |s| # match x or | x |
      match = Regexp.last_match
      matched_id = match[1] || match[2]
      line_builder << next_line[prev_match_end...match.begin(0)]
      line_builder << add_frame_tags(
        next_line[match.begin(0)...match.end(0)], matched_id)
      prev_match_end = match.end 0
    end
    line_builder << next_line[prev_match_end..-1]
    line_builder.string
  end

  def add_frame_tags(substring, frame_id)
    %Q{<c-frm f-id="#{frame_id}">#{
    CGI.escapeHTML(substring)}</c-frm>}
  end

  def line_highlight_marker(reference_num)
    %Q{<c-line f-id="#{reference_num}"></c-line>}
  end
end

def build_map(code: nil, steps: nil)
  {
    code: code,
    steps: steps.map do |step_data|
      {
        cmds: step_data.cmds,
        html: step_data.text
      }
    end
  }
end

def build_lessons_metadata(target:, lesson_name:, lesson_data:)
  target << {
    'name': lesson_name,
    'length': lesson_data[:steps].length
  }
end

if __FILE__ == $0
  renderer = Redcarpet::Render::HTML.new(
    safe_links_only: true, prettify: true, hard_wrap: true)
  markdown_parser = Redcarpet::Markdown.new(renderer,
                                            autolink: true, fenced_code_blocks: true)
  output_dir = FileUtils.mkdir_p("./#{ARGV[0]}").first
  lesson_metadata = []
  Dir.foreach('lessons') do |filename|
    next if filename == '.' or filename == '..'
    path = "lessons/#{filename}"
    if File.directory? path
      steps_parser = StepsParser.new markdown_parser
      lesson_map = build_map(code: CodeParser.decorate_code(path),
                             steps: steps_parser.generate_steps(path))
      build_lessons_metadata target: lesson_metadata,
                             lesson_name: filename,
                             lesson_data: lesson_map
      File.open("#{output_dir}/lesson-#{filename}.json", 'w') do |lesson_json|
        lesson_json << lesson_map.to_json
      end
    end
  end
  File.open("#{output_dir}/lessons.json", 'w') do |lessons_list_json|
    lessons_list_json << {
      lessons: lesson_metadata
    }.to_json
  end
end
