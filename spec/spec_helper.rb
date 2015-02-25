require_relative '../lib/the_google'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'

def random_string
  SecureRandom.uuid
end
