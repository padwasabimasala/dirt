require 'bebo'
require 'dirt'

class Bebo::PublicProfileParser < Dirt::Parser
  def parse_last_active
    extract %r{Last active: </strong>\s*<span>([0-9/]*)}
  end

  def parse_gender
    extract %r{user-asl">\s*<li>\s*(\w*)}
  end

  def parse_age
    extract %r{user-asl">\s*<li>\s*\w*, (\d*)}
  end

  def parse_hometown
    @doc.css("li.hometown").text.strip
  end
end

if __FILE__ == $0
  p Bebo::PublicProfileParser.new(IO.read(ARGV.first)).parse
end
