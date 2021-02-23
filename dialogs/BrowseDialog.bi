#Include Once "Win/ShlObj.bi"
#Include Once "../../gui/kogaion_gui.bas"

Type PBrowseDialog As QBrowseDialog Ptr
Type QBrowseDialog Extends QObject
     Private:
     Declare Static Function Hook(hWnd As HWND,uMsg As uINT,lParam AS LPARAM,lpData As LPARAM) As Integer
     Public:
'     Parent     As PControl
     Handle     As Hwnd
     Caption    As String
     Title      As String
     InitialDir As String
     Directory  As String
     Center     As Integer
     Declare Function Execute As boolean
     Declare Operator Cast As Any Ptr
     Declare Constructor
     Declare Destructor
     OnSelectionChange As Sub(ByRef Sender As QBrowseDialog,Folder As Any Ptr)
End Type
