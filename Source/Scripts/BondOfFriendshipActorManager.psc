Scriptname BondOfFriendshipActorManager extends Quest Conditional 

; == variables
Int Property ActorSlots Auto Conditional
int Property NewActors Auto Conditional
int Property FeatureCounter Auto Conditional
Float Property ShaderDuration Auto
GlobalVariable Property BOFmessage Auto
GlobalVariable Property BOFallies Auto
GlobalVariable Property BOFoutfit Auto
GlobalVariable Property BOFshader Auto
; == arrays
ReferenceAlias[] Property ActorSlotsAlias Auto
BondOfFriendshipAlias[] Property ActorAliasScripts Auto
; == ReferenceAlias
ReferenceAlias Property AliasActorTemp Auto
; == actors
Actor Property PlayerRef Auto
; == faction
Faction Property BondOfFriendshipAssigned Auto
Faction Property BondOfFriendshipAllies Auto
Faction Property BondOfFriendshipQuickM Auto
Faction Property BondOfFriendshipAutoEquip Auto
Faction Property BondOfFriendshipTeammate Auto
Faction Property CurrentFollowerFaction Auto
; == spell
Spell Property BondOfFriendshipAbility Auto
Spell Property BondOfFriendshipAutomaticTeleportSpell Auto
Spell Property BondOfFriendshipKnockoutPreventionAbility Auto
Spell Property BondOfFriendshipEthereal Auto
Spell Property BondOfFriendshipAimed Auto
Spell Property BondOfFriendshipDebugUtilityAimed Auto
Spell Property BondOfFriendshipRequestsAimed Auto
; == shader
EffectShader Property IllusionPositiveFXS Auto
; == scripts
BondOfFriendshipVariables Property Variables Auto
BondOfFriendshipDebugUtilityQscript Property DebugUtility Auto
BondOfFriendshipRequestsQScript Property Requests Auto
BondOfFriendshipMaintenance Property Maintenance Auto
; == messages - menu
Message Property BondOfFriendshipMenuAssign Auto
Message Property BondOfFriendshipAOEAssign Auto
Message Property BondOfFriendshipMenuMain Auto
Message Property BondOfFriendshipMenuMainP2 Auto
; = features - page 1:
Message Property BondOfFriendshipMenuAutomaticCalm Auto
Message Property BondOfFriendshipMenuFriendlyHits Auto
Message Property BondOfFriendshipMenuKnockoutPrevention Auto
Message Property BondOfFriendshipMenuStatsMain Auto
Message Property BondOfFriendshipMenuStatsSkillsCombat Auto
Message Property BondOfFriendshipMenuStatsSkillsMagic Auto
Message Property BondOfFriendshipMenuStatsSkillsStealth Auto
Message Property BondOfFriendshipMenuStatsResistances Auto
Message Property BondOfFriendshipMenuMakeImmortal Auto
Message Property BondOfFriendshipMenuClearSlots Auto
Message Property BondOfFriendshipMenuSettings Auto
; = features - page 2:
Message Property BondOfFriendshipMenuQuickM Auto
Message Property BondOfFriendshipMenuTeammate Auto
Message Property BondOfFriendshipMenuAutoEquip Auto
Message Property BondOfFriendshipMenuAutoTeleport Auto
Message Property BondOfFriendshipMenuScanFollowers Auto
; == messages - notification
Message Property BondOfFriendshipMaxSlotsReached Auto
Message Property BondOfFriendshipHostileActor Auto
Message Property BondOfFriendshipAOEAssignHowTo Auto
Message Property BondOfFriendshipAOEAssignCooldown Auto
Message Property BondOfFriendshipFeatureAlreadyActivated Auto
Message Property BondOfFriendshipFeatureCommandedActors Auto
Message Property BondOfFriendshipSlotCleared Auto
Message Property BondOfFriendshipSlotsCleared Auto


; === Is actor following player (used for teleporting mechanics)

bool Function IsPlayerFollower(actor akActor)
    if akActor.IsInFaction(BondOfFriendshipAssigned) == False
        return False
    endif

    Actor[] followers = po3_SKSEFunctions.GetPlayerFollowers()
    int i = 0
    bool bBreak = False
    
    if followers != None
        While (i < followers.Length) && !bBreak
            If (followers[i] != None && followers[i] == akActor)
                if followers[i].IsInFaction(BondOfFriendshipAssigned) == True 
                    bBreak = true
                    Return True 
                endif
            EndIf
            i += 1
        EndWhile
        Return False 
    endif    
EndFunction

bool Function IsPlayerSummon(actor akActor)
    if akActor.IsInFaction(BondOfFriendshipAssigned) == False
        return False
    endif

    Actor[] thralls = po3_SKSEFunctions.GetCommandedActors(PlayerRef)
    int i = 0
    bool bBreak = False
    
    if thralls != None
        While (i < thralls.Length) && !bBreak
            If (thralls[i] != None && thralls[i] == akActor)
                if thralls[i].IsInFaction(BondOfFriendshipAssigned) == True 
                    bBreak = true
                    Return True 
                endif
            EndIf
            i += 1
        EndWhile
        Return False 
    endif    
EndFunction

; === Target Actors

