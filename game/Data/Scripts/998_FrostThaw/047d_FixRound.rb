#===============================================================================
# Frost & Thaw - the fix round for Chapter 7A, Chapters 10-13 and the White Vault
# (docs/FIX_ROUND.md, docs/reaudit/D_rootspire_tabs3to8.md and friends).
#
#   - Hyphora's Undercanopy goods the notes list and the game lacked: the Hyphal
#     Lash, Sap-Stones, the Rootbond Armlet (Korun's forge), the Wand of Spores
#     (Faria), Hyphora's Crown and Hyphora's Seed (Luminara's gifts).
#   - Shroomsmith Korun, as the notes play him: mending, his own craft, his
#     respect for makers and his scorn for neglect, toys for the sporelings.
#   - Consequences that the trial week and the Undercanopy set and nothing read:
#     the verdict's geas, Wyn barred from the Rootwardens' stores, the Canopy
#     under watch or martial law, the blight's scar, the Rootwardens angered,
#     the sap grudge (a raid night), the poisoned pool, the Silent Chapel's
#     answer, the Suffering Pods left sleeping, Eira's missing patrols.
#   - The Political Favour Track: boons from friends, rivals from the rest.
#   - Reptin's vow at the Chasm, kept; Sephek's pilgrim visions; Darrus paying
#     for the voyage.
#===============================================================================
module FrostThaw
  SW_SAP_RAID = 4154      # the Rootwardens come for the sap, one night of the trial week
  SW_CANOPY_GUARD = 4155  # wardens on the Canopy walkways (the Canopy watched, or under martial law)

  RELIC_ITEMS.merge!(
    FT_SAPSTONE: ["Sap-Stone", "Sap-Stones", 2, 600,
      "A polished amber stone of concentrated sap. Thrown in battle, it bursts and glues the target in place: its Speed falls sharply.", 0, 5, 0],
    FT_HYPHALLASH: ["Hyphal Lash", "Hyphal Lashes", 8, 0,
      "A whip grown from a living vine, from Korun's forge. Once each battle: lash the foe and pull it off its feet (Defense falls, and it may be poisoned).", 0, 10, 6],
    FT_ROOTBONDARMLET: ["Rootbond Armlet", "Rootbond Armlets", 8, 0,
      "A thick bracelet carved from Hyphora's bark. Bonded to the ground: your Pokémon's Speed can't be lowered by tangling, mud or webs.", 0, 0, 6],
    FT_WANDOFSPORES: ["Wand of Spores", "Wands of Spores", 8, 0,
      "Faria's wand. Three charges a day: fog and tangling vines (the foe's accuracy and Speed fall), and a surge of green (your Pokémon recovers a little).", 0, 10, 6],
    FT_HYPHORACROWN: ["Hyphora's Crown", "Hyphora's Crowns", 8, 0,
      "A living circlet, gifted only to those sworn to the tree. Once each battle: release pacifying spores, and the foe's raised stats calm back to nothing.", 0, 10, 6],
    FT_HYPHORASEED: ["Hyphora's Seed", "Hyphora's Seeds", 2, 0,
      "A sacred seed. Planted in battle, it sprouts a grove: your Pokémon are soothed, and can't be confused or infatuated for the rest of the fight.", 0, 5, 0],
    FT_SPORELINGTOY: ["Hyphae Toy", "Hyphae Toys", 8, 0,
      "A little wolf shaped out of hyphae by Korun's own hands, for the sporeling in Yarro's nursery.", 0, 0, 6]
  )

  TEXT.merge!(
    korun_scorn: ["Korun looks at your Pokémon, then at your bag. A long, scornful puff of spores.",
                  "KORUN: (Neglect. Made things remember who neglected them.)"],
    sap_raid_after: ["The sap vats on the Root-Tier stand under a fresh lock.", "Rootwarden and myconid guards share the watch now. Mostly they glare."],
    canopy_guard: -> {
      T.flag?(:canopy_martial_law) ?
        ["WARDEN ON THE WALKWAY: Papers, Herald. Martial law. Selrae's orders. I hate it too.",
         "WARDEN ON THE WALKWAY: Go on. And don't run. Running looks like something."] :
        ["WARDEN ON THE WALKWAY: Just watching, Herald. Kelyn's compromise. The Rift, the walkways.",
         "WARDEN ON THE WALKWAY: (lower) Watch you, too. Sorry."] }
  )

  module_function

  #-----------------------------------------------------------------------------
  # Shroomsmith Korun (rootspire.md Tab 5): blunt, literal, speaks in things he
  # makes. Mends gear; respects makers; scorns neglect; gentle with sporelings.
  #-----------------------------------------------------------------------------
  def korun_smith(event_id = nil)
    talk(:korun, event_id)
    neglect = ($Trainer.party.any? { |pk| !pk.egg? && (pk.fainted? || pk.moves.any? { |m| m && m.total_pp > 0 && m.pp == 0 }) } rescue false)
    maker = with_or_is?(:meat_meat)
    if !flag?(:korun_met)
      set_flag(:korun_met)
      if maker
        say([herald?(:meat_meat) ? "Korun's cap tilts toward your goggles. Cracked, patched, re-patched. Your own work." :
                                   "Korun's cap tilts toward Meat Meat's goggles. Cracked, patched, re-patched. Her own work.",
             "KORUN: (Made them yourself. Good. You may ask for things.)"])
      end
    end
    say(lines_for(:korun_scorn)) if neglect
    opts = []
    opts << [:mend, _INTL(maker ? "Ask him to mend your gear (free, for a maker)" : "Ask him to mend your gear ($500)")]
    opts << [:craft, _INTL("Look at what he's made")]
    opts << [:toy, _INTL("Ask about the sporelings")] if blessing?(:nursery) && !flag?(:korun_toy)
    opts << [:bye, _INTL("Leave him to it")]
    c = pbMessage(_INTL("Korun..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :mend
      cost = maker ? 0 : 500
      if $Trainer.money < cost
        return say(["KORUN: (No sap-scrip. No mending. Made things cost.)"])
      end
      $Trainer.money -= cost
      $Trainer.party.each { |pk| pk.moves.each { |m| m.pp = m.total_pp if m } if !pk.egg? } rescue nil
      say(["He takes each Poké Ball, breathes spores over it, and taps it once with his hammer.",
           "Something in every one of your Pokémon settles, like a strap pulled tight.", "(Every move's PP is restored.)",
           "KORUN: (Mended. Respect it.)"])
    when :craft
      korun_craft
    when :toy
      set_flag(:korun_toy)
      say(["At the word 'sporeling', the big myconid goes very still. Then he sets down the hammer.",
           "His thick fingers pull a strand of hyphae off the bench and twist it, and twist it.", "And it's a little wolf.",
           "KORUN: (For the small one in the nursery. Small ones should have things.)"])
      give_key(:FT_SPORELINGTOY)
    end
  end

  def korun_craft
    maker = with_or_is?(:meat_meat)
    lash_cost = maker ? 2250 : 3000
    band_cost = maker ? 3750 : 5000
    opts = []
    opts << [:stones, _INTL("Sap-Stones (by the stone)")]
    opts << [:lash, _INTL("The Hyphal Lash (${1})", lash_cost)] if !($PokemonBag.pbHasItem?(:FT_HYPHALLASH) rescue false)
    opts << [:band, _INTL("The Rootbond Armlet (${1})", band_cost)] if !($PokemonBag.pbHasItem?(:FT_ROOTBONDARMLET) rescue false)
    opts << [:bye, _INTL("Nothing")]
    say(["On the bench: a whip grown from a vine, still twitching. Amber stones, sticky.", "And a thick bracelet of bark."])
    c = pbMessage(_INTL("Buy..."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :stones
      pbPokemonMart([:FT_SAPSTONE]) rescue nil
    when :lash
      return say(["KORUN: (Not enough. The vine is worth more than that.)"]) if $Trainer.money < lash_cost
      $Trainer.money -= lash_cost
      give_key(:FT_HYPHALLASH)
      say(["KORUN: (It pulls. It bites. Don't feed it.)"])
    when :band
      return say(["KORUN: (Not enough. The bark is Hyphora's. She doesn't give it cheap.)"]) if $Trainer.money < band_cost
      $Trainer.money -= band_cost
      give_key(:FT_ROOTBONDARMLET)
      say(["He fastens it round a wrist himself, and presses it to the floor. The floor presses back.",
           "KORUN: (Bonded. Nothing will pull you off your feet now. Not mud. Not webs.)"])
    end
  end

  #-----------------------------------------------------------------------------
  # Luminara's gifts (rootspire.md Tab 5: "Cleanse the Lake. Reward: Hyphora's
  # Seed"; Hyphora's Crown, "gifted only to those sworn to protect the tree")
  #-----------------------------------------------------------------------------
  def luminara_gifts
    given = false
    if flag?(:lake_cleansed) && !flag?(:hyphora_seed_given)
      set_flag(:hyphora_seed_given)
      say(["LUMINARA: The lake is clean. Yarro's ritual held. You were promised a thing, for that.",
           "She sets a single seed in your palm. It's warm, and it beats, very slowly, like the tree."])
      give(:FT_HYPHORASEED, 1)
      given = true
    end
    if flag?(:hyphora_sworn) && flag?(:colony_recognised) && !flag?(:hyphora_crown_given)
      set_flag(:hyphora_crown_given)
      say(["LUMINARA: You swore to protect her. You brought the surface to our floor. To listen.",
           "LUMINARA: This is grown, not made. It is given only to the sworn.",
           "A living circlet of rootlets, still growing, settles into your hands."])
      give_key(:FT_HYPHORACROWN)
      given = true
    end
    given
  end

  # Faria's Wand of Spores (rare; the notes' Undercanopy market).
  def faria_wand
    return false if ($PokemonBag.pbHasItem?(:FT_WANDOFSPORES) rescue false) || !flag?(:badge_undercanopy)
    return false if !pbConfirmMessage(_INTL("FARIA: (A wand of spores. Fog, vines, a little green surge. Six thousand. Interested?)"))
    if $Trainer.money < 6000
      say(["FARIA: (Not enough. I'd haggle, but I like you, so I won't. Come back richer.)"])
      return true
    end
    $Trainer.money -= 6000
    give_key(:FT_WANDOFSPORES)
    say(["FARIA: (Three charges a day. It wakes up full at dawn. Don't point it at me.)"])
    true
  end

  def wand_charges
    today = (pbGetTimeNow.strftime("%Y%m%d") rescue "0")
    w = (state[:wand] ||= { day: today, charges: 3 })
    if w[:day] != today
      w[:day] = today
      w[:charges] = 3
    end
    w
  end
end

#-------------------------------------------------------------------------------
# The Undercanopy goods in battle
#-------------------------------------------------------------------------------
if defined?(ItemHandlers::UseInBattle)
  module FrostThaw
    def self.ft_foe_of(battler, battle)
      battle.battlers.find { |b| b && !b.fainted? && b.opposes?(battler) } rescue nil
    end
  end

  ItemHandlers::UseInBattle.add(:FT_SAPSTONE, proc { |item, battler, battle|
    foe = FrostThaw.ft_foe_of(battler, battle)
    battle.pbDisplay(_INTL("The Sap-Stone bursts! Sticky sap everywhere!"))
    if foe && foe.pbCanLowerStatStage?(:SPEED, battler, nil, true)
      foe.pbLowerStatStage(:SPEED, 2, battler)
    end
  })

  ItemHandlers::CanUseInBattle.add(:FT_HYPHALLASH, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
    if battle.instance_variable_get(:@ft_lash_used)
      scene.pbDisplay(_INTL("The lash is still coiling itself back up. (Once each battle.)")) if showMessages
      next false
    end
    next true
  }) if defined?(ItemHandlers::CanUseInBattle)
  ItemHandlers::UseInBattle.add(:FT_HYPHALLASH, proc { |item, battler, battle|
    battle.instance_variable_set(:@ft_lash_used, true)
    foe = FrostThaw.ft_foe_of(battler, battle)
    next if !foe
    battle.pbDisplay(_INTL("The Hyphal Lash wraps round {1} and pulls it off its feet!", foe.pbThis(true)))
    foe.pbLowerStatStage(:DEFENSE, 1, battler) if foe.pbCanLowerStatStage?(:DEFENSE, battler, nil, true)
    foe.pbPoison(battler) if rand(100) < 50 && foe.pbCanPoison?(battler, false)
  })

  ItemHandlers::CanUseInBattle.add(:FT_WANDOFSPORES, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
    if FrostThaw.wand_charges[:charges] <= 0
      scene.pbDisplay(_INTL("The wand is spent. It wakes up full at dawn.")) if showMessages
      next false
    end
    next true
  }) if defined?(ItemHandlers::CanUseInBattle)
  ItemHandlers::UseInBattle.add(:FT_WANDOFSPORES, proc { |item, battler, battle|
    FrostThaw.wand_charges[:charges] -= 1
    foe = FrostThaw.ft_foe_of(battler, battle)
    battle.pbDisplay(_INTL("Fog rolls out of the wand, and vines come up through the floor!"))
    if foe
      foe.pbLowerStatStage(:ACCURACY, 1, battler) if foe.pbCanLowerStatStage?(:ACCURACY, battler, nil, true)
      foe.pbLowerStatStage(:SPEED, 1, battler) if foe.pbCanLowerStatStage?(:SPEED, battler, nil, true)
    end
    own = battler
    own = battle.battlers.find { |b| b && !b.fainted? && !b.opposes?(battler) } if own.nil? || own.fainted?
    own.pbRecoverHP(own.totalhp / 8) if own && own.hp < own.totalhp
    battle.pbDisplay(_INTL("(The wand has {1} charge(s) left today.)", FrostThaw.wand_charges[:charges]))
  })

  ItemHandlers::CanUseInBattle.add(:FT_HYPHORACROWN, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
    if battle.instance_variable_get(:@ft_crown_used)
      scene.pbDisplay(_INTL("The crown's spores are spent for this fight.")) if showMessages
      next false
    end
    next true
  }) if defined?(ItemHandlers::CanUseInBattle)
  ItemHandlers::UseInBattle.add(:FT_HYPHORACROWN, proc { |item, battler, battle|
    battle.instance_variable_set(:@ft_crown_used, true)
    battle.pbDisplay(_INTL("Pale, calming spores drift out of Hyphora's Crown..."))
    battle.battlers.each do |b|
      next if !b || b.fainted? || !b.opposes?(battler)
      calmed = false
      b.stages.each_key { |s| (b.stages[s] = 0; calmed = true) if b.stages[s] > 0 }
      battle.pbDisplay(calmed ? _INTL("{1} calms down! Its raised stats return to normal.", b.pbThis) :
                                _INTL("{1} breathes the spores, and sways.", b.pbThis))
    end
  })

  ItemHandlers::UseInBattle.add(:FT_HYPHORASEED, proc { |item, battler, battle|
    battle.instance_variable_set(:@ft_grove, true)
    battle.pbDisplay(_INTL("Hyphora's Seed takes root! A grove springs up round your Pokémon."))
    battle.battlers.each { |b| b.pbRecoverHP(b.totalhp / 8) if b && !b.fainted? && !b.opposes?(battler) && b.hp < b.totalhp }
  })
end

if defined?(PokeBattle_Battler)
  class PokeBattle_Battler
    # Hyphora's grove: your side can't be confused or infatuated this battle.
    if method_defined?(:pbCanConfuse?)
      alias ft_fx_pbCanConfuse? pbCanConfuse? unless method_defined?(:ft_fx_pbCanConfuse?)
      def pbCanConfuse?(user = nil, showMessages = true, move = nil, selfInflicted = false)
        if FrostThaw.active? && @battle.instance_variable_get(:@ft_grove) && FrostThaw.ft_player_side?(self) && !fainted?
          @battle.pbDisplay(_INTL("The grove soothes {1}! It won't be confused!", pbThis(true))) if showMessages
          return false
        end
        ft_fx_pbCanConfuse?(user, showMessages, move, selfInflicted)
      end
    end
    if method_defined?(:pbCanAttract?)
      alias ft_fx_pbCanAttract? pbCanAttract? unless method_defined?(:ft_fx_pbCanAttract?)
      def pbCanAttract?(user, showMessages = true)
        if FrostThaw.active? && @battle.instance_variable_get(:@ft_grove) && FrostThaw.ft_player_side?(self) && !fainted?
          @battle.pbDisplay(_INTL("The grove soothes {1}! It won't be charmed!", pbThis(true))) if showMessages
          return false
        end
        ft_fx_pbCanAttract?(user, showMessages)
      end
    end
    # The Rootbond Armlet: your side's Speed can't be pulled down.
    if method_defined?(:pbCanLowerStatStage?)
      alias ft_fx_pbCanLowerStatStage? pbCanLowerStatStage? unless method_defined?(:ft_fx_pbCanLowerStatStage?)
      def pbCanLowerStatStage?(stat, user = nil, move = nil, showFailMsg = false, ignoreContrary = false, *rest)
        if stat == :SPEED && FrostThaw.active? && FrostThaw.ft_player_side?(self) && !(user && user.index == @index) &&
           ($PokemonBag.pbHasItem?(:FT_ROOTBONDARMLET) rescue false)
          @battle.pbDisplay(_INTL("{1} is bonded to the ground! Its Speed won't drop!", pbThis)) if showFailMsg
          return false
        end
        ft_fx_pbCanLowerStatStage?(stat, user, move, showFailMsg, ignoreContrary, *rest)
      end
    end
  end
end

#===============================================================================
# The trial week's choices, coming back: the election stance, the Favour Track,
# Reptin's vow, the nights (Sephek's pilgrim, the sap raid), Summer's quarters
# atop the Council tower, and the consequences the verdict and the week set.
#===============================================================================
module FrostThaw
  SUMMER_QUARTERS = [2173, 9, 10, 8]    # the Marshal's quarters (tools/build_w4.rb), in from the tower stair
  TOWER_STAIR_FOOT = [2054, 6, 5, 2]    # back down: the Council Hall, at the foot of the stair
  MAPS.merge!(summer_quarters: 2173)
  MAP_NAMES.merge!(2173 => "Summer's Quarters")
  MAP_METADATA.merge!(2173 => { announce_location: true })
  AREAS.merge!(2173 => :rootspire)

  # The Heralds as a candidate (Tab 8 Q6.3: "run themselves"): a petition of five, or a faction.
  CANDIDATES[:heralds] = ["The Heralds", "Dawn and dusk: every season gets its turn, and nobody wears anybody."]
  CANDIDATE_BASE[:heralds] = 2
  SIGNATURES_NEEDED[:heralds] = 5
  DEBATE_QUESTIONS[0][1][:heralds] = "We went down there. Nobody digs under her while we're in this city."
  DEBATE_QUESTIONS[1][1][:heralds] = "Home. Half of us fell out of a lamp from there. Open the Gate both ways."

  TRAINERS.merge!(
    sap_raider_oak: [:FT_ROOTWARDEN, "Oakes", [[:PILOSWINE, 55], [:B114H72, 55]], "Put the torch down. Nobody's burning anything."],
    martial_warden: [:FT_ROOTWARDEN, "Checkpoint Warden", [[:B59H221, 56], [:PILOSWINE, 56]], "...Papers. Next time, papers."],
    spores_warden:  [:FT_ROOTWARDEN, "Selrae's Warden", [[:B59H221, 52], [:SNEASEL, 52]], "Stand down. The Council will hear of this."]
  )
  TRAINER_INTROS.merge!(
    sap_raider_oak: "OAKES: Out of the way, Heralds. Rootwarden business.",
    martial_warden: "CHECKPOINT WARDEN: Martial law. Halt. ...You're not halting.",
    spores_warden: "SELRAE'S WARDEN: In the Council's name. Hands where we can see them."
  )

  TEXT.merge!(
    sap_raid_after: -> {
      T.flag?(:sap_raided) ?
        ["The sap vats stand half empty. A myconid guard watches the ramp, and doesn't look at you."] :
        ["The sap vats on the Root-Tier stand under a fresh lock.", "Rootwarden and myconid guards share the watch now. Mostly they glare.",
         "ROOTWARDEN ON WATCH: (grudging) A barrel a week, carried by the Heralds. That's the deal.", "ROOTWARDEN ON WATCH: ...Lis says it's working."] },
    tower_stair_shut: ["A narrow stair winds up the Council tower toward the Summer Marshal's quarters.",
                       "A Rootwarden sits on the bottom step, spear across his knees.", "\"Sealed,\" he says. \"Thirty years, sealed.\""],
    summer_quarters_sealed: ["The tower stair. A Council seal on the door at the top now, the wax still soft.",
                             "CLERK: (from below) The Marshal's quarters are the Council's evidence now. Nobody goes up."]
  )

  FACTION_RIVAL = { spring: :autumn, autumn: :spring, winter: :summer }
  FACTION_CANDIDATE = { spring: :eirwen, winter: :rheven, autumn: :mira }

  module_function

  #-----------------------------------------------------------------------------
  # The election stance (Tab 8 Q6.3: "Heroes can choose to endorse a candidate,
  # run themselves or remain neutral. Winning a seat allows direct influence over
  # future quests; supporting a candidate garners an ally; remaining neutral
  # leaves the council uncertain.") Asked by Kelyn the first time you see her
  # in the week; or at the vote, if you never did.
  #-----------------------------------------------------------------------------
  def election_stance(at_vote = false)
    return state[:election_stance] if state[:election_stance]
    say(["KELYN: Two empty chairs, Heralds. The city wants to know what you'll do about them.",
         "KELYN: Speak for someone. Stand for a chair yourselves. Or let the city choose alone."])
    opts = [[:endorse, _INTL("Speak for candidates")]]
    opts << [:stand, _INTL("Stand for a chair ourselves")] if !at_vote || nominated?(:heralds)
    opts << [:neutral, _INTL("Stay out of it")]
    c = pbMessage(_INTL("In the election, the Heralds will..."), opts.map(&:last), 0)
    stance = opts[[c, 0].max][0]
    state[:election_stance] = stance
    case stance
    when :stand
      speak(:alberica, "Darlings, I've been on a stage my whole life. Let's sit in a chair for once.",
            "...We'll stand. Somebody should sit in Summer's chair who isn't wearing anybody.")
      if flag?(:wardens_sworn) || flag?(:oath_of_roots)
        say(["KELYN: You'll need five names, or a faction. ...You swore the Wardens' oath here.",
             "KELYN: Spring stands behind you. That's a faction. Your name goes forward."])
        set_flag(:petition_heralds)
        set_flag(:nominated_heralds)
        add_support(:heralds, 1)
      elsif !at_vote
        say(["KELYN: Then you need a petition like anyone else. Five names, or a notable faction."])
        start_petition(:heralds)
      end
    when :neutral
      say(["KELYN: (slowly) ...Neutral. The city will notice that, too. Some will call it wisdom.",
           "KELYN: Some will call it washing your hands. The Council won't know what you are. Nor I."])
      set_flag(:election_neutral)
    else
      say(["KELYN: Then speak where people can hear: the debate stages, in the Bazaar and the Fields."])
    end
    stance
  end

  #-----------------------------------------------------------------------------
  # The Political Favour Track (Tab 1, Seasonal Factions: "PCs may earn standing
  # with one seasonal faction, gaining small boons but inheriting rivalries").
  # Read on the trial week's first morning, and at the vote.
  #-----------------------------------------------------------------------------
  def favour_word(v) = v >= 4 ? :trusted : v >= 2 ? :warm : v <= -2 ? :cold : :neutral

  def favour_boons
    return if flag?(:favour_boons_given)
    set_flag(:favour_boons_given)
    f = state[:favour] || {}
    friends = %i[spring winter autumn].select { |fac| %i[warm trusted].include?(favour_word(f[fac] || 0)) }
    %i[spring winter autumn].each do |fac|
      w = favour_word(f[fac] || 0)
      if w == :cold
        say(["People in #{fac.to_s.capitalize}'s colours turn their backs when you pass.", "Somebody hisses \"murderers\" from a doorway."])
        trial[:mud] += 1
        next
      end
      next if w == :neutral
      case fac
      when :spring
        say(["A warden in Spring's green presses a basket into your hands as you cross the Bazaar.",
             "SPRING WARDEN: Seeds from the Spring Seat's own beds.", "SPRING WARDEN: Kelyn's people remember their friends. We'll speak for you."])
        give(:REVIVALHERB, w == :trusted ? 3 : 2)
        add_opinion(1)
      when :winter
        say(["A Rootwarden in Winter's white falls in beside you, and stays there.",
             "BALANCE WARDEN: Ysera's word. The Order watches its friends this week.", "BALANCE WARDEN: Nobody throws anything while I'm here."])
        trial[:mud] = [trial[:mud] - 1, 0].max
        give(:FULLRESTORE, 1) if w == :trusted
      when :autumn
        say(["A courier in Autumn's gold leaf bows far too low.",
             "AUTUMN COURIER: With the Court's compliments. Splendor rewards its admirers. Discreetly."])
        ($Trainer.money += (w == :trusted ? 4000 : 2000)) rescue nil
        say(["(The purse is heavy. The Court's rivals will hear of it.)"])
      end
    end
    # Inherited rivalries: a faction's friend is its rival's mark.
    friends.each do |fac|
      rival = FACTION_RIVAL[fac]
      next if friends.include?(rival)
      say([{ spring: "AUTUMN COURTIER: (loudly, to nobody) Spring's favourites. On trial for murder.",
             autumn: "SPRING WARDEN: (not quite to you) Gilded by the Court. The tree knows bought gold's smell.",
             winter: "OLD LOYALIST: (spitting) The Order's pets. The Marshal kept this city warm thirty years." }[fac]])
      trial[:mud] += 1
    end
  end

  # At the vote: a faction that trusts you brings its people out for its candidate;
  # one that's cold to you votes against whoever you speak for first.
  def favour_votes(votes, picks)
    f = state[:favour] || {}
    FACTION_CANDIDATE.each do |fac, cand|
      w = favour_word(f[fac] || 0)
      if votes.key?(cand)
        votes[cand] += 1 if w == :warm
        votes[cand] += 2 if w == :trusted
      end
      votes[picks.first] -= 1 if w == :cold && picks.first && votes.key?(picks.first)
    end
    votes
  end

  #-----------------------------------------------------------------------------
  # Reptin's vow at the Chasm ("I'll come back. I swear I'll come back."): the
  # wolves keep their side of it, and send word.
  #-----------------------------------------------------------------------------
  def reptin_wolf_message
    return if !flag?(:reptin_warden_vow) || flag?(:chasm_wolf_came) || !with_or_is?(:reptin)
    set_flag(:chasm_wolf_came)
    rp = herald?(:reptin)
    say(["In the morning a grey wolf sits in the snow outside the Hearth. Thin, scarred, patient.", "Not a Rootwarden's.",
         rp ? "It's waiting for you. You know it. You saw it last at the Chasm, answering your howl." :
              "It's waiting for Reptin. He knows it before he's halfway down the steps."])
    seen = ["The wolf puts its nose in #{rp ? 'your' : "Reptin's"} hand, and you all see it, the way wolves see things: the Chasm, quiet."]
    seen << "The kobolds' fires, lit along the old bridge." if flag?(:kobolds_freed)
    seen << "A yeti and her grown cub fishing at the black water." if flag?(:cub_home) && !flag?(:yeti_mother_dead)
    seen << "A young yeti, alone, keeping the Order's hall swept." if flag?(:yeti_mother_dead)
    seen << "The ghost's candle, still lit, in the sanctum." if flag?(:ghost_blessing)
    seen << "Wolves on the ridge above the lodge, fat for once, watching the road for him." if flag?(:reptin_wolf_calm) || flag?(:fed_pack)
    say(seen)
    speak(:reptin, "(to the wolf, low) I said I'd come back. I will. When winter's done. Tell them.",
          "(to the wolf) ...I'll come back. Tell them.")
    say(["The wolf turns and lopes off toward the Wall, and the snow closes behind it."])
    set_flag(:chasm_watch_kept)
  end

  #-----------------------------------------------------------------------------
  # The trial week's nights (each rest at the Hearth)
  #-----------------------------------------------------------------------------
  def trial_night(day)
    reptin_wolf_message if day >= 3
    pilgrim_dream if day >= 2
    sap_raid if day >= 3 && flag?(:sap_grudge) && !flag?(:sap_raid_done) && !flag?(:sap_settled)
  end

  # rootspire.md Tab 1, Sephek: "appears in visions as a hooded pilgrim offering 'cold blessings'".
  def pilgrim_dream
    return if flag?(:pilgrim_dream)
    set_flag(:pilgrim_dream)
    say(["Last night, you all dreamed the same dream.",
         "A road of packed snow, and a hooded pilgrim walking it beside you, staff tapping the ice.",
         "PILGRIM: (gently) It's so warm in that city. Doesn't it tire you? All that hurry.",
         "PILGRIM: Take a little cold with you. A blessing. It keeps things the way they are.",
         "He holds out a hand. In it, a snowflake that doesn't melt."])
    if with_or_is?(:meat_meat)
      say(["PILGRIM: (to Meat Meat, softer) And you. Prototype Verdant.", "PILGRIM: Your blood remembers the cold table. So do I.",
           herald?(:meat_meat) ? "(Nobody calls you that. Only the cold table did. Your skin crawls.)" :
                                 "MEAT MEAT: (very small) Nobody calls Meat Meat that. Only the cold table did.",
           herald?(:meat_meat) ? nil : "MEAT MEAT: (smaller still) ...Meat Meat does not like this man."].compact)
    end
    if with_or_is?(:alerion)
      say(["PILGRIM: (not looking at Alerion) And you, who listen for the cold. One of us is enough."])
    end
    c = pbMessage(_INTL("The pilgrim's cold blessing..."), [_INTL("Refuse it"), _INTL("Take it")], 0)
    if c == 1
      say(["The snowflake settles on your palm. It's lovely. It's very, very cold.",
           "You wake with frost in your hair. Your lead Pokémon is frozen stiff in its ball."])
      lead = $Trainer.party.find { |pk| !pk.egg? && pk.hp > 0 }
      (lead.status = :FROZEN) if lead rescue nil
      set_flag(:took_cold_blessing)
      wheel(-1)
    else
      say(["The pilgrim smiles, as if refusing were a kind of yes, and walks on into the snow.",
           "You wake. Somebody says \"Sephek\" out loud in the dark, and nobody answers."])
    end
  end

  # rootspire.md Tab 5, the Fane's sap delegation: "Then we'll take it ourselves, one night."
  def sap_raid
    set_flag(:sap_raid_done)
    say(["Past midnight, a sporeling hammers on the Hearth's door, breathless and glowing with fear.",
         "SPORELING: (in your head) Wardens! At the sap vats! With carts!",
         "Down in the Root-Tier: lanterns, Warden Lis and a dozen Rootwardens.", "And carts, already half full of Hyphora's sap."])
    c = pbMessage(_INTL("The sap raid..."), [_INTL("Stand between them and the vats"), _INTL("Talk them down"), _INTL("Let them take it")], 0)
    case c
    when 0
      won = pbTrainerBattle(:FT_ROOTWARDEN, "Oakes", nil, false, 0, true) ? true : false
      if won
        # Warden Lis of the Fane delegation, as she is now (her Ch6 team is version 0)
        key = [:FT_ROOTWARDEN, "Lis", 1]
        GameData::Trainer::DATA[key] ||= GameData::Trainer.new({ id: key, id_number: 9894, trainer_type: :FT_ROOTWARDEN, name: "Lis", version: 1,
          items: [:SUPERPOTION], lose_text: "...Fine. The sap stays. Carry it yourselves, then. Like you said.",
          pokemon: [{ species: :B59H221, level: 55 }, { species: :STANTLER, level: 55 }, { species: :URSARING, level: 56 }] })
        say(["WARDEN LIS: You said you'd carry the sap yourselves. You didn't. So we're carrying it."])
        won = pbTrainerBattle(:FT_ROOTWARDEN, "Lis", nil, false, 1, true) ? true : false
      end
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      if won
        say(["The carts go back down the ramp. Lis stands in the dark, arms folded. Furious. Then tired.",
             "WARDEN LIS: ...Carry it yourselves, then. Like you said. Every week. I'll be counting."])
        set_flag(:sap_raid_stopped)
        set_flag(:sap_settled)
        add_opinion(1)
      else
        say(["The Rootwardens roll the carts up the ramp, and the sap with them."])
        set_flag(:sap_raided)
      end
    when 1
      if challenge("Warden Lis has her hand on the cart.", ["\"Carry it with us. Tonight. By the tree's leave, so much a week.\"",
                                                            "\"The Council will hear about this.\"", "\"Take it and go.\""], 0)
        say(["WARDEN LIS: (a long breath) ...By the tree's leave. You carry the first barrel. Now.", "WARDEN LIS: In your nightclothes.",
             "You carry the first barrel. In your nightclothes. Luminara's spore-guard watch, and nod."])
        set_flag(:sap_settled)
        set_flag(:rootwarden_diplomacy)
      else
        say(["WARDEN LIS: Threats. From people on trial for murder. Good night, Heralds."])
        set_flag(:sap_raided)
      end
    else
      say(["You watch the carts go up the ramp. Nobody says anything."])
      set_flag(:sap_raided)
    end
    if flag?(:sap_raided)
      say(["In the morning the Undercanopy's lanterns are dim, and the myconids won't look at you.",
           "(The spore-guard won't sign anybody's petition this week.)"])
      trial[:mud] += 1
    end
  end

  #-----------------------------------------------------------------------------
  # Summer's quarters, atop the Council tower (Tab 8 Q6: "Infiltrate Avarice's
  # quarters atop the Verdant Council tower. The door is locked (DC 16); inside,
  # the party must avoid magical alarms (Arcana DC 15) and bone-and-ice
  # constructs with Avarice's sigil. Hidden beneath a loose floorboard is a
  # leather ledger...")
  #-----------------------------------------------------------------------------
  def tower_stair(event_id = nil)
    return say(lines_for(:summer_quarters_sealed), event_id) if flag?(:ch10_done)
    return say(lines_for(:tower_stair_shut), event_id) if !flag?(:trials_open)
    return transfer(*SUMMER_QUARTERS) if flag?(:quarters_door_open)
    say(["A narrow stair winds up the Council tower to the Summer Marshal's quarters.", "Thirty years, and nobody up there but him.",
         "Her. Whatever wore him.",
         "The warden on the bottom step is asleep.", "At the top: a door of red-lacquered root, with a lock like a closed fist."], event_id)
    say([cl(:alberica, "\"Ledger to the tower.\" ...I did wonder which tower.")].compact) if flag?(:ledger_trail) && !flag?(:ledger_found)
    return if !pbConfirmMessage(_INTL("Creep up, and get through that door?"))
    opts = []
    opts << [:badge, _INTL("Press the Marshal's badge into the lock")] if ($PokemonBag.pbHasItem?(:FT_MARSHALBADGE) rescue false)
    opts << [:pick, _INTL("Pick the lock (Meat Meat's fingers)")] if with_or_is?(:meat_meat)
    opts << [:feel, _INTL("Feel for the knot in the root that holds it")]
    opts << [:force, _INTL("Force it")]
    c = pbMessage(_INTL("The lock..."), opts.map(&:last), 0)
    ok = case opts[[c, 0].max][0]
         when :badge
           say(["The badge's gold is warm on the lock. The root remembers its Marshal, and lets go."]); true
         when :pick
           say([herald?(:meat_meat) ? "(Small fingers. Clever fingers. The tumblers are root-knots, and knots are just puzzles.)" :
                                      "Meat Meat kneels at the lock, tongue between her teeth. Small fingers. Clever fingers."])
           challenge("The last knot.", ["Ease it round, don't pull", "Yank it", "Bite it"], 0)
         when :feel
           challenge("The root-lock.", ["Find the knot that's warm, and loosen it", "Find the coldest and break it", "Pull everything"], 0)
         else
           say(["The door shudders, and holds. Below you, the warden on the step is very much awake."]); false
         end
    if !ok
      say(["WARDEN ON THE STAIR: Oi! That's sealed for the trial! Down! Down, or I fetch the Captain!",
           "(Word gets round. You'll have to try again, more quietly.)"])
      trial[:mud] += 1
      return
    end
    set_flag(:quarters_door_open)
    say(["The door swings in on a room that smells of hot brass and old perfume."])
    transfer(*SUMMER_QUARTERS)
  end

  def scene_summer_quarters
    return if flag?(:quarters_entered)
    set_flag(:quarters_entered)
    sayc(["The Summer Marshal's quarters. Thirty years of somebody very tidy.",
          "Gold-leaf maps of the Dale on every wall, with pins in. Ten towns. A pin for every name.",
          "Glyphs glow faintly on the floor between you and the desk: alarms, in a neat white hand.",
          "And in the alcove by the desk, something of bone and ice stands very, very still.",
          cl(:alberica, "Mind your feet. A woman who glyphs her own floor doesn't like guests."),
          cl(:wyn, "(very quietly) Don't look at it. Things like that know when you look.")])
  end

  # The alarms: unwrite one, or wake a construct.
  def quarters_glyph(n, event_id = nil)
    key = :"quarters_glyph_#{n}"
    return if flag?(key)
    set_flag(key)
    say(["Your foot comes down on a glyph in her neat white hand. It brightens."], event_id)
    ok = challenge("The alarm glyph.", ["Trace it backwards, and unwrite it", "Jump clear", "Smudge it with your boot"], 0)
    return say(["The glyph unwrites itself, line by line, and goes dark."]) if ok
    say(["The glyph flares white. Out of the corner unfolds a shape of bone and ice.", "Avarice's sigil is burned into its skull."])
    if !skirmish(named_mon(:B105H124, 56, "Bone-and-Ice Construct"))
      say(["It herds you back to the door, and folds itself back into its corner to wait."])
      transfer(*TOWER_STAIR_FOOT)
    end
  end

  def quarters_construct(event_id = nil)
    return say(["Bone and ice in a heap, and a burnt sigil on the skull."], event_id) if flag?(:quarters_construct)
    say(["The construct stands in the alcove by the desk. Avarice's sigil is burned in its skull.",
         "Its head turns. Not all the way. Not yet."], event_id)
    c = pbMessage(_INTL("The construct..."), [_INTL("Slip past while it's still turning"), _INTL("Break it")], 0)
    if c == 0 && challenge("Its head is still turning.", ["Move when it moves, and stop when it stops", "Run for it", "Throw something to distract it"], 0)
      say(["You move when it moves. It stops. You stop. Its empty eyes slide over you, to the door.",
           "You're past. Behind you it folds down into the corner, a heap of bone and ice.", "Waiting for somebody else."])
    else
      say(["Its jaw opens on frost."])
      if !skirmish(named_mon(:B105H124, 57, "Bone-and-Ice Construct"), named_mon(:B105H124, 57, "Bone-and-Ice Construct"))
        say(["It throws you out of the alcove, and takes up its post again."])
        return
      end
      say(["It comes apart in a shower of ice and old bones."])
    end
    set_flag(:quarters_construct)
    set_self_switch(event_id, "A") if event_id
  end

  def quarters_floorboard(event_id = nil)
    if flag?(:ledger_found)
      return say(["The loose floorboard under the desk, and an empty hollow under it."], event_id)
    end
    say(["Under the desk, one floorboard sits a finger higher than the rest."], event_id)
    return if !pbConfirmMessage(_INTL("Lift it?"))
    say(["Under it, wrapped in oilcloth: a leather ledger.",
         "Payments from Frostmaiden cultists, in Halo script.", "Lists of Ten-Towners, town by town, a little cross beside each name.",
         "And on the first page, underlined twice: \"Project Rime: reforge the Everlasting Summer.\""])
    give_key(:FT_CORRUPTLEDGER)
    set_flag(:ledger_found)
    set_flag(:ledger_from_quarters)
    add_counter(:story_beats)
    speak(:alberica, "(very quiet) Bryn Shander's lottery. The Halo paid her to pick the names.",
          "(very quiet) ...Bryn Shander's lottery. She sent them the names.") if with_or_is?(:alberica)
    sayc([cl(:reptin, "This is the sort of thing a Council asks to see. Keep it dry."),
          cl(:alerion, "It's been dry thirty years.")].compact)
  end

  def quarters_wardrobe(event_id = nil)
    say(["A wardrobe of a man's clothes, thirty years out of fashion, pressed, folded, never worn.",
         "A Rootwarden's old cloak at the back, moth-eaten. A child's drawing of a bear on the door."], event_id)
    if flag?(:var_story_known)
      sayc([cl(:alerion, "Var's. From before. She kept his things the way you'd keep the lining of a coat."),
            cl(:reptin, "(very quietly) Somebody drew him a bear.")])
    else
      sayc([cl(:reptin, "Whose are these? Nothing in here is hers, except the order it's all in.")])
    end
    set_flag(:var_wardrobe_seen)
  end

  def quarters_mirror(event_id = nil)
    say(["A tall mirror in a frame of gold leaf, turned to face the wall.",
         "When you turn it back the glass is dark.", "Then something at the very back of it moves, like a smile in a crowd."], event_id)
    return if !flag?(:avarice_faked_death) || flag?(:avarice_revealed)
    set_flag(:avarice_doubt)
    sayc([cl(:meat_meat, "(very still) ...Meat Meat saw that."),
          cl(:alberica, "Saw what, sweetheart? There's nothing there."),
          # (context 09, M9-3: if the doubt was shared at the Forge, they already know)
          cl(:alerion, flag?(:avarice_doubt_shared) ? "(turning it back to the wall) Leave it. We already know." :
                                                      "(turning it back to the wall) Leave it. We'll know soon enough.")])
  end

  #-----------------------------------------------------------------------------
  # Consequences the week carries forward (reaudit D row 15)
  #-----------------------------------------------------------------------------
  # The Canopy under watch, or martial law: wardens on the walkways until the
  # Council's first session.
  def canopy_warden(event_id = nil)
    talk(:canopy_guard, event_id)
    return if !flag?(:canopy_martial_law) || flag?(:checkpoint_done)
    c = pbMessage(_INTL("The checkpoint..."), [_INTL("Show your Warden's oath"), _INTL("Push past")], 0)
    if c == 0 && (flag?(:wardens_sworn) || flag?(:oath_of_roots))
      say(["CHECKPOINT WARDEN: (reading it, embarrassed) ...Wardens. Right. Go on, then. Sorry."])
      set_flag(:checkpoint_done)
    elsif c == 0
      say(["CHECKPOINT WARDEN: An oath? You've sworn nothing under this roof. Papers, or turn round."])
    else
      won = pbTrainerBattle(:FT_ROOTWARDEN, "Checkpoint Warden", nil, false, 0, true) ? true : false
      pbFadeOutIn { $Trainer.heal_party } rescue nil if !won
      set_flag(:checkpoint_done) if won
      say(["(Somebody will tell Selrae about that.)"])
      trial[:mud] += 1 if flag?(:trials_open) && !flag?(:ch10_done)
    end
  end

  # The verdict's geas ("you may not leave Rootspire without the Council's
  # leave"): until the appeal lifts it, or the Council's first session does.
  def geas_binds? = flag?(:verdict_geas) && !flag?(:ch11_done)

  def geas_turns_back(event_id = nil)
    say(["At the Wall your feet stop on their own. The geas: a cold hand flat on your chest.",
         "KELYN'S VOICE, in your head: Not without the Council's leave, Heralds."], event_id)
    pbMoveRoute($game_player, [PBMoveRoute::Right]) rescue nil
  end

  # Eira's missing patrols (Tab 5), found beyond the Wall (GQ4): she hears it.
  def eira_patrol_report
    set_flag(:eira_patrols_reported)
    say(["You tell Eira about the warden in the ice beyond the Wall.", "And the wight with a face like a stopped clock.",
         flag?(:leaf_shattered) ? "And the leaf, shattered in her fist." : "And Brisa, breathing again, with the chronal leaf whole in her hand.",
         "EIRA: (a cold creek, very quiet) ...And my two? The spore-guard who walked with her?",
         "You tell her what Brisa told you: they walked into the stopped snow, and didn't come out.",
         "EIRA: Then they're keeping watch out there still. We'll leave a light at the Echo Gate.",
         "EIRA: You looked. Nobody else would. The spore-guard owes you twice."])
    ($PokemonBag.pbHasItem?(:FT_SPORELANTERN) rescue false) ? give(:REVIVALHERB, 3) : give_key(:FT_SPORELANTERN)
    wheel(1)
  end

  def apply_fix_round_switches
    return if !active? || !$game_switches
    $game_switches[SW_CANOPY_GUARD] = (flag?(:canopy_martial_law) || flag?(:canopy_watched)) && !flag?(:ch11_done)
    $game_switches[SW_SAP_RAID] = flag?(:sap_raid_done)
    $game_switches[SW_BEYOND_WALL] = flag?(:summer_ended) && !geas_binds? if defined?(SW_BEYOND_WALL)
  end

  #-----------------------------------------------------------------------------
  # Hooks into the week's own scenes
  #-----------------------------------------------------------------------------
  class << self
    if method_defined?(:trial_day_passes) && !method_defined?(:ft_fix_trial_day_passes)
      alias ft_fix_trial_day_passes trial_day_passes
      def trial_day_passes
        before = (trial[:day] rescue 1)
        ft_fix_trial_day_passes
        trial_night(trial[:day]) if flag?(:trials_open) && !flag?(:ch10_done) && trial[:day] > before
      rescue StandardError => e
        log("trial night failed: #{e.message}")
      end
    end
    if method_defined?(:scene_trial_morning) && !method_defined?(:ft_fix_scene_trial_morning)
      alias ft_fix_scene_trial_morning scene_trial_morning
      def scene_trial_morning
        had = flag?(:criers_heard)
        ft_fix_scene_trial_morning
        favour_boons if !had && flag?(:criers_heard)
      end
    end
    if method_defined?(:kelyn_trials) && !method_defined?(:ft_fix_kelyn_trials)
      alias ft_fix_kelyn_trials kelyn_trials
      def kelyn_trials(event_id = nil)
        election_stance if flag?(:trials_open) && !flag?(:ch10_done) && !state[:election_stance]
        ft_fix_kelyn_trials(event_id)
      end
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_fix_round_switches
  rescue StandardError => err
    FrostThaw.log("Fix-round switches failed: #{err.message}")
  end
}

#===============================================================================
# The Council's first session (SC 11.04): what the week bought
#===============================================================================
module FrostThaw
  # (notes/11 11.09, dialogue/10 §2: no "darlings" outside Alberica; one box each;
  # notes/15 E5: Rheven remembers the festival he said he'd remember)
  ALLY_GIFTS = {
    rheven: [-> { ["RHEVEN: You spoke for me in the Fields. Take these, from the Rootwardens' stores.",
                   FrostThaw.flag?(:rootwardens_favour) ? "RHEVEN: The festival, and now this. That's two the Rootwardens owe you." : nil].compact },
             :MAXREVIVE, 2],
    mira: [["MIRA: You spoke for me. The Corsairs pay their debts. In coin, usually. Today, in this."], :FULLRESTORE, 3],
    eirwen: [["EIRWEN: You spoke for me. The leaves said you would. These are from the Shrine's stores."], :MAXREVIVE, 2],
    phildendrin: [["PHILDENDRIN: You spoke for a goblin, in public, in front of everyone.",
                   "PHILDENDRIN: Here. Every apothecary in the Bazaar owes me now."], :FULLRESTORE, 3],
    anduin: [["ANDUIN: You spoke for me. For us. Take this to him, wherever he goes. And this, for you."], :MAXREVIVE, 2]
  }

  module_function

  def four_chairs_consequences
    if flag?(:wyn_barred) && !flag?(:wyn_bar_lifted)
      say(["KETHAN: (from the Rootwardens' bench) The Council's first act, by my asking:", "KETHAN: The Rootwardens' stores are open to Wyn again.",
           "KETHAN: Whatever they did or didn't do at that door, they're going north for us now."])
      set_flag(:wyn_bar_lifted)
    end
    if flag?(:canopy_martial_law)
      say(["SELRAE: Martial law on the Canopy ends today. My wardens are needed on the Wall."])
    elsif flag?(:canopy_watched)
      say(["KELYN: And the watch on the Canopy is lifted. Not one Halo candle lit all week."])
    end
    if flag?(:council_heralds)
      say(["KELYN: For the first time in thirty years, Summer's chair holds nobody in disguise.",
           "KELYN: The Heralds sit with us. Their word goes north with them. Choose how you'll go."])
      heralds_pick_route
      give(:MAXREVIVE, 2)
      say(["(The Council's stores are yours to draw on, councillors.)"])
    elsif flag?(:council_uncertain)
      say(["The new councillors look at you, then at each other. Nobody thanks you. Nobody knows how.",
           "KELYN: (carefully) You didn't speak for any of us. We'll send you north.", "KELYN: We don't know what you'll be when you come back."])
    elsif (ally = state[:council_ally]) && ALLY_GIFTS[ally]
      text, item, n = ALLY_GIFTS[ally]
      say(text.respond_to?(:call) ? text.call : text)
      give(item, n)
      set_flag(:council_ally_gift)
    end
    # (notes/15 E5: the Council's "whatever you need", read back where it's needed)
    if flag?(:council_support) && !flag?(:council_support_paid)
      set_flag(:council_support_paid)
      say(["KELYN: Before the trial this Council said \"whatever you need.\" It meant it.",
           "KELYN: Furs, lamp-oil, the Shrine's stores. Take what the north will want."])
      give(:FULLRESTORE, 2)
    end
    darrus_pays
  end

  # Winning a seat "allows direct influence over future quests" (Tab 8 Q6.3).
  def heralds_pick_route
    opts = [[:ship, _INTL("By sea: Mira's Corsairs, on the Boreal Requiem")],
            [:griffons, _INTL("By air: the Skytower clan's griffons")],
            [:whale, _INTL("By the old way: the Wennen bell, and Angajuk")]]
    c = pbMessage(_INTL("The Heralds will go north..."), opts.map(&:last), 0)
    state[:voyage_pick] = opts[[c, 0].max][0]
    say([{ ship: flag?(:mira_left_possessed) ? "FIRST MATE: (from the gallery) The Requiem sails. The captain's not herself. I'll steer." :
                                             "MIRA: (from the gallery) The Requiem's been provisioned for thirty years. It's about time.",
           griffons: "KETHAN: Skytower remembers who carried its wounded down the mountain. Griffons. Dawn.",
           whale: "LUMIN: (both paws on the bell rope already) He'll come. He always comes for the bell." }[state[:voyage_pick]]])
  end

  # Darrus Fell's redemption (rootspire.md Tab 1: "by financing the White Vault
  # expedition"): the coin he swore at the old moorings comes up for the voyage.
  def darrus_pays
    return if !flag?(:darrus_redeemed) || flag?(:darrus_paid)
    set_flag(:darrus_paid)
    chartered = !%i[council_mira council_rheven council_anduin council_heralds].any? { |f| flag?(f) }
    say(["As the Council rises, a Corsair runner pushes through, a crate on her shoulder.",
         "CORSAIR RUNNER: From a man in a borrowed coat who counts barrels.", "CORSAIR RUNNER: He says: for the voyage, and for the vault after it.",
         "Inside: a purse of sap-scrip, furs, lamp-oil, and a note in a very neat hand.",
         "DARRUS'S NOTE: Every coin in Rootspire is buried somewhere. I knew where.", "DARRUS'S NOTE: Some of it was mine. Most of it was hers.",
         "DARRUS'S NOTE: Spend it on the north. The only good thing her money will ever have done."])
    ($Trainer.money += 10000) rescue nil
    give(:FULLRESTORE, 2)
    give(:MAXREVIVE, 1)
    if chartered
      say(["DARRUS'S NOTE: P.S. Nobody you elected has a ship. So I bought you one.", "DARRUS'S NOTE: The Requiem sails when you're ready.",
           "LUMIN: (lowering the bell rope, a little sad) ...Then nobody rings it the long way."])
      state[:flags].delete(:long_voyage) if state[:flags]
      set_flag(:darrus_chartered)
    end
    sayc([cl(:reptin, "He signed it. With his real name. Bravest thing he's ever done."),
          cl(:meat_meat, "Meat Meat will bring him a coffee. When we are back. A small one.")])
  end
end
