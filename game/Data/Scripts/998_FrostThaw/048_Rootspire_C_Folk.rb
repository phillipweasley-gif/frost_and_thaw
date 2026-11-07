#===============================================================================
# Frost & Thaw - Rootspire as a living city (part C): the "20 New Rootspire
# NPCs (Campaign-Integrated)", each with an outward face and a secret, and the
# Bazaar's mirror stall (the first half of "Mirror, Mirror").
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
      say(["A Rootwarden initiate with short platinum braids and ice-bitten hands nearly walks into you.",
           "TALWYN: Oh! #{herald?(:wyn) ? 'Wyn! And Heralds' : 'Heralds'}! I'm Talwyn, Talwyn Frostrill, initiate, Bough circle, well, nearly, I can help, I'm a guard,",
           "TALWYN: junior guard, nearly-guard. Do you need anything guarded? I'm very good at standing near things.",
           "She fidgets with her belt the whole time."], event_id)
      set_switch(SW_TALWYN_FIELDS, true)
    when 1
      say(["TALWYN: You came back! I knew you'd come back. I saw you go up the root-stair this morning. And down. And up.",
           "TALWYN: Not following. Guarding. From a distance. A respectful distance."], event_id)
    else
      say(["TALWYN: (very fast) I'm writing down everything you do. For the archive. For the Hall. For later. Sorry. Hi."], event_id)
    end
    state[:talwyn] = n + 1
    talwyn_secret if state[:talwyn] >= 3
  end

  # Met again out in the Blooming Fields: the secret.
  def talwyn_fields(event_id = nil)
    state[:talwyn] = (state[:talwyn] || 0) + 1
    talwyn_secret(event_id)
  end

  def talwyn_secret(event_id = nil)
    return say(["TALWYN: (waving from behind a snowdrift) Still guarding! Don't mind me!"], event_id) if flag?(:talwyn_told)
    set_flag(:talwyn_told)
    say(["Talwyn stops fidgeting. For once she speaks slowly.",
         "TALWYN: I was on night watch, the week before you came. Over the market well.",
         "TALWYN: The white dragon came down out of the aurora and circled the Heartroot. Round and round. For an hour.",
         "TALWYN: Like she was waiting for someone to come up out of it. Or go down.",
         "TALWYN: Then you came out of a lantern. And she landed for you.",
         with_or_is?(:alerion) ? "TALWYN: (looking straight at #{herald?(:alerion) ? 'you' : 'Alerion'}) One of you is hers. Her chosen. I know it." :
                                 "TALWYN: One of you is hers. Her chosen. I know it.",
         "TALWYN: I'm going to be there when you find out."], event_id)
    sayc([herald?(:alerion) ? "(Your ring goes cold. Then warm.)" : cl(:alerion, "(a hand on his ring) ...She's not wrong."),
          cl(:alberica, "Sweetheart, being somebody's chosen mostly means getting shouted at by dragons. Ask him.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 2. Jorik Pinebellow: sap-barrel merchant on the docks, smuggling infernal
  # ore for Gorran (and so, without knowing it, for Summer).
  #-----------------------------------------------------------------------------
  def jorik(event_id = nil)
    if first_time?(:met_jorik)
      say(["A dwarf with a chest like a barrel and an amber beard braided with pine twigs laughs too loudly.",
           "JORIK: HA! Warm-sap brew, Heralds! Jorik Pinebellow's own! Warms you down to the boots!",
           "JORIK: HA! ...Ha."], event_id)
    elsif flag?(:dock_ore_seen) && !flag?(:jorik_confessed)
      set_flag(:jorik_confessed)
      say(["You point at the black grit still caught between the planks by his barrels.",
           "JORIK: HA! That? Fell off a boat. From the south. Boats from the south drop all sorts of-",
           "He stops laughing. He looks very tired.",
           "JORIK: It's ore. Warm ore. It comes up from the old Guild tunnels under the dock. The Smuggler's Run.",
           "JORIK: Gorran pays me to carry it up. Special commissions. I don't ask. I just carry the barrels.",
           "JORIK: The hatch is behind the third pier-post. I'll... I'll leave it unbarred. Just don't tell Gorran it was me.",
           "JORIK: He gets warm when he's angry. Properly warm."], event_id)
      set_switch(SW_RUN_OPEN, true)
      sayc([cl(:meat_meat, "Meat Meat saw that ore before. On these planks. Dock man swept it. Dock man was lying."),
            cl(:reptin, "And now he isn't. Well done, Jorik. That was brave. Have a drink. One of yours."),
            "JORIK: (as you go) Ash meets the barrels himself. Nobody checks a Rootwarden."].compact)
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
         "It's ore. But wrong. It gives off a faint warmth, and smells like smoke shut up inside a stone.",
         "A dockworker panics, sweeps it into the water, and says it fell off a boat from the south.",
         "It absolutely did NOT come from the sap-mines. He says that twice."], event_id)
  end

  #-----------------------------------------------------------------------------
  # 3. Serelle of the Still Veil: a spirit-tender with visions of Avarice
  # forging "a god of light made wrong".
  #-----------------------------------------------------------------------------
  def serelle(event_id = nil)
    if first_time?(:met_serelle)
      say(["A woman in a veil of frost-silk hums a dirge with no melody. She tends a small funerary shrine of leaves.",
           "SERELLE: I keep the rites for those the tree takes back. Serelle. Of the Still Veil.",
           "SERELLE: You are not dead. How unusual, for people of your age."], event_id)
    else
      say(["SERELLE: (between verses) I dreamed it again. Shall I tell you? You'll wish I hadn't."], event_id)
      return if flag?(:serelle_vision)
      set_flag(:serelle_vision)
      say(["SERELLE: Under the Heartroot, a forge. Someone at it, hammering light into a shape.",
           "SERELLE: Wings. A crown. A god of light. Made wrong. Made of something that remembers being cold.",
           "SERELLE: Every time she strikes it, somebody somewhere forgets their own name.",
           "She goes back to humming. The dirge has a melody now. You wish it didn't."])
      sayc([cl(:glimmer, "(very quiet) A god of light made wrong. She's making a Brightmane of her own."),
            cl(:alberica, "Darling, nobody forges a god. They just forge a very large problem and call it holy.")].compact)
    end
  end

  #-----------------------------------------------------------------------------
  # 4. Pimmlet Natch: an auroral librarian hiding a forbidden scroll, "Shimmer's
  # Heart" (the ritual that made the Frost Wyrmling).
  #-----------------------------------------------------------------------------
  def pimmlet(event_id = nil)
    if first_time?(:met_pimmlet)
      say(["A gnome with enormous round lenses that magnify two anxious eyes looks up from a ladder.",
           "PIMMLET: Shhh. ...Sorry. Shhh. Habit. Pimmlet Natch. Auroral Librarian. Shhh.",
           "He's whispering \"shhh\" to nobody, even when nobody is talking."], event_id)
      # The Journey kid runs the College's errands (context 15 §6): somebody knows them.
      say(["PIMMLET: Shhh. ...You're Wynsnow's runner. You were gone a whole HOUR. Shhh."]) if journey?
      return
    end
    if !flag?(:shimmers_heart_scroll) && (with_or_is?(:glimmer) || with_or_is?(:shade) || flag?(:twins_met))
      set_flag(:shimmers_heart_scroll)
      say(["PIMMLET: (very quietly, glancing at the shelves as if they'll tell) Shhh. Come here. Shhh.",
           "PIMMLET: I'm not supposed to have this. It's forbidden. Solvaran thinks it's under the floor.",
           "He unrolls a scroll of crystal leaf. A title in old Wennen: SHIMMER'S HEART.",
           "PIMMLET: The ritual that made the white wyrmling. A heart of ice, given willingly, put into a frost egg.",
           "PIMMLET: Sung over with four notes. The same four. Every time.",
           "PIMMLET: It says the egg doesn't hatch a dragon. It hatches an answer.",
           "PIMMLET: An answer to what? It doesn't say. Shhh. I've read it nine hundred times."], event_id)
      sayc([with_or_is?(:glimmer) ? cl(:glimmer, "(quietly, humming the four notes, off-key) ...She was always the answer. She just never let us ask the question.") :
                                    cl(:shade, "(staring at the four notes) That's her song. That's Shimmer's song."),
            cl(:alerion, "An answer. To Auril.")].compact)
    else
      say(["PIMMLET: Shhh. ...Sorry. Shhh."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 5. Reva Mosscut: her floral sculpture of the Heralds hides a vine-person she
  # grew for Autumn's illusions (a spy).
  #-----------------------------------------------------------------------------
  def reva(event_id = nil)
    if !flag?(:met_reva)
      set_flag(:met_reva)
      return talk(:reva, event_id)
    end
    if flag?(:watcher_weasel) && !flag?(:reva_confessed)
      set_flag(:reva_confessed)
      say(["The sculpture of the Heralds turns its flower-head, just slightly, to follow you.",
           "Reva's head tilts sharply. Her ears go flat.",
           "REVA: ...It's not a sculpture. Not all of it. The fifth figure, at the back. It's a vine-person.",
           "REVA: Lumea asked. For the Court. It listens, and it tells her what the Heralds say to each other.",
           "REVA: I didn't think it was hurting anyone. It's so pretty. It's the best thing I ever grew.",
           "REVA: I'll... I'll plant it out in the Fields. Somewhere nobody talks."], event_id)
      sayc([cl(:reptin, "Plant it somewhere it can grow up into something that isn't a spy, Reva. That's all any of us want."),
            cl(:meat_meat, "Meat Meat said rude things near the flowers. Meat Meat does not regret it.")].compact)
      return
    end
    talk(:reva, event_id)
  end

  #-----------------------------------------------------------------------------
  # 7. Mistress Felka Thornhand: the Heartroot's archivist. She found a mirror
  # shard that speaks in Avarice's voice, and hid it in the roots.
  #-----------------------------------------------------------------------------
  def felka(event_id = nil)
    if first_time?(:met_felka)
      say(["A tiefling with bark-textured skin and hands wrapped in thorn-vines stands by the sealed Root-Gate.",
           "FELKA: (a soft monotone) Mistress Felka Thornhand. I keep the labyrinth's records. The outer ring is mine.",
           "FELKA: The gate is sealed. It has been sealed before. It always opens. That is the nature of gates."], event_id)
      return
    end
    if !flag?(:felka_shard) && flag?(:ch7_started)
      say(["FELKA: (still a monotone, but her thorn-wrapped hands are shaking) You go down. Then take it. Please.",
           "She lifts a coil of root aside. Inside, a shard of mirror the size of a palm, pulsing faintly.",
           "From it, a woman's voice, pleasant and precise: \"Every glass is an eye, Felka. You can't hide an eye in the dark.\"",
           "FELKA: I hid it in the roots. The roots don't like it. Take it away and break it where it can't see the tree."], event_id)
      return if !pbConfirmMessage(_INTL("Take Felka's shard and break it?"))
      set_flag(:felka_shard)
      wheel(1)
      pbSEPlay("Ice1") rescue nil
      sayc(["You grind the shard under a heel, on the stone, away from the roots.",
            "The voice says \"Rude,\" very calmly, and then nothing at all.",
            "FELKA: ...Thank you. The outer ring is mine again.",
            cl(:alerion, "She talks through glass. Every glass. We'll need a lot of heels.")].compact)
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
      say(["An old man with frost in his beard (in this heat) strums a lute and sings to a crowd that isn't listening.",
           "YORIN: Old Yorin the Chanter! Songs of things that happened! ...Will have happened. Happen. Grammar's hard."], event_id)
    end
    song = YORIN_SONGS.find { |cond, _| cond.call(self) }
    say(["YORIN: (strumming) Here's one I've never sung before. Funny. I know every word."] + song[1])
    if song.equal?(YORIN_SONGS[1]) && with_or_is?(:glimmer) && first_time?(:yorin_gold_cat)
      sayc([cl(:glimmer, "(after a long moment) ...Catchy."),
            cl(:alberica, "I don't like that song, Yorin. Sing a different one. Sing a rude one.")].compact)
    end
  end

  #-----------------------------------------------------------------------------
  # 9. Dathra Spineshade: a drow trader of underdark curios, secretly hired by
  # Avarice to fetch Deepfire Quartz for the Eternal Summer Engine.
  #-----------------------------------------------------------------------------
  def dathra(event_id = nil)
    if first_time?(:met_dathra)
      say(["A drow in a cloak of spider-silk, onyx skin and luminous teal eyes, snaps her fingers as she thinks.",
           "DATHRA: Dathra Spineshade. Curios from below. Below below. Not this kind of below.",
           "DATHRA: Glow-moss, lichen-wine, a very rude fossil. Deepfire Quartz, if you're very rich and very discreet."], event_id)
      return
    end
    if !flag?(:dathra_turned)
      say(["DATHRA: (snap) Deepfire Quartz. I have a buyer already. Pays in warm gold. Wants ten cases.",
           "DATHRA: (snap, snap) Burns hotter than anything up here. Hot enough to keep a summer going forever."], event_id)
      c = pbMessage(_INTL("What do you say?"), [_INTL("\"Who's the buyer?\""), _INTL("\"We'll pay double. Don't sell it.\""), _INTL("\"Nothing.\"")], 2)
      case c
      when 0
        say(["DATHRA: (snap) Never seen her face. Nobody has. She sends a man with no reflection to collect.",
             "DATHRA: ...You've gone very pale. Is that a normal colour for you?"])
        set_flag(:dathra_buyer)
      when 1
        if $Trainer.money >= 8000
          $Trainer.money -= 8000
          set_flag(:dathra_turned)
          wheel(1)
          say(["DATHRA: (counting) Double. Fine. Ten cases of Deepfire, at the bottom of the Glasswater.",
               "DATHRA: The buyer will be furious. I'll be somewhere else. I'm always somewhere else.",
               "She snaps her fingers once more, and smiles, for the first time."])
          sayc([cl(:reptin, "Eight thousand to keep a forge from getting warmer. Best money we've ever spent."),
                cl(:meat_meat, "Meat Meat would have bitten her for free.")].compact)
        else
          say(["DATHRA: (snap) Double is eight thousand. You have... less. Come back richer."])
        end
      end
    else
      say(["DATHRA: (snap) The bottom of the Glasswater is very peaceful. Ten cases of peace."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 10. Gurk Thistlebane: the Rootwardens' smith. His hammer wakes at night and
  # whispers warnings of Auril's agents gathering again.
  #-----------------------------------------------------------------------------
  def gurk(event_id = nil)
    if first_time?(:met_gurk)
      say(["A massive orc with silver-capped tusks wipes soot off a hammer with real tenderness.",
           "GURK: Gurk Thistlebane. I forge for the Wardens. Blood in the steel, storm in the quench.",
           "GURK: This hammer talks at night. Don't laugh. It's never wrong."], event_id)
      return
    end
    if !flag?(:cellar_hint) && flag?(:rite_stopped)
      set_flag(:cellar_hint)
      set_switch(SW_CELLAR_FOUND, true)
      say(["GURK: Hammer woke me last night. Whispered the same thing till dawn. Like sleet on a roof.",
           "GURK: \"The cold gathers under the cask. The cold gathers under the cask.\"",
           "GURK: There's only one cask in the civic ring. The old Verdant Cask brewery, by the south steps.",
           "GURK: Thirty years shut. And last night, there was frost on the boards. In summer.",
           "GURK: Storm's coming up from under, Heralds. You'd best be the lightning."], event_id)
      sayc([cl(:alerion, "The Halo had another hideout. Rheven always said so."),
            cl(:wyn, "(quietly) The Frozen Cellar. The spores in the gardens talk about it. Nobody goes.")].compact)
    else
      say(["GURK: Hammer's quiet. Good. When it's loud, somebody's bleeding."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 11. Elitha Snowmere: a frost-glass artist. One of her sculptures is a prison
  # holding a sliver of Auril's will.
  #-----------------------------------------------------------------------------
  def elitha(event_id = nil)
    if first_time?(:met_elitha)
      say(["A Winter eladrin with hair that drifts like falling snow gestures at her work with chilling elegance.",
           "ELITHA: Elitha Snowmere. Frost-glass. Nothing melts here unless I let it.",
           "ELITHA: That one is my finest. A woman, dancing. Don't touch her. She bites."], event_id)
    else
      say(["ELITHA: (not looking at the dancing figure) She's been very still today. That's a good sign. Probably."], event_id)
    end
  end

  def elitha_sculpture(event_id = nil)
    if flag?(:sliver_freed)
      return say(["The sculpture's frost has gone clear and ordinary. A woman, dancing. Only a woman, dancing."], event_id)
    end
    say(["A frost-glass dancer, life-sized. Inside the ice, something moves that isn't the light.",
         "A voice in your bones: \"Little vessel. Come closer. I'm so cold in here. Warm me.\"",
         herald?(:alberica) ? "(The rune on your chest burns.)" : (with_or_is?(:alberica) ? "Alberica puts a hand to her chest. Her rune is burning." : nil)].compact, event_id)
    say(["ELITHA: (very quietly, behind you) I trapped it. Four hundred years ago my grandmother's grandmother did.",
         "ELITHA: A sliver of Auril's will. It's been getting louder since you came. It knows her."])
    return if !pbConfirmMessage(_INTL("Break the sculpture and let the sliver out to fight?"))
    say(["The frost-glass shatters. The sliver pours out, white and furious, and takes the shape of a dancer with no face."])
    return if !boss_battle(named_mon(:B124H215, 43, "Sliver of Auril"))
    set_flag(:sliver_freed)
    add_counter(:story_beats)
    sayc(["The sliver comes apart into snow, and the snow melts before it lands.",
          "ELITHA: ...It's gone. Truly gone. Oh, my grandmother's grandmother would have wept.",
          "ELITHA: Take this. Frost-glass that never melts. It liked you. That's the worst thing I can say about it.",
          cl(:alberica, "(a hand on her chest) Quieter. The rune's quieter. ...Thank you, darling.")].compact)
    give(:NEVERMELTICE)
  end

  #-----------------------------------------------------------------------------
  # 12. Pellar Wicket: a courier who trips everywhere and never drops a package.
  # He carries coded notes between Autumn's spies.
  #-----------------------------------------------------------------------------
  def pellar(event_id = nil)
    if first_time?(:met_pellar)
      say(["A small, flushed halfling in a coat that is mostly pockets trips over nothing and doesn't drop a thing.",
           "PELLAR: Pellar Wicket! Courier! Every tier, every hour! Never dropped a package in my life!",
           "He trips again. Doesn't drop anything again."], event_id)
      return
    end
    if !flag?(:autumn_note) && flag?(:met_lumea)
      set_flag(:autumn_note)
      say(["PELLAR: Delivery for the Atelier, delivery for the Clothier, delivery for the Council, delivery for-",
           "He trips. For the first time in his life, something falls out of a pocket. A folded leaf.",
           "He doesn't notice. He's already gone, apologising to a lamp-post.",
           "The leaf is covered in numbers. Under them, in Lumea's handwriting, decoded in pencil by someone careless:",
           "\"K. is ready. Feed her the dream of a green crown. She'll use their relics to quicken the tree. Then Summer returns to a burning.\""], event_id)
      sayc([cl(:reptin, "'K.' Kelyn. They're going to use Kelyn. And our relics."),
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
    "\"And the Dwarf of Song held the seed in her hand, and the seed held four hundred years in it, and did not drop them.\"",
    "\"And the Warden of Life and Death fed the wolves from his own bowl, and the wolves remembered for four hundred years.\"",
    "\"And the Guardian of the Dark Half walked into the winter and taught it to kneel.\"",
    "\"And the Guardian of the Light Half came up from the cold table and called the green dragon by his name.\"",
    "\"And the Sparkbearer stepped through the mirror, and the mirror gave him back as fire.\""
  ]

  def selene(event_id = nil)
    if first_time?(:met_selene)
      say(["An acolyte with pale gold hair and mismatched eyes (one green, one icy blue) looks up from a book.",
           "SELENE: Sister Selene Marr, of the Twinned Dragons. Frost and verdance are one- (she bows her head)",
           "SELENE: -blessed be the wheel- one faith. Oh. Oh, it's you. It's YOU.",
           "SELENE: I'm writing your scripture. You're demigods, reborn. You don't have to agree. Gods never do."], event_id)
    end
    i = (state[:selene_verse] ||= 0)
    say(["SELENE: (reading) The Book of the Heralds, verse #{i + 1}:", SELENE_VERSES[i % SELENE_VERSES.size]])
    state[:selene_verse] = i + 1
    if i == 0
      sayc([cl(:alberica, "Darling, I've been called a lot of things. 'Demigod' is going straight on my door."),
            cl(:meat_meat, "Meat Meat is in a book. Meat Meat wants a copy. Alerion can read it to her.")].compact)
    elsif i == 2                      # (the verse about him)
      sayc([cl(:alerion, "Kneel. It never knelt. It sat down beside me once, and I was grateful.")].compact)
    end
  end

  #-----------------------------------------------------------------------------
  # 14. Krolf the Mossback: a hermit in the Echo Gate caverns who hears Sephek's
  # voice in the wind (and another voice, a boy's).
  #-----------------------------------------------------------------------------
  def krolf(event_id = nil)
    if first_time?(:met_krolf)
      say(["In a hollow by the Echo Gate sits a goliath covered in luminous green moss, so still he could be a rock.",
           "KROLF: (very slowly, as if he's listening to someone else first) ...Krolf. Mossback.",
           "KROLF: The wind talks. Here. In the Gate. A man's voice. Cold. Always the same words.",
           "KROLF: \"The lake remembers.\" ...Then a long time, nothing. Then again."], event_id)
      return
    end
    if !flag?(:talion_foreshadowed)
      set_flag(:talion_foreshadowed)
      say(["KROLF: (listening) ...Another voice, lately. Small. A boy's.",
           "KROLF: \"You told me to stay in the house.\" He says. \"You said you'd come back.\"",
           "KROLF: The wind brings it off the lake, by the Glasswater's still edge.",
           "KROLF: The lake keeps what touches it. That's what the cold man means. The lake remembers."], event_id)
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
      say(["A half-elf in a wax-splattered apron, hair bound with iron rings, lines up candles. She never looks at you.",
           "VIESSA: (to the candles) Scented candles. Pine, honey, frost. Viessa Arialune."], event_id)
      return
    end
    if !flag?(:viessa_map)
      set_flag(:viessa_map)
      say(["VIESSA: (still to the candles) They flicker. Some places. Always the same places. I write them down.",
           "She unrolls a map of Rootspire covered in wax drips, each one a place where a candle went sideways.",
           "The sealed Root-Gate. The Suncleft Emporium's shutters. A hatch under the Split Dock.",
           "The old brewery in the civic ring. The Council Hall. And a cluster, thick as a swarm, right under the Hearth.",
           "VIESSA: Under the Hearth is the worst. Something there is very warm and very patient.",
           "VIESSA: Take it. The map. I don't want it in the shop."], event_id)
      set_switch(SW_RUN_OPEN, true)
      set_switch(SW_CELLAR_FOUND, true) if flag?(:rite_stopped)
      sayc([cl(:alberica, "Under the Hearth. Hellen's cellar. Our shrine. ...Somebody's going to get a very rude conversation."),
            cl(:reptin, "Under the Hearth is under the tree. Under the tree is the forge. Everything here is under the Hearth, darling.")].compact)
    else
      say(["VIESSA: (to a candle) Burn straight. Burn straight. ...Good."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 16. Harget Flinttoe: archivist of local law. He has found an old document
  # naming you "Heralds of the Verdant Dawn", and plans to blackmail you. He
  # also holds the Council's copy of the forged decree ("The Frozen Edict").
  #-----------------------------------------------------------------------------
  def harget(event_id = nil)
    if first_time?(:met_harget)
      say(["A dwarf with bloodshot eyes and a soot-stained beard scratches notes without looking up. Scratch, scratch.",
           "HARGET: Harget Flinttoe. Archivist of local law. Civic order. Paperwork. Scratch, scratch.",
           "HARGET: Funny thing. Found an old charter in the stacks. Names four people. Heralds of the Verdant Dawn.",
           "HARGET: Signed, sealed, and witnessed four hundred years ago. By you. Which is impossible. Which is interesting.",
           "HARGET: A Council that found out its founders were living, breathing, accountable people... well.",
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
          say(["HARGET: Pleasure. Scratch, scratch. The charter is lost. Very lost. Tragically."])
        else
          say(["HARGET: You haven't got it. Interesting. Heralds, and broke."])
        end
      when 1
        set_flag(:harget_settled)
        say(["HARGET: Then I'll publish. ...Eventually. When I've filled in the forms. There are a lot of forms.",
             "He scratches a note. It says, you're fairly sure, 'They called my bluff.'"])
        sayc([cl(:alberica, "Publish and be damned, sweetheart. I'd love to see my signature. Is it pretty?")].compact)
      else
        set_flag(:harget_settled); set_flag(:harget_reported)
        say(["HARGET: (going grey) ...Kethan. No need for Kethan. The charter's very old. Scratch."])
      end
    end
    harget_decree
  end

  # The forged decree (The Frozen Edict): looking closely at the wax.
  def harget_decree
    return if flag?(:decree_examined)
    say(["HARGET: While you're here. The Council's copy of that decree. The one nobody signed. Digging under the Heartroot.",
         "HARGET: It's in my keeping. Civic order. Look at it, if you like. It gives me a headache."])
    return if !pbConfirmMessage(_INTL("Look closely at the decree's seal?"))
    set_flag(:decree_examined)
    say(["The wax is the Council's four leaves round a drop of sap. Almost.",
         "Under a lens: the drop of sap is a tiny cracked mirror. And in the mirror, a single letter. A.",
         "HARGET: Scratch. Scratch. I'm writing that down. I'm writing that I didn't see it."])
    sayc([cl(:meat_meat, "That A. Meat Meat has that A. Meat Meat had it burned on."),
          cl(:alerion, "She's been ordering the city to dig her a door. In its own handwriting.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 17. Mira Thynelight: a seamstress who never looks up, and who steals hair,
  # thread and cloth from the Heralds to weave identity-stealing garments for
  # Maera Vell.
  #-----------------------------------------------------------------------------
  def mira_thynelight(event_id = nil)
    if first_time?(:met_thynelight)
      say(["A seamstress with needle-pricked fingers sews while she talks and never once looks up.",
           "MIRA THYNELIGHT: Mira Thynelight. Not that Mira. The other one. People mix us up. I don't mind.",
           "MIRA THYNELIGHT: Hold still, you've a loose thread. There. Got it.",
           "She tucks something into her sleeve. It's a hair. It's one of yours."], event_id)
      state[:thynelight_at] = (state[:rs_day] || 0)
      return
    end
    if !flag?(:thynelight_caught) && (state[:rs_day] || 0) > (state[:thynelight_at] || 0)
      thynelight_double(event_id)
    else
      say(["MIRA THYNELIGHT: (sewing) Lovely hair, you've got. Lovely. Just lovely."], event_id)
    end
  end

  def thynelight_double(event_id = nil)
    set_flag(:thynelight_caught)
    say(["Across the promenade, someone is walking toward you. They're wearing your coat. Your face.",
         "Your hair, exactly. Even the way you walk is nearly right.",
         "MIRA THYNELIGHT: (still sewing, very quietly) Oh. Oh no. It wasn't supposed to be finished yet.",
         "The garment-double smiles your smile at you, and lunges."], event_id)
    return if !boss_battle(named_mon(:B132H122, 42, "Garment-Double"))
    sayc(["The double comes apart into thread. Hundreds of threads, and every one of them a hair or a fibre of yours.",
          "MIRA THYNELIGHT: Maera said they were for a festival. For a pageant. Heralds in the procession.",
          "MIRA THYNELIGHT: She didn't say they'd walk on their own. I'll stop. I'll stop. Here, take your hair back.",
          # (only the watchers you've caught: dialogue 15 #13)
          (flag?(:watcher_moth_swarm) && flag?(:watcher_weasel) ?
             cl(:alberica, "Lumea's moths, Maera's weasels, now my own face. This city collects us like stamps, darling.") :
             cl(:alberica, "My own face, walking about without me. This city collects us like stamps.")),
          cl(:reptin, "Then let's be the kind of stamp that sticks in the throat.")].compact)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # 18. Shivven Pearlbite: a white dragonborn ice-diver who saw a silhouette like
  # Auril's avatar in the frozen deep, and can't sleep.
  #-----------------------------------------------------------------------------
  def shivven(event_id = nil)
    if first_time?(:met_shivven)
      say(["A white dragonborn crusted in frost, with gills along the neck, stares at the sky. Then at the water. Then at the sky.",
           "SHIVVEN: Shivven Pearlbite. I dive the cold half for fish. Relic fish. They taste of four hundred years.",
           "SHIVVEN: I haven't slept in nine days. Ask me why. No. Don't."], event_id)
      return
    end
    if !flag?(:shivven_told)
      set_flag(:shivven_told)
      say(["SHIVVEN: (to the sky) Fine. Under the frozen half. Deep. Where the ice goes blue-black.",
           "SHIVVEN: A shape in the ice. A woman. Tall as the Hearth. Arms out. Like she's holding something up.",
           "SHIVVEN: Or holding something down.",
           "SHIVVEN: Her eyes were open. I think. I didn't stay to see if they moved. I came up so fast I bled.",
           "SHIVVEN: Every night since, I dream I'm still down there. And she's closer."], event_id)
      sayc([cl(:alberica, "(a hand flat on her chest, over the rune) ...She's not under the lake, darling. She's just very good at mirrors."),
            cl(:alerion, "Auril's avatar. Or her shadow. Either way: she's watching the water.")].compact)
    else
      say(["SHIVVEN: (to the sky) Still haven't slept. Still not diving. Still dreaming of diving."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 19. Professor Halden Vex: a temporal researcher in the Library who believes
  # you are displaced centuries and means to "reset" you to your origin.
  #-----------------------------------------------------------------------------
  def halden_vex(event_id = nil)
    if first_time?(:met_halden)
      say(["A gnome with a shock of white hair and ink-stained gloves talks in spirals and then circles back.",
           "HALDEN: Professor Halden Vex, temporal research, where was I, ah. You. You're four centuries out of place.",
           "HALDEN: Like a book on the wrong shelf. The library notices. The library is... uncomfortable.",
           "HALDEN: I'm building something. To put things back. On their proper shelves. Where was I. Ah. Good day."], event_id)
      set_switch(SW_HALDEN, true) if flag?(:ch7_started)
      return
    end
    halden_reset(event_id)
  end

  def halden_reset(event_id = nil)
    if flag?(:halden_done)
      return say(["HALDEN: The engine's in pieces. My hypothesis is in pieces. You are... on the right shelf, apparently."], event_id)
    end
    if !flag?(:ch7_started)
      return say(["HALDEN: Not ready. Not ready. Calibrating. Come back when the tree's had a bad night."], event_id)
    end
    say(["Halden has filled a corner of the Library with brass rings, crystal leaves and a humming chair.",
         # (the Journey kid and Wyn are from Rootspire: context 15 §6)
         outsider? ? "HALDEN: Ready! Sit, sit. A small reset. Back to before you left. You'll hardly notice." :
                     "HALDEN: Ready! Sit, sit. A small reset. Back to your origin. Targos, four hundred years ago. You'll hardly notice.",
         "HALDEN: Your Pokémon may not come with you. Footnote. Small footnote."], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("\"No.\""), _INTL("Talk him out of it."), _INTL("Break the engine.")], 0)
    if c == 1
      speak(:alberica, "Halden, darling. Every book in here was on the wrong shelf once. That's how libraries grow.",
            "...Some books belong where they ended up.") if with_or_is?(:alberica)
      sayc([cl(:reptin, "We're not out of place, Professor. We're the place. The tree grew round us. Ask it.")].compact)
      set_flag(:halden_done)
      wheel(1)
      return say(["HALDEN: (spiralling, then circling back, very slowly) ...The tree grew round them. The tree grew round them.",
                  "HALDEN: Then the shelf is them. Then I've built a very expensive chair. Excuse me. I need to sit in it."])
    end
    say(["HALDEN: (as the rings start to spin) No? No is a temporal anomaly! Hold still! For science!"])
    return if !pbTrainerBattle(:FT_SCHOLAR, "Halden Vex", nil, false, 0)
    set_flag(:halden_done)
    set_switch(SW_HALDEN, false)
    say(["The rings wobble and fall over one by one. The chair stops humming.",
         "HALDEN: Fascinating. Distressing. Fascinating. You resisted. Time resisted with you.",
         "HALDEN: Perhaps you aren't out of place. Perhaps the place is you. Where was I. Ah. Sorry."])
  end

  #-----------------------------------------------------------------------------
  # 20. Rilka Dawnshard: a wandering monk with sunburst and snowflake tattoos,
  # sent by Glimmer's future church (the faith of the Dagger Reborn) to make sure
  # the Heralds survive what's coming.
  #-----------------------------------------------------------------------------
  def rilka(event_id = nil)
    if first_time?(:met_rilka)
      say(["A half-orc monk with sunbursts and snowflakes tattooed down both arms bows with her eyes closed before she speaks.",
           "RILKA: Rilka Dawnshard. I meditate on the balance of the seasons. And on you.",
           "RILKA: I was sent to see that you survive what's coming. By a church that doesn't exist yet."], event_id)
      return
    end
    if flag?(:glimmer_gone) || flag?(:engine_dead)
      if first_time?(:rilka_after)
        say(["Rilka bows. Her eyes stay closed for a long time.",
             "RILKA: Now I can tell you. My church is his. The Dagger Reborn. The cat who knelt in the light.",
             "RILKA: In my time, children light a candle for him on the longest night. They hum four notes.",
             "RILKA: I was sent to make sure you survived. All of you. I failed one. He would not let me not.",
             "RILKA: He said it was what torches are like."], event_id)
        sayc([cl(:alberica, "(very quiet) ...Of course he did. Of course he bloody did."),
              cl(:meat_meat, "Fluffy one has a church. Meat Meat will go to it. Meat Meat will bring snacks for the candle."),
              cl(:alerion, "Four notes. He never got them right. ...Tell your children to sing them wrong.")].compact)
        return
      end
      return say(["RILKA: (eyes closed) The wheel turns. I'm still watching the rest of you."], event_id)
    end
    say(["RILKA: (eyes closed) Not yet. I'm not allowed to say yet. Stay close to each other. Especially the warm one."], event_id)
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
           "Behind them, an elegant half-elf with black hair. She's warm, and distracted, and always surrounded by reflections.",
           "MIRA: Mira of the North Wind. Captain of the Auroral Corsairs, when I'm at sea. Merchant, when I'm not.",
           "MIRA: Frost-glass, straight from the permafrost. Look into one at midnight. We- I find it's best at midnight."], event_id)
    end
    talk(:mira_north_wind)
    if !flag?(:mirror_child_free)
      say(["MIRA: (smiling at nothing) My daughter's at home. We- I put her to bed. She's... somewhere wet. She likes the water.",
           "MIRA: She'll be up soon. She always looks in my mirrors when she thinks I'm not watching."])
    end
    if flag?(:met_mirror_child) && !flag?(:mirror_twin_known)
      say(["MIRA: The child? The boy with the mirror? I... I swear it's just a scrying shard. Just a shard. We swear."])
    end
    if !flag?(:mira_shard_bought) && pbConfirmMessage(_INTL("MIRA: A mirror for you? Five hundred. It pulses near anything interesting."))
      if $Trainer.money >= 500
        $Trainer.money -= 500
        set_flag(:mira_shard_bought)
        say(["MIRA: Lovely. Keep it near your heart. Or don't. It doesn't mind.",
             "The shard of mirror is cold in your hand. In it, behind your shoulder, for a moment, someone is smiling."])
        give(:FT_STILLSHARD)
      else
        say(["MIRA: Another time. We- I'll be here."])
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
    say(["CHILD: I bought it from the lady. It's got a friend in it. She talks when the others aren't looking.",
         "The reflection's mouth moves. The boy's doesn't. The voice is a woman's, pleasant and precise:",
         "\"Hello again, variables. You broke the hag's glass. I was using it as a door.\"",
         "\"I'm cold. My other half is down in the roots. Bring it here and I'll let the boy go.\"",
         "\"Or don't, and I'll keep him. Children are very good at looking.\"",
         "\"There's a girl in my other half already. Mira's girl. She looked too long.\"",
         "Behind the boy's reflection, for a blink, another face: a woman with hollow eyes and a crown of ice.",
         "CHILD: She says that a lot. Can you make her stop?"])
    if first
      sayc([cl(:meat_meat, "(very still) That voice. Meat Meat knows that voice. From the cold table."),
            cl(:meat_meat, "Variables. Her word for us. Things you change, to see what breaks."),
            cl(:alberica, "Shh, sweetheart. Look at me, not the glass. Big breath. We're going to find the other half and break it."),
            cl(:alerion, "The twin. In the Heartroot. Somewhere wet, where it can watch the sap.")].compact)
    end
    boy_mirror_exorcism if !has_key?(:FT_BOYSMIRROR) && !flag?(:twin_broken)
  end

  # Quest M2 (rootspire.md 8317-8331): Meat Meat's. Know the reflection for a
  # trapped spirit, calm the boy, and take the mirror off him without hurting
  # him; then carry it down to its twin in the Heartroot.
  def boy_mirror_exorcism
    if !with_or_is?(:meat_meat)
      return say(["(The reflection keeps looking past you, for someone smaller. Meat Meat should be here for this.)"])
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
              "MEAT MEAT: (low) Not the boy. Something in the glass, wearing the boy's face. Meat Meat knows how that feels."])
    c = pbMessage(_INTL(mm ? "How do you calm the boy?" : "How does Meat Meat calm the boy?"),
                  [_INTL("\"Meat Meat had a mirror lady too. Meat Meat got away. You will.\""),
                   _INTL("\"Hold still and don't cry.\""), _INTL("Just grab it")], 0)
    if c != 0
      mirror_lash("The boy screams and clutches the mirror tighter. Frost bites up his fingers, and the reflection lashes out.")
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
    side_goal(:mirror_boy, "Carry the boy's mirror down to its twin: in the Heartroot's Overflow Channel, where Mira's girl is trapped.", done: :twin_broken)
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
      return say(["CORSAIR: (not looking at you) Captain says \"we\" all the time now. The girl sleeps in the hold, by the humming thing.",
                  "CORSAIR: You were down there. You could've broken it. ...Move along."], event_id)
    end
    if flag?(:mira_freed) && first_time?(:corsair_symbol)
      say(["He shows you the tattoo on his wrist: a ship's wheel inside a spiral of aurora.",
           "CORSAIR: Captain's back. Proper back. One voice. We'd sail into the frozen half for you now."])
    end
  end
end
