Scriptname BondOfFriendshipAlias extends ReferenceAlias 

BondOfFriendshipActorManager Property ActorManager Auto
BondOfFriendshipVariables Property Variables Auto
Faction Property CurrentFollowerFaction Auto
Actor Property PlayerRef Auto
Spell Property BondOfFriendshipAutomaticTeleportSpell Auto 
Spell Property BondOfFriendshipEthereal Auto
Spell Property BondOfFriendshipAbility Auto
EffectShader Property IllusionPositiveFXS Auto
Float Property ShaderDuration Auto
GlobalVariable Property BOFshader Auto
GlobalVariable Property BOFoutfit Auto
Form[] CurrentOutfitList
bool ActorWasDisabled
Faction Property BondOfFriendshipQuickM Auto
BondOfFriendshipRequestsQScript Property Requests Auto
Quest Property BondOfFriendshipRequestsQ Auto
bool ReEquipping
bool Property IsTeleporting Auto
BondOfFriendshipMaintenance Property Maintenance Auto


Event OnSpellCast(Form akSpell)
    Spell castedSpell = akSpell as Spell
    GoToState("Busy")
    
    if Maintenance.PapyrusExtenderActive == True
        if castedSpell
            int i = castedSpell.GetNumEffects() - 1

            While i > -1
                if ( castedSpell.GetNthEffectMagicEffect(i) ) && ( castedSpell.GetNthEffectMagicEffect(i).GetAssociatedSkill() == "Conjuration" )
                    GetSummon()
                endif
            i -= 1
            EndWhile
        endif
    endif
    RegisterForSingleUpdate(1.0)
EndEvent

State Busy
    Event OnUpdate()
        GotoState("")
        UnregisterForUpdate()
    EndEvent
EndState


Function GetSummon(INT iLoopIterations = 15, Float fAreaToSearch = 3000.0)
   
    While iLoopIterations > 0
        Actor Summoned = Game.FindRandomActorFromRef(PlayerRef, fAreaToSearch)
        iLoopIterations -= 1
        if Summoned && Summoned != PlayerRef && Summoned.IsCommandedActor() && !Summoned.IsHostileToActor(PlayerRef) && PO3_SKSEFunctions.GetCommandingActor(Summoned) == Self.getactorreference()
            iLoopIterations = 0
            ;Debug.Notification("Follower has summoned "+Summoned.GetActorBase().GetName())
            Summoned.AddSpell(ActorManager.BondOfFriendshipAbility)
        endif
    EndWhile
EndFunction

Event OnActivate(ObjectReference akActionRef)
    if akActionRef == PlayerRef
        Actor Follower = Self.getactorreference()
        if Follower.IsInFaction(BondOfFriendshipQuickM)
            if BondOfFriendshipRequestsQ.isrunning() == 0
                BondOfFriendshipRequestsQ.Start()
            EndIf
            Requests.AliasActorTemp.ForceRefTo(Self.getactorreference() as ObjectReference)
            Requests.RequestsMenu()
        endif    
    endif
EndEvent

Event OnUpdate()
    if ReEquipping == True
        EquipCurrentOutfit()
        ReEquipping = False
        UnregisterForUpdate()
    EndIf   
EndEvent   


Event OnDying(Actor akKiller) ; OnDeath didn't work on Dead Thralls, OnDying did work
    ActorManager.ClearSlot(Self.GetActorReference() as ObjectReference)
EndEvent


Event OnCellDetach()
    Actor Follower = Self.getactorreference()
    if Follower.HasSpell(BondOfFriendshipAutomaticTeleportSpell) == 1 && Follower.GetActorValue("WaitingForPlayer") == 0 && Follower.IsAIEnabled()
        
       if !Follower.IsInCombat() && !PlayerRef.IsInCombat() && !Follower.IsBleedingOut() && Follower.GetCurrentScene() == None
          
            If Follower.IsCommandedActor() == True
                Teleporting()
            EndIf
       endif
    EndIf
EndEvent 


