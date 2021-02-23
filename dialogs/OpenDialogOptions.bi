#Include once "Win/CommDlg.bi"

Enum QOpenDialogOption
    ofReadOnly            = OFN_READONLY 
    ofOverwritePrompt     = OFN_OVERWRITEPROMPT 
    ofHideReadOnly        = OFN_HIDEREADONLY
    ofNoChangeDir         = OFN_NOCHANGEDIR
    ofShowHelp            = OFN_SHOWHELP
    ofNoValidate          = OFN_NOVALIDATE 
    ofAllowMultiSelect    = OFN_ALLOWMULTISELECT
    ofExtensionDifferent  = OFN_EXTENSIONDIFFERENT 
    ofPathMustExist       = OFN_PATHMUSTEXIST 
    ofFileMustExist       = OFN_FILEMUSTEXIST 
    ofCreatePrompt        = OFN_CREATEPROMPT
    ofShareAware          = OFN_SHAREAWARE 
    ofNoReadOnlyReturn    = OFN_NOREADONLYRETURN 
    ofNoTestFileCreate    = OFN_NOTESTFILECREATE 
    ofNoNetworkButton     = OFN_NONETWORKBUTTON
    ofNoLongNames         = OFN_NOLONGNAMES 
    ofOldStyleDialog      = OFN_EXPLORER 
    ofNoDereferenceLinks  = OFN_NODEREFERENCELINKS 
    ofEnableIncludeNotify = OFN_ENABLEINCLUDENOTIFY
    ofEnableSizing        = OFN_ENABLESIZING
End Enum

Type POpenDialogOptions As QOpenDialogOptions
Type QOpenDialogOptions
    Count   As Integer
    Options As Integer Ptr
    Declare Sub Include(Value As Integer)
    Declare Sub Exclude(Value As Integer)
    Declare Operator Cast As Integer
End Type

