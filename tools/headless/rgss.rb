# Headless stand-ins for the parts of RGSS/mkxp-z that draw, play sound or
# read input, so Infinite Fusion's own scripts (map logic, events, battles,
# Frost & Thaw) can run unchanged in plain Ruby. Drawing does nothing; input
# comes from a queue the test driver fills.
$HEADLESS = true
class HeadlessStuck < Exception; end
require_relative "../rgss_stub"     # Table, Color, Tone, RPG data classes

class Rect
  attr_accessor :x, :y, :width, :height
  def initialize(x = 0, y = 0, w = 0, h = 0); @x, @y, @width, @height = x, y, w, h; end
  def set(x, y = 0, w = 0, h = 0)
    if x.is_a?(Rect) then @x, @y, @width, @height = x.x, x.y, x.width, x.height
    else @x, @y, @width, @height = x, y, w, h end
    self
  end
  def empty; set(0, 0, 0, 0); end
  def ==(o); o.is_a?(Rect) && [x, y, width, height] == [o.x, o.y, o.width, o.height]; end
end
class Color
  def set(r, g = 0, b = 0, a = 255)
    if r.is_a?(Color) then @red, @green, @blue, @alpha = r.red, r.green, r.blue, r.alpha
    else @red, @green, @blue, @alpha = r, g, b, a end
    self
  end
  def ==(o); o.is_a?(Color) && [red, green, blue, alpha] == [o.red, o.green, o.blue, o.alpha]; end
end
class Tone
  def set(r, g = 0, b = 0, gr = 0)
    if r.is_a?(Tone) then @red, @green, @blue, @gray = r.red, r.green, r.blue, r.gray
    else @red, @green, @blue, @gray = r, g, b, gr end
    self
  end
end
class Table; def resize(*a); end; end

class Font
  class << self; attr_accessor :default_name, :default_size, :default_bold, :default_italic, :default_color, :default_outline, :default_shadow, :default_out_color; end
  attr_accessor :name, :size, :bold, :italic, :color, :outline, :shadow, :out_color
  def initialize(n = nil, s = 22); @name = n; @size = s; @color = Color.new(255, 255, 255); @out_color = Color.new; end
  def self.exist?(*); true; end
end

# Size of a picture file, read from its PNG header (so layout code that
# measures bitmaps gets real numbers).
module HeadlessImages
  def self.size(path)
    return [32, 32] if !path
    cands = [path, path + ".png", path + ".PNG", path + ".gif", path + ".jpg"]
    f = cands.find { |c| File.file?(c) }
    return nil if !f
    head = File.binread(f, 32)
    if head[1, 3] == "PNG" then head[16, 8].unpack("NN")
    elsif head[0, 3] == "GIF" then head[6, 4].unpack("vv")
    else [32, 32] end
  rescue StandardError
    [32, 32]
  end
end

class Bitmap
  attr_accessor :font, :path
  attr_reader :width, :height
  def initialize(a = 32, b = nil)
    @font = Font.new
    if a.is_a?(String)
      @path = a
      sz = HeadlessImages.size(a)
      raise Errno::ENOENT, a if !sz
      @width, @height = sz
    else
      @width, @height = a.to_i, (b || 32).to_i
    end
    @disposed = false
  end
  def rect; Rect.new(0, 0, @width, @height); end
  def dispose; @disposed = true; end
  def disposed?; @disposed; end
  def clone; b = Bitmap.new(@width, @height); b.path = @path; b; end
  def dup; clone; end
  def text_size(s); Rect.new(0, 0, s.to_s.length * 10, 24); end
  def get_pixel(*); Color.new(0, 0, 0, 255); end
  def method_missing(n, *a, &b); nil; end
  def respond_to_missing?(*); true; end
  def self.method_missing(n, *a); nil; end
end

class Viewport
  attr_accessor :rect, :z, :ox, :oy, :color, :tone, :visible
  def initialize(*a); @rect = Rect.new(*(a.size == 4 ? a : [0, 0, 512, 384])); @z = 0; @ox = 0; @oy = 0; @color = Color.new; @tone = Tone.new; @visible = true; end
  def dispose; @disposed = true; end
  def disposed?; !!@disposed; end
  def update; end
  def flash(*); end
end

class Sprite
  attr_accessor :bitmap, :src_rect, :x, :y, :z, :ox, :oy, :zoom_x, :zoom_y, :angle, :mirror, :opacity,
                :blend_type, :color, :tone, :visible, :viewport, :bush_depth, :wave_amp, :wave_length,
                :wave_speed, :wave_phase
  def initialize(vp = nil)
    @viewport = vp; @src_rect = Rect.new; @x = @y = @z = @ox = @oy = 0; @zoom_x = @zoom_y = 1.0
    @angle = 0; @opacity = 255; @blend_type = 0; @color = Color.new; @tone = Tone.new; @visible = true; @bush_depth = 0
  end
  def bitmap=(b); @bitmap = b; @src_rect = b ? Rect.new(0, 0, b.width, b.height) : Rect.new; end
  def dispose; @disposed = true; end
  def disposed?; !!@disposed; end
  def update; end
  def flash(*); end
  def width; @src_rect.width; end
  def height; @src_rect.height; end
