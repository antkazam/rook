module UI
  class Panel
    attr_accessor :x, :y, :width, :height, :color
    attr_reader :window

    def initialize(window, x, y, width, height, color = Colors::BLACK)
      @window = window
      @x, @y, @width, @height = x, y, width, height
      if color.kind_of? Gosu::Color
        @color = color
      elsif color.kind_of?(Array) && (color.length == 4)
        @color = Gosu::Color.argb(*color)
      else
        @color = Gosu::Color::BLACK
      end
    end

    def p
      3
    end

    def draw
      i, j, c, w, h = x, y, color, width, height
      @window.draw_quad(i, j, c, i+w, j, c, i+w, j+h, c, i, j+h, c)
      i += p
      j += p
      w -= 2*p
      h -= 2*p
      c = Gosu::Color.from_hsv(c.hue, c.saturation, c.value*0.5)
      @window.draw_quad(i, j, c, i+w, j, c, i+w, j+h, c, i, j+h, c)
    end
  end

  class TextPanel < Panel
    attr_accessor :font
    attr_reader :log

    def initialize(window, x, y, width, height, color = Colors::BLACK)
      @log = []
      @font = Font.new(window, Gosu::default_font_name, 20)
      super
    end

    def write(string)
      stack = []
      row = []
      temp = ''

      string.split.each do |word|
        row << "#{word}"
        if @font.text_width(row, 0.55) > (width-2*p)
          temp = row.pop
          stack << row
          row = [temp]
        end
      end
      stack << row
      stack.each do |row|
        string = row.join(' ')
        @log << string if string.kind_of?(String)
        @log.shift() if @log.length + 1 > height / @font.height
      end
    end

    def draw
      super
      @log.each_with_index do |line, i|
        xpos = 2*p + x
        ypos = 2*p + y + @font.height * i
        @font.draw(line, xpos, ypos, 10, 1.0, 1.0, color)
      end
    end
  end

end