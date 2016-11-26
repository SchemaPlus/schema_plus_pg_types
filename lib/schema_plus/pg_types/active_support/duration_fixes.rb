require 'active_support/duration'
require 'active_support/duration/iso8601_serializer'

class ActiveSupport::Duration
  # Patch rails inconsistent handling of ISO8601 dates.
  # ActiveSupport::Duration uses fixes values for date and time elements:
  # 1 Year = 365.25 days, 1 Month = 30 days, 1 Day = 24 hours, etc.
  # The original parse() implementation advanced the current time by the
  # specified date and time elements and then subtracted the current time
  # again to get the duration. This produces inconsistent results since
  # actual months and years can vary in length.
  # In short, without this fix, the following expression wouldn't necessarily be true:
  #   2.months == ActiveSupport::Duration.parse(2.months)
  def self.parse(iso8601duration)
    parts = ISO8601Parser.new(iso8601duration).parse!
    total_seconds = 0
    parts.each do |part, value|
      total_seconds += value.send part.to_sym
    end
    new(total_seconds, parts)
  end

  # Patch rails to treat zero durations
  # This bug was fixed in the following commit, but is still not part of Rails 5.0
  # https://github.com/rails/rails/commit/629dde297ce5e4b7614fbb0218f2593effaf7e28
  class ISO8601Serializer
    def serialize
      parts, sign = normalize
      return 'PT0S'.freeze if parts.empty?

      output = 'P'
      output << "#{parts[:years]}Y"   if parts.key?(:years)
      output << "#{parts[:months]}M"  if parts.key?(:months)
      output << "#{parts[:weeks]}W"   if parts.key?(:weeks)
      output << "#{parts[:days]}D"    if parts.key?(:days)
      time = ''
      time << "#{parts[:hours]}H"     if parts.key?(:hours)
      time << "#{parts[:minutes]}M"   if parts.key?(:minutes)
      if parts.key?(:seconds)
        time << "#{sprintf(@precision ? "%0.0#{@precision}f" : '%g', parts[:seconds])}S"
      end
      output << "T#{time}"  if time.present?
      "#{sign}#{output}"
    end
  end
end
