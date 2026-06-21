Scriptname BondOfFriendshipDebugUtility extends activemagiceffect  


EffectShader Property IllusionPositiveFXS Auto
Float Property ShaderDuration auto
BondOfFriendshipVariables Property Variables Auto
Actor Target
Quest Property BondOfFriendshipDebugUtilityQ Auto
BondOfFriendshipDebugUtilityQscript Property DebugUtility Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !BondOfFriendshipDebugUtilityQ.isrunning()
        BondOfFriendshipDebugUtilityQ.Start()
    endif
    
    
    Target = akTarget
    if Target.GetCurrentScene() != None
        Debug.MessageBox("The actor is currently in a scene. Therefore, the menu cannot be accessed.")
        Return
    else 
        if Target
            DebugUtility.BondOfFriendshipSlotCurrent.ForceRefTo(Target as ObjectReference)
            DebugUtility.StartLesserPower2Menu(AOE = False)
        endif
    endif    
EndEvent

  
