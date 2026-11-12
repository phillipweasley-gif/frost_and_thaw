#===============================================================================
# Frost & Thaw - the trial week's other roads (rootspire.md Tab 4 and Tab 8)
#
#   The Mirror Maze (the Echo Gate's pocket-plane, 2161):
#     A1 Echoes at the Auroral Wall (Alerion's lost reflection), and the Mirror
#     Wraiths who bear witness in the trials (Q3, Q4, Q6). The Echo Gate's
#     Frostshard Sigil waits at its heart, for anyone who missed it before.
#   W1 Shadows in the Undercity (Wyn): the Smuggler's Run (2160)
#   W2 The Mirror Lake Ghost (Wyn): the Glasswater (2078), on a new moon
#   B2 The Stolen Leaf (Alberica) and GQ4 Beyond the Auroral Wall: the
#     Glasswater crossing, the frozen time beyond the Wall (2163), the ruins of
#     Dougan's Hole under the ice (2164), the Temporal Guardian
#   R2 Pulse of the Blooming Fields (Reptin)
#   Q6: Slaudi the fisherman (Bryn Shander); the cedar charm; the Library's
#     Leaf of Old Alliances; the trial days (a day passes at each Hearth rest)
#===============================================================================
module FrostThaw
  SW_SMUGGLERS = 4127    # the Smuggler's Run is open (once Wyn travels with you)
  SW_ECHO_POCKET = 4128  # the frost patterns at the Echo Gate open on the Mirror Maze
  SW_GLASSWATER = 4129   # the Wall has receded: the Glasswater lies past the Blooming Fields
  SW_BEYOND_WALL = 4137  # the way through the Wall, from the Glasswater's far shore
  SW_LEAF_SHELF = 4141   # the chronal leaf is missing from the Library
  SW_FIELD_SPIRITS = 4146 # the summer and winter spirits, in the Blooming Fields
  SW_BRISA_HOME = 4198   # Warden Brisa, pulled out of the ice past the Wall, is home in the Root-Tier

  MAPS.merge!(undercity: 2160, mirror_maze: 2161, beyond_wall: 2163, drowned_hall: 2164)
  MAP_NAMES.merge!(2160 => "The Undercity", 2161 => "The Mirror Maze", 2163 => "Beyond the Auroral Wall",
                   2164 => "The Drowned Hall")
  MAP_METADATA.merge!(
    2160 => { announce_location: true, battle_environment: :Cave },
    2161 => { announce_location: true, battle_environment: :Ice },
    2163 => { outdoor_map: true, announce_location: true, battle_environment: :Snow },
    2164 => { announce_location: true, battle_environment: :Ice }
  )
  AREAS.merge!(2160 => :root_tier, 2161 => :rootspire, 2163 => :beyond_wall, 2164 => :beyond_wall)
  ENCOUNTERS[2160] = { step_chances: { Cave: 8 },
                       Cave: [[30, :PARAS, 52, 54], [25, :GLOAMCAP, 52, 54], [20, :CARVANHA, 52, 54],
                              [15, :SHROOMISH, 52, 54], [10, :TANGELA, 53, 55]] }
  ENCOUNTERS[2163] = { step_chances: { Land: 7 },
                       Land: [[30, :SNEASEL, 56, 58], [25, :GLALIE, 56, 58], [20, :SNORUNT, 56, 58],
                              [15, :DUSKULL, 56, 58], [10, :FROSLASS, 57, 59]] }

  RELIC_ITEMS.merge!(
    FT_CHRONALLEAF: ["Chronal Leaf", "Chronal Leaves", 8, 0,
      "A crystal leaf torn from Alberica's own timeline. Hold it to your ear: her voice, from a year that hasn't happened.", 0, 0, 6],
    FT_SPOREDREAM: ["Spore Dream", "Spore Dreams", 2, 0,
      "A memory the Undercity's spore colony gave back. Throw it in battle: the target sees phantoms and becomes confused.", 0, 5, 0],
    FT_MIRRORBLADE: ["Mirror-Blade", "Mirror-Blades", 1, 0,
      "The drowned cultist's sword of mirror shards, bound to Wyn's call. Held: Steel- and Ghost-type moves hit harder.", 0, 0, 0],
    FT_MIRRORSHARD: ["Shard of the Mirror Mother", "Shards of the Mirror Mother", 8, 0,
      "A shard of the Mirror Mother's glass. The drowned woman carried it for fifty years. It's very cold, and it's listening.", 0, 0, 6],
    FT_FIELDSPIRITS: ["Seasons' Token", "Seasons' Tokens", 8, 0,
      "Half a green leaf and half a white snowflake, grown together. The Fields' two spirits answer when it's held.", 0, 0, 6]
  )

  TEXT.merge!(
    smuggler_dockworker: -> {
      flag?(:undercity_done) ? ["DOCKWORKER: I sleep now. Right through. Thank whatever you did down there."] :
        ["DOCKWORKER: A fungus down the Smuggler's Run. It sprouts eyes. It whispers.",
         "DOCKWORKER: It showed me things I shouldn't know. Now my dreams are full of shadows.",
         (herald?(:wyn) ? "DOCKWORKER: The hatch by the Split Dock barrels. You'll know it, Rootwarden." :
                          "DOCKWORKER: The hatch by the Split Dock barrels. Wyn knows it. The wardens won't go down.")] },
    run_glowworms: ["Lanterns of bottled glow-worms swing from root arches. The light is green and sick.",
                    "Moss-steam rises off the dark water like breath."],
    guild_vault_sealed: ["A door of banded root, set deep in the rock. The Guild of Roots and Stone's seal is on it.",
                         "Something behind it hums, very faintly. Not your business. Not today."],
    maze_pane: ["Ice, polished like a mirror. Your reflection is a heartbeat late."],
    # (after the end the Wall is down and time moves here again: context 13 M13-8)
    beyond_snow: -> { FrostThaw.flag?(:game_complete) ? ["Snow, falling the ordinary way. Where the Wall stood, nothing stops it now."] :
                                                       ["Snowflakes hang in the air. You walk through them; they part, and stay parted."] },
    beyond_waves: -> { FrostThaw.flag?(:game_complete) ? ["A wave on the lake, slumped into slush and broken ice.", "It froze mid-crest for four hundred years. It's falling now, slowly."] :
                                                        ["A wave on the lake, frozen mid-crest, taller than a house.", "In its face: constellations that don't match any sky."] },
    drowned_hall_sign: ["A carved beam, half under ice: DOUGAN'S HOLE - MEAD HALL.", "The rest of the village is under four hundred years of frost."],
    leaf_gap: ["A shelf of crystal leaves, humming in different tones. One gap, the shape of a leaf.",
               "The edges of the gap are burned with frost."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Trial days pass at the Hearth (Tab 8: "each day they neglect the walls...")
  #-----------------------------------------------------------------------------
  class << self
    if method_defined?(:hellen) || respond_to?(:hellen)
      alias ft_w4_hellen hellen unless method_defined?(:ft_w4_hellen)
      def hellen(event_id = nil)
        ft_w4_hellen(event_id)
        trial_day_passes if flag?(:trials_open) && !flag?(:ch10_done) && respond_to?(:trial_day_passes)
      rescue StandardError => e
        log("hellen (trial days) failed: #{e.message}")
      end
    end
  end

  #-----------------------------------------------------------------------------
  # The cedar charm (Q1 evidence): from Reptin's pack, or carved from a fallen leaf
  #-----------------------------------------------------------------------------
  def reptin_pack(event_id = nil)
    return say(["Reptin's pack, on the bed in his room. Very neatly packed. Annoyingly so."], event_id) if ($PokemonBag.pbHasItem?(:FT_CEDARCHARM) rescue false)
    if !with_or_is?(:reptin)
      return say(["Reptin's pack. It isn't yours to rummage in."], event_id)
    end
    say([herald?(:reptin) ? "Your pack. At the bottom, in a sock: the cedar charm. Forgotten. Never forgotten." :
                            "REPTIN: It'll be at the bottom. It's always at the bottom. ...There.",
         "A little charm carved from cedar, worn smooth. Four hundred years old, and a few weeks."], event_id)
    give_key(:FT_CEDARCHARM)
  end

  def fallen_leaves(event_id = nil)
    say(["Hyphora's leaves, falling for the first time anyone remembers. Brown, gold, a few green."], event_id)
    return if ($PokemonBag.pbHasItem?(:FT_CEDARCHARM) rescue false) || !flag?(:anduin_talked) && !flag?(:trials_open)
    return if !with_or_is?(:reptin)
    return if !pbConfirmMessage(_INTL("Carve a charm from a fallen leaf, the way Anduin carved the cedar one?"))
    if challenge("The leaf is thin and brittle.", ["A green one, carved with the grain", "The biggest brown one", "Carve fast"], 0)
      say(["A little charm, carved from Hyphora's own leaf. It smells of sap, not cedar. It'll do."])
      give_key(:FT_CEDARCHARM)
    else
      say(["It crumbles in your fingers."])
    end
  end

  #-----------------------------------------------------------------------------
  # Q6: Slaudi, the two-fingered fisherman (Bryn Shander, past the thinned Wall)
  #-----------------------------------------------------------------------------
  def slaudi(event_id = nil)
    return say(["SLAUDI: I'll come south. I'll say it to their crystals. I'll hold up my hand so they can count."], event_id) if flag?(:slaudi_testifies)
    say(["A gnarled fisherman, two fingers short, mending a net with the eight he has left.",
         "SLAUDI: Caer-Konig. Was. Before the Rime ate it."], event_id)
    return if !pbConfirmMessage(_INTL("Ask Slaudi about the food caravans."))
    if challenge("Slaudi doesn't trust anyone from south of the Wall.", ["Ask about Caer-Konig, and listen", "Tell him you're Heralds", "Pay him"], 0)
      say(["SLAUDI: The caravans. Every one up the Eastway, the last two winters.",
           "SLAUDI: Turned round at the Wall. Food, furs, lamp-oil. Went south, into the light.",
           "SLAUDI: We ate our dogs. Then we ate... Never mind what we ate.",
           "He doesn't look up from the net.",
           "SLAUDI: Somebody had a stockpile. Somebody warm. I'll say so, to their faces."])
      set_flag(:slaudi_testifies)
      add_support(:phildendrin, 1) rescue nil
    else
      say(["SLAUDI: Heralds. We had Heralds once, on a mural. Didn't feed anybody."])
    end
  end

  #-----------------------------------------------------------------------------
  # Q5: the Leaf of Old Alliances, in the Wind-Glass Library
  #-----------------------------------------------------------------------------
  def old_alliances(event_id = nil)
    return say(["The oldest shelf. You've taken the leaf you needed."], event_id) if ($PokemonBag.pbHasItem?(:FT_HISTORYSCROLL) rescue false)
    say(["The oldest shelf, very high up. Crystal leaves, dim with age, humming low."], event_id)
    if challenge("Find the right leaf.", ["Listen for the oldest hum", "Take the brightest", "Take one at random"], 0)
      say(["It's a history: a world-tree in the south, long ago, and the myconids who sheltered it.",
           "Then another, in the east. Then another. Three times before Hyphora, the same alliance."])
      give_key(:FT_HISTORYSCROLL)
    else
      say(["A leaf of somebody's shopping list, four hundred years old. Twelve eggs."])
    end
  end

  #-----------------------------------------------------------------------------
  # The Mirror Maze (A1; and the wraiths' testimony)
  #-----------------------------------------------------------------------------
  MIRROR_MAZE_ARRIVAL = [2161, 12, 22, 8]

  def echo_frost(event_id = nil)
    say(["The frost on the Echo Gate's dark ice is patterned like eyes. They follow you.",
         "Linger, and the wind whispers your name. Then another voice, cold: \"The lake remembers.\"",
         "Your reflection in the ice flickers and winks out, as if it stepped away without you."], event_id)
    if !flag?(:talion_foreshadowed)
      sayc(["And under the wind, very small, a boy's voice, from somewhere a long way down in the ice:",
            "BOY'S VOICE: ...Alerion? You said you'd come back.",
            cl(:alerion, "...No. No, that's not possible."),
            cl(:alberica, "Pretty boy? Who's Alerion's little friend?"),
            cl(:alerion, "Nobody. A long time ago. Leave it.")])
      set_flag(:talion_foreshadowed)
    end
    return if !pbConfirmMessage(_INTL("Step into the reflection, after it?"))
    enter_mirror_maze
  end

  # A1's way in (the notes: "Alerion must succeed on a Wisdom save to resist the
  # gate's chilling whispers"): from the Echo Gate, after the wraiths in Ch6
  # (048 echoes_at_the_wall), or the frost door from Ch7 on (echo_frost).
  def enter_mirror_maze
    if !flag?(:maze_entered)
      who = with_or_is?(:alerion) ? (herald?(:alerion) ? "You" : "Alerion") : "You"
      ok = challenge("The gate's whispers press in on #{who == 'You' ? 'you' : 'Alerion'}.",
                     ["Breathe, and let them pass", "Shout back", "Cover your ears"], 0)
      if !ok
        say(["The whispers get in. Heads ring; your Pokémon flinch and stagger, cold to the bone."])
        $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 6), 1].max if !pk.egg? && pk.hp > 0 } rescue nil
      end
    end
    transfer(*MIRROR_MAZE_ARRIVAL)
  end

  def reflection_done?
    flag?(:reflection_claimed) || flag?(:alerion_reflection)
  end

  def scene_mirror_maze
    return if flag?(:maze_entered)
    set_flag(:maze_entered)
    if reflection_done?
      return sayc(["A pocket of the world made entirely of mirror-ice. Corridors that reflect corridors.",
                   "Nobody walks away from you in it any more. At its heart, the wraiths wait in a ring."])
    end
    sayc(["A pocket of the world made entirely of mirror-ice. Corridors that reflect corridors.",
          "Somewhere in it, very far off, a figure is walking away from you, wearing your face.",
          cl(:alerion, "That one's mine. I left it here. When the time broke, and we fell."),
          cl(:alberica, "Then we'll fetch it, pretty boy. Nobody leaves bits of themselves lying about.")])
  end

  # The maze's three junctions (skill challenge: 3 successes before 2 failures).
  # A failed check brings a Mirror Wraith; beating it counts as a success. Two
  # failures and the maze folds up on you: the round starts again.
  def maze_junction(which, event_id = nil)
    st = (state[:maze] ||= { ok: 0, bad: 0, done: [] })
    return say(lines_for(:maze_pane), event_id) if st[:done].include?(which) || reflection_done?
    prompt, opts = { stealth: ["Mirror Wraiths drift along the corridor ahead.", ["Wait for them to pass, then slip by", "Charge", "Call out"]],
                     path: ["Three corridors, each reflecting the others.", ["The one where your reflection lags", "Follow the brightest", "Follow the coldest"]],
                     shadow: ["A flicker, at the edge of the ice.", ["The shadow that doesn't match", "Look for movement", "Look away"]] }[which]
    if challenge(prompt, opts, 0)
      st[:ok] += 1
      say(["(A step closer.)"])
    else
      say(["Something in the ice notices you. A Mirror Wraith steps out, wearing your face, cracked."], event_id)
      if skirmish(named_mon(:B122H429, flag?(:trials_open) ? 54 : 42, "Mirror Wraith"))
        st[:ok] += 1                                   # (defeating a wraith counts as a success)
      else
        st[:bad] += 1
        if st[:bad] >= 2
          say(["The corridors turn, and turn again, and fold up like a letter. You're back at the start.",
               cl(:alerion, "It's still in there. It'll wait. It's very good at waiting. So am I.")].compact)
          state[:maze] = { ok: 0, bad: 0, done: [] }
          return
        end
        return say(["(The wraith drives you back. This way's still open: try it again.)"])
      end
    end
    st[:done] << which
  end

  # A1: claiming the reflection
  def maze_reflection(event_id = nil)
    return say(["A pane of ice. Just ice now."], event_id) if reflection_done?
    today = (pbGetTimeNow.strftime("%Y%m%d") rescue "0")
    if state[:reflection_dawn] && state[:reflection_dawn] == today
      return say(["Your reflection's gone deep into the ice, past where you can follow.",
                  "(It's escaped until the next dawn.)"], event_id)
    end
    st = (state[:maze] ||= { ok: 0, bad: 0, done: [] })
    if st[:ok] < 3
      return say(["Far down the corridor, your reflection turns a corner. You can't catch it from here.",
                  "(Get through the maze's junctions first.)"], event_id)
    end
    al = herald?(:alerion)
    say([herald?(:alerion) ? "A pane of ice, and your own face in it, staring back. Younger. It hasn't slept in years." :
                             "A pane of ice, and Alerion's face in it, staring back. Younger. It hasn't slept in years.",
         al ? "(It's the part of you that stayed behind when the time broke.)" : "ALERION: That's the part of me that stayed behind."], event_id)
    if !with_or_is?(:alerion)
      return say(["Without Alerion here, the reflection only watches you, and waits."])
    end
    tries = (state[:reflection_tries] ||= 0)
    ok = challenge("Meditate, and take it back.", ["Breathe slow, and let it come", "Reach in and grab it", "Talk to it"], [0, 2])
    if ok
      say(["The man who walked into the winter four hundred years ago left a piece of himself here."])
      speak(:alerion, "(a palm flat on the glass) Come on, then. I've kept your seat warm. Well. Cold.",
            "(a palm flat on the glass) ...Come home.")
      say([al ? "You breathe out. The reflection breathes in. Then it's not in the ice any more." :
                "Alerion breathes out. The reflection breathes in. Then it's not in the ice any more.",
           as(:alerion, "(steadier than any of you have heard him) ...There. I'm all here now."),
           cl(:alberica, "We won't ask. We'll just be very smug about it.")].compact)
      set_flag(:reflection_claimed)
      set_flag(:alerion_reflection)
      wheel(1)
      add_counter(:story_beats)
      give(:MENTALHERB, 2)
      grant_blessing(:reflection, "Alerion's Reflection", "Your Pokémon can no longer be confused.")
    else
      # "Failure causes the reflection to flee deeper, requiring another round of checks.
      #  If he fails three times, the reflection escapes until the next dawn."
      state[:reflection_tries] = tries + 1
      st[:ok] = 0; st[:bad] = 0; st[:done] = []
      if tries + 1 >= 3
        say(["The reflection flees deeper, into ice you can't follow. It'll be back at dawn."])
        state[:reflection_tries] = 0
        state[:reflection_dawn] = today
      else
        say(["The reflection flinches and slides deeper, back into the corridors.",
             "(You'll have to go after it again, junction by junction.)"])
      end
    end
  end

  # The wraiths' testimony: a vial (from Mira) or Wyn's rapport carries it to the court.
  def maze_witness(event_id = nil)
    say(["At the maze's heart, a ring of Mirror Wraiths faces inward, waiting to be asked."], event_id)
    can_carry = ($PokemonBag.pbHasItem?(:FT_MEMORYVIAL) rescue false) || with_or_is?(:wyn)
    opts = []
    opts << [:door, _INTL("\"Who broke the Underdark seal?\"")] if flag?(:wyn_summoned) && !flag?(:wraith_witness_door)
    opts << [:dead, _INTL("\"What of those who see their dead?\"")] if flag?(:talion_met) && !flag?(:wraith_riddle_understood)
    opts << [:lake, _INTL("\"What is Talion?\"")] if flag?(:talion_met) && !flag?(:wraith_called_reflection)
    opts << [:avarice, _INTL("\"What did Avarice command you to do?\"")] if flag?(:trials_open) && !flag?(:wraith_echo_avarice)
    opts << [:sigil, _INTL("Ask for the sigil they guard")] if !(flag?(:echo_wraiths_down) || flag?(:sigil_echo))
    opts << [:bye, _INTL("Ask nothing")]
    c = pbMessage(_INTL("Ask the wraiths..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :door
      say(["The wraiths turn as one. In their glass: the Underdark door, at night.",
           "Figures in Rootwarden cloaks chant over a circle of frost. Their breath doesn't fog.",
           "Far off in another pane, a small figure walks down into the spore-light, alone: Wyn."])
      if can_carry
        say([($PokemonBag.pbHasItem?(:FT_MEMORYVIAL) rescue false) ? "(The vision runs into the memory vial like water.)" :
                                                                    "(Wyn takes it, gently, into their spores: they can show it to the court.)"])
        set_flag(:wraith_witness_door)
      else
        say(["(You'll need a way to carry it: a memory vial from Mira, or Wyn's rapport.)"])
      end
    when :dead
      say(["THE WRAITHS: (in your voices) Echoes fade when embraced. Reflections devour when chased."])
      if challenge("What does it mean?", ["Accept him; don't try to hold him", "Fight for him", "Run from him"], 0)
        say(["(Acceptance, not control. That's the key.)"])
        set_flag(:wraith_riddle_understood)
      end
    when :lake
      say(["THE WRAITHS: A reflection, made when a living hand reached into the aurora-lit lake.",
           "THE WRAITHS: Not a boy. The shape of a boy. A boy-shaped echo."])
      set_flag(:wraith_called_reflection)
    when :avarice
      if challenge("The wraiths wait to see how you'll ask.", ["Ask respectfully, and wait", "Command them", "Threaten them"], 0)
        say(["In the glass: the woman who counts, at the Echo Gate, years ago. Var's body, her voice.",
             "AVARICE: (in the vision) Watch the Ten-Towns. All ten. Count them for me.",
             "AVARICE: Choose who'd be missed least. They go to Auril. Her winter buys my summer."])
        if can_carry
          say(["(The vision is carried. The court will see it.)"])
          set_flag(:wraith_echo_avarice)
        else
          say(["(You'll need a way to carry it: a memory vial from Mira, or Wyn's rapport.)"])
        end
      else
        say(["The wraiths turn their backs. Every one of them."])
      end
    when :sigil
      say(["The ring opens. In its centre, on ice, a crystal that hums toward the Heartroot.",
           "THE WRAITHS: Take it. It was never ours. We only kept it from her."])
      give(:FT_FROSTSIGIL)
      set_flag(:sigil_echo)
      say(["(A Frostshard Sigil. One of three keys to the White Vault, beyond the Auroral Wall.)"])
      try_merge_sigils
    end
  end

  #-----------------------------------------------------------------------------
  # W1: Shadows in the Undercity (Wyn)
  #-----------------------------------------------------------------------------
  def scene_smugglers_run
    return if flag?(:undercity_entered)
    set_flag(:undercity_entered)
    sayc(["Below the Smuggler's Run, the crack opens on the Undercity: older tunnels, dripping caves.",
          "Moss-steam rises off dark water. Glow-worm lanterns sway from root arches, sickly green.",
          cl(:wyn, "...Spores. Old ones. Hungry ones. This way.")])
  end

  # Following the densest spore clouds (Survival): a wrong turn and you breathe them.
  def spore_trail(n, event_id = nil)
    key = :"spore_trail_#{n}"
    return if flag?(key)
    fork = [["The spore-cloud thickens. It splits two ways.",
              "(then pointing) That way. Where it's cold. Breathe through your sleeve.",
              ["Follow Wyn, sleeve over your mouth", "Go the other way"], ["Where it's thickest and coldest", "Where it's thinnest"]],
             ["Water drips from the roof. One way is wet and dark; the other dry, lit by glow-worms.",
              "...The wet way. Sorry. The lanterns are what it wants you to follow.",
              ["The wet, dark way, with Wyn", "The dry way, by the lanterns"], ["The wet, dark way", "The dry way, by the lanterns"]],
             ["Whispering, from both ways at once. One way it's soft. The other way it's loud.",
              "There. Where it's loudest. It knows we're coming.",
              ["Toward the loud whispering", "Toward the soft whispering"], ["Toward the loud whispering", "Toward the soft whispering"]]][(n - 1) % 3]
    say([fork[0]], event_id)
    if with_or_is?(:wyn)
      # (Survival: Wyn knows the Undercity's spores by smell.)
      say([as(:wyn, fork[1])])
      ok = challenge("Which way?", fork[2] + ["Back"], 0)
    else
      ok = challenge("Which way?", fork[3] + ["Back"], 0)
    end
    set_flag(key)
    if !ok
      say(["You breathe a lungful. The cavern walls breathe back. Everything has eyes for a while."])
      set_flag(:undercity_spored)
    end
  end

  def undercity_colony(event_id = nil)
    if flag?(:undercity_done)
      return say([flag?(:undercity_bargain) ? "The colony pulses, slow and content. Its eyes are closed." :
                                             "Ash, and the smell of burnt mushrooms, and quiet."], event_id)
    end
    if !with_or_is?(:wyn)
      return say(["A mass of mushrooms, pulsing dark, an eye in every cap. They all turn to you.",
                  "(It won't talk to you. It wants someone who speaks spore.)"], event_id)
    end
    say(["A mass of mushrooms, pulsing dark, an eye in every cap. They all turn to you.",
         "Whispers, not words: things people dropped down here. Secrets. Bad dreams."], event_id)
    ok = challenge("Commune with it.", ["Listen to what it wants", "Push your mind into it", "Ask it to stop"], 0)
    if ok && flag?(:undercity_spored)
      # (W1: breathing the spores is disadvantage on the commune.)
      say(["The spores in your lungs answer it first. Its whispers come back in your own voice."])
      ok = challenge("Hold on to your own voice.", [(herald?(:wyn) ? "Breathe out; listen for your own voice" : "Breathe out; listen for Wyn's voice"), "Shout over it", "Let it talk"], 0)
    end
    if ok
      say([as(:wyn, "...It's hungry. For stories. It eats them, and dreams them out bent."),
           as(:wyn, "It doesn't mean to frighten anyone. It just doesn't know what else to do with them.")])
      c = pbMessage(_INTL("Pacify it?"), [herald?(:wyn) ? _INTL("Offer it a memory of your own") : _INTL("Offer it a memory of Wyn's"), _INTL("Feed it your Pokémon's strength"), _INTL("No")], 0)
      if c == 0
        speak(:wyn, herald?(:wyn) ? "(to the colony) The night the spores went quiet. Then the snow. Take it. It's a good one." :
                                    "Here. The night Hyphora called me. The spores singing my name. Take it. It's a good one.",
              "...Take this one. It's a good one.")
        say(["The colony goes quiet. Its eyes close, one by one, like lanterns going out."])
      elsif c == 1
        $Trainer.party.each { |pk| pk.hp = [pk.hp - 10, 1].max if !pk.egg? && pk.hp > 0 } rescue nil
        say(["It drinks a little of your team's strength, gently, and its eyes close."])
      else
        ok = false
      end
    end
    if !ok
      say(["The colony bursts. Spore swarms boil out of it, all teeth and whispers."])
      return if !boss_battle(named_mon(:B47H92, 53, "Spore Swarm"), named_mon(:B47H92, 53, "Spore Swarm"))
    end
    c = pbMessage(_INTL("And now?"), [_INTL("Strike a bargain with it"), _INTL("Burn it")], 0)
    if c == 0
      say([as(:wyn, "(to the colony) Eat the stories that hurt. Give back the ones that help. ...Please?"),
           "The colony pulses once: yes. A little cap drops into your hand, a dream folded small."])
      give(:FT_SPOREDREAM, 1)
      set_flag(:undercity_bargain)
      grant_blessing(:undercity, "Undercity's Bargain", "The colony owes Wyn a dream. Throw a Spore Dream in battle to confuse a foe.")
    else
      fire = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && (GameData::Move.get(m.id).type == :FIRE rescue false) } }
      say([fire ? "#{fire.name} burns it. The fumes roll back over you; you hold your breath and run." :
                  "You burn it with lamp-oil from the glow-worm lanterns. The fumes roll back over you.",
           "Nightmares stop all over the Root-Tier that night.",
           "By morning, the Rootwardens want to know who burned a colony under their docks."])
      set_flag(:undercity_burned)
      set_flag(:rootwardens_angered)
    end
    set_flag(:undercity_done)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # W2: the Mirror Lake Ghost (Wyn), on the Glasswater
  #-----------------------------------------------------------------------------
  def glasswater_shore(event_id = nil)
    say(lines_for(:glasswater_still), event_id)
    opts = []
    opts << [:ghost, _INTL("Wait for the new moon")] if !flag?(:lake_ghost_done)
    opts << [:inquiry, _INTL("Ask the lake about Talion")] if flag?(:talion_met) && !flag?(:talion_lake_seen)
    opts << [:bye, _INTL("Leave it")]
    c = pbMessage(_INTL("At the lake's edge..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :ghost then lake_ghost
    when :inquiry then talion_lake_inquiry
    end
  end

  def talion_lake_inquiry
    say(["Twilight. The lake goes so still it's a mirror with no back to it.",
         "You ask. It shows you a man kneeling in the shallows, years ago, his hands glowing.",
         "The aurora pours down into the lake around him.",
         "Where his hands touch the reflections, a small shape stands up out of the water."])
    if challenge("What does it show?", ["His spell made an echo, not a boy", "Talion never died", "A curse"], 0)
      say(["(The Talion in the Fields is an echo. Made from a reflection, not raised from a grave.)"])
      set_flag(:talion_lake_seen)
    end
  end

  def lake_ghost
    if !with_or_is?(:wyn)
      return say(["Mist on the water, and something in it. It's waiting for someone who walks in shadow."])
    end
    wyn_me = herald?(:wyn)
    say(["Nights pass at the shore. Then the new moon.",
         "Mist clings to the half-thawed lake. The stars in it don't match the sky."])
    # she comes across the water to you (notes/10 E1: on screen when she speaks)
    ghost = Stage.actor(:ghost, $game_player.x + 4, $game_player.y - 3, 4, graphic: "Followers/FROSLASS")
    if ghost
      ghost.opacity = 160
      Stage.walk_to(ghost, $game_player.x + 2, $game_player.y - 1) || Stage.walk(ghost, [PBMoveRoute::Left] * 2)
    end
    say(["A figure crosses the water toward you: a gaunt woman in wet furs, her eyes empty pits.",
         "In her hand, a blade made of mirror shards. Her footsteps make no ripples."])
    if !challenge("Get close to her.", ["Take the old boat from the reeds", "Walk out on the ice, quietly", "Call to her from the shore"], [0, 1])
      say(["The ice gives under you. Freezing water to the waist. Your Pokémon haul you out, shaking."])
      $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 5), 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    end
    talk_ok = challenge("She stops. She's watching Wyn.", ["Let Wyn speak, through the spores", "Draw a weapon", "Ask her what she wants"], [0, 2])
    if talk_ok
      say([as(:wyn, "(through the spores) ...You're so cold. Who made you carry that?"),
           "GHOST: (like water under ice) The Halo. Fifty years ago. A shard of the hag's glass.",
           "GHOST: Mother Thruuna's. I wasn't to put it down.",
           "GHOST: I fell through. I'm still holding it. I can't let go."])
    else
      say(["She raises the mirror-blade. The shards in it scream."])
      return if !boss_battle(named_mon(:B429H227, 56, "Drowned Lady"))
      say(["She stops, mid-water. She doesn't fall. She just looks at the shard in her hand.",
           "GHOST: ...I can't let go."])
    end
    c = pbMessage(_INTL("The ghost..."), [_INTL("Lay her to rest"), _INTL("Bind her as the lake's guardian")], 0)
    if c == 0
      gmon = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.hasType?(:GHOST) }
      say([gmon ? "#{gmon.name} sings to her, the way ghosts sing to each other." :
                  as(:wyn, "(the god-spark of shadow warm in one hand) You can put it down now. I'll hold it."),
           wyn_me ? "She opens her hand. The shard drops into yours. She smiles, and the mist takes her." :
                    "She opens her hand. The shard drops into Wyn's. She smiles, and the mist takes her.",
           "From now on the Glasswater lies still and kind. The ice holds; the boats don't tip."])
      Stage.remove_actor(ghost) if ghost
      set_flag(:lake_ghost_rested)
      give_key(:FT_MIRRORSHARD)
    else
      say([as(:wyn, "Stay. Guard the lake. Come when I call."),
           wyn_me ? "She bows her head, gives you the blade, and stays: a shape in the mist, watching." :
                    "She bows her head, gives the blade to Wyn, and stays: a shape in the mist, watching."])
      set_flag(:lake_ghost_bound)
      give(:FT_MIRRORBLADE)
      give_key(:FT_MIRRORSHARD)
    end
    Stage.cleanup rescue nil
    set_flag(:lake_ghost_done)
    add_counter(:story_beats)
    trial_work_done if respond_to?(:trial_work_done)      # (nights at the shore: the week's days go too)
  end

  #-----------------------------------------------------------------------------
  # B2: the Stolen Leaf; GQ4: Beyond the Auroral Wall
  #-----------------------------------------------------------------------------
  # Eirwen comes to the shelf (notes/10 E27: she isn't standing in the
  # Library all week while she's also at the Shrine).
  def library_eirwen
    ev = stage_event("Eirwen Solglass")
    return ev if ev && !ev.transparent && !ev.instance_variable_get(:@erased) && Stage.on_screen?(ev)
    ev = Stage.actor(:eirwen, $game_player.x - 3, $game_player.y + 1, 6, graphic: "FT_eirwen_solglass")
    Stage.approach(ev) if ev
    ev
  end

  def chronal_shelf(event_id = nil)
    return say(["The gap on the shelf is filled. The new leaf hums in Alberica's voice."], event_id) if flag?(:leaf_restored)
    say(lines_for(:leaf_gap), event_id)
    if !flag?(:leaf_quest)
      library_eirwen
      me = herald?(:alberica)
      say([me ? "EIRWEN: (out of breath) A chronal leaf is gone. Torn out of your own timeline." :
                "EIRWEN: (out of breath) A chronal leaf is gone. Torn out of Alberica's own timeline.",
           me ? "EIRWEN: Without it, your days come loose. A year of you, gone, like a torn-out page." :
                "EIRWEN: Without it, her days come loose. A year of her, gone, like a torn-out page.",
           "EIRWEN: A Rootwarden patrol from the Bough circle went out past the Wall that night. They never came back."])
      speak(:alberica, "...Somebody's got a piece of my life in their pocket.", "...That's mine.")
      say([as(:alberica, "I'd like it back.")])
      set_flag(:leaf_quest)
      side_goal(:leaf, "The chronal leaf: across the Glasswater, through the Auroral Wall.", done: :leaf_restored)
      Stage.cleanup rescue nil
      return
    end
    if ($PokemonBag.pbHasItem?(:FT_CHRONALLEAF) rescue false)
      library_eirwen
      # (notes/10 E20: hand it over, and the one whose life is on it says the last word)
      say(["You give Eirwen the chronal leaf.",
           "EIRWEN: (both hands round it) Oh. It's whole. I can hear her. She's laughing, on it."])
      take_key(:FT_CHRONALLEAF)
      say([cl(:alberica, "...Laughing. Good. I'd hate to be crying on it.")].compact)
      set_flag(:leaf_restored)
      add_counter(:story_beats)
      Stage.cleanup rescue nil
    elsif flag?(:leaf_shattered)
      library_eirwen
      say(["EIRWEN: The pieces... They need mending, and a careful hand. Let me try."])
      if challenge("Help Eirwen mend it.", ["Hold the pieces in the order they hum", "Push them together", "Glue"], 0)
        say(["The pieces hum, find each other, and the leaf is whole. Cracked, but whole.",
             cl(:alberica, "...Cracked's all right. So am I.")].compact)
        set_flag(:leaf_restored)
      else
        say(["Not yet. The pieces don't want to be together yet."])
      end
      Stage.cleanup rescue nil
    end
  end

  # The boat across the Glasswater (to the Wall).
  def glasswater_boat(event_id = nil)
    if flag?(:game_complete)
      # The Wall is down (context 13 M13-8): the boat crosses to where it stood. No Wall, no frozen time.
      say(["An old fisher's boat, half in the reeds. The lake is open water now, all the way north."], event_id)
      return if !pbConfirmMessage(_INTL("Row across, to where the Wall stood?"))
      say(["You row across. Where the Wall stood there's only snow, and the north beyond it."])
      return transfer(2163, 4, 20, 6)
    end
    say(["An old boat in the reeds. The lake is half thawed, half frozen, all of it still."], event_id)
    return if !pbConfirmMessage(_INTL("Row across, to the Auroral Wall?"))
    if flag?(:lake_ghost_rested)
      say(["The ice holds. The water's kind. You cross without a ripple."])
    elsif !challenge("Halfway over, the boat lurches.", ["Lean into it, together", "Stand up", "Row faster"], 0)
      say(["The boat cracks against an ice-shelf. Freezing water. You make the far shore, barely."])
      $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 5), 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    end
    say(["The Auroral Wall stands before you: thin now, a curtain you could put a hand through."])
    return if !pbConfirmMessage(_INTL("Go through the Wall?"))
    if blessing?(:still_sky)
      say(["The Still Ones' blessing holds you. The time-freeze runs off your back like rain."])
    elsif !challenge("The pressure of time on the far side.", ["Breathe slow, and keep walking", "Run", "Hold your breath"], 0)
      al = herald?(:alberica)
      say(["The time-freeze slams into you. Your Pokémon stagger.",
           al ? "(For a breath you're back in the Chasm, hand on the root. Four hundred years at once.)" :
                "ALBERICA: (gasping) ...I was back in the Chasm. My hand on the root. Four hundred years."])
      $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 6), 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    end
    transfer(2163, 4, 20, 6)
  end

  def scene_beyond_wall
    if flag?(:game_complete)
      return if flag?(:wall_site_entered)
      set_flag(:wall_site_entered)
      return sayc(["Where the Wall stood. The snow falls here now, the ordinary way.",
                   "The frozen waves have slumped into the lake. Under the ice, the old village is thawing.",
                   cl(:reptin, "Dougan's Hole. Four hundred years, and it's only weather now.")])
    end
    return if flag?(:beyond_entered)
    set_flag(:beyond_entered)
    add_counter(:story_beats)
    sayc(["The air crystallises in your lungs. Snowflakes hang suspended mid-fall.",
          "Frozen waves crest over the lake. Their mirrored faces hold stars that match no sky.",
          "Beyond, the ruins of an old village slumber under ice.",
          cl(:reptin, "Dougan's Hole. The half the tree didn't swallow."),
          cl(:alberica, "Stay close. If anything replays, don't watch. Ask me how I know.")])
  end

  # Frozen-time hazards: three successes before two failures.
  def time_hazard(n, event_id = nil)
    key = :"time_hazard_#{n}"
    return say(lines_for(:beyond_snow), event_id) if flag?(key) || flag?(:game_complete)
    st = (state[:beyond] ||= { ok: 0, bad: 0 })
    prompt, opts = [["The path forks between two frozen waves.", ["Follow the fence-posts under the ice", "Follow the light", "Climb the wave"]],
                    ["A sound behind you: your own voices, from a moment ago.", ["Keep walking; don't look back", "Turn round", "Answer them"]],
                    ["The snow ahead hangs thicker, a wall of stopped flakes.", ["Part it with your hands, slowly", "Run through", "Go round the long way, over the ice"]]][n - 1]
    set_flag(key)
    if challenge(prompt, opts, 0)
      st[:ok] += 1
      say(["(The way opens.)"])
    else
      st[:bad] += 1
      if n == 2
        say(["A replay, in the air: all of you, a minute ago. One of you looks round, again and again.",
             "It takes the others to drag them out of the loop."])
      else
        say(["The ice under your feet cracks, and grey hands come up through it: ice wights."], event_id)
        skirmish(named_mon(:B92H429, 56, "Ice Wight"), named_mon(:B92H429, 56, "Ice Wight"))
      end
    end
  end

  # B2: the Rootwarden in the ice, clutching the chronal leaf. (notes/10 E19:
  # she's Warden Brisa, she speaks on screen, and she goes home.)
  def frozen_rootwarden(event_id = nil)
    return say(["Only a hollow in the ice, warden-shaped."], event_id) if flag?(:rootwarden_freed) || flag?(:leaf_shattered)
    say(["A Rootwarden encased in ice, mid-step, a hand over her chest.",
         "In her fist, something that catches the light in a hundred colours: a crystal leaf.",
         "Her cloak's clasp: the Bough circle. One of the patrols that went missing beyond the Wall."], event_id)
    fire = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && (%i[FIRE FAIRY].include?(GameData::Move.get(m.id).type) rescue false) } }
    token = ($PokemonBag.pbHasItem?(:FT_FIELDSPIRITS) rescue false)
    if !fire && !token
      return say(["(The ice is old and hard. It needs fire, or radiant light: a Fire- or Fairy-type move.)",
                  "(Or a summer that owes you a favour.)"])
    end
    if fire
      return if !pbConfirmMessage(_INTL("Have {1} melt the ice?", fire.name))
      say(["#{fire.name} melts the ice, slowly, carefully. The warden drops into your arms, breathing."])
    else
      return if !pbConfirmMessage(_INTL("Hold up the Seasons' Token, and call the summer spirit?"))
      say(["The token's green half warms. A hot wind comes from nowhere, smelling of cut grass.",
           "The ice runs off the warden like rain off a roof. She drops into your arms, breathing."])
    end
    ice = stage_event(event_id)
    brisa = ice ? Stage.actor(:warden_brisa, ice.x, ice.y, 4, graphic: "BW030") : nil
    ice.opacity = 0 if ice && brisa rescue nil
    say(["Out of the ice behind her steps a wight of frozen time, with a face like a stopped clock."])
    won = skirmish(named_mon(:B92H429, 58, "Time Wight"))
    if won
      say(["The wight comes apart into seconds, and the seconds fall like snow."])
    else
      say(["The wight lunges for the leaf. It shatters in her fist into a hundred humming pieces.",
           "You gather what you can."])
    end
    # (dialogue 10 §5: she went missing in the autumn just gone; keep her line)
    say(["WARDEN BRISA: ...How long? It was autumn. It was autumn a minute ago."])
    if won
      say(["She opens her fist. The chronal leaf, whole."])
      give_key(:FT_CHRONALLEAF)
    else
      set_flag(:leaf_shattered)
    end
    say(["WARDEN BRISA: Brisa. Of the Bough. ...I can walk. I'll find the wardens' hall.",
         "WARDEN BRISA: Cloaks like ours walked past us to the Wall that night. Tell Kethan."])
    Stage.leave(brisa, 0, brisa.y) if brisa
    set_flag(:rootwarden_freed)
    set_flag(:missing_patrol_found)
  end

  # Warden Brisa, home in the Root-Tier: a witness for the Underdark charge.
  def warden_brisa(event_id = nil)
    if flag?(:brisa_home)
      return say(["WARDEN BRISA: Ten weeks, they tell me. It felt like a minute. Thank you."], event_id)
    end
    say(["WARDEN BRISA: (wrapped in two blankets) You. You pulled me out of the ice.",
         "WARDEN BRISA: Ten weeks, they tell me. It felt like a minute. Thank you."], event_id)
    if flag?(:trials_open) && !flag?(:verdict_heard) && !flag?(:wyn_cleared)
      say(["WARDEN BRISA: Wardens' cloaks walked past us to the Wall. Their breath didn't fog.",
           "WARDEN BRISA: Kethan's put me down to speak at the Rootwarden's hearing. Wyn's, isn't it?"], event_id)
    end
    set_flag(:brisa_home)
  end

  # GQ4: the ruins of Dougan's Hole; the Drowned Hall.
  def drowned_hall_ice(event_id = nil)
    return transfer(2164, 9, 13, 8) if flag?(:hall_ice_broken)
    say(["A mead hall's roof, sunk under the lake ice. Below it, a hall, dark and dry, sealed in.",
         "The ice over the doorway is a yard thick."], event_id)
    mon = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && (%i[FIGHTING FIRE].include?(GameData::Move.get(m.id).type) rescue false) } }
    return say(["(It needs breaking, or melting: a Fighting- or Fire-type move.)"]) if !mon
    return if !pbConfirmMessage(_INTL("Have {1} break the ice?", mon.name))
    say(["#{mon.name} goes at the ice until it gives, all at once, like a dropped plate."])
    set_flag(:hall_ice_broken)
    transfer(2164, 9, 13, 8)
  end

  def temporal_guardian(event_id = nil)
    return say(["The guardian stands at rest, its hands folded over nothing. It nods to you."], event_id) if flag?(:vault_map_3)
    say(["At the hall's far end, a specter in a mail-coat of hours guards a chest under the ice.",
         "TEMPORAL GUARDIAN: (each word a moment early) Turn back. This hall is kept.",
         "TEMPORAL GUARDIAN: What's in it belongs to a time that hasn't finished happening."], event_id)
    c = pbMessage(_INTL("The guardian..."), [_INTL("Promise to keep the timeline whole"), _INTL("Fight it")], 0)
    persuaded = false
    if c == 0
      # (dialogue 10 §6: her flaw, keeping everything, turned into a vow; hers alone)
      if with_or_is?(:alberica)
        say([as(:alberica, "(stepping up) I'm the one the timeline's tied to.")])
        speak(:alberica, "I'll keep it. All of it. I promise.", "...I'll keep it. I promise.")
      end
      persuaded = challenge("Convince it.", ["Show it your tie to the timeline", "Tell it you're Heralds", "Bargain"],
                            flag?(:rootwarden_freed) || with_or_is?(:alberica) ? 0 : [])
    end
    if persuaded
      say(["TEMPORAL GUARDIAN: (a long, long moment) ...Then keep it. It's heavier than it looks."])
    else
      say(["TEMPORAL GUARDIAN: Then I keep it."])
      guard = named_mon(:B92H449, 60, "Temporal Guardian")
      return if !boss_battle(guard)
      say(["The guardian falls, and rewinds, and stands again, smaller.", "TEMPORAL GUARDIAN: ...Once. I can only do that once."])
      return if !boss_battle(named_mon(:B92H449, 57, "Temporal Guardian"))
    end
    say(["The chest opens. Under the frost: a scrap of hide, painted with frost that won't melt.",
         "A fragment of a map: the White Vault. A glacier, north, and a door with wings on it."])
    set_flag(:vault_map_3)
    add_counter(:story_beats)
    grant_blessing(:still_sky, "Blessing of Still Sky", "You keep your footing on ice and snow: no more sliding. (Sap is another matter.)") if !blessing?(:still_sky)
    say(["(Clues to the White Vault: it lies beyond the Wall, under the glacier to the north.)"])
  end

  # GQ4.4: the aurora flickers; get back before the Wall closes.
  def beyond_return(event_id = nil)
    if flag?(:game_complete)
      say(["You walk back south, to the Glasswater's far shore."], event_id)
      return transfer(2078, 26, 12, 4)
    end
    say(["Behind you the aurora flickers. The Wall is closing."], event_id)
    if !challenge("Get back to the Wall!", ["Run together, holding hands", "Every one for themselves", "Wait for it to steady"], 0)
      say(["Too slow. The world stops round you, and something stands up out of the stopped snow."])
      skirmish(named_mon(:B92H429, 57, "Ice Wight"))
      beyond_trapped
    end
    say(["You come through the Wall in a gasp of warm air, onto the Glasswater's far shore."])
    transfer(2078, 26, 12, 4)
  end

  # GQ4: "If trapped, they lose half their god points and require rescue."
  def beyond_trapped
    say(["The aurora closes. The snow stops. Nothing moves, and neither can you.",
         "The wheel in you slows. Whatever the gods put in you runs out like warmth out of a hand."])
    w = (counter(:wheel) rescue 0).to_i
    if w > 0
      add_counter(:wheel, -(w / 2.0).ceil)
      say(["(Half of what the Wheel had given you is gone.)"])
    end
    rescuer = flag?(:missing_patrol_found) ? "Warden Brisa, at the head of a Rootwarden rope-line" :
                                             "a Rootwarden rope-line, Eira's spore-guard glowing at its end"
    say(["Then a rope, and a light: #{rescuer}.",
         "They wade out into the stopped snow after you, one slow step at a time.",
         "They haul you back, hand over hand. It takes them all night. It feels like a second."])
    set_flag(:beyond_rescued)
    trial_work_done if respond_to?(:trial_work_done)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
  end

  #-----------------------------------------------------------------------------
  # R2: Pulse of the Blooming Fields (Reptin)
  #-----------------------------------------------------------------------------
  # One quest, not two: R2 lives in the Blooming Fields from Chapter 6 on
  # (048_Rootspire_D_Quests.rb fields_spirits), and its success sets this
  # blessing and token. Kept as a name for old saves and scripts.
  def field_spirits(event_id = nil)
    fields_spirits(event_id)
  end

  def apply_trial_week_switches
    return if !active? || !$game_switches
    $game_switches[SW_SMUGGLERS] = (flag?(:wyn_joined) || herald?(:wyn)) && !flag?(:undercity_done)
    # Wyn knows the Rootwardens' way down: the dock hatch into the Smuggler's Run (048) opens with her.
    $game_switches[SW_RUN_OPEN] = true if $game_switches[SW_SMUGGLERS]
    $game_switches[SW_ECHO_POCKET] = flag?(:ch7_started)
    $game_switches[SW_GLASSWATER] = flag?(:summer_ended)
    $game_switches[SW_BEYOND_WALL] = flag?(:summer_ended)
    $game_switches[SW_LEAF_SHELF] = flag?(:summer_ended) && !flag?(:leaf_restored)
    $game_switches[SW_BRISA_HOME] = flag?(:rootwarden_freed)
    # (once she's out of the ice, the ice is empty: only the hollow is left)
    if $game_map && $game_map.map_id == 2163 && flag?(:rootwarden_freed)
      ice = $game_map.events.values.find { |e| e.name == "Frozen Rootwarden" }
      ice.character_name = "" if ice
    end
    # (notes/10 E27: Eirwen keeps the Shrine this week; the Library's Eirwen steps out)
    if $game_map && $game_map.map_id == 2062 && $game_switches[SW_EIRWEN_SHRINE]
      lib = $game_map.events.values.find { |e| e.name == "Eirwen Solglass" }
      lib.erase if lib && !lib.instance_variable_get(:@erased)
    end
    $game_switches[SW_FIELD_SPIRITS] = false      # (R2 is 048's Fields event now)
  end
