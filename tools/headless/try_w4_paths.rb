# The trial week's other roads, checked scene by scene: Talion's ritual at the
# Glasswater (and holding on to him), the debates and the heckler, petitions
# and signers, a failed Selrae bid (martial law), a poor verdict and the appeal
# to Hyphora, Wyn's silence, Meat Meat's break-out, the Throne with no Vault.
#   PIF_DIR=/home/claude/pifrun_W4 ruby <wt>/tools/headless/try_w4_paths.rb
require_relative "story_run"
FT = FrostThaw unless defined?(FT)
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game; HL.frames(200)
$fails = 0
def ok(c, m) = (puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails += 1 unless c)
def fresh(*flags)
  FT.state[:flags] = {}
  FT.state.delete(:trial)
  (%i[intro_done trials_open heralds_arrested summer_ended wyn_joined] + flags).each { |f| FT.set_flag(f) }
end
def answers(*rules) = (HL.answers = rules)
FT.state[:companions] = %i[alberica reptin alerion meat_meat wyn]
$Trainer.party.clear
%i[B330H152 FORGEL B7H221 SPOREYE B331H154 MYCONARCH].each { |sp| $Trainer.party << Pokemon.new(sp, 70) }
Story.fit(70)
heal = -> { $Trainer.heal_party }

# Talion: the ritual at the Glasswater, bringing him back
fresh
answers([/^Talion\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /Decide what to do|ritual at the Mirror-Lake/ } }], [/Ask Mira/, ->(t, c) { c.index { |x| x.to_s =~ /frost-glass|free a soul/ } || 0 }],
        [/soul is anchored/, 1])
$Trainer.money = 5000
FT.talion
ok(FT.flag?(:talion_ritual_chosen) && $game_switches[FT::SW_TALION], "Talion: choosing the ritual opens the night lake")
FT.mira_trials; FT.mira_trials
ok(($PokemonBag.pbHasItem?(:FT_FROSTGLASS) rescue false) && FT.flag?(:mira_ritual_advice), "Mira sells the frost-glass and gives her advice")
answers([/^Talion\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /What item|what ties/i } || 0 }], [/soul is anchored/, 1])
FT.talion
FT.talion_ritual
ok(FT.flag?(:talion_restored) && !$game_switches[FT::SW_TALION], "the ritual, anchored, brings Talion back (restored)")
ok(FT.witnesses(:summer).any? { |_, who, _, _| who =~ /Talion/ }, "...and he testifies")

# Talion: holding on to him (the chase)
fresh
answers([/^Talion\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /Decide what to do|hold on/i } }])
FT.talion; heal.()
ok(FT.flag?(:talion_chased), "holding on to Talion: the specter, and he's chased (not released)")

# Debates: talk without deeds is jeered; deeds carry; the heckler
fresh(:criers_heard, :wall_helped)
answers([/Whose platform/, 0], [/How\?/, 0], [/Answer the heckler/, ->(t, c) { c.size - 1 }])
FT.debate_stage(:bazaar)
ok(FT.trial[:support][:rheven].to_i >= 2, "a debate speech for Rheven carries after a day on the wall")
ok(FT.trial[:mud] == 1, "letting the heckler go costs you (mud #{FT.trial[:mud]})")
fresh(:criers_heard)
answers([/Whose platform/, 1], [/How\?/, 0])
FT.debate_stage(:fields)
ok(FT.trial[:support][:mira].to_i < 0, "talk with nothing done is jeered (Mira's support #{FT.trial[:support][:mira]})")

# Petitions: Phildendrin needs ten names
fresh(:mm_reconciled, :phildendrin_found)
answers()
FT.start_petition(:phildendrin)
%i[refugees bazaar hearth].each { |w| FT.petition_signer(w) }
ok(FT.nominated?(:phildendrin), "Phildendrin nominated with 10 signatures (#{FT.trial[:signatures][:phildendrin]})")
FT.start_petition(:anduin)
%i[myconids dockers guild scholars bazaar refugees].each { |w| FT.petition_signer(w) }
ok(!FT.nominated?(:anduin), "Anduin isn't nominated without the wardens and Reptin's word")

# Selrae's bid, lost: martial law
fresh
answers([/Sway|Read the room|Selrae says|Call out|One last word/, 2], [/Enter the crystals/, ->(t, c) { 1 }])
FT.selrae_bid
ok(FT.state[:seasons_debate] == :lost, "a bad debate loses the room")
answers([/vines|heat|voices|blizzard/i, 2])
FT.define_singleton_method(:transfer) { |*a| $ft_transfer = a }
FT.define_singleton_method(:selrae_dream_battle) { FT.set_flag(:badge_selrae); FT.seasons_outcome }
real_party = $Trainer.party.dup
$Trainer.party.replace([Pokemon.new(:RATTATA, 70)])
FT.state[:companions] = %i[alberica]
%i[spring summer autumn].each { |s| FT.season_quarter(s) }
FT.season_quarter(:winter)
ok(FT.flag?(:canopy_martial_law), "losing both the debate and the seasons: martial law")
$Trainer.party.replace(real_party)
FT.state[:companions] = %i[alberica reptin alerion meat_meat wyn]

# A poor verdict, and the appeal to Hyphora
fresh(:badge_selrae)
answers([/Who speaks/, 3], [/Call for the verdict/, 0], [/endorse first|And second/, 0])
FT.trial[:neglected] = 4
FT.kelyn_trials
ok(FT.flag?(:verdict_geas) && FT.flag?(:mm_outlaw), "no witnesses and four days' neglect: a geas, and Meat Meat outlawed")
ok($game_switches[FT::SW_APPEAL], "the appeal to Hyphora opens")
answers([/Ask Hyphora/, 0])
FT.hyphora_appeal
ok(FT.flag?(:verdict_service) && !FT.flag?(:verdict_geas), "Hyphora's answer reduces it to service")
ok(FT.flag?(:long_voyage) || FT.flag?(:council_rheven), "the vote still fills the chairs")

# Wyn's silence; Meat Meat breaking out
fresh(:wyn_summoned)
answers([/Wyn's account/, 2], [/Go down to the Underdark/, 1])
FT.wyn_hearing
ok(FT.flag?(:wyn_heard) && FT.trial[:mud] == 1, "Wyn's silence is noted")
FT.wyn_alibi
ok(FT.flag?(:wyn_barred), "with no evidence, Wyn serves at the Echo Gate and the stores close")
fresh
answers([/Escape\?/, 2])
FT.root_cells; heal.()
ok(FT.flag?(:escape_decided) && FT.trial[:mud] >= 1, "breaking out of the root-cell weighs against her (mud #{FT.trial[:mud]})")

# The Throne with no White Vault: Avarice steps out of the mirror
fresh(:avarice_faked_death)
answers()
FT.avarice_at_the_throne; heal.()
ok(FT.flag?(:avarice_revealed) && FT.flag?(:avarice_ended), "skip the Vault, and Avarice comes for Auril's gem at the throne")
fresh(:avarice_body_broken)
FT.avarice_at_the_throne
ok(FT.flag?(:avarice_ended), "break her body in the Vault, and only a splinter is left to stamp on")

puts "problems:"; puts HL.problems.uniq
puts($fails == 0 ? "all paths ok" : "#{$fails} failed")
