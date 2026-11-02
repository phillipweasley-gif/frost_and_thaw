#===============================================================================
# Frost & Thaw - Act I, Chapter 5: The Cackling Chasm
#
# After the campaign's "The Cackling Chasm" adventure and its "Frost Hag" boss
# notes, ending with the Verdant Reversal of the Rootspire timeline ("the party
# shatters the Hag's mirrors in the Cackling Chasm, freeing time's flow and
# seeding life into the Dale; a single sapling bursts from the thawed soil
# above the ruins of Dougan's Hole").
#
#   1. The Laughing Waste. Reptin hasn't slept: the wolf in his dreams, chained
#      in ice, and a crone telling him to give up his bond.
#   2. The chasm: the hag's illusion at the door, an icefall and ice mephits,
#      a frozen locket with Alberica's name in it.
#   3. The frozen feast hall: a yeti's family, torn apart. The mother fights.
#   4. The hall of illusions: a child's voice and a light to the left (a pit,
#      and things in it); an old woman weeping to the right (the true way).
#   5. The frozen rift and its bridge; a warm fissure to rest by; the
#      Guardian's Gate of the Order of Life and Death (life and death, offered).
#   6. The hidden sanctum: the last guardian of the Order, who has Alberica's
#      face. The werewolf wardens. The Heart. A blessing.
#   7. The Heart of the Chasm: Granny Thredra, the yeti cub in chains, her
#      winter wolf and ice troll, her mirrors. The mirrors break; she is caught
#      in them; the Heart is denied; Reptin keeps his charge; and time comes
#      loose: the Verdant Reversal. The memory ends.
#===============================================================================
module FrostThaw
  SW_ICEFALL   = 3927
  SW_YETI_DOWN = 3928
  SW_PIT_DONE  = 3929
  SW_GATE_OPEN = 3930
  SW_GHOST_REST = 3931
  SW_REVERSAL  = 3932

  MAPS.merge!(waste: 2041, upper_caves: 2042, pit: 2043, rift: 2044, sanctum: 2045, heart: 2046)
  MAP_NAMES.merge!(
    2041 => "The Laughing Waste", 2042 => "The Cackling Chasm", 2043 => "The Pit", 2044 => "The Frozen Rift",
    2045 => "Hidden Sanctum", 2046 => "The Heart of the Chasm"
  )
  MAP_METADATA.merge!(
    2041 => { outdoor_map: true, announce_location: true, weather: [:Snow, 80], battle_environment: :Snow },
    2042 => { announce_location: true, battle_environment: :Cave },
    2043 => { battle_environment: :Cave },
    2044 => { announce_location: true, battle_environment: :Cave },
    2045 => { battle_environment: :Cave },
    2046 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2041 => :waste, 2042 => :chasm, 2043 => :chasm, 2044 => :rift, 2045 => :sanctum, 2046 => :heart)
  # Where you wake after losing, once you've rested by the warm fissure.
  CHASM_REST = [2044, 34, 27, 6]

  ENCOUNTERS[2041] = { step_chances: { Land: 21 },
                       Land: [[20, :SNORUNT, 27, 29], [15, :SWINUB, 27, 29], [10, :PILOSWINE, 28, 30],
                              [15, :SNEASEL, 27, 30], [15, :MIGHTYENA, 28, 30], [15, :HOUNDOUR, 27, 29],
                              [10, :GASTLY, 27, 29], [5, :YETOT, 27, 29]] }
  ENCOUNTERS[2042] = { step_chances: { Cave: 8 },
                       Cave: [[25, :GOLBAT, 28, 30], [20, :GASTLY, 28, 30], [15, :SNORUNT, 28, 30],
                              [15, :SNEASEL, 28, 30], [15, :CUBONE, 28, 30], [10, :HAUNTER, 29, 31]] }
  ENCOUNTERS[2044] = { step_chances: { Cave: 8 },
                       Cave: [[25, :GOLBAT, 29, 31], [20, :HAUNTER, 29, 31], [15, :SNORUNT, 29, 31],
                              [15, :DUSKULL, 29, 31], [15, :CUBONE, 29, 31], [10, :GLALIE, 30, 32]] }
  VERSION_ENCOUNTERS[:frost][2041] = { Land: [[10, :MISDREAVUS, 27, 29]] }
  VERSION_ENCOUNTERS[:thaw][2041]  = { Land: [[10, :GROWLITHE, 27, 29]] }
  VERSION_ENCOUNTERS[:frost][2042] = { Cave: [[10, :SMOOCHUM, 28, 30]] }
  VERSION_ENCOUNTERS[:thaw][2042]  = { Cave: [[10, :PHANPY, 28, 30]] }

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINERS.merge!(
    aurilite_ten:   [:FT_AURILITE,     "Rhosk", [[:SNEASEL, 28], [:B428H215, 29]],
                     "The crone laughs at all of us. Even the faithful."],
    hunter_gerd:    [:HIKER,           "Gerd",  [[:B217H215, 29], [:PILOSWINE, 29]],
                     "Came for yeti pelts. Going home with nothing. Story of my life."],
    ranger_brisa:   [:POKEMONRANGER_F, "Brisa", [[:DELIBIRD, 28], [:B87H221, 30]],
                     "Rangers don't go into the chasm. I can see why you might."],
    channeler_odda: [:CHANNELER,       "Odda",  [[:HAUNTER, 29], [:B200H427, 30]],
                     "The voices in the chasm aren't ghosts, child. That's what frightens me."],
    thredra:        [:FT_HAG,          "Thredra", [[:B429H124, 31], [:B255H200, 32], [:B124H429, 33]],
                     "Heh... heh... Won, have you? Look in the mirror, dearies.", [:HYPERPOTION, :FULLHEAL]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    dh_south_block: ["TRAPPER: Nobody goes south of the Stones. South is where the laughing comes from.",
                     "TRAPPER: When the laughing stops, maybe. Not before."],
    sign_waste: ["SOUTH: the Laughing Waste.", "(Someone has scratched underneath: \"TURN BACK. SHE HEARS YOU.\")"],
    waste_trapper: ["The chasm's just past the ice hills. You'll hear it before you see it.",
                    "There used to be gnolls in there. Then something worse moved in,",
                    "and the gnolls stopped laughing."],
    aurilite_ten_after: ["She promised Auril a gift. A big one.", "I don't think it's the gift Auril wanted."],
    hunter_gerd_after: ["A yeti family came down from the peaks this winter. I haven't seen them in a week."],
    ranger_brisa_after: ["Mind the bridge in there. That old explorers' rope wouldn't hold a cat."],
    channeler_odda_after: ["The Order of Life and Death built that place. Old druids.",
                           "They kept something down there that keeps the world turning."],
    # --- the chasm ---------------------------------------------------------------------
    mother_yeti_after: [{ if: { flag: :cub_home }, lines: ["The mother yeti lies curled around her cub. She opens one eye as you pass, and closes it again."] },
                        ["The mother yeti lies over her mate's body, breathing slowly.",
                         "Her eyes follow you, then the far tunnel. Then you again."]],
    pit_message: ["Scrawled on the wall of the pit in old, dark blood:", "\"SHE LIES.\"", "\"DON'T TRUST THE LIGHT.\""],
    gate_arch: ["An arch of carved skulls and blossoms frames the door.",
                "Grinning skulls and wilting stone flowers, woven together.",
                "Runes writhe above it under centuries of frost. As near as anyone can read them:",
                "Life for Death. Death for Life."],
    bier_after: ["The bier is empty but for a little dust and a dark green robe, folded.",
                 "The lichen glow has dimmed to almost nothing."],
    heart_crystal: ["The Heart of the Chasm: four curved spires of ice cradling an orb of blood-red ice.",
                    "It pulses, slowly, like a heartbeat. You feel it in your teeth."],
    heart_crystal_after: ["The Heart has gone quiet: a pale crystal, faintly warm.",
                          "Deep inside, a slow green light turns over, like a seed in the dark."],
    yeti_cub_chained: ["A yeti cub hangs in chains between the pillars, gagged, white fur matted with tears.", "Its blue eyes beg."],
    heart_mirror: ["A tall pane of frost-rimmed ice. In it, the crone smiles at you from just behind your own shoulder."]
  )

  PARTY_CHAT[:alberica].merge!(
    waste: ["My locket's... no. I don't have a locket.", "Why did I just reach for one?"],
    chasm: [{ if: { flag: :order_locket }, lines: ["It's my face in that locket. Older. Sterner. Still gorgeous, mind.",
                                                     "I don't understand it, darling. I don't think I'm meant to yet."] },
            ["Every song I know about places like this ends the same way.", "I'd like to write a new ending. With fewer bones."]],
    rift: ["Don't look down. Sing if you have to. I'm singing.", "You can't hear it, but I'm singing."],
    sanctum: ["She looked at me like she was remembering me. Not meeting me.", "Remembering me."],
    heart: [{ if: { flag: :reversal }, lines: ["I put my hand on it and the whole world turned over.",
                                                "I think I've done that before. I think I'll do it again."] },
            ["That crystal's beating in time with my heart.", "Or my heart's beating in time with it. I don't like either."]]
  )
  PARTY_CHAT[:reptin].merge!(
    waste: ["I haven't slept. When I close my eyes there's a wolf in chains,",
            "and an old woman telling it to let go. I'm fine. Don't look at me."],
    chasm: ["The blood in here is old. The wolf in me doesn't care how old.", "I care. I'm holding on."],
    rift: ["The wind sounds like laughing. Under it, very low, something's howling.", "I think it's howling for me."],
    sanctum: ["A charge, she said. Not a curse.",
              "I've been ashamed of this so long I don't know how to be anything else. Yet."],
    heart: [{ if: { flag: :reversal }, lines: ["I'll keep watch. Not alone, I hope. But I'll keep watch."] },
            ["She promised to take it away. The hunger, the moon. All of it.", "I'd be lying if I said I didn't want that."]]
  )
  PARTY_CHAT[:alerion].merge!(
    waste: ["My ring hasn't been this cold since the Glade.", "She knows we're coming."],
    chasm: ["Bones in the ice. Voices in the dark. I've walked through worse.", "I'd rather not, though."],
    rift: ["Single file. Slow. If the wind takes you, grab the rope.", "Not me. I'll go over with you."],
    sanctum: ["The dead here aren't restless. They're patient.", "That's worse."],
    heart: [{ if: { flag: :reversal }, lines: ["I've been frozen outside of time. Now I've watched time thaw.", "I prefer it this way round."] },
            ["Seven mirrors. Watch them, not her.", "She's always in the one you aren't looking at."]]
  )
  PARTY_CHAT[:shade].merge!(
    waste: ["Shimmer would've hated this place.", "Then she'd have gone in first."],
    chasm: ["That was a kid's voice. I know it wasn't a kid.", "Doesn't matter. My feet still wanted to go left."],
    rift: ["I'm fine. I'm fine. Just walk."],
    sanctum: ["Ghosts. Of course there are ghosts.", "Is there one place in this Dale that isn't haunted? Asking for a friend. The friend is me."],
    heart: [{ if: { flag: :reversal }, lines: ["Did you hear the cub laugh?", "First thing I've heard laugh in months that wasn't her."] },
            ["She's going to hurt that baby. Over my dead body.", "Ideally over hers."]]
  )
  PARTY_CHAT[:meat_meat].merge!(
    waste: ["Wind is laughing at Meat Meat. Meat Meat is laughing back. Louder."],
    chasm: ["Big fluffy mama in there was sad, not mean. Meat Meat knows the difference."],
    rift: ["Meat Meat is not looking down. Meat Meat is looking at you. Keep walking."],
    sanctum: ["Ghost lady has a nice face. Same face as singing lady.", "Meat Meat noticed. Meat Meat notices things."],
    heart: [{ if: { flag: :reversal }, lines: ["Baby yeti laughed! Meat Meat taught it a better laugh.", "Meat Meat is a good teacher."] },
            ["Pointy crystal is beating. Meat Meat does not like things that beat that are not hearts."]]
  )

  module_function

  def hurt_party(fraction)
    $Trainer.party.each do |pk|
      next if pk.egg? || pk.fainted?
      pk.hp = [pk.hp - (pk.totalhp * fraction).floor, 1].max
    end
  rescue StandardError => e
    log("hurt_party: #{e.message}")
  end

  #-----------------------------------------------------------------------------
  # The Laughing Waste
  #-----------------------------------------------------------------------------
  # SC 5.01 - Full moon on the Laughing Waste
  def scene_waste_start
    set_flag(:waste_started)
    add_counter(:story_beats)
    say(["South of Dougan's Hole the land breaks into ice hills and black stone.",
         "A full moon. The wind sounds like someone laughing."])
    wolf = Stage.herald(:reptin, 0, -1, 2)
    if herald?(:reptin)
      say(["You stop walking. Your shoulders roll wrong."])
      Stage.pose(wolf, "P-REP-04", 0, frames: [0, 1, 2], per: 8) if wolf
      say(["For one breath you are a wolf, grey and enormous. Then you're on your knees in the snow."])
      Stage.pose(wolf, "P-REP-04", 0, frames: [3], per: 4) if wolf
      say(["(The bite. It's the bite.)",
           "(Every night since, you've dreamed of a chained wolf. And a crone: \"Abandon your bond and be free.\")"])
      speak(:reptin, "I'm fine. Don't look at me. I'm fine.", "...I'm fine.")
      sayc(["ALERION: Then don't listen to her.",
            cl(:alberica, "Up you get, sugar. Lean on me. I'm sturdier than I look. Which is very sturdy."),
            "(You stand up. You weren't planning to stay down.)"])
    else
      sayc(["Reptin stops walking. His shoulders roll wrong."])
      Stage.pose(wolf, "P-REP-04", 0, frames: [0, 1, 2], per: 8) if wolf
      sayc(["For one breath there's a wolf where he stood, grey and enormous. Then Reptin again, on his knees."])
      Stage.pose(wolf, "P-REP-04", 0, frames: [3], per: 4) if wolf
      sayc(["REPTIN: The bite. It's the bite.",
            "REPTIN: Every night since, I've dreamed of a chained wolf. And a crone: \"Abandon your bond and be free.\"",
            as(:alerion, "Then don't listen to her."),
            cl(:meat_meat, "Doggy Reptin. Meat Meat is not scared. Meat Meat will still sit next to him."),
            "REPTIN: (standing) I wasn't planning to. I'm fine. Don't look at me."])
    end
    Stage.cleanup rescue nil
    set_flag(:reptin_wolf)
  end

  #-----------------------------------------------------------------------------
  # The upper caves
  #-----------------------------------------------------------------------------
  # SC 5.02 - An old woman's home (its own scene key: the Frost-Light Chasm's is scene_frostlight_enter)
  def scene_cackling_enter
    return if flag?(:chasm_entered)
    set_flag(:chasm_entered)
    set_flag(:cackling_entered)
    sayc(["The chasm laughs. Not echoing: laughing, out of the rock itself.",
          "A kindly old woman stands at the cave mouth with a lantern.",
          "THREDRA: So good of you to visit an old woman in her home.",
          "THREDRA: I smell the wolf among you. Good. I asked for the wolf.",
          "She flickers and is gone. The lantern stays, hanging from nothing.",
          cl(:reptin, "She's lovely. Really. Somebody remind me to never visit again."),
          cl(:shade, "Free lantern, though.")])
  end

  def chasm_icefall(event_id = nil)
    return if flag?(:mephits_done)
    if !flag?(:icefall_fell)
      set_flag(:icefall_fell)
      pbSEPlay("Ice2") rescue nil
      say(["A crack, high overhead. Then the ceiling comes down: jagged icicles and chunks of heavy ice!",
           "Your Pokémon throw themselves in front of you. The crash echoes away, deeper and deeper.",
           "Somewhere ahead, delighted, the crone: \"Oops! Mind your heads, dearies!\""])
      hurt_party(0.2)
    end
    say(["Out of the crevices near the roof swoop small shapes made of ice, shrieking with laughter: ice mephits!"])
    return if !boss_battle(named_mon(:SNORUNT, 28, "Ice mephit"), named_mon(:SNORUNT, 28, "Ice mephit"))
    sayc(["The last mephit cracks and bursts into a spray of shards. The tunnel goes quiet.",
          cl(:meat_meat, "Laughing ice. Meat Meat laughed last. Meat Meat wins.")])
    set_flag(:mephits_done)
    $game_switches[SW_ICEFALL] = true if $game_switches
  end

  # SC 5.03 - The Order's locket
  def chasm_locket(event_id = nil)
    say(["A silver locket, half sun, half moon. Inside, a portrait of a stern, older dwarf woman.",
         "Under it, a name."], event_id)
    if herald?(:alberica)
      say(["(That's your name. That's your face. Older.)"])
      speak(:alberica, "Well. I age beautifully. That's something. ...I've never been here.", "...I've never been here.")
    else
      say(["ALBERICA: (very still) That's my name. That's my face. Older.",
           "ALBERICA: I've never been here."])
    end
    sayc([cl(:alerion, "You're sure?"),
          cl(:alberica, "Pretty boy, I'd remember a place this miserable.")])
    give_key(:FT_ORDERLOCKET)
    set_flag(:order_locket)
    set_self_switch(event_id, "A")
  end

  def dead_yeti(event_id = nil)
    say(["A white-furred yeti lies dead at the centre of the hall, chest torn open.",
         "Its heart has been taken. Not bitten out. Cut.",
         "One great hand is clenched tight around something."], event_id)
    if flag?(:yeti_faced) && !flag?(:found_swaddling)
      set_flag(:found_swaddling)
      sayc(["You work the frozen fingers open. Inside: a tuft of soft white fur tied with sinew. A baby's swaddling.",
            "Drag marks lead away into the far tunnel. Booted footprints beside them.",
            as(:reptin, "They had a child. She took the child."),
            cl(:shade, "(very quiet) Then we take it back.")])
    end
  end

  def yeti_notice(event_id = nil)
    return if flag?(:yeti_faced)
    mother_yeti(event_id)
  end

  # SC 5.04 - The feast hall
  def mother_yeti(event_id = nil)
    return talk(:mother_yeti_after, event_id) if flag?(:yeti_faced)
    say(["A great white yeti lies dead, chest opened, heart gone.",
         "His hand still clutches a scrap of baby swaddling.",
         "Over him stands his mate, roaring."])
    me = herald?(:alberica)
    c = pbMessage(_INTL("What do you do?"), [me ? _INTL("Sing.") : _INTL("Ask Alberica to sing."), _INTL("Fight.")], 0)
    if c == 0
      say([me ? "You sing the lullaby from Bryn Shander's square. No jokes in it. Not one." :
                "Alberica sings the lullaby from Bryn Shander's square. No jokes in it. Not one."])
      if flag?(:stood_with_alberica)
        say(["The mother stops, shaking. She looks at the swaddling.",
             "Then she points, deeper into the chasm, to where her cub was taken."])
        set_flag(:yeti_calmed)
        set_flag(:yeti_faced)
        $game_switches[SW_YETI_DOWN] = true if $game_switches
        add_counter(:story_beats)
        return
      end
      say(["The song catches. Nobody stood beside it that night in the square, and it hasn't learned to carry yet.",
           "The yeti roars over it and charges."])
    end
    return if !boss_battle(named_mon(:YETITAN, 31, "Yeti"))
    say(["She collapses over her mate. Then she gets up, and limps after you at a distance."])
    set_flag(:yeti_fought)
    set_flag(:yeti_faced)
    $game_switches[SW_YETI_DOWN] = true if $game_switches
    add_counter(:story_beats)
  end

  def bone_pile(event_id = nil)
    if flag?(:bone_dust)
      return say(["Gnawed bones, frozen into the floor. You've already taken what you need."], event_id)
    end
    say(["A pile of gnawed bones: goat, fox, gnoll. The oldest have crumbled to grey dust.",
         "On an impulse you can't explain, you fold a pinch of the dust into a scrap of cloth and keep it."], event_id)
    set_flag(:bone_dust)
  end

  def chasm_backpack(event_id = nil)
    say(["On the bone pile: a backpack and a journal. Inside the pack, a healing draught, still intact.",
         "\"Granny Thredra is kind. Granny Thredra says she can bring my sister back.\"",
         "The last page says only: SHE LIES."], event_id)
    pbReceiveItem(:SUPERPOTION) rescue nil
    set_flag(:thredra_named)
    set_self_switch(event_id, "A")
  end

  # SC 5.05 - The split path
  def scene_illusion_fork
    return if flag?(:seen_illusion_fork)       # it sits on a three-tile row: play it once, not per tile or per visit
    set_flag(:seen_illusion_fork)
    say(["Two tunnels of glassy ice. From the left, warm light and a child's voice.",
         "From the right, an old woman weeping.",
         "CHILD'S VOICE: Shade? Shade, it's me. Shimmer. I'm lost. I'm so cold.",
         "SHADE: (already moving) That's..."])
    speak(:alerion, "(grabbing their arm) Your sister's gone, Shade. And she was never that small.",
                    "(grabbing their arm) Shade. She was never that small.")
  end

  def pit_trap(event_id = nil)
    return if flag?(:pit_done)
    set_flag(:took_left)
    say(["You follow the light into a little cave. The child's voice is just ahead: \"This way... hurry...\"",
         "Then the floor isn't there any more."])
    pbSEPlay("Earth3") rescue nil
    transfer(MAPS[:pit], 6, 6, 2)
  end

  def pit_bottom(event_id = nil)
    if flag?(:pit_done)
      set_self_switch(event_id, "A")
      return
    end
    say(["You land hard on jagged rock and old bones, fifteen feet down. The light above goes out.",
         "Something in the dark is moving. Two shapes, starved thin, eyes shining with hunger."])
    hurt_party(0.15)
    return if !boss_battle(named_mon(:DUSKULL, 29, "Ghoul"), named_mon(:BANETTE, 30, "Ghoul"))
    say(["The ghouls collapse into rags and dust.",
         "Far above, the crone's laughter rolls through the caves: \"Poor little lambs... did you stumble? Heehee!\""])
    set_flag(:pit_done)
    $game_switches[SW_PIT_DONE] = true if $game_switches
    set_self_switch(event_id, "A")
  end

  def pit_pouch(event_id = nil)
    say(["Among the bones: a belt pouch with a healing draught,",
         "and a little scrimshaw carving of a smiling halfling."], event_id)
    pbReceiveItem(:SUPERPOTION) rescue nil
    set_self_switch(event_id, "A")
  end

  def pit_climb(event_id = nil)
    if !flag?(:pit_done)
      return say(["An old rope hangs down the wall of the pit. Whatever's down here won't let you reach it."], event_id)
    end
    say(["You climb the old rope, hand over hand, back up to the fork."], event_id)
    fork_after
    transfer(MAPS[:upper_caves], 12, 7, 6)
  end

  def scene_weeping_dark
    return if flag?(:seen_weeping_dark)
    set_flag(:seen_weeping_dark)
    set_flag(:took_right) if !flag?(:took_left)
    say(["The weeping is real: the cub's mother, or her echo, somewhere ahead in the dark.",
         "This is the true way. Claw marks on the walls go the same way you are."])
    fork_after
  end

  # Either way out of the fork.
  def fork_after
    return if flag?(:fork_talked)
    set_flag(:fork_talked)
    say(["SHADE: She knew her name. How did she know her name?",
         as(:meat_meat, "Hags know everything you're scared of. That is their whole job."),
         cl(:alberica, "(an arm around Shade's shoulders, just for a moment) And it's a rotten job, sugar.")].compact)
  end

  #-----------------------------------------------------------------------------
  # The frozen rift and the Guardian's Gate
  #-----------------------------------------------------------------------------
  def scene_rift_arrive
    set_flag(:rift_arrived)
    sayc(["The passage ends at a ledge over nothing. A chasm cuts down so deep your light gives up.",
          "Across it runs a long, narrow bridge, slick with ice, its old rope railing limp and frayed.",
          "The wind howls up out of the dark, and the cackling is louder here, rising, fading to a moan.",
          "Under it, from beyond the far side, very faint: chanting.",
          cl(:alberica, "Lovely. Who's first? Not me. I'm the morale."),
          cl(:alerion, "Me.")])
  end

  def bridge_crack(event_id = nil)
    return if flag?(:bridge_cracked)
    set_flag(:bridge_cracked)
    pbSEPlay("Ice2") rescue nil
    say(["CRACK! A chunk of ice breaks from the roof and shatters on the bridge, one step ahead of you.",
         "The whole span shudders. Pebbles skitter off the edge, and you never hear them land.",
         "The laughter on the wind rises, as if mocking you."])
  end

  def bridge_gust(event_id = nil)
    return if flag?(:bridge_gusted)
    set_flag(:bridge_gusted)
    say(["A gust tears up out of the abyss. You drop to your knees on the ice, gripping the stone."])
    ghost = begin
      d = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }[$game_player.direction] || [0, -1]
      Stage.actor(:green_ghost, $game_player.x + d[0] * 4, $game_player.y + d[1] * 4,
                  10 - $game_player.direction, graphic: "FT_green_ghost")
    rescue StandardError
      nil
    end
    ghost.instance_variable_set(:@opacity, 170) if ghost
    say(["For a moment, on the far ledge, a ghostly woman in dark green robes stands pointing at you."])
    Stage.hide(ghost)
    say(["Then she's gone. The gust passes. You get up. You keep going."])
    Stage.cleanup rescue nil
  end

  def chasm_camp(event_id = nil)
    say(["A fissure in the rock breathes warm air up from somewhere very deep. Out of the wind, it's almost cosy.",
         "You rest a while. The laughing sounds further away from here."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(CHASM_REST)
    sayc([cl(:meat_meat, "Warm crack. Meat Meat could make coffee on this crack."),
          cl(:meat_meat, "Meat Meat has no coffee. Meat Meat is going to cry. Fondly."),
          cl(:alberica, "Here, darling. Last of the Good Mead honey cake. Don't tell anyone."),
          cl(:shade, "Everyone's watching you hand it over."),
          cl(:alberica, "Then nobody tell anyone.")], event_id)
  end

  def guardian_gate(event_id = nil)
    return if flag?(:gate_open)
    say(["A massive door of ancient granite, carved in two halves.",
         "On one, a great wolf curled round a full moon. On the other, a reaper's scythe cradling a newborn.",
         "In the centre of each half, a shallow bowl. The life bowl is stained brown; the death bowl, grey.",
         "A whisper in your mind, many voices at once: \"Only by the blood of living life...",
         "\"...only by the stillness of death... shall the passage open.\""], event_id)
    return if !pbConfirmMessage(_INTL("Make an offering?"))
    life = pbMessage(_INTL("What do you give the wolf and moon?"),
                     [_INTL("A few drops of your own blood"), _INTL("A handful of snow"), _INTL("A coin")], -1)
    death_opts = []
    death_opts << [:bone, _INTL("Bone dust from the feast hall")] if flag?(:bone_dust)
    death_opts << [:snow, _INTL("A handful of snow")]
    death_opts << [:silence, _INTL("Stand in silence")]
    death_opts << [:coin, _INTL("A coin")]
    di = pbMessage(_INTL("What do you give the scythe and child?"), death_opts.map(&:last), -1)
    death = di >= 0 ? death_opts[di][0] : nil
    if life == 0 && [:bone, :silence].include?(death)
      say([herald?(:reptin) ? "You hold your bitten hand over the life bowl. The stone drinks the blood as if it were thirsty." :
                              "Reptin holds his bitten hand over the life bowl before you can. The stone drinks the blood as if it were thirsty."])
      say(death == :bone ? ["You tip the grey dust into the death bowl. It settles, and does not stir."] :
                           ["You stand before the death bowl and say nothing at all. The silence goes on, and the stone listens."])
      pbSEPlay("Earth3") rescue nil
      sayc(["The runes glow: red on the wolf's side, dull grey on the reaper's. The two halves grind apart.",
            "Stale, cold air rushes out, and for a moment you see something that isn't there:",
            "a robed dwarf woman performing this same rite, long ago, great wolves at her side.",
            "The vision fades. Off to one side of the passage, a hairline seam has opened in the ice wall.",
            cl(:reptin, "Wolves. Standing with her. Not chained."),
            cl(:alerion, "Noted.")])
      set_flag(:gate_open)
      $game_switches[SW_GATE_OPEN] = true if $game_switches
      add_counter(:story_beats)
    else
      say(["The offering lies in the bowl. Nothing happens. Then the skulls on the arch begin to clatter.",
           "Bones pull themselves out of the walls: the Order's dead guardians, come to drive you off!"])
      if boss_battle(named_mon(:MAROWAK, 30, "Guardian"), named_mon(:B105H312, 31, "Guardian"))
        say(["The guardians crumble back into the walls. The door stays shut.",
             "The whisper again, patient: \"Give life... give death...\""])
      end
    end
  end

  def hollow_wall(event_id = nil)
    if !flag?(:gate_open) && !flag?(:order_locket)
      return say(["You knock on the ice. It sounds hollow."], event_id)
    end
    say(["The ice here sounds hollow. " + (flag?(:order_locket) ? "The locket in your pocket grows warm." : "A hairline seam runs down it."),
         "You put your shoulder to it, and a sheet of ice falls away. Behind it, a narrow crevice."], event_id)
    transfer(MAPS[:sanctum], 6, 7, 8)
  end

  #-----------------------------------------------------------------------------
  # The last guardian
  #-----------------------------------------------------------------------------
  # SC 5.07 - The ghost with her face (Alberica's future self; never confirmed in Act I)
  def order_ghost(event_id = nil)
    return talk(:bier_after, event_id) if flag?(:ghost_blessing)
    me = herald?(:alberica)
    ghost = (event_id && $game_map ? $game_map.events[event_id] : nil) rescue nil
    (ghost.turn_toward_player rescue nil) if ghost
    Stage.overlay("O-03", opacity: 200, fade: 20)
    say(["The green-robed ghost is waiting. When she turns, she has Alberica's face, decades older.",
         me ? "(You have my face.)" : "ALBERICA: You have my face.",
         "GHOST: I borrowed it. I'll give it back when you're done."], event_id)
    if counter(:loop_count) > 0
      say(["GHOST: (quieter) You held her still. I know. I'm the one who held her.",
           "GHOST: Holding isn't keeping. Find the song."])
    end
    say(["GHOST: Listen, because I only get to say this once.",
         "GHOST: Under this chasm is a root. The last living root of the World Tree the Frostmaiden cut down.",
         "GHOST: The hag means to drain it and become winter herself.",
         me ? "(Why does that sound like something you already knew?)" : "ALBERICA: ...Why does that sound like something I already knew?"])
    say([herald?(:reptin) ? "GHOST: (to you) And you. Your wolf isn't a curse." :
                            "GHOST: (to Reptin) And you. Your wolf isn't a curse.",
         "GHOST: The wolves were the wardens of this place, once. It's a charge.",
         "GHOST: You can put it down, or you can carry it."])
    kneel = Stage.herald(:reptin, -1, 0, 8)
    Stage.pose(kneel, "P-REP-01", 3, per: 7) if kneel
    speak(:reptin, "I'll keep it. The wolf. The watch. All of it. Not because I can't put it down.",
                   "...I'll keep it.")
    sayc([as(:reptin, "Because somebody has to hold it."),
          "GHOST: (smiling) I know. I remember.",
          me ? "(Who are you?)" : "ALBERICA: Who are you?",
          "GHOST: Time is a wheel, dear. Go. She's started.",
          cl(:meat_meat, "Ghost lady is singing lady. Meat Meat says nothing. Meat Meat is very good at secrets.")])
    Stage.overlay_off("O-03", fade: 20)
    Stage.cleanup rescue nil
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    pbMessage(_INTL("A soft silver light settles over you and your Pokémon. (It will be there again when you need it most.)"))
    set_flag(:reptin_charge)
    set_flag(:ghost_blessing)
    $game_switches[SW_GHOST_REST] = true if $game_switches
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # The Heart of the Chasm
  #-----------------------------------------------------------------------------
  def scene_heart_enter
    say(["The passage climbs into a great cavern.",
         "On a dais in its centre, four spires of ice cradle an orb of blood-red ice.",
         "It pulses with a faint light, like a slow heartbeat. Veins of crimson and cobalt crackle through it.",
         "Between the pillars, a yeti cub hangs in black iron chains, gagged, white fur matted with tears.",
         "All around the cavern stand tall mirrors of frost-rimmed ice. In every one, a crone is smiling."])
  end

  # SC 5.08 - The Heart of the Chasm
  def thredra(event_id = nil)
    return if flag?(:reversal)
    if !flag?(:thredra_parley)
      set_flag(:thredra_parley)
      say(["Beside the Heart stands the hag, no longer hiding.",
           "At her right hand, a winter wolf: Kanan.",
           "At her left, an ice troll with crystal growing through its flesh.",
           "THREDRA: There you are. My little seamstress's samples.",
           "THREDRA: Do you know what this is? (the root, pulsing under the ice)",
           "THREDRA: The last living piece of the old World Tree.",
           cl(:shade, "She talks a lot for someone who's about to lose."),
           "THREDRA: It remembers every winter there ever was. Feed it a life, and it gives me all of them.",
           "THREDRA: Not her winter. Mine. I'll be the new Winter, dearies. Not so fickle as Auril.",
           "THREDRA: (a claw on the chained cub's head) A life for a life. This sweet one, I think."].compact)
      opts = [_INTL("\"Never.\""), herald?(:reptin) ? _INTL("Step forward yourself.") : _INTL("Let Reptin step forward.")]
      opts << _INTL("Hold up the golden acorn.") if flag?(:golden_acorn)
      c = pbMessage(_INTL("What do you do?"), opts, 0)
      case c
      when 1
        say([as(:reptin, "Take me instead."), "THREDRA: Oh, I'll take you all, wolf. In order."])
      when 2
        say(["THREDRA: (laughing) A seed? You'd feed a god a seed?"])
        set_flag(:offered_acorn)
      else
        sayc(["THREDRA: Then I'll take one of yours.",
              cl(:meat_meat, "(very quiet) Touch baby yeti and Meat Meat takes your face.")])
      end
    end
    if !flag?(:minions_down)
      say(["KANAN: Warm blood!", "The winter wolf and the ice troll lunge!"])
      lv = 0
      if flag?(:yeti_calmed)
        say(["Behind you, a roar. The mother yeti comes down the tunnel like an avalanche and slams into the troll."])
        lv = 3
      end
      return if !boss_battle(named_mon(:B272H310, 33, "Kanan"), named_mon(:B68H221, 33 - lv, "Ice troll"))
      say(["Kanan yelps and slinks behind a pillar. The troll crashes to the ice and lies there, steaming."])
      set_flag(:minions_down)
    end
    if !flag?(:thredra_beaten)
      say(["THREDRA: Useless, the both of them. Let's dance upon the glass, and see who shatters first."])
      return if !pbTrainerBattle(:FT_HAG, "Thredra", nil, false, 0)
      set_flag(:thredra_beaten)
    end
    thr = Stage.find("Thredra")
    Stage.pose(thr, "P-THR-02", 0, frames: [0, 1], per: 8) if thr
    say(["Her staff cracks across. The hag shrieks and leaps backward into the largest mirror."])
    Stage.pose(thr, "P-THR-02", 0, frames: [2, 3], per: 8) if thr
    say(["The glass takes her like water.",
         "THREDRA: Clever, clever! But I am the mirror, dearies. Break me, if you can bear to look!",
         "Out of the grand mirror steps her reflection, made of frost and spite."])
    if flag?(:ghost_blessing)
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      helper = begin
        Stage.actor(:green_ghost, $game_player.x + 1, $game_player.y, 4, graphic: "FT_green_ghost")
      rescue StandardError
        nil
      end
      helper.instance_variable_set(:@opacity, 180) if helper
      say(["For one moment, a dwarf woman in dark green robes stands at your side,",
           "silver light spilling from her hands."])
      Stage.hide(helper)
      say(["Then she's gone, and your Pokémon are on their feet again."])
    end
    return if !boss_battle(named_mon(:B124H255, 36, "Reflection"))
    scene_third_way
  ensure
    Stage.cleanup rescue nil
  end

  # SC 5.09 - The third way, again. Then SC 5.10 - Falling.
  def scene_third_way
    me_alb = herald?(:alberica)
    say(["Thredra's Reflection cracks. The last mirror.",
         "You're the one who breaks it.",
         "The Heart pulses hard. It's still hungry. The root under the ice opens like a mouth.",
         as(:reptin, "(stepping toward it) It wants a life.")])
    speak(:alberica, "No. Shimmer showed us. There's always a third way.", "...There's always a third way.")
    say([if flag?(:offered_acorn)
           me_alb ? "You take the golden acorn back from your own hand." : "Alberica takes the golden acorn from your hand."
         else
           me_alb ? "You take the golden acorn from Reptin's pack." : "Alberica takes the golden acorn from Reptin's pack."
         end,
         me_alb ? "(A life that hasn't started yet.)" : "ALBERICA: A life that hasn't started yet."].compact)
    alb = Stage.herald(:alberica, 0, -1, 8)
    Stage.pose(alb, "P-ALB-02", 3, per: 7) if alb
    say([me_alb ? "You press the acorn into the root." : "She presses the acorn into the root."])
    take_key(:FT_GOLDENACORN)
    pbSEPlay("Ice2") rescue nil
    # every mirror in the chasm cracks top to bottom and falls (E-06), all at once
    mirrors = ($game_map.events.values.select { |e| e.name =~ /\AMirror \d/ } rescue [])
    thr = Stage.find("Thredra")
    Stage.hide(thr)
    mirrors.each { |m| Stage.hide(m); Stage.fx("E-06", m, oy: 56, wait: false) }
    $game_screen.start_shake(4, 8, 20) rescue nil
    Stage.wait(10 * Stage.ticks) if !mirrors.empty?
    say(["Every mirror in the chasm shatters at once.",
         "Thredra screams, stretched across a thousand shards:",
         "laughing in one, weeping in another, silent in a third."])
    # the time flood (E-08): hourglass shards pour their light down into the root
    root_at = alb || $game_player
    Stage.fx("E-08", root_at, oy: 72, hold: true, wait: false) if root_at
    say(["Out of the shards pours everything she stole: hours, nights, whole winters, frozen moments.",
         "A flood of time, with nowhere to go but down into the root. Into the seed.",
         "The seed drinks it."])
    pbSEPlay("Saint7") rescue nil
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    green = Stage.actor(:egg_green, px - 1, py + 1, 2, graphic: "K-EGG-02")
    white = Stage.actor(:egg_white, px + 1, py + 1, 4, graphic: "K-EGG-02")
    if green || white
      Stage.pose(green, "K-EGG-02", 0, frames: [0], per: 1)
      Stage.pose(white, "K-EGG-02", 1, frames: [0], per: 8)
      (1..3).each do |f|
        Stage.pose(green, "K-EGG-02", 0, frames: [f], per: 4)
        Stage.pose(white, "K-EGG-02", 1, frames: [f], per: 6)
      end
    end
    say(["In Reptin's arms the Moon-Touched Egg cracks, and in Shade's the Frost Egg answers it.",
         "Two wyrmlings tumble out together."])
    Stage.panel("S-07")
    say([herald?(:meat_meat) ? "One is moss-green flecked with silver, gold-eyed. It grabs a fistful of your long white hair." :
                               "One is moss-green flecked with silver, gold-eyed. It grabs a fistful of Meat Meat's long white hair.",
         "The other is white as new frost, with wings like leaves of ice.",
         "She looks at Shade, tilts her head the way someone used to, and hums four notes.",
         "SHADE: (very quietly) ...Hi."])
    Stage.panel_off
    Stage.balloon(white, "B-05") if white
    say(["RAZZILITH: (no voice; a picture in all your heads, of flying) ...Fly?"])
    mm = Stage.herald(:meat_meat, -1, 0, 6)
    Stage.balloon(mm, "B-07", frames: 80) if mm
    speak(:meat_meat, "(sobbing and laughing) RAZZY. Meat Meat is not crying. That is sap. RAZZY.", "(very quietly) ...Razzy.")
    take_key(:FT_MOONEGG)
    take_key(:FT_FROSTEGG)
    set_flag(:razzy_hatched)
    set_flag(:razzilith_hatched)
    set_flag(:frostina_hatched)
    if flag?(:yeti_calmed)
      say(["The mother yeti breaks the cub's chains with her hands. The cub looks at you. Then it comes to you."])
    else
      say(["The cub's chains snap in the flood. It runs to its mother, limping in from the feast hall.",
           "Then it looks back at you."])
    end
    if pbConfirmMessage(_INTL("Take Yetot with you?"))
      cub = Pokemon.new(:YETOT, 25)
      cub.calc_stats
      set_flag(:got_yeti_cub) if pbAddPokemon(cub)
      set_flag(:got_yetot) if flag?(:got_yeti_cub)
    end
    set_flag(:cub_home)
    say([me_alb ? "Your hand is still on the root. Your eyes are full of light." :
                  "Alberica's hand is still on the root. She looks up, and her eyes are full of light.",
         me_alb ? "(I can see it. A sapling. A forest. A city. Four hundred years, all at once.)" :
                  "ALBERICA: I can see it. A sapling. A forest. A city. Four hundred years, all at once.",
         "THREDRA: (from every shard, fading) You think you've won? Mirrors remember, dearies.",
         "THREDRA: Mirrors always remember."])
    $game_screen.start_shake(6, 8, 30) rescue nil
    Stage.pose(alb, "P-ALB-03", 0, frames: [0, 1, 2], per: 6) if alb
    Stage.pose(mm, "P-MM-03", 0, frames: [0, 1, 2], per: 6) if mm
    Stage.overlay("O-06", fps: 5, fade: 0, wait: true)        # the screen cracks like a mirror
    say(["Time comes loose. The floor of the world tips. You all fall into the shards."])
    set_flag(:reversal)
    $game_switches[SW_REVERSAL] = true if $game_switches
    add_counter(:story_beats)
    scene_falling
  end

  # SC 5.10 - Falling (Act I epilogue)
  def scene_falling
    $game_screen.start_tone_change(Tone.new(120, 140, 80, 0), 30) rescue nil
    Stage.cleanup rescue nil
    Stage.overlay("O-07", scroll_y: 1, opacity: 220, above_panels: true, fade: 20)
    say(["You fall through moments."])
    Stage.panel("S-08a")
    say(["A sapling bursts from thawed soil above a frozen town."])
    Stage.panel("S-08b")
    say(["Moon-white Wennen drag a sledge to the sapling: a man frozen in a block of ice.",
         "They kneel among the roots, and stay. Settlers lay walkways between the roots."])
    Stage.panel("S-08c")
    say(["Two young dragons, one green and one white, circle a tree that pierces the aurora."])
    Stage.panel("S-08d")
    say(["A tavern-keeper carves heroes into living wood. Her chisel hesitates over a small sixth figure."])
    if journey?
      Stage.panel("S-08e")
      say(["A festival. A lantern. Your own face, looking in."])
    end
    Stage.panel_off
    say([as(:alerion, "(somewhere close, in the fall) Hold on to something."),
         cl(:alberica, "I'm holding on to you, pretty boy. Don't make it weird.")].compact)
    speak(:meat_meat, "Holding Razzy! Meat Meat is holding... Razzy? RAZZY!", "...Razzy?")
    say(["Both wyrmlings are pulled out of your arms, back toward the root.",
         "One picture comes from both of them, fading: Meat Meat's face, Shade's face, and the word WAIT."])
    Stage.overlay_off("O-07", fade: 30)
    Stage.cleanup rescue nil
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 40) rescue nil
    set_flag(:act1_done)
    loop_snapshot(:act1)
    begin
      pbMessage(_INTL("END OF ACT I: THE RIME"))
      save_prompt
    rescue StandardError => e
      log("Act I save prompt failed: #{e.message}")
    end
    transfer(*ARRIVAL_POINT)     # Act II: the Thaw (SC 6.01)
  end

  def save_prompt
    return if !pbConfirmMessage(_INTL("This is a good place to save. Would you like to save your game?"))
    pbSaveScreen
  end

  # A cub taken before the yetis had their own Pokémon was a Snorunt/Teddiursa fusion standing in for one.
  OLD_CUB = :B216H427

  def repair_yeti_cub
    return if !active? || !$Trainer || !flag?(:got_yeti_cub) || flag?(:cub_is_yetot)
    mons = $Trainer.party.dup
    if $PokemonStorage
      ($PokemonStorage.maxBoxes rescue 0).times do |b|
        ($PokemonStorage.maxPokemon(b) rescue 0).times { |i| mons << $PokemonStorage[b, i] }
      end
    end
    pk = mons.compact.find { |m| m.species == OLD_CUB }
    if pk
      lv = pk.level
      pk.species = lv >= 32 ? :YETITAN : :YETOT
      pk.level = lv if pk.level != lv
      pk.pif_sprite = nil if pk.respond_to?(:pif_sprite=)
      pk.calc_stats
      log("The yeti cub is now a #{pk.speciesName} (level #{lv}).")
    end
    set_flag(:cub_is_yetot)
  end

  def apply_chapter5_switches
    return if !active? || !$game_switches
    sync_switch(SW_ICEFALL, flag?(:mephits_done))
    sync_switch(SW_YETI_DOWN, flag?(:yeti_faced))
    sync_switch(SW_PIT_DONE, flag?(:pit_done))
    sync_switch(SW_GATE_OPEN, flag?(:gate_open))
    sync_switch(SW_GHOST_REST, flag?(:ghost_blessing))
    sync_switch(SW_REVERSAL, flag?(:reversal))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter5_switches
    FrostThaw.repair_yeti_cub
  rescue StandardError => err
    FrostThaw.log("Chapter 5 switches failed: #{err.message}")
  end
}
