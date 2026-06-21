Scriptname BondOfFriendshipDebugUtilityQscript extends Quest Conditional


Message Property BondOfFriendshipMenuDebugActors Auto
Message Property BondOfFriendshipSlotEmpty Auto
Message Property BondOfFriendshipMenuDebugActorsActions Auto
Message Property BondOfFriendshipDebugDisableEnable Auto
Message Property BondOfFriendshipDebugGetUp Auto
Message Property BondOfFriendshipDebugResetInventory Auto
Message Property BondOfFriendshipDebugResetAI Auto
Message Property BondOfFriendshipDebugRecycleActor Auto
Message Property BondOfFriendshipDebugMoveToMe Auto
Message Property BondOfFriendshipFeatureDone Auto
Message Property BondOfFriendshipMsgSKSE Auto
Message Property BondOfFriendshipMsgConsoleUtil Auto
Message Property BondOfFriendshipMsgConsoleUtilSKSE Auto
ReferenceAlias Property BondOfFriendshipSlotCurrent Auto
ObjectReference Property EmptySlot Auto
Spell Property BondOfFriendshipStagger Auto
Actor Target
Actor Property PlayerRef Auto
BondOfFriendshipActorManager Property ActorManager Auto
BondOfFriendshipMaintenance Property Maintenance Auto
Int Property CurrentSlot Auto Conditional
Int Property i Auto Conditional




Function CheckCurrentSlot()
    int iElement = ActorManager.ActorSlotsAlias.Length
    int iIndex = i
    bool bBreak = False
    
    While iIndex < iElement && !bBreak
        if ActorManager.ActorSlotsAlias[iIndex].GetReference()
            BondOfFriendshipSlotCurrent.ForceRefTo(ActorManager.ActorSlotsAlias[iIndex].GetActorRef())
            bBreak = True
        else
            BondOfFriendshipSlotCurrent.Clear()
            BondOfFriendshipSlotCurrent.ForceRefTo(EmptySlot)
            bBreak = True
        endif
        iIndex += 1
    EndWhile  
EndFunction


Function StartLesserPower2Menu(bool AOE = True)
    
    ;Debug.Notification(BondOfFriendshipSlotCurrent.GetActorRef().GetActorBase().GetName())
    
    int NextMenu = 1

    if NextMenu == 0
        Return
    endif
   
    if AOE == False
        NextMenu = 2
    endif            

    While NextMenu > 0
        if NextMenu == 1
            NextMenu = DebugActorsMenu()
        elseif NextMenu == 2
            NextMenu = DebugActionsMenu()
        
        ;--- Debug Actions - Submenus ---
        elseif NextMenu == 21 ; Debug Disable/Enable
            NextMenu = DebugDisableEnable()
        elseif NextMenu == 22 ; Get Up!
            NextMenu = DebugGetUp() 
        elseif NextMenu == 23 ; Reset Inventory
            NextMenu = DebugResetInventory()
        elseif NextMenu == 24 ; Reset AI
            NextMenu = DebugResetAI()
        elseif NextMenu == 25 ; Recycle Actor
            NextMenu = DebugRecycleActor()
        elseif NextMenu == 26 ; Move To Me
            NextMenu = DebugMoveToMe()    
        endif  
    EndWhile    
    
EndFunction    

int Function DebugActorsMenu(bool bMenu = True)
    i = 0
    CurrentSlot = 1
    CheckCurrentSlot()
    While bMenu
        int button = BondOfFriendshipMenuDebugActors.Show(CurrentSlot)
    
        if button == 0 ; First Slot
            i = 0
            CurrentSlot = 1
            CheckCurrentSlot()
        elseif button == 1 ; Next Slot
            i += 1
            CurrentSlot = i + 1
            if i > 9
                i = 0
                CurrentSlot = 1
            endif
            CheckCurrentSlot()
        elseif button == 2 ; Previous Slot
            i -= 1
            CurrentSlot = i + 1
            if i < 0
                i = 9
                CurrentSlot = i + 1
            endif
            CheckCurrentSlot()
        elseif button == 3 ; Last Slot
            i = 9
            CurrentSlot = i + 1
            CheckCurrentSlot()    
        elseif button == 4 ; > Actions
            if BondOfFriendshipSlotCurrent.GetReference() != EmptySlot
                bMenu = False
                Return 2
            else
                BondOfFriendshipSlotEmpty.Show()
            endif
        elseif button == 5 ; exit
            bMenu = False
            BondOfFriendshipSlotCurrent.Clear()
            Return 0
        endif
    EndWhile    
EndFunction



int Function DebugActionsMenu()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipMenuDebugActorsActions.Show()
    if button == 0 ; Debug Disable/Enable
        Return 21
    elseif button == 1 ; Get Up!
        Return 22 
    elseif button == 2 ; Reset Inventory <- requires SKSE
        Return 23    
    elseif button == 3 ; Reset AI <- requires ConsoleUtil and SKSE
        Return 24
    elseif button == 4 ; Recycle Actor <- requires ConsoleUtil and SKSE
        Return 25
    elseif button == 5 ; Move To Me
        Return 26
    elseif button == 6 ; Back
        Return 1
    elseif button == 7 ; Exit
        BondOfFriendshipSlotCurrent.Clear()
        Return 0    
    endif    
