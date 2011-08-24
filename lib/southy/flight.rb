require 'date'
require 'csv'

class Southy::Flight
  attr_accessor :first_name, :last_name, :number, :depart_date, :confirmation_number, :depart_airport, :arrive_airport

  def self.parse(node)
    flight = Southy::Flight.new
    names = node.find('.passenger_row_name').text.split.map &:capitalize
    flight.first_name = names[0]
    flight.last_name = names[1]

    flight.confirmation_number = node.find('.confirmation_number').text

    leg = node.all('tr.whiteRow')[0]
    leg_pieces = leg.all('.segmentsCell.firstSegmentCell .segmentLegDetails')
    leg_depart = leg_pieces[0]
    leg_arrive = leg_pieces[1]
    
    date = leg.find('.travelTimeCell .departureLongDate').text
    time = leg_depart.find('.segmentTime').text + leg_depart.find('.segmentTimeAMPM').text
    flight.number = leg.all('.flightNumberCell.firstSegmentCell div')[1].text.sub(/^#/, '')
    flight.depart_date = DateTime.parse("#{date} #{time}")
    flight.depart_airport = leg_depart.find('.segmentCityName').text
    flight.arrive_airport = leg_arrive.find('.segmentCityName').text

    flight
  end

  def self.from_csv(line)
    pieces = line.parse_csv
    flight = Southy::Flight.new
    flight.confirmation_number = pieces[0]
    flight.first_name = pieces[1]
    flight.last_name = pieces[2]
    flight.number = pieces[3]
    flight.depart_date = pieces[4]
    flight.depart_airport = pieces[5]
    flight.arrive_airport = pieces[6]
    flight
  end

  def to_csv
    [confirmation_number, first_name, last_name, number, depart_date, depart_airport, arrive_airport].to_csv
  end

  def to_s
    if depart_date
      "SW#{number}: #{first_name} #{last_name}, #{depart_date.strftime('%F %l:%M%P')} #{depart_airport} -> #{arrive_airport} (#{confirmation_number})"
    else
      "#{first_name} #{last_name}, no other info (#{confirmation_number})"
    end

  end
end