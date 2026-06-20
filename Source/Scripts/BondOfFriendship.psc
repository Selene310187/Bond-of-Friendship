Scriptname BondOfFriendship extends activemagiceffect  


GlobalVariable Property BOFallies Auto
Faction Property BondOfFriendshipAllies Auto
Faction Property BondOfFriendshipAssigned Auto
Message Property BondOfFriendshipMenuAssign Auto
Message Property BondOfFriendshipMenuScanFollowers Auto
Message Property BondOfFriendshipMaxSlotsReached Auto
Message Property BondOfFriendshipHostileActor Auto
BondOfFriendshipActorManager Property ActorManager Auto
BondOfFriendshipVariables Property Variables Auto
Actor Property PlayerRef Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    Actor Target = akTarget
    if Target.GetCurrentScene() != None
        Debug.MessageBox("The actor is currently in a scene. Therefore, the menu cannot be accessed.")
        Return
    else 
        if Target && Target.GetCombatTarget() != PlayerRef
            if Target.isinfaction(BondOfFriendshipAssigned) == 0
                ActorManager.UpdateActorSlotsVariable()
                if ActorManager.ActorSlots < 11 && ActorManager.ActorSlots > 0
                    ActorManager.AliasActorTemp.ForceRefTo(Target as ObjectReference)
                    ActorManager.StartLesserPower1Menu(abStartWithAssign = true)
                elseif ActorManager.ActorSlots == 0
                    BondOfFriendshipMaxSlotsReached.Show()
                endif    
            else
                ActorManager.AliasActorTemp.ForceRefTo(Target as ObjectReference)
                ActorManager.StartLesserPower1Menu()
            endif
        endif 

        if Target && Target.GetCombatTarget() == PlayerRef
            BondOfFriendshipHostileActor.Show()
        endif
    endif
EndEvent





