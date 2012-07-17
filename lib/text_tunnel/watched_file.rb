require "tmpdir"
require "fileutils"
require "securerandom"
require "digest"

class WatchedFile
  attr_reader :id
  attr_reader :local_path
  attr_reader :data
  attr_reader :hash

  def initialize(name, data)
    @name = sanitize_name(name)
    @data = data
    @id = SecureRandom.hex
    @local_dir = "#{Dir.tmpdir}/text-tunnel/#{id}"
    @local_path = "#{@local_dir}/#{@name}"

    write_temp_file
  end

  def poll
    old_mtime = @mtime
    @mtime = File.mtime(local_path)
    if @mtime != old_mtime
      @mtime = old_mtime
      @data = File.read(local_path)
      hash_data
    end
  end

  private
    def write_temp_file
      FileUtils.mkdir_p @local_dir
      File.write(@local_path, @data)
      @mtime = File.mtime(local_path)
      hash_data
    end

    def hash_data
      @hash = Digest::SHA1.hexdigest(@data)
    end

    def sanitize_name(name)
      name.gsub(/\W/, "")
    end
end
