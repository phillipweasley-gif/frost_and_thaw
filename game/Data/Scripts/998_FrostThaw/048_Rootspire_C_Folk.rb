#===============================================================================
# Frost & Thaw - Rootspire as a living city (part C): the "20 New Rootspire
# NPCs (Campaign-Integrated)", each with an outward face and a secret, and the
# Bazaar's mirror stall (the first half of "Mirror, Mirror").
#
# Scene pass (notes/15 E1, E8, E10): every first meeting that has a second beat
# ends on a hook the player can act on, and when the second beat is ready the
# person notices you and comes over (GIVERS, 048_G); people speak where they
# stand; each secret answers to its own flag.
#===============================================================================
module FrostThaw
  module_function

  #-----------------------------------------------------------------------------
  # 1. Talwyn Frostrill: a Rootwarden initiate who has decided you are Frostina's
  # chosen, and follows you everywhere to prove it.
  #-----------------------------------------------------------------------------
  def talwyn(event_id = nil)
    n = (state[:talwyn] ||= 0)
    case n
    when 0
      say(["A Rootwarden initiate with platinum braids and ice-bitten hands nearly walks into you.",
           "TALWYN: Oh! #{herald?(:wyn) ? 'Wyn! And Heralds' : 'Heralds'}! I'm Talwyn. Talwyn Frostrill. Initiate. Bough circle. Nearly.",
           "TALWYN: I can help! I'm a guard. A junior guard. A nearly-guard.",
           "TALWYN: Do you need anything guarded? I'm very good at standing near things.",
           "She fidgets with her belt the whole time."], event_id)
      set_switch(SW_TALWYN_FIELDS, true)
    when 1
      say(["TALWYN: You came back! I knew you would. I saw you go up the root-stair. And down.",
           "TALWYN: Not following. Guarding. From a distance. A respectful distance."], event_id)
    else
      say(["TALWYN: (very fast) I'm writing down everything you do. For the Hall. Sorry. Hi."], event_id)
    end
    state[:talwyn] = n + 1
    talwyn_secret(event_id) if state[:talwyn] >= 3
  end

  # Met again out in the Blooming Fields: the secret.
  def talwyn_fields(event_id = nil)
    state[:talwyn] = (state[:talwyn] || 0) + 1
    talwyn_secret(event_id)
  end

  def talwyn_secret(event_id = nil)
    if flag?(:talwyn_told)
      cover = ($game_map.map_id rescue 0) == 2060 ? "a snowdrift" : "a pillar"
      return say(["TALWYN: (waving from behind #{cover}) Still guarding! Don't mind me!"], event_id)
    end
    set_flag(:talwyn_told)
    say(["Talwyn stops fidgeting. For once she speaks slowly.",
         "TALWYN: I was on night watch, the week before you came. Over the market well.",
         "TALWYN: The white dragon came down out of the aurora. She circled the Heartroot. An hour.",
         "TALWYN: Like she was waiting for someone to come up out of it. Or go down.",
         "Her hands have gone still on her belt.",
         "TALWYN: Then you came out of a lantern. And she landed for you.",
         with_or_is?(:alerion) ? "TALWYN: (looking straight at #{herald?(:alerion) ? 'you' : 'Alerion'}) One of you is hers. Her chosen." :
                                 "TALWYN: One of you is hers. Her chosen. I know it.",
         "TALWYN: I'm going to be there when you find out."], event_id)
    sayc([herald?(:alerion) ? "(Your ring goes cold. Then warm.)" : cl(:alerion, "(a hand on his ring) She landed for me. She's particular."),
          cl(:alberica, "Sweetheart, being somebody's chosen mostly means dragons shout at you. Ask him.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 2. Jorik Pinebellow: sap-barrel merchant on the docks, smuggling infernal
  # ore for Gorran (and so, without knowing it, for Summer).
  #-----------------------------------------------------------------------------
  def jorik(event_id = nil)
    if first_time?(:met_jorik)
      say(["A barrel-chested dwarf, pine twigs braided into his amber beard, laughs too loudly.",
           "JORIK: HA! Warm-sap brew, Heralds! Jorik Pinebellow's own! Warms you down to the boots!",
           "JORIK: HA! ...Ha."], event_id)
    elsif flag?(:dock_ore_seen) && !flag?(:jorik_confessed)
      # (notes/15 E6: you choose to bring it up)
      if !pbConfirmMessage(_INTL("Ask Jorik about the black grit by his barrels?"))
        return say(["JORIK: HA! Brew? Brew. Brew's good. Everything's good."], event_id)
      end
      set_flag(:jorik_confessed)
      say(["You point at the black grit still caught between the planks by his barrels.",
           "JORIK: HA! That? Fell off a boat. From the south. Boats from the south drop all sorts of-",
           "He stops laughing. He looks very tired.",
           "JORIK: It's ore. Warm ore. From the old Guild tunnels under the dock. The Smuggler's Run.",
           "JORIK: Gorran pays me to carry it up. Special commissions. I don't ask. I carry barrels."], event_id)
      sayc([cl(:reptin, "Thank you, Jorik. That was brave. Have a drink. One of yours.")].compact)
      say(["JORIK: The hatch by the split crate. I'll... I'll leave it unbarred. Don't tell Gorran.",
           "JORIK: He gets warm when he's angry. Properly warm."], event_id)
      set_switch(SW_RUN_OPEN, true)
      sayc([cl(:meat_meat, "Meat Meat saw that ore before. On these planks. Dock man swept it. He lied."),
            "JORIK: (as you go) Ash meets the barrels himself. Nobody checks a Rootwarden."].compact, event_id)
      side_goal(:smugglers_run, "The Smuggler's Run: the hatch by the split crate, on the Split Dock. Jorik's opened it.",
                done: [:ore_found, :summer_ended])
    else
      say(["JORIK: HA! Brew? Brew. Brew's good. Everything's good."], event_id)
    end
  end

  # Meat Meat's undercity walk turns this up; anyone can, after.
  def dock_ore(event_id = nil)
    if flag?(:dock_ore_seen)
      return say(["Between the planks by Jorik's barrels: a little black grit that's warmer than the planks."], event_id)
    end
    set_flag(:dock_ore_seen)
    say(["A half-rotted crate by the barrels has spilled shimmering black grit across the boards.",
         "It's ore. But wrong. It's faintly warm, and smells like smoke shut up inside a stone.",
         "A dockworker panics, sweeps it into the water, and says it fell off a boat from the south.",
         "It absolutely did NOT come from the sap-mines. He says that twice."], event_id)
  end

  #-----------------------------------------------------------------------------
  # 3. Serelle of the Still Veil: a spirit-tender with visions of Avarice
  # forging "a god of light made wrong".
  #-----------------------------------------------------------------------------
  def serelle(event_id = nil)
    if first_time?(:met_serelle)
      say(["By a funeral shrine of leaves, a woman in a frost-silk veil hums a dirge with no tune.",
           "SERELLE: I keep the rites for those the tree takes back. Serelle. Of the Still Veil.",
           "SERELLE: You are not dead. How unusual, for people of your age.",
           # (her warning in her own lens, burials: dialogue 15 §2; and a hook for the second beat: notes/15 E1)
           "SERELLE: No bodies from the Root-Tier in a month. They go down. They don't come up.",
           "SERELLE: The dead have been showing me where. Come back, if you can bear to hear it."], event_id)
      return
    end
    if flag?(:serelle_vision)
      return say(["SERELLE: (between verses) The same forge. The same wrong god. I won't tell it twice."], event_id)
    end
    giver_hello(event_id) if respond_to?(:giver_hello)
    set_flag(:serelle_vision)
    say(["SERELLE: (between verses) You came back. Then hear what the dead are showing me.",
         "SERELLE: Under the Heartroot, a forge. Someone at it, hammering light into a shape.",
         "SERELLE: Wings. A crown. A god of light, made wrong, of something that remembers cold.",
         "She hums one bar of the dirge.",
         "SERELLE: Every time it's struck, somebody somewhere forgets their own name.",
         "She goes back to humming. The dirge has a melody now. You wish it didn't."], event_id)
    sayc([cl(:glimmer, "(very quiet) Brightmane has wings like that."),
          cl(:alberica, "Darling, nobody forges a god. They forge a very large problem and call it holy.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 4. Pimmlet Natch: an auroral librarian hiding a forbidden scroll, "Shimmer's
  # Heart" (the ritual that made the Frost Wyrmling).
  #-----------------------------------------------------------------------------
  def pimmlet_ready? = flag?(:met_pimmlet) && !flag?(:shimmers_heart_scroll) &&
                       (with_or_is?(:glimmer) || with_or_is?(:shade) || flag?(:twins_met))

  def pimmlet(event_id = nil)
    if first_time?(:met_pimmlet)
      say(["A gnome with enormous round lenses that magnify two anxious eyes looks up from a ladder.",
           "PIMMLET: Shhh. ...Sorry. Shhh. Habit. Pimmlet Natch. Auroral Librarian. Shhh.",
           "He's whispering \"shhh\" to nobody, even when nobody is talking."], event_id)
      # The Journey kid runs the College's errands (context 15 §6): somebody knows them.
      say(["PIMMLET: Shhh. ...You're Wynsnow's runner. You were gone a whole HOUR. Shhh."], event_id) if journey?
      # (a hook for the scroll: notes/15 E1)
      say(["PIMMLET: Don't ask me about the scroll. There isn't a scroll. Shhh. Not that one."], event_id)
      return
    end
    if pimmlet_ready?
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:shimmers_heart_scroll)
      say(["PIMMLET: (very quietly, glancing at the shelves as if they'll tell) Shhh. Come here. Shhh.",
           "PIMMLET: I'm not supposed to have this. Solvaran thinks it's locked under the floor.",
           "He unrolls a scroll of crystal leaf. A title in old Wennen: SHIMMER'S HEART."], event_id)
      say(["PIMMLET: The ritual that made the white wyrmling. A heart of ice, given willingly.",
           "PIMMLET: Put into a frost egg, and sung over with four notes. The same four. Every time."], event_id)
      sayc([with_or_is?(:glimmer) ? cl(:glimmer, "(quietly, humming the four notes, off-key) ...") :
                                    cl(:shade, "(staring at the four notes) That's her song. That's Shimmer's song.")].compact)
      say(["PIMMLET: It says the egg doesn't hatch a dragon. It hatches an answer.",
           "PIMMLET: An answer to what? It doesn't say. Shhh. I've read it nine hundred times."], event_id)
      sayc([with_or_is?(:glimmer) ? cl(:glimmer, "She was always the answer. She just never let us ask the question.") : nil,
            cl(:alerion, "An answer. To Auril.")].compact)
    else
      say(["PIMMLET: Shhh. ...Sorry. Shhh."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 5. Reva Mosscut: her floral sculpture of the Heralds hides a vine-person she
  # grew for Autumn's illusions (a spy). She owns up once you've caught one of
  # Lumea's watchers (notes/15 E8a: Lumea's, not Maera's).
  #-----------------------------------------------------------------------------
  def reva(event_id = nil)
    if !flag?(:met_reva)
      set_flag(:met_reva)
      return talk(:reva, event_id)
    end
    if (flag?(:watcher_moth_swarm) || flag?(:watcher_rune_beetle)) && !flag?(:reva_confessed)
      set_flag(:reva_confessed)
      say(["The sculpture of the Heralds turns its flower-head, just slightly, to follow you.",
           "Reva's head tilts sharply. Her ears go flat.",
           "REVA: ...It's not a sculpture. Not all of it. The fifth one, at the back. A vine-person.",
           "REVA: Lumea asked. For the Court. It listens, and tells her what you say to each other."], event_id)
      say(["REVA: I didn't think it was hurting anyone. It's so pretty. The best thing I ever grew.",
           "REVA: I'll... I'll plant it out in the Fields. Somewhere nobody talks."], event_id)
      sayc([cl(:reptin, "Plant it where it can grow into something that isn't a spy, Reva. That's all."),
            cl(:meat_meat, "Meat Meat said rude things near the flowers. Meat Meat does not regret it.")].compact)
      return
    end
    talk(:reva, event_id)
  end

  #-----------------------------------------------------------------------------
  # 7. Mistress Felka Thornhand: the Heartroot's archivist. She found a mirror
  # shard that speaks in Avarice's voice, and hid it in the roots.
  #-----------------------------------------------------------------------------
  def felka_ready? = flag?(:met_felka) && flag?(:ch7_started) && !flag?(:felka_shard)

  def felka(event_id = nil)
    if first_time?(:met_felka)
      say(["By the sealed Root-Gate stands a woman with bark for skin, her hands wrapped in thorns.",
           "FELKA: (a soft monotone) Mistress Felka Thornhand. I keep the labyrinth's records.",
           "FELKA: The gate is sealed. It has been before. It always opens. That's what gates do.",
           # (a hook, and a chapter gate said aloud: notes/15 E1, E16)
           "FELKA: When it opens, find me. I have something I need to give away."], event_id)
      return
    end
    if felka_ready?
      if flag?(:felka_offered)
        # (notes/15 E9: the second time, straight to the ask)
        say(["FELKA: (holding out the coil of root) Please. Take it, and break it far from the tree."], event_id)
      else
        giver_hello(event_id) if respond_to?(:giver_hello)
        set_flag(:felka_offered)
        say(["FELKA: (a monotone, but her thorny hands are shaking) You go down. Then take it.",
             "She lifts a coil of root aside. Inside it, a palm-sized shard of mirror, pulsing faintly.",
             "A woman's voice, pleasant and precise: \"Every glass is an eye, Felka.\"",
             "\"You can't hide an eye in the dark.\"",
             "FELKA: I hid it in the roots. They don't like it. Break it where it can't see the tree."], event_id)
      end
      return if !pbConfirmMessage(_INTL("Take Felka's shard and break it?"))
      set_flag(:felka_shard)
      wheel(1)
      pbSEPlay("Ice1") rescue nil
      sayc(["You grind the shard under a heel, on the stone, away from the roots.",
            "The voice says \"Rude,\" very calmly, and then nothing at all.",
            "FELKA: ...Thank you. The outer ring is mine again.",
            cl(:alerion, "She talks through glass. Every glass. We'll need a lot of heels.")].compact, event_id)
    elsif !flag?(:ch7_started)
      say(["FELKA: The gate is still sealed. When it opens, find me."], event_id)
    else
      say(["FELKA: The roots are quiet today. That is either very good or I have stopped hearing them."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 8. Old Yorin the Chanter: touched by the time-fracture. His songs are what
  # will happen, disguised as rhyme. (Each sings the next turn of the story.)
  #-----------------------------------------------------------------------------
  YORIN_SONGS = [
    [->(t) { !t.flag?(:festival_night) },
     ["\"When the throne sits empty and the lanterns all are lit,",
      " the ground will clear its throat beneath, and something wake in it.\""]],
    [->(t) { !t.flag?(:engine_dead) },
     ["\"Down past the wells where the golden sap sings,",
      " a dragon of black glass is folding its wings.",
      " A cat made of gold will kneel down in the light,",
      " and a dagger come up from the fire burning bright.\""]],
    [->(t) { !t.flag?(:summer_ended) },
     ["\"The gold will go rose, and the rose will go pale,",
      " and a leaf will come down on the end of the tale.\""]],
    [->(t) { !t.flag?(:ch10_done) },
     ["\"Two dragons, two riders, a fall through the Wall,",
      " and a court made of crystal to listen to all.\""]],
    [->(t) { !t.flag?(:frostina_taken) },
     ["\"A saint who was frozen will breathe in the Shrine,",
      " and a white thing will sleep in a coffin of rime.\""]],
    [->(_t) { true },
     ["\"The wheel goes round, and round, and round,",
      " and what was lost is what is found.\""]]
  ]

  def yorin(event_id = nil)
    if first_time?(:met_yorin)
      say(["An old man with frost in his beard, in this heat, strums a lute to a crowd not listening.",
           "YORIN: Old Yorin the Chanter! Songs of things that happened! ...Will have happened.",
           "YORIN: Happen. Grammar's hard."], event_id)
    end
    i = YORIN_SONGS.index { |cond, _| cond.call(self) }
    song = YORIN_SONGS[i]
    sung = (state[:yorin_sung] ||= [])
    # (dialogue 15 §3: "never sung before" only the first time a song is sung)
    say([sung.include?(i) ? "YORIN: (strumming) One you know. Sing along if it scares you." :
                            "YORIN: (strumming) Here's one I've never sung before. Funny. I know every word."] + song[1], event_id)
    sung << i if !sung.include?(i)
    if i == 1 && with_or_is?(:glimmer) && first_time?(:yorin_gold_cat)
      sayc([cl(:glimmer, "(after a long moment) ...Catchy."),
            cl(:alberica, "I don't like that song, Yorin. Sing a different one. Sing a rude one.")].compact)
    end
  end

  #-----------------------------------------------------------------------------
  # 9. Dathra Spineshade: a trader of underdark curios, secretly hired by Avarice
  # to fetch Deepfire Quartz for the Eternal Summer Engine.
  #-----------------------------------------------------------------------------
  def dathra(event_id = nil)
    if first_time?(:met_dathra)
      say(["A woman with onyx skin and glowing teal eyes, in a spider-silk cloak, snaps her fingers.",
           "DATHRA: Dathra Spineshade. Curios from below. Below below. Not this kind of below.",
           "DATHRA: Glow-moss, lichen-wine, a very rude fossil. Deepfire Quartz, if you're rich."], event_id)
      return
    end
    if !flag?(:dathra_turned)
      say(["DATHRA: (snap) Deepfire Quartz. I've a buyer already. Pays in warm gold. Ten cases.",
           "DATHRA: (snap, snap) Hotter than anything up here. Hot enough to keep a summer forever."], event_id)
      c = pbMessage(_INTL("What do you say?"), [_INTL("\"Who's the buyer?\""), _INTL("\"We'll pay double. Don't sell it.\""), _INTL("\"Nothing.\"")], 2)
      case c
      when 0
        say(["DATHRA: (snap) Never seen her face. Nobody has. She sends a man with no reflection.",
             "DATHRA: ...You've gone very pale. Is that a normal colour for you?"], event_id)
        set_flag(:dathra_buyer)
      when 1
        if $Trainer.money >= 8000
          $Trainer.money -= 8000
          set_flag(:dathra_turned)
          wheel(1)
          say(["DATHRA: (counting) Double. Fine. Ten cases of Deepfire, at the bottom of the Glasswater.",
               "DATHRA: The buyer will be furious. I'll be somewhere else. I'm always somewhere else.",
               "She snaps her fingers once more, and smiles, for the first time."], event_id)
          sayc([cl(:reptin, "Eight thousand to keep a forge from getting warmer. Best money we've ever spent."),
                cl(:meat_meat, "Meat Meat would have bitten her for free.")].compact)
        else
          say(["DATHRA: (snap) Double is eight thousand. You have... less. Come back richer."], event_id)
        end
      end
    else
      say(["DATHRA: (snap) The bottom of the Glasswater is very peaceful. Ten cases of peace."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 10. Gurk Thistlebane: the Rootwardens' smith. A smith knows a blade: a Halo
  # knife brought in to be ground leads him to the Frozen Cellar. (dialogue 15
  # §2: Brogar's crystal arm is the smith who senses the forge; Gurk's a smith.)
  #-----------------------------------------------------------------------------
  def gurk(event_id = nil)
    if first_time?(:met_gurk)
      say(["A massive orc with silver-capped tusks wipes soot off a hammer with real tenderness.",
           "GURK: Gurk Thistlebane. I forge for the Wardens. Blood in the steel, storm in the quench.",
           "GURK: Bring me anything with an edge, and I'll tell you what it's cut."], event_id)
      return
    end
    if !flag?(:cellar_hint) && flag?(:rite_stopped)
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:cellar_hint)
      set_switch(SW_CELLAR_FOUND, true)
      say(["GURK: A Halo boy brought me a knife to grind last night. Frost on the blade. In summer.",
           "GURK: Paid me in coppers that stank of old beer. One place in the ring smells like that.",
           "He spits on the grindstone, and watches it hiss.",
           "GURK: The old Verdant Cask brewery, by the south steps. Thirty years shut.",
           "GURK: This morning, frost on its boards. A storm's coming up from under. Be the lightning."], event_id)
      sayc([cl(:alerion, "The Halo had another hideout. Rheven always said so."),
            cl(:wyn, "(quietly) The Frozen Cellar. The spores in the gardens talk about it. Nobody goes.")].compact)
      side_goal(:frozen_cellar, "The Frozen Cellar, under the old Verdant Cask brewery in the Verdant Halls.", done: :cellar_cleared)
    else
      say(["GURK: Quiet day at the anvil. Good. When it's loud, somebody's bleeding."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 11. Elitha Snowmere: a frost-glass artist. One of her sculptures is a prison
  # holding a sliver of Auril's will.
  #-----------------------------------------------------------------------------
  def elitha(event_id = nil)
    if first_time?(:met_elitha)
      say(["A woman with frost-white hair that drifts like falling snow gestures at her work.",
           "ELITHA: Elitha Snowmere. Frost-glass. Nothing melts here unless I let it.",
           "ELITHA: That one is my finest. A woman, dancing. Don't touch her. She bites."], event_id)
    elsif flag?(:sliver_freed)
      say(["ELITHA: My best work, ruined. I've never been happier."], event_id)
    else
      say(["ELITHA: (not looking at the dancer) She's been very still today. A good sign. Probably."], event_id)
    end
  end

  def elitha_sculpture(event_id = nil)
    if flag?(:sliver_freed)
      return say(["The sculpture's frost has gone clear and ordinary. A woman dancing. Only a woman."], event_id)
    end
    say(["A frost-glass dancer, life-sized. Inside the ice, something moves that isn't the light.",
         "A voice in your bones: \"Little vessel. Come closer. I'm so cold in here. Warm me.\"",
         herald?(:alberica) ? "(The rune on your chest burns.)" : (with_or_is?(:alberica) ? "Alberica puts a hand to her chest. Her rune is burning." : nil)].compact, event_id)
    # (notes/15 E10: she comes over, so the quiet line is said from beside you)
    eev = Stage.find("Elitha Snowmere")
    Stage.approach(eev) if eev
    say(["ELITHA: (very quietly) My grandmother's grandmother trapped it. Four hundred years ago.",
         "ELITHA: A sliver of Auril's will. It's been getting louder since you came. It knows her."])
    return if !pbConfirmMessage(_INTL("Break the sculpture and let the sliver out to fight?"))
    pbSEPlay("Ice1") rescue nil
    $game_screen.start_flash(Color.new(220, 240, 255, 200), 12) rescue nil
    say(["The frost-glass shatters. The sliver pours out, white and furious, a dancer with no face."])
    return if !boss_battle(named_mon(:B124H215, 43, "Sliver of Auril"))
    set_flag(:sliver_freed)
    add_counter(:story_beats)
    sayc(["The sliver comes apart into snow, and the snow melts before it lands.",
          "ELITHA: ...It's gone. Truly gone. Oh, my grandmother's grandmother would have wept.",
          "ELITHA: Take this. Frost-glass that never melts.",
          "ELITHA: It liked you. That's the worst thing I can say about it.",
          cl(:alberica, "(a hand on her chest) Quieter. The rune's quieter. ...Thank you, darling.")].compact)
    give(:NEVERMELTICE)
  end

  #-----------------------------------------------------------------------------
  # 12. Pellar Wicket: a courier who trips everywhere and never drops a package.
  # He carries coded notes between Autumn's spies.
  #-----------------------------------------------------------------------------
  def pellar(event_id = nil)
    if first_time?(:met_pellar)
      say(["A small, flushed halfling in a coat that is mostly pockets trips over nothing.",
           "He doesn't drop a thing.",
           "PELLAR: Pellar Wicket! Courier! Every tier, every hour! Never dropped a package. Ever!",
           "He trips again. Doesn't drop anything again."], event_id)
      return
    end
    if !flag?(:autumn_note) && flag?(:met_lumea)
      set_flag(:autumn_note)
      say(["PELLAR: Delivery for the Atelier, the Clothier, the Council, delivery for the-",
           "He trips. For the first time in his life, something falls out of a pocket. A folded leaf.",
           "He doesn't notice. He's already gone, apologising to a lamp-post.",
           "The leaf is covered in numbers. Under them, in Lumea's hand, decoded in careless pencil:",
           "\"K. is ready. Feed her the dream of a green crown.\"",
           "\"She'll use their relics to quicken the tree. Then Summer returns to a burning.\""], event_id)
      sayc([cl(:reptin, "One K on the Council. And she's been so very kind to us."),
            cl(:alberica, "Somebody's playing the High Speaker like a lute. Badly. With our things.")].compact)
    else
      say(["PELLAR: Can't stop! Can't stop! Never stop!"], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 13. Sister Selene Marr: an acolyte of the Twinned Dragons, writing scripture
  # about the Heralds as reincarnated demigods.
  #-----------------------------------------------------------------------------
  SELENE_VERSES = [
    ["\"And the Dwarf of Song held the seed in her hand,", "and the seed held four hundred years in it, and did not drop them.\""],
    ["\"And the Warden of Life and Death fed the wolves from his own bowl,", "and the wolves remembered for four hundred years.\""],
    ["\"And the Guardian of the Dark Half walked into the winter", "and taught it to kneel.\""],
    ["\"And the Guardian of the Light Half came up from the cold table,", "and called the green dragon by his name.\""],
    ["\"And the Sparkbearer stepped through the mirror,", "and the mirror gave him back as fire.\""]
  ]

  def selene(event_id = nil)
    if first_time?(:met_selene)
      say(["An acolyte with pale gold hair and mismatched eyes, one green, one icy blue, looks up.",
           "SELENE: Sister Selene Marr, of the Twinned Dragons. Frost and verdance are one- (she bows)",
           "SELENE: -blessed be the wheel- one faith. Oh. Oh, it's you. It's YOU.",
           "SELENE: I'm writing your scripture. You're demigods, reborn. You don't have to agree."], event_id)
    end
    i = (state[:selene_verse] ||= 0)
    say(["SELENE: (reading) The Book of the Heralds, verse #{i + 1}:"] + SELENE_VERSES[i % SELENE_VERSES.size], event_id)
    state[:selene_verse] = i + 1
    if i == 0
      sayc([cl(:alberica, "Darling, I've been called a lot of things. 'Demigod' is going on my door."),
            # (dialogue 15 §4: the joke is "again" only if she's heard Eirwen's book)
            flag?(:winter_returns_leaf) ? cl(:meat_meat, "Meat Meat is in a book again. Meat Meat wants a copy. With pictures.") :
                                          cl(:meat_meat, "Meat Meat is in a book. Meat Meat wants a copy. Alerion can read it to her.")].compact)
    elsif i == 2                      # (the verse about him)
      sayc([cl(:alerion, "...It didn't kneel.")].compact)
    end
  end

  #-----------------------------------------------------------------------------
  # 14. Krolf the Mossback: a hermit in the Echo Gate caverns who hears Sephek's
  # voice in the wind (and another voice, a boy's). The boy's voice is his own
  # beat (notes/15 E8b): the frozen hunter's Talion scene no longer locks it out.
  #-----------------------------------------------------------------------------
  def krolf(event_id = nil)
    if first_time?(:met_krolf)
      say(["By the Echo Gate sits a huge man covered in glowing moss, so still he could be a rock.",
           "KROLF: (very slowly, as if he's listening to someone else first) ...Krolf. Mossback.",
           "KROLF: The wind talks. Here. In the Gate. A man's voice. Cold. Always the same words.",
           "KROLF: \"The lake remembers.\" ...Then a long time, nothing. Then again.",
           "KROLF: (his head tilting) ...Lately, another voice. Come back. I'll listen for it."], event_id)
      return
    end
    if !flag?(:krolf_boy)
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:krolf_boy)
      set_flag(:talion_foreshadowed)
      say(["KROLF: (listening) ...The other voice. Small. A boy's.",
           "KROLF: \"You told me to stay in the house.\" He says. \"You said you'd come back.\"",
           "KROLF: The wind brings it off the lake, by the Glasswater's still edge.",
           "KROLF: The lake keeps what touches it. That's what the cold man means."], event_id)
      sayc([herald?(:alerion) ? "(You don't move. Your ring has gone so cold it burns.)" :
                                "Alerion doesn't move. His ring has frosted white.",
            herald?(:alerion) ? nil : cl(:alerion, "...Talion."),
            cl(:wyn, "(very gently) Alerion?"),
            herald?(:alerion) ? nil : cl(:alerion, "Not now. ...Not now.")].compact)
    else
      say(["KROLF: (listening) ...Quiet today. The wind is waiting for someone."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 15. Viessa Arialune: a candlewright whose candles flicker when Avarice's
  # magic is near. She's been mapping the places.
  #-----------------------------------------------------------------------------
  def viessa(event_id = nil)
    if first_time?(:met_viessa)
      say(["A half-elf in a wax-splattered apron, iron rings in her hair, lines up candles.",
           "She never looks at you.",
           "VIESSA: (to the candles) Scented candles. Pine, honey, frost. Viessa Arialune.",
           # (a hook for the map: notes/15 E1)
           "VIESSA: (to the candles) Some places, you go sideways. I've been writing them down. Shh."], event_id)
      return
    end
    if !flag?(:viessa_map)
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:viessa_map)
      say(["VIESSA: (still to the candles) They flicker. Some places. Always the same places.",
           "She unrolls a map of Rootspire covered in wax drips: every place a candle went sideways.",
           "The sealed Root-Gate. The Suncleft's shutters. A hatch under the Split Dock.",
           "The old brewery in the civic ring. The Council Hall.",
           "And a cluster under the Hearth, the drips run together, thick as a swarm.",
           "VIESSA: Under the Hearth is the worst. Something there is very warm and very patient."], event_id)
      sayc([cl(:alberica, "Under the Hearth. Hellen's cellar. Our shrine. ...Somebody's in for a rude talk."),
            cl(:reptin, "Under the Hearth is the tree. Under the tree, the forge. Rude all the way down.")].compact)
      # (notes/15 E19: the map's yours)
      say(["VIESSA: Take it. The map. I don't want it in the shop."], event_id)
      give_key(:FT_WAXMAP)
      set_switch(SW_RUN_OPEN, true)
      set_switch(SW_CELLAR_FOUND, true) if flag?(:rite_stopped)
    else
      say(["VIESSA: (to a candle) Burn straight. Burn straight. ...Good."], event_id)
    end
  end

  # The wax map, from the bag: the six places (notes/15 E19).
  def wax_map_use
    pbMessage(_INTL("Viessa's map of Rootspire. Six places where her candles went sideways:"))
    pbMessage(_INTL("The sealed Root-Gate in the market. The Suncleft's shutters on the Promenade."))
    pbMessage(_INTL("A hatch under the Split Dock. The old brewery in the Verdant Halls."))
    pbMessage(_INTL("The Council Hall. And under the Hearth, so thick the wax has run together."))
  end

  #-----------------------------------------------------------------------------
  # 16. Harget Flinttoe: archivist of local law. He has found an old document
  # naming you "Heralds of the Verdant Dawn", and plans to blackmail you. He
  # also holds the Council's copy of the forged decree ("The Frozen Edict").
  #-----------------------------------------------------------------------------
  def harget(event_id = nil)
    if first_time?(:met_harget)
      say(["A dwarf with bloodshot eyes and a soot-stained beard scratches notes. Scratch, scratch.",
           "HARGET: Harget Flinttoe. Archivist of local law. Civic order. Paperwork.",
           "HARGET: Funny thing. Found an old charter in the stacks. Names four people.",
           "HARGET: Heralds of the Verdant Dawn. Signed and witnessed four hundred years ago. By you.",
           "He looks up for the first time.",
           "HARGET: Which is impossible. Which is interesting. Founders, alive and accountable.",
           "HARGET: That'd be a lot of paperwork. For you. Unless."], event_id)
      return
    end
    if !flag?(:harget_settled)
      c = pbMessage(_INTL("HARGET: Five thousand, and the charter goes back in the stacks. Forever."),
                    [_INTL("Pay him."), _INTL("Refuse."), _INTL("\"Let's ask Captain Kethan.\"")], 1)
      case c
      when 0
        if $Trainer.money >= 5000
          $Trainer.money -= 5000
          set_flag(:harget_settled); set_flag(:harget_paid)
          say(["HARGET: Pleasure. The charter is lost. Very lost. Tragically."], event_id)
        else
          say(["HARGET: You haven't got it. Interesting. Heralds, and broke."], event_id)
        end
      when 1
        set_flag(:harget_settled)
        say(["HARGET: Then I'll publish. ...Eventually. When I've filled in the forms. So many forms.",
             "He scratches a note. It says, you're fairly sure, 'They called my bluff.'"], event_id)
        sayc([cl(:alberica, "Publish and be damned, sweetheart. I'd love to see my signature. Is it pretty?")].compact)
      else
        set_flag(:harget_settled); set_flag(:harget_reported)
        say(["HARGET: (going grey) ...Kethan. No need for Kethan. The charter's very old. Scratch."], event_id)
      end
      harget_decree(event_id)
      return
    end
    return harget_decree(event_id) if !flag?(:decree_examined)
    # (notes/15 E5: what you did with him, read back)
    say([flag?(:harget_paid) ? "HARGET: The charter? Lost. Tragically. I've no idea what you're talking about." :
         flag?(:harget_reported) ? "HARGET: (not looking up) Captain Vale came by. We had a long talk about archives." :
                                   "HARGET: Still filling in the forms. Page nine hundred. You're very famous there."], event_id)
  end

  # The forged decree (The Frozen Edict): looking closely at the wax.
  def harget_decree(event_id = nil)
    return if flag?(:decree_examined)
    say(["HARGET: While you're here. The decree nobody signed: a dig under the Heartroot. My copy.",
         "HARGET: It's in my keeping. Civic order. Look at it, if you like. It gives me a headache."], event_id)
    return if !pbConfirmMessage(_INTL("Look closely at the decree's seal?"))
    set_flag(:decree_examined)
    say(["The wax is the Council's four leaves round a drop of sap. Almost.",
         "Under a lens, the drop of sap is a tiny cracked mirror. In the mirror, a single letter: A.",
         "HARGET: Scratch. Scratch. I'm writing that down. I'm writing that I didn't see it."], event_id)
    sayc([cl(:meat_meat, "That A. Meat Meat has that A. Meat Meat had it burned on."),
          cl(:alerion, "She's been ordering the city to dig her a door. In its own handwriting.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 17. Mira Thynelight: a seamstress who never looks up, and who steals hair,
  # thread and cloth from the Heralds to weave identity-stealing garments for
  # Maera Vell.
  #-----------------------------------------------------------------------------
  def thynelight_ready? = flag?(:met_thynelight) && !flag?(:thynelight_caught) &&
                          (state[:rs_day] || 0) > (state[:thynelight_at] || 0)

  def mira_thynelight(event_id = nil)
    if first_time?(:met_thynelight)
      say(["A seamstress with needle-pricked fingers sews while she talks, and never once looks up.",
           "MIRA THYNELIGHT: Mira Thynelight. Not that Mira. The other one. People mix us up.",
           "MIRA THYNELIGHT: Hold still, you've a loose thread. There. Got it.",
           "She tucks something into her sleeve. It's a hair. It's one of yours.",
           # (the hook, and when: notes/15 E1, E16)
           "MIRA THYNELIGHT: Come by tomorrow. I'll have something to show you. Nearly finished."], event_id)
      state[:thynelight_at] = (state[:rs_day] || 0)
      return
    end
    if thynelight_ready?
      thynelight_double(event_id)
    else
      say(["MIRA THYNELIGHT: (sewing) Lovely hair, you've got. Lovely. Just lovely."], event_id)
    end
  end

  # Somewhere a few steps off where the double can stand and walk in from.
  def double_spot
    px, py = $game_player.x, $game_player.y
    [[3, 0], [-3, 0], [0, 3], [0, -3], [2, 0], [-2, 0], [0, 2], [0, -2]].each do |dx, dy|
      x, y = px + dx, py + dy
      next if !$game_map.valid?(x, y) || !($game_map.passable?(x, y, 0) rescue false)
      next if $game_map.events.values.any? { |e| e.x == x && e.y == y && !e.through && !e.character_name.to_s.empty? }
      return [x, y]
    end
    nil
  end

  def thynelight_double(event_id = nil)
    giver_hello(event_id) if respond_to?(:giver_hello)
    set_flag(:thynelight_caught)
    # (notes/15 E10: the garment-double is on the map, wearing your sprite)
    spot = double_spot
    dbl = spot ? Stage.actor(:double, spot[0], spot[1], 2, graphic: $game_player.character_name) : nil
    say(["Across the promenade, someone is walking toward you. They're wearing your coat. Your face.",
         "Your hair, exactly. Even the way you walk is nearly right."], event_id)
    Stage.approach(dbl) if dbl
    say(["MIRA THYNELIGHT: (still sewing, very quietly) Oh. Oh no. It isn't finished yet.",
         "The garment-double smiles your smile at you, and lunges."], event_id)
    won = boss_battle(named_mon(:B132H122, 42, "Garment-Double"))
    Stage.remove_actor(dbl) if dbl
    return if !won
    sayc(["The double comes apart into hundreds of threads, every one a hair or fibre of yours.",
          "MIRA THYNELIGHT: Maera said they were for a festival. Heralds in the procession.",
          "MIRA THYNELIGHT: She never said they'd walk on their own. I'll stop. Here. Your hair.",
          herald?(:alberica) ? "(Your own face, walking about without you. This city collects you like stamps.)" :
                               cl(:alberica, "Your face, walking about without you. This city collects us like stamps."),
          cl(:reptin, "Then let's be the set they never finish.")].compact, event_id)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # 18. Shivven Pearlbite: a frost-white diver who saw a silhouette like Auril's
  # avatar in the frozen deep, and can't sleep.
  #-----------------------------------------------------------------------------
  def shivven(event_id = nil)
    if first_time?(:met_shivven)
      say(["A pale, scaled diver crusted in frost, gills at the neck, stares at the sky. Then the ice.",
           "SHIVVEN: Shivven Pearlbite. I dive the cold half for relic fish. They taste of centuries.",
           "SHIVVEN: I haven't slept in nine days. Ask me why. No. Don't."], event_id)
      return
    end
    if !flag?(:shivven_told)
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:shivven_told)
      say(["SHIVVEN: (to the sky) Fine. Under the frozen half. Deep. Where the ice goes blue-black.",
           "SHIVVEN: A shape in the ice. A woman. Tall as the Hearth. Arms out, holding something up.",
           "SHIVVEN: Or holding something down.",
           "Shivven's gills flutter shut.",
           "SHIVVEN: Her eyes were open, I think. I didn't stay to see. I came up so fast I bled.",
           "SHIVVEN: Every time I sleep, I'm still down there. And she's closer."], event_id)
      sayc([cl(:alberica, "(a hand on her rune) She's not under the lake, darling. She's good at mirrors."),
            cl(:alerion, "Don't dive.")].compact)
    else
      say(["SHIVVEN: (to the sky) Still haven't slept. Still not diving. Still dreaming of diving."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 19. Professor Halden Vex: a temporal researcher in the Library who believes
  # you are displaced centuries and means to "reset" you to your origin.
  #-----------------------------------------------------------------------------
  def halden_ready? = flag?(:met_halden) && flag?(:ch7_started) && !flag?(:halden_done)

  def halden_vex(event_id = nil)
    if first_time?(:met_halden)
      say(["A gnome with a shock of white hair and inky gloves talks in spirals, then circles back.",
           "HALDEN: Professor Halden Vex, temporal research, where was I, ah. You.",
           "HALDEN: Four centuries out of place. Books on the wrong shelf. The library notices.",
           "HALDEN: I'm building something to put books back on shelves. Where was I. Ah. Good day."], event_id)
      set_switch(SW_HALDEN, true) if flag?(:ch7_started)
      return
    end
    halden_reset(event_id)
  end

  def halden_reset(event_id = nil)
    if flag?(:halden_done)
      return say(["HALDEN: The engine's in pieces. So's my hypothesis. You're on the right shelf, apparently."], event_id)
    end
    if !flag?(:ch7_started)
      return say(["HALDEN: Not ready. Not ready. Calibrating. Come back when the tree's had a bad night."], event_id)
    end
    giver_hello(event_id) if respond_to?(:giver_hello)
    say(["Halden has filled a corner of the Library with brass rings, glass leaves, a humming chair.",
         # (the Journey kid and Wyn are from Rootspire: context 15 §6)
         outsider? ? "HALDEN: Ready! Sit, sit. A small reset. Back to before you left. You'll hardly notice." :
                     "HALDEN: Ready! Sit, sit. A small reset. Back where your friends belong. Painless.",
         "HALDEN: Your Pokémon may not come with you. Footnote. Small footnote."], event_id)
    # (notes/15 E7: three different answers)
    c = pbMessage(_INTL("What do you do?"), [_INTL("\"No.\""), _INTL("Talk him out of it."), _INTL("Kick the chair over.")], 0)
    if c == 1
      speak(:alberica, "Halden, darling. Every book here was on the wrong shelf once. That's growth.",
            "...Some books belong where they ended up.") if with_or_is?(:alberica)
      sayc([cl(:reptin, "We're not out of place, Professor. We're the place. The tree grew round us.")].compact)
      halden_finish
      wheel(1)
      return say(["HALDEN: (spiralling, then circling back, very slowly) ...The tree grew round them.",
                  "HALDEN: Then the shelf is them. And I've built a very expensive chair.",
                  "HALDEN: Excuse me. I need to sit in it."], event_id)
    elsif c == 2
      pbSEPlay("Glass") rescue nil
      $game_screen.start_shake(4, 6, 10) rescue nil
      say(["You plant a boot on the humming chair and shove. It goes over with a bang.",
           "The brass rings come down one after another, ringing like dropped bells. The hum stops.",
           "Halden sits down slowly in the wreck, a crystal leaf in each hand.",
           "HALDEN: ...Well. That's one way to falsify a hypothesis. Where was I. Ah. Nowhere."], event_id)
      return halden_finish
    end
    say(["HALDEN: (the rings spinning up) No? No is a temporal anomaly! Hold still! For science!"], event_id)
    return if !pbTrainerBattle(:FT_SCHOLAR, "Halden Vex", nil, false, 0)
    halden_finish
    say(["The rings wobble and fall over one by one. The chair stops humming.",
         "HALDEN: Fascinating. Distressing. Fascinating. You resisted. Time resisted with you.",
         "HALDEN: Perhaps you aren't out of place. Perhaps the place is you. Where was I. Ah. Sorry."], event_id)
  end

  # (notes/15 E8f: the engine goes, however it ends)
  def halden_finish
    set_flag(:halden_done)
    set_switch(SW_HALDEN, false)
  end

  #-----------------------------------------------------------------------------
  # 20. Rilka Dawnshard: a wandering monk with sunburst and snowflake tattoos,
  # sent by Glimmer's future church (the faith of the Dagger Reborn) to make sure
  # the Heralds survive what's coming.
  #-----------------------------------------------------------------------------
  def rilka(event_id = nil)
    if first_time?(:met_rilka)
      say(["A half-orc monk with sunbursts and snowflakes tattooed down both arms bows, eyes closed.",
           "RILKA: Rilka Dawnshard. I meditate on the balance of the seasons. And on you.",
           "RILKA: I was sent to see you survive what's coming. By a church that doesn't exist yet."], event_id)
      return
    end
    if flag?(:glimmer_gone) || flag?(:engine_dead)
      if first_time?(:rilka_after)
        say(["Rilka bows. Her eyes stay closed for a long time.",
             "RILKA: Now I can tell you. My church is his. The Dagger Reborn. The cat in the light.",
             "RILKA: In my time, children light him a candle on the longest night, and hum four notes."], event_id)
        say(["RILKA: I was sent to see you all survive. I failed one. He would not let me not.",
             "RILKA: He said it was what torches are like."], event_id)
        sayc([cl(:alberica, "(very quiet) ...Of course he did. Of course he bloody did."),
              cl(:meat_meat, "Fluffy one has a church. Meat Meat will go. Meat Meat will bring snacks."),
              cl(:alerion, "Four notes. He never got them right. ...Tell your children to sing them wrong.")].compact)
        return
      end
      return say(["RILKA: (eyes closed) The wheel turns. I'm still watching the rest of you."], event_id)
    end
    say(["RILKA: (eyes closed) Not yet. I'm not allowed to say yet.",
         "RILKA: Stay close to each other. Especially the warm one."], event_id)
  end

  #-----------------------------------------------------------------------------
  # Mira of the North Wind's mirror stall, and the child who bought a mirror and
  # is possessed by the whispering reflection in it (Mirror, Mirror: first half;
  # the twin is found and broken in the Heartroot, 033_Chapter7B).
  #-----------------------------------------------------------------------------
  def mira_stall(event_id = nil)
    if !flag?(:met_mira_stall)
      set_flag(:met_mira_stall)
      say(["A stall of frost-glass mirrors, every one tilted to catch the aurora.",
           "Behind them, among her reflections: an elegant half-elf with black hair, warm, distracted.",
           "MIRA: Mira of the North Wind. A Corsair captain at sea. A merchant, when I'm not."], event_id)
    end
    talk(:mira_north_wind, event_id)
    if !flag?(:mirror_child_free)
      say(["MIRA: (smiling at nothing) My daughter's at home. We- I put her to bed. Somewhere wet.",
           "MIRA: She'll be up soon. She always looks in my mirrors when she thinks I'm not watching."], event_id)
    end
    # (notes/15 E19: the shard goes cold near a watcher, so say so)
    if !flag?(:mira_shard_bought) && pbConfirmMessage(_INTL("MIRA: A mirror for you? Five hundred. It goes cold near anything watching."))
      if $Trainer.money >= 500
        $Trainer.money -= 500
        set_flag(:mira_shard_bought)
        say(["MIRA: Lovely. Keep it near your heart. Or don't. It doesn't mind.",
             "The shard is cold. In it, behind your shoulder, for a moment, someone is smiling."], event_id)
        give(:FT_STILLSHARD)
      else
        say(["MIRA: Another time. We- I'll be here."], event_id)
      end
    end
  end

  def rs_mirror_child(event_id = nil)
    if flag?(:twin_broken)
      return say(["CHILD: My mirror's just a mirror now! I can see my own face!", "CHILD: It's a bit boring. I love it."], event_id)
    end
    first = !flag?(:met_mirror_child)
    set_flag(:met_mirror_child)
    say(["A boy clutches a frost-glass mirror with both hands. Tears are running down his face.",
         "In the glass, his reflection is smirking.",
         "When he tries to put the mirror down, it clings to his fingers like frost to a tongue."], event_id)
    say(["CHILD: I bought it from the lady. It's got a friend in it. She talks when nobody looks.",
         "The reflection's mouth moves. The boy's doesn't. A woman's voice, pleasant and precise:",
         "\"Hello again, variables. You broke the hag's glass. I was using it as a door.\"",
         "\"I'm cold. My other half is down in the roots. Bring it here and I'll let the boy go.\"",
         "\"Or don't, and I'll keep him. Children are very good at looking.\"",
         "\"There's a girl in my other half already. Mira's girl. She looked too long.\"",
         "Behind the boy's reflection, for a blink: a woman with hollow eyes, crowned in ice.",
         "CHILD: She says that a lot. Can you make her stop?"], event_id)
    if first
      sayc([cl(:meat_meat, "(very still) That voice. Meat Meat knows that voice. From the cold table."),
            cl(:meat_meat, "Variables. Her word for us. Things you change, to see what breaks."),
            cl(:alberica, "Shh, sweetheart. Look at me, not the glass."),
            cl(:alberica, "We'll find the other half and break it."),
            cl(:alerion, "Her other half. Down where the sap runs. We follow the shine.")].compact)
    end
    boy_mirror_exorcism if !has_key?(:FT_BOYSMIRROR) && !flag?(:twin_broken)
  end

  # Quest M2 (rootspire.md 8317-8331): Meat Meat's. Know the reflection for a
  # trapped spirit, calm the boy, and take the mirror off him without hurting
  # him; then carry it down to its twin in the Heartroot.
  def boy_mirror_exorcism
    if !with_or_is?(:meat_meat)
      return say(["(The reflection keeps looking past you, for someone smaller.)", "(Meat Meat should be here for this.)"])
    end
    mm = herald?(:meat_meat)
    return if !pbConfirmMessage(_INTL(mm ? "Try to take the mirror off him?" : "Let Meat Meat try to take the mirror off him?"))
    c = pbMessage(_INTL("The reflection smirks. What is it?"),
                  [_INTL("A trapped spirit, wearing his face"), _INTL("A trick of the frost-glass"), _INTL("The boy himself, lying")], 0)
    if c != 0
      mirror_lash("The reflection laughs at you. \"Wrong, variable.\" The glass flexes like a muscle.")
      return
    end
    say([mm ? "(Not his face. Hers, wearing his. A spirit, caught in glass, with its fingers in him.)" :
              "MEAT MEAT: (low) Not the boy. Something in the glass, wearing his face.",
              "MEAT MEAT: Meat Meat knows how that feels."])
    c = pbMessage(_INTL(mm ? "How do you calm the boy?" : "How does Meat Meat calm the boy?"),
                  [_INTL("\"Meat Meat had a mirror lady too. Meat Meat got away. You will.\""),
                   _INTL("\"Hold still and don't cry.\""), _INTL("Just grab it")], 0)
    if c != 0
      mirror_lash("The boy screams and clutches the mirror tighter. Frost bites up his fingers.")
      return
    end
    say(["The boy sniffs. He looks at the goblin, and the goggles, and the hair, and decides.",
         mm ? "He lets you take it. The glass is cold enough to burn. You don't let go." :
              "He lets Meat Meat take it. The glass is cold enough to burn. She doesn't let go.",
         "In the mirror, the smirk goes flat.",
         "\"Clever. Now you're carrying me. Down you go, V-7. Down to my other half.\"",
         mm ? "(V-7. That was you, on the cold table. Seven. Razzy was Raz.)" :
              "MEAT MEAT: (low) V-7. That was Meat Meat, on the cold table. Seven. Razzy was Raz.",
         cl(:alberica, "Not any more, it isn't. You're Meat Meat. Hold the glass, sweetheart."),
         "CHILD: (flexing his fingers) It's quieter. She's... she's in your hands now. Is that bad?",
         mm ? "(Very.)" : "MEAT MEAT: Very. But Meat Meat has strong hands."].compact)
    give_key(:FT_BOYSMIRROR)
    set_flag(:boy_mirror_taken)
    side_goal(:mirror_boy, "The boy's mirror, to its twin in the Heartroot's Overflow Channel.", done: :twin_broken)
  end

  # Failure: the spirit lashes out (the source's disadvantage on the next attack:
  # here, the lead Pokémon's nerve).
  def mirror_lash(line)
    say([line])
    lead = $Trainer.first_able_pokemon rescue nil
    if lead
      lead.hp = [lead.hp - [lead.totalhp / 8, 1].max, 1].max
      say(["Something cold whips out of the glass. #{lead.name} flinches back, rattled."])
    end
    say(["(The boy won't let go of it now. Try again once he's calmer.)"])
  end

  # The Corsair sailor on the Root-Tier (his lines were written in Ch6).
  def corsair_sailor(event_id = nil)
    talk(:corsair_sailor, event_id)
    if flag?(:mira_left_possessed)
      return say(["CORSAIR: (not looking at you) Captain says \"we\" all the time now.",
                  "CORSAIR: The girl sleeps in the hold, by the humming thing.",
                  "CORSAIR: You were down there. You could've broken it. ...Move along."], event_id)
    end
    if flag?(:mira_freed) && first_time?(:corsair_symbol)
      say(["He shows you the tattoo on his wrist: a ship's wheel inside a spiral of aurora.",
           "CORSAIR: Captain's back. Proper back. One voice. We'd sail the frozen half for you now."], event_id)
    end
  end
end
