Scriptname BondOfFriendshipDebugUtilityAOE extends activemagiceffect  


Actor Property PlayerRef Auto
Spell Property BondOfFriendshipDebugUtilityAimed Auto
BondOfFriendshipActorManager Property ActorManager Auto
Message Property BondOfFriendshipAOEAssign Auto
BondOfFriendshipVariables Property Variables Auto
Quest Property BondOfFriendshipDebugUtilityQ Auto
Quest Property BondOfFriendshipActorManagerQ Auto
BondOfFriendshipDebugUtilityQscript Property DebugUtility Auto



Event OnEffectStart(Actor target, Actor caster)
     if !BondOfFriendshipDebugUtilityQ.isrunning()
         BondOfFriendshipDebugUtilityQ.Start()
     endif
     if BondOfFriendshipActorManagerQ.isrunning() == 0
        BondOfFriendshipActorManagerQ.Start()
     endif
    
    Variables.CurrentLesserPower = 2
    
    if caster.IsWeaponDrawn()
    Variables.WeaponDrawn = True
        ActorManager.TargetActor()
    else
        Variables.WeaponDrawn = False
        if ActorManager.ActorSlots > 9
            ActorManager.StartLesserPower1Menu(abPleaseAssign = True)
        elseif ActorManager.ActorSlots < 10
            DebugUtility.CheckCurrentSlot()
            DebugUtility.StartLesserPower2Menu()
        endif
    endif    
EndEvent

 