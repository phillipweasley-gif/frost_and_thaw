#===============================================================================
# Frost & Thaw - Rootspire as a living city (part G): the city's switches,
# signs, and the hooks the older Rootspire scripts call.
#===============================================================================
module FrostThaw
  TEXT.merge!(
    timeline_wall: ["A long panel of living bark, carved with the city's years.", "FROM DOUGAN'S HOLE TO ROOTSPIRE.",
                    "YEAR 0 VR. The Heralds shatter the hag's mirrors.", "A sapling bursts from the thawed soil over Dougan's Hole.",
                    "YEAR 57 VR. The roots lace the valley. Druids, exiles and fishers build walkways.", "They name the tree the Heart of Spring.",
                    "YEAR 113 VR. Two wyrmlings circle the valley: Razzilith the Verdant, Frostina the Pale.", "Their breath quickens the tree.",
                    "YEAR 250 VR. The trunk hardens to crystal-oak. The canopy pierces the aurora.", "Dougan's Hole is gone beneath the roots. Rootspire is named.",
                    "YEAR 400 VR. The Heralds of Dawn and Dusk return.",
                    "Someone has scratched underneath, more recently: AND THE SUMMER NEVER ENDED."],
    prophecy_leaf: [{ if: { flag: :summer_ended }, lines: ["A crystal leaf that used to whisper. It's quiet now. The roots bled, and you were there."] },
                    ["A single frost-glass leaf in a case of its own, labelled DO NOT READ ALOUD.",
                     "It whispers anyway, to anyone who leans close:",
                     "\"The Frost Saint will climb the Spire when the roots bleed.\""]],
    dock_hatch_barred: ["A hatch in the dock planks, barred from below. Fish-oil and smoke seep up through it.",
                        "Somebody's using whatever's under the Split Dock. Somebody with a key."],
    great_root: ["A root as wide as a house, rising out of the market toward the trunk.", "It's warm. It's always warm."]
  )

  # What the party says in the city's new places (the party-chat menu).
  {
    alberica: { verdant_halls: ["Clerks, shops and a bank run by mushrooms. Civilisation, darling.", "I've missed paperwork. I've never said that before."],
                warden_hall: ["All these serious young people with spears. I want to adopt every one."],
                ledger_bank: ["The spores keep whispering a name. I'd rather they whispered mine."],
                frozen_cellar: ["Cold in the middle of summer. Somebody's praying very hard down here.", "To the wrong god, sweetheart."],
                promenade: ["Autumn's quarter. Everyone's beautiful and nobody's honest.", "I feel right at home."],
                suncleft: ["Warm as a hand on a fevered forehead.", "Whoever lived here left in a hurry, or didn't leave."],
                mirror_dust: ["Every mirror in here is looking at me. Normally I'd be flattered."],
                smugglers_run: ["Fish oil, smoke and somebody else's secrets.", "Lead on, sweetheart. Quietly."],
                frozen_run: ["Don't look down. There are people in the ice.", "...I looked down."] },
    reptin:   { verdant_halls: ["Four seasons carved over every door. Diplomatically, I approve."],
                warden_hall: ["My creed, on the wall, in letters taller than me.", "I'd have proofread it if I'd known."],
                ledger_bank: ["Breloom accountants. The future is strange and fungal."],
                frozen_cellar: ["The pulse goes quiet down here. Like a held breath."],
                promenade: ["Everyone here wants something. Politely. With canapés."],
                suncleft: ["Summer's house. Nobody home. The fire's still lit."],
                mirror_dust: ["The wolf in me wants to break every mirror in this shop. I'm overruling it."],
                smugglers_run: ["Rootwarden knots on the walls. Old ones. My knots, nearly."],
                frozen_run: ["The lake remembers every one of them. So will I."] },
    alerion:  { verdant_halls: ["Too many people. Too many windows."],
                warden_hall: ["They train well. They watch the door well. Good."],
                ledger_bank: ["Something in the spores is counting us."],
                frozen_cellar: ["Halo. Close. Quiet now."],
                promenade: ["Every one of them is watching every other one."],
                suncleft: ["Too warm. Something under the floor."],
                mirror_dust: ["Don't look in the tall one."],
                smugglers_run: ["Low light. Good. Stay behind me."],
                frozen_run: ["The ice is old. Walk where I walk."] },
    meat_meat: { verdant_halls: ["Meat Meat counted forty shops. Not one sells coffee.", "Meat Meat asked twice."],
                 warden_hall: ["Big tree-guards. Meat Meat could take three. Maybe four."],
                 ledger_bank: ["Mushrooms with money. Meat Meat respects this."],
                 frozen_cellar: ["Cold table cold. Meat Meat does not like it here."],
                 promenade: ["Fancy people. Meat Meat is keeping her hands in her pockets. For now."],
                 suncleft: ["Smells like the bad forge. Little bit."],
                 mirror_dust: ["Meat Meat is not looking at the mirrors. Meat Meat is very busy not looking."],
                 smugglers_run: ["Tunnels! Meat Meat likes tunnels. Nobody tall can follow fast."],
                 frozen_run: ["Ice people. Meat Meat will not step on them. Out of respect."] },
    # (dialogue/15 §1: Wyn had no party chat in any new district)
    wyn:      { verdant_halls: ["A bank run by Breloom. The spores in there knew my name. I didn't tell them."],
                warden_hall: ["The wardens nod at me now. I keep nodding back too long."],
                ledger_bank: ["The Accountancy hums when I come in. Like a hive saying hello."],
                frozen_cellar: ["The mould down here's dying. Too cold to be anything."],
                promenade: ["Everything up here is pretty. Nothing up here is growing."],
                suncleft: ["I don't want to stand still in here. The floor might notice."],
                mirror_dust: ["My reflection waved back. Later than I did."],
                smugglers_run: ["Little mushrooms on the beams. They're keeping the damp company."],
                frozen_run: ["Nothing grows in that ice. Nothing at all. That's the part I hate."] },
    glimmer:  { verdant_halls: ["Lanterns in every window. A city that does that on purpose."],
                warden_hall: ["They salute the cat. I could get used to that."],
                promenade: ["Sun-thread for sale. I know what that's for now."],
                suncleft: ["The Shard's burning. Something here hates the light."],
                mirror_dust: ["I came back through a mirror once. I'm not doing it again."],
                frozen_cellar: ["The knife likes it down here. That's how I know it's wrong."] }
  }.each { |k, areas| (PARTY_CHAT[k] ||= {}).merge!(areas) if defined?(PARTY_CHAT) }

  # The party remembers what you finished (notes/15 E5: one line per ending),
  # in the place it happened. A line here comes before the place's usual one.
  def self.party_react(who, area, flag, lines)
    return if !defined?(PARTY_CHAT)
    tab = (PARTY_CHAT[who] ||= {})
    cur = tab[area]
    variant = { if: { flag: flag }, lines: lines }
    tab[area] = if cur.nil? then [variant, ["..."]]
                elsif cur.all? { |e| e.is_a?(String) } then [variant, cur]
                else [variant] + cur
                end
  end

  [[:reptin, :fields, :staff_attuned, ["The staff hums with me now. Out here, where the year goes round."]],
   [:reptin, :fields, :yeti_child_home, ["That yeti's out there with her cub.", "I like to think she watches the road for us."]],
   [:glimmer, :canopy, :glimmer_hope, ["I told the envoy hope. The Shard's been warm since. Like a hearth."]],
   [:glimmer, :canopy, :glimmer_judgment, ["I told the envoy judgment. The Shard runs hot now.", "I'm trying to be worth it."]],
   [:alberica, :library, :naerth_ledger_published, ["Naerth's ledger, on the open shelves. People queue to cry at it.", "Good."]],
   [:alberica, :library, :naerth_ledger_sealed, ["Eirwen's sealed ledger. Some doors you shut so you can open them later."]],
   [:alberica, :library, :naerth_ledger_council, ["Kelyn has the ledger. I hope the Council reads faster than it votes."]],
   [:alerion, :root_tier, :frozen_run_done, ["The ice is quiet now. The crews are sleeping."]],
   [:meat_meat, :council, :heist_exposed, ["Meat Meat sat in fancy man's empty chair. It is not comfortable. Good."]],
   [:meat_meat, :council, :heist_destroyed, ["Girl of light went up through that roof. Meat Meat waves at the roof sometimes."]],
   [:reptin, :council, :council_support, ["The whole Council stood up for us.", "I've never been stood up for by a committee. It's alarming."]],
   [:alberica, :hearth, :rootspire_haven, ["Home, sweetheart. It still sounds strange. I'm getting used to it."]],
   [:alerion, :canopy, :kelyn_secret, ["Kelyn doesn't touch the orb for herself now. She looks at it. That's all."]],
   [:wyn, :rootspire, :ash_exposed, ["Ash taught me to tie a ward-knot. I keep tying them.", "I don't know who for any more."]],
   [:glimmer, :suncleft, :helion_known, ["Helion waited thirty years for that engine. The Shard hates him."]],
   [:alberica, :college, :chronal_anchored, ["I can hear the tree in my pulse, darling. It hums flat. I'm learning harmony."]],
   [:alberica, :college, :wynsnow_confessed, ["The Professor meant to sew us into his tapestry. Sweet man. Dangerous needle."]],
   [:reptin, :warden_hall, :oath_of_roots, ["I took my own oath, from Rheven. My hands still feel it."]],
   [:meat_meat, :hearth, :blade_seed, ["The blade said Meat Meat is a seed. Seeds do not stay in jars."]],
   [:meat_meat, :promenade, :sliver_freed, ["Ice lady's statue is just a statue now. Meat Meat licked it to check. Cold."]]
  ].each { |who, area, f, lines| party_react(who, area, f, lines) }

  #-----------------------------------------------------------------------------
  # Givers who come to you (notes/15 E1): when someone's second beat is ready,
  # they notice you ("!") and come over, the way Act I's givers do (045_TenTowns
  # GIVERS, givers_step). Their own scripts call giver_hello.
  #-----------------------------------------------------------------------------
  if defined?(GIVERS)
    GIVERS.merge!(
      2189 => [["Serelle of the Still Veil", 3, -> { flag?(:met_serelle) && !flag?(:serelle_vision) }],
               ["Mira Thynelight", 4, -> { thynelight_ready? }]],
      2055 => [["Shivven Pearlbite", 3, -> { flag?(:met_shivven) && !flag?(:shivven_told) }],
               ["Viessa Arialune", 3, -> { flag?(:met_viessa) && !flag?(:viessa_map) }],
               ["Captain Ivran Solmar", 4, -> { ivran_ready? && !(respond_to?(:hellen_note_due?) && hellen_note_due?) &&
                                        state[:hellen_note_day] != rs_day }]],
      2050 => [["Krolf the Mossback", 3, -> { flag?(:met_krolf) && !flag?(:krolf_boy) }],
               ["Mistress Felka", 3, -> { felka_ready? && !flag?(:felka_offered) }],
               ["Guild assessor", 3, -> { !flag?(:amber_asked) && !flag?(:amber_tested) }]],
      2062 => [["Pimmlet Natch", 3, -> { pimmlet_ready? }],
               ["Professor Halden Vex", 4, -> { halden_ready? }]],
      2180 => [["Gurk Thistlebane", 3, -> { flag?(:met_gurk) && !flag?(:cellar_hint) && flag?(:rite_stopped) }]]
    )
  end

  # The Wheel, the first time it turns in Rootspire (notes/15 F10): what it is,
  # once, in plain words.
  class << self
    alias_method :wheel_before_note, :wheel if method_defined?(:wheel) && !method_defined?(:wheel_before_note)
  end

  def self.wheel(amount = 1)
    wheel_before_note(amount)
    if amount > 0 && flag?(:act1_done) && !flag?(:wheel_explained)
      set_flag(:wheel_explained)
      say(["(Somewhere in the year, something turns a notch. The Wheel: kindness moves the seasons.)"])
    end
  end

  module_function

  #-----------------------------------------------------------------------------
  # Walk-ons (WRITING_GUIDE §9a: whoever speaks is on screen). A side scene's
  # passer-by who has no event of their own steps up beside you to say their
  # piece, and goes again after. Heralds summon themselves (say does that).
  #-----------------------------------------------------------------------------
  WALK_ON_LOOKS = {
    "APPRENTICE" => "BWSchoolKid_male", "RHEVEN" => "FT_captain_rheven_stormbranch", "KELYN" => "FT_high_speaker_kelyn_of_spring",
    "SELRAE" => "FT_winter_matron_selrae_vorn", "LUMEA" => "BW (64)", "RENEWAL WARDEN" => "BW (62)", "CLERK" => "BWClerk_male2",
    "COURIER" => "BWRichboy", "HALDIS" => "BW (62)", "SPRING WARDEN" => "BW (62)", "BALANCE WARDEN" => "BW (62)",
    "AUTUMN COURIER" => "BWRichboy", "AUTUMN COURTIER" => "BWSocialite", "OLD LOYALIST" => "BW_oldman-drunk",
    "PILGRIM" => "FT_sephek", "CORSAIR RUNNER" => "BW_Sailor", "INITIATE" => "BW (22)", "DOCKWORKER" => "BW (19)",
    "RAZZILITH" => "FT_razzilith", "KETHAN" => "BW (71)", "HELLEN" => "FT_hellen", "EIRWEN" => "FT_eirwen_solglass",
    "MIRA" => "FT_mira_of_the_north_wind", "LUMIN" => "FT_wennen_lumin", "ANDUIN" => "FT_anduin", "PHILDENDRIN" => "FT_phildendrin",
    "EIRA" => "FT_myconid_eira", "SPORELING" => "Followers/SHROOMISH", "WARDEN LIS" => "BW (62)",
    "LANTERN-CARVER" => "FT_halo_disciple_male", "DRUM-KEEPER" => "FT_halo_disciple_female", "MASKED DEVOTEE" => "FT_halo_disciple_female"
  }

  def walk_on(tag, graphic = nil)
    return nil if !$game_map
    if (sp = Stage.speaker(tag))
      # already in the scene: off camera, they come over (and stay where they stop)
      Stage.walk_to(sp, $game_player.x, $game_player.y, adjacent: true) if !Stage.on_screen?(sp)
      return nil
    end
    slot = Stage.near_slot or return nil
    key = tag.downcase.gsub(/[^a-z\-]+/, "_")
    look = graphic || WALK_ON_LOOKS[tag] || walk_on_look(key, tag)
    a = Stage.actor(key.to_sym, slot[0], slot[1], 2, graphic: look)
    Stage.turn_to(a) if a
    a
  rescue StandardError => e
    log("walk_on #{tag}: #{e.message}")
    nil
  end

  # A look for someone not in the table: their own sheet if there is one, else a plain townsperson.
  def walk_on_look(key, tag)
    own = "FT_#{key.tr('-', '_')}"
    return own if (pbResolveBitmap("Graphics/Characters/#{own}") rescue nil)
    return "BW (62)" if tag =~ /WARDEN|GUARD/
    return "BW_Sailor" if tag =~ /CORSAIR|MATE|SAILOR/
    "BW (22)"
  end

  # Everyone named in these lines who isn't here and isn't a Herald steps up.
  def walk_on_for(lines)
    mates = defined?(COMPANION_NAMES) ? COMPANION_NAMES.values : []
    me = ($Trainer.name.to_s.upcase rescue "")
    tags = Array(lines).flatten.compact.map { |l| l[/\A([A-Z][A-Z'\- ]*[A-Z]):/, 1] }.compact.uniq
    tags.reject { |t| mates.include?(t) || t == me }.map { |t| walk_on(t) }.compact
  end

  def walk_off(actors)
    actors = Array(actors).compact
    return if actors.empty?
    Stage.leave_all(actors, $game_player.x, $game_player.y + 7)
  rescue StandardError
    actors.each { |a| Stage.remove_actor(a) rescue nil }
  end

  # say, with the walk-ons staged round it.
  def say_staged(lines, event_id = nil)
    actors = walk_on_for(lines)
    say(lines, event_id)
    walk_off(actors)
  end

  #-----------------------------------------------------------------------------
  # Downtime after the Heartroot: Council Petitions (present what you found and
  # win the Council's support) and the Festival of Balance (accept, and
  # Rootspire is your safe haven).
  #-----------------------------------------------------------------------------
  PETITION_FINDINGS = [
    [:chardalyn_found, "the chardalyn fragment from the Echo Gate, still warm"],
    [:ledger_found, "the Ledger of Corruption: Project Rime"],
    [:heist_exposed, "the Guild's reliquary, and what Darrus did for it"],
    [:ash_exposed, "Ash's confession: the patrols, and the Rite of the Long Gold"],
    [:selrae_white_womb, "the Winter Matron's black-ice dagger, and the White Womb"],
    [:souls_ledger_seen, "Eira Voss's ledger: twelve souls delivered to the forge"],
    [:forge_glimpsed, "what the mirror showed: the forge under the roots"]
  ]

  def petition_bench(event_id = nil)
    if !flag?(:engine_dead)
      return say(["The petitioners' bench, before the four crystals. People wait here for the Council's ear.",
                  "A clerk's sign: PETITIONS HEARD BETWEEN SEASONS. (No seasons, these thirty years.)"], event_id)
    end
    return council_petitions(event_id) if !flag?(:council_petitioned)
    return festival_of_balance(event_id) if !flag?(:festival_of_balance)
    say(["The petitioners' bench. Five small figures carved into one end.", "And a sixth, newer, smaller."], event_id)
  end

  # Each seat wants a particular proof (notes/15 E7): what it cares about wins
  # it; anything else wins it only if that season already trusts you a little;
  # an appeal without proof only if it trusts you more.
  SEAT_WANTS = { spring: %i[chardalyn_found ash_exposed], winter: %i[selrae_white_womb souls_ledger_seen],
                 autumn: %i[heist_exposed ledger_found], wardens: %i[ash_exposed forge_glimpsed chardalyn_found] }

  def council_petitions(event_id = nil)
    have = PETITION_FINDINGS.select { |f, _| flag?(f) }
    say(["The Council sits for petitions, the first time since the summer began.",
         "KELYN: Heralds. You've been under the city and out to its edges.",
         "KELYN: The Council will hear what you found. Not what you think. What you found."], event_id)
    if have.size < 2
      return say(["You haven't enough to lay before them yet.",
                  "(Bring the Council proof: what you found under the city, and in it.)"])
    end
    wins = 0; fails = 0
    winter = flag?(:selrae_rescued) ? "SELRAE: (from Winter's seat) Winter will hear it. Briefly." :
                                      "Selrae's seat holds her deputy now, a frost-bearded old Warden."
    seats = [["KELYN: (to the Hall) Spring will hear it.", :spring, :spring],
             [winter, :winter, :winter],
             ["Autumn's seat has a new Warden in it, very nervous.", :autumn, :autumn],
             ["The Rootwardens' captains, at the back, arms folded.", :spring, :wardens]]
    seats.each do |intro, faction, wants|
      break if wins >= 3 || fails >= 2
      say([intro])
      opts = have.map { |_, t| _INTL("Show {1}.", t) } + [_INTL("Appeal to them without proof.")]
      c = pbMessage(_INTL("What do you lay before them?"), opts, -1)
      c = opts.size - 1 if !c || c < 0
      ok = if c < have.size
             SEAT_WANTS[wants].include?(have[c][0]) || favour_of(faction) >= 1
           else
             favour_of(faction) >= 2
           end
      if ok
        wins += 1
        favour(faction, 1, quiet: true)
        say([c < have.size ? "A murmur runs round the Hall. Heads nod, slowly. #{have[c][1].capitalize}." :
                             "They hear you out, and believe you. They've watched you all season."])
      else
        fails += 1
        say([c < have.size ? "They listen, politely. It isn't what this seat wanted to hear." :
                             "Polite silence. Somebody coughs. You've lost them, a little."])
      end
      have.delete_at(c) if c < have.size && have.size > 1
    end
    set_flag(:council_petitioned)
    if wins >= 3
      set_flag(:council_support)
      wheel(1)
      add_counter(:story_beats)
      say(["KELYN: (standing) The Council of Seasons supports the Heralds. Whatever you need.",
           "KELYN: For whatever comes next. North, if it's north.",
           "Every crystal in the Hall glows at once."])
    else
      say(["KELYN: (carefully) The Council... thanks the Heralds. And will consider. At length.",
           "(You can't win the Council over today. The support you have will have to do.)"])
    end
  end

  def festival_of_balance(event_id = nil)
    say(["KELYN: The city wants to thank you. A Festival of Balance, in the Hall of Seasons.",
         "KELYN: And if you'll take it, Rootspire as your home. A bed. A door that's never locked."], event_id)
    # (story/15 §3, 15.33: the Council remembers the orb)
    say(["KELYN: (quieter, to you) You stopped me at the orb. I haven't forgotten. I won't."], event_id) if flag?(:kelyn_warned)
    c = pbMessage(_INTL("Accept the city's thanks?"), [_INTL("\"We accept.\""), _INTL("\"Not yet. When it's finished.\"")], 0)
    set_flag(:festival_of_balance)
    if c == 0
      set_flag(:rootspire_haven)
      # (notes/15 E11: the night comes, and the city with it)
      pbFadeOutIn { $game_screen.start_tone_change(Tone.new(-60, -50, -10, 30), 0) rescue nil }
      px, py = $game_player.x, $game_player.y
      Stage.actor(:hellen, px - 1, py + 2, 8, graphic: "FT_hellen")
      Stage.actor(:tamsin, px + 1, py + 2, 8, graphic: "FT_tamsin")
      Stage.actor(:rheven, px + 2, py + 1, 4, graphic: "FT_captain_rheven_stormbranch")
      sayc(["That night the whole city comes. Rootwood pipes, frost-glass lanterns, and dancing.",
            "Hellen cries. Tamsin pretends not to. Rheven dances, very badly, with a Wennen.",
            "Somebody carves your names into the Council's living pillar, under the four leaves.",
            cl(:alberica, "Home. Sweethearts, I haven't had one of those in four hundred years."),
            cl(:reptin, "We've had one. We just kept leaving it.")].compact)
      pbFadeOutIn { $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil }
      say(["For once the dawn comes up green."])
      wheel(1)
    else
      say(["KELYN: Then the door's open when it's finished. It'll stay open."])
    end
  end

  #-----------------------------------------------------------------------------
  # Tamsin shows the strangers round (context 15, M15-2): during the downtime
  # week, the first talk after you've battled her. In Rootspire the Heralds are
  # the outsiders, and Tamsin, who wants to be a Rootwarden, is the expert.
  #-----------------------------------------------------------------------------
  def tamsin_tour_due?
    flag?(:beat_tamsin) && !flag?(:tamsin_tour) && (respond_to?(:festival_business_done?) && festival_business_done?) &&
      !flag?(:festival_night) && $game_map && $game_map.map_id == 2050
  end

  def tamsin_tour(event_id = nil)
    set_flag(:tamsin_tour)
    ev = event_id && $game_map ? $game_map.events[event_id] : nil
    sayc(["TAMSIN: (to the Heralds, bouncing) Never seen the Verdant Halls? Have you? HAVE you?",
          "TAMSIN: North stair. The Rootwarden Hall's up there. Seven shops. Everyone who matters.",
          cl(:alberica, "Darling, is anyone up there who knows where Summer went?"),
          "TAMSIN: Everyone up there THINKS they know. That's the fun of it. Come on!"].compact, event_id)
    Stage.escort(ev, 17, 9) rescue nil if ev
    say(["TAMSIN: And the Promenade's over the leaf-bridge, on the Canopy. That's Autumn's. Posh."], event_id)
    say(["TAMSIN: (to you, quieter) I'm showing them round. You can come. ...You can't be in charge."], event_id) if journey?
    side_goal(:city_tour, "The Verdant Halls: up the market's north stair. The Promenade: the leaf-bridge.",
              done: [:festival_night, :visited_halls])
  end

  class << self
    alias_method :tamsin_before_tour, :tamsin if method_defined?(:tamsin) && !method_defined?(:tamsin_before_tour)
    alias_method :party_chat_before_friends, :party_chat if method_defined?(:party_chat) && !method_defined?(:party_chat_before_friends)
  end

  def self.tamsin(event_id = nil)
    return tamsin_tour(event_id) if tamsin_tour_due?
    tamsin_before_tour(event_id)
  end

  # The city keeps count (context 15, M15-4 C): from the week in Rootspire the
  # Heralds menu lists who'd speak for you. At the trial it becomes the
  # witness list (036 show_witnesses).
  def self.party_chat
    if flag?(:met_hellen) && !flag?(:trials_open) && respond_to?(:witnesses) && !companions.empty?
      list = witnesses
      if !list.empty?
        pbMessage(_INTL("Friends in Rootspire ({1}): who'd speak for you, and what they'd say.", list.size))
        list.first(6).each { |_, who, what, _| pbMessage(_INTL("{1}: \"{2}\"", who, respond_to?(:witness_line) ? witness_line(what) : what)) }
      end
    end
    party_chat_before_friends
  end

  def tree_communion_or_talk(event_id = nil)
    return if respond_to?(:tree_communion) && tree_communion(event_id)
    talk(:great_root, event_id)
  end

  # The switches the city's events show and hide on, kept true to the story.
  def apply_rootspire_life_switches
    return if !active? || !$game_switches
    set_flag(:visited_halls) if ($game_map.map_id rescue 0) == 2180 && !flag?(:visited_halls)   # (Tamsin's tour goal)
    s = lambda { |id, on| $game_switches[id] = on ? true : false }
    s.call(SW_ORB_HALO, flag?(:twins_met) && !flag?(:halo_orb_cleared))
    s.call(SW_KELYN_ORB, flag?(:orb_visions) && !flag?(:kelyn_secret) && rs_day >= 3)
    s.call(SW_EREN_TROUBLED, flag?(:twins_met) && !flag?(:eren_settled))
    s.call(SW_SPIRITS, (flag?(:rheven_counselled) || flag?(:ch7_started)) && !flag?(:fields_pulse))
    s.call(SW_STILL_BEAST, flag?(:still_beast_asked) && !flag?(:still_beast_done))
    s.call(SW_LANTERN, ($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue false))
    s.call(SW_ASH_EXPOSED, flag?(:ash_exposed))
    s.call(SW_DARRUS_HIDING, flag?(:heist_exposed))
    s.call(SW_SCORCH, flag?(:rootwardens_at_door) && !flag?(:chardalyn_found))
    s.call(SW_FROSTFELL, flag?(:auroral_storm_seen) && !flag?(:frostfell_seen))
    s.call(SW_TALWYN_FIELDS, (state[:talwyn] || 0) >= 1)
    s.call(SW_HALDEN, flag?(:met_halden) && flag?(:ch7_started) && !flag?(:halden_done))
    s.call(SW_FROZEN_RUN, false) if flag?(:frozen_run_done)
    $game_switches[SW_RUN_OPEN] = true if flag?(:heist_offered) || flag?(:jorik_confessed) || flag?(:viessa_map)
    $game_switches[SW_CELLAR_FOUND] = true if flag?(:cellar_hint) || (flag?(:viessa_map) && flag?(:rite_stopped))
    $game_switches[SW_SUNCLEFT_OPEN] = true if flag?(:suncleft_open)
    # (notes/15 E10: Darrus ran; he isn't at his seat when you come back)
    if flag?(:heist_exposed) && ($game_map.map_id rescue 0) == 2054
      d = $game_map.events.values.find { |e| e.name == "Darrus Fell" }
      (d.transparent = true; d.through = true) if d
    end
    $game_map.need_refresh = true if $game_map
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_rootspire_life_switches
  rescue StandardError => err
    FrostThaw.log("Rootspire life switches failed: #{err.message}")
  end
}

#-------------------------------------------------------------------------------
# The Verdant Prototype's Blade's curse: each time it scores a killing blow, the
# mirror in its guard flickers with another face, one of Avarice's unfinished
# prototypes.
#-------------------------------------------------------------------------------
if defined?(BattleHandlers::UserItemAfterMoveUse)
  BattleHandlers::UserItemAfterMoveUse.add(:FT_VERDANTBLADE,
    proc { |_item, user, targets, _move, _numHits, battle|
      next if !targets.any? { |b| b.fainted? && b.opposes?(user) }
      faces = ["a goblin child with no eyes", "a small green thing with a dragon's jaw", "a girl made of mirror, half finished",
               "a face that's almost Meat Meat's", "something that was meant to have wings"]
      n = (FrostThaw.state[:blade_faces] = (FrostThaw.state[:blade_faces] || 0) + 1)
      battle.pbDisplay(_INTL("In the mirror of the Verdant Blade, another face flickers: {1}.", faces[(n - 1) % faces.size]))
    }
  )
end

# A map where someone has spoken since you arrived holds back its step-triggered
# omen or vignette for the next map (048_E's step hook; box rules, notes/09 E15).
module FrostThaw
  class << self
    unless method_defined?(:ft_h_scene_say)
      alias ft_h_scene_say say
      def say(lines, event_id = nil)
        @rs_scene_here = true
        ft_h_scene_say(lines, event_id)
      end
    end
  end
end
