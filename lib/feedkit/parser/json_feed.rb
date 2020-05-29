# frozen_string_literal: true

module Feedkit
  module Parser
    class JSONFeed < Feed

      def feed
        @feed ||= JSON.load(@body)
      end

      def title
        @title ||= feed["title"]
      end

      def site_url
        @site_url ||= begin
          if feed["home_page_url"]
            url = feed["home_page_url"]
          else
            url = url_from_host(feed_url)
          end
          url
        end
      end

      def self_url
        @self_url ||= begin
          if feed["feed_url"]
            url = feed["feed_url"]
            if !url.match(/^http/)
              url = URI.join(feed_url, url).to_s
            end
          end
          url
        rescue
          feed_url
        end
      end

      def hubs
        []
      end

      def author
        @author ||= begin
          if feed["author"] && feed["author"]["name"]
            feed["author"]["name"]
          else
            nil
          end
        end
      end

      def entries
        @entries ||= begin
          entries = []
          if !feed["items"].nil? && feed["items"].length > 0
            entries = feed["items"].map do |entry|
              JSONEntry.new(entry, base_url, author)
            end
            entries = entries.uniq { |entry| entry.public_id }
          end
          entries
        end
      end

      def valid?
        @valid ||= feed["version"].start_with?("https://jsonfeed.org/version/") && feed["title"]
      end

      def options
        keys = %w{version title home_page_url feed_url description user_comment next_url icon favicon author name url avatar expired hubs}
        {json_feed: feed.slice(*keys)}
      end

    end
  end
end