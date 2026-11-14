#===============================================================================
# Frost & Thaw - the browser build's file names, and Ruby 3.3
#
# The browser player keeps the game in the browser's private storage, which
# doesn't accept every file name: names with accents ("Pokémon Center...",
# "Trovão") fail there. tools/web/pack_web.py stores those files under plain
# ASCII names, folded the same way as web_fold below. Here, any audio or picture
# the game asks for by an accented name is played from the folded name when
# that's the one that exists. On a normal install the accented file is found
# first and nothing changes.
#===============================================================================
#-------------------------------------------------------------------------------
# Ruby 3.2+ (the browser engine runs Ruby 3.3) removed a few things Infinite
# Fusion, written for Ruby 3.1, still calls. Put them back as they were.
#-------------------------------------------------------------------------------
File.define_singleton_method(:exists?) { |*a| File.exist?(*a) } unless File.respond_to?(:exists?)
Dir.define_singleton_method(:exists?) { |*a| Dir.exist?(*a) } unless Dir.respond_to?(:exists?)
class Object
  def taint; self; end unless method_defined?(:taint)
  def untaint; self; end unless method_defined?(:untaint)
  def tainted?; false; end unless method_defined?(:tainted?)
  def trust; self; end unless method_defined?(:trust)
  def untrust; self; end unless method_defined?(:untrust)
  def untrusted?; false; end unless method_defined?(:untrusted?)
  def =~(_other); nil; end unless method_defined?(:=~)
end
# The browser engine's sandboxed Ruby has a `caller` that takes no arguments;
# Infinite Fusion's debug logger asks for caller(1..1)
module Kernel
  if method_defined?(:echoln) && !method_defined?(:ft_web_echoln)
    alias_method :ft_web_echoln, :echoln
    def echoln(string)
      ft_web_echoln(string)
    rescue ArgumentError
      return unless $DEBUG
      echo(string)
      echo("\r\n")
    end
  end
end
Fixnum = Integer unless defined?(Fixnum)
Bignum = Integer unless defined?(Bignum)

#-------------------------------------------------------------------------------
# Infinite Fusion's data files are XOR-scrambled, and its unscrambler turns the
# file into an array of one number per byte (31 million for messages.dat). In
# the browser's 32-bit Ruby that runs out of memory and crashes the game the
# first time a fusion's name is looked up (the title screen). Same result, in
# 64 KB pieces, using whole-piece integer XOR: byte-for-byte identical output,
# about 4x faster on PC as well.
#-------------------------------------------------------------------------------
if defined?(Encryption) && defined?(Encryption::ENCRYPTION_KEY) && Encryption::ENCRYPTION_KEY.length == 16
  module Encryption
    FT_XOR_CHUNK = 65536   # a multiple of the key length, so every piece starts at key byte 0
    FT_KEY_HEX = ENCRYPTION_KEY.pack("C*").unpack1("H*")
    FT_FULL_KEY = (FT_KEY_HEX * (FT_XOR_CHUNK / 16)).to_i(16)

    def self.xor(data)
      data = data.b
      out = String.new(capacity: data.bytesize, encoding: Encoding::BINARY)
      pos = 0
      while pos < data.bytesize
        piece = data.byteslice(pos, FT_XOR_CHUNK)
        n = piece.bytesize
        key = (n == FT_XOR_CHUNK) ? FT_FULL_KEY : (FT_KEY_HEX * (n / 16 + 1))[0, n * 2].to_i(16)
        out << [(piece.unpack1("H*").to_i(16) ^ key).to_s(16).rjust(n * 2, "0")].pack("H*")
        pos += n
      end
      out
    end
  end
end

