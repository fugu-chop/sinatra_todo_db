# frozen_string_literal: true

require 'pg'

# Handle the session related commands. Routes are handled outside of this.
class DatabasePersistence
  # We pass the session hash from Sinatra as an argument on instantiation.
  def initialize(logger)
    @db = PG.connect(dbname: 'todos')
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
    sql = 'SELECT * FROM lists;'
    result = query(sql)

    result.map do |tuple|
      { id: tuple['id'].to_i, name: tuple['name'], todos: find_todos(tuple['id']) }
    end
  end

  def create_new_list(list_name)
    # id = next_element_id(@session[:lists])
    # @session[:lists] << { id: id, name: list_name, todos: [] }
  end

  def delete_list(id)
    # @session[:lists].reject! { |list| list[:id] == id }
  end

  def update_list_name(id, new_name)
    # list = find_list(id)
    # list[:name] = new_name
  end

  def create_new_todo(list_id, todo_name)
    # list = find_list(list_id)
    # id = next_element_id(list[:todos])
    # list[:todos] << { id: id, name: todo_name, completed: false }
  end

  def delete_todo_from_list(list_id, todo_id)
    # list = find_list(list_id)
    # list[:todos].reject! { |todo| todo[:id] == todo_id }
  end

  def update_todo_status(list_id, todo_id, new_status)
    # list = find_list(list_id)
    # todo = list[:todos].find { |t| t[:id] == todo_id }
    # todo[:completed] = new_status
  end

  def mark_all_todos_as_completed(list_id)
    # list = find_list(list_id)
    # list[:todos].each do |todo|
    #   todo[:completed] = true
    # end
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