require 'date'

# Класс «Задача», разновидность базового класса «Запись»
class Task < Post
  # Конструктор у класса «Задача» свой, но использует конструктор родителя.
  def initialize
    # Вызываем конструктор родителя
    super

    # время, ккоторому задачу нужно выполнить
    @due_date = Time.now
  end

  # метод будет спрашивать ввод содержимого Задача
  def read_from_console
    puts "Что надо сделать"
    @text = STDIN.gets.chomp

    puts "К какому числу надо сделать? Введите дату в формате ДД.ММ.ГГГГ Например, 12.01.2006"
    @due_date = STDIN.gets.chomp
  end

  # Этот метод будет возвращать массив из трех строк: дедлайн задачи, описание
  # и дата создания
  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    deadline = "Крайний срок: #{@due_date}"

    return [time_string, @text, deadline]
  end

  def to_db_hash
    super.merge(
             {
                 'due_date' => @due_date,
                 'text' => @text

             }
    )

  end

  def load_data(data_hash)
    super(data_hash)
    @due_date = Date.parse(data_hash['due_date'])
  end
end
