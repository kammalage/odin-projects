module Hangman
	class Player
		attr_accessor :name

		def initialize(name)
			@name = name
		end
	end

	class Game
		attr_accessor :dictionary, :player, :guess_word

		def initialize(player)
			@player = player
			load_dictionary
		end

		def load_dictionary
			@dictionary = File.open("test.txt", "r").read.split
		end

		def pick_word
			words = @dictionary.select { |word| word.length.between?(5,12)}
			@guess_word = words.sample
		end


	end
end
player_one = Hangman::Player.new("Shan")
game = Hangman::Game.new(player_one)