Event OnUnload()
    
    
    Actor akTarget = Self.GetActorReference()
    If akTarget.IsDisabled() == True
        ActorWasDisabled = True
    EndIf

    Actor Follower = Self.GetActorReference()
    
    If Follower.HasSpell(BondOfFriendshipAutomaticTeleportSpell) == 1 && Follower.GetActorValue("WaitingForPlayer") == 0 && Follower.IsAIEnabled()
        If Follower.IsCommandedActor() == True
            If !Follower.IsInCombat() && !PlayerRef.IsInCombat() && !Follower.IsBleedingOut() && Follower.GetCurrentScene() == None
                ;Debug.Notification("OnUnload")
                Teleporting()
            EndIf
        EndIf
    EndIf  

EndEvent  

Event OnLoad()
    Actor akTarget = Self.GetActorReference()
    if ActorWasDisabled == True
        ActorWasDisabled = False
    endif
EndEvent 

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    Actor Follower = Self.getactorreference()
    
    if !Follower || !akTarget || aeCombatState != 1
        return
    endif
    
    Actor targetActor = akTarget as Actor
    if !targetActor || !Follower.HasSpell(BondOfFriendshipAbility)
        return
    endif 
    
    
    Race SpectralDrumRace = Game.GetFormFromFile(0x00029EFC, "Dragonborn.esm") as Race
    bool shouldStopCombat = false
    
    if Follower.HasSpell(BondOfFriendshipAbility) && aeCombatState == 1
        if targetActor.HasSpell(BondOfFriendshipAbility)
            shouldStopCombat = true
        endif    
        if !targetActor.IsHostileToActor(PlayerRef) && !targetActor.HasSpell(BondOfFriendshipAbility) && targetActor != PlayerRef
            If targetActor.GetActorValue("Aggression") < 2.0
                If targetActor.GetCrimeFaction() != None
                    shouldStopCombat = True
                EndIf
            EndIf
        endif    
        if targetActor.IsCommandedActor() && !targetActor.IsHostileToActor(PlayerRef)
            shouldStopCombat = true
        endif    
        if SpectralDrumRace && targetActor.GetRace() == SpectralDrumRace
            shouldStopCombat = true
        endif    
       
        
        if shouldStopCombat
            Follower.StopCombat()
            Follower.StopCombatAlarm()
            targetActor.StopCombat()
            targetActor.StopCombatAlarm()
            if BOFshader.getvalueint() == 1
                IllusionPositiveFXS.Play(Follower, ShaderDuration)
                IllusionPositiveFXS.Play(targetActor, ShaderDuration)
            EndIf
            if ActorManager.BOFmessage.getvalueint() == 1
                if Follower.IsCommandedActor()
                    if IsLeveledActor(Follower) == false
                        Debug.Notification(Follower.GetActorBase().GetName()+" has been calmed.")
                    else
                        Debug.Notification(Follower.GetLeveledActorBase().GetName()+" has been calmed.")
                    endif    
                endif
                if targetActor.IsCommandedActor()
                    if IsLeveledActor(targetActor) == false
                        Debug.Notification(targetActor.GetActorBase().GetName()+" has been calmed.")
                    else
                        Debug.Notification(targetActor.GetLeveledActorBase().GetName()+" has been calmed.")
                    endif     
                endif 
            endif
        EndIf
    EndIf   
EndEvent        

Function ReEquip()
    ReEquipping = True
    RegisterForSingleUpdate(0.5)
EndFunction    

Function EquipCurrentOutfit()
    Actor Follower = self.getactorreference()
    int index = 0
    while index < CurrentOutfitList.Length
        if Follower.GetItemCount(CurrentOutfitList[index]) < 1
            Follower.AddItem(CurrentOutfitList[index], 1, true)
            endif
        
        if Follower.IsEquipped(CurrentOutfitList[index]) == 0
            Follower.equipitem(CurrentOutfitList[index])
        EndIf
        index += 1
    EndWhile
    if Follower.IsCommandedActor()
        if Follower.GetWornForm(0x00000004) == None
             Follower.AddItem(Requests.DummyItem, 1, true)
             Follower.EquipItem(Requests.DummyItem, false, true)
             Utility.Wait(0.1)
             Follower.RemoveItem(Requests.DummyItem, 1, true) 
         endif    
    EndIf
EndFunction


Function AddToArray(Form CurrentForm)
    if !CurrentOutfitList
            CurrentOutfitList = new Form[10]
    endif
    
    
    int i = CurrentOutfitList.Find(None)
    bool AlreadyListed = false
            
    int index = 0
    while index < CurrentOutfitList.Length
        if CurrentOutfitList[index] == CurrentForm
            AlreadyListed = true
        endif
        index += 1
    EndWhile
    
    if !AlreadyListed 
        CurrentOutfitList[i] = CurrentForm
        ;debug.notification(CurrentForm.GetName())
    EndIf
