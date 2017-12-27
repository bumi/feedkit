$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "feedbin/parser"

require "minitest/autorun"
require 'webmock/minitest'

def stub_request_file(file, url, options={})
  file = File.join('test/support/www', file)
  defaults = {body: File.new(file), status: 200}
  stub_request(:get, url).
    to_return(defaults.merge(options))
end

def random_string
  (0...50).map { ('a'..'z').to_a[rand(26)] }.join
end