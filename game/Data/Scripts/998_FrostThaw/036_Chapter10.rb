#===============================================================================
# Frost & Thaw - Act II, Chapter 10: Trials of the Roots (script SC 10.01-10.09)
#
# Answer for what the Heralds did, and help the city choose who leads it next.
# A hub week: the five personal trials can be done in any order, and each adds
# witnesses. Gym 8 is the Trial of Winter. Then the Verdict, then the Vote.
#
#   10.01 The Tribunal opens (the Council Hall)
#   10.02 Roots of Love (Reptin): Anduin, by the market; the Heartroot's Test
#   10.03 Assassin's Reckoning (Meat Meat): the root-cells; Phildendrin;
#         Autumn's spying mirror, in the Sap Wells
#   10.04 Absent Watcher (Wyn): Captain Kethan Vale; the Underdark Door (2077)
#   10.05 Brother from Beyond (Alerion): Talion, on the Glasswater shore (2078)
#   10.06 Spores of Contention (Alberica): Kelyn and Selrae in the Undercanopy
#   10.07 Gym 8: the Trial of Winter (Selrae, at the Still Sky Shrine)
#   10.08 The Verdict      10.09 The Vote: end of Act II
#===============================================================================
module FrostThaw
  SW_TRIBUNAL   = 3991   # you've been brought before the Council (10.01 plays in the hall)
  SW_TRIALS     = 3988   # the trial week: witnesses, cells and candidates are about
  SW_PHIL_MIRROR = 3989  # Phildendrin asked for the mirror: Autumn's spying mirror waits in the Sap Wells
  SW_TALION     = 3990   # night on the Glasswater shore, after another trial
  SW_ACT2_DONE  = 3992   # the Vote is done

  MAPS.merge!(underdark_door: 2077, glasswater: 2078)
  MAP_NAMES.merge!(2077 => "The Underdark Door", 2078 => "The Glasswater Shore")
  MAP_METADATA.merge!(2077 => { announce_location: true, battle_environment: :Cave },
                      2078 => { announce_location: true, battle_environment: :Cave })
  AREAS.merge!(2077 => :root_tier, 2078 => :root_tier)

  TRAINERS[:selrae] = [:FT_WINTER_MATRON, "Selrae",
                       [[:B124H200, 54], [:B131H225, 55], [:B221H215, 55], [:B87H124, 56], [:B144H131, 58]],
                       "Winter yields. As it should. As it always must, in the end.", [:FULLRESTORE, :FULLRESTORE]]

  # Every witness the Heralds can bring: [flag(s), who, what they say]
  WITNESSES = [
    [[:hew_confessed], "Hew Talmire", "His ledgers: ten years of sap, sold to Summer's people."],
    [[:yarro_witness], "Yarro", "The roots ran hot from below. The Heralds put the fire out. Gently."],
    [[:mira_witness], "Mira of the North Wind", "Darrus shipped crates to the Forge every week for ten years."],
    [[:anduin_reconciled, :anduin_doubtful], "Anduin", "Reptin stood between a fire and a sapling."],
    [[:mm_atoned], "Phildendrin", "My daughter was made to be a weapon. She chose to save a child."],
    [[:child_parents], "The rescued child's parents", "She saved our girl."],
    [[:talion_released, :talion_chased], "Talion, through the lake", "The tall gold man had no reflection. None. For years."],
    [[:wyn_cleared], "Hyphora", "Shadow answered my call."],
    [[:colony_recognised], "Luminara's memory bubble", "Var Rime-Breaker, alone in the roots, peeling back his own face."],
    [[:selrae_witness], "Selrae Vorn", "Her word, for whatever an old Halo-sheltering fool's word is worth."],
    [[:wardens_sworn], "Kelyn of Spring", "They swore the Wardens' oath the day they came home."]
  ]

  CANDIDATES = {
    rheven: ["Rheven Stormbranch", "Strength and security"],
    mira: ["Mira of the North Wind", "Free water"],
    eirwen: ["Eirwen Solglass", "The truth, published"],
    phildendrin: ["Phildendrin", "Justice and reform"],
    anduin: ["Anduin", "Faith and humility"]
  }

  TEXT.merge!(
    trial_gallery: ["GALLERY: (whispering) That's them. The Heralds. They don't look like murderers.",
                    "GALLERY: What does a murderer look like? Like a hero, my nan says."],
    kethan_after: ["KETHAN: Go on, Rootwarden. Your post's still yours. If you want it."],
    underdark_circle: ["Behind the broken door, cut into the rock: a ritual circle of frost.",
                       "Auril's snowflake, under a crown."],
    glasswater_still: ["The lake is so still it could be a second sky. Nothing breathes on it."],
    phildendrin_after: -> { flag?(:mm_atoned) ? ["PHILDENDRIN: The faces in that mirror were people. You let them go.",
                                                 "PHILDENDRIN: Now let the court do the same for her."] :
                                                ["PHILDENDRIN: Autumn's spying mirror. In the Heartroot's wells, where Darrus kept his secrets.",
                                                 "PHILDENDRIN: Break it, and the court will listen."] },
    glasswater_shut: ["A narrow tunnel runs down to a still lake under the roots.",
                      "Nothing calls you there. Not yet."],
    refugee_camp: ["REFUGEE: The tree people gave us blankets. Blankets! In autumn!",
                   "REFUGEE: We've had snow in our boots for two years."]
  )

  module_function

  def witnesses
    WITNESSES.select { |flags, _, _| flags.any? { |f| flag?(f) } }
  end

  def trials_done
    %i[anduin_reconciled anduin_doubtful phildendrin_found wyn_cleared talion_released talion_chased colony_recognised].count { |f| flag?(f) }
  end

  def show_witnesses
    list = witnesses
    if list.empty?
      return pbMessage(_INTL("Witnesses: nobody yet. The Tribunal sits in seven days."))
    end
    pbMessage(_INTL("Witnesses ({1}):", list.size))
    list.each { |_, who, what| pbMessage(_INTL("{1}: \"{2}\"", who, what)) }
  end

  def chapter10_start
    set_switch(SW_TRIBUNAL, true)
    transfer(2054, 11, 17, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 10.01 - The Tribunal opens
  #-----------------------------------------------------------------------------
  def scene_tribunal
    set_switch(SW_TRIBUNAL, false)
    return if flag?(:trials_open)
    say(["The four crystals pulse. Two of them, gold and red, are dim.",
         "Two chairs are draped in white.",
         "KELYN: The Heralds of Dawn and Dusk: charged with the deaths of the Summer Marshal and the Autumn Warden.",
         "KELYN: Meat Meat is charged separately. The Autumn Warden died by her hand.",
         "SELRAE: The Rootwarden Wyn: with abandoning the Underdark door the night it broke.",
         "SELRAE: And Alberica: with carrying the myconids' spores to the surface without leave.",
         as(:alberica, "(under her breath) I sneezed."),
         cl(:reptin, "(under his breath) Let me do the talking. Please. I'm begging you."),
         cl(:meat_meat, "(under her breath) Meat Meat would also like to do the talking."),
         cl(:reptin, "(under his breath) Especially not you."),
         "KELYN: You have seven days to bring witnesses. Then the crystals hear the verdict.",
         "KELYN: And on that same day, this city fills two empty chairs.",
         "A CHILD ON A CRATE: Murderers!",
         "HER MOTHER: (a refugee, a hand over the child's mouth) Hush. They brought us out of the snow."].compact)
    set_flag(:trials_open)
    set_switch(SW_TRIALS, true)
    add_counter(:story_beats)
    pbMessage(_INTL("(The Heralds menu now keeps a list of your witnesses.)")) rescue nil
    state[:goal] = "Seven days. Bring witnesses: Anduin by the market; the root-cells under the Hall; Captain Kethan in the Root-Tier; the Undercanopy; and the Trial of Winter at the Still Sky Shrine."
  end

  #-----------------------------------------------------------------------------
  # SC 10.02 - Roots of Love (Reptin)
  #-----------------------------------------------------------------------------
  def anduin_trial(event_id = nil)
    if flag?(:anduin_reconciled) || flag?(:anduin_doubtful)
      return say(flag?(:anduin_reconciled) ? ["ANDUIN: Stewards of the Heartroot. Him and me.", "ANDUIN: I like the sound of it."] :
                                             ["ANDUIN: I want to believe it. I'm trying. Give me time."], event_id)
    end
    say(["ANDUIN: (turning his iron ring over and over) They call you a god in the Rootwardens' hall.",
         "ANDUIN: They leave you offerings. Reptin, you couldn't keep a houseplant alive."], event_id)
    speak(:reptin, "(his best smile) The houseplant had it coming. ...I'm still him, Anduin.", "...I'm still him.")
    say(["ANDUIN: Are you? This tree is a god. It's young, and it's frightened.",
         "ANDUIN: And you stand next to it like a second sun. What happens to it when you outshine it?"])
    c = pbMessage(_INTL("What do you do?"), [_INTL("\"Show him.\""), _INTL("\"Tell him about the acorn.\"")], 0)
    if c == 1
      say([as(:reptin, "I carried it. I planted it. I'm not here to outshine it."),
           as(:reptin, "I'm here because I owe it."),
           "ANDUIN: ...Show me."])
    end
    pbFadeOutIn { } rescue nil
    say(["You take them both down to the Heartroot.",
         "#{herald?(:reptin) ? 'You put your hands' : 'Reptin puts his hands'} on the root. The Heartroot's Test."])
    Stage.overlay("O-03", fade: 20)
    say(["A vision: Reptin, grey-furred and enormous, between a burning machine and a sapling.",
         "He's taking the heat."])
    if flag?(:hyphora_sworn)
      say(["The vision holds. Anduin is crying.",
           "ANDUIN: You're protecting it. Not replacing it.",
           "There and then, they ask the Rootwardens to make them stewards of the Heartroot. Both of them.",
           cl(:alberica, "(sniffing loudly) I'm not crying. It's spores. This whole city is spores.")].compact)
      set_flag(:anduin_reconciled)
    else
      say(["The vision flickers.",
           "ANDUIN: I want to believe it.",
           "He'll testify. But he walks back to the refugee camp alone.",
           cl(:alberica, "(quietly) Give him time, sweetheart. The good kind of love is slow.")].compact)
      set_flag(:anduin_doubtful)
    end
    Stage.overlay_off("O-03", fade: 20)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 10.03 - Assassin's Reckoning (Meat Meat)
  #-----------------------------------------------------------------------------
  def root_cells(event_id = nil)
    if flag?(:phildendrin_found)
      return say(lines_for(:phildendrin_after), event_id)
    end
    mm = herald?(:meat_meat)
    say([mm ? "You sit in a root-cell, holding Razzilith's nose through the bars." :
              "Meat Meat sits in a root-cell, holding Razzilith's nose through the bars."], event_id)
    speak(:meat_meat, "Meat Meat could have caught his hand. Meat Meat didn't. Meat Meat would not catch it again.",
                      "...Meat Meat would not catch it again.")
    say([as(:meat_meat, "That is the truth. The crystals can judge the truth.")])
    if mm
      say([flag?(:mm_reached) ? "(The court has it written down: you reached for him. His hand slid out of yours.)" :
                                "(The court has it written down: you took the child. You didn't reach.)",
           "(They read it back to you twice.)"])
    end
    say(["The hooded goblin woman from Bryn Shander is standing at the bars.",
         "HOODED WOMAN: (her voice cracking) They told me V-7 died. In the cold room.",
         "HOODED WOMAN: They told me my baby died.",
         "She pulls her hood back.",
         as(:meat_meat, "(very small) ...Mama?"),
         "PHILDENDRIN: (both hands through the bars, on her daughter's face) Phildendrin. My name is Phildendrin.",
         "PHILDENDRIN: I'm your mama. And I am not losing you to another cell.",
         cl(:reptin, "(quietly, to the guard) Give them a minute. Please. I'll owe you one.")].compact)
    set_flag(:phildendrin_found)
    gather = []
    if flag?(:child_saved)
      gather << "The rescued child's parents push through to the bars. \"She saved our girl.\""
      set_flag(:child_parents)
    end
    gather << "MIRA: Darrus shipped crates to the Forge every week for ten years. I'll say so to anyone." if flag?(:mira_freed)
    gather << "RHEVEN: My wardens found the pens when the Forge fell. I'll say what we saw."
    set_flag(:rheven_saw_pens)
    say(gather)
    say(["PHILDENDRIN: Let her earn mercy. There's a mirror in the Heartroot's wells.",
         "PHILDENDRIN: Autumn's spying mirror. Darrus watched the whole city through it.",
         "She looks at Razzilith, and then back at her daughter.",
         "PHILDENDRIN: Break it. Free the faces trapped inside.",
         "PHILDENDRIN: Then the court can't say she only knows how to hurt.",
         as(:meat_meat, "Meat Meat breaks things very well. Mama will see.")])
    set_switch(SW_PHIL_MIRROR, true)
    add_counter(:story_beats)
    state[:goal] = "Autumn's spying mirror, in the Sap Wells under the Root Gate."
  end

  def autumn_mirror(event_id = nil)
    return say(["Shards of a tall mirror. The faces are gone. Only yours, in pieces."], event_id) if flag?(:mm_atoned)
    return say(["A tall mirror, its glass dark and greasy. Something moves behind it."], event_id) if !flag?(:phildendrin_found)
    say(["A tall mirror in a frame of red-lacquered root.",
         "Faces press against the glass from the inside: dozens. People Darrus watched. People he kept.",
         as(:meat_meat, "No more deals with mirrors."),
         cl(:wyn, "(barely a whisper) ...They're so tired. Let them out.")].compact, event_id)
    return if !pbConfirmMessage(_INTL("Break Autumn's mirror?"))
    mspot = stage_spot(stage_event(event_id))
    return if !boss_battle(named_mon(:B122H429, 55, "Mirror Wraith"))
    Stage.fx("E-06", mspot, frames: 10, oy: 32)          # the mirror falls in pieces
    say(["The wraith comes apart, and the mirror with it.",
         "The faces drift out of the shards like breath on a cold morning. They thin, and are gone.",
         "One of them, an old man, waves.",
         "PHILDENDRIN: (later, to the Tribunal) My daughter was made to be a weapon. She chose to save a child instead.",
         "PHILDENDRIN: If you want to judge her, judge the people who made her."])
    set_flag(:mm_atoned)
    set_switch(SW_PHIL_MIRROR, false)
    set_flag(:candidate_phildendrin)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 10.04 - Absent Watcher (Wyn)
  #-----------------------------------------------------------------------------
  def kethan(event_id = nil)
    return say(lines_for(:kethan_after), event_id) if flag?(:wyn_cleared)
    say(["Captain Kethan Vale, grey at the temples, waits at the mouth of the old guard tunnels.",
         "KETHAN: You left your post, Rootwarden. Cultists came through.",
         "KETHAN: Explain, or don't. I'll judge your silence too.",
         as(:wyn, "(very small) ...Yes, Captain."),
         cl(:meat_meat, "(to Kethan, cheerfully) Meat Meat will bite you if you shout at mushroom friend."),
         "KETHAN: ...Noted. The door's this way. Come and look at what you left."].compact, event_id)
    return if !pbConfirmMessage(_INTL("Go down to the Underdark Door?"))
    transfer(2077, 9, 12, 8)
  end

  def underdark_door(event_id = nil)
    return say(lines_for(:underdark_circle), event_id) if flag?(:wyn_cleared)
    speak(:wyn, "(at the broken door) Hyphora called me. That night. The spores sang my name, and I went.",
                "(at the broken door) ...She called me. And I went.", event_id)
    say([as(:wyn, "I thought I was dreaming.")])
    say(lines_for(:underdark_circle))
    say([cl(:alberica, "(touching the rune on her own chest) Same mark. Halo work."),
         as(:wyn, "They broke the seal themselves. If I'd stayed, I'd be in that circle."),
         cl(:meat_meat, "Then mushroom friend was right to go. Meat Meat says so. Meat Meat is a witness now.")].compact)
    say(["At the Tribunal, later, the crystals are asked for Hyphora's account.",
         "The green crystal flickers, and a whisper fills the hall:",
         "HYPHORA: Shadow answered my call."])
    if flag?(:godspark_shadow)
      say(["KETHAN: And you came back with a god's spark. Rootwardens have been promoted for less."])
    end
    set_flag(:wyn_cleared)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 10.05 - Brother from Beyond (Alerion)
  #-----------------------------------------------------------------------------
  def talion(event_id = nil)
    return say(lines_for(:glasswater_still), event_id) if flag?(:talion_released) || flag?(:talion_chased)
    al = herald?(:alerion)
    say(["A boy stands at the lake's still edge. No breath. Skin as cold as the water.",
         "TALION: (reciting, like a memory) You told me to stay in the house. You said you'd come back.",
         "TALION: You came back.",
         as(:alerion, "(not moving) Talion."),
         "TALION: You touched the water when you tried to bring us all back.",
         "TALION: The lake kept a little of me. I've been waiting."], event_id)
    speak(:alerion, "I can take you with me. I know how. I can keep you.", "...I can keep you.")
    Stage.overlay("O-03", opacity: 200, fade: 20)
    say([cl(:wyn, "(very gently) ...Alerion."),
         "A Mirror Wraith rises out of the lake behind the boy.",
         "It whispers: \"Echoes fade when embraced. Reflections devour when chased.\""].compact)
    c = pbMessage(_INTL("Talion..."), [_INTL("\"Let him go, Alerion.\""), _INTL("\"Keep him.\"")], 0)
    if c == 0
      boy = stage_event(event_id)
      dx, dy = boy ? [boy.x - $game_player.x, boy.y - $game_player.y + 1] : [0, -1]
      stage_act(:alerion, :kneel, dx: dx, dy: dy, dir: 8)   # kneeling to hold him
      say([al ? "You kneel and hold your brother." : "Alerion kneels and holds his brother.",
           "Talion smiles, and fades like breath on glass."])
      boy.opacity = 0 if boy rescue nil
      Stage.overlay_off("O-03", fade: 20)
      say(["On his way out, through the lake's mirror, Talion gives the court his testimony:",
           "\"The tall gold man had no reflection. None. For years.\"",
           cl(:wyn, "(sitting down beside him) ...You don't have to talk."),
           with_or_is?(:wyn) ? as(:alerion, "I know. That's why I can.") : nil,
           as(:alerion, "...He was nine. He'd have liked all of you. Even the loud ones.")].compact)
      Stage.cleanup rescue nil
      set_flag(:talion_released)
      wheel(1)
    else
      say([al ? "You reach for the necromancy." : "Alerion reaches for the necromancy.",
           "Talion's face goes hungry and grey. The Mirror Wraith comes up out of the water."])
      Stage.overlay_off("O-03", fade: 10)
      boss_battle(named_mon(:B122H429, 56, "Mirror Wraith"))
      say(["Afterwards, Talion is gone anyway."])
      quiet = Stage.herald(:alerion, 1, 0, 2) if with_or_is?(:alerion)
      Stage.balloon(quiet, "B-01", frames: 60) if quiet
      say(["#{al ? 'You say' : 'Alerion says'} nothing for an hour.",
           "The testimony still comes, from the wraith, through the lake's mirror:",
           "\"The tall gold man had no reflection. None. For years.\""])
      Stage.cleanup rescue nil
      set_flag(:talion_chased)
    end
    set_switch(SW_TALION, false)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 10.06 - Spores of Contention (Alberica)
  #-----------------------------------------------------------------------------
  def councillors_undercanopy(event_id = nil)
    return say(["KELYN: (still a little shaky) Three hundred years. Under our feet.", "KELYN: And they forgave us."], event_id) if flag?(:colony_recognised)
    say(["SELRAE: Spores in the refugee camp. Children sneezing glowing dust.",
         "SELRAE: The Council never sanctioned a fungal colony under the city."], event_id)
    speak(:alberica, "It's been here three hundred years, darling. Come and meet it. Bring a hanky.",
                     "...It's been here three hundred years. Come and meet it.")
    return if !pbConfirmMessage(_INTL("Take Kelyn and Selrae through the Undercanopy to the Fane?"))
    say(["The councillors follow you down through the glowing beds.",
         "Selrae keeps her hands in her sleeves. Kelyn keeps stopping to look.",
         cl(:wyn, "(shyly, to Kelyn) ...That one's a lantern-cap. It likes being looked at.")].compact)
    pbWildBattle(:PARASECT, 52) rescue nil
    say(["Halfway across the gardens, the ceiling groans.",
         "It comes down in a slide of rock and roots. You get everyone through.",
         "Kelyn's cloak doesn't make it.",
         cl(:alberica, "Lose the cloak, Councillor. You look ten years younger.")].compact)
    pbWildBattle(:BRELOOM, 53) rescue nil
    say(["LUMINARA: (to the councillors) Surface. Sap-takers.",
         "LUMINARA: ...We forgive you. We have something to show.",
         "She lifts a glowing memory bubble."])
    Stage.overlay("O-03", fade: 20)
    say(["In it: Var Rime-Breaker, alone in the roots, peeling his own face back like a mask."])
    Stage.overlay_off("O-03", fade: 20)
    say(["KELYN: (sitting down on the floor of the Fane) ...Oh."])
    set_flag(:colony_recognised)
    set_flag(:memory_bubble)
    set_flag(:fungal_liaison)
    add_counter(:story_beats)
    say(["(Alberica is named the Council's Fungal Liaison.)",
         "(Luminara's memory bubble will be the strongest evidence at the Verdict.)",
         as(:alberica, "Fungal Liaison. At last, a title that matches my reputation."),
         cl(:reptin, "Please don't put that on a business card.")].compact)
  end

  #-----------------------------------------------------------------------------
  # SC 10.07 - Gym 8: the Trial of Winter
  #-----------------------------------------------------------------------------
  def selrae_trial(event_id = nil)
    return say(["SELRAE: Auril is still out there, on her island.",
                "SELRAE: She'll have felt the summer end. She'll come for what she thinks is hers."], event_id) if flag?(:badge_selrae)
    say(["SELRAE: Winter judges the old way. Not by what you say.",
         "SELRAE: By whether you can stand in the cold and not let go of each other.",
         "SELRAE: I wanted a little winter for this city. Let me show you what a little winter is."], event_id)
    return if !pbTrainerBattle(:FT_WINTER_MATRON, "Selrae", nil, false, 0)
    $Trainer.badges[7] = true
    set_flag(:badge_selrae)
    set_flag(:selrae_witness)
    add_counter(:story_beats)
    say(["SELRAE: Winter's Seal."])
    pbMessage(_INTL("\\me[Badge get]{1} received Winter's Seal!", $Trainer.name))
    give(:TM13)
    say(["SELRAE: Ice Beam. Cold, and straight, and honest.",
         "SELRAE: And my word at the verdict. For whatever an old Halo-sheltering fool's word is worth.",
         "She looks north for a moment, past all of you.",
         "SELRAE: Auril is still out there, you know. On her island.",
         "SELRAE: She'll have felt the summer end. She'll come for what she thinks is hers.",
         cl(:alerion, "She can try."),
         cl(:alberica, "(a hand over her rune) ...Let's not dare her, pretty boy.")].compact)
    state[:goal] = "When you're ready, tell Kelyn in the Council Hall. The crystals will hear the verdict."
  end

  #-----------------------------------------------------------------------------
  # SC 10.08 - The Verdict; 10.09 - The Vote
  #-----------------------------------------------------------------------------
  def kelyn_trials(event_id = nil)
    return say(["KELYN: Four chairs. Four seasons. All of them filled."], event_id) if flag?(:ch10_done)
    n = witnesses.size
    say(["KELYN: Witnesses so far: #{n}. The crystals hear them on the seventh day."], event_id)
    if !flag?(:badge_selrae)
      return say(["KELYN: Selrae means to put you through the Trial of Winter first.",
                  "KELYN: At the Still Sky Shrine. She's waiting."])
    end
    return if !pbConfirmMessage(_INTL("Call for the verdict? (The trial week ends.)"))
    scene_verdict
    scene_vote
  end

  def scene_verdict
    n = witnesses.size
    say(["The seventh day. The Council Hall is full: Rootspire, the refugees, Rootwardens on the walls.",
         "The crystals hear every witness: " + witnesses.map { |_, who, _| who }.join(", ") + "."]) if n > 0
    say(["KELYN: (reading) The death of the Summer Marshal.",
         "KELYN: The Summer Marshal died thirty years ago, and this court grieves him now. Not guilty.",
         "KELYN: The death of the Autumn Warden..."])
    if n >= 3
      say(["KELYN: ...was the death of a man feeding children to a fire. Not guilty.",
           "The gallery erupts.",
           as(:meat_meat, "(very quietly) ...Mama. Mama, did you hear?"),
           cl(:alberica, "(already crying, already hugging a stranger) Drinks! Drinks on me!")].compact)
      set_flag(:verdict_acquitted)
    elsif n >= 1
      say(["KELYN: ...is a matter this court cannot excuse.",
           "KELYN: Meat Meat will serve the refugee camp for a season.",
           as(:meat_meat, "Meat Meat will serve. Meat Meat will bring coffee. The camp will be terrified.")])
      set_flag(:verdict_service)
    else
      say(["KELYN: ...guilty.",
           "KELYN: A geas: you may not leave Rootspire without the Council's leave.",
           cl(:reptin, "(under his breath) Well. It could have gone better. It could also have gone with spears.")].compact)
      set_flag(:verdict_geas)
    end
    add_counter(:story_beats)
  end

  def scene_vote
    say(["Out in the Blooming Fields, five candidates stand on a stage of braided roots.",
         "Flowers and snow grow side by side at their feet."])
    keys = CANDIDATES.keys.select { |k| k != :phildendrin || flag?(:phildendrin_found) }
    keys.each { |k| say(["#{CANDIDATES[k][0]}: #{CANDIDATES[k][1]}."]) }
    picks = []
    2.times do |i|
      left = keys - picks
      c = pbMessage(_INTL(i == 0 ? "Who do you endorse first?" : "And second?"), left.map { |k| _INTL(CANDIDATES[k][0]) }, 0)
      picks << left[[c, 0].max]
    end
    n = witnesses.size
    winners = if n >= 4 then picks
              elsif n >= 2 then [picks[0], ([:rheven, :eirwen] - [picks[0]]).first]
              else [:rheven, :eirwen]
              end
    winners.each { |k| set_flag(:"council_#{k}") }
    say(["The city votes. #{winners.map { |k| CANDIDATES[k][0] }.join(' and ')} take the empty chairs.",
         "KELYN: (at the end) Four chairs. Four seasons.",
         "KELYN: For the first time in my life, all of them filled.",
         "The crystals blaze: green, gold, red, white.",
         cl(:alberica, "To full chairs! Somebody find me a drink."),
         cl(:meat_meat, "Somebody find Meat Meat a coffee."),
         cl(:wyn, "...I made both. They're by the door. Sorry.")].compact)
    if !(winners & %i[mira rheven anduin]).any?
      say(["LUMIN: (later) Nobody's got a ship, or a griffon, or a whale-bell.",
           "LUMIN: Then I'll ring Angajuk's bell myself. It'll be a longer voyage."])
      set_flag(:long_voyage)
    end
    set_flag(:ch10_done)
    loop_snapshot(:act2)
    set_switch(SW_TRIALS, false)
    set_switch(SW_ACT2_DONE, true)
    add_counter(:story_beats)
    say(["END OF ACT II"])
    state[:goal] = "Auril is on her island. The Council will send you north."
    act3_start if respond_to?(:act3_start)
  end

  def apply_chapter10_switches
    return if !active? || !$game_switches
    $game_switches[SW_TRIALS] = flag?(:trials_open) && !flag?(:ch10_done)
    $game_switches[SW_PHIL_MIRROR] = flag?(:phildendrin_found) && !flag?(:mm_atoned)
    $game_switches[SW_TALION] = flag?(:trials_open) && trials_done > 0 && !flag?(:talion_released) && !flag?(:talion_chased)
    $game_switches[SW_ACT2_DONE] = flag?(:ch10_done)
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter10_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 10 switches failed: #{err.message}")
  end
}
