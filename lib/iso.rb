
module Iso
  W = 64.0
  H = 32.0
  
  class View
    attr_accessor :t0, :t1
    
    def initialize(xorg=50, yorg=50)
      # set the initial position of top of isometric tile 0,0
      @t0 = xorg
      @t1 = yorg
    end
    
    def move_camera_by(x, y)
      @t0 -= x
      @t1 -= y
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
  end
end
  
#include Iso
view = Iso::View.new(800, 123)