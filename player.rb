module KillShit
	class Player
		attr_accessor :name, :hp, :shield, :maxhield, :xp, :level, :maglevel, :mp, :maxmp, :atkval, :xpval, :kills

		def initialize(name, hp, shield, mshield, xp, level, maglevel, mp, maxmp, atkval, xpval, kills)
			@name = name
			@hp = hp
			@shield = shield
			@mshield = mshield
			@xp = xp
			@level = level
			@maglevel = maglevel
			@mp = mp
			@maxmp = maxmp
			@atkval = atkval
			@xpval = xpval
			@kills = kills
		end

		def self.level_up(player)
			mp_add = 20
			hp_add = 15 + rand(0..player.level)

			if player.xp >= 100 && player.level < 2
				puts "#{player.name} has leveled up!  Spells can now be cast!"

				player.maglevel += 1
				player.level += 1
				player.mp += mp_add
				player.hp += hp_add
				player.xp = 0

				Game.new(player).start
			elsif player.xp >= 100 && player.level == 9
				puts "#{player.name} has leveled up!  Spells have been refined!"

				player.maglevel += 1
				player.level += 1
				player.hp += hp_add
				player.xp = 0

				if (player.mp + mp_add) > player.maxmp
					player.mp = player.maxmp
				else
					player.mp += mp_add
				end

				Game.new(player).start
			elsif player.xp >= 100
				puts "#{player.name} has leveled up!"

				player.level += 1
				player.hp += hp_add
				player.xp = 0

				if (player.mp + mp_add) > player.maxmp
					player.mp = player.maxmp
				else
					player.mp += mp_add
				end

				Game.new(player).start
			else
				Game.new(player).start
			end
		end

		def name
			@name
		end

		def hp
			@hp
		end

		def shield
			@shield
		end

		def maxshield
			@maxshield = @level + 5
		end

		def xp
			@xp
		end

		def level
			@level
		end

		def maglevel
			@maglevel
		end

		def mp
			@mp
		end

		def maxmp
			@maxmp = @level + 35
		end

		def atkval
			@atkval
		end

		def xpval
			@xpval
		end

		def self.describe(player)
			if player.level >= 2
				description = "\tOur Hero: #{player.name} \(Lvl #{player.level}\) \:\: #{player.hp} HP \:\: #{player.mp}\/#{player.maxmp} MP \:\: #{player.shield}\/#{player.maxshield} SP"
				puts description
			else
				description = "\tOur Hero: #{player.name} \(Lvl #{player.level}\) \:\: #{player.hp} HP \:\: #{player.shield}\/#{player.maxshield} SP"
				puts description
			end
		end

	end
end
