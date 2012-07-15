require_relative "../test_helper"
require "text_tunnel/watched_file_repository"

# TODO - when editor is configurable take this stub out
class WatchedFile
  def open_editor
  end
end

describe "WatchedFileRepository" do
  before do
    @repo = WatchedFileRepository.new
  end

  describe "create" do
    it "returns a WatchedFile" do
      watched_file = @repo.create "foo", "bar"
      assert_kind_of WatchedFile, watched_file
    end

    it "stores created WatchedFile" do
      watched_file = @repo.create "foo", "bar"
      assert_equal watched_file, @repo.find(watched_file.id)
    end
  end

  describe "remove" do
    it "makes watched file no longer findable" do
      watched_file = @repo.create "foo", "bar"
      @repo.remove(watched_file)
      assert_raises(KeyError) { @repo.find(watched_file.id) }      
    end
  end

  describe "find" do
    it "finds existing WatchedFile" do
      watched_file = @repo.create "foo", "bar"
      assert_equal watched_file, @repo.find(watched_file.id)
    end

    it "raises KeyError on missing id" do
      assert_raises(KeyError) { @repo.find("missing") }
    end
  end
end
