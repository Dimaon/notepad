# Класс «Ссылка», разновидность базового класса «Запись»
class Link < Post
  # Конструктор у класса «Ссылка» свой, но использует конструктор родителя.
  def initialize
    super

    # Создаем специфичную для ссылки переменную экземпляра @url — адрес, куда
    # будет вести ссылка.
    @url = ''
  end

  # Этот метод пока пустой, он будет спрашивать ввод содержимого Ссылки
  def read_from_console
    puts "Адрес ссылки:"
    @url = STDIN.gets.chomp

    puts "Описание ссылки:"
    @text = STDIN.gets.chomp
  end

  # Этот метод будет возвращать массив из трех строк: адрес ссылки, описание
  # и дата создания
  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return [@url, @text, time_string]
  end

  def to_db_hash
    super.merge(
        {
            'url' => @url,
            'text' => @text

        }
    )
  end
  def load_data(data_hash)
    super(data_hash)
    @url = data_hash['url']
    @text = data_has['text']
  end
end