EndFunction


Function RemoveFromArray(Form CurrentForm)
    int i = CurrentOutfitList.Find(CurrentForm)
    ;debug.notification(CurrentOutfitList[i].GetName())
    CurrentOutfitList[i] = None
EndFunction

Function ClearArray()
    if CurrentOutfitList
        CurrentOutfitList = None
        ;debug.notification("array cleared")
    endif    
EndFunction   


Bool Function isLeveledActor(Actor akActor)
    If akActor.GetLeveledActorBase().GetFormID() < 0
        Return True
    EndIf
    Return False
EndFunction



Function Teleporting()
   
    Actor Follower = Self.GetActorReference()
    
    ;Debug.Notification(Follower.GetActorBase().GetName()+" has been teleported.")

    if Maintenance.PapyrusExtenderActive == 1
        if ActorManager.IsPlayerFollower(Follower as Actor) || ActorManager.IsPlayerSummon(Follower as Actor)
            If !PlayerRef.IsSneaking()
                Follower.AddSpell(ActorManager.BondOfFriendshipEthereal)
                Follower.MoveTo(PlayerRef, -100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()))
                Follower.SetAlpha(0)
                
                Utility.Wait(1)
                
                if Follower.IsInFaction(Requests.BondOfFriendshipAutoEquip)
                    EquipCurrentOutfit()
                endif
                
                Follower.SetAlpha(1)
                Utility.Wait(5)
                Follower.RemoveSpell(ActorManager.BondOfFriendshipEthereal)
            Else
                Follower.AddSpell(ActorManager.BondOfFriendshipEthereal)
                Follower.SetAV("Invisibility", 1)
                Follower.StartSneaking()
                Float AngleZ = PlayerRef.GetAngleZ()
                Float OffsetX = -120.0 * Math.Sin(AngleZ)
                Float OffsetY = 120.0 * Math.Cos(AngleZ)
                Follower.MoveTo(PlayerRef, OffsetX, OffsetY, 0.0)
                Follower.SetAlpha(0)
                Utility.Wait(1)
                
                if Follower.IsInFaction(Requests.BondOfFriendshipAutoEquip)
                    EquipCurrentOutfit()
                endif
                
                Follower.SetAlpha(1)
                Utility.Wait(5)
                Follower.SetAV("Invisibility", 0)
                Follower.RemoveSpell(ActorManager.BondOfFriendshipEthereal)   
            EndIf
        Endif
    endif
    
    if Maintenance.PapyrusExtenderActive == 0 
        if Follower.IsInFaction(ActorManager.CurrentFollowerFaction) || Follower.IsCommandedActor()
            If !PlayerRef.IsSneaking()
                Follower.AddSpell(ActorManager.BondOfFriendshipEthereal)
                Follower.MoveTo(PlayerRef, -100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()))
                Follower.SetAlpha(0)
                
                Utility.Wait(1)
                
                if Follower.IsInFaction(Requests.BondOfFriendshipAutoEquip)
                    EquipCurrentOutfit()
                endif
                
                Follower.SetAlpha(1)
                Utility.Wait(5)
                Follower.RemoveSpell(ActorManager.BondOfFriendshipEthereal)
            Else
                Follower.AddSpell(ActorManager.BondOfFriendshipEthereal)
                Follower.SetAV("Invisibility", 1)
                Follower.StartSneaking()
                Float AngleZ = PlayerRef.GetAngleZ()
                Float OffsetX = -120.0 * Math.Sin(AngleZ)
                Float OffsetY = 120.0 * Math.Cos(AngleZ)
                Follower.MoveTo(PlayerRef, OffsetX, OffsetY, 0.0)
                Follower.SetAlpha(0)
                Utility.Wait(1)
                
                if Follower.IsInFaction(Requests.BondOfFriendshipAutoEquip)
                    EquipCurrentOutfit()
                endif
                
                Follower.SetAlpha(1)
                Utility.Wait(5)
                Follower.SetAV("Invisibility", 0)
                Follower.RemoveSpell(ActorManager.BondOfFriendshipEthereal)   
            EndIf
        Endif
    Endif 
EndFunction 

