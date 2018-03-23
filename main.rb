require_relative("lib/post.rb")
require_relative("lib/link.rb")
require_relative("lib/memo.rb")
require_relative("lib/task.rb")

puts "Привет! Я твой блокнот. Работаю с Sqlite3"
puts "Что хотите записать в меня?"

# Сохраним все варианты постов из статического метода класса
choices = Post.post_types.keys

choice = -1

until choice >= 0 && choice < choice.size

  choices.each_with_index do |el, index|
    puts "\t#{index} - #{el}"
  end

  choice = STDIN.gets.to_i
end

# Создаем дочерний экз. класса на основе выбора пользователя
entry = Post.create(choices[choice])

entry.read_from_console

# entry.save
id = entry.save_to_db

puts "Запись сохранена. id = #{id}"
