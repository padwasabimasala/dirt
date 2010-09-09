require 'bebo'
require 'dirt'
require 'private_data'

class Bebo::Crawler < Dirt::Crawler
  LOGIN_REQUIRED = /Please Log In/
  PRIVATE_PROFILE = /You must be friends with this person to view their profile/

  def login
    signin_url = "https://secure.bebo.com/SignIn.jsp"
    @agent.get(signin_url)
    # set your own user and pass in private_data.rb
    resp = @agent.post(signin_url, {:EmailUsername => $user, :Password => $pass, :SignIn => 'Log+In'})
    @logged_in = true
  end

  def crawl(email)
    login if !@logged_in
    id = get_member_id(email)
    return nil if !id
    result = {
      :id => id,
      :public_profile => get_public_profile(id),
      :friend_list => get_friend_list(id)
    }
  end

  def get_member_id(email)
    search_url = "http://www.bebo.com/c/search?SearchTerm=%s"
    page = @agent.get search_url % email.strip
    page ? page.body.scan(/AddAsFriendBox.forMemberId\((\d*)\)/).flatten.first : nil
  end

  def get_public_profile(id)
    profile_url = "http://www.bebo.com/Profile.jsp?MemberId=%s" % id
    page  = @agent.get profile_url % id
    raise "Login Required" if page.body =~ LOGIN_REQUIRED
    return nil if page.body =~ PRIVATE_PROFILE
    page.body
  end

  def get_friend_list(id)
    friends_url = "http://bebo.com/FriendList.jsp?MemberId=%s" % id
    page  = @agent.get friends_url % id
    return nil if page.body =~ PRIVATE_PROFILE
    page.body
  end
end
