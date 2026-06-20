Scriptname BondOfFriendshipStartMaintenance  extends ReferenceAlias 

Quest Property BondOfFriendshipMaintenanceQ Auto


Event OnPlayerLoadGame()
        
    BondOfFriendshipMaintenance maintenanceScript = BondOfFriendshipMaintenanceQ as BondOfFriendshipMaintenance
    
    if maintenanceScript
        maintenanceScript.Maintenance()
    endif
     
EndEvent