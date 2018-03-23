require 'sqlite3'
class Post
  @@DB_FILE = './notepad'
  DB_ERROR = "Не могу выполнить запрос в базу #{@@DB_FILE}"

  def self.find_by_id(id)
    db = SQLite3::Database.open(@@DB_FILE)
    db.results_as_hash = true

    begin
      result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
    rescue SQLite3::SQLException
      puts DB_ERROR
      exit
    end

    result = result[0] if result.is_a? Array

    db.close

    if result.empty?
      puts "Такой id #{id} не найден в базе"
      return nil
    else
      post = create(result['type']) # Создаем экземпляр класса Post
      post.load_data(result)
      post
    end
  end

  def self.find_all(limit, type)
    db = SQLite3::Database.open(@@DB_FILE)
    db.results_as_hash = false
    query = "SELECT rowid, * FROM posts "

    query << "WHERE type = :type " unless type.nil?
    query << "ORDER by rowid DESC "
    query << "LIMIT :limit " unless limit.nil?

    begin
      statement = db.prepare(query)
    rescue SQLite3::SQLException
      puts DB_ERROR
      exit
    end

    statement.bind_param('type', type) unless type.nil?
    statement.bind_param('limit', limit) unless limit.nil?

    result = statement.execute! # Возвращает массив

    statement.close
    db.close

    result
  end


  def self.post_types
    {'Memo' => Memo, 'Link' => Link, 'Task' => Task}
  end

  def self.create(type)
    post_types[type].new
  end

  def initialize
    @created_at = Time.now
    @text = []
  end

  def read_from_console
  end

  def to_strings
  end

  def save
    file = File.new(file_path, 'w:UTF-8') # открываем файл на запись

    # Идем по массиву строк, полученных из метода to_strings, который будет
    # реализован у ребенка и записываем все строки в файл.
    to_strings.each do |string|
      file.puts(string)
    end

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)

    # например: link_2016-12-27_12-08-31.txt
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    # Склеиваем путь из относительного пути к папке и названия файла
    current_path + '/' + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@DB_FILE)

    db.results_as_hash = true
    begin
      db.execute(
            "INSERT INTO posts (" +
                to_db_hash.keys.join(',') +
                ")"  +
                " VALUES (" +
               ('?,'*to_db_hash.keys.size).chomp(',') +  # ?* - плейсхолдеры, которые замеются нужно число раз
                ")",
                to_db_hash.values
      )

      insert_row_id = db.last_insert_row_id
      db.close
      return insert_row_id
    rescue SQLite3::SQLException
      puts DB_ERROR
      exit
    end
  end

  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end

  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end
end
