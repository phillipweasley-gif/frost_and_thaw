#===============================================================================
# Frost & Thaw - dialogue for Act I, Chapter 1 (The Convergence, Targos)
#
# Each entry is a list of lines, or a lambda that returns one (for lines that
# change with the story, the mode, or which Herald you are).
#===============================================================================
module FrostThaw
  T = FrostThaw

  TEXT = {
    # --- Targos streets ------------------------------------------------------
    targos_gate_guard: -> {
      if T.flag?(:badge_targos)
        ["GUARD: That's the Speaker's seal. On you go.",
         "GUARD: The north road's dug out as far as Bryn Shander. Past that, you're on your own."]
      elsif T.flag?(:naerth_terms)
        ["GUARD: Lottery season. Nobody leaves Targos without the Speaker's seal.",
         "GUARD: He's back at the Town Hall. Ask him nicely. He likes nicely."]
      else
        ["GUARD: Lottery season. Nobody leaves Targos without the Speaker's seal.",
         "GUARD: He's at the Luskan Arms most nights. Doing business.",
         "GUARD: Ask him nicely. He likes nicely."]
      end
    },
    targos_cold_talk: ["Two years of night. The sun hasn't cleared the mountains since the Rime set in.",
                       "Some days the sky goes grey for an hour, like it's thinking about it. Then it gives up.",
                       "The Frostmaiden's angry with us. Nobody knows why. Everybody's got a guess."],
    targos_sacrifice_talk: ["Every new moon, Targos draws a name. Bryn Shander and Easthaven too. Whoever's drawn goes out onto the ice.",
                            "The little towns give their food, or their fires, instead. They can't spare people.",
                            "For Auril. Targos skipped it once. The storm that came after... We don't skip it anymore."],
    targos_lake_talk: ["Fishing's the only trade left on Maer Dualdon. Knucklehead trout, if you're lucky.",
                       "Magikarp, if you're not. Mostly you're not."],
    targos_child_talk: ["Grandma says if you hear laughing on the south wind, you go inside and don't look out.",
                        "She says it's the witch from Dougan's Hole. I looked out once. Just snow."],
    orvus_hollowgale: -> {
      if T.flag?(:met_party)
        ["ORVUS: That dagger your friend carries. Pale. Smokes in the cold.",
         "ORVUS: Rimefang, the old crews called that kind of blade. Bad luck with an edge on it.",
         "ORVUS: Throw it in the lake, if you've any sense. (He looks at you.) You won't."]
      else
        ["ORVUS: Five passengers off three ships, all in one night. In winter.",
         "ORVUS: Nobody travels the Dale in winter. Nobody sane."]
      end
    },
    closed_off: ["That way is closed off."],
    targos_barricade: ["A barricade of frozen crates and sledges blocks the road north."],
    targos_sign_square: ["TARGOS - Seat of Speaker Naerth Maxildanarr.", "Visitors are asked to mind their purses."],
    targos_termalaine_road: ["The east road to Termalaine runs outside the wall. It's buried in drifts higher than the gate."],
    targos_sign_hall: ["TARGOS TOWN HALL", "Speaker Naerth Maxildanarr. Petitions heard by appointment. Challengers welcome."],

    fisher_hob_after: ["HOB: Lake's colder than cold this year.",
                       "HOB: Old men say something's moving under the ice. I'm an old man. I say it too."],
    sailor_brannoc_after: ["BRANNOC: We passed a shape in the storm on the way in. Standing on the water.",
                           "BRANNOC: It wasn't a man. Or if it was, it isn't anymore."],

    # --- The Three Flags Sailing -----------------------------------------------------
    barkeep: -> {
      if T.flag?(:met_party)
        ["MA YARBROUL: Warmest room in Targos, ducks. Which isn't saying much.",
         "MA YARBROUL: Speaker's seal? Town Hall, up the main street. Bring coin, or bring Pokémon. And eat something first."]
      else
        ["A plump, grey-haired widow fusses along the benches, refilling stew bowls whether anybody asked or not.",
         "MA YARBROUL: Ethen Yarbroul. Ma, to this lot. Five strangers in one night, in winter? Sit. Eat.",
         "MA YARBROUL: Auril must be bored."]
      end
    },
    npc_alberica: ["ALBERICA: Well, hello, sweetheart. Pull up a stool. The fire's terrible, but the company's improving.",
                   "ALBERICA: (turning a pendant of black ice in her fingers) I threw this in the sea once. It came back.",
                   "ALBERICA: Now it's pulling me north. ...Don't make a thing of it. Have a drink."],
    npc_reptin: ["REPTIN: Good evening. You have the look of someone about to ask me a question.",
                 "REPTIN: (his medallion frosts over in his palm) It hasn't stopped pulsing since the docks. Rude of it.",
                 "REPTIN: The Sacred Flame says every ending is a crime. Winter has a place. Just not all of it."],
    npc_alerion: ["ALERION: My ring went cold when we came into the harbour. It does that near death magic.",
                  "ALERION: ...Or near her. The one in the furs.",
                  "ALERION: You saw her too. Don't look surprised."],
    npc_shade: ["SHADE: Our last job in Saltmarsh went sideways. Broken crates. A sigil burned in like frostbite.",
                "SHADE: (tapping a pale dagger) And this came aboard with us. Some nights it's colder than the wind.",
                "SHADE: Some nights it whispers. I'm told that's not normal, for a knife."],
    npc_shimmer: ["SHIMMER: The woman by the door. I've seen her before. On the Saltmarsh docks, in the snow. Watching.",
                  "SHIMMER: And there's a stone under my ribs that gets colder near shrines. That's new too.",
                  "SHIMMER: Don't tell Shade it scares me. Shade would try to be brave about it. Badly."],
    tavern_brawler_after: ["GORM: ...Fine. Keep the stool. It wobbles anyway."],

    # --- Pokémon Center, market, houses --------------------------------------
    center_traveler: ["There's a killer loose in the Dale. Walks through blizzards in his shirtsleeves.",
                      "Never shivers, they say. The Frostmaiden's chosen.",
                      "If you meet a man who doesn't feel the cold... run."],
    market_customer: ["Prices doubled since the Rime set in. Half of it goes to the Speaker, they say.",
                      "The other half goes to the Speaker too. They just don't say it."],
    epheris_thornweald: -> {
      if T.herald?(:alberica)
        ["EPHERIS: ...That pendant. Put it away, and don't take it out again.",
         "EPHERIS: Black ice that never melts. The Arcane Brotherhood would kill for it. I'd know. I was one.",
         "EPHERIS: It's Netherese. A key to a city lost in the glacier. Keep it hidden. Keep walking."]
      else
        ["EPHERIS: Relics from across the Dale. Old, odd, and occasionally cursed.",
         "EPHERIS: No refunds on the cursed ones. I used to be Brotherhood, you know. I got out. Mostly."]
      end
    },
    fisher_widow: ["WIDOW: He went fishing near Dougan's Hole. They heard laughing out on the ice. Then nothing.",
                   "WIDOW: Take his Spheal. It sits by the door every night. It shouldn't have to wait alone."],
    lantern_mother: ["We keep a lantern lit for my sister. The lottery took her last new moon.",
                     "Auril's chosen came for her himself. In his shirtsleeves. He didn't even shiver."],
    lantern_child: ["Is the sun real? Mama says it used to come up every day.", "Every day! That sounds made up."],

    # --- The Luskan Arms -----------------------------------------------------
    marek_draeven: -> {
      lines = ["MAREK: Anything you need, I can find. Anything you lose, I've probably already sold.",
               "MAREK: Naerth takes his cut of both, naturally."]
      if T.flag?(:met_party)
        lines << "MAREK: Between us. The Speaker keeps a ledger in his hall. Everyone in Targos is in it."
        lines << "MAREK: Some people would pay well to see a page go missing. I'm just saying words."
      end
      lines
    },
    skath: ["SKATH: I work for the Speaker. I watch the door. I watch strangers.",
            "SKATH: Right now, I'm watching you. Keep walking."],
    zhent_thug_1_after: ["DASK: Naerth hears about everything in this town. Now he'll hear about you."],
    zhent_thug_2_after: ["VEY: Keep your purse close in Targos. Closer than that."],

    # --- Town Hall --------------------------------------------------------
    hall_guide: -> {
      if !T.flag?(:naerth_terms)
        ["The Speaker's not in. Try the Luskan Arms. He does his business there, most nights."]
      else
        ["Welcome to the Town Hall. Mind the tables, and the people at them.",
         "The Speaker takes challenges from strangers who want his seal. He's at the back, behind the bar.",
         "Win, and you travel the Dale on Targos's good name. Lose, and... well. You'll owe him."]
      end
    },
    hall_guide_old: ["Welcome to the Town Hall. Mind the tables, and the people at them.",
                     "The Speaker takes challenges from strangers who want his seal. He's at the back, behind the bar.",
                     "Win, and you travel the Dale on Targos's good name. Lose, and... well. You'll owe him."],
    hall_enforcer_1_after: ["CORRIN: Fine. The Speaker will want to meet you now."],
    hall_enforcer_2_after: ["ILSA: Huh. Not bad, stranger. Not bad at all."],
    hall_dealer_after: ["MARA: Go on, then. He's watched every hand you've played since you walked in.",
                        "MARA: Naerth doesn't lose often. When he does, he remembers who."]
  }

  #-----------------------------------------------------------------------------
  # Party chat: what each companion says about where you are right now.
  # Areas group maps (all of Targos is :targos). Entries use the same variant
  # format as TEXT, so a line can depend on the story, the mode or the Herald.
  #-----------------------------------------------------------------------------
  AREAS = { 2001 => :targos, 2002 => :tavern, 2003 => :targos, 2004 => :luskan, 2005 => :hall,
            2006 => :targos, 2007 => :targos, 2008 => :targos, 2009 => :targos }

  COMPANION_NAMES = { alberica: "ALBERICA", reptin: "REPTIN", alerion: "ALERION",
                      shade: "SHADE", shimmer: "SHIMMER" }

  PARTY_CHAT = {
    alberica: {
      targos:  ["Everyone here's counting coins or counting days. I could write a very sad song about Targos.",
                "...I might. Somebody should remember this place kindly. Then a rude one, to cheer us up."],
      tavern:  ["The fire's dying and nobody's feeding it. That's the Dale in one picture.",
                "Barkeep! Another log, and another drink. In that order. Or the other order."],
      luskan:  [{ if: { flag: :met_party }, lines: ["Marek keeps looking at my pendant. I keep looking at his hands.",
                                                    "Light fingers. I know the type, sweetheart. I used to date the type."] },
                ["This place smells like stolen fish and bad decisions.", "I've made worse ones. Fewer fish, though."]],
      hall:    ["Naerth sits like a king on a throne of debts. I've met his kind.",
                "My family was his kind. I left them a song on the way out. Not a nice one."]
    },
    reptin: {
      targos:  ["The frost here crawls in patterns. Like handwriting.",
                "My medallion pulses every time I try to read it. Whatever this winter is, it isn't weather."],
      tavern:  ["Five strangers, one fire. The Sacred Flame would call it an omen.",
                "I call it a cold night, and an excellent excuse for another round."],
      luskan:  ["Naerth's people look at me like a tool they haven't found a use for yet.",
                "(under his breath) They'll find I'm the kind that cuts."],
      hall:    ["A ruler who keeps everyone in debt. That's just another way to freeze a town in place.",
                "Leave the talking to me. You stand behind me and look expensive."]
    },
    alerion: {
      targos:  [{ if: { time: :night }, lines: ["The dead are restless tonight. My ring is cold as a grave.", "Colder. I checked."] },
                ["My ring hasn't warmed since we landed. Something here was waiting for me.", "It can wait longer."]],
      tavern:  ["The woman in the furs looked at each of us like she was counting.",
                "Nobody counts strangers unless they mean to take some."],
      luskan:  ["The Brotherhood has eyes in here. I can feel them on my back.", "I'm not turning round. That's what they want."],
      hall:    ["Win his seal and he calls us friends. Lose, and he calls us debtors.",
                "Either way he calls us. I don't like being called."]
    },
    shade: {
      targos:  ["The dagger's quiet here. I don't like it quiet. Quiet means it's listening.", "Same goes for Shimmer, actually."],
      tavern:  ["Shimmer thinks that woman followed us from Saltmarsh.", "Shimmer's usually right. It's her worst quality."],
      luskan:  [{ if: { flag: :met_party }, lines: ["Orvus on the docks knew this blade. Looked at it like it owed him money.",
                                                    "Everything in this town owes somebody money. Even the knives."] },
                ["Smugglers' den. Feels like home.", "That's not a compliment to either of us."]],
      hall:    ["If Naerth keeps a ledger, there's a page in it with our names by morning.",
                "I'd like to be on the page that goes missing."]
    },
    shimmer: {
      targos:  ["My stone's colder near the shrines. There's one on every street.",
                "Auril's shrines. They keep her close in Targos. Closer than I'd like."],
      tavern:  ["Don't tell Shade, but I keep checking the door.", "If she comes back, I'd like to see her first."],
      luskan:  ["I used to work rooms like this. Smile, listen, count the exits.",
                "Four exits. Two of them are windows. One of them is Shade."],
      hall:    ["Naerth would sell the lake if someone could carry it.", "Let's not be the ones who help him lift."]
    }
  }

  module_function

  # Picks the right lines for a TEXT entry. An entry is:
  #   ["line", ...]                                   always these lines
  #   -> { [...] }                                    computed
  #   [{ if: {conditions}, lines: [...] }, ..., [...]] first matching variant
  def lines_for(key)
    return resolve(TEXT[key]) || ["..."]
  end

  def resolve(entry)
    entry = entry.call if entry.respond_to?(:call)
    return nil if entry.nil?
    return entry if entry.all? { |e| e.is_a?(String) }
    entry.each do |variant|
      return variant if variant.is_a?(Array)
      next if !variant.is_a?(Hash)
      return variant[:lines] if condition_met?(variant[:if] || {})
    end
    return nil
  end

  # Conditions a line can depend on.
  def condition_met?(cond)
    cond.all? do |k, v|
      case k
      when :flag     then Array(v).all? { |f| flag?(f) }
      when :not_flag then Array(v).none? { |f| flag?(f) }
      when :herald   then Array(v).include?(herald)
      when :mode     then mode == v
      when :version  then version == v
      when :map      then Array(v).include?($game_map.map_id)
      when :area     then Array(v).include?(AREAS[$game_map.map_id])
      when :with     then Array(v).all? { |c| companions.include?(c) }
      when :time     then (v == :night) == (PBDayNight.isNight? rescue false)
      else true
      end
    end
  end

  # Who travels with you right now (not counting yourself).
  def companions
    list = state[:companions] || []
    return list.reject { |c| c == herald }
  end
end
