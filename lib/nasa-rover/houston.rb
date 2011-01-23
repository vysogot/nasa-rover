class Houston

  #
  # controls the mission of the NASA rovers
  #

  def initialize(input)
    @orders = OrdersReader.new(input)

    # read planet's dimensions
    x, y = @orders.get_planet
    @planet = Planet.new(x.to_i, y.to_i)

    # rovers on the mission
    @rovers = []

    # report of the mission
    @report = ""
  end

  # using the orders reader iterates through a collection of rovers
  # and sends them signals from the list checking if rovers are not
  # out of the planet
  def start_the_mission!
    until @orders.eof? do
      x, y, face, signals = @orders.next_rover_data
      @rovers << rover = Rover.new(x, y, face)

      if out_of_planet?(rover)
        mission_failed(rover, "it missed the planet")
        next 
      end

      signals.each do |signal|
        rover.receive_signal(signal)
        if out_of_planet?(rover)
          mission_failed(rover, "it fell of the planet")
          break
        end
      end        
    end
  end

  # creates ad-hoc mission report by collecting 
  # current positions of rovers on the planet
  def mission_report
    @rovers.each {|rover| @report << rover.position.join(' ') << "\n"} if @report.empty?
    return @report
  end

  private

  # checks if the rover is not out of the planet
  def out_of_planet?(rover)
    (rover.x > @planet.x || rover.x < 0 ||
     rover.y > @planet.y || rover.y < 0)
  end

  # adds a failure of an mission to the mission report
  def mission_failed(rover, reason)
    @report += "Mission of Rover-#{@rovers.index(rover)} on #{@planet.name} failed: #{reason}"
  end

end
