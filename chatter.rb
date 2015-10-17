gem 'faraday'

require 'json'
require 'faraday'

class Chat
  attr_reader :connection, :messages, :response, :last_message_id

  URL = 'http://192.168.101.52:4567'

  def initialize
    @messages = []
    @last_message_id = 0
    connect
  end

  def connect
    @connection = Faraday::Connection.new(URL)
  end

  def send_message(message)
    response = connection.post('/send', {message: message})
    response = JSON.parse(response.body)
    @last_message_id = response["last_message_id"]
    @last_message = message
  end

  def receive_message
    sleep 1
    response = connection.get('/receive', { last_message_id: @last_message_id })
    @response = JSON.parse(response.body)
    last_id = @response["last_message_id"]
    unless last_id == last_message_id
      message = @response["message"]
      @last_message_id = @response["last_message_id"]
      @messages << message if message
      puts message
    end
  end
end


chat = Chat.new

res = Thread.new do
  loop{
    chat.receive_message
  }
end

req = Thread.new do
  loop{
    message = gets.chomp
    chat.send_message(message) if message
  }
end

req.join
res.join

# gem 'eventmachine'
# require 'eventmachine'

# loop{
#
# }

# loop{
#   Thread.start
# }
# EM.run do
#   EM.add_periodic_timer(2) do
#     chat.receive_message
#   end
#   EM.add_periodic_timer(1) do
#     message = gets.chomp
#     chat.send_message(message)
#   end
# end



  # def msg
  #
  # end

  # chat


# EM.run do
#   EM.add_periodic_timer(2) do
#     message = gets.chomp
#     chat.send_message(message)
#   end
# end
# loop do
#   receive_message
#   # message =
#   # puts @last_message
# end
