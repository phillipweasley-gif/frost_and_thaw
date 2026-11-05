#===============================================================================
# Frost & Thaw - Act II, Chapter 7, Road B: the Forge Road (script SC 7B.01-7B.08)
#
# Follow the missing diggers and the heat down through the city's own works, to
# the forge door. Gyms 5 and 6 are on this road; like Gym 7 on Road A, their
# teams scale with your badge count (032_Chapter7A.rb).
#
#   7B.01 Twelve diggers: Hew takes you down his ladder into the Guild Dig;
#         Gant and Hobb, sap-dazed; the Halo's saboteurs at the sap caches;
#         Prototype 3 praying to "Father".
#   7B.02 Gym 5: Master Hew Talmire (Steel/Ground), the Guild Seal; his
#         confession (ten years of sap sold to Summer's people).
#   7B.03 The child in the mirror, in the Overflow Channel: the Mirror Echo.
#   7B.04 Gym 6: Mira of the North Wind, aboard the Boreal Requiem at the Split
#         Dock. A mirror-core in the hold first; then Mira, herself again.
#   7B.05 The aurora seal at the Root Gate (025_Chapter7.rb).
#   7B.06 Three wells (visions, their backlash, and a second Vault Map
#         fragment), and the attendant's answers, for a promise: burn the
#         forge, or free the heart.
#   7B.07 Selrae, below: the White Womb; home, or ahead. The Root-Key.
#   7B.07+ The Root-Key opens the heart-wall: the Labyrinth's lower zones,
#         down to Avarice's Scriptory and its glass sigil (046_DeepLabyrinth.rb).
#   7B.08 The door of iron and glass at the bottom of Hew's last ladder: the
#         Root-Key for the iron, the glass sigil for the glass.
#
# The Heartroot's maps join up the way they did before (the well in the market
# and Hew's ladder both lead down), so the beats can come in more than one
# order; none of them needs another except Mira (the child first) and the door
# (the Root-Key).
#===============================================================================
module FrostThaw
  SW_HEW_DOWN   = 3972   # Hew has gone down his ladder with you: he waits in the dig
  SW_CHILD_FREE = 3973   # the child is out of the mirror
  SW_MIRA_FREED = 3974   # Mira is herself again (she and her daughter on the pier)

  GUILD_LADDER_FOOT = [2066, 5, 5, 2]

  TRAINER_TYPES.merge!(
    FT_GUILDMASTER: ["Guild Master", :WORKER, 0, 140, :LEADER_Brock],
    FT_CORSAIR_CAPT: ["Corsair Captain", :SAILOR, 1, 140, :LEADER_Brock]
  )
  TRAINERS.merge!(
    guild_worker_pell: [:FT_GUILD, "Teodric", [[:B76H95, 41], [:B208H75, 42]], "Forty years down here and I never saw the tree bleed till this week."],
    guild_worker_rusk: [:FT_GUILD, "Rusk", [[:MAGNETON, 41], [:B205H232, 42]], "Go on. He's waiting. He's been waiting for somebody to stop him."],
    hew:  [:FT_GUILDMASTER, "Hew", [[:B208H76, 42], [:B95H205, 42], [:B232H82, 43], [:B76H208, 44]],
           "Guild Seal. And here's the truth.", [:HYPERPOTION, :FULLRESTORE]],
    mira: [:FT_CORSAIR_CAPT, "Mira", [[:B80H121, 42], [:B131H199, 43], [:B121H80, 43], [:B130H196, 44]],
           "Tide Seal. And the Requiem is yours.", [:HYPERPOTION, :FULLRESTORE]]
  )
  TRAINER_INTROS.merge!(
    guild_worker_pell: "TEODRIC: Guild Annex. Masters only past here. Today that means whoever beats me.",
    guild_worker_rusk: "RUSK: Hew said you'd come through. Hew says a lot of things this week.",
    hew: "HEW: Ladder's earned, not given.",
    mira: "MIRA: Properly, now. One voice."
  )
  SCALED_EXTRA.merge!(hew: [:B111H208, 42], mira: [:B73H199, 42], luminara: [:B47H286, 42])

  TEXT.merge!(
    guild_worker_pell_after: ["The Annex is where we tested the amber fuel. It whispered at the test-burns. We kept testing."],
    guild_worker_rusk_after: ["Gant's my cousin. Thanks for bringing him round."],
    corsair_gangplank: -> {
      if flag?(:mira_freed)
        ["CORSAIR: Captain's herself again. One voice. We'd sail you to the edge of the world.",
         "CORSAIR: Mind you, the edge of the world is about there."]
      elsif flag?(:mirror_child_free)
        ["CORSAIR: Is that... the little one's ribbon? Where did you... Get aboard. Quick.",
         "CORSAIR: The Captain's at the wheel."]
      else
        ["CORSAIR: The Boreal Requiem. Captain Mira's not seeing anyone.", "CORSAIR: Not since her little one went missing.",
         "CORSAIR: She talks to the mirrors now. Says \"we\". Nobody likes it."]
      end
    },
    mira_after: ["MIRA: Thirty years of something in my mirrors.", "MIRA: I'll be smashing every one I own. Slowly. With joy.",
                 "MIRA: The Requiem is yours if you ever need a ship. I don't care where."],
    mira_daughter: ["MIRA'S DAUGHTER: I don't look in mirrors any more. I look at puddles. Puddles are honest."],
    dig_roots_shut: ["Where the dig broke into the Heartroot, the roots have braided shut again, tight as a fist.",
                     "(From the other side, through the Root Gate, they might open.)", "(The well in the market goes down to it.)"],
    heart_wall: ["The roots here are knotted tight as a fist. Behind them something beats, slow and enormous.",
                 "Warm air comes through the gaps, and with it, very faint, the smell of forge smoke.",
                 "(The way down isn't here. Hew's tunnels go deeper, though.)"]
  )

  module_function

  #-----------------------------------------------------------------------------
  # SC 7B.01 - Twelve diggers
  #-----------------------------------------------------------------------------
  # Hew in the market, by his ladder.
  def hew(event_id = nil)
    return talk(:hew_talmire, event_id) if !flag?(:ch7_started)
    if flag?(:hew_down)
      say(["The Guild's ladder goes down into the dark. Hew's down there already, with a lamp."], event_id)
    else
      sayc(["HEW: You're going down? Then you're going down MY ladder.",
            "HEW: Twelve of mine went down that dig. I'm not sending anybody else alone.",
            cl(:meat_meat, "Ladder man is loud. Meat Meat likes ladder man.")], event_id)
    end
    return if !pbConfirmMessage(_INTL("Climb down the Guild's ladder?"))
    set_flag(:hew_down)
    set_flag(:guild_ladder_down)
    ($game_switches[SW_HEW_DOWN] = true; $game_switches[SW_GUILD_LADDER] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    transfer(*GUILD_LADDER_FOOT)
  end

  def scene_guild_dig_enter
    return if flag?(:guild_dig_entered)
    set_flag(:guild_dig_entered)
    sayc(["The tunnels are hot. Sap runs warm in the walls and drips like sweat.",
          "Somewhere ahead, a pick is still swinging. Slowly. Like someone sleepwalking.",
          flag?(:hew_down) ? "HEW: That's how they all went. Walked down, smiling." :
                             cl(:reptin, "They cut into the tree. Not around it. Into it. It's bleeding."),
          cl(:alberica, "Hot, dark, sweaty tunnels. I've had worse nights out."),
          cl(:reptin, "We know, darling. You told us."),
          cl(:alerion, "Twice.")])
    state[:goal] = "Find Hew's diggers. Stop whoever's at the sap caches."
  end

  def digger(key, event_id = nil)
    return say(lines_for(:"#{key}_after"), event_id) if flag?(:"beat_#{key}")
    if key == :digger_gant
      say(["GANT: (sap-dazed, smiling) Warm. So warm. Down's where the warm is. Down, down."], event_id)
    end
    return if !trainer(key, event_id)
    set_flag(:"beat_#{key}")
    sayc(["The sap-daze clears from the digger's eyes all at once. They sit down, hard.",
          "DIGGER: Where... We were digging, and the amber started talking.",
          "DIGGER: The others kept going. Down. I don't know where.",
          cl(:wyn, "(holding out a biscuit) Here. You've been working a long time. Eat something.")])
    set_flag(:diggers_found) if flag?(:beat_digger_gant) && flag?(:beat_digger_hobb)
  end

  def sap_cache(n, event_id = nil)
    key = n == 1 ? :halo_tarn : :halo_odile
    if flag?(:"cache_#{n}_safe")
      return say(["The sap cache is cold and dark, its fuses cut. The amber inside mutters to itself."], event_id)
    end
    sayc(["A Guild sap cache: amber fuel bricks stacked to the ceiling.",
          "A fuse of oiled cord runs into it. The cord is smoking.",
          "A figure in grey Halo robes crouches over it with a flint.",
          cl(:reptin, "Fuse. Now.")], event_id)
    return if !trainer(key, event_id)
    set_flag(:"cache_#{n}_safe")
    say(["You stamp out the fuse."])
    if n == 2
      say(["ODILE: (beaten) We only wanted to cool it.",
           "ODILE: Summer said a little fire here and the tree would sleep. And winter would come."])
    end
    say(["The saboteur scrambles away up the tunnel."])
    if flag?(:cache_1_safe) && flag?(:cache_2_safe)
      sayc([cl(:alerion, "Fire to make winter. Summer's promises don't add up."),
            cl(:alerion, "Somebody's banking on that."),
            cl(:meat_meat, "Ice Prince did maths. Meat Meat is proud."),
            flag?(:hew_down) ? "HEW: (from the west tunnels) Caches safe? Then come and see me in the Annex." : nil,
            flag?(:hew_down) ? "HEW: We need to talk. Properly." : nil])
      state[:goal] = "Hew, in the Guild Annex by the ladder."
    end
  end

  def father_construct(event_id = nil)
    if flag?(:construct_kept) || flag?(:construct_stopped)
      return say([flag?(:construct_kept) ? "The construct kneels at the root, praying softly. \"Father, you are cooler today.\"" :
                                           "The construct sits still and dark, its lamp-eyes out. Moss has already started on its shoulders."], event_id)
    end
    sayc(["A small sap-powered construct kneels at a root, hands pressed together.",
          "PROTOTYPE 3: Father. Father, you are hot. Father, I am afraid for you.",
          flag?(:hew_down) ? "HEW: (embarrassed) It calls the tree that. I didn't teach it that." : "Stamped on its back: GUILD OF ROOTS AND STONE, PROTOTYPE 3.",
          cl(:meat_meat, "...It is scared for its father. Meat Meat would be too."),
          cl(:wyn, "(kneeling beside it) He can hear you. Trees always can.")], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Let it keep praying"), _INTL("Shut it down")], 0)
    if c == 1
      set_flag(:construct_stopped)
      say(["You find the switch behind its neck. It lets you.",
           "The lamp-eyes dim last of all, still turned toward the root.",
           "In its clay hand: something it found in the roots, and was keeping for its father."])
      give(:METALCOAT)
    else
      set_flag(:construct_kept)
      say(["You leave it praying.", "As you turn away, it holds something out without looking: a stone from the roots, shining.",
           "PROTOTYPE 3: For the visitors. Father would want."])
      give(:SHINYSTONE)
    end
  end

  #-----------------------------------------------------------------------------
  # SC 7B.02 - Gym 5: Master Hew Talmire
  #-----------------------------------------------------------------------------
  def leader_hew(event_id = nil)
    if flag?(:badge_hew)
      return say(["HEW: My last ladder's past the south cache.",
                  "HEW: There's a door at the bottom I was told never to open. By Summer's people. Of course I was."], event_id)
    end
    if !flag?(:cache_1_safe) || !flag?(:cache_2_safe)
      return say(["HEW: Caches first! If those go up, there's no Guild left to have a gym.",
                  "HEW: North tunnel and south tunnel. Go!"], event_id)
    end
    sayc(["HEW: I've dug sap out of this tree for forty years. Somebody's been digging deeper.",
          "HEW: Let's see if you're worth my ladder.",
          cl(:alberica, "Forty years with one tree. Now that's devotion.")], event_id)
    return if !scaled_leader_battle(:hew)
    $Trainer.badges[4] = true
    set_flag(:badge_hew)
    set_flag(:hew_confessed)
    add_counter(:story_beats)
    say(["HEW: Guild Seal."])
    pbMessage(_INTL("\\me[Badge get]{1} received the Guild Seal!", $Trainer.name))
    give(:TM80)
    sayc(["HEW: Rock Slide. Mind your heads.",
          "HEW: And here's the truth. Ten years I've sold sap to Summer's people.",
          "HEW: Liquid sunlight, they called it. I never asked what for.",
          cl(:reptin, "(quietly) Thank you for telling us. That can't have been easy."),
          "HEW: I'll say it again at any trial you like. I'll say it to the tree.",
          "HEW: My last ladder runs past the south cache, to a door I was told never to open.",
          "HEW: Iron and glass. Summer's people again."])
    # Hew's gift (rootspire.md 1174): mechanical assistance, and, though he
    # doesn't know it, a dormant fragment of Avarice's code in the works.
    sayc(["HEW: Here. You'll want this down there. Built it from Prototype 3's spare parts, the batch Summer's people paid for.",
          "HEW: Root-compass. Points at the warmest thing below you. Ticks a bit. Ignore the ticking.",
          cl(:alberica, "Darling, I never ignore ticking."),
          cl(:meat_meat, "(holding it to her ear) It is ticking in a pattern. Meat Meat does not like the pattern.")])
    give_key(:FT_ROOTCOMPASS)
    set_flag(:hew_gift)
    if flag?(:beat_digger_gant) && flag?(:beat_digger_hobb) && !flag?(:hew_thanked)
      set_flag(:hew_thanked)
      say(["HEW: And Gant. And Hobb. You brought two of them back to me.",
           "HEW: Take the Guild's dig money. Take the light. Take anything."])
      $Trainer.money += 6000 rescue nil
      pbMessage(_INTL("\\me[Item get]{1} received $6,000 from the Guild!", $Trainer.name)) rescue nil
      give(:FT_AURORALMOTE, 2)
    end
    state[:goal] = flag?(:root_key) ? "The door of iron and glass, at the bottom of Hew's last ladder." :
                   "The door at the bottom of Hew's ladder is locked. Someone below has a key: the Root Gate, the Sap Wells."
  end

  #-----------------------------------------------------------------------------
  # SC 7B.03 - The child in the mirror
  #-----------------------------------------------------------------------------
  def twin_mirror(event_id = nil)
    if flag?(:mirror_child_free)
      return say(["Shards of frost-glass glitter in the hardened sap, dull and ordinary now."], event_id)
    end
    sayc(["On the far ledge stands a tall mirror.",
          "A girl is pressed against the glass from the inside, half of her through on this side.",
          "MIRROR CHILD: It pulled me. Mama's mirror. I was looking at my hair, and it pulled."], event_id)
    mirror = stage_event(event_id)
    mx, my = stage_spot(mirror)
    # Quest M2 is Meat Meat's (rootspire.md 8323): she carries the boy's mirror down.
    if !with_or_is?(:meat_meat)
      return say(["The glass is cold and flat as ice under your hand. It won't break. It's waiting for something.",
                  "(Meat Meat should be here. This one is hers.)"])
    end
    if !flag?(:mirror_sentinel_down)
      say(["Between you and the ledge, the slick sap heaves. A shape climbs out of it: a suit of armour made of mirror-glass, empty inside, its visor full of frost.",
           "It turns to face Meat Meat, and only Meat Meat."])
      return if !boss_battle(named_mon(:B208H227, 44, "Mirror Sentinel"))
      set_flag(:mirror_sentinel_down)
      say(["The Sentinel comes apart in plates of glass and slides into the sap."])
    end
    if !has_key?(:FT_BOYSMIRROR)
      return say([herald?(:meat_meat) ? "You put your palm on the glass. It won't break. It won't even crack." :
                                        "Meat Meat puts her palm on the glass. It won't break. It won't even crack.",
                  "In it, behind the girl, a woman's face with hollow eyes smiles. \"Not without my other half, V-7.\"",
                  "(The boy's mirror. In the Verdant Bazaar. It's the other half.)"])
    end
    mm = herald?(:meat_meat)
    dx, dy = mirror ? [mirror.x - $game_player.x, mirror.y - $game_player.y + 1] : [0, -1]
    stage_act(:meat_meat, :reach, dx: dx, dy: dy, dir: 8, per: 6)   # the boy's mirror, against the twin
    sayc([mm ? "You press the boy's mirror flat against the tall one. Glass to glass." :
               "Meat Meat presses the boy's mirror flat against the tall one. Glass to glass.",
          "Both mirrors scream. Something pours from one into the other and back, looking for a way out, and there's a girl in the way.",
          cl(:alberica, "Hold it, sweetheart! Hold it there!")])
    c = pbMessage(_INTL(mm ? "The mirrors buck in your hands..." : "The mirrors buck in Meat Meat's hands..."),
                  [_INTL("Brace, and hold them together"), _INTL("Pull the girl through first"), _INTL("Let go")], 0)
    Stage.cleanup rescue nil
    if c != 0
      say(["The mirrors slip. The spirit tears loose between them: a wraith of glass and ice, screaming in a pleasant, precise voice."])
      boss_battle(named_mon(:B122H429, 44, "Mirror Wraith"))
      say(["The wraith breaks up and slides back into the glass. The two mirrors are still waiting.",
           "(Try again: brace, and hold them together.)"])
      return
    end
    set_flag(:mirror_child_free)
    set_flag(:twin_broken)
    set_flag(:avarice_fragment_kept)
    ($game_switches[SW_CHILD_FREE] = true; $game_switches[SW_TWIN_BROKEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    wheel(1)
    Stage.fx("E-06", [mx, my], frames: 10, oy: 24)      # the mirrors crack, and the spirit sets
    sayc([mm ? "You hold on. Your arms shake. Your teeth hurt. You hold on." : "Meat Meat holds on. Her arms shake. She bares her teeth. She holds on.",
          "Between the two mirrors, frost grows inward, a lattice of crystal like a snowflake drawn by someone very patient.",
          "The voice in it gets smaller, and smaller, and stops. Caught.",
          "The girl falls free, into Alberica's arms, and sneezes.",
          cl(:alberica, "Bless you! There she is. Brave girl."),
          mm ? "(The crystal lattice is in your hands, cold and still. Something in it is very quiet, and very angry.)" :
               "MEAT MEAT: (holding up the crystal lattice) Got her. Got a piece of her. Meat Meat is keeping this piece in a box.",
          "MIRROR CHILD: My mama's Mira. On the big ship.",
          "MIRROR CHILD: She's been talking funny. She says \"we\" now.",
          "She holds on to your sleeve, and won't let go until you've promised to take her home.",
          cl(:meat_meat, "Meat Meat will hold the small one's other sleeve.")])
    take_key(:FT_BOYSMIRROR) rescue nil
    give_key(:FT_MIRRORLATTICE)
    state[:goal] = "Take the girl home: the Boreal Requiem, at the Split Dock in the Root-Tier. (And the boy in the Bazaar is free.)"
  end

  #-----------------------------------------------------------------------------
  # SC 7B.04 - Gym 6: Mira of the North Wind
  #-----------------------------------------------------------------------------
  def boreal_requiem(event_id = nil)
    return departure(:ship, event_id) if flag?(:ch11_done) && respond_to?(:departure)
    return say(lines_for(:corsair_gangplank), event_id) if !flag?(:mirror_child_free) || flag?(:mira_freed)
    say(lines_for(:corsair_gangplank), event_id)
    return if !pbConfirmMessage(_INTL("Board the Boreal Requiem?"))
    if !flag?(:mira_core_broken)
      sayc(["Mira stands at the wheel in a ring of mirrors. Her daughter runs to her.",
            "Mira doesn't look down.",
            "MIRA: (two voices at once, one of them colder) We know you. The Heralds. Our little failures.",
            herald?(:meat_meat) ? "(You stop dead. You know that voice. From the cold table.)" :
                                  cl(:meat_meat, "(stopping dead) ...Meat Meat knows that voice. From the cold table."),
            cl(:reptin, "(stepping between the girl and her mother) Behind me, sweetheart. Now."),
            "MIRA: (the cold voice) You found my nest, didn't you? Come down and see it. We'll be waiting.",
            "Below, in the hold, something hums: a mirror-core, wired into the ship's ribs.",
            "MIRA: (both voices, sweetly) Or leave it. Leave us be. You'll have your seal, and the girl, and no one has to break anything.",
            "MIRA: The girl's mother stays with her. Isn't that what you came for?"])
      c = pbMessage(_INTL("The mirror-core hums in the hold."), [_INTL("Go down and break it"), _INTL("Leave it be")], 0)
      if c == 1
        mira_left_possessed(true)
        return
      end
      return if !boss_battle(named_mon(:B122H429, 45, "Mirror-Core"))
      set_flag(:mira_core_broken)
      add_counter(:story_beats)
      sayc(["The core cracks across, and every mirror on the deck cracks with it.",
            "Mira collapses. When she looks up, there's only one voice.",
            "MIRA: (hoarse) Thirty years. Something talking in my mirrors for thirty years.",
            "Her daughter climbs into her lap.",
            "MIRA: ...Gods. Thank you. Now fight me properly. I need to feel like myself.",
            cl(:alberica, "Oh, I like her.")])
    elsif flag?(:mira_left_possessed)
      return mira_left_possessed(false)
    else
      say(["MIRA: You came back. Good. Properly, this time. I need to feel like myself."])
    end
    return if !scaled_leader_battle(:mira)
    $Trainer.badges[5] = true
    set_flag(:badge_mira)
    set_flag(:mira_freed)
    set_flag(:corsair_favour)
    set_flag(:mira_witness)
    ($game_switches[SW_MIRA_FREED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["MIRA: Tide Seal."])
    pbMessage(_INTL("\\me[Badge get]{1} received the Tide Seal!", $Trainer.name))
    give(:TM29)
    say(["MIRA: Psychic. Clean thinking. I could use some.",
         "MIRA: And the Requiem is yours if you ever need a ship. I don't care where."])
  end

  # If left possessed (rootspire.md 1079): she keeps her ship and her daughter
  # and her "we", and she still gives you a gym battle and the seal; but no
  # naval aid, no testimony, and later, when Avarice needs a new body, she has one.
  def mira_left_possessed(first = true)
    if first
      set_flag(:mira_left_possessed)
      set_flag(:mira_core_broken)        # (the gangplank's gate: the matter is settled, one way)
      sayc(["You don't go down. The humming in the hold settles, content.",
            "MIRA: (the warm voice, and the cold one, together, smiling) Good. Good. We knew you were reasonable.",
            "Her daughter holds her hand and looks up at her, and frowns, and doesn't say anything.",
            cl(:reptin, "(very quietly) I don't like this. I don't like this at all."),
            cl(:meat_meat, "(staring at the hold) Meat Meat is going to remember this. Meat Meat is going to remember we LEFT her.")])
    else
      say(["MIRA: (two voices) Back for the seal, little failures? We kept it warm."])
    end
    return if !scaled_leader_battle(:mira)
    $Trainer.badges[5] = true
    set_flag(:badge_mira)
    set_flag(:mira_freed)              # (Gym 6 is settled; :mira_left_possessed says how)
    ($game_switches[SW_MIRA_FREED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    wheel(-1)
    say(["MIRA: (two voices) Tide Seal."])
    pbMessage(_INTL("\\me[Badge get]{1} received the Tide Seal!", $Trainer.name))
    give(:TM29)
    say(["MIRA: Psychic. We think very clearly, now. We'll see you again, little failures. North of here, probably.",
         "(No offer of a ship. The crew won't meet your eyes.)"])
  end

  #-----------------------------------------------------------------------------
  # SC 7B.06 - Three wells
  #-----------------------------------------------------------------------------
  WELL_VISIONS = {
    1 => ["A woman in white fur walks through a garden of glass trees,", "on an island shaped like a snowflake."],
    2 => ["Long ago: a hand of mirror glass reaches up from under the roots, and takes hold."],
    3 => ["A vault of white ice under a glacier. In it, something with wings spread over a frozen eye."]
  }

  def sap_well(n, event_id = nil)
    say(["Golden sap bubbles lazily in the basin, whispering in half-remembered voices."], event_id)
    return if !pbConfirmMessage(_INTL("Drink from the well?"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    say(["It tastes of honey and sunlight and, underneath, of ice.", "Your Pokémon crowd round and drink too."])
    key = :"well_vision_#{n}"
    return if flag?(key)
    set_flag(key)
    say(["...and then the cavern goes away."])
    Stage.overlay("O-03", fade: 20)
    say(WELL_VISIONS[n])
    Stage.overlay_off("O-03", fade: 20)
    # the visions bite back (Tab 3: psychic backlash)
    $Trainer.party.each { |pk| pk.hp = [pk.hp - [pk.totalhp / 10, 1].max, 1].max if pk.hp > 0 } rescue nil
    say(["The vision lets go all at once. Your head rings like a struck bell, and your Pokémon flinch and shake theirs."])
    if (1..3).all? { |i| flag?(:"well_vision_#{i}") }
      set_flag(:wells_seen)
      add_counter(:story_beats)
      sayc([cl(:alberica, "Three wells, three bad dreams. Somebody else's memories."),
            cl(:alberica, "Or somebody else's plans."),
            cl(:alerion, "Plans.")])
      if !flag?(:vault_map_2)
        say(["In the third basin, where the visions overlapped, the sap has set into something flat and pale:",
             "a second fragment of the frost-drawn map. A glacier. A door. A dragon's eye."])
        set_flag(:vault_map_2)
        sayc([cl(:alberica, "Two pieces, darling. Told you there'd be more."), cl(:alerion, "One to go.")])
      end
    end
  end

  def attendant(event_id = nil)
    sayc(["A sap-thing clings to a root column.", "Half its face is smooth. The other half is a swirl of mouths.",
          "ATTENDANT: (in Avarice's voice, then in #{herald?(:alberica) ? 'your own' : "Alberica's own"}) Ask. One question each.",
          cl(:alberica, "Don't do my voice. Nobody does my voice.")], event_id)
    if !state[:attendant_promise]
      say(["ATTENDANT: (every mouth at once) But a question costs a promise. Burn the forge. Or free the heart."])
      c0 = pbMessage(_INTL("The attendant's price..."), [_INTL("\"We'll burn the forge.\""), _INTL("\"We'll free the heart.\""), _INTL("Promise nothing")], 2)
      if c0 == 2 || c0.nil?
        return say(["ATTENDANT: Then ask nothing. The sap is listening. The sap remembers who promises."])
      end
      state[:attendant_promise] = c0 == 0 ? :burn : :free
      set_flag(:attendant_promise)
      say([c0 == 0 ? "ATTENDANT: Burn it. Yes. Burn the hot heart out of the tree." : "ATTENDANT: Free it. Yes. Nothing should beat in a cage.",
           "ATTENDANT: Remember. We will."])
    end
    asked = state[:attendant_asked] ||= []
    opts = []
    opts << [:summer, _INTL("About Summer")] if !asked.include?(:summer)
    opts << [:heart, _INTL("About the heart")] if !asked.include?(:heart)
    opts << [:self, _INTL("About yourself")] if journey? && !asked.include?(:self)
    return say(["ATTENDANT: You've asked. I've answered. Go away; you're making the sap nervous."]) if opts.empty?
    c = pbMessage(_INTL("Ask it..."), opts.map(&:last) + [_INTL("Nothing")], opts.size)
    return if c.nil? || c < 0 || c >= opts.size
    key = opts[c][0]
    asked << key
    set_flag(:attendant_spoke)
    case key
    when :summer then say(["ATTENDANT: Summer is a coat."]); set_flag(:knows_summer_coat)
    when :heart  then say(["ATTENDANT: The cold man's heart is in the engine.", "ATTENDANT: The engine is in the hag's old kitchen."])
    when :self   then say(["ATTENDANT: You aren't on her wheel. That's why the glass let you through."]); set_flag(:not_on_wheel)
    end
  end

  #-----------------------------------------------------------------------------
  # SC 7B.07 - Selrae, below
  #-----------------------------------------------------------------------------
  def selrae_heartroot(event_id = nil)
    return say(lines_for(:selrae_after), event_id) if flag?(:root_key)
    sayc(["The Winter Matron sits on a root with frost-burned hands. Her Pokémon pant in the heat.",
          "Two Rootwardens stand over her, unsure who they're guarding.",
          "SELRAE: I came down after Var. A week ago. I got this far.",
          "SELRAE: You should know. I let the Halo into this city. Thirty years.",
          "SELRAE: I thought a little winter would balance this endless summer. That's all I wanted.",
          cl(:reptin, "(gently) Go on, Matron. We're listening."),
          "SELRAE: They gave the Frost Saint's heart to Summer. I knew it was wrong.",
          "SELRAE: The Halo had a friend down here too. White hair. Lovely manners.",
          herald?(:alberica) ? "(Avarice.)" : (with_or_is?(:alberica) ? "ALBERICA: (very plainly) Avarice." : "Avarice."),
          "SELRAE: (closing her eyes) I've read that name in the oldest ledgers. I hoped it was a story.",
          cl(:meat_meat, "Not a story. Meat Meat has the scars."),
          "SELRAE: She wants a vault. Far north, under the glacier, where the goddess keeps what she can't bear to look at.",
          "SELRAE: (softly, like a prayer) The White Womb. That's what the old priests called it. I never thought I'd say it aloud."], event_id)
    c = pbMessage(_INTL("What do you tell Selrae?"), [_INTL("\"Come home. Tell the Council.\""), _INTL("\"Come with us.\"")], 0)
    if c == 1
      set_flag(:selrae_ahead)
      sayc(["SELRAE: I'll only slow you. No. I'll go ahead.",
            "SELRAE: Somebody should see what's down there before you walk into it.",
            "She stands, badly, and walks into the frost-grown roots before anyone can stop her.",
            cl(:alerion, "She'll get herself caught.")])
    else
      set_flag(:selrae_home)
      say(["SELRAE: ...Kelyn will cry. Then she'll shout. Then she'll make me tea. Very well.",
           "She goes back up with the Rootwardens, leaning on one of them."])
    end
    say(["Before she goes, she presses a key of black ice into your hand.",
         "SELRAE: The Root-Key. Summer gave Winter a copy. To keep me quiet, I think."])
    give_key(:FT_ROOTKEY)
    set_flag(:root_key)
    set_flag(:selrae_faced)
    ($game_switches[SW_SELRAE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    state[:goal] = "The Root-Key: the knotted heart-wall here in the Sap Wells, and the Heartroot's lower zones below it."
  end

  def apply_road_b_switches
    return if !active? || !$game_switches
    sync_switch(SW_HEW_DOWN, flag?(:hew_down))
    sync_switch(SW_CHILD_FREE, flag?(:mirror_child_free))
    sync_switch(SW_MIRA_FREED, flag?(:mira_freed))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_road_b_switches
  rescue StandardError => err
    FrostThaw.log("Road B switches failed: #{err.message}")
  end
}
