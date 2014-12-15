module I18n
  module Sync
    # Main class
    class Work
      attr_accessor :master, :debug

      def initialize(master,  opts = {}) #, keys = {}, _argf = [])
        @master = YamlFile.new(master)
        say "Start work on #{master}"
      end

      def self.sync_dir(path, master, opts = {})
        path ||= DEFAULT_LOCALE
        fail "Path doesn't exist '#{path}'" unless File.exist?(path)
        Dir["#{path}/**"].map do |file|
          next unless file =~ /(^|\.)#{master}\./
          new(file,  opts)
        end
      end

      def sync
        master.siblings.each do |file|
          say "Syncing #{file}"
          other = YamlFile.new(file)
          other.sync_with!(master)
          other.write!
        end
      end

      def create_new_files
        @new_ones.each do |name|
          say "Creating new file #{name}"
          create name
        end
      end

      def create(newlang)
        # New name  "app.en.yml" -> "app.pt.yml", "en.yml" -> "pt.yml"
        newname =  @file.gsub(/(^|\.)#{@lang}\./, "\\1#{newlang}.")
        fullpath =  "#{@path}/#{newname}"
        return puts('File exists.') if File.exist?(fullpath)
        write_file(fullpath, newlang, @comments, @words)
      end

      def say(txt)
        puts txt # if debug
      end
    end
  end
end
