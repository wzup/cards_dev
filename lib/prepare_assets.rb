# coding: utf-8

require "uglifier"
dir = File.expand_path("../../app/assets/javascripts/cards", __FILE__)
pattern = File.join(dir, "**", "*.js")

# puts "dir:" + dir
# puts "exists? " + Dir.exists?(dir).inspect
# puts "pattern: " + pattern

Dir.glob(pattern) { |file|
  f = Uglifier.new(:mangle => true, :output => {:beautify => true}).compile(File.open(file))
  puts "\n\nUglified: #{file}"
  ext = File.extname(file)
  basename = File.basename(file, ext)
  dirname = File.dirname(file)
  # puts "#{dirname + "/" + basename + "__" + ext}"
  puts "Before write: #{file}"
  # IO.write(dirname + "/" + basename + "__" + ext, f) # для тестирования
  IO.write(file, f) # на чистовик
  puts "After write: #{file}\n\n"
}