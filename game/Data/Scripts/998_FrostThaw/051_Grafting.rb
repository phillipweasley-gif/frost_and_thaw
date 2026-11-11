#===============================================================================
# Frost & Thaw - grafting in the story (owner's call, 2026-11-11: "Let's do 1-4")
#
# Wynsnow's licence (026 wynsnow, SC 6.05) opens the Cocoon Chamber a third of
# the way in. Before this file it was the last the story said about grafting.
#  1. The jar Wynsnow holds up hatches in front of you, and the graft is yours
#     (first_graft_gift).
#  2. The world grafts too. A few trainers carry one graft each, chosen by hand,
#     and bring it out before the battle so you see what it is (GRAFTS,
#     graft_reveal). The mod's own random grafting of every NPC team stays off in
#     a Frost & Thaw save (009_CocoonFusion): it rebuilt hand-made teams, and the
#     Pokémon their lines name, after the licence.
#  3. The party reacts when you graft: Meat Meat the first time she sees it
#     (she was made by a Joining, and the subtext stays subtext: dialogue 06 §4),
#     then one line from whoever's with you (graft_reaction).
#  4. Hyphora knows a graft when her roots find one, and gives you something for
#     the next (hyphora_graft, from 032 scene_root_chapel). Never required.
#===============================================================================
module FrostThaw
  # [trainer type, name] => what that trainer grafted, and what they say about it.
  #   base:     the species in their party that took the graft
  #   donor:    the species that gave itself
  #   versions: which versions of the trainer carry it (nil: all)
  #   pre:      said before the Pokémon comes out; lines: said while it's out
  GRAFTS = {
    # The College: Wynsnow's students (2063). They may be fought before the licence;
    # then their teams are as written and nothing is said.
    [:FT_SCHOLAR, "Quill"] => {
      base: :XATU, donor: :NOCTOWL,
      lines: ["QUILL: My thesis. Xatu took a Noctowl into its cocoon.",
              "QUILL: One sees the future, one sees in the dark. Now it does both. Mostly."]
    },
    # Gym 6 (the Undercanopy): Luminara's ace
    [:FT_SOVEREIGN, "Luminara"] => {
      base: :B45H439, donor: :PARASECT,
      lines: ["LUMINARA: (wind through reeds) Our oldest way. A flower and a cap, one cocoon.",
              "LUMINARA: Vileplume gave room. Parasect gave spores. Taste them."]
    },
    # Gym 5 (the Guild): Hew's ace
    [:FT_GUILDMASTER, "Hew"] => {
      base: :B76H208, donor: :DUGTRIO,
      lines: ["HEW: (thumbing a Ball) My Golem took a Dugtrio in. My first week in the Guild.",
              "HEW: Forty years. Best digger I've ever had."]
    },
    # Gym 6 (the Requiem): Mira, free or not
    [:FT_CORSAIR_CAPT, "Mira"] => {
      base: :B130H196, donor: :KINGDRA,
      lines: -> {
        flag?(:mira_left_possessed) ?
          ["MIRA: (both voices) Our Gyarados took a Kingdra into its cocoon. A graft is for keeps.",
           "MIRA: (both voices) We know all about keeping."] :
          ["MIRA: (a Ball in her fist) My Gyarados took a Kingdra into its cocoon, the year before the mirrors.",
           "MIRA: Let's see if it still knows me."]
      }
    },
    # Gym 8 (Selrae's dream)
    [:FT_WINTER_MATRON, "Selrae"] => {
      base: :B221H215, donor: :JYNX,
      lines: ["SELRAE: My Piloswine took a Jynx into its cocoon.",
              "SELRAE: Even winter can make room for someone."]
    },
    # The rival's send-off (038 tamsin_final). Only that battle: version 2.
    [:FT_TAMSIN_I, "Tamsin"] => {
      base: :FURRET, donor: :HOOTHOOT, versions: [2],
      pre:   ["TAMSIN: And I've got a licence now. Wynsnow says I'm a natural. LOOK."],
      lines: ["TAMSIN: Furret and my Hoothoot. One cocoon. Now it can see in the dark.",
              "TAMSIN: It's terrifying. I love it."]
    }
  }

  # Wynsnow's jar (SC 6.05): which two, and the level of the result.
  JAR_GRAFT = { base: :NATU, donor: :SUNKERN, level: 34 }

  module_function

  def grafting_live?
    defined?(CocoonFusion) && flag?(:grafting)
  end

  def graft_entry(type, name, version = nil)
    e = GRAFTS[[type, name]]
    return nil if !e
    return nil if e[:versions] && !e[:versions].include?(version || 0)
    e
  end

  # One graft, the same every time for the same trainer (the mod's own rule for NPCs).
  def graft_onto!(pkmn, donor_species, seed)
    donor = Pokemon.new(donor_species, pkmn.level, $Trainer, false)
    CocoonFusion.merge!(pkmn, donor, moves: :base, level_mode: :classic, rng: Random.new(Zlib.crc32(seed.to_s)))
    pkmn.heal
    pkmn
  end

  # pbLoadTrainer, after the mod: the hand-picked graft, once the licence exists.
  def graft_trainer!(trainer, tr_type, tr_name, tr_version)
    return if !active? || !grafting_live? || !trainer
    type_id = (GameData::TrainerType.try_get(tr_type)&.id rescue nil) || tr_type
    e = graft_entry(type_id, tr_name, tr_version)
    return if !e
    pk = trainer.party.find { |p| p && !p.egg? && p.species == e[:base] && !p.cocoon_merged? }
    graft_onto!(pk, e[:donor], "#{type_id}|#{tr_name}") if pk
  rescue StandardError => ex
    log("graft_trainer!(#{tr_name}): #{ex.message}")
  end

  # What the trainer's graft looks like, for showing before the battle.
  def graft_preview(type, name, e)
    graft_onto!(Pokemon.new(e[:base], 40), e[:donor], "#{type}|#{name}")
  rescue StandardError => ex
    log("graft_preview(#{name}): #{ex.message}")
    nil
  end

  # Before the battle: the trainer brings the graft out and says what it is, the
  # first time you fight them with it. Returns true when something was shown.
  def graft_reveal(type, name, version = 0, event_id = nil)
    return false if !active? || !grafting_live?
    e = graft_entry(type, name, version)
    return false if !e
    seen = :"graft_seen_#{type}_#{name.to_s.downcase.gsub(/\W+/, '_')}"
    return false if flag?(seen)                  # once: a rematch after a loss doesn't repeat it
    set_flag(seen)
    pre = e[:pre]
    pre = pre.call if pre.respond_to?(:call)
    lines = e[:lines]
    lines = lines.call if lines.respond_to?(:call)
    say(pre, event_id) if pre
    pk = graft_preview(type, name, e)
    begin
      Stage.partner_out(pk) if pk
      say(lines, event_id)
    ensure
      Stage.partner_in
    end
    true
  rescue StandardError => ex
    log("graft_reveal(#{name}): #{ex.message}")
    false
  end

  # For trainers fought through trainer(key) (016 trainer_intro).
  def graft_reveal_key(key, event_id = nil)
    t = TRAINERS[key]
    return false if !t
    graft_reveal(t[0], t[1], 0, event_id)
  end

  #-----------------------------------------------------------------------------
  # 1. The jar hatches (SC 6.05, after the rules). The graft is yours.
  #-----------------------------------------------------------------------------
  def first_graft_gift(event_id = nil)
    return if flag?(:jar_graft) || !defined?(CocoonFusion)
    wyn = stage_event(event_id)
    x, y = wyn ? [wyn.x + 1, wyn.y] : [$game_player.x + 1, $game_player.y - 1]
    pk = Pokemon.new(JAR_GRAFT[:base], JAR_GRAFT[:level])
    sun = Pokemon.new(JAR_GRAFT[:donor], JAR_GRAFT[:level])
    CocoonFusion.merge!(pk, sun, moves: :base, level_mode: :classic)
    pk.heal
    pbSEPlay("Battle damage weak") rescue nil
    say(["Something taps inside the jar. A crack runs round the cocoon.",
         "WYNSNOW: Oh! Early. Nothing in this room keeps time with you lot in it.",
         "He tips the cocoon out onto the boards. It rocks."], event_id)
    cocoon = Stage.actor(:jar_cocoon, x, y, 4, graphic: "FT_prop_cocoon")
    Stage.pose(cocoon, "FT_prop_cocoon", 1, frames: [0, 1, 2, 3, 0, 1, 2, 3], per: 5) if cocoon
    pbSEPlay("Battle recall") rescue nil
    Stage.remove_actor(cocoon) if cocoon
    begin
      Stage.partner_out(pk)
      sayc(["The cocoon splits down the middle. One Pokémon climbs out, blinking.",
            "WYNSNOW: A Natu and a Sunkern. One watches the sun, one drinks it. They were never going to be apart.",
            "WYNSNOW: Both of them, and neither. The Sunkern gave itself, and the Natu kept it.",
            cl(:alberica, "Oh, look at its face. It's got both their faces. Sort of. Mostly the leaves."),
            "WYNSNOW: Take it. A licence wants a first graft, and that one will want a window. I work in the dark."], event_id)
    ensure
      Stage.partner_in
    end
    set_flag(:jar_graft)
    pbAddPokemon(pk) rescue log("first_graft_gift: #{$!.message}")
  rescue StandardError => e
    log("first_graft_gift: #{e.message}")
  end

  #-----------------------------------------------------------------------------
  # 3. When you graft (the Cocoon Chamber, any PC)
  #-----------------------------------------------------------------------------
  GRAFT_LINES = {
    alberica:  "Oh, look at it. Somebody write it a song. ...Fine. Me. I'll do it.",
    reptin:    "Seedlings remember. That one's going to remember both of them.",
    wyn:       "(a hand on its head) It smells like both of them. Like a wood after rain.",
    alerion:   "(looking at it a long time) ...It doesn't look lost.",
    glimmer:   "(the horn humming in his hand) New body, same heart. It takes a while to fit. It'll get there.",
    shade:     "(turning the Rimefang over) For keeps, the Professor said. ...Nothing's for keeps.",
    meat_meat: "(walking all the way round it) Both still in there. Meat Meat checks every time."
  }
  # Who answers Meat Meat's question, first one with you.
  GRAFT_ANSWERS = [
    [:alberica, "Slept right through it, love. Look. Not a scratch."],
    [:reptin,   "No. It slept. Like a seed in the ground."],
    [:wyn,      "(softly) It was asleep. It didn't even dream. ...I'd know."],
    [:glimmer,  "No. Waking up's the strange part. Trust me."],
    [:shade,    "No. It went to sleep and woke up bigger. I've had worse nights."],
    [:alerion,  "No."]
  ]

  def graft_reaction(pk)
    add_counter(:grafts)
    set_flag(:first_graft)
    begin
      Stage.partner_out(pk) if pk
      if with_or_is?(:meat_meat) && !flag?(:mm_saw_graft)
        set_flag(:mm_saw_graft)
        answer = GRAFT_ANSWERS.find { |k, _| companions.include?(k) }
        sayc([herald?(:meat_meat) ? "You can't stop looking at the place where the cocoon was." :
                                    "Meat Meat is staring at the place where the cocoon was.",
              ask_cl(:meat_meat, "...Did it hurt? In there?", "...Did it hurt?"),
              answer ? as(answer[0], answer[1]) : "Nobody answers.",
              cl(:meat_meat, "(walking all the way round it, slowly) Both still in there. Meat Meat checked.")])
      else
        here = GRAFT_LINES.keys.select { |k| companions.include?(k) }
        k = here[(counter(:grafts) - 1) % here.size] if !here.empty?
        say([as(k, GRAFT_LINES[k])]) if k
      end
    ensure
      Stage.partner_in
    end
  rescue StandardError => e
    log("graft_reaction: #{e.message}")
  end

  #-----------------------------------------------------------------------------
  # 4. Hyphora's roots find a graft (SC 7A.07). A reward, never a gate.
  #-----------------------------------------------------------------------------
  def hyphora_graft
    return if flag?(:hyphora_graft) || !defined?(CocoonFusion)
    pk = ($Trainer.party.find { |p| p && !p.egg? && p.respond_to?(:cocoon_merged?) && p.cocoon_merged? } rescue nil)
    return if !pk
    set_flag(:hyphora_graft)
    begin
      Stage.partner_out(pk)
      sayc(["A root finds #{pk.name} and stops. It feels it all over, the way you'd read a face in the dark.",
            "HYPHORA: Two in one. My old way. Someone up in my branches still remembers.",
            "HYPHORA: Then take this. For the next two.",
            "A thread of root ties itself into a knot in your hand.",
            cl(:wyn, "(very softly) She sounds proud.")])
    ensure
      Stage.partner_in
    end
    give(:DESTINYKNOT)
    say(["(Held by either Pokémon in a graft, it carries more of both into the cocoon.)"])
  rescue StandardError => e
    log("hyphora_graft: #{e.message}")
  end
