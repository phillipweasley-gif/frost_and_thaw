#===============================================================================
# Frost & Thaw - "The White Moose" (Lonelywood; RotF pp. 79-84)
#
# A white moose is terrorising Lonelywood's loggers, and it's smarter than any
# moose should be: Ravisin, an evil frost druid, awakened it, and lights the
# full-moon symbol on an elven moon dial with a moonbeam so the moose can scry
# on hunters through the Mirror of the Full Moon. Ravisin blames Ten-Towners for
# her twin sister Vurnis's death, and keeps Vurnis's body in a sarcophagus.
#
#   Speaker Nimsy Huddle asks (cookies; 100 gold for the head, 125 if pressed;
#   Ramshackle, the closed inn, if you push further). The forest: an hour per
#   search for tracks, a d6 (only a 6 is the white moose), the Lonelywood Forest
#   Encounters table every three hours (banshee, brown bears, chwingas, fox and
#   hare, wolf pack). The elven tomb: E1 the statues (ten of them; topple all
#   ten and the misdirection ends), E2 the barrow door (opens from inside only),
#   E3 the gazebo brazier (twig, pinecone, feather, a severed hand, set alight),
#   E4 the sarcophagus and crystal pillars (Sahnar, the moon-elf mummy, who
#   smells of pumpkin spice), E5 the moon dial; under the hill, E6 the barrow
#   (the sleeping animals, the moose), E7 the Mirror of the Full Moon (seven
#   questions), E8/E9 the tombs of the half-moon (an elf's bow and cup; Ravisin,
#   her awakened berry bush, and Vurnis).
#===============================================================================
module FrostThaw
  SW_WM_TOMB_FOUND = 4068    # you've found the white moose's tracks: the way to the tomb is clear
  SW_WM_MOOSE_DEAD = 4069    # the awakened white moose is dead
  SW_WM_RAVISIN    = 4070    # Ravisin the frost druid is dealt with
  SW_WM_BARROW_OPEN = 4071   # the barrow door (E2) is open from inside
  SW_WM_HALF_OPEN  = 4072    # the tombs of the half-moon are open
  SW_WM_SAHNAR     = 4073    # Sahnar's sarcophagus is open
  SW_WM_AWAKENED   = 4074    # Ravisin lives on: newly awakened beasts harass the loggers
  SW_WM_RAMSHACKLE = 4075    # Ramshackle is yours

  MAPS.merge!(lonely_forest: 2129, elven_tomb: 2130, elven_barrow: 2131, ramshackle: 2137)
  MAP_NAMES.merge!(2129 => "Lonelywood Forest", 2130 => "The Elven Tomb", 2131 => "The Elven Barrow", 2137 => "Ramshackle")
  MAP_METADATA.merge!(
    2129 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Forest },
    2130 => { outdoor_map: true, announce_location: true, weather: [:Snow, 40], battle_environment: :Snow },
    2131 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2129 => :lonely_forest, 2130 => :elven_tomb, 2131 => :elven_tomb, 2137 => :lonelywood)
  RAMSHACKLE_REST = [2021, 15, 32, 2]

  ENCOUNTERS[2129] = { step_chances: { Land: 18 },
                       Land: [[25, :STANTLER, 16, 18], [20, :BUNEARY, 15, 17], [15, :VULPIX, 15, 17], [15, :HOOTHOOT, 15, 17],
                              [10, :TEDDIURSA, 15, 17], [10, :POOCHYENA, 15, 17], [5, :SNEASEL, 17, 18]] }

  RELIC_ITEMS.merge!(
    FT_TWIG: ["Twig", "Twigs", 8, 0, "A dry twig from the Lonelywood forest. One of four things the gazebo brazier wants.", 0, 0, 6],
    FT_PINECONE: ["Pinecone", "Pinecones", 8, 0, "A fat pinecone. The pillar by the sarcophagus has one carved on it.", 0, 0, 6],
    FT_GREYFEATHER: ["Owl Feather", "Owl Feathers", 8, 0, "A soft grey owl's feather, dropped in the snow.", 0, 0, 6],
    FT_SKELETALHAND: ["Skeletal Hand", "Skeletal Hands", 8, 0,
      "An old, old hand from the barrow's bones. It doesn't need to come from a living person, the pillar says. Thankfully.", 0, 0, 6],
    FT_MOOSEHEAD: ["White Moose's Head", "White Moose's Heads", 8, 0,
      "The head of the awakened white moose, antlers and all. Proof for Speaker Huddle.", 0, 0, 6],
    FT_RAMSHACKLEDEED: ["Ramshackle Deed", "Ramshackle Deeds", 8, 0,
      "The deed to Ramshackle, Lonelywood's closed inn. An investment property, Speaker Huddle says. To do with as you will.", 0, 0, 6],
    FT_ELVENBOW: ["Unstrung Elven Bow", "Unstrung Elven Bows", 8, 0,
      "A moon elf's bow from the first tomb of the half-moon. The string rotted away centuries ago. The wood didn't.", 0, 0, 6],
    FT_SILVERARROWHEAD: ["Silvered Arrowhead", "Silvered Arrowheads", 1, 500,
      "A silvered arrowhead from an elven tomb. Worth something to a fletcher, or a werewolf's enemy.", 0, 0, 0],
    FT_WINGEDFISHCUP: ["Winged-Fish Cup", "Winged-Fish Cups", 8, 0,
      "A wooden cup with a winged fish etched into the side. Somebody loved this cup.", 0, 0, 6]
  )

  TRAINER_TYPES.merge!(FT_FROSTDRUID: ["Frost Druid", :CHANNELER, 1, 120])
  TRAINER_INTROS.merge!(
    forest_hunter_brann: "HALVARD: You're after MY moose? Over my dead Pokémon.",
    forest_logger_tova:  "TOVA: Can't cut, can't haul, can't go home without wood. Might as well battle."
  )
  TRAINERS.merge!(
    forest_hunter_brann: [:FT_TRAPPER, "Halvard", [[:NOCTOWL, 18], [:B58H216, 18]], "Fine. You find it, then. I've been out here a month."],
    forest_logger_tova:  [:WORKER, "Tova", [[:MACHOP, 17], [:B185H216, 18]], "Strong arms, weak bench. Story of my life."]
  )
  TRAINER_INTROS[:ravisin] = "RAVISIN: My moose only returns the favour. So will I."
  TRAINERS[:ravisin] = [:FT_FROSTDRUID, "Ravisin", [[:SNORUNT, 19], [:B234H215, 20], [:FROSLASS, 21]],
                        "My beasts will avenge us!"]

  # The questions you can put to the Mirror of the Full Moon (seven, all told).
  MIRROR_QUESTIONS = [
    ["Where is the white moose now?", :moose],
    ["Who awakened it?", :ravisin],
    ["Whose body lies in the tomb with the druid?", :vurnis],
    ["Who is Sephek, really?", :sephek],
    ["Where does Auril live?", :auril],
    ["What did DeGrootz of Ramshackle really die of?", :degrootz],
    ["What's under the Spine of the World?", :spine],
    ["What is the cry for help in the psi crystal?", :psi],
    ["Will the summer ever come back?", :summer]
  ]

  TEXT.merge!(
    sign_lonely_forest: ["LONELYWOOD LOGGING CAMPS. Keep to the marked trail.", "(Someone has scratched underneath: WATCH FOR THE MOOSE.)"],
    lonely_forest_logger: [{ if: { flag: :white_moose_done }, lines: ["LOGGER: Back to cutting, thanks to you. Woods feel like woods again."] },
                           { if: { switch: SW_WM_AWAKENED }, lines: ["LOGGER: The moose is dead, but now there's a polar bear that TALKS.",
                                                                     "LOGGER: It knew my name. It said my name and then it laughed."] },
                           ["LOGGER: It waits for us. It knows where we'll be. Moose don't know where you'll be.",
                            "LOGGER: Hunters can't find it. It finds them.",
                            "LOGGER: Speaker Huddle's paying for that moose. Ask her."]],
    lonely_forest_hunter: [{ if: { flag: :white_moose_done }, lines: ["HUNTER: You got it? With what, a ballista? Huh. Drinks are on me."] },
                           ["HUNTER: White hide, white snow. It's like hunting a cloud with horns.",
                            "HUNTER: Tracks? Everywhere. Ordinary moose, mostly. The white one's tracks don't wander."]],
    lonely_forest_logpile: ["Logs stacked higher than a house, waiting for sledges that don't come.",
                            "The loggers won't stay out here past noon."],
    tomb_gazebo: ["A delicately carved marble gazebo. Its polished floor is swept clean by the wind."],
    tomb_e1: ["A white marble statue of a slender, robed figure on a seven-foot pillar, facing north.",
              "The wind has worn the face away, but the pointed ears say elf."],
    tomb_e2: ["Embedded in the hillside: a stone door with no visible handles or hinges. Snug. Airtight.",
              "It won't budge from out here. Whatever opens it is on the other side."],
    tomb_pillars: ["Five pale blue crystal pillars stand in a half-circle around the sarcophagus.",
                   "A carving tops each, north to south: a twig, a pinecone, a flame, a feather, a hand."],
    tomb_lookout: ["From up in the trees you can see the whole moon dial, and the dark hole under the hill."],
    barrow_animals: ["Foxes, hares, goats, owls, wolf pups and young bears, asleep together among the bones.",
                     "Nobody here eats anybody. Something has told them not to."],
    barrow_animals_after: ["The animals have scattered into the woods.",
                           "The bones are all that's left, and the smell of them."],
    barrow_lever: ["A stone lever set into the wall beside the south door."],
    tomb_e8_closed: ["A stone door engraved with a white half-moon, its rounded edge to the right. Locked.",
                     "There's no keyhole. Only the half-moon, waiting for light."],
    tomb_e9_closed: ["A stone door engraved with a white half-moon, its rounded edge to the left. Locked.",
                     "Behind it, faintly: someone humming. And something rustling, like leaves."],
    tomb_e8_light: ["A beam of light shines down from the top of the dome onto the sarcophagus.",
                    "A minor magic, centuries old."],
    awakened_shrub: [{ if: { flag: :shrub_talked }, lines: ["SHRUB: More berries? Take. Take. Just no fire. Please, no fire."] },
                     ["The berry bush trembles."]],
    vurnis_after: ["The sarcophagus lid lies askew. Vurnis lies under it, quiet.",
                   "The pouch is gone; the smell isn't."],
    ramshackle_inside: ["Lumber stacked to the rafters, chairs on tables, a long bar furred with dust.",
                        "The beam over the common room is the one. Nobody's taken the hook out of it."],
    ramshackle_notice: ["A notice nailed to the bar, in a cramped hand: \"Closed. - D.\"",
                        "Under it, in a different hand, in pencil: \"He didn't do it himself.\""],
    sahnar_after: ["The sarcophagus is empty and smells, inexplicably, of pumpkin spice."],
    tomb_bones: ["Bones, mostly animal. A few aren't."],
    forest_hunter_brann_after: ["HALVARD: A month. Not one clean look at it. It's like it KNOWS where I'll be.",
                                "HALVARD: It goes east, into the old trees. Look for tracks that don't wander."],
    forest_logger_tova_after: [{ if: { flag: :white_moose_done }, lines: ["TOVA: Back to work. Thanks. I mean it."] },
                               ["TOVA: If you find that moose, tell it I said something rude."]]
  )

  PARTY_CHAT[:alberica].merge!(lonely_forest: ["Every tree in this forest looks like every other tree.",
                                               "I keep counting them. It helps."],
                               elven_tomb: ["Elves always build somewhere pretty to be dead in. I respect that. I do."])
  PARTY_CHAT[:reptin].merge!(lonely_forest: ["A moose that hunts the hunters. That's not nature.",
                                             "That's somebody's opinion, with antlers."],
                             elven_tomb: ["Old magic here. Polite magic. It keeps asking us to leave."])
  PARTY_CHAT[:alerion].merge!(lonely_forest: ["Hunters' marks on the trees. Old ones.",
                                              "Some of them never came back to finish the job."],
                              elven_tomb: ["Elven. Very old. The moon dial still keeps time.",
                                           "Even down here, the moon matters."])
  PARTY_CHAT[:shade].merge!(lonely_forest: ["Tracks I can read. It's everything else."],
                            elven_tomb: ["Somebody lives under this hill.",
                                         "Bedroll, herbs, a fire's leavings. And they don't want visitors."])
  PARTY_CHAT[:meat_meat].merge!(lonely_forest: ["Meat Meat smells moose. Many moose. One moose smells... clever.",
                                                "Meat Meat does not like clever moose."],
                                elven_tomb: ["Statues have ears like Meat Meat's friend's ears.",
                                             "Pointy. They are watching the wrong way."]) if PARTY_CHAT[:meat_meat]

  module_function

  #-----------------------------------------------------------------------------
  # Speaker Huddle's offer. (Her attic, her cookies: 015's nimsy runs the rest.)
  #-----------------------------------------------------------------------------
  class << self
    alias_method :nimsy_without_moose, :nimsy if method_defined?(:nimsy) && !method_defined?(:nimsy_without_moose)
  end

  def self.nimsy(event_id = nil)
    settled = flag?(:rested_lonelywood)   # (not on your first night: that night belongs to Shimmer)
    # the moose first, then her attic (notes 14 E9: not tacked on after the rest)
    white_moose_nimsy(event_id) if settled && flag?(:met_nimsy)
    nimsy_without_moose(event_id)
  end

  def white_moose_nimsy(event_id = nil)
    return white_moose_reward(event_id) if $game_switches[SW_WM_MOOSE_DEAD] && !flag?(:white_moose_done)
    return if flag?(:white_moose_taken) || flag?(:white_moose_done)
    if flag?(:white_moose_refused)
      return if !pbConfirmMessage(_INTL("Ask Speaker Huddle about the white moose after all?"))
    else
      # (the morning after her attic lost Shimmer: grief first, notes 14 E9)
      # Purpose: a Speaker who just lost a guest from her attic still has a town
      # to keep alive; she asks, gently, and the party decides whether it can.
      say([flag?(:shimmer_taken) ? "NIMSY: (the plate, untouched since last night) I won't ask how you slept." :
                                   "NIMSY: Before you go. (She sets the cookie plate down, and doesn't offer it.)",
           "NIMSY: A white moose is killing our loggers. It can wait. It's waited this long.",
           "NIMSY: Our hunters can't get near it. When you're ready... will you help?"], event_id)
    end
    c = pbMessage(_INTL("What do you say?"), [_INTL("\"We'll find your moose.\""), _INTL("\"What's in it for us?\""), _INTL("\"Not now.\"")], 0)
    if c == 2
      set_flag(:white_moose_refused)
      return say(["NIMSY: Of course. Lonelywood's three days north of Bryn Shander. I'll still be baking."])
    end
    if c == 1
      say(["NIMSY: (unoffended) Cookies aren't enough? They're shaped like halflings!",
           "NIMSY: Fine. Ten thousand for its head. The butcher pays a thousand for the carcass."])
      persuade = with_or_is?(:alberica) || rand(100) < 50
      speak(:alberica, "Ten thousand? For a moose that's beaten every hunter in town? Do better.",
                       "(quietly) Ten thousand. For that moose.") if with_or_is?(:alberica)
      sayc([
            persuade ? "NIMSY: (laughing) ...Twelve and a half. And not a copper more." : "NIMSY: Ten. I've got children, and a roof that leaks."])
      set_flag(:moose_fee_125) if persuade
      sayc(["She folds her arms. Then she unfolds them, and looks out of the window.",
            cl(:shade, "And if we want more than gold?"),
            with_or_is?(:shade) ? "NIMSY: Then... there's Ramshackle. The old inn. Closed two years. Nobody wants it." :
                                  "NIMSY: And... there's Ramshackle. The old inn. Closed two years. Nobody wants it.",
            "NIMSY: An investment property. To do with what you will."])
      set_flag(:moose_fee)
    else
      say(["NIMSY: Thank you. (She presses cookies on you anyway.) Take two. Take three, you're tall."])
    end
    say(["She takes a tarnished coin out of her apron and turns it over.",
         "NIMSY: And my mother's lucky coin, for its head. It's all I've got that shines.",
         "NIMSY: The loggers work the woods east of town, on the logging road. Look for tracks.",
         "NIMSY: Most will be ordinary moose. You'll know the white one's. Or you won't."])
    set_flag(:white_moose_taken)
    side_goal(:moose, "The white moose: in the woods east of Lonelywood, on the logging road.", done: :white_moose_done)
  end

  def white_moose_reward(event_id = nil)
    say(["You set the white moose's head down on Speaker Huddle's kitchen table.",
         "The children go very quiet.",
         "NIMSY: ...Well. It IS white."], event_id)
    take_key(:FT_MOOSEHEAD)
    knew = (state[:mirror_topics] || []).include?(:ravisin)
    if !$game_switches[SW_WM_RAVISIN]
      if knew
        sayc(["You tell her what the mirror showed: a frost druid gave the moose its words.",
              "NIMSY: A druid. Who makes them talk.",
              cl(:alerion, "She'll do it again. A polar bear. Something under the lake. Anything."),
              "NIMSY: (very quietly) Then this isn't over. Is it."])
      end
      set_switch(SW_WM_AWAKENED, true)
    else
      sayc(["You tell her about the druid in the tomb, and the sister she said hunters shot.",
            "NIMSY: Her poor sister. (She sits down.) Somebody's hunters did that. Ours, maybe.",
            nil])
      speak(:reptin, "It doesn't make what she did right. It makes it make sense.", "(quietly) It makes it make sense. Not right.") if with_or_is?(:reptin)
      sayc([
            "NIMSY: It always makes sense, afterwards. That's the worst of it."])
    end
    if flag?(:moose_fee)
      gold = flag?(:moose_fee_125) ? 12_500 : 10_000
      $Trainer.money += gold
      pbMessage(_INTL("You got ${1}!", gold.to_s_formatted))
      say(["NIMSY: And Ramshackle's yours. Here's the deed. Don't let anybody tell you it's haunted.",
           "NIMSY: It's probably not haunted."])
      give_key(:FT_RAMSHACKLEDEED)
      set_switch(SW_WM_RAMSHACKLE, true)
    else
      say(["NIMSY: And for heroes who asked for nothing but cookies... a whole TIN."])
      pbReceiveItem(:RARECANDY) rescue nil
      say(["NIMSY: ...And, oh, take Ramshackle.",
           "NIMSY: Somebody ought to have it. You lot clearly need a roof."])
      give_key(:FT_RAMSHACKLEDEED)
      set_switch(SW_WM_RAMSHACKLE, true)
    end
    say(["NIMSY: And my mother's lucky coin, as I promised.",
         "NIMSY: Pin it on a Pokémon and the purse comes home heavier.",
         "NIMSY: Mine never did. But I never fought anything."])
    give(:AMULETCOIN)
    quest_done_box("The white moose is dead.")
    set_flag(:white_moose_done)
    side_goal_done(:moose)
    town_quest_finished
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # Ramshackle
  #-----------------------------------------------------------------------------
  def ramshackle_door(event_id = nil)
    if !$game_switches[SW_WM_RAMSHACKLE]
      say(lines_for(:ramshackle_closed), event_id)
      return pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
    end
    transfer(*RAMSHACKLE_INSIDE)
  end

  RAMSHACKLE_INSIDE = [2137, 5, 11, 8]

  def ramshackle_rest(event_id = nil)
    say(lines_for(:ramshackle_inside), event_id)
    return if !pbConfirmMessage(_INTL("Clear a corner and rest at Ramshackle?"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(RAMSHACKLE_REST)
    sayc(["You sleep among the lumber. Nobody comes. Nothing creaks that shouldn't.",
          cl(:shade, "(in the morning) Somebody stood at the bar last night."),
          cl(:shade, "Didn't order. Didn't leave footprints."),
          cl(:alberica, "Darling, every bar has one of those.")])
  end

  #-----------------------------------------------------------------------------
  # The forest: tracks, false trails, and the encounters table
  #-----------------------------------------------------------------------------
  def forest_hours(n)
    state[:forest_hours] = (state[:forest_hours] || 0) + n
    while state[:forest_hours] >= 3
      state[:forest_hours] -= 3
      forest_encounter
    end
  end

  # The book: an hour's search and a DC 15 Wisdom (Survival) check finds a set
  # of moose tracks; a d6 says whose (only a 6 is the white moose); otherwise an
  # ordinary moose after 1d4 hours, and you search again. Every three hours in
  # the forest, the encounters table. (So it can't go on for ever: the third set
  # of tracks you find is always the white moose's.)
  WHITE_MOOSE_PITY = 3            # (notes 14 E24: not a grind of a dozen prompts)

  def moose_tracks(event_id = nil)
    return say(["Moose tracks. Lots of them. You've found the one set that matters already."], event_id) if $game_switches[SW_WM_TOMB_FOUND]
    say(["Moose tracks crisscross the snow under the pines. Old ones, new ones, all sizes."], event_id)
    return if !pbConfirmMessage(_INTL("Spend an hour searching for a fresh set of moose tracks?"))
    forest_hours(1)
    return if $game_switches[SW_WM_TOMB_FOUND]          # (the fox may have led you to them meanwhile)
    found = rand(100) < (with_or_is?(:alerion) ? 80 : 50)
    return failed_track_search if !found
    sayc([cl(:alerion, "(crouching) Here. Fresh. Heavy, steady. We follow these.")]) if with_or_is?(:alerion)
    state[:track_sets] = state[:track_sets].to_i + 1
    if rand(6) == 5 || state[:track_sets] >= WHITE_MOOSE_PITY
      return white_moose_tracks
    end
    say(["You follow the tracks for an hour or two..."])
    forest_hours(1 + rand(4))
    ordinary_moose
  end

  # A search that finds no fresh tracks still takes the hour, and the forest
  # gives you something for it, good or bad.
  def failed_track_search
    case rand(6)
    when 0
      sayc(["An hour of squinting at snow. Every set of tracks leads into every other set.",
            cl(:meat_meat, "Meat Meat is cold. Meat Meat also cannot find moose.")])
    when 1
      say(["No moose.",
           "But under a fallen pine, an old hunter's snare, still baited with a frozen berry."])
      pbReceiveItem(:PECHABERRY) rescue nil
    when 2
      say(["The tracks you follow turn out to be wolves'. A lot of wolves. Very fresh.",
           "You hear them before you see them."])
      forest_wolves
    when 3
      sayc(["You follow a trail for an hour. It doubles back on itself, and you realise you're lost.",
            cl(:alerion, "The moss is on the wrong side of every tree here. Somebody did that on purpose."),
            "Another hour gone, finding the logging road again."])
      forest_hours(1)
    when 4
      say(["No tracks. But in the hollow of an old stump: a hunter's cache, wrapped in oilcloth.",
           "Whoever left it isn't coming back."])
      pbReceiveItem(:SUPERPOTION) rescue nil
    else
      need = %i[FT_TWIG FT_PINECONE FT_GREYFEATHER].reject { |i| $PokemonBag.pbHasItem?(i) rescue false }
      if need.empty?
        say(["Nothing but snow, and the sense of being watched.",
             "Off in the trees, something white moves, and is gone."])
      else
        say(["No tracks. But something catches your eye in the snow."])
        forest_pickup(need.first)
      end
    end
  end

  def ordinary_moose
    say(["...and find a moose. Brown. Enormous. Ordinary.",
         "Chewing bark, looking at you with total indifference.",
         "It poses no threat, as long as you leave it alone."])
    c = pbMessage(_INTL("What do you do?"), [_INTL("Leave it alone."), _INTL("Battle it.")], 0)
    pbWildBattle(:STANTLER, 17) rescue nil if c == 1
    say(["You'll have to search for tracks again. Somewhere out here, a white moose is laughing."])
  end

  def white_moose_tracks
    sayc(["These tracks are different. Deeper. Wider. And they don't wander. They go somewhere.",
          "They lead east, into the old trees, to a slope where the woods thin out.",
          cl(:reptin, "Strange. My feet keep wanting to turn round. Do yours?"),
          cl(:alerion, "Elven ward. It turns people away. Don't let it. Watch the tracks, not the trees.")])
    set_switch(SW_WM_TOMB_FOUND, true)
    set_flag(:moose_tracks_found)
  end

  # The elven ward turns travellers away until they're following a beast's tracks.
  def tomb_ward(event_id = nil)
    return if $game_switches[SW_WM_TOMB_FOUND]
    say(["You walk on into the old trees, and walk, and walk...",
         "...and somehow you're back where you started, facing the logging camp.",
         "Nobody remembers turning round."], event_id)
    pbMoveRoute($game_player, [PBMoveRoute::TurnLeft, PBMoveRoute::TurnLeft, PBMoveRoute::Forward,
                               PBMoveRoute::Forward, PBMoveRoute::Forward]) rescue nil
  end

  # The fox and the hare.
  def fox_and_hare(event_id = nil)
    return say(["Paw prints, a little scuffle in the snow. The fox and the hare are long gone."], event_id) if flag?(:fox_hare_done)
    say(["An arctic fox, patiently stalking a snowshoe hare across the snow. Neither has seen you."], event_id)
    talker = with_or_is?(:meat_meat) ? :meat_meat : nil
    opts = [_INTL("Leave them be."), _INTL("Crouch down by the fox."), _INTL("Crouch down by the hare.")]
    c = pbMessage(_INTL("What do you do?"), opts, 0)
    set_flag(:fox_hare_done)
    if c == 0
      return say(rand(2) == 0 ? ["The hare bolts. The fox sits down in the snow and sulks."] :
                               ["The fox pounces. The hare doesn't get away. The fox trots off with dinner."])
    end
    friend = c == 1 ? "fox" : "hare"
    sayc([talker ? as(:meat_meat, "Little #{friend}. Meat Meat will not eat you. Meat Meat wants the moose.") :
                   "You crouch, very still, and hold out an empty hand to the #{friend}.",
          "The #{c == 1 ? "hare" : "fox"} bolts. The #{friend} sits, ears up, and looks at you for a long moment.",
          "Then it trots off east, stopping every few steps to make sure you're following."])
    forest_hours(1 + rand(4))
    white_moose_tracks if !$game_switches[SW_WM_TOMB_FOUND]
  end

  def forest_encounter
    roll = rand(20) + 1
    case roll
    when 1..10 then nil
    when 11..12 then forest_banshee
    when 13..14 then forest_bears
    when 15..16 then forest_chwingas
    when 17..18 then fox_and_hare if !flag?(:fox_hare_done)
    else forest_wolves
    end
  end

  def forest_banshee
    say(["A pale shape between the trees: a woman, an elf, in a tattered cloak, with a bow of mist.",
         "The spectral remnant of a warrior banished for something selfish and cruel.",
         "She nocks a phantom arrow."])
    if boss_battle(named_mon(:FROSLASS, 19, "Banshee"))
      say(["She comes apart like breath in the cold.",
           "She'll re-form somewhere in the forest tomorrow, damned to her exile."])
    end
  end

  def forest_bears
    if flag?(:forest_bear_killed)
      return say(["A brown bear and a scatter of cubs, nosing at the snow. The bear's mate.",
                  "She looks at you a long time, then takes her cubs the other way."])
    end
    say(["A hungry brown bear is pulling low branches off a pine and gnawing them.",
         "It sees you, and comes toward you, looking for tastier food."])
    if with_or_is?(:meat_meat)
      sayc([as(:meat_meat, "(drawing herself up to her full height, and roaring) MEAT MEAT IS NOT FOOD."),
            "The bear stops. Considers. Leaves."])
      return
    end
    set_flag(:forest_bear_killed) if boss_battle(named_mon(:URSARING, 18, "Brown bear"))
  end

  def forest_chwingas
    sayc(["As you stop for a breather, something tiny and bright-eyed peers out of a hollow log.",
          "Then another. Chwingas.",
          "They follow you for a while, copying the way you walk, giggling silently.",
          cl(:alberica, "(delighted, in spite of everything) They're doing your walk. It's uncanny."),
          "When they've had their fun, one leaves a little gift in a footprint, and they're gone."])
    pbReceiveItem(:ORANBERRY) rescue nil
  end

  def forest_wolves
    say(["Wolves. A pack of them, spreading out between the pines. They come in fast."])
    say(["You beat them back. The rest of the pack melts into the trees."]) if boss_battle(named_mon(:MIGHTYENA, 17, "Wolf"), named_mon(:POOCHYENA, 16, "Wolf"))
  end

  # The four things the gazebo brazier wants, lying about in the woods.
  def forest_pickup(item, event_id = nil)
    if $PokemonBag && $PokemonBag.pbHasItem?(item)
      return say(["Plenty more where that came from. You only need the one."], event_id)
    end
    text = { FT_TWIG: "A dry twig, snapped off clean.", FT_PINECONE: "A fat pinecone, half-buried in the snow.",
             FT_GREYFEATHER: "A soft grey owl feather, caught on a branch." }[item]
    say([text], event_id)
    give_key(item)
  end

  # The awakened polar bear that harasses the loggers while Ravisin lives.
  def awakened_bear(event_id = nil)
    return if !$game_switches[SW_WM_AWAKENED] || $game_switches[SW_WM_RAVISIN]
    say(["A polar bear stands up on its hind legs in the logging camp, and SPEAKS.",
         "BEAR: The druid gave me words. Want to hear them? GET OUT OF MY FOREST."], event_id)
    if boss_battle(named_mon(:B217H215, 21, "Awakened bear"))
      say(["It goes down muttering. Ravisin is still out there. There'll be another."])
    end
  end

  #-----------------------------------------------------------------------------
  # The elven tomb, outside (E1-E5)
  #-----------------------------------------------------------------------------
  def scene_elven_tomb_arrival
    say(["The tracks lead to a large, circular indentation in a snowy hillside.",
         "In the middle of the circle rises a gnomon of carved crystal, twenty feet tall.",
         "East of it, a berm crowned with evergreens shelters what looks like a sarcophagus.",
         "Round it under the snow: a half-circle of pale blue crystal pillars.",
         "North of it, a marble gazebo.",
         "South, a row of white marble statues on pillars, facing outward."])
  end

  # E1, E6: the ten statues. Topple all ten and the misdirection ends.
  def elf_statue(event_id = nil)
    say(lines_for(:tomb_e1), event_id)
    return if !pbConfirmMessage(_INTL("Topple the statue?"))
    if !party_has_strength?
      return say(["You heave together. The statue doesn't so much as rock.",
                  "You'd need a lot more strength than this."])
    end
    say(["You set your shoulders to the plinth and heave.",
         "The statue goes over and breaks in the snow."])
    set_self_switch(event_id, "A")
    state[:statues_down] = (state[:statues_down] || 0) + 1
    if state[:statues_down] >= 10
      say(["As the tenth statue falls, the air changes.",
           "The polite, persistent wish to be somewhere else is gone."])
      set_flag(:tomb_unwarded)
      set_switch(SW_WM_TOMB_FOUND, true)
    else
      say(["(#{state[:statues_down]} of 10 statues toppled.)"])
    end
  end

  # E3: the brazier. A twig, a pinecone, a feather and a severed hand, set alight.
  def gazebo_brazier(event_id = nil)
    if flag?(:brazier_lit)
      return say(["A silver flame burns in the brazier, warm as a campfire, and it won't go out for a tenday."], event_id)
    end
    say(lines_for(:tomb_gazebo), event_id)
    say(["In the middle of the gazebo sits an unlit stone brazier, its bowl twenty inches across.",
         "It's full of snow and pine needles the wind has swept off the floor.",
         "It's fixed to the marble. It won't budge."])
    need = %i[FT_TWIG FT_PINECONE FT_GREYFEATHER FT_SKELETALHAND]
    have = need.select { |i| $PokemonBag.pbHasItem?(i) rescue false }
    return if have.size < need.size && !pbConfirmMessage(_INTL("Put something in the brazier?"))
    if have.size < need.size
      missing = (need - have).map { |i| GameData::Item.get(i).name rescue i.to_s }
      return say(["You clear out the snow, but you don't have everything the pillars show yet.",
                  "(Still missing: #{missing.join(", ")}.)"])
    end
    say(["You clear the bowl and lay them in: the twig, the pinecone, the feather, and the hand."])
    if !party_has_fire?
      return say(["Now you need fire. A spark, a flame, something that burns."])
    end
    say(["A spark, and a silver flame eats the brazier's contents, then burns on, on nothing at all.",
         "It gives off heat and light like a campfire."])
    need.each { |i| take_key(i) }
    set_flag(:brazier_lit)
  end

  # E4: the sarcophagus and Sahnar.
  def tomb_sarcophagus(event_id = nil)
    return say(lines_for(:sahnar_after), event_id) if $game_switches[SW_WM_SAHNAR]
    say(lines_for(:tomb_pillars), event_id)
    say(["Atop the berm, a granite sarcophagus.",
         "Clearing the snow off the lid reveals an engraving of a brazier."])
    return say(["The lid won't move. No amount of force shifts it a hair."]) if !flag?(:brazier_lit)
    return if !pbConfirmMessage(_INTL("Push the lid aside? (It weighs as much as a horse.)"))
    if !party_has_strength?
      return say(["It weighs five hundred pounds. You'll need someone, or something, much stronger."])
    end
    say(["The lid grinds aside. Inside: a moon elf, wrapped in linen, preserved, and... sitting up."])
    sev = $game_map.events[event_id] rescue nil
    Stage.actor(:sahnar, sev.x, sev.y - 1, 2, graphic: SAHNAR_GRAPHIC) if sev && Stage.map?
    sayc(["SAHNAR: (in a dry, courtly voice) Ah. Liberators.",
          "SAHNAR: I am Sahnar. At your command, until I fall to dust.",
          "A strong smell fills the air. Cinnamon, nutmeg, cloves. Pumpkin spice.",
          cl(:alberica, "...The mummy smells like pumpkin pie."),
          cl(:meat_meat, "Meat Meat likes this one.")])
    set_switch(SW_WM_SAHNAR, true)
    pk = named_mon(:YAMASK, 18, "Sahnar")
    again = looped_gift?(:sahnar_with_you)
    if again || pbAddPokemonSilent(pk)
      pbMessage(again ? _INTL("(Sahnar is already with you, from last time. He bows anyway.)") :
                        _INTL("Sahnar the moon-elf mummy (a Yamask) joins you!\\me[Pkmn get]\\wtnp[20]"))
      say(["Sahnar knows nothing of Ten-Towns, or the winter. He's been sealed up for centuries.",
           "SAHNAR: But the moon dial, that I know. Ask, and I will show you how it turns."])
      set_flag(:sahnar_with_you)
      Stage.cleanup
    end
  rescue StandardError => e
    log("tomb_sarcophagus: #{e.message}")
  end

  SAHNAR_GRAPHIC = "Followers/YAMASK"      # stand-in (art request: a linen-wrapped moon-elf mummy)

  # E5: the moon dial. The gnomon lights the current phase; a moonbeam can light another.
  def moon_dial(event_id = nil)
    phase = (moonphase rescue 4)
    sayc(["The snow round the gnomon has melted away.",
          "Moon phases are carved in a circle in the stone.",
          "A full moon north, a new moon south, and the waxing and waning phases between."], event_id)
    if !flag?(:dial_read)
      sayc(["Tiny Elvish inscriptions run round the full moon and the two half-moons, east and west.",
            cl(:alerion, "The full moon: \"Gaze upon your own face and have seven questions answered.\""),
            cl(:alerion, "And the half-moons: \"Unlock the tombs of the half moon.\""),
            (!with_or_is?(:alerion) ? "The full moon: \"Gaze upon your own face and have seven questions answered.\"" : nil),
            (!with_or_is?(:alerion) ? "The half-moons: \"Unlock the tombs of the half moon.\"" : nil)])
      set_flag(:dial_read)
    end
    dial_lit
    names = { full: "the full moon", half: "a half-moon" }
    say(["Right now the gnomon's light rests on #{["the new moon", "a crescent", "a half-moon", "a gibbous moon", "the full moon",
         "a gibbous moon", "a half-moon", "a crescent"][phase]}." + (state[:dial_beam] ? " A moonbeam holds #{names[state[:dial_beam]]} lit as well." : "")])
    beam = dial_beam_source
    return if !beam
    c = pbMessage(_INTL("Light a symbol with {1}?", beam), [_INTL("The full moon."), _INTL("A half-moon."), _INTL("Leave it.")], 3)
    return if c == 2 || c < 0
    state[:dial_beam] = c == 0 ? :full : :half
    if c == 1
      set_switch(SW_WM_HALF_OPEN, true)
      say(["Silver light pools on the half-moon. Somewhere under the hill, two stone doors click."])
    else
      say(["Silver light pools on the full moon. Under the hill, something begins to glow."])
    end
  end

  # What's lit right now: by the real moon, or by a moonbeam.
  def dial_lit
    phase = (moonphase rescue 0)
    lit = []
    lit << :full if phase == 4 || state[:dial_beam] == :full || (!$game_switches[SW_WM_RAVISIN] && !$game_switches[SW_WM_MOOSE_DEAD])
    lit << :half if [2, 6].include?(phase) || state[:dial_beam] == :half
    set_switch(SW_WM_HALF_OPEN, true) if lit.include?(:half)
    lit
  end

  def dial_beam_source
    mon = $Trainer.party.find do |pk|
      !pk.egg? && !pk.fainted? && (pk.hasType?(:FAIRY) || pk.moves.any? { |m| %i[MOONLIGHT MOONBLAST].include?(m.id) })
    end rescue nil
    return mon.name if mon
    return "Sahnar's help" if flag?(:sahnar_with_you)
    nil
  end

  #-----------------------------------------------------------------------------
  # Under the hill (E6-E9)
  #-----------------------------------------------------------------------------
  # E6: the barrow, the sleeping animals, and the white moose at home.
  def barrow_moose(event_id = nil)
    return if $game_switches[SW_WM_MOOSE_DEAD]
    say(["Among the sleeping animals, a huge white shape lifts its head. The white moose.",
         "It looks at you with clever, hateful eyes, and speaks, in a voice like a tree splitting.",
         "MOOSE: Loggers' friends. Hunters' friends. I SAW you coming. I always see them coming."], event_id)
    sayc(["The other animals wake, startle, and scatter out through the hole in the hill."])
    white_moose_battle
  end

  # Watch from a distance, and the moose comes out to stand in the moon dial.
  def tomb_lookout(event_id = nil)
    say(lines_for(:tomb_lookout), event_id)
    return if $game_switches[SW_WM_MOOSE_DEAD]
    return if !pbConfirmMessage(_INTL("Watch the tomb from here for an hour?"))
    # the moose comes out on screen (notes 14 E18): from the hole, to the dial, to you
    say(["An hour passes, cold and still. Then something moves in the hole under the hill."])
    moose = Stage.actor(:white_moose, 10, 8, 2, graphic: MOOSE_GRAPHIC) if Stage.map?
    if moose
      Stage.walk_to(moose, 16, 15)
      Stage.cry(:STANTLER)
    end
    say(["A huge white moose stands in the moon dial, and sniffs the air for a few minutes."])
    Stage.approach(moose) if moose
    Stage.emote(moose, :angry) if moose
    say(["It turns toward Lonelywood, and walks straight toward your hiding place."])
    white_moose_battle
    Stage.cleanup
  end

  MOOSE_GRAPHIC = "Followers/STANTLER"     # stand-in (art request: a white bull moose, palmate antlers)

  def white_moose_battle
    if boss_battle(named_mon(:B234H128, 22, "White moose"))
      sayc(["The white moose goes down in the snow and doesn't get up.",
            "MOOSE: (a last breath, almost a laugh) She'll... make... more.",
            cl(:reptin, "(quietly) It could talk. It could think."),
            cl(:reptin, "Someone gave it that, and gave it nothing to do with it but hate."),
            "You take its head, for Speaker Huddle."])
      give_key(:FT_MOOSEHEAD)
      set_switch(SW_WM_MOOSE_DEAD, true)
      side_goal(:moose, "Take the white moose's head to Speaker Huddle in Lonelywood.", done: :white_moose_done)
    end
  end

  def barrow_bones(event_id = nil)
    say(lines_for(:tomb_bones), event_id)
    return if flag?(:took_hand) || ($PokemonBag.pbHasItem?(:FT_SKELETALHAND) rescue false)
    return if !pbConfirmMessage(_INTL("Take a hand from the bones?"))
    sayc(["You pick out a hand, all its little bones still wired together by the cold.",
          cl(:alberica, "I'm not going to ask. I'm going to look at the ceiling.")])
    give_key(:FT_SKELETALHAND)
    set_flag(:took_hand)
  end

  def barrow_lever(event_id = nil)
    say(lines_for(:barrow_lever), event_id)
    return say(["The south door stands open to the snow."]) if $game_switches[SW_WM_BARROW_OPEN]
    return if !pbConfirmMessage(_INTL("Pull the lever?"))
    say(["Stone grinds on stone.",
         "The airtight door in the hillside swings open from inside, and snow blows in."])
    set_switch(SW_WM_BARROW_OPEN, true)
  end

  # E7: the Mirror of the Full Moon. Seven questions, while the full moon's lit.
  def full_moon_mirror(event_id = nil)
    say(["The passage narrows and ends at an oval mirror, seven feet tall, in a carved stone frame."], event_id)
    if !dial_lit.include?(:full)
      return say(["The frame is dark. Your own reflection stares back, tired and cold."])
    end
    say(["The mirror's frame glows with silvery, scintillating light."])
    if !$game_switches[SW_WM_MOOSE_DEAD] && !flag?(:mirror_mine)
      say(["In the glass, instead of your faces: a logging camp.",
           "Hunters. A view from low in the trees, watching them.",
           "The mirror is attuned to someone else. Something else.",
           "The moose uses this to watch its enemies."])
      return if !pbConfirmMessage(_INTL("Gaze into the mirror, and make it yours?"))
    end
    set_flag(:mirror_mine)
    left = 7 - (state[:mirror_asked] || 0)
    return say(["Your own face looks back. The mirror has answered all seven questions it had for you."]) if left <= 0
    say(["Your own face looks back, and waits. (#{left} question#{left == 1 ? "" : "s"} left.)"])
    loop do
      left = 7 - (state[:mirror_asked] || 0)
      break if left <= 0
      asked = state[:mirror_topics] || []
      qs = MIRROR_QUESTIONS.reject { |_q, k| asked.include?(k) }
      c = pbMessage(_INTL("Ask the mirror..."), qs.map { |q, _| _INTL(q) } + [_INTL("Nothing more, for now.")], qs.size + 1)
      break if c < 0 || c >= qs.size
      key = qs[c][1]
      state[:mirror_topics] = asked + [key]
      state[:mirror_asked] = (state[:mirror_asked] || 0) + 1
      say(mirror_answer(key))
    end
  end

  def mirror_answer(key)
    case key
    when :moose
      $game_switches[SW_WM_MOOSE_DEAD] ? ["The glass shows a white hide in the snow, and a head on a halfling's kitchen table."] :
                                         ["The glass shows the barrow under this hill: a white shape among the sleepers, eyes open."]
    when :ravisin
      ["A woman with frost in her hair and blue-stained teeth, in a tomb behind a half-moon door.",
       "A frost druid. Ravisin.",
       "She gave the moose words. And a polar bear. And something very large, under the lake."]
    when :vurnis
      ["The same woman's face, but still, and grey. Her twin.",
       "Vurnis. Hunters' arrows near Lonelywood, last autumn.",
       "Ravisin keeps her in the sarcophagus she works on.",
       "She talks to her while she grinds her herbs."]
    when :sephek
      ["A man in his shirtsleeves who never sleeps, never eats, and isn't cold.",
       "Inside him, a cold that isn't his.",
       "The glass frosts over before it shows you more."]
    when :auril
      ["An island of ice in the Sea of Moving Ice, far to the north-west.",
       "A castle that is also a cloud.",
       "Someone on a throne, turning, and looking straight back at you.",
       "The mirror goes dark for a moment."]
    when :degrootz
      ["A common room at night. Three men who called themselves his friends.",
       "A rope, and a chair kicked over afterward."]
    when :spine
      ["Mountains with a city in their roots, and doors with no handles.",
       "Something older than the elves who built this tomb."]
    when :psi
      ["A dark ship under the ice, and something in it that thinks in screams.",
       "It wants help. You don't want to help it."]
    when :summer
      ["The glass shows a lake, thawing. Green at the edges.",
       "It holds the picture a long time, and then it lets it go."]
    else ["The mirror shows only you."]
    end
  end

  # E8: the first tomb of the half-moon.
  def half_tomb_one(event_id = nil)
    say(lines_for(:tomb_e8_light), event_id)
    return say(["The sarcophagus lies open. The elf inside lies in peace, robes mostly dust."]) if flag?(:e8_opened)
    return if !pbConfirmMessage(_INTL("Lift the sarcophagus's lid?"))
    return say(["It weighs three hundred and fifty pounds. Not without more strength than you've got."]) if !party_has_strength?
    say(["The rush of air stirs the cadaver's robes, and most of them crumble to dust.",
         "A withered elf lies inside.",
         "With it: an unstrung bow, six silvered arrowheads, and a cup etched with a winged fish."])
    give_key(:FT_ELVENBOW)
    pbReceiveItem(:FT_SILVERARROWHEAD, 6) rescue nil
    give_key(:FT_WINGEDFISHCUP)
    set_flag(:e8_opened)
  end

  # E9: Ravisin, the awakened berry bush, and Vurnis.
  def ravisin(event_id = nil)
    return if $game_switches[SW_WM_RAVISIN]
    say(["Someone lives in this tomb: a rack of drying herbs, a bedroll behind the sarcophagus.",
         "An herbalism kit is spread across the sarcophagus lid like a workbench.",
         "As the door opens, a figure ducks behind the sarcophagus.",
         "Then she climbs up onto it: a woman with frost in her hair and teeth stained blue.",
         "Something rustles behind her, trying to hide."], event_id)
    say(["(A druid. Like you. Gone the other way, the way the cold goes.)"]) if herald?(:wyn)
    # The villain's case, before the fight (dialogue 14, 14.12-4).
    say(["RAVISIN: Your towns' hunters shot my sister in these woods. Nobody even looked for her."], event_id)
    if pbTrainerBattle(:FT_FROSTDRUID, "Ravisin", nil, false, 0)
      sayc(["Ravisin falls against the sarcophagus.",
            "Her last, gasping breath: \"My beasts will avenge us!\"",
            cl(:alerion, "(looking at the sarcophagus) Two of them. She wasn't alone in here."),
            "Behind the sarcophagus, the berry bush is shaking so hard it's dropping berries."])
      set_switch(SW_WM_RAVISIN, true)
      set_switch(SW_WM_AWAKENED, false)
      state[:dial_beam] = nil if state[:dial_beam] == :full
    end
  end

  def awakened_shrub(event_id = nil)
    if !$game_switches[SW_WM_RAVISIN]
      return say(["The berry bush trembles behind the sarcophagus, very still, pretending to be a bush."], event_id)
    end
    if flag?(:shrub_talked)
      say(lines_for(:awakened_shrub), event_id)
      return
    end
    sayc(["SHRUB: (a tiny, rustling voice) Is she... is she gone? Really gone? No fire? Please.",
          "SHRUB: She blamed the towns, for her sister. Vurnis. Also a druid.",
          "SHRUB: I don't know how she died. Ravisin hid her in there.",
          "Its leaves shiver.",
          "SHRUB: Ravisin awakened lots of us, all over the Dale. Some are mean, like the moose.",
          "SHRUB: Some aren't. Like me.",
          "SHRUB: She was always cross with the big one in the lake. Too many scruples, she said.",
          "A handful of berries drops into your hand.",
          "SHRUB: You can have berries. They're good. They make your teeth blue. Take, take."], event_id)
    pbReceiveItem(:ORANBERRY, 10) rescue nil
    set_flag(:shrub_talked)
  end

  def vurnis(event_id = nil)
    return say(lines_for(:vurnis_after), event_id) if flag?(:vurnis_opened)
    say(["The sarcophagus Ravisin used as a worktable.",
         "Herbs, a mortar, little knives, all laid out with care."], event_id)
    return say(["Ravisin is still here. You'd have to get past her first."]) if !$game_switches[SW_WM_RAVISIN]
    return if !pbConfirmMessage(_INTL("Move the lid aside?"))
    return say(["Three hundred and fifty pounds. You'll need more strength."]) if !party_has_strength?
    sayc(["The tomb fills with a horrible stench of decay.",
          "Inside lies the rotting corpse of a woman with Ravisin's face. Her twin, Vurnis.",
          cl(:reptin, "(quietly, over the smell) She kept her sister here. Through all of it."),
          "Tucked under the body: a sharkskin pouch, and two crystal vials."])
    pbReceiveItem(:FULLHEAL) rescue nil
    pbReceiveItem(:MAXPOTION) rescue nil
    set_flag(:vurnis_opened)
  end

  # The tombs' doors stand in the way until a half-moon on the dial is lit; then
  # they swing open (and push open easily from inside ever after).
  def half_moon_door(which, event_id = nil)
    dial_lit
    if $game_switches[SW_WM_HALF_OPEN]
      return say(["Moonlight from somewhere far above runs along the half-moon's edge. The door swings open."], event_id)
    end
    say(lines_for(which == :e8 ? :tomb_e8_closed : :tomb_e9_closed), event_id)
    if with_or_is?(:shade) && pbConfirmMessage(_INTL("Let Shade try the door?"))
      sayc([as(:shade, "(after a long minute with an ear to the stone) No keyhole, no pins, no trick."),
            as(:shade, "It wants moonlight.")])
    end
  end

end
