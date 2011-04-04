#
# Based on translation rake task on spree (http://spreecommerce.com/)
#
require 'ya2yaml'

class I18S

  def initialize(argv, opts = {}, argf=[])
    # argf.each { |file| p file }
    @fullpath, *@new_ones = argv
    @file, *path = @fullpath.split("/").reverse # hm.. hack,,, in 1.9
    @path = path.reverse.join("/") || "."       # can splat the first
    _, @lang, @namespace = @file.split(".").reverse
    @debug = opts[:trace]
    @order = opts[:order]
    @comments, @words = read_file(@fullpath, @lang)
  end

  def work
    puts "Start work on #{@file} (#{@lang})"
    @new_ones.empty? ? sync : create_new_files
  end

  def create_new_files
    @new_ones.each do |file|
      puts "Creating new file #{file}"
      create(file)
    end
  end

  def sync
    Dir["#{@path}/*.{yml,rb}"].each do |filename|
      #next if filename.match('_rails')
      next if filename =~ /#{@file}/
      lang, namespace = File.basename(filename, '.yml').split(".").reverse  #filename.split("/").last.split(".").reverse
      if namespace
        next unless @namespace && @namespace == namespace
      else
        next if @namespace
      end

      puts "Writing #{filename}"
      (_comments, other) = read_file(filename, lang)
      # Initializing hash variable as empty if it does not exist
      @words.each { |k,v| other[k] ||= @words[k] }
      # Remove if not defined in master
      other.delete_if { |k,v| !@words[k] }
      write_file(filename, lang, @comments, other)
    end
  end

  def create(file)
    fullpath = file =~ /\// ? file : "#{@path}/#{file}.yml"
    return puts("File exists.") if File.exists?(fullpath)
    write_file(fullpath, file, @comments, @words)
  end

  #Retrieve comments, translation data in hash form
  def read_file(filename, basename)
    comments = File.read(filename).each_line.select { |l| l =~ /^\w*#/}.join("\n")
    [comments, YAML.load(File.open(filename, "r:utf-8"))[basename]]
  end

  #Creates hash of translation data
  #def create_hash(data, filename)
    # return {} unless data
    # words = Hash.new
    # return words if !data
    # parent = Array.new
    # previous_key = 'base'
    # data.split("\n").each do |w|
    #   next if w.strip.empty?
    #   w.sub!(":", "") if w =~ /^(\s*)\:/
    #   (key, *value) = w.split(':')
    #   value = value.join# ||= ''
    #   shift = (key =~ /\w/)/2 - parent.size                             #Determine level of current key in comparison to parent array
    #   key = key.sub(/^\s+/,'')
    #   parent << previous_key if shift > 0                               #If key is child of previous key, add previous key as parent
    #   (shift*-1).times { parent.pop } if shift < 0                      #If key is not related to previous key, remove parent keys
    #   previous_key = key                                                #Track key in case next key is child of this key
    #   words[parent.join(':')+':'+key] = value
    # end
    # words
  #end

  #Writes to file from translation data hash structure
  def write_file(filename, basename, comments, data)
    File.delete filename if File.exists? filename
    File.open(filename, "w:utf-8") do |y|
      y.puts(comments) if comments
      #y.puts(basename + ":\n")
      y.puts({ basename => data }.ya2yaml )# (:sick_compatible => true))
      # words.sort.each do |k,v|
      #   keys = k.split(':')
      #   (keys.size-1).times { keys[keys.size-1] = '  ' + keys[keys.size-1] }   #Add indentation for children keys
      #   y.puts(keys[keys.size-1]+':'+v+"\n")
      # end
    end
  end

  def out(txt)
    puts txt if @debug
  end

end
