Scriptname BondOfFriendshipRequests extends activemagiceffect

Faction Property BondOfFriendshipAssigned Auto
EffectShader Property IllusionPositiveFXS Auto
Float Property ShaderDuration auto
BondOfFriendshipVariables Property Variables Auto
Actor Target
Actor Property PlayerRef Auto
Quest Property BondOfFriendshipRequestsQ Auto
BondOfFriendshipRequestsQScript Property Requests Auto
BondOfFriendshipActorManager Property ActorManager Auto
Message Property BondOfFriendshipMaxSlotsReached Auto
Message Property BondOfFriendshipHostileActor Auto
Message Property BondOfFriendshipMenuAssign Auto
Quest Property BondOfFriendshipActorManagerQ Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !BondOfFriendshipRequestsQ.isrunning()
        BondOfFriendshipRequestsQ.Start()
    endif
   

    Target = akTarget
    
    if Target.GetCurrentScene() != None
        Debug.MessageBox("The actor is currently in a scene. Therefore, the menu cannot be accessed.")
        Return
    else 
        if Target  && Target.GetCombatTarget() != PlayerRef  
            
            if Target.isinfaction(BondOfFriendshipAssigned) == 0
                if ActorManager.ActorSlots < 11 && ActorManager.ActorSlots > 0
                    ActorManager.StartLesserPower1Menu(abPleaseAssign = True)
                elseif ActorManager.ActorSlots == 0
                    BondOfFriendshipMaxSlotsReached.Show()
                endif    
            else
                Requests.AliasActorTemp.ForceRefTo(Target as ObjectReference)
                Requests.StartLesserPower3Menu()
            endif
        endif

         if Target && Target.GetCombatTarget() == PlayerRef
            ;Debug.Notification("This doesn't work on hostile actors.")
            BondOfFriendshipHostileActor.Show()
        endif
    endif
EndEvent


