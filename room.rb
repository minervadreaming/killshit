require_relative 'game'
require_relative 'spells'
require_relative 'player'
require_relative 'monster'

module KillShit
	class Room
		attr_reader :player, :monster, :game

		def initialize(player, monster, game)
			@player = player
			@monster = monster
			@game = game
		end

		def vs
			puts "\t \t \t \tvs"
		end

		def prompt
			print "> "
		end

		def self.outline
			puts "**********************************************************************"
		end

		def outline
			puts "**********************************************************************"
		end

		def start
			action
		end

		#Generating initial monster and sending user to action choices.
		def self.load_monster(player, game)

			outline
			puts "\n#{player.name} takes a breath, looks around the arena, and prepares for battle.\n \n"
	
			monster_type = rand(1..2)

			if monster_type == 1
				monster = Monster.new("Griffin", rand(10..30), 0, 0, 0, (player.level + rand(0..2)), 0, 0, 0, 1, rand(5..30), 0)
				puts "A mighty Griffin swoops down from above!\n"
			else
				monster = Monster.new("Cyclops", rand(20..30), 0, 0, 0, (player.level + rand(0..2)), 0, 0, 0, 3, rand(20..50), 0)
				puts "A huge Cyclops comes crashing into the arena!\n"
			end

			new(player, monster, game)
		end


		#Where the player makes his choices.  Initial if-then checking for Shield status in order to display SP for user
		def action
			outline
			Player.describe(player)
			vs
			Monster.describe(monster)
			outline

			#rolling a d20 to see who takes a turn
			turn = rand(1..100)

			if turn <= 20
				monster_attack
			else
				puts "What would you like to do?"
				puts "1. Attack!"
				puts "2. Defend!"
				puts "3. Run away!"
				#Give the player magic if they're at least level 2
				if player.maglevel >= 1
					puts "4. Cast spell"
				else
				end

				prompt; action = gets.chomp
		
				if action == "1"
					attack(player, monster)
				elsif action == "2"
					defend
				elsif action == "3"
					flee
				elsif action == "4" && player.maglevel >= 1
					magic
				else
					action
				end
			end
		end

		def magic
			puts "What magic would you like to cast?"
			if player.maglevel == 1
				puts "1. Heal"
				puts "2. Fireball"
				puts "3. Tremor"
				prompt; magic = gets.chomp

				if magic == "1"
					Spells.heal(player, monster, game)
				elsif magic == "2"
					Spells.fireball(player, monster)
				elsif magic == "3"
					Spells.tremor(player, monster)
				else
					magic
				end
			elsif player.maglevel == 2
				puts "1. Greater Heal"
				puts "2. Firestorm"
				puts "3. Earthquake"
				prompt; magic = gets.chomp

				if magic == "1"
					Spells.greaterheal(player)
				elsif magic == "2"
					Spells.firestorm(player, monster)
				elsif magic == "3"
					Spells.earthquake(player, monster)
				else
					magic
				end
			else
			end
		end

		#20% chance of monster attacking - this checks for a hit or a miss by the monster
		def monster_attack
			puts "The #{monster.name} attacks #{player.name}!"
			#rolling for success
			mscore = rand(1..20)

			if mscore >= 8
				monster_attack_success
			else
				puts "The #{monster.name} misses with its attack!"
				action
			end
		end

		#The monster was successful in the attack
		def monster_attack_success
			damage = ((rand(1..6) + rand(0..monster.level)) + monster.atkval)

			#Handling damage, taking Shield Points into account
			if player.hp >= 1  && player.shield >= damage
				puts "The #{monster.name} whomps #{player.name} for #{damage} HP, but #{player.name}'s shield absorbs it!"
				player.shield -= damage
			elsif player.hp >= 1 && player.shield >= 1
				puts "The #{monster.name} whomps #{player.name} for #{damage} HP, but #{player.name}'s shield absorbs #{player.shield} damage!"
				player.hp -= (damage - player.shield)
				player.shield = 0
			elsif player.hp >= 1 
				puts "The #{monster.name} whomps #{player.name} for #{damage} HP!"
				player.hp -= damage
			else
				puts "The #{monster.name} slays #{player.name} with a wicked blow!"
				player_death
			end

			if player.hp <= 0
				player_death
			else
				action
			end
		end

		#The user chose to attack, checking for hit or miss
		def attack(player, monster)
			puts "#{player.name} attacks!"
			pscore = rand(1..20)
			if pscore >= 9
				d6(player, monster)
			else
				puts "#{player.name} missed with a wild swing!"
				action
			end
		end

		#The user's attack was successful, now rolling for damage and death of monster
		def d6(player, monster)
			damage = (rand(1..6) + player.atkval)
			crit_hit = rand(1..100)

			#Determine if the player's attack lands a critical hit for a damage modifier of 2x
			if player.level <=9 && crit_hit <= 15
				puts "CRITICAL HIT!"
				damage *= 2
			elsif player.level >=10 && crit_hit <= 20
				puts "CRITICAL HIT!"
				damage *= 2
			else
				damage = damage
			end

			monster.hp -= damage

			if monster.hp >= 1
				puts "#{player.name} slices the #{monster.name} for #{damage} HP!"
				action
			else
				puts "#{player.name} slays the #{monster.name} with a wicked blow!"
				monster_death
			end
		end

		#User chose to defend - checking for max shield value of 5, adding SP if not.  Allows user to go above 5 on addition of SP.
		def defend
			shield_add = rand(1..4)
		#	player.mshield = player.level + 5

			if player.shield >= player.maxshield
				puts "#{player.name} already has maximum defense!"
				action
			elsif (player.shield + shield_add) > player.maxshield
				player.shield = player.maxshield
				puts "#{player.name} now has maximum defense!"
				action			
			else
				player.shield += shield_add
				puts "#{player.name} prepares their defenses!"
				action
			end
		end

		#User chose to flee; small chance of flight.  If they lose roll, monster wins attack.
		def flee
			chance = rand(0..20)

			if chance >= 15
				puts "#{player.name} flees the battle!"
				Game.new(player).start
			else
				puts "Oh no!  The #{monster.name} blocks #{player.name}'s path and attacks!"
				monster_attack
			end
		end

		#User has defeated the monster.  Kill is added to tally, user starts over again.
		def monster_death
			xpgained = (monster.xpval + monster.level)
			puts "The #{monster.name} thrashes about for a bit before gurgling its last breath.  You win!"
			puts "#{player.name} gains #{xpgained} XP!"

			player.kills += 1

			player.xp += xpgained

			Player.level_up(player)
		end
	
		#User has been defeated.  User is shown how many kills they tallied.
		def player_death
			puts "#{player.name} has died at the hands of the mighty #{monster.name}."
			puts "Before dying, #{player.name} slew #{player.kills} foul beasts!"
			exit(0)
		end
	end
end



