# require 'matrix'

module Notch
  class Bitmap
    attr_accessor :width, :height, :pixels

    def initialize(width, height)
      @width = width
      @height = height
      @pixels = Array.new(width*height)
    end

    def draw(bitmap, x_off=0, y_off=0)
      0.upto(bitmap.height-1) do |y|
        y_pix = y + y_off
        next unless (y_pix >= 0 or y_pix < @height)

        0.upto(bitmap.width-1) do |x|
          x_pix = x + x_off
          next unless (x_pix >= 0 or x_pix < @width)

          src = bitmap.pixels[x + y * bitmap.width]
          @pixels[x_pix + y_pix * @width] = src
        end
      end
    end

    def flip_draw(bitmap, x_off=0, y_off=0)
      0.upto(bitmap.height-1) do |y|
        y_pix = y + y_off
        next unless (y_pix >= 0 or y_pix < @height)

        0.upto(bitmap.width-1) do |x|
          x_pix = x + x_off + bitmap.width - x - 1 #the flip
          next unless (x_pix >= 0 or x_pix < @width)

          src = bitmap.pixels[x + y * bitmap.width]
          @pixels[x_pix + y_pix * @width] = src
        end
      end
    end

    def scale_draw(bitmap, scale, x_off, y_off, xo, yo, w, h, col)
      0.upto(h * scale - 1) do |y|
        y_pix = y + y_off
        next unless (y_pix >= 0 or y_pix < @height)

        0.upto(w * scale - 1) do |x|
          x_pix = x + x_off
          next unless (x_pix >= 0 or x_pix < @width)

          src = bitmap.pixels[(x / scale + xo) + (y / scale + yo) * bitmap.width]
          if src >= 0
            @pixels[x_pix + y_pix * @width] = src * col
          end
        end
      end
    end

    def fill(x0, y0, x1, y1, color)
      y0.upto(y1-1) do |y|
        x0.upto(x1-1) do |x|
          pixels[x + y * @width] = color
        end
      end
    end
  end


  class Bitmap3D < Bitmap
    attr_reader :z_buffer, :z_buffer_wall
    attr_reader :x_cam, :y_cam, :z_cam
    attr_reader :rcos, :rsin, :fov, :x_center, :y_center, :rot

    def initialize(width, height)
      super(width, height)

      @z_buffer = Array.new(width*height)
      @z_buffer_wall = Array.new(width)
    end

    def render(t)
      0.upto(@width-1) do |x|
        @z_buffer_wall[x] = 0.0
      end
      0.upto(@width*@height-1) do |i|
        @z_buffer[i] = 10000.0
      end

      #player stuff in Java
      #rot = game.player.rot;
      @rot = t*0.1
      #xCam = game.player.x - Math.sin(rot) * 0.3;
      @x_cam = -Math.sin(@rot) * 0.3
      #yCam = game.player.z - Math.cos(rot) * 0.3;
      @y_cam = -Math.cos(@rot) * 0.3
      #zCam = -0.2 + Math.sin(game.player.bobPhase * 0.4) * 0.01 * game.player.bob - game.player.y;
      @z_cam = 0.8
      #end player stuff

      @x_center = @width / 2.0
      @y_center = @height / 3.0

      @rcos = Math.cos(@rot)
      @rsin = Math.sin(@rot)

      @fov = @height

      r = 6

      render_floor
    end

    def render_floor
      0.upto(@height-1) do |y|
        yd = ((y + 0.5) - @y_center) / @fov

        floor = true
        zd = (12 - @z_cam * 8) / yd
        if yd < 0
          floor = false
          zd = (4 + @z_cam * 8) / -yd
        end

        0.upto(@width-1) do |x|
          next if (@z_buffer[x + y * @width] <= zd)

          xd = (@x_center - x) / @fov
          xd *= zd

          xx = xd * @rcos + zd * @rsin + (@x_cam + 0.5) * 8
          yy = zd * @rcos - xd * @rsin + (@y_cam + 0.5) * 8

          x_pix = (xx * 2).to_i
          y_pix = (yy * 2).to_i
          x_tile = x_pix >> 4
          y_tile = y_pix >> 4

          #col = block.floor_col
          #tex = block.floor_tex
          if not floor
            #col = block.ceil_col
            #tex = block.ceil_tex
          end
          @tex = 1
          if (@tex < 0)
            @z_buffer[x + y * @width] = -1
          else
            @z_buffer[x + y * @width] = zd
            #puts "#{xx} and #{yy}"
            r = ((x_pix/16) % 128).to_i
            g = ((x_pix/16) % 255).to_i
            b = ((x_pix*64) % 255).to_i

            @pixels[x + y * @width] = r << 16 | g << 8 | b
          end
          #@pixels[x + y * @width] = xx*2+yy*128*256
        end
      end
    end
  end


  class Screen < Bitmap
    $PANEL_HEIGHT = 16

    attr_reader :viewport, :panel

    attr_accessor :time, :test_bitmap

    def initialize(width, height)
      super(width, height)

      @viewport = Bitmap3D.new(width, height - $PANEL_HEIGHT)
      @panel = Bitmap.new(width, $PANEL_HEIGHT)

      random = Random.new()
      @test_bitmap = Bitmap.new(64, 64)
      0.upto(64*64-1) do |i|
        @test_bitmap.pixels[i] = random.rand() * (random.rand(5) / 4)
      end

      0.upto($PANEL_HEIGHT-1) do |y|
        color = random.rand(255*255)
        0.upto(width-1) do |x|
          @panel.pixels[x + y * width] = color
        end
      end

      @time = 0
    end

    def render(t)
      @viewport.render(t)
      draw(@viewport)
      #draw(@panel, 0, @height-$PANEL_HEIGHT)
    end
  end
end