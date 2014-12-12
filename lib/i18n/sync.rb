#
# Inspired by translation rake task on spree (http://spreecommerce.com/)
#
require 'yaml'
# Changed to use YAML instead of text regex,
# but yaml has issues so we need to:
require 'ya2yaml'
# In order to work with utf8 encoded .yml files.
# TODO: Fixed in ruby 1.9.x ???
require 'i18n/sync/hash'


module I18n

  class Sync

    def initialize(argv, opts = {}, keys = {}, argf=[])
      # argf.each { |file| p file }
      @fullpath, *@new_ones = argv
      @file, *path = @fullpath.split("/").reverse # hm.. hack,,, in 1.9
      @path = path.reverse.join("/") || "."       # can splat the first
      _, @lang, @namespace = @file.split(".").reverse
      @debug = opts[:debug]
      @order = opts[:order]
      @comments, @words = read_file(@fullpath, @lang)
      @words.merge! keys unless keys.empty?
      work
    end

    def work
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
        lang, namespace = File.basename(filename, '.yml').split(".").reverse
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

    def create newlang
      # New name  "app.en.yml" -> "app.pt.yml", "en.yml" -> "pt.yml"
      newname =  @file.gsub(/(^|\.)#{@lang}\./, "\\1#{newlang}.")
      fullpath =  "#{@path}/#{newname}"
      return puts("File exists.") if File.exists?(fullpath)
      write_file(fullpath, newlang, @comments, @words)
    end

    # Retrieve comments and translation data in hash form
    def read_file(filename, basename)
      comments = File.read(filename).each_line.select { |l| l =~ /^\w*#/}.join("\n")
      [comments, YAML.load(File.open(filename, "r:utf-8"))[basename]]
    end

    # Writes to file the translation data hash structure
    def write_file(filename, basename, comments, data)
      File.delete filename if File.exists? filename
      File.open(filename, "w:utf-8") do |y|
        y.puts(comments) if comments
        yaml = { basename => data }.ya2yaml

        yaml.gsub!(/ +$/, '') # removing trailing spaces
        y.puts(yaml)
      end
    end

    def out(txt)
      puts txt if @debug
    end

    class << self

      # Just here cuz I'm lazy....TBF really ugly !  ! ! !
      def work_on(argv, opts = {}, argf = [])
        if File.directory? path = argv[0]
          Dir["#{path}/**"].map do |file|
            next unless file =~ /(^|\.)#{opts[:lang]}\./
            new([file], opts, argf)
          end.reject(&:nil?)
        else
          [new(argv, opts, argf)]
        end
      end

      def add_key(key, val, file)
        hsh = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
        keys = key.split(".")
        keys.reduce(hsh) do |a, k|
          k == keys[-1] ? a[k] = val : a = a[k]
        end
        new(file, {}, hsh)
      end

    end

  end
end
