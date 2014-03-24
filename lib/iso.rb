require 'chingu'
require 'matrix'
include Gosu

module Iso
  W = 64.0
  H = 32.0
  
  class View
    attr_accessor :t0, :t1
    #attr_accessor :bitmap
    attr_accessor :window
    
    def initialize(xorg=50, yorg=50)
      # set the initial position of top of isometric tile 0,0
      @t0 = xorg
      @t1 = yorg
      @window = $window
    end
    
    def move_camera_by(x, y, speed=1)
      @t0 -= x * speed
      @t1 -= y * speed
    end
    
    def grid_to_screen_space(gx, gy)
      sx = ( gx - gy ) * W / 2.0 + @t0
      sy = ( gx + gy ) * H / 2.0 + @t1
      return sx, sy
    end
    
    def screen_to_grid_space(sx, sy)
      gx = (sx - @t0) / W + (sy - @t1) / H
      gy = -1.0 * (sx - @t0) / W + (sy - @t1) / H
      return gx, gy
    end
    
    def tile_origin(gx, gy)
      sx, sy = grid_to_screen_space(gx, gy)
      sx -= W / 2
      return sx, sy
    end
    
    def put_wobbly_block(x, y, color=Color::WHITE)
      c = color
      top_color = c
      left_color = Color.from_hsv(c.hue, c.saturation, c.value*0.8)
      right_color = Color.from_hsv(c.hue, c.saturation, c.value*0.5)

      #y += rand(-2..2)
      w = W
      h = H
      hw = w/2
      hh = h/2
      v1 = [x, y+hh, top_color]
      v2 = [x+hw, y+h, top_color]
      v3 = [x+w, y+hh, top_color]
      v4 = [x+hw, y, top_color]
      @window.draw_quad(*v1, *v2, *v3, *v4)

      v1 = [x, y+hh, left_color]
      v2 = [x+hw, y+h, left_color]
      v5 = [x, y+hh+h, left_color]
      v6 = [x+hw, y+h+h, left_color]
      @window.draw_quad(*v1, *v5, *v6, *v2)

      v3 = [x+w, y+hh, right_color]
      v2 = [x+hw, y+h, right_color]
      v6 = [x+hw, y+h+h, right_color]
      v7 = [x+w, y+hh+h, right_color]
      @window.draw_quad(*v2, *v6, *v7, *v3)
    end
    
    def draw(matrix)
      matrix.each_with_index do |e, i, j|
        sx, sy = tile_origin(i, j)
        put_wobbly_block(sx, sy, e)
      end
      
    end
  end
end

$dimension = 400

class GameWindow < Chingu::Window
  def initialize
    super $dimension, $dimension, false, 100
    self.caption = "Game"

    # instantiate actors
    #@map = Iso::Map.new(self, $size)
    @view = Iso::View.new($dimension/2, 10)
    @timer = Chingu::FPSCounter.new
    @font = Font.new(self, Gosu::default_font_name, 20)
    self.input = { 
      :escape => :exit, 
      :holding_left => lambda { @view.move_camera_by(-1, 0) }, 
      :holding_right => lambda { @view.move_camera_by(1, 0) }, 
      :holding_up => lambda { @view.move_camera_by(0, -1) }, 
      :holding_down => lambda { @view.move_camera_by(0, 1) }, 
    }
    @map = Matrix.build(10, 10) do
      Color.new(255, rand(255), rand(255), rand(255))
    end
  end

  def button_down(key) 
    camx = camy = 0
    camy = 1 if key == KbUp
    camy = -1 if key == KbDown
    camx = 1 if key == KbRight
    camx = -1 if key == KbLeft
    # puts "x: #{camx} y: #{camy}"
    @view.move_camera_by(camx, camy)
  end
  
  def update() 
    @timer.register_tick
  end
  
  def draw() 
    @view.draw(@map)
    @font.draw("fps: #{@timer.fps}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end
end

GameWindow.new.show