Function TargetActor(Int iLoopIterations = 20, Float fAreaToSearch = 1500.0)
    if Maintenance.SKSEActive == 0
        if Variables.CurrentLesserPower == 1
            BondOfFriendshipAimed.Cast(PlayerRef)
        elseif Variables.CurrentLesserPower == 2
            BondOfFriendshipDebugUtilityAimed.Cast(PlayerRef)
        elseif Variables.CurrentLesserPower == 3    
            BondOfFriendshipRequestsAimed.Cast(PlayerRef)
        endif
    else    
        Actor ActorTarget = Game.GetCurrentCrosshairRef() as Actor
        
        ; Fallback: If the crosshair fails, we roll for NPCs within range
        
        if ActorTarget == None
            bool bBreak = False
            While iLoopIterations > 0 && !bBreak
                Actor Candidate = Game.FindRandomActorFromRef(PlayerRef, fAreaToSearch)
                iLoopIterations -= 1
                
                if Candidate && Candidate != PlayerRef
                    ; Does the player have a line of sight and is he looking roughly in that direction?
                    if PlayerRef.HasLOS(Candidate) && PlayerRef.GetHeadingAngle(Candidate) > -35.0 && PlayerRef.GetHeadingAngle(Candidate) < 35.0
                        ActorTarget = Candidate
                        bBreak = True ; break loop
                    endif
                endif
            EndWhile
        endif
        
        
        if ActorTarget && ActorTarget != PlayerRef
            if ActorTarget.GetCombatTarget() != PlayerRef
                if ActorTarget.isinfaction(BondOfFriendshipAssigned) == 0
                    UpdateActorSlotsVariable()
                    if ActorSlots < 11 && ActorSlots > 0
                        if ActorTarget.GetCurrentScene() == None
                            AliasActorTemp.ForceRefTo(ActorTarget as ObjectReference)
                            StartLesserPower1Menu(abStartWithAssign = true)
                        else
                            Debug.MessageBox("The actor is currently in a scene. Therefore, the menu cannot be accessed.")
                        endif
                    elseif ActorSlots == 0
                        BondOfFriendshipMaxSlotsReached.Show()
                    endif    
                else
                    if Variables.CurrentLesserPower == 1
                        if ActorTarget.GetCurrentScene() == None
                            AliasActorTemp.ForceRefTo(ActorTarget as ObjectReference)
                            StartLesserPower1Menu()
                        else
                            Debug.MessageBox("The actor is currently in a scene. Therefore, the menu cannot be accessed.")
                            Return
                        endif   
                    elseif Variables.CurrentLesserPower == 2
                        DebugUtility.BondOfFriendshipSlotCurrent.ForceRefTo(ActorTarget as ObjectReference)
                        DebugUtility.StartLesserPower2Menu()
                    elseif Variables.CurrentLesserPower == 3
                        if ActorTarget.GetCurrentScene() == None
                            Requests.AliasActorTemp.ForceRefTo(ActorTarget as ObjectReference)
                            Requests.StartLesserPower3Menu()
                        else
                            Debug.MessageBox("The actor is currently in a scene. Therefore, the menu cannot be accessed.")
                            Return
                        endif
                    endif    
                endif
            endif 

            if ActorTarget && ActorTarget.GetCombatTarget() == PlayerRef
                BondOfFriendshipHostileActor.Show()
            endif
        endif
    endif    
EndFunction   


;=== Manual Assigning

Function AssignActor(ObjectReference member)
       
    ActorSlots -= 1
    
    int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    bool bBreak = false
    
    While iIndex < iElement && !bBreak
        if !ActorSlotsAlias[iIndex].GetReference()
            if !IsAlreadyInArray(member as Actor)
                ActorSlotsAlias[iIndex].ForceRefTo(member)
                bBreak = True
            endif    
        endif
        iIndex += 1
    EndWhile    
    
endFunction

;===== Auto Assigning


Function AutoFillFollowers()
    ; 1. getting followers
    Actor[] followers = po3_SKSEFunctions.GetPlayerFollowers()
    if followers != none
        int i = 0
        while i < followers.Length
            if followers[i] != none
                AssignActorAuto(followers[i])
            endif
            i += 1
        endwhile
    endif
 EndFunction

Function AutoFillThralls()   
    ; 2. getting dead thralls and summons
    Actor[] thralls = po3_SKSEFunctions.GetCommandedActors(PlayerRef)
    if thralls != none
        int j = 0
        while j < thralls.Length
            if thralls[j] != none
                AssignActorAuto(thralls[j])
            endif
            j += 1
        endwhile
    endif
EndFunction


Function AssignActorAuto(ObjectReference member)
    Actor actorToAssign = member as Actor
    if !actorToAssign
        return
    endif

    ; 1st Safety check: Is the actor already in the array?
    if IsAlreadyInArray(actorToAssign)
        return
    endif
    
    ;2nd Safety check: Is the actor already part of the faction, or is the actor in a scene?
    if actorToAssign.IsInFaction(BondOfFriendshipAssigned) == 1 || actorToAssign.GetCurrentScene() != None
        return
    endif
    
    ; Find an available slot and assign the actor
    int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    bool bBreak = false
    
    While iIndex < iElement && !bBreak
        if !ActorSlotsAlias[iIndex].GetReference()
            if actorToAssign.IsInFaction(BondOfFriendshipAssigned) == 0 
                if actorToAssign.GetCurrentScene() == None
                    ActorSlotsAlias[iIndex].ForceRefTo(actorToAssign)
                    actorToAssign.AddToFaction(BondOfFriendshipAssigned)
                    
                    ; Update the counter for the message boxes immediately after the entry
                    UpdateActorSlotsVariable()
                    NewActors += 1
                    
                    bBreak = true
                endif
            endif
        endif
        iIndex += 1
    EndWhile    
endFunction



;===== Assigning - helper functions

bool Function IsAlreadyInArray(actor akActor)
    int i = 0
    bool bBreak = False
    While (i < ActorSlotsAlias.Length) && !bBreak
        If (ActorSlotsAlias[i] != None && ActorSlotsAlias[i].GetReference() == akActor)
            bBreak = true
            Return True ; Found! The follower is already registered.
        EndIf
        i += 1
    EndWhile
    Return False ; Nothing found
EndFunction

Function UpdateActorSlotsVariable()
    int freeCount = 0
    int i = 0
    while i < ActorSlotsAlias.Length
        if !ActorSlotsAlias[i].GetReference()
            freeCount += 1
        endif
        i += 1
    endwhile
    
    ActorSlots = freeCount
