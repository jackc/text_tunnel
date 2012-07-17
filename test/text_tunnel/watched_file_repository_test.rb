require_relative "../test_helper"
require "text_tunnel/watched_file_repository"

class WatchedFileRepositoryTest < MiniTest::Unit::TestCase
  def setup
    @repo = WatchedFileRepository.new
  end

  def test_create_returns_a_WatchedFile
    watched_file = @repo.create "foo", "bar"
    assert_kind_of WatchedFile, watched_file
  end

  def test_create_stores_created_WatchedFile
    watched_file = @repo.create "foo", "bar"
    assert_equal watched_file, @repo.find(watched_file.id)
  end

  def test_remove_makes_watched_file_no_longer_findable
    watched_file = @repo.create "foo", "bar"
    @repo.remove(watched_file)
    assert_raises(KeyError) { @repo.find(watched_file.id) }      
  end

  def test_find_existing_WatchedFile
    watched_file = @repo.create "foo", "bar"
    assert_equal watched_file, @repo.find(watched_file.id)
  end

  def test_find_raises_KeyError_on_missing_id
    assert_raises(KeyError) { @repo.find("missing") }
  end
end
