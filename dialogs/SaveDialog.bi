#include once "../../gui/kogaion_gui.bi"
#include once "../../gui/kogaion_gui_classes.bi"

#include once "OpenDialogOptions.bas"

#ifndef OFN_ENABLEINCLUDENOTIFY
    Const OFN_ENABLEINCLUDENOTIFY = &H400000
#endif

type PSaveDialog as QSaveDialog Ptr
type QSaveDialog extends object
     private:
     protected:
     declare static function Hook(hDlg as HWND,Msg as UINT,wParam as WPARAM,lParam as LPARAM) as uinteger
     public:
     Owner        as PFrame
     InitialDir   as string
     Caption      as string
     DefaultExt   as string
     FileName     as string
     Filter       as string
     FilterIndex  as integer
     Handle       as HWND
     Options      as QOpenDialogOptions
     Center       as integer
     declare function Execute as integer
     declare operator cast as any ptr
     declare constructor
     declare destructor
     OnFolderChange    as sub(byref Sender as QSaveDialog)
     OnSelectionChange as sub(byref Sender as QSaveDialog)
     OnTypeChange      as sub(byref Sender as QSaveDialog,Index as integer)
end type