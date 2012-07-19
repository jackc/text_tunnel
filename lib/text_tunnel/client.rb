#!/usr/bin/env ruby

gem 'rest-client', '~> 1.6.7'
require "rest_client"

# Interface is compatible with RestClient exception
class UnexpectedResponseError < StandardError
  attr_reader :response

  def initialize(response)
    @response = response
  end

  def http_code
    response.code.to_i
  end

  def http_body
    response.body
  end  
end

class Client
  # Establishes initial connection to text_tunneld server
  def initialize(port, file_path)
    @file_path = file_path

    open(file_path, "rb") do |f|
      response = RestClient.post "http://localhost:#{port}/files", :file => f
      raise UnexpectedResponseError.new(response) unless response.code == 201
      @location = response.headers[:location]
      @etag = response.headers[:etag]
    end    
  end

  # Returns true if a change was made
  def poll
    RestClient.get(@location, :if_none_match => @etag) do |response, request, result|
      return false if response.code == 304
      if response.code == 200
        @etag = response.headers[:etag]
        File.write(@file_path, response.body)
        return true
      end

      raise UnexpectedResponseError.new(response)
    end
  end

  def cleanup
    # This call can fail, especially if text_tunnel is terminating because of
    # a previous error. So swallow any errors.
    RestClient.delete(@location) rescue nil
  end
end
