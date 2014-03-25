class Loot
  attr_reader :text, :ac, :prefix, :suffix
  def initialize(name, ac, prefix=nil, suffix=nil)
    @text = "#{name}"
    @text = "#{prefix[:name]} " + @text if prefix
    @text = @text + " #{suffix[:name]}" if suffix
    @prefix = prefix
    @suffix = suffix
    @ac = ac
    @modifiers = []
    @modifiers << {:name => prefix[:name],
                   :mod => prefix[:mod1code],
                   :amount => prefix[:mod1value]} if prefix
    @modifiers << {:name => suffix[:name],
                   :mod => suffix[:mod1code],
                   :amount => suffix[:mod1value]} if suffix
  end

  def to_s
    #puts "#{@text}"
    #puts "#{@ac} Armor rating"
    @modifiers.each do |mod|
      #puts "+#{mod[:amount]} to #{mod[:mod]}".gsub('_',' ')
    end
    @text.gsub('_', ' ')
  end
end
