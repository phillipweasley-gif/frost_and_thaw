#===============================================================================
# Frost & Thaw - Rootspire as a living city (part B): its people and its shops
#
# Each of the compendium's shopkeepers says their read-aloud line, sells their
# stock and passes on their rumour; each of the dossier's faction agents and
# the "20 New NPCs" shows their outward face first and lets their secret slip
# when you've earned it (usually by cornering the watcher they sent after you,
# or by finding what they've hidden).
#
# Scene pass (notes/15, dialogue/15): first meetings say what the eye sees, not
# a race word (F4); each faction agent's first meeting shows the watcher they
# sent, so the watcher has a master you've met (E4), and each master owns up
# once you've caught it; asks the player didn't make are choices (E6); every
# box fits the message box.
#===============================================================================
module FrostThaw
  HERALD_NAMES = { alberica: "Alberica", reptin: "Reptin", alerion: "Alerion", meat_meat: "Meat Meat", wyn: "Wyn",
                   glimmer: "Glimmer", shade: "Shade" }

  TEXT.merge!(
    # --- the Verdant Halls --------------------------------------------------------------
    halls_sign: ["THE VERDANT HALLS. The Trunk-Tier's civic ring.",
                 "Rootwarden Hall and its Armory. Run & Bloom. The Glasswater Outfitter. Gem & Thorn.",
                 "Auroral Arms. The Perfumed Root. The Thorned Ledger Bank."],
    armory_sign: ["THE SPIRE ARMORY. Rootwarden Hall.", "\"Guard the pulse. Let neither flame nor frost claim it wholly.\""],
    halls_closed: ["A sap-tea house, shuttered for the festival. A note on the door: GONE TO SEE THE HERALDS."],
    brewery_shut: -> {
      if T.flag?(:cellar_hint)
        ["The old Verdant Cask brewery. Boarded up for thirty years.",
         "You put your ear to the boards. Under the floor, very faintly: chanting.",
         "And a cold draught, in the middle of summer."]
      else
        ["THE VERDANT CASK. A brewery, boarded up.",
         "The sign's paint has peeled into the shape of a snowflake.", "It smells of old beer, and frost."]
      end
    },
    # Who stands at the top of each new district's way in, and says where you are (notes/15 E3).
    halls_greeter: -> {
      next ["CLERK: Shops round the ring, the Rootwarden Hall up in the tower. Mind the ledgers."] if T.flag?(:visited_halls_greeter)
      T.set_flag(:visited_halls_greeter)
      ["CLERK: (looking up from a ledger) Welcome to the Verdant Halls, the civic ring.",
       "CLERK: Shops on every terrace. The Rootwarden Hall's the tower. Mushrooms run the bank.",
       "CLERK: And don't feed the counting spores. They lose count."]
    },
    promenade_greeter: -> {
      next ["DOORMAN: The Atelier, the Shrine of Balance, the bookhouse, the clothier. Autumn's best."] if T.flag?(:visited_promenade_greeter)
      T.set_flag(:visited_promenade_greeter)
      ["DOORMAN: (with a flourish) The Lightfall Promenade. Autumn's quarter of the Canopy.",
       "DOORMAN: Ateliers, a shrine, a bookhouse, a clothier. And the Suncleft upstairs. Shut.",
       "DOORMAN: Everyone here is very well dressed. Try to keep up."]
    },
    whispering_sapling_done: ["The little sapling between the planks has grown a second leaf.", "It leans toward you when you pass."],
    # --- shops --------------------------------------------------------------------------
    run_bloom_corks: ["Crystal-bark shelves of vials, pulsing like captured fireflies.",
                      "A label: MIND THE CORKS. SOME MIXTURES GROW LONELY WHEN OPENED."],
    tirena_maps: -> {
      ["Maps of the Dale pinned over maps of the Dale. Ink on bark, ink on hide.",
       T.flag?(:tirena_maps_moved) ? "The coast on the nearest one has moved again since you last looked." :
                                     "On one, Maer Dualdon's coast is drawn twice, in two places. Both are labelled TRUE."]
    },
    armory_targets: ["Vine-woven targets that bloom when an arrow hits them.", "One has been hit so often it's a bouquet."],
    warden_map: -> {
      T.set_flag(:warden_map_seen)          # one of Kethan's infiltrator clues (048_D)
      lines = ["A glowing map of the Auroral Wall, pinned with Rootwarden markers.",
               "The Bough circle's patrols, in green. Three green pins sit right at the Wall's edge.",
               "Each of the three has a small black X beside it."]
      lines << "Someone has added a fourth X since this morning." if T.flag?(:ch7_started) && !T.flag?(:ash_exposed)
      lines
    },
    perfume_shelf: ["Perfumes swirl in their bottles like coloured smoke.",
                    "Calm Bloom. Valor Mist. Repose Oil. Winter's Whisper.",
                    "One bottle is labelled in violet ink: SUMMER'S BREATH. DO NOT SNIFF BEFORE SLEEP."],
    vault_door: ["The vault door is shaped like coiled vines. It is very, very locked.", "A plaque: DEPOSITS GROW, UNLESS EATEN."],
    cellar_casks: ["Old brewing casks, frost-split. On every one, the cracked snowflake of the Fractured Halo.",
                   "And over it, very carefully, someone has painted a small flame."],
    promenade_sign: ["THE LIGHTFALL PROMENADE. The Canopy-Tier's artisans.",
                     "The Auroral Atelier. The Shrine of Balance. Ink & Ember. Crystal Quill. Frost-Thread.",
                     "Above, on the Upper Sunwalk: the Suncleft Emporium. (Closed.)"],
    # (one age for the summer and the Suncleft: notes/15 E15)
    sunwalk_sign: ["THE UPPER SUNWALK. Gold-leaf bark shutters, warm to the touch. Unnaturally warm.",
                   "SUNCLEFT EMPORIUM. HELION VAEL, ARCHMAGE OF SUMMER. CLOSED THIRTY YEARS."],
    promenade_closed: ["A private house among the leaves. Someone inside is playing a harp very badly, on purpose."],
    four_arches: ["Four arches, each glowing a different season's light: green, gold, red, white.",
                  "Sap-candles burn in bowls of frost-glass under each one."],
    stable_pseudodragon: ["A pseudodragon, the size of a cat, flicks its tail at you.",
                          "It sniffs your hands, finds a wyrmling's scent on them, and sneezes respectfully."],
    frozen_sailor: ["A Corsair, frozen at the oar mid-stroke. Glass all through.", "The lake remembers him. He doesn't move."],
    # --- trainers, after -------------------------------------------------------------------
    warden_bryony_after: ["Seed circle mends what it can. Lately there's a lot more to mend."],
    clerk_fenn_after: ["Recorded: Heralds, victorious. I'll file it under 'unsurprising'."],
    warden_claw_after: ["Claw circle keeps the Armory. The Captain says hold the line.", "Lately the line keeps moving."],
    warden_seed_after: ["Rest a moment. Your Pokémon fought well. So did you, for a legend."],
    halo_frost_wick_after: ["Stillness. Then the flame. Then nothing. That's the whole prayer."],
    halo_soot_ren_after: ["The Frozen Flame doesn't need you to believe. It just needs you to stand still."],
    halo_cinder_oda_after: ["(Oda says nothing. Oda has said nothing for eleven years.)", "(Oda smiles without moving her lips.)"],
    prom_patron_vell_after: ["Autumn always loses gracefully. Then it wins slowly. Remember that."],
    prom_artist_cora_after: ["I'll paint you losing. No? Then winning. ...You're very difficult to compose."],
    run_warden_moss_after: ["I won't say I saw you. I'm not sure I did. Wardens' tunnels are dark."],
    run_smuggler_kett_after: ["Gorran's ore goes up the east shaft. Not that I said. Not that I'm here."],
    revenant_hask_after: ["The revenant settles back into the ice, and is only a frozen man again."],
    revenant_moirin_after: ["The oar of ice cracks in two. The sailor lowers it, gently, as if apologising."],
    revenant_tobe_after: ["At the wheel, the frozen sailor turns his head toward the far shore, and stops."]
  )

  module_function

  def hn(key) = herald?(key) ? "you" : HERALD_NAMES[key]
  def hposs(key) = herald?(key) ? "your" : "#{HERALD_NAMES[key]}'s"

  # Runs a block once per flag: true the first time.
  def first_time?(flag)
    return false if flag?(flag)
    set_flag(flag)
    true
  end

  # The watcher a faction agent sent after you, glimpsed at your first meeting,
  # so the faint thing you see later has a master you've met (notes/15 E4).
  def watcher_glimpse(line)
    say(["(#{line})"])
  end

  #-----------------------------------------------------------------------------
  # 1. Run & Bloom Apothecary: Bryn of Spring (and Nivva Sunwick at the annex)
  #-----------------------------------------------------------------------------
  def bryn(event_id = nil)
    if first_time?(:met_bryn)
      say(["Moist, fragrant air. Crystal-bark shelves of vials, pulsing like captured fireflies.",
           "A man with windburned skin and wheat-pale hair looks up. Sap stains every finger.",
           "BRYN: Bryn of Spring. Mind the corks. Some mixtures grow lonely when opened.",
           "He pauses, as if listening to something under the floor. Then he goes on.",
           "BRYN: You're the Heralds. ...It's alright. It's alright. Sit, if you like.",
           "BRYN: Somebody from Summer's side stole my rebirth sap last month. From a locked case."], event_id)
      watcher_glimpse("In the doorway, something small and twiggy ducks out of sight.")
      say(["BRYN: That? That's mine. It's alright. It only watches. Leave it be."], event_id)
    elsif flag?(:watcher_stalker) && !flag?(:bryn_confessed)
      set_flag(:bryn_confessed)
      say(["BRYN: You caught my Stalker. It's alright. It wasn't watching you. Not really.",
           "He listens to the floor for a long moment.",
           "BRYN: Rot, near the Heartroot. Black and soft, in roots that have never rotted.",
           "BRYN: I've been covering it with moss so nobody panics. I've been covering it with moss.",
           "He pats the moss on the counter flat, very carefully.",
           "BRYN: Summer, I think. Summer, and something older that wears Summer like a glove.",
           "BRYN: Please don't make me say it's something until you know what it is."], event_id)
      sayc([cl(:reptin, "You did right to tell someone. Now you've told the Heralds. That's two someones."),
            cl(:wyn, "(quietly) Hyphora's roots felt it too. Under the gardens. Like a fever.")].compact)
    elsif flag?(:engine_dead)
      say(["BRYN: The rot's stopped spreading. Since something below went quiet.",
           "BRYN: It's alright. It's alright. ...For once, I mean it."], event_id)
    else
      say(["BRYN: Rest your hands. Breathe. The tree's listening; it likes slow breathing."], event_id)
    end
    mart(:run_bloom, event_id)
  end

  # Nivva at the annex stand: the six potions of Alerion's Day 5 live here.
  def nivva_shop(event_id = nil)
    say(["NIVVA: Run & Bloom's annex stand! Red heals. Green's for frost and the long road.",
         "NIVVA: The muddled one's both. Heartroot Renewal. A surprise every time. A good one."], event_id)
    (alerion_potions || alerion_held_potions) if respond_to?(:alerion_potions)
    mart(:run_bloom, event_id)
  end

  #-----------------------------------------------------------------------------
  # 2. The Sap-Smith: Gorran Ashal-Forge, in the forge annex behind Goldlash's
  #-----------------------------------------------------------------------------
  def gorran(event_id = nil)
    if first_time?(:met_gorran)
      say(["Heat thrums through the floor. Metal grows from roots as hammers ring.",
           "A man with ash-grey skin, ember freckles and curling ram's horns wipes sap off his brow.",
           "The air round him is a few degrees warmer than it should be.",
           "GORRAN: Gorran Ashal-Forge. I arm the Rootwardens. Fire remembers what winter forgets.",
           "GORRAN: And anyone else with coin. Mostly the Rootwardens.",
           "He taps the anvil: tap, tap-tap, tap. Like a code. Sparks crackle between his teeth."], event_id)
      watcher_glimpse("Under the bench, a rat with coals for eyes watches the door. It's warm to look at.")
    elsif has_key?(:FT_WARMORE) && !flag?(:gorran_confronted)
      # (notes/15 E6: you picked the ore up in the Run, and you choose to show it)
      if !pbConfirmMessage(_INTL("Put the lump of warm ore on Gorran's anvil?"))
        return say(["GORRAN: Buying, or staring? Staring's free. Buying isn't."], event_id)
      end
      set_flag(:gorran_confronted)
      take_key(:FT_WARMORE)
      say(["You set the lump of black ore from the Smuggler's Run on his anvil. It's still warm.",
           "GORRAN: (very still) Where did you get that.",
           "GORRAN: ...It's from the south. Fell off a boat. Ask Jorik.",
           "His hammer taps the anvil: tap, tap-tap, tap. Faster now.",
           "GORRAN: Special commissions. That's all. I don't ask who wants the work.",
           "GORRAN: Somebody who pays in gold still warm from somewhere very deep.",
           "GORRAN: Leave it, Heralds. Some fires you don't stand close to."], event_id)
      sayc([cl(:meat_meat, "Fire man is lying. Meat Meat knows lying. Meat Meat was raised by it."),
            # (Jorik begged not to be named: dialogue 15 #14)
            flag?(:jorik_confessed) ? cl(:reptin, "(quietly) Jorik asked us not to say his name. Gorran just said it for him.") : nil,
            cl(:alerion, "Same boat Jorik's fell off. Busy boat.")].compact)
    elsif flag?(:watcher_ember_rat) && !flag?(:gorran_rat_owned)
      set_flag(:gorran_rat_owned)
      say(["GORRAN: (not looking up) You caught my rat. It follows heat. I follow the money.",
           "GORRAN: It watches the Suncleft for me. Somebody pays me to know who goes near it.",
           "GORRAN: Don't ask me who. I've never asked."], event_id)
    elsif flag?(:engine_dead)
      say(["GORRAN: The commissions stopped. The gold stopped. Nobody's come to collect.",
           "GORRAN: ...Good. My forge sleeps better. I didn't know it had nightmares."], event_id)
    else
      say(["GORRAN: Voices in the flame at night? Gossip. Fire crackles. That's what fire does."], event_id)
    end
    mart(:sap_smith, event_id)
  end

  #-----------------------------------------------------------------------------
  # 3. Auroral Atelier: Lumea Keth (Autumn, the Court of Splendor)
  #-----------------------------------------------------------------------------
  def lumea(event_id = nil)
    if first_time?(:met_lumea)
      say(["Shards turn in the air, scattering illusions of wings across the walls.",
           "A woman with maple-red hair looks you over. Her amber eyes hardly ever blink.",
           "She laughs, as if on a stage. Every chuckle chosen.",
           "LUMEA: Lumea Keth. Lightcraft, glamour, spectacle. Seeking truth? Or something prettier?",
           "She touches your arm, too lightly, too soon. Her eyes flick over your face: sketching you.",
           # (notes/15 E8e, dialogue §5: the fox is out on the Promenade, and she wants you to listen)
           "LUMEA: One of my illusions got out. A fox of leaves and light. It's on the Promenade.",
           "LUMEA: If it talks to you, do let it. It says such lovely things."], event_id)
      watcher_glimpse("A cloud of pale moths lifts off the ceiling as you turn, and settles again behind you.")
    elsif flag?(:atelier_fox_seen) && !flag?(:lumea_exposed)
      set_flag(:lumea_exposed)
      say(["LUMEA: You found my fox. You've seen what it shows. The golden age. The warm crown.",
           "LUMEA: It's art. Art for people who've been cold for four hundred years.",
           "LUMEA: Summer will come back, and it'll be glorious. Autumn will have dressed the stage.",
           "Her laugh doesn't land this time. Her eyes don't blink at all.",
           "LUMEA: Eternal Summer answers Eternal Winter. The Court agrees. Everyone who matters."], event_id)
      sayc([cl(:alberica, "Darling, 'eternal' anything is just a cage with good lighting."),
            cl(:reptin, "Seasons end. That's how you know they were seasons.")].compact)
    elsif (flag?(:watcher_moth_swarm) || flag?(:watcher_rune_beetle)) && !flag?(:lumea_watchers_owned)
      set_flag(:lumea_watchers_owned)
      say(["LUMEA: My little critics. You've been collecting them.",
           "LUMEA: They take your reading. What moves you, what bores you, who you look at first.",
           "LUMEA: Autumn likes to know what to paint. Don't look so hurt. It's flattering."], event_id)
    else
      say(["LUMEA: Do look around. All of it's for sale. Even the parts that aren't there."], event_id)
    end
    mart(:atelier, event_id)
  end

  # Her escaped illusion: a fox of leaves and light that whispers Autumn's line.
  def atelier_fox(event_id = nil)
    say(["A fox of swirling leaves and light pads up to you. It sits, looks up, and whispers:",
         "\"Choose warmth.\"",
         "Inside its leaves, for a moment: a golden city, and a crowned figure with no face.",
         "Everyone in the city is smiling. Everyone.",
         "Then it scatters into sparks."], event_id)
    set_flag(:atelier_fox_seen)
    set_self_switch(event_id, "A")
  end

  #-----------------------------------------------------------------------------
  # 4. Glasswater Outfitter: Tirena Loch-Vine
  #-----------------------------------------------------------------------------
  def tirena(event_id = nil)
    if first_time?(:met_tirena)
      say(["Fur, leather, climbing gear and frost-elk tack. A warm stream runs under the floor.",
           "A rangy woman in a ranger's coat taps a crate with her boot.",
           "TIRENA: You'll want better gear than that. Tirena Loch-Vine. I map the Dale.",
           "TIRENA: Mapped. Map. The maps change when the aurora shifts. I've stopped arguing.",
           "She digs in the crate and holds something out."], event_id)
      # (notes/15 E19: it does what she says)
      say(["TIRENA: A compass from the frozen side. It doesn't point north.",
           "TIRENA: It points where the world's thin. In here it just spins.",
           "TIRENA: Out on the tiers it finds things. I've no use for thin places."])
      give_key(:FT_AURORALCOMPASS)
    else
      set_flag(:tirena_maps_moved) if flag?(:ch7_started)
      say(["TIRENA: The coast moved again this morning. Took my tea with it, almost."], event_id)
    end
    mart(:outfitter, event_id)
  end

  #-----------------------------------------------------------------------------
  # 5. The Wind-Glass Library's counter: Solvaran
  #-----------------------------------------------------------------------------
  def solvaran(event_id = nil)
    if first_time?(:met_solvaran)
      say(["Books float in silent orbit round a counter of clear bark. Their pages breathe.",
           "A silver-browed elf doesn't look up.",
           "SOLVARAN: Solvaran. I sell what the leaves let me copy. The originals stay with the tree.",
           "SOLVARAN: There's a codex locked beneath this floor that nobody's allowed to read.",
           "SOLVARAN: I tell everyone that. It saves them asking. It never stops them wondering."], event_id)
    else
      say(["SOLVARAN: Scrolls. Lore. Memory, copied out. The original stays with the tree."], event_id)
    end
    mart(:solvaran, event_id)
  end

  #-----------------------------------------------------------------------------
  # 6. Shrine of Balance: Ysera Dorn (Winter, the Order of Balance)
  #-----------------------------------------------------------------------------
  def ysera(event_id = nil)
    if first_time?(:met_ysera)
      say(["Sap-candles burn in bowls of frost-glass under four arches of seasonal light.",
           "A woman pale as moonlit snow, ice-lilies in her braids, speaks in short, heavy sentences.",
           # (her warning in her own lens, the wheel of rebirth: dialogue 15 §2)
           "YSERA: The soul-flow is blocked. The dead go down into the roots. They don't come back.",
           "She touches her temple. A vision, passing.",
           "YSERA: Ysera Dorn. The Order of Balance. We keep the wheel of rebirth turning.",
           "YSERA: Nothing is wrong. All is well.",
           "She sighs. She is very bad at lying."], event_id)
      sayc([cl(:alberica, "Sweetheart, I've lied to dukes. That sigh would get you hanged."),
            cl(:alerion, "Then we didn't hear anything.")].compact)
      watcher_glimpse("Behind her, something veiled and pale drifts out through the wall.")
    elsif flag?(:watcher_veil_shade) && !flag?(:ysera_warned)
      set_flag(:ysera_warned)
      say(["YSERA: You saw my Shade. Then you know I watch who walks with Autumn, and with Summer.",
           "YSERA: The truth. Souls meant for rebirth aren't returning. They're being harvested.",
           "YSERA: I have no proof. My divinations fail every time I look down.",
           "She touches the bridge of her nose.",
           "YSERA: A dragon of light is trapped down there. I hear it. It doesn't sing. It burns.",
           "YSERA: Go carefully. Some of my order have started to like the warmth."], event_id)
      sayc([cl(:meat_meat, "Cold table had a dragon. Meat Meat heard it. Under the hammers."),
            flag?(:brightmane_answered) ? cl(:glimmer, "(a hand on his chest) Brightmane showed me that. I thought it was a dream.") : nil].compact)
    else
      say(["YSERA: Balance is not stillness. Pray for the wheel. Not for the cold."], event_id)
    end
    if pbConfirmMessage(_INTL("Ask Ysera for the Shrine's blessing of rest? (Your Pokémon are healed.)"))
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      say(["YSERA: Rest. The wheel turns for you too."])
    end
    mart(:balance, event_id)
  end

  #-----------------------------------------------------------------------------
  # 7. The Still Sky Shrine's black market is cut (story/15 §3, 15.31; owner's call
  # 2026-11-07): Eira Voss is met once, in the Frozen Cellar (048_D). Her stall's
  # event is gone from the Shrine (build_rootspire_life); this answers an old save.
  #-----------------------------------------------------------------------------
  def eira_black_market(event_id = nil)
    say(["Frost on the sconces where somebody used to sell things. Nobody sells anything here now."], event_id)
  end

  #-----------------------------------------------------------------------------
  # 8. Rootwarden Hall: Captain Kethan Vale (the Hall's own business is in part D)
  #-----------------------------------------------------------------------------
  def kethan(event_id = nil)
    first = first_time?(:met_kethan)
    if first && with_or_is?(:wyn)
      # Wyn's own captain: Wyn doesn't need him introduced (context 15 §6).
      say(["Weapons hang by root-shields. Captain Kethan frowns over a map of the Wall.",
           "He cracks his knuckles without looking up: pop, pop, like ice splitting far away.",
           herald?(:wyn) ? "KETHAN: Wyn. You left your post at the Sap Gate. Then you left the century." :
                           "KETHAN: Wyn. You left the Sap Gate on festival night. We'll talk about that.",
           "KETHAN: (to the others) Kethan Vale. Captain. I keep order in the civic ring.",
           "KETHAN: Patrols hear hammers under the Heartroot at night. Trees don't dream with hammers."], event_id)
      sayc([cl(:alerion, "Skytower. Goliaths. Our Skytower?"),
            "KETHAN: Four hundred years on. We remember who carried our wounded down the mountain."].compact)
    elsif first
      say(["Weapons hang by root-shields. A huge, stone-grey man frowns over a map of the Wall.",
           "His cloak is Rootwarden green. Frost-blue tattoos run down his arms like rivers on a map.",
           "KETHAN: If you're here to help, good. If not, don't.",
           "He cracks his knuckles: pop, pop, like ice splitting far away. His stare lasts too long.",
           "KETHAN: Captain Kethan Vale, of the Skytower goliaths. I keep order in the civic ring.",
           "KETHAN: Patrols hear hammering under the Heartroot. Rheven says the tree's dreaming.",
           "KETHAN: Trees don't dream with hammers."], event_id)
      sayc([cl(:alerion, "Skytower. Goliaths. Our Skytower?"),
            "KETHAN: Four hundred years on. We remember who carried our wounded down the mountain.",
            cl(:reptin, "Then we're in good hands. Large ones. Very large.")].compact)
    end
    watcher_glimpse("Up in the rafters, a grey thing thin as thread hangs still, watching the door.") if first
    if flag?(:watcher_wraithling) && !flag?(:kethan_wraith_owned)
      set_flag(:kethan_wraith_owned)
      say(["KETHAN: (pop) You caught the Hall's wraithling. Mine, and Ysera's.",
           "KETHAN: It keeps the Heartroot's doors. Somebody's been going through them at night.",
           "KETHAN: It saw the threads between people. Not the face."], event_id)
    end
    kethan_business(event_id) if respond_to?(:kethan_business)
    if flag?(:wyn_barred) && !flag?(:wyn_bar_lifted)
      return say(["KETHAN: The stores are closed to you. Council's word, not mine. Until it says otherwise."])
    end
    if pbConfirmMessage(_INTL("Look at the Hall's stores?"))
      mart(:warden_hall, event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 9. Ink & Ember Bookhouse: Mirna Cowl (and Avarice's mirror-glass letters)
  #-----------------------------------------------------------------------------
  def mirna(event_id = nil)
    if first_time?(:met_mirna)
      say(["Quills write by themselves. The books breathe, and their titles change with the light.",
           "A half-elf archivist peers at you over a monocle.",
           "MIRNA: Mirna Cowl, Ink & Ember. Stories rot when they're left untold.",
           "MIRNA: Buy, borrow, or read standing up. I'll glare. That's included."], event_id)
    else
      say(["MIRNA: Back for a story? Everything in here has one. Some have two. The second's worse."], event_id)
    end
    mart(:ink_ember, event_id)
  end

  def mirror_letters(event_id = nil)
    if !flag?(:met_mirna)
      return say(["A locked case of letters written on thin sheets of mirror-glass."], event_id)
    end
    if first_time?(:mirror_letters_read)
      say(["MIRNA: (quietly) You want the case. Everyone who's anyone wants the case.",
           "MIRNA: Letters on mirror-glass. From before the Reversal. Signed with one letter: A.",
           "She unlocks it. The glass is cold, and the writing moves, as if it's being written now.",
           "\"Variables that refuse to die are the only ones worth measuring.\"",
           "\"The goblin's heart is a seed. The seed is a key. The key is mine.\"",
           "\"Tell the merchant to keep selling mirrors. Every glass is an eye.\"",
           "MIRNA: I stopped reading them when one of them answered."], event_id)
      sayc([herald?(:meat_meat) ? "(Your hands have gone cold. You know that handwriting. You were written in it.)" :
                                  cl(:meat_meat, "(very small) Meat Meat knows that writing. Meat Meat does not want to."),
            cl(:alberica, "Lock it, darling. Lock it and put a book on it. A heavy one.")].compact)
    else
      say(["The letters lie in their case. One, you'd swear, has a new line at the bottom."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 10. Crystal Quill Scrollworks: Filgen Rootfoot
  #-----------------------------------------------------------------------------
  def filgen(event_id = nil)
    if first_time?(:met_filgen)
      say(["Quartz pods glow with drifting sigils. Scrolls unspool from the ceiling like vines.",
           "A tiny man in a sap-stained apron waves both arms at once.",
           "FILGEN: We grow our spells here! Filgen Rootfoot! Every scroll's a cutting! Some bite!",
           # (notes/15 F5: the shop sells TMs; say what they are, not their D&D names)
           "FILGEN: Fire, haste, frost, the lot. Grown in sap, picked fresh."], event_id)
    else
      say(["FILGEN: Fresh crop this morning! Mind the fire one, it's very ripe."], event_id)
    end
    mart(:crystal_quill, event_id)
  end

  def blank_scrolls(event_id = nil)
    if !flag?(:ch7_started)
      return say(["A rack of blank sap-scrolls, waiting to be written on. Perfectly ordinary. Probably."], event_id)
    end
    say(["The rack of blank sap-scrolls is whispering. Names. Over and over, very softly.",
         "Yours is one of them. So is Var Rime-Breaker's.",
         "So is another, whispered loudest of all: Helion.",
         "FILGEN: (behind a pod) They only do that at night! It's not night! WHY IS IT DOING THAT?"], event_id)
    set_flag(:scrolls_whispered)
  end

  #-----------------------------------------------------------------------------
  # 11. Gem & Thorn Exchange: Arvoss Ember-Scale
  #-----------------------------------------------------------------------------
  def arvoss(event_id = nil)
    if first_time?(:met_arvoss)
      say(["Crystal roots form glittering fountains.",
           "A broad man with copper scales taps each gem in turn. They hum faintly.",
           "ARVOSS: Arvoss Ember-Scale. I buy, I sell, I listen. Stones remember.",
           "ARVOSS: That one by the window hums sometimes. Only when it's carried past certain roots.",
           "ARVOSS: I keep it by the window so it can see where it wants to go."], event_id)
    else
      say(["ARVOSS: Stones remember. People forget. That's why I'm in stones."], event_id)
    end
    mart(:gem_thorn, event_id)
  end

  def humming_gem(event_id = nil)
    say(["A gem the size of an egg, by the window. It hums when you lift it.",
         "Turn it toward the market well, the sealed Root-Gate, and it hums louder. Much louder.",
         "When you turn back, it stops, like something holding its breath."], event_id)
    set_flag(:gem_vibrates)
  end

  #-----------------------------------------------------------------------------
  # 12. The Perfumed Root: Lirielle's own shop (and Summer's Breath)
  #-----------------------------------------------------------------------------
  def perfumer(event_id = nil)
    say(["Perfumes swirl like coloured smoke. The shop smells of moss, mint, and maybe memory.",
         "LIRIELLE: (notebook out) Welcome to the Perfumed Root! Scents wake old memories."], event_id)
    if !flag?(:summers_breath) && flag?(:lirielle_dream)
      if pbConfirmMessage(_INTL("LIRIELLE: Try Summer's Breath? It gives dreams. One sniff."))
        perfume_prophecy
      end
    end
    mart(:perfumed_root, event_id)
  end

  # Summer's Breath (prophecy): the "Perfume Prophecy" (night event 8), taken awake.
  def perfume_prophecy
    set_flag(:summers_breath)
    say(["You breathe in. Warm rain. Then smoke.",
         "Roots, burning from the inside. Sap whistling in its channels like kettles.",
         "A great shape of black crystal and iron, wings folded, chained in a ring of twenty stones.",
         "Its chest opens. Inside, something blue beats, and isn't its own heart.",
         "A woman's voice, pleased: \"Tomorrow, it flies.\"",
         "You're on the shop floor. Lirielle is fanning you with her notebook."])
    sayc(["LIRIELLE: (her fur smelling of charred flowers) That's the one the air keeps bringing me.",
          cl(:reptin, "(steadying you) Twenty stones. The Twenty Stones. Under Dougan's Hole."),
          cl(:alerion, "Under us.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 13. Verdant Stables: Thim Wicker
  #-----------------------------------------------------------------------------
  def thim(event_id = nil)
    if first_time?(:met_thim)
      say(["Stalls carved from thick roots, glowing moss over the pens. Frost-elk lift their heads.",
           "A halfling with straw in her hair smiles.",
           "THIM: Mind their tempers. Thim Wicker. Tack, feed and the odd friendly beast.",
           "THIM: The old elk won't eat. She stands with her ear to the floor all day, listening."], event_id)
    else
      say(["THIM: Feed's fresh. Tempers are not. Mind your fingers."], event_id)
    end
    mart(:stables, event_id)
  end

  # The beasts for sale: a frost-elk (Stantler) or a pseudodragon (Dratini), once each.
  def stable_beast(event_id = nil)
    say(["A frost-elk with rime in her antlers stamps once, and looks down at the floor. Listening."], event_id)
    opts = []
    opts << [:STANTLER, 30, 6000, "a frost-elk"] if !flag?(:bought_elk)
    opts << [:DRATINI, 25, 9000, "a pseudodragon"] if !flag?(:bought_pseudodragon)
    return say(["THIM: You've got the best of my stable already. Treat them well."]) if opts.empty?
    names = opts.map { |_, _, price, desc| _INTL("{1} (${2})", desc.capitalize, price) }
    c = pbMessage(_INTL("THIM: Want one of them? They'll go with someone who'll walk them."), names + [_INTL("Not today")], names.size)
    return if !c || c < 0 || c >= opts.size
    sp, lv, price, desc = opts[c]
    return say(["THIM: That's not enough, love. They eat a lot."]) if $Trainer.money < price
    pk = Pokemon.new(sp, lv)
    pk.calc_stats
    return if !pbAddPokemon(pk)
    $Trainer.money -= price
    set_flag(sp == :STANTLER ? :bought_elk : :bought_pseudodragon)
    say(["THIM: There. Walk them every day.",
         "THIM: And if #{sp == :STANTLER ? 'she' : 'it'} looks at the floor and goes quiet, listen too."])
  end

  #-----------------------------------------------------------------------------
  # 14. Mirror-Dust Curiosity Shop: Jast Penumbran
  #-----------------------------------------------------------------------------
  def jast(event_id = nil)
    if first_time?(:met_jast)
      say(["A cramped shop, its signs painted backwards. Reflections move before the objects do.",
           "The shopkeeper's reflection smiles first. Then the shopkeeper does: a tiny old man.",
           "Wispy white hair. Huge black pupils, like polished obsidian. He blinks, rapid as a moth.",
           "JAST: Everything is real somewhere. Jast Penumbran. You'll want the lantern.",
           "JAST: Don't ask which lantern. You were about to.",
           "He talks to a polished brass bowl while you look round. The bowl seems to answer."], event_id)
      watcher_glimpse("On a shelf, a little figure made of mirror-shards clicks its head round to watch you.")
    end
    if flag?(:watcher_homunculus) && !flag?(:jast_confessed)
      set_flag(:jast_confessed)
      say(["JAST: (to the bowl) They caught it. Yes. I know.",
           "JAST: My homunculus. It counts who carries shards, and who says her name.",
           "JAST: She pays very well and never visits. ...I'd like her to keep not visiting."], event_id)
      say(["He rubs the brass bowl with his sleeve, as if to make it feel better."])
    end
    if !($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue true)
      say(["JAST: The Lantern of Revealing. Every watcher in this city shows up in its light.",
           "JAST: Spring's, Winter's, Autumn's, Summer's, the Halo's. Even hers. Especially hers.",
           "JAST: Three thousand. You were going to ask. The answer's always three thousand."])
      if pbConfirmMessage(_INTL("Buy the Lantern of Revealing for $3000?"))
        if $Trainer.money >= 3000
          $Trainer.money -= 3000
          give_key(:FT_REVEALLANTERN)
          set_switch(SW_LANTERN, true)
          say(["JAST: (to the brass bowl) They bought it. Yes. I know. I know you knew."])
        else
          say(["JAST: Not today, then. It'll wait. It's patient. Unlike me."])
        end
      end
    else
      say(["JAST: Mirror shards? I buy those. For a collector.",
           "His reflection, in the bowl, is shaking its head at you. Very slightly."], event_id)
      # (notes/15 E19, F14: he does buy them)
      n = ($PokemonBag.pbQuantity(:FT_STILLSHARD) rescue 0).to_i
      if n > 0 && pbConfirmMessage(_INTL("Sell Jast your Shards of Stillness? (${1} each, {2} in all)", 300, n))
        $PokemonBag.pbDeleteItem(:FT_STILLSHARD, n) rescue nil
        $Trainer.money += 300 * n
        say(["JAST: (counting them into a velvet bag without looking) She'll be so pleased. I'm not."])
      end
    end
    mart(:mirror_dust, event_id)
  end

  def jast_mirror(event_id = nil)
    if first_time?(:jast_mirror_seen)
      say(["A tall mirror in the back, its glass a patchwork of shards fitted together like a map.",
           "In it, the Dale. Frozen solid. A tree of black crystal where the World Tree should be.",
           "A woman on a throne of ice, smiling. She has no face. You know her anyway."], event_id)
      # (notes/15 E10: he comes up behind you, so he's there when he speaks)
      jev = Stage.find("Jast Penumbran")
      Stage.approach(jev) if jev
      say(["JAST: (at your shoulder) Possible futures. The ones where she wins. She likes them all.",
           "JAST: I collect the shards. I don't look. ...I look a little."], event_id)
      sayc([cl(:alerion, "Break it."),
            "JAST: Then she'd only see us through the pieces. Shards are worse. Ask the Halo."])
    else
      say(["The patchwork mirror shows the Dale, frozen. Today the black tree has more branches."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 15. Auroral Arms: Brogar Frostvein
  #-----------------------------------------------------------------------------
  def brogar(event_id = nil)
    if first_time?(:met_brogar)
      say(["Blue-white light pulses across racks of frost-runed steel.",
           "A dwarf with an arm of clear crystal grunts at you.",
           "BROGAR: Brogar Frostvein. Guards' gear, mostly. Heralds' gear, today. Steel likes cold.",
           "His crystal arm hums. He frowns at it.",
           "BROGAR: Does that when someone's forging. Deep down. Nobody forges down there.",
           "BROGAR: So it shouldn't."], event_id)
    elsif flag?(:engine_dead)
      say(["BROGAR: Arm's gone quiet. First time in a year. ...I miss the hum. Don't tell anyone."], event_id)
    else
      say(["BROGAR: Hum's louder today. Somebody's working late, down there."], event_id)
    end
    mart(:auroral_arms, event_id)
  end

  #-----------------------------------------------------------------------------
  # 17. Thorned Ledger Bank: the Accountancy (a fungal collective). A real bank:
  # what you leave grows a little every night you sleep at the Hearth.
  #-----------------------------------------------------------------------------
  def accountancy(event_id = nil)
    if first_time?(:met_accountancy)
      say(["Vine abaci count themselves on the walls. Click. Click-click.",
           "A myconid clerk tilts its cap at you. Its voice blooms in your head, very precise.",
           "THE ACCOUNTANCY: (Deposits grow, unless eaten. We are the Accountancy. We are several.)",
           "THE ACCOUNTANCY: (Leave coin with us. Each night you sleep here, it grows. A little.)"], event_id)
    end
    bank = state[:bank] || 0
    say(["THE ACCOUNTANCY: (Your account: $#{bank}. Growing.)"], event_id) if bank > 0
    c = pbMessage(_INTL("THE ACCOUNTANCY: (Transaction?)"), [_INTL("Deposit"), _INTL("Withdraw"), _INTL("Nothing")], 2)
    case c
    when 0
      amount = [($Trainer.money / 1000) * 1000, 0].max
      return say(["THE ACCOUNTANCY: (You have nothing to grow.)"], event_id) if amount <= 0
      opts = [1000, 5000, 10000, amount].uniq.select { |a| a <= $Trainer.money }
      n = pbMessage(_INTL("Deposit how much?"), opts.map { |a| _INTL("${1}", a) } + [_INTL("Cancel")], opts.size)
      return if !n || n < 0 || n >= opts.size
      $Trainer.money -= opts[n]
      state[:bank] = bank + opts[n]
      say(["THE ACCOUNTANCY: (Planted.)"], event_id)
    when 1
      return say(["THE ACCOUNTANCY: (There is nothing here of yours.)"], event_id) if bank <= 0
      $Trainer.money += bank
      state[:bank] = 0
      say(["THE ACCOUNTANCY: (Harvested: $#{bank}. Come again.)"], event_id)
    end
  end

  # Called each night at the Hearth: deposits grow 2%.
  def bank_grow
    bank = state[:bank] || 0
    state[:bank] = bank + [(bank * 0.02).floor, 0].max if bank > 0
  end

  def counting_spore(event_id = nil)
    if !flag?(:ch7_started) && !flag?(:met_accountancy)
      return say(["A small counting spore bobs over a ledger, ticking off columns."], event_id)
    end
    say(["A small counting spore bobs over a ledger. It isn't counting.",
         "Very softly, over and over, it is saying a name. \"A-va-rice. A-va-rice. A-va-rice.\"",
         "THE ACCOUNTANCY: (Spore echo. It heard the name somewhere. In the deep accounts.)",
         "THE ACCOUNTANCY: (We do not know whose account it is.)",
         "THE ACCOUNTANCY: (We have checked. The account does not exist. It is very large.)"], event_id)
    set_flag(:spore_whispered)
  end

  #-----------------------------------------------------------------------------
  # 16. The Suncleft Emporium: Helion Vael's shuttered vault
  #-----------------------------------------------------------------------------
  # The door (build_rootspire_life: the closed page calls this alone). Once the
  # lock gives, you go straight in (notes/15 F13); a shut door bumps you back.
  def suncleft_door(event_id = nil)
    say(["The Suncleft's gold-leaf shutters are warm. Far too warm, like a fevered forehead.",
         "Dust shimmers in waves of heat behind the glass. The shelves are full. Unsettlingly full."], event_id)
    if (flag?(:watcher_ember_rat) || flag?(:warm_window_seen)) && !flag?(:suncleft_open)
      say(["Down by the step, scorch-marks lead under the shutters: little footprints, in embers.",
           "Something small and hot came this way. The lock is warm enough to bend."])
      if pbConfirmMessage(_INTL("Force the warm lock?"))
        set_flag(:suncleft_open)
        set_switch(SW_SUNCLEFT_OPEN, true)
        say(["The lock gives like toffee. The door swings in on a breath of heat."])
        pbSEPlay("Door exit") rescue nil
        return transfer(2194, 11, 14, 8)
      end
    end
    pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
  end

  def scene_suncleft_enter
    set_flag(:suncleft_entered)
    sayc(["Dust hangs in slow waves of heat. Nothing's been touched in decades. Nothing's rotted.",
          "Firestones on velvet. Charcoal in jars. Flame-orbs that are still warm.",
          cl(:alberica, "Thirty years shut and not a cobweb. Somebody's been dusting. Somebody warm."),
          cl(:wyn, "(very quietly) The floor's warm. Like... like it's breathing out.")].compact)
  end

  def helion_mural(event_id = nil)
    say(["A mural across the back wall: a figure of molten gold, flame for hair.",
         "Its crown is a set of burning antlers. Under it: HELION VAEL, ARCHMAGE OF SUMMER.",
         "As you look, the gold moves. A recorded illusion, woken by the warmth of your hand."], event_id)
    say(["HELION: (warm as a hearth, and as hungry) Ah. Saplings. Come for the old Summer?",
         "HELION: Summer was never lost, child. Summer went down. Into the roots, to the forge.",
         "HELION: There is a lady there who knows what a season is worth. Every soul is a coal.",
         "The gold flares, hot enough to feel on your face.",
         "HELION: When the engine wakes, I'll be its herald. Eternal Summer. No more winter.",
         "HELION: No more anything.",
         "The illusion smiles, and runs out, and is only paint."])
    sayc([cl(:reptin, "'No more anything.' He said it like it was the good part."),
          cl(:alerion, "He went down to wait for it. Thirty years. He's still waiting.")].compact)
    set_flag(:helion_known)
  end

  def suncleft_shelves(event_id = nil)
    if flag?(:suncleft_looted)
      return say(["The shelves are bare where you took what you took. The rest is warm, and waiting."], event_id)
    end
    say(["Summer's goods, untouched and warm: firestones, charcoal, flame-orbs, a heat rock.",
         "Nobody is coming back for them. Somebody might be coming back for you."], event_id)
    return if !pbConfirmMessage(_INTL("Take what's left on the shelves?"))
    set_flag(:suncleft_looted)
    SUNCLEFT_SHELVES.each { |it| give(it) }
    sayc([cl(:meat_meat, "Meat Meat is not stealing. Meat Meat is rescuing from bad man."),
          cl(:reptin, "We'll call it confiscation. The paperwork can catch up.")].compact)
  end

  def suncleft_hatch(event_id = nil)
    say(["A hatch in the floor, iron, very warm. Below it, a shaft runs straight down into the dark.",
         "Heat breathes up out of it in slow pulses. Far, far below: hammers.",
         "The shaft has been sealed from below with molten iron."], event_id)
    set_flag(:suncleft_tunnel)
    sayc([cl(:alerion, "Somebody poured it shut. From below."),
          flag?(:brightmane_answered) ? cl(:glimmer, "(quietly) Brightmane said I'd know the fire. That's not it. That's its chimney.") :
                                        cl(:glimmer, "(very quietly) That's not the fire. That's its chimney.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 18. Frost-Thread Clothier: Maera Vell (Autumn) and the crowning robes
  #-----------------------------------------------------------------------------
  def maera(event_id = nil)
    if flag?(:autumn_fell) && flag?(:heist_exposed)
      # With Darrus fled, Maera carried the robes below herself, and fell at the Forge (034 autumn_hand).
      say(["A boy with pins in his mouth is minding the shop. The dress form in the back stands empty.",
           "APPRENTICE: Mistress Vell took the gold robes down herself. For a steady hand, she said.",
           "APPRENTICE: That was when Warden Fell ran. She didn't come back up.",
           "APPRENTICE: ...The scarves are still half price. She'd want them sold."], event_id)
      set_flag(:maera_apprentice_heard)        # (a witness at the trial: 036 WITNESSES)
      return mart(:frost_thread, event_id)
    end
    if first_time?(:met_maera)
      say(["Cloth changes colour as you pass: winter blue, spring green, autumn gold.",
           "A tailor with ruddy cheeks and dye-stained fingers hums as she works.",
           "MAERA: In Rootspire, prophecy chooses fashion. Maera Vell.",
           "MAERA: Oh, you'd look divine in green. And you. And YOU.",
           "Every compliment lands exactly where it was aimed. The tune changes with her mood."], event_id)
      watcher_glimpse("A ferret-thin creature slips under a dress form, carrying a single thread of yours.")
      # (notes/15 E6: you choose to bring Summer up)
      if pbConfirmMessage(_INTL("Ask Maera about Summer?"))
        sayc(["MAERA: Summer? Oh, nobody's wearing Summer this year.",
              "(Her eyes go flat for a moment. Then she's humming again.)"])
      end
    elsif flag?(:robes_seen) && !flag?(:maera_confronted)
      set_flag(:maera_confronted)
      say(["MAERA: You looked at the commission. That was private.",
           "MAERA: The Autumn Warden ordered them. Crowning robes, for a coronation that's coming.",
           "MAERA: I don't ask who wears them. I measure. Tall. Slender. Odd at the collar.",
           "She stops humming.",
           "MAERA: I've never been sent a face."], event_id)
      sayc([herald?(:meat_meat) ? "(No face. Razzilith said a no-face thing too. You don't like it.)" :
                                  cl(:meat_meat, "No face. Razzy said a no-face thing too. Meat Meat does not like it."),
            cl(:alberica, "Robes for someone nobody's met. Darling, that's not fashion. That's a warrant.")].compact)
    elsif flag?(:watcher_weasel) && !flag?(:maera_weasel_owned)
      set_flag(:maera_weasel_owned)
      say(["MAERA: (not looking up from her pins) My weasel. It fetched me your measurements.",
           "MAERA: Hair, cloth, scent. Who you lean on. For the procession, I was told.",
           "MAERA: Heralds in the procession. Lifelike. ...That's all it was for. I'm almost sure."], event_id)
    else
      say(["MAERA: Try the scarves. Every one's cut to flatter a hero. I've had a lot of practice."], event_id)
    end
    mart(:frost_thread, event_id)
  end

  def crowning_robes(event_id = nil)
    if !flag?(:met_maera)
      return say(["A dress form under a sheet. Something gold glints at the hem."], event_id)
    end
    say(["Under the sheet: robes of gold-leaf velvet, embroidered with flames that seem to move.",
         "A pinned card: AUTUMN WARDEN D. FELL. CROWNING ROBES. FOR THE RETURN. DELIVER BELOW.",
         "They're cut for someone tall and slender.",
         "The collar's been let out, high at the back, for something."], event_id)
    set_flag(:robes_seen)
  end

  #-----------------------------------------------------------------------------
  # The Sap-Works' forge annex, the Library counter, Eira at the shrine: talk-to
  # wrappers for the builder's NPC events.
  #-----------------------------------------------------------------------------
  def frozen_run_end(event_id = nil)
    frozen_run_finish(event_id) if respond_to?(:frozen_run_finish)
  end
end
