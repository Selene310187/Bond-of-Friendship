Scriptname BondOfFriendshipMaintenance extends Quest Conditional 


bool Property SKSEActive Auto Conditional
bool Property ConsoleUtilActive Auto Conditional
bool Property PapyrusExtenderActive Auto Conditional

Event OnInit()
    Maintenance()
EndEvent


 
Function Maintenance()  
   
; === checking if SKSE is installed

     If SKSE.GetVersion() > 0
        ;Debug.Notification("SKSE is installed.")
        Debug.Trace("[BondOfFriendship] Info: SKSE is installed.")
        SKSEActive = True
    Else
        ;Debug.Notification("SKSE is not installed.")
        Debug.Trace("[BondOfFriendship] Info: SKSE is not installed.")
        SKSEActive = False
    EndIf

; === checking if ConsoleUtil is installed

     If ConsoleUtil.GetVersion() > 0
        ;Debug.Notification("ConsoleUtil is installed.")
        Debug.Trace("[BondOfFriendship] Info: ConsoleUtil is installed.")
        ConsoleUtilActive = True
    Else
        ;Debug.Notification("ConsoleUtil is not installed.")
        Debug.Trace("[BondOfFriendship] Info: ConsoleUtil is not installed.")
        ConsoleUtilActive = False
    EndIf
    
; === checking if Papyrus Extender is installed    
    
    int[] versionArray = PO3_SKSEFunctions.GetPapyrusExtenderVersion()

    if versionArray == None
        ;Debug.Notification("Papyrus Extender is not installed.")
        Debug.Trace("[BondOfFriendship] Info: Papyrus Extender is not installed.")
        PapyrusExtenderActive = False
    else
        if versionArray[0] > 0
            ;Debug.Notification("Papyrus Extender is installed.")
            Debug.Trace("[BondOfFriendship] Info: Papyrus Extender v" + versionArray[0] + "." + versionArray[1] + " detected.")
            PapyrusExtenderActive = True
        endif
    endif

EndFunction