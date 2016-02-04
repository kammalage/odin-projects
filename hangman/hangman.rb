require 'yaml'

module Hangman
	class Player
		attr_accessor :name

		def initialize(name)
			@name = name
		end
	end

	class Game
		attr_accessor :dictionary, :player, :guess_word, :attempts, :used_letters,:max_attempts, :guess_area

		def initialize(player)
			@player = player
			@used_letters = []
			@max_attempts = 10
			@attempts = Array.new(10,"*");
			load_dictionary
			pick_word
			set_guess_area
		end

		def load_dictionary
			@dictionary = File.open("5desk.txt", "r").read.split
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
			guess
			check_win(guess)
			
			letter = guess
			if check_bounds(letter) and match_input(letter)
				puts "You entered #{letter}"
				compare_letter(letter)
			elsif guess == "SAVE_GAME"
				save_game
			elsif guess == "LOAD_GAME"
				load_game
			else
				puts "Incorrect input, try again."
				puts "You entered #{letter}"
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
				guess_letters.each_with_index do |correct_letter, index|
					if correct_letter == letter
						@guess_area[index] = letter
					end
				end
				add_used_letter(letter)
			else
				unless @used_letters.include?(letter)
					add_used_letter(letter)
					remove_attempt
				else
					puts "You already entered that. Try again."
				end
			end
		end

		def check_win(full_guess = nil)
			unless full_guess.nil?
				if full_guess == @guess_word
					puts "YOU WIN!"
					puts "It was #{@guess_word}."
					exit
				end
			else 
				if @guess_area.join("") == @guess_word
					puts "YOU WIN!"
					puts "It was #{@guess_word}."
					exit
				elsif @attempts.empty?
					puts "YOU LOSE!"
					puts "The correct answer is #{@guess_word}."
					exit
				end
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

		def display_rules
			puts " To enter a guess just enter a single letter."
			puts " If you know the answer type in the complete word."
			puts " To save your game enter 'save_game'."
			puts " To load your game enter 'load_game'."
		end

		def save_game
			puts "Saving..."
			yaml = YAML::dump(self)
			File.open("saves/#{@player.name}_save.yaml","w") { |f| f.write(yaml)}
			puts "Saved"
		end

		def load_game
			puts "Loading..."
			save_file = File.open("saves/#{@player.name}_save.yaml","r")
			yaml = save_file.read
			loaded_game = YAML::load(yaml)
			load_elements(loaded_game)
		end

		def load_elements(loaded_game)
			@guess_word = loaded_game.guess_word
			@player = loaded_game.player
			@guess_area = loaded_game.guess_area
			@attempts = loaded_game.attempts
			@used_letters = loaded_game.used_letters
			@max_attempts = loaded_game.max_attempts
		end


		def play
			puts ""
			puts " Welcome to Hangman! Try to guess the word correctly, but you only get #{@max_attempts} tries!"
			display_rules
			print_tab
			puts ""
			puts " Good Luck!"
			puts ""

			while true
			print_board
			print "Enter guess: "
			guess = gets.chomp.upcase
			check_input(guess)
			check_win
			end
		end
	end
end
player_one = Hangman::Player.new("Shan")
game = Hangman::Game.new(player_one)
game.play
