require_relative 'room'
require_relative 'player'
require_relative 'monster'

module KillShit
	class Spells
		attr_accessor :player, :monster, :room

	#Checking if user has enough MP to cast spell
		def self.mp_check(req, player)
			req_mp = req
			if player.mp < req_mp
				puts "#{player.name} doesn't have enough MP!"
				action
			else
			end
		end

		def self.heal(player)
			req_mp = 3
			Spells.mp_check(req_mp, player)

			player.mp -= req_mp
			amt = rand(3..10)
			player.hp += amt
			puts "#{player.name} has been healed by #{amt} HP!"
			KillShit::Room.action
		end

		def self.fireball(player, monster)
			req_mp = 5
			Spells.mp_check(req_mp, player)

			player.mp -= req_mp
			dmg = rand(5..10)
			monster.hp -= dmg

			if monster.hp >= 1
				puts "#{player.name}'s fireball burns the #{monster.name} for #{dmg} HP!"
				action			else
				puts "#{player.name} launches a mighty fireball at the #{monster.name}!"
				monster_death
			end
		end

		def self.tremor(player, monster)
			req_mp = 8
			Spells.mp_check(req_mp, player)

			player.mp -= req_mp
			dmg = rand(5..15)
			monster.hp -= dmg

			if monster.hp >= 1
				puts "The ground quakes beneath the #{monster.name}, damaging it for #{dmg} HP!"
				action
			else
				puts "The #{monster.name} is slammed to the ground!"
				monster_death
			end
		end

		def self.greaterheal(player)
			req_mp = 5
			Spells.mp_check(req_mp, player)

			player.mp -= req_mp
			amt = rand(7..15)
			player.hp += amt
			puts "#{player.name} has been healed by #{amt} HP!"
			action
		end

		def self.firestorm(player, monster)
			req_mp = 8
			Spells.mp_check(req_mp, player)

			player.mp -= req_mp
			dmg = rand(7..15)
			monster.hp -= dmg

			if monster.hp >= 1
				puts "#{player.name}'s firestorm scorches the #{monster.name} for #{dmg} HP!"
				action
			else
				puts "#{player.name} brings down a raging storm of fire upon the #{monster.name}!"
				monster_death
			end
		end

		def self.earthquake(player, monster)
			req_mp = 10
			Spells.mp_check(req_mp, player)

			player.mp -= req_mp
			dmg = rand(10..20)
			monster.hp -= dmg

			if monster.hp >= 1
				puts "#{player.name}'s earthquake crushes the #{monster.name} for #{dmg} HP!"
				action
			else
				puts "The ground violently lurches and cracks open beneath the #{monster.name}!"
				monster_death
			end
		end

	end
end