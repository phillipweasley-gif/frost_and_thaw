# 0.9.0 (2026-11-12): goals, difficulty, and the two rare bugs

The owner chose three things for the hours before 4 pm: a quest log, a difficulty-curve audit, and chasing the
two rare bugs from the test runs.

## 1. The quest log was already there; it's now kept current

I planned to build a quest log, then found the game already has one. The pause menu's "Goal" entry shows where
the story goes next, plus open side quests. A journey playthrough changes it about 100 times. So instead I
audited the traces of all eight routes for stretches where the Goal stayed the same for too long. Three
stretches went 40+ story steps without a change, which is where a returning player gets lost:

| Stretch | Before | Now (`055_GoalSteps.rb`) |
|---|---|---|
| The hag's old lair to the Root-Throne (Ch8) | One Goal across 9 maps | Five steps: the Deep Root Shaft, the Scratching Hollow, the Cocoon Pens, the Root-Throne and the root-keep gate, then down into the Dragonforge |
| The Heartroot's lower zones (Ch7B) | One Goal across 5 maps | Four steps: the Hollow Core, the Frozen Drop, the Vault of Amber Dreams, the Mirror-Root Vault and the Scriptory |
| Avarice's sanctum to the Heart Chamber (Ch8) | One Goal across 4 maps | Two steps: the sanctum, then the Auroral Antechapel |

Rules for the steps:
- A step only replaces its own stretch's Goal or an earlier step, and only ever moves forwards.
- A goal set later by the story is never overwritten.
- A smoke check covers all three rules.

Also, after the credits the Goal menu points you to the Cup of Seasons until you win it.

Left as they are: the trial week and festival Goals. They stay the same for many steps by design, because
those are days you spend however you like.

## 2. Difficulty curve

I tabled every boss and story trainer's levels in story order and compared them with where the runner's team
lost, over 16 full test routes. The curve is smooth except at one point:
- **The fall into Rootspire.** Act 1 ends with Thredra at Lv 31–32 and wild Pokémon at 27–30. The first
  Rootspire fights were the Hearth regulars at 38–39, Tamsin at 37–40 and Hellen at 37–40. That made Hellen the
  most-lost fight in the game, with 15 losses across 16 runs.

| Fight | Was | Now |
|---|---|---|
| The Hearth's four regulars | 38–39 | 36–37 |
| Hellen (Gym 4) | 37/38/38/40 | 35/36/36/38 |
| Tamsin (all three starters) | 37/38/40 | 35/36/38 |
| Eline (Ch6) | 38–40 | 37–39 |
| Thredra at the Heart (joint most-lost, 15) | 31/32/32 | 30/31/32 |

Looked at and left alone:
- **Durmoot.** His levels sit in line with the trainers around him.
- **Sephek.** A story boss that's meant to be hard.
- **The Root-Throne duergar.** See below.

## 3. The two rare bugs

Neither one can strand a real player.
- **The root-keep gate (map 2072 → 2150).** The runner kept losing in the Root-Throne's run of duergar and
  waking at the Barricade. The levels there are in line (48–49). But the game already has a fix for this: a
  digger's camp on the Root-Throne level heals you and moves your respawn there. The runner just never talks
  to him. The new step goal for that stretch now names the Root-Throne before you reach it.
- **The walks on maps 2143/2144 (and "Captain's root-desk").** These are runner faults. Its path stepped on a
  door tile on the way, and it looked for the root-desk on map 2053 when that event is on map 2057. Both
  targets are reachable, and every rerun reaches them.

## Checks

- Smoke test: 249/249, with one new check for the step goals.
- check_all: 159 maps pass.
