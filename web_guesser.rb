require 'sinatra'
require 'sinatra/reloader'

$SECRET_NUMBER = rand(100)
$correct = false
$bg_color = "white"
$available_guesses = 5

def reinitialize
	$old_number = $SECRET_NUMBER
	$SECRET_NUMBER = rand(100)
	$bg_color = ($correct == true ? "lime" : "white")
	$correct = false
	$available_guesses = 5
end

def check_guess(guess)
	begin
		if guess != nil
			guess = guess.to_i
			if $SECRET_NUMBER == guess
				message = "Correct"
				$correct = true
				$bg_color = "lime"
			elsif $SECRET_NUMBER - guess > 30 && $SECRET_NUMBER - guess < 50
				message = "Too Low"
				$bg_color = "lightcoral"
				$available_guesses -= 1
			elsif $SECRET_NUMBER - guess >= 50
				message = "Way too Low"
				$bg_color = "red"
				$available_guesses -= 1
			elsif guess - $SECRET_NUMBER > 30 && guess - $SECRET_NUMBER < 50
				message = "Too High"
				$bg_color = "lightcoral"
				$available_guesses -= 1
			elsif guess - $SECRET_NUMBER >= 50
				message = "Way too High"
				$bg_color = "red"
				$available_guesses -= 1
			elsif $SECRET_NUMBER - guess <= 30 && $SECRET_NUMBER - guess >= 0
				message = "Increase your guess!"
				$bg_color = "peachpuff"
				$available_guesses -= 1
			else
				message = "Decrease your guess!"
				$bg_color = "peachpuff"
				$available_guesses -= 1
			end
		end
	rescue Exception => ex
		message = ex.to_s
	end

	if $correct
		reinitialize
		message += "! A new number is generated"
	elsif $available_guesses == 0
		reinitialize
		message = "You have lost! A new number is generated"
	end

	return message
end

get '/'  do
	guess = params['guess']
	cheet = params['cheet']
	if cheet != 'true'
		message = check_guess(guess)
	end
	erb :index, :locals => {
							:number => $old_number,
							:message => message, 
							:correct => $bg_color == "lime"? true : false,
							:bg_color => $bg_color,
							:available_guesses => $available_guesses,
							:cheet => cheet,
							:cheet_number => $SECRET_NUMBER
						}
end