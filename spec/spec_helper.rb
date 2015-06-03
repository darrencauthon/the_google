require_relative '../lib/the_google'
require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require 'timecop'

def random_string
  SecureRandom.uuid
end

def random_integer
  Random.rand(10000)
end
