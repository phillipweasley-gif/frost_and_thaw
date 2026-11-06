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
                       Cave: [[30, :GOLBAT, 29, 31], [20, :HAUNTER, 29, 31], [15, :SNORUNT, 29, 31],
                              [15, :DUSKULL, 29, 31], [15, :CUBONE, 29, 31], [5, :GLALIE, 29, 31]] }   # (balance: the bridge is the only way on)
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
    mother_yeti_after: [{ if: { flag: :yeti_mother_dead }, lines: ["She lies curled over her mate. She doesn't move."] },
                        { if: { flag: :cub_home, not_flag: :got_yeti_cub }, lines: ["The mother yeti lies curled round her cub. She opens one eye as you pass, then closes it."] },
                        { if: { flag: :got_yeti_cub }, lines: ["The mother yeti lies over her mate's body.", "She sees her cub in its ball at your belt, makes a low, soft sound, and lets you go."] },
                        { if: { flag: :yeti_avoided }, lines: ["The mother yeti stands guard over her mate. She growls, low, but she doesn't come at you."] },
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
    heart_mirror: ["A tall pane of frost-rimmed ice. In it, the crone smiles at you from behind your shoulder."]
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
    waste: ["I haven't slept. When I close my eyes there's a wolf in chains.",
            "And an old woman, telling it to let go. Lovely woman. Terrible advice."],
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
    heart: [{ if: { flag: :reversal }, lines: ["Time moved. I watched it.", "I prefer it this way round."] },
            ["Seven mirrors. Watch them, not her.", "She's always in the one you aren't looking at."]]
  )
  PARTY_CHAT[:shade].merge!(
    waste: ["Shimmer would've hated this place.", "Then she'd have gone in first."],
    chasm: ["That was a kid's voice. I know it wasn't a kid.", "Doesn't matter. My feet still wanted to go left."],
    rift: ["Don't look down. Don't look at the lights. Just walk."],
    sanctum: ["Ghosts. Of course there are ghosts.", "Is there one place in this Dale that isn't haunted? I'd pay to stay there."],
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
  # SC 5.01 - Full moon on the Laughing Waste. Two days on from Dougan's Hole,
  # the bite wakes under the full moon Thredra promised (context 05 M5-1).
  def scene_waste_start
    set_flag(:waste_started)
    add_counter(:story_beats)
    $game_screen.start_tone_change(Tone.new(-255, -255, -255, 0), 0) rescue nil
    say(["..."])
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 30) rescue nil
    say(["Two days south of Dougan's Hole, the land breaks into ice hills and black stone.",
         "Tonight the moon is full. The wind sounds like someone laughing."])
    wolf = Stage.herald(:reptin, 1, 0, 4)        # beside you, not on the warp row behind (notes 05 E28)
    me = herald?(:reptin)
    say([me ? "You stop walking. Your shoulders roll wrong." : "Reptin stops walking. His shoulders roll wrong."])
    Stage.pose(wolf, "P-REP-04", 0, frames: [0, 1, 2], per: 8) if wolf
    say(me ? ["For one breath you are a wolf, grey and enormous.", "Then you're on your knees in the snow."] :
             ["For one breath there's a wolf where he stood, grey and enormous.", "Then Reptin again, on his knees."])
    Stage.pose(wolf, "P-REP-04", 0, frames: [3], per: 4) if wolf
    say([me ? "(The bite. It's the bite.)" : "REPTIN: The bite. It's the bite."])
    # spoken, so the others can answer it (WRITING_GUIDE §5)
    speak(:reptin, "Last night I dreamed of a wolf in chains, on a ring of leaf and bone.", "...A wolf in chains. Again.")
    speak(:reptin, "And a crone: \"Abandon your bond, forsake your curse, and be free.\"", "...And a crone, telling it to let go.")
    sayc([cl(:alerion, "Then don't listen to her."),
          cl(:meat_meat, me ? "Bite woke up. Meat Meat said. Meat Meat will still sit next to you." :
                              "Bite woke up. Meat Meat said. Meat Meat will still sit next to him.")])
    speak(:reptin, "(standing) Sit wherever you like. I'm fine. Don't look at me.", "(standing) ...I'm fine.")
    sayc([cl(:alerion, "You're not fine.")])
    # the dream's other half: the crone's voice, and her offer (the module's "Reptin's Vision")
    speak(:reptin, "She had more to say. \"Poor boy... all that rage and pain inside you.\"", "...She had more to say.")
    speak(:reptin, "\"Give it to me. Let me take it away.\" (a breath) I woke up facing south.", "...I woke up facing south.")
    sayc([cl(:shade, "Facing south's fine. Walking south alone isn't."),
          cl(:alberica, "Nobody's taking anything out of you, sugar. Not without asking me first.")])
    if (state[:bargain_memory] || 0) > 0
      say([herald?(:reptin) ? "(Once, somewhere, you were cured. You remember the quiet. And what it cost.)" :
                              "REPTIN: (very quietly) ...I've been cured before. Somewhere. I remember what it cost."])
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
    set_flag(:chasm_entered); chasm_goal
    set_flag(:cackling_entered)
    sayc(["Jagged icicles hang from the cave mouth like fangs.", "A blast of frigid air rolls out, carrying the stench of decay.",
          "The chasm laughs. Not echoing: laughing, out of the rock itself."])
    # her illusion, on screen and see-through (notes 05 E2)
    crone = (Stage.actor(:thredra, $game_player.x, $game_player.y - 4, 2, graphic: "FT_thredra") rescue nil)
    crone.instance_variable_set(:@opacity, 120) if crone
    cackle
    say(["THREDRA: Come in, dearies... come in! Mind the cold, mind your step... Heehee!",
         "Deeper in the tunnel stands a hunched crone, stringy-haired, eyes like pale blue embers.",
         "She holds a lantern. She beckons with a gnarled hand.",
         "THREDRA: So good of you to visit an old woman in her home.",
         "THREDRA: I smell the wolf among you. Cold, child? Come warm yourself by Granny's fire.",
         "THREDRA: I asked for the wolf. Right this way. The cure for all your troubles lies ahead."])
    c = pbMessage(_INTL("The crone waits, smiling."), [_INTL("Go in."), _INTL("Watch her closely.")], 0)
    if c == 1
      say(["You watch her. She doesn't move right: too still, like a puppet waiting for its strings.",
           "Her voice comes a beat after her mouth. Her feet leave no prints in the frost.",
           "She isn't there. She's a picture of an old woman, thrown up the tunnel from much deeper in."])
      set_flag(:saw_through_illusion)
      sayc([cl(:alerion, "An illusion. She's showing us her face so we'll stop looking for the rest of her.")])
    end
    say(["THREDRA: This way... if you dare."])
    $game_screen.start_flash(Color.new(200, 230, 255, 120), 10) rescue nil
    Stage.hide(crone) if crone
    sayc(["She flickers and is gone with a parting giggle. The lantern stays, hanging from nothing.",
          cl(:reptin, "She's lovely. Really. Somebody remind me to never visit again."),
          cl(:shade, "Free lantern, though.")])
    Stage.cleanup rescue nil
  end

  def chasm_icefall(event_id = nil)
    return if flag?(:mephits_done)
    if !flag?(:icefall_fell)
      set_flag(:icefall_fell)
      pbSEPlay("Ice2") rescue nil
      say(["A crack, high overhead. Then the ceiling comes down: icicles and chunks of heavy ice!"])
      $game_screen.start_shake(5, 8, 16) rescue nil
      Stage.hop($game_player)
      hurt_party(0.2)
      say(["Your Pokémon throw themselves in front of you. The crash echoes away, deeper and deeper.",
           "(Your Pokémon are hurt.)",
           "Somewhere ahead, delighted, the crone: \"Oops! Mind your heads, dearies!\""])
    end
    sayc(["Out of the crevices swoop ice mephits: small imps of living ice, shrieking with laughter!",
          cl(:meat_meat, "Ice goblins. Not real goblins. Meat Meat checked.")])
    return if !boss_battle(named_mon(:SNORUNT, 28, "Ice mephit"), named_mon(:SNORUNT, 28, "Ice mephit"))
    sayc(["The last mephit cracks and bursts into a spray of shards. The tunnel goes quiet.",
          cl(:meat_meat, "Laughing ice. Meat Meat laughed last. Meat Meat wins.")])
    set_flag(:mephits_done)
    $game_switches[SW_ICEFALL] = true if $game_switches
    $game_map.need_refresh = true if $game_map      # the locket and the femur show now, not on the next refresh (context 05 M5-3)
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
    say(["When you close it, the silver is warm. Warmer than it should be.", "As if someone still watches over it."])
    give_key(:FT_ORDERLOCKET)
    set_flag(:order_locket)
    set_self_switch(event_id, "A")
  end

  def dead_yeti(event_id = nil)
    if flag?(:yeti_mother_dead)
      say(["The two yetis lie together at the centre of the hall now, her body curled over his.",
           "A whole family, destroyed. Except for one."], event_id)
    else
      say(["A white-furred yeti lies dead at the centre of the hall, chest torn open, ribs splayed.",
           "The flesh round the wound is charred black with frostbite: magic cold, not teeth.",
           "Its heart has been taken. Not bitten out. Cut.",
           "One great hand is clenched tight around something."], event_id)
    end
    if flag?(:yeti_faced) && !flag?(:found_swaddling)
      set_flag(:found_swaddling)
      sayc(["You work the frozen fingers open: soft white fur, tied with sinew. A baby's swaddling.",
            "Drag marks lead away into the far tunnel, a few days old, half frosted over.",
            "Booted footprints beside them.",
            as(:reptin, "They had a child. She took the child."),
            cl(:shade, "(very quiet) Then we take it back.")])
      give_key(:FT_SWADDLING)
    end
  end

  def yeti_notice(event_id = nil)
    return if flag?(:yeti_faced)
    mother_yeti(event_id)
  end

  # SC 5.04 - The feast hall
  def mother_yeti(event_id = nil)
    return talk(:mother_yeti_after, event_id) if flag?(:yeti_faced)
    mom = Stage.find("Mother yeti")
    Stage.pan_to(mom.x, mom.y + 2) if mom && !Stage.on_screen?(mom)
    say(["A low growl from the far end of the hall. Two pale eyes blink open behind a stalagmite."])
    Stage.walk(mom, [1, 1]) if mom
    Stage.cry(:YETITAN)
    Stage.emote(mom, :angry) if mom
    say(["With a roar, a massive yeti lunges into view: alive, and out of her mind.",
         "Her fur is matted with blood, burned and cut.",
         "One eye is clouded. Her howl is half fury, half agony.",
         "She plants herself over the dead male, roaring, and swings her head toward you."])
    say([herald?(:reptin) ? "She smells the wolf on you. Every bit of her fury swings your way." :
                            "She smells the wolf on Reptin. Every bit of her fury swings his way."])
    if with_or_is?(:reptin) && (pbResolveBitmap("Graphics/Characters/P-REP-05") rescue nil)
      Stage.pan_back
      wolf = Stage.herald(:reptin, 1, 0, 8)
      Stage.pose(wolf, "P-REP-05", 0, frames: [0, 1], per: 10) if wolf
      say([herald?(:reptin) ? "The wolf in you answers her. Your eyes flash amber; your teeth bare." :
                              "The wolf in Reptin answers her. His eyes flash amber; his teeth bare."])
      Stage.pose(wolf, "P-REP-05", 0, frames: [2], per: 8) if wolf
      say([herald?(:reptin) ? "(No.) You catch it, and hold it down." : "He catches it, and holds it down."])
      Stage.unpose(wolf) if wolf
    end
    say(["But there are tears frozen on her face. Under the roar, she's whimpering."])
    me = herald?(:alberica)
    opts = [me ? _INTL("Sing.") : _INTL("Ask Alberica to sing."), _INTL("Fight."), _INTL("Back away slowly.")]
    c = pbMessage(_INTL("What do you do?"), opts, 0)
    if c == 0
      say([me ? "You sing, plain, the way you spoke to Bryn Shander's square. No jokes. Not one." :
                "Alberica sings, plain, the way she spoke to Bryn Shander's square. No jokes. Not one."])
      if flag?(:stood_with_alberica)
        say(["The mother stops, shaking. She looks at her dead mate's hand, clenched round something."])
        Stage.face(mom, 8) if mom
        say(["Then she points, deeper into the chasm, to where her cub was taken."])
        Stage.pan_back
        set_flag(:yeti_calmed)
        set_flag(:yeti_faced); chasm_goal
        $game_switches[SW_YETI_DOWN] = true if $game_switches
        add_counter(:story_beats)
        yeti_after_echo
        return
      end
      say([me ? "The song catches. Nobody stood by you that night in the square. You can't find the note." :
                "The song catches. Nobody stood by her that night in the square. She can't find the note.",
           "The yeti roars over it and charges."])
    elsif c == 2
      say(["You back away, slow, hands open, eyes down. Nobody runs.",
           "She roars after you, and roars, and doesn't follow past her mate's body.",
           "You edge round the far wall of the hall, and she lets you go.", "She's guarding something that's already gone."])
      Stage.pan_back
      sayc([cl(:alberica, "(whispering) That poor thing."),
            cl(:reptin, "She'll be there when we come back with her baby. That's the deal. With myself.")])
      set_flag(:yeti_avoided)
      set_flag(:yeti_faced); chasm_goal
      $game_switches[SW_YETI_DOWN] = true if $game_switches
      add_counter(:story_beats)
      yeti_after_echo
      return
    end
    # She fights to the death: there's no reasoning with her now.
    Stage.pan_back
    return if !boss_battle(named_mon(:YETITAN, 31, "Yeti"))
    mom = Stage.find("Mother yeti")
    say(["She doesn't fall back. She doesn't run.", "When she can't stand any more, she drags herself to her mate."])
    if mom && (pbResolveBitmap("Graphics/Characters/K-YET-03") rescue nil)
      Stage.pan_to(mom.x, mom.y + 1) if !Stage.on_screen?(mom)
      Stage.walk_to(mom, 16, 21)                      # beside him (he lies at 16,22)
      Stage.pose(mom, "K-YET-03", 0, frames: [0, 1, 2, 3], per: 12)
    end
    say(["She lies down over him, curled round him, and a last whimper rattles out of her.",
         "Then she's still. The snarl goes out of her face.",
         "A whole family, destroyed. Except for one, somewhere ahead."])
    Stage.release(mom) if mom          # her page goes blank at the switch; "Her body" lies there now
    Stage.pan_back
    sayc([cl(:alberica, "(after a long moment) ...Give me a minute."),
          cl(:alerion, "Those burns were on her before we came. Somebody hurt her first."),
          cl(:meat_meat, "Meat Meat is sorry, fluffy mama. Meat Meat will find your baby. Meat Meat promises.")])
    set_flag(:yeti_fought)
    set_flag(:yeti_mother_dead)
    set_flag(:yeti_faced); chasm_goal
    $game_switches[SW_YETI_DOWN] = true if $game_switches
    $game_switches[SW_MOTHER_DEAD] = true if $game_switches
    $game_map.need_refresh = true if $game_map
    add_counter(:story_beats)
    yeti_after_echo
  end

  def bone_pile(event_id = nil)
    if flag?(:bone_dust)
      return say(["Gnawed bones, frozen into the floor. You've already taken what you need."], event_id)
    end
    say(["A pile of gnawed bones: goat, fox, gnoll. The oldest have crumbled to grey dust.",
         "On an impulse, you fold a pinch of the dust into a scrap of cloth and keep it."], event_id)
    give_key(:FT_BONEDUST)
    set_flag(:bone_dust)
  end

  def chasm_backpack(event_id = nil)
    say(["Beside a clawed skeleton, too long in the arm to be human: a tattered backpack.",
         "Inside: a healing draught, and a journal ruined with blood. A few lines are left:",
         "\"...met an old woman on the trail. Granny Thredra, she called herself.\"",
         "\"She knew things about me. She offered a deal.\"",
         "\"I don't trust her. But I'm desperate to save Alberica. Tomorrow, the chasm.\"",
         "\"The voices - children laughing? - echo at night. I must keep my wits.\"",
         "It's signed: Glimmer."], event_id)
    pbReceiveItem(:SUPERPOTION) rescue nil
    give_key(:FT_GLIMMERJOURNAL)
    set_flag(:thredra_named)
    set_flag(:read_glimmer_journal)
    speak(:alberica, "...To save Alberica. That's my name. Again. In a dead stranger's handwriting.", "...That's my name. Again.")
    sayc([cl(:shade, "Glimmer. Who'd call themselves Glimmer? Terrible name."),
          cl(:alberica, "I've never met a Glimmer in my life. I'd remember. I'd have written a song."),
          cl(:reptin, "Somebody who came down here hoping. Like us."),
          cl(:alerion, "Then we keep our wits. Like they didn't.")])
    set_self_switch(event_id, "A")
  end

  # SC 5.05 - The split path
  def scene_illusion_fork
    return if flag?(:seen_illusion_fork)       # it sits on a three-tile row: play it once, not per tile or per visit
    set_flag(:seen_illusion_fork); chasm_goal
    say(["The passage curves down into a corridor of ice, melted and frozen glassy as a mirror.",
         "Your reflections slide and warp along the walls beside you.",
         "One of them lingers a moment after you've moved on.",
         "It's grinning. Then it's only you again.",
         "Forty feet on, the tunnel forks. The silence breaks.",
         "From the left: a soft, quavering voice, and a lantern's glow going round a bend.",
         "From the right, black and rimed with frost: an old woman weeping in the dark.",
         "It rises, then hushes.",
         "CHILD'S VOICE: H-hello? Is someone there? Please... help me...",
         "CHILD'S VOICE: Shade? Shade, it's me. Shimmer. I'm lost. I'm so cold.",
         as(:shade, "(already moving) That's...")])
    speak(:alerion, "(grabbing their arm) Your sister's gone, Shade. And she was never that small.",
                    "(grabbing their arm) Shade. She was never that small.")
    illusion_fork_study
  end

  # The fork's clues, as many as you want to look at (each once).
  def illusion_fork_study
    left = [[:air, _INTL("Feel the air")], [:mirror, _INTL("Study the reflections")],
            [:listen, _INTL("Listen to the weeping")], [:ask, _INTL("Call out: \"Who are you?\"")]]
    loop do
      opts = left.map(&:last) + [_INTL("Choose a way")]
      c = pbMessage(_INTL("Your reflections wait for you to choose."), opts, opts.size)
      break if c.nil? || c < 0 || c >= left.size
      key = left.delete_at(c)[0]
      case key
      when :air
        say(["You hold up a wet finger. Colder air breathes from the right: somewhere big, and open.",
             "The air from the left is stale and still. Dead-end air."])
      when :mirror
        say(["You watch the lantern glow in the ice. The reflections don't line up with it.",
             "The light is wrong in every one of them, like someone painted it on afterwards."])
        # what you saw at the cave mouth, read back (notes 05 E33)
        say(["You've seen her trick before, at the cave mouth. A picture, thrown up the tunnel."]) if flag?(:saw_through_illusion)
        sayc([cl(:alerion, "The light's a lie.")])
      when :listen
        say(["You listen to the weeping on the right for a long minute.",
             "The same sobs, in the same order, the same catch in the same breath.",
             "Over, and over. A loop.",
             "Whoever she is, she isn't there either."])
        sayc([cl(:reptin, "So the weeping's a trick too. Then we pick the trick that goes somewhere.")])
      when :ask
        say(["CHILD'S VOICE: (sweet, wobbling) It's me... it's Shimmer... this way... hurry...",
             "CHILD'S VOICE: Please... it hurts... Mama...?",
             "Ask it anything else and it only cries louder, as if it knows no other words."])
        sayc([cl(:shade, "(very quiet) Shimmer never said please in her life.")])
      end
    end
    # how to choose: you walk it (notes 05 E21)
    false_light = Stage.find("False light")
    Stage.pan_to(false_light.x, false_light.y) if false_light
    say(["Left: the light, and the child's voice. Right: the dark, and the weeping.",
         "There's nothing more to learn standing here. You'll have to walk it."])
    Stage.pan_back
  end

  def pit_trap(event_id = nil)
    return if flag?(:pit_done)
    set_flag(:took_left)
    say(["You follow the light down the left passage. It dances just out of reach.",
         "The tunnel narrows. You duck under a curtain of icicles, into a small, closed hollow.",
         "The lantern light winks out. The sobbing stops. A foul stench fills the air: rotting meat.",
         "In the corner, a heap of bones and pelts.",
         "An old gnoll's nest. There's no child. This is a dead end.",
         "You turn to leave. Then the floor isn't there any more."])
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
    say(["(Your Pokémon are hurt.)"])
    return if !boss_battle(named_mon(:DUSKULL, 29, "Ghoul"), named_mon(:BANETTE, 30, "Ghoul"))
    say(["The ghouls collapse into rags and dust.",
         "Far above, the crone's laughter rolls through the caves:",
         "\"Poor little lambs... did you stumble? Heehee!\""])
    set_flag(:pit_done)
    $game_switches[SW_PIT_DONE] = true if $game_switches
    set_self_switch(event_id, "A")
  end

  def pit_pouch(event_id = nil)
    say(["The remains of earlier victims.", "A gnoll skeleton still clutching a crude iron dagger, rusted nearly through.",
         "On its belt, a pouch: fifteen gold, and a polished agate."], event_id)
    give_money(750, "You take the gnoll's fifteen gold.")
    give(:FT_GEMSTONE)
    say(["Beside it, a half-chewed body in leather armour. Its belt pouch holds a restoring draught,",
         "and a little scrimshaw carving of a smiling halfling. Somebody's lucky charm. It wasn't."])
    pbReceiveItem(:FULLHEAL) rescue nil
    sayc([cl(:alberica, "(turning the little halfling over) I'll keep this. Somebody should remember them.")])
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
    if !flag?(:took_left)
      say(["You take the dark way. Behind you, the child's voice goes high and desperate:",
           "CHILD'S VOICE: Don't leave me! Please! PLEASE!",
           "It follows you a long way. Then it doesn't."])
      sayc([cl(:shade, "(not looking back) Keep walking. Keep. Walking.")])
    end
    say(["The weeping ahead fades as you walk toward it, then stops dead, like a door shut on it.",
         "There's nobody there. There never was.",
         "Only the dark, and a colder wind coming up the tunnel.",
         "This is the true way. Fresh claw marks run along the walls, deeper in."])
    fork_after
  end

  # Either way out of the fork.
  def fork_after
    return if flag?(:fork_talked)
    set_flag(:fork_talked)
    say([cl(:shade, "She knew to use her name. What else does she know about us?"),
         cl(:meat_meat, "Hags know everything you're scared of. That is their whole job."),
         cl(:alberica, "(an arm round Shade, just for a moment) And it's a rotten job.")].compact)
  end

  #-----------------------------------------------------------------------------
  # The frozen rift and the Guardian's Gate
  #-----------------------------------------------------------------------------
  def scene_rift_arrive
    set_flag(:rift_arrived); chasm_goal
    sayc(["The passage ends at a ledge over nothing. A chasm cuts down so deep your light gives up.",
          "Across it runs a long, narrow bridge, slick with ice. Its old rope railing hangs frayed.",
          "The wind howls up out of the dark. The cackling is louder here, rising and fading.",
          "Jagged spurs of ice jut from the walls like the ribs of something enormous.",
          "Far below in the dark, faint lights flicker. Or your eyes are playing tricks.",
          "The wind dies for a moment. In the quiet: chanting, very faint, from the far side.",
          cl(:alberica, "Lovely. Who's first? Not me. I'm the morale."),
          cl(:alerion, "Me.")])
    choose_bridge_plan
  end

  def bridge_crack(event_id = nil)
    return if flag?(:bridge_cracked)
    set_flag(:bridge_cracked)
    ghost = begin
      d = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }[$game_player.direction] || [0, -1]
      Stage.actor(:green_ghost, $game_player.x + d[0] * 5, $game_player.y + d[1] * 5,
                  10 - $game_player.direction, graphic: "FT_green_ghost")
    rescue StandardError
      nil
    end
    ghost.instance_variable_set(:@opacity, 150) if ghost
    say(["Ahead on the bridge, a woman in dark green, faint as breath on glass. She points up.",
         "You look up. You throw yourself flat."])
    Stage.hide(ghost) if ghost
    Stage.cleanup rescue nil
    pbSEPlay("Ice2") rescue nil
    $game_screen.start_shake(4, 8, 12) rescue nil
    say(["CRACK! A chunk of ice breaks off the roof and shatters where you were standing.",
         "The whole span shudders. Pebbles skitter off the edge, and you never hear them land.",
         "The laughter on the wind rises, as if mocking you.",
         "Where the ice hit, new cracks run across the stone. The next stretch is going to be worse."])
  end

  def bridge_gust(event_id = nil)
    return if flag?(:bridge_gusted)
    set_flag(:bridge_gusted); chasm_goal
    say(["A gust tears up out of the abyss. You drop to your knees on the ice, gripping the stone."])
    ghost = begin
      d = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }[$game_player.direction] || [0, -1]
      Stage.actor(:green_ghost, $game_player.x + d[0] * 4, $game_player.y + d[1] * 4,
                  10 - $game_player.direction, graphic: "FT_green_ghost")
    rescue StandardError
      nil
    end
    ghost.instance_variable_set(:@opacity, 170) if ghost
    say(["The woman in dark green is there again, ahead. She points: keep going."])
    Stage.hide(ghost)
    say(["Then she's gone. The gust passes. You get up. You keep going."])
    Stage.cleanup rescue nil
  end

  def chasm_camp(event_id = nil)
    say(["A fissure breathes warm air up from far below. Out of the wind, it's almost cosy.",
         "You rest a while. The laughing sounds further away from here."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(CHASM_REST)
    if !flag?(:camp_disturbed)
      set_flag(:camp_disturbed)
      say(["Not that it's restful. Twice a scream drifts up out of the rift. Once, the cave rumbles.",
           "Beyond the far tunnel the chanting is clearer: a drone that comes up through the stone."])
      # (the banter plays once; later rests just heal, like the mead hall's)
      sayc([cl(:meat_meat, "Warm crack. Meat Meat could make coffee on this crack."),
            cl(:meat_meat, "Meat Meat has no coffee. Meat Meat will bite this crack. Fondly."),
            cl(:alberica, "Here, darling. Last of the Good Mead honey cake. Don't tell anyone."),
            cl(:shade, "Everyone's watching you hand it over."),
            cl(:alberica, "Then nobody tell anyone.")], event_id)
    end
  end

  def guardian_gate(event_id = nil)
    return if flag?(:gate_open)
    say(["A massive door of ancient granite, carved in two halves.",
         "On one, a great wolf curled round a full moon.",
         "On the other, a reaper's scythe cradling a newborn.",
         "In the centre of each half, a shallow bowl.",
         "The life bowl is stained brown; the death bowl, grey.",
         "A whisper, many voices at once: \"Only by the blood of the living...",
         "...and the stillness of the dead, shall the passage open.\""], event_id)
    return if !pbConfirmMessage(_INTL("Make an offering?"))
    life = pbMessage(_INTL("What do you give the wolf and moon?"),
                     [_INTL("A few drops of your own blood"), _INTL("A handful of snow"), _INTL("A coin")], -1)
    death_opts = []
    death_opts << [:bone, _INTL("Bone dust from the feast hall")] if flag?(:bone_dust)
    death_opts << [:snow, _INTL("A handful of snow")]
    death_opts << [:silence, _INTL("Stand in silence")]
    death_opts << [:coin, _INTL("A coin")]
    return say(["You step back from the bowls. The whisper waits, patient as stone."]) if life.nil? || life < 0
    di = pbMessage(_INTL("What do you give the scythe and child?"), death_opts.map(&:last), -1)
    return say(["You step back from the bowls. The whisper waits, patient as stone."]) if di.nil? || di < 0
    death = death_opts[di][0]
    if life == 0 && [:bone, :silence].include?(death)
      say([herald?(:reptin) ? "You hold your bitten hand over the life bowl." :
                              "Before you can move, Reptin holds his bitten hand over the life bowl.",
           "The stone drinks the blood as if it were thirsty."])
      take_key(:FT_BONEDUST) if death == :bone
      say(death == :bone ? ["You tip the grey dust into the death bowl. It settles, and does not stir."] :
                           ["You stand before the death bowl and say nothing at all. The stone listens."])
      pbSEPlay("Earth3") rescue nil
      sayc(["The runes glow red on the wolf's side, grey on the reaper's. The two halves grind apart.",
            "Stale, cold air rushes out, and for a moment you see something that isn't there:",
            "a robed dwarf woman performing this same rite, long ago, great wolves at her side.",
            "The vision fades.",
            "Off to one side of the passage, a hairline seam has opened in the ice wall.",
            cl(:reptin, "Wolves. Standing with her. Not chained."),
            cl(:alerion, "Noted.")])
      # her Chapter 4 hook, recognised; the ghost answers it (context 05 M5-5)
      if with_or_is?(:reptin) && flag?(:hag_bargain_offered)
        look = herald?(:reptin) ? "(looking at your hand)" : "(looking at his hand)"
        if flag?(:asked_hag_task)
          speak(:reptin, "#{look} \"A door only a wolf can open.\" She said that, at the Stones.",
                         "#{look} ...\"A door only a wolf can open.\"")
        else
          speak(:reptin, "#{look} \"Bring the wolf,\" she said. My blood opened that door.",
                         "#{look} ...\"Bring the wolf.\"")
        end
        sayc([cl(:alerion, "Then how is she on the other side?"),
              cl(:shade, "Same way she left the Stones. In pieces.")])
      end
      set_flag(:gate_open); chasm_goal
      $game_switches[SW_GATE_OPEN] = true if $game_switches
      add_counter(:story_beats)
    else
      say(["The offering lies in the bowl. Nothing happens. Then the skulls on the arch start to clatter."])
      if life != 0 || [:coin, :snow, nil].include?(death)
        pbSEPlay("Darkness") rescue nil
        say(["The door is insulted. A burst of grey, deathly cold rolls out of the stone, through you."])
        hurt_party(0.12)
        say(["(Your Pokémon are hurt.)"])
      end
      say(["Bones pull themselves out of the walls: the Order's dead guardians, come to drive you off!"])
      if boss_battle(named_mon(:MAROWAK, 30, "Guardian"), named_mon(:B105H312, 31, "Guardian"))
        say(["The guardians crumble back into the walls. The door stays shut.",
             "The whisper again, patient: \"Give life... give death...\""])
        if !flag?(:gate_hint)
          set_flag(:gate_hint)
          # (the druid knows the rite; the ranger reads the bowls: dialogue 05 §4)
          sayc([cl(:reptin, "Old rites. Life wants blood, warm. Death wants ash, or bone, or stillness."),
                cl(:alerion, "The bowls. Brown. Grey."),
                "(The stains are the answer, if you know how to read them.)"])
        end
      end
    end
  end

  def hollow_wall(event_id = nil)
    if !flag?(:gate_open)
      return say(["You knock on the ice. It sounds hollow.",
                  flag?(:order_locket) ? "The locket in your pocket grows warm, as if it knows this wall. The ice won't give. Not yet." : nil].compact, event_id)
    end
    say(["The ice here sounds hollow." + (flag?(:order_locket) ? " The locket in your pocket grows warm." : ""),
         "A hairline seam has opened down the ice.",
         "You put your shoulder to it, and a sheet of ice falls away. Behind it, a narrow crevice."], event_id)
    transfer(MAPS[:sanctum], 6, 7, 8)
  end

  #-----------------------------------------------------------------------------
  # The last guardian
  #-----------------------------------------------------------------------------
  # The Heart's door, before the ghost: Reptin won't go on until you've looked
  # in the seam (context 05 M5-8; WRITING_GUIDE §9a, people as gates).
  def heart_door_held(event_id = nil)
    set_flag(:heart_door_held)
    chasm_goal
    if with_or_is?(:reptin)
      rep = Stage.herald(:reptin, 0, 1, 8)
      Stage.turn_to($game_player, rep) if rep && !herald?(:reptin)
      sayc([herald?(:reptin) ? "You stop dead. (Wait. That seam in the ice, by the gate.)" :
                               "REPTIN: (stopping dead) Wait. That seam in the ice, by the gate.",
            as(:reptin, "Something in there knows my name. We look first.")])
    else
      say(["Something in the seam beside the gate is pulling at you. You look first."])
    end
    Stage.cleanup rescue nil
    Stage.walk($game_player, [1]) rescue nil         # one step back from the door
  end

  # The ghost's whereabouts while she waits for you at the bier (between her two beats).
  # She stands where P-GHO-01's last frame leaves her: just right of the bier.
  def ghost_actor(bier)
    g = ($game_map.events.values.find { |e| e.name == "stage_green_ghost" } rescue nil)
    return g if g
    g = (bier ? Stage.actor(:green_ghost, bier.x + 1, bier.y, 2, graphic: "FT_green_ghost") : nil) rescue nil
    g.instance_variable_set(:@opacity, 190) if g
    g
  end

  # The body on the bier (the tile is a bare slab): P-GHO-01's first frame, the
  # dwarf woman in green, laid out. Gone with the scene once she's dust.
  def bier_body(bier)
    b = ($game_map.events.values.find { |e| e.name == "stage_bier_body" } rescue nil)
    return b if b
    return nil if !bier || !(pbResolveBitmap("Graphics/Characters/P-GHO-01") rescue nil)
    b = (Stage.actor(:bier_body, bier.x, bier.y, 2, graphic: "P-GHO-01") rescue nil)
    Stage.pose(b, "P-GHO-01", 0, frames: [0], per: 1) if b
    b
  end

  # SC 5.07 - The ghost with her face (Alberica's future self; never confirmed in
  # Act I). The ghost IS Alberica (owner's decision 6, 2026-11-06): old, Keeper
  # of Time, she came back to keep the Order's post (the epilogue's coda), and
  # died here with the Order's last when the gnolls came. Her story hints at
  # the loop (she was here once, young, with friends) without naming her. On the path now (the Heart's door waits for her), and in two beats
  # with an action between (context 05 M5-8): one, the Heart, the wolves, the
  # hag's plan and Reptin's choice; then you take what she left on the bier;
  # two, the blessing, the tips, the rule and the prophecy.
  def order_ghost(event_id = nil)
    return talk(:bier_after, event_id) if flag?(:ghost_blessing)
    bier = (event_id && $game_map ? $game_map.events[event_id] : nil) rescue nil
    return order_ghost_blessing(bier) if flag?(:ghost_beat_one)
    me = herald?(:alberica)
    rep = herald?(:reptin)
    Stage.overlay("O-03", opacity: 200, fade: 20)
    say(["The air in here is still and reverent. Silver lichen on the ceiling gives a faint glow.",
         "On a stone bier lies a dwarf woman in dark green robes, kept whole by the cold.",
         "As you step closer, the air warms a few degrees. Your breath stops frosting."], event_id)
    body = bier_body(bier)
    say(["The corpse's eyes fly open, glowing a soft white."])
    Stage.walk($game_player, [13]) rescue nil         # one step back from the bier
    Stage.pose(body, "P-GHO-01", 0, frames: [1, 2, 3], per: 10) if body
    say(["A translucent spirit rises out of the body, as if lifted, and steps down onto the floor."])
    Stage.pose(body, "P-GHO-01", 0, frames: [0], per: 1) if body   # she's her own figure now
    ghost_actor(bier)
    say(["GHOST: Oh. You're early.",
         me ? "When she turns, she has your face, decades older." : "When she turns, she has Alberica's face, decades older.",
         me ? "(You have my face.)" : "ALBERICA: You have my face.",
         "GHOST: I borrowed it. I'll give it back when you're done.",
         "GHOST: I am the last guardian of the Order of Life and Death.",
         "GHOST: I came to it late, and old. I'd stood here once before. Young, with friends."])
    if counter(:loop_count) > 0
      say(["GHOST: (quieter) You held her still. I know. I'm the one who held her.",
           "GHOST: Holding isn't keeping. Find the song."])
    end
    if (state[:bargain_memory] || 0) > 0
      say(["GHOST: (very quietly) Once, you let the hag have the little one. I remember. Don't. Please."])
    end
    if flag?(:order_locket)
      say(["Her eyes go to the locket in your hand.",
           "GHOST: You found it. I dropped it the day the gnolls came. I wondered where it went."])
    end
    # the Order's history, and one name for the thing it kept
    say(["GHOST: The Order kept the balance here, between life and death. We kept the Heart.",
         me ? "(We?)" : "ALBERICA: (very quietly) ...We?",
         "GHOST: The Heart is a root. The last living root of a World Tree.",
         "GHOST: The Frostmaiden felled that tree long ago. This root is all of it that's left.",
         journey? ? "You think of Rootspire's roots, the ones you climbed as a kid. This one feels the same." :
         herald?(:wyn) ? "You think of Rootspire's roots, the ones you walk on watch. This one feels the same." : nil,
         cl(:reptin, "(quietly) I can feel it. Under the floor. Like a pulse."),
         "GHOST: It can drink life to stave off death. End a curse, or a winter. The cost is dire.",
         "GHOST: Then the gnolls came, who pray to a hyena-headed demon. They broke in, laughing.",
         cl(:shade, "(very quiet) The feast hall."),
         "GHOST: The last of the Order died there, old like me.",
         "GHOST: I sealed the doors, and gave myself to the wards."].compact)
    ghost_questions
    # the wolves, the charge, and the door she means
    say([rep ? "GHOST: (to you) And you. Child of the wolf." : "GHOST: (to Reptin) And you. Child of the wolf.",
         "GHOST: Wolves were the wardens here. The Children of the Wolf, bound by oath, long ago.",
         "GHOST: Their gift was long life and great strength. Its price was the moon.",
         cl(:reptin, "(very still) The bite."),
         "GHOST: It didn't find you by chance. It found the warden already in your blood.",
         "GHOST: The curse in your blood is no curse at all. It's a sacred charge."].compact)
    speak(:reptin, "A charge. It bit me in a ditch, starving.", "...A charge.")
    say(["GHOST: So did they. Every one.",
         "GHOST: Only a wolf bound by honour can stand watch over the Heart and not fall to it.",
         cl(:alerion, "And the hag knows it."),
         "GHOST: She came up the rift with her troll, where my wards are thinnest.",
         rep ? "GHOST: The gate was never the door she wanted, child. You are." :
               "GHOST: (to Reptin) The gate was never the door she wanted, child. You are.",
         "GHOST: Cut the wolf out of you, and the Heart has no warden. Then it's hers.",
         cl(:reptin, "(very quietly) And she offered to.")].compact)
    say(["GHOST: She means to drain the root and become winter herself.",
         me ? "(Why does that sound like something I already knew?)" : "ALBERICA: ...Why does that sound like something I already knew?",
         "GHOST: She'd end this winter, yes. Then she'd be a blight on life and death both.",
         "GHOST: The life she means to spend is a yeti cub. A baby. Stop her. Please.",
         cl(:meat_meat, "Nobody is killing baby yeti. Meat Meat has decided.")].compact)
    say([rep ? "GHOST: (gently, to you) Curing you cuts the bond. The chasm would lose its last warden." :
               "GHOST: (gently, to Reptin) Curing you cuts the bond. The chasm would lose its last warden.",
         "GHOST: I won't choose for you. Put it down, or carry it. It has to be your choice."])
    kneel = stand_in(:reptin, -1, 0, 8)
    if !rep
      c = pbMessage(_INTL("Reptin looks at you."), [_INTL("Nod to him."), _INTL("Wait. It's his to say.")], 1)
      say([c == 0 ? "Reptin nods back, once. He doesn't look away." :
                    "You don't say anything. He doesn't need you to. He needs you to stay."])
    end
    Stage.pose(kneel, "P-REP-01", 3, per: 7) if kneel
    speak(:reptin, "I'll keep it. The wolf. The watch. All of it. Not because I can't put it down.",
                   "...I'll keep it.")
    sayc([as(:reptin, "Because somebody has to hold it."),
          "GHOST: (smiling) I know. I remember.",
          "GHOST: We asked this of your forebears too. I'm sorry it's you.",
          "GHOST: (pointing to the bier) She left you something. Take it."])
    # the kneeling stand-in goes; the ghost waits by the bier for you
    if kneel
      Stage.unpose(kneel)
      Stage.remove_actor(kneel)
      $game_player.transparent = false if rep
    end
    set_flag(:ghost_beat_one)
    chasm_goal
  end

  # Beat two: what she left on the bier, her blessing, and her last words.
  def order_ghost_blessing(bier)
    me = herald?(:alberica)
    Stage.overlay("O-03", opacity: 200, fade: 20) if !Stage.overlay?("O-03")
    ghost = ghost_actor(bier)
    body = bier_body(bier)
    say(["Beside the body lies a silver dagger. You take it. The hilt is warm."])
    give(:FT_ORDERDAGGER)
    set_flag(:order_dagger)
    if !flag?(:order_locket)
      say(["Round the body's neck hangs a silver locket, half sun, half moon. You take that too."])
      give_key(:FT_ORDERLOCKET)
      set_flag(:order_locket)
    end
    say(["GHOST: The dagger was mine. Fey things hate silver. Hags are fey, and so is their glass.",
         "GHOST: Now the locket. Give it here a moment.",
         "She closes her ghostly hand over it, and it fills with a cold silver light.",
         "GHOST: It will shine true in the face of illusion, and keep the worst of the cold off you.",
         cl(:alberica, "(very quietly) It's warm. Like a hand.")].compact)
    set_flag(:locket_talisman)
    say(["GHOST: When you meet her: break her black staff. It focuses her power.",
         "GHOST: And the troll she keeps. Only flame can quell the ice-eater.",
         "GHOST: If the Heart drinks innocent blood, it wakes all the way. Then nothing stops it.",
         cl(:alerion, "And if it drinks nothing?"),
         "GHOST: It will drink. But a life freely given, or a life not yet begun, may satisfy it.",
         "GHOST: The Order needs wardens again. Children of the Wolf, and all who stand with them.",
         cl(:reptin, "(quietly) Wardens. Plural."),
         "GHOST: (half singing, an old tune) Wolf's howl and baby's cry, under the crone...",
         "GHOST: ...and round the wheel goes.",
         me ? "(Who are you?)" : "ALBERICA: Who are you?",
         "GHOST: (her light thinning) Time is a wheel, dear. Go. She's started."].compact)
    set_flag(:tip_staff)
    set_flag(:tip_flame)
    set_flag(:order_wardens)
    sayc([herald?(:meat_meat) ? "(That face. Meat Meat knows that face. Meat Meat says nothing.)" :
                                cl(:meat_meat, "(to you, very quietly) Meat Meat knows that face. Meat Meat says nothing.")])
    if body && (pbResolveBitmap("Graphics/Characters/P-GHO-02") rescue nil)
      Stage.walk_to(ghost, bier.x - 1, bier.y, face: 6) if ghost      # round to the head of the bier
      Stage.hide(ghost) if ghost
      Stage.pose(body, "P-GHO-02", 0, frames: [0, 1], per: 12)
      say(["She lies back down into the body on the bier, and the body closes its eyes."])
      Stage.pose(body, "P-GHO-02", 0, frames: [2, 3], per: 18)
      say(["Then it ages in a breath: skin to parchment, parchment to dust. The lichen light dims.",
           "Behind the bier, on a shelf in the rock, something in oilcloth catches the last light."])
    else
      Stage.hide(ghost) if ghost
      say(["She lies back down into the body on the bier, and the body closes its eyes.",
           "Then it ages in a breath: skin to parchment, parchment to dust. The lichen light dims.",
           "Behind the bier, on a shelf in the rock, something in oilcloth catches the last light."])
    end
    Stage.overlay_off("O-03", fade: 20)
    Stage.cleanup rescue nil
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    pbMessage(_INTL("A soft silver light settles over you and your Pokémon."))
    pbMessage(_INTL("(It will be there again when you need it most.)"))
    set_flag(:reptin_charge)
    set_flag(:ghost_blessing); chasm_goal
    $game_switches[SW_GHOST_REST] = true if $game_switches
    $game_map.need_refresh = true if $game_map
    add_counter(:story_beats)
  end

  # What you can ask the last guardian before she fades.
  def ghost_questions
    qs = [[:winter, _INTL("\"Would it end the winter?\"")]]
    qs << [:cure, herald?(:reptin) ? _INTL("\"She promised to cure me.\"") : _INTL("\"She promised to cure Reptin.\"")] if flag?(:hag_bargain_offered)
    qs << [:glimmer, _INTL("\"Who was Glimmer?\"")] if flag?(:read_glimmer_journal)
    qs << [:guilt, _INTL("\"We thought about letting her do it.\"")] if flag?(:hag_bargain_offered)
    loop do
      opts = qs.map(&:last) + [_INTL("\"Tell us how to stop her.\"")]
      c = pbMessage(_INTL("Ask the ghost..."), opts, opts.size)
      break if c.nil? || c < 0 || c >= qs.size
      key = qs.delete_at(c)[0]
      case key
      when :winter
        say(["GHOST: With that sacrifice? Yes. For a while. Maybe a long while.",
             "GHOST: But the price is soul-debt. Death unbalanced. Nature answers that with calamity.",
             "GHOST: Or the Heart darkens, and demands more. And more. It never stops at one."])
      when :cure
        say(["GHOST: (her face hardening) Of course she did. That's the hook in it.",
             herald?(:reptin) ? "GHOST: A cure for you is the warden gone. She wants the wolf out of the way, child." :
                                "GHOST: A cure for him is the warden gone. She wants the wolf out of the way, child.",
             "GHOST: Her cure is a ploy. It always was."])
      when :glimmer
        say(["GHOST: (a look at the journal) Someone who wanted very badly to save someone.",
             "GHOST: You'll see. Not yet."])
      when :guilt
        say(["GHOST: (gently) Of course you did. Winter for two years, and a friend with a wolf in him.",
             "GHOST: Anyone would think it."])
        sayc([cl(:reptin, "(very quietly) I thought it hardest.")])
        say(["GHOST: Thinking it isn't doing it, dear.",
             "GHOST: You came down here instead. That's the part that counts."])
        sayc([cl(:alberica, "(very quietly) She's right, you know.")])
        say(["GHOST: So choose the light now. And then keep choosing it. That's all any of us ever did."])
      end
    end
  end

  #-----------------------------------------------------------------------------
  # The Heart of the Chasm
  #-----------------------------------------------------------------------------
  # The Heart, seen: one object (the root of a World Tree, under red ice), the
  # cub, the mirrors (context 05 M5-2). The acorn comes out on the whisper row.
  def scene_heart_enter
    say(["The passage climbs into a great cavern. The ceiling is lost in shadow."])
    Stage.pan_to(12, 8)
    say(["On a dais, four spires of ice cradle an orb of blood-red ice. It beats, slow as a heart.",
         "Through the red ice, something dark and branching: a root, thick as a man. Alive.",
         "A yeti cub hangs in black chains between the pillars, gagged, white fur matted with tears.",
         "All round the cavern stand tall mirrors of ice. In every one, a crone is smiling."])
    Stage.pan_back
    set_flag(:heart_entered); chasm_goal
  end

  # SC 5.08 - The Heart of the Chasm
  def thredra(event_id = nil)
    return if flag?(:reversal) || flag?(:cub_sacrificed)
    if !flag?(:thredra_parley)
      set_flag(:thredra_parley)
      return chasm_dark_ending(:agreed) if thredra_parley == :agreed
    end
    if !flag?(:minions_down)
      Stage.pan_to(11, 9)
      say(["You take a step toward the dais.", "THREDRA: Don't take another step! Kanan! Troll! Supper!",
           "KANAN: Warm blood!", "The winter wolf and the ice troll lunge!"])
      lv = 0
      if flag?(:yeti_calmed)
        mom = (Stage.actor(:mother_yeti, $game_player.x, [$game_player.y + 3, $game_map.height - 2].min, 8,
                           graphic: "Followers/YETITAN") rescue nil)
        Stage.cry(:YETITAN)
        say(["Behind you, a roar. The mother yeti comes down the tunnel like an avalanche."])
        troll = Stage.find("Ice troll")
        Stage.walk_to(mom, troll.x, troll.y, adjacent: true) if mom && troll
        $game_screen.start_shake(5, 8, 12) rescue nil
        say(["She slams into the troll."])
        lv = 3
      end
      Stage.pan_back
      won = with_battle_script(:minions) do
        boss_battle(named_mon(:B272H310, 33, "Kanan"), named_mon(:B68H221, 33 - lv, "Ice troll"))
      end
      if !won
        state[:chasm_nightmare] = true
        chasm_loss_nightmare
        return
      end
      Stage.pan_to(11, 9)
      kanan = Stage.find("Kanan")
      say(["Kanan yelps and slinks behind a pillar, leaving a hank of white pelt on the ice."])
      Stage.leave(kanan, 6, 9) if kanan
      troll = Stage.find("Ice troll")
      $game_screen.start_shake(4, 8, 10) rescue nil
      Stage.face(troll, 8) if troll
      say(["The troll crashes down and lies there, steaming."])
      if flag?(:troll_burned)
        say(["(\"Only flame can quell the ice-eater.\" Where your fire caught it, the flesh stays torn.)"])
      else
        say(["The troll lies steaming. Already, its torn flesh is starting to knit."])
      end
      set_flag(:minions_down)
    end
    if !flag?(:thredra_beaten)
      Stage.pan_to(11, 9)
      say(["THREDRA: Useless, the both of them. We danced on the glass at the Stones, dearies. Again!"])
      Stage.pan_back
      won = thredra_battle
      if !won
        state[:chasm_nightmare] = true
        chasm_loss_nightmare
        return
      end
      set_flag(:thredra_beaten)
    end
    Stage.pan_to(11, 9)
    hag_lunge
    thr = Stage.find("Thredra")
    # the staff: if it's still whole, you break it (notes 05 E17; the ghost's "break her black staff")
    if !flag?(:broke_hag_staff)
      say(["Her black staff is still in her claw, crackling blue."])
      pbMessage(_INTL(flag?(:tip_staff) ? "\"Break her black staff.\"" : "The staff..."), [_INTL("Break it.")], 0)
      set_flag(:broke_hag_staff)
      say(["You wrench it out of her claw and bring it down across your knee.", "It cracks like a frozen lake."])
    end
    Stage.pose(thr, "P-THR-02", 0, frames: [0, 1], per: 8) if thr
    say(["Her broken staff falls in two pieces. The hag shrieks and leaps into the grand mirror."])
    Stage.unpose(thr) if thr
    Stage.walk_to(thr, 12, 11, face: 2) if thr
    Stage.hide(thr) if thr
    pbSEPlay("Ice2") rescue nil
    say(["The glass takes her like water."])
    refl = (Stage.actor(:thredra_reflection, 12, 12, 2, graphic: "FT_thredra_echo") rescue nil)
    say(["Out of the grand mirror steps her reflection, made of frost and spite.",
         "THREDRA: Clever, clever! But I am the mirror, dearies. And you're all inside it."])
    if flag?(:locket_talisman)
      say(["The locket burns silver. Her reflection is the only thing in the glass that's real.",
           "You don't take your eyes off it."])
    end
    Stage.pan_back
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
    won = boss_battle(named_mon(:B124H255, 36, "Reflection"), bgm: "BW2_Ghetsis Battle")
    if !won
      state[:chasm_nightmare] = true
      chasm_loss_nightmare
      return
    end
    Stage.pan_to(12, 10)
    scene_third_way(refl)
  ensure
    Stage.cleanup rescue nil
  end

  # The hag in full, her bargain called in, and your answer. Returns :agreed if
  # you let her have the cub.
  def thredra_parley
    rep = herald?(:reptin)
    alb_rune = herald?(:alberica) ? "your" : "Alberica's"
    # the hag in full, on camera (notes 05 E2); Kanan recognised (M5-6); her two
    # motives joined, Auril's seamstress and the new Winter (M5-7)
    Stage.pan_to(11, 8)
    say(["By the Heart stands the hag, bruise-coloured, white hair in a wind you can't feel.",
         "A black staff hung with frozen things. At her heel, Kanan. At her side, an ice troll."])
    if with_or_is?(:reptin)
      speak(:reptin, "(very quietly) Kanan. So this is where you ran.", "(very quietly) ...Kanan.")
      say(["KANAN: Granny feeds us better than the giant ever did."])
    end
    Stage.theme(THREDRA_THEME)
    cackle
    say(["THREDRA: Ssooo, my dearies, you made it after all! I was beginning to worry.",
         "THREDRA: And you fetched me my wolf. Good dearies.",
         "She gestures with her staff. The chains hoist the cub up off the floor, and it yelps.",
         "THREDRA: (the root beats under the red ice) Do you know what this is?",
         "THREDRA: The last living piece of the old World Tree.",
         "THREDRA: It remembers every winter there ever was. Feed it a life, and they're all mine.",
         "Under the red ice, the root beats faster.",
         "THREDRA: Not her winter. Mine. I'll be the new Winter, dearies. Not so fickle as Auril."])
    if with_or_is?(:alberica)
      speak(:alberica, "You said you were her seamstress.", "...Her seamstress.")
      say(["THREDRA: (a look at #{alb_rune} rune) And I've cut her a lovely coat. I'll hand it over.",
           "THREDRA: Once I'm wearing the winter myself."])
    end
    say(["THREDRA: (to you) And Granny's last glass sends the lost one home. Everybody wins."]) if outsider?
    say(["She points the staff at #{rep ? 'you' : 'Reptin'}. Magic pulses out of it."])
    # the player acts, even where it changes nothing (WRITING_GUIDE §3a): read back when the frost breaks
    grab = pbMessage(_INTL("She's going for #{rep ? 'you' : 'Reptin'}!"),
                     [rep ? _INTL("Brace.") : _INTL("Grab Reptin."), _INTL("Rush the hag.")], 0)
    state[:heart_grab] = grab == 1 ? :rush : :hold
    if grab == 1
      say(["You get two steps. Kanan's teeth snap an inch from your face, and you stop."])
    end
    held = Stage.herald(:reptin, -1, 0, 8) if (pbResolveBitmap("Graphics/Characters/P-REP-06") rescue nil)
    Stage.pose(held, "P-REP-06", 0, frames: [0, 1, 0, 1], per: 8) if held
    if rep
      say(["Something takes hold of the wolf in you and pulls, like a rope tied round your heart.",
           "For one long moment the wolf is coming out of you by the roots.",
           "Then she stops, and cackles.",
           "You can't move. Frost has you to the knees."])
    else
      say([grab == 0 ? "You get a fist in Reptin's collar. He doubles over anyway. Something is tearing at him." :
                       "Reptin doubles over. For one long moment, something is tearing the wolf out of him.",
           "Then she stops short, and cackles. Frost climbs his legs to the knee and holds him there."])
    end
    say(["THREDRA: Ah-ah! First, payment. A life for a life, was it not?",
         "THREDRA: This sweet babe's blood, to seal our pact.",
         "She lays a claw on the cub's head, lovingly. It shivers.",
         "THREDRA: One cut... and all your burdens are lifted.",
         "THREDRA: Eternal winter, gone. The werewolf's curse, gone.",
         "THREDRA: (her eyes sliding to #{rep ? 'you' : 'Reptin'}) I always keep my end of a bargain.",
         "The cub sobs behind its gag.",
         "THREDRA: Well, dearies... shall we shake on it? Or would you rather haggle?"])
    # the dealer answers the deal (dialogue 05 §5)
    if with_or_is?(:shade)
      speak(:shade, "We never shook on anything, Granny. I'd remember. I count my fingers after.", "...We never shook.")
      speak(:shade, "Name your price for the cub.", "...Name a price.")
      say(["THREDRA: Oh, it isn't for sale, dearie. It's the price."])
    end
    if (state[:bargain_memory] || 0) > 0
      say(["THREDRA: (purring) You were so sensible, last time round. Weren't you? Heehee."])
    end
    opts = [[:never, _INTL("\"Never.\"")],
            [:reptin, rep ? _INTL("\"Take me instead!\"") : _INTL("Let Reptin offer himself.")]]
    opts << [:acorn, _INTL("Hold up the golden acorn.")] if flag?(:golden_acorn)
    opts << [:agree, _INTL("\"...Do it.\"")]
    c = pbMessage(_INTL("What do you do?"), opts.map(&:last), 0)
    choice = (c && c >= 0 ? opts[c] : opts[0])[0]
    if choice == :agree
      if pbConfirmMessage(_INTL("Let her kill the cub? There is no taking this back."))
        say([cl(:alberica, "No. No, darling, you can't..."), cl(:reptin, "Don't. Don't do this for me.")].compact)
        Stage.pan_back
        return :agreed
      end
      choice = :never
    end
    case choice
    when :reptin
      say([as(:reptin, "(straining against the frost) Take me instead! If a life has to be given, take mine!"),
           "THREDRA: (scornful) Nonsense. I need innocent blood. None of you reek of innocence, dearies.",
           "THREDRA: Except maybe that one... (a long look at you) ...but no. I prefer the yeti."])
    when :acorn
      say(["THREDRA: (laughing) A seed? You'd feed a god a seed?"])
      set_flag(:offered_acorn)
    end
    sayc(["THREDRA: You'd keep the winter, and his curse, for one little monster? How precious.",
          "THREDRA: (sweetly) No? Then you can watch, dearies.",
          herald?(:shade) ? "She lunges for the cub out of spite. You're already moving. She snatches her claw back." :
                            "She lunges for the cub out of spite. Shade is already moving. She snatches her claw back.",
          cl(:meat_meat, "(very quiet) Touch baby yeti and Meat Meat takes your face.")])
    Stage.unpose(held) if held
    say(["The frost on #{rep ? 'your' : "Reptin's"} legs cracks and falls away."])
    if state[:heart_grab] == :hold && !rep
      say(["Your fist is still in Reptin's collar."])
      sayc([cl(:reptin, "You can let go now. ...Thank you.")])
    elsif state[:heart_grab] == :rush
      sayc([cl(:alerion, "You went for her alone. Don't.")])
    end
    Stage.pan_back
    nil
  end

  # SC 5.09 - The third way, again. Then SC 5.10 - Falling.
  def scene_third_way(refl = nil)
    me_alb = herald?(:alberica)
    if outsider?
      last_mirror_choice(refl)
    else
      Stage.hide(refl) if refl
      say(["Thredra's Reflection cracks. The last mirror.",
           flag?(:order_dagger) ? "You break it with the Order's silver dagger. Fey glass. It screams." :
                                  "You're the one who breaks it."])
    end
    Stage.pan_back
    pbBGMFade(1.0) rescue nil
    say([
         "The Heart pulses hard. It's still hungry. The root under the ice opens like a mouth.",
         as(:reptin, "(stepping toward it) It wants a life.")])
    speak(:alberica, "No. Shimmer showed us. There's always a third way.", "...There's always a third way.")
    say([if flag?(:offered_acorn)
           me_alb ? "You take the golden acorn back from your own hand." : "Alberica takes the golden acorn from your hand."
         else
           me_alb ? "You take the golden acorn from Reptin's pack." :
           herald?(:reptin) ? "Alberica takes the golden acorn from your pack." : "Alberica takes the golden acorn from Reptin's pack."
         end,
         me_alb ? "(A life that hasn't started yet.)" : "ALBERICA: A life that hasn't started yet."].compact)
    alb = Stage.herald(:alberica, 0, -1, 8)
    Stage.pose(alb, "P-ALB-02", 3, per: 7) if alb
    pbMessage(_INTL("The root opens under the ice."), [me_alb ? _INTL("Press the acorn in.") : _INTL("Help her press it in.")], 0)
    say([me_alb ? "You press the acorn into the root." : "You put your hand over hers, and together you press the acorn into the root."])
    take_key(:FT_GOLDENACORN)
    pbSEPlay("Ice2") rescue nil
    # every mirror in the chasm cracks top to bottom and falls (E-06), all at once
    mirrors = ($game_map.events.values.select { |e| e.name =~ /\AMirror \d/ } rescue [])
    thr = Stage.find("Thredra")
    Stage.hide(thr)
    mirrors.each { |m| Stage.hide(m); Stage.fx("E-06", m, oy: 56, wait: false) }
    Stage.hide(Stage.find("stage_thredra_shards"))
    $game_screen.start_shake(4, 8, 20) rescue nil
    Stage.wait(10 * Stage.ticks) if !mirrors.empty?
    say(["Every mirror in the chasm shatters at once.",
         "Thredra screams, stretched across a thousand shards:",
         "laughing in one, weeping in another, silent in a third."])
    # the time flood (E-08): hourglass shards pour their light down into the root
    root_at = alb || $game_player
    Stage.fx("E-08", root_at, oy: 72, hold: true, wait: false) if root_at
    say(["Out of the shards pours everything she stole: hours, nights, winters, frozen moments.",
         "The month she took from the fishers on the ice. The years she took from everyone before.",
         "A flood of time, with nowhere to go but down into the root. Into the seed.",
         "The seed drinks it."])
    pbSEPlay("Saint7") rescue nil
    # the eggs crack in the arms that carried them (notes 05 E24)
    rep_ev = stand_in(:reptin, -1, 0, 2)
    sh_ev = stand_in(:shade, 1, 0, 2)
    gx, gy = rep_ev ? [rep_ev.x, rep_ev.y + 1] : [$game_player.x - 1, $game_player.y + 1]
    wx, wy = sh_ev ? [sh_ev.x, sh_ev.y + 1] : [$game_player.x + 1, $game_player.y + 1]
    # (named for who hatches, so RAZZILITH's line finds its speaker)
    green = Stage.actor(:razzilith, gx, gy, 2, graphic: "K-EGG-02")
    white = Stage.actor(:frostina, wx, wy, 4, graphic: "K-EGG-02")
    if green || white
      Stage.pose(green, "K-EGG-02", 0, frames: [0], per: 1)
      Stage.pose(white, "K-EGG-02", 1, frames: [0], per: 8)
      (1..3).each do |f|
        Stage.pose(green, "K-EGG-02", 0, frames: [f], per: 4)
        Stage.pose(white, "K-EGG-02", 1, frames: [f], per: 6)
      end
    end
    say([herald?(:reptin) ? "In your arms the Moon-Touched Egg cracks, and in Shade's the Frost Egg answers it." :
         herald?(:shade) ? "In Reptin's arms the Moon-Touched Egg cracks, and in yours the Frost Egg answers it." :
                           "In Reptin's arms the Moon-Touched Egg cracks, and in Shade's the Frost Egg answers it."])
    sayc([cl(:reptin, "\"It needs time, and the world hasn't got enough.\" Well. Now it has."),
          "Two wyrmlings tumble out together."])
    Stage.panel("S-07")
    say([herald?(:meat_meat) ? "One is moss-green, flecked with silver. It grabs a fistful of your white hair." :
                               "One is moss-green, flecked with silver. It grabs a fistful of Meat Meat's white hair.",
         "The other is white as new frost, with wings like leaves of ice.",
         herald?(:shade) ? "She looks at you, tilts her head the way someone used to, and hums four notes." :
                           "She looks at Shade, tilts her head the way someone used to, and hums four notes.",
         as(:shade, "(very quietly) ...Hi.")])
    sayc([cl(:alerion, "(softly) Frostina.")])
    Stage.panel_off
    Stage.balloon(green, "B-05") if green
    say(["RAZZILITH: (no voice; a picture in all your heads, of flying) ...Fly?"])
    mm = stand_in(:meat_meat, -2, 0, 6)
    Stage.balloon(mm, "B-07", frames: 80) if mm
    speak(:meat_meat, "(sobbing and laughing) RAZZY. Meat Meat is not crying. That is sap. RAZZY.", "(very quietly) ...Razzy.")
    take_key(:FT_MOONEGG)
    take_key(:FT_FROSTEGG)
    set_flag(:razzy_hatched)
    set_flag(:razzilith_hatched)
    set_flag(:frostina_hatched)
    chasm_cub_and_aftermath
    say([me_alb ? "Your hand is still on the root. Your eyes are full of light." :
                  "Alberica's hand is still on the root. She looks up, and her eyes are full of light.",
         me_alb ? "(I can see it. A sapling. A forest. A city. Four hundred years, all at once.)" :
                  "ALBERICA: I can see it. A sapling. A forest. A city. Four hundred years, all at once.",
         "THREDRA: (from every shard, fading) You think you've won? Mirrors remember, dearies.",
         "THREDRA: Mirrors always remember."].tap { thredra_shards })
    $game_screen.start_shake(6, 8, 30) rescue nil
    Stage.hide(Stage.find("stage_thredra_shards")) rescue nil
    Stage.pose(alb, "P-ALB-03", 0, frames: [0, 1, 2], per: 6) if alb
    Stage.pose(mm, "P-MM-03", 0, frames: [0, 1, 2], per: 6) if mm
    Stage.overlay("O-06", fps: 5, fade: 0, wait: true)        # the screen cracks like a mirror
    sayc(["Time comes loose. The floor of the world tips. You all fall into the shards.",
          cl(:alberica, "(falling) The whole world just turned over.")])
    set_flag(:reversal)
    $game_switches[SW_REVERSAL] = true if $game_switches
    add_counter(:story_beats)
    scene_falling
  end

  # SC 5.10 - Falling (Act I epilogue): the Verdant Reversal, named, and the fall
  # forward in time to the player's home (context 05 M5-9). The glimpses come
  # first, so the fall only ever runs forward.
  def scene_falling
    $game_screen.start_tone_change(Tone.new(120, 140, 80, 0), 30) rescue nil
    Stage.cleanup rescue nil
    Stage.overlay("O-07", scroll_y: 1, opacity: 220, above_panels: true, fade: 20)
    Stage.theme(:heralds)                      # the Heralds' theme, in full, for the first time
    eyes = pbMessage(_INTL("You fall through moments."), [_INTL("Keep your eyes open."), _INTL("Shut them tight.")], 0)
    if eyes == 1
      set_flag(:fall_eyes_shut)
      say(["You squeeze your eyes shut. The light comes through anyway."])
    else
      chasm_falling_glimpses
    end
    Stage.panel("S-08a")
    say(["A sapling bursts from thawed soil above a frozen town."])
    Stage.panel("S-08b")
    say(["Moon-white Wennen drag a sledge to the sapling: a man frozen in a block of ice.",
         "They kneel among the roots, and stay. Settlers lay walkways between the roots."])
    Stage.panel("S-08c")
    say(["Two young dragons, one green and one white, circle a tree that pierces the aurora."])
    Stage.panel("S-08d")
    say([outsider? ? "A tavern-keeper carves heroes into living wood. Her chisel stops at a small sixth figure." :
                    "A tavern-keeper carves five heroes into living wood. One of them has your face.",
         "Under them she cuts the year it began: YEAR 0 OF THE VERDANT REVERSAL."])
    if outsider?
      say(["Deep in the roots, a digger holds a shard of glass up to her lamp. \"Hag's glass!\""])
      Stage.panel("S-08e")
      if herald?(:wyn)
        say(["A festival. A lantern at the Sap Gate. Your own face, looking in.",
             "Four hundred years, all at once. You know how this story ends. Every Rootwarden learns it."])
      else
        say(["A festival. A lantern. Your own face, looking in.",
             "Four hundred years, all at once. You know how this story ends. You fell asleep to it."])
      end
    end
    Stage.panel_off
    sayc([cl(:alerion, "(somewhere close, in the fall) Hold on to something.")])
    hold = herald?(:alberica) ? _INTL("Hold on to Alerion.") : _INTL("Hold on to Alberica.")
    c = pbMessage(_INTL("You're falling..."), [hold, _INTL("Reach for the wyrmlings.")], 0)
    if c == 1
      set_flag(:fall_reached_wyrmlings)
      say(["You catch a wing. It slips through your fingers like a tide going out."])
    else
      set_flag(:fall_held_on)
      sayc([cl(:alberica, "I'm holding on to you, pretty boy. Don't make it weird.")])
    end
    speak(:meat_meat, "Holding Razzy! Meat Meat is holding... Razzy? RAZZY!", "...Razzy?")
    say(["Both wyrmlings are pulled out of your arms, back toward the root.",
         herald?(:meat_meat) ? "One picture from both of them, fading: your face, Shade's face, and the word WAIT." :
         herald?(:shade) ? "One picture from both of them, fading: Meat Meat's face, your face, and the word WAIT." :
                           "One picture from both of them, fading: Meat Meat's face, Shade's face, and the word WAIT."])
    chasm_keepsakes
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

  # Her music in the Heart (a stand-in for her own theme: art/audio request).
  THREDRA_THEME = "Lavender_Town_Pokemon_Tower_Remix"

  # What's left of her: her echo in the grand mirror's glass, so her last
  # words come from something on screen.
  def thredra_shards
    ev = ($game_map.events.values.find { |e| e.name == "stage_thredra_shards" } rescue nil)
    if ev
      ev.transparent = false
    else
      ev = (Stage.actor(:thredra_shards, 12, 12, 2, graphic: "FT_thredra_echo") rescue nil)
      ev.instance_variable_set(:@opacity, 120) if ev
    end
    ev
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

  # The Chasm's Goal, one step at a time (review Ch5 E6: it never changed from
  # the Waste to the end of the act).
  def chasm_goal
    return if !flag?(:chasm_entered) || flag?(:reversal)
    state[:goal] =
      if flag?(:heart_entered)          then "The hag, at the Heart. The cub is in chains by the dais."
      elsif flag?(:ghost_blessing)      then "Stop the hag at the Heart. Break her staff; fire for the troll."
      elsif flag?(:ghost_beat_one)      then "Take what the ghost left you on the bier."
      elsif flag?(:heart_door_held)     then "Reptin won't go on yet. The seam in the ice beside the gate."
      elsif flag?(:gate_open)           then "On through the Guardian's Gate. A seam has opened in the ice beside it."
      elsif flag?(:bridge_gusted)       then "Open the Guardian's Gate: a gift of life, a gift of death."
      elsif flag?(:rift_arrived)        then "Cross the bridge over the rift."
      elsif flag?(:seen_illusion_fork)  then "The tunnel forks. Find the true way down."
      elsif flag?(:yeti_faced)          then "Find the yeti's cub. The drag marks go north, deeper in."
      else                                   "Down through the Cackling Chasm, to the hag's lair."
      end
  end

  def apply_chapter5_switches
    chasm_goal rescue nil
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

module FrostThaw
  module_function

  # The player's decision (owner's call, 2026-11-05): the last mirror is your way
  # home. Step through and leave them, or break it. Either way it breaks, and
  # the Reversal takes everyone; what you chose is remembered.
  def last_mirror_choice(refl = nil)
    wyn = herald?(:wyn)
    Stage.hide(refl) if refl
    thredra_shards
    say(["Thredra's Reflection cracks. One mirror is left standing.",
         "The #{my_glass} in your pocket answers it, one clear note.",
         wyn ? "In it: the Sap Gate, gold with festival lanterns. Your post. Your lamp, still lit." :
               "In it: Rootspire's market, gold with festival lanterns. Hellen's door.",
         wyn ? "Your Sableye's reflection sits in the roots at the gate, waiting for you." :
               "Tamsin, in the doorway, holding a cracked lantern.",
         "THREDRA: (from a thousand shards) Go on, lost one. Step through. Leave them to Granny.",
         "THREDRA: Home by supper."])
    c = pbMessage(_INTL("The last mirror..."), [_INTL("Step through."), _INTL("Break it.")], 1)
    if c == 0
      set_flag(:tried_to_leave)
      say(["You put your hand to the glass. It's warm. It gives, like water.",
           "Behind you, the cub cries out once in its chains.",
           wyn ? "In the mirror, Sableye's reflection grins at you with someone else's teeth." :
                 "In the mirror, Tamsin turns to look at you, and smiles with someone else's teeth."])
      sayc([cl(:alberica, "(catching your wrist) Not like that, darling. Not through her door."),
            "The glass cracks under both your hands."])
    else
      set_flag(:broke_last_mirror)
      say([wyn ? "You don't look at it for long. Home, the gate, your lamp." : "You don't look at it for long. Home, warm, a saved seat.",
           flag?(:order_dagger) ? "You draw the Order's silver dagger. The glass screams before the blade touches it." :
                                  "You break it.",
           flag?(:order_dagger) ? "Fey glass, the ghost said. It breaks like ice on a pond." : nil].compact)
    end
  end
end
