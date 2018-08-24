input = File.open('INPUTFILE.erb').read
output = File.open('OUTPUTFILE.rb', 'w')

input.gsub!(/\r?\n/, "\n")
input.each_line do |linex|
  line = linex.chomp
  line.each_line do
    a, _b = line.split('=')
    c = a.delete_prefix('[')
    d = c.delete_suffix(']')
    output.puts "default['sickrage']['conf']['#{d}'] = '#{line}'\n"
  end
end
output.close
