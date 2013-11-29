require 'net/https'
require 'uri'

class Joyrock
  REMOTE_ADDR = "http://www.raboof.com/projects/jayrock/demo.ashx"

  attr_reader :error

  def initialize
    @id = 0
    @uri = URI.parse(REMOTE_ADDR)
    @error = nil
  end

  # Add two integers using Joyrock server
  def add(a,b)
    r = request({method: "add", params: {a: a, b: b}})
    r["result"] if r
  end

  protected 

  def request(data)
    @id += 1; @error = nil
    data.merge!({id: @id})

    req = Net::HTTP::Post.new(@uri.path)
    req.content_type = 'application/json'
    req.body = data.to_json

    http = Net::HTTP.new(@uri.host, @uri.port)

    response = http.request(req)
    result = JSON.parse(response.body)
    result.delete(:id)
    if result.has_key?("error")
      @error = result["error"]
      nil
    else
      result
    end
  end
end