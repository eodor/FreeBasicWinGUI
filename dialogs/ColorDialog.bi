#include once "win/commdlg.bi"
#include once "../../gui/kogaion_gui.bas"

Type PColorDialog As QColorDialog Ptr
Type QColorDialog Extends QObject
     Private:
     CC              As CHOOSECOLORA
     Declare Static Function Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
     Public:
     Parent          As PFrame
     Center          As Integer
     Handle          As Hwnd
     Caption         As String
     Color           As Integer
     Style           As Integer
     Colors(16)      As Integer => {&H0,&H808080,&H000080,&H008080,_
                                    &H008000,&H808000,&H800000,&H800080,_
                                    &HFFFFFF,&HC0C0C0,&H0000FF,&H00FFFF,_
                                    &H00FF00,&HFFFF00,&HFF0000,&HFF00FF _
                                   }
     BackColor       As Integer
     Declare Operator Cast As Any Ptr
     Declare Function Execute As Integer
     Declare Constructor
     Declare Destructor
End Type
