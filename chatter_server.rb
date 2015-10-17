gem 'sinatra'
gem 'sinatra-contrib'
gem 'thin'

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'

set :bind, '0.0.0.0'

register Sinatra::Reloader
#

get '/receive' do
  last = params[:last_message_id].to_i
  Chatter.receive_message(last)
  #Chatter.post_message()
end

post '/send' do
  message = params[:message]
  Chatter.post_message(message)
end

class Chatter
  @@messages = []

  def self.post_message(message)
    @@messages << message# unless last_message_id - 1 == @messages.size
    {last_message_id: @@messages.size, response: "Message sent", time: Time.now}.to_json
  end

  def self.receive_message(last_message_id)
    total_messages =  @@messages.size
    messages = @@messages[last_message_id..-1] || []
    message_concat = ""
    messages.each{ |msg|
      message_concat << msg
      message_concat << "\n"
    }
    return {message: message_concat, last_message_id: total_messages, time: Time.now }.to_json if last_message_id <= total_messages
    {message: "No new message", time: Time.now }.to_json
  end

  def self.get_messages
    @@messages
  end
end

    # require 'pry' ; binding.pry