EndFunction



; === Menus

; == Menu Manager

Function StartLesserPower1Menu(bool abStartWithAssign = false, bool abPleaseAssign = false)

    int NextMenu = 1
    
    if NextMenu == 0
        Return
    endif    
    
    if abStartWithAssign
        NextMenu = 60 
    endif
   
    if abPleaseAssign     
        NextMenu = 70
    endif    
        
    While NextMenu > 0
        ; --- MAIN MENUS --- 
        if NextMenu == 1
             NextMenu = MainMenu() ; Returns IDs for submenus, among other things
        elseif NextMenu == 2
             NextMenu = MainMenuPage2()  
             
        ; --- SUBMENUS PAGE 1 ---   
        elseif NextMenu == 11   
            NextMenu = AutomaticCalmMenu()
        elseif NextMenu == 12    
            NextMenu = FriendlyHitsMenu()
        elseif NextMenu == 13 
            NextMenu = KnockoutPreventionMenu()   
        elseif NextMenu == 14
            NextMenu = EditStatsMenu()
        elseif NextMenu == 141    
            NextMenu = SkillsCombatMenu()
        elseif NextMenu == 142
            NextMenu = SkillsMagicMenu()
        elseif NextMenu == 143    
            NextMenu = SkillsStealthMenu()
        elseif NextMenu == 144
            NextMenu = ResistancesMenu()
        elseif NextMenu == 15    
            NextMenu = MakeImmortalMenu()
        elseif NextMenu == 16    
            NextMenu = ClearSlotsMenu()
        elseif NextMenu == 17
            NextMenu = SettingsMenu()    
            
        ; --- SUBMENUS PAGE 2 ---
        elseif NextMenu == 21
            NextMenu = ToggleQuickMenu()
        elseif NextMenu == 22
            NextMenu = TeammateMenu()
        elseif NextMenu == 23
            NextMenu = AutoEquipMenu()
        elseif NextMenu == 24
            NextMenu = AutomaticTeleportMenu()
        elseif NextMenu == 25
            NextMenu = ScanFollowersMenu() ; Returns 99
        elseif NextMenu == 26   
            NextMenu = ListActors()
        
        ; --- SPECIAL MENUS ---    
        elseif NextMenu == 60
            NextMenu = AssignMenu()
        elseif NextMenu == 70
            NextMenu = PleaseAssignActorMsgBox()
     
        ; --- Scan Followers - menu routing ---   
        elseif NextMenu == 99
            ; Code 99 received: We're updating the status and reloading the main menu!
            NextMenu = 1 
        endif
    EndWhile
EndFunction


; == Main Menus
int Function MainMenu(bool bMenu = True)
    While bMenu
        int button = BondOfFriendshipMenuMain.Show(ActorSlots)
        
        if button == 0 ; Automatic Calm
            bMenu = False
            Return 11
        elseIf button == 1 ; Modify Friendly Hits
            bMenu = False
            Return 12          
        elseif button == 2 ; Knockout Prevention
            bMenu = False
            Return 13        
        elseif button == 3 ; Edit Stats
            bMenu = False
            Return 14
        elseif button == 4 ; Make Immortal
            bMenu = False
            Return 15           
        elseif button == 5 ; Clear Slot(s) Menu
            bMenu = False
            Return 16    
        elseif button == 6 ; Settings
            bMenu = False
            Return 17    
        elseif button == 7 ; Page 2
            bMenu = False 
            Return 2
        elseif button == 8 ; Exit menu
            bMenu = False
            StartFeatureProcessing()
            Return 0
        endif
      EndWhile
EndFunction    

int Function MainMenuPage2(bool bMenu = True)
    While bMenu
        int button = BondOfFriendshipMenuMainP2.Show()
        
        if button == 0 ; Quick Menu (Requests menu upon NPC activation)
            bMenu = False
            Return 21
        elseif button == 1 ; Team Mate (SetPlayerTeammate)  
            bMenu = False
            Return 22
        elseif button == 2 ; Auto Equip
            bMenu = False
            Return 23
        elseif button == 3 ; Auto Teleport
            bMenu = False
            Return 24
        elseif button == 4 ; Scan Followers
            bMenu = False
            Return 25
        elseif button == 5 ; Actor List
            bMenu = False
            Return 26
        elseif button == 6 ; back to main menu, page 1
            bMenu = False
            Return 1
        elseif button == 7 ; exit
            bMenu = False
            StartFeatureProcessing()
            Return 0
        endif    
    EndWhile
EndFunction

Function StartFeatureProcessing()
    if FeatureCounter > 0
        FeatureCounter = 0
        ToggleFeatures()
    else
        Debug.Notification("The features haven been processed.")    
    endif
    AliasActorTemp.Clear()
EndFunction    


; == Submenus, Page 1

; = Automatic Calm

