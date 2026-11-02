# F3 (the fix round): plays each Labyrinth / Ch7B / Forge / Ch9 fix in the real
# game code, with real battles, and checks each branch lands where it should.
#   PIF_DIR=/home/claude/pifrun_F3 ruby tools/headless/try_f3.rb
require_relative "driver"
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/save your game/, 1]]
HL.new_game; HL.frames(200)
FT = FrostThaw unless defined?(FT)
$fails = 0
def ok(c, m) = (puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails += 1 unless c)
def mark = HL.log.size
def said_since?(m, re) = HL.log[m..].any? { |l| l =~ re }
def bag?(it) = ($PokemonBag.pbHasItem?(it) rescue false)
def ev(name) = $game_map.events.values.find { |e| e.name == name }
def clear(*fl) = fl.each { |f| (FT.state[:flags] || {}).delete(f) }
def answer(re, idx) = HL.answers.unshift([re, idx])
def strong_party
  $Trainer.party.clear
  [[:ARCANINE, 70], [:GYARADOS, 70], [:ALAKAZAM, 70], [:MACHAMP, 70], [:B6H130, 70], [:SNORLAX, 70]].each do |sp, lv|
    pk = Pokemon.new(sp, lv); HL.sensible_moves(pk); pk.calc_stats; $Trainer.party << pk
  end
end
def heal = ($Trainer.heal_party rescue nil)
$game_switches[Settings::NO_MONEY_LOSS] = true rescue nil
FT.state[:companions] = %i[alberica reptin alerion glimmer meat_meat wyn]
%i[met_party twins_met ch7_started wyn_joined].each { |f| FT.set_flag(f) }
strong_party
$Trainer.money = 20000

