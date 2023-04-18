module App
  class Todo
    attr_accessor :id, :content

    def initialize(id:, content:)
      self.id = id
      self.content = content
    end
  end
end
