require "watched_file"

class WatchedFileRepository
  def initialize
    @watched_files = {}
  end

  def create(name, data)
    watched_file = WatchedFile.new(name, data)
    @watched_files[watched_file.id] = watched_file
  end

  def remove(watched_file)
    @watched_files.delete(watched_file.object_id)
  end

  def find(id)
    @watched_files.fetch(id)
  end
end
