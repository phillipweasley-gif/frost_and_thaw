#===============================================================================
# Frost & Thaw - Act II, Chapter 6: the Festival of Returning Light (SC 6.01-6.09)
#
# Rootspire, year 400 of the Verdant Reversal. The Heralds fall out of a cracked
# lantern into the market an hour after the Prologue (Journey) and spend the
# festival week finding out where and when they are:
#
#   6.01 Out of the lantern        6.02 You're in my wall (Hellen, the Hearth)
#   6.03 They waited (the twins land in the market)
#   6.04 The empty throne (the Council; the Wardens' oath)
#   6.05 The College (Grafting)    6.06 Gym 4: Hellen (026_Rootspire.rb)
#   6.07 The Rite of Stillness (Sephek in the ice; Summer has his heart)
#   6.08 The spark that wasn't out (Glimmer; 029_Glimmer.rb)
#   6.09 Festival night: rest at the Hearth once the rite is stopped, Glimmer
#        is with you and you hold Hellen's seal. Both roads down open.
#
# The Auroral Wall (the old Echo Gate, west of the market) holds until the
# summer ends in Chapter 9; outside it the snow hangs in the air.
#===============================================================================
module FrostThaw
  SW_HEARTH  = 3934
  SW_WARDENS = 3935
  SW_RITE_STOPPED = 3936
  SW_FESTIVAL = 3966      # you've sat down for the festival's last night: the market plays it

  MAPS.merge!(rootspire: 2050, rs_center: 2051, sap_shop: 2052, hearth: 2053, council: 2054, root_tier: 2055, shrine: 2056)
  MAP_NAMES.merge!(
    2050 => "Rootspire", 2051 => "Rootspire Pokémon Center", 2052 => "Goldlash Sap-Works",
    2053 => "The Rooted Hearth", 2054 => "Council Hall of Seasons", 2055 => "Rootspire Root-Tier",
    2056 => "The Still Sky Shrine"
  )
  MAP_METADATA.merge!(
    2050 => { outdoor_map: true, announce_location: true, battle_environment: :Forest },
    2051 => {}, 2052 => {}, 2053 => {},
    2054 => { announce_location: true },
    2055 => { announce_location: true, battle_environment: :Cave },
    2056 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2050 => :rootspire, 2051 => :rootspire, 2052 => :rootspire, 2053 => :hearth, 2054 => :council,
               2055 => :root_tier, 2056 => :shrine)
  ARRIVAL_POINT = [2050, 28, 29, 2]   # out of the cracked lantern, by the lantern stall
  HEART_RETURN  = [2046, 12, 45, 8]
  DALE_GATE     = [2030, 1, 13, 6]        # out through the thinned Wall: the Eastway, weeks after you left
  HEARTH_REST   = [2053, 5, 9, 8]

  MARTS[:rootspire] = [:POKEBALL, :GREATBALL, :ULTRABALL, :SUPERPOTION, :HYPERPOTION, :FULLHEAL, :REVIVE,
                       :SUPERREPEL, :ESCAPEROPE]

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_ROOTWARDEN: ["Rootwarden", :POKEMONRANGER_M, 0, 60],
    FT_HALO:       ["Fractured Halo", :CHANNELER, 1, 60],
    FT_HALO_MATRON: ["Matron of the Halo", :CHANNELER, 1, 160, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    warden_ash:   [:FT_ROOTWARDEN, "Ash",   [[:SUDOWOODO, 35], [:B114H220, 36]],
                   "The tree hums for you. I felt it. I just had to be sure."],
    warden_lis:   [:FT_ROOTWARDEN, "Lis",   [[:JUMPLUFF, 35], [:B87H182, 36]],
                   "Spring and frost in one breath. That's what the old songs say about you."],
    warden_tobin: [:FT_ROOTWARDEN, "Tobin", [[:EXEGGUTOR, 36], [:PILOSWINE, 36], [:B103H189, 37]],
                   "Four hundred years and you still hit like a blizzard. Welcome home, Heralds."],
    halo_vigil:   [:FT_HALO, "Brother Iskar", [[:SNEASEL, 37], [:B215H200, 38]],
                   "The thaw is a fever. Someone has to sit with the patient while it breaks."],
    halo_ascetic: [:FT_HALO, "Sister Wenna",  [[:B124H227, 37], [:DEWGONG, 38]],
                   "I was a Rootwarden once. I listened to the tree. It's so tired."],
    eline:        [:FT_HALO_MATRON, "Eline", [[:JYNX, 38], [:B91H225, 39], [:B221H124, 40]],
                   "Still... the sky was still... for one moment, it was still...", [:HYPERPOTION, :FULLHEAL]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    sign_rootspire: ["ROOTSPIRE, City of the Verdant Dawn.", "Trunk-Tier: the Market Ring. Mind the sap channels."],
    root_gate_sealed: ["A well of living root drops into the dark. Warm air rises out of it: sap, and old ice.",
                       "A Rootwarden's willow seal is tied across the mouth.",
                       "THE ROOT-GATE IS CLOSED. BY ORDER OF THE VERDANT COUNCIL."],
    kurt_door: [{ if: { flag: :wardens_emeritus }, lines: ["WOODCARVER: Wardens! The Rootwardens' stair to the Root-Tier is through my workshop.",
                                                           "WOODCARVER: Mind the third step. It bites."] },
                ["WOODCARVER: Festival masks. Dragons, mostly: Razzilith the Verdant and Frostina the Pale.",
                 "WOODCARVER: Every year somebody orders a Herald mask. Every year I carve you wrong.",
                 "WOODCARVER: ...You'd know, I suppose."]],
    root_stair_closed: ["The woodcarver's workshop. A trapdoor in the floor leads down into the roots.",
                        "A Rootwarden's seal is tied across it.",
                        "WOODCARVER: The Wardens' stair to the Root-Tier. Council business only, I'm afraid."],
    split_dock_fisher: ["FISHER: Water's warm as breath down here. Always has been.",
                        "FISHER: Then last month it froze round two Corsair boats in a single night.",
                        "FISHER: Crews still at the oars. Glass all through.",
                        "FISHER: Somebody's been praying for cold. And somebody's been answered."],
    corsair_sailor: ["CORSAIR: Auroral Corsairs. We run the outer lakes when nobody else will.",
                     "CORSAIR: Those were our people out there. Whoever froze them did it from the shore.",
                     "CORSAIR: The ice came off the land."],
    halo_vigil_after: ["The Matron is at the Still Sky Shrine. Tonight she makes the sky hold still.",
                       "You'll see. Everyone will see."],
    halo_ascetic_after: ["Go on, then. Go and stop her. I hope you can. I hope you can't.", "I don't know anymore."],
    auril_statue: ["A cracked statue of Auril stares up through the hole in the roof.",
                   "Centuries of prayer have worn her face smooth.",
                   "But the eyes have been freshly cut. Sharp. Knowing."],
    sephek_altar: -> {
      flag?(:rite_stopped) ? ["Sephek, in his old blue ice. The candles have gone out.",
                              "The hollow in his chest is clean-edged, like a cut. Cold comes off it."] :
                             ["A man frozen in old blue ice. No coat. Bare feet.",
                              "In his chest, where something used to beat, there's only a hollow."]
    },
    halo_disciple: ["DISCIPLE: Hush. The Matron is listening for the sky."],
    frost_saint_runes: [{ if: { flag: :rite_stopped }, lines: ["New runes, cut over the old prayers: THE FROST SAINT WALKS AGAIN.",
                                                               "Underneath, smaller, in a different hand: \"The lake remembers.\""] },
                        ["Fresh runes in the old blue marble, frost still in the grooves.", "You can't make them out from here."]],
    rs_dockhand: ["Down on the Split Dock the water's warm as breath. Shouldn't be cold enough to freeze a man.",
                  "It is, now. Two Corsair crews came in last month frozen at the oars.",
                  "Crystallized. Like somebody'd turned them to glass.",
                  "Old fishers say the lake remembers. Don't know what it's remembering."],
    mira_north_wind: [{ if: { flag: :wardens_emeritus }, lines: ["MIRA: Wardens, now? How lovely. A mirror for each of you? No? Another time."] },
                      ["MIRA: Frost-glass, straight from the permafrost. Look into one at midnight.",
                       "MIRA: You'll see your heart's desire. Or something that wants to be your heart's desire.",
                       "MIRA: The glass isn't fussy."]],
    mirror_child: ["I bought a mirror from the lady! It's got a friend in it.",
                   "She talks when the others aren't looking. She says she knows you.",
                   "She says you broke her house."],
    rs_festival_goer: ["The Festival of Returning Light is tonight!",
                       "When the aurora bends down to touch the tree, everyone holds their breath.",
                       "Grandma says it's to see whether warmth or winter wins. Warmth always wins. That's the point."],
    rs_lantern_maker: ["Lanterns for the festival! Glow-worm, frost-glass, or the old kind with a candle.",
                       "The old kind's for the Heralds. Everybody knows that."],
    rs_mural_kid: ["That's you on the Hearth wall! The one with the fire AND the snow.",
                   "Hellen says you're not real.", "...Are you real?"],
    rs_center_pilgrim: ["I walked from the Auroral Wall for the festival. Nine days.", "The tree hums louder every mile."],
    sap_customer: ["Tarin's 'liquid sunlight' is just sap and honey.",
                   "But it's warm going down, and it's the only warm thing in the Root-Tier."],
    hearth_drinker: ["To the Heralds! ...They're on the wall, see. Fire on one side, snow on the other.",
                     "Every carving's a bit different. Depends who was paying."],
    hearth_bard: ["Do you know 'The Shade and the Shimmer'? Everybody's sick of it.", "I'm going to play it anyway."],
    warden_ash_after: ["The Root-Gate's sealed. Council orders.", "Nobody's said why, and we're the ones guarding it."],
    warden_lis_after: ["Rootwardens are going missing beyond the Auroral Wall. Three this season.",
                       "We don't talk about it at the festival."],
    warden_tobin_after: ["If the Winter Matron asks you anything, think about your answer.", "She remembers everything you say."],
    darrus_fell: [{ if: { flag: :wardens_emeritus }, lines: ["DARRUS: Law and trade, Wardens. Find who forged that decree and both will thank you."] },
                  ["DARRUS: Autumn Warden Darrus Fell. Law and trade. And, lately, forgeries.",
                   "DARRUS: A decree turned up in the Council's own hand, ordering a dig under the Heartroot.",
                   "DARRUS: None of us signed it."]],
    selrae_vorn: [{ if: { flag: :rite_stopped }, lines: ["The Winter Matron's seat is empty.", "Her fur-trimmed cloak still hangs on it, stiff with frost."] },
                  { if: { flag: :wardens_emeritus }, lines: ["SELRAE: Winter keeps what spring forgets, Wardens.", "SELRAE: I hope you remember that tonight."] },
                  ["SELRAE: Winter Matron Selrae Vorn. Defense and faith.",
                   "SELRAE: You have the look of people who've been very cold for a very long time.",
                   "SELRAE: Sit down, before the High Speaker hugs you."]],
    council_heart: ["Four crystal veins run up the living pillar, pulsing green, red, white and gold in turn.",
                    "It feels less like a pillar and more like standing beside a heartbeat."]
  )

  PARTY_CHAT[:alberica].merge!(
    root_tier: ["Glow-worms in bottles. Somebody down here still loves a lantern.", "I could kiss them. I might."],
    shrine: ["Somebody keeps re-cutting Auril's eyes, sweetheart.", "You don't do that for a goddess you think is dead."],
    rootspire: ["Four hundred years, and they're still singing our songs.", "The second verse is wrong. I'll fix it. Loudly."],
    hearth: ["That carving of me has a lute. I've never been so happy to be misremembered.", "Somebody buy the lute girl a drink."],
    council: ["'Memory,' it says over the door. 'Alberica's line.'", "I don't have a line. ...Do I, sugar? Is it a good one?"]
  )
  PARTY_CHAT[:reptin].merge!(
    root_tier: ["The wolf in me knows these tunnels. I'd rather it didn't.", "Shall we? Quickly, and politely."],
    shrine: ["Cold enough to stop a heart. I'd know.", "Let's not linger. It's terrible for the complexion."],
    rootspire: ["Everything here is alive. The wolf can't decide whether to hunt it or nap in it.", "Neither can I, frankly."],
    hearth: ["'Growth,' the wall calls me. How flattering.", "I'll try to live up to a carving."],
    council: ["The Winter Matron hasn't blinked once since we sat down.", "I've charmed stuffed bears that blinked more."]
  )
  PARTY_CHAT[:alerion].merge!(
    root_tier: ["Watch the water. Whatever froze those Corsairs came from the shore."],
    shrine: ["Mirror-glass prayer tokens. Avarice never throws anything away."],
    rootspire: ["My ring's warm. I didn't know it could be warm.", "...I don't hate it."],
    hearth: ["Hellen knows more about us than we do. Keep her talking. Gently."],
    council: ["A forged decree. Avarice's mark in the wax.", "We broke her mirrors. Not her."]
  )
  PARTY_CHAT[:shade].merge!(
    root_tier: ["Smells like fish and secrets.", "My two least favourite smells. My two best customers."],
    shrine: ["I hate this place. I hate that it's pretty."],
    rootspire: ["Shimmer would've loved this. Lanterns, trees, people who think we're heroes.",
                "She'd have robbed half of them by now. Lovingly."],
    hearth: ["Free rooms. Free ale. I'm not going to ask why.", "I'm going to sit down before somebody changes their mind."],
    council: ["Three people who all think they're in charge.", "Four hundred years, and nothing's changed."]
  )

  # The Heralds' action sheets (batch 02): P-<code>-01 kneel (row 0 facing
  # down, row 3 facing up), -02 reach and touch (row 3), -03 knocked down (row 0).
  HERALD_SHEET = { alberica: "ALB", reptin: "REP", alerion: "ALE", meat_meat: "MM", wyn: "WYN" }

  module_function

  # Staging: a Herald acts something out, as their NPC, as you (in Herald Mode),
  # or as a stand-in beside you. act: :kneel, :reach or :down. Returns the actor.
  def stage_act(key, act, dx: 1, dy: 0, dir: 2, frames: [0, 1, 2, 3], per: 8)
    return nil if !with_or_is?(key) || !Stage.map?
    n = { kneel: 1, reach: 2, down: 3 }[act]
    code = HERALD_SHEET[key]
    return nil if !n || !code
    ev = Stage.herald(key, dx, dy, dir)
    return nil if !ev
    row = act == :reach ? 3 : (act == :kneel && dir == 8 ? 3 : 0)
    Stage.pose(ev, "P-#{code}-0#{n}", row, frames: frames, per: per)
    ev
  rescue StandardError => e
    log("stage_act #{key} #{act}: #{e.message}")
    nil
  end

  # A map event by id or by name (for staging effects on it); nil if it isn't there.
  def stage_event(id_or_name)
    return nil if !$game_map || !id_or_name
    return $game_map.events[id_or_name] if id_or_name.is_a?(Integer)
    $game_map.events.values.find { |e| e.name == id_or_name }
  rescue StandardError
    nil
  end

  # Where an event stands, or a spot near the player when it isn't there.
  def stage_spot(ev, dx = 0, dy = -1)
    return [ev.x, ev.y] if ev
    ([$game_player.x + dx, $game_player.y + dy] rescue [0, 0])
  end

  #-----------------------------------------------------------------------------
  # The way here, and the way back
  #-----------------------------------------------------------------------------
  def heart_gateway(event_id = nil)
    if !flag?(:reversal)
      return talk(:heart_crystal, event_id)
    end
    say(["The Heart has gone quiet: a pale crystal, faintly warm.",
         "Deep inside it, a slow green light turns over, like a seed in the dark.",
         "The shard of mirror in your pocket hums against it.",
         "In the glass: lanterns. Leaves. A tree as tall as the sky."], event_id)
    return if !pbConfirmMessage(_INTL("Step into the shard's reflection, 400 years on?"))
    say(["You hold the shard up to the Heart, and the Heart up to the shard.", "The cavern folds like a page."])
    transfer(*ARRIVAL_POINT)
  end

  # The Auroral Wall, west of the market. Until the summer ends (Ch9) nobody can
  # cross it: outside, the snow hangs in the air, four hundred years and a few
  # weeks away.
  def echo_gate(event_id = nil)
    if !flag?(:wall_thinning)
      say(["The road ends at the Auroral Wall: a curtain of green-gold light from the ground to the sky.",
           "Beyond it, snow. It isn't falling. Every flake hangs in the air,", "as if time out there were holding its breath."], event_id)
      return if respond_to?(:echo_wraiths) && echo_wraiths
      say([cl(:alerion, "Weeks out there. Four hundred years in here. I'm not walking through to find out.")].compact)
      pbMoveRoute($game_player, [PBMoveRoute::Right]) rescue nil
      return
    end
    return geas_turns_back(event_id) if respond_to?(:geas_binds?) && geas_binds?
    say(["The Auroral Wall has gone thin as breath.", "Beyond it, snow is falling again, slowly, over the Dale."], event_id)
    if pbConfirmMessage(_INTL("Walk out through the Wall, into the Dale?"))
      transfer(*DALE_GATE)
    else
      pbMoveRoute($game_player, [PBMoveRoute::Right]) rescue nil
    end
  end

  # SC 6.01 - Out of the lantern
  def scene_rootspire_arrival
    return if flag?(:rootspire_arrived)
    set_flag(:rootspire_arrived)
    set_flag(:razzy_hatched)
    add_counter(:story_beats)
    state[:companions] = ([:alberica, :reptin, :alerion, :shade, :meat_meat] - [herald]).uniq
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    Stage.fx("E-09", [px, py - 1], frames: 9, oy: 16)       # the lantern bursts; snow puffs out
    say(["The cracked lantern on the cobbles bursts like a soap bubble.",
         "A tangle of people, one goblin and a great deal of snow tumbles out onto the market stones."])
    rootspire_sky
    Stage.panel("S-09", fade: 20)
    say(["Gold light. Warm air. A tree so tall its crown is lost in the aurora.",
         "The wind that once screamed through Icewind Dale hums here: a deep, living note that vibrates in your ribs.",
         "Bark veined with light. Branches tangled with frost-glass leaves that catch the aurora and scatter it in a thousand colours.",
         "Thawed earth and pine resin. Water dripping, birds crying, distant bells.",
         "For the first time in centuries, the air tastes of spring.",
         "Welcome to Rootspire, the City of the Verdant Dawn."])
    Stage.panel_off(fade: 20)
    if journey?
      say(["TAMSIN: (screaming, then grabbing you) WHERE DID YOU GO. You were gone an HOUR.",
           "TAMSIN: Who are... (she sees the others) ...who are THEY?",
           cl(:alberica, "(dusting snow off Tamsin's head) Hello, gorgeous. We fell out of a lamp. Don't try it at home.")].compact)
    end
    say([cl(:alberica, "(looking at her empty hands) I was holding it. In the Chasm. It was a seed."),
         cl(:reptin, "(looking up, and up, and up) It isn't a seed any more.")].compact)
    speak(:meat_meat, "Razzy? Razzy is gone. Razzy was holding on...", "...Razzy?") if with_or_is?(:meat_meat)
    say([cl(:alberica, "(a hand on #{herald?(:meat_meat) ? 'your' : "Meat Meat's"} shoulder) We'll find him, sweetheart. He can't hide forever."),
         "LANTERN SELLER: ...Refunds are at the other stall.",
         cl(:shade, "Noted."),
         "Down the street, the Rooted Hearth's windows are lit. The crowd is already parting toward it."].compact)
    Stage.cleanup rescue nil
    state[:goal] = "The Rooted Hearth. Hellen will know what happened."
    loop_skip(:act2) if respond_to?(:loop_skip)
  end

  #-----------------------------------------------------------------------------
  # The Verdant Bazaar
  #-----------------------------------------------------------------------------
  def tarin(event_id = nil)
    if !flag?(:met_tarin)
      set_flag(:met_tarin)
      say(["TARIN: Tarin Goldlash, sap-smith! Liquid sunlight, bottled at the root!",
           "TARIN: Cures chills, sulks and most frostbite. Proper supplies too, for proper adventurers.",
           "TARIN: You look proper. Mostly."], event_id)
      if with_or_is?(:meat_meat)
        say([as(:meat_meat, "Is there coffee in the sunlight?"),
             "TARIN: ...There can be.",
             as(:meat_meat, "Rootspire. Meat Meat gives you four beans. So far.")])
      end
    end
    mart(:rootspire, event_id)
  end

  #-----------------------------------------------------------------------------
  # The Rooted Hearth
  #-----------------------------------------------------------------------------
  # SC 6.02 - You're in my wall. Then a rest point; and SC 6.09 when the time comes.
  def hellen(event_id = nil)
    if !flag?(:met_hellen)
      set_flag(:met_hellen)
      ($game_switches[SW_HEARTH] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      add_counter(:story_beats)
      say(["HELLEN: (dropping a tray) No.",
           herald?(:alberica) ? "She looks at the mural. At you. At the mural again." : "She looks at the mural. At Alberica. At the mural again.",
           "HELLEN: No. You're the Heralds of Dawn and Dusk. You're on my wall. You're in my BAR.",
           cl(:shade, "We've been called worse. Usually in bars."),
           cl(:alberica, "And we've been in worse bars. This one has a mural of me. I love it here."),
           "HELLEN: Sit. All of you. Eat. You've snow in your hair that fell four hundred years ago."].compact, event_id)
      if journey?
        say(["Tamsin looks at you. Then at the small sixth figure on the wall. Then at you again.",
             "They don't say anything. Yet."])
      end
      say(["HELLEN: Here's what my grandmother told me. You broke the hag's mirrors, and a seed took root.",
           "HELLEN: The tree grew in one night that lasted four hundred years. Inside the Auroral Wall, anyway.",
           cl(:alerion, "And outside?"),
           "HELLEN: Outside it's still snowing the same snow. Past the Wall, the flakes hang in the air.",
           "HELLEN: Like time out there is holding its breath."].compact)
      speak(:reptin, "(very quietly) Anduin is out there.", "...Anduin.") if with_or_is?(:reptin)
      say([with_or_is?(:reptin) ? "HELLEN: Then he's waiting a lot less time than you'd think, love." : nil,
           with_or_is?(:shade) ? "In the corner, the bard starts up \"The Shade and the Shimmer\". Shade gets up and walks out." : nil,
           with_or_is?(:shade) ? cl(:alberica, "(watching the door) ...I'll go after them. In a minute. Give them the minute.") : nil,
           "HELLEN: The Council will want to see you. The round hall with the four crystals.",
           "HELLEN: And the root-lift goes up to the Canopy, if you want to see the top of the world."].compact)
      set_flag(:heard_wall_rule)
      state[:goal] = "The Council Hall of Seasons wants to see you."
    elsif festival_ready?
      say(["HELLEN: Last night of the festival. Sit down. Everyone's here.", "HELLEN: Even the Council, gods help us."], event_id)
      return if !pbConfirmMessage(_INTL("Stay for the festival night?"))
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      set_switch(SW_FESTIVAL, true)            # the market plays the night (SC 6.09) when you arrive
      return transfer(2050, 31, 28, 2)
    else
      say(["HELLEN: Back again! Sit, sit. Your rooms are aired and the soup's on."], event_id)
      if !flag?(:badge_hearth)
        say(["HELLEN: And when you want to know the city? Fight the people who feed it.", "HELLEN: Cellar's behind the bar."])
      end
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(HEARTH_REST)
    hearth_coffee
    hearth_night(event_id) if respond_to?(:hearth_night)   # a night in Rootspire (048)
  end

  def festival_ready?
    flag?(:rite_stopped) && flag?(:glimmer_joined) && flag?(:badge_hearth) && !flag?(:festival_night)
  end

  # Rest banter (the Voices tab, Sample 2): the first morning at the Hearth
  # with all five Heralds in the party. Plays once.
  def hearth_coffee
    return if flag?(:hearth_coffee)
    return if ![:alberica, :reptin, :alerion, :meat_meat, :wyn].all? { |k| with_or_is?(k) }
    set_flag(:hearth_coffee)
    mm  = herald?(:meat_meat)
    wyn = herald?(:wyn)
    say(["Morning. Hellen sets a black iron pot on the bar.",
         "HELLEN: Pot's on. Who wants...",
         as(:meat_meat, "MEAT MEAT. Meat Meat wants."),
         mm ? "You take the whole pot." : "She takes the whole pot.",
         "HELLEN: That's the whole pot.",
         as(:meat_meat, "Meat Meat is a whole goblin."),
         as(:reptin, "Hellen, I'm so sorry. She was raised by a laboratory. We're working on it. Diplomatically."),
         as(:meat_meat, "One more word about laboratory and Meat Meat pours coffee in Reptin's ears."),
         as(:reptin, "...And that's the working on it."),
         as(:alberica, "Pour it somewhere useful, sweetheart. Like in me."),
         as(:wyn, "(very quietly) Um. There's... a second pot. I made it. It's mushroom."),
         as(:wyn, "Root-chicory and cap. It's good for you."),
         mm ? "You squint at it." : "Meat Meat squints at it.",
         as(:meat_meat, "Mushroom coffee."),
         as(:wyn, "It's very gentle."),
         as(:meat_meat, "Meat Meat does not want gentle. Meat Meat wants to hear colours."),
         mm ? "You drink it anyway. A long pause." : "She drinks it anyway. A long pause.",
         as(:meat_meat, "...Meat Meat will kill for you, mushroom friend."),
         as(:wyn, "Oh. Oh, please don't. But thank you."),
         as(:alerion, "That's a compliment."),
         as(:wyn, "I know. That's the part that worries me."),
         as(:alerion, "(sipping) This is good."),
         as(:alerion, "...I don't like that it's good."),
         as(:alberica, "That's the most feelings Alerion's had all week. Wyn, marry me."),
         wyn ? "You go pink." : "Wyn goes pink.",
         as(:wyn, "I... I have a Sableye."),
         as(:alberica, "He can come. I'm very open-minded."),
         as(:reptin, "She's like this with everyone, Wyn. It's a compliment and a warning."),
         herald?(:alberica) ? "You rest your chin on your hand and look round the table at all of them." :
                              "Alberica rests her chin on her hand and looks round the table at all of them."])
    speak(:alberica, "...Look at us. Two years ago I'd have been drinking alone. To the people who stay.",
          "(quietly, lifting her cup) To the people who stay.")
    say([as(:meat_meat, "To coffee."),
         as(:alberica, "That's what I said."),
         cl(:glimmer, "(curled in the warm spot by the hearth, eyes shut) Wake me when there's milk."),
         wyn ? "Everyone drinks. Sableye snores on your boot." : "Everyone drinks. Sableye snores on Wyn's boot."].compact)
  end

  # SC 6.09 - Festival night
  def scene_festival_night
    set_switch(SW_FESTIVAL, false)
    return if flag?(:festival_night)
    set_flag(:festival_night)
    add_counter(:story_beats)
    festival_opening if respond_to?(:festival_opening)
    say(["The seventh night. Lanterns on every root, pine-mead in every hand, the whole city in the market.",
         "Beside the Heralds stands the Summer Throne, carried out for the night: empty, and scorched black.",
         "KELYN: (raising a glass) Heralds of Dawn and Dusk. Tonight, Rootspire remembers.",
         cl(:alberica, "Finally, a toast with my name in it. Somebody top me up."),
         cl(:reptin, "(under his breath, smiling at the crowd) Wave. They carved us. We owe them the faces.")].compact)
    festival_toast if respond_to?(:festival_toast)
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(4, 6, 20) rescue nil
    say(["The ground shudders. Once. The same shudder as the lantern.", "The music falters. Everyone goes silent."])
    festival_shudder_extras if respond_to?(:festival_shudder_extras)
    Stage.overlay("O-01", scroll_x: 0.25, opacity: 210, pulse: :hard, fade: 8)
    say(["Overhead, the aurora flickers in a hard, even rhythm. Like a pulse. Like something built.",
         cl(:glimmer, "(a hand on his chest, head cocked) Something under us is burning. ...And hammering. Deep in the roots. Can none of you hear that?"),
         herald?(:meat_meat) ? "(You know that sound. Hammers. The cold table had hammers under it.)" :
                               cl(:meat_meat, "(gone white) Meat Meat knows that sound. Hammers. The cold table had hammers under it."),
         with_or_is?(:meat_meat) ? cl(:alerion, "(low, to #{herald?(:meat_meat) ? 'you' : 'Meat Meat'}) Then we go down and break them.") : nil,
         "RHEVEN: The tree dreams of fire. I've seen it every night this week."].compact)
    if flag?(:fed_pack) && with_or_is?(:reptin)
      say(["Rheven's direwolf has pushed her nose into #{herald?(:reptin) ? 'your' : "Reptin's"} hand and won't leave.",
           "RHEVEN: She's tundra stock. Old line. She knows you."])
    end
    festival_voices if respond_to?(:festival_voices)
    say(["EIRWEN: The library's oldest maps show the hag's lair. Under Dougan's Hole.", "EIRWEN: Which is under us.",
         "Then it stops. The crowd starts cheering again, a little too loudly. The Heralds know better."])
    if herald?(:wyn)
      say(["(The spores went silent. You know what that means.)",
           "(You've heard that silence once before: the night you left your post.)"])
    else
      say(["A Rootwarden pushes through the crowd, out of breath, a Sableye clinging to their shoulder.",
           "WYN: Captain... the Sap Gate spores went silent. Hyphora's... afraid.",
           "WYN: Sorry. Sorry. I'm interrupting."])
    end
    say(["KELYN: (setting down her glass) Heralds. Something is waking below. Find our Summer Marshal.",
         "KELYN: And stop whatever is burning the roots.",
         "HEW: (shoving through) And find my diggers while you're at it! Twelve gone in the Guild Dig!"])
    if herald?(:wyn)
      speak(:wyn, "The roots have another way down. Through the myconids. I can take you.",
            "...I know another way down. The myconids'.")
    else
      say(["WYN: The roots have... another way down. Through the myconids. I can take you.",
           "WYN: If... if that's all right.",
           cl(:alberica, "Darling, it's more than all right. Lead on."),
           cl(:meat_meat, "Mushroom person smells like coffee. Meat Meat approves.")].compact)
    end
    if !herald?(:wyn)
      state[:companions] = ((state[:companions] || []) + [:wyn]).uniq
      set_flag(:wyn_joined)
      pbMessage(_INTL("Wyn joined the party."))
    end
    set_flag(:ch7_started)
    restore_sky
    aurora_hue if respond_to?(:aurora_hue)
    ($game_switches[3937] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    state[:goal] = "Two ways down: the Sap Gate in the Root-Tier (the myconids), or Hew's Guild Dig and the Split Dock."
  end

  # SC 6.03 - They waited (autorun in the market, once you've met Hellen)
  def scene_twins_land
    return if flag?(:twins_met)
    pbSEPlay("Saint7") rescue nil
    say(["Shadows fall across the market. Two dragons come down out of the gold sky.",
         "They're bigger than houses now: one green-gold, one silver-white.",
         herald?(:meat_meat) ? "The green one lands so hard the cobbles crack. He shoves his enormous head into your chest." :
                               "The green one lands so hard the cobbles crack. He shoves his enormous head into Meat Meat's chest.",
         "RAZZILITH: (a painted thought: a goblin's face, over and over, four hundred years of it) ...WAITED.",
         herald?(:meat_meat) ? "(Meat Meat is here. Meat Meat is here now.)" : "MEAT MEAT: (arms round as much of him as she can reach) Meat Meat is here. Meat Meat is here now.",
         cl(:alberica, "(wiping her eyes) Oh, look at the size of him. Who's a big boy? Who waited?"),
         herald?(:alerion) ? "The white one lands like snow. She looks at you and lowers her head." :
                             "The white one lands like snow. She looks at Alerion and lowers her head to him.",
         herald?(:alerion) ? "Your ring frosts and warms at once." : "His ring frosts and warms at once.",
         "Then she looks at Shade, tilts her head, and hums four notes.",
         "SHADE: (sitting down in the street) ...Hi.",
         cl(:reptin, "(gently) Take your time."),
         "LUMIN: (a Wennen in priest's robes, trembling) The Twinned Dragons haven't touched the ground in a century.",
         "LUMIN: The old texts say they'd wait for their partners. Not masters. Partners.",
         "The dragons lift off together, back toward the Shrine of the Twinned Dragons on the Canopy-Tier."].compact)
    set_flag(:twins_met)
    ($game_switches[SW_TWINS_MET] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
  end

  RUMOURS = [
    ["The World Tree bleeds sap that freezes before it lands.", "Rootwardens say it's nothing. Rootwardens say a lot of things are nothing."],
    ["A ghost walks the lake every new moon, carrying a sword made of mirrors.", "I've seen the footprints. They don't melt."],
    ["The Council can't agree whether to seal the Heartroot for good.",
     "The Winter Matron wants it sealed. The High Speaker wants it open. Nobody asks the tree."],
    ["Rootwardens have been going missing beyond the Auroral Wall. Three this season."],
    ["Somebody saw a pale woman talking to the tree's reflection in the sap-wells.", "Talking to it like an old friend."],
    ["There's a direwolf on the northern path with eyes like fire.", "It only howls for the Heralds, they say. Well. You're the Heralds."]
  ]

  def hearth_rumour(event_id = nil)
    n = (state[:rumour_n] ||= 0)
    state[:rumour_n] = (n + 1) % RUMOURS.size
    say(["REGULAR: Rumours? I've got rumours."] + RUMOURS[n], event_id)
  end

  #-----------------------------------------------------------------------------
  # The Council Hall of Seasons
  #-----------------------------------------------------------------------------
  # SC 6.04 - The empty throne
  def kelyn(event_id = nil)
    return kelyn_trials(event_id) if flag?(:trials_open) && respond_to?(:kelyn_trials)
    if flag?(:rite_stopped)
      return ch7_council(event_id) if respond_to?(:ch7_council)
      return say(["KELYN: The aurora touched the tree, and the tree held. Thank you."], event_id)
    elsif flag?(:wardens_sworn) || flag?(:wardens_refused)
      return say(["KELYN: The Still Sky Shrine is in the Root-Tier. The Wardens' stair is in the woodcarver's workshop.",
                  "KELYN: Watch the rite closely."], event_id)
    end
    say(["Four crystal obelisks pulse: green, gold, red, white. Three seats are filled.",
         "The fourth is gold-leafed and vine-draped, scorched black, with warm sap dripping under it.",
         "KELYN: Four hundred years late. Or right on time. Welcome home.",
         "SELRAE: (not unkindly) We'd hoped you'd be taller.",
         cl(:alerion, "We'd hoped you'd be warmer."),
         with_or_is?(:alerion) ? cl(:reptin, "(under his breath) Let me do the talking. Please. I'm begging.") : nil,
         "DARRUS: (chewing clove bark) Spare us the poetry.",
         "DARRUS: Our Summer Marshal, Var Rime-Breaker, went down to check the heat in the roots. Seven days ago.",
         "DARRUS: He hasn't come back. And this arrived the next morning.",
         "A decree: \"Begin excavation beneath the Heartroot.\" Signed with Summer's seal.",
         "In the wax there's a tiny mark: a cracked mirror.",
         cl(:alerion, "That's the hag's sign."),
         "SELRAE: The hag has been dead four hundred years.",
         cl(:meat_meat, "Mirrors remember. She said so. Meat Meat remembers too."),
         "KELYN: Rootspire has been stuck in this summer for thirty years. I need people the tree trusts.",
         "KELYN: Will you swear the Wardens' oath?"].compact, event_id)
    c = pbMessage(_INTL("Swear the Wardens' oath?"), [_INTL("\"We'll guard the pulse.\""), _INTL("\"We just got here.\"")], 0)
    if c == 1
      set_flag(:wardens_refused)
      say(["SELRAE: Good. People who swear oaths in their first hour swear them to anyone.",
           "KELYN: (tightly) ...As you like. The city will still need you.",
           cl(:reptin, "(warmly) And it'll have us, Speaker. Oath or no oath. We're terrible at leaving.")].compact)
    else
      set_flag(:wardens_sworn)
      say(["You put your hands on the living pillar. It's warm, and it beats.",
           "KELYN: Then welcome home, Wardens of Rootspire.",
           "KELYN: Take this: sap from the Heart of Spring's first root.",
           "KELYN: It heals what it touches. Slowly and stubbornly, like the tree.",
           cl(:alberica, "Slow and stubborn. Story of my love life. ...Thank you, Speaker.")].compact)
      pbReceiveItem(:LEFTOVERS) rescue nil
    end
    set_flag(:wardens_emeritus)      # the Root-Tier stair opens either way (switch 3935)
    ($game_switches[SW_WARDENS] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["Over the Council's seats, carved in the living wood: a ring of four leaves, each a different season, round a single drop of sap.",
         "Under it the motto: BALANCE IS SURVIVAL.",
         "KELYN: Growth, Memory, Balance. Reptin's legacy, Alberica's line, Glimmer's faith. We were founded on you three.",
         "KELYN: (quieter) And a season too long. Thirty years of summer. I want to know why. Captain Kethan of the Rootwardens says it was no accident.",
         "KELYN: He keeps the Rootwarden Hall, in the Verdant Halls off the Bazaar. Hear him out.",
         "SELRAE: If the Halo moves tonight, Kelyn, I'll want the Canopy under martial law. My wardens. To protect the Rift.",
         "KELYN: No.",
         "SELRAE: (to you, mildly) She always says no. Then something burns, and she says yes.",
         "SELRAE: There's a rite at the Still Sky Shrine tonight that I'd like you to watch. Closely.",
         "KELYN: The Wardens' stair down to the Root-Tier is in the woodcarver's workshop, by the old gate."])
    selrae_court if respond_to?(:selrae_court)
    state[:goal] = "The Still Sky Shrine, in the Root-Tier. (The woodcarver's workshop has the stair down.)"
  end

  #-----------------------------------------------------------------------------
  # Festival night: the Root-Tier and the Rite of Stillness
  #-----------------------------------------------------------------------------
  def scene_root_tier_arrival
    return if flag?(:root_tier_arrived)
    set_flag(:root_tier_arrived)
    say(["Moss-steam and fish oil. Living wood creaks overhead, and meltwater drips from the roots.",
         "Glow-worm lanterns swing from root-arches, green light on black water.",
         "Where the ice once choked Dougan's Hole, warm mist coils.",
         cl(:reptin, "Dougan's Hole. Right under our feet. I walked these streets when they were ice."),
         cl(:alberica, "(sniffing) Fish, moss and old ice. Smells like my first marriage."),
         cl(:shade, "Festival's up there. Whatever this is, it's down here. Let's be quick.") ||
           cl(:glimmer, "Festival's up there, and so's the milk. Let's be quick. My fur's frizzing.")].compact)
  end

  def scene_shrine_enter
    return if flag?(:shrine_entered)
    set_flag(:shrine_entered)
    say(["A half-collapsed chapel of blue marble. Frost clings to every icon.",
         "Under a hole in the roof, robed figures kneel round a statue. Jars of glowing sap line its feet.",
         "Someone is chanting, very softly:",
         "\"Cool the heart of the goddess. Cool the heart. Cool it until it stops.\"",
         cl(:alberica, "(whispering) I hate a hymn with no tune."),
         with_or_is?(:alberica) ? cl(:alerion, "Quiet.") : nil].compact)
  end

  # SC 6.07 - The Rite of Stillness
  def eline(event_id = nil)
    return if flag?(:rite_stopped)
    if !flag?(:eline_spoke)
      say(["On the altar, under a cracked statue of Auril, a man stands frozen in old blue ice.",
           "No coat. Bare feet.",
           cl(:shade, "(very quiet) ...That's him.") || cl(:glimmer, "(very quiet) ...That's him. Sephek."),
           "Four hundred years in the ice. The Halo's candles burn all around him.",
           "In his chest, where the frost-light used to beat, there's only a carved-out hollow.",
           "ELINE: The Frost Saint. You know him. Your hand froze him. Ours kept him.",
           "ELINE: His heart was the holiest thing we had.",
           cl(:alberica, "Was?"),
           "ELINE: We gave it to Summer. Summer has promised us a winter. Not death. Stillness, at last.",
           "ELINE: The way the Dale was meant to be.",
           "ELINE: Tonight we cool the tree. A little. Just enough to start."].compact, event_id)
      speak(:reptin, "(pleasantly) Matron, I'm going to ask you nicely to stop. That was the nice part.",
            "Stop. Please.") if with_or_is?(:reptin)
      eline_conversion if respond_to?(:eline_conversion)
      set_flag(:eline_spoke)
    end
    return if !trainer(:eline, event_id)
    set_flag(:rite_stopped)
    set_flag(:heart_given_summer)
    ($game_switches[SW_RITE_STOPPED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["ELINE: It doesn't matter. Summer has the heart. Summer keeps promises.",
         "She slips out through a back door you didn't see.",
         "Outside, the aurora flickers, and the gold steadies.",
         "On the altar, beside the frozen man, someone has left two Full Restores.",
         cl(:alerion, "Bait."),
         cl(:alberica, "Free, though."),
         with_or_is?(:alberica) && with_or_is?(:alerion) ? cl(:alerion, "...Free bait.") : nil].compact)
    pbReceiveItem(:FULLRESTORE, 2) rescue nil
    state[:goal] = "Summer has Sephek's heart. The festival runs seven days: rest at the Hearth for its last night when you're ready."
  end

  # The aurora curtain (O-01) hangs over Rootspire's open sky until summer ends.
  ROOTSPIRE_SKY_MAPS = [2050, 2061]
  def rootspire_sky
    return if !$game_map || !active?
    if ROOTSPIRE_SKY_MAPS.include?($game_map.map_id) && !flag?(:summer_ended)
      Stage.overlay("O-01", scroll_x: 0.25, opacity: 110, fade: 0, ambient: true) if !Stage.overlay?("O-01")
    else
      Stage.overlay_off("O-01", fade: 0)
    end
  end

  # After a scene that took the sky over: give it back.
  def restore_sky
    Stage.overlay_off("O-01", fade: 20)
    rootspire_sky
  end

  def apply_chapter6_switches
    return if !active? || !$game_switches
    sync_switch(SW_HEARTH, flag?(:met_hellen))
    sync_switch(SW_WARDENS, flag?(:wardens_emeritus) || flag?(:wardens_sworn) || flag?(:wardens_refused))
    sync_switch(SW_RITE_STOPPED, flag?(:rite_stopped))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter6_switches
    FrostThaw.rootspire_sky
  rescue StandardError => err
    FrostThaw.log("Chapter 6 switches failed: #{err.message}")
  end
}
