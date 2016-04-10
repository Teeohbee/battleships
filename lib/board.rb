require_relative './ship.rb'

class Board
  attr_reader :ships, :recorded_shots

  def initialize
    @ships = {}
    @recorded_shots = {}
  end

  def place_ship(ship, starting_location)
    calculate_ship_location(ship, starting_location)
  end

  def fire(position)
    return "Location already targeted." if recorded_shots.keys.include? position
    if ships.values.flatten.any? { |location| location == position }
      hit_ship = ships.select { |k,v| v.include? position }
      hit_ship.keys[0].gets_got
      @recorded_shots.merge!(position => "H")
      if hit_ship.keys[0].has_sunk?
        ships.delete(hit_ship.keys[0])
        return "You sunk my battleship!"
      end
      return 'HIT!'
    else
      @recorded_shots.merge!(position => "M")
      return 'Miss!'
    end
  end

  def calculate_ship_location(ship, starting_location)
    placement_array = [starting_location]
    location_array = starting_location.scan(/\d+|\D+/)
    letter, number = location_array[0], location_array[1].to_i
    (ship.size - 1).times do
      ship.direction == :H ? number += 1 : letter = letter.next
      placement_array << "#{letter}#{number}"
    end
    check_ship_location_on_board(placement_array)
    check_ship_overlap(placement_array)
    add_ship_details_to_board(ship, placement_array)
  end

  def check_ship_location_on_board(placement_array)
    placement_array.each do |coord|
      if coord[0] > 'J' || coord[1..-1].to_i > 10 || coord[1..-1].to_i < 1
        fail 'Location not on board'
      end
    end
  end

  def check_ship_overlap(placement_array)
    if (ships.values.flatten & placement_array).empty?
      true
    else
      fail 'Overlap'
    end
  end

  def add_ship_details_to_board(ship, placement_array)
    ships.merge!(ship => placement_array)
  end
end