int Function AutomaticCalmMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        
        int button = BondOfFriendshipMenuAutomaticCalm.Show()
        
        if button == 0 ; Add
            if ActorTemp.HasSpell(BondOfFriendshipAbility) == 0
                ActorTemp.AddSpell(BondOfFriendshipAbility)
                Debug.Notification("Automatic Calm: Setting saved.")
                bMenu = False
                Return 1
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()                    
            endif
        elseif button == 1 ; Add (all)
            FeatureCounter += 1
            Variables.AutomaticCalm = True
            Debug.Notification("Automatic Calm: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 2 ; Remove
            ActorTemp.RemoveSpell(BondOfFriendshipAbility)
            Debug.Notification("Automatic Calm: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 3 ; Remove (all)    
            FeatureCounter += 1
            Variables.AutomaticCalm = False
            Debug.Notification("Automatic Calm: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 4 ; Back
            bMenu = False
            Return 1
        endif
    EndWhile
EndFunction

; = Friendly Hits

int Function FriendlyHitsMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()

        int button = BondOfFriendshipMenuFriendlyHits.Show()
        
        if button == 0 ; Ignore
            if ActorTemp.IsIgnoringFriendlyHits() == true
                BondOfFriendshipFeatureAlreadyActivated.Show()
                bMenu = False
                Return 1
                else
                Debug.Notification("Friendly Hits: Setting saved.")
                ActorTemp.IgnoreFriendlyHits()
                bMenu = False
                Return 1
            endif
        elseif button == 1 ; Ignore (all)
            FeatureCounter += 1
            Variables.FriendlyHitsIgnored = true
            Debug.Notification("Friendly Hits: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 2 ; Don't ignore
            if ActorTemp.IsIgnoringFriendlyHits() == true
                ActorTemp.IgnoreFriendlyHits(false)
                Debug.Notification("Friendly Hits: Setting saved.")
                bMenu = False
                Return 1
            endIf
        elseif button == 3 ; Don't ignore (all)
            FeatureCounter += 1
            Variables.FriendlyHitsIgnored = false
            Debug.Notification("Friendly Hits: Setting saved.")
            bMenu = False           
            Return 1
        elseif button == 4 ; Back
            bMenu = False
            Return 1
        endif
    EndWhile
EndFunction
 
; = Knockout Prevention 
 
int Function KnockoutPreventionMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()

        int button = BondOfFriendshipMenuKnockoutPrevention.Show()
        
        if button == 0 ; Yes
            if ActorTemp.HasSpell(BondOfFriendshipKnockoutPreventionAbility) == 0
                ActorTemp.AddSpell(BondOfFriendshipKnockoutPreventionAbility)
                Debug.Notification("Knockout Prevention: Setting saved.")
                bMenu = False
                Return 1
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()
                bMenu = False
                Return 1
            endif
        elseif button == 1 ; Yes (all)
            FeatureCounter += 1            
            Variables.KnockoutPrevention = true
            Debug.Notification("Knockout Prevention: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 2 ; No
            ActorTemp.RemoveSpell(BondOfFriendshipKnockoutPreventionAbility)
            Debug.Notification("Knockout Prevention: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 3 ; No (all)
            FeatureCounter += 1
            Variables.KnockoutPrevention = false
            Debug.Notification("Knockout Prevention: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 4 ; Back
            bMenu = False
            Return 1
        endif
    EndWhile
EndFunction 

; = Edit Stats (single actor version only)

int Function EditStatsMenu(bool bMenu = True)
    
    While bMenu        
        
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int TotalHealth = ActorTemp.GetActorValue("Health") as int
        int TotalStamina = ActorTemp.GetActorValue("Stamina") as int
        int TotalMagicka = ActorTemp.GetActorValue("Magicka") as int
        
        int button = BondOfFriendshipMenuStatsMain.Show(TotalHealth, TotalStamina, TotalMagicka)
        
        if button == 0 ; Health
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            Totalhealth = result as int
            if Totalhealth < 50
                Totalhealth = ActorTemp.getbaseactorvalue("health") as int
            endif    
            ActorTemp.RestoreActorValue("health", ActorTemp.getbaseactorvalue("health"))
            ActorTemp.ForceActorValue("health", ActorTemp.getbaseactorvalue("health"))
            ActorTemp.ForceActorValue("health", TotalHealth)
            TotalHealth = ActorTemp.GetActorValue("Health") as int          
        elseif button == 1 ; Stamina
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            TotalStamina = result as int
            if TotalStamina < 50
                TotalStamina = ActorTemp.getbaseactorvalue("stamina") as int
            endif
            ActorTemp.RestoreActorValue("stamina", ActorTemp.getbaseactorvalue("stamina"))
            ActorTemp.ForceActorValue("stamina", ActorTemp.getbaseactorvalue("stamina"))
            ActorTemp.ForceActorValue("stamina", TotalStamina)
            TotalStamina = ActorTemp.GetActorValue("stamina") as int            
        elseif button == 2 ; Magicka
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            TotalMagicka = result as int
            if TotalMagicka < 50
                TotalMagicka = ActorTemp.getbaseactorvalue("magicka") as int
            endif
            ActorTemp.RestoreActorValue("magicka", ActorTemp.getbaseactorvalue("magicka"))
            ActorTemp.ForceActorValue("magicka", ActorTemp.getbaseactorvalue("magicka"))
            ActorTemp.ForceActorValue("magicka", TotalMagicka)
            TotalMagicka = ActorTemp.GetActorValue("magicka") as int            
        elseif button == 3 ; Combat skills
            bMenu = False
            Return 141
        elseif button == 4 ; Magic skills
            bMenu = False
            Return 142
        elseif button == 5 ; Stealth skills
            bMenu = False
            Return 143
        elseif button == 6 ; Resistances
            bMenu = False
            Return 144
        elseif button == 7 ; [ Back ]
            bMenu = False
            Return 1
        endif
    EndWhile    
EndFunction

int Function SkillsCombatMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int SkillOneHanded = ActorTemp.GetActorValue("onehanded") as int
        int SkillTwoHanded = ActorTemp.GetActorValue("twohanded") as int
        int SkillMarksman = ActorTemp.GetActorValue("marksman") as int
        int SkillHeavyArmor = ActorTemp.GetActorValue("heavyarmor") as int
        int SkillLightArmor = ActorTemp.GetActorValue("lightarmor") as int
        int SkillBlock = ActorTemp.GetActorValue("block") as int
        
        int button = BondOfFriendshipMenuStatsSkillsCombat.Show(SkillOneHanded, SkillTwoHanded, SkillMarksman, SkillHeavyArmor, SkillLightArmor, SkillBlock)
        
        if button == 0 ; One-handed
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillOneHanded = result as int
            ActorTemp.ForceActorValue("onehanded", SkillOneHanded)
            SkillOneHanded = ActorTemp.GetActorValue("onehanded") as int
        elseif button == 1 ; Two-handed
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillTwoHanded = result as int
            ActorTemp.ForceActorValue("twohanded", SkillTwoHanded)
            SkillTwoHanded = ActorTemp.GetActorValue("twohanded") as int
        elseif button == 2 ; Marksman
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillMarksman = result as int
            ActorTemp.ForceActorValue("marksman", SkillMarksman)
            SkillMarksman = ActorTemp.GetActorValue("marksman") as int
        elseif button == 3 ; Heavy Armor
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillHeavyArmor = result as int
            ActorTemp.ForceActorValue("heavyarmor", SkillHeavyArmor)
            SkillHeavyArmor = ActorTemp.GetActorValue("heavyarmor") as int
        elseif button == 4 ; light Armor
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillLightArmor = result as int
            ActorTemp.ForceActorValue("lightarmor", SkillLightArmor)
            SkillLightArmor = ActorTemp.GetActorValue("lightarmor") as int
        elseif button == 5 ; block
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillBlock = result as int
            ActorTemp.ForceActorValue("block", SkillBlock)
            SkillBlock = ActorTemp.GetActorValue("block") as int
        elseif button == 6 ; [ back ]
            bMenu = False
            Return 14
        endif
    EndWhile    
EndFunction

int Function SkillsMagicMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int SkillDestruction = ActorTemp.GetActorValue("destruction") as int
        int SkillIllusion = ActorTemp.GetActorValue("illusion") as int
        int SkillConjuration = ActorTemp.GetActorValue("conjuration") as int
        int SkillRestoration = ActorTemp.GetActorValue("restoration") as int
        
        int button = BondOfFriendshipMenuStatsSkillsMagic.Show(SkillDestruction, SkillIllusion, SkillConjuration, SkillRestoration)
        
        if button == 0 ; destruction
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillDestruction = result as int
            ActorTemp.ForceActorValue("destruction", SkillDestruction)
            SkillDestruction = ActorTemp.GetActorValue("destruction") as int
        elseif button == 1 ; illusion
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillIllusion = result as int
            ActorTemp.ForceActorValue("illusion", SkillIllusion)
            SkillIllusion = ActorTemp.GetActorValue("illusion") as int
        elseif button == 2 ; conjuration
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillConjuration = result as int
            ActorTemp.ForceActorValue("conjuration", SkillConjuration)
            SkillConjuration = ActorTemp.GetActorValue("conjuration") as int
        elseif button == 3 ; restoration
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillRestoration = result as int
            ActorTemp.ForceActorValue("restoration", SkillRestoration)
            SkillRestoration = ActorTemp.GetActorValue("restoration") as int
        elseif button == 4 ; [ back ]
            bMenu = False
            Return 14
        endif
    EndWhile    
EndFunction

int Function SkillsStealthMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int SkillSneak = ActorTemp.GetActorValue("sneak") as int
        int SkillLockpicking = ActorTemp.GetActorValue("lockpicking") as int
            
        int button = BondOfFriendshipMenuStatsSkillsStealth.Show(SkillSneak, SkillLockpicking)
        
        if button == 0 ; sneak
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillSneak = result as int
            ActorTemp.ForceActorValue("sneak", SkillSneak)
            SkillSneak = ActorTemp.GetActorValue("sneak") as int
        elseif button == 1 ; lockpicking
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            SkillLockpicking = result as int
            ActorTemp.ForceActorValue("lockpicking", SkillLockpicking)
            SkillLockpicking = ActorTemp.GetActorValue("lockpicking") as int
        elseif button == 2 ; [ back ]
            bMenu = False
            Return 14
        endif
    EndWhile    
EndFunction

int Function ResistancesMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int ResistanceDamage = ActorTemp.GetActorValue("damageresist") as int
        int ResistanceMagic = ActorTemp.GetActorValue("magicresist") as int
        int ResistanceDisease = ActorTemp.GetActorValue("diseaseresist") as int
        
        int button = BondOfFriendshipMenuStatsResistances.Show(ResistanceDamage, ResistanceMagic, ResistanceDisease)
        
        if button == 0 ; Resist Damage
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            ResistanceDamage = result as int
            ActorTemp.ForceActorValue("damageresist", ResistanceDamage)
            ResistanceDamage = ActorTemp.GetActorValue("damageresist") as int
        elseif button == 1 ; Resist Magic
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            ResistanceMagic = result as int
            ActorTemp.ForceActorValue("magicresist", ResistanceMagic)
            ResistanceMagic = ActorTemp.GetActorValue("magicresist") as int
        elseif button == 2 ; Resist Disease
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string result = UIExtensions.GetMenuResultString("UITextEntryMenu")
            ResistanceDisease = result as int
            ActorTemp.ForceActorValue("diseaseresist", ResistanceDisease)
            ResistanceDisease = ActorTemp.GetActorValue("diseaseresist") as int
        elseif button == 3 ; [ back ]
            bMenu = False
            Return 14
        endif
    EndWhile    
EndFunction  
 
; = Mortality

int Function MakeImmortalMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        
        int button = BondOfFriendshipMenuMakeImmortal.Show()
        
        if button == 0 ; Immortal
            if ActorTemp.IsEssential() == 0
                if ActorTemp.IsCommandedActor() == False
                    ActorTemp.GetActorBase().SetEssential()
                    Debug.Notification("Mortalility: Setting saved.")
                else
                    BondOfFriendshipFeatureCommandedActors.Show()
                endif
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()
            endif
            bMenu = False
            Return 1
        elseif button == 1 ; Immortal (all) 
            FeatureCounter += 1
            Debug.Notification("Mortalility: Setting saved.")
            Variables.MakeImmortal = true
            bMenu = False
            Return 1
        elseif button == 2 ; Mortal
            ActorTemp.GetActorBase().SetEssential(False)
            ;Debug.Notification(Target.GetActorBase().GetName())
            if ActorTemp.GetActorBase().IsProtected()
                ActorTemp.GetActorBase().SetProtected(False)
            endif    
            Debug.Notification("Mortalility: Setting saved.")
            bMenu = False
            Return 1
        elseif button == 3 ; Mortal (all)
            FeatureCounter += 1
            Debug.Notification("Mortalility: Setting saved.")
            Variables.MakeImmortal = false
            bMenu = False
            Return 1
        elseif button == 4 ; Back
            bMenu = False
            Return 1
        endif
    EndWhile
EndFunction

; = Clear Slot(s)

int Function ClearSlotsMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int button = BondOfFriendshipMenuClearSlots.Show()
        
        if button == 0 ; current slot alias
            ClearSlot(ActorTemp)
            BondOfFriendshipSlotCleared.Show()
            Variables.WeaponDrawn = False
            bMenu = False
            Return 0
        elseif button == 1 ; all actor slots
            BondOfFriendshipSlotsCleared.Show()
            ClearAllSlots()
            if Variables.WeaponDrawn == True
                Variables.WeaponDrawn = False
            endif
            bMenu = False    
            Return 0
        elseif button == 2 ; Back
            bMenu = False
            Return 1
        endif
    EndWhile
EndFunction

; = Settings

int Function SettingsMenu(bool bMenu = True)
    While bMenu
        int button = BondOfFriendshipMenuSettings.Show(BOFshader.getvalueint(), BOFmessage.getvalueint(), BOFallies.getvalueint())
        
        if button == 0 ; show shader
            if BOFshader.getvalueint() == 1
                BOFshader.setvalueint(0)
            else
                BOFshader.setvalueint(1)
            endif
        elseif button == 1 ; show message
            if BOFmessage.getvalueint() == 1
                BOFmessage.setvalueint(0)
            else
                BOFmessage.setvalueint(1)
            endif
        elseif button == 2 ; allies
            if BOFallies.getvalueint() == 1
                BOFallies.setvalueint(0)
                FeatureCounter += 1
            else
                BOFallies.setvalueint(1)
                FeatureCounter += 1
            endif
        elseif button == 3 ; back
            bMenu = False
            Return 1
        endif
    EndWhile
EndFunction

; == Submenus, Page 2

; = Quick Menu

int Function ToggleQuickMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int button = BondOfFriendshipMenuQuickM.Show() 
        if button == 0 ; Add
           if ActorTemp.IsInFaction(BondOfFriendshipQuickM) == 0
               ActorTemp.AddToFaction(BondOfFriendshipQuickM)
               ActorTemp.BlockActivation(True)
               Debug.Notification("Quick Menu: Setting saved.")
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()
            endif
            bMenu = False
            Return 2    
        elseif button == 1 ; Add (all)
            FeatureCounter += 1
            Debug.Notification("Quick Menu: Setting saved.")
            Variables.QuickMenu = True
            bMenu = False
            Return 2
        elseif button == 2 ; Remove
            ActorTemp.RemoveFromFaction(BondOfFriendshipQuickM)
            ActorTemp.BlockActivation(False)
            Debug.Notification("Quick Menu: Setting saved.")
            bMenu = False
            Return 2
        elseif button == 3 ; Remove (all)    
            FeatureCounter += 1
            Debug.Notification("Quick Menu: Setting saved.")
            Variables.QuickMenu = False
            bMenu = False
            Return 2
        elseif button == 4 ; Back
            bMenu = False
            Return 2
        endif
    EndWhile
EndFunction

; = Teammate

int Function TeammateMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int button = BondOfFriendshipMenuTeammate.Show() 
        if button == 0 ; Add
            if !ActorTemp.IsPlayerTeammate()
                ActorTemp.SetPlayerTeammate(true)
                ActorTemp.AddToFaction(BondOfFriendshipTeammate)
                Debug.Notification("Teammate: Setting saved.")
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()
            endif
            bMenu = False
            Return 2
        elseif button == 1 ; Add (all)
            Debug.Notification("Teammate: Setting saved.")
            Variables.Teammate = True
            ToggleTeammate()
            bMenu = False
            Return 2
        elseif button == 2 ; Remove
            ActorTemp.SetPlayerteammate(false)
            ActorTemp.RemoveFromFaction(BondOfFriendshipTeammate)
            Debug.Notification("Teammate: Setting saved.")
            bMenu = False
            Return 2
        elseif button == 3 ; Remove (all)    
            Debug.Notification("Teammate: Setting saved.")
            Variables.Teammate = False
            ToggleTeammate()
            bMenu = False
            Return 2
        elseif button == 4 ; Back
            bMenu = False
            Return 2
        endif
    EndWhile
EndFunction

Function ToggleTeammate()
   int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    While iIndex < iElement 
         if ActorSlotsAlias[iIndex].getreference()
             Actor Target = ActorSlotsAlias[iIndex].getactorreference()
            if Target.IsNearPlayer()
                if Variables.Teammate == True
                    if !Target.IsPlayerTeammate()
                        Target.addtofaction(BondOfFriendshipTeammate)
                        Target.SetPlayerTeammate(true)
                    endif
                else
                    Target.removefromfaction(BondOfFriendshipTeammate)
                    Target.SetPlayerTeammate(false)
                endif 
            endif
        endif
        iIndex += 1    
    EndWhile   
EndFunction  

; = Auto Equip

int Function AutoEquipMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int button = BondOfFriendshipMenuAutoEquip.Show() 
        if button == 0 ; Add
           if ActorTemp.IsInFaction(BondOfFriendshipAutoEquip) == 0
               ActorTemp.AddToFaction(BondOfFriendshipAutoEquip)
               Debug.Notification("Auto Equip: Setting saved.")
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()
            endif
            bMenu = False
            Return 2
        elseif button == 1 ; Add (all)
            FeatureCounter += 1
            Variables.AutoEquip = True
            Debug.Notification("Auto Equip: Setting saved.")
            bMenu = False
            Return 2
        elseif button == 2 ; Remove
            ActorTemp.RemoveFromFaction(BondOfFriendshipAutoEquip)
            bMenu = False
            Return 2
        elseif button == 3 ; Remove (all)    
            FeatureCounter += 1
            Debug.Notification("Auto Equip: Setting saved.")
            Variables.AutoEquip = False
            bMenu = False
            Return 2
        elseif button == 4 ; Back
            bMenu = False
            Return 2
        endif
    EndWhile
EndFunction

; = Auto Teleport
int Function AutomaticTeleportMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
        int button = BondOfFriendshipMenuAutoTeleport.Show()
        
        if button == 0 ; Add
            if ActorTemp.HasSpell(BondOfFriendshipAutomaticTeleportSpell) == 0
                ActorTemp.AddSpell(BondOfFriendshipAutomaticTeleportSpell)
                Debug.Notification("Auto Teleport: Setting saved.")  
            else
                BondOfFriendshipFeatureAlreadyActivated.Show()              
            endif
            bMenu = False
            Return 2
        elseif button == 1  ; Add (all)
            FeatureCounter += 1
            Debug.Notification("Auto Teleport: Setting saved.")
            Variables.AutoTeleport = true
            bMenu = False
            Return 2
        elseif button == 2 ; Remove
            ActorTemp.RemoveSpell(BondOfFriendshipAutomaticTeleportSpell)
            Debug.Notification("Auto Teleport: Setting saved.")
            bMenu = False
            Return 2
        elseif button == 3 ; Remove (all)
            FeatureCounter += 1
            Debug.Notification("Auto Teleport: Setting saved.")
            Variables.AutoTeleport = false  
            bMenu = False
            Return 2
        elseif button == 4 ; Back
            bMenu = False
            Return 2
        endif
   EndWhile 
EndFunction

; = Actor List

int Function ListActors()
    string text = ""
    int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    
    While iIndex < iElement
        if ActorSlotsAlias[iIndex].getreference()
            Actor currentFollower = ActorSlotsAlias[iIndex].getactorreference()
            if IsLeveledActor(currentFollower) == false
                text += "\n" + currentFollower.GetActorBase().getname()
            else
                text += "\n" + currentFollower.GetLeveledActorBase().getname()
            endif    
        endif
        iIndex += 1
    EndWhile
    Debug.Messagebox(text)
    Return 2
EndFunction    
    
Bool Function isLeveledActor(Actor akActor)
    If akActor.GetLeveledActorBase().GetFormID() < 0
        Return True
    EndIf
    Return False
EndFunction    

; == Special Menus

; = Assigning - single actor
int Function AssignMenu(bool bMenu = True)
    While bMenu
        Actor ActorTemp = AliasActorTemp.getactorreference()
       
        int button = BondOfFriendshipMenuAssign.Show(ActorSlots)

        if button == 0 ; Assign actor
            ActorTemp.AddToFaction(BondOfFriendshipAssigned)
            if BOFallies.getvalueint() == 1
                ActorTemp.AddToFaction(BondOfFriendshipAllies)
            else
                ActorTemp.RemoveFromFaction(BondOfFriendshipAllies)
            endif
            AssignActor(ActorTemp as ObjectReference)
            bMenu = False    
            Return 99
        elseif button == 1 ; Scan Followers
            bMenu = False
            Return 25
        elseif button == 2
            bMenu = False
            Return 0    
        endif
    EndWhile
EndFunction   


; = Assingning - multiple actor (for all scripts containing "AOE" in the name)

int Function PleaseAssignActorMsgBox(bool bMenu = True)
        While bMenu
            int button = BondOfFriendshipAOEAssign.Show()
         
            if button == 0 ; Scan Followers (only available when Papyrus Extender is installed)    
                Return 25
            elseif button == 1 ; How to
                BondOfFriendshipAOEAssignHowTo.Show()
            elseif button == 2 ; about cooldown
                BondOfFriendshipAOEAssignCooldown.Show()
            elseif button == 3 ; exit
                bMenu = False
                Return 0    
            endif
        EndWhile
EndFunction

; = Scan Followers
 
int Function ScanFollowersMenu(bool bMenu = True)
    While bMenu
        int button = BondOfFriendshipMenuScanFollowers.Show()

        if button == 0 ; Start Scan
            NewActors = 0
            AutoFillFollowers()
            AutoFillThralls()
            if NewActors > 0
                debug.notification("Scan complete: "+NewActors+" new Actor(s) found.")
                NewActors = 0
            else   
                debug.notification("Scan complete: No new Actor(s) found.")
            endif
            bMenu = False
            if Variables.CurrentLesserPower == 1
                Return 99
            else
                Return 0
            endif   
        elseif button == 1 ; Back    
            bMenu = False
            Return 99
        endif
    EndWhile
EndFunction 
 
 
 ; === Adding Features via BondOfFriendshipSelf spell (weapon NOT drawn)
 

Function ToggleFeatures()
    Debug.Notification("The features are being processed. Please wait..." )
    int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    
    While iIndex < iElement 
         if ActorSlotsAlias[iIndex].getreference()
             
            Actor Target = ActorSlotsAlias[iIndex].getactorreference()
            if Target.IsNearPlayer()
                
                ;=== Automatic Calm
                
                if Variables.AutomaticCalm == True
                    target.AddSpell(BondOfFriendshipAbility)
                    
                else
                    target.RemoveSpell(BondOfFriendshipAbility)
                endif
                
                ;=== Friendly Hits
                
                if Variables.FriendlyHitsIgnored == True
                    target.IgnoreFriendlyHits()
                else
                    target.IgnoreFriendlyHits(false)
                endif
                
                ;=== Knockout Prevention
                
                if Variables.KnockoutPrevention == True
                   target.AddSpell(BondOfFriendshipKnockoutPreventionAbility)
                else
                   target.RemoveSpell(BondOfFriendshipKnockoutPreventionAbility)
                endif   

               ;=== Allies
                
                if BOFallies.getvalueint() == 1
                    target.addtofaction(BondOfFriendshipAllies)
                else
                    target.removefromfaction(BondOfFriendshipAllies)
                endif   
                
                ;=== Make Immortal
                
                if Variables.MakeImmortal == True
                    if target.IsCommandedActor() == False
                        target.GetActorBase().SetEssential()
                    endif    
                else
                    if target.IsCommandedActor() == False
                        target.GetActorBase().SetEssential(False)
                        if Target.GetActorBase().IsProtected()
                            Target.GetActorBase().SetProtected(False)
                        EndIf   
                    endif    
                endif
                
                ;=== Automatic Teleport
                
                if Variables.AutoTeleport == True
                    target.AddSpell(BondOfFriendshipAutomaticTeleportSpell)
                else
                    target.RemoveSpell(BondOfFriendshipAutomaticTeleportSpell)
                endif
                
               ;=== QuickMenu
                
                if Variables.QuickMenu == True
                    target.addtofaction(BondOfFriendshipQuickM)
                    Target.BlockActivation(True)
                else
                    target.removefromfaction(BondOfFriendshipQuickM)
                    Target.BlockActivation(False)
                endif 
                
                ;=== Auto Equip
                
                if Variables.AutoEquip == True
                    target.addtofaction(BondOfFriendshipAutoEquip)
                else
                    target.removefromfaction(BondOfFriendshipAutoEquip)
                endif
            endif
        endif
        iIndex += 1    
    EndWhile
    Debug.Notification("Done.")
EndFunction    



Function ClearSlot(ObjectReference member)
    
    ActorSlots += 1
    
    int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    bool bBreak = False
    
    While iIndex < iElement && !bBreak
        if (ActorSlotsAlias[iIndex].GetActorReference() As ObjectReference) == member
            
            int jIndex = 0
            bool cBreak = False
            while (jIndex < ActorAliasScripts.Length) && !cBreak
                if (ActorAliasScripts[jIndex].GetActorReference() As ObjectReference) == member
                    ActorAliasScripts[jIndex].ClearArray()    
                    cBreak = True
                endif
                jIndex += 1
            endwhile
            ActorSlotsAlias[iIndex].Clear()
            bBreak = True
        endif
        iIndex += 1
    EndWhile
    
    
    Actor Target = (member as actor)
    Target.RemoveFromFaction(BondOfFriendshipAssigned)
    Target.RemoveFromFaction(BondOfFriendshipAllies)
    if Target.IsInFaction(BondOfFriendshipQuickM)
        Target.RemoveFromFaction(BondOfFriendshipQuickM)
        Target.BlockActivation(False)
    endif
    if Target.IsInFaction(BondOfFriendshipTeammate)
            Target.RemoveFromFaction(BondOfFriendshipTeammate)
            Target.SetPlayerTeammate(false)
        endif    
    Target.RemoveFromFaction(BondOfFriendshipAutoEquip)
    if Target.HasSpell(BondOfFriendshipKnockoutPreventionAbility)
        Target.RemoveSpell(BondOfFriendshipKnockoutPreventionAbility)
    endif    
    if Target.HasSpell(BondOfFriendshipAbility)
        Target.RemoveSpell(BondOfFriendshipAbility)
    endif   
    if Target.HasSpell(BondOfFriendshipAutomaticTeleportSpell)
        Target.RemoveSpell(BondOfFriendshipAutomaticTeleportSpell)
    endif
EndFunction



Function ClearAllSlots()
    int iElement = ActorSlotsAlias.Length
    int iIndex = 0
    
    While iIndex < iElement 
        Actor Target = ActorSlotsAlias[iIndex].getactorreference()
        
        int jIndex = 0
        bool cBreak = False
        while (jIndex < ActorAliasScripts.Length) && !cBreak
            if (ActorAliasScripts[jIndex].GetActorReference() As ObjectReference) == Target
                ActorAliasScripts[jIndex].ClearArray()    
                cBreak = True
            endif
            jIndex += 1
        endwhile
        
        Target.RemoveFromFaction(BondOfFriendshipAssigned)
        Target.RemoveFromFaction(BondOfFriendshipAllies)
        if Target.IsInFaction(BondOfFriendshipQuickM)
            Target.RemoveFromFaction(BondOfFriendshipQuickM)
            Target.BlockActivation(False)
        endif
        if Target.IsInFaction(BondOfFriendshipTeammate)
            Target.RemoveFromFaction(BondOfFriendshipTeammate)
            Target.SetPlayerTeammate(false)
        endif
        Target.RemoveFromFaction(BondOfFriendshipAutoEquip)
        if Target.HasSpell(BondOfFriendshipKnockoutPreventionAbility)
            Target.RemoveSpell(BondOfFriendshipKnockoutPreventionAbility)
        endif    
        if Target.HasSpell(BondOfFriendshipAbility)
            Target.RemoveSpell(BondOfFriendshipAbility)
        endif   
        if Target.HasSpell(BondOfFriendshipAutomaticTeleportSpell)
            Target.RemoveSpell(BondOfFriendshipAutomaticTeleportSpell)
        endif
        ActorSlotsAlias[iIndex].Clear()
        iIndex += 1    
    EndWhile
    ActorSlots = 10
    Variables.AutomaticCalm = False
    Variables.FriendlyHitsIgnored = False
    Variables.MakeImmortal = False 
    Variables.AutoTeleport = False 
    Variables.KnockoutPrevention = False
    Variables.QuickMenu = False 
    Variables.Teammate = False
    Variables.AutoEquip = False
EndFunction