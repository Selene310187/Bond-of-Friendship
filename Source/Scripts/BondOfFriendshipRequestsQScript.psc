Scriptname BondOfFriendshipRequestsQScript extends Quest  Conditional

Message Property BondOfFriendshipMenuRequests Auto
Message Property BondOfFriendshipMenuRequestsAOE Auto
ObjectReference Property OutfitChest Auto
ReferenceAlias Property AliasActorTemp Auto
BondOfFriendshipActorManager Property ActorManager Auto
Form[] Property LastInventory Auto
Faction Property BondOfFriendshipAutoEquip Auto
Armor Property DummyItem Auto
Actor Property PlayerRef Auto
Actor Property Target Auto
ObjectReference Property MeetingPoint Auto
ObjectReference Property EmergencyPoint Auto
Message Property BondOfFriendshipMenuRequestsMeetingPoint Auto
BondOfFriendshipVariables Property Variables Auto
Message Property BondOfFriendshipFeatureDone Auto
Message Property BondOfFriendshipMeetingPointCannotBeSet Auto
Message Property BondOfFriendshipMeetingPointSetFirst Auto
BondOfFriendshipMaintenance Property Maintenance Auto
bool FollowAfterTeleport

Function CleanUp()
    AliasActorTemp.Clear()
    Target = None
    if Variables.CommandedActor == True
        Variables.CommandedActor = False
    endif
      if Variables.SpectralDrum == True
          Variables.SpectralDrum = False
    endif 
EndFunction    

  



Function StartLesserPower3Menu(bool AOE = False)
    
    int NextMenu = 1
    
    if NextMenu == 0
        Return
    endif 
    
    if AOE == true
        NextMenu = 2
    endif    

    While NextMenu > 0
        if NextMenu == 1 ; Requests - single actor
            NextMenu = RequestsMenu()
        elseif NextMenu == 2 ; Requests - multiple actors (AOE)
            NextMenu = RequestsMenuAOE()
        elseif NextMenu == 21 ; Meeting Point (only in AOE)
            NextMenu = MeetingPointMenu()
        endif  
    EndWhile
EndFunction    
    


int Function RequestsMenu()
    
    Actor ActorTemp = AliasActorTemp.getactorreference()
    
    Race SpectralDrumRace = Game.GetFormFromFile(0x00029EFC, "Dragonborn.esm") as Race
    
    if ActorTemp.IsCommandedActor()
        Variables.CommandedActor = True
    endif    
    
    if SpectralDrumRace && ActorTemp.GetRace() == SpectralDrumRace
        Variables.SpectralDrum = True
    endif 
        
    int button = BondOfFriendshipMenuRequests.Show()
    
    Variables.CommandedActor = False
    
    if button == 0 ; Talk
        if ActorTemp.IsInFaction(ActorManager.BondOfFriendshipQuickM)
            ActorTemp.BlockActivation(False)
            RegisterForMenu("Dialogue Menu")
            ActorTemp.Activate(PlayerRef, true)
            ActorTemp.BlockActivation(True)
        else
            ActorTemp.Activate(PlayerRef, true)
        EndIf
        CleanUp()
        Return 0
    elseIf button == 1 ; Wait
        if ActorTemp.IsCommandedActor()
            ActorTemp.SetPlayerTeammate(true)
            ActorTemp.EnableAI(false)
            ActorTemp.Disable()
            ActorTemp.Enable()
            CleanUp()
        else
            ActorTemp.SetActorValue("WaitingForPlayer", 1)
            ActorTemp.EvaluatePackage()
            CleanUp()
        EndIf
       
        Return 0
    elseif button == 2 ; Follow
        if ActorTemp.IsCommandedActor()
            ActorTemp.EnableAI(true)
            ActorTemp.Disable()
            ActorTemp.Enable()
            if !ActorTemp.IsInFaction(ActorManager.BondOfFriendshipTeammate)
                ActorTemp.SetPlayerTeammate(false)
            endif 
            CleanUp()
        else
            ActorTemp.SetActorValue("WaitingForPlayer", 0)
            ActorTemp.EvaluatePackage()
            CleanUp()
        endif    
        Return 0
    elseif button == 3 ; Favor
        ActorTemp.SetDoingFavor()
        CleanUp()
        Return 0
    elseif button == 4 ; Inventory
        if Maintenance.SKSEActive == True
            RegisterForMenu("ContainerMenu")
        endif
        ActorTemp.OpenInventory(true)
        if Maintenance.SKSEActive == False
            CleanUp()
        endif
        Return 0
    elseif button == 5 ; exit
        CleanUp()    
        Return 0    
    endif
