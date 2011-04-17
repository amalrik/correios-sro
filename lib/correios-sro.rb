require "rubygems"
require "nokogiri"
require "open-uri"
require "track"
require "status"

class CorreiosSRO

  def self.track(number)
    @xml = open("http://correios-api.appspot.com/yql?numero=#{number}")
    track = Track.new(number)

    status = self.parse(track)
    track << status if not status.nil?

    return track
  end

  private
  def self.parse(track)
    xml = Nokogiri::XML(@xml)

    xml.xpath('/results/status').map do |value|
      status = Status.new.tap { |s|
        s.date = value.search('data').inner_text
        s.place = value.search('local').inner_text
        s.track = value.search('situacao').inner_text
        s.details = value.search('detalhes').inner_text
      }
    end
  end

end