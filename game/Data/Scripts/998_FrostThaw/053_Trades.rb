#===============================================================================
# Frost & Thaw - in-game trades
#
# Three of Rootspire's people will trade you a Pokémon once you know them, the
# way X/Y's and Sword and Shield's townsfolk do (owner's ask, 2026-11-11). Each
# wants something that lives near the city, and gives something you can't catch
# here, under a name they chose. One trade each; the offer stands until taken.
#
#   Talwyn (after her secret):        a Delibird  for her Swinub, "Frostina"
#   Dathra (after the Deepfire talk): a Swablu    for her very rude fossil, "Grudge"
#   Gurk   (after the cellar hint):   a Magcargo  for his Scyther, "Whetstone"
#===============================================================================
module FrostThaw
  TRADES = {
    talwyn: { want: :DELIBIRD, give: :SWINUB, nick: "Frostina", ot: "Talwyn", gender: 1,
              ask: ["TALWYN: Can I ask you something? Not as a guard. As a person.",
                    "TALWYN: Have you got a Delibird? They deliver things. That's basically guarding.",
                    "TALWYN: I'd trade you my Swinub for one. His name's Frostina. He's a boy. He doesn't mind."],
              again: ["TALWYN: My offer's still open! A Delibird for Frostina. He grunted at you. That means hello."],
              thanks: ["TALWYN: (hugging the Delibird, which puts up with it) Thank you! Frostina, be good.",
                       "TALWYN: ...He's already eating something. Look after him. He likes his nose scratched."],
              done: ["TALWYN: The Delibird's guarding my boots. How's Frostina? Is he eating? He's always eating."] },
    dathra: { want: :SWABLU, give: :KABUTO, nick: "Grudge", ot: "Dathra", gender: 1,
              ask: ["DATHRA: (snap) Business. That very rude fossil I mentioned? I woke it up. It bites.",
                    "DATHRA: I want a Swablu for it. Cotton wings. Nobody below has ever seen a cloud.",
                    "DATHRA: They'll pay me a fortune just to touch one."],
              again: ["DATHRA: (snap) A Swablu, and the fossil's yours. It's still rude. It hasn't changed its mind."],
              thanks: ["DATHRA: (stroking the Swablu with one finger) Oh. Oh, that's soft. I'm not selling this one.",
                       "DATHRA: The fossil's called Grudge. It earned the name. Keep your fingers clear."],
              done: ["DATHRA: (the Swablu asleep on her shoulder) Don't. I know. I said I'd sell it. I lied."] },
    gurk:   { want: :MAGCARGO, give: :SCYTHER, nick: "Whetstone", ot: "Gurk", gender: 0,
              ask: ["GURK: You know an edge when you see one. So: a trade.",
                    "GURK: Bring me a Magcargo. A living forge. I'd never have to light a fire again.",
                    "GURK: For it, my Scyther. I've kept its arms sharp for six years. It's ready for a real fight."],
              again: ["GURK: A Magcargo for my Scyther. The offer's still hot. Like the Magcargo will be."],
              thanks: ["GURK: (holding his hands over the Magcargo like a stove) Ahh. Blood in the steel, fire in the shell.",
                       "GURK: Whetstone's yours. Mind its arms. And keep them sharp. I'll check."],
              done: ["GURK: The Magcargo's asleep in the forge. Best apprentice I've ever had. Never talks back."] }
  }

  module_function

  def offer_trade(key, event_id = nil)
    t = TRADES[key]
    done = :"trade_#{key}"
    return say(t[:done], event_id) if flag?(done)
    asked = :"trade_#{key}_asked"
    say(flag?(asked) ? t[:again] : t[:ask], event_id)
    set_flag(asked)
    want = (GameData::Species.get(t[:want]).name rescue t[:want].to_s.capitalize)
    give_name = (GameData::Species.get(t[:give]).name rescue t[:give].to_s.capitalize)
    if $Trainer.party.none? { |pk| pk && !pk.egg? && pk.species == t[:want] }
      return say(["(You don't have a #{want} with you.)"], event_id)
    end
    return if !pbConfirmMessage(_INTL("Trade your {1} for {2}'s {3}, {4}?", want, t[:ot], give_name, t[:nick]))
    saved = [$game_variables[1], $game_variables[2]]
    begin
      pbChooseTradablePokemon(1, 2, proc { |pk| pk.species == t[:want] })
      idx = $game_variables[1].to_i
      return if idx < 0 || !$Trainer.party[idx] || $Trainer.party[idx].species != t[:want]
      pbStartTrade(idx, t[:give], t[:nick], t[:ot], t[:gender])
    ensure
      $game_variables[1], $game_variables[2] = saved
    end
    set_flag(done)
    add_counter(:trades)
    say(t[:thanks], event_id)
  rescue StandardError => e
    log("offer_trade(#{key}) failed: #{e.class}: #{e.message}")
  end
end

# The three offers come after each person's own business is done
module FrostThaw
  class << self
    unless method_defined?(:ft_t_talwyn)
      alias ft_t_talwyn talwyn
      def talwyn(event_id = nil)
        ready = flag?(:talwyn_told)
        ft_t_talwyn(event_id)
        offer_trade(:talwyn, event_id) if ready
      end
      alias ft_t_dathra dathra
      def dathra(event_id = nil)
        ready = flag?(:met_dathra) && (flag?(:dathra_turned) || flag?(:dathra_buyer))
        ft_t_dathra(event_id)
        offer_trade(:dathra, event_id) if ready
      end
      alias ft_t_gurk gurk
      def gurk(event_id = nil)
        ready = flag?(:cellar_hint)
        ft_t_gurk(event_id)
        offer_trade(:gurk, event_id) if ready
      end
    end
  end
end
