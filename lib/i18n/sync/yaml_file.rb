module I18n
  module Sync
    class YamlFile
      attr_accessor :path, :prefix, :lang, :data

      def initialize(file)
        fail "File doesn't exist '#{file}'" unless File.exist?(file)
        name, @path = File.basename(file), File.dirname(file)
        _ext, @lang, @prefix = name.split('.').reverse
        @data ||= YAML.load(File.open(file, 'r:utf-8'))[lang]
        @comm ||= File.read(file).lines.select { |l| l =~ /^\w*#/ }.join("\n")
      end

      def file
        @file ||= File.join(path, [prefix, lang, :yml].join('.'))
      end

      def siblings
        Dir["#{path}/#{prefix}*.{yml,rb}"] - Dir[file]
      end

      def sync!(master)
        @data = master.data.dup.deep_sync!(data)
      end

      def write!
        File.delete file if File.exist? file
        File.open(file, 'w:utf-8') do |f|
          f.puts(@comm) if @comm
          yaml = { lang => data }.to_yaml # ya2yaml
          yaml.gsub!(/ +$/, '') # removing trailing spaces
          f.puts(yaml)
        end
      end
    end
  end
end
