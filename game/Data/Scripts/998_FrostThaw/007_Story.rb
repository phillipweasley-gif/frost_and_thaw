#===============================================================================
# Frost & Thaw - what map events call
#
#   FT.talk(:key, @event_id)       an NPC or sign speaks
#   FT.trainer(:key, @event_id)    a trainer battle (sets self switch A on a win)
#   FT.scene(:key, @event_id)      a one-time cutscene (sets self switch A)
#   FT.gym_leader(:key, @event_id) a gym leader
#   FT.mart(:key, @event_id)       a shop
#===============================================================================
module FrostThaw
  MARTS = {
    targos: [:POKEBALL, :POTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING, :ESCAPEROPE, :REPEL]
  }

  module_function

  # Each "NAME: line" gets a speech bubble pointing at that character, found by
  # name on the map (WRITING_GUIDE §9a: speakers are on screen). A speaker who
  # isn't on the map, or is outside the camera, is noted once per map in the
  # log so the staging sweep can find them.
  def say(lines, event_id = nil)
    Array(lines).flatten.compact.each do |line|
      begin
        tag = line[/\A([A-Z][A-Z'\- ]*[A-Z]):/, 1]
        if tag
          ev = Stage.speaker(tag, event_id)
          mate = COMPANION_NAMES.key(tag)
          if !ev && mate && companions.include?(mate)
            ev = Stage.summon(mate)           # a companion walks in beside you to speak
          elsif !ev && !mate && event_id && event_id > 0
            # someone without a name of their own on the map (a townsperson whose
            # line says FISHER:): the person you're talking to. Never a companion.
            e = $game_map.events[event_id]
            ev = e if e && !e.character_name.to_s.empty? && e.name.to_s !~ Stage::NOT_SPEAKERS
          end
          if ev && Stage.on_screen?(ev)
            pbCallBub(2, ev.id)
          elsif ev
            note_offstage(tag, :off_camera)      # (no bubble: it would point off the screen)
          else
            note_offstage(tag, :absent)
          end
        end
      rescue StandardError
      end
      pbMessage(_INTL(line))
    end
  end

  # Speakers who talked without being seen (for the staging sweep). The player
  # speaking as their own Herald is on screen by definition.
  def note_offstage(tag, why)
    return if ($Trainer.name.to_s.upcase == tag rescue false)
    @offstage ||= {}
    key = [($game_map.map_id rescue 0), tag, why]
    return if @offstage[key]
    @offstage[key] = true
    log("Off-stage speaker: #{tag} (#{why}) on map #{key[0]}")
  end

  def offstage_speakers
    (@offstage || {}).keys
  end

  # A Herald's line, shown now. When you are playing that Herald and a quieter
  # version is given, you pick how to say it (the Voices tab: loud or soft, but
  # always as them). Returns 0 for the first line, 1 for the quiet one, so a
  # scene can let others react. Call it as its own statement, between say()s.
  def speak(key, loud, quiet = nil, event_id = nil)
    if herald?(key) && quiet
      short = lambda do |t|
        t = t.sub(/\A\([^()]*\)\s*/, "")
        t.length > 40 ? t[0, 38].rstrip + "..." : t
      end
      c = (pbMessage(_INTL("(You say...)"), [short.call(loud), short.call(quiet)], -1) rescue 0)
      c = 0 if !c || c < 0
      say([as(key, c == 1 ? quiet : loud)], event_id)
      return c == 1 ? 1 : 0
    end
    say([as(key, loud)], event_id)
    0
  end

  # map_id: the map the event is on. Give it when the player may have left the
  # map in between (losing a battle sends you to a Pokémon Center).
  def set_self_switch(event_id, letter = "A", value = true, map_id = nil)
    return if !event_id || !$game_map
    $game_self_switches[[map_id || $game_map.map_id, event_id, letter]] = value
    $game_map.need_refresh = true
  end

  def talk(key, event_id = nil)
    say(lines_for(key), event_id)
  rescue StandardError => e
    log("talk(#{key}) failed: #{e.message}")
  end

  def trainer(key, event_id = nil)
    data = TRAINERS[key]
    return log("Unknown trainer #{key}") if !data
    type, name = data[0], data[1]
    won = pbTrainerBattle(type, name, nil, false, 0)
    if won
      set_self_switch(event_id, "A")
      add_counter(:trainers_beaten)
    end
    return won
  rescue StandardError => e
    log("trainer(#{key}) failed: #{e.message}")
    return false
  end

  def mart(key, event_id = nil)
    return torrga_refusal(key, event_id) if respond_to?(:torrga_refuses?) && torrga_refuses?(key)
    stock = (MARTS[key] || MARTS[:targos]).dup
    stock.insert(1, :DNASPLICERS) if flag?(:badge_targos) && !stock.include?(:DNASPLICERS)   # Twinning, after Naerth's seal
    pbPokemonMart(stock)
  rescue StandardError => e
    log("mart(#{key}) failed: #{e.message}")
  end

  #-----------------------------------------------------------------------------
  # Cutscenes
  #-----------------------------------------------------------------------------
  def scene(key, event_id = nil)
    set_self_switch(event_id, "A")     # first, so a scene never repeats by accident
    case key
    when :intro              then intro
    when :targos_arrival     then scene_targos_arrival
    when :tavern_convergence then scene_tavern_convergence
    else
      meth = "scene_#{key}"
      if respond_to?(meth)
        method(meth).arity == 0 ? send(meth) : send(meth, event_id)
      else
        log("Unknown scene #{key}")
      end
    end
  rescue StandardError => e
    log("scene(#{key}) failed: #{e.class}: #{e.message}")
  end

  SW_PARTY_FORMED = 3961   # the Heralds have met: their tavern NPCs are gone (they travel with you)
  SW_NAERTH_TERMS = 3963   # Naerth has set his terms at the Luskan Arms: he's back in the Town Hall
  # After the seal: rest first (the carved cat, SC 1.07), then the road.
  TARGOS_REST_GOAL = "Rest at Three Flags Sailing; Ma Yarbroul keeps the fire. Then out the south-west gate."
  TARGOS_ROAD_GOAL = "The south-west gate is open. Bryn Shander is south-east along the road, and Dougan's Hole beyond it."

  # SC 1.01 - Out of the air. Where and when you are, and the three who find
  # you on the pier, walking in and off on screen (context/01.md B1, HB1, HB3).
  def scene_targos_arrival
    return if respond_to?(:loop_skip) && loop_skip(:act1)      # (in the Still Keeper's loop: "I remember this")
    apply_herald_switches
    if herald?(:meat_meat)
      say(["From behind the hay bales you watch the docks. Strangers are coming up from the ships."])
      stage_strangers_pass
      say(["A dwarf, an elf, an eladrin with a frosted ring. Two smugglers who walk like they own it.",
           "One by one, they all head for the same warm light: Three Flags Sailing.",
           "(Cold things in their pockets. Cold like the lab. Meat Meat follows cold things.)",
           "(Strangers have ships. Strangers have ways out. Also food. Maybe coffee.)"])
      state[:goal] = "Follow the cold strangers. They're going to Three Flags Sailing."
      set_flag(:arrived_targos)
      return
    elsif journey? || herald?(:wyn)
      if journey?
        pbBGMStop rescue nil                     # wind only, for the landing
        Stage.hop($game_player)
        say(["You land on frozen planks.",
             "Your hand is still closed round something: a shard of the lantern's glass.",
             "It's colder than the snow.",
             "Behind you, somewhere very far away, Tamsin is still saying your name."])
        give_key(:FT_LANTERNGLASS) rescue nil
        $game_map.autoplay rescue nil
      end
      Stage.face($game_player, 8)
      Stage.wait(10)
      say(["Snow, everywhere. The sky has no sun in it at all.",
           journey? ? "Targos, in Icewind Dale. The winter from Hellen's stories, and you're standing in it." :
                      "(Targos. A name from the old songs. ...Sableye, I think we fell into a history lesson.)"])
      stage_pier_welcome
    else
      say(["Five travellers come down three gangplanks on the same night. None of you planned it.",
           "All of you look up at the same moment, as if something called your names.",
           "Warm light spills from a tavern along the docks: Three Flags Sailing.",
           as(:alberica, "Is that a tavern? That's a tavern. Out of my way, I want the stool by the fire."),
           as(:reptin, "(watching the dwarf go) First sensible thing anyone's said in Targos.")])
    end
    state[:goal] = "Get out of the cold. Three Flags Sailing, up the hill."
    set_flag(:arrived_targos)
  end

  # The pier (x 33, y 19-24) meets the shore at y 25. Alerion walks up it and
  # catches your arm; Shimmer and Alberica pass along the shore, heading west
  # for the tavern; then Alerion goes after them.
  def stage_pier_welcome
    alerion = Stage.actor(:alerion, 33, 25, 8)
    Stage.walk_to(alerion, 33, 22, face: 8) if alerion
    Stage.face($game_player, 2)
    say(["A pale elf catches your arm. The ring on his hand is white with frost.",
         "ALERION: You fell out of the air.",
         "ALERION: ...Nobody else saw. Keep it that way."])
    shimmer = Stage.actor(:shimmer, 37, 25, 4)
    Stage.walk_to(shimmer, 34, 25, face: 8) if shimmer
    Stage.emote(shimmer, :exclaim) if shimmer
    say(["SHIMMER: I saw. Tavern's west, up the hill. Whatever you are, you'll freeze like us."])
    Stage.leave(shimmer, 26, 25) if shimmer
    alberica = Stage.actor(:alberica, 37, 25, 4)
    Stage.walk_to(alberica, 34, 25, face: 8) if alberica
    say([journey? ? "ALBERICA: (sea-bag, lute on her back) Pretty boy's found a stray! Can we keep it?" :
                    "ALBERICA: (sea-bag, lute on her back) Pretty boy's found someone! Can we keep them?"])
    Stage.leave_all([alberica, alerion].compact, 26, 25)
    Stage.cleanup
  end

  # Meat Meat watches the five come up from the ships and along the shore to
  # the tavern (00.md H4: the hay prologue no longer tells it first).
  def stage_strangers_pass
    walkers = %i[alberica reptin alerion shade shimmer].each_with_index.map do |k, i|
      Stage.actor(k, 33, 24 - i, 2)                  # in a line down the pier
    end.compact
    Stage.leave_all(walkers, 16, 18)
    Stage.cleanup
  rescue StandardError => e
    log("stage_strangers_pass: #{e.message}")
  end

  # SC 1.02 - The woman in frost-furs, then SC 1.03 - Five cold things
  def scene_tavern_convergence
    outsider = journey? || herald?(:wyn)
    say(["A fire that barely warms. Five strangers at five tables."])
    # Meat Meat is in the room before the woman comes in (context/01.md HB3).
    if herald?(:meat_meat)
      say(["You slip in behind them and find a shadow by the wall.", "Nobody notices a goblin in a shadow.",
           "SHADE: ...Except me. Hands where I can see them, little one.",
           "SHADE: Sit. You're shaking worse than we are.",
           "(The smuggler smells like the sea. Meat Meat decides not to bite the smuggler. Yet.)"])
    end
    stage_frost_furs_enters
    ma = Stage.find("Barkeep")
    say(["MA YARBROUL: Drinks are on the house, ducks. Please leave tomorrow.",
         as(:alberica, "Free drinks. See? The night's turning around already."),
         as(:reptin, "(to the barkeep) That's very generous, thank you. We'll be gone by noon."),
         as(:reptin, "Probably. Ask me again after the drinks.")], ma && ma.id)
    Stage.pan_to(10, 8)              # the whole room in view: you by the door, Shimmer by the far wall
    say(["SHADE: Well. That was a terrible omen. I'm Shade.", "SHADE: This is my sister, Shimmer. We're in shipping.",
         "SHIMMER: Smuggling.",
         "SHADE: Smuggling is a kind of shipping."])
    if herald?(:meat_meat)
      speak(:meat_meat, "Meat Meat.", "...Meat Meat.")
      say(["SHADE: ...Is that one name or two?",
           as(:meat_meat, "One name. Twice. So nobody forgets Meat Meat.")])
    end
    speak(:alberica, "Alberica. I sing, I drink, and I'm told I'm a terrible influence.",
          "...Alberica. I sing.")
    # The recognition: only the player knows who these five are (context/01.md B2, HB1).
    if outsider
      Stage.emote($game_player, :exclaim)
      Stage.turn_to($game_player, Stage.find("Alberica"))
      say([journey? ? "Alberica. The one with the lute, on Hellen's wall." :
                      "(Alberica. With the lute. ...Oh. Oh, no. I know this song.)"])
    end
    say(["She sets a pendant of black ice on the table.",
         as(:alberica, "I threw this in the sea three weeks ago. It came back."),
         as(:alberica, "Most things I throw out don't come back. Men, mostly."),
         as(:reptin, "Reptin. I talk us into places and, now and then, out of them."),
         journey? ? "Reptin. The wolf." : nil,
         "A frost-etched medallion, beside the pendant.",
         as(:reptin, "Someone left this for me. No name, no note. Rude, frankly."),
         "A silver ring, rimed white, beside that.",
         as(:alerion, "Alerion. It was on a dock rail. It's cold. That's all I know."),
         herald?(:alberica) ? "(That's all? Pretty boy, you have to give us more than that.)" :
                              "ALBERICA: That's all? Pretty boy, you have to give us more than that."].compact)
    speak(:alerion, "No I don't.", "...That's all I have. Sorry.")
    say(["SHADE: And this turned up in my boot. I don't own boots this nice.",
         "A pale dagger, smoking with cold.",
         "SHIMMER: I've got a stone. It's under my ribs. Don't ask.",
         as(:alberica, "Oh, now I have to ask."),
         "SHIMMER: Don't.",
         "Old things, cold things. Relics, the Dale calls them."])
    stage_relics_hum
    say(["Four relics on the table, and the stone under Shimmer's ribs makes five.", "They hum together, like a chord.",
         as(:reptin, "They know each other. That's either very good news or the start of a ghost story."),
         as(:alerion, "Ghost story."),
         as(:alberica, "I don't need it to make sense. I need it to stop."),
         as(:alberica, "...And I need another drink.")])
    if outsider
      say([journey? ? "...They're the Heralds. And nobody's carved them yet." :
                      "(Every lantern in Rootspire is lit for them. They're sitting by the worst fire in Targos.)",
           "SHADE: (to you) And you? You came off no ship I saw."])
      c = pbMessage(_INTL("What do you do?"), [_INTL("Show your Pokémon"), _INTL("\"I'm from somewhere else.\""), _INTL("Say nothing")], -1)
      case c
      when 1
        say([as(:alerion, "Clearly."),
             as(:alberica, "Ignore him, he's like that with everyone. It's part of the charm. Allegedly.")])
        set_flag(:told_somewhere)
      when 2
        say(["SHIMMER: Good. Keep doing that.",
             as(:alberica, "She likes you. That's how you can tell.")])
        set_flag(:told_nothing)
        set_flag(:shimmer_warm)
      else
        mon = ($Trainer.party[0] rescue nil)
        if mon
          Stage.cry(mon.species)
          say(["You hold up #{mon.name}. It blinks at the fire, and at all of them."])
        end
        say([as(:reptin, "Good instinct. Nobody distrusts someone with a Pokémon that cute."),
             as(:reptin, "(to your Pokémon) Hello, little ambassador.")])
        set_flag(:told_nothing)
      end
    end
    # Meat Meat's want, said to people who can help.
    if herald?(:meat_meat)
      speak(:meat_meat, "Meat Meat is looking for Razzy. Small. Goblin. Went out the gate tonight.",
            "...Razzy. Small goblin. Went out the gate.")
      say(["SHIMMER: (quietly) Small ones don't last out there. We'll look."])
    end
    say(["SHADE: Relic dealer by the south-west wall. Epheris. He's cheated better people than us."])
    speak(:reptin, "Leave the talking to me. Epheris will love me. Everybody does, eventually.",
          "I'll talk to him. Politely.")
    say([as(:alerion, "Everybody leaves eventually, too."),
         as(:alberica, "(raising a mug) To bad omens and free drinks."),
         herald?(:alerion) ? "Shimmer touches her mug to Alberica's without looking up. After a moment, so do you." :
                             "Shimmer touches her mug to Alberica's without looking up. Alerion, after a moment, does too."])
    # Together, then: the one who'd organise it says so, and the five walk out
    # ahead of you (context/01.md B3).
    shade = Stage.find("Shade")
    Stage.hop(shade) if shade
    say(["SHADE: Nobody walks Targos alone tonight. Epheris first, all of us."])
    Stage.leave_all(%w[Alberica Reptin Alerion Shade Shimmer].map { |n| Stage.find(n) }.compact, 6, 12)
    Stage.pan_back
    pbSEPlay("Door exit") rescue nil
    state[:companions] = [:alberica, :reptin, :alerion, :shade, :shimmer]
    state[:goal] = "Ask Epheris, the relic dealer, what the relics are."
    set_flag(:met_party)
    set_switch(SW_PARTY_FORMED, true)
    say(["(Tip: choose Heralds in the menu to hear what your companions think, wherever you are.)"])
  end

  # SC 1.02, staged: the woman in frost-furs walks in, looks at each of them,
  # and goes out as frost (P-AUR-04, B-06, E-01).
  def stage_frost_furs_enters
    s = Stage
    pbSEPlay("Door exit") rescue nil
    $game_screen.start_flash(Color.new(220, 235, 255, 120), 10) rescue nil
    auril = s.actor(:auril_furs, 6, 12, 8)
    say(["The door opens and lets the night in. A woman in furs that shine with frost."])
    if auril
      s.walk(auril, PBMoveRoute::Up, PBMoveRoute::Up, PBMoveRoute::Up, PBMoveRoute::Up,
             PBMoveRoute::Right, PBMoveRoute::Right)
    end
    say(["She doesn't go to the bar. She doesn't go to the fire."])
    %i[alberica reptin alerion shimmer].each do |k|
      ev = herald?(k) ? $game_player : s.find(k.to_s.capitalize)
      next if !ev
      s.face(auril, ev.x < auril.x ? 4 : ev.x > auril.x ? 6 : (ev.y < auril.y ? 8 : 2)) if auril
      s.balloon(ev, "B-06")
      s.wait(14)
    end
    say(["She looks at each of them in turn.",
         [herald?(:alberica) ? "Your hand goes to your throat." : "Alberica's hand goes to her throat.",
          herald?(:reptin) ? "Your medallion fogs." : "Reptin's medallion fogs."].join(" "),
         [herald?(:alerion) ? "Your ring cracks with rime." : "Alerion's ring cracks with rime.",
          "Shimmer stops breathing."].join(" ")])
    say(["(Ring's colder than it gets near the dead. That's new.)"]) if herald?(:alerion)
    if auril
      s.face(auril, 4)
      s.balloon($game_player, "B-06")
      s.wait(30)
    end
    outsider = journey? || herald?(:wyn)
    say(["Then she looks at you.", "She tilts her head, like you're a word in a language she almost knows."]) if outsider
    say(["She looks at you last, and longest."]) if herald? && !herald?(:wyn)
    say(["She smiles. Not warm. Not kind."])
    if auril
      s.fx("E-01", auril, frames: 10, hold: true, wait: false)
      s.pose(auril, "P-AUR-04", 0, per: 7)
      s.hide(auril)
      s.wait(20)
    end
    say(["The frost stays on the floor where she stood. The door swings shut on nothing."])
    s.cleanup
  rescue StandardError => e
    log("stage_frost_furs_enters: #{e.message}")
    Stage.cleanup rescue nil
  end

  # The four relics and Shimmer's stone hum together: a chill over each of them.
  def stage_relics_hum
    %i[alberica reptin alerion shimmer].each do |k|
      ev = herald?(k) ? $game_player : Stage.find(k.to_s.capitalize)
      Stage.balloon(ev, "B-06", frames: 40) if ev
    end
    shade = Stage.find("Shade")
    Stage.balloon(shade, "B-06", frames: 40) if shade
    Stage.wait(30)
  rescue StandardError => e
    log("stage_relics_hum: #{e.message}")
  end

  # SC 1.07 - The one we lost (rest at the tavern after the gym)
  def barkeep(event_id = nil)
    if !flag?(:badge_targos)
      return say(lines_for(:barkeep), event_id)
    end
    if flag?(:heard_of_glimmer)
      return say(["MA YARBROUL: Leaving tomorrow, I hope. For your sakes, not mine. Eat first."], event_id)
    end
    say(["MA YARBROUL: Leaving at first bell, by the look of you. There's no first light. Not here.",
         "MA YARBROUL: One more night by the fire?"], event_id)
    return if !pbConfirmMessage(_INTL("Rest at Three Flags Sailing?"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    long_rest_taken if respond_to?(:long_rest_taken)
    say(["Late. The fire's down to coals.",
         as(:alberica, "(stretched out along a bench) Night, pretty boy. Dream of me."),
         as(:alerion, "I don't dream."),
         as(:alberica, "Then think of me. Same thing, done awake."),
         as(:reptin, "(face in his cloak) Goodnight, everyone. Please. Goodnight."),
         "Across the hearth, Shimmer turns a little carved wooden cat over and over in her fingers.",
         "SHADE: She does that when she's scared.",
         "SHIMMER: I'm not scared. I'm counting.",
         "SHIMMER: Shade carved it when we were kids. Terrible cats. Shade always wanted to be one.",
         "SHADE: I still do. Cats land on their feet.",
         "SHIMMER: Cats get nine lives. You've used about six.",
         "SHADE: (quietly) Saltmarsh was one of them. Yours, not mine.",
         "SHIMMER: ...Go to sleep, Shade."])
    set_flag(:heard_of_glimmer)
    state[:goal] = TARGOS_ROAD_GOAL if state[:goal] == TARGOS_REST_GOAL
  end

  # SC 1.05 - Everyone owes me something (Naerth at the Luskan Arms)
  def naerth_terms(event_id = nil)
    if !flag?(:met_party)
      return say(["NAERTH: Strangers. I see a great many strangers, and they all want something from me.",
                  "NAERTH: Go and get warm first. Then we'll talk."], event_id)
    end
    naerth = event_id && $game_map.events[event_id]
    Stage.arrive(%i[reptin shimmer alberica], 9, 11)      # they come in with you (context/01.md B6)
    count = journey? || herald?(:wyn) || herald?(:meat_meat) ? "Six" : "Five"
    # The party asks for something, so Naerth's terms answer someone (dialogue/01.md).
    speak(:reptin, "Speaker. We'd like to leave Targos. Quietly, and soon.",
          "Speaker. We'd like to leave. Quietly.", event_id)
    say(["NAERTH: Everyone would. #{count} strangers in a blizzard. Shall we speak plainly?",
         "NAERTH: Here is how Targos works. Everyone owes me something.",
         "NAERTH: Each new moon, Targos draws a name. So do Bryn Shander and Easthaven.",
         as(:reptin, "(quietly) And everyone thanks him for the privilege. Charming.")], event_id)
    # What the lottery is for, and whose name it is (context/01.md B4).
    if journey?
      say(["NAERTH: Whoever's drawn walks out onto the ice, for Auril."], event_id)
      Stage.emote(naerth, :question) if naerth
      say(["NAERTH: (to you) You don't know Auril? Where did you say you were from?",
           "SHIMMER: Somewhere warm. Leave it.",
           "NAERTH: Auril. The Frostmaiden. Winter's own goddess. She's had two years of names."], event_id)
    else
      say(["NAERTH: Whoever's drawn walks onto the ice, for Auril, winter's goddess. Two years now."], event_id)
    end
    say(["NAERTH: Some people pay to keep their names off the board. Lately, they get found. Frozen.",
         "NAERTH: By a man who doesn't feel the cold.",
         "SHIMMER: Sephek.",
         "NAERTH: ...You know his name. Interesting.",
         "NAERTH: My seal says you aren't running. Earn it. Town Hall. I'll be waiting.",
         journey? && flag?(:glass_read) ? "NAERTH: And the stray wants Dougan's Hole. Everyone wants something." : nil,
         as(:alberica, "Men like him are always waiting. It's the only exercise they get."),
         herald?(:meat_meat) ? "(The gate. Razzy got out. Razzy is small. Meat Meat is not small enough.)" : nil].compact,
        event_id)
    set_flag(:naerth_terms)
    state[:goal] = flag?(:relics_are_lures) ? "Win Speaker Naerth's seal at the Town Hall. It opens the south-west gate." :
                                              "Ask Epheris what the relics are, then win Naerth's seal at the Town Hall."
    set_switch(SW_NAERTH_TERMS, true)
    Stage.leave(naerth, 9, 12) if naerth && Stage.map?   # off to the Town Hall, ahead of you
  end

  def apply_chapter1_switches
    return if !active? || !$game_switches
    set_switch(SW_PARTY_FORMED, flag?(:met_party)) if $game_switches[SW_PARTY_FORMED] != flag?(:met_party)
    set_switch(SW_NAERTH_TERMS, flag?(:naerth_terms)) if $game_switches[SW_NAERTH_TERMS] != flag?(:naerth_terms)
  end

  #-----------------------------------------------------------------------------
  # Gym leaders
  #-----------------------------------------------------------------------------
  def gym_leader(key, event_id = nil)
    meth = "leader_#{key}"
    respond_to?(meth) ? send(meth, event_id) : log("Unknown gym leader #{key}")
  rescue StandardError => e
    log("gym_leader(#{key}) failed: #{e.class}: #{e.message}")
  end

  # SC 1.06 - Gym 1: Speaker Naerth
  def leader_naerth(event_id)
    if flag?(:badge_targos)
      return naerth_splicers(event_id) if !flag?(:got_splicers)    # saves from before he gave them out
      say(["NAERTH: You have my seal. Don't make me regret it.",
           "NAERTH: And mind the north road. There's a killer in the Dale. Auril's own, some say.",
           "NAERTH: Sephek Kaltro. If you meet him, you never had my seal."], event_id)
      return
    end
    if !flag?(:naerth_terms)
      return naerth_terms(event_id)
    end
    Stage.arrive(%i[alberica reptin alerion], 10, 19)    # they come up the hall with you (context/01.md B6)
    lines = ["NAERTH: Everyone in this town fights for me. Let's see who you fight for."]
    if herald?(:reptin)
      lines.unshift("NAERTH: Reptin of the Sacred Flame. I hear things about you. Useful things.",
                    "NAERTH: An exile who fixes things. Targos has a great many things that need fixing.")
    end
    lines << if herald?(:reptin) then "(Diplomacy is just threatening people politely. Time to be very polite.)"
             elsif herald?(:alberica) then "(Knock his crown off. Then write a song about it. A rude one.)"
             else "ALBERICA: Knock his crown off, sweetheart. I'll sing about it after."
             end
    say(lines, event_id)
    won = pbTrainerBattle(:FT_SPEAKER, "Naerth", nil, false, 0)
    if won
      $Trainer.badges[0] = true
      set_flag(:badge_targos)
      $game_switches[3910] = true if $game_switches     # the Targos gate guards step aside
      say(["NAERTH: Fine. You're not running. You're walking toward something. That's worse.",
           "NAERTH: Here. My seal. Any guard on the lake will let you pass."], event_id)
      pbMessage(_INTL("\\me[Badge get]{1} received the Speaker's Seal!", $Trainer.name))
      say([as(:reptin, "Thank you, Speaker. We'll treasure it."),
           as(:reptin, "(quietly) Right up to the gate.")], event_id)
      pbReceiveItem(:TM46) rescue nil
      say(["NAERTH: That TM teaches Thief. Fitting, for this town.",
           "NAERTH: One more thing, free.",
           "NAERTH: A lady in a tower pays very well for cold trinkets like yours.",
           "NAERTH: Pale. Books and bones. If you meet her, you never met me.",
           as(:alerion, "We never met you. That part's easy.")], event_id)
      naerth_splicers(event_id)
      state[:goal] = flag?(:heard_of_glimmer) ? TARGOS_ROAD_GOAL : TARGOS_REST_GOAL
    end
  end

  # Twinning: Naerth hands over a few DNA Splicers, and from then on the
  # shops stock them.
  def naerth_splicers(event_id)
    say(["NAERTH: My last one was two in one skin. Twinning, the traders call it.",
         "NAERTH: You're going into the Dale. Take these. DNA Splicers: two Pokémon in, one out."], event_id)
    pbReceiveItem(:DNASPLICERS, 3)
    say(["NAERTH: Use them from your Bag, on two of your Pokémon. Splice again to pull them apart.",
         "NAERTH: Triglio's shop stocks them now. He'll still charge you."], event_id)
    set_flag(:got_splicers)
  end

  #-----------------------------------------------------------------------------
  # Party chat ("Heralds" in the pause menu)
  #-----------------------------------------------------------------------------
  def party_chat_available?
    return active? && !companions.empty?
  end

  def party_chat
    area = AREAS[$game_map.map_id]
    people = companions.select { |c| PARTY_CHAT[c] }
    if people.empty?
      pbMessage(_INTL("Nobody is travelling with you right now."))
      return
    end
    pbMessage(_INTL("Where we're headed: {1}", state[:goal])) if state[:goal]
    show_witnesses if flag?(:trials_open) && !flag?(:ch10_done) && respond_to?(:show_witnesses)
    labels = people.map { |c| COMPANION_NAMES[c].split(" ").map(&:capitalize).join(" ") } + [_INTL("Never mind")]
    loop do
      i = pbMessage(_INTL("Who do you want to talk to?"), labels, labels.length - 1)
      break if i < 0 || i >= people.length
      c = people[i]
      lines = resolve(PARTY_CHAT[c][area]) || [_INTL("...Nothing to say about this place. Yet.")]
      lines.each { |l| pbMessage(_INTL("{1}: {2}", COMPANION_NAMES[c], l)) }
    end
  end
end

module FrostThaw
  module_function

  # Side quests keep their own lines under the story's Goal (fix plan step 3):
  # a side quest never overwrites where the story goes next, and nothing has to
  # "restore" it afterwards. done: a flag (or flags); once any is set, the line
  # is gone by itself.
  def side_goal(key, text, done: nil)
    (state[:side_goals] ||= {})[key] = [text, Array(done)]
  end

  def side_goal_done(key)
    (state[:side_goals] ||= {}).delete(key)
  end

  # Act I's side goals live in Icewind Dale. After the fall (act1_done) you can't
  # reach them, so they leave the Goal menu (context 14, top 5 #2).
  ACT1_SIDE_GOALS = %i[razzy way_home mugs mead election climb mine moose]

  def side_goals
    (state[:side_goals] || {}).reject { |k, (_t, done)|
      done.any? { |f| flag?(f) } || (flag?(:act1_done) && ACT1_SIDE_GOALS.include?(k))
    }.values.map(&:first)
  end
end

class PokemonPauseMenu_Scene
  alias ft_orig_pbShowCommands pbShowCommands unless method_defined?(:ft_orig_pbShowCommands)
  # Two entries of ours after the player's: "Goal" (where the story goes next,
  # whenever there is one) and "Heralds" (party chat, once anyone travels with you).
  def pbShowCommands(commands)
    extras = []
    goal = (FrostThaw.active? && FrostThaw.state[:goal]) rescue nil
    sides = (FrostThaw.active? && FrostThaw.side_goals) rescue []
    extras << [:goal, "  <icon=menuIcons/PLAYER>  " + _INTL("Goal")] if (goal.is_a?(String) && !goal.empty?) || !sides.empty?
    extras << [:heralds, "  <icon=menuIcons/PLAYER>  " + _INTL("Heralds")] if FrostThaw.party_chat_available?
    return ft_orig_pbShowCommands(commands) if extras.empty?
    player_entry = commands.index { |c| c.to_s.include?("menuIcons/PLAYER") } || (commands.length - 1)
    ours = player_entry + 1
    with_ours = commands.dup
    with_ours.insert(ours, *extras.map { |e| e[1] })
    loop do
      ret = ft_orig_pbShowCommands(with_ours)
      if ret >= ours && ret < ours + extras.size
        pbPlayDecisionSE rescue nil
        pbHideMenu
        case extras[ret - ours][0]
        when :goal
          g = FrostThaw.state[:goal]
          pbMessage(_INTL("Goal: {1}", g)) if g.is_a?(String) && !g.empty?
          FrostThaw.side_goals.each { |t| pbMessage(_INTL("Also: {1}", t)) }
        when :heralds then FrostThaw.party_chat
        end
        pbShowMenu
        next
      end
      return (ret >= ours + extras.size) ? ret - extras.size : ret
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter1_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 1 switches failed: #{err.message}")
  end
}
