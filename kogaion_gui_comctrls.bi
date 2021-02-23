'kogaion_gui_comctrls.bi -library windows controls wrapper
'this file is part of Koganion(RqWork7) rad-ide
'and can't be redistributed without permission
'Copyright (c)2020 Vasile Eodor Nastasa
'mail: nastasa.eodor@gmail.com
'web:http://www.rqwork.de

#include once "kogaion_gui.bas"
#include once "kogaion_gui_classes.bas"

''register classes to ide
#Define ComCtrls_RegisterClasses "QToolBar,QStatusBar,QTabControl"

#Define Q_CustomToolBar(__ptr__) *cast(QCustomToolBar ptr, @__ptr__)
#Define W_CustomToolBar(__hwnd__) *cast(QCustomToolBar ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))
#Define Q_ToolBar(__ptr__) *cast(QToolBar ptr, @__ptr__)
#Define W_ToolBar(__hwnd__) *cast(QToolBar ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

#Define Q_CustomStatusBar(__ptr__) *cast(QCustomStatusBar ptr, @__ptr__)
#Define W_CustomStatusBar(__hwnd__) *cast(QCustomStatusBar ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))
#Define Q_StatusBar(__ptr__) *cast(QStatusBar ptr, @__ptr__)
#Define W_StatusBar(__hwnd__) *cast(QStatusBar ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

#Define Q_CustomTabControl(__ptr__) *cast(QCustomTabControl ptr, @__ptr__)
#Define W_CustomTabControl(__hwnd__) *cast(QCustomTabControl ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))
#Define Q_TabControl(__ptr__) *cast(QTabControl ptr, @__ptr__)
#Define W_TabControl(__hwnd__) *cast(TabControl ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

#Define Q_ToolButton(__ptr__) *cast(PToolButton,__ptr__)

#Define W_ToolButton(__tb__,__idx__)_
       orphanButton=new TBBUTTON :_
       SendMessage(__tb__,tb_getbutton,__idx__,cint(orphanButton)) :_
       *cast(PToolButton,orphanButton->ToolButton.dwData)

type PCustomToolBar as QCustomToolBar ptr
type PToolBar as QToolBar ptr
type PToolButton as QToolButton ptr
type PCustomStatusBar as QCustomStatusBar ptr
type PStatusBar as QStatusBar ptr
type PCustomTabConntrol as QCustomTabControl ptr
type PTabControl as QTabControl ptr

type TToolBar as QToolBar
common shared as PToolButton orphanButton

type LPNMTBGETINFOTIP as NMTBGETINFOTIP ptr

/' QImageList '/
Enum QDrawingStyle
     dsFocus       = ILD_FOCUS
     dsNormal      = ILD_NORMAL
     dsSelected    = ILD_SELECTED
     dsTransparent = ILD_TRANSPARENT
     dsBlend       = ILD_BLEND
     dsBlend25     = ILD_BLEND25
     dsBlend50     = ILD_BLEND50
End Enum

Enum QImageType
     itImage = 0
     itMask  = ILD_MASK
End Enum

type PImageList as QImageList ptr
Type QImageList extends QObject
    Protected:
    fFrame As PFrame
    FWidth        As Integer
    FHeight       As Integer
    FBKColor      As Integer
    FCount        As Integer
    Declare Sub Create
    Declare Sub NotifyControl
    Public:
    Handle        As HIMAGELIST
    AllocBy       As Integer
    ImageType     As QImageType
    DrawingStyle  As QDrawingStyle
    Declare Property Frame As PFrame
    Declare Property Frame(Value As PFrame)
    Declare Property Width As Integer
    Declare Property Width(Value As Integer)
    Declare Property Height As Integer
    Declare Property Height(Value As Integer)
    Declare Property BKColor As Integer
    Declare Property BKColor(Value As Integer)
    Declare Property Count As Integer
    Declare Sub AddBitmap(Bitmap As HBitmap,Mask As HBitmap)
    Declare Sub AddIcon(Icon As HIcon)
    Declare Sub AddCursor(Cursor As HCursor)
    Declare Sub AddMasked(Bitmap As HBitmap,MaskColor As Integer)
    Declare Sub Remove(Index As Integer)
    Declare Function GetBitmap(Index As Integer) As HBitmap
    Declare Function GetMask(Index As Integer) As HBitmap
    Declare Function GetIcon(Index As Integer) As HIcon
    Declare Function GetCursor(Index As Integer) As HCursor
    Declare Sub DrawEx(Index As Integer,DestDC As HDC,X As Integer,Y As Integer,iWidth As Integer,iHeight As Integer,FG As Integer,BK As Integer)
    Declare Sub Draw(Index As Integer,DestDC As HDC,X As Integer,Y As Integer)
    Declare Sub Clear
    Declare Operator Cast As Any Ptr
    Declare Constructor
    Declare Destructor
    OnChange As Sub(BYREF Sender As QImageList)
End Type

