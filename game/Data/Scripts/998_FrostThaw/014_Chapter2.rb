#===============================================================================
# Frost & Thaw - Act I, Chapter 2: Razzy
#
# The North Road out of Targos, the Frost-Light Chasm where Razzy falls and his
# chrysalis becomes an egg, and Bryn Shander (map 1.2 of the book), where
# Speaker Duvessa Shane, young, honest and head of the Council of Speakers,
# holds the Town Hall (Gym 2, Steel / Normal) and draws the lottery she hates.
#
# Story beats follow the campaign record in the Story Bible: Razzy, voiceless
# (Avarice took it), falls into a chasm of frost-light; his body turns into a
# moon-touched chrysalis; Reptin's blood and Shade's unicorn horn turn it into
# an egg. The last part of the rite, his name spoken as a promise, waits for
# Meat Meat (Chapter 3), and the egg hatches at the Verdant Reversal.
#===============================================================================
module FrostThaw
  SW_ROAD_OPEN   = 3910    # Targos gate guards step aside (Naerth's seal)
  SW_BRYN_BADGE  = 3912    # Bryn Shander's seal won (Sephek's appearance waits on it)

  MAPS.merge!(north_road: 2010, chasm: 2011, bryn: 2012, bryn_center: 2013, bryn_mart: 2014,
              bryn_gym: 2015, northlook: 2016, bryn_house_a: 2017, bryn_house_b: 2018)

  MAP_NAMES.merge!(
    2010 => "Bryn Shander Road", 2011 => "Frost-Light Chasm", 2012 => "Bryn Shander",
    2013 => "Bryn Shander Pokémon Center", 2014 => "Blackiron Blades", 2015 => "Bryn Shander Town Hall",
    2016 => "The Northlook", 2017 => "Weaver's House", 2018 => "Lottery House",
    2019 => "House of the Morninglord"
  )

  MAP_METADATA.merge!(
    2010 => { outdoor_map: true, announce_location: true, weather: [:Snow, 100], battle_environment: :Snow },
    2011 => { announce_location: true, battle_environment: :Cave },
    2012 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Snow },
    2013 => { teleport_destination: [2012, 10, 22] }
  )

  AREAS.merge!(2010 => :north_road, 2011 => :chasm, 2012 => :bryn, 2013 => :bryn, 2014 => :bryn,
               2015 => :bryn_hall, 2016 => :northlook, 2017 => :bryn, 2018 => :bryn, 2019 => :bryn)

  MARTS[:bryn] = [:POKEBALL, :GREATBALL, :POTION, :SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING,
                  :ICEHEAL, :ESCAPEROPE, :REPEL]

  #-----------------------------------------------------------------------------
  # Wild Pokémon. [chance, species, min level, max level]. Each version adds its
  # own lines: Frost the Ice and Ghost ones, Thaw the Grass and Fire ones.
  #-----------------------------------------------------------------------------
  ENCOUNTERS = {
    2010 => { step_chances: { Land: 21 },
              Land: [[25, :SWINUB, 8, 11], [20, :SENTRET, 8, 10], [15, :SPEAROW, 9, 11],
                     [10, :DELIBIRD, 9, 11], [10, :TEDDIURSA, 8, 10], [10, :MEOWTH, 9, 11]] },
    2011 => { step_chances: { Cave: 6 },
              Cave: [[30, :ZUBAT, 10, 13], [20, :SWINUB, 10, 12], [20, :GEODUDE, 10, 13], [10, :SNEASEL, 11, 13]] }
  }
  VERSION_ENCOUNTERS = {
    frost: { 2010 => { Land: [[10, :GASTLY, 9, 11]] }, 2011 => { Cave: [[20, :GASTLY, 11, 13]] } },
    thaw:  { 2010 => { Land: [[10, :VULPIX, 9, 11]] }, 2011 => { Cave: [[20, :SLUGMA, 11, 13]] } }
  }

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_AURILITE:  ["Aurilite",  :CHANNELER,     1, 30],
    FT_SPEAKER_F: ["Speaker",   :LEADER_Jasmine, 1, 100, :LEADER_Brock]
  )

  TRAINERS.merge!(
    hiker_tor:      [:HIKER,           "Tor",     [[:GEODUDE, 10], [:SWINUB, 11]],
                     "Ha! The mountain wins again. I mean you do."],
    backpacker_wen: [:PICNICKER,       "Wen",     [[:SENTRET, 10], [:TEDDIURSA, 11]],
                     "I packed for snow. I didn't pack for you."],
    ranger_aldo:    [:POKEMONRANGER_M, "Aldo",    [[:SPEAROW, 11], [:DELIBIRD, 11]],
                     "The road's safe enough with you on it, I suppose."],
    aurilite_one:   [:FT_AURILITE,     "Hesk",    [[:SWINUB, 12], [:B220H92, 12]],
                     "The Frostmaiden doesn't need you to believe in her."],
    ranger_lune:    [:POKEMONRANGER_F, "Lune",    [[:MEOWTH, 11], [:SNEASEL, 11]],
                     "Fine. Bryn Shander's that way. Mind the gate."],
    hiker_bram:     [:HIKER,           "Bram",    [[:GEODUDE, 12], [:B74H220, 12]],
                     "Even my rocks are cold."],
    aurilite_two:   [:FT_AURILITE,     "Siv",     [[:ZUBAT, 12], [:B220H215, 13]],
                     "The light below is hers. Whatever goes into it, she keeps."],
    aurilite_three: [:FT_AURILITE,     "Orla",    [[:GASTLY, 13], [:SNEASEL, 13]],
                     "Go on, then. See what the cold makes of your little friend."],
    bryn_zhent_a:   [:FT_ZHENTARIM,    "Brosk",   [[:MEOWTH, 13], [:B19H81, 13]],
                     "The Speaker won't take our coin. Everyone takes it eventually."],
    northlook_zhent: [:FT_ZHENTARIM,   "Dorn",    [[:KOFFING, 13], [:B52H109, 14]],
                     "The Black Network doesn't forget. Neither do I."],
    bhall_clerk_2:  [:GENTLEMAN,       "Corvin",  [[:B161H81, 15]],
                     "Six generations on the Council staff, and beaten by a stranger. How refreshing."],
    duvessa:        [:FT_SPEAKER_F,    "Duvessa", [[:B161H81, 15], [:B216H208, 15], [:B52H227, 17]],
                     "Bryn Shander pays its debts. Even to strangers.", [:SUPERPOTION]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    targos_gate_guard: -> {
      if T.flag?(:badge_targos)
        ["GUARD: Naerth's seal. Fine. The road's dug out as far as the pines.",
         "GUARD: Bryn Shander's at the end of it. Keep moving. Keep together."]
      else
        ["GUARD: Nobody leaves Targos without Speaker Naerth's say-so.",
         "GUARD: Not in this weather. Not strangers.",
         T.flag?(:naerth_terms) ? "GUARD: Want the road? Win his seal at the Town Hall." :
                                  "GUARD: Want the road? Ask the Speaker. He's at the Luskan Arms, on the south shore."]
      end
    },
    targos_gate_guard_open: ["GUARD: Bryn Shander's at the end of the road, up on its hill. Two hours' walk.",
                             "GUARD: In good weather. We haven't had good weather in two years."],

    # --- North Road --------------------------------------------------------------
    sign_north_road: ["BRYN SHANDER ROAD", "Targos - Bryn Shander", "Travelers: stay on the road. Stay together."],
    sign_chasm: ["A warning, scratched into a board and half buried in frost:",
                 "\"COLD LIGHT BELOW. DO NOT FOLLOW IT.\""],
    sign_bryn_ahead: ["BRYN SHANDER", "Gates close at dark. It is always dark."],
    road_old_trapper: -> {
      if T.flag?(:razzy_egg)
        ["TRAPPER: You came back up out of that hole. Not many do.",
         "TRAPPER: Whatever's in your coat, keep it warm. Cold things want warm things back."]
      else
        ["TRAPPER: There's a crack in the rocks east of here. Glows at night.",
         "TRAPPER: Blue, like moon under ice. The Aurilites pray at it. I set my traps the other way."]
      end
    },
    road_caravan_guard: ["GUARD: Bryn Shander's caravan. Stuck till the drifts settle. We wait. We always wait.",
                         "GUARD: You'll want the Speaker, Duvessa Shane. Young. Sharp.",
                         "GUARD: Heads the Council of Speakers, too. Honest. Which round here makes her unusual."],
    hiker_tor_after: ["Hiking's the only way to stay warm out here. That, and losing to strangers."],
    backpacker_wen_after: ["When the wind turns, I hear laughing from the south. It's just the wind. Right?"],
    ranger_aldo_after: ["Rangers keep this road open. We try. The snow doesn't care how hard we try."],
    aurilite_one_after: ["Every new moon, a town gives her one of its own. One life buys a month.",
                         "You think that's cruel. She thinks it's cheap."],
    ranger_lune_after: ["A man walks this road at night in his shirtsleeves. I don't go out after dark any more."],
    hiker_bram_after: ["Bryn Shander's walls are the only real ones in the Dale. Two rings of logs.",
                       "Thirty feet high. Built for orcs. Useless against weather."],
    razzy_wait: -> {
      who = T.companion_or_you(:reptin)
      # (the goal says where; a thought box repeating it put words in the silent player's head)
      [who ? "#{who}: We can't leave him down there. Not in that light." :
             "(You can't leave him down there. Not in that light.)"]
    },

    # --- Frost-Light Chasm --------------------------------------------------------
    aurilite_two_after: ["Siv is just a name. The cold keeps our real ones."],
    aurilite_three_after: ["She'll take him whole. That's a mercy. Most of us she takes a piece at a time."],
    chasm_after: ["The crack is dark now. Only frost, and the shape of a small body pressed into it."],

    # --- Bryn Shander -------------------------------------------------------------
    bryn_south_guard: ["GUARD: Welcome to Bryn Shander. Mind the lottery board, and your purse. In that order.",
                       "GUARD: Gates shut when it's dark. Which is to say, more often than not."],
    bryn_east_guard_open: ["GUARD: The Eastway's open. Good Mead's off it to the south, and Dougan's Hole past that.",
                           "GUARD: Nobody's come back from the Hole in a month. Your funeral. Mind the wolves."],
    bryn_council_hall: ["COUNCIL HALL", "Where the Council of Speakers of the Ten-Towns meets, when there's call to."],
    morninglord_acolyte: ["ACOLYTE: The Morninglord's fire never goes out in this house.",
                          "ACOLYTE: Two years of night. Not once.",
                          "ACOLYTE: Some days it's the only proof the sun's still out there."],
    bryn_south_guard_open: ["GUARD: Welcome to Bryn Shander. Mind the lottery board, and your purse. In that order."],
    bryn_north_guard: -> {
      if T.flag?(:seen_sephek_bryn)
        ["GUARD: Follow Sephek Kaltro into the snow? Not on my say-so.",
         "GUARD: Bring the Speaker's seal. Then it's your funeral, not mine."]
      else
        ["GUARD: North gate's closed. The Termalaine path's under ten feet of drift.",
         "GUARD: Lonelywood's past that. Come back when the Speaker says otherwise."]
      end
    },
    bryn_east_guard: ["GUARD: The Eastway runs to Easthaven. Off it to the south, Good Mead and Dougan's Hole.",
                      "GUARD: Nobody's been back from the Hole in a month. The gate stays shut."],
    bryn_square_talk: [{ if: { flag: :lottery_stand }, lines: ["Ilda's home. Nobody on this square is looking at their feet today."] },
                       ["Biggest of the Ten-Towns. Every road in the Dale comes through this square.",
                        "Every rumour too. Heard about the man who doesn't feel the cold?"]],
    bryn_lottery_talk: [{ if: { flag: :lottery_stand }, lines: ["The board's still up. Duvessa says it's coming down.",
                                                                "Nobody believes it yet. Nobody's touching it either."] },
                        ["The lottery board. Every new moon, a name. Last month it was the cooper's boy.",
                         "Name's drawn at sundown. They walk out onto the ice at dawn. Nobody walks back.",
                         "Duvessa tried to stop it once. The storm that came after took three roofs."]],
    bryn_kid_talk: ["I counted the lanterns over the streets. Forty-one. Somebody climbs up to light them.",
                    "When I'm big I'm going to be the one who climbs up."],
    bryn_sephek_talk: -> {
      if T.flag?(:seen_sephek_bryn)
        ["He looked right at me. He didn't blink. The snow didn't melt on his skin."]
      else
        ["They found a fisher frozen solid on the Easthaven road. Standing up. Eyes open.",
         "Sephek Kaltro, they say. Auril's own. He walks town to town and nobody stops him."]
      end
    },
    bryn_trade_talk: ["Scrimshaw! Knucklehead-trout bone, carved by hand. Two years of night, you carve a lot."],
    bryn_sign_hall: ["TOWN HALL", "Seat of Duvessa Shane, Speaker of Bryn Shander.",
                     "Challengers for the town's seal: inquire within."],
    bryn_sign_square: ["MARKET SQUARE", "No trading after the lottery bell."],
    bryn_house_locked: ["The door is barred from inside. A lantern burns in the window."],
    bryn_center_traveler: ["I came up from Easthaven. The ferries stopped. The lake's too thick to break.",
                           "Bryn Shander's the only place left with enough people to feel safe."],
    bryn_market_customer: ["Prices are better than in Targos. Don't ask who pays the difference."],
    bryn_weaver: -> {
      if T.flag?(:lottery_stand)
        ["BRENNA: They'd have walked her out at dawn. Twelve. You stood up there for her.",
         "BRENNA: I burn the names into the tokens. I'll never burn hers again."]
      else
        lines = ["BRENNA: I make the lottery tokens. Little wooden discs, a name burned into each.",
                 "BRENNA: I burned my own girl's into one last month. Ilda. It's still in the bowl."]
        lines << (T.herald?(:alberica) ? "BRENNA: ...You, with the pendant. Sing something, would you? It's been so long." :
                                         "BRENNA: ...Your friend with the pendant. Would she sing something? It's been so long.") if T.with_or_is?(:alberica)
        lines
      end
    },
    bryn_ilda: -> {
      if T.flag?(:lottery_stand)
        [T.herald?(:alberica) ? "ILDA: Will you teach me the summer song? Mama says I can stay up." :
                                "ILDA: Is the singer still here? I want to learn the summer song."]
      else
        ["ILDA: Mama makes me stay in on draw nights. She says the bowl can't see you indoors."]
      end
    },
    bryn_lottery_mother: ["Duvessa came herself to tell us. First Speaker who ever did.",
                          "It doesn't bring my husband back. But she came."],
    bryn_lottery_child: ["Mama says the Frostmaiden is just very lonely. Is that true?"],
    northlook_keeper: ["SCRAMSAX: The Northlook. Warmest beds in Bryn Shander. Coldest company.",
                       "SCRAMSAX: Back table's spoken for. Always is. Don't sit there."],
    zhent_broker: -> {
      # (one name for the gang, said once in full: notes 02 E31)
      lines = ["BROKER: Naerth's seal. So you're the strangers he writes about.",
               "BROKER: Zhentarim. The Black Network, to most. We've friends in every town but this one.",
               "BROKER: The Speaker sends our coin back unopened. Everyone takes it eventually."]
      if T.flag?(:razzy_egg)
        lines << T.cl(:reptin, "(pleasantly) We'll keep our coin, thank you.")
        lines << "BROKER: A goblin egg. There's a woman in Luskan who'd pay a fortune for that."
        lines << "BROKER: Avarice, she calls herself. Think it over."
      end
      lines.compact
    },
    northlook_zhent_after: ["The back table's still spoken for."],
    bryn_zhent_a_after: ["Everybody in this square owes the Network something. Even the lottery board."],
    northlook_traveler: ["I'm off to Lonelywood when the road opens. They say rabbits keep the moon there.",
                         "Rabbits the size of people, with lanterns. My cousin swears it."],
    northlook_old_hand: ["Easthaven, Lonelywood, Dougan's Hole, Bremen. I've hauled for all the Ten-Towns.",
                         "The Hole's the one I won't go back to. You can hear her laughing out on the ice."],
    bhall_guide: ["The Town Hall. The Speaker sits here, over the town's winter stores.",
                  "Sheriff Southwell's militia stand at every gap. They'll want a go at you first.",
                  "Speaker Duvessa trains Steel and Normal fusions. Walls and watchmen. Like the town."],
    bhall_militia_1_after: ["Every crate in this hall is grain for the winter. We count it twice a day."],
    bhall_clerk_2_after: ["These days I mostly keep the stove lit. The papers like it warm."],
    bhall_militia_2_after: ["Go on. She's expecting you. She expects everyone."]
  )

  PARTY_CHAT[:alberica].merge!(
    north_road: [{ if: { flag: :razzy_egg }, lines: ["The egg's warm. I sang to it a while back and it got warmer.",
                                                     "Finally. Somebody with taste."] },
                 ["So quiet out here. Even the wind's holding its breath.",
                  "If I wrote a song for this road, sugar, it'd be all rests."]],
    chasm: [{ if: { flag: :razzy_egg }, lines: ["Give me the egg. Dwarves run hot. It's our one use in a blizzard.",
                                                "...Well. One of our uses."] },
            ["The light down here hums. Like a note somebody's held too long."]],
    bryn: [{ if: { flag: :lottery_stand }, lines: ["It itches. Like a snowflake that won't melt.", "Don't make a thing of it."] },
           ["Lanterns over every street, and not a soul under them. A town holding its breath.",
            "Somebody should sing in that square. Somebody will."]],
    bryn_hall: ["She keeps the whole town's winter in this room, and she still draws a name every month.",
                "I'd have taken up drinking, darling. Well. More drinking."],
    northlook: ["Nobody's at the back table, and everybody's watching it.",
                "That's the most popular chair in town, darling."]
  )
  PARTY_CHAT[:reptin].merge!(
    north_road: ["My medallion's been pulling east since the second field. Toward that glow.",
                 "Rude of it, not to ask first."],
    chasm: [{ if: { flag: :razzy_egg }, lines: ["My hand still stings where I cut it. Good sting. It means it took."] },
            ["The Sacred Flame called frost-light Auril's breath. Whatever it touches, she keeps.",
             "Lovely people. Terrible theology."]],
    bryn: ["A whole town, cold to the bone. Like a winter that forgot to leave."],
    bryn_hall: ["Naerth bought his chair. She was elected to hers. I'd like to see the difference hold."],
    northlook: ["Someone in here smells of the Black Network. Coin and cold iron.",
                "(under his breath) Keep smiling. They're counting us."]
  )
  PARTY_CHAT[:alerion].merge!(
    north_road: [{ if: { time: :night }, lines: ["Someone walked this road tonight. No footprints. My ring knows."] },
                 ["Stay off the ridges. Something's been watching us since Targos."]],
    chasm: [{ if: { flag: :razzy_egg }, lines: ["He isn't dead. My ring goes cold near the dead. The egg is warm."] },
            ["My ring's colder here. Death's been here. Or something wearing it."]],
    bryn: [{ if: { flag: :seen_sephek_bryn }, lines: ["He walked out the north gate like he owned it.", "Next time he doesn't walk."] },
           ["The only real walls in the Dale. They don't keep the cold out."]],
    bryn_hall: ["Bought steel is still steel."],
    northlook: ["Two Black Network agents at the bar. They stopped talking when we came in.", "Rude."]
  )
  PARTY_CHAT[:shade].merge!(
    north_road: ["The dagger keeps turning toward that glow in the rocks.",
                 "I don't like what it wants. I like it less that I want it too."],
    chasm: [{ if: { flag: :razzy_egg }, lines: ["Carried that horn since Saltmarsh. Now I know why. I hate knowing."] },
            ["Little footprints. Goblin. Running, not walking."]],
    bryn: ["Naerth's people are here too. Back table at the Northlook. They get around."],
    bryn_hall: ["Count the crates. Count the guards. She's ready for a siege. The siege is the sky."],
    northlook: ["The back table's the Black Network's. I've sat at tables like that.",
                "They always cost more than the drinks."]
  )
  PARTY_CHAT[:shimmer].merge!(
    north_road: ["Same colour as that light in the rocks. That's not a good sign."],
    chasm: [{ if: { flag: :razzy_egg }, lines: ["The light took him gently. Like it knew him.", "I can't decide if that's better or worse."] },
            ["This place feels like the inside of my stone. Cold, and listening."]],
    bryn: [{ if: { flag: :seen_sephek_bryn }, lines: ["She sent her regards. To me.", "I'd have preferred a fruit basket."] },
           ["People look at my stone, then look away. Like they know what it is."]],
    bryn_hall: ["She's not cruel. She's cornered. The second kind bites harder."],
    northlook: ["I'm keeping my hood up in here. Don't ask."]
  )

  # The Act I script's music cues are moods (act1_script.md, "Music"); these
  # are the tracks Chapters 2-3 map them to.
  MOOD_MUSIC = { rime: "mountsilver", frostmaiden: "sealed_chamber", requiem: "Lavender Town",
                 thaw: "fullmoonIsland", hunt: "magma_hideout", heralds: "tintower" }

  module_function

  def mood(key)
    key.nil? ? (pbBGMFade(0.8) rescue nil) : Stage.theme(MOOD_MUSIC[key] || key)
  end

  # A companion's name for a line, or nil when the player IS that Herald.
  def companion_or_you(key)
    return nil if herald?(key)
    return COMPANION_NAMES[key]
  end

  # A stage direction about the speaker's own body, said of the Herald you are,
  # becomes "your" (WRITING_GUIDE §5): "under his breath" -> "under your breath".
  # Only phrases that can only mean the speaker are changed; "a hand on his
  # back" or "taking both her hands" are about someone else and stay.
  SELF_DIRECTIONS = [
    /\b(under|through) (his|her|their) (breath|teeth)\b/i,
    /\b(wiping|rubbing|shutting|closing) (his|her|their) (eyes|nose|face)\b/i,
    /\bmanaging (his|her|their) voice\b/i,
    /\bon (his|her|their) knees\b/i,
    /\bbehind (his|her|their) hand\b/i,
    /\b(his|her|their) own\b/i,
    /\b(his|her|their) (empty )?hands?\b(?= on (his|her|their) (rune|ring|chest|pendant|medallion))/i,
    /\bon (his|her|their) (rune|ring|chest|pendant|medallion)\b/i,
    /\bat (his|her|their) empty hands\b/i
  ]
  def your_direction(dir)
    SELF_DIRECTIONS.reduce(dir) do |d, re|
      d.gsub(re) { |m| m.gsub(/\b(his|her|their)\b/i) { |w| w[0] == w[0].upcase ? "Your" : "your" } }
    end
  end

  # Speaks a line as a companion; when you are that Herald it becomes a thought.
  def as(key, text)
    if herald?(key)
      # A stage direction on your own line becomes narration: "(a hand on her
      # neck) I'll watch her." -> "A hand on her neck. (I'll watch her.)"
      if text =~ /\A\(([^()]+)\)\s*(.*)\z/m
        dir, rest = $1, $2
        dir = your_direction(dir)
        dir = dir[0].upcase + dir[1..-1]
        return rest.empty? ? "#{dir}." : "#{dir}. (#{rest})"
      end
      return "(#{text})"
    end
    return "#{COMPANION_NAMES[key]}: #{text}"
  end

  # The line north of the chasm bend: until the egg is safe, the party turns back.
  def razzy_block(event_id = nil)
    return if !flag?(:met_razzy) || flag?(:razzy_egg)
    talk(:razzy_wait, event_id)
    $game_player.turn_down rescue nil
    $game_player.move_down rescue nil
  end

  # The House of the Morninglord: Mishann keeps the fire lit and heals travellers.
  def morninglord(event_id = nil)
    if flag?(:badge_bryn) && !flag?(:golden_acorn)
      morninglord_acorn(event_id)
      return
    end
    # (after the acorn she knows you: notes 02 E36)
    say([flag?(:golden_acorn) ? "MISHANN: Back already? Good. The fire's lit." :
                                "MISHANN: Come in out of the dark. The Morninglord turns no one away.",
         "MISHANN: Sit by the fire a moment. Your Pokémon too."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    Stage.jingle(:heal)
    say(["MISHANN: There. The dawn comes back, you know. Even here. It always comes back."], event_id)
  end

  # SC 2.09 - The Morninglord's acorn, the thing the whole act turns on (the
  # third way). Purpose: Reptin is given the acorn by the priestess who named
  # Auril, and the player learns who she is and what Reptin is.
  # Out of the hall with the seal (notes 02 E4, E18; context 02 M2-8): walking
  # out is the player's input after the gym; Mishann is waiting on the steps.
  HALL_STEPS = [31, 20]

  def scene_mishann_steps
    return if flag?(:golden_acorn) || !flag?(:badge_bryn)
    mishann_on_the_steps
  end

  def mishann_on_the_steps
    s = Stage
    mish = nil
    if s.map?
      if $game_map.map_id != MAPS[:bryn] && $scene.respond_to?(:transfer_player)
        pbFadeOutIn { s.jump(MAPS[:bryn], *HALL_STEPS, 2) }
      end
      mish = s.actor(:mishann, HALL_STEPS[0] + 2, HALL_STEPS[1] + 3, 8, graphic: "BW (98)")
      if mish
        (mish.move_speed = 4) rescue nil                 # (out of breath, hurrying)
        s.approach(mish)
      end
    end
    mid = mish ? mish.id : nil
    say(["The priestess from the square hurries up the steps, her lantern still lit.",
         "MISHANN: There you are. Mishann. I keep the Morninglord's fire. The dawn's, such as it is.",
         herald?(:reptin) ? "MISHANN: I've looked for you since the draw. I had a feeling." :
                            "MISHANN: I've looked for your druid since the draw. I had a feeling."], mid)
    morninglord_acorn(mid)
    s.leave(mish, HALL_STEPS[0] + 2, HALL_STEPS[1] + 4) if mish
    s.cleanup
  end

  def morninglord_acorn(event_id = nil)
    return if flag?(:golden_acorn)
    if flag?(:razzy_egg)
      say(["MISHANN: You gave blood to something the cold had taken. It's still on your hand."], event_id)
      say([herald?(:reptin) ? "You close your hand over the cut." : "Reptin closes his hand over the cut."])
      speak(:reptin, "A scratch. Nothing.", "...It's nothing.")
    end
    # (the prophecy in two boxes, not four: dialogue 02 §4)
    say([herald?(:reptin) ? "She presses something into your palm anyway: a golden acorn." :
                            "She presses something into Reptin's palm anyway: a golden acorn.",
         "MISHANN: A priest in the south gave this to my order. \"Carry it north,\" he said.",
         "MISHANN: I think he meant you."], event_id)
    speak(:reptin, "How generous. ...What does it do?", "...What does it do?")
    say(["MISHANN: I don't know. Plant it somewhere the sun can't reach.",
         "MISHANN: See what it does out of spite.",
         cl(:alberica, "Oh, I like her.")].compact, event_id)
    give_key(:FT_GOLDENACORN)
    set_flag(:golden_acorn)
    state[:goal] = "Sephek is in Lonelywood: out the north gate, through Termalaine."
  end

  def apply_story_switches
    return if !active? || !$game_switches
    sync_switch(SW_ROAD_OPEN, flag?(:badge_targos))
    sync_switch(SW_BRYN_BADGE, flag?(:badge_bryn))
    # Make everyone on the map re-check the story switches. A save remembers
    # which "page" each person was showing, so a guard saved while blocking
    # the gate would otherwise keep blocking it after the switch is on.
    $game_map.need_refresh = true if $game_map
  end

  def sync_switch(id, on)
    $game_switches[id] = true if on
  end

  #-----------------------------------------------------------------------------
  # Scenes
  #-----------------------------------------------------------------------------
  # SC 2.01 - The north road
  def scene_north_road_start
    if herald?(:meat_meat)
      # They met her in the Targos tavern, and Shimmer promised to look for Razzy
      # (Chapter 1): this follows on from that.
      say(["You've followed Razzy's footprints all night.",
           "The strangers from the tavern are on the same road. They have food.",
           "Razzy would want you to ask.",
           "SHADE: You again. The goblin from the tavern. Hungry, or friendly?"])
      pbMessage(_INTL("What do you say?"), [_INTL("\"Both. Meat Meat is still looking for Razzy.\"")], 0)
      say(["SHADE: ...Fair answer. Walk with us, then. Nobody should be out here alone.",
           "SHIMMER: We said we'd look. So we're looking.",
           "REPTIN: Small, green, out the gate. Anything else we should know?"])
      speak(:meat_meat, "Razzy can't talk. Razzy and Meat Meat ran from a cold table.", "...Razzy can't talk.")
      say([cl(:alberica, "Sweetheart, you're blue. Here. Scarf. Don't argue.")].compact)
      set_flag(:meat_meat_joined)
    else
      say(["The road north is a white line between black pines.",
           "Behind you, the lanterns of Targos shrink to sparks."])
      speak(:alerion, "Single file. The drifts hide holes.", "...Single file.")
      say([as(:shimmer, "My stone's humming. It never hums."),
           cl(:shade, "You hum all the time."),
           as(:shimmer, "I'm in tune. It isn't."),
           cl(:alberica, "Nobody's in tune at this temperature, darling.")].compact)
    end
    state[:goal] = "Follow the road north through the pines to Bryn Shander."
  end

  # SC 2.02 - A voiceless goblin
  # Purpose: the player sees Razzy (mute, scarred, glowing) and he leads them
  # off the road to the chasm; the scar is a question the next chapter answers.
  CHASM_MOUTH = [29, 28]

  def scene_razzy_appears
    return if flag?(:met_razzy)
    set_flag(:met_razzy)
    # one scene, one trigger: the other tiles along the row stand down (notes 02 E25)
    if Stage.map?
      $game_map.events.each_value do |e|
        $game_self_switches[[$game_map.map_id, e.id, "A"]] = true if e.name.to_s =~ /razzy_appears/
      end
      $game_map.need_refresh = true
    end
    s = Stage
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    reptin = herald?(:reptin) ? $game_player : s.summon(:reptin)
    razzy = s.actor(:razzy, px + 1, py - 2, 2)
    if razzy
      s.fx("E-01", razzy, frames: 10, wait: false)
      pbSEPlay("Ice1") rescue nil
      s.hop(razzy)
    end
    say(["A small goblin bursts out of the snow. Thin. A pale scar across his throat.",
         "Green light moves under his skin, like veins."])
    if razzy && reptin
      s.walk_to(razzy, reptin.x, reptin.y, adjacent: true)
      s.turn_to(razzy, reptin)
      s.turn_to(reptin, razzy) if !reptin.equal?($game_player)
    end
    say([herald?(:reptin) ? "He grabs your sleeve and pulls." : "He grabs Reptin's sleeve and pulls."])
    speak(:reptin, "Hello, little one. You're freezing. Here, take my...", "You're freezing. Here...")
    say(["He opens his mouth. No sound comes out."])
    s.emote(reptin, :question) if reptin && !reptin.equal?($game_player)
    say([as(:reptin, "(very quiet) Someone cut that scar. On purpose.")])
    if razzy
      (razzy.move_speed = 5) rescue nil                 # (he runs)
      s.walk_to(razzy, CHASM_MOUTH[0], CHASM_MOUTH[1], wait_for: false)
      s.pan_to(*CHASM_MOUTH)
    else
      s.pan_to(*CHASM_MOUTH)
    end
    say(["He points east, at a crack in the snow glowing blue-white. Then he runs."])
    if razzy
      guard = 0
      while razzy.move_route_forcing && guard < 300
        s.wait(1)
        guard += 1
      end
      s.remove_actor(razzy)
    end
    s.pan_back
    say([as(:shade, "Trap or kid. Out here I'd bet trap."),
         cl(:alerion, "Kid. Traps don't shiver.")].compact)
    if herald?(:meat_meat)
      say(["(Razzy. Razzy! Razzy, no, not that way...)",
           "SHIMMER: Small, green, running. That's your Razzy?"])
    end
    state[:goal] = "Follow the little goblin to the glowing crack, north-east of the road."
  end

  # SC 2.03 - Frost-light (its own scene key: the Cackling Chasm's is scene_cackling_enter)
  # Purpose: the first scene the Frostmaiden drives; the player learns her
  # light is hers, and that the Aurilites pray to the winter (context 02 M2-2).
  SIV_SPOT = [12, 24]

  def scene_frostlight_enter
    say(["Blue light seeps out of the ice like breath."])
    Stage.pan_to(*SIV_SPOT)
    siv = ($game_map.events.values.find { |e| [e.x, e.y] == SIV_SPOT } rescue nil)
    say(["Two figures in white robes chip at it with bone picks.",
         "SIV: The Frostmaiden's light. Every crumb belongs to her. You don't."], siv ? siv.id : nil)
    Stage.pan_back
    say([as(:reptin, "(under his breath) Aurilites. They pray to the winter, and it listens."),
         as(:reptin, "Zealots with picks. My favourite."),
         cl(:alberica, "Nobody belongs to anybody, sugar. Step aside.")].compact)
  end

  # SC 2.04 - Shell of light
  # Purpose: Razzy is lost to the frost-light and saved as an egg, at the cost
  # of Reptin's blood and Shade's horn; the rite still wants his name.
  def scene_razzy_falls(event_id = nil)
    s = Stage
    return if flag?(:razzy_egg)
    # Razzy waits at the lip ("Frost-light"); pressing A on him or stepping up
    # to the lip both start this, and all of them stand down after it
    light = ($game_map.events.values.find { |e| e.name == "Frost-light" } rescue nil)
    if s.map?
      $game_map.events.each_value do |e|
        next unless e.name == "Frost-light" || e.name.to_s =~ /razzy_falls/
        $game_self_switches[[$game_map.map_id, e.id, "A"]] = true
      end
    end
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    lx, ly = light ? [light.x, light.y] : [px, py - 1]
    s.turn_to($game_player, light) if light
    light.transparent = true if light
    razzy = s.actor(:razzy, lx, ly, 8)
    s.pose(razzy, "K-RZY-02", 0, frames: [0], per: 20) if razzy
    say(["Razzy stands at the lip of the crack, where the light is brightest."])
    if razzy
      s.pose(razzy, "K-RZY-02", 0, frames: [1], per: 30)
      say(["He looks back at you. Almost smiling."])
      s.pose(razzy, "K-RZY-02", 0, frames: [2, 3], per: 8)
      s.walk(razzy, [14, 0, 0])                    # a last small hop, into the light
      s.hide(razzy)
    end
    pbSEPlay("Battle damage weak") rescue nil
    $game_screen.start_shake(3, 6, 10) rescue nil
    say(["Then the ice gives."])
    shell = s.fx("E-03", [lx, ly], frames: 15, oy: 24, loop_from: 10)
    s.wait(10 * s.ticks)
    say(["He doesn't fall far. The light catches him and closes, like hands.",
         "When it stops, a shell of frost sits in the crack.",
         "Inside it, slow and green, something beats.",
         as(:reptin, "He's alive. The light's... keeping him."),
         cl(:alberica, "Then we get him back. Tell me how, and I'll do it."),
         herald?(:reptin) ? "The medallion on your chest pulls toward the shell." : "The medallion on Reptin's chest pulls toward the shell."].compact)
    speak(:reptin, "It wants blood. Mine. Of course it does.", "...It wants my blood.")
    c = pbMessage(_INTL("What do you say?"), [_INTL("\"Do it.\""), _INTL("\"Wait...\"")], -1)
    if c == 0
      set_flag(:razzy_bloodwarm)
      say([as(:reptin, "(already rolling up a sleeve) I was hoping you'd say that.")]) if !herald?(:reptin)
    else
      say([as(:reptin, "There's no waiting in this cold.")])
    end
    reptin = s.herald(:reptin, -1, 0, 8)
    s.face(reptin, 8)
    s.pose(reptin, "P-REP-02", 0, per: 8) if reptin
    say([herald?(:reptin) ? "You cut your palm and press it to the shell. The frost drinks it." :
                            "Reptin cuts his palm and presses it to the shell. The frost drinks it.",
         "The shell softens. It isn't enough.",
         as(:shade, "(digging in a pack) I've carried this since the Saltmarsh job. A unicorn's horn."),
         as(:shade, "Never knew why I kept it."),
         as(:shimmer, "(very still) ...You kept that.")])
    shade = s.actor(:shade, px + 1, py, 8)
    s.pose(shade, "P-SHA-02", 0, per: 8) if shade
    $game_screen.start_flash(Color.new(200, 255, 200, 140), 12) rescue nil
    s.stop_fx(shell)
    egg = s.actor(:egg, lx, ly, 2, graphic: "K-EGG-01")
    s.pose(egg, "K-EGG-01", 0, frames: [0, 1, 2, 3, 0, 1, 2, 3], per: 6) if egg
    say([herald?(:shade) ? "You lay the horn against the shell. It melts in, like snow into a hand." :
                           "Shade lays the horn against the shell. It melts in, like snow into a hand.",
         "The shell rounds into an egg, warm and green-gold.",
         herald?(:alerion) ? "(Your ring goes cold near the dead. The egg is warm.)" : nil,
         herald?(:reptin) ? "(The old druid rhymes. You haven't said one aloud in years.)" : nil].compact)
    speak(:reptin, "The old rhymes want a name. Spoken as a promise.",
          "...The old rhymes want a name. Spoken as a promise.")
    speak(:alberica, "And none of us knows his.", "...None of us knows his name.")
    say([cl(:alerion, "Then we find whoever cut his throat. They'll know.")].compact)
    if herald?(:meat_meat)
      say(["Reptin passes the egg to you.",
           "(Razzy. His name is Razzy. Meat Meat promises.)",
           "You say it out loud, to the egg. The egg warms against your chest.",
           cl(:alberica, "(very softly) ...Oh, sweetheart.")].compact)
      set_flag(:razzy_named)
    end
    s.cleanup
    $game_map.need_refresh = true if s.map?        # (the crack is dark now: the event's second page)
    give_key(:FT_MOONEGG)
    set_flag(:razzy_egg)
    add_counter(:story_beats)
    state[:goal] = flag?(:razzy_named) ? "Keep the egg warm. On to Bryn Shander." :
                                         "Keep the egg warm, and find someone who knows his name. On to Bryn Shander."
  rescue StandardError => e
    log("scene_razzy_falls: #{e.message}")
    Stage.cleanup rescue nil
    if !flag?(:razzy_egg)
      give_key(:FT_MOONEGG) rescue nil
      set_flag(:razzy_egg)
    end
  end

  # SC 2.05 - The board in the square
  # Purpose: the stakes of tonight; what the lottery is for, and to whom, and
  # what refusing costs (context 02 M2-4). The gate guard walks up to say it.
  BOARD_SPOT = [25, 23]          # the square, where the lottery board stands

  def scene_bryn_arrival
    s = Stage
    say(["Bryn Shander sits on its hill inside two walls of logs, thirty feet high."])
    s.pan_to(*BOARD_SPOT)
    say(["Bright lanterns twist over the narrow streets. Under them, nobody.",
         "In the square, a board lists every name in town. Tonight is the new moon."])
    s.pan_back
    guard = s.actor(:gate_guard, $game_player.x, $game_player.y - 4, 2, graphic: "BWPoliceman") if s.map?
    s.approach(guard) if guard
    gid = guard ? guard.id : nil
    say(["GUARD: Draw's at sundown. Speaker says nobody leaves on a draw night. Nobody.",
         "GUARD: And they've added travellers. You went on the board when you came through the gate."], gid)
    speak(:alberica, "We're on it?", "...Us too?")
    say([as(:shimmer, "Everyone's on it."),
         cl(:reptin, "How democratic.")].compact)
    say(["GUARD: Laugh, then. One name a moon, for the Frostmaiden, and she spares the rest of us."], gid)
    say([as(:shade, "And if you don't give her one?")])
    say(["GUARD: Two years of her Everlasting Rime says you don't want to find out."], gid)
    s.leave(guard, $game_player.x, $game_player.y - 6) if guard
    if flag?(:kip_list)
      say([as(:alberica, "...Kip's list. Three names on this board have never once been drawn."),
           as(:alberica, "Not in two years."),
           as(:shade, "Funny how luck works."),
           cl(:reptin, "Luck and bribery. Same family. Different hats.")].compact)
      set_flag(:lottery_rigged)
    end
    set_flag(:bryn_arrived)
    state[:goal] = "The lottery is drawn at sundown. Wait it out at the Northlook inn."
  end

  # The Northlook's keeper: rest until sundown, and the lottery begins. After
  # the draw it's an ordinary inn again, with a bed for the night (notes 02 E22).
  def northlook_keeper(event_id = nil)
    return say(lines_for(:northlook_keeper), event_id) if !flag?(:bryn_arrived)
    return northlook_rest(event_id) if flag?(:lottery_stand)
    if !flag?(:northlook_pitched)
      # (his own introduction has just played: a Herald gets a word in, not a second pitch)
      set_flag(:northlook_pitched)
      sayc([cl(:reptin, "(under his breath) He means interest.")])
    else
      say(["SCRAMSAX: The Northlook. Warmest beds in Bryn Shander. Coldest company."], event_id)
    end
    say(["SCRAMSAX: You'll want to be off the street before the draw. Or on it. Some folk watch."], event_id)
    return if !pbConfirmMessage(_INTL("Rest until sundown? (${1}, or on his tab)", SCRAMSAX_ROOM))
    $Trainer.money -= SCRAMSAX_ROOM if !northlook_rest_on_credit?
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    Stage.jingle(:heal)
    say(["You rest until the light goes. At sundown, the whole town walks to the square."])
    long_rest_taken
    # the draw is in the square: go out to it (the square's autorun plays lottery_night)
    set_switch(SW_LOTTERY_NIGHT, true)
    transfer(*LOTTERY_SPOT)
  end

  def northlook_rest(event_id = nil)
    say(lines_for(:northlook_keeper), event_id)
    return if !pbConfirmMessage(_INTL("Rest for the night? (${1}, or on his tab)", SCRAMSAX_ROOM))
    $Trainer.money -= SCRAMSAX_ROOM if !northlook_rest_on_credit?
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    Stage.jingle(:heal)
    say(["You sleep, and nobody draws a name."])
    long_rest_taken
  end

  SW_LOTTERY_NIGHT = 3955
  LOTTERY_SPOT = [2012, 26, 25, 8]
  # The square's own people (the gossips, the scrimshaw seller, the sheriff, the
  # Zhentarim by the board) would stand in the crowd's tiles: they're part of
  # the crowd tonight, so they're hidden until morning.
  SQUARE_FOLK = /\ANPC bryn_(square|lottery|kid|sephek|trade)_talk\z|\ASheriff Southwell\z/
  SQUARE_TRAINER = [16, 23]
  NORTH_GATE_GUARDS = [[22, 5], [23, 5]]

  def hide_square_folk(hide = true)
    return [] if !Stage.map?
    folk = $game_map.events.values.select do |e|
      e.name.to_s =~ SQUARE_FOLK || [e.x, e.y] == SQUARE_TRAINER || (@square_folk || []).include?(e)
    end
    folk.each { |e| e.transparent = hide; e.through = hide }
    @square_folk = hide ? folk : nil
    folk
  rescue StandardError => e
    log("hide_square_folk: #{e.message}")
    []
  end

  # SC 2.06 - Lottery night, then SC 2.07 - Like weather
  # Purpose: a girl is drawn; Alberica stands up and the town refuses; Auril
  # marks her for it; Sephek names his price for Shimmer and the deadline,
  # and the player chooses north with them. (Music: Rime, cut on the name,
  # Heralds under the song, Frostmaiden from the woman in furs.)
  def lottery_night
    set_switch(SW_LOTTERY_NIGHT, false)
    return if flag?(:lottery_stand)
    me = herald?(:alberica)
    s = Stage
    hide_square_folk(true)
    mood(:rime)
    $game_screen.start_tone_change(Tone.new(-70, -60, -10, 40), 0) rescue nil
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    duvessa = s.actor(:duvessa, px, py - 4, 2, graphic: "BW_Jasmine")
    crowd = [[-4, -2, "BW (20)"], [-3, -1, "BW (38)"], [3, -2, "BW (54)"], [4, -1, "BW (61)"],
             [-5, -1, "BWOldMan"], [5, -2, "BWOldWoman"], [2, -1, "BW (77)"]].map do |dx, dy, g|
      s.actor(:crowd, px + dx, py + dy, 8, graphic: g)
    end.compact
    ilda = s.actor(:ilda, px - 1, py - 2, 8, graphic: "BW (16)")
    mother = s.actor(:ilda_mother, px - 2, py - 2, 8, graphic: "BW (62)")
    # Mishann, at the crowd's edge with her lantern: PRIESTESS until she gives her name (M2-8)
    priestess = s.actor(:priestess, px - 6, py - 1, 6, graphic: "BW (98)")
    party = {}
    [[:alberica, 1, 0], [:reptin, -1, 0], [:alerion, 2, 0], [:shade, -2, 1], [:shimmer, -1, 1]].each do |k, dx, dy|
      next if herald?(k)
      party[k] = s.actor(k, px + dx, py + dy, 8)
    end
    party[:alberica] = s.herald(:alberica) if me     # (you: a stand-in that can wear her action sheets)
    s.wait(10)
    say(["The square at sundown. Torches. A bowl of wooden tokens.",
         "DUVESSA: (reaching into the bowl) For the Frostmaiden. One of us, so the rest wake up.",
         "DUVESSA: Ilda Weaverson."])
    mood(nil)                                        # the music cuts on the name
    s.balloon(mother, "B-06") if mother
    say(["A girl of twelve. Her mother makes a sound like something breaking."])
    crowd.each { |c| pbMoveRoute(c, [PBMoveRoute::Backward]) rescue nil }
    s.wait(16)
    say(["The crowd steps back from them. Nobody looks up."])
    speak(:alberica, "No. Absolutely not.", "...No.")
    alb = party[:alberica]
    if alb
      s.walk(alb, PBMoveRoute::Up, PBMoveRoute::Up)
      s.face(alb, 2)
      crowd.each { |c| s.turn_to(c, alb) }          # the square turns to look at her
      s.turn_to(duvessa, alb) if duvessa
    end
    say([me ? "(The pendant's warm against your throat. It's never warm.)" : nil,
         me ? "You climb up where the whole square can see you." :
              "Alberica climbs up where the whole square can see her.",
         "Two years without a summer. #{me ? 'You sing' : 'She sings'} them one.",
         me ? "You pull the Pendant of Black Ice out of your coat." :
              "She pulls the Pendant of Black Ice out of her coat."].compact)
    mood(:heralds)
    say([as(:alberica, "Look at me. All of you. You remember the last summer."),
         as(:alberica, "The trout jumping. Bread you didn't have to count."),
         as(:alberica, "Your kids asleep in a warm room. Remember it. Hold on to it.")])
    $game_screen.start_flash(Color.new(255, 255, 255, 200), 16) rescue nil
    $game_screen.start_tone_change(Tone.new(-30, -25, 0, 10), 20) rescue nil
    crowd.each { |c| s.balloon(c, "B-06", frames: 30) }
    s.wait(20)
    say(["The pendant burns white-hot and cold at once.",
         "The square fills with things that aren't there: cut grass, a lullaby, somebody's laugh.",
         "Every face in the crowd changes."])
    if flag?(:lottery_rigged)
      say([as(:alberica, "And three of you have never once been drawn. Ask yourselves why.")])
    end
    opts = me ? [_INTL("Keep singing."), _INTL("Look for her at the crowd's edge.")] :
                [_INTL("Stand beside Alberica."), _INTL("Watch the crowd's edge.")]
    c = pbMessage(_INTL("What do you do?"), opts, -1)
    # the woman in frost-furs arrives the way she leaves: in a gust of snow (notes 02 E13)
    auril = s.actor(:auril_furs, px + 6, py, 4)
    s.fx("E-01", auril, frames: 10, hold: false, wait: false) if auril
    if c == 1
      set_flag(:saw_auril_bryn)
      $game_player.turn_right rescue nil
      s.wait(12)
      say(["At the back of the crowd, where the torchlight gives out: a woman in frost-furs.",
           me ? "She isn't watching Ilda, or the Speaker. She's watching you." :
                "She isn't watching Ilda, or the Speaker. She's watching Alberica."])
    else
      set_flag(:stood_with_alberica)
      wheel(1)
      s.walk($game_player, PBMoveRoute::Up) if !me && s.map?
      say([me ? "You don't stop. The crowd moves toward Ilda instead of away." :
                "You climb up beside her. The crowd moves toward Ilda instead of away."])
    end
    # the crowd closes round Ilda and her mother, on the tiles round them
    if ilda && mother
      ring = [[ilda.x, ilda.y - 1], [mother.x, mother.y - 1], [ilda.x + 1, ilda.y], [mother.x - 1, mother.y],
              [ilda.x + 1, ilda.y - 1], [mother.x - 1, mother.y - 1], [mother.x, mother.y + 1]]
      crowd.each_with_index { |cr, i| s.walk_to(cr, *ring[i % ring.size], wait_for: false) }
      guard = 0
      while crowd.any?(&:move_route_forcing) && guard < 120
        s.wait(1)
        guard += 1
      end
      crowd.each { |cr| s.turn_to(cr, ilda) }
    else
      crowd.each { |cr| pbMoveRoute(cr, [PBMoveRoute::Forward, PBMoveRoute::Forward]) rescue nil }
      s.wait(24)
    end
    s.balloon(mother, "B-07", frames: 60) if mother
    say(["The crowd closes around Ilda and her mother. Nobody gives her up."])
    s.turn_to(duvessa, ilda) if duvessa && ilda
    say(["DUVESSA: ...No walk tonight. Go home. All of you."])
    s.hop(ilda) if ilda
    say([cl(:reptin, "(quietly) Remind me never to argue with her in public."),
         cl(:shade, "You'd lose. So did the whole town.")].compact)
    s.face(auril, 4) if auril
    mood(:frostmaiden)
    say([me ? "At the edge of the torchlight, the woman in frost-furs. She looks only at you." :
              "At the edge of the torchlight, the woman in frost-furs. She looks only at Alberica.",
         counter(:loop_count) > 0 ? (me ? "(Your hand is on your chest before anything happens. I know this part. I hate this part.)" :
                                          "ALBERICA: (a hand on her chest before anything happens) I know this part. I hate this part.") : nil].compact)
    pbSEPlay("Ice1") rescue nil
    if alb
      rune = s.fx("E-02", alb, frames: 8, oy: 40, loop_from: 0)
      s.pose(alb, "P-ALB-04", 0, per: 8)
    end
    s.turn_to(priestess, auril) if priestess && auril
    say([me ? "Something takes hold of your chest from the inside. Cold, like a key in a lock." :
              "Alberica gasps and claws at her chest.",
         me ? "Through your coat, a mark glows blue: a snowflake, cut by a crown." :
              "Through her coat, a mark glows blue: a snowflake, cut by a crown."])
    s.emote(priestess, :exclaim) if priestess
    say(["PRIESTESS: (her lantern shaking) That's Her. Auril, the Frostmaiden. The winter, walking.",
         me ? "(Too tall, at the edge of the lamplight. On the ship. That was her.)" : nil].compact)
    if auril
      s.fx("E-01", auril, frames: 10, hold: true, wait: false)
      s.pose(auril, "P-AUR-04", 0, per: 7)
      s.hide(auril)
    end
    s.stop_fx(rune) if alb
    s.unpose(alb) if alb
    (alb.character_name = "FT_alberica_rune") rescue nil if alb      # (she keeps the mark: notes 02 E16)
    # a second beat for the player after Auril vanishes (notes 02 E17)
    watch_gate = false
    if !me
      c2 = pbMessage(_INTL("What do you do?"), [_INTL("Go to Alberica."), _INTL("Watch the north gate.")], -1)
      if c2 == 1
        watch_gate = true
        $game_player.turn_up rescue nil
      elsif alb && s.map?
        s.walk_to($game_player, alb.x, alb.y, adjacent: true)
        s.turn_to($game_player, alb)
      end
    end
    speak(:alberica, "...I'm fine. Something's pulling me north, that's all. Don't make a thing of it.",
          "...I'm fine. Don't look at me like that.")
    say([cl(:alerion, "You're not fine."),
         as(:alberica, "Pretty boy, I'm gorgeous. Fine is a step down.")].compact) if with_or_is?(:alerion)
    set_flag(:lottery_stand)
    set_flag(:alberica_marked)
    set_flag(:auril_named)
    # SC 2.07: he comes in by the north gate, and leaves by it
    gx, gy = NORTH_GATE_GUARDS[0]
    s.pan_to(gx, gy + 4) if watch_gate
    sephek = s.actor(:sephek, gx, gy + 2, 2)
    say(["At the north gate, the guards step back from someone walking in."]) if watch_gate
    s.walk_to(sephek, px, py - 4, adjacent: true, wait_for: false) if sephek
    s.pan_back if watch_gate
    shim = party[:shimmer]
    say(["A man walks into the square in shirtsleeves. No coat.",
         "Snow doesn't settle on him. His footprints don't stay."])
    guard = 0
    while sephek && sephek.move_route_forcing && guard < 200
      s.wait(1)
      guard += 1
    end
    s.turn_to(sephek, shim || $game_player) if sephek
    s.balloon(shim, "B-06") if shim
    sid = sephek ? sephek.id : nil      # (not the townsman on the square who gossips about him)
    say([as(:shimmer, "(very still) Sephek. Nobody move. He wants someone to."),
         "SEPHEK: A town that keeps its name owes her one. I'm sorry. She'll take what's hers."], sid)
    say([me ? "He looks past Ilda. Past you. At Shimmer." : "He looks past Ilda. Past Alberica. At Shimmer.",
         "SEPHEK: The Frostmaiden sends her regards. To the girl with the stone.",
         as(:shimmer, "Tell her I said no. Again."),
         "SEPHEK: Tell her yourself. I'll be in Lonelywood.",
         "SEPHEK: Come before the next moon, or I choose someone from this square instead."], sid)
    sephek_walks_out(sephek)
    s.balloon(shim, "B-01", frames: 60) if shim
    say([cl(:shade, "(very quiet) ...Shimmer."),
         as(:shimmer, "I know.")].compact)
    # "Again" becomes a question the next chapter answers (context 02 M2-5)
    speak(:alberica, "\"Again\"? You've said no to her before?", "...\"Again\"?")
    say([as(:shimmer, "Later. Not in front of the whole town.")])
    set_flag(:lottery_stand)
    set_flag(:seen_sephek_bryn)
    if outsider?
      # the player's own road pulls the other way, and the player chooses
      say(["In your pocket, the #{my_glass} tugs south-east. Toward the Hole, not the north gate.",
           cl(:alerion, "(to you) Your road's south-east. Ours just walked north.")].compact)
      c = pbMessage(_INTL("What do you say?"), [_INTL("\"North, with them.\""), _INTL("\"How far is the Hole?\"")], -1)
      if c == 1
        say([cl(:alerion, "Past the east gate. Shut till the Speaker says. North's the only road open.")].compact)
      else
        set_flag(:shimmer_first)
        say([as(:shimmer, "(not looking at you) ...Stray. Thanks.")])
      end
    else
      speak(:alerion, "North gate's shut. Only the Speaker opens it.", "...Only the Speaker opens the north gate.")
    end
    say([as(:reptin, "Then we need the Speaker's seal either way. Town Hall, in the morning.")])
    lottery_morning(party)
    state[:goal] = "Win Speaker Duvessa's seal at the Town Hall. It opens the north gate to Lonelywood."
    add_counter(:story_beats)
  rescue StandardError => e
    log("lottery_night: #{e.message}")
    Stage.cleanup rescue nil
    hide_square_folk(false) rescue nil
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil
    %i[lottery_stand alberica_marked auril_named seen_sephek_bryn].each { |f| set_flag(f) }
  end

  # "He walks out through the north gate. The guards step aside for him like
  # he's weather." The camera follows him; the gate guards step aside, then back.
  def sephek_walks_out(sephek)
    s = Stage
    line = "He walks out through the north gate. The guards step aside for him like he's weather."
    return say([line]) if !sephek || !s.map?
    guards = NORTH_GATE_GUARDS.map { |x, y| $game_map.events.values.find { |e| e.x == x && e.y == y && e.name == "Guard" } }
    gx, gy = NORTH_GATE_GUARDS[0]
    sephek.turn_up rescue nil
    s.walk_to(sephek, gx, gy + 1, wait_for: false)
    s.pan_to(gx, gy + 3, frames: 40)
    # the right-hand guard steps right, the left-hand one into its place: the gate's left tile opens
    g_left, g_right = guards
    s.walk(g_right, [PBMoveRoute::ThroughOn, PBMoveRoute::Right, PBMoveRoute::TurnLeft], wait_for: false) if g_right
    s.walk(g_left, [PBMoveRoute::ThroughOn, PBMoveRoute::Right, PBMoveRoute::TurnLeft], wait_for: false) if g_left
    say([line])
    guard = 0
    while sephek.move_route_forcing && guard < 200
      s.wait(1)
      guard += 1
    end
    s.leave(sephek, gx, 1)
    s.walk(g_left, [PBMoveRoute::Left, PBMoveRoute::TurnDown, PBMoveRoute::ThroughOff], wait_for: false) if g_left
    s.walk(g_right, [PBMoveRoute::Left, PBMoveRoute::TurnDown, PBMoveRoute::ThroughOff]) if g_right
    s.pan_back
  rescue StandardError => e
    log("sephek_walks_out: #{e.message}")
    s.pan_back rescue nil
  end

  # The morning after (context 02 M2-6): a night passes, the girl the whole
  # scene was for is alive at her door, and the Speaker sends for you.
  WEAVER_DOOR = [34, 31]

  def lottery_morning(_party = nil)
    s = Stage
    wx, wy = WEAVER_DOOR
    pbFadeOutIn do
      s.cleanup
      hide_square_folk(false)
      s.theme(nil)
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil
      if s.map?
        $game_player.moveto(wx, wy + 2) rescue nil
        $game_player.turn_up rescue nil
      end
    end
    ilda = mother = nil
    if s.map?
      ilda = s.actor(:ilda, wx, wy + 1, 2, graphic: "BW (16)")
      mother = s.actor(:ilda_mother, wx + 1, wy + 1, 2, graphic: "BW (62)")
    end
    say(["Morning. The square is empty. The lottery board is still up.",
         herald?(:alberica) ? "ILDA: (from the Weaver's door, to you) Will you sing the summer one again?" :
                              "ILDA: (from the Weaver's door, to Alberica) Will you sing the summer one again?"])
    speak(:alberica, "Every night till it comes back.", "...Yes.")
    s.leave_all([ilda, mother].compact, wx, wy) if ilda      # (home, through the Weaver's door)
    guard = s.actor(:hall_guard, wx, wy + 6, 8, graphic: "BWPoliceman") if s.map?
    s.approach(guard) if guard
    gid = guard ? guard.id : nil
    say(["GUARD: Speaker's compliments. Town Hall, when you're ready. She says bring the singer."], gid)
    # the Council session is optional and gone by Termalaine: point at it (notes 02 E23)
    say(["GUARD: The other Speakers sit with her first, in the Council Hall by the south street.",
         "GUARD: You can listen, if you like. Nobody's stopping strangers today."], gid) if respond_to?(:council_sitting?) && council_sitting?
    s.leave(guard, wx, wy + 8) if guard
    s.cleanup
  end

  #-----------------------------------------------------------------------------
  # Gym 2: Speaker Duvessa Shane, Hall of Speakers
  #-----------------------------------------------------------------------------
  # SC 2.08 - Gym 2: Speaker Duvessa Shane (the morning after the lottery)
  def leader_duvessa(event_id)
    if flag?(:badge_bryn)
      say(["DUVESSA: You have the town's seal. Go after him. The north gate's open."], event_id)
      return
    end
    if !flag?(:badge_targos)
      say(["DUVESSA: Bryn Shander's seal doesn't go to strangers with no name in the Dale.",
           "DUVESSA: Get Naerth's first. Then come back."], event_id)
      return
    end
    if !flag?(:lottery_stand)
      say(["DUVESSA: It's a draw night. No challenges until it's done.",
           "DUVESSA: Come back after. If you still want to."], event_id)
      return
    end
    say(["DUVESSA: Ten Speakers signed a bargain with Her. A life a month, or food, or warmth.",
         "DUVESSA: I signed it first. A necessary evil, we called it.",
         "DUVESSA: Last night you made me break it. Show me it was worth it.",
         cl(:reptin, "(under his breath) That was a compliment. Probably.")].compact, event_id)
    won = pbTrainerBattle(:FT_SPEAKER_F, "Duvessa", nil, false, 0)
    if won
      $Trainer.badges[1] = true
      set_flag(:badge_bryn)
      $game_switches[SW_BRYN_BADGE] = true if $game_switches
      set_switch(3913, true)                                    # the north gate opens
      say(["DUVESSA: Take the seal. Go after him."], event_id)
      pbMessage(_INTL("\\me[Badge get]{1} received the Palisade Seal!", $Trainer.name))
      say(["DUVESSA: And if you can end this, I'll owe you every name on that board."], event_id)
      pbReceiveItem(:TM118) rescue nil
      say(["DUVESSA: That TM teaches Steel Wing. You're leaving the walls. Take some steel with you."], event_id)
      duvessa_favours(event_id)
      # (Mishann waits outside: leaving the hall plays her scene, scene_mishann_steps)
      state[:goal] = "Sephek is in Lonelywood: out the north gate, through Termalaine."
    end
  end

  # The Ten-Towns favours, said before they pay (context 14, M14-1 A; owner's
  # call 2026-11-05: the favours pay well). The first time the spine says what
  # Ten-Towns is, to strangers, from the woman who leads its Council.
  def duvessa_favours(event_id = nil)
    pbBGMPlay("Opelucid City (White)") rescue nil
    if flag?(:council_session)
      say(["DUVESSA: What I said at the Council stands. Five towns. Mend them, and I'll pay."], event_id)
    else
      say(["DUVESSA: You're not from here. Ten towns, three lakes, ten Speakers. I lead them."], event_id)
      sayc([cl(:shade, "And you're telling strangers this because...?")])
      say(["DUVESSA: Because five of those towns are on your road. Each has a trouble it can't mend.",
           "DUVESSA: Mend one, and its Speaker writes to me. Mend all five, and the Council pays."], event_id)
    end
    sayc([cl(:alberica, "A government that pays its debts. I'll start mending, darling.")])
    favours_goal if respond_to?(:favours_goal)
  end

  #-----------------------------------------------------------------------------
  # Data registration
  #-----------------------------------------------------------------------------
  def register_encounters
    ENCOUNTERS.each do |map_id, enc|
      types = {}
      enc.each { |k, v| types[k] = v if k != :step_chances }
      key = sprintf("%d_0", map_id).to_sym
      begin
        GameData::Encounter::DATA[key] = GameData::Encounter.new(
          id: key, map: map_id, version: 0, step_chances: enc[:step_chances], types: types
        )
      rescue StandardError => e
        log("Encounters for #{map_id} skipped: #{e.message}")
      end
    end
  end

  # The version's own wild Pokémon, added when a map's encounters are set up.
  def add_version_encounters(tables, map_id)
    extra = (VERSION_ENCOUNTERS[version] || {})[map_id]
    return if !extra
    extra.each do |type, slots|
      next if !tables[type]
      slots.each { |s| tables[type] << s.dup unless tables[type].any? { |t| t[1] == s[1] } }
    end
  end
end

class PokemonEncounters
  alias ft_orig_setup setup unless method_defined?(:ft_orig_setup)
  def setup(map_ID)
    ft_orig_setup(map_ID)
    begin
      FrostThaw.add_version_encounters(@encounter_tables, map_ID) if FrostThaw.active?
    rescue StandardError => e
      FrostThaw.log("Version encounters failed: #{e.message}")
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_story_switches
  rescue StandardError => err
    FrostThaw.log("Story switches failed: #{err.message}")
  end
}
