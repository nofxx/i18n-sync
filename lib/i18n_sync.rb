#
# Based on translation rake task on spree (http://spreecommerce.com/)
#
class I18S

  def initialize(argv, opts, argf=[])
    # argf.each { |file| p file }
    @fullpath, *new_ones = argv
    @file, *path = @fullpath.split("/").reverse # hm.. hack,,, in 1.9
    @path = path.reverse.join("/")              # can splat the first
    @lang = @file.split(".")[0]
    @debug = opts[:trace]
    @order = opts[:order]
    puts "Start work on #{@file} (#{@lang})"
    @words = get_translation_keys
    if new_ones.empty?
      sync
    else
      new_ones.each do |file|
        puts "Creating new file #{file}"
        create(file)
      end
    end
  end

  def sync
    Dir["#{@path}/*.{yml,rb}"].each do |filename|
      #next if filename.match('_rails')
      basename = File.basename(filename, '.yml')
      puts "Writing #{filename} -> #{basename}"
      (comments, other) = read_file(filename, basename)
      @words.each { |k,v| other[k] ||= @words[k] }                    #Initializing hash variable as empty if it does not exist
      other.delete_if { |k,v| !@words[k] }                            #Remove if not defined in en-US.yml
      write_file(filename, basename, comments, other)
    end
  end

  def create(file)
    fullpath = "#{@path}/#{file}.yml"
    return puts("File exists.") if File.exists?(fullpath)
    write_file(fullpath, file, "", @words)
  end

  #Retrieve US word set
  def get_translation_keys
    (dummy_comments, words) = read_file(@fullpath, @lang)
    words
  end

  #Retrieve comments, translation data in hash form
  def read_file(filename, basename)
    (comments, data) = IO.read(filename).split(/\n*#{basename}:\s*\n/)   #Add error checking for failed file read?
    return comments, create_hash(data, basename)
  end

  #Creates hash of translation data
  def create_hash(data, basename)
    words = Hash.new
    return words if !data
    parent = Array.new
    previous_key = 'base'
    data.split("\n").each do |w|
      next if w.strip.empty?
      (key, value) = w.split(':')
      value ||= ''
      shift = (key =~ /\w/)/2 - parent.size                             #Determine level of current key in comparison to parent array
      key = key.sub(/^\s+/,'')
      parent << previous_key if shift > 0                               #If key is child of previous key, add previous key as parent
      (shift*-1).times { parent.pop } if shift < 0                      #If key is not related to previous key, remove parent keys
      previous_key = key                                                #Track key in case next key is child of this key
      words[parent.join(':')+':'+key] = value
    end
    words
  end

  #Writes to file from translation data hash structure
  def write_file(filename,basename,comments,words)
    File.open(filename, "w") do |log|
      log.puts(comments+"\n"+basename+": \n")
      words.sort.each do |k,v|
        keys = k.split(':')
        (keys.size-1).times { keys[keys.size-1] = '  ' + keys[keys.size-1] }   #Add indentation for children keys
        log.puts(keys[keys.size-1]+':'+v+"\n")
      end
    end

  end

  def out(txt)
    puts txt if @debug
  end

end
