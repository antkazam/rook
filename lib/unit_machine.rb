require 'unit'
require 'csv'

class UnitMachine
  attr_reader :random
  attr_reader :units

  def initialize(seed=0)
    @random = Random.new(seed)

    @units = []

    data = CSV.read('data/monstats.txt', { :col_sep => "\t" })
    entries = data[0].first.to_i
    columns = data[1].map { |col| col.downcase.to_sym }
    entries.times do |n|
      unit = {}
      columns.each_with_index do |col, i|
        unit[col] = data[n+2].at(i)
      end
      @units << unit
    end
    puts "Loaded #{units.length} monsters"
    puts "Warning, expected: #{entries}" unless units.length == entries
  end

  def get_tc_from_class name
    unit = @units.detect { |u| u[:class] == name }
    unit[:treasureclass]
  end


  def random_unit(level=nil)
    if level
      @units.select { |u| u[:level] < level }.sample[:class]
    else
      @units.sample[:class]
    end
  end

end