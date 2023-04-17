require 'socket'
require 'pry'

class Server
  PORT = 3000
  HOST = '127.0.0.1'
  # バッファに保存する受信コネクション数
  # SOCKET_READ_BACKLOG = 12

  attr_accessor :app

  def initialize(app)
    self.app = app
  end

  def start
    socket = listen_on_socket
    loop do #新しいコネクションを継続的にリッスンする
      conn = socket.accept #_で始まる変数は使わない変数って慣習
      status, res_headers, body = app.call

      # request headerの読み込み
      req_headers = []
      while req_header = conn.gets
        break if req_header.chomp.empty?
        req_headers << req_header.chomp
      end
      p req_headers

      conn.puts("HTTP/1.1 #{status} OK")
      res_headers.each_pair do |name, value|
        conn.puts("#{name}: #{value}")
      end
      conn.puts("")
      conn.puts("#{body}")

    rescue => e
      puts e.message
    ensure #コネクションを常にクローズする
      conn&.close
    end
  end

  private

  def listen_on_socket
    socket = TCPServer.new(HOST, PORT)
    # socket.listen(SOCKET_READ_BACKLOG)

    socket
  end
end

class Application
  def call
    status = 200
    headers = {"Content-Type" => "text/html"}
    body = ["Yay, your first web application! <3"]

    [status,headers,body]
  end
end

Server.new(Application.new).start
