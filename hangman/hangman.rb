module Hangman
	class Player
		attr_accessor :name

		def initialize(name)
			@name = name
		end
	end

	class Game
		attr_accessor :dictionary, :player, :guess_word, :attempts, :used_letters

		def initialize(player)
			@player = player
			@used_letters = []
			@attempts = Array.new(6,"*");
			load_dictionary
			pick_word
			set_guess_area
		end

		def load_dictionary
			@dictionary = File.open("test.txt", "r").read.split
		end

		def pick_word
			words = @dictionary.select { |word| word.length.between?(5,12)}
			@guess_word = words.sample.upcase
		end

		def print_tab
			print "\t"
		end

		def print_board
			puts "==================================="
			print_tab
			puts "ATTEMPTS LEFT"
			puts ""
			print_attempts
			puts ""
			print_tab
			puts "LETTERS USED"
			puts ""
			print_used_letters
			puts ""
			print_tab
			puts "GUESS THE WORD"
			puts ""
			print_guess_area
			puts ""
			puts "==================================="



		end

		def print_attempts
			print_tab
			@attempts.each { |attempt| print "#{attempt} "}
			puts ""
		end

		def remove_attempt
			@attempts.pop
		end

		def print_used_letters
			print_tab
			@used_letters.each do |letter|
				if letter.nil?
					print ""
				else
					print "#{letter} "
				end
			end
		end

		def check_input(guess)
			if guess.upcase! == @guess_word
				puts "YOU WON!"
			else
				letter = guess
				if check_bounds(letter) and match_input(letter)
					puts "Correct input"
					puts "#{letter}"
					compare_letter(letter)
				else
					puts "Incorrect input, try again."
					puts "#{letter}"
				end	
			end
		end

		def match_input(letter)
			letter.match(/[a-zA-Z]{1}/) ? true : false		
		end

		def check_bounds(letter)
			if letter.length == 1
				return true
			else
				return false
			end
		end

		def compare_letter(letter)
			guess_letters = @guess_word.split("")
			if guess_letters.include?(letter)
				#do something
				guess_letters.each_with_index do |correct_letter, index|
					if correct_letter == letter
						@guess_area[index] = letter
					end
				end
				add_used_letter(letter)
			else
				# do something else
				add_used_letter(letter)
				remove_attempt
			end
		end

		def add_used_letter(letter)
			unless @used_letters.include?(letter)
				@used_letters << letter
			end
		end

		def set_guess_area
			@guess_area = Array.new(@guess_word.length,"_")
		end

		def print_guess_area
			print_tab
			@guess_area.each { |letter| print "#{letter} "}
			puts ""
		end

		def play
			puts ""
			puts " Welcome to Hangman! Try to guess the word correctly, but you only get six tries!"
			puts " To enter a guess just enter a single letter."
			print_tab
			puts ""
			puts " Good Luck!"
			puts ""

			while true
			print_board
			print "Enter guess: "
			guess = gets.chomp
			check_input(guess)
			end
		end


	end
end
player_one = Hangman::Player.new("Shan")
game = Hangman::Game.new(player_one)
game.play
