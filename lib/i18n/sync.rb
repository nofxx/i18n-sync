#
#  I18S
#
#  Created on 2010-5-17.
#  Copyleft nofxx (c) 2011.
#
#
# Inspired by translation rake task on spree (http://spreecommerce.com/)
#
require 'yaml'
# Changed to use YAML instead of text regex,
# but yaml has issues so we need to:
# In order to work with utf8 encoded .yml files.
# TODO: Fixed in ruby 1.9.x ???
require 'i18n/sync/hash'
require 'i18n/sync/work'
require 'i18n/sync/cli'

module I18n
  module Sync
    DEFAULT_LOCALE = 'config/locales'

    class << self
      # Just here cuz I'm lazy....TBF really ugly !  ! ! !
      def work_on(base, opts = {})
        base = (base || DEFAULT_LOCALE).to_s
        fail "Path doesn't exist '#{base}'" unless File.exist?(base)
        if File.directory? path = base
          Dir["#{path}/**"].map do |file|
            next unless file =~ /(^|\.)#{opts[:lang]}\./
            Work.new([file], opts, argf)
          end.reject(&:nil?)
        else
          Work.new(base, opts)
        end
      end

      def add_key(key, val, file)
        hsh = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
        keys = key.split('.')
        keys.reduce(hsh) do |a, k|
          k == keys[-1] ? a[k] = val : a = a[k]
        end
        Work.new(file, {}, hsh)
      end
    end
  end
end
