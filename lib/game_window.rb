require 'chingu'
include Gosu
require_relative 'iso'
require_relative 'blar/screen'

class GameWindow < Chingu::Window
  def initialize
    super 640, 480, false, 100
    self.caption = "Game"
    self.input = { :escape => :close }

    @timer = Chingu::FPSCounter.new
    @font = Font.new(self, Gosu::default_font_name, 20)
    @map = Iso::Map.new(10, 10) do
      rand(4) == 1 ? nil : Color.new(255, rand(255), rand(255), rand(255))
    end

    @view = Iso::View.new(self)
  end

  def button_down(key)
    puts key
  end

  def update()
    @timer.register_tick
    @view.move_camera_by(-3, rand(-1..1))
  end

  def draw()
    @view.draw(@map.map)
    @font.draw("fps: #{@timer.fps}", 10, 10, 1, 1.0, 1.0, 0xffffff00)
  end
end
