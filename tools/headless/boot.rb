# Boots Infinite Fusion's real scripts (with Frost & Thaw) headlessly.
# Usage: ruby boot.rb [game_dir]   (then the driver takes over)
GAME_DIR = File.expand_path(ENV["PIF_DIR"] || "/home/claude/pifrun")
Dir.chdir(GAME_DIR)
require_relative "rgss"

$RGSS_SCRIPTS = []
$headless_skipped = []
$headless_load_errors = []

# Same order as the game's own loader (Data/Scripts.rxdata "Main"):
# files in a folder sorted by name, then sub-folders sorted by name.
def headless_load_folder(path)
  entries = Dir.children(path).reject { |f| %w[.git .idea .gitignore].include?(f) }
  files = entries.reject { |f| File.directory?(File.join(path, f)) }.sort
  folders = entries.select { |f| File.directory?(File.join(path, f)) }.sort
  files.each do |f|
    full = File.join(path, f)
    next unless f.end_with?(".rb")
    if full.end_with?("999_Main/999_Main.rb")
      # define everything but don't start the title-screen loop
      code = File.read(full, encoding: "UTF-8").sub(/^loop do\s*\n\s*retval = mainFunction.*\z/m, "")
    else
      code = File.read(full, encoding: "UTF-8")
    end
    begin
      eval(code, nil, full)    # like the game: inside a method, so top-level defs are public
    rescue Exception => e
      $headless_load_errors << [full.sub(GAME_DIR + "/", ""), "#{e.class}: #{e.message.lines.first&.strip}", e.backtrace&.first]
    end
  end
  folders.each { |d| headless_load_folder(File.join(path, d)) }
end

# GameSettings (first entry of Scripts.rxdata)
require "zlib"
scripts = Marshal.load(File.binread("Data/Scripts.rxdata"))
eval(Zlib::Inflate.inflate(scripts[0][2]), TOPLEVEL_BINDING, "GameSettings")
headless_load_folder("Data/Scripts")

# In the real game, methods the scripts define at the top level can be called
# as Kernel.pbSomething (the base game's own maps do this), so make them public
# here the same way.
(Object.private_instance_methods(false)).each do |m|
  loc = (Object.instance_method(m).source_location rescue nil)
  Object.send(:public, m) if loc && loc[0].to_s.start_with?("Data/Scripts")
end
