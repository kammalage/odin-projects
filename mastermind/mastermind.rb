module Mastermind
	class Player
		attr_accessor :name, :ai

		def initialize(name,ai = false)
			@name = name
			@ai = ai
		end
	end

	class Board
		attr_accessor :grid, :colors , :codemaker_row, :code_pegs,:key_pegs,:current_row, :current_position

		def initialize
			construct_board
			construct_code_pegs
			construct_current_row
		end

		def construct_board
			@grid = []
			8.times do
				@grid << Row.new
			end
		end

		def construct_current_row
			@current_position = -1
			@current_row = @grid[@current_position]
		end

		def next_row
			@current_position -= 1
			@current_row = @grid[@current_position]
		end

		def construct_code_pegs
			@code_pegs = [CodePeg.new("RED"),CodePeg.new("BLUE"),CodePeg.new("GREEN"),CodePeg.new("YELLOW"),CodePeg.new("WHITE"),CodePeg.new("BLACK")]
		end

		def construct_key_pegs
			@key_pegs = { 
				:wrong_spot => KeyPeg.new("@"), 
				:correct => KeyPeg.new("*")
			}
		end

		def display_board
			dash_line = "-" * 40
			puts ""
			puts dash_line
			@grid.each do |row|

				puts "#{row.key_row[0].value} #{row.key_row[1].value}\t "\
				"#{row.code_row[0].value}\t#{row.code_row[1].value}\t#{row.code_row[2].value}\t#{row.code_row[3].value}"\
				"\n#{row.key_row[2].value} #{row.key_row[3].value}"
				puts dash_line
			end
			puts "\t 1\t2\t3\t4"
			puts ""
			display_code_pegs
			puts ""
		end

		def display_code_pegs
			puts "    #{@code_pegs[0].value} #{@code_pegs[1].value} #{@code_pegs[2].value} #{@code_pegs[3].value} #{@code_pegs[4].value} #{@code_pegs[5].value}"
		end

		def construct_codemaker_row
			colors = []
			4.times do
				colors << random_color
			end
			@codemaker_row  = Row.new(colors)
		end

		def random_color
			return @code_pegs.sample.value
		end

		def mark_board(color,position)
			color.upcase!
			position -= 1
			if check_bounds(color,position) and slot_empty?(position)
				@current_row.code_row[position].value = color
			else
				puts "ERROR: OUT OF BOUNDS/SLOT FULL"
			end

			if current_row_full?
				puts "CURRENT ROW FULL"
				next_row
			end
		end

		def current_row_full?
			@current_row.code_row.each do |slot|
				return false if slot.value == "O"
			end
			return true
		end

		def slot_empty?(position)
			if @current_row.code_row[position].value == "O"
				return true
			else
				return false
			end
		end

		def check_bounds(color,position)
			return true if check_color_bounds(color) and check_row_bounds(position)
		end

		def check_row_bounds(position)
			return true if position >= 0 and position < 5
		end

		def check_color_bounds(color)
			return true if code_pegs_include?(color)
		end

		def code_pegs_include?(color)
			@code_pegs.each do |code_peg|
				return true if code_peg.value == color
			end
			return false
		end
	end

	class Row
		attr_accessor :code_row, :key_row

		def initialize(colors = nil)
			@code_row, @key_row = [], []
			if colors.nil?
				4.times do
					@code_row << CodeSlot.new
					@key_row << KeySlot.new
				end
			else
				colors.each do |color|
					@code_row << CodeSlot.new(color)
					@key_row << KeySlot.new
				end
			end
		end

		def display_row
			@code_row.each { |slot| print "#{slot.value} " }
		end
	end

	class Slot
		attr_accessor :value

		def initialize(value = "O")
			@value = value
		end
	end

	class KeySlot < Slot
		def initialize(value = "o")
			super(value)
		end
	end

	class CodeSlot < Slot
		def initialize(value = "O")
			super(value)
		end
	end

	class Peg
		def initialize(value)
			@value = value
		end
	end

	class KeyPeg < Peg
		attr_accessor :value

		def initialize(value)
			super(value)
		end
	end

	class CodePeg < Peg
		attr_accessor :value

		def initialize(value)
			super(value)
		end
	end

	class Game
		attr_accessor :codebreaker, :codemaker

		def initialize(players, board = Board.new)
			@players = players
			@board = board
			players.each do |player|
				@codemaker = player if player.ai
				@codebreaker = player unless player.ai
			end
			@board.construct_codemaker_row if @codemaker.ai
		end

		def play
			puts ""
			puts "\tWelcome to Mastermind!"
			puts "\t----------------------"
			puts "\tCurrent player: #{@codebreaker.name}"
			puts ""

			while true
				puts "\t#{@codebreaker.name} enter a color and position"
				@board.display_board
				@board.current_row.display_row

				color = gets.chomp
				position = gets.chomp.to_i
				@board.mark_board(color,position)
				puts "color: " + color + "position: " + position.to_s 
				puts ""
				@board.current_row_full?
			end

		end
	end
end

player_one = Mastermind::Player.new("Player 1")
computer = Mastermind::Player.new("Computer",true)
players = [player_one,computer]
game = Mastermind::Game.new(players)
game.play
	