end

class Plane < Sprite; end

class Window
  attr_accessor :windowskin, :contents, :stretch, :cursor_rect, :active, :visible, :pause, :x, :y, :width,
                :height, :z, :ox, :oy, :opacity, :back_opacity, :contents_opacity, :viewport, :openness, :tone, :color
  def initialize(vp = nil); @viewport = vp; @cursor_rect = Rect.new; @x = @y = @z = @ox = @oy = 0; @width = @height = 32; @visible = true; @active = true; @opacity = 255; @openness = 255; end
  def dispose; @disposed = true; end
  def disposed?; !!@disposed; end
  def update; end
end

class Tilemap
  attr_accessor :tileset, :autotiles, :map_data, :flash_data, :priorities, :visible, :ox, :oy, :viewport, :tone, :color
  def initialize(vp = nil); @viewport = vp; @autotiles = []; @visible = true; @ox = @oy = 0; end
  def dispose; @disposed = true; end
  def disposed?; !!@disposed; end
  def update; end
end

module Graphics
  @frame_count = 0; @frame_rate = 40; @width = 512; @height = 384; @brightness = 255
  class << self
    attr_accessor :frame_count, :frame_rate, :brightness
    def width; @width; end
    def height; @height; end
    def update
      @frame_count += 1
      $headless_frame_hook&.call
      if $headless_watchdog && @frame_count > $headless_watchdog
        $headless_watchdog = nil
        raise HeadlessStuck, "no progress: #{@frame_count} frames"
      end
    end
    def wait(n); n.times { update }; end
    def freeze; end
    def transition(*); end
    def frame_reset; end
    def fadeout(*); end
    def fadein(*); end
    def snap_to_bitmap; Bitmap.new(512, 384); end
    def resize_screen(w, h); @width, @height = w, h; end
    def average_frame_rate; 40; end
    def delta; 0.025; end
    def fullscreen; false; end
    def fullscreen=(*); end
    def scale; 1; end
    def scale=(*); end
    def play_movie(*); end
    def method_missing(n, *a); nil; end
  end
end

# Input: the driver pushes key presses into a queue; each Input.update
# takes the next one.
module Input
  DOWN = 2; LEFT = 4; RIGHT = 6; UP = 8
  A = 11; B = 12; C = 13; X = 14; Y = 15; Z = 16; L = 17; R = 18
  SHIFT = 21; CTRL = 22; ALT = 23; F5 = 25; F6 = 26; F7 = 27; F8 = 28; F9 = 29
  USE = C; BACK = B; ACTION = A; JUMPUP = X; JUMPDOWN = Y; SPECIAL = Z; AUX1 = L; AUX2 = R
  @queue = []; @current = nil; @held = nil
  class << self
    attr_accessor :queue
    def update; @current = @queue.shift; @held = @current; end
    def trigger?(k); @current == k; end
    def repeat?(k); @current == k; end
    def press?(k); @held == k; end
    def release?(*); false; end
    def dir4; [DOWN, LEFT, RIGHT, UP].include?(@held) ? @held : 0; end
    def dir8; dir4; end
    def count(*); 0; end
    def time?(*); 0; end
    def triggerex?(*); false; end
    def pressex?(*); false; end
    def repeatex?(*); false; end
    def releaseex?(*); false; end
    def text_input; false; end
    def text_input=(*); end
    def gets; ""; end
    def mouse_x; 0; end
    def mouse_y; 0; end
    def scroll_v; 0; end
    def clipboard; ""; end
    def method_missing(n, *a); n.to_s.end_with?("?") ? false : nil; end
  end
end

module Audio
  class << self
    attr_reader :log
    def method_missing(n, *a); (@log ||= []) << [n, a.first]; @log.shift if @log.size > 200; nil; end
  end
end

module System
  def self.data_directory; File.expand_path("~/.pif_headless_saves"); end
  def self.platform; "Linux"; end
  def self.is_windows?; false; end
  def self.is_linux?; true; end
  def self.is_mac?; false; end
  def self.user_language; "en_US"; end
  def self.uptime; Process.clock_gettime(Process::CLOCK_MONOTONIC); end
  def self.method_missing(n, *a); nil; end
end

class Win32API
  def initialize(*); end
  def call(*); 0; end
end

module Kernel
  def msgbox(*a); $stderr.puts "[msgbox] #{a.join(' ')}"; end
  def print(*a); $stdout.print(*a); end
end

def rgss_main; yield; end
def load_data(path)
  real = [path, path.tr("\\", "/")].find { |p| File.file?(p) } or raise Errno::ENOENT, path
  # like mkxp-z: text in the data files is UTF-8
  Marshal.load(File.binread(real), proc { |o|
    if o.is_a?(String) && o.encoding == Encoding::ASCII_8BIT && !o.frozen?
      u = o.dup.force_encoding(Encoding::UTF_8)
      o.force_encoding(Encoding::UTF_8) if u.valid_encoding?
    end
    o
  })
