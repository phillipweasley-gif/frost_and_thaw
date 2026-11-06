# Offline checks for the Frost & Thaw scripts: loads them with small stand-ins
# for the game, plus the game's real GameData trainer classes and data files.
GAME = ARGV[0] || "/home/claude/pif-682"
FT_DIR = ARGV[1] || File.expand_path("../game/Data/Scripts/998_FrostThaw", __dir__)
$fails = 0; $checks = 0
def check(name) ; $checks += 1; ok = yield; puts "#{ok ? 'ok  ' : 'FAIL'} #{name}"; $fails += 1 unless ok
rescue StandardError => e; $fails += 1; puts "FAIL #{name}: #{e.class}: #{e.message}"; end

# --- stand-ins ---------------------------------------------------------------
def echoln(*); end
def _INTL(s, *a); a.each_with_index { |v, i| s = s.gsub("{#{i + 1}}", v.to_s) }; s; end
$messages = []
def pbMessage(t, cmds = nil, *_); $messages << t; cmds ? ($next_choice || 0) : 0; end
def pbConfirmMessage(t); $messages << t; true; end
def pbCallBub(*); end
def validate(*); end
module MessageTypes; TrainerTypes = 1; TrainerNames = 2; BeginSpeech = 3; EndSpeechLose = 4; end
def pbGetMessage(*); nil; end
def pbGetMessageFromHash(_t, s); s; end
def pbResolveBitmap(p); File.exist?(File.join(GAME, p + ".png")) ? p : nil; end
class PokemonGlobalMetadata; attr_accessor :pcItemStorage, :pokecenterMapId, :pokecenterX, :pokecenterY, :pokecenterDirection; end
class GameTempStub; attr_accessor :player_transferring, :player_new_map_id, :player_new_x, :player_new_y, :player_new_direction; end
$started_over_at = nil
def pbStartOver(gameover = false); $started_over_at = $PokemonGlobal.pokecenterMapId; end
class EventList; def initialize; @p = []; end; def +(pr); @p << pr; self; end; def trigger(*a); @p.each { |pr| pr.call(*a) }; end; end
module Events; @@scene = EventList.new; def self.onMapSceneChange; @@scene; end; def self.onMapSceneChange=(v); @@scene = v; end; end
class PCItemStorage; def initialize; @i = []; end; def pbCanStore?(*); true; end; def pbStoreItem(i, q); @i << [i, q]; true; end; end
class PokemonBag
  def maxPocketSize(pocket); -1; end
  def pbCanStore?(item, qty = 1); @full ? false : true; end
  def pbStoreItem(item, qty = 1); @full ? false : true; end
  attr_accessor :full
end
class PokemonPauseMenu_Scene; def pbShowCommands(c); $shown = c; $menu_ret.shift || 0; end; def pbHideMenu; end; def pbShowMenu; end; end
module Game; def self.start_new(*a); :orig; end; end
module Input; CTRL = 0; def self.press?(*); false; end; end
class PokeBattle_Battle
  attr_accessor :trainer, :shown
  def initialize(trainer); @trainer = trainer; @battlers = [Struct.new(:o) { def opposes?; o; end }.new(false)]; end
  def trainerBattle?; @trainer; end
  def pbDisplayPaused(t); @shown = t; end
  def pbRun(i, d = false); :ran; end
end
def pbRgssExists?(p); File.exist?(p); end
def load_data(p); Marshal.load(File.binread(p)); end
class MapStub; attr_accessor :map_id, :need_refresh; def initialize(i); @map_id = i; end; end
module PBDayNight; def self.isNight?; false; end; end
module SaveData; def self.load_all_values(d); $PokemonGlobal = d[:global_metadata]; end; end
class PokemonLoadScreen; def load_save_file(p); $fake_save; end; end

require File.expand_path("../tools/rgss_stub", __dir__)
# --- the game's own data classes and trainer data ----------------------------
load File.join(GAME, "Data/Scripts/001_Technical/000_Encryption.rb")
load File.join(GAME, "Data/Scripts/010_Data/001_GameData.rb")
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/012_TrainerType.rb")
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/013_Trainer.rb")
module Settings; NB_POKEMON = 576; ZAPMOLCUNO_NB = 999999; end unless defined?(Settings::ZAPMOLCUNO_NB)
NB_POKEMON = 576 unless defined?(NB_POKEMON)
CONST_NB_POKE = NB_POKEMON unless defined?(CONST_NB_POKE)
class Pokemon; end unless defined?(Pokemon)
module MessageTypes; Species = 10; FormNames = 11; Kinds = 12; Entries = 13; def self.get(*); nil; end; end
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/008_Species.rb")
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/004_Ability.rb")
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/005_Move.rb")
module MessageTypes; Abilities = 20; AbilityDescs = 21; Moves = 22; MoveDescriptions = 23; end
class SmokeHandlers; def initialize; @h = {}; end; def add(k, pr); @h[k] = pr; end; def [](k); @h[k]; end; end
module BattleHandlers; AbilityOnSwitchIn = SmokeHandlers.new; TargetAbilityOnHit = SmokeHandlers.new; end
class PokeBattle_Move; attr_accessor :calcType; def initialize(battle = nil, move = nil); @battle = battle; end; end
# Infinite Fusion's real fusion code
def getCurrentLanguage; :ENGLISH; end
def pbResolveAudioSE(p); File.exist?(File.join(GAME, "Audio/SE", p + ".ogg")) ? p : nil; end
load File.join(GAME, "Data/Scripts/052_InfiniteFusion/Fusion/FusionUtils.rb")
load File.join(GAME, "Data/Scripts/052_InfiniteFusion/Fusion/Data/FusedSpecies.rb")
load File.join(GAME, "Data/Scripts/052_InfiniteFusion/Fusion/Data/SplitNames.rb")
load File.join(GAME, "Data/Scripts/052_InfiniteFusion/Fusion/Sprites/PIFSprite.rb")
load File.join(GAME, "Data/Scripts/052_InfiniteFusion/Fusion/Sprites/BattleSpriteLoader.rb")
load File.join(GAME, "Data/Scripts/052_InfiniteFusion/Fusion/Sprites/SpritesSubstitutions.rb")
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/009_Species_Files.rb")
class AnimatedBitmap; attr_reader :path; def initialize(p); @path = p; end; end
module GameData
  class MapMetadata; DATA = {}; attr_reader :id, :weather, :teleport_destination
    def initialize(h); @id = h[:id]; @weather = h[:weather]; @teleport_destination = h[:teleport_destination]; end; end
  class Stat; def self.each_main; [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED].each { |s| yield Struct.new(:id).new(s) }; end; end
end
raw = File.binread(File.join(GAME, "Data/trainer_types.dat"))
GameData::TrainerType.const_set(:DATA, Marshal.load(Encryption.xor(raw))) rescue GameData::TrainerType.const_set(:DATA, Marshal.load(raw))
raw = File.binread(File.join(GAME, "Data/species.dat"))
sp_data = (Marshal.load(raw) rescue Marshal.load(Encryption.xor(raw)))
GameData::Species::DATA.clear; GameData::Species::DATA.merge!(sp_data)
[[GameData::Move, "moves.dat"], [GameData::Ability, "abilities.dat"]].each do |k, f|
  raw = File.binread(File.join(GAME, "Data", f))
  dat = (Marshal.load(raw) rescue Marshal.load(Encryption.xor(raw)))
  k::DATA.merge!(dat)
end

load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/011_Encounter.rb")
class PokemonEncounters
  attr_reader :encounter_tables
  def setup(map_ID)
    d = GameData::Encounter.get(map_ID, 0)
    @encounter_tables = d ? Marshal.load(Marshal.dump(d.types)) : {}
  end
end
module GameData; def self.load_all; :loaded; end; end
# --- Frost & Thaw ------------------------------------------------------------
Dir[File.join(FT_DIR, "*")].sort.each { |f| load f }
FT = FrostThaw unless defined?(FT)

$PokemonGlobal = PokemonGlobalMetadata.new
$game_self_switches = {}
$game_switches = {}
$game_map = MapStub.new(2001)

check("not active in a normal save") { !FT.active? }
check("Infinite Fusion's own maps load normally") { FT.own_map_path("Data/Map042.rxdata").nil? }
check("map 2001 redirects to Data/FrostThaw") { FT.own_map_path("Data/Map2001.rxdata") == "Data/FrostThaw/Map2001.rxdata" }
check("MapInfos gain our map names") { i = FT.map_infos_with_ours({}); i[2001] && i[2001].name == "Targos" }

GameData.load_all
check("trainer classes registered") { %i[FT_ZHENTARIM FT_ZHENTARIM_F FT_SPEAKER].all? { |t| GameData::TrainerType.try_get(t) } }
check("new trainer class names show") { GameData::TrainerType.get(:FT_SPEAKER).name == "Speaker" }
check("borrowed battle sprite resolves") { GameData::TrainerType.front_sprite_filename(:FT_SPEAKER).to_s.include?("ROCKETBOSS") }
check("every trainer is in the game's trainer list") {
  FT::TRAINERS.all? { |k, (type, name)| GameData::Trainer.try_get(type, name, 0) } }
check("every trainer's Pokémon is a real species or fusion") {
  bad = FT::TRAINERS.flat_map { |k, (_t, _n, party)| party.map { |sp, _l| [k, sp] } }.reject { |_k, sp| (GameData::Species.get(sp) rescue nil) }
  bad.empty? || (puts bad.inspect; false) }
