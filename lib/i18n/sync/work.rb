module I18n
  module Sync
    # Main class
    class Work
      def initialize(argv, opts = {}, keys = {}, _argf = [])
        # argf.each { |file| p file }
        @fullpath, *@new_ones = argv
        @file, *path = @fullpath.split('/').reverse # hm.. hack,,, in 1.9
        @path = path.reverse.join('/') || '.'       # can splat the first
        _, @lang, @namespace = @file.split('.').reverse
        @debug = opts[:debug]
        @order = opts[:order]
        @comments, @words = read_file(@fullpath, @lang)
        @words.merge! keys unless keys.empty?
        start
      end

      def start
        out "Start work on #{@file} (#{@lang})"
        @new_ones.empty? ? sync : create_new_files
      end

      def create_new_files
        @new_ones.each do |name|
          puts "Creating new file #{name}"
          create name
        end
      end

      def sync
        Dir["#{@path}/*.{yml,rb}"].each do |filename|
          lang, namespace = File.basename(filename, '.yml').split('.').reverse
          if namespace
            next unless @namespace && @namespace == namespace
          else
            next if @namespace
          end

          out "Writing #{filename}"
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
      def read_file(filename, basename)
        comments = File.read(filename).each_line.select { |l| l =~ /^\w*#/ }.join("\n")
        [comments, YAML.load(File.open(filename, 'r:utf-8'))[basename]]
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

      def out(txt)
        puts txt if @debug
      end
    end
  end
end
