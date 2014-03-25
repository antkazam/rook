class Screen
  attr_reader :width, :height, :scale
  attr_accessor :layers

  def initialize width, height, scale
    @width = width
    @height = height
    @scale = scale
    @layers = {}
  end

  def add(layer, *args)
    if layer.respond_to? :draw
      @layers[layer] = *args #need to avoid evaluating args here somehow
    else
      raise "Unable to add non-drawable layer"
    end
  end

  def draw
    @layers.each do |layer, args|
      layer.draw(*args)
    end
  end
end