here = File.dirname(__FILE__)
require here + '/asset'
require here + '/project'
require here + '/resource'
require here + '/storyboard'
require here + '/video'
require here + '/job'
require here + '/directing_and_rendering_job'
require here + '/directing_job'
require here + '/rendering_job'

module Animoto
  class Client
    API_ENDPOINT  = "http://api.animoto.com/"
    API_VERSION   = 2
    
  end
end