class Player
	attr_reader :marker, :name

	def initialize(marker,name)
		@marker = marker
		@name = name
	end

end

class TicTacToe
	attr_reader :current_player

	def initialize(players)
		@player_one = players[0]
		@player_two = players[1]
		@current_player = @player_one
		construct_board
	end

	def construct_board
		@board = ["1","2","3",
				  "4","5","6",
				  "7","8","9"]
	end

	def display_board
		puts "\t----------"
		puts "\t#{@board[0]} #{@board[1]} #{@board[2]} \n\t#{@board[3]} #{@board[4]} #{@board[5]} \n\t#{@board[6]} #{@board[7]} #{@board[8]}"
		puts "\t----------"
	end

	def mark_board(position)
		position -= 1
		if check_bounds?(position) and cell_is_free?(position)
			@board[position] = @current_player.marker
			if win_condition?
				puts "\t#{current_player.name} won!"
				menu
			end
		else
			puts "Error: That's not a valid position or cell is already taken so try again"
			change_turn
		end
	end

	def check_bounds?(position)
		if position >= 0 and position < 9
			return true
		else
			return false
		end
	end

	def cell_is_free?(position)
		if @board[position] == @player_one.marker || @board[position] == @player_two.marker
			return false
		else
			return true
		end
	end

	def change_turn
		if @current_player == @player_one
			@current_player = @player_two
		else
			@current_player = @player_one
		end
	end

	def win_condition?
		if check?(0,1,2)
			return true
		elsif check?(3,4,5)
			return true
		elsif check?(6,7,8)
			return true
		elsif check?(0,3,6)
			return true
		elsif check?(1,4,7)
			return true
		elsif check?(2,5,8)
			return true
		elsif check?(0,4,8)
			return true
		elsif check?(6,4,2)
			return true
		else
			return false
		end
			
	end

	def check?(first,second,third)
		current_mark = @current_player.marker
		if @board[first] == current_mark and @board[second] == current_mark and @board[third] == current_mark
			return true
		else 
			return false
		end
	end

	def start
		puts "Welcome to Tic Tac Toe!"
		display_board
		while true
			puts "#{current_player.name}'s turn, enter position to mark"
			input = gets.chomp
			mark_board(input.to_i)
			display_board
			change_turn
		end
	end

	def reset
		construct_board
		start
	end

	def menu
		puts "Would you like to play again? Enter yes or no."
		input = gets.downcase.chomp
		if "yes"
			reset
		else 
		end
	end
end
    
player_one = Player.new("X","Player 1")
player_two = Player.new("O","Player 2")
players = [player_one,player_two]
game = TicTacToe.new(players)
game.start
