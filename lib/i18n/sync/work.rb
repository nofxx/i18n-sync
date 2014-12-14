module I18n
  module Sync
    # Main class
    class Work
      attr_accessor :path, :prefix, :master, :debug

      def initialize(master = :en, prefix = nil, path = nil,  opts = {}) #, keys = {}, _argf = [])
        # argf.each { |file| p file }
        @master = master
        @prefix = prefix
        @path = path
        file = File.join(path, [prefix, master, :yml].join("."))
        @comments, @words = read_file file, master
        # @words.merge! keys unless keys.empty?
        say "Start work on #{file} (#{master})"
        sync
      end

      def self.from_master(file, opts = {})
        name, path = File.basename(file), File.dirname(file)
        _ext, master, prefix = name.split('.').reverse
        new(master, prefix, path, opts)
      end


      def start
        @new_ones.empty? ? sync : create_new_files
      end

      def create_new_files
        @new_ones.each do |name|
          say "Creating new file #{name}"
          create name
        end
      end

      def sync
        Dir["#{@path}/#{prefix}*.{yml,rb}"].each do |filename|
          lang, pre = File.basename(filename, '.yml').split('.').reverse

          say "Writing #{filename}"
          (_comments, old) = read_file(filename, lang)
          # Initializing hash variable as empty if it does not exist
          other = @words.dup.deep_sync! old
          write_file(filename, lang, @comments, other)
        end
      end

      def create(newlang)
        # New name  "app.en.yml" -> "app.pt.yml", "en.yml" -> "pt.yml"
        newname =  @file.gsub(/(^|\.)#{@lang}\./, "\\1#{newlang}.")
        fullpath =  "#{@path}/#{newname}"
        return puts('File exists.') if File.exist?(fullpath)
        write_file(fullpath, newlang, @comments, @words)
      end

      # Retrieve comments and translation data in hash form
      def read_file file, namespace
        comments = File.read(file).each_line.select { |l| l =~ /^\w*#/ }.join("\n")
        [comments, YAML.load(File.open(file, 'r:utf-8'))[namespace]]
      end

      # Writes to file the translation data hash structure
      def write_file(filename, basename, comments, data)
        File.delete filename if File.exist? filename
        File.open(filename, 'w:utf-8') do |y|
          y.puts(comments) if comments
          yaml = { basename => data }.to_yaml # ya2yaml

          yaml.gsub!(/ +$/, '') # removing trailing spaces
          y.puts(yaml)
        end
      end

      def say(txt)
        puts txt # if debug
      end
    end
  end
end
