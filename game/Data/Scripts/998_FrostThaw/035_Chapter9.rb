#===============================================================================
# Frost & Thaw - Act II, Chapter 9: Destruction's Light (script SC 9.01-9.07)
#
# Stop the chardalyn dragon before it reaches Ten-Towns' people. It leads the
# party back out into the Dale they left a few weeks ago, by the Dale's clock.
#
#   9.01 The leaves fall (Rootspire's market): summer ends; the Wall thins.
#   9.02 Mount up (the Shrine of the Twinned Dragons): the twins, and Dawnfang;
#        the dragons bind Alerion (Frostina, winter) and Meat Meat (Razzilith,
#        spring) as Dragoons. You ride behind your version's Dragoon
#        (Frost: Alerion on Frostina; Thaw: Meat Meat on Razzilith).
#   9.03 Through the Wall: the sky chase, the first air battle ("Seams"), and
#        Good Mead burning: get the bees out.
#   9.04 Malevolent presence: the dragon reaches into your rider's mind; the
#        second air battle ("Pursuit").
#   9.05 The trap (Bryn Shander, re-dressed): Anduin; the final battle.
#   9.06 The green light on the horizon: the refugees follow you south.
#   9.07 Slayers of Summer (the market, autumn): the Heralds are arrested.
#
# The chase in the air is told in scenes and fought in battles; you land in
# real places (Good Mead, Bryn Shander) and walk them.
#===============================================================================
module FrostThaw
  SW_CH9_MARKET   = 3982   # you're back in the market after the forge: the leaves fall (9.01)
  SW_CH9_GOODMEAD = 3983   # Good Mead is burning (9.03): the mead hall door, your dragon in the square
  SW_CH9_MEADSAFE = 3984   # the bees and Olivessa are out
  SW_CH9_BRYN     = 3985   # Bryn Shander is packed with refugees (9.05)
  SW_CH9_AFTER    = 3986   # the dragon is down (9.06): Anduin and the hooded woman in the square
  SW_CH9_RETURN   = 3987   # walking back into Rootspire with the refugees (9.07)
  SW_RIDES_FROSTINA = 3953 # your mount is Frostina (Frost); otherwise Razzilith

  CHARDALYN = :CHARDALYN    # the Chardalyn Dragon (Dragon/Steel)

  # The chase's music (notes 09 E9): wind under the flight, a boss's theme for
  # the dragon (not the wild-battle one), the Heralds' at the Shrine and the
  # green light, and nothing at the arrest.
  FLIGHT_BGM = "strongWind"
  DRAGON_BGM = "mewtwo"

  TEXT.merge!(
    your_dragon: -> { flag?(:rides_frostina) ? ["Frostina lowers her wing. Snow slides off her like water."] :
                                               ["Razzilith lowers his neck.",
                                                "Where a snowflake lands on him, a tiny leaf grows, and falls off."] },
    anduin_after: -> { ["ANDUIN: Five weeks. I'm not letting go of his sleeve.",
                        "ANDUIN: You'd have to fight me for it. I'd win, too."] },
    hooded_woman: -> { ["A hooded goblin woman stands very still in a moving crowd.",
                        "When you look at her, she pulls her hood lower."] },
    # (notes 09 E17: five people, five lines, not one shared script)
    refugee_1: -> { T.flag?(:good_mead_saved) ?
                    ["BEEKEEPER: Good Mead's half ash. Olivessa got the queens out. I brought a hive."] :
                    ["BEEKEEPER: Good Mead's gone. I walked here with a hive under my coat. It's still humming."] },
    refugee_2: -> { T.flag?(:prisoners_freed) ?   # (whole read T30: the forge pods, read back)
                    ["A woman from the forge pods, wrapped in a Rootwarden's cloak, won't let go of your sleeve."] :
                    ["FISHER: Caer-Konig sent its boats up the river. There's no river. We pulled them."] },
    refugee_3: ["CHILD: (from Easthaven) Is it true there's a tree with summer inside it? Is it far?"],
    refugee_4: ["DOCKHAND: Targos shut its gate on us. Bryn Shander didn't. I won't forget which."],
    refugee_5: ["REFUGEE: Rootspire? Where's Rootspire? ...Under the green light? That's Dougan's Hole."],
    olivessa_refugee: ["OLIVESSA: The bees came too. They're in my hat.",
                       "OLIVESSA: Don't look at the hat. They don't like being looked at."],
    duvessa_square: ["DUVESSA: Everyone's packed. When you're ready, take them out by the south road.",
                     "DUVESSA: I'll bring up the back. Somebody has to count."],
    militia_hold: ["MILITIA: Not that way. Everyone's going south, behind you. That's the plan."],
    # Good Mead, burning (notes 09 E7): the town knows its roofs are on fire
    gm_burning_beekeeper: ["BEEKEEPER: The hives! She went back in for the hives!"],
    gm_burning_shandar: ["SHANDAR: (an axe in one hand, a bucket in the other) Help or move!"],
    gm_burning_townsfolk: ["TOWNSPERSON: It came down out of the snow and the roof just went!"],
    gm_burning_gossip: ["GOSSIP: (coughing) I always said that mead hall would go up. I never meant it."],
    gm_burning_fef: ["FEF: (holding the fox) Not now. Not now! The trees are next."],
    gm_militia: ["MILITIA: Road's on fire. Your dragon's in the square. Go!"]
  )

  module_function

  def rider_key
    flag?(:rides_frostina) ? :alerion : :meat_meat
  end

  def mount_name
    flag?(:rides_frostina) ? "Frostina" : "Razzilith"
  end

  # After the forge (SC 8.09): up to the market.
  def chapter9_start
    set_switch(SW_CH9_MARKET, true)
    transfer(2050, 31, 28, 2)
  end

  #-----------------------------------------------------------------------------
  # SC 9.01 - The leaves fall
  #-----------------------------------------------------------------------------
  # Summer ends, Rootspire sees the hole the dragon tore, and Rheven sends you
  # straight up to the twins (notes 09 E4: the emergency doesn't wait for a
  # walk across the city): a fade, and you're at the Shrine.
  SHRINE_ARRIVAL = [2061, 23, 20, 8]   # the Canopy-Tier, at the twins' feet

  def scene_leaves_fall
    set_switch(SW_CH9_MARKET, false)
    return if flag?(:summer_ended)
    say(["The gold dawn flickers. Goes rose. Then pale.",
         "For the first time in thirty years, the light changes.",
         "A leaf falls in the market. Then a hundred. People hold out their hands like it's rain."])
    if journey?
      say(["TAMSIN: (catching one) It's brown. Why is it brown? Is it sick?"])
    else
      say(["Tamsin catches one.",
           "TAMSIN: It's brown. Why is it brown? Is it sick?"])
    end
    # (an input in the market's first quiet minute)
    c = pbMessage(_INTL("Tamsin holds the leaf out to you."), [_INTL("Take it"), _INTL("Tuck it behind their ear")], 0)
    say([c == 0 ? "You take it. It's dry and light, and smells of something you can't name." :
                  "You tuck it behind their ear. They keep very still, so it won't fall."])
    rheven = Stage.find("Captain Rheven")
    Stage.approach(rheven) if rheven             # he walks over from the Council stair
    say(["RHEVEN: (looking up at the crown) It's not sick, kid. Summer's over.",
         "RHEVEN: It's autumn. It's supposed to happen. ...It's been a while, that's all.",
         "High in the crown, where the dragon tore through, a ragged hole lets in the sky.",
         cl(:alberica, "Put it in your hair, Tamsin. Autumn's the best-dressed season. Trust me."),
         cl(:meat_meat, "Meat Meat has never seen autumn.")].compact)
    # Context 09 M9-1: one line for Glimmer before anything else (notes 08 E23,
    # dialogue 08 §5: Meat Meat's, quiet, in the bible's name for him).
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "(quietly) Sparkly cat would have liked leaves.", "...Sparkly cat would have liked leaves.")
    end
    say(["Past the valley's edge, the shimmering Auroral Wall goes thin as breath.",
         "Beyond it, snow that has hung in the air for four hundred years begins, slowly, to fall."])
    if with_or_is?(:alerion)
      Stage.face(Stage.summon(:alerion), 6) rescue nil       # toward the Wall, east
      speak(:alerion, "(watching the Wall) A night in here. Out there, a few breaths.", "...A few breaths, out there.")
    else
      say(["(A night in here. Out there, past the Wall, a few breaths.)"])
    end
    sayc([cl(:reptin, flag?(:clock_first_light) ? "Then we woke it early, and it's still barely past the Wall." :
                                                  "Then it's barely past the Wall. Good Mead hasn't even seen it yet.")])
    # (notes 08 E16, E27: the people you cut out of the pens came up too)
    if flag?(:prison_pod_1)
      say(["RHEVEN: One of my Rootwardens walked out of the roots at dawn. Says you cut him loose."])
    end
    if flag?(:prison_pod_2)
      say(["Behind him, a fisherwoman in oilskins catches leaves in her hat, asking for her boat."])
    end
    sayc(["RHEVEN: Your dragons came back to the Shrine at first light. They won't fly without you.",
          "RHEVEN: The lift's held for you. Go.",
          cl(:meat_meat, "Razzy is waiting? Razzy never waits. ...Meat Meat is running.")])
    set_flag(:summer_ended)
    set_flag(:wall_thinning)
    add_counter(:story_beats)
    state[:goal] = "The twins, at the Shrine on the Canopy-Tier. Catch the dragon before Good Mead."
    Stage.cleanup rescue nil
    transfer(*SHRINE_ARRIVAL)
  end

  #-----------------------------------------------------------------------------
  # SC 9.02 - Mount up (the twins at the Shrine, after the Forge). From here on
  # Alerion is Frostina's Dragoon, and Meat Meat is Razzilith's.
  #-----------------------------------------------------------------------------
  def dragon_shrine(which, event_id = nil)
    # Bound and saddled but you said "not yet": ask again (review Ch9 E1, the
    # only soft-lock in the game). Once you've taken off this never fires.
    if flag?(:mounted_up) && !flag?(:air_seams)
      say(["#{mount_name} lowers #{flag?(:rides_frostina) ? 'her wing' : 'his neck'}. The black dragon is a speck in the south."], event_id)
      return sky_chase if pbConfirmMessage(_INTL("Take off after the black dragon?"))
      return
    end
    if !flag?(:summer_ended) || flag?(:mounted_up)
      return talk(which == :frostina ? :frostina_shrine : :razzilith_shrine, event_id)
    end
    Stage.theme(:heralds)                         # (notes 09 E9: the Heralds' theme for the Dragoons)
    frostina = Stage.find("Frostina")
    razz = Stage.find("Razzilith")
    say(["The twins are back on the Shrine, frost smoking off their wings. They came back for you.",
         "Frostina looks past all of you, at the steps, for someone who isn't there.",
         "Then she looks at the golden dagger."], event_id)
    # (notes 09 E21: the dagger is yours and Meat Meat's, from the Forge)
    mm = herald?(:meat_meat) ? nil : Stage.summon(:meat_meat)
    Stage.walk_to(mm, frostina.x, frostina.y, adjacent: true) if mm && frostina
    say([as(:meat_meat, herald?(:meat_meat) ? "(holding out Dawnfang) Glimmer said to tell you. It was a better fire." :
                                              "(holding Dawnfang out with you) Glimmer said to tell you. It was a better fire."),
         "Frostina lowers her head to the blade and hums four notes.",
         "She stops halfway, like a song with a voice missing."])
    if $PokemonBag && ($PokemonBag.pbHasItem?(:FT_FROZENROSE) rescue false)
      # (notes 08 E16: the rose Glimmer carried, given to the one who'd want it)
      say([as(:meat_meat, "(setting a black-ice jar at her feet) And Shimmer's rose. He carried it last."),
           "Frostina breathes on the jar, and the black ice goes clear."])
      set_flag(:rose_to_frostina)
    end
    speak(:alerion, "(a hand on her neck) ...I'll watch her. Somebody has to.",
                    "(a hand on her neck) ...I'll watch her.")
    # The bond (the Dragoon lore: a whisper in the blood, a second heartbeat).
    # (notes 09 E16: shown on them, not only told)
    al = herald?(:alerion) ? $game_player : Stage.summon(:alerion)
    Stage.turn_to(frostina, al) if frostina && al
    pbSEPlay("Saint7") rescue nil
    Stage.fx("E-02", al, frames: 8, oy: 24) if al
    if herald?(:alerion)
      say(["Frostina turns and lays her brow against yours.",
           "Cold runs up your arm under the skin, a pale light in the veins.",
           "It settles behind your ribs, and stays."])
    else
      say(["Frostina turns and lays her brow against Alerion's.",
           "Frost-light runs up his arm under the skin, and settles behind his ribs."])
    end
    say([as(:alerion, "(a hand flat on his ribs) ...Two of them. Hers. Then mine."),
         cl(:alberica, "(softly) Pretty boy. You're glowing."),
         as(:alerion, "I know.")].compact)
    m = herald?(:meat_meat) ? $game_player : mm
    Stage.turn_to(razz, m) if razz && m
    Stage.hop(razz) if razz
    $game_screen.start_flash(Color.new(140, 230, 120, 200), 16) rescue nil
    if herald?(:meat_meat)
      say(["Razzilith shoves his snout into your chest hard enough to sit you down in the leaves.",
           "Something green and warm goes in over your heart, and stays."])
    else
      say(["Razzilith shoves his snout into Meat Meat's chest and sits her down in the leaves.",
           "A green glow goes in over her heart, and stays."])
    end
    say([as(:meat_meat, "(delighted) He is warm. Inside Meat Meat. Like coffee."),
         as(:meat_meat, "Razzilith is Meat Meat's. Meat Meat watches him. That is the rule now.")])
    shrine_prophecy
    reader = with_or_is?(:reptin) ? (herald?(:reptin) ? "You read" : "Reptin reads") : "You read"
    say(["Round the old stump, half grown over with bark: a carving. #{reader} it out loud:",
         "THE TWINNED DRAGONS CHOOSE TWO. NOT RIDERS. DRAGOONS.",
         "GUIDES TO YOUNG DRAGONS. KEEPERS OF FRAGILE SEASONS.",
         "A LIVING VOW THAT THE SKY WILL OPEN AGAIN.",
         cl(:reptin, "...Well. Congratulations on the new job titles. I assume there's no pay."),
         as(:alerion, "I didn't apply.")].compact)
    # (dialogue 09 §4.2: the clock comes back before the jokes run dry)
    Stage.hop(razz) if razz
    say(["RAZZILITH: (a painted thought: the black dragon, and teeth) ...CHASE.",
         as(:meat_meat, "Yes. CHASE. Dragoon. Meat Meat likes it. It has teeth in it."),
         cl(:wyn, "(very softly, to Razzilith) ...Congratulations. Both of you.")].compact)
    if !herald?(:alerion) && !herald?(:meat_meat)
      say(["MEAT MEAT: Ice Prince is Frostina's. Meat Meat is Razzy's. You ride with us."])
      c = pbMessage(_INTL("Meat Meat waits for an answer."), [_INTL("\"Yes.\""), _INTL("\"Try and stop me.\"")], 0)
      say([c == 0 ? "MEAT MEAT: Good. Hold on tight. Meat Meat does not stop for falling people." :
                    "MEAT MEAT: (delighted) Meat Meat likes this one."])
    end
    set_flag(:dragoons_bound)
    # A Dragoon rides their own dragon; anyone else rides behind their
    # version's Dragoon.
    on_frostina = herald?(:alerion) ? true : herald?(:meat_meat) ? false : version == :frost
    if on_frostina
      set_flag(:rides_frostina)
      set_switch(SW_RIDES_FROSTINA, true)
      say([herald?(:alerion) ? "Frostina lowers her wing. You take the front, at the base of her neck: a Dragoon's seat." :
                               "Frostina lowers her wing. Alerion takes the Dragoon's place. You climb up behind him."])
    else
      set_flag(:rides_razzilith)
      say([herald?(:meat_meat) ? "Razzilith lowers his neck. You take the front, where a Dragoon sits." :
                                 "Razzilith lowers his neck. Meat Meat takes the Dragoon's place. You climb up behind her."])
    end
    say(["The other Heralds climb onto the other dragon, behind its Dragoon."])
    set_flag(:mounted_up)
    set_flag(:guardians_sworn)
    add_counter(:story_beats)
    set_rest_at(HEARTH_REST) rescue nil
    return if !pbConfirmMessage(_INTL("Take off after the black dragon?"))
    sky_chase
  end

  # Context 09 M9-2: why these two. Lumin tells the tree's prophecy (it used
  # to wait in Chapter 8's optional Echo Vault): riders not afraid of falling,
  # and the third season who must not hold the cold still.
  def shrine_prophecy
    lumin = Stage.find("Lumin Weavemoss")
    Stage.approach(lumin) if lumin
    say(["LUMIN: (the Wennen priest, his head bowed) The Sparkbearer isn't with you."])
    c = pbMessage(_INTL("Lumin waits."), [_INTL("\"He's gone.\""), _INTL("Say nothing")], 0)
    say([c == 0 ? "Lumin's ears go flat." : "You don't have to. Lumin's ears go flat."])
    speak(:meat_meat, "(holding up Dawnfang) He's in here now. And up there.", "(holding up Dawnfang) ...He's in here now.")
    say(["LUMIN: (a long breath) ...Then hear what the tree told us, the night he came.",
         "LUMIN: \"Each needs a rider who is not afraid of falling. Each will choose one.\""])
    speak(:alerion, "I'm afraid of falling.", "...I'll fall anyway.")
    say(["LUMIN: Then she chose well. The ones who aren't afraid don't hold on."])
    speak(:meat_meat, "Meat Meat is afraid of falling. Meat Meat will do it anyway. That counts.", "...Meat Meat will do it anyway.")
    say(["LUMIN: \"And a third season walks among you, with a song, and a mark on her chest.\"",
         "LUMIN: \"She will be asked to hold the cold still. She must not. Seasons are turned.\""])
    # (dialogue 08 §4.35: her voice, and she knows it's her)
    if herald?(:alberica)
      speak(:alberica, "Plenty of girls have a mark on their chest. Don't all look.", "...Hm.")
      say(["(Hold the cold still. That's what she's been asking me.)"])
    elsif with_or_is?(:alberica)
      say(["ALBERICA: (a hand on her rune) Plenty of girls have a mark on their chest. Don't all look."])
    end
    set_flag(:tree_prophecy_heard)
  end

  # (old saves: the Shrine event that was Shade's)
  def shade_shrine(event_id = nil)
    dragon_shrine(:frostina, event_id)
  end

  #-----------------------------------------------------------------------------
  # Air battles: a phase of the chase. Every phase you win knocks a piece off
  # the dragon's chardalyn seams, and it starts the final fight weaker.
  #-----------------------------------------------------------------------------
  # The dragon's three weapons (audit C108): frostfire breath, a sonic shatter
  # from the mirror-glass in its throat, and the burst when it dies. In battle
  # the breath is Ice Beam and Flamethrower, the shatter is Hyper Voice.
  DRAGON_MOVES = [:ICEBEAM, :FLAMETHROWER, :HYPERVOICE, :DRAGONPULSE]

  def chardalyn_dragon(level)
    pk = named_mon(CHARDALYN, level, "Chardalyn Dragon")
    begin
      pk.forget_all_moves rescue (pk.moves.clear rescue nil)
      DRAGON_MOVES.each { |m| pk.learn_move(m) rescue nil }
    rescue
    end
    pk
  end

  DRAGON_TELLS = {
    seams:   ["The dragon's jaw unhinges. Behind the black glass teeth, something burns blue and orange.",
              "Frostfire: it freezes and scorches at once.",
              "The snow under it turns to steam, then to ice again."],
    pursuit: ["The dragon opens its throat and screams.",
              "Not a roar. A mirror breaking, held for a whole breath.",
              "Every icicle on the Dale's roofs falls at once.",
              "Your ears ring, and the cold in your chest cracks."]
  }

  def dragon_tell(phase)
    lines = DRAGON_TELLS[phase] or return
    if phase == :pursuit
      say(lines[0, 2])
      pbSEPlay("Uproar") rescue nil
      $game_screen.start_shake(6, 9, 30) rescue nil   # (notes 09 §3: the shatter is felt)
      say(lines[2..])
      $Trainer.party.each { |p| next if p.fainted?; p.hp = [p.hp - (p.totalhp / 10), 1].max } rescue nil
      say(["(Your team is shaken by the shatter.)"])
    else
      say(lines)
    end
  end

  def air_battle(phase, level)
    setBattleRule("canLose") rescue nil
    dragon_tell(phase)
    won = boss_battle(chardalyn_dragon(level), bgm: DRAGON_BGM)
    pbBGMPlay(FLIGHT_BGM) rescue nil
    if won
      state[:seams] = (state[:seams] || 0) + 1
      rider = rider_key
      if herald?(rider)
        say(["(You let go of #{mount_name}'s neck and drop: a falling star with a blade in it.)",
             "(Gravity is a suggestion made by someone timid.)"])
      else
        say(["#{rider == :alerion ? 'Alerion' : 'Meat Meat'} lets go of #{mount_name}'s neck and drops, blade first.",
             "A falling star with a blade in it: a Dragoon's dive."])
      end
      say(["#{mount_name} swoops under and catches #{herald?(rider) ? 'you' : (rider == :alerion ? 'him' : 'her')} a heartbeat later.",
           "A seam of black crystal cracks off the dragon and falls away into the snow, glittering."])
    else
      say(["The dragon shrugs you off and pulls ahead.",
           "You'll have to catch it at the end."])
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_flag(:"air_#{phase}")
    won
  end

  # In the air (notes 09 E3): you're not standing on a map while you fly. The
  # screen goes dark and full of snow, your sprite is gone from it, and the
  # wind plays; a panel per leg of the flight when the art comes (see the report).
  def flight_begin
    Stage.cleanup rescue nil
    pbBGMPlay(FLIGHT_BGM) rescue nil
    pbSEPlay("Wind1") rescue nil
    $game_player.transparent = true rescue nil
    $game_screen.start_tone_change(Tone.new(-150, -140, -90, 160), 20) rescue nil
    ($game_screen.weather(:Blizzard, 9, 20) rescue ($game_screen.weather(:Snow, 9, 20) rescue nil))
    Stage.wait(20)
  end

  def flight_end(tone = Tone.new(0, 0, 0, 0))
    ($game_screen.weather(:None, 0, 10) rescue ($game_screen.weather(0, 0, 10) rescue nil))
    $game_screen.start_tone_change(tone, 10) rescue nil
    $game_player.transparent = false rescue nil
  end

  #-----------------------------------------------------------------------------
  # SC 9.03 - Through the Wall
  #-----------------------------------------------------------------------------
  def sky_chase
    flight_begin
    say(["You fly into the Auroral Wall. For a moment the air is cold water.",
         "Then you're through, into the Rime. No sun. Snow in your face.",
         "Two years of night, exactly as you left it."])
    speak(:alberica, "(shouting over the wind) It's the same winter! We've been gone a month!",
                     "(into the wind, quietly) ...It's the same winter. Nothing's moved.")
    say([cl(:reptin, "(shouting back) I'd almost forgotten how much I hate it!"),
         "Ahead, a black dragon with burning gold eyes dives on a town of beehives and honey-halls.",
         "Good Mead. Its breath is a line of light. Roofs go up like paper."].compact)
    px, py = $game_player.x, $game_player.y
    Stage.fx("E-17", [px - 3, py - 3], start: 16, frames: 8, ox: 80) rescue nil   # the black dragon's breath (E-17, row 3)
    Stage.fx("E-23", [px + 2, py - 3], frames: 6, fps: 10) rescue nil               # a roof goes up (E-23)
    if flag?(:flight_path_seen)
      # A4's root model: the Heralds know its path.
      sayc([cl(:alerion, "(over the wind) Like the Barricade's model. Good Mead, then Bryn Shander."),
            cl(:meat_meat, "Then Meat Meat gets to Bryn Shander first. And waits. With teeth.")])
    end
    air_battle(:seams, 50)
    say(["You land in the burning square.",
         "Someone is pounding on the inside of the mead hall door."])
    set_switch(SW_CH9_GOODMEAD, true)
    state[:goal] = "Good Mead is burning. Get the mead hall door open."
    flight_end(good_mead_fire)
    transfer(2031, 16, 12, 8)
  end

  # Good Mead on fire (notes 09 E7): a red-orange screen while it burns, and
  # only there (apply_chapter9_switches puts it on and takes it off by map).
  def good_mead_fire = Tone.new(60, -10, -50, 30)

  def good_mead_tone
    return if !$game_map || !$game_screen
    burning = $game_map.map_id == 2031 && flag?(:air_seams) && !flag?(:air_pursuit)
    if burning
      $game_screen.start_tone_change(good_mead_fire, 0)
      $ft_ch9_fire = true
    elsif $ft_ch9_fire
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0)
      $ft_ch9_fire = false
    end
  rescue StandardError => e
    log("Good Mead's fire: #{e.message}")
  end

  def mead_hall_door(event_id = nil)
    return if flag?(:good_mead_saved)
    say(["The mead hall door is jammed in its frame, the wood swollen with heat.",
         "OLIVESSA: (inside) The bees! Get the bees out!",
         "OLIVESSA: Never mind me, get the bees!"], event_id)
    strong = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && (m.id == :STRENGTH || (GameData::Move.get(m.id).type == :FIGHTING rescue false)) } }
    who = strong ? strong.name : (with_or_is?(:reptin) && !herald?(:reptin) ? "Reptin" : "You")
    say(["#{who} #{who == 'You' ? 'hit' : 'hits'} the door. Once. Twice."])
    $game_screen.start_shake(3, 6, 10) rescue nil
    pbSEPlay("Earth1") rescue nil
    say(["It bursts inward in a cloud of smoke and furious bees."])
    door = event_id ? $game_map.events[event_id] : nil
    oli = door ? ch9_actor(:olivessa, door.x, door.y, 2, "BW (56)") : nil
    Stage.walk_to(oli, door.x - 1, door.y + 1, face: 6) if oli
    say(["Olivessa stumbles out with them, coughing, a hive in her arms."])
    # (dialogue 09 §4.5: her own hello, not the chapter's shared "You! The ___ people!")
    say([flag?(:good_mead_met) ? "OLIVESSA: (coughing) A month! Not a word, and now dragons?" :
                                 "OLIVESSA: Whoever you are, you've a hive's worth of thanks and a jar of mead coming.",
         cl(:alberica, "Mead. Darling, I could kiss you. Later. When less of the town is on fire."),
         ask_cl(:meat_meat, "Does Good Mead have coffee?", "...Coffee?"),
         "OLIVESSA: ...We have mead.",
         cl(:meat_meat, "Good Mead is dead to Meat Meat. ...After the dragon."),
         cl(:wyn, "(cupping a dazed bee) ...You're all right. You're all right, little one."),
         # (notes 09 E19: the reward from someone's hand, and what it is)
         "OLIVESSA: (pressing something into your hand) Fell through the roof with the fire. Yours."].compact)
    set_flag(:good_mead_saved)
    set_switch(SW_CH9_MEADSAFE, true)
    add_counter(:story_beats)
    give(:FT_AURORALMOTE) rescue nil
    Stage.leave(oli, door.x - 1, door.y + 4) if oli
    state[:goal] = "Back on #{mount_name}. After the dragon."
  end

  # The mead hall stays shut while it burns (notes 09 E7).
  def mead_hall_smoke(event_id = nil)
    say(["Smoke pours out of the mead hall door. Not yet."], event_id)
    pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
  end

  #-----------------------------------------------------------------------------
  # SC 9.04 - Malevolent presence
  #-----------------------------------------------------------------------------
  def your_dragon(event_id = nil)
    say(lines_for(:your_dragon), event_id)
    return say(["(The mead hall first. Someone's still inside.)"]) if !flag?(:good_mead_saved)
    return if !pbConfirmMessage(_INTL("Take off again?"))
    rider = rider_key
    flight_begin
    say(["Over Redwaters, the black dragon turns its head and looks at you.",
         "Something reaches into #{herald?(rider) ? 'your' : 'your Dragoon\'s'} mind like a cold hand."])
    if herald?(rider)
      say([rider == :alerion ? "(Your own voice, flat and wrong: ...Turn back. Winter's right. Let it burn.)" :
                               "(Your own voice, flat and wrong: ...Meat Meat should go home. To the cold table.)",
           rider == :alerion ? "(Stillness is easier.)" : "(Meat Meat belongs there.)"])
    else
      say([rider == :alerion ? "ALERION: (flat, wrong) ...Turn back. Winter's right. Let it burn." :
                               "MEAT MEAT: (flat, wrong) ...Meat Meat should go home. To the cold table.",
           rider == :alerion ? "ALERION: Stillness is easier." : "MEAT MEAT: Meat Meat belongs there."])
    end
    say(["#{mount_name} falters and banks away."])
    # (context 09 §4: the second heartbeat offered in Journey too)
    name = rider == :alerion ? "Alerion" : "Meat Meat"
    beat_opt = rider == :alerion ? "Listen for her heartbeat in him" : "Listen for his heartbeat in her"
    opts = herald?(rider) ? [_INTL("Say your own name"), _INTL("Hum Shimmer's four notes"), _INTL("Listen for the second heartbeat")] :
                            [_INTL("Say #{name}'s name"), _INTL("Hum Shimmer's four notes"), _INTL("Grab the reins"), _INTL(beat_opt)]
    c = pbMessage(herald?(rider) ? _INTL("The cold hand is in your head.") : _INTL("The cold hand is in your Dragoon's head."), opts, 0)
    case c
    when 1
      if flag?(:requiem_done)
        say(["You hum four notes. Frostina hums them with you, wherever she is in the snow.",
             "The cold hand lets go at once."])
        wheel(1)
      else
        say(["You hum four notes you only half know. It's enough. The cold hand lets go."])
      end
      set_flag(:hummed_song)
    when 2
      if herald?(rider)
        say(["Under the cold, #{mount_name}'s heart is still going: once in #{rider == :alerion ? 'her' : 'him'}, once in you.",
             "You hold on to that, and the cold hand lets go.",
             "#{mount_name} feels you come back, and climbs."])
      else
        say(["You grab the reins and steer straight back into the chase.",
             "Your Dragoon shakes it off in a minute.",
             rider == :alerion ? "ALERION: ...Thanks. Don't do that again." :
                                 "MEAT MEAT: ...Thank you. Meat Meat will bite you later."])
      end
    when 3
      say(["You lean against your Dragoon's back and listen.",
           "Under the cold, #{mount_name}'s heart is still going: once in the dragon, once in the rider.",
           "Your Dragoon hears it too, and comes back. #{mount_name} climbs."])
    else
      # (notes 09 §3: the name of the one you can see, not "their")
      say([herald?(rider) ? "You say your own name out loud, once, the way a friend would across a table." :
                            "You say #{name}'s name once, the way you'd say it across a table.",
           herald?(rider) ? "It sounds like yours again." : (rider == :alerion ? "He blinks, and comes back." : "She blinks, and comes back.")])
    end
    air_battle(:pursuit, 52)
    say(["The dragon breaks off and dives south-west, toward the biggest walls in the Dale.",
         as(:alerion, "Bryn Shander. Everyone's there."),
         cl(:reptin, "Of course they are. Everyone runs for the walls. It knows that.")].compact)
    set_switch(SW_CH9_GOODMEAD, false)
    set_switch(SW_CH9_BRYN, true)
    flight_end
    transfer(2012, 17, 12, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 9.05 - The trap; 9.06 - The green light on the horizon
  #-----------------------------------------------------------------------------
  # Someone this chapter puts on screen for their lines (WRITING_GUIDE §9a),
  # found again if they're already standing there.
  def ch9_actor(key, x, y, dir, graphic)
    Stage.find("stage_#{key}") || Stage.actor(key, x, y, dir, graphic: graphic)
  end

  BRYN_REST = [2013, 10, 11, 8]      # Bryn Shander's Pokémon Center (notes 09 E11)

  def scene_bryn_trap
    return if flag?(:dragon_down)
    set_rest_at(BRYN_REST) rescue nil
    px, py = ($game_player.x rescue 17), ($game_player.y rescue 12)
    ch9_actor(:duvessa, px, py - 3, 2, "FT_speaker_duvessa_shane")        # on the wall
    say(["Bryn Shander's square is packed. Every town that saw the dragon has sent its people here.",
         "Behind walls that can't stop anything with wings.",
         # (dialogue 09 §4: her own hello, with the reminder in it)
         "DUVESSA: (on the wall) You. I gave you my seal a month ago. Where have you...",
         "DUVESSA: Never mind. Never mind! Is that thing yours?"])
    pbMessage(_INTL("Duvessa waits for an answer."), [_INTL("\"No!\""), _INTL("Look at the sky")], 0) if !herald?(:alerion)
    speak(:alerion, "No. It's coming here. It always meant to.", "...It meant to come here.")
    say(["DUVESSA: (understanding, horrified) Everyone's here. That's the point, isn't it.",
         cl(:wyn, "(very quietly) ...There are so many children."),
         cl(:alberica, "Then nobody's dying today, sweetheart. Stay close to me.")].compact)
    if with_or_is?(:reptin)
      anduin = ch9_actor(:anduin, px + 4, py + 2, 4, "FT_anduin")
      Stage.turn_to(anduin) if anduin
      say(["In the crowd, a tall elf in travelling clothes turns at #{herald?(:reptin) ? 'your' : "Reptin's"} voice.",
           "He has an iron ring on his finger. #{herald?(:reptin) ? 'You wear' : 'Reptin wears'} its twin.",
           "ANDUIN: ...Reptin?",
           as(:reptin, "(not able to move) ...Anduin.")])
      # Context 09 M9-4 box 1: who he is (owner's decision 7: said briefly, here)
      if herald?(:alberica)
        speak(:alberica, "(to the others, very low) His husband. The voice he heard in the Rift.", "...His husband.")
      elsif !herald?(:reptin) && with_or_is?(:alberica)
        say(["ALBERICA: (to you, very low) His husband. The voice he heard in the Rift."])
      elsif !herald?(:reptin)
        say(["(Anduin. Reptin's husband: the voice he heard in the Rift.)"])
      end
    end
    # The dragon lands, and the crowd runs from it (notes 09 E3); your own
    # dragon comes down beside you.
    sky = [px + 2, py - 6]
    dragon_ev = Stage.actor(:chardalyn, sky[0], sky[1], 2, graphic: "FT_chardalyn")
    Stage.walk(dragon_ev, [1] * 4) if dragon_ev
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(6, 8, 30) rescue nil
    refugees = $game_map.events.values.select { |e| e.name =~ /^Refugee/ && !e.character_name.to_s.empty? } rescue []
    refugees.each { |e| e.through = true; pbMoveRoute(e, [PBMoveRoute::AwayFromPlayer] * 3) rescue nil }
    say(["The black dragon lands in the square, scattering the crowd. It roars."])
    mount = Stage.actor(flag?(:rides_frostina) ? :frostina : :razzilith, px - 2, py - 4, 2)
    Stage.walk_to(mount, px - 1, py, face: 6) if mount
    say(["#{mount_name} comes down beside you, wings spread over the crowd."])
    seams = state[:seams] || 0
    dragon = chardalyn_dragon(55)
    say(["Up close: black chardalyn, mirror-glass for scales, and red runes cut into every plate.",
         "Under its breastplate something beats: an old wyrm's heart, stolen and frozen black.",
         "Avarice's sigils hold the heart in place, the way a nail holds a picture.",
         "Every rune is drinking from the crowd. You feel it pull a thread from every chest here.",
         cl(:alerion, "It isn't here to burn Bryn Shander. It's here to collect it."),
         # (dialogue 09 §4.8: she feels it; she doesn't explain Alerion's line)
         cl(:alberica, "(a hand on her rune) It's pulling at me too. At all of us.")].compact)
    if seams > 0
      dragon.hp = [(dragon.totalhp * (1.0 - 0.2 * seams)).floor, 1].max
      say([seams >= 2 ? "(Its chardalyn seams are cracked all over where you hit them in the air. It's badly hurt.)" :
                        "(One of its chardalyn seams is cracked where you hit it in the air. It's hurt already.)"])
    end
    say(["#{mount_name} breathes first: #{flag?(:rides_frostina) ? 'a white line of frost' : 'a green rush of leaves and light'} across its flank.",
         "It staggers. #{mount_name} stays beside you for the fight."])
    dragon.hp = [(dragon.hp * 0.85).floor, 1].max
    # (notes 09 E11: losing here doesn't send you back inside the Wall)
    loop do
      setBattleRule("canLose") rescue nil
      break if boss_battle(dragon, bgm: DRAGON_BGM)
      say(["#{mount_name} catches you before you hit the cobbles. The dragon is still there.",
           "(Your Pokémon get up again. So do you.)"])
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    end
    $game_screen.start_flash(Color.new(200, 230, 255, 255), 20) rescue nil
    $game_screen.start_shake(5, 8, 20) rescue nil
    say(["As it dies, everything inside it bursts at once: frost and infernal fire,",
         "in a ring that races out across the square.",
         "#{mount_name} throws #{flag?(:rides_frostina) ? 'her' : 'his'} wings over the crowd. The ring breaks on them like a wave.",
         "Where it touched the ground, the cobbles are frozen and scorched in the same stroke."])
    $Trainer.party.each { |p| next if p.fainted?; p.hp = [p.hp - (p.totalhp / 8), 1].max } rescue nil
    say(["(Your team is singed by the burst.)"])            # (notes 09 E22: said, not silent)
    Stage.fx("E-06", dragon_ev, frames: 10, oy: 24) if dragon_ev
    Stage.remove_actor(dragon_ev) if dragon_ev
    say(["The dragon shatters into a thousand pieces of black crystal.",
         "One shard skitters to your feet. In it, a pale face, smiling.",
         "AVARICE: (from the shard) Pick me up.",
         herald?(:meat_meat) ? "You stamp on it before anyone can move." : "Meat Meat stamps on it before anyone can move.",
         as(:meat_meat, "No.")])
    shard_face_reaction
    set_flag(:dragon_down)
    add_counter(:story_beats)
    scene_green_light
  end

  # Context 09 M9-3: the party saw her "Dead." last night; now her face spoke.
  # The player who saw the bare arms can tell them, or keep it.
  def shard_face_reaction
    Stage.fx("E-06", [$game_player.x, $game_player.y], frames: 6, oy: 8) rescue nil   # glass under a heel
    if with_or_is?(:alberica)
      speak(:alberica, "(very quiet) That was her face. We watched her burn.", "...That was her face.")
    end
    if with_or_is?(:alerion)
      # (dialogue 09 §4.9: he remembers his own words)
      speak(:alerion, "(looking at the black glass) \"Nothing in her.\" I said that.", "...I said that.")
    end
    grind = herald?(:meat_meat) ? "You're still grinding the glass under your heel." : "Meat Meat is still grinding the glass under her heel."
    if flag?(:avarice_doubt)
      c = pbMessage(_INTL("The bare arms in the glass..."), [_INTL("Tell them"), _INTL("Say nothing")], 0)
      if c == 0
        set_flag(:avarice_doubt_shared)
        say([herald?(:alerion) ? "You tell them: no sigils on the arms. You close your eyes." :
                                 "You tell them: no sigils on the arms. Alerion closes his eyes."])
      else
        say(["You say nothing. #{grind}"])
      end
    else
      say([grind])
    end
    speak(:meat_meat, "Every mirror. Meat Meat is going to stamp on every mirror in the world.", "...Every mirror.")
  end

  def scene_green_light
    px, py = ($game_player.x rescue 17), ($game_player.y rescue 12)
    duv = ch9_actor(:duvessa, px, py - 3, 2, "FT_speaker_duvessa_shane")
    Stage.theme(:heralds)                          # (notes 09 E9: quiet now, and theirs)
    say(["The square is quiet. Snow falls on the black glass."])
    if with_or_is?(:reptin)
      anduin = ch9_actor(:anduin, px + 4, py + 2, 4, "FT_anduin")
      Stage.approach(anduin) if anduin
      say(["#{herald?(:reptin) ? 'You and Anduin are' : 'Reptin and Anduin are'} holding each other. Anduin is shaking.",
           "ANDUIN: Five weeks I waited. You said a month, at most. You always say a month.",
           "ANDUIN: And you come down out of the sky on a dragon. What happened to you? You look..."])
      speak(:reptin, "(trying for a smile) Older?", "...I don't know.")
      # (dialogue 09 §4.10: the green light answers what he'd ask next)
      say(["ANDUIN: (touching his face) No. Like something's growing in you."])
    end
    say(["South-east, where Dougan's Hole used to be, a green light glows through the snow.",
         "The crown of a tree, piercing the aurora.",
         "DUVESSA: What is that?"])
    speak(:alberica, "Home. Somebody's. Warm, with food. And the Wall's thin enough to walk now.",
                     "...Home. It's warm there. You can walk through the Wall now.")
    say([cl(:meat_meat, "And coffee. Alberica forgot coffee."),
         cl(:alberica, "I never forget coffee. I just don't count it as food."),
         # (context 09 M9-4: the town's own reason to leave its walls: Chapter 2's lottery)
         "DUVESSA: (looking at the lottery board) Two years of that board.",
         "DUVESSA: If there's warm ground out there, I'm done drawing names.",
         # (context 09 §8b: her village was spared, the bargain's price paid by someone
         # else; the owner's call, 2026-11-06: the village is Ironhollow, made up. She doesn't answer.)
         "REFUGEE: (under her breath) Not one name drawn from Ironhollow in two years.",
         "REFUGEE: Lucky, down south. Always lucky.",
         "DUVESSA: (to the whole square) Bryn Shander! Pack what you can carry!"].compact)
    if flag?(:husband_thawed)
      widow = Stage.actor(:widow, px - 4, py + 2, 6, graphic: "BWOldWoman")
      Stage.walk_to(widow, px - 1, py + 1, face: 8) if widow
      say(["The Targos widow and her husband walk past, arm in arm.",
           # (dialogue 09 §4.12: the payoff, when you carried his message)
           flag?(:widow_told) ? "WIDOW: (squeezing his arm) He came home. Just like you said he would." :
                                "WIDOW: (squeezing his arm) Look who walked out of the ice."])
      Stage.leave(widow, px + 6, py + 2) if widow
    end
    # (the square's own Anduin and Duvessa stand in for these from here on)
    [Stage.find("stage_anduin"), Stage.find("stage_duvessa")].compact.each { |ge| Stage.remove_actor(ge) }
    set_flag(:refugees_follow)
    set_flag(:anduin_found)
    add_counter(:story_beats)
    set_switch(SW_CH9_BRYN, false)
    set_switch(SW_CH9_AFTER, true)
    # (notes 09 E5, E17: the square is yours to walk now; the south road leads out)
    state[:goal] = "Lead the refugees south-east, to Rootspire: out by Bryn Shander's south road."
    say(["(The square is packing up around you. When you're ready, the south road leads out.)"])
  end

  # Anduin in the square, after: he'll walk with you, whenever you're ready to lead them south.
  def anduin_ch9(event_id = nil)
    say(lines_for(:anduin_after), event_id)
    return if !pbConfirmMessage(_INTL("Lead the refugees south, to the green light?"))
    lead_refugees
  end

  # The hooded woman in the square (Phildendrin, unnamed): one look.
  def hooded_woman_ch9(event_id = nil)
    say(lines_for(:hooded_woman), event_id)
    return if flag?(:saw_hooded_woman)
    set_flag(:saw_hooded_woman)
    say(["She can't stop looking at #{herald?(:meat_meat) ? 'you' : 'Meat Meat'}.",
         "When #{herald?(:meat_meat) ? 'you look' : 'Meat Meat looks'} back, she's gone into the crowd."], event_id)
    sayc([cl(:meat_meat, "...Meat Meat knows that hood. Meat Meat doesn't know how.")])
  end

  # Duvessa by the south road; the road itself asks (notes 09 E5).
  def duvessa_square(event_id = nil)
    say(lines_for(:duvessa_square), event_id)
    return if !pbConfirmMessage(_INTL("Lead the refugees south, to the green light?"))
    lead_refugees
  end

  def south_road(event_id = nil)
    if pbConfirmMessage(_INTL("Lead the refugees south, to the green light?"))
      return lead_refugees
    end
    pbMoveRoute($game_player, [PBMoveRoute::Up]) rescue nil
  end

  # The walk south (from Bryn Shander, after the dragon).
  def lead_refugees(event_id = nil)
    Stage.theme(:heralds)
    say(["A long line of people walks out of Bryn Shander behind you, toward the green light."], event_id)
    say([cl(:alberica, "(singing to the kids, terribly) Oh, the dragon came down, and it went BOOM..."),
         cl(:wyn, "(handing out mushroom biscuits) ...Um. One each. They're good for you. Sorry."),
         cl(:meat_meat, "Meat Meat carries the small one. The small one bites. Meat Meat respects her."),
         cl(:alerion, "They're all following you, Alberica."),
         cl(:alberica, "Everybody follows a good song, pretty boy. Even a bad one, if you're loud.")].compact)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)   # (notes 09 E22)
    say(["Three days. Nobody complains.",
         "Then the snow thins, the air goes soft, and the Wall is only a shimmer you walk through."])
    set_switch(SW_CH9_AFTER, false)
    set_switch(SW_CH9_RETURN, true)
    transfer(2050, 9, 22, 6)
  end

  #-----------------------------------------------------------------------------
  # SC 9.07 - Slayers of Summer
  #-----------------------------------------------------------------------------
  def scene_slayers_of_summer
    set_switch(SW_CH9_RETURN, false)
    return if flag?(:heralds_arrested)
    say(["A long line of refugees walks out of the snow and into autumn.",
         "Rootspire's people stare at them. They stare back."])
    # Rheven and his wardens come down the street; Kelyn after them (WRITING_GUIDE §9a)
    px, py = ($game_player.x rescue 9), ($game_player.y rescue 22)
    rheven = Stage.find("Captain Rheven")
    rheven ? (rheven.moveto(px + 6, py) rescue nil) : (rheven = Stage.actor(:rheven, px + 6, py, 4, graphic: "FT_captain_rheven_stormbranch"))
    wardens = [Stage.actor(:rootwarden, px + 6, py - 1, 4, graphic: "BW029"), Stage.actor(:rootwarden_2, px + 6, py + 1, 4, graphic: "BW029")]
    pbBGMFade(1.0) rescue nil                      # (notes 09 E9: the music cuts for the arrest)
    Stage.approach(rheven) if rheven
    wardens.compact.each_with_index { |w, i| Stage.walk_to(w, px + 2, py + (i.zero? ? -1 : 1), face: 4) }
    # (notes 09 E14: an arrest here; the charges are read at the Tribunal)
    say(["Rootwardens close in with spears lowered. Rheven leads them. He looks unhappy.",
         "RHEVEN: (not meeting your eyes) In the name of the Verdant Council, you're under arrest.",
         "RHEVEN: For the Summer Marshal. And for #{autumn_hand[:title]}."])
    # (the player's input on the arrest: what you do when the spears come down)
    if !herald?(:meat_meat)
      c = pbMessage(_INTL("The spears come down toward Meat Meat."), [_INTL("Step in front of her"), _INTL("Put your hands up")], 0)
      set_flag(:stood_by_mm_arrest) if c == 0
      say([c == 0 ? "You step in front of her. Two spear-points stop a hand from your chest." :
                    "You put your hands up. So does everyone else, slowly."])
    end
    speak(:meat_meat, "Var was a coat! A coat!", "...Var was a coat.")
    sayc([cl(:reptin, "Let's all be very reasonable. Especially the people with spears."),   # protected (dialogue 09 §6)
          cl(:alerion, "She's right. He was a coat.")])
    kelyn = Stage.actor(:kelyn, px + 6, py, 4, graphic: "FT_high_speaker_kelyn_of_spring")
    Stage.approach(kelyn) if kelyn
    # Context 09 M9-5: the arrest's real logic (the Speaker heard; the city saw),
    # and its witness (the wardens who carried the child up, part 08 M8-5).
    say([flag?(:kelyn_heard_reveal) ? "KELYN: (arriving, white-faced) I heard her on the stone. I believe you." :
                                      "KELYN: (arriving, white-faced) I can't stop this.",
         "KELYN: But the city didn't hear her. It saw the summer die.",
         "KELYN: It saw its Marshal go down into the roots, and Autumn's chair go empty.",
         flag?(:child_carried_up) ? "RHEVEN: My wardens carried a child up out of that forge. They heard what the goblin said." :
                                    "RHEVEN: Autumn's chair is empty, and the goblin came up with the blood on her."])
    if flag?(:mm_reached)
      speak(:meat_meat, "Meat Meat reached. Meat Meat will say that too.", "...Meat Meat reached.")
    else
      speak(:meat_meat, "Meat Meat said it. Meat Meat will say it again.", "...Meat Meat will say it again.")
    end
    # (notes 08 E3: what you did on the bridge, read back)
    if flag?(:stood_by_mm_arrest) && !herald?(:meat_meat)
      say(["MEAT MEAT: (behind you, very quietly) You stood in front of the spears. Meat Meat saw."])
    end
    if flag?(:you_took_cocoon)
      say(["MEAT MEAT: (to you) You held the child. Meat Meat let go of him. Say that, at the trial."])
    elsif flag?(:you_called_mm)
      say(["MEAT MEAT: (to you) You called Meat Meat's name. Meat Meat heard. Meat Meat chose anyway."])
    end
    # (two voices from the crowd that's been staring, on screen for their lines)
    Stage.actor(:someone_in_the_crowd, px - 2, py - 2, 2, graphic: "BW (38)")
    Stage.actor(:someone_else, px - 2, py + 2, 8, graphic: "BW (29)")
    say(["SOMEONE IN THE CROWD: Murderers!",
         "SOMEONE ELSE: Liberators!",
         "KELYN: There will be a trial. The Trials of the Roots. Bring witnesses. Bring me anything."])
    set_flag(:heralds_arrested)
    add_counter(:story_beats)
    say(["END OF CHAPTER 9"])
    state[:goal] = "The Trials of the Roots. You're under watch, but free to move in the city."
    chapter10_start if respond_to?(:chapter10_start)
  end

  def apply_chapter9_switches
    return if !active? || !$game_switches
    $game_switches[SW_CH9_GOODMEAD] = flag?(:air_seams) && !flag?(:air_pursuit)
    $game_switches[SW_RIDES_FROSTINA] = flag?(:rides_frostina)
    $game_switches[SW_CH9_MEADSAFE] = flag?(:good_mead_saved)
    $game_switches[SW_CH9_BRYN] = flag?(:air_pursuit) && !flag?(:dragon_down)
    $game_switches[SW_CH9_AFTER] = flag?(:dragon_down) && !flag?(:heralds_arrested) && !$game_switches[SW_CH9_RETURN]
    good_mead_tone
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter9_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 9 switches failed: #{err.message}")
  end
}
