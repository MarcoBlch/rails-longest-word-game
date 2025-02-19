
require 'dictionary'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(9)
    @start_time = Time.now.to_i
  end

  def score
    @word = params[:word]
    @letters = params[:letters].to_s.upcase.split
    @start_time = Time.at(params[:start_time].to_i)
    @end_time = Time.now

    if @word.nil? || @letters.empty?
      @result = "An error occurred. Please try again."
    elsif !word_in_grid?(@word, @letters)
      @result = "Sorry, #{@word.upcase} can't be built out of #{@letters.join(', ')}"
    elsif !valid_english_word?(@word)
      @result = "Sorry, #{@word.upcase} is not a valid English word"
    else
      @score = calculate_score(@word, @start_time, @end_time)
      @result = "Congratulations! #{@word.upcase} is a valid English word. Your score: #{@score}"
    end
  end



  private

  def generate_grid(num)
    alphabet = ('A'..'Z').to_a
    Array.new(num) { alphabet.sample }
  end

  def word_in_grid?(word, grid)
    word.upcase.chars.all? do |letter|
      word.upcase.count(letter) <= grid.count(letter)
    end
  end

  def valid_english_word?(word)
    dictionary = Dictionary.from_file('/usr/share/dict/words')
    dictionary.exists?(word.downcase)
  end

  def calculate_score(word, start_time, end_time)
    time_taken = end_time - start_time
    base_score = word.length * 10
    time_penalty = (time_taken / 2).to_i
    [base_score - time_penalty, 0].max
  end
end
