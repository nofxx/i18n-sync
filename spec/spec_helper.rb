$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'i18n/sync'
begin
  require 'spec'
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end

# Spec::Runner.configure do |config|
# end
