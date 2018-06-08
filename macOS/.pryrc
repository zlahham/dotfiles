Pry.config.prompt = [proc { 'ᚹᚱᛘ => ' },
                     proc { '     |> ' }]

# switch default editor for pry to vim
Pry.config.editor = 'vim'
Pry.config.auto_indent = true
Pry.config.color = true

# Dir['./lib/*.rb'].each { |f| require f }

# Hit Enter to repeat last command
Pry::Commands.command(/^$/, 'repeat last command') do
  _pry_.run_command Pry.history.to_a.last
end

# use awesome print for output if available
begin
  require 'awesome_print'
  AwesomePrint.pry!
rescue LoadError
  puts 'no awesome_print :('
end

# Byebug aliases
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end