check("every wild and boss Pokémon in the scripts is a real species or fusion") {
  syms = Dir[File.join(FT_DIR, "*.rb")].flat_map { |f| File.read(f, encoding: "UTF-8").scan(/named_mon\(:(\w+)/).flatten }
  syms += FT::ENCOUNTERS.values.flat_map { |t| t.reject { |k, _| k == :step_chances }.values.flatten(1).map { |e| e[1] } }
  bad = syms.uniq.reject { |sp| (GameData::Species.get(sp.to_sym) rescue nil) }
  bad.empty? || (puts bad.inspect; false) }
check("the Heartroot's lower zones and the Forge's rooms are named, with their switches in range") {
  (2140..2155).all? { |id| FT::MAP_NAMES[id] } &&
    [FT::SW_HEARTWALL, FT::SW_RING_DONE, FT::SW_BARRACKS_DONE, FT::SW_LIFT_NODE, FT::SW_AMBER_PODS, FT::SW_SAPLIFT,
     FT::SW_ROOTWATCH, FT::SW_L3_GATE, FT::SW_MECHS, FT::SW_ANTECHAPEL, FT::SW_CIRCLE_PHASE, FT::SW_GOLEMS].all? { |s| (4080..4119).include?(s) } }
check("no wild encounter table lists a fusion (the game fuses wild Pokémon itself, and a fusion of a fusion crashes)") {
  bad = FT::ENCOUNTERS.flat_map { |m, t| t.reject { |k, _| k == :step_chances }.values.flatten(1).map { |e| [m, e[1]] } }
                      .select { |_, sp| sp.to_s =~ /\AB\d+H\d+\z/ }
  bad.empty? || (puts bad.inspect; false) }
check("no two chapters register the same map name key (MAPS[:sanctum] once sent Act I into the Forge)") {
  keys = Dir[File.join(FT_DIR, "*.rb")].flat_map { |f|
    File.read(f, encoding: "UTF-8").scan(/MAPS\.merge!\((.*?)\)/m).flatten.flat_map { |b| b.scan(/(\w+):\s*\d{4}/).flatten } }
  dup = keys.group_by(&:itself).select { |_, v| v.size > 1 }.keys
  dup.empty? || (puts dup.inspect; false) }
check("the Chardalyn Dragon breathes frostfire and shatters with sound") {
  src = File.read(File.join(FT_DIR, "035_Chapter9.rb"), encoding: "UTF-8")
  (%i[ICEBEAM FLAMETHROWER HYPERVOICE] - FT::DRAGON_MOVES).empty? && FT::DRAGON_MOVES.all? { |m| GameData::Move::DATA[m] } &&
    src.scan("chardalyn_dragon(").size >= 3 && !src.include?("named_mon(CHARDALYN, 55") }
check("Chapter 4's story switches are 3918-3926") { (FT::SW_DH_WEST_OPEN..FT::SW_WOLVES_GONE).to_a == (3918..3926).to_a }
check("Chapter 4's maps are named") { (2030..2040).all? { |id| FT::MAP_NAMES[id] } }
check("every trainer class exists") { FT::TRAINERS.values.all? { |(type)| GameData::TrainerType.try_get(type) } }
check("Naerth has 3 Pokémon") { GameData::Trainer.get(:FT_SPEAKER, "Naerth", 0).pokemon.size == 3 }
check("map metadata registered for Targos") { GameData::MapMetadata::DATA[2001].weather == [:Snow, 100] }

# a Frost & Thaw save
$PokemonGlobal.frost_thaw = { active: true, flags: {}, counters: {}, bag_limit: 20, mode: :herald, herald: :alberica, version: :frost }
check("active in a Frost & Thaw save") { FT.active? }
FT.apply_herald_switches
$game_temp = GameTempStub.new
$PokemonGlobal.pokecenterMapId = -1
pbStartOver(true)
check("losing before any Pokémon Center wakes you in Targos's") { $started_over_at == 2003 }
$PokemonGlobal.pokecenterMapId = 1
pbStartOver(true)
check("a center outside Frost & Thaw is replaced by Targos's") { $started_over_at == 2003 }
$game_map = MapStub.new(42)
Events.onMapSceneChange.trigger(nil, nil)
check("a Frost & Thaw save on an Infinite Fusion map is carried back") { $game_temp.player_transferring && $game_temp.player_new_map_id == 2003 }
$game_map = MapStub.new(2001)
$game_temp = GameTempStub.new
Events.onMapSceneChange.trigger(nil, nil)
check("no rescue while on Frost & Thaw maps") { !$game_temp.player_transferring }
b = PokeBattle_Battle.new(true)
check("no running from a trainer battle in Frost & Thaw") { b.pbRun(0) == 0 && b.shown.to_s.include?("no running") }
check("wild battles can still be run from") { PokeBattle_Battle.new(false).pbRun(0) == :ran }
FT.register_species
tot = ->(k) { GameData::Species.get(k).base_stats.values.sum }
check("new Pokémon registered") { %i[LUTLING HAUNTELLO CHORUMBRA RIMIRAGE GLOAMCAP].all? { |k| GameData::Species.get(k).name.size > 0 } }
check("old test-build names still load") { GameData::Species.get(:CHIMELET).id == :LUTLING && GameData::Species.get(:FRETSHADE).id == :HAUNTELLO }
check("Alberica's line is 315/410/530") { [tot[:LUTLING], tot[:HAUNTELLO], tot[:CHORUMBRA]] == [315, 410, 530] }
check("Chorumbra is Dark/Fairy") { s = GameData::Species.get(:CHORUMBRA); [s.type1, s.type2] == [:DARK, :FAIRY] }
check("Lutling evolves into Hauntello at 16") { GameData::Species.get(:LUTLING).evolutions.first[0..2] == [:HAUNTELLO, :Level, 16] }
FT.apply_species_patches(false)
check("Infinite Fusion saves keep a 576 Pokédex") { NB_POKEMON == 576 && Settings::NB_POKEMON == 576 }
orig_zoroark = tot[:ZOROARK]
FT.apply_species_patches(true)
check("Frost & Thaw saves have a 591 Pokédex") { NB_POKEMON == 591 && Settings::NB_POKEMON == 591 && CONST_NB_POKE == 591 }
check("Wyn's new line is 585-586") { (585..586).map { |n| GameData::Species.get(n).id } == %i[SPOREYE MYCONARCH] }
check("the yeti line is 587-588: Ice/Normal Yetot evolves at 32 into Ice/Fighting Yetitan") {
  y, t = GameData::Species.get(587), GameData::Species.get(588)
  y.id == :YETOT && t.id == :YETITAN && [y.type1, y.type2] == %i[ICE NORMAL] && [t.type1, t.type2] == %i[ICE FIGHTING] &&
    y.evolutions.any? { |e| e[0] == :YETITAN && e[2] == 32 && !e[3] } && t.evolutions.any? { |e| e[0] == :YETOT && e[3] } }
check("every new Pokémon's abilities exist") {
  FT::NEW_SPECIES.keys.all? { |k| d = GameData::Species.get(k); (d.abilities + d.hidden_abilities).all? { |a| GameData::Ability::DATA[a] } } }
check("wild Yetot live in the Western Tundra and the Laughing Waste") {
  [2039, 2041].all? { |m| FT::ENCOUNTERS[m][:Land].any? { |e| e[1] == :YETOT } } }
check("the chasm's corridor scenes play only once") {
  $messages.clear; FT.scene_illusion_fork; n1 = $messages.size; FT.scene_illusion_fork; FT.scene_weeping_dark
  n2 = $messages.size; FT.scene_weeping_dark
  n1 > 0 && n2 > n1 && $messages.size == n2 }
check("Chapter 6: Rootspire's maps, trainers and shop exist") {
  [2050, 2051, 2052, 2053, 2054].all? { |m| FT::MAP_NAMES[m] } &&
    %i[warden_ash warden_lis warden_tobin].all? { |k| FT::TRAINERS[k] && FT::TRAINERS[k][2].all? { |sp, _| GameData::Species.exists?(sp) rescue true } } &&
    FT::MARTS[:rootspire].size >= 6 }
check("Chapter 6: Hellen gives you rooms, Kelyn asks for the Wardens' oath") {
  $messages.clear; FT.hellen(nil); h = FT.flag?(:met_hellen) && FT.flag?(:heard_wall_rule) && $PokemonGlobal.pokecenterMapId == 2053
  FT.kelyn(nil); h && (FT.flag?(:wardens_sworn) || FT.flag?(:wardens_refused)) && FT.flag?(:wardens_emeritus) &&
    $messages.any? { |m| m.include?("Wardens' oath") } && $messages.any? { |m| m.include?("cracked mirror") } }
check("Road A's bosses and items exist") {
  %i[B73H130 B47H439 B439H47].all? { |sp| GameData::Species.exists?(sp) } &&
    %i[FT_BALANUSSEED FT_ROOTKEY FT_DAWNFANG FT_GARAGAIAXE].all? { |it| FT::RELIC_ITEMS[it] } }
check("Luminara's team scales with badges (v0-v2, +3 levels each)") {
  FT.register_scaled(:luminara)
  t = FT::TRAINERS[:luminara]
  l0 = GameData::Trainer.get(t[0], t[1], 0).pokemon.map { |p| p[:level] }
  l2 = GameData::Trainer.get(t[0], t[1], 2).pokemon.map { |p| p[:level] }
  l2.size == l0.size + 1 && l2.max == l0.max + 6 && l2.min >= l0.min + 6 }
check("Road B's gym teams are real Pokémon") {
  %i[hew mira guild_worker_pell guild_worker_rusk].all? { |k| FT::TRAINERS[k][2].all? { |sp, _| GameData::Species.exists?(sp) } } &&
    FT::SCALED_EXTRA.values.all? { |sp, _| GameData::Species.exists?(sp) } }
check("Sporeye only evolves once the godspark is Wyn's") {
  evo = GameData::Species.get(:SPOREYE).evolutions.find { |e| e[0] == :MYCONARCH }
  (FT.state[:flags] || {}).delete(:godspark_shadow) rescue nil
  ok = true
  if defined?(GameData::Evolution)   # (the smoke harness doesn't load the evolution table; the headless run does)
    pr = GameData::Evolution.get(:FTGodspark).level_up_proc; pk = Struct.new(:level).new(40)
    a = pr.call(pk, 36); FT.set_flag(:godspark_shadow); ok = !a && pr.call(pk, 36)
  end
  evo && evo[1] == :FTGodspark && ok }
check("Act III's bosses are real Pokémon (and the Frostmaiden has her own)") {
  %i[CHARDALYN AURIL_CRONE AURIL_REWRITTEN].all? { |sp| GameData::Species.exists?(sp) } &&
    [FT::AURIL_MAIDEN, FT::AURIL_WOMB, :B221H68, :B124H144, :B234H144, :B362H124].all? { |sp| GameData::Species.exists?(sp) } &&
    %i[gunvald jarund tiger_queen still_keeper sephek_saint sopo halo_vigilant eline_sephek].all? { |k| FT::TRAINERS[k][2].all? { |sp, _| GameData::Species.exists?(sp) } } }
check("festival night needs the rite, Glimmer and Hellen's seal") {
  %i[rite_stopped glimmer_joined badge_hearth festival_night].each { |f| (FT.state[:flags] || {}).delete(f) rescue nil }
  a = !FT.festival_ready?
  FT.set_flag(:rite_stopped); FT.set_flag(:glimmer_joined); FT.set_flag(:badge_hearth)
  d = FT.state[:rs_day]; FT.state[:rs_day] = 2
  early = !FT.festival_ready?                 # ...and the seventh night: the downtime week comes first
  FT.state[:rs_day] = FT::FESTIVAL_NIGHT
  b = FT.festival_ready?
  FT.scene_festival_night
  # the roads open only with the Council's summons, after the Rootwardens' night, the scorch and Eirwen
  c = !FT.flag?(:ch7_started); FT.council_summons
  FT.state[:rs_day] = d
  a && early && b && c && FT.flag?(:ch7_started) && FT.flag?(:council_summoned) &&
    (FT.herald?(:wyn) || FT.companions.include?(:wyn)) && !FT.festival_ready? }
check("the Heart takes you to Rootspire only after the Reversal") {
  FT.define_singleton_method(:transfer) { |*a| $ft_transfer = a }
  FT.clear_flag(:reversal) rescue (FT.state[:flags] || {}).delete(:reversal)
  $messages.clear; FT.heart_gateway(nil); before = $messages.none? { |m| m.include?("shard") }
  FT.set_flag(:reversal); $messages.clear; FT.heart_gateway(nil); before && $messages.any? { |m| m.include?("shard") } && $ft_transfer == FT::ARRIVAL_POINT }
check("the mother yeti and the cub are the new yetis") {
  src = File.read(File.join(FT_DIR, "023_Chapter5.rb")) + File.read(File.join(FT_DIR, "044_ChasmFaithful.rb"))
  src.include?("named_mon(:YETITAN, 31") && src.include?("Pokemon.new(:YETOT, 25)") }
check("the Cinderwright line is 582-584") { (582..584).map { |n| GameData::Species.get(n).id } == %i[WICKIT STOKETAIL FORGEL] }
check("Cinderwright is a starter-strength line (309/405/530)") { [tot[:WICKIT], tot[:STOKETAIL], tot[:FORGEL]] == [309, 405, 530] }
check("Forgel is Fire/Steel") { s = GameData::Species.get(:FORGEL); [s.type1, s.type2] == [:FIRE, :STEEL] }
check("Wickit evolves at 16, Stoketail at 36") {
  GameData::Species.get(:WICKIT).evolutions.first[0..2] == [:STOKETAIL, :Level, 16] &&
  GameData::Species.get(:STOKETAIL).evolutions.first[0..2] == [:FORGEL, :Level, 36] }
check("Chikoiard (Chikorita head, Pawniard body) is the Grass starter") { FT::STARTERS.any? { |st| st[:species] == :B330H152 && st[:label] == "Grass" } }
check("the Grass starter evolves at 16 and 36 into Bayiard and Megasharp") {
  FT::STARTER_EVOLUTIONS.values_at(:B330H152, :B330H153, :B331H154) == [[16, :B330H153], [36, :B331H154], nil] }
check("the Ice starter evolves at 16 and 36 into Pilotle and Pilotoise") {
  FT::STARTER_EVOLUTIONS.values_at(:B7H220, :B7H221, :B8H220, :B9H221) == [[16, :B7H221], [36, :B9H221], [36, :B9H221], nil] }
check("the Grass starter's moves exist") { FT::STARTER_MOVES[:B330H152].all? { |m| GameData::Move::DATA[m] } }
check("Wickit is the Fire starter") { FT::STARTERS.any? { |st| st[:species] == :WICKIT && st[:label] == "Fire" } }
check("Tempered is a real ability with its own name") { a = GameData::Ability.get(:TEMPERED); a.name == "Tempered" && a.description.include?("Fire-type") }
hf = GameData::Move.get(:HEARTHFORGE)
check("Hearthforge: Steel, physical, 80 power, 100 accuracy") { [hf.name, hf.type, hf.base_damage, hf.accuracy, hf.category] == ["Hearthforge", :STEEL, 80, 100, 0] }
check("Forgel learns Hearthforge") { GameData::Species.get(:FORGEL).moves.any? { |m| m[1] == :HEARTHFORGE } }
check("every move the new Pokémon learn exists") {
  FT::NEW_SPECIES.keys.all? { |k| GameData::Species.get(k).moves.all? { |m| GameData::Move::DATA[m[1]] } } }
FakeBattler = Struct.new(:raised, :fainted_flag) do
  def pbRaiseStatStageByAbility(stat, n, *_); self.raised = (raised || []) + [[stat, n]]; end
  def pbCanRaiseStatStage?(*); true; end
  def pbRaiseStatStage(stat, n, *_); self.raised = (raised || []) + [[stat, n]]; end
  def fainted?; fainted_flag; end
end
tb = FakeBattler.new([], false)
fire = Struct.new(:calcType).new(:FIRE); water = Struct.new(:calcType).new(:WATER)
BattleHandlers::AbilityOnSwitchIn[:TEMPERED].call(:TEMPERED, tb, nil)
BattleHandlers::TargetAbilityOnHit[:TEMPERED].call(:TEMPERED, nil, tb, water, nil)
BattleHandlers::TargetAbilityOnHit[:TEMPERED].call(:TEMPERED, nil, tb, fire, nil)
BattleHandlers::TargetAbilityOnHit[:TEMPERED].call(:TEMPERED, nil, tb, fire, nil)
check("Tempered raises Defense once, on the first Fire hit") { tb.raised == [[:DEFENSE, 1]] }
SunBattle = Struct.new(:w) { def pbWeather; w; end }
u1 = FakeBattler.new([], false); PokeBattle_Move_FTHearthforge.new(SunBattle.new(:Sun)).pbEffectAfterAllHits(u1, nil)
u2 = FakeBattler.new([], false); PokeBattle_Move_FTHearthforge.new(SunBattle.new(:None)).pbEffectAfterAllHits(u2, nil)
check("Hearthforge raises Defense in sunlight only") { u1.raised == [[:DEFENSE, 1]] && u2.raised.empty? }
check("new Pokémon are numbers 577-588") { (577..588).map { |n| GameData::Species.get(n).id } == %i[LUTLING HAUNTELLO CHORUMBRA RIMIRAGE GLOAMCAP WICKIT STOKETAIL FORGEL SPOREYE MYCONARCH YETOT YETITAN] }
check("new Pokémon are not fusions themselves") { !GameData::Species.get(:LUTLING).is_fusion && !GameData::Species.get(:GLOAMCAP).is_fusion }
check("Wyn's line: Sableye 16 -> Sporeye 36 -> Myconarch, 315/410/530") {
  sab = GameData::Species.get(:SABLEYE); spo = GameData::Species.get(:SPOREYE); myc = GameData::Species.get(:MYCONARCH)
  sab.evolutions.any? { |e| e[0] == :SPOREYE && e[2] == 16 && !e[3] } && spo.evolutions.any? { |e| e[0] == :MYCONARCH && e[2] == 36 && !e[3] } &&
    [tot[:SABLEYE], tot[:SPOREYE], tot[:MYCONARCH]] == [315, 410, 530] && myc.types == [:GHOST, :GRASS] }
check("Wyn's partner is Sableye, a real Infinite Fusion species") { FrostThaw::HERALDS[:wyn][:starter] == :SABLEYE && GameData::Species.exists?(:SABLEYE) }
check("Zorua/Paras lines rebalanced in Frost & Thaw") { [tot[:ZORUA], tot[:ZOROARK], tot[:RIMIRAGE], tot[:PARAS], tot[:PARASECT], tot[:GLOAMCAP]] == [315, 410, 530, 315, 410, 530] }
check("Zoroark evolves into Rimirage at 36") { GameData::Species.get(:ZOROARK).evolutions.first[0..2] == [:RIMIRAGE, :Level, 36] }

# fusing
f = GameData::Species.get(:B577H25)     # Pikachu's head on Lutling's body
check("Pikachu/Lutling fusion exists") { f.is_fusion && f.head_pokemon.id == :PIKACHU && f.body_pokemon.id == :LUTLING }
check("...and is named Pikaling") { f.name == "Pikaling" }
check("...and its number decodes back") { n = f.id_number; getBodyID(n) == 577 && getHeadID(n, 577) == 25 }
r = GameData::Species.get(:B25H577)
check("Lutling/Pikachu fusion is named Lutchu") { r.name == "Lutchu" }
check("fusion of two new Pokémon works") { x = GameData::Species.get(:B581H579); x.is_fusion && x.name == "Chorcap" }
check("getFusionSpecies works with new Pokémon") { getFusionSpecies(:CHORUMBRA, :GENGAR).head_pokemon.id == :GENGAR }
check("a fused Lutling evolves with its body") { f.evolutions.any? { |e| e[0].to_s == "B578H25" } }
check("fusion types come from head and body") { [f.type1, f.type2].include?(:ELECTRIC) && [f.type1, f.type2].include?(:FAIRY) }
fake_game_temp = Struct.new(:custom_sprites_list).new({})
$game_temp_saved = $game_temp; $game_temp = fake_game_temp
$PokemonTemp = Struct.new(:forced_alt_sprites).new(nil)
$PokemonSystem = Struct.new(:alt_sprite_substitutions, :random_sprites).new({}, false)
def get_fusion_spritename(h, b); "#{h}.#{b}"; end
loader = BattleSpriteLoader.new
check("fusion pictures come from Frost & Thaw's folder") {
  loader.select_new_pif_fusion_sprite(25, 577).local_path == "Graphics/Battlers/FrostThaw/fusions/25/25.577" }
check("...in both directions") { loader.obtain_fusion_pif_sprite(577, 25).local_path.end_with?("fusions/577/577.25") }
check("the Grass starter line's pictures come from Frost & Thaw's folder") {
  [[152, 330], [153, 330], [154, 331]].all? { |h, b| loader.select_new_pif_fusion_sprite(h, b).local_path == "Graphics/Battlers/FrostThaw/fusions/#{h}/#{h}.#{b}" } }
check("and those pictures are shipped") {
  [[152, 330], [153, 330], [154, 331]].all? { |h, b| File.exist?(File.expand_path("../build/ft_battlers/fusions/#{h}/#{h}.#{b}.png", __dir__)) } }
check("other fusions are left alone") { s = loader.select_new_pif_fusion_sprite(25, 1); s.local_path.nil? }
def get_random_alt_letter_for_unfused(*); ""; end
check("new Pokémon's own picture") { loader.select_new_pif_base_sprite(579).local_path == "Graphics/Battlers/FrostThaw/base/579" }
check("other base pictures are left alone") { loader.select_new_pif_base_sprite(25).local_path.nil? }
check("new Pokémon cry like the Pokémon they were shaped from") { GameData::Species.check_cry_file(:LUTLING, 0) == "Cries/JIGGLYPUFF" }
check("a Lutling-headed fusion cries like Lutling") { GameData::Species.check_cry_file(:B25H577, 0) == "Cries/JIGGLYPUFF" }
check("everyone else's cries are unchanged") { GameData::Species.check_cry_file(:PIKACHU, 0) == "Cries/PIKACHU" }
FakeMon = Struct.new(:species_data, :shiny_flag) do
  def egg?; false; end
  def shiny?; shiny_flag; end
  def body_shiny; false; end
  def head_shiny; false; end
  def sprite_scale; 1; end
end
class AnimatedBitmap; def scale_bitmap(*); end; end
alias smoke_resolve pbResolveBitmap
def pbResolveBitmap(p); p.include?("FrostThaw/back/") ? p : smoke_resolve(p); end
def pbResolveBitmap_test_orig; end
b = GameData::Species.sprite_bitmap_from_pokemon(FakeMon.new(GameData::Species.get(:LUTLING), false), true)
check("your own Lutling is seen from behind") { b.respond_to?(:path) && b.path.to_s.end_with?("FrostThaw/back/577") }
check("a yeti fusion with a drawn back is seen from behind") {
  sp = (GameData::Species.get(:B580H587) rescue nil)
  (puts "  (skipped: no fused species offline)"; next true) if sp.nil?
  r = GameData::Species.sprite_bitmap_from_pokemon(FakeMon.new(sp, false), true)
  r.respond_to?(:path) && r.path.to_s.end_with?("FrostThaw/back/fusions/587/587.580") }
check("fused or other Pokémon keep the normal picture") {
  r = (GameData::Species.sprite_bitmap_from_pokemon(FakeMon.new(GameData::Species.get(:PIKACHU), false), true) rescue :orig)
  !(r.respond_to?(:path) && r.path.to_s.include?("FrostThaw/back")) }
$game_temp = $game_temp_saved
FT.apply_species_patches(false)
check("originals restored for Infinite Fusion saves") { tot[:ZOROARK] == 510 && tot[:PARAS] == 285 && tot[:SABLEYE] == 380 && GameData::Species.get(:SABLEYE).evolutions.empty? && NB_POKEMON == 576 }
ft_save = PokemonGlobalMetadata.new; ft_save.frost_thaw = { active: true }
$fake_save = { global_metadata: ft_save }
PokemonLoadScreen.new.load_save_file("x")
check("the Continue screen sizes the Pokédex for a Frost & Thaw save") { NB_POKEMON == 591 }
$fake_save = { global_metadata: PokemonGlobalMetadata.new }
PokemonLoadScreen.new.load_save_file("x")
check("...and for an Infinite Fusion save") { NB_POKEMON == 576 }
keep_global = $PokemonGlobal
SaveData.load_all_values({ global_metadata: ft_save })
check("loading a Frost & Thaw save switches the new Pokémon on") { NB_POKEMON == 591 && tot[:ZOROARK] == 410 }
SaveData.load_all_values({ global_metadata: keep_global })
check("Alberica's NPC is hidden when you are Alberica") { $game_switches[3901] == true && $game_switches[3902] == false }

# every dialogue key resolves to strings, in each mode and story state
all_ok = true
[[:herald, :alberica], [:herald, :reptin], [:journey, nil]].each do |mode, h|
  [false, true].each do |met|
    FT.state[:mode] = mode; FT.state[:herald] = h
    FT.state[:flags] = { met_party: met, badge_targos: met }
    FT::TEXT.each_key do |k|
      l = FT.lines_for(k)
      all_ok &&= l.is_a?(Array) && !l.empty? && l.all? { |s| s.is_a?(String) }
    end
  end
end
check("all dialogue resolves in every mode and story state") { all_ok }
FT.state[:mode] = :herald; FT.state[:herald] = :alberica; FT.state[:flags] = {}
check("Epheris recognizes the pendant only for Alberica") { FT.lines_for(:epheris_thornweald).join.include?("pendant") }
FT.state[:herald] = :reptin
check("...and not for Reptin") { !FT.lines_for(:epheris_thornweald).join.include?("pendant") }

# map events reference only things that exist
require "json"
maps = Dir[File.expand_path("../build/maps/Map*.json", __dir__)]
keys_used = []
scripts_needed = []
Dir[File.expand_path("../build/maps/Map*.rxdata", __dir__)].each do |f|
  require File.expand_path("../tools/rgss_stub", __dir__) unless defined?(RPG::Generic)
end
require File.expand_path("../tools/rgss_stub", __dir__)
Dir[File.expand_path("../build/maps/Map*.rxdata", __dir__)].each do |f|
  m = Marshal.load(File.binread(f))
  m.events.each_value do |e|
    e.pages.each do |pg|
      src = pg.list.select { |c| [355, 655].include?(c.code) }.map { |c| c.parameters[0] }.join("\n")
      src.scan(/FT\.(talk|trainer|scene|gym_leader|mart)\(:(\w+)/) { |kind, key| keys_used << [kind, key.to_sym, File.basename(f)] }
      pg.list.select { |c| c.code == 201 }.each { |c| scripts_needed << [c.parameters[1], c.parameters[2], c.parameters[3], File.basename(f)] }
    end
  end
end
missing = keys_used.select do |kind, key, _|
  case kind
  when "talk" then !FT::TEXT.key?(key)
  when "trainer" then !FT::TRAINERS.key?(key)
  when "scene" then ![:intro, :targos_arrival, :tavern_convergence].include?(key) && !FT.respond_to?("scene_#{key}")
  when "gym_leader" then !FT.respond_to?("leader_#{key}")
  when "mart" then !FT::MARTS.key?(key)
  end
end
check("every map event's dialogue/trainer/scene exists (#{keys_used.size} refs)") { missing.empty? || (puts missing.inspect; false) }
check("every door leads to a map that exists") {
  bad = scripts_needed.reject { |id, *_| id < 2000 || File.exist?(File.expand_path(format("../build/maps/Map%04d.rxdata", id), __dir__)) }
  bad.empty? || (puts bad.inspect; false) }
check("every map is named") { (2000..2018).all? { |i| FT::MAP_NAMES[i] } && (2020..2029).all? { |i| FT::MAP_NAMES[i] } }
check("every built map has a name in the game") {
  Dir[File.expand_path("../build/maps/Map*.rxdata", __dir__)].all? { |f| FT::MAP_NAMES[f[/Map(\d+)/, 1].to_i] } }

# the Ten-Towns side quests (W2: 045_*.rb, maps 2120-2139, switches 4040-4079)
calls = []
Dir[File.expand_path("../build/maps/Map*.rxdata", __dir__)].each do |f|
  Marshal.load(File.binread(f)).events.each_value do |e|
    e.pages.each { |pg| pg.list.select { |c| [355, 655].include?(c.code) }.each { |c| c.parameters[0].scan(/FT\.(\w+[?!]?)\(/) { |(m)| calls << [m, File.basename(f)] } } }
  end
end
check("every FT method a map event calls exists (#{calls.size} calls)") {
  bad = calls.reject { |m, _| FT.respond_to?(m) }.uniq
  bad.empty? || (puts bad.inspect; false) }
w2_src = Dir[File.expand_path("../game/Data/Scripts/998_FrostThaw/045_*.rb", __dir__)].map { |f| File.read(f, encoding: "UTF-8") }.join("\n")
check("the Ten-Towns quests' switches are all 4040-4079, and distinct") {
  sws = w2_src.scan(/^\s*(SW_[A-Z_]+)\s*=\s*(\d{4})/).map { |n, v| [n, v.to_i] }
  sws.size > 30 && sws.all? { |_, v| (4040..4079).cover?(v) } && sws.map(&:last).uniq.size == sws.size }
check("the Ten-Towns maps are built and named") {
  [*2120..2137].all? { |id| FT::MAP_NAMES[id] && File.exist?(File.expand_path(format("../build/maps/Map%04d.rxdata", id), __dir__)) } }
check("every Pokémon the Ten-Towns quests send at you exists") {
  sp = w2_src.scan(/(?:named_mon|pbWildBattle)\(:(\w+)/).flatten.uniq
  bad = sp.reject { |s| GameData::Species.try_get(s.to_sym) || s =~ /\AB\d+H\d+\z/ }
  bad.empty? || (puts bad.inspect; false) }
check("every Frost & Thaw item the Ten-Towns quests give or take is registered") {
  it = w2_src.scan(/(?:give_key|take_key|pbReceiveItem|pbHasItem\?)\(:(FT_\w+)/).flatten.uniq
  bad = it.reject { |i| FT::RELIC_ITEMS.key?(i.to_sym) }
  bad.empty? || (puts bad.inspect; false) }
check("Lonelywood is reached through Termalaine, not straight from Bryn Shander") {
  lr = Marshal.load(File.binread(File.expand_path("../build/maps/Map2020.rxdata", __dir__)))
  to = lr.events.values.flat_map { |e| e.pages.flat_map { |pg| pg.list.select { |c| c.code == 201 }.map { |c| c.parameters[1] } } }.uniq
  to.include?(2120) && !to.include?(2012) }

# party chat
FT.state[:companions] = [:alberica, :reptin, :alerion, :shade, :shimmer]
FT.state[:herald] = :reptin
check("Reptin doesn't talk to himself") { !FT.companions.include?(:reptin) && FT.companions.size == 4 }
ok = true
FT::PARTY_CHAT.each { |c, areas| areas.each_value { |v| r = FT.resolve(v); ok &&= r.is_a?(Array) && r.all? { |s| s.is_a?(String) } } }
check("all party chat resolves") { ok }
saved_goal = FT.state[:goal]
FT.state[:goal] = nil
saved_sides = FT.state[:side_goals]          # (the Council gives every mode the Wall goal now: start this check without it)
FT.state[:side_goals] = {}
$menu_ret = [3, 4]
cmds = ["  <icon=menuIcons/POKEMON>  Pokémon", "  <icon=menuIcons/BAG>  Bag", "  <icon=menuIcons/PLAYER>  Name", "Save", "Options"]
$next_choice = 99
r = PokemonPauseMenu_Scene.new.pbShowCommands(cmds)
check("pause menu gains Heralds after the trainer entry") { $shown[3].include?("Heralds") }
check("choosing Heralds opens chat, then later choices map back correctly") { r == 3 }
FT.state[:goal] = "Get to the College at the top of the tree."
$menu_ret = [3, 4, 5]
$messages.clear
r = PokemonPauseMenu_Scene.new.pbShowCommands(cmds)
check("with a goal, the pause menu shows Goal, then Heralds, after the trainer entry") {
  $shown[3].include?("Goal") && $shown[4].include?("Heralds") }
check("choosing Goal shows it; later choices still map back correctly") {
  r == 3 && $messages.any? { |m| m.to_s.include?("Get to the College") } }
FT.state[:goal] = saved_goal
FT.state[:side_goals] = saved_sides

# bag
bag = PokemonBag.new
check("pockets hold 20 kinds in Frost & Thaw") { bag.maxPocketSize(1) == 20 }
check("Key Items never fill up") { bag.maxPocketSize(8) == -1 }
check("TMs never fill up") { bag.maxPocketSize(4) == -1 }
bag.full = true
$messages.clear
check("a full pocket sends the item to the PC") { bag.pbStoreItem(:POTION, 1) && $PokemonGlobal.pcItemStorage }
FT.state[:active] = false
check("normal saves keep the unlimited bag") { bag.maxPocketSize(1) == -1 }
FT.state[:active] = true

# new game choice
$next_choice = 0
check("New Game still starts Infinite Fusion when chosen") { Game.start_new == :orig }

# --- Chapter 2: Razzy ----------------------------------------------------------
check("every trainer's Pokémon exists (fusions too)") {
  bad = FT::TRAINERS.flat_map { |k, (_, _, party)| party.map(&:first) }.uniq.reject { |sp| (GameData::Species.get(sp) rescue nil) }
  bad.empty? || (puts bad.inspect; false) }
check("every wild Pokémon exists") {
  sp = FT::ENCOUNTERS.values.flat_map { |e| e.reject { |k, _| k == :step_chances }.values.flatten(1).map { |s| s[1] } } +
       FT::VERSION_ENCOUNTERS.values.flat_map { |v| v.values.flat_map { |e| e.values.flatten(1).map { |s| s[1] } } }
  bad = sp.uniq.reject { |x| GameData::Species.get(x) rescue false }
  bad.empty? || (puts bad.inspect; false) }
check("Speaker Duvessa is Steel/Normal-themed with 3 fusions") {
  t = GameData::Trainer.get(:FT_SPEAKER_F, "Duvessa", 0); t.pokemon.size == 3 && t.pokemon.all? { |pk| pk[:species].to_s.start_with?("B") } }
FT.register_encounters
enc = PokemonEncounters.new
FT.state[:version] = :frost
enc.setup(2010); FT.add_version_encounters(enc.encounter_tables, 2010)
check("North Road has wild Pokémon, with Gastly in Frost") { enc.encounter_tables[:Land].any? { |s| s[1] == :GASTLY } && enc.encounter_tables[:Land].none? { |s| s[1] == :VULPIX } }
FT.state[:version] = :thaw
enc.setup(2010); FT.add_version_encounters(enc.encounter_tables, 2010)
check("...and Vulpix in Thaw") { enc.encounter_tables[:Land].any? { |s| s[1] == :VULPIX } && enc.encounter_tables[:Land].none? { |s| s[1] == :GASTLY } }
enc.setup(2011)
check("the Frost-Light Chasm is a cave") { enc.encounter_tables[:Cave].size >= 4 }
def pbTrainerBattle(*); $battle_result; end
def pbReceiveItem(i, *); $received = i; true; end
def pbSEPlay(*); end
class TrainerStub; attr_accessor :badges, :name; def initialize; @badges = [false] * 8; @name = "Tester"; end; end
class PlayerStub; attr_accessor :moved; def turn_down; end; def move_down; @moved = true; end; end
$Trainer = TrainerStub.new
$game_player = PlayerStub.new
scene_ok = true
[[:herald, :alberica], [:herald, :reptin], [:herald, :meat_meat], [:herald, :shimmer], [:journey, nil]].each do |mode, h|
  FT.state[:mode] = mode; FT.state[:herald] = h; FT.state[:flags] = { met_party: true, badge_targos: true }
  FT.state[:companions] = [:alberica, :reptin, :alerion, :shade, :shimmer]
  $messages.clear
  %i[scene_north_road_start scene_razzy_appears scene_frostlight_enter scene_razzy_falls scene_bryn_arrival lottery_night].each do |k|
    begin
      FT.send(k)
    rescue StandardError => e
      scene_ok = false; puts "  #{h || mode} #{k}: #{e.class}: #{e.message}"
    end
  end
  scene_ok &&= $messages.all? { |m| m.is_a?(String) && !m.include?("#<") } && FT.flag?(:razzy_egg) && FT.flag?(:seen_sephek_bryn)
end
check("Chapter 2 scenes play in every mode") { scene_ok }
FT.state[:mode] = :herald; FT.state[:herald] = :reptin
FT.state[:flags] = { met_party: true, badge_targos: true, met_razzy: true, razzy_egg: true }
$messages.clear; FT.scene_razzy_appears
check("Razzy appears only once") { $messages.empty? }
FT.state[:herald] = :meat_meat; FT.state[:flags] = { met_party: true }
$messages.clear; FT.scene_razzy_falls
check("as Meat Meat you speak Razzy's name") { $messages.join.include?("His name is Razzy") && FT.flag?(:razzy_named) }
FT.state[:herald] = :alberica; FT.state[:flags] = { met_party: true, met_razzy: true }
$game_player.moved = false
FT.razzy_block
check("the party won't leave Razzy behind") { $game_player.moved }
FT.set_flag(:razzy_egg); $game_player.moved = false
FT.razzy_block
check("...until the egg is safe") { !$game_player.moved }
$game_switches = {}
FT.state[:flags] = { met_party: true, badge_targos: true, lottery_stand: true }
$battle_result = true
$messages.clear
FT.leader_duvessa(nil)
check("beating Duvessa gives the second badge and Steel Wing, and opens the north gate") { $Trainer.badges[1] && FT.flag?(:badge_bryn) && $messages.any? { |m| m.to_s.include?("Steel Wing") } && $game_switches[3912] && $game_switches[3913] }
check("...and Mishann brings Reptin the golden acorn on the hall steps (the third way can't go missing)") { FT.flag?(:golden_acorn) && $received == :FT_GOLDENACORN }
FT.state[:flags] = { met_party: true, badge_targos: true }; $messages.clear; FT.leader_duvessa(nil)
check("...but not before the lottery (SC 2.08)") { !FT.flag?(:badge_bryn) && $messages.join.include?("draw night") }
FT.state[:flags] = {}
$messages.clear
FT.leader_duvessa(nil)
check("Duvessa wants Naerth's seal first") { $messages.join.include?("Naerth's first") }
$game_switches = {}
FT.state[:flags] = { badge_targos: true }
FT.apply_story_switches
check("older saves with Naerth's seal get the North Road opened") { $game_switches[3910] }
d_ok = true
[[:herald, :alberica], [:herald, :reptin], [:herald, :meat_meat], [:journey, nil]].each do |mode, h|
  [{}, { met_party: true, badge_targos: true, razzy_egg: true, seen_sephek_bryn: true }].each do |fl|
    FT.state[:mode] = mode; FT.state[:herald] = h; FT.state[:flags] = fl
    FT::TEXT.each_key { |k| l = FT.lines_for(k); d_ok &&= l.is_a?(Array) && !l.empty? && l.all? { |x| x.is_a?(String) } }
    FT::PARTY_CHAT.each_value { |areas| areas.each_value { |v| r = FT.resolve(v); d_ok &&= r.is_a?(Array) && r.all? { |x| x.is_a?(String) } } }
  end
end
check("Chapter 2 dialogue resolves in every mode and story state") { d_ok }
check("every Chapter 2 area has party chat for each companion") {
  %i[north_road chasm bryn bryn_hall northlook].all? { |a| %i[alberica reptin alerion shade shimmer].all? { |c| FT::PARTY_CHAT[c][a] } } }

# --- Chapter 3: Shimmer's Requiem ----------------------------------------------
def pbConfirmMessage(t); $messages << t; true; end
def pbFadeOutIn; yield; end
class TrainerStub; attr_accessor :healed; def heal_party; @healed = true; end; end
c3_ok = true
[[:herald, :alberica], [:herald, :reptin], [:herald, :meat_meat], [:journey, nil]].each do |mode, h|
  FT.state[:mode] = mode; FT.state[:herald] = h
  FT.state[:flags] = { met_party: true, badge_targos: true, badge_bryn: true, razzy_egg: true, seen_sephek_bryn: true }
  FT.state[:companions] = [:alberica, :reptin, :alerion, :shade, :shimmer]
  $game_switches = {}
  $messages.clear
  $battle_result = true
  begin
    FT.scene_lonely_road_start; FT.scene_lonelywood_arrival
    FT.nimsy(nil)                       # (no bed yet: Sephek first, context 03 M3-2)
    c3_ok &&= !FT.flag?(:shimmer_taken)
    FT.sephek_torgs(nil)
    FT.nimsy(nil)
    FT.scene_glade_aftermath
    FT.scene_moon_grounds_arrival
    FT.scene_sephek_moon_temple(nil)
    FT.scene_warren_enter
    FT.zenith(nil)
  rescue StandardError => e
    c3_ok = false; puts "  #{h || mode}: #{e.class}: #{e.message} #{e.backtrace.first}"
  end
  c3_ok &&= FT.flag?(:shimmer_taken) && FT.flag?(:heart_of_ice) && FT.flag?(:sephek_defeated) && FT.flag?(:requiem_done)
  c3_ok &&= !FT.state[:companions].include?(:shimmer)
  c3_ok &&= (h == :meat_meat) || FT.state[:companions].include?(:meat_meat)
  c3_ok &&= $game_switches[3914] && $PokemonGlobal.pokecenterMapId == 2021 && $Trainer.healed
  c3_ok &&= $messages.all? { |m| m.is_a?(String) && !m.include?("#<") }
end
check("Chapter 3 plays through in every mode") { c3_ok }
FT.state[:mode] = :journey; FT.state[:herald] = nil
FT.state[:flags] = { heart_of_ice: true }
$battle_result = false
FT.scene_sephek_moon_temple(nil)
check("losing to Sephek lets you try again") { !FT.flag?(:sephek_defeated) }
FT.state[:flags] = {}
$messages.clear; FT.zenith(nil)
check("Zenith speaks in verse until you bring the heart") { $messages.join.include?("rose will know") && !FT.flag?(:requiem_done) }
d3 = true
[[:herald, :alberica], [:herald, :meat_meat], [:journey, nil]].each do |mode, h|
  [{}, { shimmer_taken: true, heart_of_ice: true, sephek_defeated: true, requiem_done: true, rested_lonelywood: true }].each do |fl|
    FT.state[:mode] = mode; FT.state[:herald] = h; FT.state[:flags] = fl
    FT.state[:companions] = [:alberica, :reptin, :alerion, :shade, :meat_meat]
    FT::TEXT.each_key { |k| l = FT.lines_for(k); d3 &&= l.is_a?(Array) && !l.empty? && l.all? { |x| x.is_a?(String) } }
    FT::PARTY_CHAT.each_value { |areas| areas.each_value { |v| r = FT.resolve(v); d3 &&= r.is_a?(Array) && r.all? { |x| x.is_a?(String) } } }
  end
end
check("Chapter 3 dialogue resolves in every mode and story state") { d3 }
FT.state[:version] = :frost
enc.setup(2020); FT.add_version_encounters(enc.encounter_tables, 2020)
check("Lonelywood Road has wild Pokémon (Misdreavus in Frost)") { enc.encounter_tables[:Land].any? { |s| s[1] == :MISDREAVUS } }

leaders = %i[naerth duvessa sephek durmoot hag thredra avarice]
check("every trainer says something when they challenge you") {
  missing = FT::TRAINERS.keys - leaders - FT::TRAINER_INTROS.keys
  missing.empty? || (puts missing.inspect; false) }
$messages.clear; $battle_result = true
FT.trainer(:hiker_tor, nil)
check("...and says it before the battle starts") { $messages.first.to_s.start_with?("TOR:") }

# --- Targos: wild Pokémon, the widow's Spheal, sparring, Kip's Cups ------------
enc.setup(2001)
check("the Commons in Targos have wild Pokémon") {
  t = enc.encounter_tables[:Land]; t && t.size >= 5 && t.all? { |s| GameData::Species.exists?(s[1]) } }
check("sparring partners use real species") {
  FT::SPARRING.values.all? { |i| i[:pools].flatten.all? { |sp| GameData::Species.exists?(sp) } } }
Mon = Struct.new(:level)
class TrainerStub; attr_accessor :money, :party; def badge_count; @badges.count(true); end; end
$Trainer.money = 0; $Trainer.party = [Mon.new(7)]
module Settings; NO_MONEY_LOSS = 33; end unless defined?(Settings::NO_MONEY_LOSS)
$battle_args = nil
def pbTrainerBattle(*a); $battle_args = a; $battle_result; end
FT.state[:flags] = {}
$battle_result = false; $messages.clear
FT.spar(:spar_jod, nil)
t = GameData::Trainer.get(:WORKER, "Jod", 0)
check("a spar matches your best Pokémon's level") { t.pokemon.map { |pk| pk[:level] }.max == 7 }
check("losing a spar is allowed and costs no money") { $battle_args[5] == true && !$game_switches[33] }
$Trainer.party = [Mon.new(34), Mon.new(20)]; $Trainer.badges = [true] * 4
FT.spar(:spar_tess, nil)
t = GameData::Trainer.get(:PICNICKER, "Tess", 0)
check("spars grow with you (evolved team, more members)") { t.pokemon.size == 3 && t.pokemon.any? { |pk| pk[:species] == :MAMOSWINE } }
$Trainer.badges = [false] * 8
$got = nil
def pbAddPokemon(sp, lv = 1, *); $got = [sp, lv]; true; end
FT.widow_gift(nil); first = $got; $got = nil; FT.widow_gift(nil)
check("the widow gives her husband's Spheal once") { first == [:SPHEAL, 6] && $got.nil? && FT.flag?(:widow_spheal) }

# an older save with Naerth's seal: the gate guards step aside straight away
FT.state[:flags][:badge_targos] = true; $game_switches[3910] = false
$game_map = MapStub.new(2001); Events.onMapSceneChange.trigger(nil, nil)
check("with Naerth's seal the Targos guards step aside on the spot") { $game_switches[3910] && $game_map.need_refresh }
$game_map.need_refresh = false; Events.onMapSceneChange.trigger(nil, nil)
check("...even in a save where the switch was already on but the guards were saved blocking") { $game_map.need_refresh }
FT.state[:flags].delete(:badge_targos)

# Infinite Fusion ignores switches without a name; ours must still count
class Game_Event
  def switchIsOn?(id); name = ($data_system_switches || [])[id]; return false if !name; $game_switches[id]; end
end
load File.join(FT_DIR, "019_Switches.rb")
$game_switches[3910] = true; $game_switches[5] = true
ge = Game_Event.allocate
check("map people obey Frost & Thaw's story switches") { ge.switchIsOn?(3910) == true }
$game_switches[3910] = false
check("...and see them turn off again") { ge.switchIsOn?(3910) == false }
check("Infinite Fusion's own switches behave as before") { ge.switchIsOn?(5) == false }

# Twinning: Naerth hands out DNA Splicers, then the shops sell them
$got_items = []
def pbReceiveItem(i, q = 1, *); $got_items << [i, q]; true; end
def pbPokemonMart(stock, *); $stock = stock; end
FT.state[:flags] = { met_party: true, naerth_terms: true }; $battle_result = true; $messages.clear
FT.mart(:targos)
check("no DNA Splicers in the shop before Naerth's seal") { !$stock.include?(:DNASPLICERS) }
FT.leader_naerth(nil)
check("beating Naerth gives you DNA Splicers") { $got_items.include?([:DNASPLICERS, 3]) && FT.flag?(:got_splicers) }
FT.mart(:targos); a = $stock; FT.mart(:bryn)
check("...and every shop sells them afterwards") { a.include?(:DNASPLICERS) && $stock.include?(:DNASPLICERS) && !FT::MARTS[:targos].include?(:DNASPLICERS) }
$got_items.clear; FT.state[:flags] = { met_party: true, badge_targos: true }
FT.leader_naerth(nil); FT.leader_naerth(nil)
check("a save that beat him earlier gets them by talking to him, once") { $got_items.count { |i, _| i == :DNASPLICERS } == 1 }

# every item the scripts sell, give or hand to trainers is a real Infinite Fusion item
module MessageTypes; Items = 30; ItemPlurals = 31; ItemDescriptions = 32; end
load File.join(GAME, "Data/Scripts/010_Data/002_PBS data/006_Item.rb")
raw = File.binread(File.join(GAME, "Data/items.dat"))
idata = (Marshal.load(raw) rescue Marshal.load(Encryption.xor(raw)))
GameData::Item::DATA.merge!(idata)
FT.register_relic_items
src = Dir[File.join(FT_DIR, "*.rb")].map { |f| File.read(f, encoding: "UTF-8") }.join("\n")
item_refs = []
src.scan(/MARTS(?:\[:\w+\])?\s*=\s*(\{.*?\n\s*\}|\[[^\]]*\])/m) { |(body)| item_refs += body.scan(/:([A-Z][A-Z0-9_]+)/).flatten }
item_refs += src.scan(/pbReceiveItem\(:([A-Z0-9_]+)/).flatten
item_refs += src.scan(/pbStoreItem\(:([A-Z0-9_]+)/).flatten
item_refs += src.scan(/\bgive\(:([A-Z0-9_]+)/).flatten
item_refs += src.scan(/\]\],\s*\n?\s*"[^"]*",\s*\[([^\]]*)\]/m).flatten.join(" ").scan(/:([A-Z0-9_]+)/).flatten
item_refs += %w[DNASPLICERS]
item_refs += FT::TRAINERS.values.flat_map { |t| Array(t[4]).map(&:to_s) }
bad_items = item_refs.uniq.reject { |k| GameData::Item::DATA.key?(k.to_sym) } - %w[UNKNOWN]
puts item_refs.uniq.sort.join(" ") if ENV["SHOW_ITEMS"]
check("every item in shops, gifts and trainer bags exists (#{item_refs.uniq.size} checked)") { bad_items.empty? || (puts bad_items.inspect; false) }

# the Pokédex and snowshoes are handed to you in Targos, not at the start
check("a new game starts without the Pokédex or running shoes") {
  src = File.read(File.join(FT_DIR, "005_NewGame.rb")); src.include?("has_pokedex = false") && !src.include?("runningShoes = true") }
class TrainerStub; attr_accessor :has_pokedex, :has_running_shoes; end
$Trainer.has_pokedex = false; $Trainer.has_running_shoes = false
%i[got_pokedex got_snowshoes].each { |f| FT.state[:flags].delete(f) }
$messages.clear; FT.epheris(nil)
check("Epheris gives you the Pokédex") { $Trainer.has_pokedex && $messages.any? { |m| m.include?("received the Pokédex") } }
$messages.clear; FT.epheris(nil)
check("...only once") { $messages.none? { |m| m.include?("received the Pokédex") } }
$messages.clear; FT.snowshoes(nil)
check("the trapper gives you snowshoes to run with") { $Trainer.has_running_shoes && $messages.any? { |m| m.include?("Snowshoes") } }
$messages.clear; FT.snowshoes(nil)
check("...only once") { $messages.none? { |m| m.include?("got the Snowshoes") } }
FT.state[:flags].delete(:got_pokedex); $messages.clear; FT.epheris(nil)
check("an older save that already has a Pokédex isn't given another") { $messages.none? { |m| m.include?("received the Pokédex") } && FT.flag?(:got_pokedex) }

# Kip's Cups, played headless with stand-ins for the screen
class Bitmap; attr_reader :font; def initialize(*); @font = Struct.new(:color).new; end
  def fill_rect(*); end; def clear; end; def draw_text(*); end; def dispose; end; end unless defined?(Bitmap)
class Viewport; attr_accessor :z; def initialize(*); end; def dispose; end; end unless defined?(Viewport)
class Sprite; attr_accessor :bitmap, :x, :y, :z, :ox, :oy, :zoom_x, :zoom_y, :opacity, :visible
  def initialize(*); end; def dispose; end; end unless defined?(Sprite)
module Graphics; def self.width; 512; end; def self.height; 384; end; def self.update; $frames += 1; end; end
module Input; LEFT = 4; RIGHT = 6; USE = 13; BACK = 12; @q = []
  def self.queue=(q); @q = q; end; def self.update; @cur = @q.shift; end; def self.trigger?(k); @cur == k; end; end
def pbSetSystemFont(*); end; def pbPlayCursorSE; end; def pbPlayDecisionSE; end; def pbMEPlay(*); end
%w[cup cup_table cup_shadow cup_arrow].each { |f| check("cup game picture #{f} exists") { File.exist?(File.expand_path("../build/cups/#{f}.png", __dir__)) } }
logic = (0...200).all? do |seed|
  g = FT::CupGame.new(8, 4, Random.new(seed)); ball = g.ball_cup
  g.plan.each { |a, b| g.apply_swap(a, b) }
  g.slot_of.sort == [0, 1, 2] && [0, 1, 2].count { |sl| g.correct?(sl) } == 1 && g.cup_in(g.slot_of[ball]) == ball
end
check("the cups always hide exactly one ball and follow the swaps") { logic }
# play the real animation: steer to the right cup, and to a wrong one
def play_to(target_slot_from_game)
  $frames = 0
  g = FT::CupGame.new(5, 6, Random.new(7))
  g.plan.each { |a, b| }   # plan fixed by the seed
  sim = FT::CupGame.new(5, 6, Random.new(7)); sim.plan.each { |a, b| sim.apply_swap(a, b) }
  goal = target_slot_from_game.call(sim)
  keys = Array.new(400, nil)
  presses = [Input::LEFT] * 2 + [Input::RIGHT] * goal + [Input::USE]
  start = 10 + 12 + 40 + 12 + 10 + 5 * 6 + 2
  presses.each_with_index { |k, i| keys[start + i * 2] = k }
  Input.queue = keys
  [g.play, $frames]
end
won, frames = play_to(->(sim) { sim.slot_of[sim.ball_cup] })
check("following the ball wins the cup game (#{frames} frames)") { won == true }
lost, = play_to(->(sim) { (sim.slot_of[sim.ball_cup] + 1) % 3 })
check("pointing at the wrong cup loses") { lost == false }
# the table: betting, payouts, and the free round when broke
class FT::CupGame; def play; $cup_win; end; end
$Trainer.money = 300; $cup_win = true
def pbMessage(t, cmds = nil, *_); $messages << t; cmds ? 1 : 0; end           # bet $200
$confirms = [false]
def pbConfirmMessage(t); $messages << t; $confirms.shift; end
FT.cup_game(nil)
check("winning a $200 bet pays $400") { $Trainer.money == 500 }
$Trainer.money = 10; $cup_win = true; FT.cup_game(nil)
check("broke players get a free round worth $200") { $Trainer.money == 210 }
$Trainer.money = 10; $cup_win = false; FT.cup_game(nil)
check("losing the free round costs nothing") { $Trainer.money == 10 }
check("Kip's lines read cleanly") { $messages.all? { |m| m.is_a?(String) && !m.include?("#<") } }

check("the loop keeps nothing of the story but the loop") {
  FT.set_flag(:act1_done); FT.state[:counters] ||= {}
  FT.define_singleton_method(:transfer) { |*a| $ft_transfer = a }
  FT.start_loop
  !FT.flag?(:act1_done) && FT.counter(:loop_count) >= 1 && FT.flag?(:in_loop) }

def pbMessage(t, cmds = nil, *_); $messages << t; cmds ? ($next_choice || 0) : 0; end
FT.state[:mode] = :herald; FT.state[:herald] = :alerion
$messages.clear; $next_choice = 1
r = FT.speak(:alerion, "(flat) No.", "...Fine.")
check("as a Herald you pick how to say their line") { r == 1 && $messages.include?("(...Fine.)") && $messages.include?("(You say...)") }
FT.state[:herald] = :reptin; $messages.clear
FT.speak(:alerion, "(flat) No.", "...Fine.")
check("...and the others just say theirs") { $messages == ["ALERION: (flat) No."] }
FT.state[:herald] = :alerion; $messages.clear; $next_choice = 0
check("a stage direction on your own line reads as narration") { FT.as(:alerion, "(a hand on her neck) Mine.") == "A hand on her neck. (Mine.)" }
$next_choice = nil

# --- Act I in full (W1: the Cackling Chasm and Sephek) ----------------------------
FT.state[:mode] = :journey; FT.state[:herald] = nil
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
check("the chasm's new keepsakes are real items") {
  %i[FT_GRAYSTAFF FT_WOLFPELT FT_ORDERDAGGER FT_DRUIDCODEX FT_HEARTSHARD FT_WOLFBLOOM FT_OWLFEATHER
     FT_GLIMMERJOURNAL FT_OPAL FT_GEMSTONE FT_BLACKICERING FT_GNOLLAXE].all? { |k| FT::RELIC_ITEMS.key?(k) } }
check("...and the readable ones can be read from the bag") {
  %i[FT_DRUIDCODEX FT_HEARTSHARD FT_WOLFBLOOM FT_OWLFEATHER FT_GLIMMERJOURNAL].all? { |k| FT::RELIC_ITEMS[k][5] == 2 } }
check("the rift floor is a real map") { FT::MAPS[:rift_floor] == 2100 && FT::MAP_NAMES[2100] == "The Rift Floor" }
check("Torrga, her hand and the Winter-Crowned hag are trainers") {
  %i[torrga torg_hand thredra_crown].all? { |k| FT::TRAINERS.key?(k) } }
(FT.state[:flags] || {}).delete(:ghost_blessing)
check("the Order's locket is only a portrait until the ghost rests") { FT.locket_description.include?("never been here") }
FT.set_flag(:ghost_blessing)
check("...then it smiles, and blesses") { FT.locket_description.include?("smiles") }
(FT.state[:flags] || {}).delete(:ghost_blessing)
$messages.clear; $next_choice = 0
FT.hag_bargain_offer(nil)
check("the hag makes her bargain at the Stones: the winter and Reptin's wolf") {
  FT.flag?(:hag_bargain_offered) && FT.flag?(:reptin_tempted) &&
    $messages.any? { |m| m.include?("end the winter") } && $messages.any? { |m| m.include?("take the wolf out of him") } }
check("...and asking about the task is remembered") { FT.flag?(:asked_hag_task) }
check("the chasm's new lines all resolve") {
  %i[fallen_ice blood_runes chasm_coins gnoll_axe_left gnoll_remains gnoll_quiet rift_wisp_light walker_after
     heart_cauldron heart_cauldron_after codex_shelf codex_shelf_after torgs_flag torgs_dogs torgs_hand_idle
     torgs_camp_gone mother_yeti_after].all? { |k| FT.lines_for(k).first != "..." } }
FT.set_flag(:yeti_mother_dead)
check("a mother yeti who fought to the death stays dead") { FT.lines_for(:mother_yeti_after).first.include?("doesn't move") }
(FT.state[:flags] || {}).delete(:yeti_mother_dead)
FT.set_flag(:cub_home); FT.set_flag(:got_yeti_cub)
check("...and if you took her cub, she isn't shown curled round it") { !FT.lines_for(:mother_yeti_after).first.include?("curled around her cub") }
%i[cub_home got_yeti_cub].each { |f| (FT.state[:flags] || {}).delete(f) }
check("every chasm whisper speaks once") {
  $messages.clear; FT.chasm_whisper(1); n = $messages.size; FT.chasm_whisper(1); n > 0 && $messages.size == n }
$next_choice = nil
# W4 (the faithful build-out): every story function a map event calls exists,
# and the White Vault's sigils behave
calls = []
Dir[File.expand_path("../build/maps/Map*.rxdata", __dir__)].each do |f|
  Marshal.load(File.binread(f)).events.each_value do |e|
    e.pages.each do |pg|
      src = pg.list.select { |c| [355, 655].include?(c.code) }.map { |c| c.parameters[0] }.join("\n")
      src.scan(/FT\.(\w+[?!]?)/) { |(fn)| calls << [fn, File.basename(f), e.name] }
    end
  end
end
missing_fns = calls.reject { |fn, _, _| FT.respond_to?(fn) }.uniq
check("every story function a map event calls exists (#{calls.size} calls)") { missing_fns.empty? || (puts missing_fns.inspect; false) }
check("W4's switches are ones the game reads (4120-4159)") {
  FT.constants.select { |c| c.to_s.start_with?("SW_") }.map { |c| FT.const_get(c) }.select { |v| v.is_a?(Integer) && v >= 4120 && v < 4160 }.all? { |v| FT::STORY_SWITCHES.include?(v) } }
check("no wild table holds a fusion (the game's wild-fusion roll breaks on one)") {
  bad = FT::ENCOUNTERS.select { |_id, t| t.any? { |k, list| k != :step_chances && list.any? { |e| e[1].to_s =~ /^B\d+H\d+$/ } } }.keys
  bad.empty? || (puts bad.inspect; false) }
check("W4's maps are named and in the 2160-2179 range") { [2077, 2078, 2160, 2161, 2163, 2164, 2165, 2166, *2168..2172].all? { |i| FT::MAP_NAMES[i] } }
def pbMessage(t, cmds = nil, *_); $messages << t; cmds ? 0 : 0; end
def pbConfirmMessage(t); $messages << t; true; end
%i[sigils_merged sigil_echo sigil_eirwen sigil_sephek echo_wraiths_down].each { |f| FT.state[:flags]&.delete(f) }
FT.set_flag(:sigil_echo); FT.set_flag(:sigil_eirwen)
two = FT.try_merge_sigils
FT.set_flag(:sigil_sephek); $messages.clear
FT.state[:flags]&.delete(:game_complete)
early = FT.try_merge_sigils     # (the Vault is postgame: three only hum before the credits)
FT.set_flag(:game_complete)
three = FT.try_merge_sigils
FT.state[:flags]&.delete(:game_complete)
check("two sigils don't merge; three only hum in the story, and merge after the credits") { !two && !early && three && FT.flag?(:sigils_merged) && $messages.any? { |m| m.to_s.include?("wings spread over a frozen eye") } }
check("the trial counts Rheven's testimony and Naerth's ledger") {
  %i[rheven_testimony naerth_ledger].all? { |f| FT::WITNESSES.any? { |flags, *_| flags.include?(f) } } }
check("Anduin's outcome isn't keyed on the always-set oath") { !File.read(File.expand_path("../game/Data/Scripts/998_FrostThaw/036_Chapter10.rb", __dir__)).include?("hyphora_sworn") }
# --- Rootspire as a living city (W5) -----------------------------------------
w5_src = Dir[File.join(FT_DIR, "*.rb")].map { |f| File.read(f, encoding: "UTF-8") }.join("\n")
w5_mons = w5_src.scan(/named_mon\(:(\w+)/).flatten.uniq + FT::WATCHERS.map { |w| w[3].to_s }
check("every wild boss and watcher in Rootspire is a real species or fusion (#{w5_mons.size})") {
  bad = w5_mons.reject { |sp| (GameData::Species.get(sp.to_sym) rescue nil) }
  bad.empty? || (puts bad.inspect; false) }
check("every Rootspire watcher has a spot on a map") { FT::WATCHERS.all? { |w| FT::WATCHER_SPOTS[w[0]] } }
check("each Herald has five omens' worth of lines, three tiers each") {
  FT::OMENS.size == 5 && FT::OMENS.values.all? { |_h, trig, tiers| trig.size == 3 && tiers.size == 3 } }
check("an omen reads as Alberica, or as you when you're her") {
  line = "{A} [[touches|touch]] the hollow of {her} throat. {She} [[pulls|pull]] back."
  FT.omen_text(line, false) == "Alberica touches the hollow of her throat. She pulls back." &&
    FT.omen_text(line, true) == "You touch the hollow of your throat. You pull back." }
FT.state[:mode] = :herald; FT.state[:herald] = :reptin; FT.state[:companions] = [:alberica, :alerion]
FT.state.delete(:rs_day)
FT.set_flag(:met_hellen)
FT.define_singleton_method(:investigation_night) { false }
FT.define_singleton_method(:downtime_morning) { nil }
$messages.clear
FT.hearth_night
d1 = FT.state[:rs_day]
FT.state[:flags]&.delete(:rite_stopped)
FT.hearth_night
check("the rite is tonight until it's stopped: resting before it passes no night") { FT.state[:rs_day] == 1 }
FT.set_flag(:rite_stopped)
FT.hearth_night
check("the night you arrive is Day 1, and each rest at the Hearth is another day") { d1 == 1 && FT.state[:rs_day] == 2 }
check("...and the night brings something: an omen, a vignette or a night event") { $messages.size > 1 }
FT.state[:omens] = {}; FT.set_flag(:twins_met); $messages.clear
check("Auril's omens come only to Alberica, and count themselves") {
  n = FT.counter(:omens_seen); FT.omen_check && FT.counter(:omens_seen) == n + 1 && $messages.first.include?("Alberica") }
FT.state[:companions] = [:alerion]; FT.state[:omens] = {}
check("...and never without her") { !FT.omen_check }
check("the ten night events and a Verdant Storm are all written") {
  FT::NIGHT_ORDER.size == 11 && FT::NIGHT_ORDER.all? { |k| FT.respond_to?(:"night_#{k}") } }
check("the dossier's faction events (9 by map, 5 at the Hearth: Autumn's leaf is on your pillow) and 11 ambient events are all there") {
  FT::FACTION_EVENTS.size == 9 && FT::HEARTH_VIGNETTES.size == 5 && FT::HEARTH_VIGNETTES.any? { |k, *_| k == :autumn_pillow } && FT::AMBIENT.size == 11 }
check("all seven of Alberica's rumours are in the tavern") { FT::TAVERN_RUMOURS.size == 7 }
f2_src = %w[023_Chapter5 024_Chapter6 026_Rootspire 029_Glimmer 048_Rootspire_B_People 048_Rootspire_E_Nights 048_Rootspire_F_Downtime].to_h { |f| [f, File.read(File.join(FT_DIR, "#{f}.rb"))] }
{ "026_Rootspire" => ["her breath silver in the night, her eyes locked on a man with a shield", "Both roads are his.", "in the tears there is fire",
                      "they blaze with life", "two dragons cower", "wolf-bite in your hand", "as the curse bound him to hunger", "Even ruin is motion",
                      "...Still gone. Of course it is.", "sing a line of the Cycle Canticle", "The Vault of the North", "the tender and the terrible both",
                      "Here they're scripture", "chronal leaves", "Verse Eleven"],
  "024_Chapter6" => ["Wardens Emeritus of Rootspire", "I still can't sleep in a cold room", "Expansion is a wall, Kelyn", "Mirror-ice"],
  "029_Glimmer" => ["Will you bear hope when even the sun freezes?", ":glimmer_knows_journal"],
  "023_Chapter5" => ["too long in the arm to be human"],
  "048_Rootspire_B_People" => ["set_flag(:warden_map_seen)", "Brightmane said I'd"],
  "048_Rootspire_E_Nights" => ["a newborn's cry", "Frostina won't settle", "Hammers. Deep in the roots"],
  "048_Rootspire_F_Downtime" => ["Festival Circle", "children of the Reversal", "carved into the living bark"] }.each do |f, needles|
  check("F2's restored lines in #{f}") { miss = needles.reject { |n| f2_src[f].include?(n) }; miss.empty? || (puts("  missing: #{miss.inspect}"); false) }
end
check("the omens stop with the Whisper, and harden when Alberica strays") {
  s = f2_src["048_Rootspire_E_Nights"]; s.include?("flag?(:auril_whisper)") && !s.include?("ch11_whisper") && !s.include?("flag?(:ch11_started)") && s.include?("alberica_strayed >= 2") }
check("the downtime week and the GM outline end at the Forge's door") {
  FT.set_flag(:barricade_entered); a = !FT.dt_ready?(:alberica) && !FT.eirwen_audience_due?; FT.set_flag(:barricade_entered, false); a }
check("the Cycle Canticle has three verses (hope, loss, endurance), matching Ch13") {
  FT::CANTICLE_VERSES.map(&:first) == %i[spring autumn winter] && File.read(File.join(FT_DIR, "039_Chapter13.rb")).include?("three verses. Hope, loss, endurance") }
check("each Herald's downtime days are written (Arvik 2-7, Alerion 2-7, Glimmer 2-7, Meat Meat 2-5)") {
  (2..7).all? { |d| FT.respond_to?(:"arvik_day#{d}") && FT.respond_to?(:"glimmer_day#{d}") } &&
    [2, 3, 4, 6, 7].all? { |d| FT.respond_to?(:"alerion_day#{d}") } && (2..5).all? { |d| FT.respond_to?(:"meat_meat_day#{d}") } }
check("the Verdant Heist has four wards and three endings") {
  FT::HEIST_WARDS.size == 4 && FT.method(:heist_delivery) && w5_src.include?(":heist_delivered") &&
    w5_src.include?(":heist_exposed") && w5_src.include?(":heist_destroyed") }
FT.state[:mode] = nil; FT.state[:herald] = nil

# --- final fixes: Eline's mercy, the Echo Vault's forward-looking visions ----------
%i[eline_spared eline_captured eline_unbeaten eline_fate].each { |f| FT.state[:flags]&.delete(f) }
$next_choice = 0; FT.eline_mercy(true)
check("Eline spared at the Shrine (rootspire.md 1020-1024)") { FT.flag?(:eline_spared) && !FT.flag?(:eline_captured) }
FT.state[:flags].delete(:eline_spared); $messages.clear
def pbMessage(t, cmds = nil, *_); $messages << t; cmds ? 1 : 0; end      # pick "Bind her"
FT.eline_mercy(true)
def pbMessage(t, cmds = nil, *_); $messages << t; cmds ? 0 : 0; end
check("...or bound, praying backwards") { FT.flag?(:eline_captured) && $messages.any? { |m| m.include?("ecnelis") } }
FT.state[:flags].delete(:eline_captured); FT.eline_mercy(false)
check("...and unbeaten, she rides north to stand with him") { FT.flag?(:eline_unbeaten) }
FT.state[:flags].delete(:eline_unbeaten); $next_choice = nil
%i[mantle_found reflection_claimed].each { |f| FT.state[:flags]&.delete(f) }
v1 = FT.attendant_vision(:alerion); FT.set_flag(:mantle_found); v2 = FT.attendant_vision(:alerion)
FT.set_flag(:reflection_claimed); v3 = FT.attendant_vision(:alerion)
check("the Echo Vault's visions point at the quest still open") { v1.include?("Finish the step") && v2.include?("maze of mirror-ice") && v3.include?("walk back") }
%i[mantle_found reflection_claimed].each { |f| FT.state[:flags]&.delete(f) }
check("each White Vault circuit answers to a Herald's relic") { FT::CIRCUIT_RELICS.keys.sort == FT::VAULT_CIRCUITS.sort }
check("the Vault's key items sit on numbers no relic uses") {
  last_relic = FT::RELIC_ITEM_NUMBER + FT::RELIC_ITEMS.size - 1
  FT::VAULT_KEY_ITEM_NUMBER > last_relic &&
    (FT::VAULT_KEY_ITEM_NUMBER...(FT::VAULT_KEY_ITEM_NUMBER + FT::VAULT_KEY_ITEMS.size)).none? { |n|
      (it = GameData::Item::DATA[n]) && !FT::VAULT_KEY_ITEMS.key?(it.id) }
}

puts "\n#{$checks - $fails}/#{$checks} checks passed"
exit($fails == 0 ? 0 : 1)
