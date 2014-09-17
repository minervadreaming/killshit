require_relative 'player'
require_relative 'room'
require_relative 'monster'

module KillShit
	class Game

		attr_reader :player

		def initialize(player) 
			@player = player
		end

		def player
			@player
		end

		def start
			new_room
		end

		def new_room
			Room.new(player, self).load_monster
		end
	end
end
