<p align="center">  
    <picture>
    <img src="Screenshots/Bond of Friendship - Banner.png" alt="Bond of Friendship Logo" width="400">
    </picture>
</p>    
This mod for Skyrim Special Edition introduces three lesser powers to make traveling with followers more comfortable. They are added to you automatically. Each lesser power opens a menu upon casting.

### Lesser Power 1: Bond of Friendship (the Actor Manager)
Used for managing features and actors (i.e. followers and all types of summons including reanimated minions).

- **Automatic Calm:** A passive ability that automatically stops any hostility due to friendly fire towards other actors who possess this ability, as well as the player. All of your follower's summons automatically receive the ability (*requires Papyrus Extender*). To prevent your own summons from becoming hostile when you accidentally attack them yourself, you will need to enable the 'Ignore Friendly Hits' setting as well.
- **Friendly Hits:** This option toggles whether the actor ignores friendly fire or reacts to it.
- **Knockout Prevention:** Grants a passive ability that automatically triggers when the actor's health drops below 40% to protect them from being knocked out.
- **Edit Stats:** Customize the actor's attributes, including health, stamina, magicka, combat/magic/stealth skills, and resistances. (Only available in the single-actor version of this power. *Requires UIExtensions*.)
- **Mortality:** Change whether the actor is essential (immortal) or can be killed in combat.
- **Quick Menu:** Replaces the actor's default activation with the "Bond of Friendship - Requests" menu. While active, normal dialogue options are suppressed, but you can still access them via the custom "Talk" command. 
- **Teammate:** Toggles the actor's teammate status, ensuring they draw their weapon and sneak in sync with the player.
- **Auto Equip:** Forces the actor to automatically equip items (weapons, armor, etc.) placed into their inventory via the "Bond of Friendship - Requests -> Inventory" menu. Should be disabled if you use external outfit managers.
- **Auto Teleport:** Automatically teleports the actor to your position if they have fallen too far behind.
- **Scan Followers:** Scans and assigns your entire follower group to the Actor Manager, eliminating the need to target each one manually. A massive time-saver for large parties. (*Requires Papyrus Extender*.)
- **Actor List:** Opens a menu displaying all currently managed actors.

#### Context-Sensitive Casting Mechanics
How the power behaves depends entirely on your weapon state when cast:

- **Weapon Drawn (Pointing at a target):** Assigns the targeted NPC to the *Bond of Friendship* Actor Manager and immediately opens the single-actor menu to customize their features. If your followers or summons become hostile due to friendly fire, you can manually calm them using the lesser power *(Requires Papyrus Extender)*.
- **Weapon Sheathed:** Opens the multiple-actor version of the menu to manage features and options for all assigned actors at once.

#### Special Note Regarding Dead Thralls
To ensure they keep their assigned gear while traveling, I recommend enabling the "Auto Equip" and "Auto Teleport" features. Alternatively, you can give them the "Teammate" feature.

When commanded to wait, Dead Thralls will freeze in place. This is intentional; their AI is temporarily disabled to prevent them from following you. Simply command them to follow again to unfreeze them.

### Lesser Power 2: Bond of Friendship - Debug Utility

A powerful troubleshooting tool designed to fix common Skyrim follower bugs, such as broken AI, stuck animations, or lost NPCs. 

#### Available Debug Actions
- **Disable/Enable:** Safely toggles the actor's existence to fix invisibility or visual glitches.
- **Get Up!:** Instantly forces the actor out of the stuck crawling/bleeding-out animation on the ground.
- **Reset AI:** Restarts the actor's artificial intelligence package if they stop responding. *(Requires ConsoleUtilSSE)*
- **Recycle Actor:** Completely resets the actor to their default spawning state. *(Requires ConsoleUtilSSE)*
- **Reset Inventory:** Restores the actor's default outfit and starting items. *(Requires SKSE)*
- **Move To Me:** Teleports the selected actor directly to your current position.

#### Context-Sensitive Casting Mechanics
The scope of the Debug Utility depends on your weapon state when cast:

- **Weapon Drawn:** Directly targets the NPC you are pointing at (the actor does not need to be assigned to the Actor Manager).
- **Weapon Sheathed:** Opens a slot-based navigation menu (`First Slot`, `Next Slot`, `Previous Slot`, `Last Slot`) allowing you to select any assigned actor from a distance. Once selected, choose `> Actions` to execute any of the debug options above. This is highly useful for locating lost companions via *Move To Me* or fixing vanished NPCs via *Disable/Enable*.


### Lesser Power 3: Bond of Friendship - Requests
Provides a quick-access menu to issue core commands directly to your followers, avoiding tedious dialogue menus.

#### Context-Sensitive Casting Mechanics
The available requests and their scope depend entirely on your weapon state when cast:

- **Weapon Drawn (Targeted Actor):** Opens the single-target requests menu with the following options:
  - **Talk:** Initiates normal dialogue with the NPC (essential if the *Quick Menu* feature is active).
  - **Wait / Follow:** Toggles whether the individual actor stays at their current postion or resumes following you.
  - **Favor:** Commands the actor to perform a specific action in the environment (e.g., lockpicking, stealing, or sitting).
  - **Inventory:** Opens the actor's inventory container directly to trade gear.

- **Weapon Sheathed (All Assigned Followers):** Opens the global team menu to issue commands to your entire party simultaneously:
  - **Wait / Follow:** Orders all managed followers to wait or follow at once.
  - **Meeting Point:** Allows you to set or remove a custom meeting point anywhere in Skyrim. You can teleport yourself and/or your followers directly to this point. Includes an emergency teleport to Dragonsreach for both the player and followers.

