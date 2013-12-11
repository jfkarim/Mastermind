class Mastermind

  def initialize
    @colors = ['r', 'g', 'b', 'y', 'o', 'p']
    @human = HumanPlayer.new
    @cpu = ComputerPlayer.new
    @total_turns = 0
    @win_count = 0
    @lose_count = 0
    instructions
  end

  def round
    human_pegs = @human.move(@colors)
    p @cpu.correction(human_pegs)
  end

  def instructions
    puts "#{@human.name}, welcome to Mastermind.  Your goal is to choose the correct sequence of four colored pegs that the computer has chosen.  You only get ten turns."
  end

  def play_again
    puts "Play again? (y/n)"
    ans = gets.chomp.downcase[0]
    play if ans == 'y'
  end

  def play
    new_game

    loop do
      round
      @turn_count += 1

      if win?
        win
        break

      elsif @turn_count == 10
        lose
        break

      end
    end

    @total_turns += @turn_count
    puts "Your record is #{@win_count}-#{@lose_count}.  Average turns per game: #{@total_turns / (@win_count + @lose_count)}."

    play_again
  end

  def new_game
    @cpu.set_cpu_pegs(@colors)
    @turn_count = 0
  end

  def win
    puts "You won in #{@turn_count} turns!"
    @win_count += 1
  end

  def lose
    puts "Told you, loser."
    @lose_count += 1
  end

  def win?
    @human.pegs == @cpu.cpu_pegs
  end

end

class HumanPlayer
  attr_accessor :pegs, :name

  def initialize
    puts "What is your name?"
    @name = gets.chomp
  end

  def move(colors)
    @pegs = []
    while true
      puts "Enter a peg color as such (r, g, b, y, o, p):"
      color = gets.chomp.downcase[0]
      @pegs << color unless !valid?(color, colors)
      break if @pegs.count == 4
    end
    p @pegs
    @pegs
  end

  def valid?(color, colors)
    colors.include?(color)
  end
end

class ComputerPlayer
  attr_accessor :cpu_pegs, :color_hash

  def initialize
  end

  def set_cpu_pegs(colors)
    @cpu_pegs = []

    4.times { @cpu_pegs << colors.sample }
    puts "Get ready to lose."

    @color_hash = {}.tap do |hash|
      @cpu_pegs.each do |peg|
        hash[peg] ||=0
        hash[peg] += 1
      end

    end
  end

  def correction(pegs)
    result = ['','','','']
    temp_hash = @color_hash.dup

    pegs.each_with_index do |peg, index|
      if peg == @cpu_pegs[index]
        result[index] = 'r'
        temp_hash[peg] -= 1
      end
    end

    pegs.each_with_index do |peg, index|
      unless result[index] == 'r'
        if @cpu_pegs.include?(peg) && temp_hash[peg] > 0
          result[index] = "w"
          temp_hash[peg] -= 1
        else
          result[index] = "b"
        end
      end

    end
    result
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Mastermind.new
  game.play
end