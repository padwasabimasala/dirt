require 'bebo'
require 'dirt'

class Bebo::FriendListParser < Dirt::Parser
  def parse_friends
    @content.scan(%r{MemberId=(\d*)><b>}).flatten.compact
  end
end

if __FILE__ == $0
  require 'pp'
  p Bebo::FriendListParser.new(IO.read(ARGV.first)).parse
end
