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
  LOPUNNY_GFX = "FT_wennen_generic"        # the Wennen (as on the maps, tools/build_ch3.rb)
  JET_GFX = "FT_wennen_jet_sentry"

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_SEPHEK: ["Auril's Chosen", :MYSTICALMAN, 0, 120, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    bug_catcher_pell: [:BUGCATCHER,       "Nettle",  [[:SPINARAK, 15], [:PINECO, 16]],
                       "My bugs hate the cold. I'm starting to see their point."],
    lady_maren:       [:BEAUTY,           "Maren",  [[:B35H220, 16], [:SNUBBULL, 16]],
                       "Lonelywood's dreadful, darling. That's why I love it."],
    hiker_osk:        [:HIKER,            "Osk",    [[:GRAVELER, 16], [:B220H95, 17]],
                       "Felled by a stranger. Like a pine."],
    aurilite_four:    [:FT_AURILITE,      "Wyst",   [[:SWINUB, 16], [:B215H200, 17]],
                       "He passed at dawn. Didn't even feel the cold."],
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
                       "Her Chosen comes back for what's hers. He always comes back."],
    sephek:           [:FT_SEPHEK,        "Sephek", [[:B215H92, 22], [:B220H93, 23], [:B124H200, 23], [:B87H215, 25]],
                       "...So cold. Why is it so cold?", [:SUPERPOTION, :SUPERPOTION]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  WENNEN_LINES = {
    jet_sentry:       [{ if: { flag: :requiem_done }, lines: ["JET SENTRY: Luna's by the Rose. Hear her out before you go."] },
                       ["JET SENTRY: Scout of the Pinewalls. I was too slow at the Glade. I won't be again.",
                        "JET SENTRY: Weeks ago a goblin like your little one ran past our walls. Toward the light."]],
    aurora_traveller: ["AURORA TRAVELLER: Sit. Warm your hands. The moonfire here doesn't go out. I see to that.",
                       "AURORA TRAVELLER: Cold scrying can't see through cinderwood. You're hidden here."],
    eclipse_spicer:   ["ECLIPSE SPICER: Oh, I hear everything. Gossip is history nobody's written down yet.",
                       "ECLIPSE SPICER: A woman with books and bones has been asking after frozen hearts.",
                       "ECLIPSE SPICER: Avarice, she's called. She wants a third."],
    pulsar_bond:      [{ if: { flag: :requiem_done }, lines: ["PULSAR BOND: Two eggs now. One green, one ice. Neither will hatch here.",
                                                              "PULSAR BOND: I think they're waiting for the same thing."] },
                       ["PULSAR BOND: Moonroot, frostbalm, a little patience. That's most of healing.",
                        "PULSAR BOND: The goblin egg you carry has changed. Moonlight did that.",
                        "PULSAR BOND: Verdant transfiguration, we call it. Keep it warm."]],
    celeste_scribe:   ["CELESTE SCRIBE: The Hearts of Ice are failed vessels.",
                       "CELESTE SCRIBE: Each time she wears a mortal body, one is left behind.",
                       "CELESTE SCRIBE: Gather enough in one place and she walks again. Remember that."],
    cosmo_bookman:    [{ if: { flag: :shimmer_taken }, lines: ["COSMO BOOKMAN: I collect final words. I have hers. \"For them.\"",
                                                                 "COSMO BOOKMAN: Some last words are a door closing. Hers was one opening."] },
                       ["COSMO BOOKMAN: I collect final words. Most people's are about the weather.",
                        "COSMO BOOKMAN: Some aren't. I wait for those."]],
    stellar_fletcher: [{ if: { flag: :heart_of_ice }, lines: ["STELLAR FLETCHER: I forge with silverthread and moonlight. I won't forge with that heart.",
                                                              "STELLAR FLETCHER: Some metals remember who they belonged to."] },
                       ["STELLAR FLETCHER: I forge with silverthread and moonlight. Nothing else holds, out here.",
                        "STELLAR FLETCHER: Some metals remember who they belonged to."]],
    helios_meadow:    ["HELIOS MEADOW: The Veinflower wilts when she looks this way. All week, it's wilted.",
                       "HELIOS MEADOW: But it's blooming at you. Interesting."],
    luna_carver:      [{ if: { with: :meat_meat }, lines: ["LUNA CARVER: Ah. The Squeak of Destiny. Moon-touched, that one.",
                                                           "LUNA CARVER: Don't let her go hungry. Or uncaffeinated."] },
                       ["LUNA CARVER: I dream for the Circle. Lately I dream of a broken moon,",
                        "LUNA CARVER: and two eggs in a nest of roots."]],
    luna_camp:        ["LUNA CARVER: We keep what the cold leaves. We kept an egg for two years.",
                       "LUNA CARVER: The cold man sleeps on the sledge. His heart still beats. We watch it."],
    jet_sentry_gate:  ["JET SENTRY: The east gate is open. South-east to Dougan's Hole, and past it, the laughing.",
                       "JET SENTRY: The Circle follows at a distance. We don't leave a piece of her unwatched."],
    umbra_rider:      ["UMBRA RIDER: Two hearts is a burden. Three is a summons. Never carry three.",
                       "UMBRA RIDER: The old texts name what three hearts make. The Rewritten Auril.",
                       "UMBRA RIDER: Pray you never need to know more."]
  }

  TEXT.merge!(WENNEN_LINES)
  TEXT.merge!(
    bryn_north_guard_open: ["GUARD: North path to Termalaine, and Lonelywood past it.",
                            "GUARD: Loggers, fishers, folk who'd rather not be found.",
                            "GUARD: Two days to Lonelywood, if the drifts are kind. The man in the shirt went that way."],
    # --- Lonelywood Road -----------------------------------------------------------
    sign_lonely_road: ["LONELYWOOD ROAD", "North to Lonelywood. Beware the white moose."],
    sign_stream: ["The stream is frozen solid. Someone has laid logs across it anyway, out of habit."],
    lonely_road_woodcutter: [{ if: { flag: :shimmer_taken }, lines: ["WOODCUTTER: The girl with the humming stone. I heard. I'm sorry.",
                                                                      "WOODCUTTER: He asked me where she was. I said no. I'm glad that was true, at least."] },
                             ["WOODCUTTER: A man passed at dawn in his shirtsleeves. Snow on him. Didn't melt.",
                              "WOODCUTTER: He asked if I'd seen a girl with a stone that hums.",
                              "WOODCUTTER: I said no. I'm glad it was true."]],
    bug_catcher_pell_after: ["Lonelywood's got bugs nobody's catalogued. Mostly because they're frozen."],
    lady_maren_after: ["I came to Icewind Dale for the scenery. There isn't any. It's all snow."],
    hiker_osk_after: ["The pines get thicker toward Lonelywood. And quieter. I don't like the quiet."],
    aurilite_four_after: ["Every time someone tells her no, the winter gets longer. You lot say no a lot."],
    ranger_tamsa_after: ["Lonelywood's Speaker bakes cookies for strangers. That's how you know you're welcome."],
    # --- Lonelywood ------------------------------------------------------------------
    lonely_sign: ["LONELYWOOD", "Logging, fishing, scrimshaw. Speaker: Nimsy Huddle.", "(The house with the green roof.)",
                  "The post is old Sembian work: dragons, lions and goats, all bowing toward a chimera.",
                  "The crest of the family who founded the town. Nobody remembers their name. Nobody asks."],
    sign_moon_temple: ["North: the Moon Temple.", "Someone has carved little spirals into the post. They glow faintly."],
    sign_glade_road: ["East: the old logging road.", "Scratched underneath: \"NOT PAST THE STONES.\""],
    ramshackle_closed: ["RAMSHACKLE. The town's only inn. Shut since its owner was found hanged, two winters back.",
                        "Some say he didn't do it himself. The door is nailed shut."],
    scoop_huddle: -> {
      if T.flag?(:shimmer_taken)
        ["SCOOP: Mama says we have to be quiet today."]
      elsif T.flag?(:met_sephek_torgs)
        ["SCOOP: Mama baked cookies! Our house is the green one.",
         "SCOOP: There's a dwarf at the Lucky Liar asking everybody about the man in the shirt."]
      else
        ["SCOOP: Are you the strangers from Bryn Shander? Mama baked cookies!",
         "SCOOP: They're shaped like halflings!",
         "SCOOP: Our house is the green one. Come in! Everyone comes in."]
      end
    },
    huddle_kids: ["The Huddle children chase each other round the table with wooden swords.",
                  "One stops long enough to offer you a slightly squashed cookie."],
    lonely_fisher: ["Half of Lonelywood fishes, half fells trees. The other half lies about it at the Liar."],
    lonely_logger: ["Something's chasing loggers out of the woods. A white moose, they say. Big as a cabin.",
                    "Smart, too. Like it knows where we'll be before we do."],
    lonely_moon_talk: [{ if: { flag: :requiem_done }, lines: ["Hear the singing last night, up by the temple? Rabbits singing.",
                                                              "And something answered."] },
                       ["There are rabbits in the woods north of here. The size of people, with lanterns.",
                        "My mother called them the Wennen. Moon-keepers. You don't find them. They find you."]],
    lonely_north_path: ["The path north climbs to the Moon Temple. Old stones, older than the town.",
                        "Folk leave offerings up there on full-moon nights. Nobody says to whom."],
    jet_sentry_town: -> {
      if T.flag?(:heart_of_ice)
        ["JET SENTRY: Bring the heart north, to the Moon Temple. Our Warren is under it.",
         "JET SENTRY: Zenith will know what to do.",
         "JET SENTRY: And hurry. The cold man follows its pulse."]
      else
        ["JET SENTRY: The logging road east, through the forest, to the Glade of the Unmade.",
         "JET SENTRY: A stone circle in the birches. I'm sorry. I was too slow."]
      end
    },
    fisher_garrow_after: ["The lake's frozen ten feet down. I still fish. What else would I do?"],
    logger_breck_after: ["Speaker Huddle says she'll deal with the moose. Speaker Huddle's never met the moose."],
    danae_xotal: ["DANAE: Welcome to the Lucky Liar. Every story here is true. None of them happened.",
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
        ["NOVA KEEPER: He sleeps in the ice now. Not dead.", "NOVA KEEPER: The cold doesn't let its chosen die so easily.",
         "NOVA KEEPER: We'll watch him. Go below. Zenith is waiting at the Rose."]
      elsif T.flag?(:shimmer_taken)
        ["NOVA KEEPER: Warden of the Moon Temple. These stones are ours to keep.",
         "NOVA KEEPER: The Warren's door is the lodge below. Go in quietly. The Circle is grieving."]
      else
        ["NOVA KEEPER: Warden of the Moon Temple. These stones are ours to keep.",
         "NOVA KEEPER: The Warren's door is the lodge below. Knock, and wait."]
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
    warren_bolt_tunnel: ["A bolt tunnel: a narrow way up to the surface, screened with roots and kept clear."],
    undying_rose_warren: -> {
      if T.flag?(:requiem_done)
        ["A cutting of the Undying Rose blooms over a sacred stone.",
         "Beneath it the earth is warm, and very faintly, something beats."]
      else
        ["A cutting of the Undying Rose blooms over a sacred stone.", "Its petals are silver in the fungal light."]
      end
    },
    warren_nursery: -> {
      if T.flag?(:requiem_done)
        ["The nest of roots is empty now. Frost still glitters where the egg lay."]
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
                 ["A logging town that bakes cookies for strangers. I'm in love with Lonelywood."]],
    lucky_liar: ["Every story in here's a lie. Best-behaved room I've been in all year.",
                 "Buy me a drink, I'll tell you the truth. Two drinks, I'll tell you a better one."],
    glade: [{ if: { flag: :shimmer_taken }, lines: ["My pendant broke when she... I saw all of it.",
                                                    "I'll write it down. Somebody has to sing it right."] },
            ["Standing stones, and nobody's left an offering in years.", "I don't trust a shrine nobody visits."]],
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
    glade: [{ if: { flag: :shimmer_taken }, lines: ["The frost bends away from the altar. Like it's afraid of her rose."] },
            ["Older than the town, these stones. Something here is waiting to be used."]],
    moon_temple: ["My medallion's quiet here. First time since Targos. I could almost get used to it."],
    warren: ["Roots for ribs, earth for skin. This place is alive in a way I understand."]
  )
  PARTY_CHAT[:alerion].merge!(
    lonely_road: [{ if: { time: :night }, lines: ["He walked this road. My ring knows where his cold went."] },
                  ["Sephek came this way. He's not hiding. He wants to be followed."]],
    lonelywood: [{ if: { flag: :shimmer_taken }, lines: ["I've stood at a lot of gravesides.", "This is the first with nothing to bury."] },
                 ["Lonelywood is for people who don't want to be found. We'll fit in."]],
    lucky_liar: ["Someone in here is Thayan. Old death and careful perfume."],
    glade: [{ if: { flag: :shimmer_taken }, lines: ["My ring is warm. Here, of all places. She did that."] },
            ["My ring's cold here. Not the dead. Something that wants to make some."]],
    moon_temple: ["The dead don't walk near these stones. Something keeps them down. Something kind."],
    warren: ["Thirteen of them. Each one looks at us like we're a story they've already read."]
  )
  PARTY_CHAT[:shade].merge!(
    lonely_road: [{ if: { flag: :shimmer_taken }, lines: ["I keep looking for her stone glowing in the dark. Habit."] },
                  ["Shimmer keeps touching her stone. She thinks I don't notice.", "I always notice."]],
    lonelywood: [{ if: { flag: :shimmer_taken }, lines: ["...I should have been awake.", "I'm always awake. I should have been awake."] },
                 ["Nimsy Huddle bakes cookies and runs a town full of thieves. I respect that."]],
    lucky_liar: ["I'm not drinking tonight. Someone has to watch the door.",
                 "(flexing a white hand) Knife's cold. My fingers are colder. Don't tell Shimmer."],   # the curse, set up (whole read T5)
    glade: [{ if: { flag: :shimmer_taken }, lines: ["Don't. Just... don't say anything. Not yet."] },
            ["Stone circle, nobody for miles. Good place for a bad deal."]],
    moon_temple: [{ if: { flag: :sephek_defeated }, lines: ["He's in there. Asleep. I could stand here all night and watch him not wake up."] },
                  ["If he's here, he's mine."]],
    warren: ["Rabbits. Giant rabbits who sing.", "She'd have loved this. She'd have laughed for an hour."]
  )
  PARTY_CHAT[:shimmer].merge!(
    lonely_road: ["My stone hums when he's near. It's humming."],
    lonelywood: ["Cookies shaped like halflings. Shade, look. Shade. Look at the cookies."]
  )
  PARTY_CHAT[:meat_meat] = {
    lonelywood: ["Cookie lady has coffee. Weak coffee. Meat Meat forgives her. Once.",
                 "Also cookie lady does not count pockets. Good lady."],
    lucky_liar: ["Everyone here lies! Meat Meat fits in very nicely."],
    glade: ["Rose is warm. Meat Meat put hand on it. Felt like a hug."],
    moon_temple: ["Rabbit Lords live under here. Meat Meat saw them in a dream.", "They were taller in the dream."],
    warren: ["Rabbit Lords! Meat Meat bows. Is bowing right? Meat Meat bows again."],
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
           "NIMSY: Cookie? They're shaped like halflings. Like me. That's the joke.",
           "NIMSY: I'm Nimsy Huddle. I speak for Lonelywood, for all the good it does us.",
           cl(:alberica, "Darling, you've just become my favourite Speaker in the Dale."),
           "NIMSY: The attic's yours. House rule in Lonelywood: nobody asks about anybody's past.",
           as(:shimmer, "Perfect."),
           cl(:shade, "Shimmer meant that one. Don't tell her I noticed."),
           # (notes/14 E9: the moose seeded on the first visit, no ask yet)
           "NIMSY: And mind the logging road. We've a moose problem. Ask me when you're settled."].compact, event_id)
    end
    # the morning after, the house knows (notes 03 E14)
    if flag?(:shimmer_taken) && !flag?(:nimsy_sorry)
      set_flag(:nimsy_sorry)
      say(["NIMSY: (quietly) Your friend's bedroll was cold before dawn. I'm sorry.",
           "NIMSY: The attic's yours as long as you need it."], event_id)
    end
    last_night = !flag?(:shimmer_taken) && companions.include?(:shimmer)
    # Sephek first (context 03 M3-2): the night needs his deadline under it
    if last_night && !flag?(:met_sephek_torgs)
      say([as(:shade, "Not yet. He's out by the sleds, past the fisher's house."),
           as(:shade, "I want to see his face before any of us sleeps.")], event_id)
      state[:goal] = "Find Sephek at the sleds in the clearing, past the fisher's house."
      return
    end
    # The watch (context 03 M3-3): the night is a decision the party owns
    if last_night && !flag?(:watch_shade) && !flag?(:watch_you) && !flag?(:watch_shimmer)
      say([as(:shade, "We sleep in shifts. He's out there, and he knows which roof.")], event_id)
      c = pbMessage(_INTL("Who keeps first watch?"), [_INTL("Shade."), _INTL("You."), _INTL("Shimmer.")], -1)
      c = 0 if !c || c < 0
      set_flag(%i[watch_shade watch_you watch_shimmer][c])
      say([[as(:shade, "Me, then. I don't sleep anyway. Family trait."),
            as(:shimmer, journey? ? "The stray. Good. You see what the rest of us walk past." :
                                  "You, then. Good. You see what the rest of us walk past."),
            as(:shimmer, "Me. I'm awake anyway. I'm counting.")][c]], event_id)
    end
    if pbConfirmMessage(last_night ? _INTL("Go up to the attic for the night?") : _INTL("Rest in Nimsy's attic?"))
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

  # Nimsy and the children are downstairs: the attic scenes hide them.
  def hide_household
    return if !Stage.map?
    $game_map.events.each_value { |e| e.transparent = true if e.name =~ /Nimsy|Huddle kids/ }
  end

  def set_rest_point
    return if !$PokemonGlobal
    map_id, x, y, dir = LONELYWOOD_REST
    $PokemonGlobal.pokecenterMapId     = map_id
    $PokemonGlobal.pokecenterX         = x
    $PokemonGlobal.pokecenterY         = y
    $PokemonGlobal.pokecenterDirection = dir
  end

  # SC 3.03 - The night, the empty bedroll, then SC 3.04 - The third way (vision),
  # then Jet Sentry under the window. Purpose: Shimmer decides, lies and leaves
  # on screen (the watch, the cat, her four notes); the party sees her choice
  # and learns where she is and who saw it (context 03 M3-3, M3-4, M3-5).
  ATTIC_NIGHT = Tone.new(-85, -75, -20, 40) rescue nil
  ATTIC_DAWN  = Tone.new(-20, -30, -10, 20) rescue nil
  NIMSY_DOOR  = [9, 11]                       # the ladder down and out (Speaker Huddle's House)
  JET_ROAD    = [39, 11]                      # Jet leads you to the logging road, by its sign

  def scene_shimmer_taken
    me = herald?(:alberica)
    st = Stage
    party = {}
    mood(nil)                                       # the house's music fades with the light
    pbFadeOutIn do
      $game_screen.start_tone_change(ATTIC_NIGHT, 0) rescue nil
      if st.map?
        hide_household
        $game_player.moveto(8, 8) rescue nil
        $game_player.turn_up rescue nil
        { alberica: [6, 8, 8], reptin: [7, 9, 8], alerion: [10, 8, 4], shade: [9, 9, 8],
          meat_meat: [11, 9, 4], shimmer: [9, 6, 8] }.each do |k, (x, y, d)|
          next if herald?(k) || !companions.include?(k)
          party[k] = st.actor(k, x, y, d)
        end
      end
    end
    shim = party[:shimmer]
    say(["The attic is warm. Below, the fire ticks as it cools.",
         "One by one, the party falls asleep."])
    if flag?(:watch_shade)
      say(["Past midnight, Shimmer takes the watch from Shade. Shade lets her."])
    elsif flag?(:watch_you)
      st.walk_to(shim, 9, 8, face: 4) if shim
      say(["Past midnight, Shimmer sits down beside you. \"Go on. I'm awake anyway.\""])
      st.walk_to(shim, 9, 6, face: 8) if shim
    end
    say(["By the window, Shimmer turns a little carved wooden cat over in her fingers."])
    if !flag?(:heard_of_glimmer)
      say([as(:shade, "(half asleep) You're doing the cat thing."),
           as(:shimmer, "I'm not scared. I'm counting."),
           as(:shimmer, "You carved it when we were kids. Terrible cats. They always wanted to be one."),
           as(:shimmer, "Cats get nine lives. You've used about six. Go to sleep.")])
    else
      say([as(:shade, "(half asleep) Still counting?"),
           as(:shimmer, "Still counting.")])
    end
    st.jingle("lullaby")
    say(["Then she hums. Four notes, very low. The same four, over and over."])
    speak(:alberica, "(mostly asleep) Louder, sweetheart. I'll learn it.", "(mostly asleep) ...Hm. Pretty.")
    say([as(:shimmer, "It isn't a song. The stone hums. I just keep it in tune.")])
    st.walk_to(shim, $game_player.x, $game_player.y, adjacent: true) if shim
    st.turn_to(shim) if shim
    c = pbMessage(_INTL("Shimmer laces her boots, and stops at your bedroll."),
                  [_INTL("\"Shimmer?\""), _INTL("(Keep your eyes shut.)")], -1)
    if c == 0
      set_flag(:shimmer_lied)
      say([as(:shimmer, "(a whisper) Privy. Go back to sleep.")])
    else
      set_flag(:shimmer_asked)
      say([as(:shimmer, "(a whisper) Look after Shade. They'll pretend they don't need it.")])
    end
    if shim
      st.leave(shim, *NIMSY_DOOR)
      pbSEPlay("Exit Door") rescue nil
    end
    pbFadeOutIn do
      $game_screen.start_tone_change(ATTIC_DAWN, 0) rescue nil
      st.wait(40)
    end
    mood(:requiem)
    say(["Morning. Shimmer's bedroll is empty."])
    # the player finds the note (notes 03 E6: an action, and a break in the run)
    pbMessage(_INTL("On the pillow: a note, and the carved wooden cat."), [_INTL("(Read the note.)")], -1)
    shade = party[:shade]
    st.walk_to(shade, 9, 7, face: 8) if shade
    say([as(:shade, "(reading) \"He said before the next moon, or he picks someone else.\""),
         as(:shade, "\"I'm not letting him pick. Don't follow. Keep the cat. S.\"")])
    if flag?(:shimmer_lied)
      st.turn_to(shade) if shade
      say([herald?(:shade) ? "You look up." : "Shade looks up at you.",
           as(:shade, "She told you the privy. She told me a storm.")])
    end
    say([as(:shade, "(very quiet) ...She always does this.")])
    state[:goal] = "Go after her."
    pbMessage(_INTL("What do you do?"), [_INTL("(Go after her.)")], -1)
    st.walk_to($game_player, *NIMSY_DOOR) if st.map?
    shimmer_vision(me)
    st.cleanup
    hide_household                                  # (the vision's cut home brought the house back)
    mood(:requiem)
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    state[:companions] = (state[:companions] || []) - [:shimmer]
    set_flag(:shimmer_taken)
    $game_switches[SW_SHIMMER_TAKEN] = true if $game_switches
    pbMessage(_INTL("\\me[lullaby]Shimmer left the party."))
    say([me ? "You're back in the attic. The pendant is gone. The rune on your chest isn't." :
              "You're back in the attic. Alberica's pendant is gone. The rune on her chest isn't.",
         me ? "(It itches. Like a snowflake that won't melt.)" : nil,
         as(:shade, "(very quiet) ...No.")].compact)
    speak(:alerion, "She's gone, Shade. She chose it.", "...She's gone, Shade.")
    speak(:alerion, "Stone circle. Birches. Someone in this town knows where.", "...Stone circle. Birches. Someone here knows where.")
    say([cl(:reptin, "(very quietly) She said no to a god. Twice.")].compact)
    # (Shade answers her with a look: as Alberica it's said aloud, not thought)
    speak(:alberica, "Shade. Look at me. We go together. Nobody goes alone.", "Shade. ...Together.") if with_or_is?(:alberica)
    say([outsider? && flag?(:shimmer_first) ? as(:shade, "(to you) You could have gone south. You came for her.") : nil,
         "Outside, under the window, a tall figure with long ears and a lantern waits in the snow."].compact)
    state[:goal] = "Outside. Someone's waiting under the window."
    jet_under_the_window
  end

  # The vision (SC 3.04): it takes you on the way out after her.
  # Purpose: the party sees Shimmer choose the third way: she refuses Auril,
  # shuts the door in herself, and takes the knife for the people Sephek
  # threatened. Silent but for the voices ("Snow falling without a sound").
  GLADE_SLAB   = [14, 10]
  GLADE_SEPHEK = [12, 10]      # on the slab's left, as the panels have him (notes 03 E7)

  def shimmer_vision(me = herald?(:alberica))
    say([me ? "Your pendant flares and cracks." : "Alberica's pendant flares and cracks.",
         outsider? ? "In your pocket, the #{my_glass} goes cold, as if it's watching too." : nil,
         me ? "(It's showing me her. It's showing me now.)" :
              "ALBERICA: (the pendant burning in her fist) That's her. That's now.",
         "The room goes white. Then you're all somewhere else, and none of you can move."].compact)
    # S-04 covers the cut to the Glade, where it plays out on the slab itself
    # under a frosted frame (O-03); S-05 is the frozen moment after.
    Stage.overlay("O-03", above_panels: true, fade: 20)
    Stage.panel("S-04", fade: 20)
    say(["A stone circle in the birches. Snow falling without a sound."])
    Stage.visit(GLADE_MAP, 14, 13, 8) do
      st = Stage
      pbBGMStop(0.5) rescue nil                     # (the vision is silent)
      shim = st.actor(:shimmer, *GLADE_SLAB, 2)
      st.pose(shim, "P-SHI-03", 3, frames: [0, 1], per: 24) if shim
      seph = st.actor(:sephek, *GLADE_SEPHEK, 6)
      # the sphere over her: a stand-in until its own effect is drawn (art request)
      sphere = st.fx("E-14", [GLADE_SLAB[0], GLADE_SLAB[1] - 1], oy: 8, loop_from: 0)
      st.panel_off(fade: 24)
      say(["Shimmer lies on a slab older than names, bound in cords of living ice.",
           "Above her floats a sphere of black-veined ice: a piece of Auril, waiting for a way in.",
           "It beats to someone else's pulse."])
      st.face(seph, 6) if seph
      say(["SEPHEK: She forgives, Shimmer. Take her back into you. Let the Dale breathe.",
           "SEPHEK: You won't be a prison this time. You'll be a queen.",
           "SHIMMER: A queen. Is that what she calls the coat now?",
           "SEPHEK: Then I go back to that square, and I choose. A child, this time.",
           "SHIMMER: Two doors, then. Hers, or some child's.",
           "SHIMMER: You forgot. There's always a third way.",
           "She closes her eyes. In her chest, something cracks like ice on a lake: the stone.",
           "SHIMMER: There. The door's shut. She can't come in."])
      $game_screen.start_shake(4, 6, 16) rescue nil
      st.stop_fx(sphere) if sphere
      say(["Above her, the black ice screams.",
           "SEPHEK: (the knife up, very sorry) Then she has you the hard way.",
           "SHIMMER: Do it. If she needs blood, let it be mine. But not for her.",
           "SHIMMER: For them."])
      pbMessage(_INTL("You can't move."), [_INTL("(Shout her name.)")], -1)
      say(["You open your mouth. No sound comes out."])
      st.walk(seph, [PBMoveRoute::ThroughOn, PBMoveRoute::Right]) if seph
      $game_screen.start_flash(Color.new(255, 255, 255, 220), 16) rescue nil
      st.hide(shim) if shim
      say(["The blade falls. White fire. When it fades, there is no body."])
      st.fx("E-14", [GLADE_SLAB[0], GLADE_SLAB[1] - 1], oy: 8, loop_from: 0)
      say(["Only a rose, frozen in bloom, growing out of the stone.",
           "Beside it, a heart of ice beats once, and breathes out mist."])
      st.turn_to(seph, shim) if seph && shim
      say(["Sephek reaches for the heart. The frost bites his hand, and he snatches it back."])
      # S-05: the frozen moment after (he is already on his knees in it)
      st.panel("S-05", fade: 12)
    end
    mood(:requiem)                                  # (not the house's music, coming home from the vision)
    state[:companions] = (state[:companions] || []) - [:shimmer]   # (her last line comes from nowhere)
    say(["Sephek is on his knees, weeping.",
         "SHIMMER: (from nowhere, very softly) Not all fire dies. Some of it just learns to freeze."])
    Stage.overlay_off("O-03", fade: 20)
    Stage.panel_off(fade: 20)
  end

  # Jet Sentry, outside Nimsy's door (context 03 M3-5): the one witness tells
  # what happened between the attic and the Glade, and leads you to the road.
  def jet_under_the_window
    st = Stage
    pbFadeOutIn { st.jump(MAPS[:lonelywood], 14, 24, 2) } if st.map?
    mood(:requiem)
    jet = st.find("Jet Sentry")
    if jet
      st.turn_to(jet)
      st.emote(jet, :exclaim)
      st.approach(jet)
    end
    say(["Long ears, a lantern, snow thick on her shoulders. She's been out here all night.",
         "JET SENTRY: Jet Sentry, of the Wennen. The moon-keepers, in the woods north of here.",
         "JET SENTRY: Before dawn she walked to the cold man's sleds. Nobody made her.",
         "JET SENTRY: He bound her in ice and carried her east.",
         as(:shade, "You watched him take her."),
         "JET SENTRY: I followed. I'm fast. He's faster, in the cold.",
         "JET SENTRY: The logging road, to the Glade of the Unmade. A stone circle. I'll take you."])
    set_flag(:jet_told)
    st.escort(jet, *JET_ROAD, facing: 6) if jet
    state[:goal] = "Follow the logging road east, through the forest, to the Glade of the Unmade."
  end

  # The Happy Scrimshander's keeper: a doughy spinster of few words, who never
  # talks about her past, only, fondly, about people she once knew who are dead.
  IRISKREE_DEAD = [
    ["IRISKREE: Corvin Tull used to buy that very needle. Steadiest hands in the Dale.",
     "IRISKREE: Went through the ice off Targos. He'd have liked you. He liked anyone who paid."],
    ["IRISKREE: Mags Ullan carved the best whales I ever saw. Lost her to a winter like this.",
     "IRISKREE: She laughed at everything. Even at the end. Especially at the end."],
    ["She looks at the scrimshaw knife in her hand.",
     "IRISKREE: A man in Luskan taught me to hold a blade very still.",
     "IRISKREE: He's dead now. Most of the people I knew then are. I'm the one who isn't."]
  ]

  def iriskree(event_id = nil)
    if first_time?(:met_iriskree)
      say(["A doughy, grey-haired woman looks up from the whale tooth she's engraving, and back down.",
           "IRISKREE: Iriskree Harrowhill. Needles, knives, inks, wax. Look. Buy. Don't chatter."], event_id)
    else
      lines = IRISKREE_DEAD[((counter(:iriskree_talks) rescue 0).to_i) % IRISKREE_DEAD.size]
      add_counter(:iriskree_talks)
      say(lines, event_id)
    end
    if first_time?(:iriskree_noticed)
      sayc([cl(:shade, "(quietly, once she's turned away) She stands like someone who's killed for money."),
            cl(:alerion, "Then she's retired. Leave it.")])
    end
    mart(:lonelywood, event_id)
  end

  #-----------------------------------------------------------------------------
  # Scenes
  #-----------------------------------------------------------------------------
  # SC 3.01 - What she carried. Purpose: the player learns what happened in
  # Saltmarsh (Auril wore Shimmer, the "vessel"), how Shimmer knows Sephek, and
  # why he wants her, pulled out of her by the bare footprints (context 03 M3-1).
  def scene_lonely_road_start
    st = Stage
    pbBGMFade(1.0) rescue nil                       # the map music cuts; only the wind
    st.pan_to(15, 52)
    say(["Bare footprints in the snow, running north. They don't sink."])
    st.pan_back
    say([as(:shade, "A trapper. Barefoot. People out here do strange things."),
         as(:shimmer, "Those are his. You know they are."),
         "Shimmer stops, and turns to face the rest of you.",
         as(:shimmer, "You should know why he wants me. Before he says it for me."),
         as(:shimmer, "Saltmarsh. A port, a long way south. A job: a stone in a box."),
         as(:shimmer, "I opened the box, and the Frostmaiden came in.")])
    # the memory: a frozen harbour (O-03 means a vision or memory; S-03a is the art request)
    st.overlay("O-03", fade: 16)
    st.panel("S-03a", fade: 16)
    say(["A harbour at night. A ship frozen solid in one breath, rigging and all.",
         "On its deck stands a girl with white light where her eyes should be.",
         as(:shimmer, "One night, she wore me like a coat. Her priests have a word for it. Vessel.")])
    st.panel_off(fade: 16)
    st.overlay_off("O-03", fade: 16)
    say([as(:shade, "(quietly) You told me it was a storm."),
         as(:shimmer, "It was a storm. Hers. You came into it after me anyway."),
         as(:shimmer, "Dragged me out by the hair."),
         as(:shade, "And in the morning there was a horn in the snow. I never knew whose."),
         as(:shimmer, "I got out. The stone didn't. It's still in here. A door she left open."),
         herald?(:alerion) ? "(Your ring goes cold when she says \"a door\". You know that cold.)" : nil,
         as(:shimmer, "She's sent him after me ever since. He always finds me. I always say no."),
         as(:shade, "Why didn't you tell me?"),
         as(:shimmer, "You'd have tried to fix it.")].compact)
    speak(:alberica, "(a hand over the rune) So she wants a coat again. She's trying me on for size.",
          "(a hand over the rune) ...She's trying me on for size.")
    say([cl(:reptin, "Then she's in for a shock. Nobody's ever made you fit anything.")].compact)
    st.theme(nil)
    st.cleanup
    set_flag(:shimmer_confessed)
    state[:goal] = "Lonelywood, north. Sephek wants Shimmer back as Auril's vessel."
  end

  NIMSY_ROOF = [15, 21]

  def scene_lonelywood_arrival
    set_flag(:lonelywood_arrived)
    say(["Lonelywood: timber houses in a crescent on the shore of Maer Dualdon.",
         "Five piers run out into the ice. The forest presses in behind."])
    Stage.pan_to(*NIMSY_ROOF)
    say(["Smoke rises from a green-roofed house. Someone in there is baking."])
    Stage.pan_back
    say([ask_as(:alberica, "Is that... cinnamon? In Icewind Dale? Somebody marry me.", "...Cinnamon?"),
         cl(:alerion, "No."),
         cl(:reptin, "He means congratulations."),
         cl(:shimmer, "He means no.")].compact)
    # Sephek is here, on the spine (context 03 M3-2): the goal's "waiting" pays off
    return if !with_or_is?(:shimmer) || flag?(:met_sephek_torgs) || flag?(:shimmer_taken)
    Stage.pan_to(37, 20)
    say(["Past the fisher's house, a man in shirtsleeves leans on a sled, watching the road."])
    Stage.pan_back
    state[:goal] = "Find Sephek at the sleds in the clearing, past the fisher's house."
  end

  # SC 3.05 - The Glade
  # Purpose: the party finds what Shimmer left (the rose, the heart of ice),
  # Meat Meat finishes Razzy's rite and joins, and Jet gives them a reason to
  # carry the heart to the temple where Sephek waits (context 03 M3-6, M3-7).
  GLADE_BELOW_SLAB = [14, 12]
  GLADE_BEHIND     = [14, 8]       # Meat Meat, asleep behind the altar (notes 03 E9)

  def scene_glade_aftermath
    return if flag?(:heart_of_ice)
    st = Stage
    # one scene, one row of triggers: the rest stand down
    if st.map?
      $game_map.events.each_value do |e|
        $game_self_switches[[$game_map.map_id, e.id, "A"]] = true if e.name == "Glade aftermath"
      end
      $game_map.need_refresh = true
    end
    mood(:requiem)
    if st.map?
      st.walk_to($game_player, *GLADE_BELOW_SLAB, face: 8)
      mm = st.actor(:meat_meat, *GLADE_BEHIND, 2) if !flag?(:meat_meat_joined)
      mm.transparent = true if mm
    end
    heart = st.fx("E-14", [GLADE_SLAB[0], GLADE_SLAB[1] - 1], oy: 8, loop_from: 0) if st.map?
    say(["The rose. And beside it, the heart of ice, beating once a minute."])
    pre = { alberica: "ALB", reptin: "REP", alerion: "ALE", meat_meat: "MM", wyn: "WYN" }[herald]
    if pre && st.map?
      me = st.herald(herald)
      st.pose(me, "P-#{pre}-02", 3, per: 8) if me
    end
    shim = st.actor(:shimmer, *GLADE_SLAB, 2) if st.map?
    st.pose(shim, "P-SHI-02", 0, frames: [0, 1, 2, 3, 0, 1, 2, 3], per: 6) if shim
    say(["You touch it. For a moment you see a girl in the wind with her arms open, smiling."])
    st.hide(shim) if shim
    st.stop_fx(heart) if heart
    st.unpose(me) if me
    say([as(:shade, "I'm not leaving her here.")])
    give_key(:FT_HEARTOFICE)
    set_flag(:heart_of_ice)
    $game_switches[SW_HEART_TAKEN] = true if $game_switches
    # Jet Sentry walks in up the south path behind you (context 03 M3-6)
    jet = nil
    if st.map?
      jet = st.actor(:jet_sentry, 14, 26, 8, graphic: JET_GFX)
      st.walk_to(jet, $game_player.x, $game_player.y, adjacent: true) if jet
      st.turn_to(jet) if jet
    end
    say(["JET SENTRY: A heart of ice. It's what's left when she tries to wear someone, and can't.",
         as(:shade, "(very quiet) ...She couldn't. Good.")])
    if !flag?(:meat_meat_joined)
      eggs = herald?(:reptin) ? "your arms" : "Reptin's arms"
      if mm
        mm.transparent = false
        st.emote(mm, :exclaim)
      end
      say(["Behind the altar, a bundle of furs sneezes."])
      st.walk_to(mm, GLADE_BELOW_SLAB[0] - 2, GLADE_BELOW_SLAB[1], face: 6) if mm
      say(["A goblin, half frozen, chewing mushroom jerky. Long white hair stiff with frost.",
           "Cracked goggles. Violet eyes. A pack bigger than she is.",
           "MEAT MEAT: Meat Meat followed Razzy's feet from Targos. Snow ate the feet.",
           "MEAT MEAT: Meat Meat dreamed Razzy fell into cold light.",
           "MEAT MEAT: Meat Meat followed the dream. Dream was wrong place. Rude dream.",
           "She sees the egg in #{eggs} and goes very still."])
      pbMessage(_INTL("What do you do?"), [herald?(:reptin) ? _INTL("(Hold the egg out to her.)") : _INTL("(Nudge Reptin toward her.)")], -1)
      reptin = herald?(:reptin) ? $game_player : st.summon(:reptin)
      st.walk_to(mm, reptin.x, reptin.y, adjacent: true) if mm && reptin
      st.turn_to(mm, reptin) if mm && reptin
      say(["MEAT MEAT: ...Razzy?",
           "The egg warms so suddenly it nearly slips.",
           "MEAT MEAT: That is Razzy. Razzy not dead. Just very cold. Meat Meat promises."])
      speak(:reptin, "She said his name, and she promised. That's the rite.", "...She said his name. She promised.")
      say(["MEAT MEAT: Razzy and Meat Meat ran away together. From a cold table.",
           "MEAT MEAT: From the lady with books and bones. She took Razzy's voice.",
           as(:reptin, "(quietly) The scar on his throat."),
           as(:alerion, "Pale, books and bones. Naerth's lady in the tower."),
           "MEAT MEAT: Meat Meat comes with you now. Meat Meat is not asking.",
           ask_cl(:alberica, "Oh, I love her. Can we keep her?"),
           "MEAT MEAT: Meat Meat will bite you. Fondly.",
           cl(:reptin, "She's saying she's grateful."),
           "MEAT MEAT: Meat Meat is saying the other thing. Also: who has coffee?",
           # the grief answers the jokes (dialogue 03 Top 5 #2)
           as(:shade, "(very quiet) She'd have liked you.")].compact)
      state[:companions] = ((state[:companions] || []) + [:meat_meat]).uniq
      set_flag(:meat_meat_joined)
      set_switch(SW_MEAT_JOINED, true)
      pbMessage(_INTL("\\me[Pkmn get]Meat Meat joined the party!"))
    else
      say(["Under your coat, the egg's heartbeat answers the heart of ice, beat for beat.",
           cl(:meat_meat, "Razzy can hear her. Razzy is being very brave.")].compact)
      if herald?(:meat_meat)
        # her road, said aloud to Shade, so the party hears it (context 03 §6)
        speak(:meat_meat, "The lady with books and bones took Razzy's voice. On her cold table.",
              "...The lady with books took his voice.")
        say([as(:alerion, "Pale, books and bones. Naerth's lady in the tower."),
             as(:reptin, "(quietly) The scar on his throat.")])
      end
    end
    set_flag(:razzy_named)
    say(["JET SENTRY: The Circle will want that heart.",
         as(:shade, "The Circle can ask. It's my sister's. It goes where I go."),
         "JET SENTRY: Then come with it. The Circle is our council: thirteen Wennen, in our Warren.",
         "JET SENTRY: The Warren is under the Moon Temple, north of town. Zenith can keep it safe.",
         "JET SENTRY: The cold man knows that. He'll be waiting at the door.",
         as(:shade, "Let him.")], jet ? jet.id : nil)
    st.leave(jet, 14, 27) if jet
    pbFadeOutIn { st.cleanup }                       # (Meat Meat walks with you now)
    st.theme(nil)
    state[:goal] = "The Moon Temple, north of town: the Wennen's Warren is under it, and Sephek is waiting."
  end

  def scene_moon_grounds_arrival
    say(["The path climbs to a shrine of old stone arches, half buried in snow.",
         "Spirals glow faintly on every post.",
         "Below the arches, a timber lodge with a root-grown door breathes out warm air.",
         "Mint, and earth.",
         cl(:meat_meat, "Rabbit Lords live here. Meat Meat will be very polite. Very.")].compact)
    if flag?(:shimmer_taken)
      # "Everybody does, eventually." (Ch1) - Alerion's answer was that everybody leaves, too
      say([cl(:reptin, "Leave the talking to me. Rabbits love me. Everybody—"),
           with_or_is?(:reptin) ? (herald?(:reptin) ? "You stop, and don't finish it." : "Reptin stops, and doesn't finish it.") : nil].compact)
    else
      say([cl(:reptin, "Leave the talking to me. Rabbits love me. Everybody does, eventually.")].compact)
    end
    say([cl(:shade, flag?(:heart_of_ice) ? "Talk later. He's here. I can feel it." :
                                           "Talk later. If he comes up here, he's mine.")].compact)
  end

  def scene_sephek_moon_temple(event_id = nil)
    if flag?(:sephek_defeated)
      return
    end
    st = Stage
    spot = ($game_map.events.values.find { |e| e.name == "Sephek in ice" } rescue nil)
    sx, sy = spot ? [spot.x, spot.y] : ([$game_player.x, $game_player.y - 2] rescue [0, 0])
    seph = st.actor(:sephek, sx, sy, 2) if st.map?
    mood(:frostmaiden)
    say(["The wind stops. Between the arches, a man in a thin linen shirt is waiting.",
         "His eyes are red. He hasn't stopped weeping.",
         "SEPHEK: Give me the heart, and the Frostmaiden forgets your names.",
         "SEPHEK: I can't take it. It burns me. It has to be given.",
         as(:shade, "You killed my sister."),
         "SEPHEK: (quietly) She killed herself. I only held the knife. I'm sorry. Give it to me.",
         cl(:alberica, "(a hand on Shade's arm) Not alone. Not this time.")].compact)
    here = $game_map.map_id
    won = pbTrainerBattle(:FT_SEPHEK, "Sephek", nil, false, 0)
    if !won
      # losing sends you to the Pokémon Center: re-arm the scene on the temple
      # map (not wherever you woke up), so he's waiting when you come back
      set_self_switch(event_id, "A", false, here)
      Stage.cleanup
      return
    end
    set_flag(:sephek_won)                # (before anything can re-arm the scene: notes 03 E21)
    say(["SEPHEK: ...So cold. Why is it so cold? The cold never touched me..."])
    st.pose(seph, "P-SEP-02", 0, frames: [0, 1], per: 10) if seph
    sephek_true_nature(seph)           # what he really is (Rime of the Frostmaiden; 044_ChasmFaithful.rb)
    if seph                            # (frost only creeps while he talks; the ice closes after: notes E10)
      pbSEPlay("Ice2") rescue nil
      st.fx("E-04", seph, frames: 10, hold: true, wait: false)
      st.pose(seph, "P-SEP-02", 0, frames: [2, 3], per: 12)
    end
    say(["Ice closes over him.",
         "In his chest, a sliver of blue light still beats. Slow as a sleeper."])
    speak(:alerion, "He's not dead. He's waiting.", "...He's waiting.")
    say([cl(:shade, "Then let him wait. Forever, if it's up to me.")].compact)
    set_flag(:sephek_defeated)
    set_flag(:sephek_frozen)
    # the Warden walks out to say where to go now (context 03 §5, 3.15 -> 3.16)
    nova = Stage.find("Nova Keeper")
    if nova
      Stage.approach(nova)
      say(lines_for(:nova_keeper), nova.id)
    end
    state[:goal] = "The Wennen's Warren, under the Moon Temple. Zenith Abbott is waiting at the Rose."
    $game_switches[SW_SEPHEK_DOWN] = true if $game_switches
    Stage.cleanup
    Stage.theme(nil)
    $game_map.need_refresh = true if $game_map     # (his statue takes the stand-in's place)
    add_counter(:story_beats)
  end

  # Saves where Sephek won before this was fixed: the fight never came back.
  def rearm_sephek
    return if !$game_map || $game_map.map_id != MAPS[:moon_grounds]
    return if flag?(:sephek_defeated) || flag?(:sephek_won) || !flag?(:heart_of_ice)
    ev = $game_map.events.values.find { |e| e.name.to_s == "Cutscene sephek_moon_temple" } or return
    key = [$game_map.map_id, ev.id, "A"]
    return if !$game_self_switches[key]
    $game_self_switches[key] = false
    $game_map.need_refresh = true
    log("Sephek's fight at the Moon Temple was re-armed.")
  rescue StandardError => e
    log("rearm_sephek: #{e.message}")
  end

  # Purpose: the Warren, its people, and the frost egg seen before the Requiem uses it (context 03 M3-9).
  WARREN_NURSERY = [9, 34]

  def scene_warren_enter
    st = Stage
    say(["The tunnel widens as it goes down: round halls of pressed clay, ribbed with white roots.",
         "Fungal veins glow along the walls. Driftwood lanterns burn amber. It's warm.",
         "Tall figures with long ears watch you pass. The Wennen, and their Circle of thirteen."])
    if st.map?
      nx, ny = WARREN_NURSERY
      st.actor(:wennen_guard, nx - 1, ny, 6, graphic: LOPUNNY_GFX)
      st.actor(:wennen_guard, nx + 1, ny, 4, graphic: LOPUNNY_GFX)
      st.pan_to(nx, ny)
    end
    say(["In a nest of white roots, two Wennen guard an egg of pale blue ice. It's never been warm."])
    if st.map?
      st.pan_back
      st.cleanup
    end
    say([cl(:meat_meat, "Big egg. Not Razzy. Meat Meat checked."),
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
    if !flag?(:shimmer_taken)
      # (nothing has happened yet: no verse that knows it will)
      say(["ZENITH: Moon above, roots below,",
           "ZENITH: a guest too soon. The rose says no.",
           "(The tall Wennen in green robes speaks only in verse.)"], event_id)
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
  # Purpose: what Shimmer chose is given a shape: the frost egg takes her heart
  # and hums her four notes, and Alerion names it Frostina. The player hands
  # Shade the heart (the decisive beat). Music: Requiem, then Thaw.
  ROSE_TILE = [11, 9]

  def scene_moon_requiem(event_id = nil)
    st = Stage
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    mood(:requiem)
    # Shade is beside you before anyone speaks (notes 03 E11), on your left so
    # Luna can come to your right
    shade = st.actor(:shade, px - 1, py, 6) if st.map? && !herald?(:shade)
    say(["Zenith Abbott, who keeps the Rose, speaks only in verse.",
         "ZENITH: A heart that chose. A rose that would not close.",
         "ZENITH: An egg that fell when winter first arose."], event_id)
    # Luna walks over for her part (notes 03 E5): nobody speaks from off screen
    luna = st.find("Luna Carver")
    st.approach(luna) if luna
    lid = luna ? luna.id : nil
    say(["LUNA CARVER: I dream for the Circle. I dreamed this egg.",
         "LUNA CARVER: The night the Rime began, the Frostmaiden's roc flew over us.",
         "LUNA CARVER: Iskra. A white bird, wide as a sail. Something fell from her."], lid)
    # two Wennen carry the egg up from the nursery and set it under the Rose
    egg = nil
    b1 = b2 = nil
    if st.map?
      rx, ry = ROSE_TILE
      b1 = st.actor(:wennen_bearer, px - 1, py + 3, 8, graphic: LOPUNNY_GFX)
      b2 = st.actor(:wennen_bearer, px, py + 3, 8, graphic: LOPUNNY_GFX)
      st.walk_to(b1, rx - 1, ry - 1, wait_for: false) if b1
      st.walk_to(b2, rx, ry - 1, face: 2) if b2
      guard = 0
      while b1 && b1.move_route_forcing && guard < 200
        st.wait(1)
        guard += 1
      end
      st.face(b1, 2) if b1
      egg = st.actor(:frost_egg, rx, ry, 2, graphic: "K-EGG-02")
      st.pose(egg, "K-EGG-02", 1, frames: [0], per: 4) if egg
    end
    say(["Two Wennen carry an ice egg up from the nursery and set it beneath the Rose.",
         "LUNA CARVER: An egg, cold all through. It never woke. We kept it anyway."], lid)
    # the decisive beat is yours: the heart goes from your bag to Shade's hand
    pbMessage(_INTL("Shade holds out a hand for the heart of ice."), [_INTL("(Give Shade the heart.)")], -1)
    take_key(:FT_HEARTOFICE)
    if shade
      st.walk_to(shade, ROSE_TILE[0], ROSE_TILE[1] + 1, face: 8)
      st.pose(shade, "P-SHA-02", 3, per: 8)
    end
    say(["Shade lays Shimmer's heart beneath the Rose, beside the pale-blue egg."])
    3.times do
      pbSEPlay("Player bump", 100, 60) rescue nil
      st.wait(14)
    end
    $game_screen.start_tone_change(Tone.new(30, 30, 50, 0), 30) rescue nil
    say(["The Wennen thump a slow beat with their feet. The false moon in the ceiling brightens."])
    mood(:thaw)
    pbSEPlay("Ice2") rescue nil
    say(["The egg doesn't crack. It warms.",
         "Frost-white light moves under the shell.",
         "Something inside turns over, the way someone used to in her sleep."])
    st.balloon(egg, "B-05", frames: 90) if egg
    st.jingle("lullaby")                       # her four notes, the same as the attic's
    say(["Then, from inside the shell, a hum. Four notes."])
    st.unpose(shade) if shade
    st.balloon(shade, "B-07", frames: 70) if shade
    say([as(:shade, "(very quiet) ...She said it wasn't a song."),
         flag?(:shimmer_asked) && !herald?(:shade) ? "You put a hand on Shade's shoulder." : nil,
         "ZENITH: Not her vessel. Her answer.",
         herald?(:alerion) ? "The ring on your hand warms for the first time. (...Frostina.)" :
                             "The ring on Alerion's hand warms for the first time.",
         herald?(:alerion) ? nil : "ALERION: ...Frostina.",
         cl(:alberica, "(softly) Frostina. She'd have hated that. She'd have loved it."),
         "LUNA CARVER: It has a heart now. It needs time, and the world hasn't got enough."].compact)
    st.remove_actor(egg) if egg
    give_key(:FT_FROSTEGG)
    say(["Shade wraps the Frost Egg in their coat. (You can check on it in Key Items.)"])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "(quietly) Razzy heard it too. Razzy wants a song.", "...Razzy heard it too.")
    end
    # Zenith's optional verse pays off much later: invite it (notes 03 E28)
    say(["ZENITH: Come back when the egg is still,",
         "ZENITH: and I will ask you, if you will."], event_id)
    st.leave_all([b1, b2].compact, px, py + 3)       # the bearers go back down; Shade stays by the Rose
    set_flag(:requiem_done)
    set_flag(:frost_egg)
    $game_switches[SW_REQUIEM_DONE] = true if $game_switches
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 30) rescue nil
    add_counter(:story_beats)
    state[:goal] = "Speak with Luna Carver before you go."
  end

  # SC 3.08 - One, two, three (Luna Carver, after the Requiem)
  # Purpose: the rule of three hearts; the Wennen take Sephek's ice south and
  # follow the party, over Shade's objection.
  def luna(event_id = nil)
    if !flag?(:requiem_done)
      return say(lines_for(:luna_carver), event_id)
    end
    if flag?(:knows_three_hearts)
      return say(["LUNA CARVER: Go on. We'll be behind you, at a distance. We're good at distance."], event_id)
    end
    st = Stage
    shade = st.speaker("SHADE") || st.summon(:shade) if !herald?(:shade)    # (still by the Rose, after the Requiem)
    say(["LUNA CARVER: One heart of ice is grief. Two is a burden. Three is a summons.",
         "LUNA CARVER: Shimmer's is the first, sung into the egg. The cold man's beats in his chest.",
         "LUNA CARVER: Bring a third to the other two, and the Frostmaiden gets a body to walk in.",
         cl(:reptin, "Then nobody brings a third. I'll be very rude about it."),
         outsider? ? "LUNA CARVER: (to you) You I can't see at all. Like you're not on her wheel yet." : nil].compact, event_id)
    lev = event_id && $game_map ? $game_map.events[event_id] : nil
    st.turn_to(lev, shade) if lev && shade
    say(["LUNA CARVER: (to Shade) And you. Your house has a spark in it that isn't out.",
         "LUNA CARVER: I can see it on you. It's waiting somewhere bright.",
         as(:shade, "My house is one smuggler and a carved cat. But thanks."),
         "LUNA CARVER: The cold man can't stay at our temple with his heart beating.",
         "LUNA CARVER: We'll take him south on a sledge, and follow you. At a distance.",
         # Shade objects to the Wennen keeping Shimmer's killer (dialogue 03 Top 5 #3)
         as(:shade, "You're bringing him."),
         "LUNA CARVER: We keep what the cold leaves. Her egg, for two years. Now him."], event_id)
    st.turn_to(lev) if lev
    set_flag(:knows_three_hearts)
    set_flag(:luna_spark)
    set_flag(:wennen_follow)
    set_switch(SW_WENNEN_FOLLOW, true)
    scene_laughing_calling           # Zenith is here to say it (notes 03 E2: not from Lonelywood)
  end

  # Leaving the Warren without hearing Luna would skip the Wennen following you
  # (notes 03 E5): Jet Sentry, by the way out, sends you back to her.
  def warren_exit_check(_event_id = nil)
    return if !flag?(:requiem_done) || flag?(:knows_three_hearts)
    jet = Stage.find("Jet Sentry")
    say(["JET SENTRY: Luna's by the Rose. Hear her out before you go."], jet ? jet.id : nil)
    $game_player.turn_up rescue nil
    $game_player.move_up rescue nil
  end

  # Lonelywood's old autorun for SC 3.09 (saves from before it moved into the
  # Warren): if Luna was never heard, her flags are set so later chapters work.
  def scene_laughing_calling_town(event_id = nil)
    if !flag?(:knows_three_hearts)
      %i[knows_three_hearts luna_spark wennen_follow].each { |f| set_flag(f) }
      set_switch(SW_WENNEN_FOLLOW, true)
    end
    scene_laughing_calling
  end

  # SC 3.09 - The laughing is the calling, in the Warren after Luna, then the
  # sledge south (context 03 M3-10).
  # Purpose: the hag is named and the next road is south-east; the player
  # takes the Wennen's sledge to Bryn Shander. Music: Hunt.
  def scene_laughing_calling
    return if flag?(:hag_named)
    st = Stage
    jet = nil
    mood(:hunt)
    if st.map? && $game_map.map_id == MAPS[:warren]
      # (she comes up the passage from the south, the way the egg came)
      jet = st.actor(:jet_sentry, $game_player.x, $game_player.y + 3, 8, graphic: JET_GFX)
      st.walk_to(jet, $game_player.x, $game_player.y, adjacent: true) if jet
      st.turn_to(jet) if jet
    end
    zen = st.find("Zenith Abbott")
    say(["ZENITH: South of the Hole, where the ice holds them all,",
         "ZENITH: a crone laughs low, and the laughing's the call."], zen ? zen.id : nil)
    say(["JET SENTRY: Plain words: a hag lives in a chasm south of Dougan's Hole.",
         "JET SENTRY: The fishers hear her laughing on the ice. So do your trinkets.",
         outsider? ? "JET SENTRY: (to you) She keeps mirrors. Cold glass. Like the shard you carry." : nil].compact,
        jet ? jet.id : nil)
    # (Alerion answers her: as Alberica it's said aloud)
    speak(:alberica, "A laughing hag who wants our jewellery. I've dated worse.", "...A hag. Lovely.") if with_or_is?(:alberica)
    say([cl(:alerion, "You have.")].compact)
    set_flag(:hag_named)
    state[:goal] = outsider? ? "South-east to Dougan's Hole: who's calling them, and the hag's mirrors." :
                              "South-east to Dougan's Hole. Find who's calling us."
    sledge_south(jet)
  end

  # The chapter's last bridge: the Wennen's sledge, Sephek's ice, and what
  # Shimmer bought Bryn Shander (context 03 M3-10). The road home stays walkable.
  BRYN_EAST_GATE = [40, 22]

  def sledge_south(jet = nil)
    st = Stage
    say(["JET SENTRY: Our sledge goes south tonight, with the cold man in his ice. Ride with us."], jet ? jet.id : nil)
    return if !st.map? || !$scene.respond_to?(:transfer_player)
    pbMessage(_INTL("The sledge leaves tonight."), [_INTL("(Ride south with the Wennen.)")], -1)
    pbFadeOutIn { st.jump(MAPS[:bryn], *BRYN_EAST_GATE, 6) }
    gx, gy = BRYN_EAST_GATE
    st.actor(:sephek_sledge, gx, gy + 1, 6, graphic: "FT_sephek_frozen")
    st.actor(:wennen_driver, gx - 1, gy + 1, 6, graphic: LOPUNNY_GFX)
    jet = st.find("Jet Sentry") || st.actor(:jet_sentry, gx + 1, gy + 1, 4, graphic: JET_GFX)
    guard = $game_map.events.values.find { |e| e.name.to_s =~ /bryn_east_guard_open/ && !e.character_name.to_s.empty? }
    guard ||= st.actor(:gate_guard, gx + 3, gy, 4, graphic: "BWPoliceman")
    say(["Two nights on the sledge, south past Termalaine. In his ice, Sephek never once blinks."])
    st.approach(guard) if guard
    gid = guard ? guard.id : nil
    say(["GUARD: (staring at the ice) Is that him? The man in the shirt?"], gid)
    st.turn_to(jet, guard) if jet && guard
    say(["JET SENTRY: Sleeping. We'll watch him. That's what we're for."], jet ? jet.id : nil)
    say([herald?(:alberica) ? "GUARD: Board's down in the square. Speaker's word. Nobody drawn since you sang." :
                              "GUARD: Board's down in the square. Speaker's word. Nobody drawn since your dwarf sang.",
         "GUARD: Gate's open. The Hole's that way. Nobody's come back from it in a month."], gid)
    st.cleanup
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
