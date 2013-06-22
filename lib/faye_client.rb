require 'net/http'
require 'json'

class FayeClient
  SERVER_URL = "http://localhost:3000/faye"

  def self.server(url = nil)
    @@server ||= URI.parse(url || SERVER_URL)
  end

  def self.publish(channel, data = {}, options = {}) 
    message = {:channel => channel, :data => data}
    Net::HTTP.post_form(server, :message => message.to_json)
  end
end
