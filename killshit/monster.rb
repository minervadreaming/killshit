module KillShit
	class Monster < Player

		def self.describe(monster)
			description = "\t \tEnemy: #{monster.name} \(Lvl #{monster.level}\) \:\: #{monster.hp} HP"

			puts description
		end
	end
end