EndFunction


int Function RequestsMenuAOE()
    int button = BondOfFriendshipMenuRequestsAOE.Show()
    

    If button == 0 ; Wait
        int iElement = ActorManager.ActorSlotsAlias.Length
        int iIndex = 0
    
        While iIndex < iElement 
            if ActorManager.ActorSlotsAlias[iIndex].getreference()
                Target = ActorManager.ActorSlotsAlias[iIndex].getactorreference()
                if Target.IsNearPlayer() && Target.GetCurrentScene() == None
                    if Target.IsCommandedActor()
                        Target.SetPlayerTeammate(true)
                        Target.EnableAI(false)
                        Target.Disable()
                        Target.Enable()
                    else
                        Target.SetActorValue("WaitingForPlayer", 1)
                        Target.EvaluatePackage()
                    endif    
                endif
            endif
            iIndex += 1    
        EndWhile
        CleanUp()
        Return 0   
    elseif button == 1 ; Follow
        int iElement = ActorManager.ActorSlotsAlias.Length
        int iIndex = 0
    
        While iIndex < iElement 
            if ActorManager.ActorSlotsAlias[iIndex].getreference()
                Target = ActorManager.ActorSlotsAlias[iIndex].getactorreference()
                if Target.IsNearPlayer() && Target.GetCurrentScene() == None
                    if Target.IsCommandedActor() && !Target.IsAIEnabled()
                        Target.EnableAI(True)
                        Target.Disable()
                        Target.Enable()
                        if !Target.IsInFaction(ActorManager.BondOfFriendshipTeammate)
                            Target.SetPlayerTeammate(false)
                        endif
                        
                        if Target.IsInFaction(BondOfFriendshipAutoEquip)
                            int j = 0
                            bool cBreak = False
                            while (j < ActorManager.ActorAliasScripts.Length) && !cBreak
                               ObjectReference ActorAliasRef = ActorManager.ActorAliasScripts[j].GetActorReference() As ObjectReference
                               If ActorAliasRef == Target
                                   ActorManager.ActorAliasScripts[j].ReEquip()
                                   cBreak = True
                               endif
                               j += 1
                            endwhile    
                        endif
                    Else
                        Target.SetActorValue("WaitingForPlayer", 0)
                        Target.EvaluatePackage()
                    endif   
                endif
            endif
            iIndex += 1    
        EndWhile
        CleanUp()
        Return 0
    elseif button == 2 ; Meeting Point
        Return 21
    elseif button == 3 ; exit
        CleanUp()
        Return 0    
    endif
    
EndFunction

  


