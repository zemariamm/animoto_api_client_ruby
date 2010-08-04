module Animoto
  class << self
    attr_accessor :api_endpoint, :api_version
  end
  
  @api_endpoint = "http://api.animoto.com/"
  @api_version  = 2
end