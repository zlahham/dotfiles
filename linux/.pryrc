# Pry.config.prompt = [proc { "PRY ᛬ " },
                     # proc { "     | " }]

# switch default editor for pry to vim
Pry.config.editor = "vim"
Pry.config.auto_indent = true
Pry.config.color = true

#Dir['./lib/*.rb'].each { |f| require f }

# use awesome print for output if available
begin
  require 'awesome_print'
  AwesomePrint.pry!
  #Pry.config.print = proc { |output, value| output.puts value.ai  }
rescue LoadError => err
  puts "no awesome_print :("
end
