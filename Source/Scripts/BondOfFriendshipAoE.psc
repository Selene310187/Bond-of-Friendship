Scriptname BondOfFriendshipAoE extends activemagiceffect  


Actor Property PlayerRef Auto
Message Property BondOfFriendshipMenuMainAOE Auto
Message Property BondOfFriendshipMenuFriendlyHits Auto
Message Property BondOfFriendshipMenuKnockoutPrevention Auto
Message Property BondOfFriendshipMenuAutomaticCalm Auto
Message Property BondOfFriendshipMenuAutoTeleport Auto
Message Property BondOfFriendshipMenuMakeImmortal Auto
Message Property BondOfFriendshipFeatureDone Auto
Message Property BondOfFriendshipFeatureAlreadyActivated Auto
Message Property BondOfFriendshipSlotsCleared Auto
Message Property BondOfFriendshipAOEAssign Auto
BondOfFriendshipVariables Property Variables Auto
BondOfFriendshipActorManager Property ActorManager Auto
Quest Property BondOfFriendshipActorManagerQ Auto
Spell Property BondOfFriendshipSpell Auto
int FeatureCounter
Message Property BondOfFriendshipAOEAssignHowTo Auto
Message Property BondOfFriendshipAOEAssignCooldown Auto
GlobalVariable Property BOFallies Auto
GlobalVariable Property BOFoutfit Auto
GlobalVariable Property BOFshader Auto
Message Property BondOfFriendshipMenuSettings Auto
Message Property BondOfFriendshipMenuMainP2 Auto
Faction Property BondOfFriendshipQuickM Auto
Message Property BondOfFriendshipMenuQuickM Auto
Message Property BondOfFriendshipMenuTeammate Auto
Message Property BondOfFriendshipMenuAutoEquip Auto
Faction Property BondOfFriendshipAutoEquip Auto
GlobalVariable Property BOFmessage Auto
Message Property BondOfFriendshipMenuScanFollowers Auto



Event OnEffectStart(Actor target, Actor caster)
    if BondOfFriendshipActorManagerQ.isrunning() == 0
        BondOfFriendshipActorManagerQ.Start()
    endif
    
    Variables.CurrentLesserPower = 1
    
    if caster.IsWeaponDrawn()
        Variables.WeaponDrawn = True
        ActorManager.TargetActor()
    else
        Variables.WeaponDrawn = False
        if ActorManager.ActorSlots > 9
            ActorManager.StartLesserPower1Menu(abPleaseAssign = True)
        elseif ActorManager.ActorSlots < 10    
            ActorManager.StartLesserPower1Menu()
        endif
    endif    
EndEvent



