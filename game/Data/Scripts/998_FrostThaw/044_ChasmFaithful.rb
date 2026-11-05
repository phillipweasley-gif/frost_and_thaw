#===============================================================================
# Frost & Thaw - Act I in full: the Cackling Chasm and Sephek Kaltro
#
# The faithful build-out (Nov 2026) of everything the campaign's "The Cackling
# Chasm" module and Rime of the Frostmaiden's "Cold-Hearted Killer" put in Act I
# that the first adaptation had cut down or left out (docs/audit A and E):
#
#   The hag's bargain (end the winter, cure Reptin), made at the Twenty Stones
#   and called in at the Heart; her temptation of Reptin all the way down.
#   The chasm's atmosphere: names whispered, the gnoll femur in the fallen ice,
#   the feast hall's carnage and Yeenoghu's blood runes, the hall of illusions'
#   mind games, the bridge as a real crossing (you can fall), the rift floor
#   below it, the will-o'-wisps, the coldlight walker, voices on the wind.
#   The Order's history, the ghost's warnings, prophecy, talisman and dagger,
#   the Druidic Codex. The hag in full: her look, her cauldron, her flight on
#   the staff, the Heart's lair magic, the troll that only fire stops, and her
#   last lunge at the cub. A dark path you can take, and where it leads.
#   The loot, the legacy, the wildflower and the wolves, the owl feather, the
#   wolf-and-bloom carving, "Glimmer in the Chasm".
#   Hlin Trollbane's hunt for the ice-dagger killer, Torrga Icevein and Torg's,
#   and what Sephek Kaltro really is.
#===============================================================================
module FrostThaw
  SW_TORRGA_GONE  = 4000   # Torg's has been dealt with: Torrga beaten, the camp packed up
  SW_HLIN_PAID    = 4001   # Hlin Trollbane has paid out (she leaves the Lucky Liar's corner)
  SW_WALKER_DOWN  = 4002   # the coldlight walker on the far ledge of the rift is laid to rest
  SW_MOTHER_DEAD  = 4003   # the mother yeti fought to the death over her mate
  SW_CODEX_TAKEN  = 4004   # the Druidic Codex is off the sanctum shelf
  SW_RIFT_GNOLL   = 4005   # the cackling gnoll ghost on the rift floor is quiet

  MAPS.merge!(rift_floor: 2100)
  MAP_NAMES.merge!(2100 => "The Rift Floor")
  MAP_METADATA.merge!(2100 => { announce_location: true, battle_environment: :Cave })
  AREAS.merge!(2100 => :rift)
  ENCOUNTERS[2100] = { step_chances: { Cave: 10 },
                       Cave: [[25, :HAUNTER, 29, 31], [20, :DUSKULL, 29, 31], [20, :GOLBAT, 29, 31],
                              [15, :MISDREAVUS, 29, 31], [10, :CUBONE, 29, 31], [10, :MAROWAK, 30, 32]] }

  #-----------------------------------------------------------------------------
  # Treasure and keepsakes
  #-----------------------------------------------------------------------------
  RELIC_ITEMS.merge!(
    FT_GRAYSTAFF: ["Black Ice Staff", "Black Ice Staffs", 1, 0,
      "Granny Thredra's Graystaff, cracked. A held item that boosts the holder's Ice-type moves. Whoever carries it goes hungry in the deep cold, and dreams of cackling.", 0, 0, 0],
    FT_WOLFPELT: ["Winter Wolf Pelt", "Winter Wolf Pelts", 1, 0,
      "A hank of Kanan's white pelt, torn out at the Heart. A held item: the holder takes half damage from Ice-type moves.", 0, 0, 0],
    FT_ORDERDAGGER: ["Order's Silver Dagger", "Order's Silver Daggers", 1, 0,
      "The last guardian's silver dagger, from beside her bier. A held item that hits Ghost and Fairy types (hags are fey) a quarter harder.", 0, 0, 0],
    FT_DRUIDCODEX: ["Druidic Codex", "Druidic Codices", 8, 0,
      "The Order of Life and Death's codex: its rites, its wardens, and the ritual to recharge the Heart. Some pages are best left closed.", 2, 0, 6],
    FT_HEARTSHARD: ["Heart Shard", "Heart Shards", 8, 0,
      "A sliver of the Heart of the Chasm's blood-red ice. It never melts. Hold it too long and you dream of both the living and the dead.", 2, 0, 6],
    FT_WOLFBLOOM: ["Wolf-and-Bloom Carving", "Wolf-and-Bloom Carvings", 8, 0,
      "A wolf and a flower, carved together out of ancient ice. Warm to the touch. Nobody saw who left it.", 2, 0, 6],
    FT_OWLFEATHER: ["Rimed Owl Feather", "Rimed Owl Feathers", 8, 0,
      "A black feather from a snowy owl, coated in rime. It doesn't thaw. The Frostmaiden's mark.", 2, 0, 6],
    FT_GLIMMERJOURNAL: ["Glimmer's Journal", "Glimmer's Journals", 8, 0,
      "A waterlogged journal from the feast hall, signed \"Glimmer\". Most of it is ruined with blood.", 2, 0, 6],
    FT_OPAL: ["Hag's Opal", "Hag's Opals", 1, 8000,
      "An opal fished out of Granny Thredra's ritual brew. A collector would pay a great deal for it, and ask no questions.", 0, 0, 0],
    FT_GEMSTONE: ["Small Gemstone", "Small Gemstones", 1, 1000,
      "A small polished stone. A shop will give a little money for it.", 0, 0, 0],
    FT_BLACKICERING: ["Black Ice Ring", "Black Ice Rings", 1, 3000,
      "A ring of black ice from one of Auril's faithful. Cold right through your gloves. It would sell, to the right buyer.", 0, 0, 0],
    FT_GNOLLAXE: ["Rusty Greataxe", "Rusty Greataxes", 1, 400,
      "A gnoll's greataxe, rusted nearly through. Worth a few coins as scrap.", 0, 0, 0]
  )

  TRAINER_TYPES.merge!(
    FT_BANDITCAPTAIN: ["Bandit Captain", :CRUSHGIRL, 1, 70],
    FT_TORGHAND:      ["Torg's Hand",    :ROUGHNECK, 0, 35],
    FT_WINTERCROWN:   ["Winter-Crowned", :CHANNELER, 1, 200, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    torrga:        [:FT_BANDITCAPTAIN, "Torrga", [[:SNEASEL, 18], [:B215H95, 19], [:B20H95, 19], [:HONCHKROW, 20]],
                    "Business is business. And business is closed.", [:SUPERPOTION]],
    torg_hand:     [:FT_TORGHAND,      "Brannig", [[:HOUNDOUR, 17], [:MIGHTYENA, 18]],
                    "She pays us to drive dogs, not to bleed."],
    torg_hand2:    [:FT_TORGHAND,      "Oska", [[:SNEASEL, 17], [:MIGHTYENA, 17]],
                    "Not my sled. Not my fight. Not my teeth, either."],
    torg_hand3:    [:FT_TORGHAND,      "Corran", [[:POOCHYENA, 16], [:HOUNDOUR, 18]],
                    "...You could've just bought something."],
    torg_hand4:    [:FT_TORGHAND,      "Skeld", [[:MURKROW, 17], [:MIGHTYENA, 18]],
                    "Tell the boss I tried."],
    ethel:         [:FT_HAG,           "Ethel", [[:B124H71, 31], [:B44H94, 32]],
                    "Sister... you promised me a share..."],
    thredra_crown: [:FT_WINTERCROWN,   "Thredra", [[:B429H124, 36], [:B272H310, 36], [:B255H200, 37], [:B124H429, 38]],
                    "Winter... kept... its... bargain..."]
  )

  TRAINER_INTROS.merge!(
    torrga:        "TORRGA: You've had your hands in my sacks. That's theft, that is. Brannig! Business!",
    torg_hand:     "BRANNIG: Boss says you're done shopping.",
    torg_hand2:    "OSKA: Off the sleds! Now!",
    torg_hand3:    "CORRAN: Boss wants you gone. So. Gone.",
    torg_hand4:    "SKELD: Four of us and one of her. You picked a bad fight.",
    thredra_crown: "THREDRA: Winter's mine now, dearies. All of it. Come and have a taste.",
    ethel:         "ETHEL: A share of the cutting, sister promised. I'll start with you."
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    # --- the chasm ---------------------------------------------------------------------
    fallen_ice: ["One of the big fallen icicles has something inside it, frozen in like a fly in amber:",
                 "a bone. Half gnawed. Too long and too bent to be a person's.",
                 "A gnoll's thighbone. Whatever lived in these caves before her, she's been feeding on it."],
    blood_runes: ["The walls are smeared with dried blood: sweeping handprints, long claw marks.",
                  "Among them, painted over and over, crude runes in a demon's script. Two words, again and again:",
                  "HUNGER. FEAST.",
                  "Over the top of everything, a sign like a hyena's head, cut deep into the stone:",
                  "the mark of Yeenoghu, the demon lord of gnolls, gouged across an older carving.",
                  "Under the gouges you can just make out what it defaced: a ring of leaf and bone. Life and death, turning."],
    chasm_coins: ["Among the bones and the frozen packs: coins. Ten-Towns mint, and some from much further south.",
                  "Whoever carried them didn't get any further than this hall."],
    gnoll_axe_left: ["A gnoll lies broken in the bones. Its greataxe is gone; you took it.",
                     "Its necklace of dried ears you leave exactly where it is."],
    gnoll_remains: ["Gnolls. Dozens of them, broken on the ice, still in their rusted mail.",
                    "Their jaws are frozen open. Laughing, or screaming. In the cold it's hard to tell which.",
                    "This is where the chasm's cackle came from, once. This is where it ended."],
    gnoll_quiet: ["The gnoll bones lie still now. The wind down here has stopped laughing."],
    rift_wisp_light: ["Two little lights drift over the ice, bobbing, waiting.",
                      "They don't come closer. They don't need to."],
    walker_after: ["The frozen wanderer lies face down on the ledge. Its eyes are only ice now.",
                   "Someone came this far looking for something. You hope they found it first."],
    heart_cauldron: ["A great iron cauldron squats beside the dais, over a fire of blue flame that gives no heat.",
                     "Thick white vapour pours over its lip and rolls round the dais like a caul.",
                     "Inside: a slush of blood and ice and herbs. Things turn over in it that you don't look at for long."],
    heart_cauldron_after: ["The cauldron has gone cold. The blue fire is out, and the brew has frozen solid."],
    codex_shelf: ["A shelf cut into the rock behind the bier. On it, wrapped in oilcloth, a heavy leather-bound book."],
    codex_shelf_after: ["The shelf is bare now, but for a ring in the dust where the Codex lay."],
    # --- Lonelywood: Torg's, and Hlin Trollbane -------------------------------------------
    torgs_flag: ["A dog-sled flag snaps in the wind: a gold wolf's paw on a black field.",
                 "TORG'S. GOODS FOR SALE. NO CREDIT. NO QUESTIONS."],
    torgs_dogs: ["Six sled dogs to a team, curled nose to tail in the snow. One thumps its tail at you.",
                 "Friendlier than the people who own them."],
    torgs_hand_idle: ["TORG'S HAND: Buying? Talk to the boss. Not buying? Keep walking.",
                      "TORG'S HAND: And don't stare at the cold one. He likes it."],
    torgs_camp_gone: ["Sled tracks and frozen dog mess. Torg's has moved on, and not in a hurry to come back."],
  )

  PARTY_CHAT[:alberica].merge!(rift_floor: ["Well. Down is one direction we hadn't tried.", "I'm putting this in the song. Heroically. With fewer bruises."])
  PARTY_CHAT[:reptin].merge!(rift_floor: ["All these bones. They were wardens' enemies, once. I don't feel sorry. I'm trying to."])
  PARTY_CHAT[:alerion].merge!(rift_floor: ["The dead down here are angry. Not at us. At the joke."])
  PARTY_CHAT[:shade].merge!(rift_floor: ["Eighty feet. I've had worse falls. I haven't had many."])
  PARTY_CHAT[:meat_meat].merge!(rift_floor: ["Meat Meat fell! Meat Meat is fine! Meat Meat is a bit flat."])

  module_function

  #-----------------------------------------------------------------------------
  # Small helpers
  #-----------------------------------------------------------------------------
  def reptin_name = herald?(:reptin) ? "you" : "Reptin"
  def alberica_name = herald?(:alberica) ? "you" : "Alberica"

  def give_money(amount, what)
    $Trainer.money += amount rescue nil
    pbMessage(_INTL("\\me[Item get]{1} (₽{2})", what, amount)) rescue nil
  end

  # Names whispered in the dark: once each, at a few places in the chasm.
  WHISPERS = {
    1 => ["Somewhere in the dark ahead, very faintly, someone whispers your name.",
          "When you stop to listen, there's only the wind, and the wind laughing."],
    2 => ["Your torchlight shivers in the draught. The shadows on the walls reach like hands, and let go.",
          "The floor here is glazed with ice. Somebody's feet go out from under them, and they land hard, and laugh too loudly getting up.",
          "Out of the corner of your eye, something watches. When you turn, it's your own reflection in the ice."],
    3 => ["A whiff of smoke and herbs drifts down from somewhere deep. Somebody is cooking.",
          "Under it, the old, sweet smell of rot."],
    4 => ["Frost has crept over every buckle and blade you're carrying. Your breath hangs in front of you like a ghost.",
          "Your name again, closer. Then a giggle."]
  }

  def chasm_whisper(n, event_id = nil)
    key = :"chasm_whisper_#{n}"
    return if flag?(key)
    set_flag(key)
    say(WHISPERS[n] || [])
    if n == 4
      sayc([cl(:shade, "Did everyone hear that, or is it just me?"),
            cl(:alerion, "Everyone."),
            cl(:meat_meat, "Meat Meat heard Meat Meat's name. Meat Meat said \"what\". Nobody answered. Rude.")])
      heart_acorn_remembered
    end
  end

  # On the way up to the Heart: the acorn from Chapter 2, and the egg, warm
  # before they're needed (context 05 M5-2: "Plant it somewhere the sun can't reach").
  def heart_acorn_remembered
    return if flag?(:acorn_remembered)
    set_flag(:acorn_remembered)
    if flag?(:golden_acorn) && with_or_is?(:reptin)
      say([herald?(:reptin) ? "In your pack, something is warm. You take out the golden acorn and look at it." :
                              "In Reptin's pack, something is warm. He takes out the golden acorn and looks at it.",
           as(:reptin, "\"Somewhere the sun can't reach.\" Well. We found it.")])
    end
    if flag?(:frost_egg) && with_or_is?(:shade)
      say([herald?(:shade) ? "A hand on your coat. (The egg's warm too.)" : "SHADE: (a hand on their coat) The egg's warm too."])
    end
  end

  def chasm_fallen_ice(event_id = nil)
    talk(:fallen_ice, event_id)
    set_flag(:saw_gnoll_femur)
    sayc([cl(:reptin, "Gnoll. They used to laugh in here. Now she does."),
          cl(:alerion, "Somebody ate that. Recently, and also not.")]) if !flag?(:femur_talked)
    set_flag(:femur_talked)
  end

  #-----------------------------------------------------------------------------
  # The feast hall
  #-----------------------------------------------------------------------------
  def scene_feast_hall_enter
    return if flag?(:feast_hall_seen)
    set_flag(:feast_hall_seen)
    say(["The tunnel widens into a chamber of ice and dark. Your light finds a scene of carnage, frozen in place.",
         "Gnawed bones and carcasses everywhere: mountain goats, foxes, hares, gnolls.",
         "A trapper's boot with the foot still in it. A dwarf's caravan harness. What looks like a human arm.",
         "The walls are smeared brown and red: handprints, claw marks, long frozen.",
         "The smell of old blood and rot is thick enough to taste."])
    if herald?(:reptin)
      say(["The smell hits you like a hand. Your gums ache. Your eyes sting, then sharpen: everything in the hall goes amber.",
           "(The wolf wants this place. The wolf thinks this place smells like dinner.)"])
      speak(:reptin, "(through his teeth) I'm fine. Give me a moment. I'm fine.", "...A moment.")
    else
      sayc(["Reptin stops dead. His breath comes short. When he looks round, his eyes are flashing amber.",
            "REPTIN: (baring his teeth, then catching it) This... this isn't right. She's been busy in here.",
            "REPTIN: Give me a moment. I'm fine."])
    end
    sayc([cl(:alberica, "(a hand flat between his shoulder blades) Breathe, sugar. In through the nose. Actually, no. Through the mouth."),
          cl(:alerion, "(stepping between him and the worst of it) Look at me, not at that.")])
    set_flag(:reptin_amber)
    blood_runes if pbConfirmMessage(_INTL("Among the smears on the walls, there are shapes. Runes. Look closer?"))
  end

  def blood_runes(event_id = nil)
    talk(:blood_runes, event_id)
    return if flag?(:read_blood_runes)
    set_flag(:read_blood_runes)
    sayc([cl(:alerion, "Gnolls. They pray to a hyena-headed demon. They broke in and defiled this place."),
          cl(:reptin, "That ring under the gouges. Leaf and bone. I've seen it before. In the dream.")])
  end

  def chasm_coins(event_id = nil)
    talk(:chasm_coins, event_id)
    give_money(1250, "You gather up thirty-two gold and eighteen silver coins.")
    set_self_switch(event_id, "A")
  end

  def gnoll_axe(event_id = nil)
    say(["A gnoll lies broken in the bones, still gripping a rusty greataxe.",
         "Round its neck hangs a necklace of dried ears. Trophies."], event_id)
    if pbConfirmMessage(_INTL("Take the greataxe? (It's scrap, but it's worth something.)"))
      give(:FT_GNOLLAXE)
      sayc([cl(:meat_meat, "Meat Meat will sell axe. Meat Meat will not sell ears. Meat Meat has standards.")])
      set_self_switch(event_id, "A")
    end
  end

  # The yeti's after-fight: the hag watches, and Reptin swears.
  def yeti_after_echo
    if flag?(:yeti_calmed)
      say(["From everywhere, delighted: \"Singing to the beasties? How sweet. Hurry along, dearies. Time is ticking.\""])
    else
      say(["From everywhere at once, the crone's voice, pleased as a cat:",
           "\"Ohhh, such violence... tsk, tsk. Hurry along now, dearies. Time is ticking...\""])
    end
  end

  #-----------------------------------------------------------------------------
  # The frozen rift: the crossing, the voices, the lights, the fall
  #-----------------------------------------------------------------------------
  BRIDGE_PLANS = [:rope, :slow, :walk]

  def bridge_plan = state[:bridge_plan] || :slow

  def choose_bridge_plan
    c = pbMessage(_INTL("How do you cross?"),
                  [_INTL("Rope up, one at a time"), _INTL("Single file, slow, low"), _INTL("Just walk across")], 1)
    plan = BRIDGE_PLANS[c] || :slow
    state[:bridge_plan] = plan
    case plan
    when :rope
      sayc([cl(:alerion, "Rope. Round the waist. I anchor this end, then whoever's last anchors the other."),
            cl(:alberica, "The old railing?"),
            cl(:alerion, "Don't touch the old railing."),
            "You knot yourselves together and go over one at a time, slowly."])
    when :slow
      sayc(["You go single file, bent low, testing every step before you trust it.",
            cl(:shade, "Don't use the railing. It's decoration.")])
    else
      sayc([cl(:meat_meat, "Bridge is a floor with ambitions. Meat Meat walks on floors all day."),
            "You set off across the ice at a walk."])
    end
  end

  # The midpoint of the span: the slip.
  def bridge_slip(event_id = nil)
    return if flag?(:bridge_slipped)
    set_flag(:bridge_slipped)
    say(["Out of the dark below, two small glowing lights rise beside the bridge and bob there, like lanterns held by nobody.",
         "Something with leathery wings bursts out from under the span, shrieking, and is gone."])
    case bridge_plan
    when :rope
      say(["A foot goes. Somebody's over the side!",
           "The rope snaps taut. They swing out over nothing, and back, and you haul them up hand over hand.",
           "Nobody says anything for a long moment. Then everybody breathes."])
      sayc([cl(:alerion, "That's what the rope's for.")])
    when :slow
      say(["Your foot goes out from under you. You're flat on your belly on the ice, clinging,",
           "and pebbles skitter off the edge into the dark. You never hear them land."])
      hurt_party(0.05)
      sayc([cl(:alberica, "Up you come, darling. Slowly. I've got your collar.")])
    else
      say(["The lights startle you. Your foot slides. Then there's no bridge under it at all."])
      c = pbMessage(_INTL("You're going over!"), [_INTL("Grab for the old railing"), _INTL("Grab for the edge")], 1)
      if c == 0
        say(["Your hand closes on the old rope railing. It holds for one heartbeat, and snaps."])
        fall_from_bridge
        return
      end
      say(["Your fingers catch the lip of the stone. You're hanging over the dark by one hand."])
      saver = [:alberica, :alerion, :shade, :meat_meat, :reptin].find { |k| companions.include?(k) }
      if saver
        say(["#{COMPANION_NAMES[saver].capitalize} throws themself flat and grabs your wrist.",
             "For a long moment nobody's sure which way this is going. Then they haul, and you come up over the edge."])
        say([as(saver, { alberica: "I'm putting that in the song. With me as the hero. Which I was.",
                         alerion: "Don't do that again.",
                         shade: "Walk. Like a normal person. Please.",
                         meat_meat: "Meat Meat caught you! Meat Meat is very strong for size of Meat Meat!",
                         reptin: "I've got you. I've got you. Don't look down." }[saver])])
      else
        say(["Nobody's close enough. Your fingers give."])
        fall_from_bridge
      end
    end
  end

  def fall_from_bridge
    pbSEPlay("Fall") rescue nil
    say(["The dark takes you. Wind, laughter, the bridge shrinking to a thread overhead,",
         "and then ice, and broken stone, and a long, long slide."])
    hurt_party(0.35)
    set_flag(:fell_into_rift)
    transfer(MAPS[:rift_floor], 14, 7, 2)
  end

  def scene_rift_floor_arrive
    return if flag?(:rift_floor_seen)
    set_flag(:rift_floor_seen)
    say(["You come to a stop eighty feet down, on a slope of ice and broken stone. Everything hurts.",
         "Far above, the bridge is a thread across the dark. Faint lights move down here with you."])
    sayc([cl(:alberica, "(from somewhere above, very small) ARE YOU ALIVE?"),
          cl(:alerion, "(from above) Stay there. There's a chute on the far wall. Climb the chute. We'll meet you at the ledge."),
          "(The others are coming down after you anyway. Of course they are.)"])
  end

  def rift_floor_climb(event_id = nil)
    say(["A chute of ice runs up the wall, notched with old gnoll claw marks. It goes all the way back up.",
         "It takes a long time. Your hands go numb, then stop telling you anything at all."], event_id)
    return if !pbConfirmMessage(_INTL("Climb back up to the bridge?"))
    hurt_party(0.05)
    say(["Hand over hand, notch over notch, you climb out of the rift and roll onto the near ledge."])
    transfer(MAPS[:rift], 8, 22, 6)
  end

  def gnoll_remains(event_id = nil)
    return talk(:gnoll_quiet, event_id) if flag?(:rift_gnoll_laid)
    talk(:gnoll_remains, event_id)
    say(["Then the bones begin to laugh. A ghost climbs up out of them, hyena-headed, cackling with a dead mouth,",
         "and grabs for you with hands like smoke!"])
    return if !boss_battle(named_mon(:B229H94, 30, "Gnoll ghost"))
    say(["The ghost comes apart in the wind like smoke, still laughing, and the laugh goes thin, and stops."])
    set_flag(:rift_gnoll_laid)
    $game_switches[SW_RIFT_GNOLL] = true if $game_switches
    give(:FT_GEMSTONE, 2)
  end

  # Voices in the wind, past the gust: each of you hears someone.
  def rift_voices(event_id = nil)
    return if flag?(:rift_voices)
    set_flag(:rift_voices)
    say(["The laughter on the wind changes. It isn't laughter any more. It's voices."])
    # one line each that names who they hear (context 05 M5-4): the only place in
    # Act I that Anduin and Talion can be planted
    sayc([herald?(:alberica) ? "(A woman laughing the way your mother used to, at a joke you've forgotten.)" :
                               cl(:alberica, "...That's my mother laughing. She's been dead twenty years."),
          herald?(:reptin) ? "(Wolves, singing. And under them Anduin, your husband, calling you home.)" :
                             cl(:reptin, "Wolves. And Anduin, calling me home. My husband. He can't be here.")])
    if herald?(:alerion)
      say(["(A boy's voice: \"You said you'd come back.\" Talion. You didn't.)"])
    elsif with_or_is?(:alerion)
      sayc([cl(:alerion, "(very quiet) A boy. \"You said you'd come back.\"")])
      speak(:alberica, "Who is he?", "...Who?") if with_or_is?(:alberica)
      sayc([cl(:alerion, "My brother. Talion. I didn't.")])
    end
    sayc([herald?(:shade) ? "(Shimmer, laughing at you. The good laugh. The one you'd do anything to hear again.)" :
                            cl(:shade, "...That's her. That's her laughing."),
          herald?(:meat_meat) ? "(A small happy chirp. Razzy's chirp. It comes from nowhere.)" :
                                cl(:meat_meat, "Razzy? RAZZY? ...Not Razzy. Wind. Mean wind.")])
    say(["Children giggling. Your own name, over and over.",
         "Then the wind drops, and it's only wind."])
    if flag?(:took_right) && !flag?(:took_left)
      say(["In the ice wall beside the bridge, just for a moment, a small girl's reflection walks along beside yours.",
           "\"Why won't you help me?\" she says. Then the wall is only ice."])
      sayc([cl(:shade, "She's not real. She's not real. Keep walking.")])
    end
  end

  # The coldlight walker: a frozen wanderer on the far ledge, with lamps for eyes.
  def scene_rift_walker_wakes
    return if flag?(:walker_down) || flag?(:walker_woke)
    set_flag(:walker_woke)
    say(["On the far ledge, two pinpoints of blue-white light ignite in the dark:",
         "the eyes of a gaunt, frozen corpse, standing where nobody should be standing.",
         "It raises an arm and lets out a long, hollow moan, and its eyes swing toward you like lanterns."])
  end

  def coldlight_walker(event_id = nil)
    return talk(:walker_after, event_id) if flag?(:walker_down)
    say(["A gaunt figure stands frozen on the ledge in the rags of a traveller's coat.",
         "Its eyes are two blazing lamps of cold light. When it turns them on you, the light is like a blow."], event_id)
    hurt_party(0.05)
    return if !pbConfirmMessage(_INTL("Fight the coldlight walker?"))
    return if !boss_battle(named_mon(:B200H427, 31, "Coldlight walker"))
    say(["The lamps in its eyes gutter out. The frozen wanderer folds slowly to its knees, and then to the ice.",
         "In its coat: a little pouch, and a note in a careful hand. \"If you find this, tell Bryn Shander I tried.\""])
    give(:FT_GEMSTONE, 3)
    pbReceiveItem(:REVIVE) rescue nil
    set_flag(:walker_down)
    $game_switches[SW_WALKER_DOWN] = true if $game_switches
    set_self_switch(event_id, "A")
  end

  #-----------------------------------------------------------------------------
  # The hidden sanctum: the codex
  #-----------------------------------------------------------------------------
  def codex_shelf(event_id = nil)
    return talk(:codex_shelf_after, event_id) if flag?(:druid_codex)
    talk(:codex_shelf, event_id)
    if !flag?(:ghost_blessing)
      return say(["(It doesn't feel like yours to take. Not with her lying there watching.)"])
    end
    say(["You open it carefully. Druidic script, and pictures: wolves under the moon, a reaper cradling a child, a heart of ice.",
         "The Order's rites. Its wardens' oaths. And, at the back, in a different hand, a ritual:",
         "how to wake the Heart again with a life that's freely given. Someone has written beside it: NEVER."])
    give_key(:FT_DRUIDCODEX)
    set_flag(:druid_codex)
    $game_switches[SW_CODEX_TAKEN] = true if $game_switches
    sayc([cl(:reptin, "Wardens' oaths. Mine's in here. I'd like to read it someday. Not today.")])
  end

  #-----------------------------------------------------------------------------
  # The hag's battles: what happens round by round
  #-----------------------------------------------------------------------------
  # $ft_battle_script = { kind:, round: 0 } is read at the start of each end of
  # round. Every effect is a message plus a small, fair change.
  def run_battle_script(battle)
    script = $ft_battle_script
    return if !script || !battle || battle.decision != 0
    round = battle.turnCount + 1
    case script[:kind]
    when :minions then minions_round(battle, round)
    when :thredra then thredra_round(battle, round, script)
    when :crown   then thredra_round(battle, round, script)
    end
  rescue StandardError => e
    log("battle script: #{e.message}")
  end

  def live_battlers(battle, foe)
    battle.battlers.compact.select { |b| !b.fainted? && (foe ? b.opposes?(0) : !b.opposes?(0)) }
  end

  # The ice troll knits itself back together unless fire stops it.
  def minions_round(battle, round)
    battle.pbDisplay(_INTL("KANAN: Warm blood! Warm blood!")) if round == 1
    if round == 2 && !$ft_battle_script[:reptin_in]
      $ft_battle_script[:reptin_in] = true
      kanan = live_battlers(battle, true).find { |b| b.name.to_s =~ /Kanan/ }
      if kanan
        battle.pbDisplay(_INTL(herald?(:reptin) ? "The wolf in you surges up the way it did on the tundra. You let it." :
                                                  "Reptin's eyes go yellow. The wolf in him surges up, and he lets it."))
        battle.pbDisplay(_INTL(herald?(:reptin) ? "You hit Kanan from the side, wolf against wolf, and your teeth find his ruff!" :
                                                  "He hits Kanan from the side, wolf against wolf, and his teeth find the winter wolf's ruff!"))
        kanan.pbReduceHP((kanan.totalhp / 6.0).ceil) if kanan.hp > 1
        set_flag(:reptin_fought_kanan)
      end
    end
    troll = live_battlers(battle, true).find { |b| b.name.to_s =~ /troll/i }
    return if !troll || troll.hp >= troll.totalhp
    burned = troll.tookDamage && Array(troll.lastAttacker).any? do |i|
      a = battle.battlers[i]
      a && a.lastMoveUsedType == :FIRE
    end
    if burned
      set_flag(:troll_burned)                  # (the after-fight line plays only if fire was used: notes 05 E18)
      battle.pbDisplay(_INTL("The fire sears the troll's wounds shut. Its flesh can't knit!"))
    else
      battle.pbDisplay(_INTL("The ice troll's torn flesh knits itself back together!"))
      battle.pbDisplay(_INTL("(\"Only flame can quell the ice-eater.\")")) if flag?(:tip_flame) && !$ft_battle_script[:tipped]
      $ft_battle_script[:tipped] = true
      troll.pbRecoverHP((troll.totalhp / 8.0).ceil)
    end
  end

  def thredra_round(battle, round, script)
    talisman = flag?(:locket_talisman)
    if round == 1
      battle.pbDisplay(_INTL("Thredra seats herself on her black staff and rises into the air, cackling!"))
      if talisman
        battle.pbDisplay(_INTL("The Order's locket throws a silver light up after her. She can't hide up there."))
      else
        live_battlers(battle, true).each { |b| hag_evade(b) }
      end
      return
    end
    case (round - 2) % 3
    when 0
      battle.pbDisplay(_INTL("The Heart of the Chasm throbs. A wave of grey cold rolls off it, draining the warmth out of everything!"))
      if talisman
        battle.pbDisplay(_INTL("The Order's locket flares silver. The wave breaks around your Pokémon like water round a stone."))
      else
        live_battlers(battle, false).each { |b| b.pbReduceHP((b.totalhp / 12.0).ceil) if b.hp > 1 }
      end
      if script[:kind] == :thredra && !flag?(:freed_cub_midfight)
        if talisman
          battle.pbDisplay(_INTL("Somewhere behind the pillars, the chained cub cries louder."))
        else
          battle.pbDisplay(_INTL("The grey wave washes over the chained cub too. It goes limp in its chains for a moment, then whimpers."))
          state[:cub_hurt] = (state[:cub_hurt] || 0) + 1
        end
      end
    when 1
      battle.pbDisplay(_INTL("Thredra flickers, and there are three of her, cackling in three voices!"))
      if talisman
        battle.pbDisplay(_INTL("The locket shines true. Two of the crones are only frost and light."))
      else
        live_battlers(battle, true).each { |b| hag_evade(b) }
      end
      target = live_battlers(battle, false).sample
      if target
        battle.pbDisplay(_INTL("{1} sees something dead reaching for it out of the Heart's red light!", target.pbThis))
        if talisman
          battle.pbDisplay(_INTL("The locket burns bright. It's only frost. {1} shakes it off!", target.pbThis))
        elsif target.pbCanConfuse?(nil, false)
          target.pbConfuse
        end
      end
    when 2
      battle.pbDisplay(_INTL("The Heart swings the other way: a warm pulse of life washes over everyone in the cavern!"))
      battle.battlers.compact.each { |b| b.pbRecoverHP((b.totalhp / 16.0).ceil) if !b.fainted? && b.hp < b.totalhp }
    end
    if !script[:offered] && live_battlers(battle, false).any? { |b| b.hp <= b.totalhp / 4 }
      script[:offered] = true
      battle.pbDisplay(_INTL("THREDRA: Still time to reconsider, dearies! Lay down your arms and I'll spare you. Let Granny finish!"))
    end
    hag_lunge_in_battle(battle) if script[:kind] == :thredra && hag_cornered?(battle)
  end

  # Her last Pokémon below a quarter: "If I can't have victory, at least I'll have
  # your despair." (CC 1046-1050, 1086-1092)
  def hag_cornered?(battle)
    return false if flag?(:lunge_done)
    foes = live_battlers(battle, true)
    left = (battle.pbParty(1).count { |pk| pk && pk.hp > 0 && !pk.egg? } rescue foes.size)
    left <= 1 && foes.size == 1 && foes[0].hp <= foes[0].totalhp / 4
  end

  def hag_lunge_in_battle(battle)
    set_flag(:lunge_done)
    set_flag(:lunge_in_battle)
    battle.pbDisplay(_INTL("THREDRA: No. No, no, no. If I can't have my victory..."))
    battle.pbDisplay(_INTL("She snatches a knife of black ice out of her rags and throws herself at the chained cub!"))
    battle.pbDisplay(_INTL("THREDRA: ...then I'll have your despair!"))
    c = battle.pbShowCommands(_INTL("She's going for the cub!"), hag_lunge_options.map(&:last), false) rescue 0
    lunge_outcome(hag_lunge_options[[c.to_i, 0].max][0]).each { |l| battle.pbDisplay(_INTL(l)) }
    if flag?(:broke_hag_staff)
      live_battlers(battle, true).each { |b| b.stages[:EVASION] = 0 rescue nil }
    elsif flag?(:shielded_cub) && !flag?(:locket_caught_wrist)
      lead = live_battlers(battle, false).first
      lead.pbReduceHP((lead.totalhp / 8.0).ceil) if lead && lead.hp > 1
    end
  end

  def hag_lunge_options
    [[:shield, _INTL("Throw yourself between them")], [:staff, _INTL("Smash her black staff")],
     [:chains, _INTL("Wrench the cub's chains free")], [:stay, _INTL("Stay where you are. It's another illusion.")]]
  end

  # What happens at the lunge. Nothing here kills the cub: the only way the cub
  # dies is the bargain itself, agreed to out loud.
  def lunge_outcome(pick)
    case pick
    when :shield
      set_flag(:shielded_cub)
      ["You get there first. The black knife opens your arm instead of the cub's throat.",
       "Your lead Pokémon roars and knocks her sprawling."]
    when :staff
      set_flag(:broke_hag_staff)
      [flag?(:tip_staff) ? "\"Destroy her black staff. It focuses her power.\" You remember, and you swing." :
                           "You go for the thing she's always holding. You swing.",
       "The black staff cracks across with a sound like a frozen lake breaking. Every frozen thing hanging from it shatters.",
       "Her knife-hand spasms. The blade goes skittering across the ice."]
    when :chains
      set_flag(:freed_cub_midfight)
      ["You throw your weight on the chains. They tear out of the pillar,",
       "and the cub drops into your arms and scrambles behind you, shaking.",
       "Her knife bites into the pillar where its throat was."]
    else
      lines = ["You hold still. It's a trick. It has to be a trick."]
      if flag?(:locket_talisman)
        lines += ["The locket against your chest burns like a coal. Not an illusion. Real!",
                  "You move without thinking and catch her wrist an inch from the cub."]
        set_flag(:shielded_cub); set_flag(:locket_caught_wrist)
      end
      if flag?(:ghost_blessing)
        lines += [flag?(:locket_caught_wrist) ? "She twists free, and the knife comes down again, and a hand of silver light closes over the blade:" :
                                               "It isn't. The knife comes down, and a hand of silver light closes over the blade:",
                  "a dwarf woman in dark green robes, there and gone. The knife shatters."]
        set_flag(:ghost_caught_knife)
      end
      if !flag?(:locket_caught_wrist) && !flag?(:ghost_caught_knife)
        rep = herald?(:reptin)
        lines += ["It isn't.",
                  rep ? "The wolf moves before you do. You're across the ice faster than anything should move," :
                        "Reptin's wolf moves before anyone else can. He's across the ice faster than anything should move,",
                  "and the black blade skids off a shoulder of grey fur instead of the cub's throat.",
                  "Not clean. The cub is cut, badly. But it's breathing."]
        set_flag(:cub_wounded); set_flag(:reptin_wolf_surged)
      end
      lines
    end
  end

  # Her flight and her illusions make her harder to hit: one stage, never more.
  def hag_evade(b)
    return if (b.stages[:EVASION] rescue 0).to_i >= 1
    b.pbRaiseStatStage(:EVASION, 1, b) if b.pbCanRaiseStatStage?(:EVASION, b)
  end

  # On Hard, the module's coven: a second hag waiting in the ice at the cavern's edge.
  def thredra_battle
    if ($Trainer.selected_difficulty rescue 1).to_i >= 2
      say(["A second cold laugh answers hers, from the edge of the cavern.",
           "What you took for an ice statue cracks open, and a hag in rotting green steps out of it, dripping.",
           "THREDRA: Sister! Just in time for the cutting.",
           "ETHEL: You promised me a share, Thredra. I've come to collect it."])
      set_flag(:coven_sister)
      return with_battle_script(:thredra) do
        pbDoubleTrainerBattle(:FT_HAG, "Thredra", 0, nil, :FT_HAG, "Ethel", 0, nil)
      end
    end
    with_battle_script(:thredra) { pbTrainerBattle(:FT_HAG, "Thredra", nil, false, 0) }
  end

  def with_battle_script(kind)
    $ft_battle_script = { kind: kind }
    yield
  ensure
    $ft_battle_script = nil
  end

  #-----------------------------------------------------------------------------
  # The cub, the knife, and the dark path
  #-----------------------------------------------------------------------------
  # After her own fight, before the mirror: "If I can't have victory, at least
  # I'll have your despair." Returns false if the cub died.
  def hag_lunge
    if !flag?(:lunge_done)
      set_flag(:lunge_done)
      say(["Thredra reels back against the dais, smoking, her Pokémon down.",
           "THREDRA: No. No, no, no. If I can't have my victory...",
           "She snatches a knife of black ice out of her rags and throws herself at the chained cub.",
           "THREDRA: ...then I'll have your despair!"])
      c = pbMessage(_INTL("She's going for the cub!"), hag_lunge_options.map(&:last), 0)
      say(lunge_outcome(hag_lunge_options[[c.to_i, 0].max][0]))
      hurt_party(0.1) if flag?(:shielded_cub) && !flag?(:locket_caught_wrist)
    end
    return true if flag?(:lunge_aftermath_said)
    set_flag(:lunge_aftermath_said)
    say([flag?(:cub_wounded) ? cl(:meat_meat, "(arriving at a dead run, pressing both hands over the cut) MINE. Meat Meat's baby now. Stay breathing, baby.") :
                               cl(:meat_meat, "(arriving at a dead run) MINE. Meat Meat's baby now. Back off, granny."),
         cl(:reptin, "(between her and the cub, every hair on end) Not one more step.")].compact)
    true
  end

  # The bargain kept, one way or the other. cause: :agreed (you said yes), or
  # :failed (you let the knife fall). Either way, the cub dies and the Heart drinks.
  def chasm_dark_ending(cause)
    set_flag(:hag_bargain_taken) if cause == :agreed
    set_flag(:cub_sacrificed)
    state[:bargain_memory] = (state[:bargain_memory] || 0) + 1
    rep = herald?(:reptin)
    if cause == :agreed
      say(["THREDRA: (softly, delighted) Heehee. Sensible wolves.",
           "She lays her hand on the cub's head, lovingly. One cut.",
           "The cub's cry stops."])
    else
      say(["The cub's cry stops."])
    end
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(200, 20, 30, 200), 30) rescue nil
    say(["The Heart drinks. Its red light goes up through the roof of the cavern in a column, throbbing,",
         "and you feel the whole world lurch, as if something enormous had cried out.",
         "Far above, through a mile of rock and ice, the aurora goes out.",
         "And somewhere over Icewind Dale, for the first time in two years, the sun comes up."])
    if rep
      say(["The wolf goes out of you like a breath, and doesn't come back.",
           "The moon is just the moon. The hunger is gone. You're only you.",
           "You're on your knees beside the little body, holding it, and the sound coming out of you is a howl,",
           "a long human howl with nothing wolf left in it at all."])
    else
      say(["Reptin is on his knees. His yellow eyes fade, flicker, and go human. The wolf is gone. Just like that.",
           "He gathers up the tiny body in both arms, and the sound he makes isn't a wolf's howl. It's worse."])
    end
    if cause == :agreed
      say(["THREDRA: (swelling, laughing, a winter wind in her hair) I always keep my end of a bargain!",
           "THREDRA: The Frostmaiden's winter is broken, just as I promised. And now it's mine. All of it. Mine.",
           "THREDRA: Not so fickle as Auril. Oh, no. I'll be very, very steady.",
           "THREDRA: Now, dearies. My reward is so much bigger than I am. Let's start with you."])
      won = with_battle_script(:crown) { pbTrainerBattle(:FT_WINTERCROWN, "Thredra", nil, false, 0, true) }
      if !won
        chasm_witch_queen_ending
        return
      end
      say(["Thredra, Winter-Crowned, staggers, and the Heart's light turns on her.",
           "It pours into her and through her, more than she can hold, and she shrieks,",
           "and comes apart into snow."])
    else
      say(["Thredra, beaten and bloody, laughs and laughs as the light pours into her.",
           "Then it's too much. The Heart's power backlashes through her. She shrieks, and comes apart into snow."])
    end
    say(["Ten-Towns will rejoice. The Rime is broken. They'll call you saviours. They'll sing about you.",
         "Every one of you will carry this for the rest of your days.",
         "\"Life for death. Death for life.\" You'll hear it in your sleep."])
    sayc([cl(:alberica, "(very quietly) I'm not writing this one down. Nobody is ever writing this one down."),
          cl(:shade, "...We could have said no."),
          cl(:alerion, "We could have.")])
    say(["That night, a single black feather of a snowy owl drifts onto the ledge beside you, coated in rime.",
         "The Frostmaiden has seen. The Frostmaiden will remember."])
    give_key(:FT_OWLFEATHER)
    chasm_wheel_turns_back
  end

  # Lose to the Winter-Crowned hag: the module's witch-queen ending.
  def chasm_witch_queen_ending
    set_flag(:witch_queen_ending)
    say(["You fall. The others fall around you.",
         "Thredra sits down on her dais with the Heart in her lap, humming to it.",
         "Outside, the sun rises over Icewind Dale. For a little while, it's warm.",
         "Then it isn't. The famine comes after, and the long night after that,",
         "and every year the Witch-Queen of the North takes a little more, and calls it a gift.",
         "The Order of Life and Death is gone for good. Nobody is left who remembers what it was for."])
    chasm_wheel_turns_back
  end

  # The wheel won't stop here. Back to the start, as in the Still Keeper's loop.
  def chasm_wheel_turns_back
    pbBGMFade(2.0) rescue nil
    say(["In the dark behind your eyes, an old dwarf woman in dark green robes shakes her head.",
         "GHOST: No. That isn't how it goes, dear. That's never how it goes.",
         "GHOST: Time is a wheel. Go round again. Find the third way.",
         "GHOST: You'll remember a little. Use it."])
    pbMessage(_INTL("THE CRONE'S BARGAIN")) rescue nil
    if respond_to?(:start_loop)
      start_loop
    else
      log("start_loop missing: the bargain ending can't turn the wheel")
    end
  end

  # A loss to the hag in her own lair: the witch-queen ending, as a nightmare.
  def chasm_loss_nightmare
    return if !state[:chasm_nightmare]
    state[:chasm_nightmare] = nil
    say(["You dream of the Heart of the Chasm.",
         "The hag sits on her dais, cackling, the Heart in her lap. Your own bodies lie frozen at her feet.",
         "The sun rises over a Dale that belongs to her.",
         flag?(:camp_disturbed) ? "You wake by the warm fissure, gasping. It hasn't happened. Not yet." :
                                     "You wake with a gasp, a long way from the chasm. It hasn't happened. Not yet."])
  end

  #-----------------------------------------------------------------------------
  # After the third way: the cub, the warden, the Heart, the spoils, the wolves
  #-----------------------------------------------------------------------------
  def chasm_cub_and_aftermath
    mother_alive = !flag?(:yeti_mother_dead)
    if flag?(:freed_cub_midfight)
      say(["The cub has been hiding behind you since you tore it loose. It peeks out now, shaking."])
    elsif flag?(:yeti_calmed)
      say(["The mother yeti breaks the cub's chains with her hands."])
    else
      say(["The cub's chains snap in the flood of light."])
    end
    if flag?(:cub_wounded)
      say(["The cut along the cub's neck has stopped bleeding. Meat Meat has bound it with a strip of her own scarf.",
           "It'll scar. It'll live."])
    elsif (state[:cub_hurt] || 0) > 0
      say(["The cub is shivering from the Heart's grey cold, frost still in its fur. It'll mend."])
    end
    if mother_alive && !flag?(:yeti_calmed)
      say(["Down the tunnel from the feast hall comes the mother, limping, roaring, and the cub runs to her."])
    end
    if mother_alive
      say(["Mother and cub, nose to nose. Then the cub looks back at you. Then it comes to you, and presses its head against your leg."])
    else
      say(["It looks round the cavern for someone who isn't coming. Then it creeps to you,",
           "presses its furry head against your leg, and makes a small, sad, cooing sound for its lost parents."])
      sayc([cl(:reptin, "(crouching, very gently) I know. I know. I'm sorry."),
            cl(:meat_meat, "Meat Meat has no mama either for a long time. It gets better. Slowly. Meat Meat promises.")])
    end
    if pbConfirmMessage(_INTL("Take Yetot with you?"))
      cub = Pokemon.new(:YETOT, 25)
      cub.calc_stats
      # a wounded cub comes with you scarred, and slower to trust anything with a knife
      cub.hp = [(cub.totalhp / 2.0).ceil, 1].max if flag?(:cub_wounded)
      set_flag(:got_yeti_cub) if pbAddPokemon(cub)
      set_flag(:got_yetot) if flag?(:got_yeti_cub)
    elsif mother_alive
      say(["The cub stays with its mother. She lifts it in one great arm and turns away, home, toward the peaks."])
    else
      say(["#{reptin_name == 'you' ? 'You set' : 'Reptin sets'} the cub down by the warm fissure and howls, once, low.",
           "Far up at the chasm mouth, wolves answer. They'll come for it. The wardens look after their own."])
    end
    set_flag(:cub_home)
    # the warden: the Heart knows its wolf
    say(["The Heart has gone quiet: pale now, faintly warm. Its light turns, slowly, toward #{reptin_name}.",
         herald?(:reptin) ? "The wolf in you lies down. Not gone. Still there, and still yours. But it's stopped pulling at the chain." :
                            "Reptin breathes out like he's been holding that breath for a year. The wolf in him has lain down: still there, still his, no longer pulling at the chain.",
         herald?(:reptin) ? "(A warden's bond. The rage was the curse. The rest of it is you.)" :
                            "REPTIN: (wondering) It's still there. It's just... quiet. It knows me now."])
    set_flag(:reptin_wolf_calm)
    if flag?(:ghost_blessing)
      say([herald?(:reptin) ? "You turn toward the tunnel to the sanctum, where she lies, and say a few words." :
                              "Reptin turns toward the tunnel to the sanctum, where she lies, and says a few words."])
      speak(:reptin, "Rest, warden. We kept it. Your wolves will keep it after us. I'll keep it, after them.",
                     "...Rest, warden. We kept it.")
      set_flag(:warden_honoured)
    end
    c = pbMessage(_INTL("The Heart pulses, slow and warm."), [_INTL("Leave it be."), _INTL("Break it, so nobody ever uses it again.")], 0)
    if c == 1
      say(["You raise your hand over it.",
           "And from nowhere, a voice in your head, an old dwarf woman's, very tired:",
           "\"Leave it. It must stay here, watched by its wardens, until the time for balance to shift.",
           "If it's destroyed, the energies will be catastrophic.\"",
           "You lower your hand."])
    end
    speak(:reptin, "Somebody has to watch it. Whatever happens next, I'll come back for it. I swear.",
                   "...I'll come back for it.")
    set_flag(:reptin_warden_vow)
    chasm_spoils
    say(["Far above, up at the chasm mouth, wolves are howling. Not hungry. Watchful.",
         herald?(:reptin) ? "You tip your head back and answer them. (Keep the watch till I'm back.)" :
                            "Reptin tips his head back and answers them, once. REPTIN: (quietly) Keep the watch till I'm back."])
  end

  # The loot, in the one quiet moment before the floor tips: the staff and the
  # pelt as their own beats, the rest in one box (notes 05 E8).
  def chasm_spoils
    if flag?(:broke_hag_staff) || flag?(:thredra_beaten)
      say(["The two halves of the hag's black staff lie on the ice, still crackling faintly. You take them."])
      give(:FT_GRAYSTAFF)
    end
    if flag?(:minions_down)
      say(["The hank of white pelt Kanan left behind is thick and warm. It would make a fine cloak against the cold."])
      give(:FT_WOLFPELT)
    end
    say(["In her rags and her cauldron: opals, a black ice ring, a counterspell. You take it all."])
    quiet_add = lambda do |item, qty|
      ok = ($PokemonBag.pbStoreItem(item, qty) rescue false)
      ok = ($bag.add(item, qty) rescue false) if !ok
      give(item, qty) if !ok
    end
    [[:FT_OPAL, 3], [:FT_BLACKICERING, 1], [:GUARDSPEC, 1], [:ICEHEAL, 1], [:FULLRESTORE, 1]].each { |it, q| quiet_add.(it, q) }
    pbMessage(_INTL("\\me[Item get]You put the hag's things in your bag.")) rescue nil
    say(["A sliver of red ice skitters to your feet. It beats, once, against your palm."])
    give_key(:FT_HEARTSHARD)
    set_flag(:heart_shard)
  end

  # SC 5.10, the first moments of the fall: what the chasm leaves behind, in
  # order, before the panels run on to Rootspire (notes 05 E31).
  def chasm_falling_glimpses
    say(["The chasm mouth at dawn. In a crack in the frost, a single wildflower.",
         "Wolves on the ridge above it, howling at nothing. Not hungry. Watchful.",
         flag?(:order_wardens) ? "A ring of Reghed tents at the chasm mouth, and a post carved with a wolf and a scythe." : nil,
         "Dougan's Hole. Durmoot lifts a cup: \"To the ones who went down.\" A pause. \"...Don't tell.\"",
         "In Bryn Shander a bard sings \"Glimmer in the Chasm\": a small light, and an old spirit."].compact)
    sayc([cl(:shade, "(somewhere in the fall) ...Glimmer. That name again.")])
    say(["The woman in dark green, and beside her a small light, like a lantern. They smile at you.",
         "\"Thank you,\" they whisper, like wind chimes. \"Balance is restored... for now.\""])
  end

  # Landing: two things in your pack that weren't there before.
  def chasm_keepsakes
    # Owner's call (2026-11-05): the outsider is unseen until a choice of their
    # own; the last mirror is that choice, and then Auril marks them.
    say(["As the light slows, something cold settles on your collar.",
         "A single black feather from a snowy owl, coated in rime."])
    if outsider?
      say([flag?(:tried_to_leave) ? "You reached for the way home, and the glass broke in your hands." :
                                    "You chose this side of the glass.",
           "Far to the north, something felt you choose. Until now she couldn't see you.",
           "Now she can. The Frostmaiden has marked you."])
    else
      say(["The Frostmaiden has seen what you did. She has marked you."])
    end
    give_key(:FT_OWLFEATHER)
    say(["And in your pack, a small carving that wasn't there before: a wolf and a bloom, twined together, carved from ancient ice.",
         "Nobody saw who left it. It's warm, like the locket was. Like she was."])
    give_key(:FT_WOLFBLOOM)
  end

  # SC 4.09: at the Twenty Stones, the hag makes her offer.
  def hag_bargain_offer(event_id = nil)
    set_flag(:hag_bargain_offered)
    rep = herald?(:reptin)
    # (context 04 M4-6: the curse confirms the tundra's bite, it doesn't announce it)
    say(["THREDRA: This winter. Auril's Rime. Two years of night, and children drawn by lot.",
         "THREDRA: Granny knows a place where life and death can be traded, and come out even.",
         rep ? "THREDRA: And you, poor bitten thing. Wait for the full moon. Then ask what bit you." :
               "THREDRA: And your poor bitten friend. Wait for the full moon. Then ask what bit him.",
         rep ? "(She's looking right at you. The bite on your hand throbs.)" : "Reptin's hand closes over the bite on his hand.",
         "THREDRA: Do a little task for Granny, and I'll end the winter.",
         rep ? "THREDRA: And I'll take the wolf out of you. Root and all." :
               "THREDRA: And I'll take the wolf out of him. Root and all."], event_id)
    c = pbMessage(_INTL("The hag waits for your answer."), [_INTL("\"What's the task?\""), _INTL("\"No deals.\"")], 1)
    if c == 0
      set_flag(:asked_hag_task)
      say(["THREDRA: Oh, a little thing. Come to my home in the chasm, south of here. Bring your wolf.",
           "THREDRA: There's a door down there only a wolf can open, and a thing I need fetched. Heehee. You'll see."], event_id)
    else
      say(["THREDRA: Oh, you'll come anyway. They always come. Bring the wolf."], event_id)
    end
    speak(:reptin, "(quietly) ...She can do that? Take it out of me?", "...Can she?")
    set_flag(:reptin_tempted)
    sayc([cl(:alberica, "Sugar, she's a hag. They lie. It's the only thing they do for free."),
          cl(:alerion, "Everything she offers has a hook in it. Find the hook before you bite."),
          journey? ? cl(:shade, "(to you) Whatever she's selling, she's selling it twice.") : nil])
  end

  #-----------------------------------------------------------------------------
  # Keepsakes you can read
  #-----------------------------------------------------------------------------
  def read_glimmer_journal
    pbMessage(_INTL("Most of the pages are ruined with blood. A few lines are left."))
    pbMessage(_INTL("\"...voices in the wind. Something about a treasure of life beyond death, hidden in the chasm...\""))
    pbMessage(_INTL("\"...met an old woman on the trail. She called herself Granny Thredra. She knew things about me... offered a deal.\""))
    pbMessage(_INTL("\"I don't trust her, but I'm desperate to save Alberica... Tomorrow, I venture into the chasm.\""))
    pbMessage(_INTL("\"The voices - children laughing? - echo at night. I must keep my wits.\""))
    pbMessage(_INTL("It's signed: Glimmer."))
    if flag?(:reversal)
      pbMessage(_INTL("At the bottom of the last page, a line you couldn't read before has come up out of the stains:"))
      pbMessage(_INTL("\"Balance must be kept. Spare the innocent.\""))
    end
  end

  def read_druid_codex
    pbMessage(_INTL("THE ORDER OF LIFE AND DEATH. Druidic script, very old, very small."))
    pbMessage(_INTL("\"The Heart drinks life to stave off death. It is a last resort. Use it never, or almost never.\""))
    pbMessage(_INTL("\"The Children of the Wolf keep the watch. Their gift is long life and great strength; its price is the moon.\""))
    pbMessage(_INTL("\"Only a wolf bound by honour can stand beside the Heart and not be tempted by it.\""))
    pbMessage(_INTL("At the back, the ritual to wake the Heart with a life freely given. Beside it, in a different hand: NEVER."))
  end

  def read_wolfbloom
    pbMessage(_INTL("A wolf and a flower, carved round each other out of ice older than the Dale. It's warm in your hand."))
    pbMessage(_INTL("Nobody saw who left it. It's warm, like the locket. A wolf and a bloom: the Order's sign."))
  end

  def read_owl_feather
    pbMessage(_INTL("A black feather from a snowy owl, coated in rime that won't thaw, even by a fire."))
    pbMessage(_INTL(outsider? ? "It caught in your collar the moment you chose. The Frostmaiden has marked you." :
                                "It drifted down out of nowhere and caught in your collar. The Frostmaiden has marked you."))
  end

  def read_heart_shard
    pbMessage(_INTL("Crimson ice, in a stoppered vial. It doesn't melt. It beats, very faintly, once a minute."))
    pbMessage(_INTL("When you hold it, you dream of both the living and the dead, standing in a ring, holding hands."))
  end

  def locket_description
    if flag?(:ghost_blessing)
      "Half sun, half moon. The portrait of Alberica, older, now smiles, at peace. Use it once a day to bless your team (heals 1/4 HP and cures status)."
    else
      "Half sun, half moon. A portrait of Alberica, older. She's never been here."
    end
  end

  def use_locket
    if !flag?(:ghost_blessing)
      pbMessage(_INTL("A stern older woman with Alberica's face looks back at you. Nothing happens."))
      return 1
    end
    today = (Time.now.year * 1000 + Time.now.yday)
    if state[:locket_day] == today
      pbMessage(_INTL("The locket is quiet. Its blessing will come back tomorrow."))
      return 1
    end
    state[:locket_day] = today
    pbMessage(_INTL("You open the locket. Inside, Alberica's older face smiles at you, at peace."))
    $Trainer.party.each do |pk|
      next if pk.egg? || pk.fainted?
      pk.hp = [pk.hp + (pk.totalhp / 4.0).ceil, pk.totalhp].min
      pk.heal_status
    end
    pbMessage(_INTL("A silver warmth settles over your Pokémon. They're blessed!"))
    1
  rescue StandardError => e
    log("use_locket: #{e.message}")
    0
  end

  def patch_w1_items
    lk = GameData::Item::DATA[:FT_ORDERLOCKET]
    if lk
      lk.define_singleton_method(:description) { FrostThaw.locket_description }
      lk.instance_variable_set(:@field_use, 2)
    end
  end

  #-----------------------------------------------------------------------------
  # The Cold-Hearted Killer: Hlin Trollbane, Torg's, and Sephek Kaltro
  #-----------------------------------------------------------------------------
  def hlin(event_id = nil)
    if flag?(:hlin_paid)
      return say(["HLIN: (tamping her pipe) Murders stopped. My trust wasn't misplaced. Drink's on me, if you're buying."], event_id)
    end
    if flag?(:hlin_hired) && flag?(:sephek_defeated)
      say(["HLIN: You're back. And the ice-dagger killer?"], event_id)
      say([flag?(:sephek_origin_known) ? "You tell her: a sailor, drowned off Auril's island, and something cold that climbed into him and stayed." :
                                         "You tell her about the Moon Temple, and the ice."])
      say(["HLIN: (a long breath of smoke) Not dead. Frozen. Well. He won't be killing anyone from in there.",
           "HLIN: The murders stop, I'll know you did right by me. Here. A hundred gold. I've more than I need."])
      give_money(5000, "Hlin counts out a hundred gold pieces.")
      if flag?(:found_torgs_corpse) && !flag?(:torrga_beaten)
        say(["HLIN: And the half-elf in Torrga's sack? Leave Torrga to me. I've a few old friends in Luskan she won't enjoy meeting."])
      elsif flag?(:torrga_beaten)
        say(["HLIN: You took Torrga down too? (She laughs, and it turns into a cough.) Retirement's going to be very boring."])
      end
      set_flag(:hlin_paid)
      $game_switches[SW_HLIN_PAID] = true if $game_switches
      sayc([cl(:shade, "She paid. A Ten-Towner, paying what she said she would. I need to sit down.")])
      return
    end
    # First met after the Moon Temple: she's heard already, and pays for work you did without her.
    if !flag?(:hlin_hired) && flag?(:sephek_defeated)
      say(["An elderly shield dwarf sits apart from everyone else, a nasty scar across her nose, smoking a long pipe.",
           "HLIN: Sit. Hlin Trollbane. Retired. Bounty hunter. You'd be the lot who went up to the Moon Temple.",
           "HLIN: Three murders this past month, each with a dagger of ice through the heart. I'd followed Torg's a tenday.",
           "HLIN: Their bodyguard. Sephek Kaltro. I was going to hire somebody to deal with him. Seems I'm late."], event_id)
      set_flag(:hlin_hired)
      return hlin(event_id)
    end
    if flag?(:hlin_hired)
      return say(["HLIN: Torg's is camped by the clearing, past the fisher's house. Sephek's the one in his shirtsleeves.",
                  "HLIN: Get him alone if you can. He's no trouble to anyone while Torrga's open for business."], event_id)
    end
    say(["An elderly shield dwarf sits apart from everyone else, a nasty scar across her nose, smoking a long pipe.",
         "She's been watching you since you walked in. She takes the pipe out of her mouth.",
         "HLIN: Sit. You've the look of people who don't scare. I'm Hlin Trollbane. Retired. Bounty hunter.",
         "HLIN: Three murders this past month. A halfling trapper in Easthaven. A shipbuilder in Targos.",
         "HLIN: And, three days back, a dwarf glassblower in Bryn Shander. Each found with a dagger of ice through the heart.",
         "HLIN: Nobody else'll look into it. Not even the Council of Speakers. So I did."], event_id)
    say(["HLIN: Sephek Kaltro. He works for a little travelling outfit called Torg's. Torrga Icevein's company. Shady dwarf.",
         "HLIN: He's her bodyguard. He's charming, makes friends easy. Good with a blade, I'd guess.",
         "HLIN: His victims all come from the three towns that sacrifice people to the Frostmaiden on new-moon nights.",
         "HLIN: Maybe they found a way to keep their names out of the drawing. Maybe he found out.",
         flag?(:kip_list) ? as(:alberica, "Kip's list. Three names on Bryn Shander's board that never got drawn.") : nil,
         flag?(:kip_list) ? "HLIN: (a slow nod) The glassblower's was one. Paid a clerk, the way I hear it." : nil,
         "HLIN: I followed Torg's for a tenday. What struck me: no coat on him. No gloves. Like the cold can't touch him.",
         "HLIN: Kiss of the Frostmaiden, indeed. And now Torg's is camped here. In Lonelywood. Right by the clearing."].compact)
    say(["HLIN: I'll pay you a hundred gold to take Sephek Kaltro, make sure of his guilt, and deal with him.",
         "HLIN: Quietly, if you can. Without the authorities. Come back to me when it's done."])
    c = pbMessage(_INTL("Take Hlin's job?"), [_INTL("\"We'll do it.\""), _INTL("\"We were going after him anyway.\"")], 0)
    say([c == 0 ? "HLIN: Good. Mind his hands. He makes knives out of nothing." :
                  "HLIN: Then I'll pay you for something you were doing anyway. Best kind of job. Mind his hands."])
    set_flag(:hlin_hired)
    sayc([cl(:shimmer, "(very quiet) He's here for me. Isn't he."),
          cl(:shade, "(a hand on her shoulder) He's here for a fight. He'll get one.")])
  end

  def sephek_torgs(event_id = nil)
    if flag?(:met_sephek_torgs)
      return say(["SEPHEK: (not looking up from the snow) Soon. She's very patient, but she isn't endless."], event_id)
    end
    set_flag(:met_sephek_torgs)
    say(["A man in his thirties leans on Torrga's sled in a stylish vest and nothing warmer.",
         "No coat, no hat, no gloves. Olive skin, dark hair in a tail. Snow lands on his shoulders and doesn't melt.",
         "His eyes are as blue as a frozen lake.",
         "SEPHEK: (smiling, easy) Travellers! Good. It gets so quiet. Buying, or just looking at me?"], event_id)
    if with_or_is?(:shimmer)
      say(["His eyes go past you to Shimmer, and stay there.",
           "SEPHEK: (gently) There you are."])
    end
    c = pbMessage(_INTL("What do you ask him?"),
                  [_INTL("\"Aren't you cold?\""), _INTL("\"The ice-dagger murders.\""), _INTL("Say nothing.")], 2)
    case c
    when 0
      say(["SEPHEK: I was born on Midwinter. The Frostmaiden's blessing keeps the cold off me. Lucky, in a place like this."])
    when 1
      say(["He doesn't even pretend.",
           "SEPHEK: They cheated her. A clerk paid, a name rubbed off a board, and somebody else's child walks out into the snow instead.",
           "SEPHEK: She is owed. I collect. That's all."])
      set_flag(:sephek_confessed)
    else
      say(["SEPHEK: (still smiling) A careful one. Good."])
    end
    sayc([cl(:shade, "(hand on a knife) Then let's do this now."),
          "SEPHEK: Here? With the Speaker's little ones playing two roads over? No. I'm not a monster.",
          with_or_is?(:shimmer) ? "SEPHEK: (to Shimmer, softly) Before the next moon. Come to me, or I pick someone else." : nil,
          with_or_is?(:shimmer) ? "SEPHEK: You always did come, in the end." : nil,
          "Frost swirls up round him like a breath, and he's standing on the far side of the sled, ten paces off.",
          cl(:alerion, "Misty step. He's not running. He's showing us he can."),
          cl(:shimmer, "...I know.")])
    if !flag?(:shimmer_taken)
      sayc([cl(:shade, "He won't fight with children in the street. Neither will we. Not tonight.")])
      state[:goal] = "Speaker Huddle's house, the green roof. Somewhere warm, with him out there."
    end
  end

  def torgs_sack(event_id = nil)
    if flag?(:found_torgs_corpse)
      return say(["The big sack is tied shut again. You know what's in it."], event_id)
    end
    say(["One of the larger sacks on the sled is heavier than it should be, and it's frozen stiff.",
         "You loosen the cord. Inside: a half-elf man in his thirties, frozen solid, a stab wound in his chest.",
         "A bounty poster from Luskan is folded into his collar. His face is on it. A hundred and twenty-five gold."], event_id)
    set_flag(:found_torgs_corpse)
    sayc([cl(:reptin, "He came all the way up here to disappear. And they found him anyway."),
          cl(:alerion, "Torrga, and her bodyguard. Sephek held him; she stabbed him. Look at his wrists."),
          cl(:meat_meat, "Meat Meat does not like this shop.")])
  end

  def torrga(event_id = nil)
    if flag?(:torrga_beaten)
      return say(["TORRGA: (counting what's left of her stock) Get away from my sled."], event_id)
    end
    if !flag?(:met_torrga)
      set_flag(:met_torrga)
      say(["A shield dwarf in good furs presides over three dog-sleds of goods, canopies keeping the snow off.",
           "TORRGA: Torrga Icevein. Torg's is my company. Cut wood, flint, whale oil, blankets, wine, medicines.",
           "TORRGA: Prices are prices. Twice what you'd pay in Bryn Shander, and worth every copper, out here."], event_id)
    end
    if flag?(:sephek_defeated) && !flag?(:torrga_grudge_said)
      set_flag(:torrga_grudge_said)
      say(["TORRGA: (not looking up from her ledger) My bodyguard went up to the Moon Temple and didn't come back down.",
           "TORRGA: Frozen solid, they're saying. And here you are, warm as toast.",
           "TORRGA: I've done business in every town on these lakes for twenty years. They listen to me. Remember that."])
    end
    if flag?(:found_torgs_corpse) || flag?(:sephek_defeated)
      opts = [_INTL("Buy something"), _INTL("Confront her"), _INTL("Leave")]
      c = pbMessage(_INTL("Torrga waits."), opts, 2)
      return torgs_shop if c == 0
      return if c != 1
      lines = []
      lines << "You tell her what's in her sack." if flag?(:found_torgs_corpse)
      lines << "You tell her what her bodyguard did, and where he is now." if flag?(:sephek_defeated)
      say(lines + ["TORRGA: (very still) I sell things. What my people do after hours is their business.",
                   "TORRGA: And what's in my sacks is mine. Boys. Kill them.",
                   "Her four drivers drop the dogs' traces and come round the sleds."])
      # the drivers first, two by two, then Torrga and her lead driver
      won = pbDoubleTrainerBattle(:FT_TORGHAND, "Oska", 0, nil, :FT_TORGHAND, "Corran", 0, nil) rescue nil
      won = pbTrainerBattle(:FT_TORGHAND, "Oska", nil, false, 0) if won.nil?
      return if !won
      say(["Oska and Corran go down in the snow. Skeld looks at them, looks at you, and doesn't run."])
      won = pbTrainerBattle(:FT_TORGHAND, "Skeld", nil, false, 0)
      return if !won
      won = pbDoubleTrainerBattle(:FT_BANDITCAPTAIN, "Torrga", 0, nil, :FT_TORGHAND, "Brannig", 0, nil) rescue nil
      won = pbTrainerBattle(:FT_BANDITCAPTAIN, "Torrga", nil, false, 0) if won.nil?
      return if !won
      say(["TORRGA: (on her knees in the snow) Fine. FINE. Take it. Take the box.",
           "She drags a key on a thong over her head. Her little iron strongbox holds coins, and seven small gems."])
      give_money(4700, "Torrga's strongbox: ninety-two gold, seventy-six silver and a scatter of copper.")
      give(:FT_GEMSTONE, 7)
      say(["By morning Torg's has packed its sleds and gone south, fast, and without its sack."])
      say(["(Whatever she was telling the merchants about you, she won't be telling it any more.)"]) if flag?(:torrga_grudge)
      set_flag(:torrga_beaten)
      set_flag(:torrga_grudge, false)
      $game_switches[SW_TORRGA_GONE] = true if $game_switches
      return
    end
    torgs_shop
  end

  TORGS_STOCK = [:POTION, :SUPERPOTION, :ICEHEAL, :BURNHEAL, :ANTIDOTE, :REPEL, :ESCAPEROPE, :POKEBALL]

  def torgs_shop
    say(["TORRGA: Look all you like. Touch, you buy."])
    old = ($game_temp.mart_prices.dup rescue nil)
    TORGS_STOCK.each do |it|
      base = (GameData::Item.get(it).price rescue 0)
      $game_temp.mart_prices[it] = [base * 2, (base / 2)] rescue nil
    end
    pbPokemonMart(TORGS_STOCK)
  rescue StandardError => e
    log("torgs_shop: #{e.message}")
  ensure
    $game_temp.mart_prices = old if old && $game_temp
  end

  # At the Moon Temple, once Sephek is beaten: what he really is.
  def sephek_true_nature
    set_flag(:sephek_origin_known)
    # Two voices out of one mouth, tagged from the first box (context 03 M3-8)
    say(["His mouth keeps moving. The voice is younger now, and frightened.",
         "SEPHEK: ...I wasn't born at Midwinter. I was born in the water. The day I drowned.",
         "SEPHEK: A ship. Her island. We went down off the coast.",
         "Frost creeps up his arms as he talks. He doesn't seem to feel it.",
         "SEPHEK: I swam, and I was dying in the snow.",
         "SEPHEK: And something cold came and climbed into me, and ate what I was, and stayed.",
         "Then something older answers, out of the same mouth.",
         "SEPHEK: (the other voice) A druid of the old winter. Hers. I wear him. I cannot leave him.",
         "SEPHEK: (the other voice) If the vessel dies, so do I. So he does not die. So he waits."])
    sayc([cl(:reptin, "A winter druid. We druids tell stories about them, to scare the young."),
          cl(:shade, "I don't care how many of him there are.")])
  end

  # Lonelywood after the Moon Temple: the ice-dagger murders have stopped.
  # Shops whose keepers would rather not cross Torrga Icevein.
  TORRGA_FRIENDS = %i[lonelywood termalaine good_mead]

  def torrga_refuses?(key)
    flag?(:torrga_grudge) && !flag?(:torrga_beaten) && TORRGA_FRIENDS.include?(key)
  end

  def torrga_refusal(key, event_id = nil)
    say(["The shopkeeper looks at you, then out of the window, toward the Lonelywood road.",
         "SHOPKEEPER: ...I'm sorry. I can't sell to you. Torrga Icevein brings half my stock up the lakes.",
         "SHOPKEEPER: She says you killed her man. I don't care if you did. I care that she says so.",
         "SHOPKEEPER: Sort it out with her, and come back."], event_id)
    if !flag?(:torrga_grudge_felt)
      set_flag(:torrga_grudge_felt)
      sayc([cl(:shade, "She said they'd listen to her. They're listening."),
            cl(:alberica, "Then we'll go and have a word with Torrga, sweetheart. A long one.")])
    end
  end

  def apply_w1_switches
    return if !active? || !$game_switches
    # Torrga survives, and believes you slew her bodyguard: she leans on the merchants
    set_flag(:torrga_grudge) if flag?(:sephek_defeated) && !flag?(:torrga_beaten) && !flag?(:torrga_grudge)
    sync_switch(SW_TORRGA_GONE, flag?(:torrga_beaten))
    # Good Mead: the exposed thug waits in Olivessa's cooperage until the vote (045_MeadMustFlow)
    sync_switch(4006, flag?(:shandar_exposed) && !$game_switches[4079])
    sync_switch(SW_HLIN_PAID, flag?(:hlin_paid))
    sync_switch(SW_WALKER_DOWN, flag?(:walker_down))
    sync_switch(SW_MOTHER_DEAD, flag?(:yeti_mother_dead))
    sync_switch(SW_CODEX_TAKEN, flag?(:druid_codex))
    sync_switch(SW_RIFT_GNOLL, flag?(:rift_gnoll_laid))
  end
