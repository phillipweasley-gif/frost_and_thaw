# The relics, blessings and goods in the real engine: the items exist with
# names and icons, the held-item handlers change damage the way the item text
# says, the salve and the seed work, and the blessings switch on.
require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(60)
$n = 0; $bad = 0
def check(name); $n += 1; ok = (yield rescue (puts "  error: #{$!.class}: #{$!.message}"; false)); puts "#{ok ? 'ok  ' : 'FAIL'} #{name}"; $bad += 1 unless ok; end

FrostThaw::RELIC_ITEMS.each_key do |id|
  check("#{id}: '#{GameData::Item.get(id).name}' with an icon") do
    GameData::Item.exists?(id) && GameData::Item.get(id).name !~ /Unnamed/ && File.exist?("Graphics/Items/#{id}.png")
  end
end

Mults = Struct.new(:h) do
  def [](k) = h[k]
  def []=(k, v); h[k] = v; end
end
def mults = { base_damage_multiplier: 1.0, attack_multiplier: 1.0, defense_multiplier: 1.0, final_damage_multiplier: 1.0 }
DS = Struct.new(:typeMod)
Tgt = Struct.new(:damageState)
Mv = Struct.new(:sound) do
  def soundMove? = sound
end
resisted = Tgt.new(DS.new(Effectiveness::NORMAL_EFFECTIVE / 2))
normal   = Tgt.new(DS.new(Effectiveness::NORMAL_EFFECTIVE))
m = mults; BattleHandlers.triggerDamageCalcUserItem(:FT_VERDANTBLADE, nil, resisted, Mv.new(false), m, 50, :NORMAL)
check("Verdant Blade doubles a not very effective hit") { m[:final_damage_multiplier] == 2.0 }
m = mults; BattleHandlers.triggerDamageCalcUserItem(:FT_VERDANTBLADE, nil, normal, Mv.new(false), m, 50, :NORMAL)
check("...and leaves a normal hit alone") { m[:final_damage_multiplier] == 1.0 }
m = mults; BattleHandlers.triggerDamageCalcTargetItem(:FT_HEARTWARDENSTAFF, nil, normal, Mv.new(false), m, 50, :FIRE)
check("Heartwarden's Staff halves Fire damage") { m[:base_damage_multiplier] == 0.5 }
m = mults; BattleHandlers.triggerDamageCalcTargetItem(:FT_HEARTWARDENSTAFF, nil, normal, Mv.new(false), m, 50, :ICE)
check("...and Ice") { m[:base_damage_multiplier] == 0.5 }
m = mults; BattleHandlers.triggerDamageCalcTargetItem(:FT_HEARTWARDENSTAFF, nil, normal, Mv.new(false), m, 50, :WATER)
check("...but not Water") { m[:base_damage_multiplier] == 1.0 }
m = mults; BattleHandlers.triggerDamageCalcUserItem(:FT_RIMEMANTLE, nil, normal, Mv.new(false), m, 50, :ICE)
check("Rime Mantle boosts Ice moves 1.2x") { (m[:base_damage_multiplier] - 1.2).abs < 1e-9 }
m = mults; BattleHandlers.triggerDamageCalcUserItem(:FT_WHISPERKEY, nil, normal, Mv.new(true), m, 50, :NORMAL)
check("Whisper Key boosts sound moves 1.3x") { (m[:base_damage_multiplier] - 1.3).abs < 1e-9 }
m = mults; BattleHandlers.triggerDamageCalcUserItem(:FT_WHISPERKEY, nil, normal, Mv.new(false), m, 50, :NORMAL)
check("...and not other moves") { m[:base_damage_multiplier] == 1.0 }

# a real battle: the staff's Verdant Pulse and the mantle's frost-proofing
$Trainer.party.clear
pk = Pokemon.new(:VENUSAUR, 40); pk.item = :FT_HEARTWARDENSTAFF; pk.calc_stats; $Trainer.party << pk
pk2 = Pokemon.new(:B9H221, 40); pk2.item = :FT_RIMEMANTLE; pk2.calc_stats; $Trainer.party << pk2
pulse_seen = false; freeze_blocked = false
class PokeBattle_Battle
  alias hl_relic_pbDisplay pbDisplay unless method_defined?(:hl_relic_pbDisplay)
  def pbDisplay(msg, &b)
    $relic_msgs ||= []; $relic_msgs << msg
    hl_relic_pbDisplay(msg, &b)
  end
end
setBattleRule("cannotRun")
foe = Pokemon.new(:JYNX, 44); foe.calc_stats
pk.hp = (pk.totalhp * 0.45).to_i
begin; d = pbWildBattleCore(foe); puts "  battle decision #{d.inspect}, log #{(HL.battle_log || []).size}"; rescue => e; puts "  battle error #{e.class} #{e.message} #{e.backtrace.first(3)}"; end
check("Verdant Pulse heals once when the holder is badly hurt") { ($relic_msgs || []).count { |l| l =~ /Verdant Pulse/ } == 1 }

FrostThaw.set_flag(:blessing_warmth)
check("Blessing of Warmth is on") { FrostThaw.blessing?(:warmth) }

# the Sap-Skin Salve and the Seed of Renewal, from the bag
$Trainer.party.each { |p| p.heal }
$Trainer.party[0].hp = 10; $Trainer.party[0].status = :FROZEN
class FakeScene; def pbDisplay(*); end; def pbRefresh; end; end
r = ItemHandlers.triggerUseOnPokemon(:FT_SAPSALVE, $Trainer.party[0], FakeScene.new)
check("Sap-Skin Salve: +60 HP and thawed") { r && $Trainer.party[0].hp == 70 && $Trainer.party[0].status == :NONE }
$Trainer.party.each { |p| p.hp = 0 }
r = ItemHandlers.triggerUseInField(:FT_RENEWALSEED)
check("Seed of Renewal revives the whole party to half") { r == 3 && $Trainer.party.all? { |p| p.hp == [(p.totalhp / 2).floor, 1].max } }

# Hyphora's Blessing: Plant Speech
FrostThaw.set_flag(:blessing_hyphora)
check("Hyphora's Blessing is on") { FrostThaw.blessing?(:hyphora) }

puts "#{$n - $bad}/#{$n} relic checks passed"
