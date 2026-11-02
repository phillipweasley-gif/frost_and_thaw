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
    cycle_cultist_lantern:   "LANTERN-CARVER: (a knife of black ice in one hand, a lantern in the other) Not yet. Not yet. Nearly.",
    cycle_cultist_drum:      "DRUM-KEEPER: (the drum still going under her hand) Dance with us, Herald. Or lie down.",
    cycle_cultist_mask:      "MASKED DEVOTEE: (the mask is frost, growing) She bends down to touch the tree tonight. Make room.",
    rival_balance_inspector: "HALDIS: The Winter Matron asked me to inspect your papers. You have no papers. How unfortunate.",
    rival_summer_zealot:     "EMBER-PENITENT: (out of the heat-shimmer by the Sap-Works) You sold yourselves to the wrong season."
  )

  TEXT.merge!(
    eline_circle: [{ if: { flag: :rite_stopped }, lines: ["The Halo's ritual circle, scraped half away. Its sap channel still runs down through a crack in the floor.",
                                                          "Down, and down, toward the Heartroot. Cold breathes up out of it."] },
                   ["A ritual circle cut into the blue marble, filled with glowing sap. Its channel runs down through a crack in the floor.",
                    "You put your ear to the crack. Far below, the Heartroot's slow pulse. The Halo has been pouring their prayers straight into it."]],
    old_cask: ["A cask by the cellar wall, heavier than a cask has any business being. It doesn't budge.",
               "Someone's chalked a small sun on the lid, and rubbed it nearly out."],
    dock_barrel_shut: ["A barrel on the dockside, nailed down. Warm air sighs out between its staves, smelling faintly of ale and old bread."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # The morning beats at the Hearth (048_E hearth_night calls this).
  #-----------------------------------------------------------------------------
  def hearth_extras
    return true if lantern_rumours
    return true if favour_tick
    return true if autumn_ruin
    return true if glasswater_recap
    false
  end

  # The 11/25 recap's first-morning sights (rootspire.md 5388-5396).
  def glasswater_recap
    return false if flag?(:glasswater_recap) || rs_day < 2
    set_flag(:glasswater_recap)
    sayc(["From the Hearth's top window at dawn you can see across the Glasswater.",
          "Under the surface, out where it's deepest: icy glimmers, slow, like something cold turning over. And green sparks flickering in the depths like fireflies.",
          "The air coming in at the window smells faintly of frost. In a city that hasn't had frost in thirty years.",
          cl(:reptin, "(beside you, not quite awake) Both at once. Down there. The lake's arguing with itself.")].compact)
    true
  end

  #-----------------------------------------------------------------------------
  # GQ3, the Cycle Day Conspiracy: the rumour before the festival
  #-----------------------------------------------------------------------------
  def lantern_rumours
    return false if flag?(:lantern_rumours) || flag?(:festival_night) || rs_day < 3 || !flag?(:wardens_emeritus)
    set_flag(:lantern_rumours)
    say(["The Hearth's common room, late. The festival's three nights off, and the city's talking about nothing else.",
         "Somewhere in the noise, the same thing three times over: masked devotees in grey, moving through the lantern-markets.",
         "Buying frost-glass. A lot of frost-glass. Nobody makes festival lanterns from frost-glass."])
    c = pbMessage(_INTL("Who do you ask?"),
                  [_INTL("The lantern-carver's apprentice, nursing one cup all night"),
                   _INTL("The Corsair telling the loudest story"),
                   _INTL("The pilgrim in grey by the door")], 0)
    case c
    when 0
      say(["The apprentice is fourteen and frightened, and talks the moment someone's kind to her.",
           "APPRENTICE: They paid in old coin. Asked for runes cut on the inside of the glass, where nobody'd see.",
           "APPRENTICE: Master said they were blessing-runes for the aurora. They didn't look like blessings. They looked like hooks.",
           "APPRENTICE: Hooks, for catching the light when it comes down to touch the tree."])
      set_flag(:lantern_runes_known)
      sayc([cl(:alerion, "Hooks for the aurora. They mean to pull something down the light into the city."),
            cl(:alberica, "At a party. Darlings, I am taking this personally.")].compact)
    when 1
      say(["The Corsair's story is about a sea-serpent, a duchess and a bucket. It's very good. It has nothing to do with lanterns.",
           "By the time it's finished, the grey-cloaked buyers have gone home."])
    else
      say(["The pilgrim smiles at you, very kindly, and says nothing at all.",
           "In the morning, every frost-glass lantern stall in the market has closed early. Somebody warned somebody."])
      set_flag(:cult_warned)
    end
    true
  end

  #-----------------------------------------------------------------------------
  # GQ3 on the seventh night: five successes before three failures
  #-----------------------------------------------------------------------------
  CYCLE_STEPS = [
    [:shadow, "A masked devotee in grey slips away from the dancers toward the lantern-strings.",
     ["Keep three dancers between you and her, and follow", "Follow close; she won't look back", "Call out to her"], [0],
     "She never sees you. She stops at a lantern, and her hand goes inside the glass.",
     "She looks back, sees you, and her hand goes to her knife."],
    [:find, "Hundreds of lanterns on the branch-beams. Some of them are carved inside. Which?",
     ["The ones whose light doesn't flicker when the wind moves", "The brightest ones", "The ones nearest the Council Hall"], [0],
     "Every carved lantern burns perfectly still while the others sway. Once you see it, you can't stop seeing it.",
     "You pull down six lanterns. All innocent. Somewhere behind you, someone laughs."],
    [:disarm, "A carved lantern, its rune cut in frost on the inside of the glass, humming toward the sky.",
     ["Scratch one line through the rune's last stroke", "Smash the lantern", "Blow the candle out"], [0],
     "The rune breaks with a sound like a held breath let go. The lantern's just a lantern again.",
     "The glass shatters, and the rune's frost leaps out of it to the next lantern down the string. And the drum stops. They know."],
    [:blend, "A ring of grey-cloaked dancers forms round the effigies. Watching the crowd. Watching for you.",
     ["Join the round-dance, and keep time", "Push through them", "Stand very still and wait"], [0],
     "You dance. Badly, but in time. Nobody watching for Heralds looks twice at a terrible dancer.",
     "The ring closes round you like a hand."],
    [:spot, "The aurora is bending lower. Everyone's looking up. Somebody isn't.",
     ["The man who isn't watching the aurora", "The woman crying with joy", "The child pointing"], [0],
     "He's counting lanterns under his breath. When he reaches the last one, he looks at the Frost Saint effigy.",
     "The child is just a child. By the time you look back, the man who wasn't watching is gone."],
    [:disarm2, "The last string of carved lanterns, right above the Frost Saint effigy. The runes are glowing now.",
     ["Cut the string, and catch the lanterns as they fall", "Climb up and scratch each rune", "Shout for the Rootwardens"], [0, 1],
     "The lanterns come down into your arms, still warm, and the runes go dark one after another.",
     "The Rootwardens come at a run, and the grey cloaks scatter, and the lanterns keep burning."],
    [:effigy, "At the effigy's feet, two figures kneel with their hands on the white wood. The wood is going whiter.",
     ["Break their hands away from the wood", "Talk to them", "Pour sap on the effigy"], [0, 2],
     "The frost runs off the effigy like rain, and it's only wood again.",
     "They don't hear you. They're not listening to anything but her."]
  ]

  def cycle_day_conspiracy
    return if flag?(:cycle_day_done)
    say(["Bells ring through the branches. Rootspire's people dance beneath petals of ice and flowers.",
         "Children laugh and scatter snow-roses. As night falls, the aurora bends, touching the World Tree like a lover's hand.",
         "For an instant the world holds its breath.",
         "Then a chill rides the drumbeat, and whispers carry warnings of masked devotees moving through the crowd."])
    hits, misses = 0, 0
    if flag?(:lantern_runes_known)
      hits += 1
      say(["You know what to look for: frost-glass lanterns with runes cut on the inside. Hooks for the light. You're already moving."])
    else
      misses += 1
      say([flag?(:cult_warned) ? "They knew you'd be watching. They've been carving since sundown. By the time you understand what the lanterns are, half the night's gone." :
                                 "By the time you understand what the lanterns are, the carving's well under way."])
    end
    fights = %i[cycle_cultist_lantern cycle_cultist_drum cycle_cultist_mask]
    CYCLE_STEPS.each do |key, prompt, opts, right, ok_line, bad_line|
      break if hits >= 5 || misses >= 3
      say([prompt])
      if key == :find && summer_sense?
        set_flag(:summer_sense_used)
        say([herald?(:meat_meat) ? "(Your skin prickles: the carved lanterns are a little warmer than the rest. Summer-Sense. You point them out without looking.)" :
                                   "MEAT MEAT: (sniffing) Those ones. Warmer. Meat Meat can feel them from here."])
        hits += 1
        say([ok_line])
        next
      end
      if challenge(prompt.split(".").first + "...", opts, right)
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
    sayc(["The last rune goes dark. The aurora bends, touches the World Tree, and lifts away again, and nothing comes down it.",
          "Rheven's wardens drag the effigy off before anyone else notices. Mostly nobody notices. That's the point.",
          "RHEVEN: (passing, very low) The Rootwardens owe you one. I'll remember. So will the Bough circle.",
          cl(:reptin, "Nobody noticed. Best kind of saving. Nobody has to be frightened tomorrow.")].compact)
    set_flag(:rootwardens_favour)
    favour(:spring, 1)
    wheel(3)
  end

  # Half the lanterns are carved: Auril's Icy Avatar manifests at the Still Sky
  # Shrine. The Heralds have to defeat it while the crowd runs.
  def cycle_day_avatar
    say(["The drum stops. Every carved lantern flares white at once.",
         "The aurora doesn't lift away from the tree. It pours down it, into the roots, and down the roots, and out somewhere far below.",
         "From the Root-Tier, a sound like a frozen lake splitting. People start screaming the word STILL SKY."])
    Stage.visit(2056, 14, 18, 8) do
      sayc(["The Still Sky Shrine. The cracked statue of Auril has stepped down off its plinth.",
            "It's taller than it was. Its face is ice, and its breath comes out of it in a white roar that freezes the air into needles.",
            "Festival-goers who followed the light down are frozen where they stood, mid-step, mid-word.",
            "AVATAR: (a voice like a whole winter speaking at once) Still. Be still. You were always meant to be still.",
            cl(:alerion, "Get between it and them. Now.")].compact)
      $game_screen.start_shake(5, 6, 20) rescue nil
      won = boss_battle(named_mon(:B124H144, 46, "Auril's Icy Avatar"))
      say([won ? "The avatar comes apart into hail and white fog, and the statue is only a statue again, face down on the marble." :
                 "You fall back, and the Rootwardens come down the stair in a wave, and somehow, between all of you, it breaks.",
           "Not everyone it touched gets up again."])
    end
    set_flag(:icy_avatar_fought)
    set_flag(:festival_casualties)
    sayc(["Back up in the Festival Circle, the lanterns are out. Families are counting heads, and some of the counts come up short.",
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
    sayc(["The orb between the spires goes white, then gold, then a colour that has no name.",
          "Out of it steps a figure of dawn-light with a face like a struck bell, six wings folded close: a celestial envoy.",
          "Lumin falls to his knees. Nobody else can move.",
          "ENVOY: Sparkbearer. Brightmane sends me, and Brightmane is afraid.",
          "ENVOY: The frost in this valley is learning to shine. Auril's light is being born again, somewhere under this tree.",
          "ENVOY: When it comes, you will stand in front of it with her torch. And you will have to decide what the torch is for.",
          "ENVOY: Hope, that lets the frost return in its season and forgives it. Or judgment, that burns it out wherever it hides.",
          "ENVOY: Brightmane will not choose for you. She asks you to choose now, so that she knows what she has made."], event_id)
    sayc([cl(:reptin, "(quietly) Hope doesn't mean soft, Glimmer. Hope's the hardest thing I know."),
          cl(:alerion, "Judgment isn't cruel. Somebody has to say no to her."),
          cl(:meat_meat, "Meat Meat says: choose the one Shimmer would. Meat Meat doesn't know which. Shimmer did."),
          cl(:alberica, "Whatever you choose, sweetheart, we'll be standing next to it.")].compact)
    c = pbMessage(_INTL("Glimmer looks at you. What do you tell him?"),
                  [_INTL("\"Hope.\""), _INTL("\"Judgment.\""), _INTL("\"It's yours to choose.\"")], 2)
    hope = c == 0 || (c == 2)
    if c == 2
      say(["Glimmer looks at the envoy for a long time. Then at the carved wooden cat in his hand.",
           "GLIMMER: She'd have said hope. She'd have rolled her eyes about it. But she'd have said it."])
    end
    if hope
      set_flag(:glimmer_hope)
      sayc(["GLIMMER: Hope. I'll carry it in. Whatever's down there, I'll give it the chance Shimmer gave the rest of us.",
            "ENVOY: (the bell of its face rings once, softly) Then Brightmane's light will heal where it lands. Even when that costs you.",
            "It touches two fingers to the Lumen Shard in his chest. The Shard's light goes warm and gold, like a hearth.",
            "Then the envoy is gone, and Lumin is getting up off his knees, and the orb is green and white again."])
      give(:SHELLBELL)
      say(["(Hope's light: the Shell Bell heals its holder a little every time it strikes.)"])
    else
      set_flag(:glimmer_judgment)
      sayc(["GLIMMER: Judgment. If her light comes back, I'll put it out. Every spark. That's what the fire's for.",
            "ENVOY: (the bell of its face rings once, low) Then Brightmane's light will burn true. Take care what you set it on.",
            "It touches two fingers to the Lumen Shard in his chest. The Shard flares white, hot enough that the air shakes.",
            "Then the envoy is gone, and Lumin is getting up off his knees, and the orb is green and white again."])
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
    flag?(:key_found) && !flag?(:key_attuned) && !flag?(:canticle_researched) && !flag?(:canticle_partial)
  end

  # The Library check (rootspire.md: DC 14 History or Religion): pick the way in,
  # then read the leaves right. Failure means improvising one verse.
  def canticle_research
    say(["EIRWEN: The Canticle. Yes. The oldest case is unlocked. What's left of the verses is on crystal leaves, scattered through three centuries of catalogue.",
         "EIRWEN: How do you want to look?"])
    way = pbMessage(_INTL("Search the leaves..."), [_INTL("By history: when each verse was last sung"), _INTL("By faith: what each season's verse is for")], 0)
    say([way == 0 ? "You line the leaves up by date. Three verses were sung every year until the Reversal; then one, then none." :
                    "You sort the leaves by the prayers written beside them. Each hard season had a verse, and each verse had a purpose."])
    ok = challenge("Which season's verse was sung for hope?", ["Spring", "Summer", "Winter"], 0)
    ok &&= challenge("And which one, for loss?", ["Winter", "Autumn", "Spring"], 1)
    if ok
      set_flag(:canticle_researched)
      say(["Spring for hope. Autumn for loss. Winter for endurance. Summer never needed a verse: it was the one that didn't hurt.",
           "The lost lines come up out of the leaves, one by one, as if they'd been waiting to be asked properly.",
           "EIRWEN: (delighted, then embarrassed about being delighted) That's all three. Go and sing it, before dawn, in the hall of four lights."])
    else
      set_flag(:canticle_partial)
      say(["Most of it comes back. The autumn verse doesn't: that leaf's been pressed too long, and the ink's run.",
           "EIRWEN: Then you'll improvise that one. Alberica's improvised worse in front of tougher crowds, I'm told."])
    end
    state[:goal] = "Sing the Cycle Canticle at the living pillar in the Council Hall of Seasons, before dawn."
    true
  end

  def eirwen_dilemma_due? = flag?(:met_eirwen) && !flag?(:naerth_ledger_decided) && flag?(:wardens_emeritus)

  def eirwen_dilemma
    say(["EIRWEN: (at a reading table covered in leaves, glowing like a child) I've finished it. Naerth's ledger. Every page.",
         "EIRWEN: Avarice was in the Speaker's ear long before the Rime. Naerth Maxildanarr's debts, his lottery, his 'protection': all hers.",
         "EIRWEN: The Frostmaiden's curse didn't make Ten-Towns cruel. Avarice had been teaching it cruelty for years.",
         "EIRWEN: I'm going to put it on the open shelves. At the festival. Everyone should know.",
         "EIRWEN: ...Why are you all looking at me like that?"])
    sayc([cl(:alerion, "Because half this city prays to the Reversal as a miracle. And the hag who made the mirrors was Avarice's pupil."),
          cl(:reptin, "If the founding miracle was half her design, some people won't know what to believe in by morning."),
          cl(:alberica, "And Eirwen, darling: some people should.")].compact)
    c = pbMessage(_INTL("Naerth's ledger..."), [_INTL("\"Publish it. The truth is everyone's.\""),
                                               _INTL("\"Keep it sealed until this is over.\""),
                                               _INTL("\"Take it to the Council, privately.\"")], 2)
    set_flag(:naerth_ledger_decided)
    case c
    when 0
      set_flag(:naerth_ledger_published)
      say(["EIRWEN: Yes. Yes. Thank you. Knowledge doesn't get to be dangerous. It only gets to be late.",
           "By the next morning, the open shelves of the Wind-Glass Library are crowded, and some of the readers are crying,",
           "and in the Root-Tier a Halo preacher is reading the ledger aloud to a crowd: \"The Reversal was a lie. Only stillness is true.\""])
      favour(:winter, 1)
      favour(:spring, -1)
    when 1
      set_flag(:naerth_ledger_sealed)
      say(["EIRWEN: (very small) ...Sealed. Yes. Until it's over. I'll write the date on the seal, so I can't pretend I forgot.",
           "They put the ledger back in the oldest roots, and stand looking at it for a long time."])
      favour(:spring, 1)
    else
      set_flag(:naerth_ledger_council)
      say(["Kelyn reads it in her chamber with the door shut. When she comes out her eyes are red and her voice is perfectly calm.",
           "KELYN: The Council has it. The Council will decide when the city's ready. Thank you, Archivist. Thank you, Heralds.",
           "SELRAE: (behind her, very dry) The Council has had a great many things it decided the city wasn't ready for."])
      favour(:spring, 1)
      favour(:winter, -1)
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
    if flag?(:badge_hearth) && !flag?(:hellen_passages)
      set_flag(:hellen_passages)
      say(["HELLEN: (lowering her voice, wiping a glass that's already clean) You beat me in my own cellar. So you get the family secret.",
           "HELLEN: The cask by the cellar wall with the sun chalked on it. Push it from the left. There's a passage behind.",
           "HELLEN: My grandmother's grandmother ran ale down it to the Root-Tier docks when the Council taxed the stair. Still comes out under a barrel on the Split Dock.",
           "HELLEN: Folk knowledge. Nobody's written it down. Don't you start."])
      set_switch(SW_HEARTH_PASSAGE, true)
      return
    end
    if flag?(:badge_hearth) && !flag?(:hellen_note_given) && flag?(:root_tier_arrived)
      set_flag(:hellen_note_given)
      say(["HELLEN: Would you carry something for me? Nothing dangerous. Probably nothing dangerous.",
           "HELLEN: A note for Captain Ivran, on the Split Dock. The Corsairs owe the Brightruns a debt from my great-grandmother's day.",
           "HELLEN: This calls it in. A berth north, if the Heralds ever need one. Don't let the Halo see you carry it: they read everything they can steal."])
      give_key(:FT_HELLENNOTE)
      state[:goal] = "Hellen's sealed note, for Captain Ivran on the Split Dock. Quietly."
      return
    end
    if flag?(:hellen_note_delivered) && !flag?(:hellen_note_thanked)
      set_flag(:hellen_note_thanked)
      say(["HELLEN: \"The Requiem remembers the Brightruns.\" Ha! Then it does. Good.",
           "HELLEN: Here: for the walk. Corsair coin. It's all I've got that isn't soup."])
      $Trainer.money += 2000 rescue nil
      say(["(Hellen pressed $2000 into your hand.)"])
      return
    end
    if flag?(:hellen_note_thanked) && !flag?(:shrine_frost_asked)
      set_flag(:shrine_frost_asked)
      say(["HELLEN: (not smiling for once) Someone's been in my cellar. At night.",
           "HELLEN: Every morning, frost on my family's shrine to you. Frost. In a city that hasn't seen it in thirty years.",
           "HELLEN: I don't want anyone hurt. I want to know who. Would you sit up with the shrine one night?"])
      state[:goal] = "Sit up with the Heralds' shrine in Hellen's cellar, and find out who's been leaving frost on it."
      return
    end
    if flag?(:shrine_frost_solved) && !flag?(:shrine_frost_thanked)
      set_flag(:shrine_frost_thanked)
      say([flag?(:tobin_turned) ? "HELLEN: Tobin. Little Tobin from the bakery. ...I'll put a cup out for him. He can come and pray to you properly, in daylight, like everyone else." :
                                  "HELLEN: Gone, and they won't be back. Thank you. I'll sleep tonight.",
           "HELLEN: That's two I owe you. Brightruns pay what they owe."])
      give(:LEFTOVERS) if !($PokemonBag.pbHasItem?(:LEFTOVERS) rescue false)
      give(:SITRUSBERRY, 3)
      wheel(1)
    end
  end

  def hellen_note_due? = ($PokemonBag.pbHasItem?(:FT_HELLENNOTE) rescue false) && !flag?(:hellen_note_delivered)

  def hellen_note_delivery(event_id = nil)
    say(["Halfway down the Split Dock you notice the grey cloak. It's been three boats behind you since the stair."], event_id)
    c = pbMessage(_INTL("You're being followed..."), [_INTL("Lose him in the fish market"), _INTL("Turn round and face him")], 0)
    if c == 0
      say(["Between the gutting tables, the eel tanks and an argument about prices, you step sideways twice and the grey cloak walks straight on past.",
           "He never finds out where you went."])
    else
      say(["You turn. He doesn't run. He smiles, and his breath comes out white."])
      trainer(:halo_silencer)
      say(["He goes into the water rather than be questioned. The note's still sealed in your pack."])
    end
    say(["IVRAN: (breaking the seal with his thumb, and reading twice) Brightrun. Well, well.",
         "IVRAN: My great-grandfather owed hers his ship and his neck. Tell Hellen: the Requiem remembers the Brightruns.",
         "IVRAN: And you lot have a berth north, any night you want it. The Corsairs pay their debts. Eventually. Loudly."])
    $PokemonBag.pbDeleteItem(:FT_HELLENNOTE) rescue nil
    set_flag(:hellen_note_delivered)
    set_flag(:corsair_berth)
    state[:goal] = "Back to Hellen at the Rooted Hearth."
    true
  end

  # The Heralds' shrine in the cellar (build_ch6b): sitting up with it.
  def herald_shrine_event(event_id = nil)
    talk(:herald_shrine, event_id)
    return if !flag?(:shrine_frost_asked) || flag?(:shrine_frost_solved)
    return if !pbConfirmMessage(_INTL("Sit up with the shrine tonight?"))
    say(["You put the lantern out and wait among the casks. The cellar's warm. The tree breathes through the floor.",
         "Past midnight, very quietly, the stair door opens.",
         "A boy in a grey novice's robe, fifteen at most, kneels at the shrine. He takes a little jar of frost-paste from his sleeve and starts painting the four carved figures white.",
         "He's crying. He's praying while he does it. He's praying to you."])
    c = pbMessage(_INTL("The novice..."), [_INTL("Sit down beside him, and ask him why"),
                                           _INTL("Grab his wrist"),
                                           _INTL("Fetch the Rootwardens")], 0)
    case c
    when 0
      say(["He nearly jumps out of his robe. Then he sees whose faces are on the shrine, and whose faces are looking at him, and goes very still.",
           "NOVICE: Tobin. I'm Tobin. The Halo said... mark the warm houses. Paint the Heralds cold, so on Cycle Night the cold knows where to go.",
           "TOBIN: I didn't want to. I pray to you every night. I just pray very quietly now.",
           "TOBIN: There's more. They've had the lantern-carvers cut hooks into the frost-glass. For the aurora, when it bends down. Half the lanterns, and she comes.",
           "TOBIN: Please don't tell my mam."])
      sayc([cl(:reptin, "(gently) Nobody's telling your mam anything. Go home. Pray loudly, in daylight. That's all the penance this needs."),
            cl(:alberica, "And Tobin, sweetheart: if they ask, you painted it. Then come and tell us what they say.")].compact)
      set_flag(:tobin_turned)
      set_flag(:lantern_runes_known)
    when 1
      say(["He twists out of your grip like an eel, frost-paste everywhere, and is up the stair and gone before anyone can stop him.",
           "He doesn't come back. The frost doesn't either."])
    else
      say(["By the time the Rootwardens come down the stair, the boy's sobbing on the floor, and they take him away.",
           "Hellen watches from the top step with her hand over her mouth."])
      set_flag(:tobin_arrested)
    end
    set_flag(:shrine_frost_solved)
    state[:goal] = "Tell Hellen what you found at her shrine."
  end

  # The passage: the sun-chalked cask in the cellar (2059), and its far end
  # under a barrel on the Split Dock (2055).
  def hearth_passage_down(event_id = nil)
    say(["You push the cask from the left. It swings aside on a hinge older than the Council.",
         "Behind it, a passage of living root slopes down into the warm dark, smelling of old ale."], event_id)
  end

  def hearth_passage_up(event_id = nil)
    say(["The barrel's lid lifts. Inside, a ladder of root goes up into the warm dark, toward the smell of soup."], event_id)
  end

  #-----------------------------------------------------------------------------
  # The Heartwarden's Staff, bonded at the edge of the Auroral Wall
  #-----------------------------------------------------------------------------
  def auroral_wall_edge(event_id = nil)
    talk(:auroral_wall, event_id)
    return if !($PokemonBag.pbHasItem?(:FT_UNBONDEDSTAFF) rescue false) || !with_or_is?(:reptin)
    r = herald?(:reptin)
    return if !pbConfirmMessage(_INTL("Rest the night here at the edge of the light, with the staff across {1} knees?", r ? "your" : "Reptin's"))
    say(["#{r ? 'You sit' : 'Reptin sits'} with #{r ? 'your' : 'his'} back to the Wall and the staff across #{r ? 'your' : 'his'} knees. The rest of you make camp in the snow.",
         "The first hour, it's spring: warm rain through the light, flowers opening in the drifts and closing again.",
         "The second, summer: heat like a hand on the back of the neck.",
         "The third, autumn: leaves that aren't there, falling through #{r ? 'you' : 'him'}.",
         "The fourth, winter. The real one. The one from four hundred years ago, on the other side of the light, pressing in."])
    ok = challenge("The cold is the old cold, the Rime's cold. #{r ? 'You' : 'Reptin'}...", ["Breathe with the staff, and let the cold go through", "Hold on, and refuse to feel it", "Get up and walk away from the Wall"], 0)
    ok &&= challenge("Then spring again, too soon, and the year wants to tear #{r ? 'you' : 'him'} in two...", ["Let it turn, and turn with it", "Hold it back, keep it winter", "Hold it back, keep it spring"], 0)
    if ok
      say(["By dawn the staff hums in time. Not with the tree: with #{r ? 'you' : 'him'}. Both at once, the way a wolf and a forest breathe together."])
    else
      say(["By dawn #{r ? 'you are' : 'Reptin is'} grey with exhaustion, hands blue, and every Pokémon in the camp is shivering.",
           "But the staff hums in time anyway. It just took longer to be sure of #{r ? 'you' : 'him'}."])
      ($Trainer.party || []).each { |pk| pk.hp = [pk.hp - pk.totalhp / 4, 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    end
    $PokemonBag.pbDeleteItem(:FT_UNBONDEDSTAFF) rescue nil
    give(:FT_HEARTWARDENSTAFF)
    set_flag(:staff_attuned)
    say(["(The Heartwarden's Staff: held by a Pokémon, it halves Fire and Ice damage, and once a battle heals a quarter of its HP when badly hurt.)"])
    speak(:reptin, "(to the staff, very fondly) There you are. Took you long enough. Took me longer.", "...There you are.")
  end

  #-----------------------------------------------------------------------------
  # The Political Favour Track (rootspire.md 602): one faction's small boons, and
  # the rivalries you inherit from it.
  #-----------------------------------------------------------------------------
  FACTION_RIVAL = { spring: :winter, winter: :spring, autumn: :spring, summer: :winter }
  FACTION_BOONS = {
    spring: [["A Renewal Warden in green at the Hearth's door with a basket: \"From the High Speaker. For the Wardens Emeritus.\"",
              "Inside: berries still warm from the Heart of Spring's glade."], [:SITRUSBERRY, 3],
             ["KELYN: (herself, at dawn, in a borrowed cloak) The Council's grateful. I'm grateful. Take this. My mother's.",
              "A brooch of living green, still growing very slowly."], :MIRACLESEED],
    winter: [["A grey-robed clerk of the Order of Balance, very correct, with a parcel: \"The Winter Matron notes your conduct favourably.\""], [:NEVERMELTICE, 1],
             ["SELRAE: (at the Hearth's back door, not coming in) You've been useful. I don't say it often. Take this; the Order's issue.",
              "A plain white stone, cold enough to sting."], :ICYROCK],
    autumn: [["A velvet-coated Wennen bows at the Hearth's door and presents a purse. \"Autumn pays its friends, Heralds. Promptly.\""], [:NUGGET, 1],
             ["LUMEA: (in the doorway, all gold leaf) The Court of Splendor counts you as its own now. Try not to look surprised. It's unbecoming."], :AMULETCOIN],
    summer: [["Nobody at the door. Only a warm stone on the step, glowing faintly orange, and a note: SUMMER REMEMBERS ITS FRIENDS."], [:HEATROCK, 1],
             ["A heat-shimmer on the stair, the shape of a woman with horns. It says nothing. It leaves something warm on the top step."], :FLAMEORB]
  }

  def favour_tick
    f = state[:favour] || {}
    # Your patron: the first faction to warm to you.
    patron = state[:patron_faction]
    if !patron
      best = f.max_by { |_k, v| v || 0 }
      if best && (best[1] || 0) >= 2
        state[:patron_faction] = patron = best[0]
        rival = FACTION_RIVAL[patron]
        favour(rival, -1)
        boon_lines, item = FACTION_BOONS[patron][0], FACTION_BOONS[patron][1]
        sayc(boon_lines)
        give(item[0], item[1])
        say(["(#{faction_name(patron)} counts you as its friends now. #{faction_name(rival)} has noticed.)"])
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
    { spring: "Spring's Renewal Wardens", winter: "Winter's Order of Balance", autumn: "Autumn's Court of Splendor", summer: "Summer's court" }[fac]
  end

  def rivalry_scene(fac)
    case fac
    when :winter
      say(["In the morning, a Winter inspector is waiting in the Hearth's common room, papers in hand and two wardens behind her."])
      trainer(:rival_balance_inspector)
      say(["HALDIS: (picking herself up) Noted. All of it. The Matron will be informed. Unfavourably."])
    when :summer
      say(["Outside the Hearth, the air over the cobbles is shimmering, though the sun isn't up."])
      trainer(:rival_summer_zealot)
    when :autumn
      lost = [($Trainer.money rescue 0) / 10, 3000].min
      $Trainer.money -= lost rescue nil
      say(["An Autumn tax-gatherer in velvet presents you with a bill for 'Heraldic duties, arrears'. The Rootwardens on the door look away.",
           "(You pay $#{lost}. Autumn always wins slowly.)"])
    when :spring
      say(["Kelyn passes you in the market and doesn't stop. The Renewal Wardens at the Hall's door look straight through you.",
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
          "HELLEN: Flour's doubled. Since the Autumn Warden ran, nobody knows who owns the grain ledgers, so nobody's selling.",
          "HELLEN: Half the Bazaar's shuttered. The Guild's frozen every account Darrus touched, and Darrus touched all of them.",
          cl(:meat_meat, "Meat Meat did that. Meat Meat is... a little sorry. About the flour. Not about Darrus."),
          cl(:reptin, "It'll settle. Trade always does. It just shouts first.")].compact)
    true
  end
end
