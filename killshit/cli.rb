require_relative 'game'
require_relative 'player'

module KillShit
	class Cli

		attr_reader :game

		def prompt
			print "> "
		end

		def banner
		 '''
 ____  __.___.____    .____        _________ ___ ___ .______________
|    |/ _|   |    |   |    |      /   _____//   |   \|   \__    ___/
|      < |   |    |   |    |      \_____  \/    ~    \   | |    |   
|    |  \|   |    |___|    |___   /        \    Y    /   | |    |   
|____|__ \___|_______ \_______ \ /_______  /\___|_  /|___| |____|   
        \/           \/       \/         \/       \/                
		Kill as many monsters as you can before you die!"


After the collapse of the rebellion and being on the run for months,
you have finally been captured.  You will be sent to the arena to fight
to the death...your death.

How long can you last?

'''
		end

		def start

			print banner

			puts "What is your name, rebel?"
			prompt; pname = gets.chomp

			if pname.length >= 1
				player = Player.new(pname, rand(20..30), 0, 0, 0, 2, 1, 100, 0, rand(1..4), 1, 0)
				Game.new(player).start
			else
				start
			end
		end
	end
end