#### Available Commands for Commanded Actors
- Follow, Wait, Inventory
  <br>
  <br> 

## Media
*(Windows/Linux: Ctrl + Click to open image in a new tab | macOS: Cmd + Click)*

<p align="center">Followers
<br>
<br>    
  <a href="Screenshots/Followers.jpg">
    <img src="Screenshots/Followers.jpg" alt="Your Followers" width="600">
  </a>
</p>

<details>
  <summary>📸 View Menu Screenshots (Click to expand)</summary> 
    <br>
<p align="center">Actor Manager
    <br>
    <br>
    <a href="Screenshots/Actor Manager - Page 1.jpg"><img src="Screenshots/Actor Manager - Page 1.jpg" alt="Actor Manager - Page 1" width="300"></a>
    <a href="Screenshots/Actor Manager - Page 2.jpg"><img src="Screenshots/Actor Manager - Page 2.jpg" alt="Actor Manager - Page 2" width="300"></a>
  </p> 
<p align="center">Edit Stats and Actor List
<br>
<br>    
  <a href="Screenshots/Edit Stats.jpg"><img src="Screenshots/Edit Stats.jpg" alt="Edit Stats" width="300"></a>
  <a href="Screenshots/Actor List.jpg"><img src="Screenshots/Actor List.jpg" alt="Actor List" width="300"></a>
</p>
<p align="center">Debug Utility and Debug Actions
    <br>
    <br>
    <a href="Screenshots/Debug Utility.jpg"><img src="Screenshots/Debug Utility.jpg" alt="Debug Utility" width="300"></a>
    <a href="Screenshots/Debug Actions.jpg"><img src="Screenshots/Debug Actions.jpg" alt="Debug Actions" width="300"></a>
  </p>
<p align="center">Requests - Single and Multiple Actor Version
    <br>
    <br>
    <a href="Screenshots/Requests - Single Actor Version.jpg"><img src="Screenshots/Requests - Single Actor Version.jpg" alt="Requests - Single Actor Version" width="300"></a>
    <a href="Screenshots/Requests - Multiple Actor Version.jpg"><img src="Screenshots/Requests - Multiple Actor Version.jpg" alt="Requests - Multiple Actor Version" width="300"></a>
  </p>
  <p align="center">Requests - Meeting Point
    <br>
    <br>    
    <a href="Screenshots/Requests - Meeting Point.jpg"><img src="Screenshots/Requests - Meeting Point.jpg" alt="Requests - Meeting Point" width="300"></a>
  </p>  
</details>  
<br>

## Requirements

To unlock all features, please install these mods. Make sure to check their pages for any additional dependencies they might need.

- <a href="https://www.nexusmods.com/skyrimspecialedition/mods/30379">**Skyrim Script Extender (SKSE64)**</a>
- <a href="https://www.nexusmods.com/skyrimspecialedition/mods/22854">**powerofthree's Papyrus Extender**</a>
- <a href="https://www.nexusmods.com/skyrimspecialedition/mods/76649">**ConsoleUtilSSE NG**</a> (Highly recommended, as it works on all Skyrim versions. Alternatively, you can use the original <a href="https://www.nexusmods.com/skyrimspecialedition/mods/24858">*ConsoleUtilSSE*</a> if you are on version 1.6.640 or older).
- <a href="https://www.nexusmods.com/skyrimspecialedition/mods/17561">**UIExtensions**</a> (together with <a href="https://www.nexusmods.com/skyrimspecialedition/mods/127375">*UIExtensions Fixed ESP Plugin*</a>)
    <br>
    <br>

## How to install

### Option 1: Via Mod Manager (Highly Recommended)

I highly recommend using a mod manager to keep your game clean and avoid installation errors.

1. Go to the **Releases** section on the right side of this GitHub page.
2. Download the mod archive (e.g., `.zip` or `.7z`) under the latest release.
3. Add the archive to your preferred mod manager:
   * **Vortex:** Go to the "Mods" tab and drag and drop the downloaded ZIP file into the "Drop File(s) here" area at the bottom, or use the "Install From File" button in the top menu.
   * **Wrye Bash:** Drag and drop the downloaded archive directly into the **Installers** tab of the Wrye Bash window, or manually move it into your **`Bash Installers`** directory.
4. Install and enable the mod.

*Note: Vortex is very beginner-friendly, while Wrye Bash is great for advanced users. Both tools are available on Nexusmods.com.*


### Option 2: Manual Installation (For Advanced Users)
1. Download the mod archive manually and extract it.
2. Copy the `Scripts` and `Source` folders, along with the `Bond of Friendship.esp`, directly into your Skyrim `Data` folder.
3. Activate the `.esp` file. 

*Note: You can activate the `.esp` directly in the game's main menu (Start Game ➔ Mods ➔ Load Order ➔ Check the box next to "Bond of Friendship.esp").*
 <br>
 <br>
## Feedback & Bug Reports
Bug reports and constructive feedback are always welcome! 

If you encounter any issues during your playthrough or have suggestions, you can report them under the following link:
👉 **[https://github.com/Selene310187/Bond-of-Friendship/issues](https://github.com/Selene310187/Bond-of-Friendship/issues)**

When creating an issue, **please select and use the provided template** (either for a Bug Report or a Feature Request) and fill out the details so I can look into it quickly.
 <br>
 <br>
##  Script Sources 
The source code for all scripts is located inside the `Source` folder of this repository and inside the downloaded archive. If you are curious, want to see how the mod works, or plan to study the script logic, feel free to take a look inside!
