Scriptname BondOfFriendshipAutomaticTeleport extends activemagiceffect  




Actor  Property PlayerRef Auto
Spell Property BondOfFriendshipEthereal Auto
Faction Property CurrentFollowerFaction Auto
BondOfFriendshipActorManager Property ActorManager Auto

;Perk Property akPerk Auto
;import PO3_SKSEFunctions

Event OnEffectStart(Actor akTarget, Actor akCaster)
    
    if !akTarget.IsInCombat() && !PlayerRef.IsInCombat() && !akTarget.IsBleedingOut() && akTarget.GetCurrentScene() == None && akTarget.IsAIEnabled()
       
        int j = 0
        while (j < ActorManager.ActorAliasScripts.Length)
           ObjectReference ActorAliasRef = ActorManager.ActorAliasScripts[j].GetActorReference() As ObjectReference
           If ActorAliasRef == akTarget
               ActorManager.ActorAliasScripts[j].Teleporting()
               j = 999
           endif
           j += 1
        endwhile 
    endif
EndEvent    



    
    
    


;DISCARDED 1
;/Actor Target
Actor Property PlayerRef Auto
Float PosX
Float PosY
Float PosZ
Float fSpeed



Event OnEffectStart(Actor akTarget, Actor akCaster)
    Target = akTarget
    fSpeed = 3000.0
    PosX = PlayerRef.GetPositionX()
    PosY = PlayerRef.GetPositionY() - 150
    PosZ = PlayerRef.GetPositionZ()
    ;Debug.Notification("Automatic Teleport Effect")
    Target.SetAlpha(0)
    Target.SetGhost()
    Target.TranslateTo(PosX, PosY, PosZ, 0.0, 0.0, 0.0, fSpeed, 0.0)
    Utility.Wait(3)
    Target.SetAlpha(1)
    Utility.Wait(1)
    Target.SetGhost(False)
    ;Debug.Notification("SetGhost false")
EndEvent/;


;DISCARDED 2

;/
Event OnEffectStart(Actor akTarget, Actor akCaster)
    ;FormList CustomFollowers = ActorManager.BondOfFriendshipCustomFollowersList    
    ;if (akTarget.isinfaction(CurrentFollowerFaction) || akTarget.IsCommandedActor() == True) || CustomFollowers.HasForm(akTarget)
        if !akTarget.IsInCombat() && !PlayerRef.IsInCombat() && !akTarget.IsBleedingOut() && akTarget.GetCurrentScene() == None && akTarget.IsAIEnabled()
            if !PlayerRef.IsSneaking()
                akTarget.AddSpell(BondOfFriendshipEthereal)
                akTarget.moveto(PlayerRef, -100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()))
                akTarget.SetAlpha(0)
                Utility.Wait(1)
                akTarget.SetAlpha(1)
                Utility.Wait(5)
                akTarget.RemoveSpell(BondOfFriendshipEthereal)
               ;AddBasePerk(akTarget, akPerk)
            Else
                ;Debug.notification("test")
                akTarget.AddSpell(BondOfFriendshipEthereal)
                akTarget.SetAV("Invisibility", 1)
                akTarget.StartSneaking()
                Float AngleZ = PlayerRef.GetAngleZ()
                Float OffsetX = -120.0 * Math.Sin(AngleZ)
                Float OffsetY = -120.0 * Math.Cos(AngleZ)
                akTarget.moveto(PlayerRef, OffsetX, OffsetY, 0.0)
                akTarget.SetAlpha(0)
                Utility.Wait(1)
                akTarget.SetAlpha(1)
                Utility.Wait(5)
                akTarget.SetAV("Invisibility", 0)
                akTarget.RemoveSpell(BondOfFriendshipEthereal)   
            EndIf      
        endif
        ; endif
EndEvent    

    /;