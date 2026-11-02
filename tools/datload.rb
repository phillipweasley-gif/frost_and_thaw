require_relative "rgss_stub"
load "/home/claude/pif-682/Data/Scripts/001_Technical/000_Encryption.rb"
module GameData
  %w[TrainerType Trainer Encounter MapMetadata Species Item Move Type Ability Metadata PlayerMetadata TownMap].each do |c|
    const_set(c, ::Class.new(RPG::Generic)) unless const_defined?(c, false)
  end
  class Species; end
end
def load_dat(name)
  raw = File.binread("/home/claude/pif-682/Data/#{name}")
  begin
    Marshal.load(Encryption.xor(raw))
  rescue StandardError
    Marshal.load(raw)
  end
end
