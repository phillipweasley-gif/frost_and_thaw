#===============================================================================
# Frost & Thaw - Hyphora's Undercanopy, the rest of it; and the Frostfell Rifts
#
# From the notes (rootspire.md Tab 4 and Tab 5):
#   R1  Verdant Sickness: Rheven asks Reptin to cleanse the blight or cut it out
#   H1  The Spore Gardens: the Secret Nursery; Yarro's lake errand, and the ambush
#   H2  The Fungal Bazaar: spore games; the stolen rapport amulets (the kobolds'
#       nest, 2172); the market duel, and the law from the root archives
#   H3  The Council Fane: the sap pool and the Vision Table; the eight root
#       thrones; the memory niche; the Rootwarden delegation and the sap; the
#       Auril cultist and the poisoned pool
#   H5  Mnemosyne's Chamber: the ritual circle; the memory archive; the tether
#       threads and the shadows that cut them; the Memory Heist; the Memory
#       Trade; the Dream Rescue (the dreamscape, 2171)
#       Eira's development: the stalkers and the wraiths; the missing patrols;
#       the spore-guard's trial
#   The Shadow Mycolith's lake minions, and its hoard
#   GQ1 Closing the Frostfell Rifts (the Celestial Rift, while Glimmer lives)
#===============================================================================
module FrostThaw
  SW_RIFT_STORM = 4120       # an auroral storm at the Celestial Rift: the Frostfell rifts are open
  SW_RHEVEN_BLIGHT = 4121    # Rheven, come down to the blight
  SW_FANE_DELEGATION = 4122  # the Rootwarden delegation in the Fane
  SW_FANE_POISONER = 4123    # a "Rootwarden" at the sap pool
  SW_MEMORY_HEIST = 4124     # a thief in Myr's archive
  SW_KOBOLD_NEST = 4125      # the kobolds' nest is found
  SW_EIRA_TRIALS = 4126      # Eira's requests
  SW_DREAM_OPEN = 4147       # Myr's dreamwalk

  MAPS.merge!(dream_logger: 2171, kobold_nest: 2172)
  MAP_NAMES.merge!(2171 => "A Sporeling's Dream", 2172 => "The Disused Root")
  MAP_METADATA.merge!(2171 => { announce_location: true, battle_environment: :Forest },
                      2172 => { announce_location: true, battle_environment: :Cave })
  AREAS.merge!(2171 => :undercanopy, 2172 => :undercanopy)

  TRAINER_TYPES.merge!(FT_KOBOLD: ["Kobold", :HIKER, 0, 30])
  TRAINERS.merge!(
    kobold_snik: [:FT_KOBOLD, "Snik", [[:SANDSHREW, 42], [:B27H98, 43], [:B66H27, 43]], "Shinies! Snik only wanted the shinies!"],
    kobold_grub: [:FT_KOBOLD, "Grub", [[:B74H27, 43], [:B27H74, 44]], "Grub keeps one. Grub KEEPS one. ...No? No."],
    fane_cultist: [:FT_HALO, "\"Warden\" Vosk", [[:B124H221, 44], [:B215H91, 45], [:JYNX, 45]], "The pool would have gone cold for her. Only a little."],
    eira_trial: [:FT_SOVEREIGN, "Eira", [[:BRELOOM, 46], [:B286H302, 47], [:B47H200, 47], [:B286H122, 48]],
                 "Mercy, and fury. You held both. Pass."]
  )
  TRAINER_INTROS.merge!(
    kobold_snik: "SNIK: Back! Back! These are ours now, finders keepers!",
    kobold_grub: "GRUB: Grub's turn! Grub nibbles!",
    fane_cultist: "\"WARDEN\" VOSK: (dropping the vial) ...Ah.",
    eira_trial: "EIRA: Show me."
  )

  RELIC_ITEMS.merge!(
    FT_SPORECHARM: ["Spore Charm", "Spore Charms", 2, 0,
      "A prize from the myconid youths' spore games. Use it on a Pokémon to cure any status and restore 30 HP.", 1, 1, 0],
    FT_RAPPORTAMULET: ["Rapport Amulet", "Rapport Amulets", 8, 0,
      "A wooden medallion the myconids give as a token of trust. Faria's thanks for getting her basket back.", 0, 0, 6],
    FT_ROOTWRAP: ["Rootwrap Cloak", "Rootwrap Cloaks", 1, 0,
      "A cloak woven from living hyphae. Held: the holder takes less damage from contact moves.", 0, 0, 0],
    FT_SPORESPEAR: ["Spore-Spear", "Spore-Spears", 1, 0,
      "A sentry's spear, furred with fungus. Held: the holder's moves deal a little more damage.", 0, 0, 0],
    FT_HYPHORACIRCLET: ["Hyphora's Circlet", "Hyphora's Circlets", 1, 0,
      "A crown grown from Hyphora's rootlets, given only to those sworn to protect her. Held: the holder can't be poisoned.", 0, 0, 0],
    FT_CLEARMIND: ["Elixir of Clear Mind", "Elixirs of Clear Mind", 2, 0,
      "Hyphora sap, mirror-lake dew and powdered auroral crystal. Cures confusion and any status, and restores 80 HP.", 1, 1, 0],
    FT_MOONOPAL: ["Moonshadow Opal", "Moonshadow Opals", 1, 10000,
      "An opal that shifts between violet and green with the light. Faintly hypnotic. Sells well.", 0, 0, 0],
    FT_FUNGALRELIEF: ["Fungal Relief", "Fungal Reliefs", 1, 15000,
      "A bas-relief carved from petrified hyphae and frost-glass: the growth of the old world-trees. Worth a great deal.", 0, 0, 0],
    FT_ROOTKNOT: ["Root-knot Totem", "Root-knot Totems", 1, 5000,
      "A small idol of dense heart-root, wrapped in silver thread.", 0, 0, 0],
    FT_AURORALCRYSTAL: ["Auroral Crystal", "Auroral Crystals", 1, 20000,
      "A fist-sized crystal from the Echo Gate's walls. It splits light like a prism.", 0, 0, 0],
    FT_FROSTBAR: ["Frost-stamped Bar", "Frost-stamped Bars", 1, 25000,
      "A slab of gold fused with frost-glass, stamped with the sigil of Hyphora's first tenders. Warm to the touch.", 0, 0, 0]
  )

  # The Vision Table (Council Fane): [vision, effect]
  VISION_TABLE = [
    ["A sapling splitting a glacier, green pushing through white.", :hope],
    ["A tree on fire, screaming across the planes. Beyond it, a construct of iron and flame.", :fire],
    ["A pair of wyrmlings circling a branch: one green, one white.", :twins],
    ["A mirror cracking under auroral light. Behind the crack, a cold man's face.", :mirror],
    ["Shadowed figures tapping a tree, like you'd tap a cask.", :greed],
    ["Roots reaching up through stars, into some other, greener sky.", :stars]
  ]

  TEXT.merge!(
    fane_thrones: ["Eight root thrones ring the sap pool, each carved with a season, a memory, or a balance."],
    memory_niche: ["Behind the thrones: an alcove of spore scrolls. Lysella's knot is tied across it."],
    nursery_curtain: ["A curtain of moss, very soft. Behind it, someone is singing."],
    kobold_hole: ["A disused root, hollow as a pipe. Something small has been dragging shiny things in here."],
    rift_quiet: ["The Celestial Rift: the aurora pours into a ring of stone. It's quiet now. Only light."],
    tether_threads: ["Thin silver threads hang from the ceiling and vanish into the floor, humming."],
    rheven_blight: -> {
      with_or_is?(:reptin) ? ["CAPTAIN RHEVEN: (by the black caps) Reptin. Good. The sap's gone black up top too.",
                              "CAPTAIN RHEVEN: Look at it with me. You planted her. You can hear her; I can't."] :
                             ["CAPTAIN RHEVEN: (kneeling by the black caps) The sap's gone black in the Root-Tier.",
                              "CAPTAIN RHEVEN: I'd hoped your warden would come. Reptin. He can hear the tree."] },
    run_hatch_shut: ["At the Run's far end, a crack in the rock breathes cold spore-mist. Too dark to see down.",
                     "Something down there is whispering. (It wants someone who speaks spore.)"],
    attunement_way: ["Roots older than the city, breathing. Carved in one: WALK BESIDE, NOT ABOVE."],
    dream_stumps: ["A stump, cut flat. The rings in it are counting down."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # R1: Verdant Sickness (with H1's blight)
  #-----------------------------------------------------------------------------
  # Called from yarro_blight once the scene is set. Returns true if it's cleansed.
  def verdant_sickness_ritual
    sayc(["Captain Rheven Stormbranch comes down the root-stair, cloak white with frost.",
          "He kneels at the black caps.",
          "RHEVEN: The sap's gone black up top too. Clotted.",
          "RHEVEN: The tree's heartbeat's muffled, like a drum under a blanket.",
          herald?(:reptin) ? "RHEVEN: (gripping your shoulder) Reptin. You planted her. You can hear her." :
                             "RHEVEN: (gripping Reptin's shoulder) Reptin. You planted her. You can hear her.",
          "RHEVEN: Cleanse it, or do we cut away the rot?"])
    set_flag(:rheven_met_blight)
    c = pbMessage(_INTL("The blight..."), [_INTL("Cleanse it (Reptin's ritual)"), _INTL("Cut away the rot (burn it)")], 0)
    return nil if c != 0
    say([as(:reptin, "(a hand flat on the root) ...There. Under the gardens. It's running sick from one place.")])
    # Sense the blight: follow the sick sap to its source
    if !challenge("Follow the sick sap.", ["The warm, sour trickle downhill", "The cold clear one", "The loudest drip"], 0)
      say(["The trail runs into toxic mould. Everyone coughs; your lead Pokémon is poisoned."])
      lead = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? }
      lead.status = :POISON if lead rescue nil
    end
    say(["At the source: a root as thick as a barrel, bulging with black sap, furred with red caps."])
    ok = 0
    ok += 1 if challenge("The poultice.", ["Moss and warm sap, packed close", "Snow, to cool it", "Ash from the brazier"], 0)
    ok += 1 if challenge("What is it?", ["A necrotic fungus, cooked from below", "Frostbite", "Ordinary rot"], 0)
    ok += 1 if challenge("Soothe the root's spirit.", [herald?(:reptin) ? "Speak softly, as to a hurt animal" : "Reptin speaks softly, as to an animal",
                                                       "Command it to heal", "Leave it be"], 0)
    if ok >= 2
      say(["The black drains out of the sap like ink out of water.",
           "The heartbeat comes back under your feet, loud and steady.",
           "RHEVEN: (letting out a breath) ...I've been listening for that for a month."])
      return true
    end
    say(["The ritual falters. The fungus heaves up out of the root: a spore blight, dripping."])
    if skirmish(named_mon(:B47H45, 44, "Spore Blight"))
      say([herald?(:reptin) ? "The blight falls apart. You finish the ritual over its pieces." :
                              "The blight falls apart. Reptin finishes the ritual over its pieces.",
           "The heartbeat comes back, quieter than it should."])
      set_flag(:blight_scarred)                # (the rot spread a little first: the Council remembers)
      true
    else
      say(["The blight sinks back into the root. It'll need doing again."])
      false
    end
  end

  #-----------------------------------------------------------------------------
  # H1: the Secret Nursery; Yarro's lake errand
  #-----------------------------------------------------------------------------
  def secret_nursery(event_id = nil)
    return say(["Yarro, humming over the white mycelia. A new myconid, thumb-sized, is asleep in it."], event_id) if blessing?(:nursery)
    say(lines_for(:nursery_curtain), event_id)
    gentle = flag?(:blight_cleansed) || with_or_is?(:wyn) || with_or_is?(:reptin)
    if !gentle
      return say(["YARRO: (through the moss) Not yet. Come back when the gardens know your feet are gentle."])
    end
    say(["Behind the moss: a warm chamber, and Yarro singing over a bed of delicate white mycelia.",
         "YARRO: (a voice like warm rain) Hush. Come and see. You only get to see this once.",
         "The mycelia gather, and swell, and stand up: a sporeling, wobbling, its cap still wet.",
         "It looks at you.",
         cl(:wyn, "(barely breathing) ...Hello. Hello, you."),
         cl(:meat_meat, "(whispering, for once) Meat Meat will protect this one. Forever. Meat Meat has decided.")])
    grant_blessing(:nursery, "Sporeling's Wonder", "Having seen the miracle, your Pokémon won't flinch.")
  end

  def yarro_errand(event_id = nil)
    return say(["YARRO: The sample's in my jars. The lake is telling me its story now. Slowly."], event_id) if flag?(:yarro_errand_done)
    if !flag?(:lake_open_any)
      return say(["YARRO: (fussing over his beds) Someone should fetch me a sample of the lake water.",
                  "YARRO: Not today. Not until it's safe."], event_id)
    end
    say(["YARRO: Walk with me to the lake? I need a sample of the bad water, to learn its sickness."], event_id)
    return if !pbConfirmMessage(_INTL("Walk Yarro down to the lake?"))
    say(["Down the root-tunnel, Yarro humming. Halfway down, the humming stops.",
         "Something big, pale and many-legged comes out of the wall, after the blight on his hands."])
    return if !boss_battle(named_mon(:B48H98, 45, "Carrion Crawler"))
    say(["YARRO: (filling a jar, perfectly calm) There. Thank you. I'll have its story in a week."])
    set_flag(:yarro_errand_done)
    give(:FT_SAPSALVE, 2)
  end

  # The root tremor (H1): hold the beam while the sporelings get out.
  def garden_tremor(event_id = nil)
    return if flag?(:tremor_done)
    say(["A root tremor shakes the gardens. Dust and spores pour down, and a beam of root cracks.",
         "Under it, a crowd of sporelings, bumbling in circles."], event_id)
    strong = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && (pk.hasType?(:FIGHTING) || pk.hasType?(:ROCK) || pk.attack >= 120) }
    if strong
      say(["#{strong.name} puts its shoulder under the beam and holds it.",
           "The sporelings trundle out, one by one, unharmed."])
      set_flag(:sporelings_saved)
    elsif challenge("The beam is coming down.", ["Brace it with everyone at once", "Grab a sporeling and run", "Shout"], 0)
      say(["You all hold the beam together until the last sporeling is out."])
      set_flag(:sporelings_saved)
    else
      say(["Debris everywhere. Yarro digs the sporelings out, one by one. Nobody's hurt. Nearly."])
    end
    set_flag(:tremor_done)
  end

  #-----------------------------------------------------------------------------
  # H2: the Fungal Bazaar
  #-----------------------------------------------------------------------------
  def spore_games(event_id = nil)
    if flag?(:spore_games_won)
      return say(["The myconid youths are puzzling each other with illusions. They wave a cap at you."], event_id)
    end
    say(["A raised platform of shelf-fungus. Myconid youths throw puzzles into the air above it.",
         "Spores make shapes, and the shapes ask questions."], event_id)
    return if !pbConfirmMessage(_INTL("Try a puzzle?"))
    say(["The spores make three mushrooms: one glowing, one dark, one half and half.",
         "Then they rearrange: dark, half, glowing.",
         "Then: half, glowing, ..."])
    if challenge("What comes next?", ["Dark", "Glowing", "Half and half"], 0)
      say(["The youths puff spores in delight. One gives you a knotted charm that smells of rain."])
      give(:FT_SPORECHARM, 2)
      set_flag(:spore_games_won)
    else
      say(["The youths puff spores in sympathy. You can try again."])
    end
  end

  def faria_theft(event_id = nil)
    if flag?(:amulets_returned)
      return say(["FARIA: My amulets, home! Every one. You've earned stories for life. Discounts too."], event_id)
    end
    if flag?(:theft_tracking)
      return say(["FARIA: Find them! Small feet, shiny-lovers, they went toward the disused roots."], event_id)
    end
    say(["FARIA: (cap wobbling) Thief! Thief! A whole basket of rapport amulets, gone in the night!",
         "FARIA: No coin here. I'll pay in stories. And favours. Good ones. Track them?"], event_id)
    return if !pbConfirmMessage(_INTL("Track the thief?"))
    found = 0
    found += 1 if challenge("The trail through the Bazaar.", ["Move quietly, watching for small shapes", "Ask loudly who saw what", "Run"], 0)
    found += 1 if challenge("A smear on a root.", ["Look closer: a tiny clawed print", "Wipe it off", "Ignore it"], 0)
    found += 1 if challenge("Where does it lead?", ["Follow the prints to the disused roots", "Back to Faria", "Up"], 0)
    if found >= 2
      say(["The prints lead to a hollow, disused root. Inside: a nest, glinting. And yapping."])
      set_flag(:theft_tracking)
      set_switch(SW_KOBOLD_NEST, true)
    else
      say(["You lose the trail among the stalls. Faria wrings her cap. (Try again.)"])
    end
  end

  # Faria's stall: her theft first, then her wares.
  def faria_stall(event_id = nil)
    if flag?(:amulets_found) && !flag?(:amulets_returned)
      amulets_home
    elsif !flag?(:amulets_returned) && flag?(:undercanopy_entered) && flag?(:blight_cleared)
      faria_theft(event_id)
    else
      talk(:faria, event_id)
      faria_wand if respond_to?(:faria_wand)      # (the Wand of Spores: 047d)
    end
    mart(:faria, event_id) if respond_to?(:mart)
  end

  def kobold_nest(event_id = nil)
    return say(["An empty nest of moss and stolen string."], event_id) if flag?(:amulets_returned) || flag?(:amulets_found)
    say(["A nest of moss, string, buttons and spoons. In the middle, a basket of rapport amulets.",
         "Three kobolds sit on it like eggs."], event_id)
    return if !trainer(:kobold_snik, nil)
    return if !trainer(:kobold_grub, nil)
    say(["The kobolds scatter into the roots, yapping. The basket's all there."])
    set_flag(:amulets_found)
  end

  def amulets_home
    return if !flag?(:amulets_found) || flag?(:amulets_returned)
    say(["FARIA: (hugging the basket) Mine, all mine! One for you. Wear it; we'll always hear you."])
    give_key(:FT_RAPPORTAMULET)
    set_flag(:amulets_returned)
  end

  def market_duel(event_id = nil)
    return say(["Two myconids, trading again. One of them gives you a little bow of the cap."], event_id) if flag?(:duel_settled)
    say(["Two myconids, cap to cap, spores flaring red. A crowd forming.",
         "MYCONID A: (in your head, furious) He gave me the wrong story for my moss!",
         "MYCONID B: (just as furious) It was the RIGHT story! She heard it WRONG!"], event_id)
    c = pbMessage(_INTL("The duel..."), [_INTL("Mediate"), _INTL("Spar with them, gently"), _INTL("Find the law: ask Lysella")], 0)
    case c
    when 0
      if challenge("Mediate.", ["Ask each to tell the story as heard", "Tell them both to calm down", "Take a side"], 0)
        say(["The two stories come out side by side. They're the same story, one of them told backwards.",
             "Their spores turn pink."])
        set_flag(:duel_settled)
      else
        say(["Both of them glare at you now. That's progress, of a sort."])
      end
    when 1
      if boss_battle(named_mon(:BRELOOM, 45, "Angry Myconid"))
        say(["After the spar they're both laughing, in that silent fungal way. The quarrel's forgotten."])
        set_flag(:duel_settled)
      end
    else
      if flag?(:niche_read)
        say(["You bring Lysella's law: \"A story told backwards is still owed forwards.\"",
             "Both myconids bow to the law. The quarrel's over."])
        set_flag(:duel_settled)
      else
        say(["LYSELLA: (from her stall) The law's in the Fane's memory niche. I'll lend you my knot."])
        set_flag(:lysella_knot)
      end
    end
    give(:FT_SPORESPEAR) if flag?(:duel_settled) && !flag?(:spore_spear_given) && (set_flag(:spore_spear_given) || true)
  end

  #-----------------------------------------------------------------------------
  # H3: the Council Fane
  #-----------------------------------------------------------------------------
  def sap_pool(event_id = nil)
    say(["The sap pool at the Fane's heart reflects the aurora, and pulses with Hyphora's heartbeat."], event_id)
    if !flag?(:badge_undercanopy)
      return say(["(The Sovereign hasn't given you leave to drink.)"])
    end
    if flag?(:pool_poisoned) && !flag?(:pool_cured)
      say(["The pool runs cold under a skin of blue frost: the false warden's frost-venom."])
      if flag?(:yarro_errand_done) || flag?(:lake_cleansed)
        say(["YARRO: (padding up with a jar) The lake told me its story. This is the end of it.",
             "YARRO: Clean water, and moss, and patience.",
             "Yarro tips it in a drop at a time, humming. The frost cracks, and the pool warms."])
        set_flag(:pool_cured)
        say(["(The three sick myconids sit up in their beds. The pool is clean.)"])
      else
        return say(["YARRO: (sadly) It needs a tincture. The lake knows how, but I haven't heard its story.",
                    "YARRO: Walk me down there?"])
      end
    end
    if flag?(:vision_today)
      return say(["(You've drunk today. The sap's heavy in you still.)"])
    end
    return if !pbConfirmMessage(_INTL("Drink from the sap pool? (The Council has given you leave.)"))
    $Trainer.party.each { |pk| pk.hp = [pk.hp - 2, 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    seen = (state[:visions_seen] ||= [])
    left = (0...VISION_TABLE.size).reject { |i| seen.include?(i) }
    left = (0...VISION_TABLE.size).to_a if left.empty?
    i = left[rand(left.size)]
    seen << i
    text, eff = VISION_TABLE[i]
    say(["The sap is sweet, then bitter, then you're somewhere else.", text])
    case eff
    when :hope then say(["(Hope, like a warm hand. Your team is healed.)"]); $Trainer.heal_party rescue nil
    when :fire then say(["(It hurts to look at. Your Pokémon flinch from it.)"]); $Trainer.party.each { |pk| pk.hp = [pk.hp - pk.totalhp / 10, 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    when :twins then say(["(Balance. Razzilith and Frostina, circling, and you're glad.)"]); wheel(1)
    when :mirror then say(["(Sephek's presence, cold as a blade. You'll know him when you see him.)"]); set_flag(:vision_sephek)
    when :greed then say(["(Greed. Someone in this city is tapping the tree. The vision leaves a bad taste.)"]); set_flag(:vision_greed)
    when :stars then say(["(The planes, all connected. For a moment you could step anywhere. Then you're back.)"]); set_flag(:vision_stars)
    end
    set_flag(:vision_today)
  end

  def root_thrones(event_id = nil)
    say(lines_for(:fane_thrones), event_id)
    return if !pbConfirmMessage(_INTL("Sit on one?"))
    c = pbMessage(_INTL("Which throne?"), [_INTL("The one carved with a balance"), _INTL("The one carved with summer"),
                                          _INTL("The one carved with a memory")], 0)
    if c == 0
      say(["The throne of balance takes your weight like it was made for you. The empty seats hum.",
           "LUMINARA: (from her throne) Hm. You know where to sit. Few surface-folk do."])
      set_flag(:sat_balance)
    else
      say(["A psychic backlash, like a slap from a hundred hands. You stand up very fast."])
      lead = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? }
      lead.hp = [lead.hp - lead.totalhp / 5, 1].max if lead rescue nil
    end
  end

  def memory_niche(event_id = nil)
    if flag?(:niche_read)
      return say(["Spore scrolls of the city's history. You've read what you needed."], event_id)
    end
    say(lines_for(:memory_niche), event_id)
    if !(flag?(:lysella_knot) || flag?(:met_lysella_word) || flag?(:badge_undercanopy))
      return say(["(It isn't yours to untie. Ask Lysella.)"])
    end
    say(["LYSELLA: (her shelf-cap in the doorway) Read. Gently. They're older than your city.",
         "The scrolls unspool memories: the first loggers, the first tenders, and a law:",
         "\"A story told backwards is still owed forwards.\"",
         "And the year Rootwardens and myconids swore to take no more sap than the tree could spare."])
    set_flag(:niche_read)
  end

  # The Rootwarden delegation demands sap for frostburn (H3; "Rootwarden Diplomacy").
  def sap_delegation(event_id = nil)
    return say(["The delegation's gone back up. The sap is shared, by the old oath."], event_id) if flag?(:sap_settled)
    return say(["The delegation's gone back up, angry. There's talk in the Root-Tier of a sap raid."], event_id) if flag?(:sap_grudge)
    say(["A Rootwarden delegation in the Fane, frost on their boots, facing the myconid council.",
         "WARDEN LIS: Frostburn in the Root-Tier. Children. The healers need sap.",
         "WARDEN LIS: And the Council says the myconids hoard it.",
         "LUMINARA: (wind through reeds) We take what she spares. Not more.",
         outsider? ? "The council is divided. Everyone looks at you, and at the Heralds." :
                     "The council is divided. Everyone looks at the Heralds."], event_id)
    ok = 0
    ok += 1 if challenge("Read the room.", ["Both sides are frightened, not greedy", "Everyone's being greedy", "It's about money"], 0)
    ok += 1 if challenge("Make the case.", [flag?(:niche_read) ? "Recite the old oath from the niche" :
                                                                 "Propose so much a week, by her leave",
                                           "Tell the myconids to give it all", "Tell the wardens to leave"], 0)
    ok += 1 if challenge("One side is wavering.", ["Offer to carry the first sap up", "Threaten both", "Walk out"], 0)
    if ok >= 2
      say(["WARDEN LIS: ...A measure, by the tree's leave. Carried by the Heralds. Fine. Fine.",
           "LUMINARA: (inclining her cap) The old oath. Good."])
      set_flag(:sap_settled)
      set_flag(:rootwarden_diplomacy)
    else
      say(["WARDEN LIS: Then we'll take it ourselves, one night. Remember I asked."])
      set_flag(:sap_grudge)
    end
    set_switch(SW_FANE_DELEGATION, false)
  end

  # An Auril cultist disguised as a Rootwarden, poisoning the sap pool (H3).
  def fane_poisoner(event_id = nil)
    return if flag?(:poisoner_caught)
    say(["A Rootwarden kneels at the sap pool's edge, hands cupped, as if to drink."], event_id)
    if challenge("Something's wrong.", ["His breath doesn't fog. A vial, hidden", "He's praying", "Nothing"], 0)
      say(["You catch his wrist. A vial of black-blue liquid: frost-venom. Enough to kill a pool."])
      return if !trainer(:fane_cultist, nil)
      say(["\"WARDEN\" VOSK: She'll come anyway. Through every crack. Through the lake. Through you.",
           "The spore-guard drag him away. The pool pulses on, untouched."])
      set_flag(:poisoner_caught)
      set_switch(SW_FANE_POISONER, false)
    else
      say(["He drinks, and goes. That night the sap pool runs cold, and three myconids sicken."])
      set_flag(:pool_poisoned)
      set_flag(:poisoner_caught)
      set_switch(SW_FANE_POISONER, false)
    end
  end

  #-----------------------------------------------------------------------------
  # H5: Mnemosyne's Chamber
  #-----------------------------------------------------------------------------
  def ritual_circle(event_id = nil)
    return say(["The stone circle glows faintly. It remembers you."], event_id) if flag?(:circle_shared)
    say(["A circle of stones inlaid with sap, glowing faintly. You step inside before you mean to.",
         "Something takes a memory from you, gently, the way you'd take a cup from a sleeping hand.",
         "MYR: (many voices) ...a tavern. A fire. Someone laughing, gap-toothed. I'll keep it warm."], event_id)
    set_flag(:circle_shared)
  end

  def memory_archive(event_id = nil)
    say(["Shelves of bark tablets, each holding a lifetime of spore-memories."], event_id)
    return if !pbConfirmMessage(_INTL("Read one?"))
    if challenge("The tablet's spores rise to meet you.", ["Read slowly, and let it come", "Breathe it in all at once", "Skim"], 0)
      say(["A memory: a priestess of the Frostmaiden, very old, on an island shaped like a snowflake.",
           "PRIESTESS: (in the memory) She doesn't hate the world. She loves it.",
           "PRIESTESS: She loves it so much she can't bear for it to change.",
           "(Something true about Auril.)"])
      set_flag(:knows_auril_love)
    else
      say(["A stranger's memory jams into yours: a lifetime of mending nets, in a town you never saw.",
           "For a day, you'll know the knots."])
    end
  end

  # The tether threads, cut by shadows (H5); and the Memory Heist.
  def tether_threads(event_id = nil)
    return say(lines_for(:tether_threads), event_id) if flag?(:threads_defended) || !flag?(:hyphora_named)
    say(lines_for(:tether_threads) +
        ["Two of them go slack. Up in the dark, shapes like torn shadows are chewing on the threads.",
         "MYR: (many voices, sharp) Shadows! They cut her from the others! Keep them off!"], event_id)
    return if !boss_battle(named_mon(:B94H200, 46, "Shadow Demon"), named_mon(:B94H200, 46, "Shadow Demon"))
    say(["The shadows tear apart into dark spores. The threads hum again, taut."])
    set_flag(:threads_defended)
    give(:FT_HYPHORACIRCLET) if flag?(:hyphora_sworn)
    say(["MYR: Sworn, and proven. Wear this. Hyphora grew it for you."]) if flag?(:hyphora_sworn)
  end

  def memory_heist(event_id = nil)
    return if flag?(:heist_thwarted)
    say(["Someone moves among the archive shelves: a cloak, a sack, a bark tablet in a gloved hand.",
         "MYR: (very faint) ...a prophecy tablet... stop them... don't break the others..."], event_id)
    if challenge("Through the archive, quietly.", ["Edge round the shelves, touching nothing", "Run straight at the thief", "Shout a warning"], 0)
      say(["You come up behind the thief silently. She drops the tablet; you catch it before it lands.",
           "She runs. She leaves the sack. In it: a Halo prayer-token, mirror-glass."])
    else
      say(["The thief bolts. A shelf rocks. You catch the tablet, but three others shatter.",
           "MYR: (a long sigh from many mouths) ...Lifetimes. Gone."])
      set_flag(:tablets_broken)
    end
    set_flag(:heist_thwarted)
    set_switch(SW_MEMORY_HEIST, false)
    say(["The prophecy on the tablet: \"Two wyrmlings turn the wheel; a third heart is the key;",
         "\"...and a fourth season waits under the ice.\""])
  end

  # The Memory Trade: lore about Auril's cult, for a cherished memory.
  def memory_trade(event_id = nil)
    if flag?(:memory_traded) && !flag?(:memory_returned)
      if flag?(:dream_rescued)
        say(["MYR: You fetched my sporeling home. Here. I give yours back, too."], event_id)
        say(["The memory comes back like warmth into cold hands."])
        set_flag(:memory_returned)
      else
        say(["MYR: Your memory is safe with me. I keep it in the warm."], event_id)
      end
      return
    end
    return say(["MYR: I have nothing more to trade. Go carefully."], event_id) if flag?(:memory_traded)
    say(["MYR: (many voices) You want the Frostmaiden's cult. Who they are. Where they kneel.",
         "MYR: I know. A memory of yours for it. A cherished one. You'll miss it till it comes back."], event_id)
    keys = %i[alberica reptin alerion meat_meat wyn].select { |k| with_or_is?(k) }
    return if keys.empty? || !pbConfirmMessage(_INTL("Trade a memory?"))
    c = pbMessage(_INTL("Whose memory?"), keys.map { |k| _INTL(COMPANION_NAMES[k].to_s.capitalize.sub("Meat_meat", "Meat Meat")) }, 0)
    who = keys[[c, 0].max]
    state[:memory_traded_by] = who
    say(["MYR: The first time you laughed after the cold came, #{COMPANION_NAMES[who].to_s.split.map(&:capitalize).join(' ')}. Give it to me.",
         "It goes out of them like a breath. For a second they look puzzled, and can't say why.",
         "MYR: The Halo kneel at the Still Sky Shrine. They carry her relics in the dark.",
         "MYR: They want a third heart, and they'll take it from a songbird.",
         cl(:alberica, "(very plainly) Songbird. That's me, then."),
         "MYR: And they have friends in the Council."].compact)
    set_flag(:memory_traded)
    set_flag(:knows_halo_plan)
  end

  # Myr, once she's named the tree: the trade, the dreamwalk, her counsel.
  def myr_after(event_id = nil)
    say(["MYR: (many voices, slow as roots) Hyphora is afraid. Go carefully. Ask, if you need to."], event_id)
    opts = []
    opts << [:trade, _INTL("\"Tell us about the Frostmaiden's cult.\"")] if !flag?(:memory_traded) || (flag?(:dream_rescued) && !flag?(:memory_returned))
    opts << [:dream, _INTL("\"Is something wrong?\"")] if !flag?(:dream_rescued)
    opts << [:bye, _INTL("Nothing")]
    c = pbMessage(_INTL("Ask Myr..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :trade then memory_trade
    when :dream then dream_request
    end
  end

  # Myr's Dream Rescue: a sporeling lost in a dream of a giant logger.
  DREAM_ARRIVAL = [2171, 10, 18, 8]

  def dream_request(event_id = nil)
    return say(["MYR: The little one is home. Dreaming better things."], event_id) if flag?(:dream_rescued)
    say(["MYR: (many voices, quiet) One of the young has gone into a dream and not come out.",
         "MYR: It dreams of the first loggers. It can't wake. Will you go in after it?"], event_id)
    return if !pbConfirmMessage(_INTL("Dreamwalk with Myr?"))
    say(["Myr's spores fill the chamber. The ceiling turns into sky."])
    transfer(*DREAM_ARRIVAL)
  end

  def scene_dream_logger
    return if flag?(:dream_entered)
    set_flag(:dream_entered)
    sayc(["A forest of stumps under a red sky. Sawdust falls like snow.",
          "Somewhere a small voice is crying. Somewhere else an axe rings on wood, huge and steady.",
          cl(:wyn, "(very small) ...This is what they're all afraid of. Every one of them. Oh.")])
  end

  def dream_sporeling(event_id = nil)
    return say(["The little sporeling clings to your leg."], event_id) if flag?(:dream_sporeling_found)
    say(["A sporeling, hiding under a stump, cap pulled down over its eyes.",
         "It won't come out. The axe is very close."], event_id)
    if challenge("Coax it out.", ["Sit down beside it, and hum", "Pull it out", "Tell it to be brave"], [0, 2])
      say(["It comes out, slowly, and holds on."])
      set_flag(:dream_sporeling_found)
    else
      say(["It burrows deeper."])
    end
  end

  # Myr's silver thread, back out of the dream.
  def dream_wake(event_id = nil)
    say(["A silver thread, hanging in the red air. Myr's. Pull it, and you'll wake."], event_id)
    return if !pbConfirmMessage(_INTL("Wake up?"))
    say(["You wake in Myr's chamber, spores in your hair."] +
        (flag?(:dream_rescued) ? [] : ["MYR: (many voices) The little one is still in there. Go back when you can."]))
    transfer(2068, 17, 13, 2)
  end

  def dream_logger(event_id = nil)
    return say(["A stump. Only a stump."], event_id) if flag?(:dream_rescued)
    if !flag?(:dream_sporeling_found)
      return say(["Over the stumps, a logger as tall as a tree, his axe lifted. He hasn't seen you yet."], event_id)
    end
    say(["The giant logger turns. His face is a blank of sawdust. His axe is the size of a door.",
         "GIANT LOGGER: (a sound like a tree falling) MINE. ALL OF IT. MINE."], event_id)
    if skirmish(named_mon(:B68H185, 50, "The Giant Logger"))
      say(["The logger falls like a felled pine, and is sawdust, and is gone.",
           "The red sky goes green. The stumps put out shoots."])
    else
      say(["The axe comes down. You wake gasping in Myr's chamber, the sporeling in your arms.",
           "It's awake too."])
    end
    set_flag(:dream_rescued)
    add_counter(:story_beats)
    say(["MYR: (all her voices, warm) You brought it home. The young will dream better things now."])
    transfer(2068, 17, 13, 2)
  end

  #-----------------------------------------------------------------------------
  # Eira's development: the unseen sentinels; the patrols; the spore-guard's trial
  #-----------------------------------------------------------------------------
  def eira_development(event_id = nil)
    if !flag?(:eira_lore)
      say(["EIRA: (a cold creek over stones) You've helped the spore-guard. So: the signs.",
           "EIRA: Things at the Echo Gate you'll never see. Stalkers, bound by old pacts. Wraiths.",
           "EIRA: Don't run past still air. Don't stare at your reflection late. Don't steal sap.",
           "EIRA: Remnants of the Rime. They serve the Dawn now. They keep thieves off her."], event_id)
      set_flag(:eira_lore)
      return
    end
    opts = []
    opts << [:patrols, _INTL("Ask about her missing patrols")] if !flag?(:eira_patrols)
    opts << [:report, _INTL("Tell her what you found beyond the Wall")] if flag?(:eira_patrols) && flag?(:missing_patrol_found) && !flag?(:eira_patrols_reported)
    opts << [:trial, _INTL("Ask about the spore-guard's trial")] if (with_or_is?(:wyn)) && !flag?(:spore_guard)
    opts << [:bye, _INTL("Nothing")]
    c = pbMessage(_INTL("Eira..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :patrols
      say(["EIRA: Two of my patrols walked to the Auroral Wall in the spring, with a Bough Rootwarden.",
           "EIRA: They didn't come back. The wind there sounds like someone counting.",
           "EIRA: When the Wall can be crossed, look for them. Please."])
      set_flag(:eira_patrols)
    when :report
      eira_patrol_report
    when :trial
      say(["EIRA: A Rootwarden wants to learn the rites? Mercy, and fury, Wyn. Both, in the same hand.",
           "EIRA: Hold both against me, and the guard will have you."])
      if trainer(:eira_trial, nil)
        say(["EIRA: Spore-guard. Welcome. We don't say it twice."])
        set_flag(:spore_guard)
        give(:FT_ROOTWRAP)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # The Shadow Mycolith: its lake minions; its hoard
  #-----------------------------------------------------------------------------
  def mycolith_minions(phase)
    if phase == 1
      say(["As the seal cracks, the black water round the platforms heaves.",
           "A Shadow Quipper Swarm boils up out of it, straight at you."])
      return false if !boss_battle(named_mon(:B318H92, 44, "Shadow Quipper Swarm"))
      say(["A wave of shadow rolls over the platforms, and #{with_or_is?(:wyn) && !herald?(:wyn) ? 'Wyn goes' : 'you go'} into the water.",
           "Lake-weed wraps an ankle and pulls."])
      if challenge("Something's dragging them under.", ["Grab their hand, and cut the weed", "Jump in after them", "Wait"], 0)
        say(["You haul them out, coughing. The weed slides back under the ice."])
      else
        return false if !boss_battle(named_mon(:B114H72, 45, "Spore-Lash Creeper"))
      end
    else
      say(["The enraged god thrashes. Shadow tentacles, spores, and the swarms again, smelling blood."])
      return false if !boss_battle(named_mon(:B318H92, 46, "Shadow Quipper Swarm"))
    end
    true
  end

  def mycolith_hoard
    return if flag?(:mycolith_hoard)
    say(["Under the roots where the Mycolith stood: a hoard of fungal idols, amber, strange flasks.",
         "Not treasure. A reliquary."])
    [[:FT_FROSTBAR, 2], [:FT_MOONOPAL, 4], [:FT_FUNGALRELIEF, 3], [:FT_ROOTKNOT, 2], [:FT_AURORALCRYSTAL, 1],
     [:POTION, 2], [:SUPERPOTION, 1], [:FT_CLEARMIND, 1], [:FT_SAPSALVE, 1], [:FT_SPORECHARM, 1]].each do |item, n|
      give(item, n)
    end
    say(["(Bars, opals, reliefs and totems: the Bazaar's merchants will buy them.)"])
    $Trainer.money += 5000 rescue nil
    pbMessage(_INTL("You found 500 black-ice coins. (+$5000)")) rescue nil
    set_flag(:mycolith_hoard)
  end

  #-----------------------------------------------------------------------------
  # GQ1: Closing the Frostfell Rifts (the Celestial Rift, Ch7, while Glimmer lives)
  #-----------------------------------------------------------------------------
  def frostfell_rifts(event_id = nil)
    return say(lines_for(:rift_quiet), event_id) if flag?(:rifts_closed)
    say(["The sky opens above you: no stars, no sun, only the aurora pouring down in green and gold.",
         "Standing in its beam is like wading through sunlight made of cold.",
         "Beyond the shimmer, figures stir: winged shapes of ice, their eyes bright with malice.",
         "On their breastplates, a mark you know. Avarice's.",
         "The aurora splits open like a wound. A voice like shattering glass: \"The Frostfell wakes.\""], event_id)
    sayc([cl(:glimmer, "(the Lumen Shard in his chest blazing) Brightmane's light knows this. Stand near me.")])
    return if !pbConfirmMessage(_INTL("Close the rifts?"))
    sealed = 0
    open = 0
    shard = with_or_is?(:glimmer)
    1.upto(6) do |round|
      break if sealed >= 3
      open += 1 if open + sealed < 3
      say(["(Round #{round}. #{open} rift#{open == 1 ? '' : 's'} open.)"])
      if round.even?
        say(["The aurora pulses. Light like a slap."])
        if shard
          say(["GLIMMER: (stepping in front of you all) Behind me. ...There. It's only light."])
        elsif !challenge("The aurora pulses.", ["Shield your eyes, and keep your place", "Look straight into it", "Run"], 0)
          say(["Blinded, you lose the round."])
          next
        end
      end
      seal_mon = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && (pk.hasType?(:PSYCHIC) || pk.hasType?(:FAIRY)) }
      ok = shard || seal_mon || challenge("A rift gapes.", ["Pour your will into it, together", "Throw something into it", "Wait"], 0)
      if ok
        say([shard ? "Glimmer lays a hand on the rift. The Lumen Shard flares and it closes like an eye." :
             seal_mon ? "#{seal_mon.name} pours its power into the rift. It shrinks, and seals." : "You all push. It seals."])
        sealed += 1
        open -= 1
      else
        say(["The rift surges. A Frostfell Angel spills out of it, an ice spear in its hands."])
        return if !boss_battle(named_mon(:B144H227, 48, "Frostfell Angel"))
      end
    end
    if sealed >= 3
      say(["The last rift closes. The aurora goes back to being only light, very beautiful, very far.",
           "Down in the city, nobody knows how close it came. That's how you know it went right."])
      set_flag(:rifts_closed)
      add_counter(:story_beats)
      grant_blessing(:riftwarden, "Rift-Warden's Light", "Your Pokémon's accuracy can no longer be lowered.")
    else
      say(["A horde of angels at the edge of the light. You fall back. The rifts are still open.",
           "(Come back and try again.)"])
    end
  end

  def apply_undercanopy_switches
    return if !active? || !$game_switches
    ch7 = flag?(:ch7_started)
    $game_switches[SW_RIFT_STORM] = ch7 && flag?(:glimmer_joined) && !flag?(:glimmer_gone) && !flag?(:rifts_closed)
    $game_switches[SW_RHEVEN_BLIGHT] = flag?(:undercanopy_entered) && !flag?(:blight_cleared)
    $game_switches[SW_FANE_DELEGATION] = flag?(:badge_undercanopy) && !flag?(:sap_settled) && !flag?(:sap_grudge)
    $game_switches[SW_FANE_POISONER] = flag?(:hyphora_named) && !flag?(:poisoner_caught)
    $game_switches[SW_MEMORY_HEIST] = flag?(:hyphora_named) && !flag?(:heist_thwarted)
    $game_switches[SW_KOBOLD_NEST] = flag?(:theft_tracking) && !flag?(:amulets_found)
    $game_switches[SW_EIRA_TRIALS] = flag?(:hyphora_leave)
    $game_switches[SW_DREAM_OPEN] = flag?(:hyphora_named)
    set_flag(:lake_open_any) if flag?(:hyphora_named) && flag?(:badge_undercanopy) && !flag?(:lake_open_any)
    state[:flags].delete(:vision_today) if state[:flags] && $game_map && $game_map.map_id != 2068
  end
end

#-------------------------------------------------------------------------------
# Battle effects of this chapter's blessings and items
#-------------------------------------------------------------------------------
if defined?(BattleHandlers) && defined?(BattleHandlers::DamageCalcUserItem)
  BattleHandlers::DamageCalcUserItem.add(:FT_SPORESPEAR,
    proc { |item, user, target, move, mults, baseDmg, type| mults[:base_damage_multiplier] *= 1.1 }
  )
  BattleHandlers::DamageCalcTargetItem.add(:FT_ROOTWRAP,
    proc { |item, user, target, move, mults, baseDmg, type| mults[:final_damage_multiplier] *= 0.85 if move.contactMove? }
  ) if defined?(BattleHandlers::DamageCalcTargetItem)
end

if defined?(PokeBattle_Battler)
  class PokeBattle_Battler
    # Hyphora's Circlet: no poison.
    if method_defined?(:pbCanPoison?)
      alias ft_w4_pbCanPoison? pbCanPoison? unless method_defined?(:ft_w4_pbCanPoison?)
      def pbCanPoison?(user, showMessages, move = nil)
        if hasActiveItem?(:FT_HYPHORACIRCLET) && !fainted?
          @battle.pbDisplay(_INTL("{1}'s circlet keeps the poison out!", pbThis)) if showMessages
          return false
        end
        ft_w4_pbCanPoison?(user, showMessages, move)
      end
    end
    # Sporeling's Wonder: no flinching on your side.
    if method_defined?(:pbFlinch)
      alias ft_w4_pbFlinch pbFlinch unless method_defined?(:ft_w4_pbFlinch)
      def pbFlinch(user = nil)
        return if FrostThaw.active? && FrostThaw.blessing?(:nursery) && FrostThaw.ft_player_side?(self)
        ft_w4_pbFlinch(user)
      end
    end
    # Rift-Warden's Light: accuracy can't be lowered on your side.
    if method_defined?(:pbCanLowerStatStage?)
      alias ft_w4_pbCanLowerStatStage? pbCanLowerStatStage? unless method_defined?(:ft_w4_pbCanLowerStatStage?)
      def pbCanLowerStatStage?(stat, user = nil, move = nil, showFailMsg = false, ignoreContrary = false, *rest)
        if stat == :ACCURACY && FrostThaw.active? && FrostThaw.blessing?(:riftwarden) && FrostThaw.ft_player_side?(self)
          @battle.pbDisplay(_INTL("{1}'s eyes are full of rift-light! Its accuracy won't drop!", pbThis)) if showFailMsg
          return false
        end
        ft_w4_pbCanLowerStatStage?(stat, user, move, showFailMsg, ignoreContrary, *rest)
      end
    end
  end
end

# The Spore Charm and the Elixir of Clear Mind
if defined?(ItemHandlers::UseOnPokemon)
  [[:FT_SPORECHARM, 30], [:FT_CLEARMIND, 80]].each do |item, hp|
    ItemHandlers::UseOnPokemon.add(item, proc { |it, pkmn, scene|
      if pkmn.fainted? || (pkmn.hp == pkmn.totalhp && pkmn.status == :NONE)
        scene.pbDisplay(_INTL("It won't have any effect."))
        next false
      end
      pkmn.heal_status
      healed = pbItemRestoreHP(pkmn, hp)
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} feels clear-headed and well.", pkmn.name))
      next true
    })
    ItemHandlers::BattleUseOnPokemon.add(item, proc { |it, pokemon, battler, choices, scene|
      if battler
        battler.pbCureStatus(false)
        battler.pbCureConfusion if battler.respond_to?(:pbCureConfusion)
      else
        pokemon.heal_status
      end
      pbBattleHPItem(pokemon, battler, hp, scene)
      next true
    })
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_undercanopy_switches
  rescue StandardError => err
    FrostThaw.log("Undercanopy switches failed: #{err.message}")
  end
}
