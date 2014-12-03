WARBLER_CONFIG = {}


ENV['GEM_HOME'] = File.expand_path('../..', __FILE__)


ENV['BUNDLE_GEMFILE'] = File.expand_path('../../ead2pdf/Gemfile', __FILE__)

$LOAD_PATH.unshift __FILE__.sub(/!.*/, '!/ead2pdf/lib')
$LOAD_PATH.unshift __FILE__.sub(/!.*/, '!/ead2pdf/bin')
require 'rubygems'
ENV['BUNDLE_WITHOUT'] = 'development:test:assets'

