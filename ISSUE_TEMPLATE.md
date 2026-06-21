## Bug Report: [Short summary of the issue here]

### 1. Game Environment & Party Setup
To help narrow down compatibility or logic issues, please list your current setup:
* **Active Followers:** (e.g., Xelzaz, Inigo, Serana, vanilla follower)
* **Summons / Commanded Actors:** (e.g., Flame Atronach, Dead Thrall, reanimated NPC)
* **Other Follower Frameworks / Outfit Managers:** (Are you using AFT, EFF, NFF, or external outfit mods? Yes/No)

### 2. Lesser Power & Weapon State
Which specific tool were you using, and what was your character's state?
* **Lesser Power used:** 
  - [ ] **Lesser Power "Bond of Friendship"** (Actor Manager assignment, Automatic Calm, Edit Stats, Teammate)
  - [ ] **"Bond of Friendship - Debug Utility"** (Disable/Enable, Get Up!, Reset AI, Recycle, Move To Me, etc.)
  - [ ] **"Bond of Friendship - Requests"** (Talk, Wait/Follow, Favor, Inventory, Meeting Point)
* **Weapon State during casting:**
  - [ ] **Weapon Drawn** (Targeting a specific actor)
  - [ ] **Weapon Sheathed** (Applying to all assigned actors / navigating via slot buttons)

### 3. Affected Feature
Which specific component of the mod did not work as expected? (Check all that apply)
* [ ] **Automatic Calm:** (Hostility from friendly fire was not stopped / failed to calm the right actors)
* [ ] **Automatic Teleport:** (Followers or commanded actors failed to teleport when falling behind or changing cells)
* [ ] **Scan Followers:** (The automated group scanning via Papyrus Extender missed some actors or summons)
* [ ] **Follower's Summon Detection (Passive Script):** (The background script failed to automatically detect a follower's summon, or failed to add the "Automatic Calm" feature to that summon)
* [ ] **Edit Stats Menu:** (Values for health, stamina, magicka, skills, or resistances did not apply)
* [ ] **Knockout Prevention:** (The protective ability failed to trigger or did not reset health/limbs when below 40% health)
* [ ] **Auto Equip:** (Items placed in inventory via Requests -> Inventory failed to equip automatically, or conflicted with external outfit managers)
* [ ] **Teammate Feature:** (Follower failed to sneak or draw weapon in sync with the player)
* [ ] **Quick Menu Feature:** (Dialogue suppression failed, or the quick access menu did not open correctly)
* [ ] **Debug Utility Actions:** (Actions like 'Get Up!', 'Reset AI', 'Move To Me', or slot-navigation failed)
* [ ] **Requests / Wait & Follow:** (Commands to wait or follow failed to execute or apply to the group)
* [ ] **Requests / Inventory:** (Opening the inventory via casting with weapon drawn (targeting a specific actor) or managing items failed)
* [ ] **Requests / Meeting Point:** (Setting/removing a meeting point, teleporting to it, or the Dragonsreach emergency teleport bugged out)

### 4. Observed Behavior (What happened?)
Please describe the exact issue in detail:
* **The Problem:** [Describe what went wrong]
* **Visual Indicators / Notifications:** (Did the green calming shader trigger? Did you see any specific Debug.Notifications on the screen?)

### 5. Situation & Steps to Reproduce
* **Location / Situation:** (e.g., during intense dungeon combat, right after fast traveling, when using the Wait/Follow commands)
* **Steps to repeat the bug:**
  1. [First step]
  2. [Second step]
  3. [Expected result vs. actual result]

