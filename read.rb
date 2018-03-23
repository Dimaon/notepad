require_relative("lib/post.rb")
require_relative("lib/link.rb")
require_relative("lib/memo.rb")
require_relative("lib/task.rb")

# Вывести записи по id , limit, type
require 'optparse'

options = {}

# Парсер опций командной строки
OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать (по-умолчанию любой)') { |o| options[:type] = o }
  opt.on('--id POST_ID', 'если задан id - показываем подробно только этот пост') { |o| options[:id] = o }
  opt.on('--limit NUMBER', 'сколько последних постов (по-умолчанию все)') { |o| options[:limit] = o }
end.parse!

result =
    if options[:id].nil?
      Post.find_all(options[:limit], options[:type])
    else
      Post.find_by_id(options[:id])
    end

if result.is_a? Post
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end
else # Покажем все записи в виде таблицы
  print "| id\t @type\t| @created_at\t\t\t| @text |t\\t\t| @url\t\t| @due_date \t "

  result.each do |row|
    puts
    row.each do |el|
      print "| #{el.to_s.delete("\\n\\r")[0..40]}\t"
    end
  end
end
