require 'matrix'
require 'gosu' # gem install gosu --no-document
include Gosu


$dimension = 400
$TILE_WIDTH = 64
$TILE_HEIGHT = 32
$size = $dimension / $TILE_WIDTH + 1

def put_wobbly_block(x, y, color=Color::WHITE)
  c = color
  top_color = c
  left_color = Color.from_hsv(c.hue, c.saturation, c.value*0.8)
  right_color = Color.from_hsv(c.hue, c.saturation, c.value*0.5) 

  y += rand(-2..2)
  w = $TILE_WIDTH
  h = $TILE_HEIGHT
  hw = w/2
  hh = h/2
  v1 = [x, y+hh, top_color]
  v2 = [x+hw, y+h, top_color]
  v3 = [x+w, y+hh, top_color]
  v4 = [x+hw, y, top_color]
  draw_quad(*v1, *v2, *v3, *v4)

  v1 = [x, y+hh, left_color]
  v2 = [x+hw, y+h, left_color]
  v5 = [x, y+hh+h, left_color]
  v6 = [x+hw, y+h+h, left_color]
  draw_quad(*v1, *v5, *v6, *v2)
  
  v3 = [x+w, y+hh, right_color]
  v2 = [x+hw, y+h, right_color]
  v6 = [x+hw, y+h+h, right_color]
  v7 = [x+w, y+hh+h, right_color]
  draw_quad(*v2, *v6, *v7, *v3)
end

def create_map size
  map = Matrix.build(4*size, size) do
    Color.new(255, rand(255), rand(255), rand(255))
  end
  return map
end

def draw_map map
  map.each_with_index do |e, i, j|
      x = j * $TILE_WIDTH
      y = i * $TILE_HEIGHT/2
      if i.odd?
        x += $TILE_WIDTH/2
      end
      put_wobbly_block(x, y, e)
  end
end



class GameWindow < Window
  def initialize
    super $dimension, $dimension, false, 100
    self.caption = "Game"
    # instantiate actors
    @map = create_map($size)
  end
  def button_down(key) 
    puts key if [KbDown,KbUp,KbRight,KbLeft].include? key
  end
  
  def update() 
  
  end
  
  def draw() 
    draw_map @map
    #put_wobbly_block(10,10)
  end
end

GameWindow.new.show