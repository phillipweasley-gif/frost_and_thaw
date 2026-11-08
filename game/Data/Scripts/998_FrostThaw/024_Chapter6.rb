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
    FT_HALO_F:     ["Fractured Halo", :CHANNELER, 1, 60],
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
    halo_ascetic: [:FT_HALO_F, "Sister Wenna",  [[:B124H227, 37], [:DEWGONG, 38]],
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
    kurt_door: [{ if: { flag: :wardens_refused }, lines: ["WOODCARVER: Heralds! Speaker's word: the stair to the Root-Tier's open to you.",
                                                          "WOODCARVER: It's through my workshop. Mind the third step. It bites."] },
                { if: { flag: :wardens_emeritus }, lines: ["WOODCARVER: Wardens! The Rootwardens' stair to the Root-Tier is through my workshop.",
                                                           "WOODCARVER: Mind the third step. It bites."] },
                ["WOODCARVER: Festival masks. Dragons, mostly: Razzilith the Verdant and Frostina the Pale.",
                 "WOODCARVER: Every year somebody orders a Herald mask. Every year I carve you wrong.",
                 "WOODCARVER: ...You'd know, I suppose."]],
    root_stair_closed: ["The woodcarver's workshop. A trapdoor in the floor leads down into the roots.",
                        "A Rootwarden's seal is tied across it.",
                        "WOODCARVER: The Wardens' stair to the Root-Tier. Council business only, I'm afraid."],
    split_dock_fisher: ["FISHER: Water's warm as breath down here. Always has been.",
                        "FISHER: Then last month it froze round two Corsair boats in a single night.",
                        "FISHER: Crews still at the oars. Glass all through. Mirror-glass, not lake ice.",
                        "FISHER: The Frost Saint's kind, my gran would've said.",
                        "FISHER: My gran'd have said somebody prayed for cold. Gran was usually right."],
    corsair_sailor: ["CORSAIR: Auroral Corsairs. We run the outer lakes when nobody else will.",
                     "CORSAIR: And the tunnels under the Split Dock, when the Council isn't looking.",
                     "CORSAIR: Those were our people out there. Whoever froze them did it from the shore.",
                     "CORSAIR: The ice came off the land. Mirror-ice. You could see your face in a dead man's.",
                     "CORSAIR: Old Ivran swears he saw a barefoot man on the shingle that night, walking north.",
                     "CORSAIR: No coat. Breath like smoke off a lake."],
    halo_vigil_after: ["ISKAR: The Matron is at the Still Sky Shrine. Tonight she makes the sky hold still.",
                       "ISKAR: You'll see. Everyone will see."],
    halo_ascetic_after: ["WENNA: Go on, then. Go and stop her. I hope you can. I hope you can't.", "WENNA: I don't know anymore."],
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
    rs_dockhand: ["Down on the Split Dock the water's warm as breath. Too warm to freeze anyone.",
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
    rs_festival_goer: ["The Festival of Returning Light! It's on all week. The seventh night's the big one.",
                       "When the aurora bends down to touch the tree, everyone holds their breath.",
                       "Grandma says it's to see if warmth or winter wins. Warmth always wins. That's the point."],
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
    # (context 15 M15-1: the seal now has a reason, said at the Shrine)
    warden_ash_after: [{ if: { flag: :ch7_started }, lines: ["ASH: The Root-Gate's open. Speaker's word. Mind the stair, it's warm."] },
                       ["ASH: The Root-Gate's sealed. Council orders, till the festival's done.",
                        "ASH: If the Marshal doesn't come up on the seventh night, we go down after him."]],
    warden_lis_after: ["LIS: Rootwardens are going missing beyond the Auroral Wall. Three this season.",
                       "LIS: We don't talk about it at the festival."],
    warden_tobin_after: ["TOBIN: If the Winter Matron asks you anything, think about your answer.", "TOBIN: She remembers everything you say."],
    darrus_fell: [{ if: { flag: :wardens_emeritus }, lines: ["DARRUS: Law and trade, Wardens. Find who forged that decree and both will thank you."] },
                  ["DARRUS: Autumn Warden Darrus Fell. Law and trade. And, lately, forgeries.",
                   "DARRUS: A decree turned up in the Council's own hand, ordering a dig under the Heartroot.",
                   "DARRUS: None of us signed it."]],
    selrae_vorn: [{ if: { flag: :rite_stopped }, lines: ["The Winter Matron's seat is empty.", "Her fur-trimmed cloak still hangs on it, stiff with frost."] },
                  # (scene pass: your answer at the Council read back; notes 06 E27: no "Wardens" if you refused)
                  { if: { flag: :terrace_walls }, lines: ["SELRAE: Walls, you said. I'll remember it at the vote.", "SELRAE: Watch the rite tonight."] },
                  { if: { flag: :terrace_roots }, lines: ["SELRAE: Roots, you said. Kelyn will love you for it. I'll forgive you eventually.",
                                                          "SELRAE: Watch the rite tonight."] },
                  { if: { flag: :wardens_refused }, lines: ["SELRAE: Winter keeps what spring forgets, Heralds.", "SELRAE: I hope you remember that tonight."] },
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
    council: ["A forged decree. Summer's seal. A mirror in the wax.", "Somebody kept a piece of the hag."]
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
      say(["The road ends at the Auroral Wall: a curtain of green-gold light, ground to sky.",
           "Beyond it, snow. It isn't falling.", "Every flake hangs in the air, as if time out there were holding its breath."], event_id)
      return if respond_to?(:echo_wraiths) && echo_wraiths
      # (scene pass, from builder e: a person holds the edge, the Pokémon way, and says why)
      w = Stage.actor(:warden, $game_player.x + 2, $game_player.y - 1, 4, graphic: "BW029") if Stage.map?
      Stage.walk_to(w, $game_player.x + 1, $game_player.y, face: 4) if w
      if flag?(:echo_warden_met)
        say(["WARDEN: Still no, friend. The Wall doesn't open. For anyone."])
      else
        set_flag(:echo_warden_met)
        say(["WARDEN: (stepping in) Not through there, friend. Rootwarden watch.",
             "WARDEN: Nobody crosses the Wall. Four hundred years of trying. It's always one step off."])
      end
      say([cl(:alerion, "Weeks out there. Four hundred years in here. I'm not walking through to find out.")].compact)
      Stage.walk(w, [3]) if w
      pbMoveRoute($game_player, [PBMoveRoute::Right]) rescue nil
      Stage.remove_actor(w) if w
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
         "A tangle of people, one goblin and a great deal of snow tumbles out onto the cobbles."])
    rootspire_sky
    Stage.panel("S-09", fade: 20)
    say(["Gold light. Warm air. A tree so tall its crown is lost in the aurora.",
         "The wind that screamed through Icewind Dale hums here, a deep, living note in your ribs.",
         "Bark veined with light. Frost-glass leaves catch the aurora and scatter it into colours.",
         "For the first time in centuries, the air tastes of spring.",
         "Welcome to Rootspire, the City of the Verdant Dawn."])
    Stage.panel_off(fade: 20)
    if journey?
      say(["TAMSIN: (screaming, then grabbing you) WHERE DID YOU GO. You were gone an HOUR.",
           "TAMSIN: Who are... (they see the others) ...who are THEY?",
           cl(:alberica, "(dusting snow off Tamsin's head) Hello, trouble."), cl(:alberica, "We fell out of a lamp. Don't try it at home.")].compact)
    end
    say([cl(:alberica, "(looking at her empty hands) I was holding it. In the Chasm. It was a seed."),
         cl(:reptin, "(looking up, and up, and up) It isn't a seed any more.")].compact)
    speak(:meat_meat, "Razzy? Razzy is gone. Razzy was holding on...", "...Razzy?") if with_or_is?(:meat_meat)
    Stage.actor(:lantern_seller, px + 2, py + 1, 4, graphic: "BW (30)") if Stage.map?   # (the stall the lantern came from)
    say([cl(:alberica, "(a hand on #{herald?(:meat_meat) ? 'your' : "Meat Meat's"} shoulder) We'll find him, sweetheart."),
         "LANTERN SELLER: ...Refunds are at the other stall.",
         cl(:shade, "Noted."),
         "Down the street, the Rooted Hearth's windows are lit.", "The crowd is already parting toward it."].compact)
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
           "TARIN: Cures chills, sulks and most frostbite. Proper supplies, too, for adventurers.",
           "TARIN: You look proper. Mostly."], event_id)
      if with_or_is?(:meat_meat)
        say([ask_as(:meat_meat, "Is there coffee in the sunlight?", "...Coffee?"),
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
      Stage.emote(stage_event(event_id), :exclaim) rescue nil
      say(["HELLEN: (dropping a tray) No.",
           herald?(:alberica) ? "She looks at the mural. At you. At the mural again." : "She looks at the mural. At Alberica. At the mural again.",
           "HELLEN: No. You're the Heralds of Dawn and Dusk. You're on my wall. You're in my BAR.",
           cl(:shade, "We've been called worse. Usually in bars."),
           cl(:alberica, "And we've been in worse bars. This one has a mural of me. I love it here."),
           "HELLEN: Sit. All of you. Eat. You've snow in your hair that fell four hundred years ago."].compact, event_id)
      # (scene pass: the player's input in the welcome. Hellen feeds you before she lets you talk.)
      c = pbMessage(_INTL("Hellen puts a bowl in front of you."), [_INTL("Eat."), _INTL("\"What happened to us?\"")], 0)
      say([c == 0 ? "Mutton stew. You'd forgotten you were hungry. You'd forgotten a lot, in the snow." :
                    "HELLEN: Eat first. Then I'll tell you. ...Fine. Both. Eat while I talk."])
      # Context 06 M6-1 and §6: the hour answered, the Wall shown as a thing
      # you can see, and why nobody walks out of it. Herald Wyn comes home.
      if herald?(:wyn)
        say(["HELLEN: (stopping, a cup in each hand) ...Wyn? You're on the Gate tonight.",
             as(:wyn, "I was. An hour ago. Or a month, and four hundred years."),
             "HELLEN: You look like you've been out in the snow for weeks, pet. Sit. Eat."])
      end
      if journey?
        tam = Stage.actor(:tamsin, 6, 11, 8, graphic: "FT_tamsin")    # at the door, as in the market
        say(["Tamsin looks at you. Then at the small sixth figure on the wall. Then at you again.",
             "They don't say anything. Yet.",
             "TAMSIN: (to Hellen) It was an HOUR. I counted.",
             "HELLEN: An hour for you, love. Four hundred years for them."])
      end
      say(["HELLEN: Gran told it like this. You broke the hag's mirrors, and a seed took root.",
           "HELLEN: The tree grew in one night that lasted four hundred years. In here, anyway."])
      if with_or_is?(:reptin)
        speak(:reptin, "(very quietly) Four hundred years. Then everyone we left out there...", "...Everyone we left.")
      else
        speak(:alberica, "Four hundred years. Then everyone in the Dale...", "...Everyone in the Dale.")
      end
      say(["HELLEN: That's the strange part. There's a ring of light round the valley. The Wall.",
           "HELLEN: Outside, it's still snowing the same snow. The flakes just hang in the air.",
           "HELLEN: Like time out there is holding its breath."])
      speak(:reptin, "(quietly) My husband's out there. Anduin. Counting days. I said a month.", "...Anduin.") if with_or_is?(:reptin)
      say([with_or_is?(:reptin) ? "HELLEN: Then he's waiting a lot less time than you'd think, love." : nil].compact)
      speak(:alberica, with_or_is?(:reptin) ? "Then we walk out and fetch him. Point me at the door." :
                                              "Then we walk out and fetch them. Point me at the door.", "...Where's the door?")
      say(["HELLEN: Folk walk at the Wall all day, pet. It's always one step off. Nobody's crossed.",
           cl(:alerion, "(at the window) A door that doesn't open.")].compact)
      Stage.remove_actor(tam) if tam
      say([with_or_is?(:shade) ? "The bard in the corner starts up \"The Shade and the Shimmer\". Shade gets up and walks out." : nil,
           with_or_is?(:shade) ? cl(:alberica, "(watching the door) ...I'll go after them. In a minute. Give them the minute.") : nil,
           "HELLEN: The Council will want to see you. The round hall with the four crystals.",
           "HELLEN: The root-lift goes up to the Canopy, if you want to see the top of the world.",
           "HELLEN: And the cellar's where the Hearth's regulars fight. Come down when you're fed."].compact)
      set_flag(:heard_wall_rule)
      state[:goal] = "The Council Hall of Seasons wants to see you."
    elsif festival_ready?
      say(["HELLEN: Last night of the festival. Sit down. Everyone's here.", "HELLEN: Even the Council, gods help us."], event_id)
      return if !pbConfirmMessage(_INTL("Stay for the festival night?"))
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      set_switch(SW_FESTIVAL, true)            # the market plays the night (SC 6.09) when you arrive
      return transfer(*FESTIVAL_SPOT)            # the Festival Circle, at the Council Hall's steps (notes 06 E4)
    else
      # (notes 06 E11: a different welcome each night, not the same three boxes)
      say([hellen_greeting], event_id)
      if flag?(:beat_tamsin) && !flag?(:hellen_on_tamsin)
        set_flag(:hellen_on_tamsin)                 # (notes 06 E32: the rival battle, read back)
        say(["HELLEN: Tamsin says you went easy on them. They're furious. Thank you."])
      end
      if !flag?(:badge_hearth)
        say(["HELLEN: And when you want to know the city? Fight the people who feed it.", "HELLEN: Cellar's behind the bar."])
      end
      if (g = festival_wait_goal)
        n = festival_nights_left
        if !flag?(:hellen_districts)
          # (context 06 §5, 15 M15-2: when the festival started, and where the city is)
          set_flag(:hellen_districts)
          say(["At the bar, a regular starts a song about the Heralds. It's mostly wrong.",
               "HELLEN: The festival opened the morning you fell, love. Its last night's the seventh.",
               "HELLEN: #{n == 1 ? 'Tomorrow' : "#{number_word(n).capitalize} more nights"}. Nobody rushes the seventh night.",
               "HELLEN: Spend the days. Halls up the north stair, the Promenade over the leaf-bridge.",
               "She tops up your cup without asking."])
        else
          say(["(The festival's last night is #{n == 1 ? 'tomorrow' : "in #{number_word(n)} nights"}.)"])
        end
        state[:goal] = g
      end
      hellen_business(event_id) if respond_to?(:hellen_business)     # her own errands and the old passages (048_H)
      # (scene pass: a rest is the player's call, the way a Pokémon Center asks)
      if !pbConfirmMessage(_INTL("Stay the night at the Hearth?"))
        return say(["HELLEN: Suit yourself, love. The bed'll keep."])
      end
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(HEARTH_REST)
    hearth_coffee
    hearth_night(event_id) if respond_to?(:hearth_night)   # a night in Rootspire (048)
  end

  HELLEN_GREETINGS = [
    "HELLEN: Back again! Sit, sit. Your rooms are aired and the soup's on.",
    "HELLEN: There you are. Boots off the bench, love. Soup's on.",
    "HELLEN: Corrie's been telling your stories wrong all night. Sit down and glare at him.",
    "HELLEN: Bread's still warm. Don't tell the regulars.",
    "HELLEN: You look half asleep. Good. Eat, then upstairs with you.",
    "HELLEN: The whole street's hanging lanterns. Sit. Eat. Look at them later."
  ]

  def hellen_greeting
    n = (state[:hellen_welcome] ||= 0)
    state[:hellen_welcome] = n + 1
    HELLEN_GREETINGS[n % HELLEN_GREETINGS.size]
  end

  NUMBER_WORDS = %w[no one two three four five six seven eight nine ten eleven twelve]
  def number_word(n) = NUMBER_WORDS[n] || n.to_s

  # The festival's last night is the seventh night in the city (rootspire.md
  # 5545-5560, 5784-5792): the downtime week comes first.
  FESTIVAL_NIGHT = 7
  FESTIVAL_SPOT = [2050, 20, 30, 8]
  FESTIVAL_TONE = Tone.new(-68, -60, -10, 30) rescue nil      # lantern-lit night (notes 06 E4)

  def festival_ready?
    festival_business_done? && rs_day >= FESTIVAL_NIGHT && !flag?(:festival_night)
  end

  def festival_business_done?
    flag?(:rite_stopped) && flag?(:glimmer_joined) && flag?(:badge_hearth)
  end

  # Days until the festival's last night, for Hellen and the goal line.
  def festival_nights_left = [FESTIVAL_NIGHT - rs_day, 0].max

  def festival_wait_goal
    return nil if !festival_business_done? || flag?(:festival_night) || rs_day >= FESTIVAL_NIGHT
    n = festival_nights_left
    # (context 06 §5: no names the player hasn't met; 15 M15-1: what the days are for)
    "The festival's last night is in #{n} night#{n == 1 ? '' : 's'}: Var must sit the Throne. Rest at the Hearth. " \
      "Between rests, ask round about Summer: the Bazaar, the Verdant Halls, the Canopy, the Library, the Root-Tier."
  end

  # Rest banter (the Voices tab, Sample 2): the first morning at the Hearth
  # with all five Heralds in the party. Plays once.
  def hearth_coffee
    return if flag?(:hearth_coffee)
    return if !flag?(:ch7_started)     # the morning after the summons, not on the heels of the shudder (notes 06 E14)
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
         as(:reptin, "Hellen, I'm so sorry. She was raised by a laboratory."),
         as(:reptin, "We're working on it. Diplomatically."),
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
         as(:wyn, "I know. That's the part that worries me.")])
    # (owner, 2026-11-07: one choice in the scene: your own cup, and a small lift for your
    # team; placed mid-scene so neither half runs past 25 boxes without an input)
    pick_coffee
    say([
         as(:alerion, "(sipping) This is good."),
         as(:alerion, "...I don't like that it's good."),
         as(:alberica, "That's the most feelings Alerion's had all week. Wyn, marry me."),
         wyn ? "You go pink." : "Wyn goes pink.",
         as(:wyn, "I... I have a Sableye."),
         as(:alberica, "He can come. I'm very open-minded."),
         as(:reptin, "She's like this with everyone, Wyn. It's a compliment and a warning."),
         herald?(:alberica) ? "You rest your chin on your hand and look round the table at all of them." :
                              "Alberica rests her chin on her hand and looks round the table at all of them."])
    say([as(:alberica, "...Look at us. Two years ago I'd have been drinking alone.")])
    speak(:alberica, "To the people who stay.", "(quietly) ...To the people who stay.")
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
    cast = festival_cast
    ($game_screen.start_tone_change(FESTIVAL_TONE, 20) if FESTIVAL_TONE) rescue nil
    pbBGMPlay("meloetta_song") rescue nil                     # the festival's own tune (notes 06 E9)
    festival_opening if respond_to?(:festival_opening)
    say(["Beside the Heralds stands the Summer Throne, carried out for the night. Empty. Scorched.",
         "KELYN: (raising a glass) Heralds of Dawn and Dusk. Tonight, Rootspire remembers.",
         cl(:alberica, "Finally, a toast with my name in it. Somebody top me up."),
         cl(:reptin, "(smiling at the crowd) Wave. They carved us. We owe them the faces."),
         "KELYN: (lower, eyes on the empty chair) Seven nights. The Marshal's oath. He didn't come.",
         "Nobody near enough hears her but you. The pipes strike up again."].compact)
    festival_toast if respond_to?(:festival_toast)
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(4, 6, 20) rescue nil
    shudder = if journey? then "The ground shudders. Once. The same shudder as the lantern, that morning."
              elsif herald?(:wyn) then "The ground shudders. Once. The same shudder as the night you fell."
              else "The ground shudders. Once. Deep, like something heavy set down below."
              end
    pbBGMFade(0.6) rescue nil
    say([shudder, "The pipes falter. Everyone goes silent."])
    festival_shudder_extras if respond_to?(:festival_shudder_extras)
    Stage.overlay("O-01", scroll_x: 0.25, opacity: 210, pulse: :hard, fade: 8)
    say(["Overhead, the aurora flickers in a hard, even rhythm. Like a pulse. Like something built.",
         cl(:glimmer, "(a hand on his chest) Something under us is burning."),
         cl(:glimmer, "And hammering. Deep in the roots. Can't you hear it?")].compact)
    if with_or_is?(:glimmer) && !herald?(:glimmer)
      c = pbMessage(_INTL("Glimmer's looking at you."), [_INTL("\"I hear it.\""), _INTL("\"Hear what?\"")], 0)
      say([c == 0 ? "GLIMMER: (very quietly) Good. Then I'm not mad. That's worse." : "GLIMMER: ...Lucky you. Keep it that way."])
    end
    say([
         herald?(:meat_meat) ? "(You know that sound. Hammers. The cold table had hammers under it.)" :
                               cl(:meat_meat, "Meat Meat knows that sound. Hammers. The cold table had hammers under it."),
         with_or_is?(:meat_meat) ? cl(:alerion, "(low, to #{herald?(:meat_meat) ? 'you' : 'Meat Meat'}) Then we go down and break them.") : nil,
         "RHEVEN: The tree dreams of fire. I've seen it every night this week."].compact)
    if flag?(:fed_pack) && with_or_is?(:reptin)
      say(["Rheven's direwolf has pushed her nose into #{herald?(:reptin) ? 'your' : "Reptin's"} hand and won't leave.",
           "RHEVEN: She's tundra stock. Old line. She knows you."])
    end
    festival_voices if respond_to?(:festival_voices)
    say(["EIRWEN: The library's oldest maps show the hag's lair. Under Dougan's Hole.", "EIRWEN: Which is under us.",
         "Then it stops. The crowd starts cheering again, a little too loudly."])
    # Context 06 M6-8: Wyn leaves the Gate on screen, so Chapter 7's "You left
    # your post" is a payoff, not news. (The myconids keep Hyphora's name.)
    if herald?(:wyn)
      say(["(The spores went silent. You know what that means.)",
           "(You've heard that silence once before: the night you left your post.)",
           "(You left the Gate open behind you. You didn't even think.)"])
    else
      Stage.walk_to(cast[:wyn], $game_player.x + 2, $game_player.y + 1, face: 8) if cast[:wyn]
      say(["A Rootwarden pushes through the crowd, out of breath, a Sableye clinging to one shoulder.",
           "WYN: Captain Rheven... it's Wyn. From the Sap Gate. The spores went silent.",
           "RHEVEN: Silent? They've never... Who's on the Gate?",
           "WYN: (very small) ...Nobody. I ran.",
           "WYN: Sorry. Sorry. I'm interrupting."])
    end
    # The mission itself comes with the Council's summons, after the
    # Rootwardens' night, the scorch marks and Eirwen (GM outline steps 1-6,
    # rootspire.md 5643-5684): council_summons, below.
    say(["KELYN: (setting down her glass) Something is waking below. I don't know what yet.",
         "KELYN: Stay in the city tonight, Heralds. When we know, the Council will send for you."])
    Stage.walk_to(cast[:hew], $game_player.x + 3, $game_player.y - 1, face: 4) if cast[:hew]
    say(["HEW: (shoving through) Hew Talmire, Guild of Roots! Then find my diggers! Twelve, gone!"])
    if herald?(:wyn)
      speak(:wyn, "The roots have another way down. Through the myconids. I can take you.",
            "...I know another way down. The myconids'.")
    else
      say(["WYN: The Sap Gate's the myconids' door. Mushroom folk, under the roots. I can take you.",
           "WYN: If... if that's all right."])
      c = pbMessage(_INTL("Wyn waits, holding their breath."), [_INTL("\"Lead the way.\""), _INTL("\"Are you sure?\"")], 0)
      say([c == 0 ? "WYN: Oh. Oh, good. ...I'll try not to get us lost. I won't. I don't." :
                    "WYN: ...No. But I'm sure I'm going. It's my Gate."])
      sayc([cl(:alberica, "Then lead on, Wyn."),
            cl(:meat_meat, "Mushroom person. Meat Meat will allow it.")].compact)
      Stage.remove_actor(cast[:wyn]) if cast[:wyn]          # (Wyn walks with you from here)
    end
    if !herald?(:wyn)
      state[:companions] = ((state[:companions] || []) + [:wyn]).uniq
      set_flag(:wyn_joined)
      pbMessage(_INTL("Wyn joined the party."))
    end
    festival_cast_off(cast)
    ($game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20)) rescue nil
    ($game_map.autoplay) rescue nil
    restore_sky
    state[:goal] = "The festival's over. Rest at the Hearth: the Council will send for you."
  end

  # Festival night's people, on screen round the Throne (WRITING_GUIDE §9a):
  # Kelyn and Eirwen by the Throne; Rheven, his direwolf, Lirielle and Hew come
  # over from their stalls (stand-ins; the stalls' own people step out of sight
  # for the night); Wyn comes in from the east road.
  FESTIVAL_STAND_INS = {
    "Captain Rheven" => [:rheven, "FT_captain_rheven_stormbranch", 4, 1, 4], "Rheven's direwolf" => [:direwolf, "Followers/FT_rheven_direwolf", 5, 1, 4],
    "Lirielle Mossdancer" => [:lirielle, "Followers/BUNEARY", -4, -1, 6], "Hew Talmire" => [:hew, "FT_master_hew_talmire", 6, -1, 4]
  }

  FESTIVAL_CROWD = [["BW (29)", -4, 0, 6], ["BWParasolLady", -3, 2, 8], ["BW (30)", 2, 2, 8], ["BW (38)", 4, 2, 8],
                    ["BW (62)", -1, 3, 8], ["BW (35)", 1, 3, 8]]

  def festival_cast
    cast = { hidden: [] }
    return cast if !Stage.map? || $game_map.map_id != MAPS[:rootspire]
    px, py = $game_player.x, $game_player.y
    # Kelyn on the Hall's steps, Eirwen by the Throne, the city in a ring round
    # the Circle (you stand facing the Hall: FESTIVAL_SPOT)
    cast[:kelyn]  = Stage.actor(:kelyn, px, py - 1, 2, graphic: "FT_high_speaker_kelyn_of_spring")
    cast[:eirwen] = Stage.actor(:eirwen, px - 2, py - 1, 2, graphic: "FT_eirwen_solglass")
    FESTIVAL_CROWD.each_with_index do |(g, dx, dy, d), i|
      cast[:"crowd#{i}"] = Stage.actor(:"townsfolk#{i}", px + dx, py + dy, d, graphic: g)
    end
    FESTIVAL_STAND_INS.each do |name, (key, graphic, dx, dy, d)|
      ev = Stage.find(name)
      (ev.transparent = true; cast[:hidden] << ev) if ev
      cast[key] = Stage.actor(key, px + dx, py + dy, d, graphic: graphic)
    end
    cast[:wyn] = Stage.actor(:wyn, px + 7, py + 1, 4, graphic: "FT_wyn") if !herald?(:wyn)
    cast
  rescue StandardError => e
    log("festival_cast: #{e.message}")
    cast || { hidden: [] }
  end

  def festival_cast_off(cast)
    Stage.cleanup rescue nil
    (cast[:hidden] || []).each { |ev| ev.transparent = false rescue nil }
  end

  # GM outline step 6 (rootspire.md 5675-5684): the Council's formal summons,
  # after Eirwen's audience. Kelyn gives the mission, and the roads down open.
  # Context 06 M6-10 (in the Hall, the chapter's question aloud, tied to the
  # Wall), 07 M7-1 (two locks, so both roads; the player picks the first),
  # 08 M8-1 part one (Kelyn's sending-stone), notes 06 E5 (the transfer).
  # Selrae isn't here: she went down after Var the night of the rite (7B.07).
  COUNCIL_SUMMONS_SPOT = [2054, 12, 15, 8]

  def council_summons
    return if flag?(:ch7_started)
    say(["The runner takes you straight to the Council Hall of Seasons."])
    (pbFadeOutIn { Stage.jump(*COUNCIL_SUMMONS_SPOT) } rescue Stage.jump(*COUNCIL_SUMMONS_SPOT)) if $game_map && $game_map.map_id != COUNCIL_SUMMONS_SPOT[0]
    hew = Stage.actor(:hew, 12, 18, 8, graphic: "FT_master_hew_talmire")              # Hew waits in the doorway, cap in his hands
    sayc(["All four crystals in the Hall are lit, and nobody is sitting down.",
          "Summer's chair is still empty. Winter's too: frost on Selrae's cloak, and no Selrae.",
          "KELYN: Heralds. Something is waking below, and Eirwen says it's under the Heartroot.",
          flag?(:festival_casualties) ? "KELYN: (very tired) We buried eleven from the Festival Circle this morning." : nil,
          flag?(:festival_casualties) ? "KELYN: The avatar's cold took them where they stood. I won't bury more." : nil,
          "KELYN: Find our Summer Marshal. And stop whatever is burning the roots.",
          "KELYN: Eirwen says the old door below has two locks. One from the roots, one from the dig.",
          "DARRUS: (not looking up from his ledger) Two ways down, then. The Sap Gate, or Hew's dig.",
          "KELYN: You'll need both roads, in the end. Pick which first."].compact)
    if herald?(:wyn)
      speak(:wyn, "(very quietly) The Sap Gate's mine. Was mine. I'd... like to go first. If I can.",
            "...The Gate first. Please.")
    else
      sayc([cl(:wyn, "(very quietly) The Sap Gate's mine. Was mine. I'd... like to go first. If I can.")])
    end
    say(["HEW: (from the door) And my lads are down the dig NOW. Every hour, they're further down."])
    gate = with_or_is?(:wyn) && !herald?(:wyn) ? _INTL("The Sap Gate, with Wyn.") : _INTL("The Sap Gate.")
    c = pbMessage(_INTL("Which way first?"), [gate, _INTL("Hew's ladder."), _INTL("(Decide later.)")], 2)
    case c
    when 0
      set_flag(:road_first_a)
      sayc([herald?(:wyn) ? cl(:reptin, "Your Gate first, then. Lead on, dear.") : cl(:wyn, "Oh. Thank you. I'll... I'll show you the knot.")])
    when 1
      set_flag(:road_first_b)
      say(["HEW: Good. My ladder's at the east end of the market. I'll be at the top of it."])
    end
    vow = flag?(:promised_their_time) || flag?(:herald_wall_vow)
    who = herald?(:alerion) ? :reptin : :alerion
    sayc(["KELYN: (to the Heralds) Thirty years of summer, and a fire under it. Want your Wall down?",
          "KELYN: Start there.",
          vow ? cl(who, flag?(:promised_their_time) ? "(to you) You said you'd get us home. Here's the road." :
                                                     "(to you) You said we'd bring it down. Here's the road.") : nil,
          "DARRUS: Bring back the Guild's diggers, if there's anything to bring back.",
          "KELYN: (to you, very low) Come back up. All of you. Please."].compact)
    kelyn = Stage.find("Kelyn of Spring")
    Stage.approach(kelyn) if kelyn
    sayc(["KELYN: (pressing a flat grey stone into your hand) A sending-stone. Var has its twin.",
          "KELYN: Speak into it and he hears, wherever he is. He hasn't answered in a week.",
          cl(:alerion, "Then he can't. Or he won't.")])
    give_key(:FT_SENDSTONE)
    Stage.remove_actor(hew) if hew
    set_flag(:ch7_started)
    set_flag(:council_summoned)
    aurora_hue if respond_to?(:aurora_hue)
    ($game_switches[3937] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    state[:goal] = summons_goal
  end

  # Find Var; two ways down, and the door needs both (07 M7-1). The first road
  # you picked comes first.
  def summons_goal
    if flag?(:road_first_a)
      "Find Var below. Road A first: the Sap Gate, in the Root-Tier. (Then Hew's ladder: the door needs both.)"
    elsif flag?(:road_first_b)
      "Find Var below. Road B first: Hew's ladder, east of the market. (Then the Sap Gate: the door needs both.)"
    else
      "Find Var below. Two ways down, and the door needs both: the Sap Gate (Root-Tier), or Hew's ladder (east)."
    end
  end

  # SC 6.03 - They waited (autorun in the market, once you've met Hellen).
  # Purpose: the twins come home to their partners; Lumin names them, and the
  # player sees them land (notes 06 E3, E21; dialogue 06 §4: Lumin names
  # Frostina here, so Alerion's "Frostina" at the orb follows).
  def scene_twins_land
    return if flag?(:twins_met)
    px, py = ($game_player ? [$game_player.x, $game_player.y] : [31, 28])
    # Shade walked out of the Hearth when the bard started: Alberica gave them the minute (notes 06 E21)
    shade = nil
    if with_or_is?(:shade) && Stage.map?
      shade = Stage.actor(:shade, px + 1, py, 2)
      say(["Outside, Shade is sitting on the Hearth's step, very still."])
      sayc([cl(:alberica, "(sitting down beside them) Budge up. ...I'm not saying anything. I'm sitting.")])
    end
    pbSEPlay("Saint7") rescue nil
    raz = fro = lumin = nil
    if Stage.map?
      raz = Stage.actor(:razzilith, px - 2, py - 7, 2, graphic: "FT_razzilith")
      fro = Stage.actor(:frostina, px + 3, py - 8, 2, graphic: "FT_frostina")
    end
    say(["Shadows fall across the market. Two dragons come down out of the gold sky."])
    Stage.walk(raz, [37] + [1] * 6, wait_for: false) if raz
    Stage.walk(fro, [37] + [1] * 6, wait_for: true) if fro
    Stage.wait(10)
    $game_screen.start_shake(5, 8, 16) rescue nil
    pbSEPlay("Earth3") rescue nil
    Stage.cry(:FLYGON)
    say(["They're bigger than houses now: one green-gold, one silver-white.",
         herald?(:meat_meat) ? "The green one lands so hard the cobbles crack. He shoves his head into your chest." :
                               "The green one lands so hard the cobbles crack. He shoves his head into Meat Meat's chest.",
         "RAZZILITH: (a painted thought: a goblin's face, four hundred years of it) ...WAITED.",
         herald?(:meat_meat) ? "(Meat Meat is here. Meat Meat is here now.)" : "MEAT MEAT: (arms round as much of him as she can reach) Meat Meat is here now.",
         cl(:alberica, "(wiping her eyes) Oh, look at the size of him. Who's a big boy? Who waited?")].compact)
    Stage.cry(:ALTARIA)
    say([herald?(:alerion) ? "The white one lands like snow. She looks at you and lowers her head." :
                             "The white one lands like snow. She looks at Alerion and lowers her head to him.",
         herald?(:alerion) ? "Your ring frosts and warms at once." : "His ring frosts and warms at once.",
         "Then she looks at Shade, tilts her head, and hums four notes.",
         "SHADE: (sitting down in the street) ...Hi.",
         cl(:reptin, "(gently) Take your time.")].compact)
    if Stage.map?
      lumin = Stage.actor(:lumin, px - 5, py + 2, 6, graphic: "FT_wennen_lumin")
      Stage.walk(lumin, [3, 3]) if lumin
      Stage.emote(lumin, :exclaim) if lumin
    end
    say(["A rabbit-eared Wennen in priest's robes hurries over, trembling.",
         "LUMIN: I'm Lumin, from their shrine up top. Four hundred years we've sung their names.",
         "LUMIN: Razzilith. Frostina. They haven't touched ground in a century. They waited for you."])
    say(["The dragons lift off together, back to their shrine up on the Canopy-Tier."])
    if raz || fro
      Stage.walk(raz, [4] * 9, wait_for: false) if raz
      Stage.walk(fro, [4] * 9, wait_for: true) if fro
      Stage.remove_actor(raz) if raz
      Stage.remove_actor(fro) if fro
    end
    # Iskra kept warm between Ch3 and Ch11 (whole read T20)
    say(["LUMIN: Our books say a white roc dropped her egg.", "LUMIN: Some winters, a shadow that size still crosses the Wall."]) if lumin
    Stage.leave(lumin, px - 7, py + 2) if lumin
    Stage.remove_actor(shade) if shade
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
      return say(["KELYN: The Still Sky Shrine is in the Root-Tier. The stair's in the woodcarver's workshop.",
                  "KELYN: Watch the rite closely."], event_id)
    end
    # Context 06 M6-2: the four seats named by the seats, and the man in
    # Summer's; 08 M8-3: Var's face, and "thirty years" said twice at once.
    # Scene pass (dialogue 06 §4, Top 5 #3): Darrus has charm and a secret
    # (the Marshal's absence is "routine"); Reptin's "Let me do the talking"
    # pays off at the oath; Kelyn's fear is shown, not spilled.
    selrae_ev = Stage.find("Selrae Vorn")
    darrus_ev = Stage.find("Darrus Fell")
    say(["Four crystals pulse over four chairs: Spring, Summer, Autumn, Winter. One sits empty.",
         "KELYN: Four hundred years late. Or right on time. Welcome home.",
         "KELYN: Kelyn, of Spring. I speak for the Council of Seasons. One chair each."].compact, event_id)
    Stage.turn_to(selrae_ev) if selrae_ev
    say(["SELRAE: (not unkindly) We'd hoped you'd be taller.",
         cl(:alerion, "We'd hoped you'd be warmer."),
         "SELRAE: Selrae Vorn. Winter's chair. Defence, and the old faiths.",
         with_or_is?(:alerion) ? cl(:reptin, "(under his breath) Let me do the talking. Please. I'm begging.") : nil].compact, event_id)
    Stage.turn_to(darrus_ev) if darrus_ev
    say(["DARRUS: (chewing clove bark) Charming. Truly. Darrus Fell, Autumn. Law and trade.",
         "DARRUS: The empty one's Summer's. Our Marshal's: Var Rime-Breaker.",
         "DARRUS: Var went down to look at the roots a week ago. Routine. He's resting, I'm sure.",
         "Over the empty chair, scorched black, hangs a portrait: a big, scarred man in gold.",
         "KELYN: Var. Our Marshal thirty years. He took the seat the spring the summer stuck.",
         "DARRUS: And this arrived the morning after he went down.",
         "A decree: \"Begin excavation beneath the Heartroot.\" Signed with Summer's seal.",
         "In the wax there's a tiny mark: a cracked mirror.",
         cl(:alerion, "That's the hag's sign."),
         "SELRAE: The hag has been dead four hundred years.",
         cl(:meat_meat, "Mirrors remember. She said so. Meat Meat remembers too."),
         "KELYN: Thirty years stuck in this summer. I need people the tree trusts.",
         "KELYN: (very quietly, and only to you) And if the cold comes back... the old cold. Hers.",
         "Her hand has gone white on the arm of her seat. She doesn't seem to notice.",
         "KELYN: I still can't sleep in a cold room.",
         "KELYN: Swear to defend Rootspire from the old cold gods, and you'll be Wardens Emeritus."].compact, event_id)
    speak(:reptin, "Speaker, we'd be honoured. We'd also like to know what we're swearing to.",
          "...What are we swearing to, exactly?") if with_or_is?(:reptin)
    c = pbMessage(_INTL("Swear the Wardens' oath?"), [_INTL("\"We'll guard the pulse.\""), _INTL("\"We just got here.\"")], 0)
    if c == 1
      set_flag(:wardens_refused)
      say(["SELRAE: Good. People who swear oaths in their first hour swear them to anyone.",
           "KELYN: (tightly) ...As you like. The city will still need you.",
           cl(:reptin, "(warmly) And it'll have us, Speaker. Oath or no oath. We're terrible at leaving.")].compact)
    else
      set_flag(:wardens_sworn)
      say(["You put your hands on the living pillar. It's warm, and it beats.",
           "KELYN: Then you're Wardens Emeritus of Rootspire. Sworn against the old cold gods.",
           "KELYN: Take this: sap from the Heart of Spring's first root.",
           "KELYN: It heals what it touches. Slowly and stubbornly, like the tree.",
           cl(:alberica, "Slow and stubborn. Story of my love life. ...Thank you, Speaker.")].compact)
      pbReceiveItem(:LEFTOVERS) rescue nil
    end
    # Context 15 M15-4 A: the crystals remember (the Trials' witnesses, Ch10).
    say(["KELYN: (a hand on the green crystal) The Hall's crystals hear every oath sworn in here.",
         "KELYN: And everything said for or against the ones who swore them. They forget nothing."])
    their_time_beat                  # every mode (context 06 M6-3)
    set_flag(:wardens_emeritus)      # the Root-Tier stair opens either way (switch 3935)
    ($game_switches[SW_WARDENS] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    # (notes 06 E20, dialogue 06 §3: no "Glimmer" before there is one, and no "you three" to five)
    founders = flag?(:glimmer_joined) ? "KELYN: Growth, Memory, Balance. Reptin's, Alberica's, and Glimmer's." :
                                        "KELYN: Growth, Memory, Balance. Reptin's, Alberica's, and the one the songs call Glimmer."
    say(["Over the seats, carved in the living wood: four leaves, four seasons, round a drop of sap.",
         "Under it the motto: BALANCE IS SURVIVAL.",
         founders,
         flag?(:glimmer_joined) ? nil : cl(:shade, "(under their breath) ...Who's Glimmer?"),
         "KELYN: Rootspire was founded on what you left behind.",
         "KELYN: (quieter) And a season too long. Thirty years of summer. I want to know why.",
         "DARRUS: (to the ceiling) And here we go.",
         # (notes 06 E19: one Rootwarden captain, Rheven; Kethan keeps the civic watch)
         "KELYN: Kethan Vale, captain of the Hall watch, says it was no accident. North stair.",
         "SELRAE: The Fractured Halo want the old winter back. They'll move tonight.",
         "SELRAE: If they do, I want the Canopy under martial law, Kelyn. My wardens, at the Rift.",
         "KELYN: No.",
         "SELRAE: (to you, mildly) She always says no. Then something burns, and she says yes.",
         "DARRUS: While we're saying no to things: the Guild wants the lower terraces cut.",
         "KELYN: Every terrace we cut is a root that can't feel the seasons.",
         "KELYN: Grow too fast and the tree forgets what balance is.",
         "SELRAE: Grow too slowly and the cold remembers us.",
         "SELRAE: Expansion is a wall, Kelyn. Walls keep winter out.",
         "KELYN: Walls keep winter in, too.",
         "KELYN: ...We'll vote on it after the festival. As we have for six years.",
         cl(:alberica, "(behind her hand) Four hundred years, and they're still on the same argument.")].compact)
    council_terrace_vote
    say(["SELRAE: There's a rite at the Still Sky Shrine tonight, the festival's first.",
         "SELRAE: Watch it. Closely.",
         "KELYN: The stair down to the Root-Tier is in the woodcarver's workshop, by the old gate."])
    selrae_court if respond_to?(:selrae_court)
    state[:goal] = "The Still Sky Shrine, in the Root-Tier. (The woodcarver's workshop has the stair down.)"
  end

  # Scene pass: the Council's old argument, put to the player (an input in the
  # Council's second half). Read back by Selrae's repeat line and the Hall's
  # summons.
  def council_terrace_vote
    say([flag?(:wardens_refused) ? "KELYN: (to you) Sworn or not, the city will ask you. Walls, or roots?" :
                                   "KELYN: (to you) You're Wardens now. You'll have a voice at that vote. Walls, or roots?"])
    c = pbMessage(_INTL("What do you tell the Council?"), [_INTL("\"Roots. Let the tree grow.\""), _INTL("\"Walls. Keep the cold out.\""),
                                                _INTL("\"We'll listen first.\"")], 2)
    case c
    when 0
      set_flag(:terrace_roots)
      say(["KELYN: (very quietly) Thank you.", "SELRAE: (mildly) Noted. Everything in this Hall is noted."])
    when 1
      set_flag(:terrace_walls)
      say(["SELRAE: Well. Somebody in this city listens.", "KELYN: (tightly) Noted."])
    else
      set_flag(:terrace_listen)
      say(["SELRAE: The first sensible thing anyone's said in this Hall all year."])
      sayc([cl(:reptin, "(under his breath) I did say let me do the talking. This is the talking.")])
    end
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
         "Under a hole in the roof, robed figures kneel round a statue. Glowing sap in jars.",
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
           ask_cl(:alberica, "Was?", "...Was?"),
           "ELINE: We gave it to Summer. Summer has promised us a winter.", "ELINE: Not death. Stillness, at last. The way the Dale was meant to be.",
           "ELINE: Tonight we cool the tree. A little. Just enough to start."].compact, event_id)
      # Context 06 M6-6: the Act I mark, seen by someone who'd care.
      if outsider? && has_key?(:FT_OWLFEATHER)
        say(["Her eyes drift to your collar, and stop.",
             "ELINE: ...You carry her feather. She's looking at you.",
             "ELINE: Four hundred years we've prayed, and she never once looked at us. Lucky child."])
      end
      speak(:reptin, "(pleasantly) Matron, I'm going to ask you nicely to stop. That was the nice part.",
            "Stop. Please.") if with_or_is?(:reptin)
      eline_conversion if respond_to?(:eline_conversion)
      set_flag(:eline_spoke)
    end
    return if !trainer(:eline, event_id)
    set_flag(:rite_stopped)
    set_flag(:heart_given_summer)
    add_counter(:story_beats)
    say(["ELINE: It doesn't matter. Summer has the heart. Summer keeps promises."], event_id)
    # (notes 06 E6: she and her disciples leave on screen, through the back of the
    # Shrine, before their events go for good with the switch)
    leavers = [stage_event(event_id), stage_event("Disciple 1"), stage_event("Disciple 2")].compact
    Stage.leave_all(leavers, 14, 26) if !leavers.empty?
    ($game_switches[SW_RITE_STOPPED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    say(["She slips out through a back door you didn't see. Her disciples go with her.",
         "Outside, the aurora flickers, and the gold steadies.",
         "On the altar, beside the frozen man, someone has left two Full Restores.",
         cl(:alerion, "Bait."),
         cl(:alberica, "Free, though."),
         with_or_is?(:alberica) && with_or_is?(:alerion) ? cl(:alerion, "...Free bait.") : nil].compact)
    pbReceiveItem(:FULLRESTORE, 2) rescue nil
    rheven_at_shrine
    state[:goal] = "Summer has Sephek's heart. Var must sit the Throne on the festival's seventh night; " \
                   "the Root-Gate's sealed till then. Ask round the city, and rest at the Hearth."
  end

  # Context 06 M6-6 (with 15 M15-1): why we wait seven nights. The Marshal's
  # oath (owner's decision 8, 2026-11-06): Var is sworn to sit the empty Summer
  # Throne on the festival's seventh night. Rheven Stormbranch, captain of the
  # Rootwardens, comes in from the dock with his direwolf.
  def rheven_at_shrine
    return if flag?(:rheven_oath_told)
    set_flag(:rheven_oath_told)
    rh = wolf = nil
    if Stage.map?
      rh = Stage.actor(:rheven, 14, 7, 2, graphic: "FT_captain_rheven_stormbranch")
      wolf = Stage.actor(:direwolf, 15, 7, 2, graphic: "Followers/MIGHTYENA")
      Stage.approach(rh) if rh
      Stage.walk_to(wolf, rh.x + 1, rh.y, face: 2) if wolf && rh
    end
    say(["A big man in Rootwarden green comes in at a run, a grey direwolf at his heel."])
    say(["RHEVEN: (a look at you) Wyn. You're meant to be on the Gate. ...Later."]) if herald?(:wyn)
    sayc(["RHEVEN: Rheven Stormbranch, Rootwarden Captain. I heard the rite break from the dock.",
          "RHEVEN: Summer has the Saint's heart? Then Summer answers for it. Not tonight.",
          cl(:alerion, "Why not tonight?"),
          "RHEVEN: Summer's Marshal is sworn to sit the Throne on the festival's seventh night.",
          "RHEVEN: Oldest oath in the city. If Var's alive, he comes up for it.",
          "RHEVEN: If he doesn't, I go down. Till then the Root-Gate stays sealed. Council's word."])
    speak(:reptin, "Seven nights, then. We'll be very patient. Loudly.", "...Seven nights.") if with_or_is?(:reptin)
    sayc(["RHEVEN: Rest at the Hearth. Watch the heat. If it gets worse before then, I want to know.",
          "RHEVEN: And ask round. Somebody in this city's seen where Summer keeps things.",
          cl(:alberica, "Then we ask, sugar. A city this size, somebody's seen something.")])
    if rh
      Stage.leave_all([rh, wolf], 14, 6)
    end
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

module FrostThaw
  module_function

  # The player's second goal (owner's call, 2026-11-05): it grows out of the
  # first. You went to Dougan's Hole for a way home and broke the glass; it
  # brought you home, and them four hundred years out of theirs. The Wall that
  # splits their time from yours stands because the wheel is stuck. That is the
  # whole game's road from here: the third way brings the Wall down.
  def their_time_beat
    return if flag?(:their_time_known)
    set_flag(:their_time_known)
    # Every mode (context 06 M6-3, 12 §6): a Herald hears the Wall's rule too.
    # Herald Reptin's own thought comes after, so his line here is a companion's.
    say(["SELRAE: (to the Heralds) Know where you are. Inside the Wall, four hundred years.",
         "SELRAE: Outside it, weeks. Your Dale's still out there. Still frozen.",
         herald?(:reptin) || !with_or_is?(:reptin) ? "Nobody says anything for a moment." : cl(:reptin, "(very quietly) Weeks. Anduin's out there. It's only been weeks."),
         "SELRAE: The Wall holds because the wheel is stuck.", "SELRAE: Summer won't leave in here. Winter won't leave out there.",
         "SELRAE: Unstick it, and the Wall comes down. Your time and ours, one morning."].compact)
    return their_time_herald if !outsider?
    sayc([cl(:alerion, "(to you) You came home. We came with you.")])
    c = pbMessage(_INTL("The Heralds look at you."), [_INTL("\"I'll get you home.\""), _INTL("\"I'm sorry.\"")], 0)
    if c == 0
      set_flag(:promised_their_time)
      sayc([cl(:reptin, "Then we'd better start with this summer, dear. One stuck season at a time."),
            cl(:meat_meat, "Meat Meat will hold you to it. Meat Meat holds very hard.")])
    elsif flag?(:tried_to_leave)
      sayc([cl(:alberica, "(quietly) You'd have gone, in the chasm. So would I. We're here now. All of us."),
            cl(:alerion, "Sorry's a start. Then help.")])
    else
      sayc([cl(:alberica, "Don't be, darling. You broke a mirror. We'd have broken it anyway."),
            cl(:alerion, "Sorry's a start. Then help.")])
    end
    side_goal(:their_time, "Your own: you broke the glass that brought them. Put the wheel right, and the Wall between their time and yours comes down.",
              done: %i[ending_third_way ending_shatter ending_still_keeper])
  end

  # The Herald version (not Wyn, who came from outside): each Herald's own
  # thought names what they left out there; then the vow (herald_wall_vow).
  HERALD_WALL_THOUGHTS = {
    alberica: "Weeks. Out there the lottery's still drawing names.",
    reptin: "Weeks. Anduin's still at the window. He'll have started counting.",
    alerion: "Weeks. The wyrm's cold is still on the lake. So is Talion.",
    meat_meat: "Weeks. The lady with books is still out there too. Somewhere."
  }

  def their_time_herald
    say([as(herald, HERALD_WALL_THOUGHTS[herald])]) if HERALD_WALL_THOUGHTS[herald]
    c = pbMessage(_INTL("Unstick it?"), [_INTL("\"Then we bring it down.\""), _INTL("\"...Weeks.\"")], 0)
    if c == 0
      set_flag(:herald_wall_vow)
      sayc([herald?(:reptin) ? cl(:alberica, "Then we'd better start with this summer, darling. One stuck season at a time.") :
                               cl(:reptin, "Then we'd better start with this summer, dear. One stuck season at a time.")])
    else
      sayc([herald?(:alberica) ? cl(:reptin, "Weeks is nothing, dear. We've done four hundred years in an afternoon.") :
                                 cl(:alberica, "Weeks is nothing, darling. We've done four hundred years in an afternoon.")])
    end
    side_goal(:their_time, "Your own: unstick the wheel, and the Wall comes down. Your own time is weeks away, outside it.",
              done: %i[ending_third_way ending_shatter ending_still_keeper])
  end
end
