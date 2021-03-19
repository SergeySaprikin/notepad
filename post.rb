# Базовый класс "Запись"
# Задает основные методы и свойства, присущие всем разновидностям Записи
class Post
  # Конструктор
  def initialize
    @created_at = Time.now # дата создания записи
    @text = [] # массив строк записи — пока пустой
  end

  # Набор известных детей класса Запись в виде массива классов
  def self.post_types
    [Memo, Task, Link]
  end
  # XXX/ Строго говоря этот метод self.types нехорош — родительский класс в идеале в коде
  # не должен никак зависеть от своих конкретных детей. Мы его использовали для простоты
  # (он адекватен поставленной задаче).
  #
  # В сложных приложениях это делается немного иначе: например отдельный класс владеет всей информацией,
  # и умеет создавать нужные объекты (т. н. шаблон проектирования "Фабрика").
  # Или каждый дочерний класс динамически регистрируется в подобном массиве сам во время загрузки программы.
  # См. подробнее книги о шаблонах проектирования в доп. материалах.

  # Динамическое создание объекта нужного класса из набора возможных детей
  def self.create(type_index)
    return post_types[type_index].new
  end

  # Вызываться в программе когда нужно считать ввод пользователя и записать его в нужные поля объекта
  def read_from_console
    # todo: должен реализовываться детьми, которые знают как именно считывать свои данные из консоли
  end

  # Возвращает состояние объекта в виде массива строк, готовых к записи в файл
  def to_strings
    # todo: должен реализовываться детьми, которые знают как именно хранить себя в файле
  end

  # Записывает текущее состояние объекта в файл
  def save
    file = File.new(file_path, "w:UTF-8") # открываем файл на запись

    for item in to_strings do # идем по массиву строк, полученных из метода to_strings
    file.puts(item)
    end

    file.close # закрываем
  end

  # Метод, возвращающий путь к файлу, куда записывать этот объект
  def file_path
    # Сохраним в переменной current_path место, откуда запустили программу
    current_path = File.dirname(__FILE__)

    # Получим имя файла из даты создания поста метод strftime формирует строку типа "2014-12-27_12-08-31.txt"
    # набор возможных ключей см. в документации Руби
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")
    # Обратите внимание, мы добавили в название файла даже секунды (%S) — это обеспечит уникальность имени файла

    return current_path + "/" + file_name
  end
end

# PS: Весь набор методов, объявленных в родительском классе называется интерфейсом класса
# Дети могут по–разному реализовывать методы, но они должны подчиняться общей идее
# и набору функций, которые заявлены в базовом (родительском классе)

# PPS: в других языках (например Java) методы, объявленные в классе, но пустые
# называются абстрактными (здесь это методы to_strings и read_from_console).
#
# Смысл абстрактных методов в том, что можно писать базовый класс и пользоваться
# этими методами уже как будто они реализованы, не задумываясь о деталях.
# С деталями реализации методов уже заморачиваются дочерние классы.
#