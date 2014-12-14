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
require 'i18n/sync/core_ext/hash/deep_sync'
require 'i18n/sync/work'
require 'i18n/sync/cli'

module I18n
  #
  #
  # I18n Sync
  #
  #
  module Sync
    DEFAULT_LOCALE = 'config/locales'

  end
end
