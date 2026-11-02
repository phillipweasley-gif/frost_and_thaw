# Act II: The Thaw

Scene scripts for Chapters 6–10: Rootspire, Year 400 of the Verdant Reversal.

## Chapter 6: The Festival of Returning Light

**Chapter goal:** understand where and when they are, and why the city is stuck in summer. It ends with the Council sending the party down into the roots.

### SC 6.01 — Out of the lantern

- **Map:** 2050 Rootspire market, festival night 1, an hour after the Prologue. **Trigger:** Act II start (autorun). **Present:** party, Tamsin (Journey), crowd, the lantern seller. **Music:** *Thaw*.

The cracked lantern on the cobbles bursts like a soap bubble.

A tangle of people, one goblin and a great deal of snow tumbles out onto the market stones.

Gold light. Warm air. A tree so tall its crown is lost in the aurora.

`[mode: journey]` **TAMSIN** *(screaming, then grabbing you)* WHERE DID YOU GO. You were gone an HOUR.

`[mode: journey]` **TAMSIN** Who are... *(she sees the others)* ...who are THEY?

`[mode: journey]` **ALBERICA** *(dusting snow off Tamsin's head)* Hello, gorgeous. We fell out of a lamp. Don't try it at home.

**ALBERICA** *(looking at her empty hands)* I was holding it. In the Chasm. It was a seed.

**REPTIN** *(looking up, and up, and up)* It isn't a seed any more.

**MEAT MEAT** Razzy? Razzy is gone. Razzy was holding on... `[herald: Meat Meat, quiet]` "...Razzy?"

**ALBERICA** *(a hand on Meat Meat's shoulder)* We'll find him, sweetheart. He can't hide forever.

**LANTERN SELLER** ...Refunds are at the other stall.

**SHADE** Noted.

Down the street, the Rooted Hearth's windows are lit. The crowd is already parting toward it.

- **Flow:** sets `rootspire_arrived`. Hellen's tavern is lit and the crowd parts toward it.

### SC 6.02 — You're in my wall

- **Map:** 2053 Rooted Hearth. **Trigger:** enter. **Present:** party, Hellen, Tamsin. **Music:** *Hearth*.

**HELLEN** *(dropping a tray)* No.

She looks at the mural. At Alberica. At the mural again. `[herald: Alberica]` At you.

**HELLEN** No. You're the Heralds of Dawn and Dusk. You're on my wall. You're in my BAR.

**SHADE** We've been called worse. Usually in bars.

**ALBERICA** And we've been in worse bars. This one has a mural of me. I love it here.

**HELLEN** Sit. All of you. Eat. You've snow in your hair that fell four hundred years ago.

`[mode: journey]` Tamsin looks at you. Then at the small sixth figure on the wall. Then at you again. They don't say anything. Yet.

**HELLEN** Here's what my grandmother told me. You broke the hag's mirrors, and a seed took root.

**HELLEN** The tree grew in one night that lasted four hundred years. Inside the Auroral Wall, anyway.

**ALERION** And outside?

**HELLEN** Outside it's still snowing the same snow. Past the Wall, the flakes hang in the air.

**HELLEN** Like time out there is holding its breath.

**REPTIN** *(very quietly)* Anduin is out there. `[herald: Reptin, quiet]` "...Anduin."

**HELLEN** Then he's waiting a lot less time than you'd think, love.

In the corner, the bard starts up "The Shade and the Shimmer". Shade gets up and walks out.

**ALBERICA** *(watching the door)* ...I'll go after them. In a minute. Give them the minute.

**HELLEN** The Council will want to see you. The round hall with the four crystals.

**HELLEN** And the root-lift goes up to the Canopy, if you want to see the top of the world.

- **Flow:** rest point. Sets `heard_wall_rule`. Opens the Council ("they'll want to see you") and the lift to the Canopy.
- **Notes:** the hearth bard's song "The Shade and the Shimmer" plays here. Shade leaves the room.

### SC 6.02a — Coffee at the Hearth (rest banter)

- **Map:** 2053 Rooted Hearth. **Trigger:** rest with Hellen, the first time all five Heralds are in the party (after Wyn joins). Plays once. **Present:** the five Heralds, Hellen, Sableye. **Music:** *Hearth*.

Morning. Hellen sets a black iron pot on the bar.

**HELLEN** Pot's on. Who wants...

**MEAT MEAT** MEAT MEAT. Meat Meat wants.

She takes the whole pot.

**HELLEN** That's the whole pot.

**MEAT MEAT** Meat Meat is a whole goblin.

**REPTIN** Hellen, I'm so sorry. She was raised by a laboratory. We're working on it. Diplomatically.

**MEAT MEAT** One more word about laboratory and Meat Meat pours coffee in Reptin's ears.

**REPTIN** ...And that's the working on it.

**ALBERICA** Pour it somewhere useful, sweetheart. Like in me.

**WYN** *(very quietly)* Um. There's... a second pot. I made it. It's mushroom.

**WYN** Root-chicory and cap. It's good for you.

Meat Meat squints at it.

**MEAT MEAT** Mushroom coffee.

**WYN** It's very gentle.

**MEAT MEAT** Meat Meat does not want gentle. Meat Meat wants to hear colours.

She drinks it anyway. A long pause.

**MEAT MEAT** ...Meat Meat will kill for you, mushroom friend.

**WYN** Oh. Oh, please don't. But thank you.

**ALERION** That's a compliment.

**WYN** I know. That's the part that worries me.

**ALERION** *(sipping)* This is good.

**ALERION** ...I don't like that it's good.

**ALBERICA** That's the most feelings Alerion's had all week. Wyn, marry me.

Wyn goes pink.

**WYN** I... I have a Sableye.

**ALBERICA** He can come. I'm very open-minded.

**REPTIN** She's like this with everyone, Wyn. It's a compliment and a warning.

Alberica rests her chin on her hand and looks round the table at all of them.

**ALBERICA** ...Look at us. Two years ago I'd have been drinking alone. To the people who stay. `[herald: Alberica, quiet]` *(quietly, lifting her cup)* "To the people who stay."

**MEAT MEAT** To coffee.

**ALBERICA** That's what I said.

`[if Glimmer is with you]` **GLIMMER** *(curled in the warm spot by the hearth, eyes shut)* Wake me when there's milk.

Everyone drinks. Sableye snores on Wyn's boot.

- **Flow:** sets `hearth_coffee`. In Herald Mode the narration turns to "you" for Meat Meat, Wyn and Alberica.

### SC 6.03 — They waited

- **Map:** 2050 market, morning (a gold dawn that never changes). **Trigger:** leave the Hearth. **Present:** party, Razzilith, Frostina, Lumin Weavemoss, crowd. **Music:** *Heralds*.

Shadows fall across the market. Two dragons come down out of the gold sky.

They're bigger than houses now: one green-gold, one silver-white.

The green one lands so hard the cobbles crack. He shoves his enormous head into Meat Meat's chest.

**RAZZILITH** *(a painted thought: a goblin's face, over and over, four hundred years of it)* ...WAITED.

**MEAT MEAT** *(arms round as much of him as she can reach)* Meat Meat is here. Meat Meat is here now.

**ALBERICA** *(wiping her eyes)* Oh, look at the size of him. Who's a big boy? Who waited?

The white one lands like snow. She looks at Alerion and lowers her head to him.

His ring frosts and warms at once.

Then she looks at Shade, tilts her head, and hums four notes.

**SHADE** *(sitting down in the street)* ...Hi.

**REPTIN** *(gently)* Take your time.

**LUMIN** *(a Wennen in priest's robes, trembling)* The Twinned Dragons haven't touched the ground in a century.

**LUMIN** The old texts say they'd wait for their partners. Not masters. Partners.

The dragons lift off together, back toward the Shrine of the Twinned Dragons on the Canopy-Tier.

- **Flow:** sets `twins_met`. Razzilith and Frostina appear around the Shrine of the Twinned Dragons from now on. Opens SC 6.08.
- **Notes:** this replaces the optional orb scene. If the old Halo-vs-orb fight is kept, move it to Ch11.

### SC 6.04 — The empty throne

- **Map:** 2054 Council Hall of Seasons. **Trigger:** enter. **Present:** party; Kelyn (Spring); Selrae (Winter); Darrus Fell (Autumn); the empty Summer Throne. **Music:** *Rime* under *Thaw*.

Four crystal obelisks pulse: green, gold, red, white. Three seats are filled.

The fourth is gold-leafed and vine-draped, scorched black, with warm sap dripping under it.

**KELYN** Four hundred years late. Or right on time. Welcome home.

**SELRAE** *(not unkindly)* We'd hoped you'd be taller.

**ALERION** We'd hoped you'd be warmer.

**REPTIN** *(under his breath)* Let me do the talking. Please. I'm begging.

**DARRUS** *(chewing clove bark)* Spare us the poetry.

**DARRUS** Our Summer Marshal, Var Rime-Breaker, went down to check the heat in the roots. Seven days ago.

**DARRUS** He hasn't come back. And this arrived the next morning.

A decree: "Begin excavation beneath the Heartroot." Signed with Summer's seal.

In the wax there's a tiny mark: a cracked mirror.

**ALERION** That's the hag's sign.

**SELRAE** The hag has been dead four hundred years.

**MEAT MEAT** Mirrors remember. She said so. Meat Meat remembers too.

**KELYN** Rootspire has been stuck in this summer for thirty years. I need people the tree trusts.

**KELYN** Will you swear the Wardens' oath?

▸ YOU:

- *Swear.* "We'll guard the pulse." You put your hands on the living pillar. It's warm, and it beats. **KELYN** Then welcome home, Wardens of Rootspire. Take this: sap from the Heart of Spring's first root. It heals what it touches. Slowly and stubbornly, like the tree. **ALBERICA** Slow and stubborn. Story of my love life. ...Thank you, Speaker. Leftovers. Sets `wardens_sworn`. Kelyn becomes a witness for you at the Trials.
- *Refuse.* "We just got here." **SELRAE** Good. People who swear oaths in their first hour swear them to anyone. **KELYN** *(tightly)* ...As you like. The city will still need you. **REPTIN** *(warmly)* And it'll have us, Speaker. Oath or no oath. We're terrible at leaving. Sets `wardens_refused`. Selrae becomes a witness instead.
- **Flow:** opens the Root-Tier stair (switch 3935) either way. **SELRAE** There's a rite at the Still Sky Shrine tonight that I'd like you to watch. Closely. **KELYN** The Wardens' stair down to the Root-Tier is in the woodcarver's workshop, by the old gate.
- **Notes:** Var is Avarice wearing a Rootspire man's body (revealed in SC 8.06). Darrus knows. Selrae only suspects.

### SC 6.05 — The College

- **Map:** 2063 College. **Trigger:** talk to Wynsnow. **Present:** Wynsnow. **Music:** *Thaw*.

`[mode: journey]` **WYNSNOW** You fell into a lantern and came back with legends. Hold still.

`[mode: journey]` He measures you with a brass rule. Then with a candle. Then with a look.

`[mode: journey]` **WYNSNOW** Your shadow is a quarter-second late. Remarkable. Horrifying.

`[mode: herald]` A half-elf in an ink-stained coat looks up from three books at once, and drops all of them.

`[mode: herald]` **WYNSNOW** The Heralds. In my lab. Hold still. I've waited my whole life to measure you.

**ALERION** No.

**REPTIN** He means he'd rather not. He's shy. Measure me instead, Professor, I'm very measurable.

**WYNSNOW** You'll want this. A licence. Grafting: two Pokémon merged in a cocoon of sap.

**WYNSNOW** The old way. One gives itself to the other and comes out part of it.

**WYNSNOW** The rules are the lore. No cocoon holds a stranger: they must be close in level.

**WYNSNOW** And seedlings remember: eggs keep their parent's growth.

**WYNSNOW** Never into a person. That's Joining, and it's forbidden.

**MEAT MEAT** ...Why forbidden?

**WYNSNOW** Because the last person who tried it made monsters. A pale woman. Long ago.

Meat Meat doesn't say anything else. She puts her hands in her pockets. `[herald: Meat Meat]` (You don't say anything. Your hands have gone cold.)

**ALBERICA** *(quietly, a hand on Meat Meat's head)* I've got you, sweetheart.

**WYNSNOW** Now, excuse me. I'm about to lecture on the Reversal. Come and watch, if you like. It's about you.

- **Flow:** Grafting licence (unlocks the Cocoon Chamber). Sets `grafting_licence`. Optional: Lecture in Blue Fire.

### SC 6.06 — Gym 4: Hellen Brightrun

- **Map:** 2059 Hearth Root-Cellar. **Trigger:** Hellen: "You want to know the city? Fight the people who feed it." **Trainers:** Dunstan, Mellow, Old Corrie, Tallis; Hellen (Normal). **Music:** gym theme.

Hellen stands in the warm dark among the roots, sleeves rolled up. Like the bar at closing.

**HELLEN** Sit down first. Eat that. ...Good. Four hundred years I've told your stories.

**HELLEN** Show me I wasn't lying.

**SHADE** Look at her stance. That's not a barkeep. That's a bouncer.

**ALBERICA** Shade, darling, she's both. The best ones always are.

**MEAT MEAT** Meat Meat ate the bread. Meat Meat will now fight the bread lady. Respectfully.

**HELLEN** *(after)* The Hearthstone Seal. It's a little cup, see? Because you always come back to the Hearth.

**HELLEN** And you never pay for a drink here again.

**HELLEN** That TM's Facade. Hits harder when you're hurt. Like most of the people in my bar.

**HELLEN** Go and see Pip in the Bazaar. Four badges? She'll want to make you a rucksack. She'll cry. Let her.

**ALBERICA** Never pay for a drink again. Hellen, marry me.

**REPTIN** She's like that with everyone, Hellen. It's a compliment and a warning.

- **Flow:** Hearthstone Seal (`badge_he`arth), TM42 (Facade).

### SC 6.07 — The Rite of Stillness

- **Map:** 2056 Still Sky Shrine, night. **Trigger:** enter with `wardens_sworn` or `wardens_refused`. **Present:** party; Matron Eline; Halo disciples; a man frozen in ice on the altar, with an empty hollow in his chest. **Music:** *Frostmaiden*, then boss.

`[first time in the Root-Tier]` Moss-steam and fish oil. Living wood creaks overhead, and meltwater drips from the roots. Glow-worm lanterns swing from root-arches, green light on black water. Where the ice once choked Dougan's Hole, warm mist coils.

`[first time in the Root-Tier]` **REPTIN** Dougan's Hole. Right under our feet. I walked these streets when they were ice. **ALBERICA** *(sniffing)* Fish, moss and old ice. Smells like my first marriage. **SHADE** Festival's up there. Whatever this is, it's down here. Let's be quick.

`[entering the Shrine]` A half-collapsed chapel of blue marble. Frost clings to every icon. Under a hole in the roof, robed figures kneel round a statue. Jars of glowing sap line its feet. Someone is chanting, very softly: "Cool the heart of the goddess. Cool the heart. Cool it until it stops."

`[entering the Shrine]` **ALBERICA** *(whispering)* I hate a hymn with no tune. **ALERION** Quiet.

On the altar, under a cracked statue of Auril, a man stands frozen in old blue ice.

No coat. Bare feet.

**SHADE** *(very quiet)* ...That's him.

Four hundred years in the ice. The Halo's candles burn all around him.

In his chest, where the frost-light used to beat, there's only a carved-out hollow.

**ELINE** The Frost Saint. You know him. Your hand froze him. Ours kept him.

**ELINE** His heart was the holiest thing we had.

**ALBERICA** Was?

**ELINE** We gave it to Summer. Summer has promised us a winter. Not death. Stillness, at last.

**ELINE** The way the Dale was meant to be.

**ELINE** Tonight we cool the tree. A little. Just enough to start.

**REPTIN** *(pleasantly)* Matron, I'm going to ask you nicely to stop. That was the nice part. `[herald: Reptin, quiet]` "Stop. Please."

- **Battle:** Halo disciples, then Eline (Lv 36–38).

**ELINE** It doesn't matter. Summer has the heart. Summer keeps promises.

She slips out through a back door you didn't see.

Outside, the aurora flickers, and the gold steadies.

On the altar, beside the frozen man, someone has left two Full Restores.

**ALERION** Bait.

**ALBERICA** Free, though.

**ALERION** ...Free bait.

- **Flow:** sets `rite_stopped`, `heart_given_summer`. The Halo leave the city's surface. 2 Full Restores on the altar.
- **Notes:** this answers "where is Sephek's heart" (Avarice's engine) and fixes Eline's old line "your own hand cut his heart from him".

### SC 6.08 — The spark that wasn't out

- **Map:** 2061 Canopy-Tier, the Celestial Rift. **Trigger:** go to the Rift after `twins_met`. **Present:** party, Frostina, then Glimmer; Brightmane in the mirror. **Music:** *Thaw*, then *Heralds*.

Above the crown of the tree, the sky opens. No clouds: only aurora, pouring down in a curtain.

In the middle of it a shard of light turns slowly.

Behind it the curtain goes smooth and bright as a mirror.

In the mirror, a plain of stars, each one burning like an ember.

At the edge of the glass stands a unicorn with a mane of fire. She is looking at Shade.

**SHADE** ...Oh. It's you.

**SHADE** It's been you since Saltmarsh, hasn't it.

Shade looks down at their own empty hands.

**SHADE** That night in the white, I pulled Shimmer out. And something pulled back.

**SHADE** In the morning there was a unicorn's horn in the snow. I carried it for years.

**SHADE** Then I gave it to an egg.

**BRIGHTMANE** *(a voice like a bell, heard through warm water)* You gave away the last of me...

**BRIGHTMANE** ...to save a child you had never met. Come and get it back.

`[flag: luna_spark]` **SHADE** The Wennen said our house had a spark that wasn't out. Waiting somewhere bright.

`[flag: luna_spark]` **SHADE** Subtle, Luna.

Frostina drops down past the Rift, close enough to stir everyone's hair.

She looks at Shade and hums four notes.

**SHADE** *(very quietly)* Shimmer told me to keep going. I think this is what she meant.

**MEAT MEAT** Shade comes back. Meat Meat promises for Shade.

**ALBERICA** You'd better come back, sugar. I haven't finished teasing you. `[herald: Alberica, quiet]` "...Come back. That's all."

**REPTIN** We'll hold the door. Diplomatically. With teeth, if it comes to that.

**ALERION** Go.

▸ YOU *(Shade looks at you last)*: "Go." (`told_shade_go`) / "Come back."

Shade steps into the mirror. The glass takes them like warm water.

Stars move on the other side. For one breath, nothing at all.

Then the glass bulges. A tall cat-man steps out, and for a moment stars come with him, caught in his fur.

A midnight-blue coat. The cursed dagger at his hip. In his hand, a unicorn's horn.

He closes his other hand on the Lumen Shard. It sinks into his chest like a coal into snow, and beats.

**???** ...That took longer than Brightmane promised. Unicorns are terrible at time.

**ALBERICA** ...Shade?

**GLIMMER** Glimmer, now. Brightmane says a name should fit what you carry.

**GLIMMER** Seven years on her side of the glass. About a minute on yours.

He turns the horn over in his hands.

**GLIMMER** She gave it back. She says I'm a fire now. I'm still deciding how I feel about the fur.

**MEAT MEAT** *(poking his arm)* Shade came back. Meat Meat promised. ...Shade is fluffy now.

**GLIMMER** Please don't.

`[flag: heard_of_glimmer]` He takes Shimmer's little carved wooden cat out of his coat and holds it up beside his own face.

`[flag: heard_of_glimmer]` He laughs. Then he isn't laughing.

`[flag: heard_of_glimmer]` **GLIMMER** She always said I'd end up a cat. I hate that she was right.

`[flag: sanctum_dream]` **GLIMMER** ...And you. You knocked on the Moon Temple door. I heard you, from the other side. Time's strange over there.

Frostina hums four notes at him. He hums them back, off-key, the way Shade always did.

**GLIMMER** Brightmane said Shimmer gave the ice of her heart so others could live.

**GLIMMER** Somebody had to carry her torch. I said it wasn't fair that it was mine.

**GLIMMER** She said that's what torches are like.

He draws the Rimefang. The blade still smokes with cold.

**GLIMMER** And this is still cursed. Still marks me for Auril. Still killing me slowly, since Saltmarsh.

**GLIMMER** Brightmane says I'll find it a better fire.

**ALERION** Then we'll find it one together. `[herald: Alerion, quiet]` "...Together."

*Shade is Glimmer now. Glimmer joined the party.*

- **Flow:** Shade leaves the companions and Glimmer joins: they're the same person. Sets `glimmer_joined`, `shade_became_glimmer`, `glimmer_has_rimefang`. The horn is the one Shade gave Razzy's shell in SC 2.04, given back by Brightmane; it goes back to her with Glimmer at the Forge.

### SC 6.09 — Festival night

- **Map:** 2050, night 7. **Trigger:** rest at the Hearth with `rite_stopped`, `glimmer_joined` and `badge_hellen`. **Present:** party, Kelyn, Rheven and his direwolf, Eirwen, Hew, crowd; Wyn (not in Wyn Mode). **Music:** *Hearth*, then a hard cut.

The seventh night. Lanterns on every root, pine-mead in every hand, the whole city in the market.

Beside the Heralds stands the Summer Throne, carried out for the night: empty, and scorched black.

**KELYN** *(raising a glass)* Heralds of Dawn and Dusk. Tonight, Rootspire remembers.

**ALBERICA** Finally, a toast with my name in it. Somebody top me up.

**REPTIN** *(under his breath, smiling at the crowd)* Wave. They carved us. We owe them the faces.

The ground shudders. Once. The same shudder as the lantern.

Overhead, the aurora flickers in a hard, even rhythm. Like a pulse. Like something built.

**GLIMMER** *(a hand on his chest)* Something under us is burning.

**MEAT MEAT** *(gone white)* Meat Meat knows that sound. Hammers. The cold table had hammers under it. `[herald: Meat Meat]` (You know that sound...)

**ALERION** *(low, to Meat Meat)* Then we go down and break them.

**RHEVEN** The tree dreams of fire. I've seen it every night this week.

`[flag: fed_pack]` Rheven's direwolf has pushed her nose into Reptin's hand and won't leave. **RHEVEN** She's tundra stock. Old line. She knows you.

**EIRWEN** The library's oldest maps show the hag's lair. Under Dougan's Hole.

**EIRWEN** Which is under us.

`[herald: not Wyn]` A Rootwarden pushes through the crowd, out of breath, a Sableye clinging to their shoulder.

`[herald: not Wyn]` **WYN** Captain... the Sap Gate spores went silent. Hyphora's... afraid.

`[herald: not Wyn]` **WYN** Sorry. Sorry. I'm interrupting.

`[herald: Wyn]` (The spores went silent. You know what that means. You've heard that silence once before: the night you left your post.)

**KELYN** *(setting down her glass)* Heralds. Something is waking below. Find our Summer Marshal.

**KELYN** And stop whatever is burning the roots.

**HEW** *(shoving through)* And find my diggers while you're at it! Twelve gone in the Guild Dig!

**WYN** The roots have... another way down. Through the myconids. I can take you.

**WYN** If... if that's all right. `[herald: Wyn]` "The roots have another way down. Through the myconids. I can take you." `[herald: Wyn, quiet]` "...I know another way down. The myconids'."

**ALBERICA** Darling, it's more than all right. Lead on.

**MEAT MEAT** Mushroom person smells like coffee. Meat Meat approves.

*Wyn joined the party.*

- **Flow:** sets `festival_night`, `ch7_started`. Wyn joins if not the player (`wyn_joined`). Both roads open: the Sap Gate to the Undercanopy (Road A), and the Guild Dig and Split Dock (Road B).
- **Notes:** in Wyn Mode, Wyn's own inner line replaces the report: "The spores went silent. I know what that means. I've heard it once before, the night I left my post."

## Chapter 7, Road A: The Heartroot

**Road goal:** reach the tree's heart from below, through the people who tend it. Wyn leads. This road can be done before or after Road B; lines marked `[flag: road_b_done]` change when it comes second.

### SC 7A.01 — Declare your purpose

- **Map:** 2055 Root-Tier, the Sap Gate; 2068 Undercanopy entrance. **Trigger:** enter the Sap Gate with `ch7_started`. **Present:** party, Wyn, Eira Shadebloom. **Music:** *Thaw* (low, wet).

**WYN** My post. I sat here every night for three years.

**WYN** *(a hand on the root)* ...And the one night it mattered, I wasn't here.

`[herald: Wyn]` Your post. Your Gate. The bench where you sat every night for three years. The place on the root you wore smooth with your thumb. **WYN** *(to the Gate)* I'm back. I'm sorry I was gone. `[herald: Wyn, quiet]` "..."

**ALBERICA** You're here now, sweetheart. That counts double.

Wyn finds a knot in the root with their thumb, the way you'd find a lamp in the dark.

The Gate unknots itself, slowly, with a sound like a sigh.

`[entering the Undercanopy]` Fungal beds glow green, blue and amber. The ceiling rises and falls, like breathing.

A myconid with a violet-veined cap steps into the tunnel. Its spear is tipped with mirror-glass.

Its voice arrives inside your head, like a cold creek running over stones.

**EIRA** Halt. Declare your purpose.

**WYN** They're with me, Eira. The roots are burning. `[herald: Wyn, quiet]` "...The roots are burning."

**EIRA** *(to Wyn)* You left your post. The night the door broke. Hyphora noticed.

**WYN** I know. I'm here to answer for it. `[herald: Wyn, quiet]` "...I know."

**REPTIN** *(gently)* And we're here to stand next to them while they do.

**MEAT MEAT** Anyone pokes mushroom friend with a spear, Meat Meat pokes back.

**EIRA** ...Pass. Touch nothing that sings.

**ALBERICA** Touch nothing that sings. Well. There goes my evening.

**ALERION** You could not sing.

**ALBERICA** Pretty boy, I could not breathe, either. Neither's happening.

- **Flow:** sets `undercanopy_entered`.

### SC 7A.02 — Yarro's blight

- **Map:** 2068 Spore Gardens. **Trigger:** talk to Yarro. **Present:** Yarro, sporelings. **Music:** *Thaw*.

Glowing fungal beds, and in the middle of them a spreading patch of black-red caps.

The air above them shimmers with heat.

**YARRO** *(a voice like warm rain)* They grow where the roots run hot.

**YARRO** Something below is cooking them. Cooking her.

**REPTIN** Her? Forgive me. Who's 'her'?

**YARRO** We don't say her name to people we've just met.

**ALBERICA** Then buy us a drink first, sugar. That's how it works upstairs.

`[a Pokémon with a Fire move]` *(Pokémon)* breathes a careful line of fire across the black caps, and not a hair further. They curl, crackle, and go to ash.

`[no Fire move, Glimmer with you]` **GLIMMER** Let me. Brightmane says I'm a fire now. Let's find out if she's right. The Lumen Shard in his chest flares. He draws one finger through the air over the black caps. They curl and go to ash. The healthy beds don't even get warm. **MEAT MEAT** Cat is a lighter now. Useful cat.

**WYN** *(to the ash, very softly)* There. You can grow back now.

**YARRO** Gently done. The gardens will remember you. So will I, if anyone asks.

**YARRO** Take a lantern-puff. Squeeze it and it glows. Carry it and the dark leaves you be.

- **Puzzle:** burn the blight cleanly with a Fire move (the existing check) without touching the healthy beds.
- **Flow:** Luminescent Lantern. Sets `blight_cleared`. Yarro becomes a Trial witness.

### SC 7A.03 — Gym 7: Sovereign Luminara

- **Map:** 2068 Council Fane. **Trigger:** enter after `blight_cleared`. **Present:** Luminara, myconid court. **Music:** gym theme.

`[before the blight is burned]` A myconid taller than the rest sits on the root-throne of the Fane. Her cap glows like stained glass. **LUMINARA** My gardener's beds are burning, and you come asking, asking. Help Yarro. Then ask.

**LUMINARA** *(wind through reeds)* Surface. Sap-takers. Root-burners.

**LUMINARA** You come asking, asking. What do you bring?

**REPTIN** Good manners, Sovereign. And your gardener's beds, mended. And a fight, if you'd like one. `[herald: Reptin, quiet]` "Your gardener's beds. Mended."

**GLIMMER** And a little light. I'm told I'm good for that now.

**LUMINARA** Then share spores with us. Battle is how we taste a stranger.

**MEAT MEAT** Meat Meat will not be tasted. Meat Meat does the tasting.

**REPTIN** *(under his breath)* What she means is, thank you for having us.

- **Battle:** Luminara (Grass/Fairy). Her overworld sprite must be a myconid, not a human Beauty sprite.

**LUMINARA** Tasted. Honest. The Rapport Seal.

**LUMINARA** Energy Ball. Light, gathered by green things, thrown hard.

**LUMINARA** Go to the Mnemosyne. She will decide if you may hear the name.

**WYN** *(barely out loud)* She said honest. She never says honest.

- **Flow:** Rapport Seal (`badge_luminara`), TM53.

### SC 7A.04 — The thread that binds

- **Map:** 2068 Mnemosyne's Chamber. **Trigger:** talk to Myr. **Present:** Myr, party. **Music:** *Thaw*, hushed.

An ancient myconid, layered like old bark, sits in a ring of stone tablets.

**MYR** *(many voices at once)* I remember the first logger. I remember the sapling.

**MYR** I remember the night the seed drank four hundred years.

**MYR** *(to Reptin)* You carried the seed.

**REPTIN** A golden acorn, from a priest in Bryn Shander. I did ask nicely.

**MYR** A seed of Erato, who was a seed of Balanus.

**MYR** And Balanus was the World Tree, before the Frostmaiden cut it down.

**ALBERICA** ...That's a lot of grandmothers for one acorn.

**MYR** You planted a god, warden. Swear to protect it, and I will tell you its name.

▸ YOU:

- *Swear.* `[flag: wardens_sworn]` "We already have." Sets `hyphora_sworn`.
- *Ask what happens if you don't.* **MYR** Then you'll protect something you can't call by name. That's harder. A long pause. The tablets around her hum. **ALERION** We'll do it anyway. Sets `hyphora_sworn` anyway.

**MYR** Hyphora. It means the thread that binds.

**WYN** *(very quietly)* Hyphora. ...Hello.

**MYR** And Hyphora is afraid. Something under her burns hotter every night.

**MYR** It drinks her sap. It has carved her old roots into a machine.

**MYR** Past the Fane the water has gone bad. Go down that way. The lake remembers things it shouldn't.

- **Flow:** sets `hyphora_named`.

### SC 7A.05 — The lake remembers

- **Map:** new Tainted Lake. **Trigger:** enter from the Fane. **Present:** party, the lake monster. **Music:** *Hunt*.

An underground lake, iridescent with slime.

A voice rises off the water: calm, charming, and very familiar.

**VOICE IN THE WATER** The lake remembers. The lake remembers.

**GLIMMER** *(a hand on the dagger at his hip)* The Rimefang's gone cold. It knows that voice.

**ALERION** Sephek.

**WYN** Not him. His heart. They're burning it, somewhere below us.

**WYN** The sap carries the echo up here.

**MEAT MEAT** Meat Meat hates this lake. Meat Meat is not drinking this lake.

`[the lake monster]` The slick on the water bulges. Something huge and pale rises out of it. Its gills flare. It's furious at the heat that woke it.

**REPTIN** It's not evil. It's scalded. Gently, if we can.

**MEAT MEAT** Meat Meat can be gentle.

**ALBERICA** Since when, sweetheart?

**MEAT MEAT** Since now. Watch.

`[after the battle]` The creature sinks back under the slick, exhausted. The water still stinks of rot and heat.

Reptin kneels at the edge and lays his hand flat on the root that runs under the water.

**REPTIN** *(softly, to the root)* Excuse me. Could we trouble you for a little rain? `[herald: Reptin, quiet]` "...Please." `[no Reptin]` Wyn kneels and lays a hand flat on a root.

He asks. The tree answers.

Rain falls from the roots overhead: clean water, cold, pattering on the lake.

The slick breaks up, drifts apart, and is gone.

The lake goes clear. At the bottom, something round and stony glints.

**ALBERICA** Reptin, darling, you have to teach me that. For baths. `[no Reptin]` "Wyn, sweetheart..."

- **Battle:** the lake monster ("angry at being woken by warmth"). Then cleanse the lake: Reptin calls rain from the roots.
- **Flow:** Hyphora's Blessing. Sets `lake_cleansed`. At the bottom, a fossilised seed of Balanus (key item; Cornipus on the Canopy explains it).

### SC 7A.06 — The fallen god

- **Map:** new Mycolith's Hollow. **Trigger:** enter after `lake_cleansed`. **Present:** party, the Shadow Mycolith. **Music:** boss.

A sealed door with five carvings: a mask, a fist, an hourglass, a paw, a shadow.

**ALERION** Places like this always ask.

**REPTIN** Five carvings, five of us. I do love a door with a guest list.

- **Puzzle (the Five Domains):** each Herald touches their domain. Alerion takes the mask (Illusion), Meat Meat the fist (Force), Alberica the hourglass (Time), Reptin the paw (Wild), and Wyn the shadow (Shadow). Missing Heralds are replaced by their partner Pokémon.

Each carving lights under its Herald's palm, with one line each: **ALERION** Illusion. ...Fine. **MEAT MEAT** Force. Obviously. **ALBERICA** Time. Darling, I'm always late. **REPTIN** Wild. Not one word, any of you. **WYN** ...Shadow. Oh.

All five carvings glow at once. The door grinds open, and cold breathes out of it.

Icy platforms over a black lake. On them, a shelf-fungus monolith with an auroral crack down its middle.

It's breathing.

**WYN** It's the old tree. What's left of Balanus's grief.

**WYN** A god that died, and wouldn't let go.

**ALERION** *(very quietly)* I know how that goes.

**SHADOW MYCOLITH** *(roots of sound)* STILL. STAY. STILL.

- **Battle:** the Shadow Mycolith (Grass/Dark; your design sheet). Two phases; the second uses the "enraged" form.

`[between phases]` The monolith splits along its crack. Something darker pours out of the gap, and stands up. **SHADOW MYCOLITH** STILL! STAY! STILL!

When it falls, a spark of shadow rises from it like a moth, and settles on Wyn's hand.

**WYN** *(quiet)* Oh. That's... mine now. Isn't it. `[herald: Wyn, quiet]` "...Oh."

**MEAT MEAT** Mushroom friend is a god now. Meat Meat is still the bodyguard.

**WYN** ...Thank you. For both of those.

- **Flow:** sets `mycolith_down`, `godspark_shadow`. Wyn's partner Sporeye can evolve to Myconarch from now on. This is what `godspark_shadow` now pays off.

### SC 7A.07 — Hyphora's leave

- **Map:** new Root Chapel, under the Fane. **Trigger:** follows 7A.06. **Present:** party; Hyphora as a voice and a light in the roots. **Music:** *Thaw*, full.

The roots around you glow amber. Something enormous and very young looks at you through them.

**HYPHORA** *(no words at first; only the feeling of being held)*

**HYPHORA** You planted me. You came back.

**HYPHORA** Below me: fire. The cold man's heart. A woman who counts.

**HYPHORA** I will open my roots to the burning place. Go carefully. I am only four hundred years old.

**ALBERICA** Only four hundred? Sweetheart, I've got shoes older than that.

**REPTIN** You do not.

**ALBERICA** Spiritually.

**WYN** *(a hand on the root)* We'll be careful. I promise.

`[flag: road_b_done]` The roots part. Hew's ladder is on the far side. The heart of the forge is straight down. *(go to Chapter 8)*

`[not: road_b_done]` The roots part, but a door of iron and mirror glass blocks the far side. **ALERION** Locked. From the city side. **WYN** The Guild Dig. Hew's tunnels touch it. *(Road B is next.)*

- **Flow:** sets `road_a_done`, `hyphora_leave`.

## Chapter 7, Road B: The Forge Road

**Road goal:** follow the missing diggers and the heat down through the city's own works, to the forge door. Gyms 5 and 6 are on this road; their teams scale with your badge count.

### SC 7B.01 — Twelve diggers

- **Map:** 2066 Guild Dig. **Trigger:** enter with `ch7_started`. **Present:** Hew, sap-dazed diggers Gant and Hobb, Prototype 3; Halo saboteurs Tarn and Odile (now with map sprites). **Music:** *Forge* (distant).

`[Hew, by his ladder in the market]` **HEW** You're going down? Then you're going down MY ladder. **HEW** Twelve of mine went down that dig. I'm not sending anybody else alone. **MEAT MEAT** Ladder man is loud. Meat Meat likes ladder man.

The tunnels are hot. Sap runs warm in the walls and drips like sweat.

Somewhere ahead, a pick is still swinging. Slowly. Like someone sleepwalking.

**HEW** That's how they all went. Walked down, smiling. `[if Hew didn't come down]` **REPTIN** They cut into the tree. Not around it. Into it. It's bleeding.

**ALBERICA** Hot, dark, sweaty tunnels. I've had worse nights out.

**REPTIN** We know, darling. You told us.

**ALERION** Twice.

`[the diggers]` **GANT** *(sap-dazed, smiling)* Warm. So warm. Down's where the warm is. Down, down.

`[after each digger's battle]` The sap-daze clears from the digger's eyes all at once. They sit down, hard. **DIGGER** Where... We were digging, and the amber started talking. The others kept going. Down. I don't know where. **WYN** *(holding out a biscuit)* Here. You've been working a long time. Eat something.

`[Prototype 3]` A small sap-powered construct kneels at a root, hands pressed together.

**PROTOTYPE 3** Father. Father, you are hot. Father, I am afraid for you.

**HEW** *(embarrassed)* It calls the tree that. I didn't teach it that.

**MEAT MEAT** ...It is scared for its father. Meat Meat would be too.

**WYN** *(kneeling beside it)* He can hear you. Trees always can.

▸ YOU: *Let it keep praying* (it holds out a shining stone: "For the visitors. Father would want." Shiny Stone) / *Shut it down* (the lamp-eyes dim last of all, still turned toward the root; in its clay hand, a Metal Coat).

- **Puzzle:** the existing sap-cache sabotage. Stop Tarn and Odile (trainer battles) from igniting the caches.

`[at each cache]` A Guild sap cache: amber fuel bricks stacked to the ceiling. A fuse of oiled cord runs into it. The cord is smoking. A figure in grey Halo robes crouches over it with a flint. **REPTIN** Fuse. Now.

You stamp out the fuse.

**ODILE** *(beaten)* We only wanted to cool it.

**ODILE** Summer said a little fire here and the tree would sleep. And winter would come.

`[both caches safe]` **ALERION** Fire to make winter. Summer's promises don't add up. **ALERION** Somebody's counting on that. **MEAT MEAT** Ice Prince did maths. Meat Meat is proud. **HEW** *(from the west tunnels)* Caches safe? Then come and see me in the Annex. We need to talk. Properly.

- **Flow:** sets `diggers_found` (they're further down; you'll find them in Ch8). Prototype 3 gives a Metal Coat or Shiny Stone (the existing `father_construct`).

### SC 7B.02 — Gym 5: Master Hew Talmire

- **Map:** 2066 Guild Forge Annex. **Trigger:** talk to Hew after the caches. **Trainers:** Guild workers; Hew (Steel/Ground). **Music:** gym theme.

**HEW** I've dug sap out of this tree for forty years. Somebody's been digging deeper.

**HEW** Let's see if you're worth my ladder.

**ALBERICA** Forty years with one tree. Now that's devotion.

**HEW** *(after)* Guild Seal. Rock Slide. Mind your heads.

**HEW** And here's the truth. Ten years I've sold sap to Summer's people.

**HEW** Liquid sunlight, they called it. I never asked what for.

**REPTIN** *(quietly)* Thank you for telling us. That can't have been easy.

**HEW** I'll say it again at any trial you like. I'll say it to the tree.

**HEW** My last ladder runs past the south cache, to a door I was told never to open. Iron and glass. Summer's people again.

`[both diggers brought back]` **HEW** And Gant. And Hobb. You brought two of them back to me. Take the Guild's dig money. Take the light. Take anything. *($6,000, 2 Auroral Motes.)*

- **Flow:** Guild Seal (`badge_hew`). Hew becomes a Trial witness (`hew_confessed`). His last ladder leads to a door he "was told never to open" (see 7B.08).

### SC 7B.03 — The child in the mirror

- **Map:** 2067 Overflow Channel. **Trigger:** enter. **Present:** party; a mirror child. **Music:** *Rime*, distorted.

On the far ledge stands a tall mirror.

A girl is pressed against the glass from the inside, half of her through on this side.

**MIRROR CHILD** It pulled me. Mama's mirror. I was looking at my hair, and it pulled.

**ALBERICA** Hey. Look at me. Big breath, all the way in. We're getting you out.

▸ YOU: *Break the mirror?* You grip the frame. The glass shrieks. Something pulls itself out of it, all edges and reflections!

- **Battle:** Mirror Echo (the existing boss) breaks the mirror. The girl falls free.

The echo shatters, and the mirror with it. The girl falls free, into your arms, and sneezes.

**ALBERICA** Bless you! There she is. Brave girl.

**MIRROR CHILD** My mama's Mira. On the big ship.

**MIRROR CHILD** She's been talking funny. She says "we" now.

She holds on to your sleeve, and won't let go until you've promised to take her home.

**MEAT MEAT** Meat Meat will hold the small one's other sleeve.

- **Flow:** sets `mirror_child_free`. Vault Map fragment 1 is on the other ledge.

### SC 7B.04 — Gym 6: Mira of the North Wind

- **Map:** 2055 Root-Tier, the Split Dock, aboard the *Boreal Requiem*. **Trigger:** board with `mirror_child_free`. **Present:** Mira; Corsairs; a mirror-core in the hold. **Music:** *Hunt*, then gym theme.

**CORSAIR** Is that... the little one's ribbon? Where did you... Get aboard. Quick. The Captain's at the wheel.

Mira stands at the wheel in a ring of mirrors. Her daughter runs to her.

Mira doesn't look down.

**MIRA** *(two voices at once, one of them colder)* We know you. The Heralds. Our little failures.

**MEAT MEAT** *(stopping dead)* ...Meat Meat knows that voice. From the cold table.

**REPTIN** *(stepping between the girl and her mother)* Behind me, sweetheart. Now.

**MIRA** *(the cold voice)* You found my nest, didn't you? Come down and see it. We'll be waiting.

Below, in the hold, something hums: a mirror-core, wired into the ship's ribs.

- **Battle 1:** the mirror-core in the hold (a Mirror Echo of Avarice). Break it.

The core cracks across, and every mirror on the deck cracks with it.

Mira collapses. When she looks up, there's only one voice.

**MIRA** *(hoarse)* Thirty years. Something talking in my mirrors for thirty years.

Her daughter climbs into her lap.

**MIRA** ...Gods. Thank you. Now fight me properly. I need to feel like myself.

**ALBERICA** Oh, I like her.

- **Battle 2:** Gym 6, Mira (Water/Psychic).

**MIRA** Tide Seal.

**MIRA** Psychic. Clean thinking. I could use some.

**MIRA** And the *Requiem* is yours if you ever need a ship. I don't care where.

- **Flow:** Tide Seal (`badge_mira`). Sets `mira_freed`, `corsair_favour` (pays off in Ch12). Mira becomes a Trial witness and a candidate.

### SC 7B.05 — The aurora seal

- **Map:** 2057 Heartroot: the Root Gate. **Trigger:** enter the Root-Gate well. **Present:** party. **Music:** *Rime*.

The stairwell breathes. Sap drips from the ceiling in slow amber tears.

Each drop hits the roots below with the sound of a heartbeat.

The air goes warm, then cold, as if the seasons can't agree whose turn it is.

Somewhere ahead, water whispers against glass.

Faint aurora trickles down through hairline cracks. *(Tonight's colour, picked once per save: green, gold, red or white.)*

**ALERION** Tonight's aurora is green. Remember that. Places like this always ask.

**REPTIN** He means: everyone, please take notes.

**ALERION** I meant remember it.

**WYN** *(very softly)* ...The tree's frightened. Sorry. I just... thought someone should say.

`[the seal]` A circle of bare heartroot, carved with four seasonal runes. Each bleeds a different colour of sap. At the centre, a hollow where the colours could meet. Round the rim, in Druidic and in Wennen: BEGIN WHERE THE SKY BEGINS. TURN AS THE YEAR TURNS.

`[right order]` Four colours of sap meet in the hollow at the centre. They climb the thread of aurora like ivy up a wall, in order, round and round. The circle sighs. Below you, the braided-root door unknots itself, root by root. **MEAT MEAT** Puzzle beaten. Meat Meat would like that on the wall too.

`[wrong order, first time]` The sap boils, rises, stands up: a Sap Wraith. When it bursts, for an instant you see through its eyes: a white room under the ice. Rows of glass. Something in the glass that has your faces.

- **Puzzle:** the existing aurora rune seal. Press the runes in year order starting from tonight's aurora colour. A wrong order spawns a Sap Wraith.
- **Flow:** sets `seal_open`.

### SC 7B.06 — Three wells

- **Map:** 2058 Heartroot: the Sap Wells. **Trigger:** drink from each well. **Present:** party; the whispering attendant. **Music:** *Thaw*, strange.

A low arch of roots opens onto a cavern. Golden sap rains from the ceiling in thin strands.

It fills shallow basins. Some of them glow with the aurora's reflection.

The air smells like honey left too long in the sun.

**ALBERICA** Oh, that's indecent. Somebody hold my hair, I'm going to drink a wall.

**WYN** Please... please don't drink the wall.

`[each well]` It tastes of honey and sunlight and, underneath, of ice. Your Pokémon crowd round and drink too. ...and then the cavern goes away.

*Well one:* A woman in white fur walks through a garden of glass trees, on an island shaped like a snowflake. *(Auril, Solstice: Act III.)*

*Well two:* Thirty years ago: a hand of mirror glass reaches up from under the roots, and takes hold of one. *(Avarice entering the bubble.)*

*Well three:* A vault of white ice under a glacier. In it, something with wings spread over a frozen eye. *(The postgame.)*

`[all three]` **ALBERICA** Three wells, three bad dreams. Somebody else's memories. Or somebody else's plans. **ALERION** Plans.

`[the attendant]` A sap-thing clings to a root column. Half its face is smooth. The other half is a swirl of mouths.

**ATTENDANT** *(in Avarice's voice, then in Alberica's own)* Ask. One question each.

**ALBERICA** Don't do my voice. Nobody does my voice.

- **Ask about Summer:** "Summer is a coat. Summer has been wearing a man for thirty years."
- **Ask about the heart:** "The cold man's heart is in the engine. The engine is in the hag's old kitchen."
- **Ask about yourself** `[mode: journey]`: "You aren't on her wheel. That's why the glass let you through."
- **Flow:** sets `wells_seen`.

### SC 7B.07 — Selrae, below

- **Map:** 2058, the far end. **Trigger:** follows 7B.06. **Present:** Selrae, two Rootwardens. **Music:** *Rime*.

The Winter Matron sits on a root with frost-burned hands. Her Pokémon pant in the heat.

Two Rootwardens stand over her, unsure who they're guarding.

**SELRAE** I came down after Var. A week ago. I got this far.

**SELRAE** You should know. I let the Halo into this city. Thirty years.

**SELRAE** I thought a little winter would balance this endless summer. That's all I wanted.

**REPTIN** *(gently)* Go on, Matron. We're listening.

**SELRAE** They gave the Frost Saint's heart to Summer. I knew it was wrong.

**SELRAE** I didn't know it was her.

**ALBERICA** *(very plainly)* Avarice.

**SELRAE** *(closing her eyes)* I've read that name in the oldest ledgers. I hoped it was a story.

**MEAT MEAT** Not a story. Meat Meat has the scars.

▸ YOU:

- *"Come home. Tell the Council."* **SELRAE** ...Kelyn will cry. Then she'll shout. Then she'll make me tea. Very well. She goes back up with the Rootwardens, leaning on one of them. Sets `selrae_home`. She testifies at the Trials and presides fairly.
- *"Come with us."* **SELRAE** I'll only slow you. No. I'll go ahead. Somebody should see what's down there before you walk into it. She stands, badly, and walks into the frost-grown roots before anyone can stop her. **ALERION** She'll get herself caught. You find her cocooned in Ch8 (SC 8.03). Sets `selrae_ahead`.

Before she goes, she presses a key of black ice into your hand.

**SELRAE** The Root-Key. Summer gave Winter a copy. To keep me quiet, I think.

- **Flow:** Root-Key (key item). Sets `root_key`.
- **Notes:** this replaces the unmotivated Selrae fight. Her battle is Gym 8 in Ch10.

### SC 7B.08 — The door of iron and glass

- **Map:** 2066, the bottom of Hew's last ladder. **Trigger:** use the Root-Key. **Present:** party. **Music:** *Forge*.

A door of iron and mirror glass, fused into the living root. The Root-Key turns.

Behind the door of iron and glass: a wall of roots, braided shut.

`[flag: road_a_done]` The roots know you. They open. Heat and hammering pour up the shaft. *(go to Chapter 8)*

`[not: road_a_done]` **WYN** The roots won't open for iron. Only for Hyphora. **REPTIN** Then we ask her. Nicely. I'm very good at nicely. *(Road A is next: the Sap Gate, in the Root-Tier.)*

- **Flow:** sets `road_b_done`.

## Chapter 8: The Rootsun Forge

**Chapter goal:** find the Summer Marshal and stop what's burning. Both roads end here, in the hag's old lair under the ruins of Dougan's Hole.

### SC 8.01 — The Rootward Barricade

- **Map:** new Rootward Barricade. **Trigger:** enter from either road. **Present:** party; enthralled duergar; Guild diggers with glassy eyes. **Music:** *Forge*.

Root and iron, fused into a wall. Duergar wearing Avarice's sigils guard it.

Among them, Hew's missing diggers haul sap with blank smiles.

**DUERGAR** The Forge-Mistress said you'd come. The failures always return.

On the wall, an illusion plays on a loop. A black dragon circles ten little towns on a frozen lake.

Each time it passes over a town, the town's lights go out. And come back. And go out.

**ALBERICA** That's the Dale. Our Dale. Outside the Wall.

**MEAT MEAT** Failures. Meat Meat has been called worse. By better.

**REPTIN** That's the spirit.

`[the ledger]` A duergar ledger, sap-stained. Tallies of fuel, tallies of hands. At the top of every page, the same words in a cramped hand: "Rimebound. Rise unbroken."

`[the gate]` A gate of root and iron, with a grille at head height. Behind the grille, eyes. **VOICE BEHIND THE GATE** Words.

▸ YOU: "Rimebound. Rise unbroken." / "Let us through." / Say nothing. *(Anything but the words: "Wrong. Go and burn somewhere else.")*

The bar slides. The gate grinds open.

The duergar behind it steps back, blinks, and looks at his hands as if they were somebody else's.

Behind you, the diggers stop hauling.

One by one they sit down where they are, and look around, and start to cry.

`[flag: hew_confessed]` **MEAT MEAT** Hew's people. Hew will come for them. Hew owes them that.

**WYN** *(already handing out a blanket)* It's all right. You're all right now.

- **Puzzle:** the passphrase "Rimebound. Rise unbroken." is scrawled on a duergar ledger. Say it at the gate.
- **Flow:** trainer battles; the diggers wake when their duergar handlers fall. Sets `barricade_passed`.

### SC 8.01a — The diggers' flask (rest banter)

- **Map:** Rootward Barricade. **Trigger:** rest with the woken diggers; once before the engine, once after. **Present:** whoever is in the party. **Music:** *Forge*, low.

A digger who's woken up shares a flask of warm sap with you and your Pokémon. Everyone feels better.

`[before 8.07]` **MEAT MEAT** This sap tastes like coffee that gave up.

`[before 8.07]` **WYN** Um. I have the mushroom kind. In my bag. If anyone...

`[before 8.07]` **MEAT MEAT** Mushroom friend is a hero.

`[before 8.07]` **GLIMMER** *(holding out a cup)* Seven years without a decent cup. Fill it, please.

`[before 8.07]` **ALBERICA** Seven years? Kitten, I'll pour it myself.

`[before 8.07]` **ALERION** Don't.

`[after 8.07]` Nobody says much. The diggers' flask goes round twice.

`[after 8.07]` **ALBERICA** *(quietly)* He'd have made a joke about this sap. A terrible one.

`[after 8.07]` **ALERION** He did.

`[after 8.07]` **WYN** ...I poured him a cup. I don't know why.

`[after 8.07]` **MEAT MEAT** Leave it. Meat Meat will guard it.

- **Flow:** rest point (heals; sets the Forge as where you wake after a loss). Sets `banter_forge_rest`, then `banter_forge_rest_after`.

### SC 8.02 — Mother's kitchen

- **Map:** new Hag's Abandoned Domain. **Trigger:** examine a tea table set for six. **Present:** party; Thredra's echo, faint in a cracked mirror. **Music:** *Frostmaiden*, warped.

A tea table set for six. Six cups, six saucers, six little cakes gone hard as stone.

Over it hangs a cracked mirror.

**THREDRA** *(from the glass, very small)* My, my. The children come back to mother's kitchen.

**ALBERICA** You're dead. We were there.

**THREDRA** I'm remembered, dearie. Mirrors always remember.

**THREDRA** And she took my kitchen. My mirrors, my stones, my lovely root.

**THREDRA** She uses my glass to wear people like coats.

**REPTIN** *(under his breath)* Says the woman who kept a pantry of children.

**THREDRA** Burn her forge, dearies, and I'll whisper you a secret.

▸ YOU:

- *"Tell us."* **THREDRA** The heart in her engine isn't hers. The body she wears isn't hers. Break the heart, and the coat falls off. The mirror cracks wider. Thredra laughs, and goes on laughing after her face has gone. The boss in 8.06 shows its weak point. Sets `took_hag_secret`, −1 Wheel.
- *Break the mirror.* **MEAT MEAT** No more deals with mirrors. `[herald: Meat Meat, quiet]` "...No." The glass breaks into a hundred pieces. None of them laugh. Sets `broke_hag_mirror`, +1 Wheel.

### SC 8.03 — The cocoon pens

- **Map:** new Hag's Abandoned Domain, lower level. **Trigger:** enter. **Present:** party; amber cocoons; Selrae (if `selrae_ahead`). **Music:** *Requiem*.

Rows of amber cocoons in the root walls. In some, shapes that might have been goblins.

Labels on brass plates: RAZ-MKI. RAZ-MKII. V-3. V-5. V-6.

One plate is empty, its cocoon split open from the inside, long ago. V-7.

**MEAT MEAT** *(very quietly)* ...That one is Meat Meat.

A journal on a lectern, in a neat white hand:

> *"Raz-MKIII showed resilience. Wyrm-essence holding." "The goblin survived far longer than expected. V-7 escaped with him." "Irrelevant: the method is proven."*

**MEAT MEAT** *(after a long time)* Meat Meat is not a method. `[herald: Meat Meat, quiet]` "...Not a method."

**REPTIN** *(kneeling beside her)* No. You're not.

Alberica doesn't make a joke. She just holds out her arm, and Meat Meat leans into it.

`[flag: selrae_ahead]` In the last cocoon: the Winter Matron, half-frozen in amber. Her eyes are open. You cut her free. **SELRAE** ...Thank you. I'll be quieter about my opinions from now on. Go on. I'll find my own way up. I've had a lot of practice being in the wrong place. **ALERION** Told you she'd get caught. **ALBERICA** Nobody likes a told-you-so, pretty boy. **ALERION** I do. Sets `selrae_rescued`.

`[flag: garagai_vow]` On a shelf: the head of a giant's axe, rimed with old frost. **REPTIN** Garagai's axe. I gave my word. It's going home. Key item: Garagai's Axe-head.

- **Flow:** sets `pens_seen`.
- **Notes:** this shows Meat Meat's origin without replacing the driftwood chest. The chest (her personal quest) still holds the full Subject V-7 page and the Verdant Blade.

### SC 8.04 — Autumn falls

- **Map:** new Dragonforge, the sap-pit bridge. **Trigger:** cross the bridge. **Present:** party; Autumn Warden Darrus Fell; a cocooned Rootspire child. **Music:** *Hunt*.

Darrus Fell, his velvet scorched, drags a cocoon toward the forge. Inside it, a child's face.

**DARRUS** Stand aside! The engine needs one more. One more, and it never stops.

**DARRUS** Eternal summer! No famine years, no winters, ever.

**DARRUS** Do you know what Autumn's ledgers could do with that?

**MEAT MEAT** That is a child. `[herald: Meat Meat, quiet]` "...Put the child down."

**DARRUS** It's fuel.

Meat Meat moves faster than anyone has ever seen her move.

A blade of pure thought flashes in her hand.

Darrus stumbles back, lets go of the cocoon, and goes over the rail.

He catches the edge. Below him, the sap boils.

**DARRUS** *(clinging)* Help me. Goblin. Help me.

Meat Meat looks at him for a long moment. Then she picks up the cocoon instead.

He falls.

`[herald: Meat Meat]` ▸ YOU *(Darrus is hanging from the edge. The child's cocoon is rolling toward the pit)*: *Take the child* (`mm_turned`) / *Reach for Darrus*: his hand finds yours; then the bridge shakes, and his hand slides out of yours like water. He falls (`mm_reached`). The court will hear which you chose.

**ALERION** *(after a beat)* ...We'll talk about that later.

**MEAT MEAT** *(holding the child)* Yes.

**WYN** *(very quietly)* ...Is the little one breathing?

The child in the cocoon is breathing. Somebody will have to carry them up.

Meat Meat doesn't let anybody else.

- **Flow:** sets `autumn_fell`, `child_saved`. This is the charge in Ch10 (Assassin's Reckoning).

### SC 8.05 — The Dragonforge

- **Map:** new Dragonforge. **Trigger:** enter. **Present:** party; duergar; a barbed devil in priest's robes; the chardalyn dragon. **Music:** *Forge*, full.

A cavern ringed by twenty standing stones.

Chained among them, on a cradle of iron and root: a dragon of black crystal and mirror glass.

Its eyes are dark.

Above it hangs the engine, a cage of chardalyn and roots.

In its heart burns a sliver of blue frost-light, wrapped in Hyphora's gold sap.

Blue at the edges. Red at the core.

**WYN** *(stricken)* That's her sap. That's Hyphora's blood.

**ALERION** And that's his heart. Sephek's.

**GLIMMER** *(the Rimefang shaking in his hand)* ...Brightmane said I'd know the fire when I saw it.

`[the devil-priest]` A barbed devil in priest's robes turns from the stones, smiling with too many teeth. **ALBERICA** Ooh. Lovely smile. Too many teeth, but lovely.

`[after]` **VEXMORTIS** Go on. She's waiting. She's always waiting. That's the worst of her. Behind him, a stair of black glass winds up into the engine's heart.

- **Flow:** trainer gauntlet (duergar, the devil-priest). Sets `forge_reached`.

### SC 8.06 — Summer

- **Map:** new Heart Chamber. **Trigger:** reach the engine. **Present:** party; Var Rime-Breaker; then Avarice. **Music:** *Forge*, then boss.

A big, scarred man in the Summer Marshal's gold stands at the engine's controls, his back to you.

**KELYN** *(over a sending-stone)* Var? Var, thank the seasons...

He turns. His face is Var's. His eyes are red-gold, and they don't blink.

**VAR** *(a woman's voice, amused)* Variables that refused to die. Hello again, my little failures.

The face cracks like a mirror.

Behind the cracks: white hair, infernal sigils, a smile like arithmetic.

**AVARICE** Thirty years I've worn this man. Thirty years of summer.

**AVARICE** A season that never ends has a god's worth of power in it. Mine.

**AVARICE** The Frostmaiden wants the world still. I want it running. On my schedule. Forever.

**MEAT MEAT** You took Razzy's voice. `[herald: Meat Meat, quiet]` "...You."

**AVARICE** I took a great deal more than that, V-7. Come here and I'll show you.

**REPTIN** *(stepping in front of Meat Meat)* She's not going anywhere near you.

`[flag: took_hag_secret]` (The hag's whisper: the heart in her engine isn't hers. You can see it now, under the gold: a seam of blue frost-light where the coat is stitched on.)

- **Battle:** Avarice, Forge-Mistress of Rootsun. Four-turn timer as the engine overheats; Infernal Rootbreakers join on turn 2. With `took_hag_secret`, the heart's weak point shows (bonus damage). If the timer runs out, the engine vents and the fight resets once with full HP for both sides.

`[if the engine vents]` The engine screams and vents. A wave of heat throws everyone to the floor. When you can see again, Avarice is on her feet, laughing, whole. **AVARICE** Again? Again. I love a repeatable experiment.

### SC 8.07 — A better fire

- **Map:** Heart Chamber. **Trigger:** win the battle. **Present:** everyone. **Music:** silence, then *Heralds*, slow.

Avarice staggers, laughing. Behind her, the engine screams.

Blue frost-light and red fire twist together.

It's going to burst, and take the tree's heart with it.

**AVARICE** Kill me and it blows. Leave me and it runs forever. Your move.

Glimmer steps past her.

**GLIMMER** This blade's been killing me slowly since Saltmarsh.

**GLIMMER** Brightmane said the curse breaks in a sacred fire.

He lifts the Rimefang.

**GLIMMER** I am a sacred fire. Brightmane made me one.

**ALBERICA** Glimmer. Sweetheart. Don't you dare. `[herald: Alberica, quiet]` "...Glimmer."

**GLIMMER** It's all right. Shimmer found the third way. I'm only following her.

He drives the Rimefang into the heart of the engine.

The Lumen Shard in his chest blazes like a sunrise.

The dagger melts. Re-forms. Gold now, not blue.

Far above, at the Shrine of the Twinned Dragons, Frostina lifts her head and goes quiet.

The engine goes dark.

Glimmer is kneeling where it was. Light is coming out of him, through his fur, through his coat.

He's smiling.

**GLIMMER** The cold's gone. Years of it. ...Tell Frostina it was a better fire. She'll know what I mean.

The light goes up, through the roots, through the tree, toward a plain of stars.

The unicorn's horn goes with it.

Where he was, a golden dagger lies on the stone, warm.

Meat Meat picks up the golden dagger and holds it against her chest for a long time.

**MEAT MEAT** Meat Meat not crying. That is sap. `[herald: Meat Meat, quiet]` "..."

**ALERION** *(very quietly)* He always hummed it wrong. On purpose, I think.

*Glimmer is gone.*

- **Flow:** Glimmer leaves the party. Sets `glimmer_gone`, `shade_curse_broken`, `engine_dead`. Key item: **Dawnfang** (the reforged Rimefang).
- **Notes:** Brightmane's chapel gets a new carving after this, and Rootspire's people start calling Glimmer "the Dagger Reborn".

### SC 8.08 — The coat falls off

- **Map:** Heart Chamber. **Trigger:** follows 8.07. **Present:** Avarice. **Music:** *Forge*, collapsing.

With the engine dead, Var's body cracks all over, like ice on a lake.

Avarice looks down at her hands.

**AVARICE** *(almost admiring)* Oh. That was clever.

She steps backward into a shard of the hag's old mirror. She's half gone before anyone can move.

**AVARICE** We'll speak again in the White Womb, little failures. Mind the dragon.

The mirror shatters. Var Rime-Breaker's body falls, empty, and turns to glass.

**ALBERICA** *(very plainly)* She doesn't get away. Not from us. Not after this.

- **Flow:** sets `avarice_fled`, `summer_dead` (the city will believe the Heralds killed Var).

### SC 8.09 — Launch

- **Map:** Dragonforge. **Trigger:** follows 8.08. **Present:** everyone; the chardalyn dragon. **Music:** boss intro.

Below, among the Twenty Stones, the black dragon's eyes light up, gold.

It doesn't need the engine. It was always meant to fly on its own.

It tears free of its chains, roars, and smashes straight up through the roots, toward the sky.

**MEAT MEAT** RAZZY!

**ALERION** *(already running)* Frostina.

Far above, two dragons are already diving.

- **Flow:** sets `dragon_launched`. Cut to Chapter 9.

## Chapter 9: Destruction's Light

**Chapter goal:** stop the chardalyn dragon before it reaches Ten-Towns' people. It leads the party back out into the Dale they left a few weeks ago, by the Dale's clock.

### SC 9.01 — The leaves fall

- **Map:** 2050 market. **Trigger:** surface after Ch8. **Present:** party, crowd, Tamsin, Rheven. **Music:** *Thaw* turning to *Rime*.

The gold dawn flickers. Goes rose. Then pale. For the first time in thirty years, the light changes.

A leaf falls in the market. Then a hundred. People hold out their hands like it's rain.

`[mode: journey]` **TAMSIN** *(catching one)* It's brown. Why is it brown? Is it sick?

`[mode: herald]` A kid with Hellen's chin catches one. **TAMSIN** It's brown. Why is it brown? Is it sick?

**RHEVEN** *(looking up at the crown)* It's not sick, kid. Summer's over. It's autumn. It's supposed to happen. ...It's been a while, that's all.

**ALBERICA** Put it in your hair, Tamsin. Autumn's the best-dressed season. Trust me.

**MEAT MEAT** Meat Meat has never seen autumn. Meat Meat is suspicious of autumn.

**ALERION** It's leaves.

**MEAT MEAT** Ice Prince says that about everything.

Past the valley's edge, the shimmering Auroral Wall goes thin as breath. Beyond it, snowflakes that have hung in the air for four hundred years begin, slowly, to fall.

- **Flow:** sets `summer_ended`, `wall_thinning`.

### SC 9.02 — Mount up

- **Map:** 2061 Canopy, the Shrine of the Twinned Dragons. **Trigger:** go to the dragons. **Present:** party, Razzilith, Frostina. **Music:** *Heralds*.

Frostina waits at the Shrine, very still. Razzilith paces the stump and won't settle. Frostina looks past all of you, at the steps, for someone who isn't there. Then she looks at the golden dagger.

**MEAT MEAT** *(holding out Dawnfang)* Glimmer said to tell you. It was a better fire.

Frostina lowers her head to the blade and hums four notes. She stops halfway, like a song with a voice missing.

**ALERION** *(a hand on her neck)* ...I'll watch her. Somebody has to. `[herald: Alerion, quiet]` "...I'll watch her."

Frostina turns and lays her brow against Alerion's. Frost-light runs up his arm under the skin, and settles behind his ribs. `[herald: Alerion]` Frostina turns and lays her brow against yours. Cold runs up your arm under the skin, a pale light in the veins. It settles behind your ribs, and stays.

**ALERION** ...She's in there. Her heart. It's beating once in her and once in me.

**ALBERICA** *(softly)* Pretty boy. You're glowing.

**ALERION** I know.

Razzilith shoves his snout into Meat Meat's chest and sits her down in the leaves. A green glow goes in over her heart, and stays. `[herald: Meat Meat]` Razzilith shoves his snout into your chest hard enough to sit you down in the leaves. Something green and warm goes in over your heart, and stays.

**MEAT MEAT** *(delighted)* He is warm. Inside Meat Meat. Like coffee. Razzilith is Meat Meat's. Meat Meat watches him. That is the rule now.

Round the old stump, so old the bark has grown over half of it, there's a carving. Reptin reads it out loud: `[herald: Reptin, or Reptin absent]` You read it out loud:

> THE TWINNED DRAGONS CHOOSE TWO. NOT RIDERS. DRAGOONS. GUIDES TO YOUNG DRAGONS. KEEPERS OF FRAGILE SEASONS. A LIVING VOW THAT THE SKY WILL OPEN AGAIN.

**REPTIN** ...Well. Congratulations on the new job titles. I assume there's no pay.

**ALERION** I didn't apply.

**MEAT MEAT** Dragoon. Meat Meat likes it. It has teeth in it.

**WYN** *(very softly, to Razzilith)* ...Congratulations. Both of you.

**RAZZILITH** *(a painted thought: the black dragon, and teeth)* ...CHASE.

`[version: frost]` Frostina lowers her wing. Alerion takes the front, at the base of her neck. That's where a Dragoon sits. You climb up behind him. `[herald: Alerion]` Frostina lowers her wing. You take the front, at the base of her neck, where a Dragoon sits.

`[version: thaw]` Razzilith lowers his neck. Meat Meat takes the front, where a Dragoon sits. You climb up behind her. `[herald: Meat Meat]` Razzilith lowers his neck. You take the front, where a Dragoon sits.

The other Heralds climb onto the other dragon, behind its Dragoon.

*(Prompt: "Take off after the black dragon?")*

- **From here on:** Alerion is Frostina's Dragoon (winter) and Meat Meat is Razzilith's (spring): bound, not just riders. Each feels a second heartbeat, their dragon's. A Dragoon rides their own dragon; everyone else rides behind their version's Dragoon. In the air battles a win shows the Dragoon's dive (dropping off the dragon onto the seam and being caught); in 9.04 a Herald who is the Dragoon can *listen for the second heartbeat* to throw off the cold hand. Sets `dragoons_bound` and `guardians_sworn`.

* **Flow:** sets `rides_frostina` or `rides_razzilith`. The other Heralds ride the other dragon.
* **Notes:** this is where the version choice finally matters: your mount for the whole chapter, the rider who's with you, and that dragon's partner lines.

### SC 9.03 — Through the Wall

- **Map:** new Sky Chase (Auroral Wall); then 2031 Good Mead, burning. **Trigger:** take off. **Present:** party on the dragons; the chardalyn dragon. **Music:** chase.

You fly into the Auroral Wall. For a moment the air is cold water. Then you're through, into the Rime. No sun. Snow in your face. Two years of night, exactly as you left it.

**ALBERICA** *(shouting over the wind)* It's the same winter! We've been gone a month! `[herald: Alberica, quiet]` "*(into the wind, quietly)* ...It's the same winter. Nothing's moved."

**REPTIN** *(shouting back)* Lovely to be home, isn't it? Never again!

Ahead, a black dragon with burning gold eyes dives on a town of beehives and honey-halls. Good Mead. Its breath is a line of light. Roofs go up like paper.

- **Battle (air 1):** Chardalyn Dragon, phase "Seams". Each hit on a chardalyn seam knocks off part of its health for the final fight.

`[air battle won]` Alerion lets go of Frostina's neck and drops, blade first. A falling star with a blade in it: a Dragoon's dive. Frostina swoops under and catches him a heartbeat later. A seam of black crystal cracks off the dragon and falls away into the snow, glittering. *(Thaw: Meat Meat drops from Razzilith, and he catches her.)* `[herald: the Dragoon]` (You let go of the neck and drop: a falling star with a blade in it.) (Gravity is a suggestion made by someone timid.)

`[air battle lost]` The dragon shrugs you off and pulls ahead. You'll have to catch it at the end.

You land in the burning square. Someone is pounding on the inside of the mead hall door.

The mead hall door is jammed in its frame, the wood swollen with heat.

**OLIVESSA** *(inside)* The bees! Get the bees out! Never mind me, get the bees!

*Your Pokémon with Strength or a Fighting move (otherwise Reptin, or you)* hits the door. Once. Twice. It bursts inward in a cloud of smoke and furious bees. Olivessa stumbles out with them, coughing, a hive in her arms.

**OLIVESSA** Whoever you are, you've got a hive's worth of thanks and a jar of mead coming. `[flag: good_mead_met]` "You! The honey-cake people! It's been a month, where were you?"

**ALBERICA** Mead. Darling, I could kiss you. Later. When less of the town is on fire.

**MEAT MEAT** Does Good Mead have coffee?

**OLIVESSA** ...We have mead.

**MEAT MEAT** Good Mead is dead to Meat Meat. ...After the dragon.

**WYN** *(cupping a dazed bee in both hands)* ...You're all right. You're all right, little one.

- **Flow:** open the door (Strength or a Fighting move). Olivessa and a cloud of furious bees come out together. Sets `good_mead_saved`; gives an Auroral Mote.

### SC 9.04 — Malevolent presence

- **Map:** Sky Chase, over Redwaters. **Trigger:** take off again. **Present:** your rider; the dragon. **Music:** chase.

`[version: frost]` Frostina lowers her wing. Snow slides off her like water. `[version: thaw]` Razzilith lowers his neck. Where a snowflake lands on him, a tiny leaf grows, and falls off.

*(Prompt: "Take off again?")*

Over Redwaters, the black dragon turns its head and looks at you. Something reaches into your Dragoon's mind like a cold hand.

`[version: frost]` **ALERION** *(flat, wrong)* ...Turn back. She's right. Let it burn. Stillness is easier. `[herald: Alerion]` (Your own voice, flat and wrong: ...Turn back. She's right. Let it burn.) (Stillness is easier.)

`[version: thaw]` **MEAT MEAT** *(flat, wrong)* ...Meat Meat should go home. To the cold table. Meat Meat belongs there. `[herald: Meat Meat]` (Your own voice, flat and wrong: ...Meat Meat should go home. To the cold table.) (Meat Meat belongs there.)

Frostina falters and banks away. *(Thaw: Razzilith.)*

*The cold hand is in your Dragoon's head.* `[herald: the Dragoon]` *The cold hand is in your head.*

▸ YOU:

- *Say their name.* You say their name once, the way you'd say it across a table. They blink, and come back. `[herald: the Dragoon]` *Say your own name:* you say your own name out loud, once, the way a friend would across a table. It sounds like yours again. Sets nothing.
- *Hum Shimmer's four notes.* You hum four notes you only half know. It's enough. The cold hand lets go. `[flag: requiem_done]` You hum four notes. Frostina hums them with you, wherever she is in the snow. The cold hand lets go at once. +1 Wheel. Sets `hummed_song`.
- *Grab the reins.* You grab the reins and steer straight back into the chase. Your Dragoon shakes it off in a minute. **ALERION** "...Thanks. Don't do that again." *(Thaw:* **MEAT MEAT** "...Thank you. Meat Meat will bite you later. Fondly."*)* `[herald: the Dragoon]` *Listen for the second heartbeat:* under the cold, your dragon's heart is still going: once in them, once in you. You hold on to that, and the cold hand lets go. Your dragon feels you come back, and climbs.
- **Battle (air 2):** Chardalyn Dragon, phase "Pursuit".

*(Air-battle win/loss lines as in 9.03.)*

The dragon breaks off and dives south-west, toward the biggest walls in the Dale.

**ALERION** Bryn Shander. Everyone's there.

**REPTIN** Of course they are. Nobody ever runs away from the dragon. Always towards the walls.

### SC 9.05 — The trap

- **Map:** 2012 Bryn Shander, re-dressed: refugees everywhere, the walls packed. **Trigger:** follow the dragon. **Present:** party; Duvessa; refugees from Easthaven, Good Mead, Caer-Konig; Anduin; a hooded goblin woman; the widow and her husband. **Music:** *Rime*, then final boss.

Bryn Shander's square is packed. Every town that saw the dragon has sent its people here. Behind walls that can't stop anything with wings.

**DUVESSA** *(on the wall)* You. You left with my seal a month ago. Where have you... Never mind. Never mind! Is that thing yours?

**ALERION** It's coming here. It always meant to come here.

**DUVESSA** *(understanding, horrified)* Everyone's here. That's the point, isn't it.

**WYN** *(very quietly)* ...There are so many children.

**ALBERICA** Then nobody's dying today, sweetheart. Stay close to me.

`[with: Reptin]` In the crowd, a tall elf in travelling clothes turns at Reptin's voice. He has an iron ring on his finger.

**ANDUIN** ...Reptin?

**REPTIN** *(not able to move)* ...Anduin.

The black dragon lands in the square, scattering the crowd. It roars. Frostina comes down beside you, wings spread over the crowd. *(Thaw: Razzilith.)*

`[seams hit: 1]` (One of its chardalyn seams is cracked where you hit it in the air. It's hurt already.) `[seams hit: 2]` (Its chardalyn seams are cracked all over where you hit them in the air. It's badly hurt.)

Frostina breathes first: a white line of frost across its flank. *(Thaw: Razzilith, a green rush of leaves and light.)* It staggers.

- **Battle:** the **Chardalyn Dragon** (Dragon/Steel; your design sheet). Its health is lowered by your seam hits in 9.03 and 9.04. Radiant breath, Malevolent Presence (it can charm one of your Pokémon for a turn). Your dragon fights beside you as a partner.

The dragon shatters into a thousand pieces of black crystal. One shard skitters to your feet. In it, a pale face, smiling.

**AVARICE** *(from the shard)* Pick me up.

Meat Meat stamps on it before anyone can move. `[herald: Meat Meat]` You stamp on it before anyone can move.

**MEAT MEAT** No.

- **Flow:** sets `dragon_down`.

### SC 9.06 — The green light on the horizon

- **Map:** 2012, after. **Trigger:** follows 9.05. **Present:** everyone. **Music:** *Heralds*, slow.

The square is quiet. Snow falls on the black glass.

`[with: Reptin]` Reptin and Anduin are holding each other. Anduin is shaking.

**ANDUIN** Five weeks. Five weeks I waited in Bryn Shander. And you come down out of the sky on a dragon. What happened to you? You look...

**REPTIN** *(trying for a smile)* Older? `[herald: Reptin, quiet]` "...I don't know."

**ANDUIN** *(touching his face)* No. Like something's growing in you. What have you become?

On the south-east horizon, where Dougan's Hole used to be, a green light glows through the snow. The crown of a tree, piercing the aurora.

**DUVESSA** What is that?

**ALBERICA** Home. Somebody's home. Warm, and with food. The Wall's thin enough to walk through now. `[herald: Alberica, quiet]` "...Home. It's warm there. You can walk through the Wall now."

**MEAT MEAT** And coffee. Alberica forgot coffee.

**ALBERICA** I never forget coffee, sweetheart. I just don't count it as food.

**DUVESSA** *(to the whole square)* Bryn Shander! Pack what you can carry!

`[flag: husband_thawed]` The Targos widow and her husband walk past, arm in arm. **WIDOW** "You! The Spheal people!"

At the back of the crowd, a hooded goblin woman can't stop looking at Meat Meat. When Meat Meat looks back, she pulls her hood lower. `[herald: Meat Meat]` ...can't stop looking at you. When you look back, she pulls her hood lower.

**ANDUIN** *(if you talk to him after)* Five weeks. I'm not letting go of his sleeve. You'd have to fight me for it. I'd win, too.

*(Prompt: "Lead the refugees south, to the green light?")*

- **Flow:** sets `refugees_follow`, `anduin_found`, `saw_hooded_woman`. The hooded woman is Phildendrin (revealed in SC 10.03).

### SC 9.06a — The walk south (banter)

- **Map:** 2012 Bryn Shander to 2050 market. **Trigger:** lead the refugees south. **Present:** party, refugees. **Music:** *Heralds*, slow.

A long line of people walks out of Bryn Shander behind you, toward the green light.

**ALBERICA** *(singing to a row of tired kids, terribly)* Oh, the dragon came down, and the dragon went BOOM...

**WYN** *(handing out mushroom biscuits)* ...Um. One each. They're good for you. Sorry.

**MEAT MEAT** Meat Meat is carrying the small one. The small one bites. Meat Meat respects her.

**ALERION** They're all following you, Alberica.

**ALBERICA** Everybody follows a good song, pretty boy. Even a bad one, if you're loud.

Three days. Nobody complains. Then the snow thins, the air goes soft, and the Wall is only a shimmer you walk through.

- **Flow:** no flags; leads straight into 9.07.

### SC 9.07 — Slayers of Summer

- **Map:** 2050 market, autumn. **Trigger:** walk back into Rootspire with the refugees. **Present:** party, refugees, Rootwardens, Kelyn, crowd. **Music:** *Rime*.

A long line of refugees walks out of the snow and into autumn. Rootspire's people stare at them. They stare back.

Rootwardens close in with spears lowered. Rheven leads them. He looks unhappy.

**RHEVEN** *(not meeting your eyes)* In the name of the Verdant Council. The Heralds of Dawn and Dusk. For the deaths of Summer Marshal Var Rime-Breaker... ...and Autumn Warden Darrus Fell.

**MEAT MEAT** Var was a coat! A coat!

**REPTIN** *(hands up, smiling)* Let's all be very reasonable. Especially the people with spears.

**ALERION** She's right. He was a coat.

**KELYN** *(arriving, white-faced)* I can't stop this. The city saw the summer die. Half of them think you saved them. Half think you killed it.

**SOMEONE IN THE CROWD** Murderers!

**SOMEONE ELSE** Liberators!

**KELYN** There will be a trial. The Trials of the Roots. ...I'm sorry.

*END OF CHAPTER 9*

- **Flow:** sets `heralds_arrested`. Chapter 10. The party is under watch but free to move inside the city.

## Chapter 10: Trials of the Roots

**Chapter goal:** answer for what the Heralds did, and help the city choose who leads it next. This is where your campaign stopped; from here the game carries it on.

**Structure:** a hub week. The five personal trials (10.02–10.06) can be done in any order, and each adds a witness. Gym 8 is the Trial of Winter. On the seventh day comes the Verdict, then the Vote. Rootspire is in autumn: leaves falling, refugees camped in the Blooming Fields, and Rheven's people building a wall where the Auroral Wall is thinning.

### SC 10.01 — The Tribunal opens

- **Map:** 2054 Council Hall of Seasons. **Trigger:** day 1. **Present:** party; Kelyn (Spring); Selrae (Winter); two white-draped chairs (Summer and Autumn); a packed gallery of Rootspire folk and refugees. **Music:** *Rime*, formal.

The four crystals pulse. Two of them, gold and red, are dim. Two chairs are draped in white.

**KELYN** The Heralds of Dawn and Dusk: charged with the deaths of the Summer Marshal and the Autumn Warden.

**KELYN** Meat Meat is charged separately. The Autumn Warden died by her hand.

**SELRAE** The Rootwarden Wyn: with abandoning the Underdark door the night it broke. And Alberica: with carrying the myconids' spores to the surface without leave.

**ALBERICA** *(under her breath)* I sneezed.

**REPTIN** *(under his breath)* Let me do the talking. Please. I'm begging you.

**MEAT MEAT** *(under her breath)* Meat Meat would also like to do the talking.

**REPTIN** *(under his breath)* Especially not you.

**KELYN** You have seven days to bring witnesses. Then the crystals hear the verdict. And on that same day, this city fills two empty chairs.

**A CHILD ON A CRATE** Murderers!

**HER MOTHER** *(a refugee, a hand over the child's mouth)* Hush. They brought us out of the snow.

*(The Heralds menu now keeps a list of your witnesses.)*

- **Flow:** sets `trials_open`. The Heralds menu gets a **Witnesses** page listing every witness you've earned, including the Chapter 7 personal quests.

### SC 10.02 — Roots of Love (Reptin)

- **Map:** 2050 the petrified-root fountain; then 2057 the Heartroot. **Trigger:** talk to Anduin. **Present:** Reptin, Anduin; Hyphora (vision). **Music:** *Hearth*, then *Thaw*.

**ANDUIN** *(turning his iron ring over and over)* They call you a god in the Rootwardens' hall. They leave you offerings. Reptin, you couldn't keep a houseplant alive.

**REPTIN** *(his best smile)* The houseplant had it coming. ...I'm still him, Anduin. `[herald: Reptin, quiet]` "...I'm still him."

**ANDUIN** Are you? This tree is a god. It's young, and it's frightened. And you stand next to it like a second sun. What happens to it when you outshine it?

▸ YOU:

- *"Show him."* Straight to the Heartroot.
- *"Tell him about the acorn."* **REPTIN** "I carried it. I planted it. I'm not here to outshine it. I'm here because I owe it." **ANDUIN** "...Show me." Then the Heartroot, as above.

You take them both down to the Heartroot. Reptin puts his hands on the root. The Heartroot's Test. `[herald: Reptin]` You put your hands on the root.

**Vision (Heartroot's Test):** Reptin, grey-furred and enormous, between a burning machine and a sapling. He's taking the heat.

`[flag: hyphora_sworn]` The vision holds. Anduin is crying. **ANDUIN** "You're protecting it. Not replacing it." There and then, they ask the Rootwardens to make them stewards of the Heartroot. Both of them. **ALBERICA** *(sniffing loudly)* "I'm not crying. It's spores. This whole city is spores." Sets `anduin_reconciled`.

`[not: hyphora_sworn]` The vision flickers. **ANDUIN** "I want to believe it." He'll testify. But he walks back to the refugee camp alone. **ALBERICA** *(quietly)* "Give him time, sweetheart. The good kind of love is slow." Sets `anduin_doubtful`.

*(Talking to Anduin afterwards.)* `[flag: anduin_reconciled]` **ANDUIN** "Stewards of the Heartroot. Him and me. I like the sound of it." `[flag: anduin_doubtful]` **ANDUIN** "I want to believe it. I'm trying. Give me time."

### SC 10.03 — Assassin's Reckoning (Meat Meat)

- **Map:** 2054 root-cells; then the Hearth. **Trigger:** visit Meat Meat in the cells. **Present:** Meat Meat; the hooded goblin woman; Mira (if freed); the rescued child's parents. **Music:** *Requiem*.

Meat Meat sits in a root-cell, holding Razzilith's nose through the bars. `[herald: Meat Meat]` You sit in a root-cell, holding Razzilith's nose through the bars.

**MEAT MEAT** Meat Meat could have caught his hand. Meat Meat didn't. Meat Meat would not catch it again. `[herald: Meat Meat, quiet]` "...Meat Meat would not catch it again."

**MEAT MEAT** That is the truth. The crystals can judge the truth.

`[herald: Meat Meat]` `[flag: mm_reached]` (The court has it written down: you reached for him. His hand slid out of yours.) `[flag: mm_turned]` (The court has it written down: you took the child. You didn't reach.) (They read it back to you twice.)

The hooded goblin woman from Bryn Shander is standing at the bars.

**HOODED WOMAN** *(her voice cracking)* They told me V-7 died. In the cold room. They told me my baby died.

She pulls her hood back.

**MEAT MEAT** *(very small)* ...Mama?

**PHILDENDRIN** *(both hands through the bars, on her daughter's face)* Phildendrin. My name is Phildendrin. I'm your mama. And I am not losing you to another cell.

**REPTIN** *(quietly, to the guard)* Give them a minute. Please. I'll owe you one.

- **Gather:** `[flag: child_saved]` the rescued child's parents push through to the bars: "She saved our girl." `[flag: mira_freed]` **MIRA** "Darrus shipped crates to the Forge every week for ten years. I'll say so to anyone." Always: **RHEVEN** "My wardens found the pens when the Forge fell. I'll say what we saw."
- **Atonement:** Phildendrin asks the court to let Meat Meat earn mercy: break Autumn's spying mirror, in the Heartroot's Sap Wells under the Root Gate, and free the faces trapped in it (a Mirror Wraith fight).

**PHILDENDRIN** Let her earn mercy. There's a mirror in the Heartroot's wells. Autumn's spying mirror. Darrus watched the whole city through it.

She looks at Razzilith, and then back at her daughter.

**PHILDENDRIN** Break it. Free the faces trapped inside. Then the court can't say she only knows how to hurt.

**MEAT MEAT** Meat Meat breaks things very well. Mama will see.

*In the Sap Wells:* a tall mirror in a frame of red-lacquered root. Faces press against the glass from the inside: dozens. People Darrus watched. People he kept.

**MEAT MEAT** No more deals with mirrors.

**WYN** *(barely a whisper)* ...They're so tired. Let them out.

*(Prompt: "Break Autumn's mirror?")* **Battle:** Mirror Wraith.

The wraith comes apart, and the mirror with it. The faces drift out of the shards like breath on a cold morning. They thin, and are gone. One of them, an old man, waves.

**PHILDENDRIN** *(later, to the Tribunal)* My daughter was made to be a weapon. She chose to save a child instead. If you want to judge her, judge the people who made her.

**PHILDENDRIN** *(if you talk to her after)* The faces in that mirror were people. You let them go. Now let the court do the same for her.

- **Flow:** sets `phildendrin_found`, `mm_atoned`. Phildendrin becomes a candidate.
- **Notes:** in Meat Meat Herald Mode, the court quotes `mm_reached` or `mm_turned` back to you.

### SC 10.04 — Absent Watcher (Wyn)

- **Map:** new Underdark Door (old guard tunnels under the Root-Tier). **Trigger:** talk to Captain Kethan Vale. **Present:** Wyn, Kethan, a junior Rootwarden. **Music:** *Hunt*.

Captain Kethan Vale, grey at the temples, waits at the mouth of the old guard tunnels.

**KETHAN** You left your post, Rootwarden. Cultists came through. Explain, or don't. I'll judge your silence too.

**WYN** *(very small)* ...Yes, Captain.

**MEAT MEAT** *(to Kethan, cheerfully)* Meat Meat will bite you if you shout at mushroom friend.

**KETHAN** ...Noted. The door's this way. Come and look at what you left.

*(Prompt: "Go down to the Underdark Door?")*

**WYN** *(at the broken door)* Hyphora called me. That night. The spores sang my name, and I went. `[herald: Wyn, quiet]` "*(at the broken door)* ...She called me. And I went."

**WYN** I thought I was dreaming.

Behind the broken door, cut into the rock: a ritual circle of frost. Auril's snowflake, under a crown.

**ALBERICA** *(touching the rune on her own chest)* Same mark. Halo work.

**WYN** They broke the seal themselves. If I'd stayed, I'd be in that circle.

**MEAT MEAT** Then mushroom friend was right to go. Meat Meat says so. Meat Meat is a witness now.

At the Tribunal, later, the crystals are asked for Hyphora's account. The green crystal flickers, and a whisper fills the hall:

**HYPHORA** *Shadow answered my call.*

**KETHAN** *(if you talk to him after)* Go on, Rootwarden. Your post's still yours. If you want it.

- **Flow:** sets `wyn_cleared`. `[flag: godspark_shadow]` Kethan: "And you came back with a god's spark. Rootwardens have been promoted for less."

### SC 10.05 — Brother from Beyond (Alerion)

- **Map:** new Glasswater Lake shore. **Trigger:** night, after any other trial. **Present:** Alerion; Talion. **Music:** *Requiem*.

A boy stands at the lake's still edge. No breath. Skin as cold as the water.

**TALION** *(reciting, like a memory)* You told me to stay in the house. You said you'd come back. You came back.

**ALERION** *(not moving)* Talion.

**TALION** You touched the water when you tried to bring us all back. The lake kept a little of me. I've been waiting.

**ALERION** I can take you with me. I know how. I can keep you. `[herald: Alerion, quiet]` "...I can keep you."

**WYN** *(very gently)* ...Alerion.

A Mirror Wraith rises out of the lake behind the boy. It whispers: *"Echoes fade when embraced. Reflections devour when chased."*

▸ YOU:

- *"Let him go, Alerion."* Alerion kneels and holds his brother (`[herald: Alerion]` you kneel). Talion smiles, and fades like breath on glass. On his way out, through the lake's mirror, Talion gives the court his testimony: "The tall gold man had no reflection. None. For years." **WYN** *(sitting down beside him)* "...You don't have to talk." `[with: Wyn]` **ALERION** "I know. That's why I can." **ALERION** "...He was nine. He'd have liked all of you. Even the loud ones." Sets `talion_released`, +1 Wheel.
- *"Keep him."* Alerion reaches for the necromancy (`[herald: Alerion]` you reach). Talion's face goes hungry and grey. The Mirror Wraith comes up out of the water (boss). Afterwards, Talion is gone anyway. Alerion says nothing for an hour. The testimony still comes, from the wraith, through the lake's mirror: "The tall gold man had no reflection. None. For years." Sets `talion_chased`.

### SC 10.06 — Spores of Contention (Alberica)

- **Map:** 2068 Undercanopy. **Trigger:** talk to the Winter and Spring representatives. **Present:** Alberica; Selrae; Kelyn; Luminara. **Music:** *Thaw*.

**SELRAE** Spores in the refugee camp. Children sneezing glowing dust. The Council never sanctioned a fungal colony under the city.

**ALBERICA** It's been here three hundred years, darling. Come and meet it. Bring a hanky. `[herald: Alberica, quiet]` "...It's been here three hundred years. Come and meet it."

*(Prompt: "Take Kelyn and Selrae through the Undercanopy to the Fane?")*

- **Escort:** take both councillors through the Undercanopy (wild battles, a cave-in).

The councillors follow you down through the glowing beds. Selrae keeps her hands in her sleeves. Kelyn keeps stopping to look.

**WYN** *(shyly, to Kelyn)* ...That one's a lantern-cap. It likes being looked at.

*(Wild battle: Parasect.)* Halfway across the gardens, the ceiling groans. It comes down in a slide of rock and roots. You get everyone through. Kelyn's cloak doesn't make it.

**ALBERICA** Lose the cloak, Councillor. You look ten years younger.

*(Wild battle: Breloom.)*

**LUMINARA** *(to the councillors)* Surface. Sap-takers. ...We forgive you. We have something to show.

She lifts a glowing memory bubble. In it: Var Rime-Breaker, alone in the roots, peeling his own face back like a mask.

**KELYN** *(sitting down on the floor of the Fane)* ...Oh.

(Alberica is named the Council's Fungal Liaison.) (Luminara's memory bubble will be the strongest evidence at the Verdict.)

**ALBERICA** Fungal Liaison. At last, a title that matches my reputation.

**REPTIN** Please don't put that on a business card.

**KELYN** *(if you talk to her after, still a little shaky)* Three hundred years. Under our feet. And they forgave us.

- **Flow:** sets `colony_recognised`, `memory_bubble`, `fungal_liaison`. Alberica is named Fungal Liaison. The memory bubble is the strongest piece of evidence at the Verdict.

### SC 10.07 — Gym 8: The Trial of Winter

- **Map:** 2056 Still Sky Shrine, cleansed. **Trigger:** day 6. **Present:** Selrae. **Music:** gym theme, cold.

**SELRAE** Winter judges the old way. Not by what you say. By whether you can stand in the cold and not let go of each other.

**SELRAE** I wanted a little winter for this city. Let me show you what a little winter is.

- **Battle:** Selrae (Ice).

**SELRAE** Winter's Seal.

*(You receive Winter's Seal, and TM13.)*

**SELRAE** Ice Beam. Cold, and straight, and honest. And my word at the verdict. For whatever an old Halo-sheltering fool's word is worth.

She looks north for a moment, past all of you.

**SELRAE** Auril is still out there, you know. On her island. She'll have felt the summer end. She'll come for what she thinks is hers.

**ALERION** She can try.

**ALBERICA** *(a hand over her rune)* ...Let's not dare her, pretty boy.

- **Flow:** Winter's Seal (`badge_selrae`; eight badges). Sets `selrae_witness`.

### SC 10.08 — The Verdict

- **Map:** 2054. **Trigger:** day 7. **Present:** everyone. **Music:** *Rime*, then *Heralds*.

**KELYN** Witnesses so far: *(the count)*. The crystals hear them on the seventh day. `[not: badge_selrae]` "Selrae means to put you through the Trial of Winter first. At the Still Sky Shrine. She's waiting."

*(Prompt: "Call for the verdict? (The trial week ends.)")*

The seventh day. The Council Hall is full: Rootspire, the refugees, Rootwardens on the walls. The crystals hear every witness: *(each witness you've earned, by name)*.

**KELYN** *(reading)* The death of the Summer Marshal. The Summer Marshal died thirty years ago, and this court grieves him now. Not guilty.

**KELYN** The death of the Autumn Warden...

- **3 or more witnesses:** **KELYN** "...was the death of a man feeding children to a fire. Not guilty." The gallery erupts. **MEAT MEAT** *(very quietly)* "...Mama. Mama, did you hear?" **ALBERICA** *(already crying, already hugging a stranger)* "Drinks! Drinks on me!" Sets `verdict_acquitted`.
- **1–2 witnesses:** **KELYN** "...is a matter this court cannot excuse. Meat Meat will serve the refugee camp for a season." **MEAT MEAT** "Meat Meat will serve. Meat Meat will bring coffee. The camp will be terrified." Sets `verdict_service`.
- **0 witnesses:** **KELYN** "...guilty. A geas: you may not leave Rootspire without the Council's leave." **REPTIN** *(under his breath)* "Well. It could have gone better. It could also have gone with spears." It lifts automatically when the Council sends you north in Ch11. Sets `verdict_geas`.

### SC 10.09 — The Vote

- **Map:** 2060 Blooming Fields, debate stage; then 2054. **Trigger:** after the Verdict. **Present:** the five candidates; the city. **Music:** *Hearth*.

Out in the Blooming Fields, five candidates stand on a stage of braided roots. Flowers and snow grow side by side at their feet. Each gives their name and platform (Phildendrin only if `phildendrin_found`):

| Candidate | Platform | If elected, in Act III |
| --- | --- | --- |
| Rheven Stormbranch | Strength and security | Rootwardens and the Skytower griffons fly you to Solstice; the Wall is guarded while you're gone |
| Mira of the North Wind | Free water | The *Boreal Requiem* sails you to Solstice; the Corsairs fight at the ice dock |
| Eirwen Solglass | The truth, published | The Library's copy of Grimskalle's plans: a shortcut past the Hall of the Four Winds |
| Phildendrin | Justice and reform | The refugees' militia under Duvessa holds Rootspire; a full heal before the final battle |
| Anduin | Faith and humility | The Wennen ring Angajuk's bell: the whale carries you; Hyphora's blessing on the final battle |

▸ YOU: endorse two. The number of witnesses decides how many of your two win: 4+ both, 2–3 one (the first you named), 0–1 none (the city picks Rheven and Eirwen).

The city votes. *(The two winners)* take the empty chairs.

**KELYN** *(at the end)* Four chairs. Four seasons. For the first time in my life, all of them filled.

The crystals blaze: green, gold, red, white.

**ALBERICA** To full chairs! Somebody find me a drink.

**MEAT MEAT** Somebody find Meat Meat a coffee.

**WYN** ...I made both. They're by the door. Sorry.

`[flag: long_voyage]` **LUMIN** *(later)* "Nobody's got a ship, or a griffon, or a whale-bell. Then I'll ring Angajuk's bell myself. It'll be a longer voyage."

*END OF ACT II*

- **Flow:** sets `council_<name>` for each winner and `ch10_done`. If neither Mira nor Rheven nor Anduin wins, Lumin rings Angajuk's bell anyway (sets `long_voyage`); the voyage is longer and has two extra battles. End of Act II.
