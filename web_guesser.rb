require 'sinatra'
require 'sinatra/reloader'

$SECRET_NUMBER = rand(100)
$correct = false
$bg_color = "white"

def check_guess(guess)
	begin
		if guess != nil
			guess = guess.to_i
			if $SECRET_NUMBER == guess
				message = "Correct"
				$correct = true
				$bg_color = "'lime'"
			elsif $SECRET_NUMBER - guess > 30 && $SECRET_NUMBER - guess < 50
				message = "Too Low"
				$bg_color = "'lightcoral'"
			elsif $SECRET_NUMBER - guess >= 50
				message = "Way too Low"
				$bg_color = "'red'"
			elsif guess - $SECRET_NUMBER > 30 && guess - $SECRET_NUMBER < 50
				message = "Too High"
				$bg_color = "'lightcoral'"
			elsif guess - $SECRET_NUMBER >= 50
				message = "Way too High"
				$bg_color = "'red'"
			elsif $SECRET_NUMBER - guess <= 30 && $SECRET_NUMBER - guess >= 0
				message = "Increase your guess!"
				$bg_color = "'peachpuff'"
			else
				message = "Decrease your guess!"
				$bg_color = "'peachpuff'"
			end
		end
	rescue Exception => ex
		message = ex.to_s
	end
	return message
end

get '/'  do
	guess = params['guess']
	message = check_guess(guess)
	erb :index, :locals => {:number => $SECRET_NUMBER,
							:message => message, 
							:correct => $correct,
							:bg_color => $bg_color}
end