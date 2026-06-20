Scriptname BondOfFriendshipAddSpell extends Quest  


Spell Property BondOfFriendshipLesserPower Auto
Spell Property DebugUtilityLesserPower Auto
Spell Property RequestsLesserPower Auto
Actor Property PlayerRef Auto
Quest Property BondOfFriendshipAddSpellQ Auto

Event OnInit()
    PlayerRef.addspell(BondOfFriendshipLesserPower)
    PlayerRef.addspell(DebugUtilityLesserPower)
    PlayerRef.addspell(RequestsLesserPower)    
    BondOfFriendshipAddSpellQ.Stop()
EndEvent