end

#-------------------------------------------------------------------------------
# Item hooks
#-------------------------------------------------------------------------------
module GameData
  class << self
    alias ft_w1_load_all load_all unless method_defined?(:ft_w1_load_all)
    def load_all
      ft_w1_load_all
      begin
        FrostThaw.patch_w1_items
      rescue StandardError => e
        FrostThaw.log("Act I keepsakes failed: #{e.message}")
      end
    end
  end
end

if defined?(ItemHandlers::UseFromBag)
  ItemHandlers::UseFromBag.add(:FT_ORDERLOCKET, proc { |item| FrostThaw.use_locket })
  ItemHandlers::UseFromBag.add(:FT_GLIMMERJOURNAL, proc { |item| FrostThaw.read_glimmer_journal; next 1 })
  ItemHandlers::UseFromBag.add(:FT_DRUIDCODEX, proc { |item| FrostThaw.read_druid_codex; next 1 })
  ItemHandlers::UseFromBag.add(:FT_WOLFBLOOM, proc { |item| FrostThaw.read_wolfbloom; next 1 })
  ItemHandlers::UseFromBag.add(:FT_OWLFEATHER, proc { |item| FrostThaw.read_owl_feather; next 1 })
  ItemHandlers::UseFromBag.add(:FT_HEARTSHARD, proc { |item| FrostThaw.read_heart_shard; next 1 })