end

#-------------------------------------------------------------------------------
# Battle effects of this week's blessings and items
#-------------------------------------------------------------------------------
if defined?(BattleHandlers) && defined?(BattleHandlers::DamageCalcUserItem)
  BattleHandlers::DamageCalcUserItem.add(:FT_MIRRORBLADE,
    proc { |item, user, target, move, mults, baseDmg, type|
      mults[:base_damage_multiplier] *= 1.2 if type == :STEEL || type == :GHOST
    }
  )
end

if defined?(PokeBattle_Battler)
  class PokeBattle_Battler
    # Alerion's Reflection: no confusion on your side.
    if method_defined?(:pbCanConfuse?)
      alias ft_w4_pbCanConfuse? pbCanConfuse? unless method_defined?(:ft_w4_pbCanConfuse?)
      def pbCanConfuse?(user = nil, showMessages = true, move = nil, selfInflicted = false)
        if FrostThaw.active? && FrostThaw.blessing?(:reflection) && FrostThaw.ft_player_side?(self) && !fainted?
          @battle.pbDisplay(_INTL("{1} knows its own mind! It won't be confused!", pbThis)) if showMessages
          return false
        end
        ft_w4_pbCanConfuse?(user, showMessages, move, selfInflicted)
      end
    end
  end
end

