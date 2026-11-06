#===============================================================================
# Frost & Thaw - Rootspire as a living city (part G): the city's switches,
# signs, and the hooks the older Rootspire scripts call.
#===============================================================================
module FrostThaw
  TEXT.merge!(
    timeline_wall: ["A long panel of living bark, carved with the city's years: FROM DOUGAN'S HOLE TO ROOTSPIRE.",
                    "YEAR 0 VR. The Heralds shatter the hag's mirrors. A sapling bursts from the thawed soil above Dougan's Hole.",
                    "YEAR 57 VR. The roots lace the valley. Druids, exiles and fisherfolk build walkways among them, and name the tree the Heart of Spring.",
                    "YEAR 113 VR. Two wyrmlings, Razzilith the Verdant and Frostina the Pale, circle the valley. Their breath quickens the tree.",
                    "YEAR 250 VR. The trunk hardens to crystal-oak. The canopy pierces the aurora. Dougan's Hole is gone beneath the roots. Rootspire is named.",
                    "YEAR 400 VR. The Heralds of Dawn and Dusk return.",
                    "Someone has scratched underneath, more recently: AND THE SUMMER NEVER ENDED."],
    prophecy_leaf: [{ if: { flag: :summer_ended }, lines: ["A crystal leaf that used to whisper. It's gone quiet now. The roots bled, and you were there."] },
                    ["A single frost-glass leaf in a case of its own, labelled DO NOT READ ALOUD.",
                     "It whispers anyway, to anyone who leans close:",
                     "\"The Frost Saint will climb the Spire when the roots bleed.\""]],
    dock_hatch_barred: ["A hatch in the dock planks, barred from below. Fish-oil and smoke seep up through the cracks.",
                        "Somebody's using whatever's under the Split Dock. Somebody with a key."],
    great_root: ["A root as wide as a house, rising out of the market toward the trunk. It's warm. It's always warm."]
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
    meat_meat: { verdant_halls: ["Meat Meat counted forty shops. Meat Meat has money for one."],
                 warden_hall: ["Big tree-guards. Meat Meat could take three. Maybe four."],
                 ledger_bank: ["Mushrooms with money. Meat Meat respects this."],
                 frozen_cellar: ["Cold table cold. Meat Meat does not like it here."],
                 promenade: ["Fancy people. Meat Meat is keeping her hands in her pockets. For now."],
                 suncleft: ["Smells like the bad forge. Little bit."],
                 mirror_dust: ["Meat Meat is not looking at the mirrors. Meat Meat is very busy not looking."],
                 smugglers_run: ["Tunnels! Meat Meat was raised in a tunnel. This one is nicer."],
                 frozen_run: ["Ice people. Meat Meat will not step on them. Out of respect."] },
    glimmer:  { verdant_halls: ["Lanterns in every window. A city that does that on purpose."],
                warden_hall: ["They salute the cat. I could get used to that."],
                promenade: ["Sun-thread for sale. I know what that's for now."],
                suncleft: ["The Shard's burning. Something here hates the light."],
                mirror_dust: ["I came back through a mirror once. I'm not doing it again."],
                frozen_cellar: ["The knife likes it down here. That's how I know it's wrong."] }
  }.each { |k, areas| (PARTY_CHAT[k] ||= {}).merge!(areas) if defined?(PARTY_CHAT) }

  module_function

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
      return say(["The petitioners' bench, in front of the four crystals. Rootspire's citizens wait here for the Council's ear.",
                  "A clerk's sign: PETITIONS HEARD BETWEEN SEASONS. (There haven't been seasons for thirty years.)"], event_id)
    end
    return council_petitions(event_id) if !flag?(:council_petitioned)
    return festival_of_balance(event_id) if !flag?(:festival_of_balance)
    say(["The petitioners' bench. Somebody has carved five small figures into the end of it, and a sixth, newer, smaller."], event_id)
  end

  def council_petitions(event_id = nil)
    have = PETITION_FINDINGS.select { |f, _| flag?(f) }
    say(["The Council sits for petitions, the first time since the summer began.",
         "KELYN: Heralds. You've been under the city and out to its edges. Tell the Council what you found. Persuade us."], event_id)
    if have.size < 2
      return say(["You haven't enough to lay before them yet. (Bring the Council proof: what you found under the city and in it.)"])
    end
    wins = 0; fails = 0
    seats = [["KELYN: (to the Hall) Spring will hear it.", :spring], ["SELRAE's empty seat is filled by her deputy, a frost-bearded old Warden.", :winter],
             ["DARRUS's seat has a new Autumn Warden in it, very nervous.", :autumn], ["The Rootwardens' captains, at the back, arms folded.", :spring]]
    seats.each do |intro, faction|
      break if wins >= 3 || fails >= 2
      say([intro])
      opts = have.map { |_, t| _INTL("Show {1}.", t) } + [_INTL("Appeal to them without proof.")]
      c = pbMessage(_INTL("What do you lay before them?"), opts, 0)
      if c < have.size
        wins += 1
        favour(faction, 1)
        say(["A murmur runs round the Hall. Heads nod, slowly. #{have[c][1].capitalize}: nobody can argue with that."])
        have.delete_at(c) if have.size > 1
      else
        fails += 1
        say(["Polite silence. Somebody coughs. You've lost them, a little."])
      end
    end
    set_flag(:council_petitioned)
    if wins >= 3
      set_flag(:council_support)
      wheel(1)
      add_counter(:story_beats)
      say(["KELYN: (standing) The Council of Seasons supports the Heralds. Whatever you need, for whatever comes next. North, if it's north.",
           "Every crystal in the Hall glows at once."])
    else
      say(["KELYN: (carefully) The Council... thanks the Heralds. And will consider. At length.",
           "(You can't win the Council over today. The support you have will have to do.)"])
    end
  end

  def festival_of_balance(event_id = nil)
    say(["KELYN: The city wants to thank you. A Festival of Balance, in the Hall of Seasons. The Heralds celebrated.",
         "KELYN: And if you'll accept it: Rootspire as your home. Whatever comes, there's a bed here, and a door that's never locked."], event_id)
    c = pbMessage(_INTL("Accept the city's thanks?"), [_INTL("\"We accept.\""), _INTL("\"Not yet. When it's finished.\"")], 0)
    set_flag(:festival_of_balance)
    if c == 0
      set_flag(:rootspire_haven)
      sayc(["That night the whole city comes. Rootwood pipes, frost-glass lanterns, and for once the dawn comes up green.",
            "Hellen cries. Tamsin pretends not to. Somebody carves your names into the Council's living pillar, under the four leaves.",
            cl(:alberica, "Home. Sweethearts, I haven't had one of those in four hundred years."),
            cl(:reptin, "We've had one. We just kept leaving it.")].compact)
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
          "TAMSIN: North stair. The Rootwarden Hall's up there. Seven shops. Everyone who's anyone.",
          cl(:alberica, "Darling, is anyone up there who knows where Summer went?"),
          "TAMSIN: Everyone up there THINKS they know. That's the fun of it. Come on!"].compact, event_id)
    Stage.escort(ev, 17, 9) rescue nil if ev
    say(["TAMSIN: And the Promenade's over the leaf-bridge, on the Canopy. That's Autumn's. Posh."], event_id)
    say(["TAMSIN: (to you, quieter) I'm showing them round. You can come. ...You can't be in charge."], event_id) if journey?
    side_goal(:city_tour, "The Verdant Halls: up the root-stair, north of the market. The Promenade: over the leaf-bridge.",
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