end

#-------------------------------------------------------------------------------
# The hooks
#-------------------------------------------------------------------------------
if defined?(CocoonFusion)
  if (Object.private_method_defined?(:pbLoadTrainer) || Object.method_defined?(:pbLoadTrainer)) &&
     !Object.private_method_defined?(:ft_graft_pbLoadTrainer) && !Object.method_defined?(:ft_graft_pbLoadTrainer)
    alias ft_graft_pbLoadTrainer pbLoadTrainer
    def pbLoadTrainer(tr_type, tr_name, tr_version = 0)
      trainer = ft_graft_pbLoadTrainer(tr_type, tr_name, tr_version)
      FrostThaw.graft_trainer!(trainer, tr_type, tr_name, tr_version) if trainer
      trainer
    end
  end

  if defined?(CocoonFusion::MergeMenu) && CocoonFusion::MergeMenu.respond_to?(:run)
    module CocoonFusion
      module MergeMenu
        class << self
          alias ft_orig_run run unless method_defined?(:ft_orig_run)
          def run(*args)
            before = ($Trainer.party.map { |p| [p, p.cocoon_generation.to_i] } rescue [])
            ok = ft_orig_run(*args)
            if ok && FrostThaw.active?
              pk = before.find { |p, g| p && $Trainer.party.any? { |q| q.equal?(p) } && p.cocoon_generation.to_i > g }
              FrostThaw.graft_reaction(pk && pk[0])
            end
            ok
          end
        end
      end
    end
  end
end
