# Minimal stand-ins for RPG Maker XP's built-in classes so plain Ruby can
# read and write the game's .rxdata files.
class Table
  attr_reader :xsize, :ysize, :zsize, :data
  def initialize(x, y = 1, z = 1)
    @dim = (z > 1 ? 3 : (y > 1 ? 2 : 1)); @xsize, @ysize, @zsize = x, y, z
    @data = Array.new(x * y * z, 0)
  end
  def [](x, y = 0, z = 0); @data[x + y * @xsize + z * @xsize * @ysize]; end
  def []=(*a); v = a.pop; x, y, z = a[0], a[1] || 0, a[2] || 0; @data[x + y * @xsize + z * @xsize * @ysize] = v; end
  def self._load(s)
    dim, x, y, z, n = s[0, 20].unpack("V5")
    t = allocate
    t.instance_variable_set(:@dim, dim); t.instance_variable_set(:@xsize, x)
    t.instance_variable_set(:@ysize, y); t.instance_variable_set(:@zsize, z)
    t.instance_variable_set(:@data, s[20, n * 2].unpack("s<*"))
    t
  end
  def _dump(_l = -1); [@dim, @xsize, @ysize, @zsize, @data.length].pack("V5") + @data.pack("s<*"); end
end
class Color
  attr_accessor :red, :green, :blue, :alpha
  def initialize(r = 0, g = 0, b = 0, a = 255); @red, @green, @blue, @alpha = r, g, b, a; end
  def self._load(s); new(*s.unpack("E4")); end
  def _dump(_l = -1); [@red, @green, @blue, @alpha].pack("E4"); end
end
class Tone
  attr_accessor :red, :green, :blue, :gray
  def initialize(r = 0, g = 0, b = 0, gr = 0); @red, @green, @blue, @gray = r, g, b, gr; end
  def self._load(s); new(*s.unpack("E4")); end
  def _dump(_l = -1); [@red, @green, @blue, @gray].pack("E4"); end
end
module RPG
  class Generic
    def method_missing(n, *a)
      s = n.to_s
      if s.end_with?("=") then instance_variable_set("@#{s.chomp('=')}", a[0])
      elsif instance_variable_defined?("@#{s}") then instance_variable_get("@#{s}")
      else super end
    end
    def respond_to_missing?(n, p = false)
      s = n.to_s
      s.end_with?("=") || instance_variable_defined?("@#{s}")
    end
  end
  %w[Map MapInfo Event MoveRoute MoveCommand EventCommand AudioFile Tileset System
     CommonEvent Actor Class Skill Item Weapon Armor Enemy Troop State Animation].each do |c|
    const_set(c, ::Class.new(Generic))
  end
  class Event
    Page = ::Class.new(Generic)
    class Page
      Condition = ::Class.new(Generic)
      Graphic = ::Class.new(Generic)
    end
  end
  class System
    Words = ::Class.new(Generic); TestBattler = ::Class.new(Generic)
  end
  class Troop; Member = ::Class.new(Generic); Page = ::Class.new(Generic); class Page; Condition = ::Class.new(Generic); end; end
  class Animation; Frame = ::Class.new(Generic); Timing = ::Class.new(Generic); end
  class Enemy; Action = ::Class.new(Generic); end
  class Class; Learning = ::Class.new(Generic); end
end
def load_data(path); File.open(path, "rb") { |f| Marshal.load(f) }; end
def save_data(obj, path); File.open(path, "wb") { |f| Marshal.dump(obj, f) }; end
