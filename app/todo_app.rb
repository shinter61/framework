require_relative 'todo'

module App
  class TodoApp
    # request の形式は以下を想定
    # - method
    # - host
    # - path
    # - params
    def call(request:)
      status = 200
      headers = {"Content-Type" => "application/json"}
      response = self.delete(id: 3)

      [response[:status],headers,response[:body]]
    end

    def initialize
      @todos = [
        Todo.new(id: 1, content: 'first todo'),
        Todo.new(id: 2, content: 'second todo'),
        Todo.new(id: 3, content: 'third todo'),
        Todo.new(id: 4, content: 'fourth todo'),
        Todo.new(id: 5, content: 'fifth todo'),
      ]
    end

    def list
      {
        status: 200,
        body: @todos
      }
    end

    def get(id:)
      target_todo = @todos.find { |todo| todo.id == id }
      if !target_todo.nil?
        return {
          status: 200,
          body: target_todo
        }
      else
        return {
          status: 404,
          body: nil
        }
      end
    end

    def post
      last_id = @todos.last.id
      new_id = last_id + 1
      @todos = @todos.push(Todo.new(id: new_id, content: "#{new_id}th todo"))

      return {
        status: 200,
        body: @todos
      }
    end

    def put(id:)
    end

    def delete(id:)
      @todos.reject! { |todo| todo.id == id }
      return {
        status: 200,
        body: @todos
      }
    end
  end
end
