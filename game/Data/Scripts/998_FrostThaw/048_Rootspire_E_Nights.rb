#===============================================================================
# Frost & Thaw - Rootspire as a living city (part E): nights and watchers
#
#   Every rest at the Rooted Hearth is a night in Rootspire (state[:rs_day]).
#   A night brings, in turn: the morning's downtime beats (part F), one of the
#   ten Rootspire Night Events, and sometimes one of Auril's Omens.
#   The first step on a Rootspire map can bring one of the faction vignettes
#   (each only in its own district, as the dossier places them), one of the
#   twelve solo-ambient events ("all factions watching"), a down-the-root hook,
#   an Omen, or the first-visit atmosphere of the tier.
#
#   Auril's Omens on Alberica: five signs only she sees, one per Herald, each
#   in three tiers (Ch6, Ch7-8, after the summer ends) that turn harsher, the
#   way the GM notes say they do. :omens_seen counts them for the Ch11 whisper.
#===============================================================================
module FrostThaw
  RELIC_ITEMS.merge!(
    FT_GOLDLEAF: ["Gold-Leaf Charm", "Gold-Leaf Charms", 8, 0,
      "Left on your pillow in a velvet box. No note. It smells of Lirielle's perfume, and of something warmer. Autumn's courtship.", 0, 0, 0]
  )

  TRAINERS.merge!(
    halo_silencer: [:FT_HALO, "Silencer Mott", [[:MRMIME, 42], [:B124H122, 42], [:B200H215, 43]], "..."],
    yeti_hunter:   [:HIKER, "Bounty-Hunter Grell", [[:PILOSWINE, 42], [:B217H59, 42], [:B232H217, 43]], "A yeti pelt's worth more than your whole team."],
    effigy_kneeler: [:FT_HALO, "Effigy Kneeler", [[:SNEASEL, 41], [:B124H215, 42]], "The Saint would have stood up. You've made him wait."]
  )
  TRAINER_INTROS.merge!(
    halo_silencer:  "...(The Silencer mouths something. No sound comes out.)",
    yeti_hunter:    "GRELL: Hand over the cub, Heralds. Furs don't pay for themselves.",
    effigy_kneeler: "KNEELER: (hands still on the white wood) A little longer. He's nearly awake.",
    eira_voss:      "EIRA VOSS: (in a whisper that fills the cellar) Be still."
  )

  #-----------------------------------------------------------------------------
  # Auril's Omens
  #-----------------------------------------------------------------------------
  # key => [herald, [[tier1 triggers], [tier2], [tier3]], [tier lines...]]
  # In the lines: {A} Alberica/you, {A's} Alberica's/your, {She} {she} She/You,
  # {her} her/your, [[third|second]] the verb for each.
  OMENS = {
    dark_half: [:alerion, [[:twins_met, :echo_wraiths_down, :mantle_found], [:eren_pupil, :alerion_reflection, :ch7_started], [:summer_ended]], [
      ["Alerion steps between {A} and the doorway without a word, the way he always does.",
       "Along his shadow on the floor, frost blooms. Feathers of it, even by the firelight.",
       "{A} [[blinks|blink]]. It's gone. Nobody else is looking at the floor."],
      ["Alerion goes still and silent, listening, the way he does when he's guarding all of you.",
       "His shadow is white. Frost all the way up the wall, thick as fur, creaking.",
       "{A's} hand goes to {her} chest. When {she} [[looks|look]] again, it's only a shadow."],
      ["Alerion is keeping watch again. {A} can't stop looking at his shadow.",
       "It's frozen solid on the ground. Under the ice, something shaped like him lies buried beneath great white wings.",
       "A voice, very close: \"Sentinel of silence. That's all he'll be. You'll watch him become it.\""]
    ]],
    light_half: [:meat_meat, [[:twins_met, :hearth_coffee, :razzy_first_flight], [:ch7_started, :heist_done], [:summer_ended]], [
      ["Meat Meat laughs: a real laugh, the loud one that makes the whole Hearth turn round.",
       "{A} [[breathes|breathe]] out, and the breath fogs thick in the warm room. It curls away like vines.",
       "Nobody else's breath is fogging."],
      ["Meat Meat laughs, and says something warm and stupid, and everyone groans.",
       "{A's} breath comes out white and heavy and creeps along the table like ivy, reaching for the goblin.",
       "Every flame needs frost waiting to quench it. The thought isn't {A's}."],
      ["Meat Meat laughs, and {A's} breath freezes in {her} throat. Actually freezes. {She} can't swallow.",
       "The steam that finally escapes curls into the shape of a meadow on fire, and a goblin holding a dragon's muzzle.",
       "\"Flame consumes as easily as it warms. Ask the goblin, when it's ash.\""]
    ]],
    memory: [:alberica, [[:key_found, :canticle_learned], [:codex_fragment_2, :eirwen_ritual, :ch7_started], [:summer_ended]], [
      ["{A} [[touches|touch]] the hollow of {her} throat, where the pendant used to hang. The skin there is cold on one side, warm on the other.",
       "Frost creeps across the left of the collarbone. Heat glows faint on the right. They meet in a line, silently fighting.",
       "When Reptin glances over, there's nothing there at all."],
      ["{A} [[touches|touch]] the place where the pendant used to be, and frost bites {her} fingertips.",
       "The rune Auril scarred into {her} chest burns cold through the cloth. The warm side is losing.",
       "{She} [[pulls|pull]] {her} collar up before anyone looks."],
      ["{A's} blood goes cold where {she} touched the rune. Cold enough to ache to the elbow.",
       "\"Memory keeps the key. And keys open as well as destroy. Which will you be, my vessel?\"",
       "{She} [[doesn't|don't]] tell anyone. {She} [[hasn't|haven't]] told anyone any of it."]
    ]],
    spark: [:glimmer, [[:glimmer_joined], [:glimmer_rite_done, :tree_communion, :ch7_started], [:glimmer_gone]], [
      ["Glimmer says Shimmer's name, very quietly, and the Lumen Shard glows under his coat.",
       "Close to {A's} ear: a crackling, like a fire smothered in snow.",
       "And under it, so faint it could be the wind: \"His grief burns too hot. Watch him.\""],
      ["Glimmer calls on Brightmane, and gold light fills the room.",
       "The crackling's back, right against {A's} ear. Fire, choking under snow.",
       "\"His grief burns too hot. Watch him. Watch him. Watch him.\""],
      ["Somebody says Glimmer's name, and there's no one to answer to it any more.",
       "Close to {A's} ear, the crackling: a fire that's finally gone out under the snow.",
       "\"His grief burned too hot. I told you to watch him. You didn't.\""]
    ]],
    life_death: [:reptin, [[:rheven_counselled, :fed_pack], [:oath_of_roots, :still_beast_done, :fields_pulse, :ash_exposed], [:summer_ended]], [
      ["Reptin spares someone who didn't deserve sparing, and doesn't hesitate.",
       "{A's} heartbeat slows. Slower. Slower. Then it slams back, fast, as if somebody had tested how long {she} could go without one."],
      ["Reptin decides a life, gently, one way and then the other. Balance.",
       "{A's} heart stops. A full breath. Two. Then it hammers, and {she} [[has|have]] to sit down.",
       "\"Life and death march only so long as they move.\""],
      ["Reptin does what a Warden of Life and Death does, and {A's} blood freezes.",
       "For a heartbeat {she} [[sees|see]] him dead in the snow, and all of them with him.",
       "\"Stop them, and all is mine. You could stop them, Alberica. You could stop them so easily.\""]
    ]]
  }

  SW_FROSTFELL = 4177     # the Celestial Rift's portal to the Frostfell is open

  module_function

  # The tier follows the story (rootspire.md: "present every session") and
  # turns harsher if Alberica strays toward Auril (session_log L94-102): each
  # Auril-leaning choice she or the party has made pulls the next tier closer.
  def omen_tier
    base = if flag?(:summer_ended) || flag?(:glimmer_gone) then 3
           elsif flag?(:ch7_started) then 2
           else 1
           end
    [base + (alberica_strayed >= 2 ? 1 : 0), 3].min
  end

  # Choices that lean toward the Frostmaiden: looking for her in Bryn Shander's
  # crowd, the hag's bargain, buying Still Shards from Eira Voss, answering the
  # frost sigil in the Silent Chapel, leaving the goddess whole in the Shard.
  def alberica_strayed
    %i[saw_auril_bryn hag_bargain_taken chapel_auril shard_preserved tree_leans_frost].count { |f| flag?(f) } +
      ((counter(:stillshards_cursed) rescue 0).to_i > 0 ? 1 : 0)
  end

  # One omen, if one is due. Only for Alberica (in the party, or you). The
  # omens lead up to Auril's Whisper at the Hearth (037), and stop with it.
  def omen_check
    return false if !with_or_is?(:alberica) || flag?(:auril_whisper)
    state[:omens] ||= {}
    OMENS.each do |key, (who, triggers, tiers)|
      next if who != :alberica && !with_or_is?(who) && !(key == :spark && flag?(:glimmer_gone))
      (0..2).each do |t|
        next if state[:omens][[key, t]]
        next if t + 1 > omen_tier
        next if triggers[t].none? { |f| flag?(f) }
        state[:omens][[key, t]] = true
        play_omen(key, tiers[t])
        return true
      end
    end
    false
  end

  def omen_text(line, me)
    t = line.gsub(/\[\[([^|\]]*)\|([^\]]*)\]\]/) { me ? $2 : $1 }
    t = t.gsub("{A's}", me ? "your" : "Alberica's").gsub("{A}", me ? "you" : "Alberica")
    t = t.gsub("{She}", me ? "You" : "She").gsub("{she}", me ? "you" : "she").gsub("{her}", me ? "your" : "her")
    t = t.gsub(/([.!?]\)?\s+)(you|your)\b/) { "#{$1}#{$2.capitalize}" }   # (context 09: "...again. You can't")
    t.sub(/\A(you|your)\b/) { $1.capitalize }
  end

  def play_omen(key, lines)
    add_counter(:omens_seen)
    me = herald?(:alberica)
    pbSEPlay("Ice8", 60, 120) rescue nil
    $game_screen.start_tone_change(Tone.new(-40, -20, 30, 60), 6) rescue nil
    first = counter(:omens_seen) == 1
    frame = if me then "(Something only you can see.)"
            elsif first then "(For a moment you see what Alberica sees. Nobody else does.)"
            else "(Something only Alberica sees.)"
            end
    say([frame] + lines.map { |l| omen_text(l, me) })
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 10) rescue nil
    if first && !me
      sayc([cl(:alberica, "(very lightly, to nobody) I'm fine, darlings. Just a chill. Somebody's walking over my grave.")].compact)
    end
  end

  #-----------------------------------------------------------------------------
  # A night at the Hearth
  #-----------------------------------------------------------------------------
  # Called by Hellen's rest (024) after the party's healed.
  def hearth_night(event_id = nil)
    return if !flag?(:met_hellen) || flag?(:auril_whisper)    # Chapter 11 begins with the Whisper at the Hearth
    if !state[:rs_day]                 # the night you arrive is Day 1
      state[:rs_day] = 1
      act1_jobs_goodbye if respond_to?(:act1_jobs_goodbye)   # the Dale's unfinished favours (context 14, M14-9 B)
      return
    end
    state[:rs_day] += 1
    bank_grow if respond_to?(:bank_grow)
    dawn_hue
    hearth_word
    return if investigation_night
    downtime_morning if respond_to?(:downtime_morning)
    return if respond_to?(:hearth_extras) && hearth_extras   # the Cycle Day rumours, standing boons, Autumn's ruin (048_H)
    return if omen_check
    hearth_vignette || night_event
  end

  def rs_day = state[:rs_day] || 1

  # Act II side quests that the city remembers (and the trial will call): the
  # first one done, Hellen says so (context 15, M15-4 B).
  CITY_REMEMBERS = %i[heist_done ash_exposed oath_of_roots still_beast_done frozen_run_done cellar_cleared kelyn_secret
                      eren_settled naerth_ledger_decided halden_done canticle_learned robes_seen]

  # One line from Hellen at the night's rest, at most: what's changed in the city.
  def hearth_word
    if !flag?(:city_keeps_count) && CITY_REMEMBERS.any? { |f| flag?(f) }
      set_flag(:city_keeps_count)
      return say(["Far up the trunk, in the Council Hall, a crystal brightens. Rootspire remembers.",
                  "HELLEN: Word's round the Bazaar what you did. This city keeps count, love. Good and bad."])
    end
    if flag?(:ch7_started) && !flag?(:hellen_favours_word)
      set_flag(:hellen_favours_word)
      return say(["HELLEN: Since the Council sent you down, half the city's come to me with a favour.",
                  "HELLEN: I've told them where you sleep."])
    end
    if rs_day >= 3 && flag?(:orb_visions) && !flag?(:kelyn_secret) && !flag?(:hellen_orb_word) && !flag?(:summer_ended)
      set_flag(:hellen_orb_word)
      say(["HELLEN: The High Speaker's up at the orb again. Every night this week."])
      side_goal(:kelyn_orb, "The High Speaker goes up to the twin orb at night, alone. Hellen's seen her.", done: [:kelyn_secret, :summer_ended])
    end
  end

  # The Cycle Pulse: Rootspire's dawn shows where the year has got to.
  def dawn_hue
    hue =
      if flag?(:summer_ended) then "green, then white, then a soft red: three seasons at once, turning"
      elsif flag?(:tree_communion) then "gold, then, for one breath, the faintest green"
      elsif flag?(:ch7_started) then "gold. Deep gold. It lingers far too long"
      else "gold, the way it's been gold for thirty years"
      end
    hue += flag?(:tree_leans_frost) ? ", with a rim of hard white frost at its edges that wasn't there before" : ""
    hue += flag?(:tree_leans_verdant) && !flag?(:summer_ended) ? ", and the leaves along the Wall a little greener for it" : ""
    say(["Dawn over Rootspire: #{hue}."])
  end

  # After the festival: the Rootwardens come to the door (GM outline, steps 1-6).
  # Steps 1-6 run between the festival and the descent, in the source's order:
  # the door, the scorch, Eirwen, Razzilith, the summons (council_summons, 024).
  def investigation_night
    return false if !flag?(:festival_night) || flag?(:ch7_started) || flag?(:rootwardens_at_door)
    set_flag(:rootwardens_at_door)
    set_switch(SW_SCORCH, true)
    sayc(["Past midnight, someone hammers on the Hearth's door.",
          "Two Rootwardens of the Claw circle, soot on their sleeves.",
          "ROOTWARDEN: Heralds. A patrol's missing. Three of ours went out to the Echo Gate after the heat pulses.",
          "ROOTWARDEN: They found scorch marks. Warm ones. In a city that hasn't had a cold night in thirty years.",
          "ROOTWARDEN: Then they stopped answering.",
          cl(:reptin, "(already pulling his boots on) The Echo Gate. West road. Come on.")].compact)
    if with_or_is?(:meat_meat)
      sayc(["Down at the dragons' hollow, Razzilith hasn't slept. He's clawing at the floor of the Shrine.",
            herald?(:meat_meat) ? "(Through the bond, you feel what he feels: a dragon, made, not born. A heart in it that's screaming. And her.)" :
                                  "Through the bond Meat Meat feels what he feels, and goes grey: a dragon, made, not born. A heart in it that's screaming. And her.",
            cl(:meat_meat, "The woman who hurt him. She is down there. Under all of it.")].compact)
    end
    # rootspire.md 5662-5667: both twins grow restless, not only Razzilith; and Glimmer hears the hammers.
    sayc([flag?(:twins_met) ? "Up on the Shrine, Frostina won't settle either. She paces the dragons' hollow, wings half open, and every few breaths she stops to listen to the floor." : nil,
          flag?(:twins_met) ? (herald?(:alerion) ? "(Through the bond, cold and clear: she can hear hammers. She doesn't like the song they're making.)" :
                                                   cl(:alerion, "(a hand to his chest) Frostina's awake. She can hear them too. Hammers.")) : nil,
          with_or_is?(:glimmer) ? (herald?(:glimmer) ? "(And you can hear it now, under everything. Hammers. Deep in the roots, keeping time.)" :
                                                       "GLIMMER: (very quietly, a hand on his chest) Hammers. Deep in the roots. They're keeping time.") : nil].compact)
    side_goal(:patrol, "The Rootwardens' missing patrol: scorch marks at the Echo Gate, on the west road.", done: :chardalyn_found)
    true
  end

  # The scorch marks at the Echo Gate, and the chardalyn fragment.
  def scorch_marks(event_id = nil)
    return say(["Only old soot now, and the faint smell of metal."], event_id) if flag?(:chardalyn_found)
    sayc(["The flagstones by the Echo Gate are scorched in a long, curving drag. Warm to the touch, hours later.",
          "The smell is wrong: hot metal, and under it something sour and old.",
          "Like a struck match in a crypt.",
          "Wedged in a crack, half melted into the stone: a shard of dark crystal.",
          "It's scored with sigils that glow dull red.",
          cl(:alerion, "Chardalyn. Glass a demon breathed on. Nothing good is made of it.")].compact, event_id)
    # (context 06, M6-7: Meat Meat knows the mark; it places Avarice below, not as Summer)
    if with_or_is?(:meat_meat)
      mm = herald?(:meat_meat)
      if !mm
        ev = (Stage.summon(:meat_meat) rescue nil)
        Stage.emote(ev, :exclaim) rescue nil if ev
      end
      speak(:meat_meat, "(very still) That mark. The mirror with the A in it. It was on the cold table.",
                "(very still) ...That mark. The cold table.")
      sayc([as(:meat_meat, "On the jars. On the straps. On Meat Meat's arm, once."),
            mm ? cl(:alberica, "(not touching it) Whose mark, sweetheart? You've gone grey.") :
                 cl(:alberica, "(not touching it) Whose mark, sweetheart?"),
            as(:meat_meat, "The lady with books and bones. White hair. Her name starts with it.")].compact)
      speak(:meat_meat, "Avarice.", "...Avarice.")
      sayc([cl(:alerion, "Naerth's pale lady. Then she came through the glass too.")].compact)
    else
      sayc([cl(:alberica, "(not touching it) Those sigils. They're hers. The cracked mirror and the A.")].compact)
    end
    give_key(:FT_CHARDALYN)
    set_flag(:chardalyn_found)
    set_switch(SW_SCORCH, false)
    say(["Beyond the scorch, three Rootwarden cloaks lie neatly folded in the dust, as if left for you to find.",
         "No bodies. No footprints. Only a drag mark, going down."])
    sayc([cl(:alerion, "(at the drag mark) Down. Eirwen has the oldest maps. She'll know what's under.")].compact)
    side_goal(:patrol, "Take the chardalyn to Eirwen at the Wind-Glass Library, up on the Canopy-Tier.", done: [:eirwen_audience, :barricade_entered])
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # The ten Rootspire Night Events, one per night, in the order the deck gives.
  #-----------------------------------------------------------------------------
  NIGHT_ORDER = [:verdant_storm, :tavern_revelry, :reflection_smiles, :perfume_prophecy, :runaway_warden, :autumn_visit,
                 :halo_ambush, :auroral_storm, :yeti_child, :silent_market, :tree_dream]

  def night_event
    state[:nights_done] ||= []
    key = NIGHT_ORDER.find { |k| !state[:nights_done].include?(k) && night_ready?(k) }
    return false if !key
    state[:nights_done] << key
    send(:"night_#{key}")
    true
  end

  def night_ready?(key)
    case key
    when :autumn_visit then flag?(:met_kelyn) || flag?(:wardens_emeritus)
    when :halo_ambush, :silent_market then flag?(:wardens_emeritus)
    when :yeti_child then flag?(:met_rheven) || flag?(:still_beast_asked) || rs_day >= 5
    when :verdant_storm then rs_day >= 10          # once a tenday
    else true
    end
  end

  def night_tavern_revelry
    sayc(["The Hearth is roaring tonight. Rootwardens off shift, Corsairs on shore leave, a Wennen band, a goblin choir.",
          "Somebody buys the Heralds a round. Then somebody else does. Then Hellen gives up and stops charging anyone.",
          herald?(:alberica) ? "You sing. You can't help it. The whole room sings back." : cl(:alberica, "(already on a table) One song, darlings. Then another. Then we'll see."),
          "By closing there's a hat on the bar full of coin, and Hellen pushes it across to you.",
          "HELLEN: Your share. Don't argue. I made three times that on the mead."].compact)
    $Trainer.money += 2500 rescue nil
    pbMessage(_INTL("You received $2,500."))
    tavern_rumour
  end

  # The seven things Alberica heard in the market (and what the Hearth hears).
  TAVERN_RUMOURS = [
    [:rumour_mirrors, "Merchants say some of the frost-glass mirrors in the Bazaar watch back. Move before you do. A child went strange last week."],
    [:rumour_secrets, "Secrets flow through the market like sap. Say a thing at one stall, and three stalls down they're already repeating it."],
    [:rumour_bryn, "Bryn of Spring looks like he hasn't slept in a month. Something about the roots by the Heartroot. He says nothing's wrong. He says it too fast."],
    [:rumour_lirielle, "Lirielle's dreams have gone dark. Burning roots, screaming sap. Her fur smells of charred flowers."],
    [:rumour_robes, "The Frost-Thread tailors say the Autumn Warden ordered crowning robes. For a coronation. Nobody knows whose."],
    [:rumour_spores, "The counting spores at the Thorned Ledger whisper one name at night, over and over. The clerks call it spore echo. They're scared."],
    [:rumour_heat, "Heat comes up the sap-lines after sundown now. Not like weather. Like something burning, under the city."]
  ]

  def tavern_rumour
    r = TAVERN_RUMOURS.find { |f, _| !flag?(f) }
    return say(["The talk at the bar tonight is all about you. It's flattering. It's exhausting."]) if !r
    set_flag(r[0])
    say(["Over the last cups, at the bar, you catch a rumour:", r[1]])
  end

  def night_reflection_smiles
    sayc(["Late. Your room at the Hearth, one candle. The little frost-glass mirror on the washstand.",
          "You lean in to wash your face. Your reflection smiles first.",
          "Not at you. Past you. At something behind the glass: fire, chains, a forge the size of a cathedral, deep under the roots."])
    c = pbMessage(_INTL("Your reflection is smiling..."), [_INTL("Look away."), _INTL("Hold its gaze.")], 0)
    if c == 0
      say(["You turn the mirror to the wall. Your hands shake for an hour. You don't sleep much."])
    else
      set_flag(:forge_glimpsed)
      sayc(["You stare back. The glass fogs with heat.",
            "A cathedral of burning sap. Iron arms, swinging. A dragon on a slab, made of dark crystal and mirror-glass, not yet alive.",
            "And a woman with white hair and red-gold eyes, turning, as if she'd heard you looking.",
            "She smiles, the way your reflection did. Her lips move, and out of the glass, very small, comes a newborn's cry.",
            "Then another. A third. A fourth. A fifth. Each one different. Each one, somehow, yours: the first sound each of you ever made.",
            "\"I know every name ever spoken in my laboratory, variables. I know the ones you were born with.\"",
            "Then the mirror cracks straight across.",
            cl(:meat_meat, "(from the doorway, very quiet) Meat Meat saw her too. In the spoon. Meat Meat is not using spoons any more.")].compact)
      wheel(1)
    end
  end

  def night_perfume_prophecy
    sayc(["In the small hours, a scent drifts in under the door. Not the Hearth's woodsmoke. Lirielle's: crushed petals, and ash.",
          "It gets into your dreams."])
    if respond_to?(:perfume_prophecy)
      perfume_prophecy
    else
      say(["You dream of roots, burning. Of sap, screaming. Of someone rewriting a season with a pen of fire."])
    end
  end

  def night_runaway_warden
    sayc(["A crash downstairs. A young Rootwarden has fallen through the Hearth's door, grey-faced, shaking.",
          "The veins in her hands glow a dull red, like coals under ash.",
          herald?(:wyn) ? "(Til. Two years below you at the Hall. She used to steal your bread.)" : nil,
          "ROOTWARDEN TIL: Don't... don't take me back to the Hall. They'll say I deserted. I just... I touched the crates.",
          "ROOTWARDEN TIL: Black grit. Warm. From the docks. It got in my cuts and now it's in me."])
    if with_or_is?(:reptin)
      speak(:reptin, "(kneeling, hands on her wrists) Easy. It's burning you from inside. Breathe with me. With the tree.",
            "...Breathe with me.")
      say(["Green light runs down #{herald?(:reptin) ? 'your' : "Reptin's"} arms and into hers. The red in her veins dims, sullen, and goes out."])
    elsif ($PokemonBag.pbHasItem?(:FULLHEAL) rescue false)
      $PokemonBag.pbDeleteItem(:FULLHEAL) rescue nil
      say(["You pour a Full Heal into her cuts. It hisses. The red in her veins fades, slowly."])
    else
      say(["Hellen sends for a Seed-circle healer. It takes until dawn. Til lives."])
    end
    set_flag(:ore_poison_seen)
    say(["ROOTWARDEN TIL: (shivering) Infernal ore. That's what the old Wardens call it. Somebody's moving it through the Root-Tier.",
         "ROOTWARDEN TIL: Ask the dockhands. Ask Jorik. He went white when I asked."])
  end

  def night_autumn_visit
    sayc(["A knock, late. On the step: a fox-masked Wennen in red velvet, holding a lantern with a red leaf painted on the glass.",
          "EMISSARY: The Court of Splendor sends its regards. And a question, which it asks of everyone it admires.",
          "EMISSARY: When Summer returns, and it will, to whom will the Heralds bow?"])
    c = pbMessage(_INTL("The Court of Splendor asks..."), [_INTL("\"To Summer, gladly.\""), _INTL("\"To nobody.\""), _INTL("\"Who sent you, really?\"")], 1)
    case c
    when 0
      set_flag(:autumn_flattered)
      favour(:autumn, 2); favour(:spring, -1); favour(:winter, -1)
      say(["EMISSARY: (bowing deep) Splendid. The Court will remember. The Court always remembers.",
           "A purse of gold leaf left on the step. Somebody's watching from across the street. Several somebodies."])
      $Trainer.money += 3000 rescue nil
    when 1
      favour(:spring, 1); favour(:winter, 1); favour(:autumn, -1)
      say(["EMISSARY: (a soft laugh behind the mask) Nobody. How very... Wintry of you. The Court will remember that too."])
    else
      set_flag(:autumn_emissary_pressed)
      say(["EMISSARY: (the mask tilting) Sent? I'm a private admirer.",
           "EMISSARY: ...If I were sent, it would be by someone who'd like to know where you'll stand when the robes are finished.",
           "The lantern goes out. So does the emissary."])
    end
    sayc([cl(:alberica, "Darling, that was a political test. We've been graded. I can feel it."),
          cl(:reptin, "Then let's hope they grade on effort.")].compact)
  end

  def night_halo_ambush
    sayc(["Walking back to the Hearth after dark. The lanterns along the root-walk go out one after another.",
          "The cold arrives before they do."])
    trainer(:halo_ambusher)
    sayc(["The cultist breaks and runs. On the boards, a token of mirror-glass, still freezing: a snowflake inside a cracked halo.",
          cl(:alerion, "They knew our route home.")].compact)
    set_flag(:halo_ambushed)
  end

  def night_auroral_storm
    sayc(["The aurora comes down in the night. Not drifting: coming down, like a wave, all the way to the leaves.",
          "Every window in the Hearth blows in at once. Light that has weight. It hits like a fist."])
    ($Trainer.party || []).each { |pk| next if !pk || pk.egg? || pk.hp <= 1; pk.hp = [pk.hp - (pk.totalhp / 5), 1].max }
    say(["(Your Pokémon are battered by the storm.)",
         "In the light, for a moment, visions: snow falling on the Dale again, at last.",
         "A vault in the ice, a door with wings spread over a frozen eye.",
         "Two dragons over a city, one green, one white, and a rider on each."])
    set_flag(:auroral_storm_seen)
    set_switch(SW_FROSTFELL, true)
    say(["HELLEN: (at the broken window, very pale) Look at the Rift. Up at the crown. It's never done that before.",
         "High above, where the Celestial Rift pours down, something has torn open: a door of white light."])
  end

  def night_yeti_child
    sayc(["Shouting in the street before dawn. Rootwardens with spears, a ring of lanterns, and in the middle of it something small and white and terrified.",
          "A yeti cub. It's wandered in from the Blooming Fields, through the Wall's edge, crying for its mother.",
          "WARDEN: Stand back, Heralds. A yeti's a yeti. Cub or not.",
          "A man in furs pushes through with a net: the kind who'd sell a pelt."])
    c = pbMessage(_INTL("The yeti cub..."), [_INTL("Take it home to the Fields."), _INTL("Leave it to the Wardens.")], 0)
    if c == 1
      say(["You step back. The Wardens close in. You hear it cry for a long time. Then you don't."])
      wheel(-1)
      return
    end
    say(["You kneel. The cub stops crying, and climbs into your arms, and bites your sleeve very hard.",
         "BOUNTY-HUNTER GRELL: That's my pelt you're cuddling."])
    trainer(:yeti_hunter)
    sayc(["You carry the cub out to the Blooming Fields, along the Wall, to where the snow begins.",
          "Out of the hanging snow, something huge and white is waiting. She doesn't move. She watches you.",
          "You set the cub down. It runs to her. She sniffs it all over, very carefully.",
          "Then she looks at you for a long moment, and leaves something in the snow, and is gone.",
          cl(:reptin, "(very softly) That's a mother's thank-you. You don't get many of those from yetis.")].compact)
    give(:NEVERMELTICE)
    set_flag(:yeti_child_home)
    wheel(1)
  end

  def night_silent_market
    sayc(["Crossing the Bazaar after midnight. Every stall shut, every lantern lit.",
          "Then, between one step and the next, sound stops. No boots. No breath. No wind in the leaves.",
          "You try to call out. Nothing comes out. Nothing at all."])
    say(["Shapes in the stalls, moving. A Mr. Mime of the Halo, palms flat against an invisible wall it's built around you."])
    trainer(:halo_silencer)
    sayc(["The wall shatters like a dropped plate. Sound comes back all at once: a dog barking, the tree's creak, your own heartbeat.",
          "The Silencer is gone. Nailed to a stall: a strip of frost-silk, embroidered with the words PERFECT STILLNESS."])
    set_flag(:silent_market_broken)
  end

  # Verdant Weather: once a tenday a Verdant Storm sweeps the valley, waking
  # dormant roots, or the dead frozen in them.
  def night_verdant_storm
    sayc(["Rain in the night that smells of pine and ash. Lightning, and it flashes green.",
          "The Verdant Storm, the old folk call it. Once a tenday.",
          "Under the Trunk-Tier, the dormant roots wake and thrash. And out of one, cracking free of the bark it froze in four hundred years ago:",
          "a dead man, still in Ten-Towns furs, with roots grown through his ribs. It walks toward the Hearth's light."])
    boss_battle(named_mon(:B93H182, 43, "Root-Bound Dead"))
    say(["The dead man falls apart into leaves and frost. By morning the roots have grown back over the place he lay.",
         "HELLEN: (sweeping up, unbothered) Verdant Storm. You get used to them. You don't get used to them."])
    set_flag(:verdant_storm_seen)
  end

  # The Celestial Rift's portal to the Frostfell, after an auroral storm: the
  # ice-winged angels bearing Avarice's mark the Rootwardens have seen.
  def frostfell_portal(event_id = nil)
    return say(["The air where the portal was still smells of snow."], event_id) if flag?(:frostfell_seen)
    say(["At the Celestial Rift a door of white light hangs open in the aurora.",
         "Through it: the Frostfell. Auril's plane, her reflection of the world. A plain of perfect ice under a black sky, and nothing moving, ever.",
         "Something is moving. Winged, white, coming through."], event_id)
    sayc(["An angel of ice, its wings like knives of frost-glass. Burned into its brow: a cracked mirror around an A.",
          cl(:alerion, "Avarice's mark. On something from Auril's own plane."),
          cl(:alberica, "(a hand on her chest, very quietly) They're working together. The goddess and the hag's girl.")].compact)
    return if !boss_battle(named_mon(:B227H124, 44, "Ice-Winged Angel"))
    set_flag(:frostfell_seen)
    set_switch(SW_FROSTFELL, false)
    add_counter(:story_beats)
    say(["The angel shatters. The door of light folds shut behind it with a sound like a frozen lake settling.",
         "In the snow on the platform: one feather of ice that doesn't melt."])
    give(:NEVERMELTICE)
  end

  def night_tree_dream
    sayc(["That night, everyone in the Hearth has the same dream.",
          "You're a seed in the dark, and the dark is warm, and you're not afraid of it.",
          "Something huge and patient is holding you. It's been holding you for four hundred years. It doesn't mind.",
          "You wake up with green on your fingertips, and every one of you is smiling."])
    ($Trainer.party || []).each { |pk| pk.heal rescue nil; pk.changeHappiness("vitamin") rescue nil }
    give(:LUMBERRY)
    say(["(Your Pokémon feel inspired. They've never been readier.)"])
    wheel(1)
    set_flag(:tree_dreamed)
  end

  #-----------------------------------------------------------------------------
  # Faction standing (the Political Favour Track): the four seasonal factions.
  #-----------------------------------------------------------------------------
  def favour(faction, n)
    state[:favour] ||= { spring: 0, winter: 0, autumn: 0, summer: 0 }
    state[:favour][faction] = (state[:favour][faction] || 0) + n
  end

  def favour_of(faction) = (state[:favour] || {})[faction] || 0

  def favour_board(event_id = nil)
    f = state[:favour] || {}
    word = ->(v) { v >= 4 ? "trusted" : v >= 2 ? "warm" : v <= -2 ? "cold" : v < 0 ? "wary" : "watching" }
    say(["THE COUNCIL'S STANDING-BOARD (chalked fresh each morning by a clerk who refuses to say who tells him):",
         "Spring, the Renewal Wardens: #{word.call(f[:spring] || 0)}.",
         "Winter, the Order of Balance: #{word.call(f[:winter] || 0)}.",
         "Autumn, the Court of Splendor: #{word.call(f[:autumn] || 0)}.",
         "Summer, the Absent Throne: #{flag?(:engine_dead) ? 'the chalk has been rubbed out' : 'nobody has ever written anything under Summer'}."], event_id)
  end

  #-----------------------------------------------------------------------------
  # First steps on a Rootspire map: atmosphere, faction vignettes, ambient
  # events and the down-the-root hooks. One vignette per map entry, and the
  # faction and ambient ones at most once per day.
  #-----------------------------------------------------------------------------
  TRUNK = [2180, 2181, 2182, 2183, 2184, 2185, 2186, 2187, 2050, 2052, 2053]
  CANOPY_MAPS = [2189, 2190, 2191, 2192, 2193, 2195, 2061, 2062, 2063]
  ROOT_MAPS = [2196, 2197, 2055, 2056]
  SHOP_MAPS = [2181, 2182, 2184, 2185, 2186, 2190, 2192, 2193, 2195, 2196, 2197, 2052]

  ATMOSPHERE = {
    2050 => ["The Trunk-Tier. Under your boots the living roots thrum, slow and steady, like a heartbeat under a floor.",
             "Birdsong from everywhere at once. On the snow side of the Bazaar, frost-glass sells by the pound;",
             "three stalls along, on the heat side, a wyrmling-idol carver is sweating through his shirt. Two weathers, one street."],
    2061 => ["The Canopy-Tier. The leaves hum, almost a chord. Mist drifts between the branches,",
             "and wherever the aurora catches it there's a small rainbow hanging in the air, going nowhere."],
    2055 => ["The Root-Tier. Lantern-light on black water. Out on the Glasswater the stars reflect back wrong:",
             "the constellations are all there, and all in the wrong places, as if the lake remembered a different sky."],
    2180 => ["The Verdant Halls, the civic ring. Bark carved with four seasons' crests, and the Council's four-leaf sigil:",
             "BALANCE IS SURVIVAL. Every clerk in Rootspire walks past it without looking."],
    2189 => ["The Lightfall Promenade. Light falls through frost-glass leaves in slow coloured sheets.",
             "Ateliers, shrines, sculptors. Autumn's quarter. Everyone here is very well dressed, and watching everyone else."]
  }

  FACTION_EVENTS = [
    [:spring_name, TRUNK, -> { true }, -> {
      sayc(["A clay pot on a sill above the walkway has bloomed overnight.",
            "The flowers spell a name in petals of pale green and white. Yours.",
            cl(:alberica, "Spring's sweet on you, darling. Or Spring's watching you. In this city it's the same flower.")].compact)
      favour(:spring, 1)
    }],
    [:winter_warning, CANOPY_MAPS, -> { true }, -> {
      sayc(["Frost feathers across the inside of a Canopy window as you pass, though the sun is blazing.",
            "The feathers form words, shaky but legible: DON'T TRUST THE WARMTH.",
            "Then they melt and run down the glass like tears."])
      favour(:winter, 1)
    }],
    [:summer_window, [2189, 2194], -> { true }, -> {
      sayc(["As you pass the shuttered Suncleft Emporium, one high window glows dull orange for the span of a single breath.",
            "Then it goes dark. Nobody's lived there in a year."])
      set_flag(:warm_window_seen)
    }],
    [:halo_flicker, [2056], -> { true }, -> {
      sayc(["A candle on the Still Sky Shrine's ledge gutters sideways, toward you,",
            "though you haven't crossed its path and there's no draught."])
    }],
    [:spring_sapling, [2180], -> { true }, -> {
      sayc(["Between the planks of the walkway, a tiny sapling has pushed up overnight.",
            "Nobody's stepped on it. Everyone's walking round it without noticing they are."])
      set_flag(:sapling_seen)
    }],
    [:winter_watcher, CANOPY_MAPS, -> { flag?(:met_ysera) || flag?(:met_kelyn) }, -> {
      sayc(["A Rootwarden stands on the bridge opposite, perfectly still, watching you.",
            "You blink. A wisp of cold fog hangs in the air where they stood. They're gone."])
    }],
    [:autumn_fox, [2189, 2061], -> { true }, -> {
      sayc(["A fox made of swirling leaves and light pads along beside you for a few steps.",
            "It glances up and whispers, in a voice like a fire in a grate: \"Choose warmth.\"",
            "Then it scatters into sparks."])
      set_flag(:fox_of_light)
    }],
    [:halo_shard, ROOT_MAPS, -> { flag?(:wardens_emeritus) }, -> {
      sayc(["Your hand brushes something sharp in your pocket. A shard of mirror you're certain wasn't there this morning.",
            "In it, your reflection blinks a moment out of sync."])
      give(:FT_STILLSHARD)
    }],
    [:halo_stillness, ROOT_MAPS, -> { flag?(:wardens_emeritus) }, -> {
      sayc(["Sound drops away for a heartbeat: no footsteps, no breath, no rustle.",
            "In the silence, your own voice, right behind you, whispers: \"Perfect stillness...\"",
            "You turn. There's nobody there."])
    }]
  ]

  # These two come in the morning, at the Hearth (the dossier puts them there).
  HEARTH_VIGNETTES = [
    # Autumn's "Leaf on the Pillow" (dossier 3023-3026): on your bed, where you sleep.
    [:autumn_pillow, -> { flag?(:met_lumea) || flag?(:met_maera) || rs_day >= 3 }, -> {
      sayc(["When you go up to your room at the Hearth, a small velvet box sits on your bed. The door was locked.",
            "Inside, a single gold-leaf charm rests on dark silk. No note. It smells faintly of Lirielle's perfume... and something warmer.",
            cl(:alberica, "(turning it over) Someone's courting us, darlings. Or measuring us for a cage. In Autumn it's the same tailor.")].compact)
      give_key(:FT_GOLDLEAF)
      favour(:autumn, 1)
    }],
    [:summer_scorch, -> { flag?(:warm_window_seen) || flag?(:met_gorran) }, -> {
      sayc(["In the morning, a faint singe mark on your sleeve where nothing should have touched it.",
            "It smells like the Sap-Smith's forge, and something older."])
    }],
    [:summer_footprint, -> { flag?(:summer_scorch) }, -> {
      sayc(["Outside your door at the Hearth: a single small footprint of glowing embers.",
            "It fades slowly while you watch, leaving only a scorch the shape of a child's foot."])
    }],
    [:ambient_note, -> { rs_day >= 3 }, -> {
      sayc(["A note has been slipped under your door in the night. Four words, in a fine hand:",
            "THE SUMMER THRONE KNOWS."])
    }],
    [:heat_rising, -> { rs_day >= 4 }, -> {
      sayc(["You wake in the dark, sweating. The floorboards are warm under your bare feet. Not summer-warm.",
            "The sap in the Hearth's walls is glowing, faintly, the colour of a coal."])
    }]
  ]

  def hearth_vignette
    row = HEARTH_VIGNETTES.find { |k, cond, _| !flag?(k) && cond.call }
    return false if !row
    set_flag(row[0])
    row[2].call
    true
  end

  AMBIENT = [
    [:amb_reflection, nil, ["In a shop window, your reflection turns to look at you a half-beat after you turn to look at it.", "It looks away last."]],
    [:amb_footsteps, nil, ["Soft footsteps behind you. They stop when you stop.", "They never gain. They never fade. When you turn, the walkway's empty."]],
    [:amb_root, nil, ["A root pulses under your boot. Warm, like a buried heart beating once."]],
    [:amb_mirror_avarice, :shop, ["In the shop's frost-glass mirror, a woman stands behind you, smiling faintly. White hair.", "You turn round. Nobody's there. The shopkeeper hasn't looked up."]],
    [:amb_frost_bloom, nil, ["Tiny ice-flowers bloom in your hair and on your lashes. Then they melt, and you're blinking cold water."]],
    [:amb_heat, nil, ["Your breath goes fire-hot for one second. Your eyes sting. Then it's just a summer's day again."]],
    [:amb_laughter, nil, ["Laughter from an empty alley. Soft, childlike, mocking.", "Just familiar enough to hurt."]],
    [:amb_groan, nil, ["The World Tree groans: a deep wooden creak, like a giant house settling.", "Nobody else so much as looks up."]],
    [:amb_stranger, nil, ["A passer-by calls you by name, warmly, like an old friend.", "When you answer, they stare at you. \"I'm sorry. I've never met you in my life.\""]],
    [:amb_candle, nil, ["A candle in a window snuffs out. No breeze. No movement. Just darkness where the light was."]],
    [:amb_breath, :late, ["Warm breath on your ear, out of nowhere, and a whisper:", "\"Soon.\""]]
  ]

  DOWN_THE_ROOT = [
    [:root_divination, [2191], -> { flag?(:met_ysera) }, ["Ysera Dorn kneels before her water-bowl, scrying. The water boils dry.",
                                                          "YSERA: (tightly) Third time today. Something below doesn't want to be seen."]],
    [:root_cask_spies, [2180], -> { flag?(:met_gurk) || flag?(:met_lumea) }, ["Two velvet-coated Wennen loiter across from the old Verdant Cask brewery, pretending to read the same leaflet.",
                                                                               "Autumn's spies. Watching the brewery doors."]],
    [:root_mirror_sigil, [2197, 2050], -> { flag?(:met_jast) || flag?(:met_mirror_child) }, ["In the Bazaar's mirrors, for a breath, every reflection has a sigil burned on its brow: a cracked mirror around an A."]],
    [:root_frostina, [2061], -> { flag?(:twins_met) }, ["Frostina is pacing the crown of the tree, not humming.",
                                                        "She keeps lowering her head to the bark of her nesting hollow and lifting it again, nostrils flared.",
                                                        "Something under it is burning. She can smell it through four hundred years of wood."]]
  ]

  def rootspire_step
    return if !active? || !$game_map || !$game_player
    map = $game_map.map_id
    return if !ROOTSPIRE_MAPS.include?(map) || !flag?(:met_hellen)
    return if $game_temp.in_battle rescue nil
    state[:atmos] ||= {}
    if ATMOSPHERE[map] && !state[:atmos][map]
      state[:atmos][map] = true
      return say(ATMOSPHERE[map])
    end
    return if omen_check
    row = DOWN_THE_ROOT.find { |k, maps, cond, _| !flag?(k) && maps.include?(map) && cond.call }
    if row
      set_flag(row[0])
      return say(row[3])
    end
    return if state[:rs_vignette_day] == rs_day || rs_day < 2
    row = FACTION_EVENTS.find { |k, maps, cond, _| !flag?(k) && maps.include?(map) && cond.call }
    if row
      state[:rs_vignette_day] = rs_day
      set_flag(row[0])
      return row[3].call
    end
    amb = AMBIENT.find do |k, where, _|
      next false if flag?(k)
      next false if where == :shop && !SHOP_MAPS.include?(map)
      next false if where == :late && !flag?(:ch7_started)
      true
    end
    return if !amb || (rs_day + map) % 2 == 1          # not every day; the city watches, it doesn't stare
    state[:rs_vignette_day] = rs_day
    set_flag(amb[0])
    add_counter(:ambient_seen)
    say(amb[2])
  end

  #-----------------------------------------------------------------------------
  # Spring's sapling, and the root-rot Bryn is hiding (with bryn in part B).
  #-----------------------------------------------------------------------------
  def whispering_sapling(event_id = nil)
    if flag?(:sapling_heard)
      return say(["The little sapling between the planks. Its leaves are curled brown at the edges now. It doesn't speak again."], event_id)
    end
    say(["A tiny sapling, pushing up between the planks of the walkway.",
         "When you touch its leaves, a faint voice shivers through your bones:",
         "\"Help...\""], event_id)
    set_flag(:sapling_heard)
    sayc(["Its roots, where they go down between the boards, are black. Not dark: black, and soft, and they smell of rot.",
          cl(:reptin, "(crouching, very serious) Root-rot. Spreading up from below. From the Heartroot.") || "Root-rot, spreading up from below.",
          "Somebody's dug round the rot recently, very neatly, and packed fresh moss over it to hide it.",
          "There's a Spring-green thread caught on the moss."].compact)
  end

  # The infernal ore spilled on the Split Dock (Meat Meat's walk, and Jorik).
  def ore_crates(event_id = nil)
    if flag?(:ore_found)
      return say(["Empty crates now. Someone's scrubbed the boards. The smell of trapped smoke is still there."], event_id)
    end
    say(["Crates stamped with the Guild's hammer, stacked by the Run's mouth. One's split.",
         "Black grit has spilled across the stone. It shimmers. It's warm. It smells like smoke shut up in rock."], event_id)
    sayc([herald?(:meat_meat) ? "(You know ore. This isn't ore. This is wrong.)" : cl(:meat_meat, "Meat Meat knows ore. This is not ore. This is wrong ore."),
          "Under the grit, a shipping tag: SAP-SMITH, TRUNK-TIER. ATTN G.A.",
          cl(:alerion, "G.A. Gorran Ashal-Forge. The Sap-Smith.")].compact)
    set_flag(:ore_found)
    set_flag(:dock_ore_seen)
  end
end

# Hooks: first step on a Rootspire map.
if Events.respond_to?(:onStepTaken) && Events.respond_to?(:onMapChange)
  Events.onMapChange += proc { |_sender, _e| FrostThaw.instance_variable_set(:@rs_step_pending, true) }
  Events.onStepTaken += proc { |_sender, _e|
    begin
      if FrostThaw.instance_variable_get(:@rs_step_pending)
        FrostThaw.instance_variable_set(:@rs_step_pending, false)
        FrostThaw.rootspire_step
      end
    rescue StandardError => err
      FrostThaw.log("Rootspire step failed: #{err.message}")
    end
  }
end