module FrostThaw
  WEB_FOLD = {
    "á" => "a", "à" => "a", "â" => "a", "ä" => "a", "ã" => "a", "å" => "a",
    "é" => "e", "è" => "e", "ê" => "e", "ë" => "e",
    "í" => "i", "ì" => "i", "î" => "i", "ï" => "i",
    "ó" => "o", "ò" => "o", "ô" => "o", "ö" => "o", "õ" => "o",
    "ú" => "u", "ù" => "u", "û" => "u", "ü" => "u",
    "ç" => "c", "ñ" => "n",
    "Á" => "A", "À" => "A", "Â" => "A", "Ä" => "A", "Ã" => "A", "Å" => "A",
    "É" => "E", "È" => "E", "Ê" => "E", "Ë" => "E",
    "Í" => "I", "Ì" => "I", "Î" => "I", "Ï" => "I",
    "Ó" => "O", "Ò" => "O", "Ô" => "O", "Ö" => "O", "Õ" => "O",
    "Ú" => "U", "Ù" => "U", "Û" => "U", "Ü" => "U",
    "Ç" => "C", "Ñ" => "N"
  }
  AUDIO_EXTS = ["", ".ogg", ".mp3", ".wav", ".mid", ".midi", ".wma"]
  @web_fold_cache = {}

  def self.web_fold_name(name)
    s = name.to_s.dup.force_encoding("UTF-8")
    s = s.gsub(/[̀-ͯ]/, "")                       # combining accents (decomposed names)
    s = s.gsub(/[^\x00-\x7f]/) { |c| WEB_FOLD[c] || "_" }
    s
  end

  # The name to open: the folded one if the accented file isn't there but the folded one is
  def self.web_fold(path, exts = AUDIO_EXTS)
    return path if !path.is_a?(String) || path.ascii_only?
    return @web_fold_cache[path] if @web_fold_cache.key?(path)
    folded = web_fold_name(path)
    found = exts.any? { |e| (File.exist?(path + e) rescue false) } ? path :
            (exts.any? { |e| (File.exist?(folded + e) rescue false) } ? folded : path)
    @web_fold_cache[path] = found
  rescue StandardError
    path
  end
end

module Audio
  class << self
    %i[bgm_play bgs_play me_play se_play].each do |m|
      next if !method_defined?(m) || method_defined?(:"ft_web_#{m}")
      alias_method :"ft_web_#{m}", m
      # Infinite Fusion passes nil for "default" volume/pitch (cries do); the PC engine
      # takes that as the default, the browser engine refuses it
      define_method(m) do |name, *rest|
        rest = rest.each_with_index.map { |v, i| v.nil? ? [100, 100, 0][i] : v }
        send(:"ft_web_#{m}", FrostThaw.web_fold(name), *rest)
      end
    end
  end
end

if defined?(RPG::Cache) && RPG::Cache.respond_to?(:load_bitmap)
  module RPG
    module Cache
      class << self
        unless method_defined?(:ft_web_load_bitmap)
          alias_method :ft_web_load_bitmap, :load_bitmap
          def load_bitmap(folder, filename = "", *rest)
            if filename.is_a?(String) && !filename.ascii_only?
              full = FrostThaw.web_fold(folder.to_s + filename, ["", ".png", ".gif"])
              filename = full[folder.to_s.length..] if full != folder.to_s + filename
            end
            ft_web_load_bitmap(folder, filename, *rest)
          end
        end
      end
    end
  end
end

#-------------------------------------------------------------------------------
# Browser build only: a boot trace in the save folder, so a black screen can be
# told apart from a slow one. Off unless the engine is the libretro/web build.
#-------------------------------------------------------------------------------
module FrostThaw
  def self.web_build?
    return @web_build unless @web_build.nil?
    plat = (System.platform rescue "").to_s
    @web_build = !!(plat =~ /emscripten|libretro|web|wasm/i) || File.exist?("mkxp.json")
  rescue StandardError
    @web_build = false
  end

  def self.web_trace(msg)
    return if !web_build?
    @web_t0 ||= Time.now
    line = format("%7.1fs %s", Time.now - @web_t0, msg)
    dir = (System.data_directory rescue nil) || "."
    File.open(File.join(dir, "ft_web_trace.txt"), "a") { |f| f.puts(line) } rescue nil
  end
end
FrostThaw.web_trace("scripts loaded, platform=#{(System.platform rescue '?')} data_dir=#{(System.data_directory rescue '?')} cwd=#{(Dir.pwd rescue '?')}")
if FrostThaw.web_build?
  module Graphics
    class << self
      unless method_defined?(:ft_web_update)
        alias_method :ft_web_update, :update
        def update(*a)
          @ft_frames = (@ft_frames || 0) + 1
          FrostThaw.web_wrap_all if @ft_frames == 1
          FrostThaw.web_trace("frame #{@ft_frames}") if @ft_frames == 1 || @ft_frames % (@ft_frames > 600 ? 60 : 300) == 0
          ft_web_update(*a)
        end
      end
    end
  end
end

