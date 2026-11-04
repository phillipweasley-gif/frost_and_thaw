#===============================================================================
# Frost & Thaw - ways to get back on your feet in Targos
#
#  * The Commons: a patch of snowy grass inside the palisade with wild Pokémon,
#    so you can catch a second Pokémon before the first gym.
#  * The fisher's widow gives you her husband's Spheal (once).
#  * The Sparring Ring: three townsfolk you can battle again and again. Their
#    teams match your strongest Pokémon, they pay prize money, losing costs
#    nothing and your team is healed afterwards.
#  * Kip's Cups: a shell game in the alley by the Pokémon Center. Follow the
#    Poké Ball and double your bet. Broke players get a free round.
#===============================================================================
module FrostThaw
  # --- wild Pokémon in the Commons -------------------------------------------------
  ENCOUNTERS[2001] = { step_chances: { Land: 21 },
                       Land: [[20, :SNORUNT, 3, 5], [20, :SWINUB, 3, 5], [15, :ZIGZAGOON, 3, 5],
                              [15, :SENTRET, 3, 5], [10, :PIDGEY, 3, 5], [10, :SPHEAL, 4, 6],
                              [10, :HOOTHOOT, 3, 5]] }

  TEXT.merge!(
    targos_sign_commons: ["THE COMMONS - Grazing land inside the wall. Mind the wild Pokémon in the drifts."],
    targos_sign_ring:    ["SPARRING RING - Fight as often as you like. No coin lost, no hard feelings.",
                          "Your Pokémon are patched up if you lose."],
    kip_hint:            ["KIP: Psst. Three cups, one Poké Ball. Talk to me if you've got sharp eyes."]
  )

  module_function

  # --- the widow's Spheal -------------------------------------------------------------
  def widow_gift(event_id = nil)
    if flag?(:husband_thawed) && !flag?(:widow_told)
      set_flag(:widow_told)
      return say(["WIDOW: ...Alive? He's alive? Out on the ice at Dougan's Hole, all this time?",
                  "WIDOW: He said to keep the lamp lit. He always says that. He always says that.",
                  "She's laughing and crying at once.",
                  "By the door, the little Spheal wriggles. It would be wagging, if it had a tail."], event_id)
    end
    if flag?(:widow_told)
      return say(["WIDOW: The lamp's lit. Every night, until he's home. Thank you. Thank you."], event_id)
    end
    if flag?(:widow_spheal)
      return say(["WIDOW: My husband's Spheal... is she well? Good. He'd have liked you."], event_id)
    end
    say(lines_for(:fisher_widow), event_id)
    if pbAddPokemon(:SPHEAL, 6)
      set_flag(:widow_spheal)
    else
      say(["WIDOW: Oh... you've no room for her. Come back when you do."], event_id)
    end
  rescue StandardError => e
    log("widow_gift failed: #{e.message}")
  end

  # --- Epheris's cataloguer (the Pokédex) ---------------------------------------------
  # SC 1.04 - Made to be found
  def epheris(event_id = nil)
    set_flag(:got_pokedex) if ($Trainer.has_pokedex rescue false)   # a save from before he handed it out
    if flag?(:relics_are_lures)
      return say(lines_for(:epheris_thornweald), event_id)
    end
    if !flag?(:met_party)
      return say(["EPHERIS: Relics from across the Dale. Old, odd, and occasionally cursed.",
                  "EPHERIS: No refunds on the cursed ones."], event_id)
    end
    say(["EPHERIS: Put those down. Not on the counter. On the floor.",
         as(:reptin, "(setting the medallion down very gently) Of course. So sorry. Is the floor also cursed?"),
         "EPHERIS: Five people. Five cold trinkets. All found where you'd find them, right when you'd find them.",
         "EPHERIS: That's not luck. That's bait.",
         as(:alberica, "Bait for what?"),
         "EPHERIS: For you. Somebody wanted you here.",
         "He holds a compass needle over the pendant. It swings south-east, and stays there.",
         "EPHERIS: And they want you closer still. South-east is Dougan's Hole.",
         "EPHERIS: Nothing in Dougan's Hole but ice, and people who don't like you.",
         as(:alerion, "Someone went to a lot of trouble."),
         herald?(:alberica) ? "(Pretty boy's right. Nobody leaves me presents unless they want something.)" :
                              "ALBERICA: Pretty boy's right. Nobody leaves me presents unless they want something.",
         "SHIMMER: Then that's where it is."].compact, event_id)
    set_flag(:relics_are_lures)
    state[:goal] = flag?(:badge_targos) ? "Find who's calling us. South-east, past Bryn Shander, to Dougan's Hole." :
                                          (flag?(:naerth_terms) ? "Win Speaker Naerth's seal at the Town Hall. It opens the south-west gate." :
                                                                 "Get Speaker Naerth's seal to leave Targos. He does business at the Luskan Arms.")
    if flag?(:got_pokedex) || ($Trainer.has_pokedex rescue false)
      set_flag(:got_pokedex)
      return
    end
    say(["EPHERIS: Take this. I used to catalogue relics for men in towers.",
         "EPHERIS: Catalogue something alive, for a change."], event_id)
    $Trainer.has_pokedex = true
    set_flag(:got_pokedex)
    pbMEPlay("Key item get") rescue nil
    pbMessage(_INTL("You received the Pokédex!"))
    say(["EPHERIS: It lives in your pack now. Open it from your menu whenever you like."], event_id)
  rescue StandardError => e
    log("epheris failed: #{e.message}")
  end

  # --- the trapper's snowshoes (running shoes) --------------------------------------------
  def snowshoes(event_id = nil)
    if flag?(:got_snowshoes) || ($Trainer.has_running_shoes rescue false)
      set_flag(:got_snowshoes)
      return say(lines_for(:center_traveler), event_id)
    end
    say(["TRAPPER: You're walking the drifts like that? You'll be all winter getting anywhere.",
         "TRAPPER: Here. I carved a spare pair of snowshoes on the boat from Easthaven.",
         "TRAPPER: Light as anything. Go on, take them. I've only got the two feet."], event_id)
    $Trainer.has_running_shoes = true
    set_flag(:got_snowshoes)
    pbMEPlay("Key item get") rescue nil
    pbMessage(_INTL("You got the Snowshoes!"))
    pbMessage(_INTL("Hold the run button to run: over snow, ice, or anything else."))
    say(lines_for(:center_traveler), event_id)
  rescue StandardError => e
    log("snowshoes failed: #{e.message}")
  end

  # --- the Sparring Ring ----------------------------------------------------------------
  # key => class, name, how many levels above/below your best Pokémon,
  #        extra team members, and species by level band (<16, <30, 30+)
  SPARRING = {
    spar_tess: { type: :PICNICKER, name: "Tess", offset: -2, extra: 0,
                 pools: [[:SWINUB, :SENTRET, :PIDGEY], [:PILOSWINE, :FURRET, :PIDGEOTTO], [:MAMOSWINE, :FURRET, :PIDGEOT]],
                 hello: "TESS: Want to warm up? I go easy. Mostly. Sometimes.",
                 win:   "TESS: Ha! Good work. Come back whenever.",
                 loss:  "TESS: Don't worry about it. Patch up and try again!" },
    spar_brin: { type: :SAILOR, name: "Brin", offset: -1, extra: 1,
                 pools: [[:TENTACOOL, :SHELLDER, :WINGULL], [:TENTACRUEL, :SEEL, :PELIPPER], [:TENTACRUEL, :DEWGONG, :CLOYSTER]],
                 hello: "BRIN: Nothing to sail on till the thaw. Might as well spar. You in?",
                 win:   "BRIN: You fight like a squall. Again sometime?",
                 loss:  "BRIN: The lake's hard on everyone. Have another go when you're ready." },
    spar_jod:  { type: :WORKER, name: "Jod", offset: 0, extra: 1,
                 pools: [[:MACHOP, :GEODUDE, :SWINUB], [:MACHOKE, :GRAVELER, :PILOSWINE], [:MACHAMP, :GOLEM, :MAMOSWINE]],
                 hello: "JOD: I haul timber all day and spar all night. Beat me and I pay well. Ready?",
                 win:   "JOD: Hah! Worth every coin. Same time tomorrow?",
                 loss:  "JOD: No shame in it. Rest up and come back swinging." }
  }

  def spar_level(info)
    best = ($Trainer.party.map(&:level).max rescue nil) || 5
    [[best + info[:offset], 3].max, 100].min
  end

  def spar_party(info, level)
    band = level < 16 ? 0 : (level < 30 ? 1 : 2)
    badges = ($Trainer.badge_count rescue 0) || 0
    size = [1 + info[:extra] + badges / 2, 3].min
    pool = info[:pools][band]
    (0...size).map { |i| { species: pool[i % pool.size], level: [level - (size - 1 - i), 2].max } }
  end

  def register_spar_trainer(info, level)
    hash = { id: [info[:type], info[:name], 0], id_number: 9900, trainer_type: info[:type], name: info[:name],
             version: 0, items: [], lose_text: info[:win], pokemon: spar_party(info, level) }
    GameData::Trainer::DATA[[info[:type], info[:name], 0]] = GameData::Trainer.new(hash)
  end

  def spar(key, event_id = nil)
    info = SPARRING[key]
    return log("Unknown sparring partner #{key}") if !info
    say([info[:hello]], event_id)
    return if !pbConfirmMessage(_INTL("Spar with {1}?", info[:name]))
    register_spar_trainer(info, spar_level(info))
    sw = (Settings::NO_MONEY_LOSS rescue 33)
    old = $game_switches[sw]
    $game_switches[sw] = true                     # a spar never costs you money
    won = pbTrainerBattle(info[:type], info[:name], nil, false, 0, true)
    $game_switches[sw] = old
    say([won ? info[:win] : info[:loss]], event_id)
    add_counter(:spars_won) if won
    won
  rescue StandardError => e
    $game_switches[sw] = old if sw
    log("spar(#{key}) failed: #{e.message}")
    false
  end

  # --- Kip's Cups -----------------------------------------------------------------------
  CUP_BETS = [50, 200, 500]
  CUP_FREE_PRIZE = 200
  # bet => [number of swaps, frames per swap]: bigger bets, quicker hands
  CUP_SPEED = { 0 => [5, 24], 50 => [5, 22], 200 => [8, 16], 500 => [11, 11] }

  def cup_game(event_id = nil)
    if flag?(:met_kip)
      say(["KIP: Back for more? The cups missed you."], event_id)
    else
      say(["KIP: Name's Kip. Three cups, one Poké Ball. I shuffle, you point.",
           "KIP: Find the ball and I pay double what you put down.",
           "KIP: Keep your eyes sharp. My hands get quicker when the stakes go up."], event_id)
      set_flag(:met_kip)
    end
    loop do
      if $Trainer.money < CUP_BETS[0]
        say(["KIP: Pockets empty? Rough week. Tell you what: one round on the house.",
             "KIP: Find the ball and I'll stake you $#{CUP_FREE_PRIZE}.",
             "KIP: Nobody walks away from Kip's table with nothing to try for."], event_id)
        bet = 0
      else
        choices = CUP_BETS.select { |b| b <= $Trainer.money }
        opts = choices.map { |b| "$#{b}" } + [_INTL("No thanks")]
        idx = pbMessage(_INTL("KIP: How much are you putting down?"), opts, opts.length)
        break if idx < 0 || idx >= choices.length
        bet = choices[idx]
        $Trainer.money -= bet
        pbSEPlay("SlotsCoin") rescue nil
      end
      swaps, frames = CUP_SPEED[bet]
      won = CupGame.new(swaps, frames).play
      if won
        prize = bet == 0 ? CUP_FREE_PRIZE : bet * 2
        $Trainer.money += prize
        pbMEPlay("SlotsWin") rescue nil
        say(["KIP: Well, look at that. Sharp eyes!", "You got $#{prize}!"], event_id)
        kip_tip(event_id)
      else
        pbSEPlay("GUI sel buzzer") rescue nil
        say([bet == 0 ? "KIP: Ooh, so close. Come see me again if you're still short." :
                        "KIP: Ah, the cups giveth and the cups taketh away."], event_id)
      end
      break if bet == 0
      break if !pbConfirmMessage(_INTL("KIP: Another round?"))
    end
    say(["KIP: Stay warm, friend."], event_id)
  rescue StandardError => e
    log("cup_game failed: #{e.class}: #{e.message}")
  end

  # Kip is a Zhentarim lookout. Beat his cups once and he tips you off: the
  # Ten-Towns lottery list, with the names that never get drawn (read in SC 2.05).
  def kip_tip(event_id = nil)
    return if flag?(:kip_list)
    say(["KIP: ...Eyes like that, you'll want to see this. Don't ask where I got it.",
         "A folded list: every name in the Bryn Shander lottery, two years of draws.",
         "Three names have never once come up.",
         "KIP: Funny how luck works, eh? You didn't get it from me."], event_id)
    set_flag(:kip_list)
  end

  # The shell game itself, drawn over the map.
  class CupGame
    SLOT_X = [132, 256, 380]
    FLOOR_Y = 292          # where the cups' mouths sit on the felt
    LIFT = 64
    PICS = "Graphics/Pictures/FrostThaw/"
    attr_reader :ball_cup, :slot_of, :choice

    def initialize(swaps, frames, rng = Random.new)
      @swaps, @frames, @rng = swaps, frames, rng
      @ball_cup = @rng.rand(3)     # which cup (0-2) hides the ball
      @slot_of = [0, 1, 2]         # cup => slot it sits in
    end

    # Plans the shuffle: a list of [slot, slot] pairs to swap.
    def plan
      @plan ||= (0...@swaps).map do
        a = @rng.rand(3); b = (a + 1 + @rng.rand(2)) % 3
        [a, b].sort
      end
    end

    def cup_in(slot)
      @slot_of.index(slot)
    end

    # The swaps with no drawing (used by the animation and by the tests).
    def apply_swap(a, b)
      ca, cb = cup_in(a), cup_in(b)
      @slot_of[ca], @slot_of[cb] = b, a
    end

    def correct?(slot)
      @slot_of[@ball_cup] == slot
    end

    def play
      create
      fade(0, 255)
      reveal(@ball_cup, true)
      wait(40)
      reveal(@ball_cup, false)
      wait(10)
      plan.each { |a, b| animate_swap(a, b) }
      @choice = pick
      won = correct?(@choice)
      reveal(cup_in(@choice), true)
      wait(30)
      unless won
        reveal(@ball_cup, true)
        wait(30)
      end
      wait_for_key
      fade(255, 0)
      won
    ensure
      dispose
    end

    private

    def frame
      Graphics.update
      Input.update
    end

    def wait(n)
      n.times { frame }
    end

    def create
      @vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @vp.z = 99990
      @sprites = {}
      dim = Sprite.new(@vp)
      dim.bitmap = Bitmap.new(Graphics.width, Graphics.height)
      dim.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(8, 10, 20, 170))
      @sprites[:dim] = dim
      t = Sprite.new(@vp); t.bitmap = Bitmap.new(PICS + "cup_table"); t.x = 24; t.y = 196; t.z = 1
      @sprites[:table] = t
      ball = Sprite.new(@vp); ball.bitmap = Bitmap.new("Graphics/Items/POKEBALL")
      ball.ox = 24; ball.oy = 44; ball.zoom_x = ball.zoom_y = 0.75; ball.z = 2
      @sprites[:ball] = ball
      @cups = (0...3).map do |i|
        sh = Sprite.new(@vp); sh.bitmap = Bitmap.new(PICS + "cup_shadow"); sh.ox = 29; sh.oy = 6; sh.z = 2
        c = Sprite.new(@vp); c.bitmap = Bitmap.new(PICS + "cup"); c.ox = 28; c.oy = 62; c.z = 10
        @sprites["shadow#{i}"] = sh; @sprites["cup#{i}"] = c
        place(i, SLOT_X[i], FLOOR_Y)
        c
      end
      ar = Sprite.new(@vp); ar.bitmap = Bitmap.new(PICS + "cup_arrow"); ar.ox = 11; ar.z = 30; ar.visible = false
      @sprites[:arrow] = ar
      tx = Sprite.new(@vp); tx.bitmap = Bitmap.new(Graphics.width, 40); tx.y = 140; tx.z = 30
      pbSetSystemFont(tx.bitmap) rescue nil
      @sprites[:text] = tx
      set_text(_INTL("Watch the Poké Ball..."))
      @sprites.each_value { |s| s.opacity = 0 }
    end

    def set_text(str)
      bmp = @sprites[:text].bitmap
      bmp.clear
      [[2, 2, Color.new(20, 20, 30)], [0, 0, Color.new(248, 240, 220)]].each do |dx, dy, col|
        bmp.font.color = col
        bmp.draw_text(dx, dy, Graphics.width, 36, str, 1)
      end
    end

    def place(cup, x, y, lift = 0)
      c = @sprites["cup#{cup}"]; sh = @sprites["shadow#{cup}"]
      c.x = x; c.y = y - lift; sh.x = x; sh.y = y
      sh.zoom_x = 1.0 - lift / 200.0
      if cup == @ball_cup
        b = @sprites[:ball]; b.x = x; b.y = y
      end
    end

    def fade(from, to)
      10.times do |i|
        o = from + (to - from) * (i + 1) / 10
        @sprites.each_value { |s| s.opacity = o }
        frame
      end
    end

    def reveal(cup, up)
      pbSEPlay("Voltorb Flip Tile") rescue nil if up
      x = SLOT_X[@slot_of[cup]]
      12.times do |i|
        f = (i + 1) / 12.0
        place(cup, x, FLOOR_Y, (up ? f : 1 - f) * LIFT)
        frame
      end
    end

    def animate_swap(a, b)
      ca, cb = cup_in(a), cup_in(b)
      xa, xb = SLOT_X[a], SLOT_X[b]
      @sprites["cup#{ca}"].z = 12; @sprites["cup#{cb}"].z = 10
      @frames.times do |i|
        f = (i + 1).to_f / @frames
        e = f < 0.5 ? 2 * f * f : 1 - ((-2 * f + 2)**2) / 2        # ease in-out
        arc = Math.sin(f * Math::PI)
        place(ca, (xa + (xb - xa) * e).round, (FLOOR_Y + 16 * arc).round)    # passes in front
        place(cb, (xb + (xa - xb) * e).round, (FLOOR_Y - 20 * arc).round)    # passes behind
        frame
      end
      apply_swap(a, b)
      place(ca, xb, FLOOR_Y); place(cb, xa, FLOOR_Y)
      (0...3).each { |c| @sprites["cup#{c}"].z = 10 }
    end

    def pick
      sel = 1
      ar = @sprites[:arrow]; ar.visible = true
      set_text(_INTL("Which cup? Left/Right to choose, then confirm."))
      t = 0
      loop do
        ar.x = SLOT_X[sel]; ar.y = FLOOR_Y - 92 + (Math.sin(t / 6.0) * 3).round
        t += 1
        frame
        if Input.trigger?(Input::LEFT) && sel > 0
          sel -= 1; pbPlayCursorSE rescue nil
        elsif Input.trigger?(Input::RIGHT) && sel < 2
          sel += 1; pbPlayCursorSE rescue nil
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE rescue nil
          break
        end
      end
      ar.visible = false
      set_text("")
      sel
    end

    def wait_for_key
      set_text(correct?(@choice) ? _INTL("Found it!") : _INTL("Not that one..."))
      60.times do
        frame
        break if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
      end
    end

    def dispose
      (@sprites || {}).each_value { |s| s.bitmap.dispose rescue nil; s.dispose rescue nil }
      @vp.dispose rescue nil
      @sprites = {}
    end
  end
end
