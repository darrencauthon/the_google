require "the_google/perspective"
require "the_google/version"

module TheGoogle

  def self.perspective_of input
    TheGoogle::Perspective.new input.merge(self.config)
  end

end
