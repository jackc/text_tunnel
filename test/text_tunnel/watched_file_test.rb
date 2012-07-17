require_relative "../test_helper"
require "text_tunnel/watched_file"

class WatchedFileTest < MiniTest::Unit::TestCase
  def test_id_is_constant
    wf = WatchedFile.new("foo", "bar")
    assert_equal wf.id, wf.id
  end

  def test_id_is_different_for_each_object
    refute_equal WatchedFile.new("foo", "bar").id, WatchedFile.new("foo", "bar").id
  end

  def test_local_path_points_to_file_with_data
    wf = WatchedFile.new("foo", "bar")
    assert_equal "bar", File.read(wf.local_path)
  end

  def test_poll_updates_data_and_hash_when_file_changes
    wf = WatchedFile.new("foo", "bar")
    old_hash, old_data = wf.hash, wf.data

    # Without the sleep the original write and the following are so close
    # together that the mtime is the same. I suppose this could be fixed by
    # using guard-listen or EventMachine::FileWatcher, but in real usage it
    # shouldn't be an issue. I prefer to keep the brain-dead simple polling
    # instead of complicating this by requiring eventing or threading.
    sleep 0.1

    File.write(wf.local_path, "quz")
    wf.poll

    refute_equal old_hash, wf.hash
    refute_equal old_data, wf.data
  end

  def test_sanitize_name_replaces_bad_characters
    dirty_name = "/\\\"'asdf#!@$ %^&*(){}}<>?'"
    sanitized_name = WatchedFile.new("foo", "bar").instance_eval { sanitize_name(dirty_name) }
    assert_equal "asdf", sanitized_name
  end
end
