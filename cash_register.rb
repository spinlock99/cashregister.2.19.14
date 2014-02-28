class CashRegister
  def initialize(coins=[25, 10, 5, 1])
    @optimal_change = Hash.new do |optimal_change, key|
      if key < coins.min
        optimal_change[key] = Change.new(coins)
      elsif coins.include?(key)
        optimal_change[key] = Change.new(coins).add(key)
      else
        possible_coins = Array.new(coins)
        possible_coins.reject! { |coin| coin > key }
        possible_coins = possible_coins.inject([]) do |coins, smaller_coin|
          coins.any? { |larger_coin| larger_coin % smaller_coin == 0 } ? coins : coins << smaller_coin
        end
        puts "possible coins: #{possible_coins}"

        optimal_change[key] = possible_coins.map do |coin|
          optimal_change[key - coin].add(coin)
        end
        optimal_change[key] = optimal_change[key].reject { |change| change.value != key }
        optimal_change[key] = optimal_change[key].min { |a, b| a.size <=> b.size }
        optimal_change[key] ||= Change.new(coins)
      end
    end
  end

  def make_change(amount)
    raise "Expected Integer got #{amount.class}" if !amount.class.ancestors.include?(Integer)

    return(@optimal_change[amount])
  end
end

class Change < Hash
  def initialize(coins)
    coins.sort.reverse.each do |coin|
      self.merge!({coin.to_s => 0})
    end
  end

  def size
    self.values.reduce(:+)
  end

  def value
    self.collect do |key, value|
      key.to_i * value
    end.reduce(:+)
  end

  def add(coin)
    puts "change: #{self}"
    puts "coin: #{coin}"
    self.merge({coin.to_s => self[coin.to_s] + 1})
  end
end
