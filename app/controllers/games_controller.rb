require "open-uri"

class GamesController < ApplicationController
  def new
    grid_size = 9
    alph = ('a'..'z').to_a
    @letters = []
    grid_size.times { @letters << alph.sample }
  end

  def score
    @attempt = params['attempt']
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    @api_response = JSON.parse(open(url).read)
    @score = @attempt.length
    @response =
      if @api_response['found'] == false
        'Sorry. Your word is not an english word!'
      elsif !matching_grid(@attempt, params['letters'])
        'Sorry, your word is not matching the grid!'
      else
        "Your word is alright! Your score is #{@score}"
      end
  end

  def matching_grid(attempt, letters)
    match = true
    letters.downcase!
    attempt.downcase.chars.each do |char|
      match = false if attempt.count(char) > letters.count(char)
    end
    return match
  end
end
