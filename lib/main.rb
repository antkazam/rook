require 'gosu' # gem install gosu --no-document
include Gosu


$dimension, $splits = 400, 20
$size = $dimension.to_f / $splits.to_f
$TILE_WIDTH = 32
$TILE_HEIGHT = 16

def put_quad(x, y, color=Color::WHITE)
  w = $TILE_WIDTH
  h = $TILE_HEIGHT
  hw = w/2
  hh = h/2
  v1 = [x, y+hh, color]
  v2 = [x+hw, y+h, color]
  v3 = [x+w, y+hh, color]
  v4 = [x+hw, y, color]
  draw_quad(*v1, *v2, *v3, *v4)
end

def create_map size
  a = Array.new(Array.new(size))
  rnd = Random.new()
  0.upto(a.length-1) do |i|
    0.upto(a.length-1) do |j|
      r = rnd.rand(255)
      g = rnd.rand(255)
      b = rnd.rand(255)
      a[i[j]] = Color.new(255, r, g, b)
    end
  end
  return a
end

def draw_map map
  0.upto(map.length-1) do |i|
      0.upto(map.length-1) do |j|
        x = j * $TILE_WIDTH
        y = i * $TILE_HEIGHT
        if i.odd?
          x += $TILE_WIDTH/2
        end
        color = map[i[j]]
        put_quad(x, y, color)
        #It's not a[i][j], but a[i[j]]
      end
  end
end



class GameWindow < Window
  def initialize
    super $dimension, $dimension, false, 100
    self.caption = "Game"
    # instantiate actors
    @map = create_map(10)
  end
  def button_down(key) 
    puts key if [KbDown,KbUp,KbRight,KbLeft].include? key
  end
  
  def update() 
  
  end
  
  def draw() 

    draw_map @map
    #put_quad(10, 10)
  end
end

GameWindow.new.show