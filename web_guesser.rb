require 'sinatra'
require 'sinatra/reloader'

$SECRET_NUMBER = rand(100)
$correct = false

def check_guess(guess)
	begin
		if guess != nil
			guess = guess.to_i
			if $SECRET_NUMBER == guess
				message = "Correct"
				$correct = true
			elsif $SECRET_NUMBER - guess > 30 && $SECRET_NUMBER - guess < 50
				message = "Too Low"
			elsif $SECRET_NUMBER - guess >= 50
				message = "Way too Low"
			elsif guess - $SECRET_NUMBER > 30 && guess - $SECRET_NUMBER < 50
				message = "Too High"
			elsif guess - $SECRET_NUMBER >= 50
				message = "Way too High"
			elsif $SECRET_NUMBER - guess <= 30 && $SECRET_NUMBER - guess >= 0
				message = "Increase your guess!"
			else
				message = "Decrease your guess!"
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
	erb :index, :locals => {:number => $SECRET_NUMBER, :message => message, :correct => $correct}
end