end

if defined?(BattleHandlers::DamageCalcUserItem)
  BattleHandlers::DamageCalcUserItem.add(:FT_GRAYSTAFF,
    proc { |item, user, target, move, mults, baseDmg, type|
      mults[:base_damage_multiplier] *= 1.2 if type == :ICE
    }
  )
  BattleHandlers::DamageCalcUserItem.add(:FT_ORDERDAGGER,
    proc { |item, user, target, move, mults, baseDmg, type|
      mults[:final_damage_multiplier] *= 1.25 if target.pbHasType?(:GHOST) || target.pbHasType?(:FAIRY)
    }
  )
end
if defined?(BattleHandlers::DamageCalcTargetItem)
  BattleHandlers::DamageCalcTargetItem.add(:FT_WOLFPELT,
    proc { |item, user, target, move, mults, baseDmg, type|
      mults[:final_damage_multiplier] /= 2 if type == :ICE
    }
  )
end

#-------------------------------------------------------------------------------
# The hag's lair, round by round
#-------------------------------------------------------------------------------
if defined?(PokeBattle_Battle) && PokeBattle_Battle.method_defined?(:pbEndOfRoundPhase)
  class PokeBattle_Battle
    alias ft_w1_pbEndOfRoundPhase pbEndOfRoundPhase unless method_defined?(:ft_w1_pbEndOfRoundPhase)
    def pbEndOfRoundPhase
      FrostThaw.run_battle_script(self) if $ft_battle_script
      ft_w1_pbEndOfRoundPhase
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_w1_switches
  rescue StandardError => err
    FrostThaw.log("Act I build-out switches failed: #{err.message}")
  end
}
