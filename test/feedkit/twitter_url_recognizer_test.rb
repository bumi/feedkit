require 'test_helper'

class Feedkit::TwitterURLRecognizerTest < Minitest::Test

  def test_should_recognize_user_urls
    url = "https://twitter.com/bsaid"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal "bsaid", twitter_feed.value
    assert_equal :user, twitter_feed.type
  end

  def test_should_recognize_user
    url = "@bsaid"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal "bsaid", twitter_feed.value
    assert_equal :user, twitter_feed.type
  end

  def test_should_recognize_search_urls
    url = "https://twitter.com/search?q=feedbin+ben&src=typd"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal "feedbin ben", twitter_feed.value
    assert_equal :search, twitter_feed.type
  end

  def test_should_recognize_list_urls
    url = "https://twitter.com/bsaid/lists/conversationlist"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    result = {user: "bsaid", list: "conversationlist"}
    assert twitter_feed.valid?
    assert_equal result, twitter_feed.value
    assert_equal :list, twitter_feed.type
  end

  def test_should_recognize_hashtag_urls
    url = "https://twitter.com/hashtag/feedbin?src=hash"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal "#feedbin", twitter_feed.value
    assert_equal :search, twitter_feed.type
  end

  def test_should_recognize_hashtags
    url = "#feedbin"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal "#feedbin", twitter_feed.value
    assert_equal :search, twitter_feed.type
  end

  def test_should_recognize_home
    url = "twitter.com"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "feedbin")
    assert twitter_feed.valid?
    assert_equal "feedbin", twitter_feed.value
    assert_equal :home, twitter_feed.type
  end
end