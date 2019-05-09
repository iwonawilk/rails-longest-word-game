require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'...'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters].split(' ')
    @user_word = params[:word]
    @check = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@user_word}").read)
    if @check['found']
      if check_grid(@letters, @user_word)
        return @score = "Congratulations, your score is #{@check['length'].to_i} points."
      else
        @score = 'Sorry, this is not in the grid.'
      end
    else
      return @score = 'Sorry, this is not an english word.'
    end
  end

  private

  def check_grid(letters, user_word)
    attempt_letters = user_word.upcase.split('')
    attempt_letters.each do |letter|
      i = letters.index(letter)
      if i.nil?
        return false
      else
        letters.delete_at(i)
      end
    end
    return true
  end
end
