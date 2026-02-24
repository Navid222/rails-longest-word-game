class GamesController < ApplicationController
  VOWELS = %w[A E I O U]

  def new
    @letters = Array.new(5) { VOWELS.sample } +
       Array.new(5) { (("A".."Z").to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word].to_s.strip
    @letters = params[:letters].to_s.split

    @result = compute_result(@word, @letters)
  end


  def compute_result(word, letters)
    up_word = word.upcase

    unless in_grid?(up_word, letters)
      return { message: "The word can't be built out of the grid.", score: 0 }
    end

    unless english_word?(word)
      return { message: "The word is not a valid English word.", score: 0 }
    end

    { message: "Well done! You found a valid word.", score: word.length }
  end

  def in_grid?(up_word, letters)
    word_counts = up_word.chars.tally
    grid_counts = letters.tally
    word_counts.all? { |char, count| grid_counts[char].to_i >= count }
  end

  def english_word?(word)
    return false if word.strip.empty?

    url = "https://dictionary.lewagon.com/#{(word)}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"] == true
  rescue
    false
  end
end
