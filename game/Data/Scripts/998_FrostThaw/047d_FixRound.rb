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
    korun_scorn: ["Korun looks at your Pokémon, then at your bag, and releases a long, scornful puff of spores.",
                  "KORUN: (Neglect. Made things remember who neglected them.)"],
    sap_raid_after: ["The sap vats on the Root-Tier stand under a fresh lock. Rootwarden and myconid guards share the watch now. Mostly they glare."],
    canopy_guard: -> {
      T.flag?(:canopy_martial_law) ?
        ["WARDEN ON THE WALKWAY: Papers, Herald. ...Martial law. Selrae's orders. I don't like it either.",
         "WARDEN ON THE WALKWAY: Go on. And don't run. Running looks like something."] :
        ["WARDEN ON THE WALKWAY: Just watching, Herald. Kelyn's compromise. Watch the Rift, watch the walkways.",
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
      say(["He takes each Poké Ball in turn, breathes spores over it, and taps it with his hammer, once.",
           "Something in every one of your Pokémon settles, like a strap pulled tight. (Every move's PP is restored.)",
           "KORUN: (Mended. Respect it.)"])
    when :craft
      korun_craft
    when :toy
      set_flag(:korun_toy)
      say(["At the word 'sporeling', the big myconid goes very still. Then he sets down the hammer.",
           "His thick fingers pull a strand of hyphae off the bench and twist it, and twist it, and it's a little wolf.",
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
    say(["On the bench: a whip grown from a vine, still twitching. Amber stones, sticky to the touch. A thick bracelet of bark."])
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
      say(["LUMINARA: You swore to protect her. And you brought the surface down to sit on our floor and listen.",
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