end
Encoding.default_external = Encoding::UTF_8
def save_data(obj, path); File.binwrite(path.tr("\\", "/"), Marshal.dump(obj)); end
module RPG
  module Cache
    @cache = {}
    def self.method_missing(n, *a); Bitmap.new(32, 32); end
  end
end

class Bitmap
  %w[draw_text blt stretch_blt fill_rect clear gradient_fill_rect hue_change blur radial_blur set_pixel
     clear_rect draw_text_outline to_file save_png mega? raw_data].each { |m| define_method(m) { |*a, &b| nil } }
  def self.max_size; 16384; end
end

# RPG Maker XP's data classes with their real constructors (the engine builds
# events and move routes in code, not just from the data files).
module RPG
  class Event
    attr_accessor :id, :name, :x, :y, :pages
    def initialize(x = 0, y = 0); @id = 0; @name = ""; @x = x; @y = y; @pages = [RPG::Event::Page.new]; end
    class Page
      attr_accessor :condition, :graphic, :move_type, :move_speed, :move_frequency, :move_route, :walk_anime,
                    :step_anime, :direction_fix, :through, :always_on_top, :trigger, :list
      def initialize
        @condition = RPG::Event::Page::Condition.new; @graphic = RPG::Event::Page::Graphic.new
        @move_type = 0; @move_speed = 3; @move_frequency = 3; @move_route = RPG::MoveRoute.new
        @walk_anime = true; @step_anime = false; @direction_fix = false; @through = false
        @always_on_top = false; @trigger = 0; @list = [RPG::EventCommand.new]
      end
      class Condition
        attr_accessor :switch1_valid, :switch2_valid, :variable_valid, :self_switch_valid, :switch1_id,
                      :switch2_id, :variable_id, :variable_value, :self_switch_ch
        def initialize
          @switch1_valid = @switch2_valid = @variable_valid = @self_switch_valid = false
          @switch1_id = @switch2_id = @variable_id = 1; @variable_value = 0; @self_switch_ch = "A"
        end
      end
      class Graphic
        attr_accessor :tile_id, :character_name, :character_hue, :direction, :pattern, :opacity, :blend_type
        def initialize; @tile_id = 0; @character_name = ""; @character_hue = 0; @direction = 2; @pattern = 0; @opacity = 255; @blend_type = 0; end
      end
    end
  end
  class EventCommand
    attr_accessor :code, :indent, :parameters
    def initialize(code = 0, indent = 0, parameters = []); @code = code; @indent = indent; @parameters = parameters; end
  end
  class MoveRoute
    attr_accessor :repeat, :skippable, :list
    def initialize; @repeat = true; @skippable = false; @list = [RPG::MoveCommand.new]; end
  end
  class MoveCommand
    attr_accessor :code, :parameters
    def initialize(code = 0, parameters = []); @code = code; @parameters = parameters; end
  end
  class AudioFile
    attr_accessor :name, :volume, :pitch
    def initialize(name = "", volume = 100, pitch = 100); @name = name; @volume = volume; @pitch = pitch; end
  end
  class Map
    attr_accessor :tileset_id, :width, :height, :autoplay_bgm, :bgm, :autoplay_bgs, :bgs, :encounter_list, :encounter_step, :data, :events
    def initialize(w = 20, h = 15); @tileset_id = 1; @width = w; @height = h; @autoplay_bgm = false; @bgm = RPG::AudioFile.new; @autoplay_bgs = false; @bgs = RPG::AudioFile.new("", 80); @encounter_list = []; @encounter_step = 30; @data = Table.new(w, h, 3); @events = {}; end
  end
  class MapInfo
    attr_accessor :name, :parent_id, :order, :expanded, :scroll_x, :scroll_y
    def initialize; @name = ""; @parent_id = 0; @order = 0; @expanded = false; @scroll_x = @scroll_y = 0; end
  end
end

# Ruby 3.1 things the game uses that newer Ruby removed
class << File; alias exists? exist? unless method_defined?(:exists?); end
class << Dir; alias exists? exist? unless method_defined?(:exists?); end
class Object; def =~(_o); nil; end unless method_defined?(:=~); end
Fixnum = Integer unless defined?(Fixnum)
Bignum = Integer unless defined?(Bignum)

# mkxp-z reads text in data and save files as UTF-8; plain Ruby reads it as
# raw bytes, which breaks names like "Pokémon Ranger". Fix it on load.
module Marshal
  HL_UTF8 = proc do |o|
    if o.is_a?(String) && o.encoding == Encoding::ASCII_8BIT && !o.frozen?
      u = o.dup.force_encoding(Encoding::UTF_8)
      o.force_encoding(Encoding::UTF_8) if u.valid_encoding?
    end
    o
  end
  class << self
    alias hl_load load unless method_defined?(:hl_load)
    def load(src, pr = nil, **kw); hl_load(src, pr || HL_UTF8, **kw); end
  end
end
