class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_reader :name, :grade, :id
  
  def initialize(name, grade)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1")[0] || 1

    sql = <<-SQL
      INSERT INTO students
      VALUES (?, ?, ?)
    SQL

    DB[:conn].execute(sql, @id, @name, @grade)
  end

  def self.create(name: nil, grade: nil)
    student = Student.new(name, grade)
    student.save
    student
  end
end
