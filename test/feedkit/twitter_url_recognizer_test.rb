require 'test_helper'

class Feedkit::TwitterURLRecognizerTest < Minitest::Test

  def test_should_recognize_user_urls
    url = "https://twitter.com/bsaid"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "@bsaid", twitter_feed.title
    assert_equal [:user_timeline, "bsaid", {count: 100, tweet_mode: "extended", exclude_replies: true}], twitter_feed.client_args
    assert_equal({"twitter_user"=>[:user, "bsaid"]}, twitter_feed.feed_options)
    assert_equal(url, twitter_feed.url.to_s)
  end

  def test_should_recognize_mobile_user_urls
    url = "https://mobile.twitter.com/bsaid"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "@bsaid", twitter_feed.title
    assert_equal [:user_timeline, "bsaid", {count: 100, tweet_mode: "extended", exclude_replies: true}], twitter_feed.client_args
    assert_equal({"twitter_user"=>[:user, "bsaid"]}, twitter_feed.feed_options)
    assert_equal(url, twitter_feed.url.to_s)
  end

  def test_should_recognize_user
    url = "@bsaid"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "@bsaid", twitter_feed.title
    assert_equal [:user_timeline, "bsaid", {count: 100, tweet_mode: "extended", exclude_replies: true}], twitter_feed.client_args
    assert_equal({"twitter_user"=>[:user, "bsaid"]}, twitter_feed.feed_options)
    assert_equal("https://twitter.com/bsaid", twitter_feed.url.to_s)
  end

  def test_should_recognize_search_urls
    url = "https://twitter.com/search?q=feedbin+ben&l=en&src=typd"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "Twitter Search: feedbin ben", twitter_feed.title
    assert_equal [:search, "feedbin+ben", {count: 100, tweet_mode: "extended", result_type: "recent", include_entities: true, lang: "en"}], twitter_feed.client_args
    assert_equal({}, twitter_feed.feed_options)
    assert_equal(url, twitter_feed.url.to_s)
  end

  def test_should_recognize_list_urls
    url = "https://twitter.com/bsaid/lists/conversationlist"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "Twitter List: bsaid/conversationlist", twitter_feed.title
    assert_equal [:list_timeline, "bsaid", "conversationlist", {count: 100, tweet_mode: "extended"}], twitter_feed.client_args
    assert_equal({}, twitter_feed.feed_options)
    assert_equal(url, twitter_feed.url.to_s)
  end

  def test_should_recognize_hashtag_urls
    url = "https://twitter.com/hashtag/feedbin?src=hash"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "Twitter: #feedbin", twitter_feed.title
    assert_equal [:search, "#feedbin", {count: 100, tweet_mode: "extended"}], twitter_feed.client_args
    assert_equal({}, twitter_feed.feed_options)
    assert_equal(url, twitter_feed.url.to_s)
  end

  def test_should_recognize_hashtags
    url = "#feedbin"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "bsaid")
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "Twitter: #feedbin", twitter_feed.title
    assert_equal [:search, "#feedbin", {count: 100, tweet_mode: "extended"}], twitter_feed.client_args
    assert_equal({}, twitter_feed.feed_options)
    assert_equal("https://twitter.com/hashtag/feedbin", twitter_feed.url.to_s)
  end

  def test_should_recognize_home
    url = "twitter.com"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, "feedbin")
    assert twitter_feed.valid?
    assert_equal :twitter_home, twitter_feed.type
    assert_equal "Twitter", twitter_feed.title
    assert_equal [:home_timeline, {count: 100, tweet_mode: "extended"}], twitter_feed.client_args
    assert_equal({}, twitter_feed.feed_options)
    assert_equal("https://twitter.com?screen_name=feedbin", twitter_feed.url.to_s)
  end

  def test_should_get_screen_name_from_url
    url = "https://twitter.com?screen_name=bsaid"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, nil)
    assert twitter_feed.valid?
    assert_equal :twitter_home, twitter_feed.type
    assert_equal "Twitter", twitter_feed.title
    assert_equal [:home_timeline, {count: 100, tweet_mode: "extended"}], twitter_feed.client_args
    assert_equal({}, twitter_feed.feed_options)
    assert_equal("https://twitter.com?screen_name=bsaid", twitter_feed.url.to_s)
  end

  def test_should_recognize_with_replies
    url = "https://twitter.com/bsaid/with_replies"
    twitter_feed = ::Feedkit::TwitterURLRecognizer.new(url, nil)
    assert twitter_feed.valid?
    assert_equal :twitter, twitter_feed.type
    assert_equal "@bsaid", twitter_feed.title
    assert_equal [:user_timeline, "bsaid", {count: 100, tweet_mode: "extended", exclude_replies: false}], twitter_feed.client_args
    assert_equal({"twitter_user"=>[:user, "bsaid"]}, twitter_feed.feed_options)
    assert_equal(url, twitter_feed.url.to_s)
  end
end
