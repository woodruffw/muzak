require "muzak"
require "readline"
require "shellwords"

opts = {
  debug: ARGV.include?("--debug") || ARGV.include?("-d"),
  verbose: ARGV.include?("--verbose") || ARGV.include?("-v"),
  batch: ARGV.include?("--batch") || ARGV.include?("-b")
}


muzak = Muzak::Instance.new(opts)

COMMANDS = Muzak::Cmd.humanize_commands!

comp = proc do |s|
  case Readline.line_buffer
  when /^enqueue-artist /
    muzak.index.artists.grep(Regexp.new(Regexp.escape(s)))
  when /^enqueue-album /
    muzak.index.album_names.grep(Regexp.new(Regexp.escape(s)))
  else
    COMMANDS.grep(Regexp.new(Regexp.escape(s)))
  end
end

Readline.completion_append_character = " "
Readline.completion_proc = comp

while line = Readline.readline("muzak> ", true)
  cmd_argv = Shellwords.split(line)
  next if cmd_argv.empty?
  muzak.send Muzak::Cmd.resolve_command(cmd_argv.shift), *cmd_argv
end
