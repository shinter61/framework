require 'socket'

class Server
  PORT = 3000
  HOST = 'localhost'
  # バッファに保存する受信コネクション数
  SOCKET_READ_BACKLOG = 12

  def start
    socket = listen_on_socket
    loop do #新しいコネクションを継続的にリッスンする
      conn, _addr_info = socket.accept #_で始まる変数は使わない変数って慣習
      request = RequestParser.call(conn)
      status,headers,body = app.call(request)
      HttpResponder.call(conn,status,headers,body)
  end

  private
  
  def listen_on_socket
    socket = TCPServer.new(HOST, PORT)
    socket.listen(SOCKET_READ_BACKLOG)
  end
end

class Application
  def call(env)
    status = 200
    headers = {"Content-Type" => "text/html"}
    body = ["Yay, your first web application! <3"]
    
    [status,headers,body]
  end
end

Server.new.start
