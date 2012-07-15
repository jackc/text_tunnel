require "tmpdir"
require "fileutils"
require "securerandom"

class WatchedFile
  def initialize(name, data)
    @original_name = name
    @original_data = data
    FileUtils.mkdir_p local_dir
    File.write(local_path, data)
    refresh_mtime
    open_editor
  end

  def id
    @id ||= SecureRandom.hex
  end

  def editing_complete?
    @editing_complete ||= mtime_changed?
  end

  def data
    raise "Can't read data until editing complete" unless editing_complete?
    @data ||= File.read(local_path)
  end

  def changed?
    data != original_data
  end

  def open_editor
    # TODO - configure what editor to use
    pid = spawn "/usr/local/bin/subl", local_path
    Process.detach(pid)
  end

  private
    attr_reader :original_name,
                :original_data,
                :mtime    

    def sanitized_name
      # TODO
      original_name
    end

    def local_dir
      @local_dir ||= "#{Dir.tmpdir}/text-tunnel/#{id}"
    end

    def local_path
      @local_path ||= "#{local_dir}/#{sanitized_name}"
    end

    def mtime_changed?
      old_mtime = mtime
      refresh_mtime
      old_mtime != mtime
    end

    def refresh_mtime
      @mtime = File.mtime(local_path)
    end
end