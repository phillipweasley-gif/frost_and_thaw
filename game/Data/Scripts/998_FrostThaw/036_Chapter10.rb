#===============================================================================
# Frost & Thaw - Act II, Chapter 10: Trials of the Roots (script SC 10.01-10.09)
#
# From the notes (rootspire.md Tab 8, "Chapter X: Trials of the Roots"). Word
# has spread that the Heralds slew Summer - Avarice, who wore the Summer
# Marshal for thirty years - outside the Council's justice. Everyone believes
# she is dead. The Heralds stand trial in seven days; the city fills two empty
# chairs on the same day. A hub week, in any order:
#
#   10.01 The Tribunal opens (the Council Hall); the town criers, next morning
#   10.02 Roots of Love (Reptin): Anduin at the Bazaar fountain; the
#         reconciliation; the Heartroot's Test (the Attunement Way, 2165)
#   10.03 Assassin's Reckoning (Meat Meat): the root-cell (escape, or stay);
#         Phildendrin; the apology; Autumn's spying mirror; the evidence
#   10.04 Absent Watcher (Wyn): the citation at the Echo Gate; the hearing;
#         the Underdark Door (2077) with Rootwarden escorts; the evidence
#   10.05 Brother from Beyond (Alerion): Talion in the Blooming Fields; the
#         investigation; the ritual at the Mirror-Lake (the Glasswater, 2078)
#   10.06 Spores of Contention (Alberica): the debate; the escort; the verdict
#   10.07 Gym 8: the Trial of the Four Seasons (Selrae's martial-law bid; the
#         crystals' dream, 2166)
#   10.08 The Verdict      10.09 The Vote: end of Act II
#   And the civic layer: wall-building and blankets, debates, mud-slinging,
#   petitions and platforms; and Q6's evidence leads (Slaudi; the memory
#   bubble; the wraith's echo; the Ledger; Rheven's horns).
# The side quests of this week (Wyn's two, the Stolen Leaf, Beyond the Wall,
# the Pulse of the Fields, the Mirror Maze) are in 047b_TrialWeek.rb.
#===============================================================================
module FrostThaw
  SW_TRIBUNAL   = 3991   # you've been brought before the Council (10.01 plays in the hall)
  SW_TRIALS     = 3988   # the trial week: witnesses, cells and candidates are about
  SW_PHIL_MIRROR = 3989  # Phildendrin asked for the mirror: Autumn's spying mirror waits in the Sap Wells
  SW_TALION     = 3990   # night on the Glasswater, for Talion's ritual
  SW_ACT2_DONE  = 3992   # the Vote is done
  SW_TALION_FIELDS = 4131  # Talion stands in the Blooming Fields
  SW_WALL_WORKS = 4132   # the wall crews and Rheven, out in the Blooming Fields
  SW_DEBATES    = 4133   # debates in the Bazaar and the Fields
  SW_PETITIONS  = 4134   # petition signers about the city
  SW_FOUR_SEASONS = 4135 # Selrae's bid, in the Council Hall
  SW_EIRWEN_SHRINE = 4136  # Eirwen tends the Still Sky Shrine this week
  SW_MIRA_MIRROR = 4142  # Mira's cursed mirror waits in the Heartroot
  SW_REFUGEE_CAMP = 4143 # the refugee camp in the Fields
  SW_SLAUDI     = 4144   # Slaudi, in Bryn Shander
  SW_WOLF_RAID  = 4145   # winter wolves on the work crew
  SW_APPEAL     = 4150   # the appeal to Hyphora, in the Heartroot
  SW_CRIERS     = 4151   # the town criers, the morning after the Tribunal opens
  SW_WYN_HEARING = 4152  # Wyn's hearing, in the Council Hall
  SW_PELL       = 4153   # Ivo, the junior Rootwarden, at the tunnel mouth

  MAPS.merge!(underdark_door: 2077, glasswater: 2078, attunement_way: 2165, crystal_dream: 2166)
  MAP_NAMES.merge!(2077 => "The Underdark Door", 2078 => "Glasswater Lake",
                   2165 => "The Attunement Way", 2166 => "The Crystals' Dream")
  MAP_METADATA.merge!(2077 => { announce_location: true, battle_environment: :Cave },
                      2078 => { outdoor_map: true, announce_location: true, battle_environment: :Snow, weather: [:Snow, 30] },
                      2165 => { announce_location: true, battle_environment: :Cave },
                      2166 => { announce_location: true, battle_environment: :Ice })
  AREAS.merge!(2077 => :root_tier, 2078 => :glasswater, 2165 => :root_tier, 2166 => :council)
  ENCOUNTERS[2077] = { step_chances: { Cave: 9 },
                       Cave: [[30, :SABLEYE, 54, 56], [25, :CARVANHA, 54, 56], [20, :DUSKULL, 54, 56],
                              [15, :TANGELA, 55, 57], [10, :DUSCLOPS, 55, 57]] }
  ENCOUNTERS[2078] = { step_chances: { Land: 7 },
                       Land: [[30, :SNEASEL, 54, 56], [25, :SNORUNT, 54, 56], [20, :DELIBIRD, 54, 56],
                              [15, :SWINUB, 54, 56], [10, :GLALIE, 55, 57]] }

  TRAINERS[:selrae] = [:FT_WINTER_MATRON, "Selrae",
                       [[:B124H200, 54], [:B131H225, 55], [:B221H215, 55], [:B87H124, 56], [:B144H131, 58]],
                       "Winter yields. As it should. As it always must, in the end.", [:FULLRESTORE, :FULLRESTORE]]
  TRAINERS.merge!(
    escape_warden_1: [:FT_ROOTWARDEN, "Warden Holt", [[:B59H221, 54], [:STANTLER, 55]], "She's out! Ring the bell!"],
    escape_warden_2: [:FT_ROOTWARDEN, "Warden Briar", [[:B3H234, 55], [:URSARING, 55]], "Stop her! Not the sharp end, you fool!"]
  )
  TRAINER_INTROS.merge!(
    escape_warden_1: "WARDEN HOLT: (grabbing his spear) Back in the cell! Now!",
    escape_warden_2: "WARDEN BRIAR: Ring the bell! She's in the corridor!"
  )

  RELIC_ITEMS.merge!(
    FT_CEDARCHARM: ["Cedar Charm", "Cedar Charms", 8, 0,
      "A little charm carved from cedar, worn smooth. Anduin gave it to Reptin the year they married.", 0, 0, 6],
    FT_HYPHORALEAF: ["Leaf of Hyphora", "Leaves of Hyphora", 8, 0,
      "One golden leaf, plucked from Hyphora's roots without hurting her. Proof of reverence.", 0, 0, 6],
    FT_TALIONWHISTLE: ["Carved Whistle", "Carved Whistles", 8, 0,
      "A wooden whistle Alerion carved for his little brother, the winter before. It still blows one note.", 0, 0, 6],
    FT_FROSTGLASS: ["Frost-glass Mirror", "Frost-glass Mirrors", 8, 0,
      "An untainted hand-mirror of frost-glass from Mira's stall. Only your own face in it. For now.", 0, 0, 6],
    FT_MEMORYVIAL: ["Memory Vial", "Memory Vials", 8, 1500,
      "A stoppered vial of frost-glass that can hold a memory, a vision, or a ghost's testimony.", 0, 0, 6],
    FT_RITUALRUNES: ["Ritual Rune-Shard", "Ritual Rune-Shards", 8, 0,
      "A shard of ice carved with Auril's snowflake under a crown, from the Underdark door. Proof of the Halo's ritual.", 0, 0, 6],
    FT_BLESSEDLEAF: ["Blessed Leaf", "Blessed Leaves", 8, 0,
      "One of Hyphora's fallen leaves, which Sovereign Luminara breathed her spores into. It's greener now than when it fell.", 0, 0, 6],
    FT_FROSTBITETINCTURE: ["Frostbite Tincture", "Frostbite Tinctures", 2, 0,
      "Yarro's brew of purified spores. It mends frostbite instead of rotting it. Heals 60 HP and thaws a frozen Pokémon.", 1, 1, 0],
    FT_HISTORYSCROLL: ["Leaf of Old Alliances", "Leaves of Old Alliances", 8, 0,
      "A crystal leaf from the Wind-Glass Library: world-trees and myconids, sheltering each other, three times before.", 0, 0, 6],
    FT_PETITION: ["Petition", "Petitions", 8, 0,
      "A petition to put a name forward for the Council's empty chairs. It wants signatures.", 0, 0, 6],
    FT_SIGILHORN: ["Sigil Horn", "Sigil Horns", 8, 0,
      "A horn off one of the Still Beasts, carved with Avarice's arcane mark. Rheven kept it.", 0, 0, 6]
  )

  # Every piece of evidence and every witness: [flag(s), who, what they say, which charge]
  #   :summer - the death of Summer (Avarice, who wore the Marshal)
  #   :autumn - Meat Meat, and the death of the Autumn Warden
  #   :wyn    - the Underdark door      :spores - Alberica's spores      :reptin - Reptin and the tree
  WITNESSES = [
    [[:hew_confessed], "Hew Talmire", "His ledgers: ten years of sap, sold to Summer's people.{HEW_HELD}", :summer],
    [[:yarro_witness], "Yarro", "The roots ran hot from below. The Heralds put the fire out. Gently.", :summer],
    [[:mira_witness], "Mira of the North Wind", "Darrus shipped crates to the Forge every week for ten years.{MAERA_KEPT}", :autumn],
    [[:anduin_reconciled, :anduin_doubtful], "Anduin", "Reptin stood between a fire and a sapling.", :reptin],
    [[:eirwen_restraint], "Eirwen Solglass", "I watched Reptin at the Mycolith. He used his gift to shield, never to rule.", :reptin],
    [[:cedar_charm_shown], "The cedar charm", "Anduin's own gift, carried through four hundred years.", :reptin],
    [[:leaf_presented], "A Leaf of Hyphora", "Plucked without a scratch on her. Reverence, not rivalry.", :reptin],
    # (one row for her, however many times she speaks: notes/10 E7)
    [[:mm_atoned, :mm_reconciled], "Phildendrin", "My daughter was made to be a weapon. She chose to save a child.", :autumn],
    [[:child_parents], "The rescued child's parents", "She saved our girl.", :autumn],
    [[:rheven_testimony], "Captain Rheven Stormbranch", "Autumn meant the refugees for sacrifices. I saw the lists.{MAERA_CARRIED}", :autumn],
    [[:rheven_saw_pens], "Rheven's wardens", "We found the pens when the Forge fell. Children's sizes.", :autumn],
    [[:autumn_labs_seen], "Autumn's laboratories", "Blood vials, ritual knives, Mirror Wraith samples, all under Autumn's sigil.", :autumn],
    [[:mira_mirror_testimony], "Mira, about the mirror", "Darrus commissioned the cursed mirror for Autumn. Autumn watched Ten-Towns through it.", :autumn],
    [[:refugees_testify], "Refugees from the Dale", "Autumn's followers took our food and worked us in the cold.", :autumn],
    [[:ritual_runes], "The ritual runes", "Auril's snowflake under a crown, cut at the Underdark door.", :wyn],
    [[:pell_testifies], "Ivo, junior Rootwarden", "Cultists dressed as wardens walked past me. Wyn was nowhere near.", :wyn],
    [[:wraith_witness_door], "A Mirror Wraith's vision", "Cultists chanting over the seal. Wyn far away, in the dark.", :wyn],
    [[:hyphora_alibi], "Hyphora", "The one who walks in shadow. I called. Wyn came.", :wyn],
    [[:wyn_seen_testified], "You, who saw Wyn at the festival", "Out of breath, with a Sableye, the night the door broke.", :wyn],
    # (notes/10 E19: the warden pulled out of the ice past the Wall comes home, and speaks)
    [[:brisa_home], "Warden Brisa, of the Bough", "Wardens' cloaks walked past us to the Wall. Their breath didn't fog.", :wyn],
    [[:blessed_leaf_shown], "Luminara's blessed leaf", "Her spores, breathed into a fallen leaf: greener, not rotten.", :spores],
    [[:tincture_shown], "Yarro's frostbite tincture", "The spores mend frostbite. They don't cause blight.", :spores],
    [[:history_shown], "The Leaf of Old Alliances", "Three world-trees before Hyphora, each sheltered by myconids.", :spores],
    [[:ally_wyn_spores], "Wyn", "I kept the door under those spores for three years. They kept me.", :spores],
    [[:ally_reptin_spores], "Reptin", "I carried the seed. The mushrooms were here first. They've been very polite about it.", :spores],
    [[:talion_released, :talion_chased, :talion_restored], "Talion, through the mirrors", "The tall gold man had no reflection. None. For years.", :summer],
    [[:memory_bubble], "Luminara's memory bubble", "Var's body in the roots, feeding a wraith into the spores. Then its face peels back.", :summer],
    [[:slaudi_testifies], "Slaudi, a fisherman", "The food caravans went south to Summer's stockpiles. Caer-Konig starved.", :summer],
    [[:wraith_echo_avarice], "A Mirror Wraith's echo", "She ordered us to watch Ten-Towns, and choose who would be sacrificed.", :summer],
    [[:ledger_found], "The Ledger of Corruption", "Payments from Auril's cult. Lists of names. \"Her winter buys my summer.\"", :summer],
    [[:rheven_horns], "Rheven's sigil horns", "Beasts carved with Avarice's mark, loosed on travellers.", :summer],
    [[:naerth_ledger], "Naerth's last ledger", "Avarice was bleeding Targos white long before the Rime.", :summer],
    [[:var_story_known], "Var Rime-Breaker's own story", "A good man, worn like a coat for thirty years.", :summer],
    [[:heist_exposed], "The Guild reliquary", "Darrus wanted the Mirror Mother's heart. Meat Meat gave it to the Council.", :autumn],
    [[:robes_seen], "Autumn's crowning robes", "Autumn's gold robes, for a horned queen nobody had met, carried to the Forge.", :autumn],
    [[:maera_apprentice_heard], "Maera Vell's apprentice", "She took the robes down herself. Autumn needed a hand that wouldn't shake.", :autumn],
    [[:watcher_weasel], "Maera Vell's garden-whisper weasel", "Every night it stole word of the Heralds, for Autumn's clothier.", :autumn],
    [[:frostfire_flask], "A flask of frostfire", "Frost and fire in one flask: the engine's fuel, off Summer's own shelves.", :summer],
    [[:pain_pods_freed], "A caravan driver from Bryn Shander", "They took the whole caravan, food and all. For the summer. The summer was hungry.", :summer],
    [[:pods_quiet], "The pale sovereign, by spore", "The pod-sleepers dream of her, and the dreams say whose they were.", :summer],
    [[:oath_of_roots], "The Rootwardens' Oath of Roots", "Sworn with Rheven, in the old way.", :summer],
    [[:selrae_witness], "Selrae Vorn, from the dock", "Her word, for whatever an old Halo-sheltering fool's word is worth.", :summer]
    # (Kelyn presides: a judge is never her own witness. notes/10 E7)
  ]

  CANDIDATES = {
    rheven: ["Rheven Stormbranch", "Strength and security: walls, patrols beyond the Wall, a close eye on magic."],
    mira: ["Mira of the North Wind", "Commerce and connection: open the city to Ten-Towns traders."],
    eirwen: ["Eirwen Solglass", "Harmony and spirit: listen to the crystals; the myconids and the wardens together."],
    phildendrin: ["Phildendrin", "Justice and reform: fair trials, not summary judgement; Hyphora's teachings for the poor."],
    anduin: ["Anduin", "Faith and humility: we serve the tree, not ourselves. No more god-sparks."]
  }
  CANDIDATE_BASE = { rheven: 4, mira: 3, eirwen: 3, phildendrin: 2, anduin: 1 }
  # Signatures a nomination needs (rootspire.md Q6.4): five, or one notable faction; outsiders need more.
  SIGNATURES_NEEDED = { phildendrin: 10, anduin: 15 }

  # Debate questions: [question, { candidate => answer }]
  DEBATE_QUESTIONS = [
    ["How will you protect Hyphora's roots?",
     { rheven: "Spears at every root-gate. Nobody digs without my say.",
       mira: "Pay the Guild to stop digging. Trade's cheaper than war.",
       eirwen: "Ask her. Every week. In the Fane. Then do as she says.",
       phildendrin: "Put the people who dug under her on trial. In public.",
       anduin: "Kneel to her. Every one of us. Gods included." }],
    ["What role should Ten-Towns play in our future?",
     { rheven: "Neighbours, behind a good wall.",
       mira: "Partners. Our sap for their fish, and a ship a week each way.",
       eirwen: "Family we forgot. The leaves remember them. So should we.",
       phildendrin: "Citizens. The refugees in that camp vote next year.",
       anduin: "Pilgrims. Let them come and see what a tree can do." }]
  ]

  TEXT.merge!(
    trial_gallery: -> {
      flag?(:verdict_heard) ? ["GALLERY: Four chairs, all filled. My nan cried."] :
        ["GALLERY: (whispering) That's them. The Heralds. They killed Summer.",
         "GALLERY: Liberators, my brother says. Murderers, says his wife. They've stopped talking."] },
    kethan_after: ["KETHAN: Go on, Rootwarden. Your post's still yours. If you want it."],
    underdark_circle: ["Behind the broken door, cut into the rock: a ritual circle of frost.",
                       "Auril's snowflake, under a crown."],
    glasswater_still: ["The lake is so still it could be a second sky.", "The constellations in it don't match the ones overhead."],
    phildendrin_after: -> { flag?(:mm_atoned) ? ["PHILDENDRIN: The faces in that mirror were people. You let them go.",
                                                 "PHILDENDRIN: Now let the court do the same for her."] :
                                                ["PHILDENDRIN: The spying mirror's in the Sap Wells, under the Root Gate. Break it.",
                                                 "PHILDENDRIN: And bring the court proof. Rheven saw the pens. He won't look at me.",
                                                 "PHILDENDRIN: Mira at the docks sold Autumn mirrors. The camp remembers the rest."] },
    refugee_camp: ["REFUGEE: The tree people gave us blankets. Blankets! In autumn!",
                   "REFUGEE: We've had snow in our boots for two years."],
    trial_gossip_1: ["STALL-KEEPER: Summer died screaming, I heard. The little goblin bit her.",
                     "STALL-KEEPER: ...No, my cousin says the cat-man burned her up. With a sunrise."],
    trial_gossip_2: ["FLOWER-SELLER: She turned into glass, they say. Summer. Like a window someone broke.",
                     "FLOWER-SELLER: Mirrored charms! Against frost spirits. And against... well."],
    trial_gossip_3: ["CHANDLER: Wool cloaks! First cold winter in thirty years, and nobody owns a cloak.",
                     "CHANDLER: The Heralds did this. Ended the summer.",
                     "CHANDLER: ...I'm not saying they were wrong. I'm saying buy a cloak."],
    trial_children: ["CHILD: If you kill somebody, Mirror Wraiths come out of the Echo Gate and take your face.",
                     "OTHER CHILD: (pointing at you) Did they take YOUR face?",
                     "CHILD: Shh! You'll make them angry!"],
    trial_scholar: ["CANDLEKEEP SCHOLAR: I came from Candlekeep for the aurora. Now there's a trial of gods.",
                    "CANDLEKEEP SCHOLAR: I've filled three notebooks. Would you sign one?"],
    trial_hearth_hush: ["The Hearth goes quiet when you come in. Some people nod. Some look at their cups.",
                        "Hellen doesn't. She pours, same as ever."],
    trial_trader: ["TRADER: Came through the Echo Gate with a sledge of furs. Ten days from Bryn Shander.",
                   "TRADER: Blizzards all the way. Then flowers in the snow. My dogs won't stop sneezing."],
    wall_rubble: ["Root-timber and blocks of cut ice, stacked chest-high. A wall, mostly.", "In places, very mostly."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Evidence, opinion, support
  #-----------------------------------------------------------------------------
  def trial
    state[:trial] ||= { day: 1, helped: 0, neglected: 0, opinion: 0, support: {}, signatures: {}, mud: 0, done_today: false }
  end

  def witnesses(charge = nil)
    WITNESSES.select { |flags, _, _, c| (charge.nil? || c == charge) && flags.any? { |f| flag?(f) } }
  end

  # Autumn's hand at the Forge was Darrus, or (if he was exposed in the heist
  # and fled) Maera Vell (034 autumn_hand): a witness line follows whichever.
  def witness_line(text)
    maera = flag?(:heist_exposed)
    text.gsub("{MAERA_KEPT}", maera ? " When he ran, Maera Vell kept them going." : "")
        .gsub("{MAERA_CARRIED}", maera ? " When Darrus ran, Maera Vell carried them below." : "")
        .gsub("{HEW_HELD}", flag?(:hew_held) ? " He says every word himself, as he promised you." :     # (Ch7B: "Then say it at the Trials.")
                            flag?(:hew_forgiven) ? " He came anyway. Nobody asked him to." : "")
  end

  def trials_done
    %i[anduin_reconciled anduin_doubtful phildendrin_found wyn_cleared talion_released talion_chased talion_restored
       talion_haunted colony_recognised colony_exiled].count { |f| flag?(f) }
  end

  # The Heralds menu during the week: the trials checklist (who, where, done),
  # then the witnesses (notes/10 E4).
  def show_witnesses
    show_trial_checklist
    list = witnesses
    if list.empty?
      return pbMessage(_INTL("Witnesses: nobody yet. The crystals sit on the seventh day."))
    end
    pbMessage(_INTL("Witnesses and evidence ({1}). Public opinion: {2}.", list.size, opinion_word))
    list.each { |_, who, what, _| pbMessage(_INTL("{1}: \"{2}\"", who, witness_line(what))) }
  end

  def trial_step_text(text) = text.respond_to?(:call) ? text.call : text

  def show_trial_checklist
    done = TRIAL_STEPS.select { |flags, _| flags.any? { |f| flag?(f) } }.map { |_, t| trial_step_text(t).split(":").first }
    open = TRIAL_STEPS.reject { |flags, _| flags.any? { |f| flag?(f) } }.map { |_, t| trial_step_text(t) }
    pbMessage(_INTL("Trial week, day {1} of 7. Heard: {2}.", trial[:day], done.empty? ? "none yet" : done.join(", ")))
    open.each { |t| pbMessage(_INTL("Still to hear: {1}.", t)) }
  end

  def opinion_word
    o = trial[:opinion] - trial[:mud]
    o >= 4 ? "with you" : o >= 2 ? "warming" : o >= 0 ? "divided" : "against you"
  end

  def add_opinion(n)  = (trial[:opinion] += n)
  def add_support(k, n) = (trial[:support][k] = (trial[:support][k] || 0) + n)

  # A small skill challenge in the notes' spirit: the right answer is the one the
  # scene has already told you. Returns true on a success. The options come in a
  # new order every time (notes/10 E6: 45 of 46 had the right answer first); a
  # way out ("Not today", "Leave it") stays last.
  STAY_LAST = /\A(Not today|Not yet|Leave it|Back|Say nothing|Nothing|Never mind|Wait)\z/

  def challenge(prompt, options, right)
    right = Array(right)
    order = (0...options.size).to_a
    tail = order.select { |i| options[i] =~ STAY_LAST }
    order = (order - tail).shuffle + tail
    @challenge_right = order.each_index.select { |j| right.include?(order[j]) }
    c = pbMessage(_INTL(prompt), order.map { |i| _INTL(options[i]) }, -1)
    @last_pick = c && c >= 0 && c < order.size ? order[c] : nil     # (the option as written, before the shuffle)
    @last_pick ? right.include?(@last_pick) : false
  ensure
    @challenge_right = nil
  end

  # Where the right answer sits in the challenge on screen now (the headless
  # driver reads it, so its runs still take the path the scene told it).
  def challenge_pick = (@challenge_right || []).first

  # A fight the story carries on through, win or lose (an ambush on the road,
  # a hazard): losing doesn't send you back to a Pokémon Center mid-scene.
  def skirmish(*mons)
    setBattleRule("canLose") rescue nil
    won = boss_battle(*mons)
    if !won
      say(["You fall back, battered, and get your breath."])
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    end
    won
  end

  def chapter10_start
    set_switch(SW_TRIBUNAL, true)
    # A night between the arrest and the court (notes/09 E5), so the Tribunal's
    # "That evening." is the next day's: the root-cells, then the card.
    $game_screen.start_tone_change(Tone.new(-255, -255, -255, 0), 12) rescue nil
    say(["The root-cells under the Council Hall. A night, and most of a day.",
         "Light through the bars, in four colours. Somewhere above, a city arguing about you."])
    # (an input between the arrest and the court, the Act II audit's longest run)
    c = pbMessage(_INTL("The night in the root-cells..."), [_INTL("Sleep, if you can"), _INTL("Lie awake and listen")], 0)
    say([c == 0 ? "You sleep, badly. In the next cell someone snores like a bear in a barrel." :
                  "Feet on the root-stair above, all night. Every one of them stops at the grate, and goes on."])
    say(["CHAPTER 10: TRIALS OF THE ROOTS"])
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 12) rescue nil
    transfer(2054, 11, 17, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 10.01 - The Tribunal opens; and the morning after
  #-----------------------------------------------------------------------------
  def scene_tribunal
    set_switch(SW_TRIBUNAL, false)
    return if flag?(:trials_open)
    Stage.actor(:a_child_on_a_crate, $game_player.x - 2, $game_player.y, 6, graphic: "BW (17)")
    Stage.actor(:her_mother, $game_player.x - 3, $game_player.y, 6, graphic: "BW (40)")
    # (notes/09 9.11: the scene plays inside the Hall, so it's told from inside)
    say(["That evening. The Council Hall fills behind you: furs, cloaks, banners of the seasons.",
         "A CHILD ON A CRATE: Murderers!",
         "HER MOTHER: (a hand over the child's mouth) Hush. They brought us out of the snow.",
         "The four seasonal crystals cast long shadows across the floor.",
         "Four chairs wait. Two of them, gold and red, are draped in white."])
    say(["KELYN: Heralds of Dawn and Dusk. Summer is dead, and our Marshal with her. By your hands.",
         "KELYN: You did it without this Council's leave.",
         "KELYN: Meat Meat is charged separately. #{autumn_hand[:who]} died by her hand."])
    # (dialogue 09 §3 item 13: nobody named the one who broke the engine)
    speak(:alberica, "(very plainly) Glimmer stopped your summer. You'll want to thank him. You can't.",
                     "(very plainly) ...Glimmer did it. And you can't thank him.") if with_or_is?(:alberica) && flag?(:glimmer_gone)
    # Owner's decision (2026-11-06, context 10 M10-2): Selrae is in the dock.
    # She confessed to the party in the Sap Wells (7B); here she says it to the city.
    selrae = stage_event("Selrae Vorn")
    Stage.hop(selrae) if selrae
    say(["SELRAE: (standing) Before I read another name, the court should hear mine.",
         "SELRAE: I let the Halo into this city. Thirty years. Their candles. My coin."])
    $game_screen.start_flash(Color.new(255, 255, 255, 90), 12) rescue nil
    say(["The gallery goes very quiet. Above the bench, the white crystal stays lit.",
         "KELYN: (very quietly) Still lit. ...She told me, the night she came up."])
    told = flag?(:selrae_home)
    c = pbMessage(_INTL(told ? "(Selrae looks for you in the Hall. You told her to come home, and she did.)" :
                               "(Selrae finds you in the Hall, and holds your eye.)"),
                  [_INTL("(Nod to her.)"), _INTL("(Look away.)")], -1)
    say([c == 0 ? "SELRAE: (a breath) ...Thank you. I'll read the charges, because someone must." :
                  "SELRAE: (a breath) Fair. I'll read the charges, because someone must.",
         "SELRAE: Then I'll stand with them."])
    say(["SELRAE: The Rootwarden Wyn: with leaving the Underdark door, the night the Halo came in."])
    if with_or_is?(:wyn)
      speak(:wyn, "(very small) ...It's true. I wasn't at my post. I didn't know they'd come in.",
                  "(very small) ...It's true. I wasn't there.")
    end
    # Owner's decision (M10-3): Alberica's real charge is the Bryn Shander night (Ch2's lottery).
    say(["SELRAE: And Alberica: with reaching into a hundred heads in Bryn Shander, unasked.",
         "SELRAE: The leaves say a square full of people forgot to be afraid. All at once.",
         "SELRAE: And that night the Frostmaiden put her mark on you. The leaves saw that too."])
    speak(:alberica, "(under her breath) They were about to hand a girl to the snow. You're welcome.",
                     "(under her breath) ...They were about to hand a girl to the snow.")
    if selrae
      Stage.walk_to(selrae, 13, 17, face: 8)               # down to the end of the dock, by the accused
    end
    say(["Selrae steps down from the bench and stands at the end of the dock, beside the accused.",
         cl(:alberica, "(sideways, making room) Room for one more, Matron. It's cosier down here."),
         "KELYN: Reptin is not charged. But we would know if he means to be a god over our tree.",
         cl(:reptin, "I planted an acorn. Once."),
         "KELYN: You have seven days to bring witnesses. Then the crystals hear the verdict.",
         "KELYN: Our sentences: service in the sap-channels or at the Echo Gate. Or exile.",
         "KELYN: An appeal goes only to Hyphora herself, by ritual, in the Heartroot.",
         cl(:reptin, "(under his breath) Leave the talking to me. I mean it this time."),
         cl(:meat_meat, "(under her breath) Meat Meat would also like to do the talking."),
         cl(:reptin, "(a look) Especially not you."),
         "KELYN: Selrae Vorn's case is heard with yours. And that day, the city fills two chairs."].compact)
    court_for_the_outsider
    set_flag(:trials_open)
    set_switch(SW_TRIALS, true)
    set_switch(SW_CRIERS, true)
    trial
    add_counter(:story_beats)
    pbMessage(_INTL("(The Heralds menu now keeps a list of your witnesses and evidence.)")) rescue nil
    trial_week_goal
  end

  # Context 10 M10-1: the court, told to the outsider (who has never seen one),
  # with the three rules the week runs on, and the adhesive: nobody leaves.
  def court_for_the_outsider
    kelyn = stage_event("Kelyn of Spring")
    Stage.approach(kelyn) if kelyn
    if journey?
      say(["KELYN: (to you) And you. Nobody charged you. You're on no list in this city.",
           "KELYN: You came out of the lantern with them, so the court will ask what you saw."])
      c = pbMessage(_INTL("(Kelyn waits.)"), [_INTL("I'll tell it straight"), _INTL("I'm on their side"), _INTL("(Say nothing.)")], -1)
      c = 2 if !c || c < 0
      set_flag(%i[court_straight court_sides court_silent][c])
      say([["KELYN: Good. That's all a witness is for.",
            "KELYN: Then say so, and the court will weigh it like that.",
            "KELYN: (a long look) The crystals will hear your silence too."][c],
           cl(:reptin, "(to you) Dear. Please be on our side, and straight.")].compact)
    elsif !herald?(:wyn)
      say(["KELYN: (to you) And you. Charged or not, you stand with them. Speak for yourself."])
      pbMessage(_INTL("(Kelyn waits.)"), [_INTL("(Nod.)"), _INTL("(Hold her eye.)")], -1)
    else
      # Wyn Mode: you're one of the charged, and a Rootwarden; you know this court
      say(["KELYN: (to you) Wyn. You know this court better than they do. Stand straight in it."])
      c = pbMessage(_INTL("(Kelyn waits.)"), [_INTL("(Stand straight.)"), _INTL("(Look at the floor.)")], -1)
      say([c == 0 ? "KELYN: Good." : "KELYN: (gently) Up, Rootwarden. Up."])
    end
    say(["KELYN: Every word said under these crystals is kept, on the Library's leaves.",
         "KELYN: Lie under them, and your season's crystal goes dark. Everyone sees it."])
    [[60, 200, 90], [230, 200, 60], [220, 70, 60], [230, 240, 255]].each do |r, g, b|
      $game_screen.start_flash(Color.new(r, g, b, 120), 6) rescue nil
      pbSEPlay("Saint1") rescue nil
      Stage.wait(8)
    end
    say(["The four crystals pulse, one by one: green, gold, red, white.",
         "KELYN: So bring people who'll stand here and say what they saw. Bring things, too.",
         "KELYN: The more who speak, the more the crystals see. On the seventh day, they decide.",
         cl(:meat_meat, "Meat Meat will bring the whole camp. Meat Meat will bring the wolves."),
         "KELYN: Until then, none of you leaves Rootspire. The Wall's thin. I'd find you."].compact)
    return if !with_or_is?(:meat_meat)
    if herald?(:meat_meat)
      say(["KELYN: (to you) Meat Meat. You sleep in the root-cells. By day you walk with them."])
      speak(:meat_meat, "Meat Meat will be good. Mostly good. Meat Meat will try very hard.", "...Mostly good.")
      say([cl(:alerion, "(to Kelyn) She'll be at the bars by sundown. I'll bring her myself.")].compact)
      return
    end
    say(["KELYN: Meat Meat sleeps in the root-cells. By day she walks with you, on your word."])
    mm = Stage.summon(:meat_meat)
    warden = mm ? Stage.actor(:rootwarden, mm.x + 1, mm.y, 4, graphic: "BW029") : nil
    Stage.turn_to(warden, mm) if warden
    say(["A Rootwarden takes Meat Meat's elbow. She looks back once.",
         "MEAT MEAT: (going) Meat Meat will be good. Mostly good. Meat Meat will try very hard."])
    Stage.leave_all([warden, mm], 17, 6) if mm
    say([cl(:alerion, "(to Kelyn) She'll be at the bars by sundown. I'll bring her myself.")].compact)
  end

  # Q6: "The morning after their return... town criers ring bells... Moments
  # later, a carpenter asks them to help reinforce a section of the new wall."
  def scene_trial_morning
    set_switch(SW_CRIERS, false)
    return if flag?(:criers_heard)
    set_flag(:criers_heard)
    px, py = ($game_player.x rescue 0), ($game_player.y rescue 0)
    crier = Stage.actor(:town_crier, px - 3, py - 2, 2, graphic: "BW (75)")
    say(["Bells, up and down the Bazaar's walkways.",
         "TOWN CRIER: Hear ye, hear ye! All are summoned to the Council Hall on the seventh day,",
         "TOWN CRIER: to witness the trial of the slayers of Summer! And to fill two empty chairs!",
         "Heads turn. Some nod at you. Some look away."])
    Stage.leave(crier, px - 8, py - 2) if crier
    reptin_worshipped
    carpenter = Stage.actor(:carpenter, px + 3, py, 4, graphic: "BW (54)")
    Stage.approach(carpenter) if carpenter
    sayc(["CARPENTER: (catching your sleeve, sawdust in his beard) You lot. You've got arms.",
          "CARPENTER: The Wall's going thin. Whatever's out there is getting in. Wolves, for a start.",
          "CARPENTER: So we're walling the city in, past the Fields. Come and lift something.",
          cl(:alberica, "Sugar, I've lifted a great many things. Most of them were drinks."),
          outsider? ? cl(:alberica, "(to you, quietly) Your Wall's coming down, you know. This is what it looks like.") : nil])
    Stage.leave(carpenter, px + 8, py) if carpenter
    set_switch(SW_WALL_WORKS, true)
    set_switch(SW_REFUGEE_CAMP, true)
    set_switch(SW_DEBATES, true)
    set_switch(SW_PETITIONS, true)
  end

  # Context 10 M10-4: the trial asks whether Reptin "means to be a god over our
  # tree"; this shows the city treating him as one, and puts Anduin at the
  # fountain the goal sends you to.
  def reptin_worshipped
    return if !with_or_is?(:reptin)
    me = herald?(:reptin)
    rep = me ? $game_player : Stage.summon(:reptin)
    warden = rep ? Stage.actor(:rootwarden, rep.x - 3, rep.y + 1, 6, graphic: "BW029") : nil
    Stage.approach(warden, rep) if warden
    say([me ? "A young Rootwarden pushes through, kneels to you, and sets a cup of sap at your feet." :
              "A young Rootwarden pushes through, kneels to Reptin, and sets a cup of sap at his feet.",
         "ROOTWARDEN: Warden of Life and Death. The tree grew from your hand. Bless my spear?"])
    speak(:reptin, "(lifting her up by the elbow) Up you get, dear. I'm a druid. We bless salad.",
                   "(lifting her up by the elbow) ...Stand up. Please.")
    say(["ROOTWARDEN: (backing away, still bowing) They said you'd say that. That's how we know."])
    Stage.leave(warden, warden.x - 6, warden.y) if warden
    anduin = stage_event("Anduin")
    if anduin
      Stage.pan_to(anduin.x, anduin.y)
      Stage.turn_to(anduin, rep) if rep
    end
    say(["By the fountain, a tall elf with an iron ring saw all of it. He looks away first."])
    if anduin
      Stage.face(anduin, 8)
      Stage.pan_back
    end
    say([as(:reptin, "(very quietly) ...Anduin.")])
  end

  # The week's clock (notes/10 E2). A night passes when you rest at the Hearth.
  # A trial heard, or a day's work for the city, spends the day; a second piece
  # of work on a spent day runs on into the next one. The crystals sit on the
  # seventh day.
  def trials_left = TRIAL_STEPS.count { |flags, _| flags.none? { |f| flag?(f) } }

  def day_line(day)
    left = trials_left
    tail = left.zero? ? "Every trial heard." : "#{%w[No One Two Three Four Five Six][left] || left} #{left == 1 ? 'trial' : 'trials'} left."
    day >= 7 ? "(Day 7 of 7: the crystals sit when you tell Kelyn. #{tail})" : "(Day #{day} of 7. #{tail})"
  end

  def trial_work_done
    return if !flag?(:trials_open) || flag?(:ch10_done) || flag?(:verdict_heard)
    t = trial
    if t[:done_today] && t[:day] < 7
      t[:day] += 1
      pbMessage(_INTL("(The work runs on past dark, into the next day.)")) rescue nil
      pbMessage(_INTL(day_line(t[:day]))) rescue nil
    elsif !t[:done_today]
      pbMessage(_INTL("(That's the day's work done. A night at the Hearth, and it's day {1}.)", [t[:day] + 1, 7].min)) rescue nil if t[:day] < 7
    end
    t[:done_today] = true
    trial_week_goal
  end

  def trial_day_passes
    return if !flag?(:trials_open) || flag?(:ch10_done)
    t = trial
    idle = !t[:done_today] && t[:day] > 1
    t[:neglected] += 1 if idle
    t[:done_today] = false
    t[:day] = [t[:day] + 1, 7].min
    pbMessage(_INTL(day_line(t[:day]))) rescue nil
    pbMessage(_INTL("(Yesterday went by with nothing done. The city counts the days, too.)")) rescue nil if idle
    # Meat Meat sleeps in the root-cells and walks with you by day (M10-1)
    if with_or_is?(:meat_meat) && !flag?(:verdict_heard)
      say([herald?(:meat_meat) ? "You come up from the root-cells, yawning. #{with_or_is?(:alerion) ? 'Alerion signs' : 'Somebody signs'} for you." :
           herald?(:alerion) ? "Meat Meat comes up from the root-cells, yawning. You sign for her." :
                               "Meat Meat comes up from the root-cells, yawning. Alerion signs for her."])
    end
    # Context 11 M11-3: one plant between Luna's word on Iskra (Ch3) and Iskra herself (Ch11)
    if t[:day] >= 2 && !flag?(:frostina_sang_north)
      set_flag(:frostina_sang_north)
      say(["Last night Frostina sang to the north, up at the crown, for an hour. Nobody knows why."])
    end
    trial_week_goal
  end

  #-----------------------------------------------------------------------------
  # The civic layer: the wall, the camp, the wolves
  #-----------------------------------------------------------------------------
  def wall_crew(event_id = nil)
    t = trial
    if t[:done_today]
      return say(["FOREMAN: You've done a day's work already. Sleep at the Hearth. The wall will keep."], event_id)
    end
    say(["Root-timber, ice blocks the size of sheep, and too few hands.",
         "FOREMAN: The carpenter sent you? Good. Three jobs, and we're short for all of them."], event_id)
    c = pbMessage(_INTL("Help with... (a day's work)"), [_INTL("Organising the crews"), _INTL("Enchanting the timber"),
                                         _INTL("Lifting spirits"), _INTL("Not today")], 3)
    return if c == 3 || c < 0
    ok = case c
         when 0
           challenge("The crews are arguing about who carries what.",
                     ["Pair strong with quick; set a pace", "Shout until they listen", "Carry it all yourself"], 0)
         when 1
           mon = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && (pk.hasType?(:GRASS) || pk.hasType?(:PSYCHIC) || pk.hasType?(:FAIRY)) }
           if mon
             say(["#{mon.name} lays a paw on the timber. Green frost-light sinks into the grain."]); true
           else
             say(["(None of your Pokémon has the knack: a Grass, Psychic or Fairy type could do it.)"]); false
           end
         else
           if with_or_is?(:alberica)
             say([as(:alberica, "(up on an ice block) Right! A work-song! Everybody knows this one: it's about me.")]); true
           elsif with_or_is?(:wyn)
             say([as(:wyn, "(quietly, to the timber) ...Hold together. Please. For them.")]); true
           else
             challenge("The crew is cold and sullen.", ["Pass round the hot sap", "Tell them the wolves are coming", "Say nothing"], 0)
           end
         end
    if ok
      t[:helped] += 1
      add_opinion(1)
      add_support(:rheven, 1)
      say(["A length of wall goes up, straight and cold and strong.",
           "FOREMAN: That'll stand. People will remember who helped stand it."])
      tamsin_sworn_in if !flag?(:tamsin_sworn)
      set_flag(:wall_helped)
      set_switch(SW_WOLF_RAID, true) if t[:helped] >= 2 && !flag?(:wolves_driven_off)
    else
      say(["It doesn't go well. The crew mutters. Something will have to be done again tomorrow."])
    end
    trial_work_done
  end

  # The rival's one stated want, paid (whole read T7): Tamsin joins the
  # Rootwardens in the trial week and turns up for you at the verdict.
  def tamsin_sworn_in
    set_flag(:tamsin_sworn)
    tam = (Stage.actor(:tamsin, $game_player.x + 2, $game_player.y, 4, graphic: "FT_tamsin") rescue nil)
    Stage.walk_to(tam, $game_player.x + 1, $game_player.y, face: 4) rescue nil if tam
    say(["Tamsin comes up the line in a new green cloak, on crooked.",
         "TAMSIN: Sworn in this morning. Junior Rootwarden. Very junior. I hold the rope."])
    sayc([cl(:alberica, "(beaming) Look at you. Somebody fetch Hellen."),
          cl(:reptin, "Congratulations, Rootwarden. The cloak goes the other way round.")])
    Stage.remove_actor(tam) rescue nil if tam
  end

  def refugee_blankets(event_id = nil)
    if flag?(:blankets_given)
      return say(lines_for(:refugee_camp), event_id)
    end
    say(["Tents of hide and root-cloth at the Fields' edge. Refugees from the Dale, two years cold.",
         "REFUGEE: Is it true? You're the ones who stopped the summer?",
         "REFUGEE: ...Then is the winter ours again?"], event_id)
    return if !pbConfirmMessage(_INTL("Spend the day handing out the Council's food and blankets?"))
    say(["You spend the day carrying. Blankets. Bread. Mushroom rations that never freeze.",
         "A woman with chapped hands takes your face in them and says nothing at all."])
    set_flag(:blankets_given)
    add_opinion(1)
    add_support(:phildendrin, 1)
    trial_work_done
  end

  # "...defending a work crew from a pack of Winter wolves (combat encounter CR 6)"
  # (notes/10 E33: the raid comes to you, on the Fields, the day after the
  # second length of wall goes up; three wolves come over it, not one standing)
  def wall_wolves(event_id = nil)
    return if flag?(:wolves_driven_off)
    px, py = ($game_player.x rescue 30), ($game_player.y rescue 16)
    pbSEPlay("Wind1") rescue nil
    say(["A howl, close. Then three."])
    wolves = [[7, -1], [8, 0], [7, 1]].map do |dx, dy|
      Stage.actor(:winter_wolf, px + dx, py + dy, 4, graphic: "Followers/MIGHTYENA")
    end.compact
    wolves.each_with_index do |w, i|
      w.move_speed = 5 rescue nil
      Stage.walk(w, [PBMoveRoute::Left] * (4 - (i % 2)), wait_for: i == wolves.size - 1)
    end
    Stage.cry(:MIGHTYENA)
    foreman = stage_event("Wall foreman")
    Stage.emote(foreman, :exclaim) if foreman
    say(["White shapes come over the half-built wall in a wave.",
         "FOREMAN: WOLVES! Get behind the timber!"], foreman ? foreman.id : nil)
    sayc([cl(:reptin, "(eyes going gold) Winter wolves. I know what they want. Behind me, everyone."),
          cl(:meat_meat, "Meat Meat will bite the wolves. The wolves will be very surprised.")])
    return if !boss_battle(named_mon(:B59H272, 56, "Winter Wolf"), named_mon(:B59H272, 56, "Winter Wolf"))
    Stage.leave_all(wolves, px + 12, py) if !wolves.empty?
    say(["The pack breaks and runs into the white. The crew comes out from the timber, cheering."])
    set_flag(:wolves_driven_off)
    set_switch(SW_WOLF_RAID, false)
    add_opinion(2)
    trial[:mud] = [trial[:mud] - 1, 0].max
    say(["(By nightfall it's all round the Bazaar. The rumours about you get quieter.)"])
  end

  #-----------------------------------------------------------------------------
  # Electioneering: debates, mud-slinging, petitions
  #-----------------------------------------------------------------------------
  def nominated?(k)
    return true if %i[rheven mira eirwen].include?(k)
    flag?(:"nominated_#{k}")
  end

  def debate_stage(where, event_id = nil)
    key = :"debated_#{where}"
    if flag?(key)
      return say(["The stage of braided roots is empty now. Someone's left a seasons banner over it."], event_id)
    end
    say(["A stage of braided roots: candidates in a row, a crowd, questions shouted from the back."], event_id)
    keys = CANDIDATES.keys.select { |k| nominated?(k) }
    q, answers = DEBATE_QUESTIONS[where == :fields ? 1 : 0]
    # the candidates themselves on the stage, so each answer comes from a face
    stage = stage_event(event_id)
    sx, sy = stage ? [stage.x, stage.y] : [$game_player.x, $game_player.y - 3]
    row = keys.select { |k| PLATFORMS[k] }
    row.each_with_index { |k, i| Stage.actor(k, sx - row.size + 1 + i * 2, sy - 1, 2, graphic: PLATFORMS[k][0]) }
    Stage.actor(:voice_in_the_crowd, $game_player.x + 2, $game_player.y + 1, 8, graphic: "BW (61)")
    say(["VOICE IN THE CROWD: #{q}"])
    keys.each { |k| say(["#{PLATFORMS[k] ? k.to_s.upcase : CANDIDATES[k][0].upcase}: #{answers[k]}"]) }
    c = pbMessage(_INTL("Whose platform will you speak for?"), keys.map { |k| _INTL(CANDIDATES[k][0]) } + [_INTL("Nobody's")], keys.size)
    if c >= 0 && c < keys.size
      k = keys[c]
      how = pbMessage(_INTL("How?"), [_INTL("A speech"), _INTL("A demonstration of skill"), _INTL("Stare the hecklers down")], 0)
      deed = case k
             when :rheven then flag?(:wall_helped) || flag?(:wolves_driven_off)
             when :mira then flag?(:mira_mirror_returned)
             when :eirwen then flag?(:anduin_reconciled) || flag?(:colony_recognised)
             when :phildendrin then flag?(:autumn_labs_seen) || flag?(:refugees_testify) || flag?(:ledger_found)
             when :anduin then flag?(:anduin_reconciled) && flag?(:reptin_endorsed)
             when :heralds then flag?(:wolves_driven_off) || flag?(:blankets_given) || flag?(:ledger_found)
             end
      if deed || how == 1
        say([how == 2 ? "You stare the hecklers down. One by one they find the floor very interesting." :
             how == 1 ? "You show them instead of telling them. The crowd goes quiet, then loud." :
                        "You speak plainly about what you've seen this candidate do. People nod.",
             "(A faction comes round to #{CANDIDATES[k][0]}.)"])
        add_support(k, 2)
        add_opinion(1)
      else
        say(["You speak. The crowd jeers. Somebody throws a frost-fruit.",
             "(Talk is cheap here. Do something for this candidate's cause first: it'll carry.)"])
        add_support(k, -1)
      end
    end
    set_flag(key)
    mud_slinging if !flag?(:mud_answered)
    Stage.cleanup
  end

  # "Opponents may accuse the party of treachery."
  def mud_slinging
    heckler = Stage.actor(:heckler, $game_player.x - 2, $game_player.y + 1, 8, graphic: "BW (88)")
    Stage.turn_to(heckler) if heckler
    say(["HECKLER: And what about THEM? Murderers! Summer's dead, and they did it with no trial!",
         "HECKLER: Who's next? Who do they decide doesn't deserve a season?"])
    proof = witnesses(:summer).size
    opts = []
    opts << [:evidence, _INTL("Answer with the evidence")] if proof >= 1
    opts << [:deed, _INTL("Point at the wall, and the wolves")] if flag?(:wolves_driven_off)
    opts << [:silence, _INTL("Let it go")]
    c = pbMessage(_INTL("Answer the heckler?"), opts.map(&:last), opts.size - 1)
    pick = opts[[c, 0].max][0]
    case pick
    when :evidence
      say(["You name what you know: who she was, what she kept in her ledgers, who she had watched.",
           "The heckler sits down."])
      set_flag(:mud_answered)
    when :deed
      say(["\"We'll be on the wall tonight. Where will you be?\" Laughter. The heckler sits down."])
      set_flag(:mud_answered)
    else
      say(["The rumour goes round the crowd, and out into the city."])
      trial[:mud] += 1
    end
  end

  # Putting an outsider's name forward needs a petition (Q6.4).
  def start_petition(k)
    return if nominated?(k) || flag?(:"petition_#{k}")
    set_flag(:"petition_#{k}")
    give_key(:FT_PETITION)
    say(["(A petition for #{CANDIDATES[k][0]}. It needs #{SIGNATURES_NEEDED[k]} names, or a faction behind it.)"])
  end

  def petition_signer(who, event_id = nil)
    open = %i[phildendrin anduin heralds].select { |k| flag?(:"petition_#{k}") && !nominated?(k) }
    signed = (state[:signed] ||= {})
    if open.empty?
      return say(["#{who.to_s.tr('_', ' ').capitalize}: Petitions? Nobody's put one in front of me."], event_id)
    end
    if who == :myconids && flag?(:sap_raided) && !flag?(:ch10_done)
      return say(["EIRA: (turning her cap away) The sap went up the ramp in Rootwarden carts. You watched.",
                  "EIRA: The spore-guard signs nothing this week."], event_id)
    end
    k = open.first
    if signed[[who, k]]
      return say(["(They've signed for #{CANDIDATES[k][0]} already.)"], event_id)
    end
    n = { refugees: 4, bazaar: 3, hearth: 3, myconids: 4, guild: 2, dockers: 3, scholars: 1 }[who] || 1
    if k == :anduin && who == :myconids
      say(["EIRA: A man who'd forbid god-sparks. ...The spore-guard signs. Gods make roots nervous."], event_id)
    elsif k == :heralds && who == :refugees
      say(["REFUGEE: You carried us out of the snow. Of course I'll sign. Pen, before I cry."], event_id)
    elsif k == :phildendrin && who == :refugees
      say(["REFUGEE: The goblin woman? She sat with our children every night. Give me the pen."], event_id)
    else
      say(["They read it, slowly. They sign."], event_id)
    end
    signed[[who, k]] = true
    trial[:signatures][k] = (trial[:signatures][k] || 0) + n
    return if check_nomination(k)
    need = SIGNATURES_NEEDED[k]
    have = trial[:signatures][k]
    say(["(#{have} of #{need} signatures for #{CANDIDATES[k][0]}.)",
         k == :anduin ? "(He also needs the Rootwardens' leave, and Reptin to stand up for him in public.)" : nil].compact)
  end

  # A petition goes forward the moment everything it needs is in place, in
  # whatever order the week brought them: signatures, the Rootwardens' leave,
  # Reptin's word in the Bazaar. Called from each of those.
  def check_nomination(k)
    return false if !flag?(:"petition_#{k}") || nominated?(k)
    need = SIGNATURES_NEEDED[k] || 0
    have = (trial[:signatures][k] || 0)
    return false if have < need
    return false if k == :anduin && !(flag?(:rootwardens_accept_anduin) && flag?(:reptin_endorsed))
    set_flag(:"nominated_#{k}")
    say(["(#{CANDIDATES[k][0]} has #{have} signatures#{k == :anduin ? ', the Rootwardens\' leave, and Reptin\'s word' : ''}.)",
         "(The name goes forward to the Council!)"])
    add_support(k, 1)
    true
  end

  #-----------------------------------------------------------------------------
  # SC 10.02 - Roots of Love (Reptin)
  #-----------------------------------------------------------------------------
  def anduin_trial(event_id = nil)
    if flag?(:anduin_reconciled) || flag?(:anduin_doubtful)
      return anduin_after(event_id)
    end
    if flag?(:anduin_talked)
      say(["ANDUIN: The Council wants him tested in the Heartroot. I'll come. I'll hold his hand.",
           "ANDUIN: If the tree shows me a god, I'm going home."], event_id)
      return heartroot_test_offer
    end
    # Purpose: Anduin wants the man he married back; Reptin wants to be that man
    # and the tree's warden at once. Ends with Anduin agreeing to walk the Test.
    me = herald?(:reptin)
    say(["The air in the Verdant Bazaar tastes of sap and frost.",
         "By the fountain of petrified roots, a tall elf turns an iron ring on his finger.",
         "His breath fogs. His eyes search the crowd until they fall on #{me ? 'you' : 'Reptin'}."], event_id)
    anduin = stage_event(event_id)
    Stage.approach(anduin) if anduin
    # (dialogue 10 §4: the cliché opener cut; the houseplant line does the work)
    say(["ANDUIN: (turning his iron ring) Reptin. Thank the seasons.",
         "ANDUIN: They leave you offerings in the Rootwardens' hall.",
         "ANDUIN: Reptin, you couldn't keep a houseplant alive."], event_id)
    speak(:reptin, "(his best smile) The houseplant had it coming. ...I'm still him, Anduin.", "...I'm still him.")
    say(["ANDUIN: Are you? This tree is a god. Young, and frightened.",
         "ANDUIN: And you stand next to it like a second sun.",
         "ANDUIN: Will you be more than her? Or are you the man I married?"])
    # The reconciliation (Q1.1): each honest answer deepens his understanding.
    # The choice names a stance; Reptin says it in his own words, then Anduin answers.
    score = 0
    honest = challenge("Anduin wants honesty.", ["Tell him the truth", "\"Nothing's changed, darling.\"",
                                                 "\"I'm stronger than I was.\""], 0)
    if honest
      speak(:reptin, "I don't know what I'm becoming. I know who I'm becoming it for.", "...I know who I'm becoming it for.")
      say(["ANDUIN: (quietly) ...That's the first true thing anyone's told me in a month."])
      score += 1
    else
      say(["ANDUIN: (stepping back) Don't. Don't handle me."])
    end
    if ($PokemonBag.pbHasItem?(:FT_CEDARCHARM) rescue false)
      say([as(:reptin, "Do you remember the cedar charm you gave me?"),
           me ? "You hold it out. Worn smooth. Four hundred years, and a few weeks." :
                "Reptin holds it out. Worn smooth. Four hundred years, and a few weeks.",
           "ANDUIN: (taking it, and his voice going) ...You kept it. Through all of that, you kept it."])
      set_flag(:cedar_charm_shown)
      score += 1
    else
      ok = challenge("A shared memory, to remind him.", ["The winter he taught you to skate", "The first sight of the Tree",
                                                          "Your last battle"], 0)
      if ok
        say([as(:reptin, "The winter you taught me to skate. I broke the ice with my face."),
             "ANDUIN: (laughing despite himself) You came up spitting fish. I proposed that night."])
        score += 1
      else
        say(["ANDUIN: That's not ours. That's the city's. I want ours."])
      end
    end
    deeds = flag?(:mycolith_down) || flag?(:engine_dead)
    power = challenge("Show him what your power is for.",
                      [deeds ? "Tell him about the Forge" : "Tell him you'll keep the city safe",
                       "Show him what you can do now", "Promise to stop using it"], 0)
    if power
      score += 1
      say(deeds ? [as(:reptin, "At the Forge, I stood between the fire and the roots. That's all it's for."),
                   "ANDUIN: (very quiet) ...Between the fire and the roots. That sounds like you."] :
                  [as(:reptin, "It's for keeping this city standing. Nothing else."),
                   "ANDUIN: (very quiet) ...Standing. All right. Keep us standing, then."])
    else
      say(["ANDUIN: (flatly) I didn't ask what it can do. I asked what it's for."])
    end
    state[:anduin_score] = score
    set_flag(:anduin_talked)
    say(["ANDUIN: They want you tested, in the Heartroot. I'll come. I'll hold your hand.",
         "ANDUIN: If the tree shows me a god, Reptin, I'm going home."])
    heartroot_test_offer
  end

  def heartroot_test_offer
    return if !pbConfirmMessage(_INTL("Go down to the Heartroot for the Test, now?"))
    pbFadeOutIn { } rescue nil
    say(["Anduin walks beside #{herald?(:reptin) ? 'you' : 'Reptin'} all the way down, not talking.",
         "Down through the Root Gate, past the seal circle, into a passage older than the city."])
    transfer(*ATTUNEMENT_ARRIVAL)
  end

  ATTUNEMENT_ARRIVAL = [2165, 10, 22, 8]

  # Anduin walks the Test beside Reptin: on screen when he speaks.
  def anduin_walks_with
    if (a = Stage.speaker("ANDUIN"))
      return if Stage.on_screen?(a)
      x, y = Stage.near_slot
      a.moveto(x, y) if x                           # (he keeps up with you between the stations)
      return
    end
    x, y = Stage.near_slot
    Stage.actor(:anduin, x, y, $game_player.direction, graphic: "FT_anduin") if x
  rescue StandardError
    nil
  end

  # The Heartroot's Test (Q1.2): six successes before three failures, across the
  # Attunement Way's three stations (passages, spores, whispers) and the leaf.
  def attunement_station(which, event_id = nil)
    st = (state[:attune] ||= { ok: 0, bad: 0, done: [], hand: false })
    return say(["(You've passed this way.)"], event_id) if st[:done].include?(which)
    anduin_walks_with
    case which
    when :passages
      say(["The passage splits three ways. Roots as thick as houses, breathing.",
           "ANDUIN: (a hand on the wall) This one's warm. Like a hearth. The others are cold."], event_id)
      2.times do |i|
        ok = challenge(i == 0 ? "Which way?" : "It splits again.", ["The warm one", "The one with the most light", "The cold, quiet one"], 0)
        ok ? (st[:ok] += 1; say(["The root under your feet pulses, as if pleased."])) : (st[:bad] += 1; say(["The way narrows to nothing. You go back."]))
      end
    when :spores
      say(["A drift of pale spores, thick as snow, glowing. Breathing them makes the walls swim.",
           "Somewhere in it, a voice that sounds like Anduin's says: \"Leave him. He's a god now.\""], event_id)
      unless st[:hand]
        if pbConfirmMessage(_INTL(herald?(:reptin) ? "Let Anduin hold your hand through it?" : "Let Anduin hold Reptin's hand through it?"))
          st[:hand] = true
          st[:ok] += 1
          say(["ANDUIN: (taking #{herald?(:reptin) ? 'your' : 'his'} hand, gripping it hard) That isn't me. THIS is me."])
        end
      end
      ok = challenge("The spore-drift.", ["Breathe slow, and keep walking", "Run through it", "Hold your breath as long as you can"], 0)
      ok ? (st[:ok] += 1; say(["You come out the other side clear-headed."])) : (st[:bad] += 1; say(["You come out the other side dizzy and sick."]))
    when :whispers
      say(["The roots whisper. The words are old, slow, and very young at the same time.",
           "HYPHORA: (a feeling more than a voice) ...where... do you... stand?"], event_id)
      ok1 = challenge("Answer the tree.", ["\"Beside you.\"", "\"Over you, keeping you safe.\"", "\"Wherever I like.\""], 0)
      say([ok1 ? "HYPHORA: ...beside... yes..." : "The roots go still, and a little cooler."])
      ok2 = challenge("HYPHORA: ...and if I grow taller than you?", ["\"Then I'll be proud.\"", "\"You won't.\"", "\"Then I'll grow too.\""], 0)
      say([ok2 ? "HYPHORA: ...good. ...stay." : "HYPHORA: (smaller) ...oh."])
      [ok1, ok2].each { |o| o ? st[:ok] += 1 : st[:bad] += 1 }
    end
    st[:done] << which
    attunement_finish if st[:bad] >= 3 || (st[:done].size >= 3 && flag?(:leaf_plucked_try))
  end

  # The Leaf of Hyphora: pluck one golden leaf without hurting her.
  def attunement_leaf(event_id = nil)
    st = (state[:attune] ||= { ok: 0, bad: 0, done: [], hand: false })
    return say(["Hyphora's root, bare where the golden leaf was."], event_id) if flag?(:leaf_plucked_try)
    say(["At the heart of the Way, a root with a single golden leaf on it, like a coin on a palm."], event_id)
    ok = challenge("Pluck the leaf.", ["Gently, where it's ready to let go", "Quickly, before she notices", "Cut it with a knife"], 0)
    set_flag(:leaf_plucked_try)
    if ok
      give_key(:FT_HYPHORALEAF)
      st[:ok] += 1
      say(["It comes away in your fingers like it was waiting. The root doesn't flinch.",
           "ANDUIN: (very quietly) ...She let you. Show them that. Show the court."])
      set_flag(:leaf_presented)
    else
      st[:bad] += 1
      say(["The root flinches. Sap wells up where the leaf was, golden, like a cut finger."])
    end
    attunement_finish if st[:done].size >= 3 || st[:bad] >= 3
  end

  def attunement_finish
    return if flag?(:anduin_reconciled) || flag?(:anduin_doubtful)
    st = state[:attune] || { ok: 0, bad: 0 }
    passed = st[:ok] >= 6 && st[:bad] < 3
    reconciled = (state[:anduin_score] || 0) >= 2
    me = herald?(:reptin)
    # (notes/10 E22: the map has no chamber here, so the vision is a vision: O-03)
    Stage.overlay("O-03", fade: 20)
    say(["The roots ahead open like eyes. The Heartroot shows you:"])
    if passed
      say([me ? "You, grey-furred and enormous, between a burning machine and a sapling." :
                "Reptin, grey-furred and enormous, between a burning machine and a sapling.",
           me ? "You take the heat. The sapling grows up past you, and you look up at it, glad." :
                "He takes the heat. The sapling grows up past him, and he looks up at it, glad."])
    else
      say([me ? "You, vast, a crown of antlers, and the sapling in your shadow, pale and small." :
                "Reptin, vast, a crown of antlers, and the sapling in his shadow, pale and small.",
           "The vision flickers. It isn't sure. Neither is anyone watching."])
    end
    Stage.overlay_off("O-03", fade: 20)
    if passed && reconciled
      # (dialogue 10 §4: say what it means to him, not what we just saw)
      say(["Anduin is crying.",
           "ANDUIN: ...I'd packed, Reptin. My bag's by the fountain. I'll go and unpack it.",
           "ANDUIN: We'll look after it together. Both of us. ...Ask the roots with me."])
      pbMessage(_INTL(me ? "(Ask the roots, with him?)" : "(Reptin holds out his hand to Anduin.)"),
                [_INTL(me ? "(Ask them.)" : "(Step back, and let them ask.)")], 0)
      say(["#{me ? 'Your hand and his' : 'Their two hands'}, flat on the root. It warms under them, and stays warm.",
           cl(:alberica, "(blowing her nose, loudly) Somebody marry those two again. I'll sing.")].compact)
      set_flag(:anduin_reconciled)
      add_support(:eirwen, 1)
      add_support(:anduin, 2)
      if !flag?(:treant_given)
        say(["The roots unknot, and a little treant stands up out of them, all heart-root and bark.",
             me ? "It walks over to you, and leans on your leg, the way the direwolf does." :
                  "It walks over to Reptin, and leans on his leg, the way the direwolf does."])
        # (notes/10 E29: it's Heartwood, not its species name, and nobody's asked to rename it)
        heartwood = named_mon(:B185H114, 50, "Heartwood")
        again = looped_gift?(:treant_given)
        added = again || (pbAddPokemonSilent(heartwood) rescue false)
        if added
          pbMessage(again ? _INTL("(Heartwood is already with you, from last time. It leans on you anyway.)") :
                            _INTL("\\me[Pkmn get]Heartwood came with you!")) rescue nil
          set_flag(:treant_given)
        end
      end
    elsif passed
      say(["ANDUIN: (wiping his eyes) The tree trusts you. ...I'm still learning how to.",
           "He'll testify. He'll stay. He isn't sure he'll stay with #{me ? 'you' : 'Reptin'}."])
      set_flag(:anduin_doubtful)
    else
      say(["ANDUIN: (very quiet) I wanted to believe it.",
           "He'll testify. But he walks back up to the camp alone.",
           "By morning he's packing for Ten-Towns.",
           cl(:alberica, "(quietly) Give him time, sweetheart. The good kind of love is slow.")].compact)
      set_flag(:anduin_doubtful)
      set_flag(:anduin_leaving)
    end
    add_counter(:story_beats)
    set_flag(:attunement_done)
    trial_work_done
    transfer(2057, 9, 14, 2) rescue nil
  end

  def anduin_after(event_id = nil)
    if flag?(:anduin_doubtful) && !flag?(:anduin_won_back) && (flag?(:eirwen_restraint) || flag?(:leaf_presented) || flag?(:cedar_charm_shown))
      return anduin_win_back(event_id)
    end
    if flag?(:anduin_leaving)
      return say(["ANDUIN: (a pack on his shoulder) I'll write. I won't know what to say. I'll write anyway."], event_id)
    end
    if flag?(:anduin_reconciled) && !flag?(:reptin_endorsed)
      say(["ANDUIN: People keep asking me to stand for the Council. Me. An outsider.",
           "ANDUIN: I'd say: we serve the tree, or we serve ourselves. ...Is that daft?"], event_id)
      if pbConfirmMessage(_INTL("Should Reptin stand up in the Bazaar and endorse him, in public?"))
        speak(:reptin, "(to the whole Bazaar) My husband would make a better councillor than I'd make a god.",
              "(to the whole Bazaar) ...Vote for him.")
        say([as(:reptin, "Vote for him. I will.")])
        set_flag(:reptin_endorsed)
        add_support(:anduin, 2)
        start_petition(:anduin)
        check_nomination(:anduin)
      end
      return
    end
    say([flag?(:anduin_reconciled) ? "ANDUIN: Stewards of the Heartroot. Him and me. I like the sound of it." :
                                     "ANDUIN: I want to believe it. I'm trying. Give me time."], event_id)
  end

  # Q1's evidence was gathered "to reassure Anduin": Eirwen's word that Reptin
  # used his gift only as a wall, Hyphora's own leaf, the cedar charm. Brought
  # to him after the Test, it can still change his mind (once).
  def anduin_win_back(event_id = nil)
    set_flag(:anduin_won_back)
    say([flag?(:anduin_leaving) ? "ANDUIN: (a pack on his shoulder, not quite leaving yet) ...You came to see me off?" :
                                  "ANDUIN: (by the fountain, turning the iron ring) You're still here. So am I. Mostly."], event_id)
    proofs = []
    proofs << "Eirwen's leaf: \"He raised his gift only as a wall. Never as a crown.\"" if flag?(:eirwen_restraint)
    proofs << "Hyphora's golden leaf, plucked without a scratch on her. She let him." if flag?(:leaf_presented)
    proofs << "The cedar charm, worn smooth, four hundred years in #{herald?(:reptin) ? 'your' : 'his'} pocket." if flag?(:cedar_charm_shown)
    say(["#{herald?(:reptin) ? 'You lay' : 'Reptin lays'} it all out on the fountain's rim:"] + proofs)
    won = proofs.size >= 2
    if !won && challenge("Anduin is listening. Really listening, this time.",
                         ["\"Trust me. Slowly.\"", "\"See? I told you so.\"", "\"You can't leave now.\""], 0)
      speak(:reptin, "I'm not asking you to trust a god. Trust me. Slowly.", "...Trust me. Slowly.")
      won = true
    end
    if won
      say(["ANDUIN: (setting the pack down) ...A wall. Not a crown.",
           "ANDUIN: Stewards of the Heartroot, the wardens said. Both of us. Ask me again.",
           herald?(:reptin) ? "(You ask him again.)" : "(Reptin asks him again.)",
           "ANDUIN: Yes. Obviously yes. Don't make a speech about it."])
      state[:flags].delete(:anduin_doubtful) if state[:flags]
      state[:flags].delete(:anduin_leaving) if state[:flags]
      set_flag(:anduin_reconciled)
      add_support(:anduin, 2)
      add_support(:eirwen, 1)
      add_counter(:story_beats)
    else
      say(["ANDUIN: (gently) I believe the evidence. I'm still learning to believe you.",
           "ANDUIN: Give me time. Real time. Not a trial week."])
    end
  end

  # Witness to restraint (Q1 evidence): Eirwen, at the Still Sky Shrine.
  def eirwen_shrine(event_id = nil)
    if flag?(:eirwen_restraint) && flag?(:naerth_ledger)
      return say(["EIRWEN: It's on a leaf now. Leaves don't take things back."], event_id)
    end
    # Context 10 M10-8: Sephek's ice, all week (Ch11's "The Halo carried it up
    # while the city voted" is paid here, on the path: Reptin's trial calls here).
    say(["Eirwen Solglass sits barefoot by the scorched throne, writing on a crystal leaf."], event_id)
    if !flag?(:saint_candles_seen)
      set_flag(:saint_candles_seen)
      Stage.pan_to(13, 21)
      say(["On the altar, Sephek still stands in his blue ice. Someone has lit new candles round him."])
      Stage.pan_back
      say(["EIRWEN: (not looking up) Every night I put them out. Every morning they're lit again.",
           "EIRWEN: Nobody comes in. I'd see. ...I think I'd see.",
           cl(:alerion, "(to the ice) Four hundred years. You'd think he'd be tired of standing.")].compact, event_id)
    end
    say(["EIRWEN: The leaves are full of you this week. Half of them say 'murderer'."], event_id)
    # Naerth's last ledger (rootspire.md, Eirwen: kept in the oldest roots). It
    # reads back what you decided with her about it (notes/15 E17, 15.35).
    if !flag?(:naerth_ledger) && pbConfirmMessage(_INTL("Ask Eirwen: \"Naerth's last ledger. Will the court see it?\""))
      first = if flag?(:naerth_ledger_published) then "EIRWEN: It's on the open shelves already. The court can read it there."
              elsif flag?(:naerth_ledger_sealed) then "EIRWEN: (very still) It's sealed. I wrote the date on it. ...For the court, I'll break it."
              elsif flag?(:naerth_ledger_council) then "EIRWEN: Kelyn has it. She'll have to read it out in front of everyone, now."
              else "EIRWEN: (very still) I found it in the oldest roots. I never knew who to show it to."
              end
      say([first,
           "EIRWEN: Every page: Targos's sap money, going south to a summer that never came.",
           "EIRWEN: \"A.\" in the margin, in Naerth's hand. Over and over. He knew, and was afraid.",
           cl(:alerion, "(flat) A. Avarice."),
           "EIRWEN: ...Yes. The crystals should read it. He'd want someone braver to carry it."].compact)
      set_flag(:naerth_ledger)
      add_support(:eirwen, 1)
    end
    return if flag?(:eirwen_restraint)
    if pbConfirmMessage(_INTL(with_or_is?(:reptin) ? "Let Reptin ask Eirwen what the leaves saw him do?" :
                                                       "Ask Eirwen what the leaves saw Reptin do?"))
      # (dialogue 10 §4: the accused asks it himself, not a lawyer's question)
      if with_or_is?(:reptin)
        speak(:reptin, "(to Eirwen) You've read the leaves about me, Eirwen. If they're unkind, tell me anyway.",
                       "...If they're unkind, tell me anyway.")
      end
      say(["EIRWEN: (looking up) I watched the Mycolith fight from the Fane. The Forge, I've only read about."])
      ok = challenge("Persuade Eirwen.", ["Ask them to read the leaves aloud", "Remind them Reptin planted the tree",
                                         "Tell them they owe you"], [0, 1])
      if ok
        say(["EIRWEN: (reading) \"The god of the wild raised his gift only as a wall. Never as a crown.\"",
             "EIRWEN: Restraint is rarer than power. The court should hear that, from me."])
        speak(:reptin, "I'd like that on my headstone. Much later.", "...Thank you.") if with_or_is?(:reptin)
        set_flag(:eirwen_restraint)
        add_support(:eirwen, 1)
      else
        say(["EIRWEN: Owing isn't truth. Come back with a better question."])
      end
    end
  end

  #-----------------------------------------------------------------------------
  # SC 10.03 - Assassin's Reckoning (Meat Meat)
  #-----------------------------------------------------------------------------
  # Purpose: Meat Meat answers for the man she let fall, and finds the mother she
  # never knew was alive; Phildendrin gives her a way to answer the court.
  # (notes/10 E12, E24; dialogue 10 Top 4: the cell shows Meat Meat, Phildendrin
  # walks in, and her errand is one line in her own voice.)
  CELL_SPOT = [17, 5]

  def root_cells(event_id = nil)
    if flag?(:phildendrin_found)
      return phildendrin_after(event_id)
    end
    mm = herald?(:meat_meat)
    cell = stage_event(event_id)
    # For this scene her lines come from the cell (its name says who's in it).
    cell_data = (cell.instance_variable_get(:@event) rescue nil)
    cell_data.name = "Meat Meat (root-cell)" if cell_data && !mm
    root_cells_scene(event_id, mm, cell)
  ensure
    cell_data.name = "Root-cells" if cell_data
  end

  def root_cells_scene(event_id, mm, cell)
    if mm
      # you're the one behind the bars
      $game_player.moveto(*CELL_SPOT) rescue nil
      $game_player.direction = 2 rescue nil
    end
    say(["The root-cells, under the Council Hall. Light through the bars, in four colours.",
         mm ? "You sit in a root-cell, holding Razzilith's nose through the bars." :
              "Meat Meat sits in a root-cell, holding Razzilith's nose through the bars."], event_id)
    speak(:meat_meat, "Meat Meat could have caught #{autumn_hand[:his]} hand. Meat Meat didn't. Meat Meat would not catch it again.",
                      "...Meat Meat would not catch it again.", event_id)
    say([as(:meat_meat, "That is the truth. The crystals can judge the truth.")], event_id)
    if mm
      say([flag?(:mm_reached) ? "(The court has it written down: you reached for #{autumn_hand[:him]}. #{autumn_hand[:His]} hand slid out of yours.)" :
                                "(The court has it written down: you took the child. You didn't reach.)",
           "(They read it back to you twice.)"])
    end
    if !flag?(:escape_decided)
      set_flag(:escape_decided)
      say(["The lock is old root, and the guard is asleep on his stool.",
           mm ? "(You could be out of here in a breath.)" : "MEAT MEAT: Meat Meat could be out of here in one breath."], event_id)
      c = pbMessage(_INTL("Escape?"), [_INTL("Stay, and answer for it"), _INTL("Slip out quietly"), _INTL("Break out")], 0)
      if c == 1
        if challenge("The lock.", ["Feel for the knot that holds it", "Bite it", "Kick it"], 0)
          say(["The root-lock unknots under small, clever fingers. Out, past the guard, into the dark.",
               mm ? "An hour later you're back in, with two coffees, and a very guilty face." :
                    "An hour later she's back in, with two coffees, and a very guilty face.",
               cl(:reptin, "(at the bars) You came BACK?"),
               as(:meat_meat, "Mama would want Meat Meat to come back. Meat Meat does not know Mama. Meat Meat guesses.")].compact, event_id)
          set_flag(:mm_slipped_out)
          trial[:mud] += 1
        else
          say(["The lock squeals. The guard wakes. More charges get written down."])
          trial[:mud] += 1
        end
      elsif c == 2
        say(["The bars come out of the root in a shower of splinters. Bells, everywhere."])
        won1 = trainer(:escape_warden_1, nil)
        won2 = won1 && trainer(:escape_warden_2, nil)
        if won2
          say([mm ? "Two Rootwardens down in the corridor. You, out in the snow, free." :
                    "Two Rootwardens down in the corridor. Meat Meat out in the snow, free.",
               mm ? "Then, very slowly, you walk back in, and sit down in what's left of the cell." :
                    "Then, very slowly, she walks back in, and sits down in what's left of the cell.",
               as(:meat_meat, "...That was wrong. Meat Meat will say so to the crystals."),
               "(Hurting the Council's wardens will weigh against her. A great deal.)"], event_id)
          set_flag(:mm_broke_out)
          trial[:mud] += 2
        else
          say([mm ? "They pin you in the corridor. More charges. More guards. A thicker door." :
                    "They pin her in the corridor. More charges. More guards. A thicker door."])
          trial[:mud] += 1
        end
      else
        set_flag(:mm_cooperated)
      end
    end
    # Phildendrin comes down the cell stair, past the sleeping guard, to the bars.
    phil = Stage.actor(:hooded_woman_phildendrin, 18, 11, 8, graphic: "FT_phildendrin_hooded")
    pbSEPlay("Door exit") rescue nil
    say(["Footsteps on the cell stair. A hooded figure comes down, past the sleeping guard."])
    Stage.walk_to(phil, 16, 5, face: 6) if phil
    Stage.emote(cell, :exclaim) if cell && !mm
    Stage.emote($game_player, :exclaim) if mm
    say([mm ? "It's the goblin from the Bryn Shander crowd. The one who never stopped watching you." :
              "It's the goblin from the Bryn Shander crowd. The one who never stopped watching Meat Meat.",
         "HOODED WOMAN: (her voice cracking) They told me V-7 died. In the cold room.",
         "HOODED WOMAN: They told me my baby died.",
         "She pulls her hood back."])
    phil.character_name = "FT_phildendrin" if phil rescue nil
    say([ask_as(:meat_meat, "(very small) ...Mama?", "...Mama?"),
         "PHILDENDRIN: (hands through the bars, on her face) My name is Phildendrin.",
         "PHILDENDRIN: I'm your mama. And I am not losing you to another cell.",
         mm ? "You hold on to her hands through the bars." : "Meat Meat holds on to her hands through the bars."], event_id)
    say(["PHILDENDRIN: (to the bars, the stair, anyone) #{autumn_hand[:full]} kept children in pens.",
         "PHILDENDRIN: Hang me next to my daughter, or let her go.",
         cl(:reptin, "(very quietly, to the rest of you) Let's give them a minute.")].compact)
    set_flag(:phildendrin_found)
    # Reconcile through heartfelt apology (Q2.2). (dialogue 10 §5: the line keeps
    # its own self-blame; the choice only names it.)
    ok = challenge("Phildendrin is waiting for something.",
                   ["Say sorry, for all of it", "\"Meat Meat did nothing wrong.\"", "Say nothing"], 0)
    if ok
      say([as(:meat_meat, "Meat Meat is sorry. For the man. For the cell. For not looking for you."),
           "PHILDENDRIN: (holding on a long time) ...I'm sorry too. I'm sorry I let them take you."], event_id)
      set_flag(:mm_reconciled)
    else
      say(["PHILDENDRIN: (holding on anyway) It's all right. You don't have to say anything. Not yet."])
    end
    if flag?(:child_saved)
      say(["The rescued child's parents push through to the bars. \"She saved our girl.\""])
      set_flag(:child_parents)
    end
    # Her want stays her daughter's; the errand is one line, and where to go.
    say(["PHILDENDRIN: They'll judge you on one killing. So give them something else to judge.",
         "PHILDENDRIN: There's a mirror in the Heartroot's wells. Autumn spied on the city with it.",
         "PHILDENDRIN: Break it. Let the faces out. Then they can't say you only know how to hurt.",
         as(:meat_meat, "Meat Meat breaks things very well. Mama will see.")], event_id)
    if ok && pbConfirmMessage(_INTL("Ask Phildendrin to stand for one of the Council's empty chairs?"))
      say([as(:meat_meat, "Mama should sit in a chair. A Council one. And make them be fair."),
           "PHILDENDRIN: (laughing, wet-eyed) An outsider? They'll want ten names on a petition.",
           "PHILDENDRIN: ...All right. For you."], event_id)
      start_petition(:phildendrin)
    end
    set_switch(SW_PHIL_MIRROR, true)
    add_counter(:story_beats)
    side_goal(:mm_mirror, "Meat Meat's trial: break Autumn's spying mirror, in the Sap Wells under the Root Gate.", done: :mm_atoned)
    trial_week_goal
  end

  def phildendrin_after(event_id = nil)
    if (flag?(:mm_reconciled) || flag?(:candidate_phildendrin)) && !flag?(:petition_phildendrin) && !nominated?(:phildendrin)
      say(["PHILDENDRIN: My daughter wants me in a chair. A Council one. ...Is she always this bossy?"], event_id)
      return start_petition(:phildendrin) if pbConfirmMessage(_INTL("Encourage her to stand?"))
    end
    say(lines_for(:phildendrin_after), event_id)
  end

  def autumn_mirror(event_id = nil)
    return say(["Shards of a tall mirror. The faces are gone. Only yours, in pieces."], event_id) if flag?(:mm_atoned)
    return say(["A tall mirror, its glass dark and greasy. Something moves behind it."], event_id) if !flag?(:phildendrin_found)
    say(["A tall mirror in a frame of red-lacquered root.",
         "Faces press against the glass from inside: dozens. People Autumn watched, and kept.",
         "At the very back, a woman with white hair turns and looks out at you. Then she's gone.",
         as(:meat_meat, "(very still) ...White hair. Meat Meat knows white hair."),
         flag?(:avarice_doubt) ? "(You think of the arms in the glass. No sigils.)" : nil,
         cl(:wyn, "(barely a whisper) ...They're so tired. Let them out.")].compact, event_id)
    return if !pbConfirmMessage(_INTL("Break Autumn's mirror?"))
    mspot = stage_spot(stage_event(event_id))
    return if !boss_battle(named_mon(:B122H429, 55, "Mirror Wraith"))
    Stage.fx("E-06", mspot, frames: 10, oy: 32)          # the mirror falls in pieces
    # (dialogue 10 §3: no flash-forward to a court that isn't sitting; her
    # testimony plays at the verdict, from WITNESSES)
    say(["The wraith comes apart, and the mirror with it.",
         "The faces drift out of the shards like breath on a cold morning. They thin, and are gone.",
         "One of them, an old man, waves.",
         as(:meat_meat, "(watching them go) Faces kept behind glass. Meat Meat knows that cage."),
         herald?(:meat_meat) ? "(Mama will tell the court what you did here.)" : "(Phildendrin will tell the court what her daughter did here.)"])
    set_flag(:mm_atoned)
    set_switch(SW_PHIL_MIRROR, false)
    set_flag(:candidate_phildendrin)
    add_support(:phildendrin, 1)
    add_counter(:story_beats)
    trial_work_done
  end

  # Rheven, at the wall: testimony about Autumn (Q2) and the sigil horns (Q6).
  def rheven_wall(event_id = nil)
    say(["Captain Rheven Stormbranch, in a wolf-skin cloak, directing the wall-crews like a battle.",
         "RHEVEN: (voice like grinding ice) Heralds. Lift, or talk. Preferably lift."], event_id)
    opts = []
    opts << [:autumn, _INTL("\"What was Autumn planning?\"")] if !flag?(:rheven_testimony)
    opts << [:horns, _INTL("\"Where did those beasts come from?\"")] if !flag?(:rheven_horns)
    opts << [:anduin, _INTL("\"Would the wardens accept Anduin?\"")] if flag?(:petition_anduin) && !flag?(:rootwardens_accept_anduin)
    opts << [:bye, _INTL("Leave him to it")]
    c = pbMessage(_INTL("Ask Rheven..."), opts.map(&:last), opts.size - 1)
    pick = opts[[c, 0].max][0]
    case pick
    when :autumn
      angered = flag?(:rootwardens_angered)
      say(["RHEVEN: (not looking up) You burned a colony under my docks. Don't expect favours."]) if angered
      if (flag?(:wall_helped) && !angered) || challenge("Rheven looks at you a long time.", ["\"You saw the pens. You know.\"", "\"Tell us or we'll find out.\"", "\"Never mind.\""], 0)
        say(["RHEVEN: (lowering his voice) Autumn kept lists. Refugees, by name and by weight.",
             flag?(:heist_exposed) ? "RHEVEN: Darrus drew them up; Maera Vell took them below. Sacrifices, to Auril or Summer." :
                                     "RHEVEN: Darrus meant them as sacrifices, to Auril or to Summer. I never learned which.",
             "RHEVEN: I should have said so the day he drew them up. Put me in front of the crystals."])
        set_flag(:rheven_testimony)
      else
        say(["RHEVEN: Threats? To a Rootwarden captain? Come back when you've learned manners."])
      end
    when :horns
      say(["RHEVEN: The Still Beasts. Bone-and-ice constructs, out on the thaw line. We burned most.",
           "He pulls a horn out of a sack: carved, delicately, with an arcane mark."])
      if challenge("He weighs whether to give it to you.", ["Ask for it as evidence, for the city", "Ask for it as a trophy", "Just take it"], 0)
        say(["RHEVEN: Avarice's mark. She loosed them on travellers. Take it. Show them."])
        give_key(:FT_SIGILHORN)
        set_flag(:rheven_horns)
      else
        say(["RHEVEN: (putting it back) No."])
      end
    when :anduin
      if flag?(:anduin_reconciled) && challenge("Rheven distrusts gods, and outsiders.",
                                                ["\"He wants fewer gods. Like you.\"", "\"He's harmless.\"", "\"He's Reptin's husband.\""], 0)
        say(["RHEVEN: Fewer god-sparks. ...Hm. A man who'd say that out loud in the Bazaar has nerve.",
             "RHEVEN: The wardens won't stand in his way."])
        set_flag(:rootwardens_accept_anduin)
        check_nomination(:anduin)
      else
        say(["RHEVEN: An outsider who married a god. No."])
      end
    end
  end

  #-----------------------------------------------------------------------------
  # SC 10.04 - Absent Watcher (Wyn)
  #-----------------------------------------------------------------------------
  # The summons: a Rootwarden emissary, an old friend, outside the Echo Gate.
  def wyn_emissary(event_id = nil)
    if flag?(:wyn_summoned)
      return say(["SORREL: I'm sorry it was me who had to hand it to you. I asked to be the one, though."], event_id)
    end
    say(["A Rootwarden in a cloak too big for her waits by the Echo Gate, a sealed citation in hand.",
         herald?(:wyn) ? "(Sorrel. You learned the Underdark watch together, three winters ago.)" :
                         "WYN: (going very still) ...Sorrel.",
         "SORREL: (holding it out) Wyn. The Council summons you, to account for your absence.",
         "SORREL: I told them you'd never just leave. Prove me right. Please."], event_id)
    speak(:wyn, "...I'll come. I'll tell them everything.", "...I'll come.")
    set_flag(:wyn_summoned)
    set_switch(SW_WYN_HEARING, true)
    side_goal(:wyn_hearing, "Wyn's hearing, in the Council Hall.", done: :wyn_cleared)
    trial_week_goal
  end

  def wyn_hearing(event_id = nil)
    return say(lines_for(:kethan_after), event_id) if flag?(:wyn_cleared)
    if flag?(:wyn_heard)
      return wyn_alibi if flag?(:underdark_door_seen)
      say(["KETHAN: Go down to the door with my wardens. Look at what you left. Then we'll talk again."], event_id)
      return if !pbConfirmMessage(_INTL("Go down to the Underdark Door now?"))
      return transfer(2077, 9, 30, 8)
    end
    say(["The Council Hall, the crystals dim. At the bench, a captain grey at the temples:",
         "Kethan Vale, captain of the Hall watch. He reads the charge himself.",
         "KETHAN: You left your post, Rootwarden: the Sap Gate, over the old door to the Underdark.",
         "KETHAN: The night it broke, cultists came through.",
         "KETHAN: Explain, or don't. I'll judge your silence too."], event_id)
    believed = 0
    spoke = false
    if herald?(:wyn)
      # Context 10 §6: in Wyn Mode the account is what the prologue showed: a mirror took you.
      c = pbMessage(_INTL("Your account."), [_INTL("A mirror took me"), _INTL("Hyphora called me"), _INTL("Say nothing")], 0)
      if c == 0
        say(["(A mirror took me. In the Sap Gate. I fell four hundred years.)",
             "KETHAN: (flat) Four hundred years.",
             "SELRAE: A mirror, a god-spark and a sapling that sings. How convenient.",
             "KELYN: (to the room) Four Heralds came back out of that night with Wyn. Ask them."])
        believed += 1
        spoke = true
      end
    else
      c = pbMessage(_INTL("Wyn's account."), [_INTL("Hyphora called me"), _INTL("I had a prophetic dream"), _INTL("Say nothing")], 0)
    end
    if spoke
      believed += 1 if flag?(:godspark_shadow)
    elsif c == 0 || c == 1
      speak(:wyn, c == 0 ? "(at the bar) Hyphora called me. That night. The spores sang my name, and I went." :
                           "(at the bar) I dreamed the roots were burning. I went to see. They were.",
            "...She called me. And I went.")
      believed += 1 if flag?(:godspark_shadow)
      # Context 10 M10-5: the player saw half of that night (Ch6, the festival): they're a witness.
      if !herald?(:wyn)
        say(["WYN: The spores at the Sap Gate went quiet. They never go quiet. So I ran up.",
             "WYN: To the festival, to tell the Captain. ...They saw me. Ask them."])
        kethan = stage_event("Captain Kethan Vale (hearing)")
        Stage.turn_to(kethan) if kethan
        say(["KETHAN: (turning) You. Did you?"])
        s = pbMessage(_INTL("Did you see Wyn at the festival?"), [_INTL("Yes. Out of breath, with a Sableye"), _INTL("I don't remember")], -1)
        if s == 0
          $game_screen.start_flash(Color.new(60, 200, 90, 110), 10) rescue nil
          say(["KETHAN: (the green crystal brightens) Then the door broke after the Rootwarden left it."])
          set_flag(:wyn_seen_testified)
          believed += 1
        else
          say(["KETHAN: Then the door will have to tell us itself."])
        end
      end
      say(["SELRAE: A god-spark, and a sapling that sings. Convenient."])
      if with_or_is?(:alberica) && flag?(:fungal_liaison)
        speak(:alberica, "(as the Council's Fungal Liaison) The spores do sing. Constantly. It's exhausting.",
                         "...The spores do sing. Constantly.")
        believed += 1
      end
      opts = ["Call on Eira's spore-guard", "Show them the god-spark", "Demand they take your word"]
      if challenge("Make your case.", opts, [0, 1])
        believed += 1
        if @last_pick == 1
          say([herald?(:wyn) ? "You open your hand. The god-spark of shadow sits in it, dark and warm." :
                               "Wyn opens a hand. The god-spark of shadow sits in it, dark and warm.",
               "KETHAN: (leaning back) ...That's not a thing you find in a ditch."])
        else
          # (notes/10 E23: the witness you called stands up and speaks)
          eira = Stage.actor(:eira, $game_player.x + 3, $game_player.y + 1, 8, graphic: "FT_myconid_eira")
          Stage.turn_to(eira) if eira
          say(["From the back of the Hall, Eira's spore-guard lift their caps.",
               "EIRA: (a cold creek over stones) The spores called. We heard it. The Rootwarden went."])
        end
      else
        say(["KETHAN: Your word is what's on trial, Rootwarden."])
      end
    else
      say(["Wyn says nothing. The silence is noted."])
      trial[:mud] += 1
    end
    if flag?(:rootwardens_angered)
      say(["KETHAN: (flatly) And this is the Rootwarden whose friends burned a colony under our docks."])
      believed -= 1
    end
    if believed >= 1
      say(["KELYN: (slowly) ...I'm willing to think there's another explanation. Kethan?"])
    else
      say(["KETHAN: Then the door will tell us. Wardens: take Wyn down."])
    end
    set_flag(:wyn_heard)
    set_flag(:wyn_hearing_believed) if believed >= 1
    say(["KETHAN: You'll go down to the door with my wardens, and look at what you left."])
    return if !pbConfirmMessage(_INTL("Go down to the Underdark Door now?"))
    transfer(2077, 9, 30, 8)
  end

  # The captain at the old guard tunnels during the trial week (the Root-Tier
  # event). Not `kethan`: that's the Rootwarden Hall's captain (048).
  def kethan_tunnels(event_id = nil)
    return say(lines_for(:kethan_after), event_id) if flag?(:wyn_cleared)
    if !flag?(:wyn_heard)
      return say(["Captain Kethan Vale, grey at the temples, waits at the mouth of the old guard tunnels.",
                  "KETHAN: Not without a hearing. The Council Hall first, Rootwarden."], event_id)
    end
    say(["KETHAN: Down you go. My wardens will walk with you."], event_id)
    return if !pbConfirmMessage(_INTL("Go down to the Underdark Door?"))
    transfer(2077, 9, 30, 8)
  end

  # Kethan's two wardens walk the tunnels with you (notes/10 E1: they're on
  # screen whenever they speak; they keep a step behind you, out of sight
  # between the scenes, and come up beside you when there's trouble).
  UNDERDARK_WARDENS = { warden_teague: "BW029", warden_oda: "BW048" }

  def underdark_wardens
    UNDERDARK_WARDENS.each_with_index.map do |(key, look), i|
      ev = stage_event("stage_#{key}")
      side = i.zero? ? -1 : 1
      x, y = $game_player.x + side, $game_player.y + 1
      if ev
        ev.moveto(x, y) if !Stage.on_screen?(ev)
        ev.direction = 8 rescue nil
        ev
      else
        Stage.actor(key, x, y, 8, graphic: look)
      end
    end
  end

  def scene_underdark_crawl
    return if flag?(:underdark_crawl_started)
    set_flag(:underdark_crawl_started)
    underdark_wardens
    sayc(["The old guard tunnels. Kethan's two wardens fall in either side of you, spears low.",
          "WARDEN TEAGUE: Shadow things since the door broke. Quick ones in the water. Unseen ones.",
          "WARDEN ODA: Stay off the black pools. Things in them pull.",
          cl(:wyn, "(very quietly) ...I used to know every stone of this. Now I don't.")])
  end

  # Stalkers and swarms along the way (Q3.2): the notes' quipper swarms and
  # spore-lash creepers, from the Mycolith's lake.
  def underdark_ambush(which, event_id = nil)
    key = :"underdark_#{which}"
    return if flag?(key)
    underdark_wardens
    case which
    when :pool
      say(["The black pool by the path boils. A swarm of shadow-dark fish comes up, all teeth.",
           "WARDEN ODA: Quippers! Back from the edge!"], event_id)
      return if !boss_battle(named_mon(:B318H92, 54, "Shadow Quipper Swarm"), named_mon(:B318H92, 54, "Shadow Quipper Swarm"))
    when :weeds
      say(["What looked like lake-weed lashes out of the water and wraps round your ankle.",
           "WARDEN TEAGUE: Creeper! Cut it, don't pull!"], event_id)
      return if !boss_battle(named_mon(:B114H72, 55, "Spore-Lash Creeper"))
    when :stalker
      say(["The air in front of you moves. Something you can't see is standing there, breathing.",
           cl(:wyn, "(whispering) That's one of Eira's sentinels. ...Someone turned it.")].compact, event_id)
      return if !boss_battle(named_mon(:B353H202, 55, "Invisible Stalker"))
    end
    set_flag(key)
    set_self_switch(event_id, "A") rescue nil
  end

  def underdark_door(event_id = nil)
    return say(lines_for(:underdark_circle), event_id) if flag?(:wyn_cleared)
    underdark_wardens
    speak(:wyn, "(at the broken door) Every night, I watched this. ...Every night but one.",
                "(at the broken door) ...Every night but one.", event_id)
    say(lines_for(:underdark_circle))
    if !flag?(:ritual_runes)
      if challenge("Search the circle.", ["Look for scorch marks and carving", "Touch the centre", "Step round it"], 0)
        say(["Scorched runes. Shards of ice carved with Auril's sigil, still cold after weeks.",
             "WARDEN TEAGUE: That's Halo work. Fresh."])
        give_key(:FT_RITUALRUNES)
        set_flag(:ritual_runes)
      else
        say(["The circle flares when you step in it. Frost bites your boots. It's still working."])
      end
    end
    say([cl(:alberica, "(a hand on her rune) ...I know that snowflake. I wake up wearing it."),
         as(:wyn, "They broke the seal themselves. If I'd stayed, I'd be in that circle."),
         cl(:alberica, "(plainly) Selrae told the Hall she let them in. Then charged you with this door."),
         with_or_is?(:alberica) ? as(:wyn, "(barely) ...Then she knew which door they'd come in by.") : nil,
         cl(:meat_meat, "Then mushroom friend was right to go. Meat Meat is a witness now.")].compact)
    set_flag(:underdark_door_seen)
    say(["(Kethan waits in the Council Hall. Ivo, at the tunnel mouth, saw that night too.)"])
  end

  # Ivo, the junior Rootwarden left at the door. (The notes name Darrus Fell
  # here, but Darrus is the Autumn Warden: this is the junior warden who was
  # left in his place. The function keeps its old name for old saves.)
  def pell(event_id = nil)
    return say(["IVO: (standing straighter) If they want it twice, they can have it twice."], event_id) if flag?(:pell_testifies)
    return say(["IVO: (not meeting anyone's eye) I've got nothing to say."], event_id) if flag?(:pell_refused)
    say(["A young Rootwarden, barely shaving, holds his spear at the tunnel mouth like a broom.",
         "IVO: I was on the door that night. After Wyn went. They left me there alone."], event_id)
    if pbConfirmMessage(_INTL("Ask Ivo what he saw that night?"))
      ok = challenge("Ivo is frightened.", ["Promise Wyn will clear his name too", "Tell him it's his fault if he lies", "Offer him money"], 0)
      if ok
        speak(:wyn, "I'll tell them you held. Alone. That's more than I did.", "...You held. Alone.")
        say([(herald?(:wyn) ? "IVO: (to you) " : "IVO: (to Wyn) ") + "...You'd say that? Out loud? Then I'll tell it.",
             "IVO: (in a rush) Rootwardens came. Our cloaks, our spears. Their breath didn't fog.",
             "IVO: They walked past the wards like the wards were nothing, and I let them, because they were us."])
        set_flag(:pell_testifies)
      else
        say(["IVO: (going red) It was Wyn's door. Ask Wyn. I've nothing to say."])
        set_flag(:pell_refused)
        trial[:mud] += 1
      end
    end
  end

  # The alibi from Hyphora (Q3.4): asked of the crystals at the Council.
  def wyn_alibi
    return if flag?(:wyn_cleared)
    have = %i[ritual_runes pell_testifies wraith_witness_door brisa_home].count { |f| flag?(f) }
    # (dialogue 10 §4: not a Prompter; the hostile voice in the room asks for it)
    say(["Back at the Council, the crystals are asked for Hyphora's account.",
         "SELRAE: (from the dock) A dream and a sapling. Show me something I can hold."])
    lines = []
    lines << "(The ritual runes: the Halo's own snowflake, carved at the door.)" if flag?(:ritual_runes)
    lines << "(Ivo's account: wardens whose breath didn't fog.)" if flag?(:pell_testifies)
    lines << "(The wraith's vision, in its vial: cultists chanting, Wyn far away.)" if flag?(:wraith_witness_door)
    lines << "(Warden Brisa: wardens' cloaks walked past her patrol that night. No breath in the cold.)" if flag?(:brisa_home)
    say(lines) if !lines.empty?
    boost = flag?(:fungal_liaison) && with_or_is?(:alberica)
    if have >= 1 || boost || flag?(:wyn_hearing_believed)
      $game_screen.start_flash(Color.new(60, 200, 90, 130), 16) rescue nil
      pbSEPlay("Saint1") rescue nil
      say(["The green crystal flares, and a whisper fills the hall:",
           "HYPHORA: ...the one who walks in shadow. I called. Wyn came."])
      if flag?(:godspark_shadow)
        say(["KETHAN: And you came back with a god's spark. Rootwardens have been promoted for less."])
      end
      say(["KETHAN: Reprimanded. The post is yours, Rootwarden, if you want it."])
      speak(:wyn, "(very small) ...I'll take it. I won't leave it again.", "...I won't leave it again.")
      set_flag(:hyphora_alibi)
      set_flag(:wyn_cleared)
    else
      say(["The crystals stay dark. Nobody asked them the right way.",
           "KETHAN: A term of service on the Echo Gate. And the Rootwardens' stores are closed to you."])
      set_flag(:wyn_cleared)
      set_flag(:wyn_barred)
    end
    add_counter(:story_beats)
    trial_work_done
  end

  #-----------------------------------------------------------------------------
  # SC 10.05 - Brother from Beyond (Alerion)
  #-----------------------------------------------------------------------------
  def talion_resolved?
    %i[talion_released talion_chased talion_restored talion_haunted].any? { |f| flag?(f) }
  end

  def talion(event_id = nil)
    return say(["Only flowers, blooming through snow, where he stood."], event_id) if talion_resolved?
    al = herald?(:alerion)
    if !flag?(:talion_met)
      say(["A commotion at the edge of the Fields. People whisper about a boy back from the dead.",
           "He stands in flowers that bloom through the snow. He looks fourteen.",
           al ? "Your brother never lived to be fourteen." : "Alerion's brother never lived to be fourteen.",
           "His eyes are vacant. His breath doesn't fog.",
           "TALION: (reciting) You told me to stay in the house. You said you'd come back.",
           "TALION: You came back. You came back. You came back."], event_id)
      say([as(:alerion, "(not moving) Talion.")])
      say(["(People have heard whispers at the Echo Gate for weeks: a boy's name, in the ice.)"]) if flag?(:talion_foreshadowed)
      set_flag(:talion_met)
    end
    opts = []
    opts << [:pulse, _INTL("Check him: breath, pulse, skin")] if !flag?(:talion_checked)
    opts << [:listen, _INTL("Listen to how he talks")] if !flag?(:talion_listened)
    opts << [:embrace, _INTL(al ? "Hold him" : "Let Alerion hold him")] if !flag?(:talion_embraced)
    opts << [:memento, _INTL(al ? "Think of a keepsake" : "Ask Alerion about a keepsake")] if with_or_is?(:alerion) && !($PokemonBag.pbHasItem?(:FT_TALIONWHISTLE) rescue false)
    # (notes/10 E17: decide only after at least one look at him)
    looked = %i[talion_checked talion_listened talion_embraced].any? { |f| flag?(f) }
    opts << [:resolve, _INTL("Decide what to do")] if looked
    opts << [:leave, _INTL("Not yet")]
    c = pbMessage(_INTL("Talion..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :pulse
      say(["His body is there: solid, cold. No pulse. His skin is cold as Glasswater, and as smooth."])
      set_flag(:talion_checked)
    when :listen
      say(["TALION: You told me to stay in the house. The lake was so pretty. ...You came back.",
           "(Patchy. As if he's reciting things someone once said, not saying them.)"])
      set_flag(:talion_listened)
    when :embrace
      say([al ? "You put your arms round him." : "Alerion puts his arms round him.",
           "Talion goes stiff as a board.",
           "TALION: (a whisper) This isn't real."])
      if challenge("Talion goes stiff in his arms.", ["Plead with him, gently, to remember", "Shake him", "Let go"], 0)
        say(["TALION: (slowly) ...You were kneeling by the water. Your hands were in it, glowing.",
             "TALION: There was a mirror in the ice. It cracked. Then I was... here, and here, and here."])
        set_flag(:talion_memory)
      else
        say(["Talion's face goes flat as glass, and stays that way."])
      end
      set_flag(:talion_embraced)
    when :memento
      say([al ? "In the bottom of your pack, where you never look: a wooden whistle. You carved it the winter before." :
                "ALERION: (after a long time, digging in his pack) ...This. I carved it for him.",
           "A little whistle, carved the winter before. Talion's head turns at the sight of it."])
      give_key(:FT_TALIONWHISTLE)
    when :resolve
      talion_resolve(event_id)
    end
  end

  # Context 10 §4: the case's best evidence names a man nobody has described.
  def gold_man_named
    herald?(:alerion) ? cl(:reptin, "(quietly) Var. The Marshal. He means the Marshal.") :
                        cl(:alerion, "(quietly) Var. The Marshal. He means the Marshal.")
  end

  def talion_resolve(event_id = nil)
    al = herald?(:alerion)
    if al
      # Context 10 §6: in Alerion's own mode, the look before the decision is his memory.
      say(["(You were kneeling by the water. Your hands were glowing.)",
           "(You wanted him back so badly the lake listened.)"])
    end
    say([al ? "(Nobody can decide this for you. Nobody ever could.)" : "Alerion looks at you, and doesn't ask."])
    c = pbMessage(_INTL("Talion..."), [_INTL("Let him go"), _INTL("The ritual at the lake, at night"),
                                       _INTL(al ? "Hold on to him" : "Let Alerion hold on to him"), _INTL("Not yet")], 3)
    case c
    when 0
      boy = stage_event(event_id)
      dx, dy = boy ? [boy.x - $game_player.x, boy.y - $game_player.y + 1] : [0, -1]
      stage_act(:alerion, :kneel, dx: dx, dy: dy, dir: 8)   # kneeling to hold him
      Stage.overlay("O-03", opacity: 200, fade: 20)
      say([al ? "You kneel and hold your brother, and you let go of him." : "Alerion kneels and holds his brother, and lets go of him.",
           "Talion smiles, and fades like breath on glass."])
      boy.opacity = 0 if boy rescue nil
      Stage.overlay_off("O-03", fade: 20)
      say(["As he fades, every mirror in the Bazaar fogs. The same words write themselves in each:",
           "\"The tall gold man had no reflection. None. For years.\"",
           (cl(:reptin, "(quietly) Var. The Marshal. He means the Marshal.") || gold_man_named),
           cl(:wyn, "(sitting down beside him) ...You don't have to talk."),
           with_or_is?(:wyn) ? as(:alerion, "I know. That's why I can.") : nil,
           as(:alerion, "...He was nine. He'd have liked all of you. Even the loud ones.")].compact)
      # (notes/10 E17: he stays on screen through it, then walks off on his own a while)
      walker = al ? nil : stage_event("stage_alerion")
      if walker
        Stage.unpose(walker) rescue nil
        say(["Alerion gets up, and walks out into the Fields on his own for a while."])
        Stage.leave(walker, walker.x + 8, walker.y)
      end
      Stage.cleanup rescue nil
      set_flag(:talion_released)
      wheel(1)
      add_counter(:story_beats)
      trial_work_done
    when 1
      say(["The Mirror-Lake. The Glasswater, past the Wall, on a clear night.",
           "You'll need a memento of him, a mirror with no crack in it, and to know what you're doing."])
      set_flag(:talion_ritual_chosen)
      set_switch(SW_TALION, true)
      side_goal(:talion, "Talion's ritual: the Glasswater, past the Fields, at night. A memento and a mirror.", done: %i[talion_released talion_chased talion_restored talion_haunted])
    when 2
      say([al ? "You reach for the necromancy." : "Alerion reaches for the necromancy.",
           "Talion's face goes hungry and grey. The flowers round his feet frost over.",
           "TALION: (in a voice like ice cracking) Stay. Stay in the house."])
      skirmish(named_mon(:B92H122, 56, "Mirror-Blade Specter"))
      say(["Afterwards, Talion is gone anyway. Not gone. Watching. You can feel it."])
      quiet = Stage.herald(:alerion, 1, 0, 2) if with_or_is?(:alerion)
      Stage.balloon(quiet, "B-01", frames: 60) if quiet
      say(["#{al ? 'You say' : 'Alerion says'} nothing for an hour.",
           "The testimony still comes, from the wraiths, through the Bazaar's mirrors:",
           "\"The tall gold man had no reflection. None. For years.\"",
           gold_man_named].compact)
      Stage.cleanup rescue nil
      set_flag(:talion_chased)
      add_counter(:story_beats)
      trial_work_done
    end
  end

  # The ritual at the Mirror-Lake (Q4.3a): Alerion's necromancy, an intact
  # frost-glass mirror from Mira's stall, a memento.
  def talion_ritual(event_id = nil)
    return say(lines_for(:glasswater_still), event_id) if talion_resolved?
    al = herald?(:alerion)
    if !($PokemonBag.pbHasItem?(:FT_FROSTGLASS) rescue false)
      return say(["Talion stands at the edge of the night lake, looking in.",
                  "(The ritual needs a flawless frost-glass mirror. Mira sells them, at the Split Dock.)"], event_id)
    end
    say(["A clear night. The Glasswater holds the wrong stars.",
         "Talion stands at the edge, looking in, the way he must have once.",
         al ? "You kneel at the water and set the frost-glass on the ice." : "Alerion kneels at the water and sets the frost-glass on the ice."], event_id)
    edge = 0
    edge += 1 if ($PokemonBag.pbHasItem?(:FT_TALIONWHISTLE) rescue false)
    edge += 1 if flag?(:mira_ritual_advice)
    edge += 1 if flag?(:talion_lake_seen)
    edge += 1 if flag?(:wraith_riddle_understood)
    say(["(You have the carved whistle.)"]) if ($PokemonBag.pbHasItem?(:FT_TALIONWHISTLE) rescue false)
    say(["(Mira's advice: a clear night, and blood from both of them, to anchor the soul.)"]) if flag?(:mira_ritual_advice)
    ok = edge >= 2 || challenge("The ritual.", ["Blow the whistle, and call him by name", "Command him to stay", "Wait"], 0)
    take_key(:FT_FROSTGLASS)
    if ok
      say(["The frost-glass fills with light: a small boy in a house in Ten-Towns, waiting at a window.",
           "TALION: (his own voice, for the first time) ...Alerion? You're so old."])
      c = pbMessage(_INTL("The soul is anchored. Now..."), [_INTL("Let him go on, in peace"), _INTL("Bring him back, all the way")], 0)
      if c == 0
        say(["TALION: It's all right. Go back to them. I'll be at the window. I'm always at the window.",
             "He walks into the glass. The glass goes clear, and the lake gives back the right stars.",
             "Every mirror in Rootspire fogs as he goes. The same words write themselves in each:",
             "\"The tall gold man had no reflection. None. For years.\"",
           gold_man_named].compact)
        set_flag(:talion_released)
        wheel(1)
      else
        say(["The light comes up out of the glass and into him, and his breath fogs.",
             "He coughs. He shivers. He is fourteen years old and cold and furious.",
             "TALION: You said you'd come back! You said! ...You came back.",
             al ? "(You can't speak. You don't have to.)" : "ALERION: (he can't speak. He doesn't have to.)",
             "He tells the crystals what the lake showed him: \"The tall gold man had no reflection.\"",
           gold_man_named].compact)
        set_flag(:talion_restored)
      end
    else
      say(["The frost-glass cracks across. In every piece, Talion's face, and none of them look back.",
           "TALION: (from all the pieces) Stay in the house. Stay in the house. Stay.",
           al ? "He doesn't fade, and he doesn't live. A cold shape follows you now, at a distance." :
                "He doesn't fade, and he doesn't live. A cold shape follows Alerion now, at a distance."])
      set_flag(:talion_haunted)
    end
    set_switch(SW_TALION, false)
    add_counter(:story_beats)
    trial_work_done
  end

  # Mira: the mirror (Q2 evidence), the frost-glass and advice (Q4), the favour (Q6).
  def mira_trials(event_id = nil)
    say(["Mira of the North Wind, on the Requiem's deck, selling frost-glass to the brave.",
         "MIRA: Heralds! Murderers or saviours, you still need mirrors."], event_id)
    opts = []
    opts << [:who, _INTL("\"Who made the mirror that showed her?\"")] if !flag?(:mira_mirror_testimony)
    opts << [:glass, _INTL("Buy a frost-glass mirror ($1000)")] if !($PokemonBag.pbHasItem?(:FT_FROSTGLASS) rescue false) && flag?(:talion_met)
    opts << [:soul, _INTL("\"How do you free a reflection?\"")] if flag?(:talion_met) && !flag?(:mira_ritual_advice)
    opts << [:vial, _INTL("Buy a memory vial ($1500)")] if !($PokemonBag.pbHasItem?(:FT_MEMORYVIAL) rescue false)
    opts << [:return, _INTL("Give back the cursed mirror")] if flag?(:mira_mirror_taken) && !flag?(:mira_mirror_returned)
    opts << [:bye, _INTL("Nothing")]
    c = pbMessage(_INTL("Ask Mira..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :who
      if challenge("Mira's face closes like a shutter.", ["Tell her what it did to Ten-Towns", "Accuse her", "Offer to buy her story"], 0)
        say(["MIRA: (quietly) Autumn commissioned it. Darrus. Paid in sap, a whole season's worth.",
             "MIRA: He spied on Ten-Towners with it. To choose. I told myself it was a scrying shard.",
             "She reaches for the nearest mirror on her stall, and turns it face-down.",
             "MIRA: I'll say so in court. If you fetch me a cursed mirror of mine, from the Heartroot.",
             "MIRA: I won't have it found down there with my name on the frame."])
        set_flag(:mira_mirror_testimony)
        set_switch(SW_MIRA_MIRROR, true)
      else
        say(["MIRA: I sell mirrors, Herald. I don't answer for what people see in them."])
      end
    when :glass
      if $Trainer.money >= 1000
        $Trainer.money -= 1000
        give_key(:FT_FROSTGLASS)
        say(["MIRA: Untainted. Only your own face in it. For now."])
      else
        say(["MIRA: A thousand. I don't do credit to murderers. Or saviours."])
      end
    when :soul
      say(["MIRA: (not laughing) Do it on a clear night. A mirror with no crack in it.",
           "MIRA: And blood, his and yours. A soul in glass needs an anchor on both sides of it."])
      set_flag(:mira_ritual_advice)
    when :return
      mira_mirror_return
    when :vial
      if $Trainer.money >= 1500
        $Trainer.money -= 1500
        give_key(:FT_MEMORYVIAL)
        say(["MIRA: Holds one memory. Or one ghost's word. Don't drop it."])
      else
        say(["MIRA: Fifteen hundred. Vials don't grow on trees. Well. Not on this one."])
      end
    end
  end

  # Mira's favour: her cursed mirror, in the Heartroot (Q2/Q6).
  def mira_cursed_mirror(event_id = nil)
    return say(["An empty frame of red root."], event_id) if flag?(:mira_mirror_taken)
    say(["A hand-mirror in a frame of red root, on a ledge. The frame is stamped: MIRA, NORTH WIND.",
         "In the glass: a Mirror Sentinel, helmed and hollow, standing right behind you."], event_id)
    return if !boss_battle(named_mon(:B449H227, 55, "Mirror Sentinel"))
    say(["The sentinel falls in plates. The mirror goes quiet in your hand."])
    set_flag(:mira_mirror_taken)
    set_switch(SW_MIRA_MIRROR, false)
  end

  def mira_mirror_return
    return if !flag?(:mira_mirror_taken) || flag?(:mira_mirror_returned)
    say(["MIRA: (turning it face-down) ...Thank you. I'll drop it in the deep lake. Tonight.",
         "MIRA: You've earned my word in court. And my vote, if anyone's counting.",
         "MIRA: I'll stand for a chair, if you'll speak for me."])
    set_flag(:mira_mirror_returned)
    add_support(:mira, 2)
  end

  # Voices of the refugees (Q2): "Bring at least two refugees to speak at the trial."
  REFUGEE_WHO = { easthaven: "a fisherwoman from Easthaven", bryn: "a cooper from Bryn Shander", termalaine: "a miner from Termalaine" }

  def refugee_voice(which, event_id = nil)
    key = :"refugee_#{which}"
    who = REFUGEE_WHO[which]
    who_cap = who[0].upcase + who[1..]                      # (notes/10 §3: not "easthaven")
    # each one promises in their own voice (dialogue 10 §4: not the same "I'll say it" eight times)
    promise = { easthaven: "REFUGEE: Put me where they can see me. I'll tell them about the boats.",
                bryn: "REFUGEE: Twelve hours. I'll say the number to their faces.",
                termalaine: "REFUGEE: Put me at the front. I want them to see how light he was." }[which]
    return say(["REFUGEE: Front row. I'll be there."], event_id) if flag?(key)
    say(["#{who_cap}, wrapped in a Council blanket."], event_id)
    return if !pbConfirmMessage(_INTL("Ask: \"What did Autumn's followers do to you?\""))
    if challenge("They don't want to remember.", ["Sit down with them, and wait", "Tell them it's for the trial", "Pay them"], [0, 1])
      lines = { easthaven: ["REFUGEE: They took the catch. Every boat. Said it was for the Council.",
                            "REFUGEE: It went south, past the Wall."],
                bryn: ["REFUGEE: Forced labour on the Eastway. Ice-cutting, twelve hours a day.",
                       "REFUGEE: Anyone who stopped was 'reassigned'. We never saw them again."],
                termalaine: ["REFUGEE: They weighed us. Wrote our weights down. My boy was light. They took him first."] }[which]
      say(lines + [promise], event_id)
      set_flag(key)
      n = %i[refugee_easthaven refugee_bryn refugee_termalaine].count { |f| flag?(f) }
      if n >= 2 && !flag?(:refugees_testify)
        set_flag(:refugees_testify)
        add_support(:phildendrin, 1)
        say(["(Two refugees will speak at the trial. That carries.)"])
      end
    else
      say(["REFUGEE: (looking away) I don't want money. I want to forget."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # SC 10.06 - Spores of Contention (Alberica)
  #-----------------------------------------------------------------------------
  # The summons and debate, in the Council Hall.
  # Purpose: Selrae accuses Alberica of walking into a hundred minds; her own
  # fear comes out in the fight; the councillors agree to go and see.
  # (notes/10 E18: the real Kelyn and Selrae walk over; a clerk calls it.)
  FANE_GOAL = "Alberica's trial: Kelyn and Selrae wait inside the Sap Gate, the Undercanopy's door."

  def spores_debate(event_id = nil)
    return say(["KELYN: (still a little shaky) Three hundred years. Under our feet.", "KELYN: And we never once asked."], event_id) if flag?(:colony_recognised)
    return say(["SELRAE: The myconids are leaving. Tonight. Are you satisfied?"], event_id) if flag?(:colony_exiled)
    if flag?(:spores_debated)
      return say(["COURT CLERK: The councillors went down already. The Sap Gate, in the Root-Tier."], event_id)
    end
    # Owner's decision (M10-3): the charge is the Bryn Shander night; the spores are the comic half.
    say(["COURT CLERK: (ringing a little bell) The spores hearing! High Speaker! Matron!"], event_id)
    kelyn = stage_event("Kelyn of Spring")
    selrae = stage_event("Selrae Vorn")
    Stage.approach(selrae) if selrae
    Stage.approach(kelyn) if kelyn
    say(["SELRAE: A mind is a house. In Bryn Shander you walked into a hundred without knocking.",
         "SELRAE: Now the camp's children breathe spores that do the same. Glowing dust, in bed."])
    # (dialogue 09 §6, protected: her old answer to the spores, back where the spores are)
    speak(:alberica, "(under her breath) I sneezed.")
    say(["SELRAE: The Council never sanctioned a fungal colony under the city. Explain yourself.",
         "The Spring crystal pulses green."])
    speak(:alberica, "It's been here three hundred years. Come and meet it. Bring a hanky.",
                     "...It's been here three hundred years. Come and meet it.")
    # (dialogue 10 Top 3: her fear comes out in anger at the joke, not on request)
    say(["SELRAE: (cold) Joke, then. I've watched a forest go black and soft in one season.",
         "SELRAE: And I prayed to a god in my head for thirty years. I know what a voice costs."])
    speak(:alberica, "(gently) Then come and meet it. Three hundred years, and not one prayer.",
                     "(gently) ...Then come and meet it.")
    set_flag(:knows_winter_fear)
    adv = with_or_is?(:wyn) ? 1 : 0
    if with_or_is?(:wyn)
      speak(:wyn, "(very small, but out loud) I kept the door under those spores for three years. They kept me.",
                  "(very small, but out loud) ...They kept me.")
      set_flag(:ally_wyn_spores)
    end
    # (notes/10 E21: what would convince her, said before the hearing, not after)
    say(["KELYN: (to you, low) Bring her something older than her fear. The Library keeps those."])
    c = pbMessage(_INTL("The councillors wait."), [_INTL("Say what the spores do"), _INTL("Say it's harmless, mostly"),
                                                  _INTL("Say it's none of their business")], -1)
    ok = c == 0
    if c == 0
      say(["You tell them: the spores feed the tree's roots, and let the myconids speak to each other."])
    elsif c == 1
      say(["SELRAE: \"Mostly.\""])
    elsif c == 2
      # (Q5: "Combat may erupt if the party refuses.")
      say(["SELRAE: None of our business. Under our own roots. ...Wardens.",
           "Two of Selrae's wardens step off the wall, spears level."])
      if pbTrainerBattle(:FT_ROOTWARDEN, "Selrae's Warden", nil, false, 0, true)
        say(["KELYN: (between you, very quietly) Enough. This is the Council Hall. Call them off.",
             "SELRAE: (calling them off) Then they'll answer for themselves, down there."])
      else
        pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
        say(["The wardens put you on the floor of the Council Hall, in front of the crystals.",
             "KELYN: (very cold) Enough. Let them up. We'll go down and see for ourselves."])
        trial[:mud] += 1
      end
      set_flag(:spores_fought)
    end
    if ok || adv > 0
      say(["KELYN: (to Selrae) Well. I'd like to see it. Wouldn't you?", "SELRAE: ...Fine. Show us."])
    else
      say(["SELRAE: Then they'll answer for themselves, down there. I'll watch for blight all the way."])
      set_flag(:spores_mistrust)
    end
    set_flag(:spores_debated)
    side_goal(:fane, FANE_GOAL, done: %i[colony_recognised colony_exiled])
    trial_week_goal
  end

  def councillors_undercanopy(event_id = nil)
    return say(["KELYN: (still a little shaky) Three hundred years. Under our feet.", "KELYN: And we never once asked."], event_id) if flag?(:colony_recognised)
    return say(["The councillors are gone. The myconids are packing."], event_id) if flag?(:colony_exiled)
    if !flag?(:spores_debated)
      return say(["KELYN: We'll hear it properly, Alberica. In the Council Hall. Come and make your case."], event_id)
    end
    say(["KELYN: Lead on. I've never been below the Root-Tier. I'm told it glows."], event_id)
    return if !pbConfirmMessage(_INTL("Take Kelyn and Selrae through the Undercanopy to the Fane?"))
    # (notes/10 E5: the walk down is a walk, with both of them beside you, not a
    # scene played at the door; then the Fane, with the Sovereign on screen)
    ["Kelyn and Selrae", "Selrae (Undercanopy)"].each { |n| (e = stage_event(n)) && (e.transparent = true) }
    Stage.cleanup                                    # (a jump on the same map keeps the old actors)
    (pbFadeOutIn { Stage.jump(*ESCORT_SPOT) }) rescue (Stage.jump(*ESCORT_SPOT) rescue nil)
    px, py = $game_player.x, $game_player.y
    Stage.actor(:kelyn, px - 1, py, 6, graphic: "FT_high_speaker_kelyn_of_spring")
    Stage.actor(:selrae, px - 2, py, 6, graphic: "FT_winter_matron_selrae_vorn")
    say(["The councillors follow you down through the glowing beds.",
         "Selrae keeps her hands in her sleeves. Kelyn keeps stopping to look.",
         cl(:wyn, "(shyly, to Kelyn) ...That one's a lantern-cap. It likes being looked at.")].compact)
    skirmish(named_mon(:PARASECT, 52, "Parasect"))
    if challenge("Something's wrong with the dark ice by the path.", ["Stop, and look properly", "Keep moving", "Throw a lantern-puff at it"], [0, 2])
      say(["Two shapes in the ice wear your faces, waiting. You go the long way round, unseen.",
           "SELRAE: (very quietly) ...Thank you."])
    else
      say(["The dark ice opens like eyes. Mirror Wraiths step out of it."])
      skirmish(named_mon(:B122H429, 53, "Mirror Wraith"), named_mon(:B122H429, 53, "Mirror Wraith"))
    end
    say(["Halfway across the gardens, the ceiling groans."])
    $game_screen.start_shake(7, 8, 24) rescue nil
    pbSEPlay("Earth3") rescue nil
    Stage.wait(20)
    say(["It comes down in a slide of rock and roots. You get everyone through.",
         "Kelyn's cloak doesn't make it."])
    speak(:alberica, "Lose the cloak, Councillor. You look ten years younger.", "...Leave the cloak.") if with_or_is?(:alberica)
    skirmish(named_mon(:BRELOOM, 53, "Breloom"))
    fane_arrival(event_id)
    say(["LUMINARA: (to the councillors) Surface. Sap-takers.",
         "LUMINARA: Our spores feed her. Hyphora. They knit her roots.",
         "LUMINARA: They let us speak, all of us, to all of us.",
         "SELRAE: (very low) All of you. In each other's heads.",
         "LUMINARA: Three hundred years we've done it. Under your feet. You never asked."])
    has = ->(item) { ($PokemonBag.pbHasItem?(item) rescue false) }
    set_flag(:blessed_leaf_shown) if has.(:FT_BLESSEDLEAF)
    set_flag(:tincture_shown) if flag?(:knows_winter_fear) && (flag?(:tincture_given) || has.(:FT_FROSTBITETINCTURE))
    set_flag(:history_shown) if has.(:FT_HISTORYSCROLL)
    score = 0
    score += 1 if !flag?(:spores_mistrust)
    score += 1 if flag?(:blessed_leaf_shown)
    score += 1 if flag?(:tincture_shown)
    score += 1 if flag?(:history_shown)
    score += 1 if flag?(:ally_wyn_spores)
    if with_or_is?(:reptin) && pbConfirmMessage(_INTL(herald?(:reptin) ? "Stand with them, for the colony?" : "Ask Reptin: \"Will you stand with us?\""))
      speak(:reptin, "I carried the seed. The mushrooms were here first. They've been very polite.",
                     "...The mushrooms were here first.")
      set_flag(:ally_reptin_spores)
      score += 1
    end
    say(["(You show them the blessed leaf, green as spring.)"]) if flag?(:blessed_leaf_shown)
    say(["(Selrae turns Yarro's tincture over in her hands. \"It cures frostbite?\" A long quiet.)"]) if flag?(:tincture_shown)
    say(["(Kelyn reads the Leaf of Old Alliances aloud: three world-trees, each kept by myconids.)"]) if flag?(:history_shown)
    if score >= 2
      # (dialogue 10 §4: her turn has a cause she can hold)
      say(["A sporeling drops a glowing cap into Selrae's palm. She looks at it a long time.",
           "SELRAE: ...Blight doesn't glow.",
           "SELRAE: I was wrong. Not every voice in a head is hers.",
           "KELYN: (sitting down on the floor of the Fane) A partnership, then. If you'll have us.",
           "LUMINARA: We have had you for three hundred years. Now you may have us."])
      memory_bubble_offer
      set_flag(:colony_recognised)
      set_flag(:fungal_liaison)
      add_support(:eirwen, 1)
      add_counter(:story_beats)
      say([herald?(:alberica) ? "(You're named the Council's Fungal Liaison.)" : "(Alberica is named the Council's Fungal Liaison.)"])
      speak(:alberica, "Fungal Liaison. At last, a title that matches my reputation.", "...Fungal Liaison.")
      say([cl(:reptin, "Please don't let her have it embroidered.")].compact)
    else
      say(["SELRAE: (standing) No. Spores in the children. The colony goes. Before the snows.",
           "LUMINARA: (very still) Then we go. As we came. Quietly.",
           "The Fane is very quiet for a long time."])
      if pbConfirmMessage(_INTL("Refuse to let the myconids be driven out?"))
        say(["Selrae calls her guard. The spore-guard raises its spears. It's very close.",
             "Then Kelyn steps between them, and the moment passes, and the myconids begin to pack."])
      end
      set_flag(:colony_exiled)
      add_counter(:story_beats)
    end
    trial_work_done
  end

  # The councillors walk you down to the Fane: put everyone in front of the
  # Sovereign, so the hearing happens where it says it does (WRITING_GUIDE §9a).
  ESCORT_SPOT = [2068, 10, 28, 8]       # the spore gardens, halfway down
  FANE_SPOT = [2068, 45, 19, 8]

  def fane_arrival(event_id)
    Stage.cleanup
    (pbFadeOutIn { Stage.jump(*FANE_SPOT) }) rescue (Stage.jump(*FANE_SPOT) rescue nil)
    px, py = $game_player.x, $game_player.y
    Stage.actor(:kelyn, px - 1, py, 8, graphic: "FT_high_speaker_kelyn_of_spring")
    Stage.actor(:selrae, px + 1, py, 8, graphic: "FT_winter_matron_selrae_vorn")
    say(["The Fane. Sovereign Luminara on her throne-cap, and the colony all round her, glowing."])
  end

  # The memory bubble (Q6): the day Avarice tried to fuse Mirror Wraith essence with spores.
  def memory_bubble_offer(asked = false)
    return if flag?(:memory_bubble)
    say(["LUMINARA: (to you) You smell of the summer. The one who wore the Marshal. Ask."]) if !asked
    if asked || challenge("Ask Luminara for the memory.", ["Ask for the day she came down", "Demand it as evidence", "Leave it"], 0)
      say(["LUMINARA: We do not show our young what we saw. But you have earned it.",
           "She lifts a glowing memory bubble."])
      Stage.overlay("O-03", fade: 20)
      say(["In it: Var's body, alone in the roots, feeding a mirror-wraith's essence into the spores.",
           "The spores scream without sound. The man's face peels back like a mask.",
           "Under it, a woman, smiling."])
      Stage.overlay_off("O-03", fade: 20)
      say(["KELYN: (very quietly, from the floor) ...Oh."])
      set_flag(:memory_bubble)
      add_support(:eirwen, 1)
    else
      say(["LUMINARA: Then keep your peace, and we keep ours."])
      set_flag(:bubble_declined)
    end
  end

  # Q6's evidence lead is its own audience with the Sovereign: if the bubble
  # wasn't asked for on the councillors' visit, ask for it now.
  def luminara_bubble(event_id = nil)
    return say(["LUMINARA: The memory is yours to carry. Carry it gently."], event_id) if flag?(:memory_bubble)
    if flag?(:colony_exiled)
      return say(["LUMINARA: (packing spore-lanterns) We are leaving, surface-friend. Our memories come too."], event_id)
    end
    if flag?(:bubble_declined_twice)
      return say(["LUMINARA: We have said no. Our young must not see it. Not even for you."], event_id)
    end
    say(["You ask for an audience. The spore-guard lets you through to the Fane's throne-cap.",
         "LUMINARA: (wind through reeds) You come asking, asking, again. For the summer's memory."], event_id)
    if challenge("Ask Luminara for the day Avarice came into the roots.",
                 ["Promise: never shown to children", "Tell her the court demands it", "Beg"], 0)
      memory_bubble_offer(true)
    else
      say(["LUMINARA: We protect our young. That memory screams. No."])
      set_flag(:bubble_declined_twice) if flag?(:bubble_declined)
      set_flag(:bubble_declined)
    end
  end

  # Luminara's blessing on a fallen leaf; Yarro's tincture (Q5 evidence).
  def luminara_blessing(event_id = nil)
    return say(["LUMINARA: The leaf is blessed. Show your Winter."], event_id) if ($PokemonBag.pbHasItem?(:FT_BLESSEDLEAF) rescue false)
    say(["LUMINARA: (wind through reeds) Surface-friend. You come asking, asking, again."], event_id)
    return if !pbConfirmMessage(_INTL("Ask: \"Will you bless this sapling?\""))
    if challenge("Luminara considers.", ["Hold out a fallen leaf of Hyphora's", "Ask for a sample of spores", "Ask her to come and show them"], 0)
      say(["She breathes on the leaf: spores, fine as pollen. The brown edges go green as you watch."])
      give_key(:FT_BLESSEDLEAF)
    else
      say(["LUMINARA: We do not send spores in jars to people who are afraid of them."])
    end
  end

  def yarro_tincture(event_id = nil)
    return say(["YARRO: (a voice like warm rain) Mind you show it to the cold one. She needs it most."], event_id) if flag?(:tincture_given) || ($PokemonBag.pbHasItem?(:FT_FROSTBITETINCTURE) rescue false)
    say(["YARRO: Frostbite, you say? In the camp? Our spores mend it. They don't rot it.",
         "YARRO: Help me brew. Moss, sap, and the right caps."], event_id)
    if challenge("Which caps?", ["The pale ones, from where it's warm", "The black-red ones from the old blight", "Any of them"], 0)
      say(["The brew goes clear and smells of spring rain."])
      give(:FT_FROSTBITETINCTURE, 2)
      set_flag(:tincture_given)   # (the witness is the brewing, not a bottle you might drink: whole read P16)
    else
      say(["YARRO: Not those. Never those. Try again tomorrow, gently."])
    end
  end

  #-----------------------------------------------------------------------------
  # SC 10.07 - Gym 8: the Trial of the Four Seasons
  #-----------------------------------------------------------------------------
  # Gym 8. Purpose: Selrae, in the dock, asks for the Canopy under her wardens
  # because the Halo are still in the city; the Heralds argue the city stays
  # free; the crystals' dream judges both. Each argument gets her answer
  # (dialogue 10 Top 3: a fight, not four menu picks nobody answers).
  DEBATE_ROUNDS = [
    ["Sway the undecided councillors.", ["Remind them the Canopy is everyone's", "Promise them safety", "Tell them they're cowards"], 0,
     "SELRAE: Everyone's. Which is no one's, the night the Halo come up the stair.",
     "SELRAE: (dry) Safety. From the people who brought the snow back."],
    ["Read the room.", ["The druids are afraid too", "Nobody likes Selrae", "Nothing"], 0,
     "(The druids won't meet Selrae's eye. They're frightened too, and she knows it.)",
     "(Whatever the room is thinking, it keeps it to itself.)"],
    ["Selrae says the Halo came back because you ended the summer.", ["She let them in, and said so", "Admit it", "Lie"], [0, 1],
     "SELRAE: (a beat) ...Yes. I did. So I know what they look like.",
     "SELRAE: The crystals heard that. So did I."],
    ["Call out the fearmongering.", ["Ask what she's really afraid of", "Shout her down", "Laugh"], 0,
     "SELRAE: (a long beat) ...Of being right again, Herald.",
     "SELRAE: Shout. Winter has heard louder."],
    ["One last word to the room.", ["Winter has a place. Not the whole year", "Let her have it", "Say nothing"], 0,
     "SELRAE: ...A place. Not the whole year. Hm.",
     "SELRAE: Then it's mine."]
  ]

  def selrae_bid(event_id = nil)
    if flag?(:frostina_taken)
      # (notes/11 E15: after the roc, her warning has come true)
      return say(["SELRAE: She came, and she took the white one. I let her people in, once. Not again."], event_id)
    end
    if flag?(:badge_selrae)
      return say(["SELRAE: Auril is still out there, on Solstice. Her island, on the Sea of Moving Ice.",
                  "SELRAE: She'll have felt the summer end. She'll come for what she thinks is hers."], event_id)
    end
    if flag?(:seasons_debated)
      say(["SELRAE: The crystals are waiting. They'll show you all four seasons.",
           "SELRAE: Pass three, and the Canopy stays free. Fail, and my wardens hold it."], event_id)
      return seasons_enter if pbConfirmMessage(_INTL("Enter the crystals' dream?"))
      return
    end
    druid = Stage.actor(:spring_druid, $game_player.x + 2, $game_player.y - 1, 4, graphic: "BW (113)")
    say(["Over the Hall, the four crystals pulse: green, red, white and gold, each with its season.",
         "Selrae stands, her breath frosting the air.",
         "SELRAE: The Halo aren't gone. They're in this city tonight. I know their candles.",
         "SELRAE: Give my wardens the Canopy and the Shrine. Until the Saint's ice is guarded.",
         "SELRAE: Rootwardens on every walkway. Martial law, until the Halo are found.",
         "Opposite her, a druid of the Spring Seat shakes his head.",
         "SPRING DRUID: Thirty years under one season's law, and now you want another?",
         outsider? ? "The room turns to you, and to the Heralds." : "The room turns to the Heralds of Dawn and Dusk."], event_id)
    # The debate (four successes before two failures)
    ok, bad = 0, 0
    # (R1's partial failure: "disadvantage on one Council skill challenge")
    if flag?(:blight_scarred)
      say(["SPRING DRUID: (unhappily) Though the Heralds let blight scar a root. We remember."])
      bad = 1
    end
    DEBATE_ROUNDS.each do |prompt, opts, right, yes, no|
      break if ok >= 4 || bad >= 2
      won = challenge(prompt, opts, right)
      won ? ok += 1 : bad += 1
      say([won ? yes : no])
    end
    state[:seasons_debate] = ok >= 4 ? :won : :lost
    say(ok >= 4 ? ["The undecided councillors are nodding. Selrae's mouth goes thin."] :
                  ["Two councillors side with Selrae. She has the room, for now."])
    say(["SELRAE: Words. The court can judge me after. Winter judges the old way: in the cold.",
         "SELRAE: The crystals will show you every season. Stand in the cold. Hold on to each other.",
         "SELRAE: Pass three of the four, and I'll yield the Canopy. Fail, and it's mine."])
    Stage.remove_actor(druid) if druid
    set_flag(:seasons_debated)
    return seasons_enter if pbConfirmMessage(_INTL("Enter the crystals' dream?"))
  end

  CRYSTAL_DREAM_ARRIVAL = [2166, 10, 13, 8]

  def seasons_enter
    pbSEPlay("Saint1") rescue nil
    say(["The crystals blaze. The Hall's four quarters peel away like bark: four seasons."])
    transfer(*CRYSTAL_DREAM_ARRIVAL)
  end

  # Each season looks like itself (notes/10 E13): a tint and a weather.
  SEASON_LOOKS = { spring: [Tone.new(-20, 30, -20, 0), :None], summer: [Tone.new(40, 15, -30, 0), :None],
                   autumn: [Tone.new(30, -5, -40, 30), :None], winter: [Tone.new(-10, 0, 30, 40), :Snow] } rescue {}

  def season_look(season)
    tone, weather = SEASON_LOOKS[season]
    $game_screen.start_tone_change(tone, 20) if tone rescue nil
    $game_screen.weather(weather, weather == :None ? 0 : 6, 20) rescue nil
  end

  def season_quarter(season, event_id = nil)
    key = :"season_#{season}"
    return say(["(This season has let you go.)"], event_id) if flag?(:"#{key}_done")
    if season == :winter && !%i[spring summer autumn].all? { |s| flag?(:"season_#{s}_done") }
      return say(["Winter: a wall of white, very patient. Selrae's shape in it, waiting.",
                  "(Winter comes last. Walk through the other seasons first.)"], event_id)
    end
    season_look(season)
    ok = case season
         when :spring
           say(["Spring: green growth boils up out of the floor and wraps your legs. Vines tighten."], event_id)
           grass = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && (pk.hasType?(:FIRE) || pk.hasType?(:BUG) || pk.hasType?(:FLYING)) }
           grass ? (say(["#{grass.name} tears the vines away."]); true) :
                   challenge("The vines tighten.", ["Go limp, and slide out", "Pull as hard as you can", "Wait"], 0)
         when :summer
           say(["Summer: heat and drought. The air shimmers. Your Pokémon's tongues hang out."], event_id)
           water = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.hasType?(:WATER) }
           water ? (say(["#{water.name} calls up water from somewhere, and everyone drinks."]); true) :
                   challenge("The heat.", ["Walk slowly, in each other's shade", "Run for the far side", "Drink everything at once"], 0)
         when :autumn
           say(["Autumn: whispers of regret. Every mistake you've made, said in a kind voice."], event_id)
           if with_or_is?(:alerion) || with_or_is?(:meat_meat)
             say([with_or_is?(:alerion) ? as(:alerion, "(a hand up; the voices come out of the wrong mouths) Illusion. Mine's better.") :
                                          as(:meat_meat, "(a push of her mind like a slap) Meat Meat says NO to the voices.")])
             true
           else
             challenge("The voices.", ["Listen, and let them pass", "Argue with them", "Agree with them"], 0)
           end
         else
           say(["Winter: a blizzard. You can't see your own hand. Somewhere ahead, Selrae is waiting."], event_id)
           warm = with_or_is?(:wyn) || with_or_is?(:reptin)
           warm ? (say([with_or_is?(:reptin) ? as(:reptin, "(going grey and furred) Hold on to me. I know the way through snow.") :
                                                as(:wyn, "(spores glowing faintly) Follow the light. It's warm. I promise.")]); true) :
                  challenge("The blizzard.", ["Hold on to each other and walk", "Split up and search", "Stand still"], 0)
         end
    set_flag(:"#{key}_done")
    set_flag(:"#{key}_passed") if ok
    say([ok ? "(The season lets you go.)" : "(The season beats you. It lets you go anyway.)"])
    if season == :winter
      selrae_dream_battle
    else
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
      $game_screen.weather(:None, 0, 20) rescue nil
    end
  end

  def selrae_dream_battle
    Stage.actor(:selrae, $game_player.x, $game_player.y - 2, 2, graphic: "FT_winter_matron_selrae_vorn")
    say(["Out of the blizzard, Selrae. In the dream she's young, eyes the white crystal's colour.",
         "SELRAE: I wanted a little winter for this city. Let me show you what a little winter is."])
    graft_reveal(:FT_WINTER_MATRON, "Selrae", 0)
    return if !pbTrainerBattle(:FT_WINTER_MATRON, "Selrae", nil, false, 0)
    $Trainer.badges[7] = true
    set_flag(:badge_selrae)
    set_flag(:selrae_witness)
    add_counter(:story_beats)
    say(["SELRAE: Winter's Seal."])
    pbMessage(_INTL("\\me[Badge get]{1} received Winter's Seal!", $Trainer.name))
    give(:TM13)
    say(["SELRAE: Ice Beam. Cold, and straight, and honest."])
    $game_screen.weather(:None, 0, 0) rescue nil
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil
    # (notes/10 E13: out of the dream first, then wake)
    (pbFadeOutIn { Stage.jump(2054, 11, 13, 8) }) rescue nil
    transfer(2054, 11, 13, 8) if ($game_map.map_id rescue 0) != 2054
    selrae = stage_event("Selrae Vorn")
    Stage.approach(selrae) if selrae
    seasons_outcome
  end

  def seasons_outcome
    passed = %i[spring summer autumn winter].count { |s| flag?(:"season_#{s}_passed") }
    debate = state[:seasons_debate] == :won
    trial_ok = passed >= 3
    say(["You wake in the Council Hall, under the four crystals. Everyone is looking at you."])
    if debate && trial_ok
      say(["SELRAE: (very quietly) ...Overruled. The Canopy stays free.",
           "SELRAE: And my word at the verdict, for what an old Halo-sheltering fool's word is worth."])
      set_flag(:canopy_free)
      add_opinion(1)
    elsif debate || trial_ok
      say(["KELYN: A compromise. The Canopy under watch until the Halo are found. Not under law.",
           "SELRAE: ...Watch. Very well."])
      set_flag(:canopy_watched)
    else
      say(["SELRAE: Martial law, until the Halo are found. Rootwardens on every walkway.",
           "SELRAE: You'll find my wardens watching you, Heralds. Don't take it personally."])
      set_flag(:canopy_martial_law)
      trial[:mud] += 1
    end
    say(["Selrae looks up at the white crystal for a long moment.",
         "SELRAE: Don't cheer yet. Auril's still out there.",
         "SELRAE: On Solstice, her island, out on the Sea of Moving Ice. North, past the Dale.",
         "SELRAE: She'll have felt the summer end. She'll come for what she thinks is hers.",
         cl(:alerion, "She can try."),
         cl(:alberica, "(a hand on her rune) ...Let's not dare her, pretty boy.")].compact)
    trial_work_done
    trial_week_goal
  end

  # Kept for an old save: Selrae at the Shrine sends you to the Council Hall now.
  def selrae_trial(event_id = nil)
    return selrae_bid(event_id) if flag?(:badge_selrae)
    say(["SELRAE: Not here. In the Council Hall, before the crystals. That's where winter is judged."], event_id)
  end

  #-----------------------------------------------------------------------------
  # The appeal to Hyphora (Tribunal: "Appeals can be made only to Hyphora's
  # spirit through a ritual in the Heartroot Labyrinth.")
  #-----------------------------------------------------------------------------
  def hyphora_appeal(event_id = nil)
    return say(["The roots are quiet. Hyphora has spoken."], event_id) if flag?(:appeal_heard)
    if !(flag?(:verdict_geas) || flag?(:mm_outlaw) || flag?(:verdict_fine))
      return say(["A hollow in the seal circle, worn smooth by knees. Where appeals were made, once."], event_id)
    end
    say(["You kneel in the hollow in the seal circle, where appeals were made, once.",
         "The roots under your knees go warm."], event_id)
    ok = challenge("Ask Hyphora.", ["Ask her to judge you as she knows you", "Ask her to overrule the Council", "Ask her to forgive you"], [0, 2])
    if ok
      say(["HYPHORA: (a feeling more than a voice) ...you planted me. you came back. you are mine.",
           "The green crystal in the Council Hall flares so bright that people in the Bazaar look up."])
      %i[verdict_geas mm_outlaw verdict_fine].each { |f| state[:flags].delete(f) if state[:flags] }
      set_flag(:verdict_service) if !flag?(:verdict_acquitted)
      say(["(The Council reduces the sentence to service.)"])
    else
      say(["The roots go cold again. Hyphora isn't a court of appeal for people who want to win."])
    end
    set_flag(:appeal_heard)
  end

  #-----------------------------------------------------------------------------
  # SC 10.08 - The Verdict; 10.09 - The Vote
  #-----------------------------------------------------------------------------
  NUMBER_WORDS = %w[no one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen
                    sixteen seventeen eighteen nineteen twenty]
  TENS_WORDS = { 2 => "twenty", 3 => "thirty", 4 => "forty", 5 => "fifty" }

  def number_word(n)
    return NUMBER_WORDS[n] if n < NUMBER_WORDS.size
    return n.to_s if n >= 60
    t, u = n.divmod(10)
    u.zero? ? TENS_WORDS[t] : "#{TENS_WORDS[t]}-#{NUMBER_WORDS[u]}"
  end

  # Kelyn: the chairs, and calling the verdict (notes/10 E2: early is a choice
  # that costs something, and she says so in her own words, not a counter).
  def kelyn_trials(event_id = nil)
    return say(["KELYN: Four chairs. Four seasons. All of them filled."], event_id) if flag?(:ch10_done)
    n = witnesses.size
    day = trial[:day]
    count = "#{number_word(n).capitalize} #{n == 1 ? 'witness' : 'witnesses'}"
    say([day >= 7 ? "KELYN: #{count}. It's the seventh day: the crystals can sit tonight." :
                    "KELYN: #{count}, and #{number_word(7 - day)} #{7 - day == 1 ? 'day' : 'days'} left. The crystals sit on the seventh."], event_id)
    wyn_alibi if flag?(:underdark_door_seen) && !flag?(:wyn_cleared)
    if !flag?(:badge_selrae)
      return say(["KELYN: Selrae's own trial comes first: her bid for the Canopy, before the crystals.",
                  "KELYN: She's waiting by the pillar."])
    end
    open = trials_left
    # (two boxes at most: 047d's election question can come just before this)
    say([open > 0 ? "KELYN: Call it now, and what you haven't finished goes unheard. I'd rather hear it all." :
                    "KELYN: Every trial's been heard. The same day, the city fills its two empty chairs."])
    day = trial[:day]
    return if !pbConfirmMessage(_INTL(day < 7 ? "It's only day {1}. Call the crystals early?" : "Call for the verdict?", day))
    early = day < 7
    trial[:day] = 7
    scene_verdict(early)
    scene_vote
  end

  # Context 14 M14-9 C: each Ten-Towns favour you finished puts a face among the refugees who testify.
  REFUGEE_FACES = [[:climb_done, "Keegan and Garret Velryn, with Boy"], [:mugs_done, "Hruna, under a Battlehammer banner"],
                   [:mine_done, "Oarus Masthew, still talking about moss"], [:white_moose_done, "Nimsy Huddle and four children"],
                   [:mead_returned, "Olivessa, with a hive"]]

  def refugee_faces
    faces = REFUGEE_FACES.select { |f, _| flag?(f) }.map(&:last)
    return if faces.empty?
    boxes = [+"Among the refugees who speak:"]
    faces.each do |f|
      boxes << +"" if (boxes.last + " " + f + ".").length > 88
      boxes[-1] = boxes.last.empty? ? "#{f}." : "#{boxes.last} #{f}."
    end
    say(boxes)
  end

  # One witness comes forward and says it (WITNESSES holds each in their own words).
  # (things are put before the court; people come forward)
  EVIDENCE_WORDS = /ledger|Ledger|horns|tincture|leaf|Leaf|bubble|robes|runes|charm|flask|story|reliquary|Oath|laboratories|vision|echo/

  def testify(row)
    _, who, what, _ = row
    say([who =~ EVIDENCE_WORDS ? "(#{who}, put before the court.)" : "(#{who} comes forward.)",
         "\"#{witness_line(what)}\""])
  end

  # The witnesses for one charge: you call the first, Kelyn calls one more,
  # and the crystals hear the rest (dialogue 10 Top 1: the testimony is in
  # the courtroom, and the player has a hand in it).
  def call_witnesses(charge, prompt)
    rows = witnesses(charge).select { |_, who, what, _| witness_line(what).length <= 86 && who.length <= 38 }
    return 0 if rows.empty?
    first = rows.first
    if rows.size > 1
      shown = rows.first(4)
      c = pbMessage(_INTL(prompt), shown.map { |_, who, _, _| _INTL(who) }, -1)
      first = shown[c] if c && c >= 0 && c < shown.size
    end
    testify(first)
    second = (rows - [first]).first
    testify(second) if second
    rest = witnesses(charge).size - (second ? 2 : 1)
    say(["(#{number_word(rest).capitalize} more on this charge. The crystals hear every one.)"]) if rest > 0
    witnesses(charge).size
  end

  VERDICT_GALLERY = [[6, 12, "BW (37)"], [7, 13, "BW (29)"], [16, 13, "BW (62)"], [17, 13, "BW (40)"], [18, 12, "BW (54)"]]

  # Purpose: every charge from the Tribunal gets a hearing and a ruling, in a
  # full Hall, with the witnesses the week found; the defence speaks; somebody
  # objects; Selrae gets the sentence she asks for.
  def scene_verdict(early = false)
    t = trial
    # the accused in the dock, facing the bench
    (pbFadeOutIn { $game_player.moveto(11, 17); $game_player.direction = 8 }) rescue nil
    Stage.arrive(companions, 11, 19) rescue nil                 # the accused, brought in together
    VERDICT_GALLERY.each_with_index do |(x, y, look), i|
      Stage.actor(i.zero? ? :voice_in_the_gallery : :"gallery_#{i}", x, y, i < 2 ? 6 : 4, graphic: look)
    end
    selrae = stage_event("Selrae Vorn")
    Stage.walk_to(selrae, $game_player.x + 2, $game_player.y, face: 8) if selrae
    Stage.theme(:heralds)
    say([early ? "The crystals sit early. The Hall fills anyway." : "The seventh day.",
         "The Council Hall is packed: Rootspire, the refugees, Rootwardens on the walls.",
         "Kelyn presides alone. Selrae stands with the accused. Two chairs are draped in white.",
         "KELYN: The court sits. The accused stand. Witnesses, when I call you, come forward."])
    # The first charge: Summer
    say(["KELYN: The first charge. The death of Summer: Avarice, who wore our Marshal thirty years."])
    summer = call_witnesses(:summer, "Who do you call first?")
    say(["KELYN: ...Nobody speaks to it? Then the crystals hear only the accused."]) if summer.zero?
    say(["(Luminara kept her memory bubble. The crystals can only hear what you bring them.)"]) if flag?(:bubble_declined) && !flag?(:memory_bubble)
    say(["VOICE IN THE GALLERY: She was our Marshal for thirty years! Who asked them?",
         "KELYN: (very quietly) Sit down, or leave."])
    tam = (Stage.actor(:tamsin, 5, 13, 6, graphic: "FT_tamsin") rescue nil)
    say([flag?(:tamsin_sworn) ? "TAMSIN: (in the gallery, too loud) That's my friend. Write that down." :
                                "TAMSIN: (in the gallery, in a new green cloak) That's my friend. Write that down."])
    set_flag(:tamsin_sworn)
    Stage.remove_actor(tam) rescue nil if tam
    worked = t[:helped] + (flag?(:blankets_given) ? 1 : 0)
    neglect = worked.zero? ? 1 : [t[:neglected] - worked, 0].max
    say(["(#{number_word(worked).capitalize} #{worked == 1 ? 'day' : 'days'} of work for the city. The city remembers.)"]) if worked > 0
    say(["(You never lifted a hand for the city this week. The city remembers that too.)"]) if worked.zero?
    # Your own testimony, read back (M10-1's choice)
    readback = { court_straight: "KELYN: You said you'd tell it straight. You did. The crystals are lit.",
                 court_sides: "KELYN: You said you were on their side. The court weighed it so.",
                 court_silent: "KELYN: You said nothing all week. The court noticed." }.find { |f, _| flag?(f) }
    if readback
      say(["KELYN: And the one who came out of the lantern with them.", readback[1]])
    end
    # Who speaks, and how: DC 15, eased by goodwill, raised by neglect and unanswered rumours
    c = pbMessage(_INTL("Who speaks for the Heralds?"), [_INTL("Reptin, persuading"), _INTL("Alberica, performing"),
                                                         _INTL("Alerion, plainly"), _INTL("Meat Meat, glaring")], 0)
    c = 0 if !c || c < 0
    speaker = [2, 1, 1, 0][c] || 0
    # ...and then they do speak (dialogue 10 §3, line 16)
    who, loud, quiet = [[:reptin, "She wore a good man for thirty years and froze the Dale. We stopped her.",
                         "...We stopped her."],
                        [:alberica, "(to the gallery) She'd have burned your tree to keep her summer. We said no.",
                         "...We said no."],
                        [:alerion, "She'd have killed this city to stay warm. We didn't ask leave. I'd do it again.",
                         "...I'd do it again."],
                        [:meat_meat, "(glaring at the whole Hall) Meat Meat would bite her again.",
                         "...Meat Meat would bite her again."]][c]
    speak(who, loud, quiet) if with_or_is?(who)
    summer_n = witnesses(:summer).size
    strength = summer_n * 2 + (summer_n >= 3 ? 2 : 0) + (t[:opinion] - t[:mud]) + speaker - neglect
    say(["KELYN: (reading) On the death of Summer.",
         flag?(:corsair_arms_deal) ? "KELYN: (reading) ...thirty blades, forty bows, no Council stamp. He kept the peace." : nil,
         (flag?(:avarice_doubt_shared) ? "(You think of the arms in the glass. The others know. The court doesn't.)" :
          flag?(:avarice_doubt) ? "(You think of the arms in the glass. No sigils. You don't say anything.)" : nil)].compact)
    if strength >= 8
      say(["KELYN: The crystals have heard what she was. A traitor to this city, and to every season.",
           "KELYN: Her death was necessary. Not guilty.",
           "The gallery erupts.",
           cl(:alberica, "(already crying, already hugging a stranger) Drinks! Drinks on me!")].compact)
      set_flag(:verdict_acquitted)
    elsif strength >= 5
      say(["KELYN: The crystals have heard what she was. But you killed without this Council.",
           "KELYN: Service. A season each in the sap-channels or the Echo Gate, when the cold's done.",
           cl(:reptin, "(under his breath) Well. I've always wanted to see a sap-channel. Closely.")].compact)
      set_flag(:verdict_service)
    elsif strength >= 3
      say(["KELYN: A fine. Four thousand in sap-scrip, to the refugee camp.",
           cl(:meat_meat, "Meat Meat has nine beans. Meat Meat will give them all.")].compact)
      $Trainer.money = [$Trainer.money - 4000, 0].max rescue nil
      set_flag(:verdict_fine)
    else
      say(["KELYN: ...guilty.",
           "KELYN: A geas: you may not leave Rootspire without the Council's leave.",
           cl(:reptin, "(under his breath) Well. It could have gone better. It could also have gone with spears.")].compact)
      set_flag(:verdict_geas)
    end
    # Meat Meat's charge
    say(["KELYN: The second charge. The death of #{autumn_hand[:who] == 'The Autumn Warden' ? 'the Autumn Warden' : autumn_hand[:full]}, by Meat Meat's hand."])
    # (notes 08 E3, built by e in Ch9: on the walk south she asked you to say it here)
    thanked = false
    if flag?(:you_took_cocoon) && !herald?(:meat_meat)
      c = pbMessage(_INTL("(\"You held the child. Say that, at the trial.\")"), [_INTL("Say it"), _INTL("Say nothing")], 0)
      if c == 0
        thanked = true
        say(["(You tell the court: you caught the cocoon at the rail. She let go of #{autumn_hand[:him]}.)",
             as(:meat_meat, "(in the dock, very quietly) ...Thank you.")])
      end
    elsif flag?(:you_called_mm) && !herald?(:meat_meat)
      say(["KELYN: A warden says you shouted her name at the rail, and she took the cocoon."])
    end
    # (notes 09: the player stepped in front of the spears at the arrest)
    if flag?(:stood_by_mm_arrest) && !herald?(:meat_meat)
      say([as(:meat_meat, thanked ? "And you stood in front of the spears. Meat Meat remembers." :
                                    "(in the dock, to you) You stood in front of the spears. Meat Meat remembers.")])
    end
    call_witnesses(:autumn, "Who do you call for Meat Meat?")
    refugee_faces if flag?(:refugees_testify)
    autumn = witnesses(:autumn).size + (flag?(:mm_atoned) ? 2 : 0) + (flag?(:mm_cooperated) ? 1 : 0) - (flag?(:mm_broke_out) ? 3 : 0)
    if autumn >= 4
      # (dialogue 10 §5: no sentence was passed, so nothing is "commuted")
      say(["KELYN: She stopped #{autumn_hand[:he] == 'she' ? 'a woman' : 'a man'} feeding children to a fire. No charge to answer.",
           "KELYN: She's free.",
           as(:meat_meat, "(very quietly) ...Mama. Mama, did you hear?")])
      set_flag(:mm_commuted)
    elsif autumn >= 1
      say(["KELYN: This court can't excuse it. Meat Meat will serve the refugee camp for a season.",
           as(:meat_meat, "Meat Meat will serve. Meat Meat will bring coffee. The camp will be terrified.")])
      set_flag(:verdict_service) if !flag?(:verdict_acquitted)
    else
      say(["KELYN: And the wardens she beat. Outlaw. Exile beyond the Wall, when the cold is done.",
           as(:meat_meat, "(very small) ...Meat Meat understands."),
           "PHILDENDRIN: (from the gallery) Then I'll go with her."])
      set_flag(:mm_outlaw)
    end
    verdict_other_charges
    if flag?(:verdict_geas) || flag?(:mm_outlaw) || flag?(:verdict_fine)
      say(["(An appeal goes to Hyphora, by ritual, in the Heartroot's seal circle.)"])
      set_switch(SW_APPEAL, true)
    end
    set_flag(:verdict_heard)
    add_counter(:story_beats)
  end

  # Context 10 M10-6: every charge read at the Tribunal gets its ruling, and
  # Selrae (owner's decision: she's in the dock) gets the one she asks for.
  def verdict_other_charges
    wyn = if flag?(:wyn_barred) then "KELYN: The Underdark door. The Rootwarden Wyn serves at the Echo Gate, as Kethan ruled."
          elsif flag?(:wyn_cleared) then "KELYN: The Underdark door. The Rootwarden Wyn is cleared. The post is Wyn's."
          else "KELYN: The Underdark door. Unheard this week. The charge lies on the table."
          end
    late = flag?(:history_shown) || flag?(:tincture_shown) || flag?(:blessed_leaf_shown) ||
           ($PokemonBag.pbHasItem?(:FT_HISTORYSCROLL) rescue false)
    alb = if flag?(:colony_recognised) then "KELYN: Bryn Shander, and the spores. The Council has a Fungal Liaison now. That will do."
          elsif flag?(:colony_exiled) && late then "KELYN: Bryn Shander, and the spores. What you brought since says we were wrong. Noted."
          elsif flag?(:colony_exiled) then "KELYN: Bryn Shander, and the spores. The colony's gone. The court asks nothing more."
          else "KELYN: Bryn Shander, and the spores. Unheard. The charge lies on the table."
          end
    rep = if flag?(:anduin_reconciled) then "KELYN: Reptin. The Heartroot says he stands beside her, not over her. So noted."
          elsif flag?(:anduin_leaving) then "KELYN: Reptin. The Heartroot wasn't sure. Neither is this court. We'll watch."
          elsif flag?(:anduin_doubtful) then "KELYN: Reptin. The Heartroot trusts him. His husband is still deciding. So noted."
          else "KELYN: Reptin. The Heartroot was never asked. This court will keep asking."
          end
    say([wyn, cl(:wyn, flag?(:wyn_barred) ? "(very small) ...I'll take the Gate." : "(very small) ...Thank you.")].compact)
    say([alb, rep])
    selrae = stage_event("Selrae Vorn")
    Stage.walk(selrae, PBMoveRoute::Up) if selrae
    say(["Selrae steps forward to the bar of the court, on her own.",
         "KELYN: Selrae Vorn. Thirty years of the Halo's candles, in this city.",
         "SELRAE: Service, at the Echo Gate. Where the cold comes in. I ask it.",
         "KELYN: (a long breath) So ordered.",
         "KELYN: ...This court is done. Out in the Blooming Fields, the city is waiting."])
    set_flag(:selrae_sentenced)
  end

  def scene_vote
    # Context 10 §5 and M10-7: a cut to the Fields, and each candidate says what
    # their seat would do, and what it would do if Auril comes.
    (pbFadeOutIn { Stage.jump(*VOTE_STAGE) }) rescue (Stage.jump(*VOTE_STAGE) rescue nil)
    say(["Out in the Blooming Fields, the candidates stand on a stage of braided roots.",
         "Flowers and snow grow side by side at their feet."])
    keys = CANDIDATES.keys.select { |k| nominated?(k) }
    vote_platforms(keys)
    # Endorse, stand, or stay out of it (Tab 8 Q6.3); asked now if Kelyn never asked in the week.
    stance = election_stance(true)
    stance = :endorse if stance == :stand && !nominated?(:heralds)
    picks = []
    case stance
    when :neutral
      say(["You stand at the back of the crowd and speak for nobody.",
           "People keep turning round to look at you, to see which way you'll lean. You don't."])
    when :stand
      picks << :heralds
      say(["You climb onto the stage of braided roots with the other candidates.",
           "Somebody in the crowd cheers. Somebody else throws a frost-fruit. It's a start."])
      left = keys - picks
      c = pbMessage(_INTL("And who do you speak for, for the other chair?"), left.map { |k| _INTL(CANDIDATES[k][0]) }, 0)
      picks << left[[c, 0].max]
    else
      2.times do |i|
        left = keys - picks
        c = pbMessage(_INTL(i == 0 ? "Who do you endorse first?" : "And second?"), left.map { |k| _INTL(CANDIDATES[k][0]) }, 0)
        picks << left[[c, 0].max]
      end
    end
    votes = {}
    keys.each { |k| votes[k] = CANDIDATE_BASE[k] + (trial[:support][k] || 0) }
    standing = [trial[:opinion] - trial[:mud], 0].max
    votes[picks[0]] += 2 + (standing >= 3 ? 2 : standing >= 1 ? 1 : 0) if picks[0]
    votes[picks[1]] += 1 + (standing >= 3 ? 1 : 0) if picks[1]
    favour_votes(votes, picks) if respond_to?(:favour_votes)
    winners = keys.sort_by { |k| [-votes[k], picks.index(k) || 9, keys.index(k)] }.first(2)
    winners.each { |k| set_flag(:"council_#{k}") }
    say(["The city votes. #{winners.map { |k| CANDIDATES[k][0] }.join(' and ')} take the empty chairs.",
         vote_reasons(winners),
         "KELYN: (at the end) Four chairs. Four seasons.",
         "KELYN: For the first time in my life, all of them filled.",
         "The crystals blaze: green, gold, red, white.",
         cl(:alberica, "To full chairs! Somebody find me a drink."),
         cl(:meat_meat, "Somebody find Meat Meat a coffee.")].compact)
    speak(:wyn, "...I made both. They're by the door. Sorry.", "...By the door.") if with_or_is?(:wyn)
    case stance
    when :stand
      if winners.include?(:heralds)
        say(["KELYN: (at the end, very quietly) ...And Summer's chair, to the Heralds. Gods help us all.",
             cl(:reptin, "(faintly) I'm a councillor. Anduin is going to laugh until he's sick.")].compact)
      else
        say(["The Heralds' name comes third. The crowd claps anyway, for the nerve of it.",
             cl(:alberica, "Third! Darlings, third is a podium.")].compact)
      end
    when :neutral
      say(["KELYN: (to the councillors) The Heralds spoke for nobody. We'll see what that means."])
      set_flag(:council_uncertain)
    else
      if picks[0] && winners.include?(picks[0])
        state[:council_ally] = picks[0]
        say([ALLY_THANKS[picks[0]]].compact)
      end
    end
    # A pick that lost, and a petition that fell short, each get a line (M10-7)
    lost = picks.compact.find { |k| k != :heralds && !winners.include?(k) && CANDIDATES[k] }
    say([LOST_PICK[lost]]) if lost && LOST_PICK[lost]
    %i[phildendrin anduin].each do |k|
      next if !flag?(:"petition_#{k}") || nominated?(k)
      short = [(SIGNATURES_NEEDED[k] || 0) - (trial[:signatures][k] || 0), 1].max
      Stage.actor(k, $game_player.x - 2, $game_player.y + 1, 8, graphic: PLATFORMS[k][0]) if PLATFORMS[k]
      say(["#{k.to_s.upcase}: (from the crowd) #{number_word(short).capitalize} #{short == 1 ? 'name' : 'names'} short. Next year, then."])
    end
    if !(winners & %i[mira rheven anduin heralds]).any?
      say(["LUMIN: (later) Nobody's got a ship, or a griffon, or a whale-bell.",
           "LUMIN: Then I'll ring Angajuk's bell myself. It'll be a longer voyage."])
      set_flag(:long_voyage)
    end
    set_flag(:ch10_done)
    loop_snapshot(:act2)
    set_switch(SW_TRIALS, false)
    set_switch(SW_ACT2_DONE, true)
    add_counter(:story_beats)
    Stage.cleanup rescue nil
    say(["END OF ACT II"])
    state[:goal] = "Auril is on Solstice, her island. The Council will send you north."
    act3_start if respond_to?(:act3_start)
  end

  VOTE_STAGE = [2060, 26, 13, 8]
  # (notes/11 E16; dialogue 10 §4: each in their own voice, and Rheven's pays
  # off his first line, "Lift, or talk")
  ALLY_THANKS = {
    rheven: "RHEVEN: (finding you in the crowd) You spoke first for me. ...Now come and lift something.",
    mira: "MIRA: (finding you in the crowd) You spoke first for me. The docks will hear about it.",
    eirwen: "EIRWEN: (finding you in the crowd) You spoke first for me. I'll write it on a leaf.",
    phildendrin: "PHILDENDRIN: (finding you in the crowd) You spoke for a goblin. First. Out loud.",
    anduin: "ANDUIN: (finding you in the crowd) You spoke first for me. Reptin will be unbearable."
  }
  # (notes/10 E9: a pick that loses gets a line from the one who lost)
  LOST_PICK = {
    rheven: "RHEVEN: (from the stage) Then I'll hold the wall from the outside. Same as always.",
    mira: "MIRA: (shrugging, from the stage) Third. Next year, Heralds. Bring mirrors.",
    eirwen: "EIRWEN: (from the stage) The leaves said so. I didn't want to believe them.",
    phildendrin: "PHILDENDRIN: (from the stage) Next year. I've got good at waiting.",
    anduin: "ANDUIN: (from the stage, relieved) Good. I'd have been terrible. ...I'd have been good."
  }
  # Who carried each winner (notes/10 E9: say why, from what the week did)
  VOTE_REASONS = { rheven: "the wall crews", mira: "the docks and the traders", eirwen: "the Fane and the Shrine",
                   phildendrin: "the refugee camp", anduin: "the Bazaar and the Rootwardens", heralds: "everyone you stood beside" }

  def vote_reasons(winners)
    parts = winners.map { |k| "#{k == :heralds ? 'You' : CANDIDATES[k][0].split.first} carried #{VOTE_REASONS[k]}" }
    "(#{parts.join('. ')}.)"
  end
  # [graphic, line]: one clause of the platform, then what the seat does if Auril comes
  PLATFORMS = {
    rheven: ["FT_captain_rheven_stormbranch", "RHEVEN: Walls, and patrols past the Wall. If she comes, the Skytower griffons fly for us."],
    mira: ["FT_mira_of_the_north_wind", "MIRA: Trade with Ten-Towns. And a ship that can cross the Sea of Moving Ice."],
    eirwen: ["FT_eirwen_solglass", "EIRWEN: Listen to the crystals. And the oldest maps of the north are mine. Every one."],
    phildendrin: ["FT_phildendrin", "PHILDENDRIN: Fair trials. And Duvessa's people hold this city, if you must go."],
    anduin: ["FT_anduin", "ANDUIN: Serve the tree. And the Wennen's bell calls something huge from the sea."]
  }

  def vote_platforms(keys)
    px, py = ($game_player.x rescue 26), ($game_player.y rescue 13)
    wall = stage_event("Captain Rheven (wall)")
    wall.transparent = true if wall rescue nil                 # he's on the stage today, not the wall
    Stage.actor(:kelyn, px, py - 2, 2, graphic: "FT_high_speaker_kelyn_of_spring")
    row = keys.select { |k| PLATFORMS[k] }
    actors = row.each_with_index.map do |k, i|
      Stage.actor(k, px - row.size + 1 + i * 2, py - 4, 2, graphic: PLATFORMS[k][0])
    end
    say(["KELYN: Two chairs. Each of them, tell the city what you'd do with one. And if she comes."])
    row.each_with_index do |k, i|
      a = actors[i]
      Stage.walk(a, PBMoveRoute::Down) if a
      say([PLATFORMS[k][1]])
      Stage.walk(a, PBMoveRoute::Up, 16) if a       # back into the row, facing the crowd
    end
  end

  # The trial week's Goal: a short hub line, kept current (review Ch10 E4: the
  # first goal was 254 characters, and each trial's goal outlived its trial).
  # Each trial's own step is a side line under it, gone when the trial is.
  TRIAL_STEPS = [
    [%i[anduin_reconciled anduin_doubtful], "Reptin: Anduin, by the Bazaar fountain"],
    [%i[mm_atoned], -> { FrostThaw.flag?(:phildendrin_found) ? "Meat Meat: Autumn's mirror, in the Sap Wells" : "Meat Meat: the root-cells" }],
    [%i[wyn_cleared], "Wyn: the summons at the Echo Gate"],
    [%i[talion_released talion_chased talion_restored talion_haunted], "Alerion: Talion, in the Blooming Fields"],
    [%i[colony_recognised colony_exiled], "Alberica: her hearing, in the Council Hall"],
    [%i[badge_selrae], "Selrae: her bid for the Canopy, in the Council Hall"]
  ]

  def trial_week_goal
    return if !flag?(:trials_open) || flag?(:ch10_done) || flag?(:verdict_heard)
    left = TRIAL_STEPS.reject { |flags, _| flags.any? { |f| flag?(f) } }
    day = (trial[:day] rescue 1)
    state[:goal] = if left.empty?
                     "When you're ready, tell Kelyn in the Council Hall. The crystals will hear the verdict."
                   else
                     "Trial week, day #{day} of 7: #{left.size} left. Next: #{left.first[1].respond_to?(:call) ? left.first[1].call : left.first[1]}."
                   end
  end

  def apply_chapter10_switches
    trial_week_goal rescue nil
    return if !active? || !$game_switches
    week = flag?(:trials_open) && !flag?(:ch10_done)
    $game_switches[SW_TRIALS] = week
    $game_switches[SW_PHIL_MIRROR] = flag?(:phildendrin_found) && !flag?(:mm_atoned)
    $game_switches[SW_TALION] = week && flag?(:talion_ritual_chosen) && !talion_resolved?
    $game_switches[SW_TALION_FIELDS] = week && !talion_resolved?
    $game_switches[SW_ACT2_DONE] = flag?(:ch10_done)
    $game_switches[SW_CRIERS] = week && !flag?(:criers_heard)
    $game_switches[SW_WALL_WORKS] = week && flag?(:criers_heard)
    $game_switches[SW_REFUGEE_CAMP] = flag?(:trials_open)
    $game_switches[SW_DEBATES] = week && flag?(:criers_heard)
    $game_switches[SW_PETITIONS] = week && (flag?(:petition_phildendrin) || flag?(:petition_anduin) || flag?(:petition_heralds))
    $game_switches[SW_FOUR_SEASONS] = week && !flag?(:badge_selrae)
    $game_switches[SW_EIRWEN_SHRINE] = week
    $game_switches[SW_MIRA_MIRROR] = flag?(:mira_mirror_testimony) && !flag?(:mira_mirror_taken)
    $game_switches[SW_SLAUDI] = week && !flag?(:slaudi_testifies)
    $game_switches[SW_WOLF_RAID] = week && (trial[:helped] rescue 0) >= 2 && !flag?(:wolves_driven_off)
    $game_switches[SW_APPEAL] = !flag?(:appeal_heard) && (flag?(:verdict_geas) || flag?(:mm_outlaw) || flag?(:verdict_fine))
    $game_switches[SW_WYN_HEARING] = week && flag?(:wyn_summoned) && !flag?(:wyn_cleared)
    $game_switches[SW_PELL] = week && flag?(:wyn_heard)
    root_cell_look
  end

  # The root-cell shows who's in it (notes/10 E12): Meat Meat until her mother
  # finds her (nobody, when you are Meat Meat); then Phildendrin at the bars.
  def root_cell_look
    return if !$game_map || $game_map.map_id != 2054
    cell = $game_map.events.values.find { |e| e.name.to_s =~ /Root-cells/ }
    return if !cell || cell.character_name.to_s.empty?
    look = if flag?(:phildendrin_found) then "FT_phildendrin"
           elsif herald?(:meat_meat) then nil
           else "FT_meat_meat"
           end
    look ? (cell.character_name = look) : (cell.opacity = 0)
  rescue StandardError => e
    log("root cell: #{e.message}")
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter10_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 10 switches failed: #{err.message}")
  end
}
