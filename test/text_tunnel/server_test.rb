require_relative "../test_helper"
require "rack/test"
require "text_tunnel/watched_file"
require "text_tunnel/watched_file_repository"
require "text_tunnel/server"

Server.configure do |s|
  s.set :editor_spawner do
    Proc.new {}
  end
  s.set :watched_files, WatchedFileRepository.new
end

class ServerTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Server
  end

  def setup
    @watched_files = WatchedFileRepository.new
    Server.configure do |s|
      s.set :watched_files, @watched_files
    end
  end

  def test_complete_editing_session
    post "/files", "file" => Rack::Test::UploadedFile.new(__FILE__, "text/plain")
    location = last_response["Location"]
    etag = last_response["Etag"]

    header("If-None-Match", etag)
    get location
    assert_equal 304, last_response.status

    watched_file_id = location[/\w+\Z/]
    local_file = @watched_files.find(watched_file_id).local_path
    File.write(local_file, "new content")

    get location
    assert_equal 200, last_response.status
    assert_equal "new content", last_response.body
  end
end
