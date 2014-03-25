$WIDTH = 640
$HEIGHT = 480

class GameWindow < Chingu::Window
  def initialize
    super $WIDTH, $HEIGHT, false, 100
    self.caption = "Such a Game"
    self.input = { :escape => :close }
    @cursor = Gosu::Image.new(self, 'media/cursor2.png')
    @timer = Chingu::FPSCounter.new
    @font = Font.new(self, Gosu::default_font_name, 20)
    @map = Iso::Map.new(20, 10) do
      rand(4) == 1 ? nil :
          rand(2) == 1 ? Color.new(255, rand(255), rand(255), rand(255)) :
              Colors::INDIGO
    end

    @view = Iso::View.new(self)
    @panel = UI::TextPanel.new(self, 0, $HEIGHT-94, $WIDTH, 100, Colors::SALMON)
    @loot_machine = LootMachine.new
    @unit_machine = UnitMachine.new
  end

  def button_down(key)
    monster = @unit_machine.random_unit
    tc = @unit_machine.get_tc_from_class(monster)
    loot = @loot_machine.give_loot(tc)
    @panel.write "Killed #{monster} and found #{loot}"
  end

  def update()
    @timer.register_tick
    #@view.move_camera_by(-3, 0) #rand(-1..1))
  end

  def draw()
    @view.draw(@map.map)
    @font.draw("fps: #{@timer.fps}", 10, 10, 1, 1.0, 1.0, Colors::YELLOW)
    @panel.draw
    #@cursor.draw self.mouse_x - 4, self.mouse_y - 2, 0
  end
end
