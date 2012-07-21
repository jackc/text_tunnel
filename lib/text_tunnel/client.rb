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

    # TODO - handle new files
    response = RestClient.post "http://localhost:#{port}/files",
      :name => File.basename(@file_path),
      :data => File.read(file_path)
    raise UnexpectedResponseError.new(response) unless response.code == 201
    @location = response.headers[:location]
    @etag = response.headers[:etag]
  end

  # Returns a truthy value if a change was made
  def poll
    response = RestClient.get(@location, :if_none_match => @etag)
    raise UnexpectedResponseError.new(response) unless response.code == 200

    @etag = response.headers[:etag]

    # TODO - gracefully handle unable to write due to permissions
    File.write(@file_path, response.body)
  rescue RestClient::NotModified
    false
  end

  def cleanup
    # This call can fail, especially if text_tunnel is terminating because of
    # a previous error. So swallow any errors.
    RestClient.delete(@location) rescue nil
  end
end
