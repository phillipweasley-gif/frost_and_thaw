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
         "GUARD: The east road's dug out as far as Bryn Shander. Past that, you're on your own."]
      elsif T.flag?(:naerth_terms)
        ["GUARD: Lottery season. Speaker Naerth runs Targos, and nobody leaves without his seal.",
         "GUARD: He's back at the Town Hall. Ask him nicely. He likes nicely."]
      else
        ["GUARD: Lottery season. Speaker Naerth runs Targos, and nobody leaves without his seal.",
         "GUARD: He's at the Luskan Arms most nights. Doing business.",
         "GUARD: Ask him nicely. He likes nicely."]
      end
    },
    # The street notices what you've done (notes/01 S5): one line each after the seal.
    targos_cold_talk: -> {
      next ["Leaving, with the Speaker's seal? Walk fast. The cold's worse past the wall."] if T.flag?(:badge_targos)
      ["Two years of night. The sun hasn't cleared the mountains since this winter set in.",
       "Some days the sky goes grey for an hour, like it's thinking about it. Then it gives up.",
       "The Frostmaiden's angry with us. Nobody knows why. Everybody's got a guess."]
    },
    targos_sacrifice_talk: -> {
      next ["You beat the Speaker? Then you'll be gone before the draw. Lucky."] if T.flag?(:badge_targos)
      ["Every new moon, a name's drawn. Whoever's drawn goes out onto the ice.",
       "The little towns give their food, or their fires, instead. They can't spare people.",
       "For Auril. Targos skipped it once. The storm that came after... We don't skip it anymore."]
    },
    targos_lake_talk: -> {
      next ["The Speaker lost a fight? Ha. The trout'll hear about it by morning."] if T.flag?(:badge_targos)
      ["Fishing's the only trade left on Maer Dualdon. Knucklehead trout, if you're lucky.",
       "Magikarp, if you're not. Mostly you're not."]
    },
    targos_child_talk: -> {
      next ["Are you going out past the wall? If you hear laughing, don't look. Promise."] if T.flag?(:badge_targos)
      ["Grandma says if you hear laughing on the south wind, you go inside and don't look out.",
       "She says it's the witch from Dougan's Hole. I looked out once. Just snow."]
    },
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
    velryn_sign: ["THE VELRYNS - Scrimshaw carved to order. Knock loud; we're usually in the back."],
    targos_sign_square: ["TARGOS - Seat of Speaker Naerth Maxildanarr.", "Visitors are asked to mind their purses."],
    targos_sign_hall: ["TARGOS TOWN HALL", "Speaker Naerth Maxildanarr. Petitions heard by appointment. Challengers welcome."],

    fisher_hob_after: ["HOB: Lake's colder than cold this year.",
                       "HOB: Old men say something's moving under the ice. I'm an old man. I say it too."],
    sailor_brannoc_after: ["BRANNOC: We passed a shape in the storm on the way in. Standing on the water.",
                           "BRANNOC: It wasn't a man. Or if it was, it isn't anymore."],

    # --- The Three Flags Sailing -----------------------------------------------------
    barkeep: -> {
      if T.flag?(:met_party)
        ["MA YARBROUL: Warmest room in Targos, ducks. Which isn't saying much.",
         T.flag?(:naerth_terms) ? "MA YARBROUL: Speaker's seal? Town Hall, up the main street. Bring Pokémon." :
                                  "MA YARBROUL: Speaker's seal? Naerth's at the Luskan Arms. Bring coin, or Pokémon.",
         "MA YARBROUL: Pokémon hurt? The Center heals them for nothing. Only free thing in Targos."]
      else
        ["MA YARBROUL: Ethen Yarbroul. Ma, to this lot.",
         "MA YARBROUL: Strangers, all of you, in winter? Go and sit with them. I'll bring stew."]
      end
    },
    # What each says at their table once you've met them (SC 1.03 plays the
    # first time: FT.tavern_table). Nothing here spends a later line: not
    # Alberica's rune ("pulling me north", 2.07), not Shimmer's fear (1.07).
    npc_alberica: ["ALBERICA: Well, hello, sweetheart. Pull up a stool. The company's improving.",
                   "ALBERICA: Go on, meet the others. I'm saving my best material for later."],
    npc_reptin: ["REPTIN: (frost on his medallion) It hasn't stopped pulsing since the docks. I did ask.",
                 "REPTIN: The Sacred Flame says every ending is a crime. Winter has a place. Just not all of it."],
    npc_alerion: ["ALERION: My ring went cold when we came into the harbour. It does that near death magic.",
                  "ALERION: ...Or near her. The one in the furs.",
                  "ALERION: You saw her too. Don't look surprised."],
    npc_shade: ["SHADE: Our last job in Saltmarsh went sideways. Broken crates. A frost sigil, burned in.",
                "SHADE: Some nights the knife whispers. I'm told that's not normal, for a knife."],
    npc_shimmer: ["SHIMMER: The woman by the door. I've seen her before. Saltmarsh docks, in the snow.",
                  "SHIMMER: Watching."],
    tavern_brawler_after: ["GORM: ...Fine. Keep the stool. It wobbles anyway."],

    # --- Pokémon Center, market, houses --------------------------------------
    center_traveler: ["TRAPPER: There's a killer loose in the Dale. Walks through blizzards in his shirtsleeves.",
                      "TRAPPER: Never shivers, they say. The Frostmaiden's chosen.",
                      "TRAPPER: If you meet a man who doesn't feel the cold... run."],
    market_customer: ["Prices doubled since this winter set in. Half of it goes to the Speaker, they say.",
                      "The other half goes to the Speaker too. They just don't say it."],
    epheris_thornweald: -> {
      if T.herald?(:alberica)
        ["EPHERIS: Still carrying that pendant? It's Netherese. A key to a city lost in the glacier.",
         "EPHERIS: Keep it hidden. Keep walking."]
      else
        ["EPHERIS: Relics from across the Dale. Old, odd, and occasionally cursed.",
         "EPHERIS: No refunds on the cursed ones. I used to be Brotherhood, you know. I got out. Mostly."]
      end
    },
    fisher_widow: ["WIDOW: My husband fished near Dougan's Hole. Folk heard laughing on the ice. Then nothing.",
                   "WIDOW: Take his Spheal. It sits by the door every night. It shouldn't have to wait alone."],
    # Marta's sister: the strongest Sephek setup in Targos, answered by the one
    # Herald who knows his name, once she's said it to Naerth (notes/01 S6).
    lantern_mother: -> {
      ["MARTA: We keep a lantern lit for my sister. She paid to keep her name off the lottery.",
       "MARTA: Everyone does, if they can.",
       "MARTA: They found her on the ice a week later. A knife of ice in her. In her own coat.",
       "MARTA: A man in his shirtsleeves was seen on our street that night. He didn't even shiver.",
       T.flag?(:naerth_terms) ? T.cl(:shimmer, "(very quietly) Sephek. He's been here.") : nil].compact
    },
    lantern_child: ["Is the sun real? Mama says it used to come up every day.", "Every day! That sounds made up."],

    # --- The Luskan Arms -----------------------------------------------------
    marek_draeven: -> {
      lines = ["MAREK: Anything you need, I can find. Anything you lose, I've probably already sold.",
               "MAREK: Naerth takes his cut of both, naturally."]
      lines << "MAREK: Between us. The Speaker keeps a ledger in his hall. Everyone in Targos is in it." if T.flag?(:met_party)
      lines
    },
    skath: ["SKATH: I work for the Speaker. I watch the door. I watch strangers.",
            "SKATH: Right now, I'm watching you. Keep walking."],
    zhent_thug_1_after: ["DASK: Naerth hears about everything in this town. Now he'll hear about you."],
    zhent_thug_2_after: ["VEY: Keep your purse close in Targos. Closer than that."],

    # --- Town Hall --------------------------------------------------------
    # The guide stands in the first gap until Naerth has asked for you, so the
    # hall can't send you round its tables for nobody (notes/01 E16, E22).
    hall_guide: -> {
      if !T.flag?(:naerth_terms)
        ["GUIDE: The Speaker's not in. Try the Luskan Arms. He does his business there, most nights.",
         "GUIDE: Green? Jod's lot spar in the yard by the hall. Free, and they patch you up after."]
      else
        ["GUIDE: Welcome to the Town Hall. Mind the tables, and the people at them.",
         "GUIDE: His three people at the tables first. Then the Speaker, at the back, behind the bar.",
         "GUIDE: Win, and his seal opens any gate on the lake. Lose, and... well. You'll owe him."]
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
      targos:  ["Everyone here's counting coins or days. I could write Targos a very sad song.",
                "...I might. Somebody should remember it kindly. Then a rude one, to cheer us up."],
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
                "My medallion pulses every time I try to read it. This winter isn't weather."],
      tavern:  ["Five strangers, one fire. The Sacred Flame would call it an omen.",
                "I call it a cold night, and an excellent excuse for another round."],
      luskan:  ["Naerth's people look at me like a tool they haven't found a use for yet.",
                "(under his breath) They'll find I'm the kind that cuts."],
      hall:    ["A ruler who keeps everyone in debt. Another way to freeze a town in place.",
                "Leave the talking to me. You stand behind me and look expensive."]
    },
    alerion: {
      targos:  [{ if: { time: :night }, lines: ["The dead are restless tonight. My ring is cold as a grave.", "Colder. I checked."] },
                ["My ring hasn't warmed since we landed. Something here was waiting for me.", "It can wait longer."]],
      tavern:  [{ if: { flag: :told_somewhere }, lines: ["\"Somewhere else.\" Good answer. I use it myself.",
                                                       "The woman in the furs looked at each of us like she was counting. You longest."] },
                ["The woman in the furs looked at each of us like she was counting.",
                 "Nobody counts strangers unless they mean to take some."]],
      luskan:  ["The Black Network has eyes in here. I can feel them on my back.", "I'm not turning round. That's what they want."],
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
      targos:  [{ if: { flag: :glass_read }, lines: ["My stone's colder near the shrines. There's one on every street.",
                                                     "Your glass hums when my stone does. I don't like that either."] },
                ["My stone's colder near the shrines. There's one on every street.",
                 "Auril's shrines. They keep her close in Targos. Closer than I'd like."]],
      tavern:  [{ if: { flag: :shimmer_warm }, lines: ["You kept quiet when Shade asked. Good. Keep doing that.",
                                                     "Don't tell Shade, but I keep checking the door."] },
                ["Don't tell Shade, but I keep checking the door.", "If she comes back, I'd like to see her first."]],
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
      when :switch   then Array(v).all? { |sw| $game_switches && $game_switches[sw] }
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