# --- M2: the boy's mirror (the Verdant Bazaar) ----------------------------------------
HL.warp(2050, 38, 21, 8)
m = mark
answer(/The reflection smirks/, 1)                    # wrong: a trick of the glass
FT.rs_mirror_child(ev("Boy with a mirror")&.id)
ok(!bag?(:FT_BOYSMIRROR) && said_since?(m, /flinches back, rattled/), "M2: a wrong read of the reflection lashes out, and the boy keeps the mirror")
ok(said_since?(m, /Mira's girl\. She looked too long/), "M2: the boy's reflection names the girl in the other half (Mira's daughter)")
HL.answers.shift
m = mark
FT.rs_mirror_child(ev("Boy with a mirror")&.id)
ok(bag?(:FT_BOYSMIRROR) && FT.flag?(:boy_mirror_taken), "M2: knowing it for a spirit and calming the boy, Meat Meat takes the mirror")

# Mira's stall, before her daughter is found
HL.warp(2050, 36, 21, 8)
m = mark; FT.mira_stall(nil)
ok(said_since?(m, /My daughter's at home\. We- I put her to bed/), "Mira's stall: her daughter, as the possession sees her")

# --- M2: the twin mirror (the Overflow Channel) ---------------------------------------
HL.warp(2067, 8, 26, 8); heal
tm = ev("Twin mirror")
answer(/The mirrors buck/, 1)                         # first: pull the girl (wrong)
m = mark; FT.twin_mirror(tm&.id); heal
ok(FT.flag?(:mirror_sentinel_down) && said_since?(m, /Mirror Sentinel/), "M2: the Mirror Sentinel guards the twin")
ok(!FT.flag?(:mirror_child_free) && said_since?(m, /Mirror Wraith/), "M2: failing to hold the mirrors releases a Mirror Wraith, and the ritual waits")
HL.answers.shift
m = mark; FT.twin_mirror(tm&.id)
ok(FT.flag?(:mirror_child_free) && bag?(:FT_MIRRORLATTICE) && !bag?(:FT_BOYSMIRROR), "M2: holding them, the fragment is caught in a crystal lattice; the girl is free")
ok(said_since?(m, /Got her\. Got a piece of her/), "M2: it's Meat Meat's moment")

# --- Mira left possessed (rootspire.md 1079) ------------------------------------------
HL.warp(2055, 36, 9, 8); heal
answer(/The mirror-core hums/, 1)
m = mark; FT.boreal_requiem(nil); heal
ok(FT.flag?(:mira_left_possessed) && !FT.flag?(:corsair_favour), "Mira can be left possessed: no naval aid")
FT.boreal_requiem(nil) if !FT.flag?(:badge_mira); heal
ok(FT.flag?(:badge_mira) && !FT.flag?(:mira_witness), "...she still gives the Tide Seal, but won't testify")
m = mark; FT.corsair_sailor(nil)
ok(said_since?(m, /You could've broken it/), "...and her crew remember who left her")
HL.answers.shift

# --- the Forge: the Barricade -----------------------------------------------------------
%i[road_a_done road_b_done hew_gift].each { |f| FT.set_flag(f) }
FT.give_key(:FT_ROOTCOMPASS)
m = mark
HL.warp(2072, 6, 10, 6); heal
FT.scene_barricade; heal
ok(FT.flag?(:flight_path_seen) && said_since?(m, /eyes burning hell-red/) && said_since?(m, /model of the Dale/), "A4: the root model of the Dale, and the frost-and-fire dragon's path")
ok(FT.flag?(:hew_compass_woke) && bag?(:FT_DEADCOMPASS) && !bag?(:FT_ROOTCOMPASS), "Hew's gift: the compass wakes at the siege, in her voice, and is broken")
ok(said_since?(m, /Prototype accepted\. Hello, little failures/), "...comic, then horror")
gate = $game_map.events.values.find { |e| e.name == "Barricade gate" }
m = mark; FT.barricade_gate(gate&.id)
ok(!FT.flag?(:barricade_passed) && said_since?(m, /Somebody will have written them down/), "B9: without the words, the gate stays shut")
FT.duergar_ledger(nil)
m = mark; FT.barricade_gate(gate&.id)
ok(FT.flag?(:barricade_passed), "B9: once read in the ledger, the words open the gate")

# --- the Forge: Mother's kitchen ------------------------------------------------------
HL.warp(2073, 12, 10, 8)
answer(/Thredra's mirror/, 0)
m = mark; FT.hag_tea_table(nil)
ok(said_since?(m, /one dead eye|One of her eyes is dead/) && said_since?(m, /Mother Thruuna/), "C5: the hag at the table, the ember eye, and Mother Thruuna named")
ok(FT.flag?(:sworn_to_thredra) && FT.flag?(:took_hag_secret), "C5: the price is sworn before the secret")
FT.set_flag(:engine_dead)
ok(FT.lines_for(:tea_table).any? { |l| l.include?("Paid in full") }, "C5: and once the forge burns, she calls it paid")
clear(:engine_dead)
HL.answers.shift

# --- the Forge: the traitor's name, the rust-feasters, the overlook --------------------
FT.set_flag(:traitor_met); FT.set_flag(:engine_dead)
m = mark; FT.traitor_duergar(nil)
ok(said_since?(m, /It's Bram\. Bram Coalhand/), "B10: after the engine dies, the traitor gives his name")
clear(:engine_dead)
src = File.read(File.join(FT_DIR_SRC = File.expand_path("../../game/Data/Scripts/998_FrostThaw", __dir__), "046_ForgeRooms.rb"))
ok(src.include?("The third rust-feaster") && !src.include?("The same words. Carved on the overlook."), "B6/B7: three rust-feasters, and the overlook quoted only if read")
m = mark; FT.rust_feasters(nil); heal
ok(FT.flag?(:rust_feasters_done) && said_since?(m, /third rust-feaster/), "B7: all three rust-feasters are fought")

# --- the Mirror-Root Vault: three checks, a sentinel per failure -----------------------
HL.warp(2145, 8, 10, 8); heal
answer(/^The thread\.\.\./, 1)
m = mark; FT.mirror_root_wards(nil); heal
ok(!FT.flag?(:mirror_wards_down) && said_since?(m, /Mirror Sentinel/), "GQ2: a wrong thread animates a Mirror Sentinel, and the work goes on")
HL.answers.shift
FT.mirror_root_wards(nil)
ok(FT.flag?(:mirror_wards_down) && FT.state[:ward_successes] == 3, "GQ2: three successes unbind the vault")

# --- the Heart Chamber: sanctify / destroy -----------------------------------------------
def heart_try(pick, tend, persuade)
  clear(:heart_choice_made, :shard_purified, :shard_preserved, :shard_destroyed, :shard_sanctified, :blessing_verdant_fire)
  FT.set_flag(:shard_fought)
  HL.answers.unshift([/The Frost Saint Shard\.\.\./, pick], [/How do you hold it/, tend], [/What do you tell it/, persuade])
  FT.scene_heart_choice; heal
  3.times { HL.answers.shift }
end
HL.warp(2076, 10, 12, 8)
heart_try(0, 0, 0)
ok(FT.flag?(:shard_sanctified) && FT.blessing?(:verdant_fire), "GQ2: sanctifying the Shard (tended, persuaded) grants the Blessing of Verdant Fire")
m = mark; heart_try(0, 1, 0)
ok(FT.flag?(:shard_purified) && !FT.flag?(:shard_sanctified) && said_since?(m, /Frost Saint Echo/), "GQ2: a failed sanctifying wakes the Frost Saint Echo, and no blessing")
heart_try(2, 0, 0)
ok(FT.flag?(:shard_destroyed) && !FT.blessing?(:verdant_fire), "GQ2: destroying it gives no blessing")

# --- the launch: the dagger, Meat Meat's rage --------------------------------------------
src34 = File.read(File.join(FT_DIR_SRC, "034_Chapter8.rb"))
ok(!src34.include?("On the stone where Glimmer knelt, the golden dagger hums") && src34.include?("In Meat Meat's hands, the golden dagger hums"), "B3: the dagger hums where it actually is")
ok(src34.include?("Meat Meat is going to take it back apart"), "P1: Meat Meat's own rage at the launch")
ok(src34.include?("Far below the floor, chains groan"), "C3: the dragon strains each round of the Circle")

# --- Still Sky covers ice, not sap ---------------------------------------------------------
src27 = File.read(File.join(FT_DIR_SRC, "027_Relics.rb"))
ok(src27.include?("SAP_SLICK_MAPS.include?($game_map.map_id)") && src27.include?("!on_sap"), "B6: the Blessing of Still Sky doesn't switch off the sap slide")

puts "\n#{$fails == 0 ? 'all' : $fails.to_s + ' failed;'} F3 checks done"
exit($fails == 0 ? 0 : 1)
