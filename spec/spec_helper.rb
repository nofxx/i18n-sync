$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'i18n/sync'
require 'rspec'

include I18n::Sync

TMP_FIX = File.join(File.dirname(__FILE__), 'tmp')
# Spec::Runner.configure do |config|
# end
def fixture_path(file)
  File.join(TMP_FIX, file)
end
