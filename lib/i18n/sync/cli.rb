require 'thor'

module I18n
  module Sync
    # Command line
    class CLI < Thor
      class_option :language, type: :string, aliases: [:lang, :l]
      class_option :verbose, type: :boolean, aliases: :v
      class_option :order, type: :boolean, default: true
      class_option :chomp, type: :boolean, default: true

      desc 'all', 'Syncs all files (separeted by prefixes)'
      option :base
      def all
      end

      desc 'new LANGS', 'Creates new languages'
      option :base
      def new(langs)
        I18n::Sync.work_on params.first, langs, options
      end

      desc 'add KEY', 'Adds key on all locales'
      def add(key, prefix = :app)
        I18n::Sync.add_key key, prefix
        #         hsh = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
        # keys = key.split('.')
        # keys.reduce(hsh) do |a, k|
        #   k == keys[-1] ? a[k] = val : a = a[k]
        # end
        # Work.new(file, {}, hsh)

      end

      desc 'del KEY', 'Removes key on all locales'
      def del(key, prefix = nil)
        I18n::Sync.del_key key, prefix
      end

      def method_missing(*params)
        return super if params.size > 1
        I18n::Sync::Work.new(params.join, options).sync
      end
    end
  end
end
