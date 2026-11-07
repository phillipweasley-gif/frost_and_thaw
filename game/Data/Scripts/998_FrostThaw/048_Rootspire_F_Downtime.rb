#===============================================================================
# Frost & Thaw - Rootspire as a living city (part F): the downtime week
#
#   Seven days beneath the unbroken summer (the session log of 11/25). Each
#   Herald has their own days, one per night at the Hearth, at their own pace:
#     Reptin   - Arvik's Rootwarden training (Rootwarden Hall), Days 2-7, the Loop-Band
#     Alerion  - the Wind-Glass Library (his desk there), Days 2-7, and Day 5's
#                six potions from Nivva at Run & Bloom
#     Glimmer  - the seven-day rite with Lumin at the twin orb, the Brightmane
#                Acceptance, his three questions and the "Chard...alyn" vision
#     Meat Meat- Razzilith's warning and her first flight; the undercity walk;
#                the rooftop drills; the summer-growth imbalance
#     Alberica - waking to "Remember..."; the Memory Codex (the Lorn Scribe keeps
#                her old pages) and its four fragments; the seven rumours
#   And the city's other downtime: the Festival's missing beats, the Halo's
#   attempt on the Frost Saint effigy, Eirwen's private audience, the Lorn
#   Scribe, the Echo Codex's chronal songs, Tirena's compass, and the potions.
#
# Scene pass (notes/15 E13, E14; dialogue/15 §3): the Lorn Scribe gives one
# riddle a visit, each to its Herald; the Codex takes two mornings; Glimmer
# asks his own questions; the long walks are broken by choices.
#===============================================================================
module FrostThaw
  DT_HERALDS = [:reptin, :alerion, :glimmer, :meat_meat, :alberica]

  module_function

  def dt_done(h) = (state[:dt] ||= {})[h] || 0
  # The downtime week belongs before the descent (rootspire.md 3809-5386): once
  # the Heralds go down to the Forge, the days are over.
  def dt_ready?(h) = with_or_is?(h) && !flag?(:barricade_entered) && ((state[:dt_day] ||= {})[h] || 0) < rs_day
  def dt_step!(h)
    (state[:dt] ||= {})[h] = dt_done(h) + 1
    (state[:dt_day] ||= {})[h] = rs_day
    add_counter(:downtime_days)
  end
  def you_or(key, third) = herald?(key) ? "you" : third
  def your_or(key, third) = herald?(key) ? "your" : third
  def verb_for(key, third, second) = herald?(key) ? second : third

  # Morning beats at the Hearth (called by hearth_night).
  def downtime_morning
    if with_or_is?(:reptin) && dt_done(:reptin) == 1 && !flag?(:reptin_black_eye)
      set_flag(:reptin_black_eye)
      sayc([herald?(:reptin) ? "(You came back last night exceptionally battered. This morning you have a black eye.)" :
                               "Reptin came back last night exceptionally battered. This morning he has a black eye.",
            cl(:alberica, "Oh, sweetheart. Did the tree do that?"),
            herald?(:reptin) ? nil : "REPTIN: Arvik did that. Diplomatically.",
            herald?(:reptin) ? "(You tell them Arvik did it. Diplomatically.)" : nil].compact)
    end
    if with_or_is?(:alberica) && !flag?(:alberica_remember)
      set_flag(:alberica_remember)
      me = herald?(:alberica)
      say(["Sleep doesn't so much leave #{me ? 'you' : 'Alberica'} as loosen its grip.",
           "The Hearth's walls are warm with slow sap that glows like sunset caught in amber.",
           "Just before #{me ? 'your' : 'her'} eyes open: whispers. Soft. Like pages turning, somewhere known.",
           "\"Remember... remember...\"",
           "Then only the tree's heartbeat, through the floor, as if checking whether #{me ? "you've" : "she's"} risen.",
           "Outside, someone is singing a tune too old for this age, and too familiar to ignore."])
    end
    if with_or_is?(:alberica) && flag?(:codex_given) && !flag?(:codex_fragments) && dt_ready?(:alberica)
      memory_codex_day
    elsif with_or_is?(:meat_meat) && dt_ready?(:meat_meat) && dt_done(:meat_meat) < 4 && flag?(:twins_met)
      meat_meat_day
    end
  end

  #-----------------------------------------------------------------------------
  # Reptin: Arvik's training (Rootwarden Hall, 2183)
  #-----------------------------------------------------------------------------
  def arvik(event_id = nil)
    if !with_or_is?(:reptin)
      return say(["A broad Rootwarden with a Bough-circle braid, watching the initiates spar.",
                  "ARVIK: I train the Bough's initiates. If your Reptin wants lessons, send him.",
                  "ARVIK: I'm told he wrote our creed. I'll believe it when he can stand still."], event_id)
    end
    if dt_done(:reptin) >= 6
      return say(["ARVIK: (looking at the Loop-Band on #{your_or(:reptin, "Reptin's")} wrist) It fits. Good. Go and guard something."], event_id)
    end
    if !dt_ready?(:reptin)
      return say(["ARVIK: Tomorrow. Rootwardens train with the tree's day, not against it. Go and sleep."], event_id)
    end
    send(:"arvik_day#{dt_done(:reptin) + 2}", event_id)
  end

  def arvik_day2(event_id)
    r = herald?(:reptin)
    say(["ARVIK: Bough circle walks the Wall. Claw holds the Armory. I teach the Bough's young."], event_id) if !herald?(:wyn)
    # (the loop: Reptin's creed came back round to him. He hasn't written it yet.)
    say(["ARVIK: Our creed? You wrote it. Or you will. A wolf-bitten druid, the first Wardens said."], event_id) if r
    say(["ARVIK: Shoes off. Stand on the root. Don't talk. Don't think, if you can manage it.",
         r ? "You stand barefoot on the Trunk-Tier's living root. Arvik says nothing for an hour." :
             "Reptin stands barefoot on the Trunk-Tier's living root. Arvik says nothing for an hour.",
         "Under your feet: the Cycle Pulse. A beat in the wood that rises and falls with the season.",
         "ARVIK: Feel that? Bark flexing. Now this: cold in the root. Stiff. Learn the difference.",
         "ARVIK: Breathe with the sap. In when it climbs. Out when it falls.",
         "ARVIK: Now. The Blind Walk. Eyes shut. A hundred feet to the far post. Vibration only."], event_id)
    steps = [["The root dips to the left under you.", [_INTL("Lean into it."), _INTL("Lean away.")], 0],
             ["A hum, ahead. Hollow wood.", [_INTL("Step around the hum."), _INTL("Step on it.")], 0],
             ["The beat goes still. Something's moving on the root.", [_INTL("Stop and wait."), _INTL("Keep going.")], 0]]
    good = steps.count do |text, opts, right|
      say([text])
      ok = pbMessage(_INTL("Eyes shut..."), opts, 0) == right
      say([ok ? "Your foot finds the root's groove." : "You walk straight into a sap-pipe. Hard."])
      ok
    end
    dt_step!(:reptin)
    say([good >= 2 ? "ARVIK: ...You found the post. With your face, the last bit. Still counts." :
                     "ARVIK: You found every post in the yard but the right one. Again tomorrow.",
         "ARVIK: The tree's rhythm. That's first. Everything else is just falling over in rhythm."])
  end

  def arvik_day3(event_id)
    say(["ARVIK: Split Dock. Now. The Balance Gauntlet.",
         "Swaying bark-walks slick with mist. Root-plates hung on ropes over black water.",
         "ARVIK: Four beats. Left, right, root, breathe. The Rootwarden stride. Every terrain.",
         "Halfway across, Arvik cuts a rope. The plate under #{you_or(:reptin, 'Reptin')} swings out over the lake."], event_id)
    c = pbMessage(_INTL("The plate swings..."), [_INTL("Left, right, root, breathe."), _INTL("Jump for it.")], 0)
    say([c == 0 ? "Four beats. The plate swings back, and #{herald?(:reptin) ? 'you step' : 'Reptin steps'} off it like a stair." :
                  "The jump almost works. The lake is very warm. Arvik fishes #{you_or(:reptin, 'Reptin')} out by the collar."])
    say(["ARVIK: (wringing out a sleeve) Spar. Before you get cocky. Or cockier."])
    trainer(:arvik_spar)
    dt_step!(:reptin)
    say(["ARVIK: You're finding your feet. After two days of taking a pummelling.",
         "Something's changed in the way Arvik looks at #{you_or(:reptin, 'him')}. Not reverence. Better: faith."])
  end

  def arvik_day4(event_id)
    say(["ARVIK: Up. The root terraces. The Aurora-Climb.",
         "A bark ramp spirals up under frost-glass leaves. The aurora makes every step look farther.",
         "Platforms of grown branch, and gaps. Leaf-blades fall, to be caught before they land.",
         herald?(:reptin) ? "Your training wounds are healing nicely, and you aren't adding new ones." :
                            "Reptin's training wounds are healing nicely, and he isn't adding new ones.",
         "Arvik, visibly relieved, calls down a moonbeam to show the true distances.",
         "ARVIK: Don't trust the light. Trust the tree. The light lies up here. The bark never does."], event_id)
    c = pbMessage(_INTL("A leaf-blade falls through the moonbeam..."), [_INTL("Catch it where the moonbeam says."), _INTL("Catch it where it looks.")], 0)
    say([c == 0 ? "It lands in your palm, edge first, and doesn't cut." : "You catch air. The blade lands on your boot. Arvik sighs."])
    dt_step!(:reptin)
  end

  def arvik_day5(event_id)
    say(["Deep in the civic ring, in the hour before dawn, Arvik teaches the Quiet Step.",
         "ARVIK: Step with the root's heartbeat. Land in the grooves. Don't stir a grain of pollen.",
         "ARVIK: A Rootwarden on living wood is a rumour. Nothing more."], event_id)
    c = pbMessage(_INTL("A sleeping Stantler, across the Ring..."), [_INTL("Step with the heartbeat, in the grooves."), _INTL("Tiptoe.")], 0)
    if c == 0
      say(["#{herald?(:reptin) ? 'You cross' : 'Reptin crosses'} the Ring and lays a hand on the Stantler's flank. It doesn't wake.",
           "ARVIK: (very quietly, from right behind) ...The Quiet Step. Huh."])
    else
      say(["Every board creaks. The Stantler wakes, looks at #{you_or(:reptin, 'Reptin')} with contempt, and sleeps.",
           "ARVIK: Tiptoeing's for burglars. Again. ...There. That one. That was the Quiet Step."])
    end
    dt_step!(:reptin)
  end

  def arvik_day6(event_id)
    say(["ARVIK: Today I'm going to ambush you. All day. You won't know when.",
         "ARVIK: Root-weights. Vine-triggers. Bark plates. Don't resist the force. Redirect it.",
         "He walks away. Nothing happens for a long time. Then a root-weight comes out of nowhere."], event_id)
    trainer(:arvik_ambush)
    say(["By sundown #{herald?(:reptin) ? 'your body moves before you think' : "Reptin's body moves before he thinks"}. Guided by the tree.",
         "ARVIK: (sitting down hard) You dodge like a wolf. But you lose your magic when you dodge."])
    speak(:reptin, "Then let me teach you something back. Hold a spell like a breath. Move round it.",
          "...Here. Hold the spell like a breath.")
    say(["For an hour the student teaches the teacher: holding a spell while rolling and falling.",
         "ARVIK: (green flickering in his palm as he hops) ...Oh. OH. Why did nobody tell me?"])
    dt_step!(:reptin)
  end

  def arvik_day7(event_id)
    say(["ARVIK: The Silent Circuit. All the Trunk-Tier. Shadow the patrols. Step with the noise.",
         "ARVIK: Round the whole tier and back without anyone noticing. Not one grain of pollen."], event_id)
    noticed = 0
    [["A Rootwarden patrol, coming round the Bazaar's corner.", [_INTL("Fall in behind them, in step."), _INTL("Duck behind a stall.")], 0],
     ["The fish-market bell. Everyone turns.", [_INTL("Move on the bell."), _INTL("Wait for quiet.")], 0],
     ["The canopy stairs, thick with pollen.", [_INTL("Step only on the grooves."), _INTL("Take them fast.")], 0]].each do |text, opts, right|
      say([text])
      noticed += 1 if pbMessage(_INTL("The Silent Circuit..."), opts, 0) != right
    end
    say([noticed == 0 ? "Not a leaf stirs. Not a petal. Nobody turns their head." :
                        "Some leaves fall. People see the branches move, and look up, and see nothing.",
         "Back at the yard, Arvik is waiting, and he says the old Rootwarden words:",
         "ARVIK: The tree has begun to trust your weight."])
    say(["That night, under the full moon, #{you_or(:reptin, 'Reptin')} #{verb_for(:reptin, 'teaches', 'teach')} Arvik one more thing:",
         "how to heal in wild shape, as the wolf.",
         "ARVIK: (afterwards, very gruff) Hold out your arm."])
    # (dialogue 15 §4: the speech is two boxes, ending on the line)
    say(["He ties a wristband of living bark round #{your_or(:reptin, "Reptin's")} wrist. It shifts, and grows, to fit.",
         "ARVIK: The Rootwarden's Loop-Band. You didn't go through the training. You didn't have to.",
         "ARVIK: Everything we guard grew out of what you left behind."])
    give_key(:FT_LOOPBAND)
    say(["(The Loop-Band: with the Quiet Step, half as many wild Pokémon find you in grass.)"])
    dt_step!(:reptin)
    wheel(1)
    add_counter(:story_beats)
    speak(:reptin, "I wrote that creed half-drunk in ten minutes, Arvik. You made it true.",
          "...Thank you, Arvik.")
  end

  #-----------------------------------------------------------------------------
  # Alerion: the Library (his desk in the Wind-Glass Library, 2062)
  # (dialogue 15 §3: he doesn't ask the books questions; he names what he's after)
  #-----------------------------------------------------------------------------
  def alerion_desk(event_id = nil)
    if !with_or_is?(:alerion)
      return say(["A reading desk under the oldest frost-glass leaves, buried in history books.",
                  "A card in a tidy hand: RESERVED. DO NOT TOUCH."], event_id)
    end
    return research_sigils(event_id) if respond_to?(:research_sigils) && research_sigils(event_id)
    n = dt_done(:alerion)
    if n >= 6
      return say(["#{herald?(:alerion) ? 'Your' : "Alerion's"} desk. The leaves on it are quiet now. They've said what they will."], event_id)
    end
    if !dt_ready?(:alerion)
      return say(["The leaves are dim. Enough for one day. (Rest at the Hearth, then come back.)"], event_id)
    end
    if n == 3
      return say(["A note on the desk, in #{herald?(:alerion) ? 'your own' : "Alerion's"} hand:",
                  "DAY 5. RUN & BLOOM. SIX POTIONS. (Nivva Sunwick, at the annex stand.)"], event_id)
    end
    send(:"alerion_day#{n + 2}", event_id)
  end

  def alerion_day2(event_id)
    a = herald?(:alerion)
    say(["#{a ? 'You spend' : 'Alerion spends'} the day on the first hundred years after the Verdant Reversal.",
         "Dougan's Hole: swallowed by roots by Year 57 VR. The whole old town is under the tree.",
         "The first settlers lived on scaffolds round the roots, and moved them up each spring.",
         "The first Cycle Pulse readings, scratched on bark: HEARTBEATS OF SPRING, RETURNING."], event_id)
    speak(:alerion, "The Twenty Stones.", "...The Twenty Stones.")
    say(["Nothing. Not a mention of the Twenty Stones in any book. As if somebody had cut it out.",
         "In the margin of one leaf, in a later hand: SEE THE FIRST MAPS. EIRWEN HAS THEM."])
    dt_step!(:alerion)
  end

  def alerion_day3(event_id)
    a = herald?(:alerion)
    say(["Old frost-glass leaves on the Reversal itself, in a dozen frightened hands.",
         "The hag's mirrors broke Rootspire's time, they think. The sapling burst out of the break.",
         "Time didn't resume in a line. Certain events echoed backward."], event_id)
    say([a ? "(Part of Rootspire remembers you before you were born. And after you died.)" :
             "Alerion goes very still. Rootspire remembers him before he was born, and after he died.",
         "One leaf has his name on it, in an account of a funeral. The date is a century from now."])
    speak(:alerion, "...I'm not reading that one.", "...No.")
    dt_step!(:alerion)
  end

  def alerion_day4(event_id)
    say(["Wyrmling history. Razzilith the Verdant, Frostina the Pale. They shaped the seasons.",
         "Their breath quickened the tree. Each generation's mood shaped the wyrmlings' temper.",
         "And the wyrmlings come round again: seasonal spirits, reborn, over and over."], event_id)
    speak(:alerion, "The wyrmlings. The way back to winter.", "...Back to winter.")
    say(["The answer is in Old Wennen, on a leaf so old it's gone soft as cloth:",
         "The wyrmlings by themselves cannot change the seasons. With a guide, they can.",
         "Dragon Warriors. Partners of dragons, never their masters.",
         "#{herald?(:alerion) ? 'You look' : 'Alerion looks'} across the Library at the party, and doesn't say anything for a while."])
    set_flag(:dragon_warriors_read)
    dt_step!(:alerion)
  end

  # Day 5: the six potions, at Nivva's stand in Run & Bloom (called from nivva_shop).
  def alerion_potions(event_id = nil)
    return false if !with_or_is?(:alerion) || dt_done(:alerion) != 3 || !dt_ready?(:alerion)
    a = herald?(:alerion)
    say(["#{a ? 'You ask' : 'Alerion asks'} for six potions. Two red, two green, a muddled one, and a red with a green tint.",
         "NIVVA: Six! A connoisseur. Sanguine Sap Tonic, the red: sweet and warm. Your cheeks glow.",
         "NIVVA: The tree likes to see you healthy. That's what we say.",
         "NIVVA: Verdant Vitality Phials, the green. Mint and basil. For the cold and the road.",
         "She holds up the muddled one, red and green chasing each other like vine round a flame.",
         "NIVVA: Heartroot Renewal. The surprise is, it's the best thing I make. Once a day, mind.",
         "NIVVA: The red with the green tint: Emberleaf Courage. Heartfire and verdant threads.",
         "NIVVA: Steadies the feelings. Your eyes'll shimmer when you mean something."], event_id)
    # Day 5 is the asking, not the buying (rootspire.md: the purchase is the
    # day's flavour); the day counts whether or not the potions are bought.
    cost = 2 * 900 + 2 * 800 + 1400 + 1200
    if ($Trainer.money rescue 0) >= cost && pbConfirmMessage(_INTL("Buy all six for ${1}?", cost))
      $Trainer.money -= cost
      give(:FT_SANGUINETONIC, 2); give(:FT_VITALITYPHIAL, 2); give(:FT_RENEWALDRAUGHT); give(:FT_EMBERLEAF)
      say(["NIVVA: (wrapping them in leaf-paper) Pleasure. Come back and say which surprised you."])
      set_flag(:alerion_potions_bought)
    else
      say(["NIVVA: That's #{cost} all told. No? Then take the names. And a sniff, on the house.",
           "She uncorks the muddled one, and for a breath you smell a summer you never had.",
           "NIVVA: I'll hold them for you. They keep. Most things in Rootspire keep."])
      set_flag(:alerion_potions_held)
    end
    dt_step!(:alerion)
    true
  end

  # The potions Nivva holds, if Alerion couldn't buy them on Day 5.
  def alerion_held_potions
    return false if !flag?(:alerion_potions_held) || flag?(:alerion_potions_bought)
    cost = 2 * 900 + 2 * 800 + 1400 + 1200
    return false if ($Trainer.money rescue 0) < cost
    return false if !pbConfirmMessage(_INTL("NIVVA: Your six potions are still here. ${1}?", cost))
    $Trainer.money -= cost
    give(:FT_SANGUINETONIC, 2); give(:FT_VITALITYPHIAL, 2); give(:FT_RENEWALDRAUGHT); give(:FT_EMBERLEAF)
    set_flag(:alerion_potions_bought)
    true
  end

  def alerion_day6(event_id)
    say(["Icewind Dale, before Auril.",
         "The Reghed tribes kept seasonal rites: fire in winter, water in summer, a turning-song.",
         "Ten-Towns cooperated only sporadically. Mostly they argued about fish.",
         "Early druids foretold a goddess of frost rising, if the balance were ever broken.",
         "And there were summers. Brief golden ones. Before the curse."], event_id)
    speak(:alerion, "Four hundred years. Was there ever a proper winter?", "...A proper winter.")
    say(["#{herald?(:alerion) ? 'You read' : 'Alerion reads'} the answer three times. It seems very clear.",
         "The Reversal had four seasons for centuries. The endless summer is new. A recent illness."])
    set_flag(:alerion_misbelief)
    say(["(The leaf is badly faded. Several words are missing. #{herald?(:alerion) ? 'You are' : 'Alerion is'} quite sure anyway.)"])
    dt_step!(:alerion)
  end

  def alerion_day7(event_id)
    a = herald?(:alerion)
    say(["The deepest leaves. The ones in the locked case, which Eirwen unlocks without being asked.",
         "EIRWEN: These don't store events. They store possibilities. Careful which you believe.",
         "#{a ? 'You lay' : 'Alerion lays'} a hand on the glass, and the visions come, one over another:"], event_id)
    say([a ? "(Yourself, cloaked in Winter's power, in a Council seat. Its last holder gone.)" :
             "Alerion, cloaked in Winter's power, in a seat in the Council Hall. Its last holder gone.",
         "A golden key, turning in a frost-sealed door.",
         "A council of Heralds, that hasn't happened yet.",
         "The World Tree shaking as frost creeps up from below.",
         "One leaf whispers, quite clearly: \"Winter returns through those who do not fear the cold.\""])
    speak(:alerion, "The golden key.", "...The key.")
    say(["A reference, half rubbed out: old tunnels, under Dougan's Hole.",
         "#{a ? "You can't tell" : "Alerion can't tell"} whether that's the leaves, or the memory of the hag's lair."])
    set_flag(:golden_key_tunnels)
    set_flag(:winter_returns_leaf)
    dt_step!(:alerion)
    wheel(1)
    add_counter(:story_beats)
    say(["Under the last leaf, Eirwen has left a slim book of their own: ON THE FIRST REVERSAL.",
         "A note from the future's past, on the first page:",
         "\"The goblin who bled green fire proved life resists design.",
         "The Verdant Prototype was lost to time, yet her heartbeat echoes through every thaw.\""])
    # (dialogue 15 §2: Meat Meat can't read; somebody reads it to her)
    sayc([cl(:meat_meat, "Somebody read Meat Meat the hard words. ...Meat Meat is in a book?"),
          cl(:alberica, "You always were, sweetheart. Now it's in writing.")].compact)
  end

  #-----------------------------------------------------------------------------
  # Glimmer: Lumin's seven-day rite (at the twin orb), and Brightmane's answers
  #-----------------------------------------------------------------------------
  def lumin_rite(event_id = nil)
    return false if !flag?(:glimmer_joined) || flag?(:glimmer_gone) || !flag?(:orb_visions) || !with_or_is?(:glimmer)
    return false if flag?(:glimmer_rite_done) && flag?(:brightmane_answered)
    return brightmane_questions(event_id) if flag?(:glimmer_rite_done)
    if !dt_ready?(:glimmer)
      say(["LUMIN: Tomorrow, Sparkbearer. The rite keeps the sun's hours. Sleep, and come at sun-up."], event_id)
      return true
    end
    send(:"glimmer_day#{dt_done(:glimmer) + 2}", event_id)
    true
  end

  def g_name = herald?(:glimmer) ? "you" : "Glimmer"
  def g_poss = herald?(:glimmer) ? "your" : "his"

  def glimmer_day2(event_id)
    if dt_done(:glimmer) == 0 && !flag?(:lumin_rite_offered)
      set_flag(:lumin_rite_offered)
      say(["LUMIN: (looking at #{herald?(:glimmer) ? 'you' : 'Glimmer'} a long time) Brightmane brought you back. Tangled.",
           "LUMIN: Some of you tastes of winter. The knife. The old pact. It's still tied to her.",
           "LUMIN: There's a rite. Seven days, sun-up to sundown. It unties what can be untied."], event_id)
      return if !pbConfirmMessage(_INTL("Begin the rite with Lumin?"))
    end
    say(["DAY 2. THE SEVERANCE OF FROST.",
         "From sun-up to sundown, #{g_name} #{verb_for(:glimmer, 'stands', 'stand')} in a circle of sun-thread cloth.",
         "LUMIN: This one. Does it taste of winter, or does it glow inward? ...And this one?",
         "One by one, every power #{g_name} #{verb_for(:glimmer, 'carries', 'carry')}, sorted, like seeds.",
         "At sundown Lumin burns a single strand of frost-silk. It hisses like a voice cut off.",
         "LUMIN: That was her whisper. One of them.",
         herald?(:glimmer) ? "(You feel it: the tether to Auril, weakening. The first fibre parting.)" : "GLIMMER: (very quietly) ...I felt that. Like a rope going slack."])
    dt_step!(:glimmer)
  end

  def glimmer_day3(event_id)
    say(["DAY 3. THE DAWN EMBER MEDITATION.",
         "Under sap-lanterns charged with the day's sun, #{g_name} #{verb_for(:glimmer, 'sits', 'sit')} with empty hands.",
         "A Wennen pulse-drum keeps the beat. Lumin chants Brightmane's Names of Courage, slow.",
         "No spell. No pact. Just asking.",
         "At the last name, a tiny gold ember sits in #{g_poss} palms, warm as a held hand."], event_id)
    dt_step!(:glimmer)
  end

  def glimmer_day4(event_id)
    say(["DAY 4. THE SUNCALL PURIFICATION.",
         "At the Suncall brazier, Lumin bathes the pact-mark in #{g_poss} fur in auroral light.",
         "A trickle of radiant fire runs down through the bloodline like a warm river.",
         "The frostburn scars shift toward warmth. The warlock's features begin, slowly, to fade.",
         "And the unicorn's horn Brightmane gave back, that #{g_name} #{verb_for(:glimmer, 'has', 'have')} carried all week,",
         "sets itself to #{g_poss} brow, and grows in. It isn't coming off again. #{herald?(:glimmer) ? 'You know' : 'He knows'} it."], event_id)
    dt_step!(:glimmer)
  end

  def glimmer_day5(event_id)
    say(["DAY 5. THE LITANY OF THE MANE.",
         "Brightmane's hymns, sung in the chapel arch where the roots twist upward like a mane.",
         "LUMIN: The four heroic virtues. Say them with me.",
         "Compassion. Courage. Persistence. Dawn-Love."], event_id)
    speak(:glimmer, "Compassion. Courage. Persistence. Dawn-love.", "...Compassion. Courage. Persistence. Dawn-love.")
    say(["Lumin ties a mane-braid of gold thread round #{g_poss} neck, warm as a hand.",
         "LUMIN: For the holy symbol. A leaf-woven one, for now. Channel into it."])
    give_key(:FT_MANEBRAID)
    say(["#{herald?(:glimmer) ? 'You hold' : 'Glimmer holds'} the leaf-woven symbol and wills it. Not a pact. Will.",
         "Light, small and clear, blooms in it. The first prayer answered by will, not pact."])
    dt_step!(:glimmer)
  end

  def glimmer_day6(event_id)
    say(["DAY 6. THE DAWNSTRIDE RITE.",
         "A walking rite over the Canopy's bridges at sunrise. Dawnlight on shut eyes.",
         "Healing prayers spoken on the move. Brightmane's courage breathed in with the cold air.",
         "Lumin teaches the stances for channelling, one per bridge.",
         "By the last bridge, the light in #{g_name} has stopped flickering. The pact is an ember."], event_id)
    dt_step!(:glimmer)
  end

  def glimmer_day7(event_id)
    say(["DAY 7. THE BRIGHTMANE ACCEPTANCE.",
         "A circle of Wennen priests in the chapel, weaving light round #{g_name} like a loom.",
         "LUMIN: (her voice carrying to the treetop) Hope has found you worthy. Step into dawn."], event_id)
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(255, 220, 120, 220), 30) rescue nil
    say(["The Suncall brazier erupts in a pillar of gold, up through the canopy. The city sees it.",
         "The tether to Auril shatters, like a pane of ice falling from a great height.",
         "Only the Rimefang still smokes with cold at #{g_poss} hip. The knife remembers her.",
         "#{herald?(:glimmer) ? 'You' : 'Glimmer'} no longer #{verb_for(:glimmer, 'does', 'do')}.",
         "LUMIN: (bowing, for the first time) Cleric of Brightmane. The chapel knows your name now."])
    set_flag(:glimmer_rite_done)
    dt_step!(:glimmer)
    wheel(1)
    add_counter(:story_beats)
    sayc([cl(:alberica, "(wiping her eyes) That was the most beautiful thing I've ever seen. Again."),
          cl(:reptin, "Step from frost into dawn. I'm stealing that."),
          cl(:meat_meat, "Fluffy one is shiny now. Meat Meat is proud.")].compact)
    say(["LUMIN: Brightmane listens closest on the day of acceptance. Ask your questions now."])
    brightmane_questions(event_id)
  end

  # Glimmer's three questions (dialogue 15 §4: in his own voice, and he picks
  # the order; the answer that matters plants the line used three times later).
  BRIGHTMANE_QUESTIONS = [
    [:auril, "What's wrong with Auril?", "GLIMMER: What's wrong with her? Auril. Really wrong?",
     ["BRIGHTMANE: (a bell heard through warm water) Power, and stasis. She wants it all still.",
      "BRIGHTMANE: A spark of hope leads to growth. Growth leads to a new spring."]],
    [:how, "How do I face her?", "GLIMMER: And when I'm in front of her. How do I do it?",
     ["BRIGHTMANE: Not alone. Lean on the ones who give you hope. Give it back to them."]],
    [:me, "What do you want me for?", "GLIMMER: And me. What do you want me for?", nil]
  ]

  def brightmane_questions(event_id = nil)
    return true if flag?(:brightmane_answered)
    say(["#{herald?(:glimmer) ? 'You kneel' : 'Glimmer kneels'} at the orb with the mane-braid in both hands.",
         herald?(:glimmer) ? nil : "GLIMMER: Brightmane. It's me. Still the cat. Three questions, and no manners."].compact, event_id)
    # (she answers as light in the orb: a pale lion's shape beside it, there and not)
    bm = walk_on("BRIGHTMANE", "Followers/SOLGALEO")
    bm.instance_variable_set(:@opacity, 110) if bm
    left = BRIGHTMANE_QUESTIONS.dup
    until left.empty?
      c = pbMessage(_INTL(herald?(:glimmer) ? "(What do you ask?)" : "Glimmer asks..."), left.map { |q| _INTL(q[1]) }, -1)
      c = 0 if !c || c < 0
      key, _label, ask, answer = left.delete_at(c)
      say([herald?(:glimmer) ? "(#{ask.sub('GLIMMER: ', '')})" : ask])
      if answer
        say(answer)
      else
        brightmane_vision
      end
    end
    Stage.remove_actor(bm) if bm
    set_flag(:brightmane_answered)
    set_flag(:chardalyn_vision)
    sayc([cl(:glimmer, "(shaking) Chardalyn. Whatever that is. And a fire, under all of it."),
          cl(:alerion, "Chardalyn. Demon-crystal. If it's under the tree, somebody put it there.")].compact)
    true
  end

  def brightmane_vision
    Stage.overlay("O-01", scroll_x: 0.4, opacity: 220, pulse: :hard, fade: 10) rescue nil
    say(["There's no answer in words. There's a vision.",
         "A dragon built by experiment, of some strange ore, bursting out of the World Tree's roots.",
         "It spreads its wings over the realm, and everywhere their shadow falls, ice.",
         "It's made of something #{herald?(:glimmer) ? "you can't" : "he can't"} quite name. A word comes, broken: \"Chard... alyn\"?",
         "And #{herald?(:glimmer) ? 'you are' : 'he is'} facing it. Not alone: the others are beside #{herald?(:glimmer) ? 'you' : 'him'}.",
         "BRIGHTMANE: (fading) There's a fire under all of this. You'll know it when you see it."])
    Stage.overlay_off("O-01", fade: 10) rescue nil
  end

  #-----------------------------------------------------------------------------
  # Meat Meat's days
  #-----------------------------------------------------------------------------
  def meat_meat_day
    n = dt_done(:meat_meat)
    mm = herald?(:meat_meat)
    prompt = ["Meat Meat's going to see Razzilith in the glade.", "Meat Meat's going down to the undercity alone.",
              "Meat Meat's up on the roof, very early.", "Meat Meat's going out to watch the dawn."][n]
    return if !mm && !pbConfirmMessage(_INTL("{1} Go with her?", prompt))
    return if mm && !pbConfirmMessage(_INTL("{1}", ["Go and see Razzilith in the glade?", "Go down to the undercity alone?",
                                                    "Go up on the roof before dawn?", "Go out and watch the dawn?"][n]))
    send(:"meat_meat_day#{n + 2}")
  end

  def mm_she = herald?(:meat_meat) ? "you" : "she"
  def mm_her = herald?(:meat_meat) ? "your" : "her"
  def mm_name = herald?(:meat_meat) ? "you" : "Meat Meat"

  def meat_meat_day2
    Stage.visit(2060, 18, 14, 8) do
      razz = walk_on("RAZZILITH")      # (he's at the Shrine by day; he flew down to meet her)
      say(["The glade where the Verdant Reversal began is warm today. Too warm. A fever under snow.",
           "Razzilith waits in the clearing, coiled round a warm stone, chirring like a harp-string.",
           "But his eyes are troubled. He nudges #{mm_her} shoulder and speaks the way he does:",
           "broken words, and painted thoughts.",
           "RAZZILITH: (a painted thought: the scorched throne, empty) ...Summer?",
           "(A flicker of orange and warm rain. Then cold.)",
           "RAZZILITH: Gone. No steps. No smell.",
           "RAZZILITH: (red leaves, covering something) Autumn... hides.",
           "His tail lashes. The picture in the bond changes.",
           "RAZZILITH: Summer is... a shape. (Heat-shimmer, a long coat. No face.)",
           "RAZZILITH: No one ever sees Summer's face. All feel... chills. Like bad winter.",
           "His wings shiver. He presses his forehead to #{mm_her}s, scales warm.",
           "RAZZILITH: Summer... wrong. Wrong things grow."])
      set_flag(:razzy_summer_warning)
      # (dialogue 15 §3: she answers him)
      speak(:meat_meat, "Meat Meat will find Summer's face, Razzy. Then Meat Meat will bite it.",
            "(very quiet) ...Meat Meat will find it, Razzy.")
      say(["He pulls back, chirping, tail thrashing like a cat's. He crouches, wings half-fanned.",
           "RAZZILITH: Fly?"])
      if !pbConfirmMessage(_INTL(herald?(:meat_meat) ? "Climb on?" : "Let Meat Meat climb on?"))
        say(["Razzilith doesn't wait for an answer. He never has."])
      end
      say(["Before #{mm_she} can breathe, he's scooped #{herald?(:meat_meat) ? 'you' : 'her'} onto his shoulders.",
           "His scales are warm and smooth and alive.",
           "Ground runs first: short sprints, wings beating. Hops that feel like falling upward.",
           "#{herald?(:meat_meat) ? 'You find' : 'She finds'} the balance point without thinking,",
           "and how to hold the ridge of his neck without hurting him.",
           "Then a leap. A real one. His wings snap wide and catch the glade's warm draught,",
           "and for a glowing heartbeat #{mm_name} #{verb_for(:meat_meat, 'is', 'are')} riding a dragon.",
           "A small dragon. But a dragon.",
           "He lands laughing, wyrmling laughter, bright as bells, and it echoes through the bond.",
           "#{herald?(:meat_meat) ? 'You are' : 'She is'} the first rider he has ever allowed on his back. And he likes it."])
      walk_off(razz)
    end
    set_flag(:razzy_first_flight)
    dt_step!(:meat_meat)
    wheel(1)
    add_counter(:story_beats)
  end

  def meat_meat_day3
    Stage.visit(2055, 20, 14, 2) do
      say(["Below the Trunk-Tier's hum, the undercity is a lung half breathed out: thin air, cold.",
           "#{herald?(:meat_meat) ? 'You slip' : 'Meat Meat slips'} between fungal lanterns and crooked doorways.",
           "Roots curve overhead like ribs.",
           "The lake-wind whistles through the planks. Something down here watches. It always does.",
           "A tunnel mouth in frost-bitten stone, moaning. Locals say it whispers passers-by's names."])
      c = pbMessage(_INTL("The tunnel mouth..."), [_INTL("Stop and listen."), _INTL("Keep walking.")], 0)
      if c == 0
        say(["#{herald?(:meat_meat) ? 'You only hear' : 'Meat Meat only hears'}: \"Don't... turn... back...\" The frost patterns look like eyes."])
      end
      say(["In a narrow root corridor the boards are warm. Something-burning-under-the-tree warm.",
           "The sap veins glow like fever. The wood thrums under #{mm_her} hand like a heart in panic.",
           "Something slides inside the bark, at the edge of sight. Gone.", "A local mutters: \"Spring's watchers.\""])
      say(["At the Split Dock, a half-rotted crate spills black grit. Warm. Smoke shut up in stone.",
           "A dockworker panics and sweeps it into the water."])
      c = pbMessage(_INTL("The dockworker is sweeping..."), [_INTL("\"That's not ore.\""), _INTL("Let it go.")], 0)
      if c == 0
        set_flag(:dock_ore_seen)
        say_staged(["DOCKWORKER: It fell off a boat from the south! It did NOT come from the sap-mines!",
             "He's lying. Badly. His name's stitched on his apron: JORIK."])
      end
      say_staged(["Between lantern posts, a shadow peels off someone walking ahead. It lingers. Snaps back.",
           "The person never notices.",
           "The Still Sky Shrine's door, ajar. A sign: CLOSED FOR VEIL OBSERVANCE. Too quiet inside.",
           "Two Rootwarden initiates whisper by a pier: some of the Bough went missing by the Wall.",
           "INITIATE: They found them frozen. Then something took them again. Like it wants them up.",
           "They go quiet when #{mm_she} #{verb_for(:meat_meat, 'passes', 'pass')}.",
           "On the way back to the lift: a presence in the root-shadow. A soft scrape of claws.",
           "It never comes close enough to see. Only close enough to promise it'll be back."])
    end
    set_flag(:mm_undercity_walk)
    dt_step!(:meat_meat)
  end

  def meat_meat_day4
    say(["Before dawn, on the Hearth's roof. Drills: rolls, drops, the silent ones.",
         "Then sitting very still, thinking about Razzy. About his laugh. About a meadow.",
         "The fear doesn't go. It sits down beside #{herald?(:meat_meat) ? 'you' : 'her'}, which is different.",
         "Back inside, the Rootwardens at the bar are trading rumours:",
         "Blue lights pulsing under the Trunk-Tier's floor at night. \"Like something signalling up.\"",
         "A Warden found walking the civic ring at dawn, empty-eyed, frost on her lashes. No memory.",
         "And somebody's forging Council decrees: a dig under the Heartroot. Nearly the right seal."])
    set_flag(:blue_lights_heard)
    say(["(#{herald?(:meat_meat) ? 'You feel' : 'Meat Meat feels'} sharp: quick, quiet, steady. First cut, true cut.)"])
    give(:QUICKCLAW)
    give(:RAZORCLAW)
    dt_step!(:meat_meat)
  end

  def meat_meat_day5
    say(["Out on the walkway, #{mm_name} #{verb_for(:meat_meat, 'watches', 'watch')} the dawn, because something's wrong with it.",
         "The light holds a deep summer gold for several breaths too long. Long enough to squint at.",
         "Leaves near the walkways are curled at the edges. Not with cold. With heat.",
         "The air's heavy. A storm that never arrives. \"Humidity spike,\" a local says. \"Happens.\"",
         "The sap-lines are warmer than yesterday. Not alarming. Strange.",
         "A glade bird sings a midsummer mating call. At dawn. Another paces, fluffed at nothing.",
         "Flowers pop open too early in the heat, and by noon they're sagging, exhausted.",
         "A vendor wipes her brow: \"Feels like summer's holding its breath.\"",
         "A Rootwarden on the steps: \"The cycle's dragging. A hot day that won't roll over.\""])
    sayc([herald?(:meat_meat) ? "(Rootspire's acting weird again. You file it away. Growth slow. Heat too strong.)" :
                                cl(:meat_meat, "Rootspire is acting weird again. Growing slow. Too hot. Meat Meat files it."),
          cl(:reptin, "(quietly) The pulse is wrong. She's right.")].compact)
    set_flag(:summer_imbalance_seen)
    # Heightened Summer-Sense (rootspire.md 5150-5156): for the next day, the
    # first thing that moves with heat doesn't get past her (048_H uses it).
    state[:summer_sense_day] = rs_day
    say(["(#{herald?(:meat_meat) ? 'Your' : "Meat Meat's"} skin prickles every time the heat moves. Heightened Summer-Sense.)",
         "(For the next day, the first warm thing that moves won't get past #{herald?(:meat_meat) ? 'you' : 'her'}.)"])
    dt_step!(:meat_meat)
  end

  def summer_sense?
    with_or_is?(:meat_meat) && state[:summer_sense_day] && rs_day <= state[:summer_sense_day] + 1 && !flag?(:summer_sense_used)
  end

  #-----------------------------------------------------------------------------
  # Alberica: the Memory Codex, and the rumours
  #-----------------------------------------------------------------------------
  # The Lorn Scribe: he works for the World Tree; he can't die (struck, he turns
  # to script and writes himself back); he keeps pages of Alberica's journal.
  # The four riddles, written down where the player can find them again
  # (context 15, M15-3): plain, with the place names that answer them.
  # (notes/15 E13: one riddle a visit, and its Herald answers it.)
  SCRIBE_RIDDLES = [
    [:scribe_key, :alberica, :key_found, "The Lorn Scribe's riddle for Alberica: a key 'where the year sleeps', in the Library.",
     "LORN SCRIBE: The key is in this room. It always was. Begin where the year sleeps.",
     "This room. Of course it's this room. It's where I'd have hidden it."],
    [:scribe_blade, :meat_meat, :blade_found, "His riddle for Meat Meat: a blade in the silt where the boats froze. The Split Dock.",
     "LORN SCRIBE: The blade sleeps in the silt where the boats were frozen.",
     "Silt. Frozen boats. Meat Meat knows the Split Dock. Meat Meat will dig."],
    [:scribe_staff, :reptin, :staff_found, "His riddle for Reptin: a staff with the first Wardens, in clear sap. The Crypt.",
     "LORN SCRIBE: The staff stands with the first Wardens, in sap clear as glass.",
     "First Wardens. In sap. I know where that is."],
    [:scribe_mantle, :alerion, :mantle_found, "His riddle for Alerion: a mantle where the world stops. The Auroral Wall.",
     "LORN SCRIBE: The mantle waits where the world stops, at the wall of light.",
     "The Wall. Where the world stops."]
  ]

  def lorn_scribe(event_id = nil)
    given = (state[:scribe_given] ||= [])
    first = !flag?(:scribe_met)
    if first
      set_flag(:scribe_met)
      say(["An old dwarf draped in frost-paper scrolls writes without looking.",
           "His eyes are milky, inked with runes."], event_id)
      if with_or_is?(:alberica)
        say([as(:alberica, "Who are you writing all that for, sugar?")])
      end
      say(["LORN SCRIBE: (still writing) The tree. Not the Council. Not the College.",
           "LORN SCRIBE: The World Tree dreams, and I write its dreams down, so it remembers them.",
           journey? ? "LORN SCRIBE: Four riddles, kept for the Heralds. You'll do to carry them, Herald's friend." :
                      "LORN SCRIBE: (not looking up) Four of you. Four riddles. One at a time. The ink is slow."], event_id)
    elsif flag?(:key_found) && !flag?(:scribe_backwards)
      set_flag(:scribe_backwards)
      talk(:lorn_scribe, event_id)      # (026: he writes backwards, once the key's found)
    end
    row = SCRIBE_RIDDLES.find { |key, who, done, *_| !given.include?(key) && !flag?(done) && with_or_is?(who) }
    if row
      key, who, done, goal, riddle, answer = row
      given << key
      say([riddle], event_id)
      sayc([cl(who, answer)].compact)
      side_goal(key, herald?(who) ? goal.sub(/for (Alberica|Meat Meat|Reptin|Alerion)/, "for you") : goal, done: done)
      left = SCRIBE_RIDDLES.count { |k, w, d, *_| !given.include?(k) && !flag?(d) && with_or_is?(w) }
      say([left > 0 ? "LORN SCRIBE: Come back when that one's found. There are #{left} more." :
                      "LORN SCRIBE: That's the last of them. Go on. The tree's waiting."], event_id) if first || left > 0
    elsif !first && !flag?(:lorn_known)
      # (his own story, on a later visit: a want, and a cost)
      set_flag(:lorn_known)
      say(["LORN SCRIBE: (still writing) They tried to kill me once. A Summer zealot with an axe.",
           "LORN SCRIBE: I became ink, and wrote myself back. It took a week.",
           "LORN SCRIBE: My handwriting has never been the same."], event_id)
    elsif !first
      say(["LORN SCRIBE: (still writing) The riddles are given. The ink is drying. Go and find them."], event_id)
    end
    if with_or_is?(:alberica) && !flag?(:codex_given)
      say(["LORN SCRIBE: (stopping. For the first time, the quill stops.) Keeper of Memory.",
           "He draws out a sheaf of pages: paper older than the tree, in Alberica's hand.",
           "LORN SCRIBE: Your journal. The pages you lost in the white. The tree found them."], event_id)
      sayc([cl(:alberica, "(very still) I wrote those in the snow. I burned the rest for warmth.")].compact)
      if pbConfirmMessage(_INTL(herald?(:alberica) ? "Take the pages?" : "Let Alberica take the pages?"))
        set_flag(:codex_given)
        say(["LORN SCRIBE: Bind them. Write on the first blank page. The tree will do the rest."], event_id)
        give_key(:FT_MEMORYCODEX)
        say(["(#{herald?(:alberica) ? 'You' : 'Alberica'} will want to sit with it somewhere quiet. The Hearth, in the morning.)"])
      else
        say(["LORN SCRIBE: Then they'll keep. Paper's patient. So am I."], event_id)
      end
    end
  end

  # The Codex over two mornings (notes/15 E14): the first two fragments, then the last two.
  def memory_codex_day
    me = herald?(:alberica)
    if flag?(:codex_fragment_1) && !flag?(:codex_fragment_2)
      # (the morning after she stopped at the first fragment)
      say(["The Codex is warm on the bark floor, where #{me ? 'you' : 'Alberica'} left it. It opens by itself.",
           "#{me ? 'You pick' : 'Alberica picks'} up the quill again."])
      Stage.overlay("O-03", above_panels: true, fade: 20) rescue nil
      codex_fragment_two
      return
    end
    if !flag?(:codex_fragment_2)
      say(["Morning, through the Hearth's leaf-glass. #{me ? 'You sit' : 'Alberica sits'} cross-legged with the Codex.",
           "The moment ink touches the first blank page, the room shifts, like a slow wheel turning.",
           "The hum of the tree deepens, almost a voice:",
           "\"You have been here before... and not yet... and again still...\""])
      Stage.overlay("O-03", above_panels: true, fade: 20) rescue nil
      say(["FRAGMENT ONE. Dougan's Hole, the day it became Rootspire.",
           "A child's laughter. A sapling splitting frost. #{me ? 'Your' : 'Her'} own hand, touching the sprout.",
           "#{me ? 'You' : 'She'} wasn't only there when the Verdant Reversal happened. #{me ? 'You were' : 'She was'} anchoring it.",
           "The Codex drinks the fragment. The ink glows gold."])
      set_flag(:codex_fragment_1)
      if !pbConfirmMessage(_INTL(me ? "Keep writing?" : "Alberica's hand is shaking. Keep going?"))
        Stage.overlay_off("O-03", fade: 20) rescue nil
        say(["#{me ? 'You close' : 'Alberica closes'} the Codex. The ink glows on through the cover. It'll wait."])
        dt_step!(:alberica)
        return
      end
      codex_fragment_two
      return
    end
    say(["The next morning, the Codex opens on its own at the third blank page.",
         "#{me ? 'You pick' : 'Alberica picks'} up the quill. It's already wet."])
    Stage.overlay("O-03", above_panels: true, fade: 20) rescue nil
    say(["FRAGMENT THREE. The Council's missing pages.",
         "The quill moves on its own. A circle, cracked. Three names crossed out. A fourth, blank.",
         "The Council of Seasons is younger than Rootspire claims. Someone is missing from it."])
    set_flag(:codex_fragment_3)
    say(["FRAGMENT FOUR. #{me ? 'Your' : 'Her'} own echo.",
         "A ghost-image: #{me ? 'you' : 'Alberica'}, under the Rift. Older. Brighter. A World-Tree staff in hand.",
         "The older one gestures, and wind brushes the younger one's cheek through the memory.",
         "A warning, carried backward.",
         "Then the image collapses into ink. The Codex closes itself with a soft thrum."])
    Stage.overlay_off("O-03", fade: 20) rescue nil
    set_flag(:codex_fragment_4)
    set_flag(:codex_fragments)
    say(["#{me ? 'You come' : 'Alberica comes'} to, and the whole day has gone. #{me ? "You're" : "She's"} starving."])
    dt_step!(:alberica)
    wheel(1)
    add_counter(:story_beats)
    alberica_rumours
  end

  def codex_fragment_two
    me = herald?(:alberica)
    say(["FRAGMENT TWO. A shadow in the future.",
         "The ink turns cold. The page curls, frostbitten.",
         "A figure outlined in pale flame, eyes like ice-splinters, watching across centuries.",
         "Not for #{me ? 'your' : "Alberica's"} power. For #{me ? 'your' : 'her'} memories.",
         "It isn't only hunting wyrmlings. It's hunting a timeline."])
    Stage.overlay_off("O-03", fade: 20) rescue nil
    set_flag(:codex_fragment_2)
    say(["The Codex closes itself with a soft thrum. Two pages more, and they won't come today."])
    sayc([cl(:meat_meat, "(sliding a plate across) Meat Meat saved you the good bread. Most of it."),
          cl(:alberica, "(very quietly, a hand flat on the Codex) Anchoring it. I was anchoring it.")].compact)
    dt_step!(:alberica)
  end

  def alberica_rumours
    return if !with_or_is?(:alberica) || flag?(:alberica_rumours)
    set_flag(:alberica_rumours)
    say(["The next day #{herald?(:alberica) ? 'you spend' : 'Alberica spends'} carousing: taverns, the market, every stall that'll talk.",
         "By night #{herald?(:alberica) ? 'you know' : 'she knows'} what Rootspire's afraid of:"])
    TAVERN_RUMOURS.each do |f, line|
      set_flag(f)
      say([line])
    end
    dt_step!(:alberica) if dt_ready?(:alberica)
    # (the Codex day and the carousing are two days: context 15 §5)
    if state[:rs_day] && flag?(:rite_stopped) && respond_to?(:festival_nights_left) && festival_nights_left > 2 && !flag?(:festival_night)
      state[:rs_day] += 1
      (state[:dt_day] ||= {})[:alberica] = rs_day if with_or_is?(:alberica)   # (she spent both days)
      n = festival_nights_left
      say(["(Two days go by like that. The festival's last night is in #{n} night#{n == 1 ? '' : 's'}.)"])
    end
  end

  #-----------------------------------------------------------------------------
  # The Festival of Returning Light (024's scene_festival_night calls these)
  #-----------------------------------------------------------------------------
  def festival_opening
    say(["The seventh night breaks warm, like a breath drawn before a long-awaited song.",
         "The Festival Circle at the market's heart is strung with frost-glass lanterns. Pipes play.",
         "Children run ahead scattering blossoms, with wyrmling effigies: one white, one green.",
         "The Rootwardens form an honour guard along the root-walk, spears garlanded.",
         "Round the Circle's rim, a mural is carved into the living bark: the Heralds' deeds.",
         "Nobody sees the figures move. But every time you look back, they stand differently."])
  end

  def festival_toast
    # (dialogue 06 §4: a toast with something in it)
    say(["KELYN: (raising a chalice) To the five on the wall. And the sixth we never could carve.",
         "KELYN: We're the children of the Reversal, every one. And our Heralds are home."])
    say(["By the empty Summer Throne, the golden vines are dry and brittle. One is charred black.",
         "Warm sap drips under the chair. Archivist Eirwen watches it drip, frowning. Watching."])
    festival_effigy
  end

  # The Cycle Day Conspiracy (rootspire.md 8494-8513, GQ3): the Frost Saint
  # cult's lanterns, the effigy and Auril's Icy Avatar. Played out in full by
  # cycle_day_conspiracy (048_H).
  def festival_effigy
    return if flag?(:effigy_saved) || flag?(:cycle_day_done)
    cycle_day_conspiracy
  end

  def festival_shudder_extras
    sayc([with_or_is?(:glimmer) ? "The Lumen Shard in #{herald?(:glimmer) ? 'your' : "Glimmer's"} chest flashes a painful white." : nil,
          flag?(:twins_met) ? "On the Hall's roof, Razzilith stiffens, nose to the roots, and growls. He doesn't stop." : nil,
          with_or_is?(:alberica) ? (herald?(:alberica) ? "(Every memory-thread you hold trembles at once, like a web touched.)" :
                                                         "Alberica's hand goes to her chest. Every memory-thread she holds is trembling.") : nil].compact)
  end

  def festival_voices
    # (dialogue 06 §4: what the leaves did, not what the Heralds heard from Darrus)
    say([flag?(:met_eirwen) ? "EIRWEN: (quietly, beside you) The leaves wrote that down. They've never written a shudder." :
                              "EIRWEN: (quietly, beside you) Eirwen, of the Library. The leaves have never shuddered.",
         "LIRIELLE: (a grey-furred Wennen, fur on end) Heat on the wind. Someone's rewriting it."])
  end

  #-----------------------------------------------------------------------------
  # Eirwen's private audience (after the chardalyn fragment)
  #-----------------------------------------------------------------------------
  def eirwen_audience_due? = flag?(:chardalyn_found) && !flag?(:eirwen_audience) && !flag?(:barricade_entered)

  def eirwen_audience(event_id = nil)
    set_flag(:eirwen_audience)
    say(["EIRWEN: (closing the Library's doors behind you, one after another) Not here. Further in.",
         "In a room of crystal leaves nobody else may enter, they unroll the oldest map of all.",
         "EIRWEN: Look. The Twenty Stones of Thruun. The old circle. Here.",
         "EIRWEN: And Rootspire, drawn over it. The Stones lie right under us. Under the Heartroot.",
         "EIRWEN: A passage, sealed since the Reversal. Under the Root-Gate, past the Guild Dig.",
         "EIRWEN: The old maps end it at a door. Iron and glass.",
         "EIRWEN: It began humming two nights ago. The leaves lining it are writing down hammers."], event_id)
    if ($PokemonBag.pbHasItem?(:FT_CHARDALYN) rescue false)
      say(["Eirwen looks at the chardalyn fragment for a long time without touching it.",
           "EIRWEN: That came up from there. I'd stake the Library on it."])
    end
    sayc([cl(:alerion, "Then that's where we go."),
          cl(:reptin, "Down. It's always down.")].compact)
    # (the runner is at the door when they speak: WRITING_GUIDE §9a)
    slot = (Stage.free_slot || Stage.near_slot) rescue nil
    Stage.actor(:runner, slot[0], slot[1], 4, graphic: "BW (84)") if slot
    say(["A runner at the doors: the Verdant Council issues a formal summons.",
         "RUNNER: \"Heralds. Something awakens below. The Speaker asks for you in the Hall. Now.\""])
    add_counter(:story_beats)
    council_summons if respond_to?(:council_summons)     # Kelyn gives the mission; the roads down open (024)
    true
  end

  #-----------------------------------------------------------------------------
  # The Echo Codex: Auroral Echoes, the chronal songs the wind keeps
  #-----------------------------------------------------------------------------
  ECHO_SPOTS = {
    2050 => [:echo_gate_song, "the Echo Gate's wind", "A song about a girl who walked into the snow, and out again centuries later, laughing."],
    2061 => [:canopy_song, "the Canopy's leaves", "A lullaby in Old Wennen, sung to two eggs. One verse for the green, one for the white."],
    2055 => [:glasswater_song, "the Glasswater", "A rowing chant from a crew that never came home. They're still keeping time."],
    2062 => [:library_song, "the Library's leaves", "A Herald's voice, singing in a square: Alberica's, though it hasn't happened yet."]
  }

  def echo_codex_use
    spot = ECHO_SPOTS[$game_map.map_id]
    if !spot
      recorded = ECHO_SPOTS.values.select { |f, _, _| flag?(f) }
      return pbMessage(_INTL("The crystal leaves are quiet. Nothing here remembers a song.")) if recorded.empty?
      recorded.each { |_, where, song| pbMessage(_INTL("(From {1}:)", where)); pbMessage(_INTL("{1}", song)) }
      return
    end
    f, where, song = spot
    if flag?(f)
      pbMessage(_INTL("The Codex whispers {1}'s song back to you:", where))
      return pbMessage(_INTL("{1}", song))
    end
    set_flag(f)
    pbSEPlay("Saint1") rescue nil
    pbMessage(_INTL("The Echo Codex's leaves shiver. It's recording {1}: an Auroral Echo.", where))
    pbMessage(_INTL("{1}", song))
    if ECHO_SPOTS.values.all? { |k, _, _| flag?(k) } && !flag?(:echoes_complete)
      set_flag(:echoes_complete)
      pbMessage(_INTL("All four Auroral Echoes are in the Codex. Old Yorin the Chanter would want to hear them."))
    end
  end

  def compass_use
    thin = { 2050 => "west, to the Echo Gate", 2055 => "down, into the Glasswater", 2061 => "up, to the Celestial Rift",
             2060 => "north, to the Auroral Wall", 2062 => "into the locked case of leaves" }
    to = thin[$game_map.map_id]
    pbMessage(_INTL(to ? "The Auroral Compass's needle ignores north and swings {1}. The world's thin there." :
                         "The Auroral Compass's needle spins slowly. Nowhere near here is thin.", to))
  end
end

#-------------------------------------------------------------------------------
# The new goods in use
#-------------------------------------------------------------------------------
if defined?(ItemHandlers::UseOnPokemon)
  FrostThaw.module_eval do
    module_function

    def ft_potion_use(pkmn, scene, hp, cure)
      if pkmn.fainted? || (pkmn.hp == pkmn.totalhp && (!cure || pkmn.status == :NONE))
        scene.pbDisplay(_INTL("It won't have any effect."))
        return false
      end
      cured = cure && pkmn.status != :NONE
      pkmn.heal_status if cured
      healed = hp > 0 ? pbItemRestoreHP(pkmn, hp) : 0
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, healed)) if healed > 0
      scene.pbDisplay(_INTL("{1} is in perfect health.", pkmn.name)) if cured
      true
    end
  end

  { FT_SANGUINETONIC: [70, false], FT_VITALITYPHIAL: [20, true], FT_RENEWALDRAUGHT: [100, true] }.each do |item, (hp, cure)|
    ItemHandlers::UseOnPokemon.add(item, proc { |_item, pkmn, scene| FrostThaw.ft_potion_use(pkmn, scene, hp, cure) })
    ItemHandlers::BattleUseOnPokemon.add(item, proc { |_item, pokemon, battler, _choices, scene|
      if cure
        if battler && battler.status != :NONE
          battler.pbCureStatus(false)
        elsif pokemon.status != :NONE
          pokemon.heal_status
        end
      end
      pbBattleHPItem(pokemon, battler, hp, scene)
      next true
    })
    ItemHandlers::CanUseInBattle.add(item, proc { |_item, pokemon, battler, _move, _first, _battle, scene, show|
      if !pokemon.able? || (pokemon.hp == pokemon.totalhp && (!cure || pokemon.status == :NONE))
        scene.pbDisplay(_INTL("It won't have any effect.")) if show
        next false
      end
      next true
    }) if defined?(ItemHandlers::CanUseInBattle)
  end

  if defined?(ItemHandlers::BattleUseOnBattler)
    ItemHandlers::BattleUseOnBattler.add(:FT_EMBERLEAF, proc { |_item, battler, scene|
      battler.pbRaiseStatStage(:ATTACK, 1, battler) if battler.pbCanRaiseStatStage?(:ATTACK, battler)
      battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, battler) if battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK, battler)
      scene.pbDisplay(_INTL("{1}'s eyes shimmer green-gold!", battler.pbThis))
      battler.pokemon.changeHappiness("battleitem") rescue nil
    })
    ItemHandlers::CanUseInBattle.add(:FT_EMBERLEAF, proc { |_item, _pokemon, battler, _move, _first, _battle, scene, show|
      if !battler || (!battler.pbCanRaiseStatStage?(:ATTACK, battler) && !battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK, battler))
        scene.pbDisplay(_INTL("It won't have any effect.")) if show
        next false
      end
      next true
    }) if defined?(ItemHandlers::CanUseInBattle)
  end

  ItemHandlers::UseInField.add(:FT_MEMORYCODEX, proc { |_item|
    if !FrostThaw.flag?(:codex_fragment_1)
      pbMessage(_INTL("The first page is blank. It wants writing somewhere quiet. In the morning, at the Hearth."))
    else
      pbMessage(_INTL("One: Alberica's hand on the sprout, anchoring the Reversal."))
      pbMessage(_INTL("Two: a figure in pale flame, hunting a timeline.")) if FrostThaw.flag?(:codex_fragment_2)
      pbMessage(_INTL("Three: three names crossed out, a fourth left blank.")) if FrostThaw.flag?(:codex_fragment_3)
      pbMessage(_INTL("Four: an older Alberica under the Celestial Rift, with a World-Tree staff.")) if FrostThaw.flag?(:codex_fragment_4)
      pbMessage(_INTL("(The rest of the pages are still blank. Another morning.)")) if !FrostThaw.flag?(:codex_fragments)
    end
    next 1
  })
  ItemHandlers::UseInField.add(:FT_ECHOCODEX, proc { |_item| FrostThaw.echo_codex_use; next 1 })
  ItemHandlers::UseInField.add(:FT_AURORALCOMPASS, proc { |_item| FrostThaw.compass_use; next 1 })
end

#-------------------------------------------------------------------------------
# The Loop-Band: half as many wild Pokémon in grass
#-------------------------------------------------------------------------------
if defined?(PokemonEncounters) && PokemonEncounters.method_defined?(:encounter_triggered?)
  class PokemonEncounters
    alias ft_loopband_encounter_triggered? encounter_triggered? unless method_defined?(:ft_loopband_encounter_triggered?)
    def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
      ret = ft_loopband_encounter_triggered?(enc_type, repel_active, triggered_by_step)
      if ret && triggered_by_step && FrostThaw.active? && $PokemonBag &&
         ($PokemonBag.pbHasItem?(:FT_LOOPBAND) rescue false) &&
         (GameData::EncounterType.get(enc_type).type == :land rescue enc_type.to_s.start_with?("Land"))
        return false if rand(2) == 0
      end
      return ret
    end
  end
end