#-------------------------------------------------------------------------------
# Browser build only: no internet calls. The web engine has no HTTPLite (and a
# browser couldn't reach Infinite Fusion's servers from the page anyway), so
# Infinite Fusion's update checks and sprite downloads are switched off, and a
# stand-in HTTPLite answers "no connection" to any call that slips through.
#-------------------------------------------------------------------------------
if FrostThaw.web_build?
  MKXPError = Class.new(StandardError) unless defined?(MKXPError)
  unless defined?(HTTPLite)
    module HTTPLite
      NO_CONNECTION = { status: 0, body: "" }.freeze
      def self.get(*_a); NO_CONNECTION.dup; end
      def self.post(*_a); NO_CONNECTION.dup; end
      def self.post_body(*_a); NO_CONNECTION.dup; end
    end
  end
  def downloadAllowed?(*_a)
    false
  end
  # The web engine's HTTPLite has no JSON reader either, and Infinite Fusion reads its
  # outfits, hairstyles, Pokédex entries and some text from local JSON files with it
  module HTTPLite
    module JSON
      TOKEN = /\s*(?:("(?:[^"\\]|\\.)*")|(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)|(true|false|null)|([\[\]{}:,]))/m
      ESC = { '"' => '"', "\\" => "\\", "/" => "/", "b" => "\b", "f" => "\f", "n" => "\n", "r" => "\r", "t" => "\t" }

      def self.unescape(str)
        return str unless str.include?("\\")
        str.gsub(/\\u([dD][89abAB]\h\h)\\u([dD][c-fC-F]\h\h)|\\u(\h{4})|\\(.)/m) do
          if $1
            (((($1.hex - 0xD800) << 10) | ($2.hex - 0xDC00)) + 0x10000).chr(Encoding::UTF_8)
          elsif $3
            $3.hex.chr(Encoding::UTF_8)
          else
            ESC[$4] || $4
          end
        end
      end

      def self.parse(src)
        src = src.to_s.dup.force_encoding(Encoding::UTF_8)
        src = src.delete_prefix("\uFEFF")
        stack = []
        keys = []
        result = nil
        have = false
        put = lambda do |v|
          top = stack.last
          if top.nil?
            result = v
            have = true
          elsif top.is_a?(Array)
            top << v
          elsif keys.last.equal?(:none)
            keys[-1] = v
          else
            top[keys.last] = v
            keys[-1] = :none
          end
        end
        # One linear pass over the tokens (anything between tokens is skipped)
        src.scan(TOKEN) do
          str, num, word, punct = $1, $2, $3, $4
          if str
            put.call(unescape(str[1..-2]))
          elsif num
            put.call(num.match?(/[.eE]/) ? num.to_f : num.to_i)
          elsif word
            put.call(word == "true" ? true : (word == "false" ? false : nil))
          else
            case punct
            when "["
              stack << []
            when "{"
              stack << {}
              keys << :none
            when "]", "}"
              v = stack.pop
              keys.pop if v.is_a?(Hash)
              put.call(v)
            end
          end
        end
        raise ArgumentError, "unfinished JSON" unless stack.empty? && have
        result
      end

      def self.stringify(obj)
        case obj
        when Hash then "{" + obj.map { |k, v| stringify(k.to_s) + ":" + stringify(v) }.join(",") + "}"
        when Array then "[" + obj.map { |v| stringify(v) }.join(",") + "]"
        when String
          '"' + obj.gsub(/["\\\x00-\x1f]/) { |c| { '"' => '\\"', "\\" => "\\\\", "\n" => "\\n", "\r" => "\\r", "\t" => "\\t" }[c] || format("\\u%04x", c.ord) } + '"'
        when Symbol then stringify(obj.to_s)
        when nil then "null"
        when true, false, Numeric then obj.to_s
        else stringify(obj.to_s)
        end
      end
    end
  end
  # Fusion Pokédex entries come from a 23 MB file that Infinite Fusion re-reads every time
  # one is shown; in the browser that's seconds of waiting and a lot of memory. Read it
  # once, keep only an index by sprite.
  if defined?(PokemonPokedexInfo_Scene) && PokemonPokedexInfo_Scene.method_defined?(:getCustomDexEntry)
    class PokemonPokedexInfo_Scene
      def getCustomDexEntry(pif_sprite)
        sprite = pif_sprite.to_filename
        index = FrostThaw.web_custom_dex_index
        entries = index[sprite]
        entries && !entries.empty? ? entries : nil
      end
    end
    module FrostThaw
      def self.web_custom_dex_index
        @web_custom_dex_index ||= begin
          index = {}
          HTTPLite::JSON.parse(File.read(Settings::CUSTOM_DEX_ENTRIES_PATH)).each do |e|
            (index[e["sprite"]] ||= []) << [e["entry"], e["author"]] if e.is_a?(Hash)
          end
          index
        rescue StandardError => e
          web_trace("custom dex entries unavailable: #{e.class} #{e.message}")
          {}
        end
      end
    end
  end
  unless defined?(::JSON)
    module ::JSON
      def self.parse(src, *_opts) = HTTPLite::JSON.parse(src)
      def self.generate(obj, *_opts) = HTTPLite::JSON.stringify(obj)
    end
  end

  # Infinite Fusion's start-up notices tell players to download things from its Discord,
  # and its start-menu links (Discord, FAQ, Wiki) can't open anything from inside the page
  module Settings
    { STARTUP_MESSAGES_KANTO: "", STARTUP_MESSAGES_HOENN: "", MAIN_MENU_LINKS: {} }.each do |c, v|
      next unless const_defined?(c, false)
      remove_const(c)
      const_set(c, v)
    end
  end
  # "Quit Game" would close the game and leave the player in the engine's own menu. It's
  # always the last command, so dropping it doesn't move any other command's number.
  if defined?(PokemonLoad_Scene) && PokemonLoad_Scene.method_defined?(:pbStartScene)
    class PokemonLoad_Scene
      unless method_defined?(:ft_web_pbStartScene)
        alias_method :ft_web_pbStartScene, :pbStartScene
        def pbStartScene(commands, *rest)
          commands.pop if commands.is_a?(Array) && commands.last == _INTL("Quit Game")
          ft_web_pbStartScene(commands, *rest)
        end
      end
    end
  end
end

# Browser build only: the load screen's steps and every raised error go in the trace,
# wrapped at the first frame (when every script, Main included, has loaded)
module FrostThaw
  def self.web_wrap(owner, name, label)
    return if !(owner.method_defined?(name) || owner.private_method_defined?(name))
    orig = :"ft_wt_#{name}"
    return if owner.method_defined?(orig) || owner.private_method_defined?(orig)
    owner.send(:alias_method, orig, name)
    owner.send(:define_method, name) do |*a, &b|
      FrostThaw.web_trace("> #{label}#{[String, Integer, Symbol].any? { |k| a[0].is_a?(k) } ? ' ' + a[0].inspect[0, 62] : ''}")
      r = send(orig, *a, &b)
      FrostThaw.web_trace("< #{label}")
      r
    end
  end

  def self.web_wrap_all
    return if @web_wrapped
    @web_wrapped = true
    load = (PokemonLoadScreen rescue nil)
    scene = (PokemonLoad_Scene rescue nil)
    list = [[load, :pbStartLoadScreen], [load, :copyKeybindings], [load, :load_save_file],
            [scene, :pbStartScene], [scene, :pbStartScene2], [scene, :pbChoose],
            [Object, :pbCallTitle], [Object, :updateHttpSettingsFile], [Object, :updateCustomDexFile],
            [Object, :find_newer_available_version], [Object, :checkEnableSpritesDownload],
            [Object, :handleReplaceExistingSprites], [Object, :promptEnableSpritesDownload],
            [Object, :getCustomSpeciesList], [Object, :pbDownloadData], [Object, :download_file],
            [Object, :pbMessage], [Object, :pbFadeOutIn], [Object, :mainFunction],
            [Object, :getRandomFusionForIntro], [(Scene_Intro rescue nil), :main],
            [(Scene_Intro rescue nil), :playIntroCinematic], [(Scene_Intro rescue nil), :closeTitle],
            [(GenOneStyle rescue nil), :initialize], [(GenOneStyle rescue nil), :intro],
            [(BattleSpriteLoader rescue nil), :load_base_sprite],
            [(BattleSpriteLoader rescue nil), :load_fusion_sprite],
            [(PIFSpriteExtracter rescue nil), :load_sprite],
            [(BaseSpriteExtracter rescue nil), :load_bitmap_from_spritesheet],
            [(CustomSpriteExtracter rescue nil), :load_bitmap_from_spritesheet],
            [(AutogenExtracter rescue nil), :load_bitmap_from_spritesheet],
            [(Game_Map rescue nil), :setup], [Object, :pbTrainerBattle], [Object, :pbWildBattle],
            [Object, :pbSave], [(FrostThaw.singleton_class rescue nil), :start_new_game]]
    list.each { |owner, name| web_wrap(owner, name, "#{owner}##{name}") if owner }
    count = 0
    @web_raise_tp = TracePoint.new(:raise) do |tp|
      count += 1
      next if count > 400
      e = tp.raised_exception
      next if e.is_a?(ArgumentError) && tp.path.to_s.include?("DebugConsole")
      FrostThaw.web_trace("raise #{e.class}: #{e.message.to_s[0, 120]} @ #{tp.path}:#{tp.lineno}") rescue nil
      if e.is_a?(NoMethodError) || e.is_a?(TypeError) || e.is_a?(NoMemoryError) || e.is_a?(SystemStackError)
        (e.backtrace || caller || []).first(12).each { |l| FrostThaw.web_trace("    from #{l}") } rescue nil
      end
    end
    @web_raise_tp.enable rescue nil
  rescue StandardError => e
    web_trace("web_wrap_all failed: #{e.class} #{e.message}")
  end
end
