#===============================================================================
# Frost & Thaw - Act II: Glimmer, the Sparkbearer (script SC 6.08)
#
# Shade becomes Glimmer. At the Celestial Rift the sky goes smooth as a mirror,
# and on the other side is Brightmane's plain of stars. Brightmane has been
# pulling at Shade since Saltmarsh, the night Shade pulled Shimmer out of the
# white and found a unicorn's horn in the snow (the horn Shade gave up in
# Act I to save Razzy). Shade steps through. A minute later a tall cat-man in
# a midnight-blue coat steps back out: Glimmer, Brightmane's devotee, years
# older on her side of the glass, with the horn given back and the Lumen Shard
# beating in his chest. He still carries the Rimefang, the cursed dagger that
# marks its bearer for Auril. ("Then I'll find it a better fire": he does, at
# the Forge, and his death there is final.)
#
# There is no third sibling: Shimmer's carved cat, and "they always wanted to
# be one", were the clue. From Ch9, Alerion and Meat Meat are the dragons'
# Dragoons; Glimmer never is.
#===============================================================================
module FrostThaw
  SW_GLIMMER = 3950   # Shade has gone through the Rift and come back as Glimmer

  COMPANION_NAMES[:glimmer] = "GLIMMER"

  TEXT.merge!(
    shade_watch: ["The Shrine is quiet. Frostina circles the crown of the tree, humming to herself."],
    razzilith_shrine: -> {
      flag?(:dragon_down) ? ["RAZZILITH: (a painted thought: Meat Meat, laughing, on his back over the snow) ...AGAIN."] :
                            ["Razzilith rumbles, low, like a meadow full of bees.", "A painted thought: a goblin's face, and a sunrise."]
    },
    frostina_shrine: -> {
      flag?(:frostina_freed) ? ["Frostina hums four notes, and then a fifth, new one.", "She's never sung that one before."] :
      flag?(:glimmer_gone) ? ["Frostina hums four notes, then stops halfway, like a song with a voice missing."] :
                             ["Frostina tilts her head and hums four notes. Shimmer's song."]
    },
    lumen_rift_empty: ["The Celestial Rift pours its curtain of gold and green down into the tree.",
                       "Where the Lumen Shard hung, there's only light now.",
                       "Very faintly, at the edge of hearing: hooves, on a road of stars."]
  )

  PARTY_CHAT[:glimmer] = {
    rootspire: ["Lanterns everywhere. Every one of them is a little spark.", "I could get used to a city that does that on purpose."],
    hearth: ["Five heroes on the wall, and I'm the shadowy one with the knife.", "Well. Was. I've been promoted to cat."],
    council: ["Four seasons and a burnt chair.", "Somebody wants this city to forget what a year is."],
    root_tier: ["Down here it's all secrets and fish. The old me loved it.", "...The new me loves the fish."],
    shrine: ["Somebody keeps cutting Auril's eyes sharp.", "Brightmane would have something to say about that. Loudly. In rhyme."],
    heartroot: ["The Shard's warm in my chest. It doesn't like it down here.", "Neither do I. My whiskers keep going flat."],
    canopy: ["Brightmane let me come back. Brightmane doesn't let anyone come back.", "So this matters. Whatever this is."],
    library: ["Every word ever said in Rootspire, written in light.", "I'm going to say something nice, so there's at least one."],
    college: ["The Professor wants to measure my whiskers. I've said no twice.", "He wrote down both."],
    crypt: ["Quiet. The kind of quiet that's earned. I'll keep my voice down."],
    undercanopy: ["The mushrooms keep asking what a unicorn tastes like.", "I think it's a joke. I think."],
    fields: ["Flowers through the snow. That's what she was like.", "That's exactly what Shimmer was like."],
    guild_dig: ["Fire in the roots would've killed this whole city.", "Light's better. Light's always better. Take it from a lamp."],
    hearth_cellar: ["Hellen hits like a mother.", "I mean that as the highest compliment."]
  }

  module_function

  # The Lumen Shard at the Celestial Rift.
  def lumen_shard(event_id = nil)
    return talk(:lumen_rift_empty, event_id) if flag?(:glimmer_joined)
    return talk(:lumen_shard, event_id) if !flag?(:twins_met)
    glimmer_arrives(event_id)
  end

  # SC 6.08 - The spark that wasn't out
  def glimmer_arrives(event_id = nil)
    Stage.overlay("O-01", scroll_x: 0.6, opacity: 255, fade: 30)   # the aurora pours down
    sayc(["Above the crown of the tree, the sky opens. No clouds: only aurora, pouring down in a curtain.",
          "In the middle of it a shard of light turns slowly.",
          "Behind it the curtain goes smooth and bright as a mirror.",
          "In the mirror, a plain of stars, each one burning like an ember.",
          "At the edge of the glass stands a unicorn with a mane of fire. She is looking at Shade."], event_id)
    sayc([cl(:shade, "...Oh. It's you."),
          cl(:shade, "It's been you since Saltmarsh, hasn't it."),
          "Shade looks down at their own empty hands.",
          cl(:shade, "That night in the white, I pulled Shimmer out. And something pulled back."),
          cl(:shade, "In the morning there was a unicorn's horn in the snow. I carried it for years."),
          cl(:shade, "Then I gave it to an egg."),
          "BRIGHTMANE: (a voice like a bell, heard through warm water) You gave away the last of me...",
          "BRIGHTMANE: ...to save a child you had never met. Come and get it back."])
    if flag?(:luna_spark)
      say([cl(:shade, "The Wennen said our house had a spark that wasn't out. Waiting somewhere bright."),
           cl(:shade, "Subtle, Luna.")].compact)
    end
    sayc(["Frostina drops down past the Rift, close enough to stir everyone's hair.",
          "She looks at Shade and hums four notes.",
          cl(:shade, "(very quietly) Shimmer told me to keep going. I think this is what she meant."),
          cl(:meat_meat, "Shade comes back. Meat Meat promises for Shade.")])
    speak(:alberica, "You'd better come back, sugar. I haven't finished teasing you.",
          "...Come back. That's all.") if with_or_is?(:alberica)
    sayc([cl(:reptin, "We'll hold the door. Diplomatically. With teeth, if it comes to that."),
          cl(:alerion, "Go.")])
    c = pbMessage(_INTL("Shade looks at you last."), [_INTL("\"Go.\""), _INTL("\"Come back.\"")], -1)
    set_flag(:told_shade_go) if c == 0
    pbSEPlay("Saint7") rescue nil
    Stage.fx("E-07", $game_player, frames: 8, oy: 40) rescue nil
    $game_screen.start_flash(Color.new(255, 240, 200, 200), 20) rescue nil
    sayc(["Shade steps into the mirror. The glass takes them like warm water.",
          "Stars move on the other side. For one breath, nothing at all.",
          "Then the glass bulges. A tall cat-man steps out, and for a moment stars come with him, caught in his fur.",
          "A midnight-blue coat. The cursed dagger at his hip. In his hand, a unicorn's horn.",
          "He reaches for the Lumen Shard. As his hand closes, a shadow of him forms in the aurora beside him: his own shape, eyes black as void.",
          "SHADOW: Will you bear hope when even the sun freezes?",
          "He doesn't look away from it.",
          "???: ...Yes. Somebody has to.",
          "The shadow steps back into him. The Shard sinks into his chest like a coal into snow, and beats.",
          "Round the Rift's inner ring, letters light up that weren't there a moment ago:",
          "FROM THE SPARK WAS BORN THE LUMEN SHARD, HOPE CRYSTALLIZED. MAY ITS BEARER LIGHT PATHS THAT NEVER KNEW DAWN.",
          "???: ...That took longer than Brightmane promised. Unicorns are terrible at time.",
          cl(:alberica, "...Shade?"),
          "GLIMMER: Glimmer, now. Brightmane says a name should fit what you carry.",
          "GLIMMER: Seven years on her side of the glass. About a minute on yours.",
          "He turns the horn over in his hands.",
          "GLIMMER: She gave it back. She says I'm a fire now. I'm still deciding how I feel about the fur.",
          cl(:meat_meat, "(poking his arm) Shade came back. Meat Meat promised. ...Shade is fluffy now."),
          with_or_is?(:meat_meat) ? "GLIMMER: Please don't." : nil])
    if flag?(:heard_of_glimmer)
      sayc(["He takes Shimmer's little carved wooden cat out of his coat and holds it up beside his own face.",
            "He laughs. Then he isn't laughing.",
            "GLIMMER: She always said I'd end up a cat. I hate that she was right."])
    end
    if flag?(:sanctum_dream)
      say(["GLIMMER: ...And you. You knocked on the Moon Temple door. I heard you, from the other side.",
           "GLIMMER: Time's strange over there."])
    end
    # The dead Glimmer's journal from the Cackling Chasm (044): the ghost said
    # "You'll see. Not yet." This is the seeing.
    if ($PokemonBag.pbHasItem?(:FT_GLIMMERJOURNAL) rescue false) || flag?(:glimmer_journal_read)
      sayc([cl(:alberica, "(very slowly, taking the journal out of the pack) Darling. ...Read this. The chasm. The skeleton with claws.") ||
              "You take the bloodstained journal from the Chasm out of the pack, and hold it out to him.",
            "He reads it standing very still. \"...desperate to save Alberica... Tomorrow, I venture into the chasm.\" Signed: Glimmer.",
            "He turns to the last page. Then back to the first. Then he holds his own hand out beside the writing.",
            "GLIMMER: (hoarse) That's my hand. That's how I make my G. I've never written this. ...I haven't written it yet. Or I wrote it last time.",
            "GLIMMER: Brightmane said the wheel turns. She didn't say it turns with me on it. Every time.",
            "GLIMMER: (to #{herald?(:alberica) ? 'you' : 'Alberica'}, very quietly) I went into that chasm for you once. I died in it.",
            "GLIMMER: ...I'm still trying. Apparently I always am.",
            cl(:alberica, "(not quite managing her voice) Then this time, sweetheart, you're going to try alive.")].compact)
      set_flag(:glimmer_knows_journal)
    end
    sayc(["Frostina hums four notes at him. He hums them back, off-key, the way Shade always did.",
          "GLIMMER: Brightmane said Shimmer gave the ice of her heart so others could live.",
          "GLIMMER: Somebody had to carry her torch. I said it wasn't fair that it was mine.",
          "GLIMMER: She said that's what torches are like.",
          "He draws the Rimefang. The blade still smokes with cold.",
          "GLIMMER: And this is still cursed. Still marks me for Auril. Still killing me slowly, since Saltmarsh.",
          "GLIMMER: Brightmane says I'll find it a better fire."])
    speak(:alerion, "Then we'll find it one together.", "...Together.") if with_or_is?(:alerion)
    state[:companions] = ((state[:companions] || []) - [:shade] + [:glimmer]).uniq
    set_flag(:glimmer_joined)
    set_flag(:shade_became_glimmer)
    set_flag(:glimmer_has_rimefang)
    ($game_switches[SW_GLIMMER] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    restore_sky
    pbMessage(_INTL("Shade is Glimmer now. Glimmer joined the party."))
    state[:goal] = flag?(:rite_stopped) && flag?(:badge_hearth) ? "The festival's last night. Rest at the Hearth." :
                   "Finish the festival's business: the Still Sky Shrine's rite, and Hellen's cellar."
  end

  def apply_glimmer_switches
    return if !active? || !$game_switches
    sync_switch(SW_GLIMMER, flag?(:glimmer_joined))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_glimmer_switches
  rescue StandardError => err
    FrostThaw.log("Glimmer switches failed: #{err.message}")
  end
}
