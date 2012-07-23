# backport IO.write to older Rubies
unless IO.respond_to?(:write)
  class IO
    def self.write(name, string)
      open(name, "wb") { |f| f.write string }
    end
  end
end
