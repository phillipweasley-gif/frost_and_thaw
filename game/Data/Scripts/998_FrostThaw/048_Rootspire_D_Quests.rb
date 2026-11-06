#===============================================================================
# Frost & Thaw - Rootspire as a living city (part D): the city's quests
#
#   The Halo splinter at the twin orb (Canopy hook C1)
#   Kelyn's secret: Razzilith's dreams, the mural, the verdant surge (Autumn's plot)
#   The Rootwardens: Rheven's counsel (R1's city half), the Oath of Roots, the
#     Still Beast and the reanimated Bough patrol, the infiltrator ("A Season
#     Too Long", Kethan's suspicion) and Kethan's duel
#   Eren Frostborn and the gift of memory
#   The intrigue aimed at Glimmer: Selrae and her black-ice dagger, Eline's
#     conversion (in 024's Rite), Wynsnow's offer (the Chronal Debt)
#   The Auroral Corsairs: the Requiem's relic vault, the Frozen Run
#   Eirwen's ritual (relive one day of the frozen past), Frostshard Sigil 2,
#     researching the sigils with Wynsnow, Tree Communion
#   The Guild's Amber Experiment
#   Reptin's Pulse of the Blooming Fields (R2); Alerion's Echoes at the Wall (A1)
#   The Verdant Heist (Meat Meat's M1) in the Smuggler's Run
#   The Frozen Cellar under the old brewery (the Fractured Halo's second hideout)
#   The watchers
#===============================================================================
module FrostThaw
  RELIC_ITEMS.merge!(
    FT_SCALECORE: ["Wyrmling Scale Core", "Wyrmling Scale Cores", 8, 0,
      "A crystal core grown hard round a cluster of green wyrmling scales, shed by Razzy at the cold table. Labelled RAZ-MKIII. Avarice wanted it back badly.", 0, 0, 6]
  )

  TEXT.merge!(
    kelyn_mural: [{ if: { flag: :kelyn_secret }, lines: ["Kelyn's alcove. The old mural: an elf with a wolf's shadow, and a cat-shaped figure in gold.",
                                                         "The first proof the Heralds were real. Kelyn has hung a sprig of fresh green over it."] },
                  ["Behind the High Speaker's seat, an alcove with an old, old mural on the bark.",
                   "Two figures: an elf with a wolf's shadow at his heels, and someone small and cat-shaped, wreathed in light.",
                   "Underneath, in the oldest Wennen: THE FIRST OF THEM. THEY WERE REAL."]],
    orb_halo: ["Two robed figures kneel at the orb, pouring something white and freezing into the light."],
    requiem_vault_shut: ["A strongbox lashed to the pier, stamped with a ship's wheel in a spiral of aurora. Locked.",
                         "CORSAIR: Captain's vault. Confiscated relics. Not without the Captain."],
    amber_assessor_done: ["GUILD ASSESSOR: The Amber Experiment is suspended. Pending a long, hard look at our consciences."],
    fields_spirits_calm: ["Flowers and snow lie together here now, peacefully. Two small whirls of warm and cold air chase each other, playing."]
  )

  # Herald Wyn is a Rootwarden: Ash is a colleague, not a stranger (context 15 §6).
  class << self
    alias_method :trainer_intro_before_wyn, :trainer_intro if method_defined?(:trainer_intro) && !method_defined?(:trainer_intro_before_wyn)
  end

  def self.trainer_intro(key, event_id = nil)
    if key == :warden_ash && herald?(:wyn)
      return say(["ASH: Wyn. Everyone's claiming to be a Herald this week. You, I'd believed were dead."], event_id)
    end
    trainer_intro_before_wyn(key, event_id)
  end

  module_function

  #-----------------------------------------------------------------------------
  # The Halo splinter at the orb: they'd channel Auril's essence into Frostina.
  # Called from twin_orb (026) before the visions.
  #-----------------------------------------------------------------------------
  def orb_halo_scene
    return true if flag?(:halo_orb_cleared)
    sayc(["Two robed figures kneel at the orb between the spires, pouring something white and freezing into the light.",
          "The orb's green goes grey where it touches. The white deepens to blue.",
          "SISTER ILSE: She's the goddess's daughter. The Frost Saint said so. Let her mother in.",
          "BROTHER VOSK: The Matron said winter's daughter comes home through this orb. Through it, into her.",
          "LUMIN: (from the shrine steps) The Fractured Halo. They pray for her winter to come back.",
          cl(:alerion, "(very quietly) Into Frostina."),
          cl(:alberica, "Over my dead body, darlings. And I'm very hard to kill.")].compact)
    return false if !pbTrainerBattle(:FT_HALO, "Sister Ilse", nil, false, 0)
    return false if !pbTrainerBattle(:FT_HALO, "Brother Vosk", nil, false, 0)
    set_flag(:halo_orb_cleared)
    set_switch(SW_ORB_HALO, false)
    $game_switches[SW_HALO_ORB] = true if $game_switches
    add_counter(:trainers_beaten, 2)
    sayc(["The cultists run for the root-lift. The white stuff in the orb boils off as steam.",
          "LUMIN: (shaking) They've been coming every night. I thought they were praying. They were pouring.",
          cl(:reptin, "They'll be back. Fanatics are terribly reliable.")].compact)
    true
  end

  #-----------------------------------------------------------------------------
  # Kelyn's secret. She communes with Razzilith's dreams through the orb at
  # night, looking for a way to wake the Verdant wyrm fully. Autumn means to use
  # that: feed her the dream of a green crown, let her use the Heralds' relics to
  # "quicken" the tree, and let Summer come back to a burning (Pellar's note).
  #-----------------------------------------------------------------------------
  def kelyn_orb(event_id = nil)
    if flag?(:kelyn_secret)
      return say(["KELYN: (at the orb, very quietly) He's dreaming of you tonight. Of a meadow. Go on. I'll keep watch."], event_id)
    end
    say(["Night on the Canopy. The High Speaker is alone at the orb, both hands on the light, eyes shut.",
         "Green fire runs up her arms and back down, like breath.",
         "KELYN: (opening her eyes, not surprised) ...Heralds. You've caught me.",
         "KELYN: I speak with him. With Razzilith. In his dreams. Through the orb. I have for years.",
         "KELYN: He's only half awake. He's been half awake for four hundred years, waiting for his partner.",
         "KELYN: If I could wake him fully... spring, real spring, would roll down this valley like a flood."], event_id)
    if flag?(:autumn_note)
      say(["KELYN: There's a way. A friend showed me, in a dream of a green crown. With your relics: the staff, the blade, the key.",
           "KELYN: Lend them to me. One night. I'd quicken the tree, and the wyrm, and the winter would never-"])
    else
      say(["KELYN: I've dreamed of a way. A green crown. Your relics, placed at the orb, one night. The tree would quicken.",
           "KELYN: I don't know where the dream came from. It came very kindly."])
    end
    choices = [_INTL("\"Lend her a relic.\""), _INTL("\"It's a trap. Autumn's using you.\""), _INTL("\"Not tonight.\"")]
    c = pbMessage(_INTL("What do you tell Kelyn?"), choices, 2)
    case c
    when 0
      kelyn_surge
    when 1
      if flag?(:autumn_note)
        sayc(["You show her Pellar's dropped note. \"K. is ready. Feed her the dream of a green crown.\"",
              "KELYN: (very still) ...Lumea. Lumea, who painted my portrait. Who sits beside me at every festival.",
              "KELYN: 'Then Summer returns to a burning.' Springfire. Uncontrolled. The whole valley.",
              "KELYN: I'd have done it. I'd have done it smiling.",
              cl(:reptin, "You'd have done it hoping. That's not the same as wicked. It's just easier to aim."),
              cl(:meat_meat, "Razzy does not want fire. Razzy wants Meat Meat. And snacks. Ask him properly.")].compact)
        set_flag(:kelyn_secret); set_flag(:kelyn_warned)
        wheel(1)
        add_counter(:story_beats)
      else
        say(["KELYN: A trap? From whom? ...You don't know. Then neither do I. Not tonight, then.",
             "(Something kind sent her that dream. You'd like to know who.)"])
      end
    else
      say(["KELYN: Another night. He'll still be dreaming. He's very good at it."])
    end
  end

  # Lending the relic: the verdant surge, and the Heralds stopping it.
  def kelyn_surge
    sayc(["Kelyn lays the relic against the orb. The light goes green, then gold, then far too bright.",
          "The leaves around the Shrine burst into flower. Then the flowers burst into flame. Green flame.",
          "Roots tear up through the platform, thrashing, blooming, burning.",
          "KELYN: No. No, no. That's not spring. That's not- STOP IT. Somebody stop it!",
          cl(:reptin, "It's not spring. It's a fever. Pin it down!")].compact)
    if !boss_battle(named_mon(:B182H126, 44, "Verdant Surge"))
      say(["The surge burns itself out at last, leaving the Shrine's floor scorched and green at once."])
    end
    set_flag(:kelyn_secret); set_flag(:kelyn_surge)
    add_counter(:story_beats)
    sayc(["The fire goes out. The flowers close. The roots settle, sullen, smoking.",
          "KELYN: (on her knees) Whoever sent me that dream wanted the valley burned. And wanted me to light it.",
          "KELYN: I'll never touch the orb for myself again. Only for him.",
          cl(:alberica, "Darling, you stopped. That's the part they'll leave out of the songs. It's the only part that matters.")].compact)
  end

  #-----------------------------------------------------------------------------
  # The Rootwardens
  #-----------------------------------------------------------------------------
  # Rheven at the Spire Armory: his dreams of a screaming tree; his belief the
  # Heartroot has become sentient and hungry and may have to be destroyed; his
  # question to Reptin, the founder of his creed: can violence ever serve balance?
  # (And R1's city half: "Will you cleanse it, or shall we cut away the rot?")
  def rheven_hall(event_id = nil)
    if !flag?(:rheven_counselled)
      say(["Rheven stands at the edge of the training yard, arms folded, watching the archers without seeing them.",
           "RHEVEN: The tree screams in my dreams. Every night now. Like something's eating it from under.",
           "RHEVEN: I think the Heartroot's woken. Not the tree. The root. And I think it's hungry.",
           "RHEVEN: If it's become a thing that eats, I'll burn it out. The whole root. Even if the tree dies with it.",
           with_or_is?(:reptin) ? "He turns to #{hn(:reptin)}. He looks, for a moment, very young." : "He turns to you."], event_id)
      if with_or_is?(:reptin)
        say(["RHEVEN: You wrote the creed. Guard the pulse. Can violence ever serve balance? Tell me true.",
             "RHEVEN: Will you cleanse it, Reptin? Or shall we cut away the rot?"])
        c = pbMessage(_INTL("What does Reptin tell him?"),
                      [_INTL("\"We cleanse it. You don't cut out a heart.\""), _INTL("\"Sometimes you cut. Never first.\""),
                       _INTL("\"I don't know. Let's find out together.\"")], 0)
        case c
        when 0
          speak(:reptin, "We cleanse it. You don't cut out a heart because it's sick. You sit with it. You find what's poisoning it.",
                "...We cleanse it. You don't cut out a heart.")
          set_flag(:rheven_mercy)
        when 1
          speak(:reptin, "Sometimes you cut. I've cut. But never first, Rheven. Not while there's a pulse left to guard.",
                "...Sometimes you cut. Never first.")
          set_flag(:rheven_balance)
        else
          speak(:reptin, "I don't know. I wrote that creed four hundred years ago in about ten minutes, slightly drunk. Let's find out together.",
                "...I don't know. Together, then.")
          set_flag(:rheven_together)
        end
        say(["RHEVEN: (a long breath) ...Then I'll hold my torch until you've looked. The roots under the gardens first.",
             "RHEVEN: The myconids say there's a blight there. Black sap. If that's the hunger, it can be cleaned. Can't it?"])
      else
        say(["RHEVEN: Can violence ever serve balance? I'd ask Reptin, if he were here. You'll do. Can it?",
             "RHEVEN: ...No, don't answer. Find the rot first. Then we'll know what kind of answer it needs."])
      end
      set_flag(:rheven_counselled)
      return
    end
    if flag?(:blight_burned) && !flag?(:rheven_blight_known)
      set_flag(:rheven_blight_known)
      return say(["RHEVEN: The black sap under the gardens is gone. The myconids sing about you.",
                  "RHEVEN: It wasn't the root that was hungry. Something was feeding on it. That I can hunt."], event_id)
    end
    still_beast_offer(event_id)
  end

  # The Still Beast (A2): a construct of bone and ice with Avarice's sigil,
  # prowling the thaw line. Rheven wants it caught alive.
  def still_beast_offer(event_id = nil)
    if flag?(:still_beast_done)
      return say(["RHEVEN: The Bough circle's patrols come home now. All of them. Guard the pulse, Heralds."], event_id)
    end
    if !flag?(:still_beast_asked)
      set_flag(:still_beast_asked)
      set_switch(SW_STILL_BEAST, true)
      say(["RHEVEN: Unnatural beasts stalk the thaw line. Constructs of bone and ice, marked with Avarice's sigil.",
           "RHEVEN: One prowls the Blooming Fields, by the Wall. My Bough circle went to look. Three didn't come back.",
           "RHEVEN: We found them frozen. And then they were gone again. Something wants them to get back up.",
           "RHEVEN: Bring me the beast alive, if you can. I want to see whose sigil it carries with my own eyes.",
           "He hands you a coil of barbed net, Rootwarden-woven. (A Poké Ball would do just as well, he admits.)"], event_id)
      side_goal(:still_beast, "The Still Beast prowls the Blooming Fields by the Wall. Rheven wants it alive.", done: :still_beast_done)
    else
      say(["RHEVEN: The Fields, by the Wall. Alive, if you can. A Poké Ball counts as alive."], event_id)
    end
  end

  def still_beast(event_id = nil)
    return say(["Only hoofprints of ice, melting into the flowers."], event_id) if flag?(:still_beast_done)
    sayc(["Between the snowdrifts, three Rootwardens of the Bough circle stand up out of the frost.",
          "Their eyes are glass. Their cloaks are stiff. Behind them, a hunched thing of bone and ice, a sigil burned in its brow.",
          cl(:alberica, "Oh, you poor loves. Somebody's wearing you."),
          cl(:wyn, "(barely a whisper) That's Teo's sister. That's- I knew her.")].compact, event_id)
    return if !boss_battle(named_mon(:B91H93, 41, "Reanimated Bough Warden"), named_mon(:B91H93, 41, "Reanimated Bough Warden"))
    say(["The frozen Wardens fall, and stay fallen. Their faces have gone peaceful.",
         "The thing of bone and ice lowers its head. The sigil in its brow is a cracked mirror around an A.",
         "It's the Still Beast. It charges."])
    sw = (SWITCH_CANNOT_CATCH_POKEMON rescue 75)
    was = $game_switches[sw]
    $game_switches[sw] = false
    setBattleRule("cannotRun")
    decision = pbWildBattleCore(named_mon(:B225H427, 42, "Still Beast")) rescue 0
    $game_switches[sw] = was
    set_flag(:still_beast_done)
    set_switch(SW_STILL_BEAST, false)
    add_counter(:story_beats)
    if decision == 4
      set_flag(:still_beast_alive)
      wheel(1)
      sayc(["Caught. Alive. Inside the ball it rattles once, then settles, like it's glad of the dark.",
            "Back at the Armory, Rheven turns the ball over and over in his huge hands.",
            "RHEVEN: Avarice's sigil. On a living thing. You brought it home breathing. That's the creed, Heralds.",
            cl(:alerion, "Winter's cruelty, held still. ...It's harder than killing. It's better.")].compact)
    else
      sayc(["The Still Beast shatters. A burst of mirror-shards sprays across the snow, cutting flowers off at the stem.",
            "In every shard, for a moment: a woman's smile.",
            "RHEVEN: (later, at the Armory) Dead, then. And it burst into her glass. So her sigils can corrupt even the wild.",
            "RHEVEN: That's worth knowing. I wish I didn't."])
    end
  end

  # The Oath of Roots: the Rootwardens' own initiation, before the living pillar
  # in the Hall. Mercy and fury, both, balanced.
  def oath_pillar(event_id = nil)
    if flag?(:oath_of_roots)
      return say(["The living pillar in the Hall beats slow and warm under your hand. It knows you."], event_id)
    end
    if !flag?(:rheven_counselled)
      return say(["A pillar of living root rises through the Hall's floor, carved with the wolf's paw over a leaf.",
                  "WARDEN: The Oath of Roots is taken here. Captain Rheven gives it. Not to strangers."], event_id)
    end
    say(["Rheven stands before the living pillar. Every Warden in the Hall has stopped to watch.",
         "RHEVEN: You swore the Council's oath. This is ours. The Oath of Roots. Every Warden takes it. Even founders.",
         "RHEVEN: Before the tree: balance mercy and fury. Show it what you are when it matters."], event_id)
    say(["Two Wardens drag in a Halo cultist, caught cutting sap-lines with a mirror-shard. He spits frost at you.",
         "HALO CULTIST: Kill me, then. The Frost Saint will thaw me out and send me back.",
         "Behind him, his Sneasel is crouched over the cut sap-line, still trying to freeze it shut."])
    c = pbMessage(_INTL("Before the living tree, what do you do?"),
                  [_INTL("Mercy: let him go."), _INTL("Fury: put him down."), _INTL("Both: stop the harm, spare the man.")], 2)
    case c
    when 0
      say(["You let him go. He runs. His Sneasel stays at the sap-line, and the sap freezes, and the pillar shivers.",
           "RHEVEN: Mercy, with nothing to catch the harm. The tree felt that. Again."])
    when 1
      say(["You step toward him. The pillar goes hot under your hand. Too hot.",
           "RHEVEN: Fury, before you'd seen what the harm was. The tree felt that too. Again."])
    end
    if c != 2
      return if !pbConfirmMessage(_INTL("Try the oath again?"))
    end
    say(["You stop the Sneasel first: the harm. Then you turn to the man.",
         "HALO CULTIST: (snarling) Well? Get on with it."])
    return if !pbTrainerBattle(:FT_HALO, "Halo Knife", nil, false, 0)
    set_flag(:oath_of_roots)
    wheel(1)
    add_counter(:story_beats)
    sayc(["You beat him, and you don't finish him. You hand him back to the Wardens, alive, and mend the sap-line yourself.",
          "The living pillar beats under your palm: once, slow and warm.",
          "RHEVEN: Root and oath. The tree holds you now, and you hold it. ...I've never said that to a founder.",
          "RHEVEN: Wardens of Rootspire, and Rootwardens. Both oaths, now. The Hall's yours.",
          cl(:reptin, "(hoarse) I didn't think it would feel like this. Taking my own creed. From him."),
          cl(:alberica, "That's what a legacy is, sweetheart. Somebody hands you back what you gave away.")].compact)
  end

  # Captain Kethan's business: "A Season Too Long" (the cycle stalled on summer,
  # and a Rootwarden ritual gone wrong), and the Summer infiltrator in his ranks.
  def kethan_business(event_id = nil)
    if flag?(:ash_exposed)
      if !flag?(:kethan_dueled)
        if pbConfirmMessage(_INTL("KETHAN: (pop, pop) You found my traitor. I'd like to know your fists are as honest as your eyes. Spar?"))
          if pbTrainerBattle(:FT_WATCHMAN, "Kethan", nil, false, 0)
            set_flag(:kethan_dueled)
            say(["KETHAN: (cracking his knuckles, satisfied) Truthful. All of you. That's rarer than you'd think, up here."])
            give(:FOCUSBAND)
          end
        end
      else
        say(["KETHAN: Order's kept. For today. Tomorrow I'll keep it again."])
      end
      return
    end
    if !flag?(:kethan_suspects)
      set_flag(:kethan_suspects)
      say(["KETHAN: (pop, pop) You want to know why the seasons stopped at summer. Kelyn's asked you. I know.",
           "KETHAN: Thirty years ago my predecessors did a thing. The Rite of the Long Gold. To hold back a hard winter.",
           "KETHAN: Bind the turning of the year to the Heartroot's pulse. Just for one season. It worked.",
           "KETHAN: Then the season never ended. A ritual gone wrong, they said. Wrong, or turned.",
           "KETHAN: And now somebody inside my Hall is feeding the Halo and Summer both. Patrol routes. Sap-lines. Names.",
           "KETHAN: I want them found quietly. Bring me proof, not shouting."])
      side_goal(:infiltrator, "Kethan wants the infiltrator in the Rootwardens found: proof, not shouting.", done: :ash_named)
      return
    end
    clues = [:warden_map_seen, :jorik_confessed, :autumn_note, :gem_vibrates].count { |f| flag?(f) }
    say(["KETHAN: (pop) What have you got? Proof, mind. Not shouting."])
    if clues < 2
      say(["KETHAN: Not enough. Look at who moves the patrol pins. Who carries what off the docks. Who passes notes."])
    else
      found = []
      found << "the patrol pins moved to the Wall's edge" if flag?(:warden_map_seen)
      found << "the ore off the docks" if flag?(:jorik_confessed)
      found << "the notes between Autumn's people" if flag?(:autumn_note)
      found << "the gem that hums toward the Root-Gate Ash guards" if flag?(:gem_vibrates)
      list = found.size > 1 ? "#{found[0..-2].join(', ')} and #{found[-1]}" : found[0]
      say(["You lay it out: #{list}.",
           "One name sits under all of it: the Warden on the civic ring's south steps. Ash.",
           "KETHAN: (very quietly) Ash. Ash trained half my initiates.",
           "KETHAN: Go and talk to him. I'll be watching. If he runs, he runs into me."])
      set_flag(:ash_named)
    end
  end

  def warden_ash(event_id = nil)
    if !flag?(:ash_named)
      return say(["A Rootwarden on the south steps, polishing a bark shield that's already polished.",
                  flag?(:festival_night) ? "ASH: #{herald?(:wyn) ? 'Wyn. ' : ''}The Root-Gate's sealed. Council orders. Nobody's said why." :
                                           "ASH: #{herald?(:wyn) ? 'Wyn. ' : ''}The Root-Gate's sealed. Council orders, till the festival's done."], event_id)
    end
    sayc(["ASH: (not looking up) Kethan sent you. He never could do his own talking.",
          "ASH: Yes. I moved the pins. I sent the Bough patrols where the cold could have them.",
          "ASH: Summer pays. The Halo pays. Balance never paid anyone.",
          "ASH: And the Rite of the Long Gold? My old captain did it right. Somebody underneath took the end of it and held on.",
          "ASH: I just made sure nobody went down to see who.",
          cl(:reptin, "Guard the pulse, Ash. You were supposed to guard the pulse.")].compact, event_id)
    return if !pbTrainerBattle(:FT_TURNCOAT, "Ash", nil, false, 0)
    set_flag(:ash_exposed)
    set_switch(SW_ASH_EXPOSED, true)
    add_counter(:story_beats)
    sayc(["Kethan's hand closes on Ash's shoulder from behind. Neither of you heard him come. Neither did Ash.",
          "KETHAN: Rootwarden Ash. The Hall will hear you. Not me. The Hall.",
          "ASH: (as they lead him away) It's not the Hall that's rotten. It's whoever's holding the other end.",
          cl(:alerion, "The Rite of the Long Gold. Somebody's still holding the rope."),
          cl(:alberica, "Then we cut the rope, sweetheart. And pull her up with it.")].compact)
  end

  #-----------------------------------------------------------------------------
  # Eren Frostborn: Auril offers him "the gift of memory" in his dreams. If he
  # takes it, Alerion's soul will fragment. Pupil, or tragic mirror.
  #-----------------------------------------------------------------------------
  def eren_armory(event_id = nil)
    if flag?(:eren_settled)
      return say(flag?(:eren_pupil) ? ["EREN: (stringing his bow) Again tomorrow, at dawn? ...Yes. I'll be there first."] :
                                      ["EREN: I'm patrolling the Wall again. I sleep. I don't dream. That's enough."], event_id)
    end
    say(["Eren sits on the Armory's steps with a bow across his knees: pale, almost translucent, the colour of new ice.",
         "EREN: It's carved from one of Frostina's shed scales. She dropped it at the Wall. I like to think on purpose.",
         "EREN: I've been dreaming. A woman in white furs, every night. She offers me a gift. The gift of memory.",
         "EREN: Every winter there ever was. Every name. Everything my family forgot. All I have to do is say yes.",
         herald?(:alerion) ? "As he says it, something pulls at you. Behind your ribs. Like a thread being drawn out of a coat." :
                             "As he says it, Alerion puts a hand to his chest, as if something had pulled."], event_id)
    speak(:alerion, "Don't. Whatever she gives you, she takes from somewhere. I think she'd take it from me.",
          "...Don't take it. It's mine she'd give you.")
    c = pbMessage(_INTL("What do you tell Eren?"), [_INTL("\"Refuse her. Learn it the slow way, with us.\""), _INTL("\"It's your choice.\"")], 0)
    if c == 0
      sayc(["EREN: (after a long time) ...The slow way. Will you teach me? The cold. How you made it kneel.",
            herald?(:alerion) ? nil : cl(:alerion, "I didn't make it kneel. I asked it to sit. ...Dawn. Here. Don't be late."),
            herald?(:alerion) ? "(You hear yourself say: Dawn. Here. Don't be late.)" : nil].compact)
      set_flag(:eren_pupil)
    else
      say(["EREN: My choice. ...Then I choose to see what she sees.",
           "Frost blooms across his lashes. His eyes go far away, past the Hall, past the Wall."])
      return if !pbTrainerBattle(:FT_DREAMER, "Eren", nil, false, 0)
      sayc(["Eren drops his bow. The frost runs off his face like water.",
            "EREN: She showed me everything, and none of it was mine. ...I'm sorry. I'm sorry. Is he alright?",
            cl(:alerion, "(steadying himself) I'm here. All of me. ...Mostly. Come to the Wall at dawn. I'll show you the slow way.")].compact)
      set_flag(:eren_pupil)
    end
    set_flag(:eren_settled)
    set_switch(SW_EREN_TROUBLED, false)
    wheel(1)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # The intrigue aimed at Glimmer: Selrae courts him as Auril's vessel (and
  # names Avarice's vault "the White Womb"); Wynsnow offers him and Alberica the
  # centuries they missed (the Chronal Debt).
  #-----------------------------------------------------------------------------
  def selrae_hall(event_id = nil)
    return talk(:selrae_vorn, event_id) if flag?(:rite_stopped)
    return if selrae_court(event_id)
    if flag?(:selrae_courted) && !flag?(:selrae_halo_known) && flag?(:eline_named_selrae)
      set_flag(:selrae_halo_known)
      return say(["SELRAE: (before you can speak) Yes. I give the Halo coin. I give them a roof. I gave them the Shrine.",
                  "SELRAE: A tempered faith keeps the goddess appeased. A starved one goes looking for blood.",
                  "SELRAE: I was her priestess once. I know what she's like hungry. Better a cult I can see than one I can't."], event_id)
    end
    talk(:selrae_vorn, event_id)
  end

  # Selrae courts the Sparkbearer as Auril's vessel: the light that came back
  # (Glimmer), or the knife-bearer the Rimefang already marks for Auril (Shade).
  def selrae_court(event_id = nil)
    return false if flag?(:selrae_courted) || flag?(:rite_stopped)
    who = with_or_is?(:glimmer) ? :glimmer : (with_or_is?(:shade) ? :shade : nil)
    return false if !who
    set_flag(:selrae_courted)
    me = herald?(who)
    name = who == :glimmer ? "Glimmer" : "Shade"
    say(["As the session breaks up, the Winter Matron steps down from her seat and inclines her head to #{me ? 'you' : name}. Only to #{me ? 'you' : (who == :glimmer ? 'him' : 'them')}."], event_id)
    if who == :shade
      # (context 06, M6-4: the Rimefang and its curse, first said in a fight)
      say(["SELRAE: (low) Knife-bearer. That knife at your hip. The Rimefang."])
      speak(:shade, "It's a knife. It came out of Saltmarsh with me. It's been cold ever since.", "...It's a knife.")
      say(["SELRAE: Cold because it's hers. It marked you for her that night. You're halfway home."])
    else
      say(["SELRAE: (low) Sparkbearer. A light that came back through a mirror. Emptied, and filled."])
    end
    say(["She draws a dagger of black ice from her sleeve and turns it so it catches the crystals' light.",
         "When the light touches it, it whispers. Prayers. Old ones. To Auril.",
         "SELRAE: The goddess needs no throne. Only a heart that can hold light and cold together.",
         "SELRAE: Yours, perhaps.",
         "SELRAE: There's a vault in the ice, far north. The White Womb. They'd make a saint there."])
    if who == :shade
      speak(:shade, "My sister was somebody's vessel. I carried her out. Put the knife away, Matron.",
            "...Put the knife away.")
    else
      speak(:glimmer, "I've been through one mirror for a goddess. That was enough. Put it away, Matron.",
            "...Put the knife away.")
    end
    sayc([cl(:alberica, "'The White Womb.' She said it like a prayer. Did you hear her? Like a prayer."),
          cl(:alerion, "She knows where the vault is.")].compact)
    set_flag(:selrae_white_womb)
    true
  end

  # At the Rite of Stillness, Eline tries to bring the Sparkbearer, and the
  # Winter Matron, into the Halo.
  def eline_conversion
    who = with_or_is?(:glimmer) ? :glimmer : (with_or_is?(:shade) ? :shade : nil)
    if who
      me = herald?(who)
      say(["ELINE: (turning, with a terrible gentleness) And you. #{who == :glimmer ? 'Sparkbearer' : 'Knife-bearer'}.",
           "ELINE: The cold in your blade knows the way home. You've felt it. Every night since Saltmarsh.",
           "ELINE: Kneel with us. Let her finish what the knife began. You'd never grieve again. Nothing that is still can grieve."])
      c = pbMessage(_INTL("Eline holds out her hand..."), [_INTL("\"No.\""), _INTL("\"...Never grieve again?\"")], 0)
      if c == 1
        say([me ? "(For one breath you want it more than anything.)" : "For one breath, #{who == :glimmer ? 'Glimmer' : 'Shade'} wants it more than anything.",
             "Then Alberica's hand is on #{me ? 'your' : 'the'} shoulder, and the breath is over."])
      end
      speak(who, "I'd rather grieve. It means I had something.", "...No.")
    end
    say(["ELINE: And tell your Winter Matron her chair is beside mine. She's nearly ours.",
         "ELINE: Who do you think pays for the candles?"])
    set_flag(:eline_named_selrae)
  end

  # Wynsnow's other offer (the Chronal Debt): to let Glimmer and Alberica
  # remember what the centuries forgot, at the price of anchoring their
  # life-threads to Rootspire forever.
  def wynsnow_chronal(event_id = nil)
    return false if flag?(:chronal_debt_done) || !flag?(:lecture_done)
    return false if !with_or_is?(:alberica) && !with_or_is?(:glimmer)
    set_flag(:chronal_debt_done)
    names = [:alberica, :glimmer].select { |k| with_or_is?(k) }.map { |k| herald?(k) ? nil : HERALD_NAMES[k] }.compact
    say(["WYNSNOW: (lowering his voice) #{names.empty? ? 'You' : names.join('. ')}. A private word. Very private. Shut the door. No, the other door.",
         "WYNSNOW: Four hundred years happened while you were falling. I can let you see them. Remember them. As if you'd lived them.",
         "WYNSNOW: The price is... a small anchoring. Your life-threads, tied to Rootspire's. The fracture would heal round you.",
         "WYNSNOW: You'd never be able to leave. Not really. Not in the way that counts. A small price, for four centuries."], event_id)
    c = pbMessage(_INTL("Pay the Chronal Debt?"), [_INTL("\"No. Our lives aren't your stitching.\""), _INTL("\"Show us. Just a glimpse. No anchor.\"")], 0)
    if c == 1
      say(["WYNSNOW: A glimpse, unanchored? ...It'll cost something else, then. It always costs something.",
           "The air over his desk splits like ice. Through it, very fast: four hundred years.",
           "A sapling. Walkways. A woman with Hellen's chin carving the first mural. Two wyrmlings, small, chasing each other through a meadow.",
           "A council of three, then four, then three, with one name scraped out of the bark. A summer that comes and doesn't leave.",
           "The crack seals. Your nose is bleeding. So is everyone's.",
           "WYNSNOW: The cost. I did say. ...Remarkable. You saw the scraped name? Nobody's seen the scraped name."])
      set_flag(:chronal_glimpse)
    else
      say(["WYNSNOW: (deflating) No. Quite right. Quite right. I'd only have been tying you to my tapestry.",
           "WYNSNOW: That was the plan, you see. Stabilise the fracture by anchoring it to you. Forever.",
           "WYNSNOW: You're the only stitches holding this century to the last one. I was going to sew you in.",
           "WYNSNOW: ...Please don't tell the Council. Or do. I'd deserve it."])
      set_flag(:wynsnow_confessed)
    end
    sayc([cl(:alberica, "Darling, I've been tied to a lot of places. I'd rather choose the knots myself."),
          cl(:glimmer, "I've had enough of other people's anchors. Brightmane's is the only one I'm keeping.")].compact)
    true
  end

  #-----------------------------------------------------------------------------
  # The Auroral Corsairs: the Requiem's relic vault, and the Frozen Run
  #-----------------------------------------------------------------------------
  def requiem_vault(event_id = nil)
    return talk(:requiem_vault_shut, event_id) if !flag?(:mira_freed)
    if flag?(:mira_left_possessed)
      return say(["The strongbox is locked. On the deck above, Mira watches you through a hand-mirror, and smiles with both her voices.",
                  "MIRA: Ours, little failures. Everything on this ship is ours now."], event_id)
    end
    if flag?(:scale_core_given)
      return say(["The vault is open, and mostly empty. The Corsairs have started returning things to their owners."], event_id)
    end
    sayc(["MIRA: (unlocking it herself) My vault. Thirty years of confiscated relics. Thirty years of somebody else choosing what to keep.",
          "Frost-glass, chardalyn shavings, a mirror wrapped in sailcloth, a Halo prayer-token.",
          "And in a box of its own, padded with moss: a crystal core, grown hard and bright as jade round a cluster of small green scales. A tag: RAZ-MKIII.",
          "MIRA: That one hummed whenever the mirrors were loudest. She wanted it more than anything else on this ship.",
          herald?(:meat_meat) ? "You know those scales before Mira says anything. Razzy shed them on the cold table, the week before you ran." :
                                cl(:meat_meat, "(very small) Those are Razzy's. He shed them on the cold table. Before we ran."),
          "MIRA: A wyrmling scale core, the ledger says. Dormant. Take it. Keep it where she can't."].compact, event_id)
    give_key(:FT_SCALECORE)
    set_flag(:scale_core_given)
    add_counter(:story_beats)
  end

  def ivran(event_id = nil)
    return hellen_note_delivery(event_id) if respond_to?(:hellen_note_due?) && hellen_note_due?   # Hellen's errand (048_H)
    if flag?(:frozen_run_done)
      return say(["IVRAN: My sledge-ship's crossed the cold half three times since. No revenants. The crews sing about you, badly."], event_id)
    end
    if flag?(:ch7_started)
      say(["IVRAN: (watching the water) Heralds. I need an escort. The frozen half of the Glasswater, to the far shore.",
           "IVRAN: Trade has to cross it. The ice is old, and the crews frozen in it have started getting up again.",
           "IVRAN: Corsairs call it the Frozen Run. I'll take the sledge-ship. You walk the ice beside her and keep the dead off her.",
           "IVRAN: Get her across whole and the Corsairs pay. Coin, and a favour. We're good for both."], event_id)
      side_goal(:frozen_run, "Captain Ivran wants an escort across the Frozen Run, past the Split Dock. Corsairs pay.",
                done: :frozen_run_done)
      return if !pbConfirmMessage(_INTL("Escort Ivran's ship across the Frozen Run?"))
      say(["IVRAN: Walk the ice beside her. Don't stop for anything that waves."], event_id)
      set_switch(SW_FROZEN_RUN, true)
      transfer(2199, 2, 9, 6)
      return
    end
    talk(:ivran, event_id)
  end

  def scene_frozen_run_start
    sayc(["The far side of the Split Dock, where the water stops being water.",
          "The Glasswater's still half: snow on black ice, stretching away under the aurora, utterly silent.",
          "Ivran's sledge-ship creaks forward on runners, sails full of a wind you can't feel.",
          "Here and there in the ice: hulls. Crews, frozen at their oars, glass all the way through.",
          cl(:reptin, "The lake remembers. Every one of them."),
          cl(:alerion, "(very quietly) Some of them are getting up.")].compact)
  end

  def frozen_run_finish(event_id = nil)
    if flag?(:frozen_run_done)
      return say(["The far shore. The sledge-ship's runners rest on rock again. The ice behind you is still."], event_id)
    end
    if [:revenant_hask, :revenant_moirin, :revenant_tobe].count { |k| trainer_beaten?(k) } < 3
      return say(["The far shore is close, but behind you revenants are still walking the ice toward Ivran's ship.",
                  "IVRAN: (from the rail) Not yet, Heralds! The ones behind us!"], event_id)
    end
    set_flag(:frozen_run_done)
    set_switch(SW_FROZEN_RUN, false)
    wheel(1)
    add_counter(:story_beats)
    sayc(["The sledge-ship grinds up onto the far shore. The crew cheers. Ivran doesn't.",
          "IVRAN: (looking back across the ice, his glass eye catching the aurora) Look. Under the ice. Deep.",
          "Far below, where the ice goes blue-black: a shape. A woman, tall as a house, arms raised.",
          "For a moment her head seems to turn.",
          flag?(:met_shivven) ? "IVRAN: Shivven saw her. I didn't believe him. ...I believe him." :
                                "IVRAN: The old crews swore something lay under the ice. I didn't believe them. I do now.",
          "IVRAN: The Corsairs owe you. When you need to cross water, any water, you'll have a ship.",
          cl(:alberica, "(a hand over her rune, very pale) Let's go home, darlings. Now. Please.")].compact)
    give(:PEARLSTRING)
    set_flag(:corsair_favour)
    transfer(2055, 36, 8, 4)
  end

  def trainer_beaten?(key)
    map = $game_map.map_id rescue nil
    ev = ($game_map.events.values.find { |e| e.name.start_with?("Trainer(") && e.list.any? { |c| c.parameters.any? { |p| p.to_s.include?(":#{key}") } } } rescue nil)
    return false if !ev || !map
    $game_self_switches[[map, ev.id, "A"]] ? true : false
  end

  #-----------------------------------------------------------------------------
  # Eirwen: Frostshard Sigil 2, the private audience after the festival (part E),
  # and the ritual that lets you relive one day of the frozen past.
  #-----------------------------------------------------------------------------
  def eirwen(event_id = nil)
    first = !flag?(:met_eirwen)
    talk(:eirwen, event_id)
    return eirwen_audience(event_id) if respond_to?(:eirwen_audience) && eirwen_audience_due?
    return canticle_research if respond_to?(:canticle_research) && canticle_research_due?   # the Canticle's lost verses (048_H)
    if flag?(:canticle_learned) && !flag?(:sigil_eirwen)
      set_flag(:sigil_eirwen)
      say(["EIRWEN: You sang the Canticle in the hall of four lights. The leaves wrote it down in gold.",
           "EIRWEN: Then you've earned the thing I've been keeping. I'm its custodian. I always assumed for you.",
           "From a hollow in the oldest shelf, they take a crystal that hums like the one from the Echo Gate.",
           "EIRWEN: A Frostshard Sigil. One of three. They point to the White Vault, beyond the Wall, in the ice.",
           "EIRWEN: Two, now, if I'm any judge of that humming in your pack."])
      give(:FT_FROSTSIGIL)
      add_counter(:story_beats)
      return
    end
    # Eirwen's hidden motive (rootspire.md 930): the ledger, and whether to publish it.
    return eirwen_dilemma if !first && respond_to?(:eirwen_dilemma) && eirwen_dilemma_due?
    if flag?(:met_eirwen) && !flag?(:eirwen_ritual)
      eirwen_ritual_offer
    end
  end

  # Relive one day from the frozen past (flashback): the day of the Bryn Shander
  # lottery, four hundred years ago, as the leaves remember it.
  def eirwen_ritual_offer
    return if !flag?(:key_found)
    say(["EIRWEN: There's a ritual the leaves allow, once, for each who asks. To relive one day from the frozen past.",
         "EIRWEN: Not a dream. The leaves remember it whole. You'd walk in it, and walk back out."])
    return if !pbConfirmMessage(_INTL("Relive a day from the frozen past?"))
    set_flag(:eirwen_ritual)
    say(["Eirwen lays a crystal leaf on your palm and blows across it, very gently.",
         "The Library goes away."])
    Stage.overlay("O-03", above_panels: true, fade: 20) rescue nil
    begin
      Stage.visit(2012, 26, 25, 8) do
        sayc(["Bryn Shander. Snow. The lottery square, four hundred years ago, the day the name was drawn.",
              "Torches. Faces you remember, younger than you remember them. Speaker Duvessa on the steps, her voice cracking.",
              "The crowd presses in, cold and afraid, and somebody small at the back is starting to cry.",
              herald?(:alberica) ? "And there you are. Your other self. Pendant at your throat, stepping up onto a crate." :
                                   "And there's Alberica. The other Alberica. Pendant at her throat, stepping up onto a crate.",
              "She sings. Warmth pours out of the pendant into the crowd like lamplight through a door.",
              "The crying stops. One by one, the faces lift.",
              "You remember it from the inside. You remember it from out here. Both at once."])
      end
    rescue StandardError => e
      log("eirwen flashback: #{e.message}")
    end
    Stage.overlay_off("O-03", fade: 20) rescue nil
    sayc(["The Library comes back. Eirwen is holding your wrist, counting your pulse.",
          "EIRWEN: You were gone a day. Here, it was a breath. The leaves wrote all of it down.",
          cl(:alberica, "(wiping her eyes) I'd forgotten how frightened they were. I'd forgotten I wasn't."),
          cl(:reptin, "You were magnificent. You still are. The past has excellent taste.")].compact)
    wheel(1)
  end

  # Researching the sigils (downtime): Wynsnow translates what the sigils point at.
  def research_sigils(event_id = nil)
    have = ($PokemonBag.pbQuantity(:FT_FROSTSIGIL) rescue 0)
    return false if have < 2 || flag?(:sigils_researched)
    set_flag(:sigils_researched)
    sayc(["WYNSNOW: Two Frostshard Sigils! Hold them together. No, apart. No, together. Watch.",
          "Held close, the two crystals project a thin line of light north, through the wall, through the Wall.",
          "At the end of it: a shape like a vault-door, wings spread over a frozen eye.",
          "WYNSNOW: The White Vault of Ithryn Athis. Under the glacier. Two keys point the way; the third opens the door.",
          "WYNSNOW: Whoever holds the third will be standing at the end of that light. I'd bring a coat.",
          "WYNSNOW: Not this year, mind. Not while the tree's sick. When it's well, the door wakes.",
          cl(:alerion, "Ithryn Athis. Avarice's vault. Selrae called it the White Womb.")].compact, event_id)
    add_counter(:story_beats)
    true
  end

  # Tree Communion (downtime): Reptin or Glimmer sits with the Heartroot and
  # cleanses it a little; the cycle steadies for a while.
  def tree_communion(event_id = nil)
    return false if flag?(:tree_communion) || !flag?(:ch7_started)
    who = with_or_is?(:reptin) ? :reptin : (with_or_is?(:glimmer) ? :glimmer : nil)
    return false if !who
    return false if !pbConfirmMessage(_INTL("Sit with the World Tree at the Root-Gate a while? ({1} leads the communion.)", HERALD_NAMES[who]))
    set_flag(:tree_communion)
    if who == :reptin
      sayc([herald?(:reptin) ? "You sit with your back to the living root, palms flat, and listen." :
                               "Reptin sits with his back to the living root, palms flat, and listens.",
            "The pulse is there, under the heat. Too fast. A fevered sleeper.",
            as(:reptin, "Easy. Easy. I know. Something's hurting you. We're coming."),
            "For an hour he hums to it, like the wolf-mother once hummed to him. The pulse slows. A little."])
    else
      sayc(["Glimmer kneels at the root with the horn across his knees and the Lumen Shard glowing in his chest.",
            "GLIMMER: (very softly) Brightmane. If any of your light's spare, it's for this.",
            "Gold runs down into the root like warm water. The fever lifts. A little."])
    end
    sayc(["That night, for the first time in thirty years, Rootspire's dawn shifts: gold, then the faintest hint of green.",
          "Only for a moment. But people in the market stop and point."])
    wheel(1)
    true
  end

  #-----------------------------------------------------------------------------
  # The Guild's Amber Experiment: the Heralds are hired to test a fuel that
  # whispers when burned (it's partly sentient sap).
  #-----------------------------------------------------------------------------
  def amber_assessor(event_id = nil)
    return talk(:amber_assessor_done, event_id) if flag?(:amber_tested)
    say(["A Guild of Roots and Stone assessor with goggles and a clipboard waves you over to a brazier.",
         "GUILD ASSESSOR: Heralds! Perfect! The Guild needs a neutral witness. Hew's new fuel. Frozen sap, cut into bricks.",
         "GUILD ASSESSOR: Burns three times hotter than coal. A few complaints about noise. Would you light one? For the record?"], event_id)
    return if !pbConfirmMessage(_INTL("Light a brick of amber fuel?"))
    say(["The amber catches with a soft whoomph. Gold flame.",
         "And under the crackle: voices. Hundreds. Not words. The sound a crowd makes, far away, through a wall.",
         "Then one voice, close and clear, a child's: \"It's warm. Why is it so warm. Where's mama.\""])
    c = pbMessage(_INTL("What do you do?"), [_INTL("Put it out."), _INTL("Let it burn, and listen.")], 0)
    set_flag(:amber_tested)
    if c == 0
      say(["You smother the brazier. The voices stop. The silence afterward is worse.",
           "GUILD ASSESSOR: (white) That's... that's not noise. That's... is the sap alive? Is the sap ALIVE?"])
      wheel(1)
    else
      say(["You listen until it burns out. The voices fade one by one, like lamps along a street at dawn.",
           "The last one says, very faintly, \"thank you for hearing\".",
           "GUILD ASSESSOR: (clipboard shaking) I'm... I'm recommending the experiment be suspended. Indefinitely."])
    end
    sayc([cl(:wyn, "(barely a whisper) Sap that's been made to scream. I said. I said it was wrong."),
          cl(:reptin, "Partly sentient fuel. The Guild's been burning the tree's own memories to light its lamps.")].compact)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # Reptin's Pulse of the Blooming Fields (R2): two spirits, one hot as summer,
  # one cold as winter, quarrelling. They are Razzilith and Frostina, as the
  # seasons dream them. Broker the peace (three before two).
  #-----------------------------------------------------------------------------
  def fields_spirits(event_id = nil)
    return talk(:fields_spirits_calm, event_id) if flag?(:fields_pulse)
    say(["Daisies blooming beside snowdrifts. Green shoots through ice. And in the middle, two whirlwinds, arguing.",
         "One is hot as a summer noon: flowers wilt where it passes. One is cold as midwinter: frost forms in its wake.",
         "You hear them in the wind. They're shouting."], event_id)
    lead = with_or_is?(:reptin) ? :reptin : nil
    say([lead ? (herald?(:reptin) ? "(You know them. You'd know them anywhere. A green egg in a coat. A white one with Shimmer's heart.)" :
                                    "Reptin goes very still. \"I know them,\" he says. \"I'd know them anywhere.\"") :
                "There's something familiar in the shapes. A green glint. A white one."])
    say(["The summer-spirit has Razzilith's laugh. The winter-spirit hums four notes.",
         "Not the dragons. What the seasons dream the dragons are."])
    wins = 0; losses = 0
    rounds = [
      ["The summer-spirit roars: the cold one always leaves! Every year it leaves!",
       [_INTL("Appeal to their shared history."), _INTL("Command respect.")], 0,
       "\"You grew this tree together. Your breath. Both of you.\" The summer-spirit flickers, and listens.",
       "You raise your voice. The summer-spirit roars back, and a dozen daisies burst into flame."],
      ["The winter-spirit hisses: the warm one never stops! It burns everything that rests!",
       [_INTL("Read its body language: it's frightened."), _INTL("Tell it to stop sulking.")], 0,
       "It isn't angry. It's afraid of melting away. You say so, gently. The frost on the flowers softens.",
       "Hail comes down like gravel. It is, very definitely, sulking harder now."],
      ["Both spirits turn on you: who are you to judge seasons?",
       [_INTL("\"Nobody. I'm just the one who fed the wolves.\""), _INTL("\"A Herald. Do as I say.\"")], 0,
       "Something old in the wind recognises you. Both whirls bow, a little.",
       "Both spirits laugh at you. The laugh is a blizzard."],
      ["The two spirits circle each other, slower now. They need a reason to stop.",
       [_INTL("\"One brings it in. One carries it away. That's the wheel.\""), _INTL("\"Split the field in half.\"")], 0,
       "The words land. The two whirls slow, and touch, and twine together.",
       "They split the field. Then they fight over the line."]
    ]
    rounds.each do |prompt, opts, good, ok_line, bad_line|
      break if wins >= 3 || losses >= 2
      say([prompt])
      c = pbMessage(_INTL("{1}", lead == :reptin ? "What does Reptin do?" : "What do you do?"), opts, 0)
      if c == good
        wins += 1
        say([ok_line])
      else
        losses += 1
        say([bad_line])
      end
    end
    if wins >= 3
      set_flag(:fields_pulse)
      set_switch(SW_SPIRITS, false)
      wheel(1)
      add_counter(:story_beats)
      sayc(["The two spirits twine together and sink into the field. Flowers and snow lie down side by side.",
            "In the wind, Razzilith's laugh, and four notes, and then quiet.",
            lead ? as(:reptin, "There. That's the pulse. Not one or the other. Both, in turn.") : nil,
            "Where they sank, two berries have grown on one stem: one warm red, one frost-white."].compact)
      give(:OCCABERRY, 3)
      give(:YACHEBERRY, 3)
      # The notes' reward: you can call on them for resistance (047b's blessing and token).
      give_key(:FT_FIELDSPIRITS)
      grant_blessing(:field_spirits, "The Fields' Two Spirits", "Once each battle, the first Fire- or Ice-type hit on your Pokémon is halved.")
      set_flag(:field_spirits_done)
      say(["(When you need to, the spirits will stand between your Pokémon and fire, or frost.)"])
    else
      say(["The spirits howl. A mini-blizzard comes down across the Fields, flowers and hail together."])
      boss_battle(named_mon(:B225H59, 42, "Squall of Seasons"))
      say(["The squall blows itself out. The spirits are still out there, sulking in opposite corners. You could try again."])
    end
  end

  #-----------------------------------------------------------------------------
  # Alerion's Echoes at the Auroral Wall (A1): past the Echo Gate's wraiths,
  # a pocket of mirror-ice where a fragment of his soul stayed behind when the
  # Reversal broke time. Three successes before two failures, then the pane.
  #-----------------------------------------------------------------------------
  def echoes_at_the_wall
    done = flag?(:alerion_reflection) || flag?(:reflection_claimed)
    return false if done || !flag?(:echo_wraiths_down) || !with_or_is?(:alerion)
    return false if !pbConfirmMessage(_INTL("The frost in the Echo Gate is moving like a door. Go through, after Alerion's reflection?"))
    sayc(["Wind pours out of the Gate: laughter, sobbing. The frost patterns on the walls are eyes, and they follow.",
          "The wind whispers your names. Then a voice, familiar and cold: \"The lake remembers.\"",
          herald?(:alerion) ? "In the ice beside you, your reflection stops walking. You don't." :
                              "In the ice beside him, Alerion's reflection stops walking. He doesn't.",
          "It turns, and walks away from you, deeper into a maze of mirror-ice that wasn't there a moment ago."])
    # One quest, one place: the Mirror Maze (047b, map 2161), with its junctions and its pane.
    enter_mirror_maze
    true
  end

  #-----------------------------------------------------------------------------
  # The Verdant Heist (Meat Meat's M1). Darrus Fell, in the Council Hall, offers
  # her a job: the Guild's sealed reliquary from the vault under the Split Dock
  # (part of the Mirror Mother's heart). Deliver it to him, expose him to the
  # Council, or destroy it and free what's trapped inside.
  #-----------------------------------------------------------------------------
  def darrus(event_id = nil)
    if flag?(:heist_delivered) || flag?(:heist_exposed) || flag?(:heist_destroyed)
      return talk(:darrus_fell, event_id) if !flag?(:heist_exposed)
      return say(["Darrus's seat is empty. Somebody has already carved a rude word into it."], event_id)
    end
    if !with_or_is?(:meat_meat) || !flag?(:wardens_emeritus)
      return talk(:darrus_fell, event_id)
    end
    if !flag?(:heist_offered)
      set_flag(:heist_offered)
      set_switch(SW_RUN_OPEN, true)
      say(["In the shadowed corner of the Hall, the Autumn Warden leans close. Velvet, gold leaf, clove bark.",
           herald?(:meat_meat) ? "His velvet fingers trace a sigil in the wax of a forged decree while he looks at you. Only at you." :
                                 "His velvet fingers trace a sigil in the wax of a forged decree while he looks at Meat Meat. Only at her.",
           "DARRUS: The Guild of Roots and Stone guards a reliquary. A sealed box, older than the tree.",
           "DARRUS: It's part of the Mirror Mother's heart. Bring it to me, and I'll see you rewarded.",
           "DARRUS: Name a price. Autumn pays. That's the only thing Autumn does well.",
           "DARRUS: The vault's under the Root-Tier docks. The Smuggler's Run. Rootwarden traps. Wards. Nothing a professional can't manage.",
           "His smile doesn't reach his eyes. Behind them, something is very frightened."], event_id)
      sayc([herald?(:meat_meat) ? "(Mirror Mother. You know that name. From under the table. From the dark.)" :
                                  cl(:meat_meat, "(very still) Mirror Mother. Meat Meat knows that name. From under the cold table."),
            cl(:alberica, "Sweetheart, if he's offering you a job, he's already decided what you are. Let's decide differently.")].compact)
      side_goal(:reliquary, "Darrus wants the Guild's sealed reliquary from the vault in the Smuggler's Run, under the Split Dock.", done: [:darrus_paid, :darrus_chartered, :darrus_redeemed, :summer_ended])
      return
    end
    if ($PokemonBag.pbHasItem?(:FT_RELIQUARY) rescue false)
      return heist_delivery(event_id)
    end
    say(["DARRUS: (not looking up) The Run, under the dock. Third pier-post. I don't know you."], event_id)
  end

  def scene_smugglers_run_enter
    set_flag(:run_entered)
    sayc(["Under the Split Dock the water's warm as breath. The tunnels smell of fish-oil, sap, and something smoky shut up in stone.",
          "Old Guild tunnels, rough-cut, with Rootwarden ward-knots tied across them in willow.",
          cl(:meat_meat, "Meat Meat is very good at tunnels. Meat Meat was raised in one. Follow quietly."),
          cl(:reptin, "We'll be quiet. Some of us will be quiet. I'll be diplomatic.")].compact)
    state[:heist] ||= { wins: 0, fails: 0 }
  end

  # The four wards between the hatch and the vault: four successes before two failures.
  HEIST_WARDS = {
    1 => ["A Rootwarden guard post, a lantern, a Warden dozing on a stool.", [_INTL("Slip past in the dark."), _INTL("Walk past like you belong.")], 0,
          "You're through before the lantern even flickers.", "The Warden snorts awake. \"Oi! Who's- WARDENS!\""],
    2 => ["A willow ward-knot across the tunnel, humming with a glyph.", [_INTL("Look for the knot's loose end."), _INTL("Cut straight through it.")], 0,
          "The knot unties itself the moment you find the right strand. Old magic, old courtesy.", "The glyph goes off with a crack like thunder."],
    3 => ["A lock on an iron grille: tiny, goblin-sized, Guild-made.", [_INTL("Pick it."), _INTL("Force it.")], 0,
          "Click. The trick of it is the same as every Guild lock ever made.", "The grille shrieks. Somewhere, a bell starts ringing."],
    4 => ["The vault door. The air in front of it shimmers: a ward you can only see from the corner of your eye.", [_INTL("Feel for it and step around."), _INTL("Trust your eyes.")], 0,
          "You feel the ward like cold breath, and step where it isn't.", "You step straight into it. It wraps you in light and noise."]
  }

  # Four successes before two failures: a ward you get past stays passed; one
  # you fail can be tried again; fail twice and the Wardens chase you out, and
  # every ward is set again.
  def heist_ward(n, event_id = nil)
    return if !flag?(:heist_offered) || ($PokemonBag.pbHasItem?(:FT_RELIQUARY) rescue false) || flag?(:heist_vault_open)
    h = (state[:heist] ||= { wins: 0, fails: 0, passed: [] })
    h[:passed] ||= []
    return if h[:passed].include?(n)
    text, opts, good, ok, bad = HEIST_WARDS[n]
    say([text], event_id)
    c = pbMessage(_INTL("Meat Meat's way, or yours?"), opts, 0)
    if c == good
      h[:wins] += 1
      h[:passed] << n
      say([ok])
      set_self_switch(event_id, "A") if event_id
    else
      h[:fails] += 1
      say([bad])
      pbTrainerBattle(:FT_ROOTWARDEN, "Moss", nil, false, 0, true) rescue nil
    end
    if h[:fails] >= 2 && h[:wins] < 4
      state[:heist] = { wins: 0, fails: 0, passed: [] }
      say(["Wardens close in from both ends. You retreat up the hatch and wait for the tunnels to go quiet.",
           "(Every ward is set again. You can try again.)"])
      (1..4).each { |i| ev = ($game_map.events.values.find { |e| e.name == "Ward #{i}" } rescue nil); set_self_switch(ev.id, "A", false) if ev }
      transfer(2055, 29, 14, 2)
    end
  end

  def guild_vault(event_id = nil)
    if ($PokemonBag.pbHasItem?(:FT_RELIQUARY) rescue false) || flag?(:heist_done)
      return say(["The Guild vault stands open and empty."], event_id)
    end
    if !flag?(:heist_offered)
      return say(["A Guild vault door, bound in willow and iron, stamped with a hammer striking a root around an anvil."], event_id)
    end
    h = (state[:heist] ||= { wins: 0, fails: 0 })
    if h[:wins] < 4
      return say(["The vault door's wards are still awake. You'll have to get past the ones before it first."], event_id)
    end
    set_flag(:heist_vault_open)
    say(["Inside, on a stone shelf: a box older than the tree, sealed with grey wax.",
         "It's whispering. Not to you. To itself. Thousands of voices, all the same voice."], event_id)
    mm = herald?(:meat_meat)
    say([mm ? "You put your hands on it. The whispering turns to you." : "Meat Meat puts her hands on it. The whispering turns to her.",
         "Countless mirror selves, being carved apart by a woman with a measuring rule. Over and over. Over and over."])
    c = pbMessage(_INTL("The reliquary's whispering..."), [_INTL("Push it down. Hold it shut."), _INTL("Listen to it.")], 0)
    if c == 1
      say(["You listen. You see the cold table. Your own face, a hundred times, in a hundred mirrors, in a hundred pieces.",
           mm ? "(It takes a long time to remember which one is you.)" : "Meat Meat shakes for a long time afterward.",
           cl(:alberica, "(holding her) Shh. Shh. You're the one here. That's how you know."),
           mm ? nil : cl(:meat_meat, "...Meat Meat is the one here.")].compact)
    else
      say([mm ? "You hold it shut, the way you held your breath under the table. It quiets." :
                "Meat Meat holds it shut, jaw set. It quiets."])
    end
    give_key(:FT_RELIQUARY)
    add_counter(:story_beats)
  end

  def heist_delivery(event_id = nil)
    say(["DARRUS: (very softly) You have it. Give it here. Quickly. Before she- before anyone sees."], event_id)
    c = pbMessage(_INTL("What do you do with the reliquary?"),
                  [_INTL("Give it to Darrus."), _INTL("Take it to the Council."), _INTL("Smash it.")], 1)
    take_key(:FT_RELIQUARY)
    set_flag(:heist_done)
    case c
    when 0
      set_flag(:heist_delivered)
      $Trainer.money += 15000
      say(["DARRUS: (pressing a heavy purse into your hands) Thank you. Thank you. She'll leave me alone now. She promised.",
           "As he takes it, the reliquary's whispering goes quiet. Satisfied.",
           "(He hands you fifteen thousand in gold. It's warm. It's still warm.)"])
      sayc([cl(:alerion, "'She promised.' He's paying her. With us."),
            cl(:meat_meat, "...Meat Meat did the job. Meat Meat does not feel paid.")].compact)
    when 1
      set_flag(:heist_exposed)
      set_switch(SW_DARRUS_HIDING, true)
      wheel(1)
      sayc(["You set the reliquary on the Council table, in front of all three seats.",
            "KELYN: (reading the Guild seal) This came from the Guild's vault. Darrus. Darrus, what is this?",
            "DARRUS: (going grey) A construct came to me. Two years ago. One of hers. It had my ledgers. All of them.",
            "DARRUS: It wanted access to the Heartroot. And the box. I've been giving it... things. Little things.",
            "SELRAE: Little things. Like a dig under the Heartroot, under a forged seal.",
            "Darrus runs. Out of the Hall, down the Wardens' stair, toward the water.",
            "KELYN: Wardens, after him. Alive. He'll run to the Corsairs, and they'll hold him.",
            "KELYN: ...Heralds. Thank you. I think.",
            cl(:meat_meat, "Meat Meat did the job right. Meat Meat feels fed.")].compact)
    else
      set_flag(:heist_destroyed)
      wheel(1)
      sayc(["You bring it down on the stone. The wax cracks. The box cracks.",
            "Out of it pours a sound like a thousand mirrors breaking. Then one voice, small and clear: \"Thank you.\"",
            "Something pale rises out of the pieces, a girl made of reflected light, and goes up through the roof without touching it.",
            "Far below, very far, something screams in fury.",
            "DARRUS: (white to the lips) What have you done. She'll know. She'll know it was you.",
            cl(:meat_meat, "Good. Meat Meat wants her to know. Meat Meat wants her to know it was a goblin.")].compact)
      give(:MENTALHERB)
      say(["(The freed soul's thanks stays with you: a calm in the head when something tries to frighten or bewitch you.)"])
    end
    add_counter(:story_beats)
  end

  def old_moorings(event_id = nil)
    say(["The Corsairs' old moorings: rotten posts in black water, and a little boat tied up and ready."], event_id)
  end

  def darrus_hiding(event_id = nil)
    if flag?(:darrus_redeemed)
      return say(["DARRUS: (in a Corsair's coat, chewing clove bark) The Corsairs have put me to work. Counting barrels. It's very soothing."], event_id)
    end
    say(["Darrus Fell, in a borrowed Corsair coat, sitting on a crate in the dark.",
         "DARRUS: You found me. Of course you did. Everyone finds everyone in this city. She saw to that.",
         "DARRUS: I'm not going back up. The Corsairs will take me north on the next run.",
         "DARRUS: ...If anyone ever goes after her. North. To that vault. They'll need money. Ships. Furs.",
         "DARRUS: I know where every coin in Rootspire is buried. I'd... I'd pay. It's the only thing I'm good at."], event_id)
    if pbConfirmMessage(_INTL("Tell Darrus you'll hold him to that?"))
      set_flag(:darrus_redeemed)
      say(["DARRUS: (letting out a breath he's been holding for two years) Then I'll count every barrel twice. For the voyage."])
    end
  end

  #-----------------------------------------------------------------------------
  # The Frozen Cellar under the old Verdant Cask brewery: the Fractured Halo's
  # second hideout, where Eira Voss preaches the Frozen Flame.
  #-----------------------------------------------------------------------------
  def scene_frozen_cellar_enter
    sayc(["Frost on old brewing casks. Blue flame in cracked sconces. Cold that bites the lungs, in the middle of summer.",
          "Chanting from deeper in: \"Freeze it. Then burn what remains. Then nothing.\"",
          cl(:wyn, "(very quietly) The Frozen Flame. Stillness, and then fire. Not either. Both. Gods."),
          cl(:alberica, "Frost and fire in one prayer. Somebody's been very creative with their heresy.")].compact)
  end

  def frozen_flame_altar(event_id = nil)
    if flag?(:cellar_cleared)
      return say(["The Frozen Flame's altar: a block of ice with a coal sealed inside it. The coal has gone out."], event_id)
    end
    say(["An altar of clear ice. Sealed inside it, a coal that's still burning. It can't melt its way out.",
         "Around it, mirror-shard prayer tokens, and a ledger in a thin, precise hand:",
         "\"Twelve souls delivered to the forge this season. The Lady of the Forge is pleased.",
         "When the engine wakes, she will raise me up: the avatar of the Frozen Flame. E.V.\""], event_id)
    set_flag(:souls_ledger_seen)
  end

  def eira_voss_cellar(event_id = nil)
    if flag?(:cellar_cleared)
      return
    end
    sayc(["EIRA VOSS: (her whisper echoing round the cellar as if it were a cathedral) You found our little church.",
          "She tilts her head too far, like a bird. Her eyes glitter. Her lips don't move.",
          "EIRA VOSS: Eline wanted the cold. The forge wants fire. I want what comes after both. Silence.",
          "EIRA VOSS: Every soul I send down to the forge brings it closer. Yours would bring it very close."], event_id)
    return if !pbTrainerBattle(:FT_HALO, "Eira Voss", nil, false, 0)
    set_flag(:cellar_cleared)
    set_self_switch(event_id, "A")
    add_counter(:story_beats)
    wheel(1)
    sayc(["Eira Voss falls to her knees. The blue flame in every sconce goes out at once.",
          "When the Rootwardens come down to take her, she's still whispering. Backwards.",
          "\".sgniht lla dne dna ,sgniht lla ezeerf dna ,sgniht lla gnirb\"",
          "Wyn writes it down and reads it the right way round, and goes grey.",
          cl(:wyn, "'Bring all things, and freeze all things, and end all things.' That's... that's their whole creed."),
          cl(:reptin, "Then it's a very short creed. And it just lost its preacher.")].compact)
  end

  #-----------------------------------------------------------------------------
  # The watchers: each faction's spy-creature, visible in the Lantern's light (or
  # after you've met whoever sent it). Corner it: it fights; catch it if you like.
  #-----------------------------------------------------------------------------
  def watcher(key, event_id = nil)
    w = WATCHERS.find { |row| row[0] == key }
    return if !w
    _k, name, master, species, _g, gate, reports = w
    if flag?(:"watcher_#{key}")
      return say(["The place where the #{name} was hiding is empty now."], event_id)
    end
    if !flag?(gate) && !($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue false)
      return say(["Something was there. Out of the corner of your eye. Now it isn't."], event_id)
    end
    say(["In the #{($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue false) ? "Lantern's light" : 'shadows'}, a #{name}. It freezes, caught. Then it turns on you.",
         "(#{reports})"], event_id)
    sw = (SWITCH_CANNOT_CATCH_POKEMON rescue 75)
    was = $game_switches[sw]
    $game_switches[sw] = false
    decision = pbWildBattleCore(named_mon(species, 40, name)) rescue 0
    $game_switches[sw] = was
    return if decision != 1 && decision != 4
    set_flag(:"watcher_#{key}")
    add_counter(:watchers_found)
    set_self_switch(event_id, "A")
    if key == :lurker && !flag?(:summer_ended)
      sayc(["#{decision == 4 ? 'Caught' : 'Driven off'}: a watcher that lives in your own shadow. Whoever sent it is very close.",
            cl(:alberica, "(very quietly) It smelled of mirrors, darling. I know that smell.")].compact)
    elsif key == :lurker
      say(["#{decision == 4 ? 'Caught' : 'Driven off'}: one of Avarice's own watchers. She was in your shadow the whole time."])
    else
      say(["#{decision == 4 ? 'Caught' : 'Driven off'}: one of #{master}'s watchers. They'll know you know."])
    end
    if counter(:watchers_found) >= WATCHERS.size && first_time?(:all_watchers)
      sayc(["Ten watchers. Spring's, Winter's, Autumn's, Summer's, the Halo's, and hers.",
            cl(:alberica, "Observed, admired, stalked. Darling, we've been courted by an entire city."),
            cl(:alerion, "And now it knows we can see it looking.")].compact)
      give(:SHINYCHARM) rescue give(:AMULETCOIN)
    end
  end
end
