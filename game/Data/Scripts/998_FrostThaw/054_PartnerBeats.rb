#===============================================================================
# Frost & Thaw - your Pokémon at the centre of the story
#
# The editor's pass before launch (owner, 2026-11-11: "make Pokémon necessary in
# three or four key story moments"). In these beats it's one of your own
# Pokémon, out of its ball and on screen, that carries the moment. None of them
# is a battle.
#
#   1. The landing in Targos (New Journey): your first Pokémon climbs into your
#      coat and keeps you alive until the Heralds find you.
#   2. Good Mead burning (Ch9): the Pokémon that gets the mead hall door open is
#      shown, and how it does it depends on what it is.
#   3. Auril's last offer (New Journey): "Nobody would ever change." Your first
#      Pokémon steps between you, and it has grown since festival morning.
#   (Already in the story: the yeti mother letting you pass because her cub is
#   in your Poké Ball; Sableye's claws holding Wyn's way home; Frostina's song.)
#===============================================================================
module FrostThaw
  module_function

  # The Pokémon you chose on festival morning, if it's with you; else your lead.
  def first_partner
    mons = ($Trainer.party.compact.reject(&:egg?) rescue [])
    pid = state[:starter_pid]
    (pid && mons.find { |pk| (pk.personalID rescue nil) == pid }) || mons.find { |pk| !pk.fainted? } || mons.first
  end

  def first_partner_is_starter?(pk)
    pk && state[:starter_pid] && (pk.personalID rescue nil) == state[:starter_pid]
  end

  def show_partner(pk)
    return if !pk
    Stage.partner_out(pk) rescue nil
    Stage.cry(pk.species) rescue nil
  end

  def hide_partner
    Stage.partner_in rescue nil
  end

  # 1. Targos pier, the first minute in the Dale
  def partner_keeps_you_warm
    pk = first_partner
    return if !pk || flag?(:partner_warmed_you)
    set_flag(:partner_warmed_you)
    say(["Something knocks against your hip. Your Poké Ball pops open on its own."])
    show_partner(pk)
    say(["#{pk.name} takes one look at the snow and climbs straight inside your coat.",
         "It's warm. Between the two of you, you might last until somebody comes."])
    hide_partner
  end

  # 2. The mead hall door at Good Mead
  def door_helper(event_id = nil)
    able = ($Trainer.party.compact.reject { |pk| pk.egg? || pk.fainted? } rescue [])
    water = able.find { |pk| (pk.hasType?(:WATER) rescue false) }
    strong = able.find { |pk| pk.moves.any? { |m| m && (m.id == :STRENGTH || (GameData::Move.get(m.id).type == :FIGHTING rescue false)) } }
    pk = water || strong || able.first
    if !pk
      who = with_or_is?(:reptin) && !herald?(:reptin) ? "Reptin" : "You"
      return say(["#{who} #{who == 'You' ? 'hit' : 'hits'} the door. Once. Twice."], event_id)
    end
    show_partner(pk)
    if pk == water
      say(["#{pk.name} soaks the frame until the wood stops smoking and shrinks back.",
           "Then you put your shoulder to the door, together. Once. Twice."], event_id)
    elsif pk == strong
      say(["#{pk.name} hits the door. Once. Twice."], event_id)
    else
      say(["#{pk.name} throws itself at the door with you. Once. Twice."], event_id)
    end
    hide_partner
  end

  # 3. Auril's offer: everything at home kept exactly as it is
  def partner_answers_auril
    pk = first_partner
    return if !pk
    show_partner(pk)
    if first_partner_is_starter?(pk) && pk.species != state[:starter]
      say(["#{pk.name} comes out of its ball without being asked, and plants itself between you and her.",
           "On festival morning it fitted in your two hands. Look at it now."])
    elsif first_partner_is_starter?(pk)
      say(["#{pk.name} comes out of its ball without being asked, and plants itself between you and her.",
           "It's no bigger than it was on festival morning. It isn't the same, though. Neither are you."])
    else
      say(["#{pk.name} comes out of its ball without being asked, and plants itself between you and her."])
    end
    say(["AURIL: ...That one grew. They always do."])
    hide_partner
  end
end
