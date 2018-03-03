# Класс «Заметка», разновидность базового класса «Запись»
class Memo < Post
  # Этот метод будет спрашивать ввод содержимого Заметки
  def read_from_console
    puts "Новая заметка (если хотите закончить, напишите 'end')"
    # Массив для сохранения строчек текста
    @text = []
    # Одна строчка текста
    line = nil

    while  line != "end" do
      line = STDIN.gets.chomp
      @text << line
    end
    # Удаляем послендий элемент, так как это "end"
    @text.pop
  end

  # Этот метод будет возвращать массив из строк заметки + строка-дата создания
  # Это будет заисываться в файл
  def to_strings
    #Время
    # Время создания записи
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"
    # Возвращаем текст с добавленным в него time_string
    return @text.unshift(time_string)
  end
end
