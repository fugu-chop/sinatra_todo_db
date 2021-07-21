# frozen_string_literal: true

require 'pg'

# Handle the session related commands. Routes are handled outside of this.
class DatabasePersistence
  # We pass the session hash from Sinatra as an argument on instantiation.
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: 'todos')
          end
    @logger = logger
  end

  def find_list(id)
    sql = 'SELECT * FROM lists WHERE id = $1'
    # splat operator captures id as an array
    result = query(sql, id)
    tuple = result.first
    { id: tuple['id'].to_i, name: tuple['name'], todos: find_todos(id) }
  end

  def all_lists
    sql = <<~query
        SELECT l.*,
             COUNT(NULLIF(t.completed, true)) AS todos_remaining_count,
             COUNT(t.id) AS todos_count
        FROM lists AS l
        LEFT JOIN todos AS t
          ON l.id = t.list_id
        GROUP BY l.id
        ORDER BY l.id;
    query
    result = query(sql)

    result.map do |tuple|
      { id: tuple['id'].to_i, 
        name: tuple['name'], 
        todos_count: tuple['todos_count'].to_i, 
        todos_remaining_count: tuple['todos_remaining_count'].to_i
      }
    end
  end

  def create_new_list(list_name)
    sql = 'INSERT INTO lists (name) VALUES ($1)'
    query(sql, list_name)
  end

  def delete_list(id)
    sql = 'DELETE FROM lists WHERE id = $1'
    query(sql, id)
  end

  def update_list_name(id, new_name)
    sql = 'UPDATE lists SET name = $1 WHERE id = $2'
    query(sql, new_name, id)
  end

  def create_new_todo(list_id, todo_name)
    sql = 'INSERT INTO todos (list_id, name) VALUES ($1, $2)'
    query(sql, list_id, todo_name)
  end

  def delete_todo_from_list(list_id, todo_id)
    sql = 'DELETE FROM todos WHERE list_id = $1 AND id = $2'
    query(sql, list_id, todo_id)
  end

  def update_todo_status(list_id, todo_id, new_status)
    sql = 'UPDATE todos SET completed = $3 WHERE list_id = $1 AND id = $2'
    query(sql, list_id, todo_id, new_status)
  end

  def mark_all_todos_as_completed(list_id)
    sql = 'UPDATE todos SET completed = true WHERE list_id = $1'
    query(sql, list_id)
  end

  # Guard rails to ensure we don't exceed connection limit on Heroku free database plan
  def disconnect
    @db.close
  end

  private

  def convert_boolean(bool)
    bool == 't'
  end

  def find_todos(list_id)
    sql = 'SELECT * FROM todos WHERE list_id = $1'
    result = query(sql, list_id)
    result.map do |tuple|
      { id: tuple['id'].to_i, name: tuple['name'], completed: convert_boolean(tuple['completed']) }
    end
  end

  def query(statement, *params)
    @logger.info("#{statement}: #{params}")
    @db.exec_params(statement, params)
  end
end
