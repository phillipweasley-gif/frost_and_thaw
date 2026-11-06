#===============================================================================
# Frost & Thaw - what each trainer says when they challenge you
#
# A trainer who spots you walks up, says their line, and the battle starts.
# (Their lose line plays in battle; the "_after" lines in the dialogue files
# are what they say if you talk to them afterwards.)
#===============================================================================
module FrostThaw
  TRAINER_INTROS = {
    # --- Act I, Chapter 1: Targos ---------------------------------------------------
    fisher_hob:       "HOB: Oi! You're standing on my ice hole. Pay the toll, or battle!",
    sailor_brannoc:   "BRANNOC: New faces on the docks? Let's see if you've got sea legs.",
    tavern_brawler:   "GORM: That's my stool you're eyeing, stranger. Fight me for it.",
    # The first Zhentarim you fight names the gang once, in both its names
    # (notes/02 E31: Dorn, the Broker and Brosk say "Black Network" later).
    zhent_thug_1:     -> { FrostThaw.zhent_named("DASK: Zhentarim. The Black Network. The Speaker likes to know what you're made of.",
                                                 "DASK: Strangers in the Luskan Arms. The Speaker likes to know what strangers are made of.") },
    zhent_thug_2:     "VEY: Lost, are we? Let me show you how Targos treats people who wander.",
    # Before Naerth has asked for you, there's no Speaker in the hall to see (notes/01 E22).
    hall_enforcer_2:  -> { FrostThaw.flag?(:naerth_terms) ? FrostThaw.zhent_named("ILSA: Zhentarim. The Black Network. Nobody sees the Speaker without us.",
                                                                                "ILSA: Nobody sees the Speaker without getting past us first.") :
                                                            "ILSA: Speaker's at the Arms tonight. You can still try getting past me." },
    hall_enforcer_1:  "CORRIN: Naerth said to test anyone who came looking for his seal. This is the test.",
    hall_dealer:      "MARA: Care to play a hand? House rules: my Pokémon against yours. The house always wins.",
    # --- Chapter 2: the road to Bryn Shander ------------------------------------------
    hiker_tor:        "TOR: Ho there! Only way to keep warm out here is a good battle!",
    backpacker_wen:   "WEN: You look like you know where you're going. Prove it!",
    ranger_aldo:      "ALDO: Rangers keep this road safe. Let's find out if you're trouble.",
    aurilite_one:     "HESK: You walk the Frostmaiden's road and leave her no offering?",
    ranger_lune:      "LUNE: Everyone headed for Bryn Shander goes through me first.",
    hiker_bram:       "BRAM: My rocks are frozen solid. Let's warm them up on you!",
    aurilite_two:     "SIV: Turn back. The light below belongs to her.",
    aurilite_three:   "ORLA: You followed the little one down here? Then you can share his fate.",
    bryn_zhent_a:     "BROSK: The Black Network has questions about you, stranger. Answer them in battle.",
    northlook_zhent:  "DORN: You're sitting too close to the back table. Move, or I move you.",
    bhall_militia_1:  "GARVIN: Sheriff Southwell's orders. Nobody walks up to the Speaker untested.",
    bhall_clerk_2:    "CORVIN: My family's kept the Council's papers six generations. I still know how to fight.",
    bhall_militia_2:  "HASKEL: Last gap before the Speaker. Last chance to turn round.",
    # --- Chapter 3: Lonelywood ---------------------------------------------------------
    bug_catcher_pell: "NETTLE: I've found a bug nobody's ever named! Want to see it? It bites!",
    lady_maren:       "MAREN: A battle in the snow! How dreadfully exciting.",
    hiker_osk:        "OSK: Only fools walk the Lonelywood road. Takes one to know one!",
    aurilite_four:    "WYST: Her Chosen walked this road at dawn. Born at Midwinter. The cold can't touch him.",
    ranger_tamsa:     "TAMSA: Hold up! Nobody passes the north woods without a ranger's say-so.",
    fisher_garrow:    "GARROW: The trout aren't biting. Maybe you will.",
    logger_breck:     "BRECK: Strangers in Lonelywood? Let's see if you're as tough as our pines.",
    liar_brawler:     "TOBB: I've never lost a fight in my life. That's the first lie of the night.",
    aurilite_five:    "HALE: You carry something of hers. I can feel it beating from here.",
    aurilite_six:     "IVEN: This temple was the Frostmaiden's before it was the moon's. Leave.",
    # --- Chapter 4: Dougan's Hole --------------------------------------------------------
    ranger_hadd:      "HADD: Eastway patrol. Nobody passes without proving they can handle themselves.",
    aurilite_seven:   "CORRA: You're walking toward the laughing. Do you know what's laughing?",
    hiker_durn:       "DURN: Nothing to climb on the Eastway. I'll settle for climbing over you!",
    musher_toma:      "TOMA: My sled's stuck and my dogs are bored. You'll do.",
    zhent_grisk:      "GRISK: The Black Network's watching this road. Smile.",
    fisher_vash:      "VASH: Quiet! You'll scare the trout. ...Too late. Battle, then.",
    skater_lys:       "LYS: You're on my rink! Well. My shore. Close enough!",
    aurilite_eight:   "NELL: Don't look at the ones on the ice. Look at me instead.",
    trapper_birk:     "BIRK: Wolves took my traps. I'll take it out on you.",
    channeler_mag:    "MAG: The spirits on the ice won't speak to me any more. Will yours?",
    fisher_rorik:     "RORIK: Off my pier, Good Mead scum! ...Oh. You're not from Good Mead. Battle anyway!",
    aurilite_nine:    "VESK: The giant's beast mourns, and the wolves wait. And you walk right into it.",
    hunter_ulf:       "ORRIN: Tracking wolves too? Then you'd better be quick on your feet.",
    trapper_brann:    "BRANN: The Speaker doesn't see anyone who can't get past her trappers.",
    trapper_holt:     "HOLT: Fur's warm, ice is cold, and you're about to lose.",
    trapper_ysa:      "YSA: Last one before Edgra. Make it count.",
    # --- Chapter 5: the Cackling Chasm ---------------------------------------------------
    aurilite_ten:     "RHOSK: You walk toward the laughing? Then laugh with it!",
    hunter_gerd:      "GERD: You're after the yetis too? Not if I get there first!",
    ranger_brisa:     "BRISA: Rangers stop everyone at the edge of the Waste. Show me you'll come back out.",
    channeler_odda:   "ODDA: The chasm speaks in children's voices. Let me hear yours.",
    # --- Chapter 6: Rootspire ------------------------------------------------------------
    warden_ash:       "ASH: Rootwarden Ash. Everyone claims to be a Herald at festival time. Prove it.",
    warden_lis:       "LIS: The tree went quiet when you walked in. It's never quiet. Battle me!",
    warden_tobin:     "TOBIN: Heralds or not, nobody passes a Rootwarden on festival day without a bout.",
    halo_vigil:       "ISKAR: The Matron said the thieves of winter would come. You're shorter than the carvings.",
    halo_ascetic:     "WENNA: Turn back. Please. I don't want to fight the Heralds. I will, though.",
    eline:            "ELINE: Then be still.",
    # --- Chapter 7: the Heartroot -------------------------------------------------------
    thrall_oren:      "OREN: The heart wants... the heart wants you to stay. Stay. STAY.",
    thrall_mae:       "MAE: Nobody passes the Rootguard post. Nobody. ...Why can't I remember why?",
    selrae:           "SELRAE: Winter does not ask permission, Wardens. Neither will I."
  }

  module_function

  # The gang's two names, said by whichever of them you fight first; after that, the plain line.
  def zhent_named(first, after)
    return after if flag?(:black_network_named)
    set_flag(:black_network_named)
    first
  end

  def trainer_intro(key, event_id = nil)
    line = TRAINER_INTROS[key]
    line = line.call if line.respond_to?(:call)
    say([line], event_id) if line
  end
end

module FrostThaw
  class << self
    alias ft_trainer_without_intro trainer unless method_defined?(:ft_trainer_without_intro)
    def trainer(key, event_id = nil)
      begin
        trainer_intro(key, event_id)
      rescue StandardError => e
        log("trainer_intro(#{key}) failed: #{e.message}")
      end
      ft_trainer_without_intro(key, event_id)
    end
  end
end
