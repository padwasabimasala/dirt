require 'dirt'

class Dirt::Crawler
  def initialize
    @agent = Dirt::Agent.new {|a|
      a.user_agent_alias = 'Mac Safari'
      a.follow_meta_refresh = true
    }
  end
end
