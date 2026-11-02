#===============================================================================
# Frost & Thaw - Act I, Chapter 3: Shimmer's Requiem
#
# Lonelywood (after map 1.14 of Rime of the Frostmaiden), the Glade of the
# Unmade, the Moon Temple and the Wennen's Warren (after the "Shimmer's
# Sacrifice" campaign notes).
#
#   1. Lonelywood. Speaker Nimsy Huddle lets you sleep in her heated attic.
#   2. That night Sephek takes Shimmer to the Glade. Alberica's pendant shows
#      the party her choice: she refuses Auril, shatters the Lodestone of Frost
#      and takes his blade "for them". An undying rose and a beating Heart of
#      Ice are all that remain.
#   3. At the Glade: the rose, the heart, and Meat Meat, half-frozen, looking
#      for Razzy. She speaks his name to the egg, finishing the rite.
#   4. The Moon Temple: Sephek comes for the heart and is struck down; the ice
#      closes over him (he returns in Act III).
#   5. The Wennen's Warren: Zenith Abbott performs the Moon Requiem beneath the
#      Undying Rose, and the frost egg takes her heart (it hatches at the
#      Verdant Reversal): not Auril's vessel any more, but her answer.
#===============================================================================
module FrostThaw
  SW_NORTH_OPEN    = 3913
  SW_REQUIEM_DONE  = 3914   # opens Bryn Shander's east gate (Chapter 4)
  SW_SEPHEK_DOWN   = 3915
  SW_SHIMMER_TAKEN = 3916
  GLADE_MAP = 2026         # the Glade of the Unmade (tools/build_ch3.rb)
  SW_HEART_TAKEN   = 3917
  SW_WENNEN_FOLLOW = 3964   # the Wennen haul Sephek's ice south (SC 3.08): his statue leaves the Moon Temple
  SW_MEAT_JOINED   = 3965   # Meat Meat travels with you: her Glade self is gone

  MAPS.merge!(lonely_road: 2020, lonelywood: 2021, warren: 2022, moon_grounds: 2023, lucky_liar: 2024,
              moon_sanctum: 2025, glade: 2026, speaker_house: 2027, scrimshander: 2028, fisher_house: 2029)
  MAP_NAMES.merge!(
    2020 => "Lonelywood Road", 2021 => "Lonelywood", 2022 => "Wennen's Warren", 2023 => "Moon Temple",
    2024 => "The Lucky Liar", 2025 => "Moon Temple Sanctum", 2026 => "Glade of the Unmade",
    2027 => "Speaker Huddle's House", 2028 => "The Happy Scrimshander", 2029 => "Fisher's House"
  )
  MAP_METADATA.merge!(
    2020 => { outdoor_map: true, announce_location: true, weather: [:Snow, 80], battle_environment: :Forest },
    2021 => { outdoor_map: true, announce_location: true, weather: [:Snow, 40], battle_environment: :Snow },
    2022 => { announce_location: true, battle_environment: :Cave },
    2023 => { outdoor_map: true, announce_location: true, battle_environment: :Snow },
    2026 => { outdoor_map: true, announce_location: true, battle_environment: :Snow }
  )
  AREAS.merge!(2020 => :lonely_road, 2021 => :lonelywood, 2024 => :lucky_liar, 2027 => :lonelywood,
               2028 => :lonelywood, 2029 => :lonelywood, 2022 => :warren, 2023 => :moon_temple,
               2025 => :moon_temple, 2026 => :glade)
  MARTS[:lonelywood] = [:POKEBALL, :GREATBALL, :POTION, :SUPERPOTION, :ANTIDOTE, :PARLYZHEAL,
                        :AWAKENING, :ICEHEAL, :BURNHEAL, :ESCAPEROPE, :REPEL, :SUPERREPEL]
  # Where you wake after losing, once you've slept in Nimsy's attic.
  LONELYWOOD_REST = [2021, 14, 24, 2]

  ENCOUNTERS[2020] = { step_chances: { Land: 21 },
                       Land: [[20, :HOOTHOOT, 15, 18], [15, :PINECO, 15, 17], [15, :TEDDIURSA, 15, 18],
                              [15, :SWINUB, 16, 18], [15, :SPINARAK, 15, 17], [10, :SNEASEL, 16, 19],
                              [10, :MURKROW, 16, 18]] }
  VERSION_ENCOUNTERS[:frost][2020] = { Land: [[10, :MISDREAVUS, 16, 18]] }
  VERSION_ENCOUNTERS[:thaw][2020]  = { Land: [[10, :HOPPIP, 15, 17]] }

  COMPANION_NAMES[:meat_meat] = "MEAT MEAT"

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_SEPHEK: ["Auril's Chosen", :MYSTICALMAN, 0, 120, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    bug_catcher_pell: [:BUGCATCHER,       "Pell",   [[:SPINARAK, 15], [:PINECO, 16]],
                       "My bugs hate the cold. I'm starting to see their point."],
    lady_maren:       [:BEAUTY,           "Maren",  [[:B35H220, 16], [:SNUBBULL, 16]],
                       "Lonelywood's dreadful, darling. That's why I love it."],
    hiker_osk:        [:HIKER,            "Osk",    [[:GRAVELER, 16], [:B220H95, 17]],
                       "Felled by a stranger. Like a pine."],
    aurilite_four:    [:FT_AURILITE,      "Wyst",   [[:SWINUB, 16], [:B215H200, 17]],
                       "The cold man walked this road at dawn. He didn't leave tracks."],
    ranger_tamsa:     [:POKEMONRANGER_F,  "Tamsa",  [[:HOOTHOOT, 16], [:B215H163, 17]],
                       "Mind the white moose past the town. It's smarter than it looks."],
    fisher_garrow:    [:FISHERMAN,        "Garrow", [[:POLIWHIRL, 17], [:B118H220, 17]],
                       "Knucklehead trout bit better than that."],
    logger_breck:     [:WORKER,           "Breck",  [[:MACHOP, 16], [:B204H95, 16]],
                       "The forest pushes back these days. So do strangers, I guess."],
    liar_brawler:     [:ROUGHNECK,        "Tobb",   [[:KOFFING, 16], [:B19H215, 17]],
                       "I'd tell you I let you win, but this is the Lucky Liar."],
    aurilite_five:    [:FT_AURILITE,      "Hale",   [[:B220H92, 18], [:SNEASEL, 18]],
                       "The moon belongs to the rabbits. The cold belongs to her."],
    aurilite_six:     [:FT_AURILITE,      "Iven",   [[:MISDREAVUS, 18], [:B87H220, 19]],
                       "Sephek will come for what you carry. He always comes."],
    sephek:           [:FT_SEPHEK,        "Sephek", [[:B215H92, 20], [:B220H93, 21], [:B124H200, 21], [:B87H215, 23]],
                       "...So cold. Why is it so cold?", [:SUPERPOTION, :SUPERPOTION]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  WENNEN_LINES = {
    jet_sentry:       ["JET SENTRY: Scout of the Pinewalls. I tracked the cold man to the altar where she died.",
                       "JET SENTRY: A goblin like your little one ran past our pinewalls weeks ago. Toward the light."],
    aurora_traveller: ["AURORA TRAVELLER: Sit. Warm your hands. The moonfire here doesn't go out. I see to that.",
                       "AURORA TRAVELLER: Cold scrying can't see through cinderwood. You're hidden here."],
    eclipse_spicer:   ["ECLIPSE SPICER: Oh, I hear everything. Gossip is history nobody's written down yet.",
                       "ECLIPSE SPICER: A woman with books and bones has been asking after frozen hearts.",
                       "ECLIPSE SPICER: Avarice, she's called. She wants a third."],
    pulsar_bond:      [{ if: { flag: :requiem_done }, lines: ["PULSAR BOND: Two eggs now. One green, one ice. Neither will hatch here.",
                                                              "PULSAR BOND: I think they're waiting for the same thing."] },
                       ["PULSAR BOND: Moonroot, frostbalm, a little patience. That's most of healing.",
                        "PULSAR BOND: The egg in your coat has changed. Moonlight and a heart of ice did that.",
                        "PULSAR BOND: Verdant transfiguration, we call it. Keep it warm."]],
    celeste_scribe:   ["CELESTE SCRIBE: The Hearts of Ice are failed vessels.",
                       "CELESTE SCRIBE: Each time she wears a mortal body, one is left behind.",
                       "CELESTE SCRIBE: Gather enough in the wrong place and she walks again. Remember that, up north."],
    cosmo_bookman:    ["COSMO BOOKMAN: I collect final words. I have hers. \"For them.\"",
                       "COSMO BOOKMAN: Some last words are a door closing. Hers was one opening."],
    stellar_fletcher: ["STELLAR FLETCHER: I forge with silverthread and moonlight. I won't forge with that heart.",
                       "STELLAR FLETCHER: Some metals remember who they belonged to."],
    helios_meadow:    ["HELIOS MEADOW: The Veinflower wilts when the Frostmaiden looks this way. All week, it's wilted.",
                       "HELIOS MEADOW: But it's blooming at you. Interesting."],
    luna_carver:      [{ if: { with: :meat_meat }, lines: ["LUNA CARVER: Ah. The Squeak of Destiny. Moon-touched, that one.",
                                                           "LUNA CARVER: Don't let her go hungry. Or uncaffeinated."] },
                       ["LUNA CARVER: I dream for the Circle. Lately I dream of a broken moon,",
                        "LUNA CARVER: and two eggs in a nest of roots."]],
    luna_camp:        ["LUNA CARVER: We keep what the cold leaves. We kept an egg for two years.",
                       "LUNA CARVER: The cold man sleeps on the sledge. His heart still beats. We watch it from here."],
    jet_sentry_gate:  ["JET SENTRY: The east gate is open. South-east to Dougan's Hole, and past it, the laughing.",
                       "JET SENTRY: The Circle follows at a distance. We don't leave a beating piece of her unwatched."],
    umbra_rider:      ["UMBRA RIDER: Two hearts is a burden. Three is a summons. Never carry three.",
                       "UMBRA RIDER: The old texts name what three hearts make. The Rewritten Auril.",
                       "UMBRA RIDER: Pray you never need to know more."]
  }

  TEXT.merge!(WENNEN_LINES)
  TEXT.merge!(
    bryn_north_guard_open: ["GUARD: North path to Termalaine, and Lonelywood past it. Loggers, fishers, folk who'd rather not be found.",
                            "GUARD: The man in the shirt went that way. We didn't follow."],
    # --- Lonelywood Road -----------------------------------------------------------
    sign_lonely_road: ["LONELYWOOD ROAD", "North to Lonelywood. Beware the white moose."],
    sign_stream: ["The stream is frozen solid. Someone has laid logs across it anyway, out of habit."],
    lonely_road_woodcutter: ["WOODCUTTER: A man passed at dawn in his shirtsleeves. Snow on his shoulders. Didn't melt.",
                             "WOODCUTTER: He asked if I'd seen a girl with a stone that hums.",
                             "WOODCUTTER: I said no. I'm glad it was true."],
    bug_catcher_pell_after: ["Lonelywood's got bugs nobody's catalogued. Mostly because they're frozen."],
    lady_maren_after: ["I came to Icewind Dale for the scenery. There isn't any. It's all snow."],
    hiker_osk_after: ["The pines get thicker toward Lonelywood. And quieter. I don't like the quiet."],
    aurilite_four_after: ["Every time someone tells her no, the winter gets longer. You lot say no a lot."],
    ranger_tamsa_after: ["Lonelywood's Speaker bakes cookies for strangers. That's how you know you're welcome."],
    # --- Lonelywood ------------------------------------------------------------------
    lonely_sign: ["LONELYWOOD", "Logging, fishing, scrimshaw. Speaker: Nimsy Huddle.", "(The house with the green roof.)"],
    sign_moon_temple: ["North: the Moon Temple.", "Someone has carved little spirals into the post. They glow faintly."],
    sign_glade_road: ["East: the old logging road.", "Scratched underneath: \"NOT PAST THE STONES.\""],
    ramshackle_closed: ["RAMSHACKLE. The town's only inn. Closed since its owner was found hanged, two winters back.",
                        "Some say he didn't do it himself. The door is nailed shut."],
    scoop_huddle: -> {
      if T.flag?(:rested_lonelywood)
        ["SCOOP: Mama says you can sleep in the attic any time! It's the warmest place in Lonelywood."]
      else
        ["SCOOP: Are you the strangers from Bryn Shander? Mama baked cookies!",
         "SCOOP: They're shaped like halflings!",
         "SCOOP: Our house is the green one. Come in! Everyone comes in."]
      end
    },
    huddle_kids: ["The Huddle children chase each other round the table with wooden swords.",
                  "One stops long enough to offer you a slightly squashed cookie."],
    lonely_fisher: ["Half of Lonelywood fishes, half fells trees. The other half lies about it at the Lucky Liar."],
    lonely_logger: ["Something's been chasing loggers out of the woods. A white moose, they say. Big as a cabin.",
                    "Smart, too. Like it knows where we'll be before we do."],
    lonely_moon_talk: [{ if: { flag: :requiem_done }, lines: ["Hear the singing last night, up by the temple? Rabbits singing.",
                                                              "And something answered."] },
                       ["There are rabbits in the woods north of here. The size of people, with lanterns.",
                        "My mother called them the Wennen. Moon-keepers. You don't find them. They find you."]],
    lonely_north_path: ["The path north climbs to the Moon Temple. Old stones, older than the town.",
                        "Folk leave offerings up there on full-moon nights. Nobody says to whom."],
    jet_sentry_town: -> {
      if T.flag?(:heart_of_ice)
        ["JET SENTRY: Bring the heart north, past the Moon Temple, to our Warren.",
         "JET SENTRY: Zenith will know what to do.",
         "JET SENTRY: And hurry. The cold man follows its pulse."]
      else
        ["JET SENTRY: I am Jet Sentry, of the Wennen. I watched the cold man carry her east.",
         "JET SENTRY: Along the logging road, to the Glade of the Unmade. Past the standing stones.",
         "JET SENTRY: I'm sorry. I was too slow."]
      end
    },
    fisher_garrow_after: ["The lake's frozen ten feet down. I still fish. What else would I do?"],
    logger_breck_after: ["Speaker Huddle says she'll deal with the moose. Speaker Huddle's never met the moose."],
    danae_xotal: ["DANAE: Welcome to the Lucky Liar. Every story told here is true, and none of them happened.",
                  "She smiles, and files your faces away somewhere behind her eyes."],
    liar_tall_tale: ["I once caught a trout so big it ate my boat. Then I ate the trout. Then I ate the boat.",
                     "...What? It's the Lucky Liar."],
    liar_fisher: ["Danae's been behind that bar twenty years. Never once said where she came from."],
    liar_brawler_after: ["Buy me a drink and I'll tell you a lie about it."],
    scrim_customer: ["Iriskree carves the finest scrimshaw on the lake.", "Don't ask what she did before. She'll only smile."],
    lakeside_elder: ["When I was a boy, the sun came up every morning. I'd like to see it once more before I go."],
    # --- the Glade ------------------------------------------------------------------
    glade_altar_before: ["A slab of stone older than names, ringed by standing stones. Frost grows on it in spirals.",
                         "It's very quiet here. Like the glade is holding its breath."],
    undying_rose: ["A single rose grows from the altar, frozen mid-bloom, its petals rimed with hoarfrost.",
                   "It's warm to the touch. It does not wilt."],
    meat_meat_glade: ["MEAT MEAT: Razzy not dead. Just very cold. You keep egg warm, yes? Meat Meat helps."],
    # --- the Moon Temple -------------------------------------------------------------
    nova_keeper: -> {
      if T.flag?(:sephek_defeated)
        ["NOVA KEEPER: He sleeps in the ice now. Not dead. The cold doesn't let its chosen die so easily.",
         "NOVA KEEPER: We'll watch him. Go below. Zenith is waiting at the Rose."]
      else
        ["NOVA KEEPER: Warden of the Glade. These stones are ours to keep.",
         "NOVA KEEPER: The Warren's door is the lodge below. Go in quietly. The Circle is grieving."]
      end
    },
    aurilite_five_after: ["He'll take it back. Whatever of hers you've got. He takes everything back."],
    aurilite_six_after: ["The temple was hers once. Before the rabbits. Before the moon."],
    sephek_frozen: ["Sephek Kaltro kneels inside a pillar of clear ice, head bowed, as if still weeping.",
                    "His blade lies across his knees.", "Deep in his chest, frost-light flickers. Slowly. Like a heartbeat."],
    aphelion_roads: ["APHELION ROADS says nothing. The old warnings tattooed in his fur say enough.",
                     "(He's guarding a sealed door. It isn't time for it yet.)"],
    sanctum_aurilite_ghost: ["An old priestess of Auril kneels at the altar.",
                             "When you come close, she's only frost in the shape of a woman."],
    # --- the Warren -------------------------------------------------------------------
    warren_bolt_tunnel: ["A bolt tunnel: a narrow way up to the surface, screened with roots. The Wennen keep it clear."],
    undying_rose_warren: -> {
      if T.flag?(:requiem_done)
        ["A cutting of the Undying Rose blooms over a sacred stone.",
         "Beneath it the earth is warm, and very faintly, something beats."]
      else
        ["A cutting of the Undying Rose blooms over a sacred stone. Its petals are silver in the fungal light."]
      end
    },
    warren_nursery: -> {
      if T.flag?(:requiem_done)
        ["The nest of roots in the nursery is empty now.",
         "Only shell fragments, glittering like frost, and a feather of cold mist."]
      else
        ["The Warren's nursery: a nest of warm roots.",
         "In it rests an egg of pale blue ice, veined with silver.",
         "Two Wennen guard it. Neither will say where it came from."]
      end
    },
    shadow_vault: ["THE SHADOW VAULT. A tunnel sealed with stone and old lunar warnings.",
                   "The Circle opens it only by choice. (The Circle hasn't chosen.)"]
  )

  PARTY_CHAT[:alberica].merge!(
    lonely_road: ["Pines this thick swallow sound. It's like walking through a held breath."],
    lonelywood: [{ if: { flag: :shimmer_taken }, lines: ["I keep humming her song. The one she pretended not to like."] },
                 ["A logging town that bakes cookies for strangers. I think I'm in love with Lonelywood."]],
    lucky_liar: ["Every story in here's a lie. Best-behaved room I've been in all year.",
                 "Buy me a drink and I'll tell you the truth. Two drinks, I'll tell you a better one."],
    glade: ["My pendant broke when she... I saw all of it.",
            "I'll write it down. Somebody has to sing it right."],
    moon_temple: ["Old stone, older song. The Wennen sing to the moon here. I want that tune."],
    warren: ["It smells like mint and rain. I haven't smelled rain in two years.", "Don't let me cry, I'm wearing kohl."]
  )
  PARTY_CHAT[:reptin].merge!(
    lonely_road: ["The forest is alive under the snow. I can feel it waiting."],
    lonelywood: [{ if: { flag: :shimmer_taken }, lines: ["She said no to a god. The Flame taught me that was impossible.",
                                                         "She did it anyway."] },
                 ["Loggers and wolves both live off this forest. Only one of them asks permission."]],
    lucky_liar: ["The barkeep watches everyone who comes in like she's taking inventory.",
                 "I'd love to know what she's got on us. Purely professionally."],
    glade: ["The frost bends away from the altar. Like it's afraid of her rose."],
    moon_temple: ["My medallion's quiet here. First time since Targos. I could almost get used to it."],
    warren: ["Roots for ribs, earth for skin. This place is alive in a way I understand."]
  )
  PARTY_CHAT[:alerion].merge!(
    lonely_road: [{ if: { time: :night }, lines: ["He walked this road. My ring knows where his cold went."] },
                  ["Sephek came this way. He's not hiding. He wants to be followed."]],
    lonelywood: [{ if: { flag: :shimmer_taken }, lines: ["I've stood at a lot of gravesides.", "This is the first with nothing to bury."] },
                 ["Lonelywood is for people who don't want to be found. We'll fit in."]],
    lucky_liar: ["Someone in here is Thayan. Old death and careful perfume."],
    glade: ["My ring is warm. Here, of all places. She did that."],
    moon_temple: ["The dead don't walk near these stones. Something keeps them down. Something kind."],
    warren: ["Thirteen of them. Each one looks at us like we're a story they've already read."]
  )
  PARTY_CHAT[:shade].merge!(
    lonely_road: ["Shimmer keeps touching her stone. She thinks I don't notice.", "I always notice."],
    lonelywood: [{ if: { flag: :shimmer_taken }, lines: ["...I should have been awake.", "I'm always awake. I should have been awake."] },
                 ["Nimsy Huddle bakes cookies and runs a town full of thieves. I respect that."]],
    lucky_liar: ["I'm not drinking tonight. Someone has to watch the door."],
    glade: ["Don't. Just... don't say anything. Not yet."],
    moon_temple: ["If he's here, he's mine."],
    warren: ["Rabbits. Giant rabbits who sing.", "She'd have loved this. She'd have laughed for an hour."]
  )
  PARTY_CHAT[:shimmer].merge!(
    lonely_road: ["My stone's so cold it burns. Whatever's coming, it's close."],
    lonelywood: ["Cookies shaped like halflings. Shade, look. Shade. Look at the cookies."]
  )
  PARTY_CHAT[:meat_meat] = {
    lonelywood: ["Cookie lady has coffee. Weak coffee. Meat Meat forgives her. Once.",
                 "Also cookie lady does not count pockets. Good lady."],
    lucky_liar: ["Everyone here lies! Meat Meat fits in very nicely."],
    glade: ["Rose is warm. Meat Meat put hand on it. Felt like a hug."],
    moon_temple: ["Rabbit Lords live under here. Meat Meat saw them in a dream.", "They were taller in the dream."],
    warren: ["Rabbit Lords! Meat Meat bows. Is bowing right? Meat Meat bows again, to be safe."],
    lonely_road: ["Razzy walked this way once. Meat Meat remembers his feet. Small feet."],
    bryn: ["Big town. Many pockets. Bad coffee. Meat Meat is being good. Mostly."]
  }

  module_function

  #-----------------------------------------------------------------------------
  # Speaker Nimsy Huddle: cookies, the attic, and the night Shimmer is taken.
  #-----------------------------------------------------------------------------
  def nimsy(event_id = nil)
    if !flag?(:met_nimsy)
      set_flag(:met_nimsy)
      say(["NIMSY: Oh! Visitors! Come in, come in, mind the little ones.",
           "NIMSY: Cookie? They're shaped like halflings. That's the joke.",
           "NIMSY: I'm Nimsy Huddle. I speak for Lonelywood, for all the good it does us.",
           cl(:alberica, "Darling, you've just become my favourite Speaker in the Dale."),
           "NIMSY: The attic's yours. House rule in Lonelywood: nobody asks about anybody's past.",
           as(:shimmer, "Perfect."),
           cl(:shade, "She means it. That's the first time I've heard her mean it.")].compact, event_id)
    end
    if pbConfirmMessage(_INTL("Rest in Nimsy's attic?"))
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      set_rest_point
      set_flag(:rested_lonelywood)
      if !flag?(:shimmer_taken) && companions.include?(:shimmer)
        scene_shimmer_taken
      else
        say(["NIMSY: Sleep well! Mind the low beam."], event_id)
        attic_banter
      end
    end
  end

  # A short talk in the attic, once, after the worst night (house rule: rest points banter).
  def attic_banter
    return if flag?(:attic_banter) || !flag?(:shimmer_taken)
    lines = [cl(:meat_meat, "Attic is warm. Meat Meat approves. Where is the coffee?"),
             cl(:alberica, "Asleep, sweetheart. Like you should be."),
             cl(:meat_meat, "Meat Meat does not sleep. Meat Meat waits for coffee."),
             cl(:alerion, "She's asleep."),
             cl(:shade, "(by the window) ...Go to sleep, all of you. I'll watch.")].compact
    return if lines.size < 3
    set_flag(:attic_banter)
    say(lines)
  end

  def set_rest_point
    return if !$PokemonGlobal
    map_id, x, y, dir = LONELYWOOD_REST
    $PokemonGlobal.pokecenterMapId     = map_id
    $PokemonGlobal.pokecenterX         = x
    $PokemonGlobal.pokecenterY         = y
    $PokemonGlobal.pokecenterDirection = dir
  end

  # SC 3.03 - The empty bedroll, then SC 3.04 - The third way (vision)
  def scene_shimmer_taken
    say(["The attic is warm. Below, the fire ticks as it cools.",
         "One by one, the party falls asleep.",
         "...",
         "Morning. Shimmer's bedroll is empty.",
         "On the pillow: a note, and the carved wooden cat.",
         as(:shade, "(reading) \"He said before the next moon, or he picks someone else.\""),
         as(:shade, "\"I'm not letting him pick. Don't follow. Keep the cat. S.\""),
         as(:shade, "(very quiet) ...She always does this.")])
    me = herald?(:alberica)
    say([me ? "Your pendant flares and cracks." : "Alberica's pendant flares and cracks.",
         "The room goes white. Then you're all somewhere else, and none of you can move."])
    # The vision: S-04 covers the cut to the Glade, where it plays out on the
    # slab itself under a frosted frame (O-03); S-05 covers the cut home.
    Stage.overlay("O-03", above_panels: true, fade: 20)
    Stage.panel("S-04", fade: 20)
    say(["A stone circle in the birches. Snow falling without a sound."])
    Stage.visit(GLADE_MAP, 14, 13, 8) do
      st = Stage
      shim = st.actor(:shimmer, 14, 10, 2)
      st.pose(shim, "P-SHI-03", 3, frames: [0, 1], per: 24) if shim
      seph = st.actor(:sephek, 16, 10, 4)
      st.panel_off(fade: 24)
      say(["Shimmer lies on a slab older than names, bound in cords of living ice.",
           "Above her floats a sphere of ice veined with black: the Heart of Winter.",
           "It beats to someone else's pulse."])
      st.face(seph, 4) if seph
      say(["SEPHEK: She forgives, Shimmer. Take her back into you. Let the Dale breathe.",
           "SEPHEK: You won't be a prison this time. You'll be a queen.",
           "SHIMMER: I've carried her once. I watched the world burn white because of it.",
           "SHIMMER: This isn't salvation. It's surrender.",
           "SEPHEK: Then you leave her no choice.",
           "SHIMMER: You gave me two paths, Sephek. Damnation, or servitude.",
           "SHIMMER: You forgot. There's always a third way.",
           "She closes her eyes. In her chest, something cracks like ice on a lake: the stone.",
           "Above her, the Heart of Winter screams."])
      $game_screen.start_shake(4, 6, 16) rescue nil
      say(["SHIMMER: Do it. If she needs blood, let it be mine. But not for her.",
           "SHIMMER: For them."])
      st.walk(seph, [PBMoveRoute::ThroughOn, PBMoveRoute::Left]) if seph
      say(["The blade falls. White fire. When it fades, there is no body."])
      $game_screen.start_flash(Color.new(255, 255, 255, 220), 16) rescue nil
      st.panel("S-05", fade: 12)
    end
    say(["Only a rose, frozen in bloom, growing out of the stone.",
         "Beside it, a heart of ice beats once, and breathes out mist.",
         "Sephek falls to his knees. He's weeping.",
         "SHIMMER: (from nowhere, very softly) Not all fire dies. Some of it just learns to freeze."])
    Stage.overlay_off("O-03", fade: 20)
    Stage.panel_off(fade: 20)
    Stage.cleanup
    state[:companions] = (state[:companions] || []) - [:shimmer]
    set_flag(:shimmer_taken)
    $game_switches[SW_SHIMMER_TAKEN] = true if $game_switches
    say([me ? "You're back in the attic. The pendant is gone. The rune on your chest isn't." :
              "You're back in the attic. Alberica's pendant is gone. The rune on her chest isn't.",
         as(:shade, "...No. No, no, no.")])
    speak(:alerion, "East. The vision was east. The old logging road.", "...The logging road. East.")
    say([cl(:alberica, "Shade. Look at me. We go together. Nobody goes alone."),
         "Outside, under the window, a tall figure with long ears and a lantern waits in the snow."].compact)
    state[:goal] = "The Glade of the Unmade, east of Lonelywood."
  end

  #-----------------------------------------------------------------------------
  # Scenes
  #-----------------------------------------------------------------------------
  # SC 3.01 - What she carried
  def scene_lonely_road_start
    say(["Bare footprints in the snow. They don't sink.",
         as(:shimmer, "Those are his. Aren't they."),
         as(:shimmer, "You should know why he wants me."),
         as(:shimmer, "Saltmarsh. A job. A stone in a box. I opened the box, and she came in."),
         as(:shimmer, "One night, she wore me like a coat. A ship froze solid around us."),
         as(:shade, "(quietly) You told me it was a storm."),
         as(:shimmer, "It was a storm. Hers. You came into it after me anyway. Dragged me out by the hair."),
         as(:shimmer, "I got out. The stone didn't. It's still in here. A door she left open."),
         as(:shade, "Why didn't you tell me?"),
         as(:shimmer, "You'd have tried to fix it."),
         as(:alberica, "So she wants a coat again. And she's trying me on for size."),
         cl(:reptin, "Then she'll find out what we all know. Nobody's ever made you fit anything.")].compact)
    set_flag(:shimmer_confessed)
    state[:goal] = "Lonelywood. Sephek is waiting. (Auril wears people. She calls them vessels.)"
  end

  def scene_lonelywood_arrival
    set_flag(:lonelywood_arrived)
    say(["Lonelywood: timber houses in a crescent on the shore of Maer Dualdon.",
         "Four piers run out into the ice. The forest presses in behind.",
         "Smoke rises from a green-roofed house. Someone in there is baking.",
         as(:alberica, "Is that... cinnamon? In Icewind Dale? Somebody marry me."),
         cl(:alerion, "No."),
         cl(:reptin, "He means congratulations."),
         cl(:shimmer, "He means no.")].compact)
  end

  # SC 3.05 - The Glade
  def scene_glade_aftermath
    st = Stage
    gx, gy = ([$game_player.x, $game_player.y - 1] rescue [0, 0])
    heart = st.fx("E-14", [gx, gy], oy: 8, loop_from: 0) if st.map?
    say(["The rose. And beside it, the heart of ice, beating once a minute."])
    pre = { alberica: "ALB", reptin: "REP", alerion: "ALE", meat_meat: "MM", wyn: "WYN" }[herald]
    if pre && st.map?
      me = st.herald(herald)
      st.pose(me, "P-#{pre}-02", 3, per: 8) if me
    end
    shim = st.actor(:shimmer, gx, gy - 1, 2) if st.map?
    st.pose(shim, "P-SHI-02", 0, frames: [0, 1, 2, 3, 0, 1, 2, 3], per: 6) if shim
    say(["You touch it. For a moment you see a girl in the wind with her arms open, smiling."])
    st.hide(shim) if shim
    st.stop_fx(heart) if heart
    st.cleanup
    say([as(:shade, "I'm not leaving her here.")])
    give_key(:FT_HEARTOFICE)
    set_flag(:heart_of_ice)
    $game_switches[SW_HEART_TAKEN] = true if $game_switches
    if !flag?(:meat_meat_joined)
      eggs = herald?(:reptin) ? "your arms" : "Reptin's arms"
      say(["Behind the altar, a bundle of furs sneezes.",
           "A goblin, half frozen, chewing mushroom jerky. Long white hair stiff with frost.",
           "Cracked goggles. Violet eyes. A pack bigger than she is.",
           "MEAT MEAT: Meat Meat dreamed Razzy fell into cold light.",
           "MEAT MEAT: Meat Meat followed the dream. Dream was wrong place. Rude dream.",
           "She sees the egg in #{eggs} and goes very still.",
           "MEAT MEAT: ...Razzy?",
           "The egg warms so suddenly it nearly slips.",
           "MEAT MEAT: That is Razzy. Razzy not dead. Just very cold. Meat Meat promises."])
      speak(:reptin, "\"A name, spoken as a promise.\" ...That's it. That's the rite.", "...A name, spoken as a promise.")
      say(["MEAT MEAT: Razzy and Meat Meat ran away together. From a cold table.",
           "MEAT MEAT: From the lady with books and bones. She took Razzy's voice.",
           as(:alerion, "Naerth's \"pale lady\"."),
           "MEAT MEAT: Meat Meat comes with you now. Meat Meat is not asking.",
           cl(:alberica, "Oh, I love her. Can we keep her?"),
           "MEAT MEAT: Meat Meat will bite you. Fondly.",
           cl(:reptin, "She's saying she's grateful."),
           "MEAT MEAT: Meat Meat is saying the other thing. Also: who has coffee?"].compact)
      state[:companions] = ((state[:companions] || []) + [:meat_meat]).uniq
      set_flag(:meat_meat_joined)
      set_switch(SW_MEAT_JOINED, true)
    else
      say(["Under your coat, the egg's heartbeat answers the heart of ice, beat for beat.",
           cl(:meat_meat, "Razzy can hear her. Razzy is being very brave.")].compact)
    end
    set_flag(:razzy_named)
    say(["JET SENTRY: I tracked the cold man here. I was too late for her.",
         "JET SENTRY: The Circle wants that heart.",
         "JET SENTRY: And the man who took her waits at our Moon Temple for it."])
    state[:goal] = "The Moon Temple, north of Lonelywood. Sephek is waiting for the heart."
  end

  def scene_moon_grounds_arrival
    say(["The path climbs to a shrine of old stone arches, half buried in snow.",
         "Spirals glow faintly on every post.",
         "Below the arches, a timber lodge with a root-grown door breathes out warm air. Mint, and earth.",
         cl(:meat_meat, "Rabbit Lords live here. Meat Meat will be very polite. Very."),
         cl(:reptin, "Leave the talking to me. Rabbits love me. Everybody does, eventually."),
         cl(:shade, "Talk later. He's here. I can feel it.")].compact)
  end

  def scene_sephek_moon_temple(event_id = nil)
    if flag?(:sephek_defeated)
      return
    end
    st = Stage
    spot = ($game_map.events.values.find { |e| e.name == "Sephek in ice" } rescue nil)
    sx, sy = spot ? [spot.x, spot.y] : ([$game_player.x, $game_player.y - 2] rescue [0, 0])
    seph = st.actor(:sephek, sx, sy, 2) if st.map?
    say(["The wind stops. Between the arches, a man in a thin linen shirt is waiting.",
         "His eyes are still red.",
         "SEPHEK: Give me the heart, and the Frostmaiden forgets your names.",
         as(:shade, "You killed my sister."),
         "SEPHEK: (quietly) She killed herself. I only held the knife. I'm sorry. Give it to me.",
         cl(:alberica, "(a hand on Shade's arm) Not alone, sweetheart. Not this time.")].compact)
    here = $game_map.map_id
    won = pbTrainerBattle(:FT_SEPHEK, "Sephek", nil, false, 0)
    if !won
      # losing sends you to the Pokémon Center: re-arm the scene on the temple
      # map (not wherever you woke up), so he's waiting when you come back
      set_self_switch(event_id, "A", false, here)
      Stage.cleanup
      return
    end
    say(["SEPHEK: ...So cold. Why is it so cold? The cold never touched me..."])
    if seph
      st.pose(seph, "P-SEP-02", 0, frames: [0, 1], per: 10)
      pbSEPlay("Ice2") rescue nil
      st.fx("E-04", seph, frames: 10, hold: true, wait: false)
      st.pose(seph, "P-SEP-02", 0, frames: [2, 3], per: 12)
    end
    say(["Ice closes over him where he kneels.",
         "In his chest, a sliver of blue light still beats. Slow as a sleeper."])
    speak(:alerion, "He's not dead. He's waiting.", "...He's waiting.")
    say([cl(:shade, "Then let him wait. Forever, if it's up to me.")].compact)
    set_flag(:sephek_defeated)
    set_flag(:sephek_frozen)
    state[:goal] = "The Wennen's Warren, under the Moon Temple. Zenith Abbott is waiting at the Rose."
    $game_switches[SW_SEPHEK_DOWN] = true if $game_switches
    Stage.cleanup
    $game_map.need_refresh = true if $game_map     # (his statue takes the stand-in's place)
    add_counter(:story_beats)
  end

  # Saves where Sephek won before this was fixed: the fight never came back.
  def rearm_sephek
    return if !$game_map || $game_map.map_id != MAPS[:moon_grounds]
    return if flag?(:sephek_defeated) || !flag?(:heart_of_ice)
    ev = $game_map.events.values.find { |e| e.name.to_s == "Cutscene sephek_moon_temple" } or return
    key = [$game_map.map_id, ev.id, "A"]
    return if !$game_self_switches[key]
    $game_self_switches[key] = false
    $game_map.need_refresh = true
    log("Sephek's fight at the Moon Temple was re-armed.")
  rescue StandardError => e
    log("rearm_sephek: #{e.message}")
  end

  def scene_warren_enter
    say(["The tunnel widens as it goes down: round halls of pressed clay, ribbed with white roots.",
         "Fungal veins glow along the walls. Driftwood lanterns burn amber. It's warm.",
         "Tall figures with long ears watch you pass. The Circle of Thirteen. Waiting. Judging.",
         cl(:meat_meat, "Meat Meat smells coffee. Rabbit coffee. Meat Meat will find it."),
         cl(:reptin, "Please don't steal from the moon-keepers."),
         cl(:meat_meat, "Meat Meat borrows.")].compact)
  end

  #-----------------------------------------------------------------------------
  # Zenith Abbott and the Moon Requiem
  #-----------------------------------------------------------------------------
  def zenith(event_id = nil)
    if flag?(:requiem_done)
      return zenith_verse(event_id) if !flag?(:rose_cutting)
      say(["ZENITH: The wheel has turned once. It will turn again."], event_id)
      return
    end
    if !flag?(:heart_of_ice)
      say(["ZENITH: Moon above, roots below,",
           "ZENITH: what was given, the rose will know.",
           "(The tall Wennen in green robes speaks only in verse.)",
           "(You think he means: bring what she left at the Glade.)"], event_id)
      return
    end
    if !flag?(:sephek_defeated)
      say(["ZENITH: The hand that struck still seeks the heart.",
           "ZENITH: Meet him under the moon. Then come back to me."], event_id)
      return
    end
    scene_moon_requiem(event_id)
  end

  # SC 3.08 (optional) - a cutting of the Undying Rose, for the one who answers the verse
  def zenith_verse(event_id = nil)
    say(["ZENITH: What grows from a choice?"], event_id)
    c = pbMessage(_INTL("What grows from a choice?"), [_INTL("A rose."), _INTL("A winter."), _INTL("Nothing.")], -1)
    if c == 0
      say(["ZENITH: A rose. Then carry one.",
           "(Zenith cuts a sprig from the Undying Rose and folds it into your hands. It's warm.)"], event_id)
      give_key(:FT_UNDYINGROSE)
      set_flag(:rose_cutting)
    else
      say(["ZENITH: Not yet. Ask the rose again."], event_id)
    end
  end

  # SC 3.07 - The Moon Requiem. The egg takes Shimmer's heart, but doesn't hatch.
  def scene_moon_requiem(event_id = nil)
    say(["ZENITH: A heart that chose. A rose that would not close.",
         "ZENITH: An egg that fell when winter first arose.",
         "LUNA CARVER: The night the Rime began, the Frostmaiden's roe flew over us.",
         "LUNA CARVER: Something fell. An egg, cold all through. It never woke. We kept it anyway.",
         "LUNA CARVER: It needed a heart. Now one has come.",
         herald?(:shade) ? "You lay Shimmer's heart beneath the Rose, beside a pale-blue egg." :
                           "Shade lays Shimmer's heart beneath the Rose, beside a pale-blue egg.",
         "The Wennen thump a slow beat with their feet. The false moon in the ceiling brightens."])
    pbSEPlay("Ice2") rescue nil
    st = Stage
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    egg = st.actor(:frost_egg, px, py - 1, 2, graphic: "K-EGG-02") if st.map?
    st.pose(egg, "K-EGG-02", 1, frames: [0], per: 4) if egg
    say(["The egg doesn't crack. It warms.",
         "Frost-white light moves under the shell.",
         "Something inside turns over, the way someone used to in her sleep."])
    st.balloon(egg, "B-05", frames: 90) if egg
    say(["Then, from inside the shell, a hum. Four notes."])
    shade = (st.find("Shade") || st.actor(:shade, px + 1, py, 8)) if st.map? && !herald?(:shade)
    st.balloon(shade, "B-07", frames: 70) if shade
    say([as(:shade, "(breaking) That's... that's her song."),
         "ZENITH: Not her vessel. Her answer.",
         herald?(:alerion) ? "The ring on your hand warms for the first time. (...Frostina.)" :
                             "ALERION: ...Frostina.",
         cl(:alberica, "(softly) Frostina. She'd have hated that. She'd have loved it."),
         "LUNA CARVER: It has a heart now. It needs time, and the world hasn't got enough."].compact)
    Stage.cleanup
    take_key(:FT_HEARTOFICE)
    give_key(:FT_FROSTEGG)
    say(["(Shade carries the Frost Egg from here on.)"])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "Razzy is jealous. Look. Razzy's egg is sulking.", "...Razzy's egg is sulking.")
    end
    set_flag(:requiem_done)
    set_flag(:frost_egg)
    $game_switches[SW_REQUIEM_DONE] = true if $game_switches
    add_counter(:story_beats)
    state[:goal] = "Speak with Luna Carver before you go."
  end

  # SC 3.08 - One, two, three (Luna Carver, after the Requiem)
  def luna(event_id = nil)
    if !flag?(:requiem_done)
      return say(lines_for(:luna_carver), event_id)
    end
    if flag?(:knows_three_hearts)
      return say(["LUNA CARVER: Go on. We'll be behind you, at a distance. We're good at distance."], event_id)
    end
    say(["LUNA CARVER: One heart of ice is grief. Two is a burden. Three is a summons.",
         "LUNA CARVER: Hers was the first. The cold man's still beats in his chest.",
         "LUNA CARVER: Bring a third to the other two, and the Frostmaiden gets a body to walk in.",
         cl(:reptin, "Then we make very sure nobody brings a third."),
         "LUNA CARVER: (turning to Shade) And you. Your house has a spark in it that isn't out.",
         "LUNA CARVER: I can see it on you. It's waiting somewhere bright.",
         as(:shade, "My house is one smuggler and a carved cat. But thanks."),
         "LUNA CARVER: The cold man can't stay at our temple with his heart beating.",
         "LUNA CARVER: We'll take him south on a sledge, and follow you. At a distance.",
         "LUNA CARVER: We keep what the cold leaves. We kept an egg for two years."].compact, event_id)
    set_flag(:knows_three_hearts)
    set_flag(:luna_spark)
    set_flag(:wennen_follow)
    set_switch(SW_WENNEN_FOLLOW, true)
  end

  # SC 3.09 - The laughing is the calling (back in Lonelywood after the Warren)
  def scene_laughing_calling
    say(["ZENITH: South of the Hole where the ice stands still,",
         "ZENITH: a crone laughs low, and the laughing is the calling.",
         "JET SENTRY: Plain words: a hag lives in a chasm south of Dougan's Hole.",
         "JET SENTRY: The Circle has heard her for two winters. Your trinkets pull toward her.",
         "JET SENTRY: I'll run ahead to Bryn Shander. The east gate will be open for you.",
         cl(:alberica, "A laughing hag who wants our jewellery. I've dated worse."),
         cl(:alerion, "You have.")].compact)
    set_flag(:hag_named)
    state[:goal] = "Bryn Shander's east gate, then south-east to Dougan's Hole. Find who's calling us."
  end

  def apply_chapter3_switches
    return if !active? || !$game_switches
    rearm_sephek
    sync_switch(SW_NORTH_OPEN, flag?(:badge_bryn))
    sync_switch(SW_SHIMMER_TAKEN, flag?(:shimmer_taken))
    sync_switch(SW_HEART_TAKEN, flag?(:heart_of_ice))
    sync_switch(SW_SEPHEK_DOWN, flag?(:sephek_defeated))
    sync_switch(SW_REQUIEM_DONE, flag?(:requiem_done))
    sync_switch(SW_WENNEN_FOLLOW, flag?(:wennen_follow))
    sync_switch(SW_MEAT_JOINED, flag?(:meat_meat_joined))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter3_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 3 switches failed: #{err.message}")
  end
}
