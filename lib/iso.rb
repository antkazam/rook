require 'matrix'
require 'gosu'
include Gosu

module Iso
  W = 64.0
  H = 32.0

  class View
    attr_accessor :t0, :t1
    #attr_accessor :bitmap
    attr_accessor :window

    def initialize(window, xorg=400, yorg=-50)
      # set the initial position of top of isometric tile 0,0
      @t0 = xorg
      @t1 = yorg
      @window = window
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
      left_color = Color.from_hsv(c.hue, c.saturation, c.value*0.6)
      right_color = Color.from_hsv(c.hue, c.saturation, c.value*0.3)

      y += rand(-2..2)
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

    def hidden(sx, sy)
      (sx < -W) or (sx >= @window.width) or (sy < -H) or (sy >= @window.height)
    end

    def draw(matrix)
      #count = 0
      matrix.each_with_index do |color, i, j|
        next if color.nil?
        sx, sy = tile_origin(i, j)
        put_wobbly_block(sx, sy, color) unless hidden(sx, sy)
        #count += 1 unless hidden(sx, sy)
      end
      #puts "Tiles on screen: #{count}"
    end
  end

  class Map
    attr_accessor :map

    def initialize(rows=10, cols=10, &setup)
      @map = Matrix.build(cols, rows, &setup)
    end

    def pad_for_screen


    end
  end
end