/' QCustomToolBar '/
type QCustomToolBar extends QFrame
    protected:
     as QList fButtons
     as integer fButtonWidth,fButtonHeight
     as boolean fTransparent, fFlat, fAdjustable
     as PImageList fimages,fhotimages,fdisabledimages
     as boolean fShowHints
     declare sub Click
     declare sub DblClick
     declare sub Change
     declare virtual sub CreateHandle
     declare virtual sub Dispatch(byref m as QMessage)
     declare static function dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
    public:
     as QCanvas Canvas
     declare sub Customize
     declare function Add(as string ="",as integer=tbstyle_button) as PToolButton
     declare function Insert(as integer,as string="",as integer=tbstyle_button) as PToolButton
     declare sub Insert overload(as integer,as PToolButton)
     declare sub Add overload(as PToolButton)
     declare sub Remove(as integer)
     declare sub Remove overload(as PToolButton)
     declare sub Clear
     declare function indexOf(v as PToolButton) as integer
     declare property ButtonCount as integer
     declare property ButtonCount (as integer)
     declare property Buttons as PList
     declare property Buttons (as PList)
     declare property Button(index as integer) as PToolButton
     declare property Button(index as integer,as PToolButton)
     declare property ShowHints as boolean
     declare property ShowHints (as boolean)
     declare property Images as PImageList
     declare property Images (as PImageList)
     declare property Adjustable as boolean
     declare property Adjustable (as boolean)
     declare property Flat as boolean
     declare property Flat (as boolean)
     declare property Transparent as boolean
     declare property Transparent (as boolean)
     declare property ButtonWidth as integer
     declare property ButtonWidth (as integer)
     declare property ButtonHeight as integer
     declare property ButtonHeight (as integer)
     declare virtual operator cast as any ptr
     declare constructor
     declare destructor
     onChange as QEvent
end type

type QToolBar extends QCustomToolBar
    declare static function Register as integer
    declare virtual operator cast as any ptr
    declare operator cast as hwnd
    declare constructor
end type

/' QToolButton '/
enum QToolButtonStyle
    tbsNormal=tbstyle_button
    tbsSeparator=tbstyle_sep
    tbsGrouped=tbstyle_group
    tbsAlowUpDown=tbstyle_check
    tbsDropDown=tbstyle_dropdown
    tbsList=tbstyle_list
end enum
enum QToolButtonState
     tstChecked=tbstate_checked
     tstHiden=tbstate_hidden
     tstEnabled=tbstate_enabled
end enum
type QToolButton extends QObject
    protected:
    as TBBUTTON fTBButton
    as PToolBar fToolBar
    as string fHint
    as boolean fShowHint
    as boolean fEnabled, fVisible
    as QToolButtonStyle fStyle
    as QToolButtonState fState
    as integer fImageIndex,fHotIndex,fDisabledIndex
    public:
    as integer index
    declare property ToolButton byref as TBBUTTON
    declare property ToolBar byref as QToolBar
    declare property ToolBar (byref as QToolBar)
    declare property ImageIndex as integer
    declare property ImageIndex(as integer)
    declare property Style as integer
    declare property Style (as integer)
    declare property Caption as string
    declare property Caption (as string)
    declare property Hint as string
    declare property Hint (as string)
    declare property ShowHint as boolean
    declare property ShowHint (as boolean)
    declare property Enabled as boolean
    declare property Enabled (as boolean)
    declare property Visible as boolean
    declare property Visible (as boolean)
    declare operator cast as any ptr
    declare operator cast as integer
    declare operator cast as TBBUTTON
    declare constructor
    declare destructor
end type

type PCustomStatusBar as QCustomStatusBar ptr
type PStatusBar as QStatusBar ptr
type PStatusPanel as QStatusPanel ptr

type TStatusPanel as QStatusPanel

/' QCustomStatusBar '/
type QCustomStatusBar extends QFrame
    protected:
     as integer ptr fParts
     as integer fCount
     as PStatusPanel ptr fPanels
     declare sub Click
     declare virtual sub CreateHandle
     declare virtual sub Dispatch(byref m as QMessage) 
     declare static function dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
    public:
     as QCanvas Canvas
     declare function Add as PStatusPanel
     declare sub Clear
     declare property Count as integer
     declare property Panels as PStatusPanel ptr
     declare property Panels (as PStatusPanel ptr)
     declare property Panel (as integer)byref as TStatusPanel
     declare virtual operator cast as any ptr
     declare constructor
end type

/'QStatusBar '/
type QStatusBar extends QCustomStatusBar
    declare static function Register as integer
    declare virtual operator cast as any ptr
    declare operator cast as hwnd
    declare constructor
end type

/' QStatusPanel '/
type QStatusPanel extends QObject
    protected:
    as QAlignment fAlignment
    as integer fcx
    as string fText
    as PStatusBar fStatusBar
    public:
    as integer index
    declare property StatusBar byref as QStatusBar
    declare property StatusBar (byref as QStatusBar)
    declare property Width as integer
    declare property width (as integer)
    declare property Alignment as QAlignment
    declare property Alignment (as QAlignment)
    declare property Text as string
    declare property Text (as string)
    declare operator cast as any ptr
    declare operator cast as integer
    declare constructor
end type


/' QCustomTabControl '/
type QCustomTabControl extends QFrame
    protected:
     declare sub Change
     declare virtual sub CreateHandle
     declare virtual sub Dispatch(byref m as QMessage) 
     declare static function dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
    public:
     as QCanvas Canvas  
     declare virtual operator cast as any ptr
     declare constructor
end type

/' QTabControl '/
type QTabControl extends QCustomTabControl
    declare static function Register as integer
    declare virtual operator cast as any ptr
    declare operator cast as hwnd
    declare constructor
end type
