module I18n
  module Sync
    class YamlFile
      attr_accessor :path, :prefix, :lang

      def initialize(file)
        fail "File doesn't exist '#{file}'" unless File.exist?(file)

        name, @path = File.basename(file), File.dirname(file)
        _ext, @lang, @prefix = name.split('.').reverse
      end

      def file
        @file ||= File.join(path, [prefix, lang, :yml].join("."))
      end

      def comments
        @comm ||= File.read(file).lines.select { |l| l =~ /^\w*#/ }.join("\n")
      end

      def data
        @data ||= YAML.load(File.open(file, 'r:utf-8'))[lang]
      end

      def siblings
        Dir["#{path}/#{prefix}*.{yml,rb}"] - Dir[file]
      end

      # Ensures multilevel hash merging
      def sync_with!(master)
        p master.data
        p master.comments
        p data
        p comments
        p self
        master.data.each do |k, v|
          next unless (tv = data[k])
          data[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.dup.deep_sync!(v) : v
        end
      end

      def write!
        File.delete file if File.exist? file
        File.open(file, 'w:utf-8') do |f|
          f.puts(comments) if comments
          yaml = { prefix => data }.to_yaml # ya2yaml
          yaml.gsub!(/ +$/, '') # removing trailing spaces
          f.puts(yaml)
        end
      end
    end
  end
end
