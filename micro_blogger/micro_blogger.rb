require 'jumpstart_auth'
require 'bitly'
require 'klout'

class MicroBlogger
	attr_reader :client, :tweet_length

	def initialize
		puts "Initializing MicroBlogger"
		Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'
		@client = JumpstartAuth.twitter
		@tweet_length = 140
	end

	def klout_score
		friends = @client.friends.collect { |f| @client.user(f).screen_name }
		friends.each do |friend|
			identity = Klout::Identity.find_by_screen_name(friend)
			user = Klout::User.new(identity.id)
			friend_score = user.score.score

			puts "#{friend}"
			puts "#{friend_score}"
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each do |follower|
			screen_names << @client.user(follower).screen_name
		end
		return screen_names
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each { |follower| dm(follower,message) }
	end

	def tweet(message)
		if message.length <= @tweet_length
			@client.update(message)
		else
			puts "Error: Tweet length exceeded, must be limited to 140 characters."
		end
	end

	def dm(target,message)
		puts "Trying to send #{target} this direct message:"
		puts message
		message = "d @#{target} #{message}"

		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		if screen_names.include?(target)
			tweet(message)
		else
			puts "Error: You can only direct message someone following you."
		end
	end

	def everyones_last_tweet

		@client.friends.each do |friend|
			timestamp = @client.user(friend).status.created_at
			puts "#{@client.user(friend).screen_name} said at #{timestamp.strftime("%A, %b %d")}"
			puts "#{@client.user(friend).status.text}"
		end
	end

	def shorten(original_url)
		#Shortening Code
		Bitly.use_api_version_3
		bitly = Bitly.new('hungryacademy','R_430e9f62250186d2612cca76eee2dbc6')
		puts "Shortening this URL: #{original_url}"
		return bitly.shorten(original_url).short_url
	end

	def run
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
				when 'q'  	then puts "Goodbye!"
				when 't'  	then tweet(parts[1..-1].join(" "))
				when 's'    then shorten(parts[1])
				when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
				when 'dm' 	then dm(parts[1],parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'elt'	then everyones_last_tweet
				when 'klout'then klout_score
				else
				puts "Sorry I don't know how to #{command}"
			end 
		end
	end
end

short_tweet = "short tweet test"
just_right_tweet = "".ljust(140, "just right tweet test")
long_tweet = "".ljust(150, "long tweet test")

blogger = MicroBlogger.new
blogger.run

#jumpstart lab pin 6437098