# The Fields' Two Spirits: the first Fire- or Ice-type hit on your side each battle is halved.
if defined?(PokeBattle_Move) && PokeBattle_Move.method_defined?(:pbCalcDamageMultipliers)
  class PokeBattle_Move
    alias ft_w4_pbCalcDamageMultipliers pbCalcDamageMultipliers unless method_defined?(:ft_w4_pbCalcDamageMultipliers)
    def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
      ft_w4_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
      begin
        if FrostThaw.active? && FrostThaw.blessing?(:field_spirits) && FrostThaw.ft_player_side?(target) &&
           (type == :FIRE || type == :ICE) && !@battle.instance_variable_get(:@ft_spirits_used)
          multipliers[:final_damage_multiplier] *= 0.5
          @battle.instance_variable_set(:@ft_spirits_used, true)
          @battle.pbDisplay(_INTL("The Fields' two spirits turn the blow aside!"))
        end
      rescue StandardError
      end
    end
  end
end

# The Spore Dream: thrown in battle, it confuses the target.
if defined?(ItemHandlers::BattleUseOnBattler)
  ItemHandlers::CanUseInBattle.add(:FT_SPOREDREAM, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
    next true
  }) if defined?(ItemHandlers::CanUseInBattle)
  ItemHandlers::UseInBattle.add(:FT_SPOREDREAM, proc { |item, battler, battle|
    foe = battle.battlers.find { |b| b && !b.fainted? && b.opposes?(battler) } rescue nil
    if foe && foe.pbCanConfuse?(battler, false)
      foe.pbConfuse(_INTL("{1} is lost in a spore dream!", foe.pbThis))
    else
      battle.pbDisplay(_INTL("The spore dream drifts away."))
    end
  }) if defined?(ItemHandlers::UseInBattle)
end

# Yarro's frostbite tincture: like the Sap-Skin Salve (60 HP, and thaws).
if defined?(ItemHandlers::UseOnPokemon)
  ItemHandlers::UseOnPokemon.copy(:FT_SAPSALVE, :FT_FROSTBITETINCTURE) rescue nil
  ItemHandlers::BattleUseOnPokemon.copy(:FT_SAPSALVE, :FT_FROSTBITETINCTURE) rescue nil
  ItemHandlers::CanUseInBattle.copy(:FT_SAPSALVE, :FT_FROSTBITETINCTURE) rescue nil if defined?(ItemHandlers::CanUseInBattle)
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_trial_week_switches
  rescue StandardError => err
    FrostThaw.log("Trial week switches failed: #{err.message}")
  end
}
