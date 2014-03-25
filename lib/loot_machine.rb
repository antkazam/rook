require 'loot'

class LootMachine
  attr_reader :random
  attr_reader :tcs, :armors, :prefixes, :suffixes

  def initialize(seed=0)
    @random = Random.new(seed)
    initialize_tcs
    initialize_armors
    initialize_prefixes
    initialize_suffixes
  end

  def initialize_tcs
    @tcs = []
    data = CSV.read('data/TreasureClassEx.txt', { :col_sep => "\t" })
    columns = data.shift.map { |col| col.downcase.gsub(' ', '_').to_sym }
    data.each do |row|
      tc = {}
      columns.each_with_index do |col, i|
        tc[col] = row.at(i)
      end
      @tcs << tc
    end
    puts "Loaded #{@tcs.length} TCs."
  end

  def initialize_armors
    @armors = []
    data = CSV.read('data/armor.txt', { :col_sep => "\t" })
    columns = data.shift.map { |col| col.downcase.gsub(' ', '_').to_sym }
    data.each do |row|
      armor = {}
      columns.each_with_index do |col, i|
        armor[col] = row.at(i)
      end
      @armors << armor
    end
    puts "Loaded #{@armors.length} types of armor."
  end

  def initialize_prefixes
    @prefixes = []
    data = CSV.read('data/MagicPrefix.txt', { :col_sep => "\t" })
    entries = data.shift.first.to_i
    columns = data.shift.map { |col| col.downcase.gsub(' ', '_').to_sym }
    data.each do |row|
      prefix = {}
      columns.each_with_index do |col, i|
        prefix[col] = row.at(i)
      end
      @prefixes << prefix
    end
    puts "Loaded #{@prefixes.length} prefixes."
    puts "Warning: expected to load #{entries}" unless entries == @prefixes.length
  end

  def initialize_suffixes
    @suffixes = []
    data = CSV.read('data/MagicSuffix.txt', { :col_sep => "\t" })
    entries = data.shift.first.to_i
    columns = data.shift.map { |col| col.downcase.gsub(' ', '_').to_sym }
    data.each do |row|
      suffix = {}
      columns.each_with_index do |col, i|
        suffix[col] = row.at(i)
      end
      @suffixes << suffix
    end
    puts "Loaded #{@suffixes.length} suffixes."
    puts "Warning: expected to load #{entries}" unless entries == @suffixes.length
  end

  def is_tc? pick
    string = pick.kind_of?(Array) ? pick.first : pick.to_s
    string[0..2].include? 'tc:'
  end

  def look_up_tc string
    result = @tcs.detect { |tc| tc[:treasure_class] == string }
    pick = [result[:item1], result[:item2], result[:item3]].sample
    return is_tc?(pick) ? look_up_tc(pick) : pick
  end

  def give_loot(tc)
    name = look_up_tc(tc)
    ac = get_ac_of(name)
    prefix = generate_prefix if @random.rand(1) == 0
    suffix = generate_suffix if @random.rand(1) == 0
    return Loot.new(name, ac, prefix, suffix)
  end

  def get_ac_of armor_name
    ar = @armors.detect { |armor| armor[:name] == armor_name }
    min = ar[:minac].to_i
    max = ar[:maxac].to_i
    @random.rand(max - min) + min
  end

  def generate_prefix
    affix = @prefixes.sample
    min = affix[:mod1min].to_i
    max = affix[:mod1max].to_i
    affix[:mod1value] = max-min == 0 ? min : @random.rand(max - min) + min
    affix
  end

  def generate_suffix
    affix = @suffixes.sample
    min = affix[:mod1min].to_i
    max = affix[:mod1max].to_i
    affix[:mod1value] = max-min == 0 ? min : @random.rand(max - min) + min
    affix
  end
end