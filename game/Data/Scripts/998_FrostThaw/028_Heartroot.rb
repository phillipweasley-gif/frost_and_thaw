#===============================================================================
# Frost & Thaw - Act II, Chapter 7 (continued): the Heartroot's side ways
#
# The Heartroot is one of Act II's quest lines out of Rootspire. Beside the
# main way down (the Root Gate, the Sap Wells, Selrae) it now has:
#
#   The Rootguard post's full watch: four enthralled Rootwardens (H4).
#   The Guild dig (Rootspire Part III-A, the Guild of Roots and Stone): Hew
#     Talmire's diggers broke into the Heartroot and didn't come back. Sap-dazed
#     miners, Halo saboteurs trying to light the sap caches ("Sabotage at the
#     Mine"), the amber fuel that whispers ("The Amber Experiment"), and Hew's
#     runaway construct that prays to the tree as "Father". A ladder up to the
#     market, by Hew.
#   The Overflow Channel (H7): a slope of slick sap you slide on, bones of
#     failed constructs in the flow, the Vault Map fragment caught in congealed
#     sap, and the twin of the possessed child's mirror ("Mirror, Mirror").
#===============================================================================
module FrostThaw
  SW_GUILD_LADDER = 3948   # the ladder up from the Guild dig is lowered
  SW_TWIN_BROKEN  = 3949   # the twin mirror is broken: the child is free

  MAPS.merge!(guild_dig: 2066, overflow: 2067)
  MAP_NAMES.merge!(2066 => "Heartroot: the Guild Dig", 2067 => "Heartroot: the Overflow Channel")
  MAP_METADATA.merge!(
    2066 => { announce_location: true, battle_environment: :Cave },
    2067 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2066 => :guild_dig, 2067 => :heartroot)
  GUILD_TOP = [2050, 47, 28, 2]

  ENCOUNTERS[2066] = { step_chances: { Cave: 8 },
                       Cave: [[25, :GRAVELER, 38, 40], [20, :ONIX, 38, 40], [20, :TANGELA, 38, 40],
                              [15, :GOLBAT, 39, 41], [10, :MAGCARGO, 39, 41], [10, :GLOAMCAP, 40, 42]] }
  # (no wild Pokémon in the Overflow Channel: nothing lives on the slick, and a
  # battle mid-slide would spoil the puzzle)

  # The Overflow Channel's slick sap: you slide on it like ice.
  SAP_SLICK_MAPS  = [2067]
  SAP_SLICK_TILES = [523, 524, 531, 532]   # (the plain cave floor is 529; it never slides)

  TRAINER_TYPES.merge!(FT_GUILD: ["Guild Digger", :WORKER, 0, 60])
  TRAINERS.merge!(
    thrall_bryce: [:FT_ROOTWARDEN, "Bryce", [[:B47H189, 39], [:B221H103, 40]],
                   "There was a song in the sap. I was the last verse."],
    thrall_ulla:  [:FT_ROOTWARDEN, "Ulla",  [[:BRELOOM, 39], [:B87H114, 40]],
                   "I'm cold. Why am I so cold? The heart was so warm."],
    digger_gant:  [:FT_GUILD, "Gant", [[:GRAVELER, 38], [:B95H76, 39]], "Where's my lamp? I had a lamp. I had a whole crew."],
    digger_hobb:  [:FT_GUILD, "Hobb", [[:MACHOKE, 38], [:B208H75, 39]], "The amber talked. I listened. Shouldn't have listened."],
    halo_tarn:    [:FT_HALO, "Brother Tarn", [[:MAGCARGO, 39], [:B124H219, 40]], "Burn the tree from within. The Matron said it was mercy."],
    halo_odile:   [:FT_HALO_F, "Sister Odile", [[:B215H429, 39], [:WEAVILE, 40]], "Fire or frost. Either way the tree stops. Either way."]
  )
  TRAINER_INTROS.merge!(
    thrall_bryce: "BRYCE: You're not on the list. Nobody's on the list. The heart wants a list.",
    thrall_ulla:  "ULLA: Back! Back, or the sap gets you too!",
    digger_gant:  "GANT: Another one! Another voice in the dark! Get off my seam!",
    digger_hobb:  "HOBB: Guild property. GUILD PROPERTY. ...Why does the amber keep saying my name?",
    halo_tarn:    "TARN: The sap caches will burn, and the tree will feel winter at last. Stand aside!",
    halo_odile:   "ODILE: You stopped the rite. You won't stop the fire."
  )

  TEXT.merge!(
    # Mirror, Mirror (Rootspire Part II-A, T1)
    mirror_child: [{ if: { flag: :twin_broken }, lines: ["CHILD: My mirror's just a mirror now! I can see my own face!",
                                                         "CHILD: It's a bit boring. I love it."] },
                   ["I bought a mirror from the lady! It's got a friend in it.",
                    "She talks when the others aren't looking. She says she knows you.",
                    "She says you broke her house.",
                    "...She says she's cold. She says her other half is down in the roots, and she wants it back."]],
    mira_north_wind: -> {
      if T.flag?(:twin_broken)
        ["MIRA: The child's mirror went quiet. So did mine, a little.",
         "MIRA: I didn't know how loud they were until they stopped.",
         "MIRA: The Corsairs owe you. When you need a ship, you'll have one. I don't say that to anyone."]
      elsif T.flag?(:met_mirror_child)
        T.set_flag(:mirror_twin_known)
        ["MIRA: The child's mirror? Frost-glass, like all of them. That one came up in a pair.",
         "MIRA: A diver found them both in the roots under the market. Under the Heartroot.",
         "MIRA: I sold one. We... I kept the other on the boat. Then it wasn't on the boat.",
         "MIRA: It went back. Mirrors do that, I find. We find.",
         "MIRA: If the child's glass is calling its twin, the twin's still down there.",
         "MIRA: Somewhere wet. Somewhere it can watch the sap move.",
         "MIRA: Break the twin, and the child's glass will just be glass.",
         "MIRA: ...We would rather you didn't. I would rather you did. Excuse me. I'm tired."]
      else
        ["MIRA: Frost-glass, straight from the permafrost. Look into one at midnight.",
         "MIRA: You'll see your heart's desire. Or something that wants to be your heart's desire.",
         "MIRA: The glass isn't fussy."]
      end
    },
    # The Guild dig
    guild_amber: ["A stack of Guild crates full of amber-coloured fuel: frozen sap, cut into bricks.",
                  "Up close, it whispers. Not words. The sound a crowd makes, far away, through a wall.",
                  "A Guild label: TEST BATCH 7. DO NOT BURN NEAR PEOPLE.",
                  "Underneath, in a different hand: DO NOT BURN AT ALL."],
    guild_ladder_up: ["A Guild ladder goes up a shaft toward lantern-light and market noise."],
    guild_ladder_shut: ["A Guild ladder, pulled up and lashed out of reach at the top of the shaft. Someone up there has to lower it."],
    heart_wall: ["The roots here are knotted tight as a fist. Behind them something beats, slow and enormous.",
                 "Warm air comes through the gaps, and with it, very faintly, forge smoke.",
                 "(The way to the Heart of the tree, where the Heartroot meets the Rootsun Forge. Not yet.)"],
    sap_bones: ["Half sunk in the glowing sap: bones that aren't bones.",
                "Ribs of root and wire, a skull of fired clay. Failed constructs.",
                "One still has a brass plate on its chest, stamped with a stylized \"A\"."],
    # (notes 07 §3: trainers' after-lines are spoken, so they carry the speaker's name)
    thrall_bryce_after: ["BRYCE: I can hear my own name again. It's a good name. I'd forgotten."],
    thrall_ulla_after: ["ULLA: Go careful past the wells. The sap sings to you if you let it."],
    digger_gant_after: ["GANT: Tell Hew I'm sorry about the lamp. It was a good lamp."],
    digger_hobb_after: ["HOBB: I'm going up. I'm going up and I'm never coming down.", "HOBB: Somebody else can dig."],
    overflow_sign: ["Carved into the root at the top of the slope, in Rootwarden script:", "SLICK. ONCE YOU'RE MOVING, YOU'RE MOVING."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # The Guild dig
  #-----------------------------------------------------------------------------
  def guild_ladder(event_id = nil)
    if !flag?(:guild_ladder_down)
      say(["The Guild's ladder shaft. The ladder's pulled up and lashed out of reach.", "But there's a bell-rope."], event_id)
      return if !pbConfirmMessage(_INTL("Ring the bell for the Guild?"))
      set_flag(:guild_ladder_down)
      ($game_switches[SW_GUILD_LADDER] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      say(["Far above, someone shouts. The ladder comes rattling down the shaft.",
           "HEW: (from the top) ALIVE? Somebody's ALIVE? Come up! Come up!"])
    end
    return if !pbConfirmMessage(_INTL("Climb up to the market?"))
    transfer(*GUILD_TOP)
  end

  # (digger: see 033_Chapter7B.rb, which replaced this one.)

  #-----------------------------------------------------------------------------
  # The Overflow Channel
  #-----------------------------------------------------------------------------
  def scene_overflow_enter
    return if flag?(:overflow_entered)
    set_flag(:overflow_entered)
    sayc(["Narrow trenches carry the wells' overflow down a sloping channel.",
          "The sap glows faintly, and the floor shines with it.",
          "One step onto the shine and your boot keeps going without you.",
          cl(:shade, "Slides. Lovely. Everyone pick a wall to hit.") ||
            cl(:glimmer, "Slides. Lovely. I'll land on my feet. The rest of you, pick a wall."),
          cl(:meat_meat, "Meat Meat goes first. 'Wheee' is a battle cry."),
          with_or_is?(:meat_meat) ? cl(:reptin, "(sighing) Of course it is. Try not to land on anything with teeth.") : nil])
  end

  #-----------------------------------------------------------------------------
  # Remember meeting the child (for Mira's part of the quest)
  #-----------------------------------------------------------------------------
  def apply_heartroot_switches
    return if !active? || !$game_switches
    sync_switch(SW_GUILD_LADDER, flag?(:guild_ladder_down))
    sync_switch(SW_TWIN_BROKEN, flag?(:twin_broken))
  end
end

#-------------------------------------------------------------------------------
# Slick sap slides like ice in the Overflow Channel
#-------------------------------------------------------------------------------
if defined?(Game_Map) && Game_Map.method_defined?(:terrain_tag)
class Game_Map
  alias ft_sap_terrain_tag terrain_tag unless method_defined?(:ft_sap_terrain_tag)
  def terrain_tag(x, y, countBridge = false)
    if FrostThaw::SAP_SLICK_MAPS.include?(@map_id) && valid?(x, y)
      [2, 1, 0].each do |i|
        return GameData::TerrainTag.get(:Ice) if FrostThaw::SAP_SLICK_TILES.include?(data[x, y, i])
      end
    end
    return ft_sap_terrain_tag(x, y, countBridge)
  end
end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_heartroot_switches
  rescue StandardError => err
    FrostThaw.log("Heartroot switches failed: #{err.message}")
  end
}
