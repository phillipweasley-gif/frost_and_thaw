#===============================================================================
# Frost & Thaw - Rootspire as a living city (part H): what the re-audit found
# missing or cut down, built from the notes.
#
#   The Cycle Day Conspiracy (rootspire.md 8494-8513, GQ3): rumours of carved
#     lanterns before the festival, a five-before-three hunt through the crowd
#     on the seventh night, cultists on each slip, and Auril's Icy Avatar at the
#     Still Sky Shrine if half the lanterns are carved.
#   Glimmer's Trial (459): a celestial envoy makes him choose hope or judgment.
#   Eirwen's ledger (930-933): she means to publish Naerth's ledger; you choose.
#   The Canticle's lost verses (8336-8350): research in the Library.
#   Hellen (979-991): her low-violence errands, and the old passages from the
#     Hearth's cellar to the Root-Tier docks.
#   The Heartwarden's Staff bonded at the Auroral Wall (1681-1683).
#   The Political Favour Track (602): small boons from the faction that trusts
#     you, and the rivalries that come with it.
#   Autumn's ruin (858): what Darrus's fall does to trade.
#
# Scene pass (notes/15, notes/06, notes/10): each step of the festival hunt
# asks its own question; the envoy's Heralds answer each other; Kelyn comes up
# to the Library for the ledger; the grey cloak is in the room when Hellen
# hands you the note, and on the dock behind you; the four seasons at the Wall
# each have their light; one rival table, and one boon a week.
#===============================================================================
module FrostThaw
  SW_HEARTH_PASSAGE = 4180   # Hellen has shown you the old passage from the cellar to the docks

  RELIC_ITEMS.merge!(
    FT_PROPHECYLEAF: ["Chronal Leaf of Prophecy", "Chronal Leaves of Prophecy", 8, 0,
      "Eirwen's gift for the Canticle. In gold: \"The Frost Saint will climb the Spire when the roots bleed.\" And, under it, Verse XI.", 2, 0, 6],
    FT_UNBONDEDSTAFF: ["Heartwarden's Staff (unbonded)", "Heartwarden's Staffs (unbonded)", 8, 0,
      "Living root in frozen wolf hide, capped with a gem. It hums a beat out of time. Carved under the wolf: REST AT THE EDGE OF THE LIGHT, AND LET THE YEAR GO ROUND YOU.", 0, 0, 6],
    FT_HELLENNOTE: ["Hellen's Sealed Note", "Hellen's Sealed Notes", 8, 0,
      "Folded small and sealed with candle-wax and a thumbprint. For Captain Ivran Solmar, at the Split Dock. Not to be read. (You haven't.)", 0, 0, 6]
  )

  TRAINERS.merge!(
    cycle_cultist_lantern: [:FT_HALO, "Lantern-Carver", [[:SNEASEL, 41], [:B124H215, 42]], "Half of them are cut. Half is enough."],
    cycle_cultist_drum:    [:FT_HALO, "Drum-Keeper", [[:B87H124, 42], [:B215H87, 42]], "The drum keeps her time, not yours."],
    cycle_cultist_mask:    [:FT_HALO, "Masked Devotee", [[:JYNX, 42], [:B225H215, 43]], "Stillness. Then her. Then nothing."],
    rival_balance_inspector: [:FT_ROOTWARDEN, "Inspector Haldis", [[:B215H87, 43], [:PILOSWINE, 43], [:B87H215, 44]], "The Order of Balance notes your conduct. Unfavourably."],
    rival_summer_zealot:   [:FT_HALO, "Ember-Penitent", [[:B228H124, 43], [:MAGMAR, 43], [:B126H215, 44]], "Summer remembers who it couldn't buy."]
  )
  TRAINER_INTROS.merge!(
    cycle_cultist_lantern:   "LANTERN-CARVER: (a black-ice knife in one hand, a lantern in the other) Not yet. Nearly.",
    cycle_cultist_drum:      "DRUM-KEEPER: (the drum still going under her hand) Dance with us. Or lie down.",
    cycle_cultist_mask:      "MASKED DEVOTEE: (the mask is frost, growing) She bends to touch the tree tonight.",
    rival_balance_inspector: "HALDIS: The Winter Matron asked me to inspect your papers. You have no papers.",
    rival_summer_zealot:     "EMBER-PENITENT: (out of the heat-shimmer) You sold yourselves to the wrong season."
  )

  TEXT.merge!(
    eline_circle: [{ if: { flag: :rite_stopped }, lines: ["The Halo's ritual circle, scraped half away.",
                                                          "Its sap channel still runs down through a crack in the floor, toward the Heartroot.",
                                                          "Cold breathes up out of it."] },
                   ["A ritual circle cut into the blue marble, filled with glowing sap.",
                    "Its channel runs down through a crack in the floor. You put your ear to the crack.",
                    "Far below, the Heartroot's slow pulse. The Halo pours its prayers straight into it."]],
    old_cask: ["A cask by the cellar wall, heavier than a cask has any business being. It doesn't budge.",
               "Someone's chalked a small sun on the lid, and rubbed it nearly out."],
    dock_barrel_shut: ["A barrel on the dockside, nailed down.",
                       "Warm air sighs out between its staves, smelling faintly of ale and old bread."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # The morning beats at the Hearth (048_E hearth_night calls this).
  #-----------------------------------------------------------------------------
  def hearth_extras
    return true if favour_tick
    return true if autumn_ruin
    return true if selrae_back_door
    return true if glasswater_recap
    false
  end

  # Whether a morning beat is due tonight, without playing it: hearth_night
  # keeps the night's one beat for it, as hearth_extras came first before.
  def hearth_morning_due?
    f = state[:favour] || {}
    patron = state[:patron_faction]
    best = f.max_by { |_k, v| v || 0 }
    favour = !flag?(:trials_open) &&
             ((!patron && best && (best[1] || 0) >= 2) ||
              (patron && (f[patron] || 0) >= 4 && !flag?(:"favour_trusted_#{patron}")) ||
              f.any? { |fac, v| (v || 0) <= -2 && !flag?(:"favour_cold_#{fac}") })
    !!(favour || (!flag?(:autumn_ruin_seen) && flag?(:heist_exposed)) || selrae_back_door_due? ||
       (!flag?(:glasswater_recap) && rs_day >= 2))
  end

  # The 11/25 recap's first-morning sights (rootspire.md 5388-5396).
  def glasswater_recap
    return false if flag?(:glasswater_recap) || rs_day < 2
    set_flag(:glasswater_recap)
    sayc(["From the Hearth's top window at dawn you can see across the Glasswater.",
          "Out where it's deepest, under the surface: icy glimmers, slow, like something turning.",
          "And green sparks flickering in the depths like fireflies.",
          "The air at the window smells faintly of frost. In a city with no frost in thirty years.",
          cl(:reptin, "(beside you, half awake) Both at once, down there. The lake's arguing with itself.")].compact)
    true
  end

  # Selrae owns up to the Halo, at the Hearth's back door after the Rite, where
  # a player on the golden path can hear it (notes/15 E8c; context 15 §8).
  def selrae_back_door_due?
    flag?(:rite_stopped) && flag?(:eline_named_selrae) && flag?(:selrae_courted) && !flag?(:selrae_halo_known) &&
      !flag?(:ch7_started)
  end

  def selrae_back_door
    return false if !selrae_back_door_due?
    set_flag(:selrae_halo_known)
    sel = (Stage.actor(:winter_matron_selrae_vorn, $game_player.x + 1, $game_player.y + 2, 8) rescue nil)
    Stage.approach(sel) if sel
    sayc(["At first light, someone at the Hearth's back door. The Winter Matron, not coming in.",
          "SELRAE: (before you can speak) Eline named me. You'll have heard. So: yes.",
          "SELRAE: I give the Halo coin. I give them a roof. I gave them the Shrine.",
          "SELRAE: A tempered faith keeps the goddess appeased. A starved one goes looking for blood.",
          "She pulls her furs closer, though it's warm.",
          "SELRAE: I was her priestess once. I know her hungry. Better a cult I can see.",
          cl(:alerion, "And the Rite? Was that one you could see?"),
          "SELRAE: (very quietly) No. That one, I didn't."].compact)
    Stage.leave(sel, sel.x, sel.y + 6) if sel
    true
  end

  #-----------------------------------------------------------------------------
  # GQ3, the Cycle Day Conspiracy: the rumour before the festival
  #-----------------------------------------------------------------------------
  def lantern_rumours
    return false if flag?(:lantern_rumours) || flag?(:festival_night) || rs_day < 3 || !flag?(:wardens_emeritus)
    set_flag(:lantern_rumours)
    say(["Late in the Hearth's common room. Three nights to the festival, and no other talk.",
         "In the noise, the same thing three times: masked devotees in grey, in the lantern-markets.",
         "Buying frost-glass. A lot of frost-glass. Nobody makes festival lanterns from frost-glass."])
    c = pbMessage(_INTL("Who do you ask?"),
                  [_INTL("The apprentice nursing one cup all night"),
                   _INTL("The Corsair with the loudest story"),
                   _INTL("The pilgrim in grey by the door")], 0)
    case c
    when 0
      say(["The lantern-carver's apprentice is fourteen and frightened, and talks once someone's kind.",
           "APPRENTICE: They paid in old coin. Asked for runes cut on the inside of the glass.",
           "APPRENTICE: Master said they were blessing-runes for the aurora. They looked like hooks.",
           "APPRENTICE: Hooks, for catching the light when it comes down to touch the tree."])
      set_flag(:lantern_runes_known)
      # (dialogue 06 §4: he doesn't explain the apprentice to us)
      sayc([cl(:alerion, "Hooks."),
            cl(:alberica, "At a party. Darlings, I am taking this personally.")].compact)
    when 1
      say(["The Corsair's story is about a sea-serpent, a duchess and a bucket. It's very good.",
           "It has nothing to do with lanterns. By the end, the grey-cloaked buyers have gone home."])
    else
      say(["The pilgrim smiles at you, very kindly, and says nothing at all.",
           "In the morning every frost-glass lantern stall has closed early. Somebody warned somebody."])
      set_flag(:cult_warned)
    end
    true
  end

  #-----------------------------------------------------------------------------
  # GQ3 on the seventh night: five successes before three failures
  # (notes/06 E31: each step asks its own question, not its own first sentence)
  #-----------------------------------------------------------------------------
  CYCLE_STEPS = [
    [:shadow, "A masked devotee in grey slips away from the dancers toward the lantern-strings.", "Follow her how?",
     ["Keep three dancers between you", "Follow close; she won't look back", "Call out to her"], [0],
     "She never sees you. She stops at a lantern, and her hand goes inside the glass.",
     "She looks back, sees you, and her hand goes to her knife."],
    [:find, "Hundreds of lanterns on the branch-beams. Some are carved inside.", "Which lanterns?",
     ["The ones that don't flicker in the wind", "The brightest ones", "The ones nearest the Hall"], [0],
     "Every carved lantern burns perfectly still while the others sway. You can't unsee it.",
     "You pull down six lanterns. All innocent. Somewhere behind you, someone laughs."],
    [:disarm, "A carved lantern, its rune cut in frost inside the glass, humming toward the sky.", "Break the rune how?",
     ["Scratch through its last stroke", "Smash the lantern", "Blow the candle out"], [0],
     "The rune breaks with a sound like a held breath let go. It's just a lantern again.",
     "The glass shatters. The rune's frost leaps to the next lantern. The drum stops. They know."],
    [:blend, "A ring of grey-cloaked dancers forms round the effigies, watching the crowd.", "Get past the ring how?",
     ["Join the round-dance, in time", "Push through them", "Stand very still and wait"], [0],
     "You dance. Badly, but in time. Nobody watching for Heralds looks twice at a bad dancer.",
     "The ring closes round you like a hand."],
    [:spot, "The aurora is bending lower. Everyone's looking up. Somebody isn't.", "Who isn't looking up?",
     ["The man counting under his breath", "The woman crying with joy", "The child pointing"], [0],
     "He's counting lanterns. When he reaches the last, he looks at the Frost Saint effigy.",
     "The child is just a child. When you look back, the man who wasn't watching is gone."],
    [:disarm2, "The last string of carved lanterns, right above the effigy. The runes are glowing now.", "The last string. How?",
     ["Cut it, and catch them as they fall", "Climb up and scratch each rune", "Shout for the Rootwardens"], [0, 1],
     "The lanterns come down into your arms, still warm, and the runes go dark one by one.",
     "The Rootwardens come at a run. The grey cloaks scatter. The lanterns keep burning."],
    [:effigy, "At the effigy's feet, two figures kneel, hands on the white wood. It's going whiter.", "The kneelers. What now?",
     ["Break their hands from the wood", "Talk to them", "Pour sap on the effigy"], [0, 2],
     "The frost runs off the effigy like rain, and it's only wood again.",
     "They don't hear you. They're not listening to anything but her."]
  ]

  def cycle_day_conspiracy
    return if flag?(:cycle_day_done)
    say(["Bells ring through the branches. Rootspire dances under petals of ice and flowers.",
         "Children scatter snow-roses. As night falls, the aurora bends to touch the World Tree.",
         "For an instant the world holds its breath.",
         "Then a chill rides the drumbeat. Masked devotees are moving through the crowd."])
    hits, misses = 0, 0
    if flag?(:lantern_runes_known)
      hits += 1
      say(["You know what to look for: frost-glass, runes cut inside. You're already moving."])
    else
      misses += 1
      say([flag?(:cult_warned) ? "They knew you'd watch. They've carved since sundown. Half the night's gone already." :
                                 "By the time you understand what the lanterns are, the carving's well under way."])
    end
    fights = %i[cycle_cultist_lantern cycle_cultist_drum cycle_cultist_mask]
    CYCLE_STEPS.each do |key, prompt, question, opts, right, ok_line, bad_line|
      break if hits >= 5 || misses >= 3
      say([prompt])
      if key == :find && summer_sense?
        set_flag(:summer_sense_used)
        say([herald?(:meat_meat) ? "(Your skin prickles: the carved ones are warmer. Summer-Sense. You point them out.)" :
                                   "MEAT MEAT: (sniffing) Those ones. Warmer. Meat Meat can feel them from here."])
        hits += 1
        say([ok_line])
        next
      end
      if challenge(question, opts, right)
        hits += 1
        say([ok_line])
      else
        misses += 1
        say([bad_line])
        foe = fights[[misses - 1, fights.size - 1].min]
        say(["A Frost Cultist comes at you out of the crowd, cold-light on her fingertips."])
        trainer(foe)
      end
    end
    if hits >= 5 || misses < 3
      cycle_day_foiled
    else
      cycle_day_avatar
    end
    set_flag(:cycle_day_done)
    add_counter(:story_beats)
  end

  def cycle_day_foiled
    set_flag(:effigy_saved)
    sayc(["The last rune goes dark. The aurora touches the Tree and lifts away. Nothing comes down.",
          "Rheven's wardens drag the effigy off. Mostly nobody notices. That's the point.",
          "RHEVEN: (passing, very low) The Rootwardens owe you one. I'll remember. So will the Bough.",
          cl(:reptin, "Nobody noticed. Best kind of saving. Nobody has to be frightened tomorrow.")].compact)
    set_flag(:rootwardens_favour)
    favour(:spring, 1)
    wheel(3)
  end

  # Half the lanterns are carved: Auril's Icy Avatar manifests at the Still Sky
  # Shrine. The Heralds have to defeat it while the crowd runs.
  def cycle_day_avatar
    say(["The drum stops. Every carved lantern flares white at once.",
         "The aurora doesn't lift away. It pours down the tree, into the roots, and out far below.",
         "From the Root-Tier, a sound like a frozen lake splitting. Someone screams: STILL SKY."])
    Stage.visit(2056, 14, 18, 8) do
      sayc(["The Still Sky Shrine. The cracked statue of Auril has stepped down off its plinth.",
            "It's taller than it was. Its face is ice. Its breath is a roar that freezes to needles.",
            "Festival-goers who followed the light down are frozen where they stood, mid-step.",
            "AVATAR: (a voice like a whole winter at once) Still. Be still. You were meant to be still.",
            cl(:alerion, "Get between it and them. Now.")].compact)
      $game_screen.start_shake(5, 6, 20) rescue nil
      won = boss_battle(named_mon(:B124H144, 46, "Auril's Icy Avatar"))
      say([won ? "The avatar comes apart into hail and fog. The statue's only a statue, face down." :
                 "You fall back, and the Rootwardens come down the stair, and between you all, it breaks.",
           "Not everyone it touched gets up again."])
    end
    set_flag(:icy_avatar_fought)
    set_flag(:festival_casualties)
    sayc(["In the Festival Circle the lanterns are out. Families count heads. Some come up short.",
          "KELYN: (white-faced, to nobody) Eleven. Eleven, on the seventh night.",
          cl(:alberica, "(very quietly) Sing for them, someone. I can't. Not yet.")].compact)
    wheel(2)
  end

  #-----------------------------------------------------------------------------
  # Glimmer's Trial (rootspire.md 459): the celestial envoy
  #-----------------------------------------------------------------------------
  def glimmer_envoy(event_id = nil)
    return false if flag?(:envoy_judged) || !flag?(:glimmer_rite_done) || flag?(:glimmer_gone) || !with_or_is?(:glimmer)
    set_flag(:envoy_judged)
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(255, 240, 200, 200), 20) rescue nil
    sayc(["The orb between the spires goes white, then gold, then a colour that has no name.",
          "Out of it steps a figure of dawn-light, six wings folded close, a face like a struck bell.",
          "Lumin falls to his knees. Nobody else can move.",
          "ENVOY: Sparkbearer. Brightmane sends me, and Brightmane is afraid.",
          "ENVOY: The frost in this valley is learning to shine. Auril's light is being born here.",
          "Its wings open, very slightly. The air hums.",
          "ENVOY: When it comes, you'll face it with her torch. Decide now what the torch is for.",
          "ENVOY: Hope, that lets the frost return in its season. Or judgment, that burns it out.",
          "ENVOY: Brightmane will not choose for you. Choose, so she knows what she has made."], event_id)
    # (dialogue 15 §3: the Heralds answer each other, not only the envoy)
    sayc([cl(:reptin, "(quietly) Hope doesn't mean soft, Glimmer. Hope's the hardest thing I know."),
          cl(:alerion, with_or_is?(:reptin) ? "Hope's slow, Reptin. Somebody has to say no to her." :
                                              "Judgment isn't cruel. Somebody has to say no to her."),
          cl(:meat_meat, "Meat Meat says: choose the one Shimmer would."), cl(:meat_meat, "Meat Meat doesn't know which. Shimmer did."),
          cl(:alberica, "Whatever you choose, sweetheart, we'll be standing next to it.")].compact)
    c = pbMessage(_INTL("Glimmer looks at you. What do you tell him?"),
                  [_INTL("\"Hope.\""), _INTL("\"Judgment.\""), _INTL("\"It's yours to choose.\"")], 2)
    hope = c == 0 || (c == 2)
    if c == 2
      say(["Glimmer looks at the envoy for a long time. Then at the carved wooden cat in his hand.",
           "GLIMMER: She'd have said hope. She'd have rolled her eyes about it.", "GLIMMER: But she'd have said it."])
    end
    if hope
      set_flag(:glimmer_hope)
      sayc(["GLIMMER: Hope. I'll carry it in. Whatever's down there gets the chance Shimmer gave us.",
            "ENVOY: (its face rings once, softly) Then her light will heal where it lands. At a cost.",
            "It touches the Lumen Shard in his chest. The Shard goes warm and gold, like a hearth.",
            "Then the envoy is gone. Lumin gets up off his knees. The orb is green and white again."])
      give(:SHELLBELL)
      say(["(Hope's light: the Shell Bell heals its holder a little every time it strikes.)"])
    else
      set_flag(:glimmer_judgment)
      sayc(["GLIMMER: Judgment. If her light comes back, I'll put it out. Every spark.",
            "ENVOY: (its face rings once, low) Then her light will burn true. Mind what you set it on.",
            "It touches the Lumen Shard in his chest. The Shard flares white, so hot the air shakes.",
            "Then the envoy is gone. Lumin gets up off his knees. The orb is green and white again."])
      give(:CHARCOAL)
      say(["(Judgment's fire: Charcoal makes its holder's Fire-type moves stronger.)"])
    end
    wheel(1)
    add_counter(:story_beats)
    true
  end

  #-----------------------------------------------------------------------------
  # Eirwen: the Canticle's lost verses, and Naerth's ledger
  #-----------------------------------------------------------------------------
  def canticle_research_due?
    flag?(:key_found) && !flag?(:key_attuned) && !flag?(:canticle_learned) && !flag?(:canticle_researched) && !flag?(:canticle_partial)
  end

  # The Library check (rootspire.md: DC 14 History or Religion): pick the way in,
  # then read the leaves right. Failure means improvising one verse.
  # (dialogue 15 §5: she answers the humming key, not a question nobody asked)
  def canticle_research(event_id = nil)
    say(["EIRWEN: That key's humming like a song with no words. The words are in my leaves.",
         "EIRWEN: The Cycle Canticle. What's left is on crystal leaves, all through the catalogue.",
         "EIRWEN: Sung whole, it gives back what the city forgot. Names. Faces. Even yours."], event_id)
    way = pbMessage(_INTL("EIRWEN: How do you want to look?"), [_INTL("By history: when each verse was sung"), _INTL("By faith: what each verse is for")], 0)
    say([way == 0 ? "You line the leaves up by date. Three verses a year until the Reversal. Then one. None." :
                    "You sort the leaves by the prayers beside them. Each hard season had a verse, and a use."])
    ok = challenge("Which season's verse was sung for hope?", ["Spring", "Summer", "Winter"], 0)
    ok &&= challenge("And which one, for loss?", ["Winter", "Autumn", "Spring"], 1)
    if ok
      set_flag(:canticle_researched)
      say(["Spring for hope. Autumn for loss. Winter for endurance. Summer never needed one.",
           "The lost lines come up out of the leaves, one by one, as if waiting to be asked properly.",
           "EIRWEN: (delighted, then embarrassed about it) That's all three.",
           "EIRWEN: Go and sing it, before dawn, in the hall of four lights."], event_id)
    else
      set_flag(:canticle_partial)
      say(["Most of it comes back. The autumn verse doesn't: that leaf's ink has run.",
           "EIRWEN: Then you'll improvise that one. Alberica has faced tougher crowds, I'm told."], event_id)
    end
    side_goal(:canticle, "Sing the Cycle Canticle at the Council Hall's living pillar, before dawn.", done: [:canticle_learned, :canticle_haunted])
    true
  end

  def eirwen_dilemma_due? = flag?(:met_eirwen) && !flag?(:naerth_ledger_decided) && flag?(:wardens_emeritus)

  def eirwen_dilemma(event_id = nil)
    say(["EIRWEN: (at a table deep in leaves, glowing) I've finished it. Naerth's ledger.",
         "EIRWEN: Avarice was in the Speaker's ear before the Rime. His debts, his lottery: hers.",
         "EIRWEN: The Frostmaiden's curse didn't make Ten-Towns cruel. Avarice taught it, for years.",
         "EIRWEN: I'm going to put it on the open shelves. Tomorrow. Everyone should know.",
         "EIRWEN: ...Why are you all looking at me like that?"], event_id)
    sayc([cl(:alerion, "Because you're about to tell a city its miracle had an author."),
          cl(:reptin, "If the founding miracle was half her design, some won't know what to believe."),
          cl(:alberica, "And Eirwen, darling: some people should.")].compact)
    c = pbMessage(_INTL("Naerth's ledger..."), [_INTL("\"Publish it. The truth is everyone's.\""),
                                               _INTL("\"Keep it sealed until this is over.\""),
                                               _INTL("\"Take it to the Council, privately.\"")], 2)
    set_flag(:naerth_ledger_decided)
    case c
    when 0
      set_flag(:naerth_ledger_published)
      say(["EIRWEN: Yes. Thank you. Knowledge doesn't get to be dangerous. It only gets to be late."], event_id)
      pbFadeOutIn { nil } rescue nil
      say(["Within a day, the Library's open shelves are crowded, and some of the readers are crying.",
           "In the Root-Tier a Halo preacher reads it aloud: \"The Reversal was a lie. Only stillness.\""])
      favour(:winter, 1, quiet: true)
      favour(:spring, -1, quiet: true)
      say(["(Winter will remember that. So will Spring.)"])
    when 1
      say(["EIRWEN: (very small) ...Sealed. Yes. Until it's over.",
           "EIRWEN: I'll write the date on the seal, so I can't pretend I forgot.",
           "They put the ledger back in the oldest roots, and stand looking at it for a long time."], event_id)
      set_flag(:naerth_ledger_sealed)
      favour(:spring, 1)
    else
      set_flag(:naerth_ledger_council)
      # (notes/15 E10: she comes up to the Library herself)
      say(["Eirwen sends a runner. Before long the High Speaker herself comes up the Library stair."], event_id)
      kel = (Stage.actor(:high_speaker_kelyn_of_spring, 16, 6, 4) rescue nil)
      Stage.approach(kel) if kel
      selrae_here = !flag?(:rite_stopped) || ($game_switches && $game_switches[3939])
      sel = selrae_here ? (Stage.actor(:winter_matron_selrae_vorn, 16, 6, 4) rescue nil) : nil
      Stage.walk_to(sel, kel.x + 1, kel.y, face: 4) if sel && kel
      say(["Kelyn reads it standing, page by page. Her eyes come up red. Her voice is calm.",
           "KELYN: The Council has it. It will say when the city's ready. Thank you, Archivist."])
      say([sel ? "SELRAE: The Council has had a great many things it decided the city wasn't ready for." :
                 "EIRWEN: (very quietly) The Council decides we aren't ready for a lot of things."])
      favour(:spring, 1, quiet: true)
      favour(:winter, -1, quiet: true)
      say(["(Spring will remember that. So will Winter.)"])
    end
    wheel(1)
    add_counter(:story_beats)
    true
  end

  #-----------------------------------------------------------------------------
  # Hellen: her errands, and the old passages under the Hearth
  #-----------------------------------------------------------------------------
  # Called from Hellen's ordinary rest (024). Each piece once.
  def hellen_business(event_id = nil)
    if flag?(:festival_casualties) && !flag?(:hellen_mourned)     # GQ3 lost: the avatar's dead (rootspire.md 8494-8513)
      set_flag(:hellen_mourned)
      say(["The common room is full, and nobody's talking. Eleven candles on the bar, one a name.",
           "HELLEN: (setting a bowl down, gently) Eat. You fought it. Half this room saw you.",
           "HELLEN: The Moss-Hatter's girl was one. She used to bring me the morning bread."], event_id)
      sayc([cl(:alberica, "(very quietly) Tell me their names, Hellen. All eleven. I'll keep them.")].compact)
      return
    end
    if flag?(:badge_hearth) && !flag?(:hellen_passages)
      set_flag(:hellen_passages)
      say(["HELLEN: (low, wiping a clean glass) You beat me in my own cellar. So: the secret.",
           "HELLEN: The cask by the cellar wall with the sun chalked on it. Push it from the left.",
           # (notes/06 6.16)
           "HELLEN: My great-great-gran ran ale down it when the Council taxed the stair.",
           "HELLEN: It comes out under a barrel on the Split Dock. Don't you write it down."], event_id)
      set_switch(SW_HEARTH_PASSAGE, true)
      return
    end
    if flag?(:badge_hearth) && !flag?(:hellen_note_given) && flag?(:root_tier_arrived)
      set_flag(:hellen_note_given)
      # (dialogue 15 §3: the Halo's ears are in the room)
      cloak = (Stage.actor(:grey_cloak, $game_player.x + 2, $game_player.y, 4, graphic: "FT_halo_disciple_male") rescue nil)
      say(["HELLEN: Would you carry something for me? Nothing dangerous. Probably nothing dangerous.",
           "HELLEN: A note for Captain Ivran, on the Split Dock. The Corsairs owe my family a debt.",
           "HELLEN: This calls it in. A berth north, if the Heralds ever need one."], event_id)
      say(["Down the bar, a man in a grey cloak puts down his cup."])
      Stage.leave(cloak, cloak.x + 6, cloak.y) if cloak
      say(["HELLEN: (lower) And don't let the Halo see it. They read everything they can steal."], event_id)
      give_key(:FT_HELLENNOTE)
      say(["HELLEN: The Corsairs? Smugglers with a ship and manners. Mostly the ship."], event_id)
      side_goal(:hellen, "Hellen's sealed note, for Captain Ivran on the Split Dock. Quietly.")
      return
    end
    if flag?(:hellen_note_delivered) && !flag?(:hellen_note_thanked)
      set_flag(:hellen_note_thanked)
      say(["HELLEN: \"The Requiem remembers the Brightruns.\" Ha! Then it does. Good.",
           "HELLEN: Here: for the walk. Corsair coin. It's all I've got that isn't soup."], event_id)
      $Trainer.money += 2000 rescue nil
      say(["(Hellen pressed $2000 into your hand.)"])
      return
    end
    if flag?(:hellen_note_thanked) && !flag?(:shrine_frost_asked)
      set_flag(:shrine_frost_asked)
      say(["HELLEN: (not smiling, for once) Someone's been in my cellar. At night.",
           "HELLEN: Every morning, frost on my family's shrine to you. Frost. In this city.",
           "HELLEN: I don't want anyone hurt. I want to know who. Sit up with the shrine one night?"], event_id)
      side_goal(:hellen, "Sit up with the Heralds' shrine in Hellen's cellar. Who's leaving frost?", done: :shrine_frost_solved)
      return
    end
    if flag?(:shrine_frost_solved) && !flag?(:shrine_frost_thanked)
      set_flag(:shrine_frost_thanked)
      say([flag?(:tobin_turned) ? "HELLEN: Tobin. Little Tobin from the bakery. ...I'll put a cup out for him." :
           flag?(:tobin_arrested) ? "HELLEN: (quietly) The frost's stopped. I'll sleep. I keep seeing that boy on my stair." :
                                    "HELLEN: Gone, and not coming back, the frost. I'll sleep tonight.",
           flag?(:tobin_turned) ? "HELLEN: He can come and pray to you properly, in daylight, like everyone else." : nil,
           "HELLEN: That's two I owe you. Brightruns pay what they owe."].compact, event_id)
      give(:LEFTOVERS) if !($PokemonBag.pbHasItem?(:LEFTOVERS) rescue false)
      give(:SITRUSBERRY, 3)
      wheel(1)
    end
  end

  def hellen_note_due? = ($PokemonBag.pbHasItem?(:FT_HELLENNOTE) rescue false) && !flag?(:hellen_note_delivered)

  def hellen_note_delivery(event_id = nil)
    # (WRITING_GUIDE §9a: the grey cloak is on the dock, behind you)
    cloak = (Stage.actor(:grey_cloak, $game_player.x, $game_player.y + 3, 8, graphic: "FT_halo_disciple_male") rescue nil)
    Stage.pan_to(cloak.x, cloak.y) if cloak
    say(["Halfway down the Split Dock you notice the grey cloak. Three boats back, since the stair."], event_id)
    Stage.pan_back if cloak
    c = pbMessage(_INTL("You're being followed..."), [_INTL("Lose him in the fish market"), _INTL("Turn round and face him")], 0)
    if c == 0
      say(["Between the gutting tables, the eel tanks and a row about prices, you step aside twice.",
           "The grey cloak walks straight on past. He never finds out where you went."])
      Stage.leave(cloak, cloak.x, cloak.y + 8) if cloak
    else
      Stage.approach(cloak) if cloak
      say(["You turn. He doesn't run. He smiles, and his breath comes out white."])
      trainer(:halo_silencer)
      say(["He goes into the water rather than be questioned. The note's still sealed in your pack."])
      Stage.remove_actor(cloak) if cloak
      say(["IVRAN: (looking down the dock) Halo Silencer. They don't talk. They listen for a living."], event_id)
    end
    say(["IVRAN: (breaking the seal with his thumb, and reading twice) Brightrun. Well, well.",
         "IVRAN: My great-grandad owed hers his ship and his neck. Tell her: the Requiem remembers.",
         "IVRAN: And you've a berth north, any night. Corsairs pay their debts. Eventually. Loudly."], event_id)
    $PokemonBag.pbDeleteItem(:FT_HELLENNOTE) rescue nil
    set_flag(:hellen_note_delivered)
    set_flag(:corsair_berth)
    side_goal(:hellen, "Back to Hellen at the Rooted Hearth.", done: :hellen_note_thanked)
    true
  end

  # The Heralds' shrine in the cellar (build_ch6b): sitting up with it.
  def herald_shrine_event(event_id = nil)
    talk(:herald_shrine, event_id)
    return if !flag?(:shrine_frost_asked) || flag?(:shrine_frost_solved)
    return if !pbConfirmMessage(_INTL("Sit up with the shrine tonight?"))
    pbFadeOutIn { $game_screen.start_tone_change(Tone.new(-80, -70, -20, 40), 0) rescue nil }
    say(["You put the lantern out and wait among the casks. The cellar's warm. The tree breathes.",
         "Past midnight, very quietly, the stair door opens."])
    tob = (Stage.actor(:tobin, $game_player.x + 2, $game_player.y - 1, 2, graphic: "FT_halo_disciple_male") rescue nil)
    say(["A boy in a grey novice's robe, fifteen at most, kneels at the shrine.",
         "From his sleeve, a jar of frost-paste. He starts painting the four carved figures white.",
         "He's crying. He's praying while he does it. He's praying to you."])
    c = pbMessage(_INTL("The novice..."), [_INTL("Sit down beside him, and ask why"),
                                           _INTL("Grab his wrist"),
                                           _INTL("Fetch the Rootwardens")], 0)
    case c
    when 0
      say(["He nearly jumps out of his robe. Then he sees whose faces are watching, and goes still.",
           "NOVICE: Tobin. I'm Tobin. The Halo said: mark the warm houses. Paint the Heralds cold.",
           "TOBIN: So on Cycle Night the cold knows where to go. I didn't want to. I pray to you.",
           "He wipes his nose on his sleeve."])
      say(["TOBIN: They've had the lantern-carvers cut hooks in the frost-glass. For the aurora.",
           "TOBIN: Half the lanterns, and she comes. ...Please don't tell my mam."])
      sayc([cl(:alerion, "(very still) Hooks in the lanterns, on Cycle Night. That's a door, not a prayer."),
            cl(:reptin, "(gently) Nobody's telling your mam anything. Go home. Pray loudly, in daylight."),
            cl(:alberica, "And Tobin, sweetheart: if they ask, you painted it. Then tell us what they say.")].compact)
      set_flag(:tobin_turned)
      set_flag(:lantern_runes_known)
      Stage.leave(tob, tob.x, tob.y - 4) if tob
    when 1
      say(["He twists out of your grip like an eel, frost-paste everywhere. Up the stair and gone.",
           "He doesn't come back. The frost doesn't either."])
      Stage.leave(tob, tob.x, tob.y - 4) if tob
    else
      say(["By the time the Rootwardens come down the stair, the boy's sobbing on the floor.",
           "They take him away. Hellen watches from the top step, her hand over her mouth."])
      set_flag(:tobin_arrested)
      Stage.leave(tob, tob.x, tob.y - 4) if tob
    end
    pbFadeOutIn { $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil }
    set_flag(:shrine_frost_solved)
    side_goal(:hellen, "Tell Hellen what you found at her shrine.", done: :shrine_frost_thanked)
  end

  # The passage: the sun-chalked cask in the cellar (2059), and its far end
  # under a barrel on the Split Dock (2055).
  def hearth_passage_down(event_id = nil)
    say(["You push the cask from the left. It swings aside on a hinge older than the Council.",
         "Behind it, a passage of living root slopes down into the warm dark, smelling of old ale."], event_id)
  end

  def hearth_passage_up(event_id = nil)
    say(["The barrel's lid lifts. Inside, a ladder of root goes up into the warm dark.",
         "It smells of soup."], event_id)
  end

  #-----------------------------------------------------------------------------
  # The Heartwarden's Staff, bonded at the edge of the Auroral Wall
  # (notes/15 E11, E15: a night, and each season its own light)
  #-----------------------------------------------------------------------------
  SEASON_TONES = [Tone.new(-30, 10, -30, 20), Tone.new(30, 10, -40, 0), Tone.new(30, -20, -50, 30), Tone.new(-40, -20, 30, 60)]

  def auroral_wall_edge(event_id = nil)
    talk(:auroral_wall, event_id)
    return if !($PokemonBag.pbHasItem?(:FT_UNBONDEDSTAFF) rescue false) || !with_or_is?(:reptin)
    r = herald?(:reptin)
    return if !pbConfirmMessage(_INTL("Rest the night here at the edge of the light, with the staff across {1} knees?", r ? "your" : "Reptin's"))
    pbFadeOutIn { $game_screen.start_tone_change(Tone.new(-80, -70, -20, 40), 0) rescue nil }
    say(["#{r ? 'You sit' : 'Reptin sits'} with #{r ? 'your' : 'his'} back to the Wall and the staff across #{r ? 'your' : 'his'} knees.",
         "The rest of you make camp in the snow."])
    seasons = ["The first hour, it's spring: warm rain through the light, flowers opening in the drifts.",
               "The second, summer: heat like a hand on the back of the neck.",
               "The third, autumn: leaves that aren't there, falling through #{r ? 'you' : 'him'}.",
               "The fourth, winter. The real one, from four hundred years ago, pressing in."]
    seasons.each_with_index do |line, i|
      $game_screen.start_tone_change(SEASON_TONES[i], 20) rescue nil
      say([line])
    end
    ok = challenge("The cold is the old cold, the Rime's cold. #{r ? 'You' : 'Reptin'}...", ["Breathe with the staff, and let it through", "Hold on, and refuse to feel it", "Get up and walk away"], 0)
    ok &&= challenge("Then spring again, too soon, and the year wants to tear #{r ? 'you' : 'him'} in two...", ["Let it turn, and turn with it", "Hold it back: keep it winter", "Hold it back: keep it spring"], 0)
    pbFadeOutIn { $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil }
    if ok
      say(["By dawn the staff hums in time. Not with the tree: with #{r ? 'you' : 'him'}.",
           "Both at once, the way a wolf and a forest breathe together."])
    else
      say(["By dawn #{r ? 'you are' : 'Reptin is'} grey with exhaustion, hands blue, and every Pokémon is shivering.",
           "But the staff hums in time anyway. It just took longer to be sure of #{r ? 'you' : 'him'}."])
      ($Trainer.party || []).each { |pk| pk.hp = [pk.hp - pk.totalhp / 4, 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    end
    $PokemonBag.pbDeleteItem(:FT_UNBONDEDSTAFF) rescue nil
    give(:FT_HEARTWARDENSTAFF)
    set_flag(:staff_attuned)
    say(["(The Heartwarden's Staff: held, it halves Fire and Ice damage.)",
         "(And once a battle, it heals a quarter of its holder's HP when badly hurt.)"])
    speak(:reptin, "(to the staff, very fondly) There you are. Took you long enough. Took me longer.", "...There you are.")
  end

  #-----------------------------------------------------------------------------
  # The Political Favour Track (rootspire.md 602): one faction's small boons, and
  # the rivalries you inherit from it. (notes/10 E15: one rival table, 047d's
  # FACTION_RIVAL; the trial week has its own boons there, so these stop then.)
  #-----------------------------------------------------------------------------
  FACTION_BOONS = {
    spring: [["A Renewal Warden in green at the Hearth's door, with a basket.",
              "RENEWAL WARDEN: From the High Speaker. For the Wardens Emeritus. Berries from the glade."], [:SITRUSBERRY, 3],
             ["KELYN: (herself, at dawn, in a borrowed cloak) The Council's grateful. I'm grateful.",
              "KELYN: Take this. My mother's. A brooch of living green, still growing, very slowly."], :MIRACLESEED],
    winter: [["A grey-robed clerk of the Order of Balance, very correct, with a parcel.",
              "CLERK: The Winter Matron notes your conduct favourably."], [:NEVERMELTICE, 1],
             ["SELRAE: (at the back door, not coming in) You've been useful. I don't say it often.",
              "SELRAE: The Order's issue. A plain white stone, cold enough to sting."], :ICYROCK],
    autumn: [["A velvet-coated Wennen bows at the Hearth's door and presents a purse.",
              "COURIER: Autumn pays its friends, Heralds. Promptly."], [:NUGGET, 1],
             ["LUMEA: (in the doorway, all gold leaf) The Court of Splendor counts you as its own now.",
              "LUMEA: Try not to look surprised. It's unbecoming."], :AMULETCOIN],
    summer: [["Nobody at the door. Only a warm stone on the step, glowing faintly orange.",
              "A note under it: SUMMER REMEMBERS ITS FRIENDS."], [:HEATROCK, 1],
             ["A heat-shimmer on the stair, the shape of someone tall. Gone before you're sure.",
              "It leaves something warm on the top step."], :FLAMEORB]
  }

  # (notes/10 10.07: plural agreement, and the rival the table names)
  FACTION_FRIEND_LINES = { spring: "The Renewal Wardens of Spring count you as friends now.",
                           winter: "Winter's Order of Balance counts you a friend now.",
                           autumn: "Autumn's Court of Splendor counts you among its own now.",
                           summer: "Summer's court counts you a friend now." }

  def favour_tick
    return false if flag?(:trials_open)
    f = state[:favour] || {}
    # Your patron: the first faction to warm to you.
    patron = state[:patron_faction]
    if !patron
      best = f.max_by { |_k, v| v || 0 }
      if best && (best[1] || 0) >= 2
        state[:patron_faction] = patron = best[0]
        rival = FACTION_RIVAL[patron] || :winter
        favour(rival, -1, quiet: true)
        boon_lines, item = FACTION_BOONS[patron][0], FACTION_BOONS[patron][1]
        sayc(boon_lines)
        give(item[0], item[1])
        say(["(#{FACTION_FRIEND_LINES[patron]} #{faction_name(rival)} has noticed.)"])
        return true
      end
    end
    if patron && (f[patron] || 0) >= 4 && !flag?(:"favour_trusted_#{patron}")
      set_flag(:"favour_trusted_#{patron}")
      sayc(FACTION_BOONS[patron][2])
      give(FACTION_BOONS[patron][3])
      return true
    end
    # Rivalries: a faction gone cold acts on it, once.
    f.each do |fac, v|
      next if (v || 0) > -2 || flag?(:"favour_cold_#{fac}")
      set_flag(:"favour_cold_#{fac}")
      rivalry_scene(fac)
      return true
    end
    false
  end

  def faction_name(fac)
    { spring: "Spring's Renewal Wardens", winter: "Winter's Order of Balance", autumn: "Autumn's court", summer: "Summer's court" }[fac]
  end

  def rivalry_scene(fac)
    case fac
    when :winter
      say(["In the morning a Winter inspector waits in the common room, papers in hand."])
      trainer(:rival_balance_inspector)
      say(["HALDIS: (picking herself up) Noted. All of it. The Matron will be informed. Unfavourably."])
    when :summer
      say(["Outside the Hearth, the air over the cobbles is shimmering, though the sun isn't up."])
      trainer(:rival_summer_zealot)
    when :autumn
      lost = [($Trainer.money rescue 0) / 10, 3000].min
      $Trainer.money -= lost rescue nil
      say(["An Autumn tax-gatherer in velvet hands you a bill: 'Heraldic duties, arrears'.",
           "The Rootwardens on the door look away.",
           "(You pay $#{lost}. Autumn always wins slowly.)"])
    when :spring
      say(["Kelyn passes you in the market and doesn't stop. Her wardens look straight through you.",
           "HELLEN: (later, pouring) Spring doesn't shout, loves. Spring just stops watering."])
    end
  end

  #-----------------------------------------------------------------------------
  # Autumn's ruin (rootspire.md 858): Darrus's fall shakes the city's trade.
  #-----------------------------------------------------------------------------
  def autumn_ruin
    return false if flag?(:autumn_ruin_seen) || !flag?(:heist_exposed)
    set_flag(:autumn_ruin_seen)
    sayc(["The Hearth's breakfast is half what it was. Hellen apologises twice.",
          "HELLEN: Flour's doubled. Since the Autumn Warden ran, nobody knows who owns the grain.",
          "HELLEN: Half the Bazaar's shut. The Guild froze every account Darrus touched. All of them.",
          cl(:meat_meat, "Meat Meat did that. Meat Meat is a little sorry. About the flour. Not Darrus."),
          cl(:reptin, "It'll settle. Trade always does. It just shouts first.")].compact)
    true
  end
end
