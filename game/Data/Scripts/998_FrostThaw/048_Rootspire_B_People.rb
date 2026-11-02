#===============================================================================
# Frost & Thaw - Rootspire as a living city (part B): its people and its shops
#
# Each of the compendium's shopkeepers says their read-aloud line, sells their
# stock and passes on their rumour; each of the dossier's faction agents and
# the "20 New NPCs" shows their outward face first and lets their secret slip
# when you've earned it (usually by cornering the watcher they sent after you,
# or by finding what they've hidden).
#===============================================================================
module FrostThaw
  HERALD_NAMES = { alberica: "Alberica", reptin: "Reptin", alerion: "Alerion", meat_meat: "Meat Meat", wyn: "Wyn",
                   glimmer: "Glimmer", shade: "Shade" }

  TEXT.merge!(
    # --- the Verdant Halls --------------------------------------------------------------
    halls_sign: ["THE VERDANT HALLS. The Trunk-Tier's civic ring.",
                 "Rootwarden Hall (the Spire Armory), Run & Bloom, the Glasswater Outfitter, Gem & Thorn,",
                 "Auroral Arms, the Perfumed Root and the Thorned Ledger Bank."],
    armory_sign: ["THE SPIRE ARMORY. Rootwarden Hall.", "\"Guard the pulse. Let neither flame nor frost claim it wholly.\""],
    halls_closed: ["A sap-tea house, shuttered for the festival. A note on the door: GONE TO SEE THE HERALDS."],
    brewery_shut: -> {
      if T.flag?(:cellar_hint)
        ["The old Verdant Cask brewery. Boarded up for thirty years.",
         "You put your ear to the boards. Under the floor, very faintly: chanting. And a cold draught, in summer."]
      else
        ["THE VERDANT CASK. A brewery, boarded up. The paint on the sign has peeled into the shape of a snowflake.",
         "It smells, very faintly, of old beer and frost."]
      end
    },
    whispering_sapling_done: ["The little sapling between the planks has grown a second leaf. It leans toward you when you pass."],
    # --- shops --------------------------------------------------------------------------
    run_bloom_corks: ["Crystal-bark shelves of vials pulsing like captured fireflies.", "A label: MIND THE CORKS. SOME MIXTURES GROW LONELY WHEN OPENED."],
    tirena_maps: -> {
      ["Maps of the Dale pinned over maps of the Dale. Ink on bark, ink on hide.",
       T.flag?(:tirena_maps_moved) ? "The coastline on the nearest one has moved again since you last looked. The aurora's shifted." :
                                     "The coastline of Maer Dualdon on one of them is drawn twice, in two different places. Both are labelled TRUE."]
    },
    armory_targets: ["Vine-woven targets that bloom when an arrow hits them. One has been hit so often it's a bouquet."],
    warden_map: -> {
      lines = ["A glowing map of the Auroral Wall, pinned with Rootwarden markers.",
               "Bough circle patrols, in green. Three green pins have been moved to the edge and marked with a small black X."]
      lines << "Someone has added a fourth X since this morning." if T.flag?(:ch7_started) && !T.flag?(:ash_exposed)
      lines
    },
    perfume_shelf: ["Perfumes swirl in their bottles like coloured smoke: Calm Bloom, Valor Mist, Repose Oil, Winter's Whisper.",
                    "One bottle is labelled in violet ink: SUMMER'S BREATH. DO NOT SNIFF BEFORE SLEEP."],
    vault_door: ["The vault door is shaped like coiled vines. It is very, very locked.", "A plaque: DEPOSITS GROW, UNLESS EATEN."],
    cellar_casks: ["Old brewing casks, frost-split. Someone has painted the cracked snowflake of the Fractured Halo on every one,",
                   "and then, over it, very carefully, a small flame."],
    promenade_sign: ["THE LIGHTFALL PROMENADE. The Canopy-Tier's artisans.",
                     "The Auroral Atelier, the Shrine of Balance, Ink & Ember, Crystal Quill, Frost-Thread.",
                     "Above, on the Upper Sunwalk: the Suncleft Emporium. (Closed.)"],
    sunwalk_sign: ["THE UPPER SUNWALK. Gold-leaf bark shutters, warm to the touch. Unnaturally warm.",
                   "SUNCLEFT EMPORIUM. HELION VAEL, ARCHMAGE OF SUMMER. CLOSED SINCE THE REVERSAL."],
    promenade_closed: ["A private house among the leaves. Someone inside is playing a harp very badly, on purpose."],
    four_arches: ["Four arches, each glowing a different season's light: green, gold, red, white.",
                  "Sap-candles burn in bowls of frost-glass under each one."],
    stable_pseudodragon: ["A pseudodragon, the size of a cat, flicks its tail at you.", "It sniffs your hands, finds a wyrmling's scent on them, and sneezes respectfully."],
    frozen_sailor: ["A Corsair, frozen at the oar mid-stroke. Glass all through.", "The lake remembers him. He doesn't move."],
    # --- trainers, after -------------------------------------------------------------------
    warden_bryony_after: ["Seed circle mends what it can. Lately there's a lot more to mend."],
    clerk_fenn_after: ["Recorded: Heralds, victorious. I'll file it under 'unsurprising'."],
    warden_claw_after: ["Claw circle keeps the Armory. The Captain says hold the line. Lately the line keeps moving."],
    warden_seed_after: ["Rest a moment. Your Pokémon fought well. So did you, for a legend."],
    halo_frost_wick_after: ["Stillness. Then the flame. Then nothing. That's the whole prayer."],
    halo_soot_ren_after: ["The Frozen Flame doesn't need you to believe. It just needs you to stand still."],
    halo_cinder_oda_after: ["(Oda says nothing. Oda has said nothing for eleven years. Oda smiles without moving her lips.)"],
    prom_patron_vell_after: ["Autumn always loses gracefully. Then it wins slowly. Remember that, Herald."],
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

  #-----------------------------------------------------------------------------
  # 1. Run & Bloom Apothecary: Bryn of Spring (and Nivva Sunwick at the annex)
  #-----------------------------------------------------------------------------
  def bryn(event_id = nil)
    if first_time?(:met_bryn)
      say(["Moist, fragrant air. Shelves of crystal bark hold vials pulsing like captured fireflies.",
           "A man with windburned skin and hair like dried wheat looks up. Moss-green eyes. Fingers stained with sap.",
           "BRYN: Bryn of Spring. Mind the corks. Some mixtures grow lonely when opened.",
           "He pauses, as if listening to something under the floor. Then he goes on.",
           "BRYN: You're the Heralds. ...It's alright. It's alright. Sit, if you like.",
           "BRYN: Somebody from Summer's side stole a sample of my rebirth sap last month. Out of a locked case.",
           "BRYN: I don't know what anyone would want with it. I hope I never find out."], event_id)
    elsif flag?(:watcher_stalker) && !flag?(:bryn_confessed)
      set_flag(:bryn_confessed)
      say(["BRYN: You caught my Stalker. It's alright. It's alright. It wasn't watching you. Not really.",
           "He listens to the floor for a long moment.",
           "BRYN: Rot. Near the Heartroot. Soft black rot in roots that have never rotted in four hundred years.",
           "BRYN: I've been covering it with moss so nobody panics. I've been covering it with moss.",
           "BRYN: I think it's Summer's doing. Summer, and something older that wears Summer like a glove.",
           "BRYN: If anyone asks me, I'll say it's nothing. Please don't make me say it's something until you know what it is."])
      sayc([cl(:reptin, "You did right to tell someone. Now you've told the Heralds. That's two someones."),
            cl(:wyn, "(quietly) Hyphora's roots felt it too. Under the gardens. Like a fever.")].compact)
    elsif flag?(:engine_dead)
      say(["BRYN: The rot's stopped spreading. Since something below went quiet.", "BRYN: It's alright. It's alright. ...For once, I mean it."], event_id)
    else
      say(["BRYN: Rest your hands. Breathe. The tree's listening; it likes slow breathing."], event_id)
    end
    mart(:run_bloom, event_id)
  end

  # Nivva at the annex stand: the six potions of Alerion's Day 5 live here.
  def nivva_shop(event_id = nil)
    say(["NIVVA: Run & Bloom's annex stand! Red heals. Green's for frost and the long road.",
         "NIVVA: The muddled one's red and green together. Heartroot Renewal. It's a surprise every time. A good one."], event_id)
    alerion_potions if respond_to?(:alerion_potions)
    mart(:run_bloom, event_id)
  end

  #-----------------------------------------------------------------------------
  # 2. The Sap-Smith: Gorran Ashal-Forge, in the forge annex behind Goldlash's
  #-----------------------------------------------------------------------------
  def gorran(event_id = nil)
    if first_time?(:met_gorran)
      say(["Heat thrums through the floor. Metal grows from roots as hammers ring.",
           "A tiefling with ash-grey skin, gold ember freckles and curling ram's horns wipes molten sap from his brow.",
           "The air around him is a few degrees warmer than it should be.",
           "GORRAN: Fire remembers what winter forgets. Gorran Ashal-Forge. I arm the Rootwardens.",
           "GORRAN: And anyone else with coin. Mostly the Rootwardens.",
           "He taps the anvil: tap, tap-tap, tap. Like a code. Sparks crackle between his teeth when he smiles."], event_id)
    elsif flag?(:ore_found) && !flag?(:gorran_confronted)
      set_flag(:gorran_confronted)
      say(["You put a lump of the black, warm ore from the Smuggler's Run on his anvil.",
           "GORRAN: (very still) Where did you get that.",
           "GORRAN: ...It's from the south. Fell off a boat. Ask Jorik.",
           "His hammer taps the anvil: tap, tap-tap, tap. Faster now.",
           "GORRAN: Special commissions. That's all. I don't ask who wants the work.",
           "GORRAN: Somebody who pays in gold that's still warm from somewhere very deep. That's all I know.",
           "GORRAN: Leave it, Heralds. Some fires you don't stand close to."])
      sayc([cl(:meat_meat, "Fire man is lying. Meat Meat knows lying. Meat Meat was raised by it."),
            cl(:alerion, "He's afraid of someone. Not of us.")].compact)
    elsif flag?(:engine_dead)
      say(["GORRAN: The commissions stopped. The gold stopped. Nobody's come to collect.",
           "GORRAN: ...Good. My forge sleeps better. I didn't know it had nightmares."], event_id)
    else
      say(["GORRAN: Late-night forging? Voices in the flame? Gossip. Fire crackles. That's what it does."], event_id)
    end
    mart(:sap_smith, event_id)
  end

  #-----------------------------------------------------------------------------
  # 3. Auroral Atelier: Lumea Keth (Autumn, the Court of Splendor)
  #-----------------------------------------------------------------------------
  def lumea(event_id = nil)
    if first_time?(:met_lumea)
      say(["Suspended shards turn in gentle air, scattering illusions of wings across the walls.",
           "An eladrin with hair the colour of late maple leaves and amber eyes that seldom blink looks you over.",
           "She laughs, as if on a stage. Every chuckle chosen.",
           "LUMEA: Seeking truth? Or something prettier? Lumea Keth. Lightcraft, glamour, spectacle.",
           "She touches your arm, too lightly, too soon. Her eyes flick from feature to feature: sketching you.",
           "LUMEA: One of my illusions escaped last week, you know. It's out there in the roots, being lovely at people.",
           "LUMEA: If you see a fox made of leaves and light, do bring it home."], event_id)
    elsif flag?(:atelier_fox_seen) && !flag?(:lumea_exposed)
      set_flag(:lumea_exposed)
      say(["LUMEA: You found my fox. And you've seen what it shows, haven't you. The golden age. The warm crown.",
           "LUMEA: It's art, darling. Art for people who've been cold for four hundred years.",
           "LUMEA: Summer will return, and it will be glorious, and Autumn will have dressed the stage.",
           "Her laugh doesn't land this time. Her eyes don't blink at all.",
           "LUMEA: Eternal Summer is the answer to Eternal Winter. Everyone in the Court agrees. Everyone who matters."])
      sayc([cl(:alberica, "Darling, 'eternal' anything is just a cage with good lighting."),
            cl(:reptin, "Seasons end. That's how you know they were seasons.")].compact)
    else
      say(["LUMEA: Do look around. Everything in here is real somewhere. Some of it's even real here."], event_id)
    end
    mart(:atelier, event_id)
  end

  # Her escaped illusion: a fox of leaves and light that whispers Autumn's line.
  def atelier_fox(event_id = nil)
    say(["A fox made of swirling leaves and light pads toward you. It sits, looks up, and whispers:",
         "\"Choose warmth.\"",
         "Inside its leaves, for a moment: a golden city, a crowned figure with no face, and everyone smiling. Everyone.",
         "Then it scatters into sparks."], event_id)
    set_flag(:atelier_fox_seen)
    set_self_switch(event_id, "A")
  end

  #-----------------------------------------------------------------------------
  # 4. Glasswater Outfitter: Tirena Loch-Vine
  #-----------------------------------------------------------------------------
  def tirena(event_id = nil)
    if first_time?(:met_tirena)
      say(["Fur, leather, climbing gear and frost-elk tack line the walls. A warm stream runs under a driftwood floor.",
           "A half-elf ranger taps a crate with her boot.",
           "TIRENA: You'll want better gear than that. Tirena Loch-Vine. I map the Dale.",
           "TIRENA: Mapped. Map. The maps keep changing when the aurora shifts. I've stopped arguing with them."], event_id)
      say(["TIRENA: Here. A compass from the frozen side. It doesn't point north. It points where the world's thin.",
           "TIRENA: I've no use for it. It points at the Celestial Rift every time. Everyone knows where the Rift is."])
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
      say(["Books float in silent orbit around a counter of clear bark. Their pages turn as if breathing.",
           "A silver-browed high elf doesn't look up.",
           "SOLVARAN: Knowledge changes hands, never price. Solvaran. I preserve what the leaves let me sell.",
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
           "An aasimar pale as moonlit snow, silver-lashed, hair braided with ice-lilies, speaks in short, heavy sentences.",
           "YSERA: The soul-flow is blocked. Something below hoards what must return.",
           "She touches her temple. A vision, passing.",
           "YSERA: Ysera Dorn. The Order of Balance. We keep the wheel of rebirth turning.",
           "YSERA: Nothing is wrong. All is well.",
           "She sighs. She is very bad at lying."], event_id)
      sayc([cl(:alberica, "Sweetheart, I've lied to dukes. That sigh would get you hanged."),
            cl(:alerion, "She's warning us. Without warning anyone else.")].compact)
    elsif flag?(:watcher_veil_shade) && !flag?(:ysera_warned)
      set_flag(:ysera_warned)
      say(["YSERA: You saw my Shade. Then you know I've been watching who walks with Autumn and with Summer.",
           "YSERA: Here is the truth. Souls meant for rebirth are not returning. They are being harvested. Below the roots.",
           "YSERA: I have no proof. My divinations fail every time I look down.",
           "She touches the bridge of her nose.",
           "YSERA: There is a dragon of light trapped below. I hear it. It does not sing. It burns.",
           "YSERA: Go carefully. Some of my order have started to like the warmth."])
      sayc([cl(:meat_meat, "Cold table had a dragon. Meat Meat heard it. Under the hammers."),
            cl(:glimmer, "(a hand on his chest) A dragon of light. Made wrong. ...I've seen it. I didn't know I had.")].compact)
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
  # 7. The Still Sky Shrine's black market: Eira Voss (the Frozen Flame)
  #-----------------------------------------------------------------------------
  def eira_black_market(event_id = nil)
    if first_time?(:met_eira_voss)
      say(["Cold grips your lungs. Blue flame burns in cracked sconces. A dozen eyes watch from the shadows.",
           "A bone-thin woman with frost-burn scars under her eyes stands where Eline's disciples knelt.",
           "Her white fur cloak is stained with soot. She tilts her head too far, like a bird.",
           "EIRA VOSS: Perfect stillness. Perfect silence. ...And very reasonable prices.",
           "Her voice echoes as if she's in a cathedral. She smiles without moving her lips.",
           "EIRA VOSS: Eline loved the cold. I love what comes after it. Buy something, Herald. Everything here is honest.",
           "EIRA VOSS: Mostly."], event_id)
      set_flag(:met_eira)
    else
      say(["EIRA VOSS: Cursed? Only one in ten. The goddess keeps a tithe."], event_id)
    end
    black_market
  end

  # A quarter of the price, one chance in ten of something else in the parcel.
  def black_market
    loop do
      names = BLACK_MARKET.map { |id, price| _INTL("{1} (${2})", (GameData::Item.get(id).name rescue id.to_s), price) }
      c = pbMessage(_INTL("EIRA VOSS: What will you take?"), names + [_INTL("Nothing")], names.size)
      break if !c || c < 0 || c >= names.size
      id, price = BLACK_MARKET[c]
      if $Trainer.money < price
        say(["EIRA VOSS: Coin first. The cold doesn't give credit."])
        next
      end
      $Trainer.money -= price
      if rand(10) == 0 && id != :FT_STILLSHARD
        say(["She wraps it in black cloth. When you unwrap it, the thing you paid for is gone.",
             "In its place: a sliver of mirror. Your reflection in it blinks a beat late.",
             "EIRA VOSS: (without moving her lips) The goddess kept her tithe."])
        give(:FT_STILLSHARD)
        add_counter(:stillshards_cursed)
      else
        give(id)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # 8. Rootwarden Hall: Captain Kethan Vale (the Hall's own business is in part C)
  #-----------------------------------------------------------------------------
  def kethan(event_id = nil)
    if first_time?(:met_kethan)
      say(["Weapons hang beside living-root shields. A towering goliath with stone-grey skin and frost-blue tattoos",
           "frowns over a glowing map of the Auroral Wall. His cloak is Rootwarden; his armour is etched with constellations.",
           "KETHAN: If you're here to help, good. If not, don't.",
           "He cracks his knuckles: pop, pop, like ice splitting far away. His stare lasts half a second too long.",
           "KETHAN: Captain Kethan Vale. Skytower Shelter clan. I keep order in the civic ring.",
           "KETHAN: Patrols hear hammering under the Heartroot at night. Rheven says it's the tree dreaming.",
           "KETHAN: Trees don't dream with hammers."], event_id)
      sayc([cl(:alerion, "Skytower. Goliaths. Our Skytower?"),
            "KETHAN: Your Skytower, four hundred years on. We remember who carried the shelter's wounded down the mountain.",
            cl(:reptin, "Then we're in good hands. Large ones. Very large.")].compact)
    end
    kethan_business(event_id) if respond_to?(:kethan_business)
    if pbConfirmMessage(_INTL("Look at the Hall's stores?"))
      mart(:warden_hall, event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 9. Ink & Ember Bookhouse: Mirna Cowl (and Avarice's mirror-glass letters)
  #-----------------------------------------------------------------------------
  def mirna(event_id = nil)
    if first_time?(:met_mirna)
      say(["Quills write unattended. The books breathe softly. Runic titles on the spines change as the light does.",
           "A half-elf archivist peers at you over a monocle.",
           "MIRNA: Stories rot when left untold. Mirna Cowl. Ink & Ember.",
           "MIRNA: Tomes, manuals, the odd loan of a book too heavy to own. Buy, borrow, or read standing up. I'll glare."], event_id)
    else
      say(["MIRNA: Back for a story? Everything in here has one. Some of them have two, and the second's worse."], event_id)
    end
    mart(:ink_ember, event_id)
  end

  def mirror_letters(event_id = nil)
    if !flag?(:met_mirna)
      return say(["A locked case of letters written on thin sheets of mirror-glass."], event_id)
    end
    if first_time?(:mirror_letters_read)
      say(["MIRNA: (quietly) You want the case. Everyone who's anyone wants the case.",
           "MIRNA: Letters on mirror-glass. From before the Reversal. Signed with a single letter: A.",
           "She unlocks it. The glass is cold, and the writing moves, slowly, like it's being written now.",
           "\"Variables that refuse to die are the only ones worth measuring.\"",
           "\"The goblin's heart is a seed. The seed is a key. The key is mine.\"",
           "\"Tell the merchant to keep selling mirrors. Every glass is an eye.\"",
           "MIRNA: I stopped reading them when one of them answered."], event_id)
      sayc([herald?(:meat_meat) ? "(Your hands have gone cold. You know that handwriting. You were written in it.)" :
                                  cl(:meat_meat, "(very small) Meat Meat knows that writing. Meat Meat does not want to know it."),
            cl(:alberica, "Lock it, darling. Lock it and put a book on it. A heavy one.")].compact)
    else
      say(["The mirror-glass letters lie in their case. One of them, you'd swear, has a new line at the bottom."], event_id)
    end
  end

  #-----------------------------------------------------------------------------
  # 10. Crystal Quill Scrollworks: Filgen Rootfoot
  #-----------------------------------------------------------------------------
  def filgen(event_id = nil)
    if first_time?(:met_filgen)
      say(["Quartz pods glow with drifting sigils. Scrolls unspool from the ceiling like vines.",
           "A gnome waves both arms at once.",
           "FILGEN: We grow our spells here! Filgen Rootfoot! Every scroll's a cutting! Some bite!",
           "FILGEN: Fireball, Haste, Slow, Misty Step, the lot. Grown in sap, picked fresh."], event_id)
    else
      say(["FILGEN: Fresh crop this morning! Mind the Fireball, it's very ripe."], event_id)
    end
    mart(:crystal_quill, event_id)
  end

  def blank_scrolls(event_id = nil)
    if !flag?(:ch7_started)
      return say(["A rack of blank sap-scrolls, waiting to be written on. Perfectly ordinary. Probably."], event_id)
    end
    say(["The rack of blank sap-scrolls is whispering. Names. Over and over, very softly.",
         "Yours is one of them. So is Var Rime-Breaker's. So is a name you don't know: Helion.",
         "FILGEN: (from behind a pod) They only do that at night! It's not night! WHY IS IT DOING THAT?"], event_id)
    set_flag(:scrolls_whispered)
  end

  #-----------------------------------------------------------------------------
  # 11. Gem & Thorn Exchange: Arvoss Ember-Scale
  #-----------------------------------------------------------------------------
  def arvoss(event_id = nil)
    if first_time?(:met_arvoss)
      say(["Crystal roots form glittering fountains. Gemstones hum faintly as a dragonborn taps each one in turn.",
           "ARVOSS: Stones remember. Arvoss Ember-Scale. I buy, I sell, I listen.",
           "ARVOSS: That one by the window vibrates sometimes. Only when it's carried past certain roots.",
           "ARVOSS: I keep it by the window so it can see where it wants to go."], event_id)
    else
      say(["ARVOSS: Stones remember. People forget. That's why I'm in stones."], event_id)
    end
    mart(:gem_thorn, event_id)
  end

  def humming_gem(event_id = nil)
    say(["A gem the size of an egg, by the window. It hums when you lift it.",
         "When you turn toward the market well (the sealed Root-Gate) it hums louder. Much louder.",
         "When you turn back, it stops, like something holding its breath."], event_id)
    set_flag(:gem_vibrates)
  end

  #-----------------------------------------------------------------------------
  # 12. The Perfumed Root: Lirielle's own shop (and Summer's Breath)
  #-----------------------------------------------------------------------------
  def perfumer(event_id = nil)
    say(["Perfumes swirl like coloured smoke. The shop smells of moss, mint and something that might be memory.",
         "LIRIELLE: (from behind the counter, notebook out) Scents awaken old memories. Welcome to the Perfumed Root!"], event_id)
    if !flag?(:summers_breath) && flag?(:lirielle_dream)
      if pbConfirmMessage(_INTL("LIRIELLE: Would you like to try Summer's Breath? It's... it gives dreams. One sniff."))
        perfume_prophecy
      end
    end
    mart(:perfumed_root, event_id)
  end

  # Summer's Breath (prophecy): the "Perfume Prophecy" (night event 8), taken awake.
  def perfume_prophecy
    set_flag(:summers_breath)
    say(["You breathe in. Warm rain. Then smoke.",
         "Roots, burning from the inside. Sap screaming in its channels like kettles.",
         "A great shape of black crystal and iron, wings folded, chained among twenty standing stones.",
         "Its chest opens. Inside, something blue beats, and isn't its own heart.",
         "A woman's voice, pleased: \"Tomorrow, it flies.\"",
         "You're on the shop floor. Lirielle is fanning you with her notebook. Her fur smells of charred flowers."])
    sayc(["LIRIELLE: That's the one I keep having. Every night. That's the one.",
          cl(:reptin, "(steadying you) Twenty stones. The Twenty Stones. Under Dougan's Hole."),
          cl(:alerion, "Under us.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 13. Verdant Stables: Thim Wicker
  #-----------------------------------------------------------------------------
  def thim(event_id = nil)
    if first_time?(:met_thim)
      say(["Stalls carved from thick roots, glowing moss lighting the pens. Frost-elk and pseudodragons lift their heads.",
           "A halfling with straw in her hair smiles.",
           "THIM: Mind their tempers. Thim Wicker. Tack, feed and the odd friendly beast.",
           "THIM: The old elk heard the tree cry, you know. From below. She hasn't eaten properly since."], event_id)
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
    say(["THIM: There. Walk them every day. And if #{sp == :STANTLER ? 'she' : 'it'} looks at the floor and goes quiet, listen too."])
  end

  #-----------------------------------------------------------------------------
  # 14. Mirror-Dust Curiosity Shop: Jast Penumbran
  #-----------------------------------------------------------------------------
  def jast(event_id = nil)
    if first_time?(:met_jast)
      say(["A cramped shop with reversed signage. The reflections move before the objects do.",
           "The shopkeeper's reflection smiles first. Then the shopkeeper: a gnome with wispy white hair",
           "and huge, polished-obsidian pupils. He blinks, rapid as a moth.",
           "JAST: Everything is real somewhere. Jast Penumbran. You'll want the lantern.",
           "JAST: Don't ask which lantern. You were about to.",
           "He talks to a polished brass bowl while you look round. The bowl seems to answer."], event_id)
    end
    if !($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue true)
      say(["JAST: The Lantern of Revealing. Every watcher in this city shows up in its light.",
           "JAST: Spring's, Winter's, Autumn's, Summer's, the Halo's. Even hers. Especially hers.",
           "JAST: Three thousand. Because you were going to ask what it costs, and the answer's always three thousand."])
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
      say(["JAST: Mirror shards? I buy those. For a collector. She pays very well and never visits.",
           "His reflection, in the bowl, is shaking its head at you. Very slightly."], event_id)
    end
    mart(:mirror_dust, event_id)
  end

  def jast_mirror(event_id = nil)
    if first_time?(:jast_mirror_seen)
      say(["A tall mirror in the back, its glass a patchwork of shards fitted together like a map.",
           "In it, the Dale. Frozen solid. A tree of black crystal where the World Tree should be.",
           "A woman on a throne of ice, smiling. She has no face. You know her anyway.",
           "JAST: (behind you, very close) Possible futures. The ones where she wins. She likes to see them all.",
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
           "A dwarf with a crystalline arm grunts at you.",
           "BROGAR: Steel speaks louder in cold. Brogar Frostvein. Guards' gear, mostly. Heralds' gear, today.",
           "His crystal arm hums. He frowns at it.",
           "BROGAR: Does that when someone's forging below. Deep below. Nobody forges below. So it shouldn't."], event_id)
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
           "THE ACCOUNTANCY: (Leave coin with us. Each night you sleep under the tree, it grows. A little.)"], event_id)
    end
    bank = state[:bank] || 0
    say(["THE ACCOUNTANCY: (Your account: $#{bank}. Growing.)"]) if bank > 0
    c = pbMessage(_INTL("THE ACCOUNTANCY: (Transaction?)"), [_INTL("Deposit"), _INTL("Withdraw"), _INTL("Nothing")], 2)
    case c
    when 0
      amount = [($Trainer.money / 1000) * 1000, 0].max
      return say(["THE ACCOUNTANCY: (You have nothing to grow.)"]) if amount <= 0
      opts = [1000, 5000, 10000, amount].uniq.select { |a| a <= $Trainer.money }
      n = pbMessage(_INTL("Deposit how much?"), opts.map { |a| _INTL("${1}", a) } + [_INTL("Cancel")], opts.size)
      return if !n || n < 0 || n >= opts.size
      $Trainer.money -= opts[n]
      state[:bank] = bank + opts[n]
      say(["THE ACCOUNTANCY: (Planted.)"])
    when 1
      return say(["THE ACCOUNTANCY: (There is nothing here of yours.)"]) if bank <= 0
      $Trainer.money += bank
      state[:bank] = 0
      say(["THE ACCOUNTANCY: (Harvested: $#{bank}. Come again.)"])
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
         "THE ACCOUNTANCY: (Spore echo. It heard it somewhere. In the deep accounts. We do not know whose account.)",
         "THE ACCOUNTANCY: (We have checked. The account does not exist. It is very large.)"], event_id)
    set_flag(:spore_whispered)
  end

  #-----------------------------------------------------------------------------
  # 16. The Suncleft Emporium: Helion Vael's shuttered vault
  #-----------------------------------------------------------------------------
  def suncleft_door(event_id = nil)
    say(["The Suncleft Emporium's gold-leaf shutters are warm. Far too warm. Like a hand on a fevered forehead.",
         "Dust shimmers in waves of heat behind the glass. The shelves are full. Unsettlingly full."], event_id)
    if flag?(:watcher_ember_rat) || flag?(:warm_window_seen)
      say(["Down by the step, scorch-marks lead under the shutters: a small creature's footprints, in embers.",
           "The Ember-Rat came this way. The lock is warm enough to bend."])
      if pbConfirmMessage(_INTL("Force the warm lock?"))
        set_switch(SW_SUNCLEFT_OPEN, true)
        say(["The lock gives like toffee. The door swings in on a breath of heat."])
      end
    end
  end

  def scene_suncleft_enter
    set_flag(:suncleft_entered)
    sayc(["Dust hangs in slow waves of heat. Nothing has been touched for decades, and nothing has rotted.",
          "Firestones on velvet. Charcoal in jars. Flame-orbs that are still warm.",
          cl(:alberica, "Thirty years shut and not a cobweb. Somebody's been dusting, sugar. Somebody warm."),
          cl(:wyn, "(very quietly) The floor's warm. Like... like it's breathing out.")].compact)
  end

  def helion_mural(event_id = nil)
    say(["A mural across the back wall: a figure of molten gold, flame for hair, a crown of burning antlers.",
         "HELION VAEL, ARCHMAGE OF SUMMER.",
         "As you look, the gold moves. A recorded illusion, triggered by the warmth of your hand."], event_id)
    say(["HELION: (a voice like a hearth: warm, and devouring) Ah. Saplings. You've come for the old Summer.",
         "HELION: Summer was never lost, child. Summer went down. Into the roots. To the forge beneath the hag's old kitchen.",
         "HELION: There is a lady there who knows what a season is worth. Every soul is a coal, sapling.",
         "HELION: When the engine wakes, I will be its herald. Eternal Summer. No more winter. No more anything.",
         "The illusion smiles, and runs out, and is only paint."])
    sayc([cl(:reptin, "'No more anything.' He said it like it was the good part."),
          cl(:alerion, "Herald of Eternal Summer. Not if we're there first.")].compact)
    set_flag(:helion_known)
  end

  def suncleft_shelves(event_id = nil)
    if flag?(:suncleft_looted)
      return say(["The shelves are bare where you took what you took. The rest is warm, and waiting."], event_id)
    end
    say(["Shelves of Summer's goods, untouched, warm: firestones, charcoal, flame-orbs, a heat rock, a ruby-red gem.",
         "Nobody is coming back for them. Somebody might be coming back for you."], event_id)
    return if !pbConfirmMessage(_INTL("Take what's left on the shelves?"))
    set_flag(:suncleft_looted)
    SUNCLEFT_SHELVES.each { |it| give(it) }
    sayc([cl(:meat_meat, "Meat Meat is not stealing. Meat Meat is rescuing from bad man."),
          cl(:reptin, "We'll call it confiscation. Diplomatically.")].compact)
  end

  def suncleft_hatch(event_id = nil)
    say(["A hatch in the floor, iron, very warm. Below it, a shaft runs straight down into the dark.",
         "Heat breathes up out of it in slow pulses. Far, far below: hammers.",
         "The shaft has been sealed from below with molten iron."], event_id)
    set_flag(:suncleft_tunnel)
    sayc([cl(:alerion, "Helion's road to the forge. He went down and somebody poured the door shut behind him."),
          cl(:glimmer, "(very quietly) Brightmane said I'd know the fire when I saw it. That's not it. That's its chimney.")].compact)
  end

  #-----------------------------------------------------------------------------
  # 18. Frost-Thread Clothier: Maera Vell (Autumn) and the crowning robes
  #-----------------------------------------------------------------------------
  def maera(event_id = nil)
    if first_time?(:met_maera)
      say(["Cloth changes colour as you pass: winter blue, spring green, autumn gold.",
           "A tailor with ruddy cheeks and dye-stained fingertips hums as she works. The tune changes with her mood.",
           "MAERA: In Rootspire, prophecy chooses fashion. Maera Vell. Oh, you'd look divine in green. And you. And YOU.",
           "Every compliment lands exactly where it was aimed."], event_id)
      sayc(["You mention Summer. Maera freezes. Her eyes go flat. Then she's humming again.",
            "MAERA: Summer's a season, darling. Seasons come back. Everyone knows that."])
    elsif flag?(:robes_seen) && !flag?(:maera_confronted)
      set_flag(:maera_confronted)
      say(["MAERA: You looked at the commission. That was private.",
           "MAERA: The Autumn Warden ordered them. Crowning robes. For a coronation that's going to happen.",
           "MAERA: I don't ask who's wearing them. I measure what I'm sent. Tall. Slender. Horns.",
           "She stops humming.",
           "MAERA: I've never been sent a face."])
      sayc([herald?(:meat_meat) ? "(Razzilith said that. 'No one ever sees Summer's face.')" :
                                  cl(:meat_meat, "Razzy said that. Razzy said Summer has no face."),
            cl(:alberica, "A coronation for someone nobody's met. Darling, that's not fashion, that's a warrant.")].compact)
    else
      say(["MAERA: Try the scarves. Every one of them is cut to flatter a hero. I've had four hundred years of practice."], event_id)
    end
    mart(:frost_thread, event_id)
  end

  def crowning_robes(event_id = nil)
    if !flag?(:met_maera)
      return say(["A dress form under a sheet. Something gold glints at the hem."], event_id)
    end
    say(["Under the sheet: robes of gold-leaf velvet, embroidered with flames that seem to move.",
         "A pinned card: AUTUMN WARDEN D. FELL. CROWNING ROBES. FOR THE RETURN. DELIVER BELOW.",
         "They're cut for someone tall and slender. The collar has two slits in it, high at the back.",
         "For horns."], event_id)
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
