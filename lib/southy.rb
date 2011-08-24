module Southy
  VERSION = "0.0.1"

  require 'southy/monkey'
  require 'southy/service'
  require 'southy/config'
  require 'southy/checkin_document'
  require 'southy/flight'

  class CLI
    def initialize
      @monkey = Monkey.new
      @config = Config.new
    end

    def start(params)
      puts "Starting..."
    end

    def stop(params)
      puts "Stopping..."
    end

    def init(params)
      @config.init *params
    end

    def add(params)
      @config.add *params
    end

    def remove(params)
      @config.remove *params
    end
    def list(params)
      @config.list
    end

    def test(params)
      flights = @monkey.lookup 'WQNR57', 'Michael', 'Wynholds'
      flights.each do |f|
        puts f.to_s
      end

      docs = @monkey.checkin flights[0]
      p docs
    end
  end
end
