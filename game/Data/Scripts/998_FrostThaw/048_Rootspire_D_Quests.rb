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
#
# Scene pass (dialogue/15 top 5 #1): each briefing has something live in the
# room (an initiate in Kethan's Hall, a knock under Ivran's dock, the High
# Speaker within earshot of Darrus); people speak where they stand and walk in
# when they arrive (notes/15 E10); a retry opens on one line (E9).
#===============================================================================
module FrostThaw
  RELIC_ITEMS.merge!(
    FT_SCALECORE: ["Wyrmling Scale Core", "Wyrmling Scale Cores", 8, 0,
      "A crystal core grown hard round a cluster of green wyrmling scales, shed by Razzy at the cold table. Labelled RAZ-MKIII. Avarice wanted it back badly.", 0, 0, 6]
  )

  TEXT.merge!(
    # Ivran at the tiller of his sledge-ship on the Frozen Run (2199)
    frozen_run_ship: -> {
      next ["IVRAN: Across, and whole. I'll stand you a drink for every hull we passed."] if T.flag?(:frozen_run_done)
      ["Ivran stands at the tiller, the runners creaking under him.",
       "IVRAN: Walk beside her. Keep the dead off. I'll keep her moving."] },
    kelyn_mural: [{ if: { flag: :kelyn_secret }, lines: ["Kelyn's alcove. The old mural: an elf with a wolf's shadow, a cat-shaped figure in gold.",
                                                         "The first proof the Heralds were real. Kelyn has hung fresh green over it."] },
                  ["Behind the High Speaker's seat, an alcove with an old, old mural on the bark.",
                   "Two figures: an elf with a wolf's shadow, and someone small and cat-shaped, in light.",
                   "Underneath, in the oldest Wennen: THE FIRST OF THEM. THEY WERE REAL."]],
    orb_halo: ["Two robed figures kneel at the orb, pouring something white and freezing into the light."],
    requiem_vault_shut: ["A strongbox lashed to the pier, stamped with a ship's wheel in a spiral of aurora. Locked.",
                         "CORSAIR: Captain's vault. Confiscated relics. Not without the Captain."],
    amber_assessor_done: ["GUILD ASSESSOR: The Amber Experiment is suspended.", "GUILD ASSESSOR: Pending a long, hard look at our consciences."],
    fields_spirits_calm: ["Flowers and snow lie together here now, peacefully.",
                          "Two small whirls of warm and cold air chase each other, playing."]
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
    sayc(["Two robed figures kneel at the orb, pouring something white into its light.",
          "The orb's green goes grey where it touches. The white deepens to blue.",
          "SISTER ILSE: (not looking up) Don't. She's the goddess's daughter. Let her mother in.",
          "BROTHER VOSK: The Matron said winter's daughter comes home through this orb. Into her.",
          "LUMIN: (from the shrine steps) The Fractured Halo. They pray for her winter to come back.",
          cl(:alerion, "(very quietly) Winter's daughter. They mean Frostina."),
          cl(:alberica, "Pour one more drop and I'll pour you off this tree, darlings.")].compact)
    return false if !pbTrainerBattle(:FT_HALO_F, "Sister Ilse", nil, false, 0)
    return false if !pbTrainerBattle(:FT_HALO, "Brother Vosk", nil, false, 0)
    set_flag(:halo_orb_cleared)
    set_switch(SW_ORB_HALO, false)
    $game_switches[SW_HALO_ORB] = true if $game_switches
    add_counter(:trainers_beaten, 2)
    ilse = Stage.find("Sister Ilse"); vosk = Stage.find("Brother Vosk")
    Stage.leave_all([ilse, vosk].compact, 12, 34) if ilse || vosk
    sayc(["The cultists run for the root-lift. The white stuff in the orb boils off as steam.",
          "LUMIN: (shaking) They've come every night. I thought they were praying. They were pouring.",
          cl(:reptin, "They'll be back. Fanatics are terribly reliable.")].compact)
    true
  end

  #-----------------------------------------------------------------------------
  # Kelyn's secret. She communes with Razzilith's dreams through the orb at
  # night, looking for a way to wake the Verdant wyrm fully. Autumn means to use
  # that: feed her the dream of a green crown, let her use the Heralds' relics to
  # "quicken" the tree, and let Summer come back to a burning (Pellar's note).
  # (dialogue 15 §4: she denies first; notes/15 E9: "Not tonight" doesn't replay
  # the whole confession; E15: it's night when it's night.)
  #-----------------------------------------------------------------------------
  def night_tone
    $game_screen.start_tone_change(Tone.new(-80, -70, -20, 40), 10) rescue nil
  end

  def day_tone
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
  end

  def kelyn_orb(event_id = nil)
    if flag?(:kelyn_secret)
      return say([flag?(:kelyn_surge) ? "KELYN: (at the orb, her hands well clear of it) Only for him now. Go on. I'll keep watch." :
                                        "KELYN: (at the orb, very quietly) He's dreaming of you tonight. Of a meadow. Go on."], event_id)
    end
    night_tone
    if flag?(:kelyn_orb_asked)
      say(["KELYN: (at the orb, not turning round) You again. ...The dream came back. A green crown.",
           "KELYN: One relic. One night. Will you lend it?"], event_id)
    else
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:kelyn_orb_asked)
      say(["Night on the Canopy. The High Speaker is alone at the orb, hands on the light, eyes shut.",
           "Green fire runs up her arms and back down, like breath.",
           "KELYN: (opening her eyes) I come up here to think.",
           "KELYN: ...You don't believe me.",
           "She takes her hands off the light. They're shaking a little."], event_id)
      say(["KELYN: I speak with Razzilith. In his dreams, through the orb. For years now.",
           "KELYN: He's been half awake four hundred years, waiting for his partner.",
           "KELYN: If I could wake him fully, real spring would roll down this valley like a flood."], event_id)
      say(["Below the platform, the city's lanterns are going out, one window at a time."], event_id)
      if flag?(:autumn_note)
        say(["KELYN: There's a way. A friend showed me, in a dream of a green crown.",
             "KELYN: Your relics. The staff, the blade, the key. One night. The winter would never-"], event_id)
      else
        say(["KELYN: I've dreamed of a way. A green crown. Your relics at the orb, for one night.",
             "KELYN: I don't know where the dream came from. It came very kindly."], event_id)
      end
    end
    choices = [_INTL("\"Lend her a relic.\""), _INTL("\"It's a trap. Autumn's using you.\""), _INTL("\"Not tonight.\"")]
    c = pbMessage(_INTL("What do you tell Kelyn?"), choices, 2)
    case c
    when 0
      kelyn_surge
    when 1
      if flag?(:autumn_note)
        sayc(["You show her Pellar's dropped note. \"K. is ready. Feed her the dream of a green crown.\"",
              "\"...Then Summer returns to a burning.\"",
              "KELYN: (very still) ...Lumea. Who painted my portrait. Who sits by me every festival.",
              "KELYN: A burning. Springfire, out of control. The whole valley.",
              "KELYN: I'd have done it. I'd have done it smiling.",
              cl(:reptin, "You'd have done it hoping. That's not the same as wicked. It's just easier to aim."),
              cl(:meat_meat, "Razzy does not want fire. Razzy wants Meat Meat. And snacks. Ask him properly.")].compact, event_id)
        set_flag(:kelyn_secret); set_flag(:kelyn_warned)
        wheel(1)
        add_counter(:story_beats)
      else
        say(["KELYN: A trap? From whom? ...You don't know. Then neither do I. Not tonight, then.",
             "(Something kind sent her that dream. You'd like to know who.)"], event_id)
      end
    else
      say(["KELYN: Another night. He'll still be dreaming. He's very good at it."], event_id)
    end
    day_tone
  end

  # Lending the relic: the verdant surge, and the Heralds stopping it.
  def kelyn_surge
    sayc(["Kelyn lays the relic against the orb. The light goes green, then gold, then too bright.",
          "The leaves round the Shrine burst into flower. Then the flowers burst into green flame."])
    # (notes/15 E11: the surge on screen)
    pbSEPlay("Fire2") rescue nil
    $game_screen.start_flash(Color.new(120, 255, 120, 220), 16) rescue nil
    $game_screen.start_shake(6, 7, 24) rescue nil
    sayc(["Roots tear up through the platform, thrashing, blooming, burning.",
          "KELYN: No. No, no. That's not spring. That's not- STOP IT. Somebody stop it!",
          cl(:reptin, "It's not spring. It's a fever. Pin it down!")].compact)
    if !boss_battle(named_mon(:B182H126, 44, "Verdant Surge"))
      say(["The surge burns itself out at last, leaving the Shrine's floor scorched and green at once."])
    end
    set_flag(:kelyn_secret); set_flag(:kelyn_surge)
    add_counter(:story_beats)
    sayc(["The fire goes out. The flowers close. The roots settle, sullen, smoking.",
          "KELYN: (on her knees) Whoever sent that dream wanted the valley burned. By me.",
          "KELYN: I'll never touch the orb for myself again. Only for him.",
          cl(:alberica, "Darling, you called for help. That's the part they'll leave out of the songs.")].compact)
  end

  #-----------------------------------------------------------------------------
  # The Rootwardens
  #-----------------------------------------------------------------------------
  # Rheven at the Spire Armory: his dreams of a burning tree; his belief the
  # Heartroot has become sentient and hungry and may have to be destroyed; his
  # question to Reptin, the founder of his creed: can violence ever serve balance?
  # (And R1's city half: "Will you cleanse it, or shall we cut away the rot?")
  def rheven_hall(event_id = nil)
    if !flag?(:rheven_counselled)
      say(["Rheven stands at the edge of the training yard, arms folded.",
           "He watches the archers without seeing them.",
           herald?(:wyn) ? "RHEVEN: (not looking round) Wyn. Good. You're back. Listen." : nil,
           "RHEVEN: The tree dreams of fire. Lately I dream it with her. Something's eating her.",
           "RHEVEN: I think the Heartroot's woken. Not the tree. The root. And I think it's hungry.",
           "He unfolds his arms. His knuckles are white.",
           "RHEVEN: If it's a thing that eats, I'll burn it out. All of it. Even if the tree dies too.",
           with_or_is?(:reptin) ? "He turns to #{hn(:reptin)}. He looks, for a moment, very young." : "He turns to you."].compact, event_id)
      if with_or_is?(:reptin)
        say(["RHEVEN: You wrote \"guard the pulse.\" Guard it from everyone? Even from me?",
             "RHEVEN: Will you cleanse it, Reptin? Or shall we cut away the rot?"], event_id)
        c = pbMessage(_INTL("What does Reptin tell him?"),
                      [_INTL("\"We cleanse it. You don't cut out a heart.\""), _INTL("\"Sometimes you cut. Never first.\""),
                       _INTL("\"I don't know. Let's find out together.\"")], 0)
        case c
        when 0
          speak(:reptin, "We cleanse it. You don't cut out a sick heart. You find what's poisoning it.",
                "...We cleanse it. You don't cut out a heart.")
          set_flag(:rheven_mercy)
        when 1
          speak(:reptin, "Sometimes you cut. I've cut. Never first, Rheven. Not while there's a pulse.",
                "...Sometimes you cut. Never first.")
          set_flag(:rheven_balance)
        else
          speak(:reptin, "I don't know. I wrote it before I'd ever had to. Let's find out together.",
                "...I don't know. Together, then.")
          set_flag(:rheven_together)
        end
        say(["RHEVEN: (a long breath) ...Then I'll hold my torch until you've looked. The gardens first.",
             "RHEVEN: The myconids say there's a blight down there. Black sap. That can be cleaned?"], event_id)
      else
        say(["RHEVEN: Can violence ever serve balance? I'd ask Reptin, if he were here. Can it?",
             "RHEVEN: ...No, don't answer. Find the rot first. Then we'll know what answer it needs."], event_id)
      end
      set_flag(:rheven_counselled)
      # (the Fields' quarrel has a person who says it's there: notes/15 E2)
      say(["RHEVEN: And there's a quarrel out in the Blooming Fields. Two winds, hot and cold.",
           "RHEVEN: The old Wardens would've known how to talk them down. Maybe one of you does."], event_id) if !flag?(:fields_pulse)
      side_goal(:fields_spirits, "Two spirits, hot and cold, are quarrelling in the Blooming Fields.", done: :fields_pulse) if !flag?(:fields_pulse)
      return
    end
    if flag?(:blight_burned) && !flag?(:rheven_blight_known)
      set_flag(:rheven_blight_known)
      # (notes/15 E5: what Reptin told him, read back)
      return say(["RHEVEN: The black sap under the gardens is gone. The myconids sing about you.",
                  flag?(:rheven_mercy) ? "RHEVEN: You said we cleanse it. We did. Something was feeding on the root. That, I hunt." :
                  flag?(:rheven_balance) ? "RHEVEN: Never first, you said. Good. Something was feeding on it. Now I can cut." :
                                           "RHEVEN: It wasn't the root that was hungry. Something was feeding on it. That I can hunt."], event_id)
    end
    still_beast_offer(event_id)
  end

  # The Still Beast (A2): a construct of bone and ice with Avarice's sigil,
  # prowling the thaw line. Rheven wants it caught alive.
  def still_beast_offer(event_id = nil)
    if flag?(:still_beast_done)
      return say([flag?(:still_beast_alive) ? "RHEVEN: The beast's in a pen under the Armory. It sleeps. The Bough patrols come home now." :
                                              "RHEVEN: The Bough circle's patrols come home now. All of them. Guard the pulse, Heralds."], event_id)
    end
    if !flag?(:still_beast_asked)
      set_flag(:still_beast_asked)
      set_switch(SW_STILL_BEAST, true)
      say(["RHEVEN: Unnatural beasts stalk the thaw line. Bone and ice, marked with Avarice's sigil.",
           "RHEVEN: One prowls the Blooming Fields, by the Wall. Three of my Bough went looking.",
           "RHEVEN: We found them frozen. Next morning, only footprints. Walking.",
           "He hands you a coil of barbed Rootwarden net. A Poké Ball would do as well, he admits.",
           "RHEVEN: Bring me the beast alive, if you can. I want to see whose sigil it carries."], event_id)
      side_goal(:still_beast, "The Still Beast prowls the Blooming Fields by the Wall. Rheven wants it alive.", done: :still_beast_done)
    else
      say(["RHEVEN: The Fields, by the Wall. Alive, if you can. A Poké Ball counts as alive."], event_id)
    end
  end

  def still_beast(event_id = nil)
    return say(["Only hoofprints of ice, melting into the flowers."], event_id) if flag?(:still_beast_done)
    sayc(["Between the snowdrifts, three Rootwardens of the Bough circle stand up out of the frost.",
          "Their eyes are glass. Their cloaks are stiff.",
          "Behind them hunches a thing of bone and ice, a sigil burned in its brow.",
          cl(:alberica, "Oh, you poor loves. Somebody's wearing you."),
          cl(:wyn, "(barely a whisper) That's Teo's sister. That's- I knew her.")].compact, event_id)
    return if !boss_battle(named_mon(:B91H93, 41, "Reanimated Bough Warden"), named_mon(:B91H93, 41, "Reanimated Bough Warden"))
    say(["The frozen Wardens fall, and stay fallen. Their faces have gone peaceful.",
         "The thing of bone and ice lowers its head. In its brow, a cracked mirror round an A.",
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
            "RHEVEN: Her sigil, on a living thing. You brought it back breathing. That's the creed.",
            cl(:alerion, "Winter's cruelty, held still. ...It's harder than killing. It's better.")].compact)
    else
      sayc(["The Still Beast shatters. Mirror-shards spray over the snow, cutting flowers at the stem.",
            "In every shard, for a moment: a woman's smile.",
            "RHEVEN: (later, at the Armory) Dead, then. And it burst into her glass.",
            "RHEVEN: So her sigils can corrupt even the wild. That's worth knowing. I wish I didn't."])
    end
  end

  # The Oath of Roots: the Rootwardens' own initiation, before the living pillar
  # in the Hall. Mercy and fury, both, balanced.
  def oath_pillar(event_id = nil)
    if flag?(:oath_of_roots)
      return say(["The living pillar in the Hall beats slow and warm under your hand. It knows you."], event_id)
    end
    if !flag?(:rheven_counselled)
      return say(["A pillar of living root rises through the floor, carved with a wolf's paw over a leaf.",
                  "WARDEN: The Oath of Roots is taken here. Captain Rheven gives it. Not to strangers."], event_id)
    end
    say(["Rheven stands before the living pillar. Every Warden in the Hall has stopped to watch.",
         "RHEVEN: You swore the Council's oath. This is ours, the Oath of Roots. Founders too.",
         "RHEVEN: Before the tree: balance mercy and fury. Show it what you are when it matters."], event_id)
    say(["Two Wardens drag in a Halo cultist, caught cutting sap-lines with a mirror-shard.",
         "He spits frost at you.",
         "HALO CULTIST: Kill me, then. The Frost Saint will thaw me out and send me back.",
         "Behind him, his Sneasel crouches over the cut sap-line, still trying to freeze it shut."])
    c = pbMessage(_INTL("Before the living tree, what do you do?"),
                  [_INTL("Mercy: let him go."), _INTL("Fury: put him down."), _INTL("Both: stop the harm, spare the man.")], 2)
    case c
    when 0
      say(["You let him go. He runs. His Sneasel stays at the sap-line, and the sap freezes.",
           "The pillar shivers.",
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
    sayc(["You beat him, and you don't finish him. You hand him back to the Wardens, alive.",
          "Then you mend the sap-line yourself. The pillar beats under your palm: once, slow, warm.",
          "RHEVEN: Root and oath. The tree holds you now, and you hold it.",
          "RHEVEN: I've never said that to a founder.",
          "RHEVEN: Wardens of Rootspire, and Rootwardens. Both oaths, now. The Hall's yours.",
          cl(:reptin, "(hoarse) I didn't think it would feel like this. Taking my own creed. From him."),
          cl(:alberica, "That's what a legacy is, sweetheart. Somebody hands you back what you gave away.")].compact)
  end

  # Captain Kethan's business: "A Season Too Long" (the cycle stalled on summer,
  # and a Rootwarden ritual gone wrong), and the Summer infiltrator in his ranks.
  # (dialogue 15 §4: the briefing happens with one of his own people in earshot)
  def kethan_business(event_id = nil)
    if flag?(:ash_exposed)
      if !flag?(:kethan_dueled)
        if pbConfirmMessage(_INTL("KETHAN: (pop, pop) You found my traitor. Let's see if your fists are as honest. Spar?"))
          if pbTrainerBattle(:FT_WATCHMAN, "Kethan", nil, false, 0)
            set_flag(:kethan_dueled)
            say(["KETHAN: (cracking his knuckles) Truthful. All of you. That's rarer than you'd think."])
            give(:FOCUSBAND)
          end
        end
      else
        say(["KETHAN: Order's kept. For today. Tomorrow I'll keep it again."], event_id)
      end
      return
    end
    if !flag?(:kethan_suspects)
      set_flag(:kethan_suspects)
      say(["KETHAN: (low; an initiate is restringing a bow two paces off) Not here. ...Fine. Quietly.",
           "KETHAN: Thirty years ago my predecessors did a thing. The Rite of the Long Gold.",
           "KETHAN: To hold off a hard winter, they tied the year to the Heartroot's pulse. It worked.",
           "The initiate's bowstring creaks. Kethan waits until she moves off.",
           "KETHAN: Then the season never ended. A ritual gone wrong, they said. Wrong, or turned.",
           "KETHAN: Somebody in this Hall is feeding the Halo and Summer. Routes. Sap-lines. Names.",
           "KETHAN: I want them found quietly. Bring me proof, not shouting."], event_id)
      side_goal(:infiltrator, "Kethan wants the infiltrator in the Rootwardens found: proof, not shouting.", done: :ash_named)
      return
    end
    clues = [:warden_map_seen, :jorik_confessed, :autumn_note, :gem_vibrates].count { |f| flag?(f) }
    say(["KETHAN: (pop) What have you got? Proof, mind. Not shouting."], event_id)
    if clues < 2
      return say(["KETHAN: Not enough. Look at who moves the patrol pins. Who carries what off the docks.",
                  "KETHAN: Who passes notes."], event_id)
    end
    found = []
    found << "the patrol pins moved to the Wall's edge" if flag?(:warden_map_seen)
    found << "the ore off the docks" if flag?(:jorik_confessed)
    found << "the notes between Autumn's people" if flag?(:autumn_note)
    found << "the gem that hums toward the Root-Gate" if flag?(:gem_vibrates)
    say(["You lay it out: #{found[0..1].join(', and ')}."] +
        (found.size > 2 ? ["And #{found[2..].join(', and ')}."] : []))
    # (scene check 48: the player names the traitor)
    c = pbMessage(_INTL("KETHAN: (very quietly) Then whose name sits under all of it?"),
                  [_INTL("Ash, on the south steps"), _INTL("Arvik, the trainer"), _INTL("Talwyn, the initiate")], -1)
    if c != 0
      return say(["KETHAN: (pop) No. They'd not know a sap-line from a washing line. Look again."], event_id)
    end
    say(["KETHAN: Ash. Ash, who guards the Root-Gate. Who meets the dock barrels himself.",
         "KETHAN: Ash trained half my initiates.",
         "KETHAN: Go and talk to him. I'll be watching. If he runs, he runs into me."], event_id)
    set_flag(:ash_named)
    side_goal(:infiltrator, "Ash, the Rootwarden on the market's south steps. Kethan's watching.", done: :ash_exposed)
  end

  def warden_ash(event_id = nil)
    if !flag?(:ash_named)
      return say(["A Rootwarden on the south steps, polishing a bark shield that's already polished.",
                  flag?(:festival_night) ? "ASH: #{herald?(:wyn) ? 'Wyn. ' : ''}The Root-Gate's sealed. Council orders. Nobody's said why." :
                                           "ASH: #{herald?(:wyn) ? 'Wyn. ' : ''}The Root-Gate's sealed. Council orders, till the festival's done."], event_id)
    end
    # (dialogue 15 §4: he denies first)
    sayc(["ASH: (not looking up) Kethan sent you. He never could do his own talking.",
          "ASH: Pins move. Wind, kids, clumsy hands. ...Fine. Yes. I moved them.",
          "ASH: I sent the Bough patrols where the cold could have them. Summer pays. The Halo pays.",
          "He sets the shield down, very carefully.",
          "ASH: The Rite of the Long Gold? My old captain did it right. Somebody below took the end.",
          "ASH: And held on. I just made sure nobody went down to see who.",
          cl(:reptin, "Guard the pulse, Ash. You were supposed to guard the pulse.")].compact, event_id)
    return if !pbTrainerBattle(:FT_TURNCOAT, "Ash", nil, false, 0)
    set_flag(:ash_exposed)
    add_counter(:story_beats)
    # (notes/15 E10: Kethan walks in, so he's there when he speaks)
    ash = $game_map.events[event_id] rescue nil
    kx, ky = $game_player.x, $game_player.y + 3
    ket = Stage.actor(:kethan, kx, ky, 8, graphic: "FT_npc_kethan_vale")
    Stage.walk_to(ket, ash.x, ash.y, adjacent: true) if ket && ash
    Stage.turn_to(ket, ash) if ket && ash
    sayc(["Kethan's hand closes on Ash's shoulder from behind. Nobody heard him come. Nor did Ash.",
          "KETHAN: Rootwarden Ash. The Hall will hear you. Not me. The Hall.",
          "ASH: (as they lead him away) Pull on the rope, Kethan. See who pulls back.",
          cl(:alerion, "The Rite of the Long Gold. Somebody's still holding the rope."),
          cl(:alberica, "Then we cut the rope, sweetheart. And pull them up with it.")].compact, event_id)
    Stage.leave_all([ket, ash].compact, $game_player.x, $game_player.y + 8) if ket
    set_switch(SW_ASH_EXPOSED, true)            # (gone from his post once he's been led off)
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
    say(["Eren sits on the Armory's steps with a bow across his knees, pale as new ice.",
         "EREN: It's carved from a scale Frostina dropped at the Wall. On purpose, I hope.",
         "EREN: I've been dreaming. A woman in white furs. She offers me a gift. The gift of memory.",
         "EREN: Every winter there ever was. Everything my family forgot. All I have to say is yes.",
         herald?(:alerion) ? "As he says it, something pulls at you, behind your ribs. A thread drawn out of a coat." :
                             "As he says it, Alerion puts a hand to his chest, as if something had pulled."], event_id)
    speak(:alerion, "Don't. Whatever she gives, she takes from somewhere. She'd take it from me.",
          "...Don't take it. It's mine she'd give you.")
    c = pbMessage(_INTL("What do you tell Eren?"), [_INTL("\"Refuse her. Learn it the slow way, with us.\""), _INTL("\"It's your choice.\"")], 0)
    if c == 0
      sayc(["EREN: (after a long time) ...The slow way. Will you teach me? How you made the cold kneel?",
            herald?(:alerion) ? nil : cl(:alerion, "I didn't make it kneel. I asked it to sit. ...Dawn. Here. Don't be late."),
            herald?(:alerion) ? "(You hear yourself say: Dawn. Here. Don't be late.)" : nil].compact)
      set_flag(:eren_pupil)
    else
      say(["EREN: My choice. ...Then I choose to see what she sees.",
           "Frost blooms across his lashes. His eyes go far away, past the Hall, past the Wall."])
      return if !pbTrainerBattle(:FT_DREAMER, "Eren", nil, false, 0)
      sayc(["Eren drops his bow. The frost runs off his face like water.",
            "EREN: She showed me everything, and none of it was mine. ...I'm sorry. Is he alright?",
            cl(:alerion, "(steadying himself) I'm here. All of me. ...Mostly. Come to the Wall at dawn.")].compact)
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
  # (notes/15 E8c: her Halo confession plays at the Hearth's back door after the
  # Rite, selrae_back_door in 048_H, where the golden path can reach it.)
  #-----------------------------------------------------------------------------
  def selrae_hall(event_id = nil)
    return talk(:selrae_vorn, event_id) if flag?(:rite_stopped)
    return if selrae_court(event_id)
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
    say(["As the session breaks up, the Winter Matron steps down and inclines her head to #{me ? 'you' : name}.",
         "Only to #{me ? 'you' : (who == :glimmer ? 'him' : 'them')}."], event_id)
    if who == :shade
      # (context 06, M6-4: the Rimefang and its curse, first said in a fight)
      say(["SELRAE: (low) Knife-bearer. That knife at your hip. The Rimefang."], event_id)
      speak(:shade, "It's a knife. It turned up in my boot in Targos. It's been cold ever since.", "...It's a knife.")
      say(["SELRAE: Cold because it's hers. It marked you for her that night. You're halfway home."], event_id)
    else
      say(["SELRAE: (low) Sparkbearer. A light that came back through a mirror. Emptied, and filled."], event_id)
    end
    say(["She draws a dagger of black ice from her sleeve and turns it to catch the crystals' light.",
         "When the light touches it, it whispers. Prayers. Old ones. To Auril.",
         "SELRAE: The goddess needs no throne. Only a heart that can hold light and cold together.",
         "SELRAE: Yours, perhaps.",
         "SELRAE: There's a vault in the ice, far north. The White Womb. They'd make a saint there."], event_id)
    # (check 48: the player's hand on the beat; as that Herald, how you say it is the choice)
    if !me
      c = pbMessage(_INTL("She holds the dagger out to {1}, hilt first.", name), [_INTL("Step between them."), _INTL("Let {1} answer.", name)], 0)
      say(["You step in front of #{name}. Selrae smiles at you as if that were an answer too."]) if c == 0
    end
    if who == :shade
      speak(:shade, "My sister was somebody's vessel. I carried her out. Put the knife away, Matron.",
            "...Put the knife away.")
    else
      speak(:glimmer, "I've been through one mirror for a goddess. That was enough. Put it away, Matron.",
            "...Put the knife away.")
    end
    sayc([cl(:alberica, "'The White Womb.' She said it the way I say 'last call'."),
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
           "Behind her the chant drops to a hum, waiting.",
           "ELINE: The cold in your blade knows the way home. You've felt it since Targos.",
           "ELINE: Kneel with us. Let her finish what the knife began.",
           "ELINE: You'd never grieve again. Nothing that is still can grieve."])
      c = pbMessage(_INTL("Eline holds out her hand..."), [_INTL("\"No.\""), _INTL("\"...Never grieve again?\"")], 0)
      if c == 1
        pron = who == :glimmer ? "his" : "their"
        say([me ? "(For one breath you want it more than anything.)" : "For one breath, #{who == :glimmer ? 'Glimmer' : 'Shade'} wants it more than anything.",
             "Then Alberica's hand is on #{me ? 'your' : pron} shoulder, and the breath is over."])
      end
      speak(who, "I'd rather grieve. It means I had something.", "...No.")
      # (dialogue 06 §3 #6: she answers him before she turns to Selrae)
      say(["ELINE: (a small, sad smile) Grief, then. Keep it. It will keep you warm a while."])
    end
    say(["ELINE: And tell your Winter Matron her chair is beside mine. She's nearly ours.",
         "The candles nearest her gutter, all together, as if someone had breathed on them.",
         "ELINE: Who do you think pays for the candles?"])
    set_flag(:eline_named_selrae)
  end

  # Wynsnow's other offer (the Chronal Debt): to let Glimmer and Alberica
  # remember what the centuries forgot, at the price of anchoring their
  # life-threads to Rootspire forever. (notes/15 E7: three real answers.)
  def wynsnow_chronal(event_id = nil)
    return false if flag?(:chronal_debt_done) || !flag?(:lecture_done)
    return false if !with_or_is?(:alberica) && !with_or_is?(:glimmer)
    set_flag(:chronal_debt_done)
    names = [:alberica, :glimmer].select { |k| with_or_is?(k) }.map { |k| herald?(k) ? nil : HERALD_NAMES[k] }.compact
    say(["WYNSNOW: (lowering his voice) #{names.empty? ? 'You' : names.join('. ')}. A private word.",
         "He shuts the door himself. Then, after some thought, the other door.",
         "WYNSNOW: Four hundred years happened while you were falling. I can let you see them.",
         "WYNSNOW: The price is a small anchoring. Your life-threads, tied to Rootspire's.",
         "He polishes his spectacles on his sleeve, not looking at you.",
         "WYNSNOW: The fracture would heal round you. You'd never quite leave. Small price, really."], event_id)
    c = pbMessage(_INTL("Wynsnow waits."), [_INTL("\"No. Our lives aren't your stitching.\""),
                                            _INTL("\"Show us. Just a glimpse. No anchor.\""),
                                            _INTL("\"Anchor us. Show us everything.\"")], 0)
    if c >= 1
      say(["WYNSNOW: #{c == 1 ? "A glimpse, unanchored? ...It'll cost something else, then." : 'Everything. Hold still.'}",
           "The air over his desk splits like ice. Through it, very fast: four hundred years.",
           "A sapling. Walkways. A woman with Hellen's chin carving the first mural.",
           "Two wyrmlings, small, chasing each other through a meadow.",
           "A council of three, then four, then three, with one name scraped out of the bark.",
           "A summer that comes and doesn't leave."], event_id)
      if c == 2
        # (the real cost: the Wheel the city's kindness turns, given to the tree)
        set_flag(:chronal_anchored)
        wheel(-2)
        say(["And then all of it at once, every year, every name, pouring in until there's no room.",
             "When the crack seals you can feel the tree's pulse in your own wrists. It doesn't go away.",
             "WYNSNOW: (very pale) It's done. You're stitched in. ...I'm sorry. I'm so pleased. Sorry."], event_id)
      else
        say(["The crack seals. Your nose is bleeding. So is everyone's.",
             "WYNSNOW: The cost. I did say. ...You saw the scraped name? Nobody's seen the scraped name."], event_id)
      end
      set_flag(:chronal_glimpse)
    else
      say(["WYNSNOW: (deflating) No. Quite right. I'd only have been tying you to my tapestry.",
           "WYNSNOW: That was the plan. Stabilise the fracture by anchoring it to you. Forever.",
           "WYNSNOW: You're the stitches holding this century to the last. I was going to sew you in.",
           "WYNSNOW: ...Please don't tell the Council. Or do. I'd deserve it."], event_id)
      set_flag(:wynsnow_confessed)
    end
    sayc([cl(:alberica, c == 2 ? "(rubbing her wrist) I can hear the tree in my pulse, darling. It hums flat." :
                                 "Darling, I've been tied to a lot of places. I'd rather choose the knots myself."),
          cl(:glimmer, "I've had enough of other people's anchors. Brightmane's is the one I'm keeping.")].compact)
    true
  end

  #-----------------------------------------------------------------------------
  # The Auroral Corsairs: the Requiem's relic vault, and the Frozen Run
  #-----------------------------------------------------------------------------
  def requiem_vault(event_id = nil)
    return talk(:requiem_vault_shut, event_id) if !flag?(:mira_freed)
    if flag?(:mira_left_possessed)
      return say(["The strongbox is locked. On deck, Mira watches you in a hand-mirror, smiling.",
                  "MIRA: Ours, little failures. Everything on this ship is ours now."], event_id)
    end
    if flag?(:scale_core_given)
      return say(["The vault is open, and mostly empty. The Corsairs are giving things back to their owners."], event_id)
    end
    # (notes/15 E10: Mira comes down off her ship to open it herself)
    mira = Stage.find("Mira of the North Wind")
    box = $game_map.events[event_id] rescue nil
    if mira && box
      Stage.walk_to(mira, box.x, box.y, adjacent: true)
      Stage.turn_to(mira, box)
    end
    sayc(["MIRA: (unlocking it herself) My vault. Thirty years of other people's relics.",
          "MIRA: Thirty years of somebody else choosing what to keep.",
          "Frost-glass, chardalyn shavings, a mirror wrapped in sailcloth, a Halo prayer-token.",
          "In a moss-padded box of its own: a crystal core, grown round a cluster of green scales.",
          "A tag: RAZ-MKIII.",
          "MIRA: That one hummed whenever the mirrors were loudest. She wanted it more than anything.",
          herald?(:meat_meat) ? "You know those scales before Mira says anything. Razzy shed them on the cold table." :
                                cl(:meat_meat, "(very small) Those are Razzy's. He shed them on the cold table. Before we ran."),
          "MIRA: A wyrmling scale core, the ledger says. Dormant. Take it. Keep it where she can't."].compact, event_id)
    give_key(:FT_SCALECORE)
    set_flag(:scale_core_given)
    add_counter(:story_beats)
  end

  def ivran_ready? = flag?(:ch7_started) && !flag?(:frozen_run_done) && !flag?(:frozen_run_asked)

  def ivran(event_id = nil)
    return hellen_note_delivery(event_id) if respond_to?(:hellen_note_due?) && hellen_note_due?   # Hellen's errand (048_H)
    if flag?(:frozen_run_done)
      return say(["IVRAN: My sledge-ship's crossed the cold half three times since. No revenants.",
                  "IVRAN: The crews sing about you. Badly."], event_id)
    end
    if flag?(:ch7_started)
      if flag?(:frozen_run_asked)
        # (notes/15 E9: the second time, straight to the ask)
        say(["IVRAN: (watching the water) The ship's ready. Are you?"], event_id)
      else
        giver_hello(event_id) if respond_to?(:giver_hello)
        set_flag(:frozen_run_asked)
        # (dialogue 15 §4: something live in the room while he asks)
        say(["IVRAN: (watching the water) Heralds. I need an escort across the frozen half.",
             "Under the planks at your feet, something knocks. Twice. Ivran doesn't look down.",
             "IVRAN: That's one of mine. The crews frozen in that ice have started getting up again.",
             "IVRAN: The Frozen Run, we call it. I'll take the sledge-ship. You walk the ice beside her.",
             "IVRAN: Keep the dead off her. Get her across whole and the Corsairs pay. Coin. A favour."], event_id)
        side_goal(:frozen_run, "Captain Ivran wants an escort across the Frozen Run, past the Split Dock.",
                  done: :frozen_run_done)
      end
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
          "The Glasswater's still half: snow on black ice, stretching away under the aurora. Silent.",
          "Ivran's sledge-ship creaks forward on runners, sails full of a wind you can't feel.",
          "Here and there in the ice: hulls. Crews, frozen at their oars, glass all the way through.",
          cl(:reptin, "The lake remembers. Every one of them."),
          cl(:alerion, "(very quietly) Some of them are getting up.")].compact)
  end

  # Ivran's sledge-ship keeps pace with you: each revenant you put down, it
  # creaks on past where it stood (notes/15 E10). Called on each step on 2199.
  FROZEN_RUN_STOPS = [[5, 11], [16, 11], [28, 11], [42, 11]]

  def frozen_run_ship_step
    return if !$game_map || $game_map.map_id != 2199 || flag?(:frozen_run_done)
    ship = $game_map.events.values.find { |e| e.name == "Ivran on his sledge-ship" } or return
    return if ship.move_route_forcing
    n = [:revenant_hask, :revenant_moirin, :revenant_tobe].count { |k| trainer_beaten?(k) }
    tx, ty = FROZEN_RUN_STOPS[n]
    return if ship.x >= tx
    Stage.walk_to(ship, tx, ty, wait_for: false)
  rescue StandardError => e
    log("frozen run ship: #{e.message}")
  end

  def frozen_run_finish(event_id = nil)
    if flag?(:frozen_run_done)
      return say(["The far shore. The sledge-ship's runners rest on rock again. Behind you, the ice is still."], event_id)
    end
    ship = $game_map.events.values.find { |e| e.name == "Ivran on his sledge-ship" }
    if [:revenant_hask, :revenant_moirin, :revenant_tobe].count { |k| trainer_beaten?(k) } < 3
      say(["The far shore is close, but revenants are still walking the ice toward Ivran's ship."], event_id)
      Stage.pan_to(ship.x, ship.y) if ship                    # (he calls from back down the lane: show him)
      say(["IVRAN: (from the rail) Not yet, Heralds! The ones behind us!"], event_id)
      Stage.pan_back if ship
      return
    end
    # the ship comes up the last of the lane to meet you before it grinds ashore
    Stage.walk_to(ship, FROZEN_RUN_STOPS.last[0], FROZEN_RUN_STOPS.last[1]) if ship && ship.x < FROZEN_RUN_STOPS.last[0]
    set_flag(:frozen_run_done)
    set_switch(SW_FROZEN_RUN, false)
    wheel(1)
    add_counter(:story_beats)
    sayc(["The sledge-ship grinds up onto the far shore. The crew cheers. Ivran doesn't.",
          "IVRAN: The Corsairs owe you. When you need to cross water, any water, you'll have a ship.",
          cl(:reptin, "We'll hold you to it. In writing, ideally.")].compact, event_id)
    give(:PEARLSTRING)
    set_flag(:corsair_favour)
    # (notes/15 E14: he points, and you go and look)
    say(["IVRAN: (from the rail, looking back, his glass eye catching the aurora) Look.",
         "IVRAN: Under the ice. Deep. By the last hull."], event_id)
  end

  # The dark ice by the last hull: what Ivran pointed at (build_rootspire_life).
  def frozen_run_shape(event_id = nil)
    if !flag?(:frozen_run_done)
      return say(["Black ice, blue-black where it's deepest. Something's down there. Not now: the revenants."], event_id)
    end
    if flag?(:frozen_run_shape)
      return say(["Blue-black ice. Nothing moves in it. You don't look for long."], event_id)
    end
    set_flag(:frozen_run_shape)
    pbBGMFade(2.0) rescue nil               # (the music goes out as you look down; the dock brings it back)
    say(["You kneel at the edge of the black ice and look down, where it goes blue-black.",
         "Far below: a shape. A woman, tall as a house, arms raised.",
         "For a moment her head seems to turn."], event_id)
    pbSEPlay("Ice8", 70, 70) rescue nil
    sayc([flag?(:shivven_told) ? "IVRAN: Shivven saw her. I didn't believe him. ...I believe him." :
                                 "IVRAN: The old crews swore something lay under the ice. I didn't believe them.",
          cl(:alberica, "(a hand over her rune, very pale) Home. Now. Please.")].compact, event_id)
    transfer(2055, 36, 8, 4)
  end

  def trainer_beaten?(key)
    map = $game_map.map_id rescue nil
    ev = ($game_map.events.values.find { |e| e.name.start_with?("Trainer(") && e.list.any? { |c| c.parameters.any? { |p| p.to_s.include?(":#{key}") } } } rescue nil)
    return false if !ev || !map
    $game_self_switches[[map, ev.id, "A"]] ? true : false
  end

  #-----------------------------------------------------------------------------
  # Eirwen: Frostshard Sigil 2, the private audience after the festival (part F),
  # and the ritual that lets you relive one day of the frozen past.
  #-----------------------------------------------------------------------------
  def eirwen(event_id = nil)
    first = !flag?(:met_eirwen)
    talk(:eirwen, event_id)
    return eirwen_audience(event_id) if respond_to?(:eirwen_audience) && eirwen_audience_due?
    return canticle_research(event_id) if respond_to?(:canticle_research) && canticle_research_due?   # the Canticle's lost verses (048_H)
    if flag?(:canticle_learned) && !flag?(:sigil_eirwen)
      set_flag(:sigil_eirwen)
      say(["EIRWEN: You sang the Canticle in the hall of four lights. The leaves wrote it in gold.",
           "EIRWEN: Then you've earned what I've been keeping. I always thought it was for you.",
           "From a hollow in the oldest shelf, they take a crystal that hums like the Echo Gate's.",
           "EIRWEN: A Frostshard Sigil. One of three. They point to the White Vault, beyond the Wall.",
           "EIRWEN: Two, now, if I'm any judge of that humming in your pack."], event_id)
      give(:FT_FROSTSIGIL)
      add_counter(:story_beats)
      return
    end
    # Eirwen's hidden motive (rootspire.md 930): the ledger, and whether to publish it.
    return eirwen_dilemma(event_id) if !first && respond_to?(:eirwen_dilemma) && eirwen_dilemma_due?
    if flag?(:met_eirwen) && !flag?(:eirwen_ritual)
      eirwen_ritual_offer(event_id)
    end
  end

  # Relive one day from the frozen past (flashback): the day of the Bryn Shander
  # lottery, four hundred years ago, as the leaves remember it.
  def eirwen_ritual_offer(event_id = nil)
    return if !flag?(:key_found)
    say(["EIRWEN: There's a ritual the leaves allow, once each. To relive a day of the frozen past.",
         "EIRWEN: Not a dream. The leaves remember it whole. You'd walk in it, and walk back out."], event_id)
    return if !pbConfirmMessage(_INTL("Relive a day from the frozen past?"))
    set_flag(:eirwen_ritual)
    say(["Eirwen lays a crystal leaf on your palm and blows across it, very gently.",
         "The Library goes away."], event_id)
    Stage.overlay("O-03", above_panels: true, fade: 20) rescue nil
    al = herald?(:alberica)
    begin
      Stage.visit(2012, 26, 25, 8) do
        # (notes/15 E11: the people in the memory stand in it)
        Stage.actor(:speaker_duvessa_shane, 26, 21, 2, graphic: "FT_speaker_duvessa_shane")
        alb = Stage.actor(:alberica_then, 24, 23, 6, graphic: "FT_alberica")
        sayc(["Bryn Shander. Snow. The lottery square, four hundred years ago, the day a name was drawn.",
              # (notes/15 E18: a New Journey player remembers nobody here)
              al ? "Torches. Faces you remember, younger than you remember them." :
                   "Torches. Faces Alberica remembers, younger than she remembers them.",
              "Speaker Duvessa on the steps, her voice cracking.",
              "The crowd presses in, cold and afraid, and somebody small at the back is starting to cry.",
              al ? "And there you are. Your other self. Pendant at your throat, stepping up onto a crate." :
                   "And there's Alberica. The other Alberica. Pendant at her throat, stepping up onto a crate."])
        Stage.hop(alb) if alb
        sayc(["She sings. Warmth pours out of the pendant into the crowd like lamplight through a door.",
              "The crying stops. One by one, the faces lift.",
              al ? "You remember it from the inside. You remember it from out here. Both at once." :
                   "Beside you, the Alberica you came with stands very still, remembering it from the inside."])
      end
    rescue StandardError => e
      log("eirwen flashback: #{e.message}")
    end
    Stage.overlay_off("O-03", fade: 20) rescue nil
    sayc(["The Library comes back. Eirwen is holding your wrist, counting your pulse.",
          "EIRWEN: You were gone a day. Here, it was a breath. The leaves wrote all of it down.",
          cl(:alberica, "I'd forgotten how frightened they were. I'd forgotten I wasn't."),
          cl(:reptin, "You were magnificent. You still are. The past has excellent taste.")].compact, event_id)
    wheel(1)
  end

  # Researching the sigils (downtime): Wynsnow translates what the sigils point at.
  def research_sigils(event_id = nil)
    have = ($PokemonBag.pbQuantity(:FT_FROSTSIGIL) rescue 0)
    return false if have < 2 || flag?(:sigils_researched)
    set_flag(:sigils_researched)
    sayc(["WYNSNOW: Two Frostshard Sigils! Hold them together. No, apart. No, together. Watch.",
          "Held close, they throw a thin line of light north, through the wall, through the Wall.",
          "At the end of it: a shape like a vault-door, wings spread over a frozen eye.",
          # (notes/15 F7: one place, said once, three names joined)
          "WYNSNOW: The White Vault of Ythryn Athis, under the glacier. Selrae says the White Womb.",
          "WYNSNOW: Same door. Two keys point the way. The third opens it. I'd bring a coat.",
          "WYNSNOW: Not this year, mind. Not while the tree's sick. When it's well, the door wakes.",
          cl(:alerion, "North. Then we go north.")].compact, event_id)
    add_counter(:story_beats)
    true
  end

  # Tree Communion (downtime): Reptin or Glimmer sits with the Heartroot and
  # cleanses it a little; the cycle steadies for a while.
  def tree_communion(event_id = nil)
    return false if flag?(:tree_communion) || !flag?(:ch7_started)
    who = with_or_is?(:reptin) ? :reptin : (with_or_is?(:glimmer) ? :glimmer : nil)
    return false if !who
    return false if !pbConfirmMessage(_INTL("Sit with the great root a while? ({1} leads.)", HERALD_NAMES[who]))
    set_flag(:tree_communion)
    if who == :reptin
      sayc([herald?(:reptin) ? "You sit with your back to the living root, palms flat, and listen." :
                               "Reptin sits with his back to the living root, palms flat, and listens.",
            "The pulse is there, under the heat. Too fast. A fevered sleeper.",
            as(:reptin, "Easy. Easy. I know. Something's hurting you. We're coming."),
            "For an hour #{herald?(:reptin) ? 'you hum' : 'he hums'} to it, like the wolf-mother once hummed. The pulse slows. A little."])
    else
      sayc(["Glimmer kneels at the root, the horn across his knees, the Shard glowing in his chest.",
            "GLIMMER: (very softly) Brightmane. If any of your light's spare, it's for this.",
            "Gold runs down into the root like warm water. The fever lifts. A little."])
    end
    # (notes/15 E15: it shows at the next dawn, which says so: dawn_hue)
    sayc(["Under your hands the root goes from fever-hot to only warm.",
          "Tomorrow's dawn will tell you if it held."])
    wheel(1)
    true
  end

  #-----------------------------------------------------------------------------
  # The Guild's Amber Experiment: the Heralds are hired to test a fuel that
  # whispers when burned (it's partly sentient sap).
  #-----------------------------------------------------------------------------
  def amber_assessor(event_id = nil)
    return talk(:amber_assessor_done, event_id) if flag?(:amber_tested)
    if flag?(:amber_asked)
      # (notes/15 E9)
      say(["GUILD ASSESSOR: (clipboard ready) Back to witness? One brick. For the record."], event_id)
    else
      giver_hello(event_id) if respond_to?(:giver_hello)
      set_flag(:amber_asked)
      say(["An assessor from the Guild of Roots and Stone, goggles and clipboard, waves you over.",
           "GUILD ASSESSOR: Heralds! Perfect! The Guild needs a neutral witness. Hew's new fuel.",
           "GUILD ASSESSOR: Frozen sap, cut into bricks. Three times hotter than coal.",
           "GUILD ASSESSOR: A few complaints about noise. Would you light one? For the record?"], event_id)
    end
    return if !pbConfirmMessage(_INTL("Light a brick of amber fuel?"))
    say(["The amber catches with a soft whoomph. Gold flame.",
         "And under the crackle: voices. Hundreds. The sound of a crowd far away, through a wall.",
         "Then one voice, close and clear, a child's: \"It's warm. Why is it so warm. Where's mama.\""], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Put it out."), _INTL("Let it burn, and listen.")], 0)
    set_flag(:amber_tested)
    if c == 0
      say(["You smother the brazier. The voices stop. The silence afterward is worse.",
           "GUILD ASSESSOR: (white) That's not noise. That's... is the sap alive? Is the sap ALIVE?"], event_id)
      wheel(1)
    else
      say(["You listen until it burns out. The voices fade one by one, like street-lamps at dawn.",
           "The last one says, very faintly, \"thank you for hearing\".",
           "GUILD ASSESSOR: (shaking) I'm recommending the experiment be suspended. Indefinitely."], event_id)
    end
    sayc([cl(:wyn, "Sap that's been made to scream. The spores knew. I knew."),
          cl(:reptin, "(very quiet) Every lamp in the market. They've been lighting them with this.")].compact)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # Reptin's Pulse of the Blooming Fields (R2): two spirits, one hot as summer,
  # one cold as winter, quarrelling. They are Razzilith and Frostina, as the
  # seasons dream them. Broker the peace (three before two).
  #-----------------------------------------------------------------------------
  def fields_spirits(event_id = nil)
    return talk(:fields_spirits_calm, event_id) if flag?(:fields_pulse)
    say(["Daisies blooming beside snowdrifts. Green shoots through ice.",
         "In the middle of it all, two whirlwinds. One is hot as noon: flowers wilt where it passes.",
         "One is cold as midwinter: frost forms in its wake. In the wind, you hear them shouting."], event_id)
    lead = with_or_is?(:reptin) ? :reptin : nil
    say([lead ? (herald?(:reptin) ? "(You know them. A green egg in a coat. A white one with Shimmer's heart.)" :
                                    "Reptin goes very still. \"I know them,\" he says. \"I'd know them anywhere.\"") :
                "There's something familiar in the shapes. A green glint. A white one."])
    say(["The summer-spirit has Razzilith's laugh. The winter-spirit hums four notes.",
         "Not the dragons. What the seasons dream the dragons are."])
    wins = 0; losses = 0
    rounds = [
      ["The summer-spirit roars: the cold one always leaves! Every year it leaves!",
       [_INTL("Appeal to their shared history."), _INTL("Command respect.")], 0,
       "\"You grew this tree together. Both of you.\" The summer-spirit flickers, and listens.",
       "You raise your voice. The summer-spirit roars back, and a dozen daisies burst into flame."],
      ["The winter-spirit hisses: the warm one never stops! It burns everything that rests!",
       [_INTL("Read it: it's frightened."), _INTL("Tell it to stop sulking.")], 0,
       "It isn't angry. It's afraid of melting away. You say so, gently. The frost softens.",
       "Hail comes down like gravel. It is, very definitely, sulking harder now."],
      ["Both spirits turn on you: who are you to judge seasons?",
       [_INTL("\"Nobody. Just the one who fed the wolves.\""), _INTL("\"A Herald. Do as I say.\"")], 0,
       "Something old in the wind recognises you. Both whirls bow, a little.",
       "Both spirits laugh at you. The laugh is a blizzard."],
      ["The two spirits circle each other, slower now. They need a reason to stop.",
       [_INTL("\"One brings it in. One carries it off.\""), _INTL("\"Split the field in half.\"")], 0,
       "That's the wheel. The words land. The two whirls slow, and touch, and twine together.",
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
      sayc(["The two spirits twine together and sink into the field.", "Flowers and snow lie down side by side.",
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
      say(["The spirits howl. A blizzard comes down across the Fields, flowers and hail together."])
      boss_battle(named_mon(:B225H59, 42, "Squall of Seasons"))
      say(["The squall blows itself out. The spirits are still out there, sulking in corners.",
           "You could try again."])
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
    sayc(["Wind pours out of the Gate: laughter, sobbing. The frost patterns on the walls are eyes.",
          "The wind whispers your names. Then a voice, familiar and cold: \"The lake remembers.\"",
          herald?(:alerion) ? "In the ice beside you, your reflection stops walking. You don't." :
                              "In the ice beside him, Alerion's reflection stops walking. He doesn't.",
          "It turns, and walks away, into a maze of mirror-ice that wasn't there a moment ago."])
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
      # (dialogue 15 §4, §5: the High Speaker is in earshot, and that's the pressure)
      say(["Kelyn is a few steps away. The Autumn Warden drops his voice and keeps smiling.",
           "Velvet, gold leaf, clove bark.",
           herald?(:meat_meat) ? "His velvet fingers trace a sigil in the wax of a forged decree. He looks only at you." :
                                 "His velvet fingers trace a sigil in a forged decree's wax. He looks only at Meat Meat.",
           "DARRUS: The Guild of Roots and Stone keeps a reliquary. A sealed box, older than the tree.",
           "DARRUS: It's part of the Mirror Mother's heart. Bring it to me. Name a price. Autumn pays.",
           "The hand on the decree is shaking."], event_id)
      say(["DARRUS: The vault's under the Root-Tier docks. The Smuggler's Run. Wards. Traps.",
           "DARRUS: Nothing a professional can't manage."], event_id)
      sayc([herald?(:meat_meat) ? "(Mirror Mother. You know that name. From under the table. From the dark.)" :
                                  cl(:meat_meat, "(very still) Mirror Mother. Meat Meat knows that name. From the cold table."),
            cl(:alberica, "If he's offering you a job, sweetheart, he's decided what you are. Let's not.")].compact)
      side_goal(:reliquary, "Darrus wants the Guild's reliquary from the vault in the Smuggler's Run.",
                done: [:darrus_paid, :darrus_chartered, :darrus_redeemed, :summer_ended, :heist_done])
      return
    end
    if ($PokemonBag.pbHasItem?(:FT_RELIQUARY) rescue false)
      return heist_delivery(event_id)
    end
    say(["DARRUS: (not looking up) The hatch by the split crate. I don't know you."], event_id)
  end

  def scene_smugglers_run_enter
    set_flag(:run_entered)
    sayc(["Under the Split Dock the water's warm as breath.",
          "The tunnels smell of fish-oil, sap, and something smoky shut up in stone.",
          "Old Guild tunnels, rough-cut, with Rootwarden ward-knots tied across them in willow.",
          cl(:meat_meat, "Meat Meat is very good at tunnels. Meat Meat grew up in one. Follow quietly."),
          cl(:reptin, "We'll be quiet. Some of us will be quiet. I'll be diplomatic.")].compact)
    state[:heist] ||= { wins: 0, fails: 0 }
  end

  # The four wards between the hatch and the vault: four successes before two
  # failures. (notes/15 E7: the right way isn't always the first one offered.)
  HEIST_WARDS = {
    1 => ["A Rootwarden guard post, a lantern, a Warden dozing on a stool.", [_INTL("Walk past like you belong."), _INTL("Slip past in the dark.")], 1,
          "You're through before the lantern even flickers.", "The Warden snorts awake. \"Oi! Who's- WARDENS!\""],
    2 => ["A willow ward-knot across the tunnel, humming with a glyph.", [_INTL("Look for the knot's loose end."), _INTL("Cut straight through it.")], 0,
          "The knot unties itself the moment you find the right strand. Old magic, old courtesy.", "The glyph goes off with a crack like thunder."],
    3 => ["A lock on an iron grille: tiny, goblin-sized, Guild-made.", [_INTL("Force it."), _INTL("Pick it.")], 1,
          "Click. The trick of it is the same as every Guild lock ever made.", "The grille shrieks. Somewhere, a bell starts ringing."],
    4 => ["The vault door. The air before it shimmers: a ward you can only see sidelong.",
          [_INTL("Trust your eyes."), _INTL("Feel for it, and step round.")], 1,
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
    c = pbMessage(_INTL("How do you get past?"), opts, 0)
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
      say(["Wardens close in from both ends. You retreat up the hatch, and wait for quiet.",
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
      return say(["A Guild vault door, bound in willow and iron, stamped with a hammer on a root and anvil."], event_id)
    end
    h = (state[:heist] ||= { wins: 0, fails: 0 })
    if h[:wins] < 4
      return say(["The vault door's wards are still awake. Get past the ones before it first."], event_id)
    end
    set_flag(:heist_vault_open)
    say(["Inside, on a stone shelf: a box older than the tree, sealed with grey wax.",
         "It's whispering. Not to you. To itself. Thousands of voices, all the same voice."], event_id)
    mm = herald?(:meat_meat)
    say([mm ? "You put your hands on it. The whispering turns to you." : "Meat Meat puts her hands on it. The whispering turns to her.",
         "Countless mirror selves, carved apart by a woman with a measuring rule. Over and over."])
    c = pbMessage(_INTL("The reliquary's whispering..."), [_INTL("Push it down. Hold it shut."), _INTL("Listen to it.")], 0)
    if c == 1
      say([mm ? "You listen. You see the cold table. Your own face, a hundred times, in a hundred pieces." :
                "Meat Meat listens. The cold table. Her own face, a hundred times, in a hundred pieces.",
           mm ? "(It takes a long time to remember which one is you.)" : "Meat Meat shakes for a long time afterward.",
           cl(:alberica, "(holding her) Shh. Shh. You're the one here. That's how you know."),
           mm ? nil : cl(:meat_meat, "...Meat Meat is the one here.")].compact)
    else
      say([mm ? "You hold it shut, the way you held your breath under the table. It quiets." :
                "Meat Meat holds it shut, jaw set. It quiets."])
    end
    give_key(:FT_RELIQUARY)
    add_counter(:story_beats)
    side_goal(:reliquary, "The reliquary: give it to Darrus, take it to the Council, or smash it.",
              done: [:heist_done, :summer_ended])
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
      say(["DARRUS: (pressing a heavy purse on you) Thank you. She'll leave me be now. She promised.",
           "As he takes it, the reliquary's whispering goes quiet. Satisfied.",
           "(He hands you fifteen thousand in gold. It's warm. It's still warm.)"], event_id)
      sayc([cl(:alerion, "'She promised.' He's paying her. With us."),
            cl(:meat_meat, "...Meat Meat did the job. Meat Meat does not feel paid.")].compact)
    when 1
      set_flag(:heist_exposed)
      set_switch(SW_DARRUS_HIDING, true)
      wheel(1)
      kel = Stage.find("Kelyn of Spring")
      Stage.approach(kel) if kel
      selrae_here = $game_switches && (!$game_switches[3936] || $game_switches[3939])
      sayc(["You set the reliquary on the Council table, in front of the seats.",
            "KELYN: (reading the Guild seal) This is the Guild's. Darrus. Darrus, what is this?",
            "DARRUS: (going grey) A construct came to me two years ago. One of hers. It had my ledgers.",
            "DARRUS: It wanted the Heartroot. And the box. I've been giving it things. Little things.",
            selrae_here ? "SELRAE: Little things. Like a dig under the Heartroot, under a forged seal." :
                          "KELYN: Little things. Like a dig under the Heartroot, under a forged seal."], event_id)
      # (notes/15 E10: he runs, on screen)
      dev = Stage.find("Darrus Fell")
      say(["Darrus runs. Out of the Hall, down the Wardens' stair, toward the water."], event_id)
      Stage.leave(dev, dev.x, dev.y + 9) if dev
      sayc(["KELYN: Let him run. I want to see who he runs to.",
            "KELYN: ...Heralds. Thank you. I think.",
            cl(:meat_meat, "Meat Meat did the job right. Meat Meat feels fed.")].compact, event_id)
      side_goal(:darrus_run, "Darrus ran for the water: the old moorings, east in the Smuggler's Run.",
                done: [:darrus_redeemed, :summer_ended])
    else
      set_flag(:heist_destroyed)
      wheel(1)
      sayc(["You bring it down on the stone. The wax cracks. The box cracks."], event_id)
      # (notes/15 E11)
      pbSEPlay("Glass") rescue nil
      $game_screen.start_flash(Color.new(230, 240, 255, 230), 14) rescue nil
      sayc(["Out pours a sound like a thousand mirrors breaking. Then one small voice: \"Thank you.\"",
            "Something pale rises out of the pieces, a girl of reflected light, up through the roof.",
            "Far below, very far, something screams in fury.",
            "DARRUS: (white to the lips) What have you done. She'll know. She'll know it was you.",
            cl(:meat_meat, "Good. Meat Meat wants her to know. Meat Meat wants her to know it was a goblin.")].compact, event_id)
      give(:MENTALHERB)
      say(["(The freed soul's thanks stays with you: a calm head when something tries to scare you.)"])
    end
    add_counter(:story_beats)
  end

  def old_moorings(event_id = nil)
    say(["The Corsairs' old moorings: rotten posts in black water, and a little boat, ready."], event_id)
  end

  def darrus_hiding(event_id = nil)
    if flag?(:darrus_redeemed)
      return say(["DARRUS: (in a Corsair's coat, chewing clove bark) The Corsairs have me counting barrels.",
                  "DARRUS: It's very soothing."], event_id)
    end
    if flag?(:darrus_found)
      # (notes/15 E9)
      say(["DARRUS: (on his crate) Still here. Still meaning it. Will you hold me to it?"], event_id)
    else
      set_flag(:darrus_found)
      say(["Darrus Fell, in a borrowed Corsair coat, sitting on a crate in the dark.",
           "DARRUS: You found me. Of course. Everyone finds everyone in this city. She saw to that.",
           "DARRUS: I'm not going back up. The Corsairs will take me north on the next run.",
           "He turns a coin over and over in his fingers.",
           "DARRUS: ...If anyone ever goes after her, north, to that vault, they'll need money. Ships.",
           "DARRUS: I know where every coin in Rootspire is buried. I'd pay. It's all I'm good at."], event_id)
    end
    if pbConfirmMessage(_INTL("Tell Darrus you'll hold him to that?"))
      set_flag(:darrus_redeemed)
      say(["DARRUS: (a breath he's held two years) Then I'll count every barrel twice. For the voyage."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # The Frozen Cellar under the old Verdant Cask brewery: the Fractured Halo's
  # second hideout, where Eira Voss preaches the Frozen Flame.
  #-----------------------------------------------------------------------------
  def scene_frozen_cellar_enter
    sayc(["Frost on old brewing casks. Blue flame in cracked sconces. A biting cold, in high summer.",
          "Chanting from deeper in: \"Freeze it. Then burn what remains. Then nothing.\"",
          cl(:wyn, "(very quietly) The Frozen Flame. Stillness, and then fire. Not either. Both. Gods."),
          cl(:alberica, "Frost and fire in one prayer. Somebody's been very creative with their heresy.")].compact)
  end

  def frozen_flame_altar(event_id = nil)
    if flag?(:cellar_cleared)
      return say(["The Frozen Flame's altar: a block of ice, a coal sealed inside it. The coal has gone out."], event_id)
    end
    say(["An altar of clear ice. Inside it, a coal that's still burning. It can't melt its way out.",
         "Around it, mirror-shard prayer tokens, and a ledger in a thin, precise hand:",
         "\"Twelve souls delivered to the forge this season. The Lady of the Forge is pleased.",
         "When the engine wakes, she will raise me up: the avatar of the Frozen Flame. E.V.\""], event_id)
    set_flag(:souls_ledger_seen)
  end

  def eira_voss_cellar(event_id = nil)
    if flag?(:cellar_cleared)
      return
    end
    # (story/15 §3, 15.31: her Shrine market is folded in here, where she's met: who she is,
    # her raven, her trade in stillness)
    sayc(["Cold grips your lungs. Blue flame in cracked sconces.",
          "A bone-thin woman with frost-burn scars, her white fur cloak stained with soot.",
          "EIRA VOSS: (her whisper filling the cellar like a cathedral) You found our little church.",
          "She tilts her head too far, like a bird. Her eyes glitter. Her lips don't move.",
          "EIRA VOSS: Eline wanted the cold. The forge wants fire. I want what comes after. Silence.",
          "EIRA VOSS: I sold stillness at the Shrine, a shard at a time. Down here I send souls."], event_id)
    if flag?(:watcher_raven)
      set_flag(:eira_raven_owned)
      say(["She glances up at an empty cask, where something used to perch.",
           "EIRA VOSS: You broke my raven. Auril's bird. It told me who carries the wyrmlings' warmth."], event_id)
    elsif flag?(:rite_stopped)
      watcher_glimpse("On a cask above her, a white-eyed raven turns its head to follow you.")
    end
    say(["EIRA VOSS: Every soul I send down brings the forge closer. Yours would bring it close."], event_id)
    return if !pbTrainerBattle(:FT_HALO_F, "Eira Voss", nil, false, 0)
    set_flag(:cellar_cleared)
    set_self_switch(event_id, "A")
    add_counter(:story_beats)
    wheel(1)
    sayc(["Eira Voss falls to her knees. The blue flame in every sconce goes out at once.",
          "When the Rootwardens come down to take her, she's still whispering. Backwards.",
          "\".sgniht lla dne dna ,sgniht lla ezeerf dna ,sgniht lla gnirb\"",
          "Wyn writes it down and reads it the right way round, and goes grey.",
          cl(:wyn, "'Bring all things, and freeze all things, and end all things.' Their whole creed."),
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
      say(["Something was there. Out of the corner of your eye. Now it isn't."], event_id)
      # (notes/15 E4, F2: the first time, somebody says what that was)
      if first_time?(:watcher_glimpsed)
        sayc([cl(:alerion, "Something's watching us. It'll hide until we've met whoever sent it."),
              with_or_is?(:alerion) ? nil : "(A watcher. It hides until you've met whoever sent it.)"].compact)
        side_goal(:watchers, "Watchers hide until you meet whoever sent them. Jast sells a lantern.",
                  done: :all_watchers)
      end
      return
    end
    say(["In the #{($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue false) ? "Lantern's light" : 'shadows'}: a #{name}. It freezes, caught.",
         "(#{reports})",
         "Then it turns on you."], event_id)
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
      sayc(["#{decision == 4 ? 'Caught' : 'Driven off'}: a watcher that lives in your own shadow. Its master is very close.",
            cl(:alberica, "(very quietly) It smelled of mirrors, darling. I know that smell.")].compact)
    elsif key == :lurker
      say(["#{decision == 4 ? 'Caught' : 'Driven off'}: one of Avarice's own watchers. She was in your shadow the whole time."])
    else
      say(["#{decision == 4 ? 'Caught' : 'Driven off'}: one of #{master}'s watchers. They'll know you know.",
           "(Whoever sent it might have something to say about it.)"])
    end
    if counter(:watchers_found) >= WATCHERS.size && first_time?(:all_watchers)
      sayc(["Ten watchers. Spring's, Winter's, Autumn's, Summer's, the Halo's, and hers.",
            cl(:alberica, "Observed, admired, stalked. Darling, we've been courted by an entire city."),
            cl(:alerion, "And now it knows we can see it looking.")].compact)
      give(:SHINYCHARM) rescue give(:AMULETCOIN)
    end
  end
end
