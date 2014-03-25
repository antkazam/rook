require 'gosu'

module Colors
  # Basic ###############################

  TRANSPARENT = Gosu::Color.argb *[0, 0, 0, 0]
  WHITE = Gosu::Color.argb *[255, 255, 255, 255]
  GRAY = Gosu::Color.argb *[255, 128, 128, 128]
  BLACK = Gosu::Color.argb *[255, 0, 0, 0]

  RED = Gosu::Color.argb *[255, 255, 0, 0]
  GREEN = Gosu::Color.argb *[255, 0, 255, 0]
  BLUE = Gosu::Color.argb *[255, 0, 0, 255]

  DARK_RED = Gosu::Color.argb *[255, 128, 0, 0]
  DARK_GREEN = Gosu::Color.argb *[255, 0, 128, 0]
  DARK_BLUE = Gosu::Color.argb *[255, 0, 0, 128]

  DARKER_RED = Gosu::Color.argb *[255, 64, 0, 0]
  DARKER_GREEN = Gosu::Color.argb *[255, 0, 64, 0]
  DARKER_BLUE = Gosu::Color.argb *[255, 0, 0, 64]

  CYAN = Gosu::Color.argb *[255, 0, 255, 255]
  MAGENTA = Gosu::Color.argb *[255, 255, 0, 255]
  YELLOW = Gosu::Color.argb *[255, 255, 255, 0]

  DARK_CYAN = Gosu::Color.argb *[255, 0, 128, 128]
  DARK_MAGENTA = Gosu::Color.argb *[255, 128, 0, 128]
  DARK_YELLOW = Gosu::Color.argb *[255, 128, 128, 0]

  DARKER_CYAN = Gosu::Color.argb *[255, 0, 64, 64]
  DARKER_MAGENTA = Gosu::Color.argb *[255, 64, 0, 64]
  DARKER_YELLOW = Gosu::Color.argb *[255, 64, 64, 0]


  # Complex #############################

  INDIGO = Gosu::Color.argb *[255, 75, 0, 130]
  GOLD = Gosu::Color.argb *[255, 255, 215, 0]
  FOREST_GREEN = Gosu::Color.argb *[255, 34, 139, 34]
  MIDNIGHT_BLUE = Gosu::Color.argb *[255, 25, 25, 112]
  TURQUOISE = Gosu::Color.argb *[255, 64, 224, 208]
  CRIMSON = Gosu::Color.argb *[255, 220, 20, 60]
  ORANGE = Gosu::Color.argb *[255, 255, 165, 0]
  SALMON = Gosu::Color.argb *[255, 255, 160, 122]


  # Aliases #############################

  GREY = GRAY

  MAROON = DARK_RED
  NAVY = DARK_BLUE

  TEAL = DARK_CYAN
  PURPLE = DARK_MAGENTA
  OLIVE = DARK_YELLOW

  # Functions ##########################

end