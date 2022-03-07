require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |st|
      students << {
        name: st.css("h4").text,
        location: st.css("p").text,
        profile_url: st.css("a").attribute('href').text
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile = {}
    doc = Nokogiri::HTML(open(profile_url))
    profile = {
      profile_quote: doc.css(".profile-quote").text,
      bio: doc.css(".description-holder p").text
    }
    social = doc.css(".social-icon-container a")
    social.each do |img|
      case img.css(".social-icon").attribute('src').text
      when "../assets/img/twitter-icon.png"
        profile.store(:twitter, img.attribute('href').text)
      when "../assets/img/linkedin-icon.png"
        profile.store(:linkedin, img.attribute('href').text)
      when "../assets/img/github-icon.png"
        profile.store(:github, img.attribute('href').text)
      when "../assets/img/rss-icon.png"
        profile.store(:blog, img.attribute('href').text)
      end
    end
    profile
  end

end

