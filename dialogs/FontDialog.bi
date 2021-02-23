#include once "win/commdlg.bi"
#include once "../../gui/kogaion_gui.bas"
#include once "../../gui/QFont.bi"

Type PFontDialog As QFontDialog Ptr
Type QFontDialog Extends QObject
     Private:
     Declare Static Function Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
     Public:
     Parent      As PFrame
     Caption     As String
     Center      As Integer
     Handle      As hwnd
     Font        As QFont
     MaxFontSize As Integer
     MinFontSize As Integer
     BackColor   As Integer
     Declare Function Execute As Integer
     Declare Operator Cast As Any Ptr
     Declare Constructor
     Declare Destructor
End Type
