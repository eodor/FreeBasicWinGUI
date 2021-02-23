#include once "../../gui/kogaion_gui.bi"
#include once "../../gui/kogaion_gui_classes.bi"

#include once "OpenDialogOptions.bas"

#ifndef OFN_ENABLEINCLUDENOTIFY
    Const OFN_ENABLEINCLUDENOTIFY = &H400000
#endif

Type POpenDialog As QOpenDialog Ptr
Type QOpenDialog extends object
     Private:
     Declare Static Function Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
     Public:
     Parent       As PFrame
     InitialDir   As String
     Caption      As String
     DefaultExt   As String
     FileName     As String
     Filter       As String
     FilterIndex  As Integer
     Handle       As HWND
     Options      As QOpenDialogOptions
     Center       As Integer
     Files        as QStrings
     Declare Function Execute As Integer
     Declare Operator Cast As Any Ptr
     Declare Constructor
     Declare Destructor
     OnFolderChange    As Sub(ByRef Sender As QOpenDialog)
     OnSelectionChange As Sub(ByRef Sender As QOpenDialog)
     OnTypeChange      As Sub(ByRef Sender As QOpenDialog,Index As Integer)
End Type