int Function MeetingPointMenu(bool bMenu = True)
    While bMenu
        int button = BondOfFriendshipMenuRequestsMeetingPoint.Show()
        
        if button == 0 ; set meeting point
            MeetingPoint.MoveTo(PlayerRef)
            Variables.MeetingPointSet = True
            ;BondOfFriendshipFeatureDone.Show()
            Debug.Notification("Meeting Point has been set.")
        elseif button == 1 ; remove meeting point   
            MeetingPoint.MoveTo(OutfitChest) ; finally using the chest of the discarded outfit manager for something
            Variables.MeetingPointSet = False
            ;BondOfFriendshipFeatureDone.Show()
            Debug.Notification("Meeting Point has been removed.")
        elseif button == 2 ; teleport all    
            if Variables.MeetingPointSet == True
                bMenu = False
                FollowAfterTeleport = True
                PlayerRef.MoveTo(MeetingPoint)
                Utility.Wait(0.1)
                MoveFollowersToMeetingPoint()
                Return 0
            else
                BondOfFriendshipMeetingPointSetFirst.Show()
            endif    
        elseif button == 3 ; teleport player
            if Variables.MeetingPointSet == False
                BondOfFriendshipMeetingPointSetFirst.Show()
            endif 
            if Variables.MeetingPointSet == True
                if Maintenance.PapyrusExtenderActive == True
                    int iElement = ActorManager.ActorSlotsAlias.Length
                    int iIndex = 0

                    While iIndex < iElement 
                        if ActorManager.ActorSlotsAlias[iIndex].getreference()
                            Target = ActorManager.ActorSlotsAlias[iIndex].getactorreference()
                            if Target.GetActorValue("WaitingForPlayer") == 0 && Target.IsAIEnabled() && Target.GetCurrentScene() == None
                                if ActorManager.IsPlayerFollower(Target as Actor) || ActorManager.IsPlayerSummon(Target as Actor)
                                    if Target.IsCommandedActor()
                                            Target.SetPlayerTeammate(true)
                                            Target.EnableAI(false)
                                            Utility.Wait(0.7)
                                            float angleZ = PlayerRef.GetAngleZ()
                                            Target.MoveTo(PlayerRef, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                                            Target.Disable()
                                            Target.Enable()
                                        else
                                            Target.SetActorValue("WaitingForPlayer", 1)
                                            Target.EvaluatePackage()
                                        endif  
                                    EndIf
                                Endif
                            endif    
                            iIndex += 1    
                    EndWhile
                    Utility.Wait(0.1)
                    PlayerRef.MoveTo(MeetingPoint)
                    bMenu = False
                    CleanUp()
                    Return 0
                endif
               
                if Maintenance.PapyrusExtenderActive == False
                    int iElement = ActorManager.ActorSlotsAlias.Length
                    int iIndex = 0

                    While iIndex < iElement 
                        if ActorManager.ActorSlotsAlias[iIndex].getreference()
                            Target = ActorManager.ActorSlotsAlias[iIndex].getactorreference()
                            if Target.GetActorValue("WaitingForPlayer") == 0 && Target.IsAIEnabled() && Target.GetCurrentScene() == None
                                if Target.IsCommandedActor() 
                                        Target.SetPlayerTeammate(true)
                                        Target.EnableAI(false)
                                        Utility.Wait(0.7)
                                        float angleZ = PlayerRef.GetAngleZ()
                                        Target.MoveTo(PlayerRef, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                                        Target.Disable()
                                        Target.Enable()
                                    else
                                        if Target.IsInFaction(ActorManager.CurrentFollowerFaction)
                                            Target.SetActorValue("WaitingForPlayer", 1)
                                            Target.EvaluatePackage()
                                        endif
                                    endif  
                                EndIf
                            endif    
                            iIndex += 1    
                    EndWhile
                    Utility.Wait(0.1)
                    PlayerRef.MoveTo(MeetingPoint)
                    bMenu = False
                    CleanUp()
                    Return 0
                endif   
            else
                BondOfFriendshipMeetingPointSetFirst.Show()    
            endif    
        elseif button == 4 ; teleport only followers
            if Variables.MeetingPointSet == True
                bMenu = False
                FollowAfterTeleport = False
                MoveFollowersToMeetingPoint()
                Return 0
            else
                BondOfFriendshipMeetingPointSetFirst.Show()    
            endif    
        elseif button == 5 ; emergency teleport
            bMenu = False
            
            PlayerRef.MoveTo(EmergencyPoint)
            Utility.Wait(0.1)
            
            int iElement = ActorManager.ActorSlotsAlias.Length
            int iIndex = 0

            While iIndex < iElement 
                if ActorManager.ActorSlotsAlias[iIndex].getreference()
                    Target = ActorManager.ActorSlotsAlias[iIndex].getactorreference()
                        if Target.GetCurrentScene() == None
                            float angleZ = EmergencyPoint.GetAngleZ()
                            Target.MoveTo(EmergencyPoint, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                            if Target.IsCommandedActor() && Target.IsAIEnabled() == False
                                Target.Disable()
                                Target.Enable()
                            endif    
                            Target.EvaluatePackage()
                            Target.SetAlert()
                            Target.SetAlert(false)
                        endif  
                    EndIf
                iIndex += 1    
            EndWhile
      
            CleanUp()
            Return 0
        elseif button == 6 ; back    
            Return 2
        endif
    EndWhile    
EndFunction  

Function MoveFollowersToMeetingPoint()
    int iElement = ActorManager.ActorSlotsAlias.Length
    int iIndex = 0

    While iIndex < iElement 
        if ActorManager.ActorSlotsAlias[iIndex].getreference()
            Target = ActorManager.ActorSlotsAlias[iIndex].getactorreference()
            
            if Target.GetCurrentScene() == None
                if FollowAfterTeleport == False
                    if Target.IsCommandedActor()
                        Target.SetPlayerTeammate(true)
                        Target.EnableAI(false)
                        Utility.Wait(0.7)
                        float angleZ = MeetingPoint.GetAngleZ()
                        Target.MoveTo(MeetingPoint, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                        Target.Disable()
                        Target.Enable()
                    else
                        float angleZ = MeetingPoint.GetAngleZ()
                        Target.MoveTo(MeetingPoint, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                        Target.SetActorValue("WaitingForPlayer", 1)
                        Target.EvaluatePackage()
                        Target.SetAlert()
                        Target.SetAlert(false) 
                    endif  
                endif
                if FollowAfterTeleport == True
                    if Target.IsCommandedActor()
                        float angleZ = MeetingPoint.GetAngleZ()
                        Target.MoveTo(MeetingPoint, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                        if Target.IsAIEnabled() == False
                            Target.EnableAI(True)
                            Target.Disable()
                            Target.Enable()
                        endif
                    else
                        float angleZ = MeetingPoint.GetAngleZ()
                        Target.MoveTo(MeetingPoint, -100.0 * Math.Sin(angleZ), 100.0 * Math.Cos(angleZ))
                        Target.SetActorValue("WaitingForPlayer", 0)
                        Target.EvaluatePackage()
                        Target.SetAlert()
                        Target.SetAlert(false) 
                    endif  
                Endif
            endif
         endif   
         iIndex += 1
    EndWhile
    CleanUp()    
EndFunction    


Event OnMenuOpen(String MenuName)
    If MenuName == "ContainerMenu"
        ;Debug.Notification("ContainerMenu has been registered and has opened.")
        
        LastInventory = AliasActorTemp.getactorreference().GetContainerForms()
        
        ;Debug.MessageBox(LastInventory)
    EndIf
EndEvent



Event OnMenuClose(String MenuName)
        
    If MenuName == "ContainerMenu"
        ;Debug.Notification("ContainerMenu has been registered and has closed.")
        Form[] CurrentInventory = AliasActorTemp.getactorreference().GetContainerForms()
        
        
        
       int i = 0
       bool bBreak = False
       while (i < ActorManager.ActorAliasScripts.Length) && !bBreak
           ObjectReference ActorAliasRef = ActorManager.ActorAliasScripts[i].GetActorReference() As ObjectReference
           If ActorAliasRef == (AliasActorTemp.GetActorReference() As ObjectReference)
           
               
           ; remove items from array that the player removed from the inventory 
       
           int j = 0
           while (j < LastInventory.Length)
             Form OldItem = LastInventory[j]
             if CurrentInventory.Find(OldItem) < 0
                ActorManager.ActorAliasScripts[i].RemoveFromArray(OldItem)
            endif
            j += 1
        endWhile
               
               
               
           ; add new items to array that the player added to the inventory
           int k = 0
           While (k < currentInventory.Length)
            Form NewItem = currentInventory[k]
            if LastInventory.Find(NewItem) < 0 
                if (NewItem.GetType() == 41 || NewItem.GetType() == 26 || NewItem.GetType() == 42) ; weapons, armor, ammo
                    ;debug.notification(item.GetName())
                    ActorManager.ActorAliasScripts[i].AddToArray(NewItem)
                endif
            endif
            k += 1
            endWhile
        
            ActorManager.ActorAliasScripts[i].EquipCurrentOutfit()
            bBreak = True
            endif
            i += 1
        endwhile
        
        
        UnregisterForMenu("ContainerMenu")
        LastInventory = None
        CurrentInventory = None
        CleanUp()
        ;Debug.notification("done")
    EndIf
EndEvent