EndFunction

   

int Function DebugDisableEnable()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipDebugDisableEnable.Show()
    if button == 0 ; Apply
        BondOfFriendshipFeatureDone.Show()
        BondOfFriendshipSlotCurrent.GetActorRef().disable()
        Utility.Wait(1)
        BondOfFriendshipSlotCurrent.GetActorRef().enable()
        BondOfFriendshipSlotCurrent.Clear()
        Return 0
    elseif button == 1
        Return 2 ; Back
    endif    
EndFunction

int Function DebugGetUp()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipDebugGetUp.Show()
    if button == 0
        BondOfFriendshipFeatureDone.Show()
        BondOfFriendshipStagger.Cast(Game.GetPlayer(), Target)
        BondOfFriendshipStagger.Cast(Game.GetPlayer(), Target)
        Target.ResetHealthAndLimbs()
        Target.EvaluatePackage()
        BondOfFriendshipSlotCurrent.Clear()
        Return 0
    elseif button == 1
        Return 2    
    endif    
EndFunction

int Function DebugResetInventory()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipDebugResetInventory.Show()
    if button == 0
        if Maintenance.SKSEActive == True
            BondOfFriendshipFeatureDone.Show()
            Target.ResetInventory()
        else
            BondOfFriendshipMsgSKSE.Show()
        endif
        BondOfFriendshipSlotCurrent.Clear()
        Return 0
    elseif button == 1
        Return 2    
    endif    
EndFunction

int Function DebugResetAI()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipDebugResetAI.Show()
    if button == 0
        if Maintenance.SKSEActive == True && Maintenance.ConsoleUtilActive == True
            BondOfFriendshipFeatureDone.Show()
            ConsoleUtil.SetSelectedReference(BondOfFriendshipSlotCurrent.GetActorRef())
            ConsoleUtil.ExecuteCommand("ResetAI") 
        endif
        
       if Maintenance.ConsoleUtilActive == False && Maintenance.SKSEActive == True 
            BondOfFriendshipMsgConsoleUtil.Show()
        elseif Maintenance.ConsoleUtilActive == False && Maintenance.SKSEActive == False
            BondOfFriendshipMsgConsoleUtilSKSE.Show()
        endif
        BondOfFriendshipSlotCurrent.Clear()
        Return 0
    elseif button == 1
        Return 2    
    endif    
EndFunction

int Function DebugRecycleActor()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipDebugRecycleActor.Show()
    if button == 0
        if Maintenance.SKSEActive == True && Maintenance.ConsoleUtilActive == True
            BondOfFriendshipFeatureDone.Show()
            ConsoleUtil.SetSelectedReference(BondOfFriendshipSlotCurrent.getactorreference())
            Target.SetAlpha(0)
            ConsoleUtil.ExecuteCommand("RecycleActor")
            MoveBackUpdateInventory()
        endif
        
       if Maintenance.ConsoleUtilActive == False && Maintenance.SKSEActive == True 
            BondOfFriendshipMsgConsoleUtil.Show()
        elseif Maintenance.ConsoleUtilActive == False && Maintenance.SKSEActive == False
            BondOfFriendshipMsgConsoleUtilSKSE.Show()
        endif    
        Return 0
    elseif button == 1
        Return 2
    endif    
EndFunction

Function MoveBackUpdateInventory()
    RegisterForSingleUpdate(0.5)
EndFunction

Event OnUpdate()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    Target.moveto(PlayerRef, 100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()))
    float zOffset = Target.GetHeadingAngle(PlayerRef)
    Target.SetAngle(Target.GetAngleX(), Target.GetAngleY(), Target.GetAngleZ() + zOffset)
    Target.ResetInventory()
    Target.SetAlpha(1)
    BondOfFriendshipSlotCurrent.Clear()
EndEvent    

int Function DebugMoveToMe()
    Target = BondOfFriendshipSlotCurrent.getactorreference()
    int button = BondOfFriendshipDebugMoveToMe.Show()
    if button == 0
        BondOfFriendshipFeatureDone.Show()
        Target.Disable()
        Target.moveto(PlayerRef, 100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()))
        float zOffset = Target.GetHeadingAngle(PlayerRef)
        Target.SetAngle(Target.GetAngleX(), Target.GetAngleY(), Target.GetAngleZ() + zOffset)
        Target.Enable()
        BondOfFriendshipSlotCurrent.Clear()
        Return 0
    elseif button == 1
        Return 2    
    endif    
EndFunction





;ConsoleUtil.SetSelectedReference(BondOfFriendshipSlotCurrent.GetActorRef())
;ConsoleUtil.ExecuteCommand("openactorcontainer 1")    

;/Disable/Enable: E.g. solves T-pose glitch, resets level (to match your own until the level cap is reached)
Reset AI: Re-evaluates combat behavior, pathing and packages.
Recycle Actor: Resets the actor completely (but not the inventory) and revives the actor as well
Reset Inventory: Use this if the NPC is naked (please remove any items from the actor's inventory that belong to you first)/;