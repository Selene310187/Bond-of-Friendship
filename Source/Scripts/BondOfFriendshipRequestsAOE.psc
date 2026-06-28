Scriptname BondOfFriendshipRequestsAOE extends activemagiceffect  


Actor Property PlayerRef Auto
Spell Property BondOfFriendshipRequestsAimed Auto
BondOfFriendshipActorManager Property ActorManager Auto
Message Property BondOfFriendshipAOEAssign Auto
BondOfFriendshipVariables Property Variables Auto
Quest Property BondOfFriendshipRequestsQ Auto
BondOfFriendshipRequestsQScript Property Requests Auto
Quest Property BondOfFriendshipActorManagerQ Auto

Event OnEffectStart(Actor target, Actor caster)
    If   !BondOfFriendshipRequestsQ.isrunning()
        BondOfFriendshipRequestsQ.Start()
    endif
    if BondOfFriendshipActorManagerQ.isrunning() == 0
        BondOfFriendshipActorManagerQ.Start()
    endif
    
    Variables.CurrentLesserPower = 3
    
    if caster.IsWeaponDrawn()
        Variables.WeaponDrawn = True
        ActorManager.TargetActor()
    else
        Variables.WeaponDrawn = False
        if ActorManager.ActorSlots > 9
            ActorManager.StartLesserPower1Menu(abPleaseAssign = True)
        elseif ActorManager.ActorSlots < 10
            Requests.StartLesserPower3Menu(AOE = True)
        endif
    endif    
EndEvent


    