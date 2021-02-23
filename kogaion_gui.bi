'koganion_gui.bi -library windows controls wrapper
'this file is part of Koganion(RqWork7) rad-ide
'and can't be redistributed without permission
'Copyright (c)2020 Vasile Eodor Nastasa
'mail: nastasa.eodor@gmail.com
'web:http://www.rqwork.de

#define Debuginfo /'false'/ true

#if defined(RecreateOnStyleApply)=0 
common shared as boolean RecreateOnStyleApply
#endif

#include once "windows.bi"
#include once "win/CommCtrl.bi"
#include once "kogaion_gui_sysutils.bas"
#include once "designer\designer.bi"

''local instances and default cursor
#define instance GetModuleHandle(0)

#define crDefault LoadCursor(0,idc_arrow)

#DEFINE crArrow       LoadCursor(0,IDC_ARROW)
#DEFINE crAppStarting LoadCursor(0,IDC_APPSTARTING)
#DEFINE crCross       LoadCursor(0,IDC_CROSS)
#DEFINE crIBeam       LoadCursor(0,IDC_IBEAM)
#DEFINE crIcon        LoadCursor(0,IDC_ICON)
#DEFINE crNo          LoadCursor(0,IDC_NO)
#DEFINE crSize        LoadCursor(0,IDC_SIZE)
#DEFINE crSizeAll     LoadCursor(0,IDC_SIZEALL)
#DEFINE crSizeNESW    LoadCursor(0,IDC_SIZENESW)
#DEFINE crSizeNS      LoadCursor(0,IDC_SIZENS)
#DEFINE crSizeNVSE    LoadCursor(0,IDC_SIZENWSE)
#DEFINE crSizeWE      LoadCursor(0,IDC_SIZEWE)
#DEFINE crUpArrow     LoadCursor(0,IDC_UPARROW)
#DEFINE crWait        LoadCursor(0,IDC_WAIT)

#define clBtnFace GetSysColor(color_btnface)
#define clWindow GetSysColor(color_window)
#define clWindowText GetSysColor(color_windowtext)

#define P_Point(x,y) cast(point ptr,type<point>(x,y))
#define Q_Point(x,y) *cast(point ptr,type<point>(x,y))

'''define casting types
#Define Q_Object(__ptr__) *cast(QObject ptr, @__ptr__)
#Define W_Object(__hwnd__) *cast(QObject ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

#Define Q_ClassObject(__ptr__) *cast(QClassObject ptr, @__ptr__)
#Define W_ClassObject(__hwnd__) *cast(QClassObject ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

#Define Q_Frame(__ptr__) *cast(QFrame ptr, @__ptr__)
#Define W_Frame(__hwnd__) *cast(QFrame ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

#Define Q_CustomForm(__ptr__) *cast(QCustomForm ptr, @__ptr__)
#define W_CustomForm(dlg) *cast(PCustomForm, GetWindowLong(dlg,GetClassLong(dlg,gcl_cbwndextra)-4))

dim as OSVERSIONINFO os
os.dwOSVersionInfoSize=sizeof(os)
if GetVersionEx(@os) then
   if os.dwMajorVersion>=6 then
      RecreateOnStyleApply=true
   else
      RecreateOnStyleApply=false   
   end if
end if

''the windows 10 bug was fixed
RecreateOnStyleApply=false

type PObject as QObject ptr
type PClassObject as QClassObject ptr
type PFrame as QFrame ptr 
type PCustomForm as QCustomForm ptr
type PApplication as QApplication ptr

common shared as PClassObject CreationData
common shared as PApplication IApplication

#Define Application *(iApplication)

const CM_COMMAND      = WM_APP+100
const CM_CTLCOLOR     = WM_APP+101
const CM_NOTIFY       = WM_APP+102
const CM_PARENTNOTIFY = WM_APP+103
const CM_HSCROLL      = WM_APP+104
const CM_VSCROLL      = WM_APP+105
const CM_LBUTTONUP    = WM_APP+106
const CM_LBUTTODOWN   = WM_APP+107
const CM_MOUSEMOVE    = WM_APP+108

const RTTI_SET =wm_app+10000
const RTTI_GET =wm_app+10001

const STP_WNDPROC = "@@@_PROC"

declare function MainWindow as hwnd
declare sub ShowMessage(as string)
declare function messageDlg(as string,as string,as integer) as integer
declare function SysErrorMessage(as integer=GetLastError) as string
declare function ClassNameIs(as hwnd) as string

type PCreationParams as QCreationParams ptr
type QCreationParams
    as string  ClassName
    as string  ClassAncestor
    as integer ExStyle
    as integer Style
    as integer cx
    as integer cy
    as wndproc Proc
    as any ptr lpData '''reserved
end type

common shared as PCreationParams CreationParams

#define Q_CreationParams(__ptr__) *cast(PCreationParams,__ptr__)

type PCanvasMessage as QCanvasMessage ptr
type QCanvasMessage
    Handle as hdc
    ps     as paintstruct ptr
end type

type QMessage
     dlg      as hwnd
     msg      as uint
     wparam   as wparam
     lparam   as lparam
     result   as lresult
     Sender   as PObject
     Captured as PClassObject
     Painted  as PCanvasMessage
end type

type QObject extends object 
    protected:
    as integer fObjectCount
    as PObject ptr fObjects
    as string fName
    public:
    as string ClassName
    declare function FindObject(v as PObject) as integer
    declare sub AddObject(as PObject)
    declare sub RemoveObject(as PObject)
    declare property Name as string
    declare property Name(as string)
    as any ptr TagPtr
    as integer Tag
    declare operator cast as any ptr
    as sub(byref as QObject) onNameChanged
end type

type QClassObject extends QObject
    private:
     as toolinfo fToolInfo
    protected:
     as string fHint
     as hwnd fHandle, fToolHandle
     as rect fClientRect, fWindowRect
     as PFrame fParent
     as hwnd fParentWindow
     as string fText
     as integer fStyle, fExStyle, fID, fx, fy, fcx, fcy
     as boolean fEnabled, fVisible, fGrouped, fTabStop, fdesignmode, fClipped, fDoubleBuffered, fShowHint
     as wndproc fdlgproc
     declare sub AllocateHint
    public:
    as PClassObject Captured
    as string ClassAncestor
    declare sub Init(as hwnd)
    declare abstract function ReadProperty(byref p as string) as any ptr
    declare abstract function WriteProperty(byref p as string, v as any ptr) as boolean
    declare abstract sub Create
    declare abstract sub RegisterProc(as wndproc)
    declare abstract sub CreateHandle
    declare abstract sub ReCreateHandle
    declare abstract sub DestroyHandle
    declare abstract sub Dispatch(byref as QMessage)
    declare abstract sub DefaultHandler(byref as QMessage)
    declare property Handle as hwnd
    declare property Handle (as hwnd)
    declare property Hint as string
    declare property Hint(as string)
    declare property ShowHint as boolean
    declare property ShowHint(as boolean)
    declare abstract operator cast as any ptr
end type

#include once "kogaion_gui_classes.bas"
'
type PCommandAllocator as QCommandAllocator ptr
type QCommandAllocator extends QList
    public:
    as integer StartWith=0
    declare function AllocateCID as integer
    declare operator cast as integer
    declare constructor
end type

common shared as PCommandAllocator iCAL
iCAL=new QCommandAllocator

#define qCAL *(iCAL)

type QEvent as sub(byref as QObject)
type QCloseEvent as sub(byref as QObject,byref as integer)
type QMouseDownEvent as sub(byref as QObject,as byte,as integer,as integer,as integer)
type QMouseUpEvent as sub(byref as QObject,as byte,as integer,as integer,as integer)
type QMouseWheelEvent as sub(byref as QObject,as byte,as integer,as integer,as integer)
type QMouseMoveEvent as sub(byref as QObject,as byte,as integer,as integer)
type QKeyDownEvent as sub(byref as QObject,as word,as integer)
type QKeyUpEvent as sub(byref as QObject,as word,as integer)
type QKeyPressEvent as sub(byref as QObject,as byte)
type QCommandEvent as sub(byref as QObject,as byte,as integer,as hwnd)
type QMenuEvent as sub(byref as QObject,as integer,as integer)
type QAccelEvent as sub(byref as QObject,as integer,as integer)
type QMouseWheel as sub(byref as QObject,as integer,as integer,as integer,as integer) 
type QScrollEvent as sub(byref as QObject,as integer,byref as integer)

type PCanvas as QCanvas ptr

Enum QFillStyle
    fsSurface = FLOODFILLSURFACE
    fsBorder  = FLOODFILLBORDER
End Enum

Enum QPenStyle
    psSolid       = PS_SOLID
    psDash        = PS_DASH
    psDot         = PS_DOT
    psDashDot     = PS_DASHDOT
    psDashDotDot  = PS_DASHDOTDOT
    psClear       = PS_NULL
    psInsideFrame = PS_INSIDEFRAME
End Enum

Enum QPenMode
    pmBlack       = R2_BLACK
    pmWhite       = R2_WHITE
    pmNop         = R2_NOP
    pmNot         = R2_NOT
    pmCopy        = R2_COPYPEN
    pmNotCopy     = R2_NOTCOPYPEN
    pmMergePenNot = R2_MERGEPENNOT
    pmMaskPenNot  = R2_MASKPENNOT
    pmMergeNotPen = R2_MERGENOTPEN
    pmMaskNotPen  = R2_MASKNOTPEN
    pmMerge       = R2_MERGEPEN
    pmNotMerge    = R2_NOTMERGEPEN
    pmMask        = R2_MASKPEN
    pmNotMask     = R2_NOTMASKPEN
    pmXor         = R2_XORPEN
    pmNotXor      = R2_NOTXORPEN
End Enum

type QCustomCanvas extends QObject
    protected:
    as PFrame fFrame
    as hdc fHandle
    as hbrush fBrush
    as hpen fPen
    as hfont fFont
    as hbitmap fBmp
    as integer fcx,fcy
    as boolean fClip
    as QPenMode fPenMode
    public:
    declare abstract sub Paint(byref as QMessage)
    declare abstract sub TextOut(as integer,as integer,as string)
    declare abstract sub MoveTo(as integer,as integer)
    declare abstract sub LineTo(as integer,as integer)
    declare abstract sub Line(as integer,as integer,as integer,as integer)
    declare abstract sub Ellipse(as integer,as integer,as integer,as integer)
    declare abstract sub Ellipse overload(R as Rect)
    declare abstract sub Rectangle(as integer,as integer,as integer,as integer)
    declare abstract sub Rectangle overload(as rect)
    declare abstract sub RoundRect overload(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nWidth as Integer,nHeight as Integer)
    declare abstract sub Polygon(Points as Point Ptr,Count as Integer)
    declare abstract sub RoundRect(R as Rect,nWidth as Integer,nHeight as Integer)
    declare abstract sub Chord(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    declare abstract sub Pie(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    declare abstract sub Arc(x as Integer,y as Integer,x1 as Integer,y1 as Integer,xStart as Integer, yStart as Integer,xEnd as Integer,yEnd as Integer)
    declare abstract sub ArcTo(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    declare abstract sub AngleArc(x as Integer,y as Integer,Radius as Integer,StartAngle as Single,SweepAngle as Single)
    declare abstract sub Polyline(Points as Point Ptr,Count as Integer)
    declare abstract sub Polyline(byref mPoint as Point,byref toPoint as Point)
    declare abstract sub PolylineTo(Points as Point Ptr,Count as Integer)
    declare abstract sub PolyBeizer(Points as Point Ptr,Count as Integer)
    declare abstract sub PolyBeizerTo(Points as Point Ptr,Count as Integer)
    declare abstract sub SetPixel(x as Integer,y as Integer,PixelColor as Integer)
    declare abstract function GetPixel(x as Integer,y as Integer) as Integer
    declare abstract sub TextOut(x as Integer,y as Integer,s as String,FG as Integer,BK as Integer)
    declare abstract sub DrawText(v as string,l as integer,r as rect,f as uint)
    declare abstract sub Draw(x as Integer,y as Integer,Image as Any Ptr)
    declare abstract sub StretchDraw(x as Integer,y as Integer,nWidth as Integer,nHeight as Integer,Image as Any Ptr)
    declare abstract sub CopyRect(Dest as Rect,Canvas as PCanvas,Source as Rect)
    declare abstract sub FloodFill(x as Integer,y as Integer,FillColor as Integer,FillStyle as QFillStyle)
    declare abstract sub FillRect(R as Rect,FillColor as Integer = -1)
    declare abstract sub DrawFocusRect(R as Rect)
    declare abstract function TextWidth(FText as String) as Integer
    declare abstract function TextHeight(FText as String) as Integer
    declare abstract sub GetDevice
    declare abstract sub ReleaseDevice
end type

type QCanvas extends QCustomCanvas
    private:
    protected:
    as colorref fColor,fTextColor
    public:
    declare virtual sub Paint(byref as QMessage)
    declare virtual sub TextOut(as integer,as integer,as string)
    declare virtual sub MoveTo(as integer,as integer)
    declare virtual sub LineTo(as integer,as integer)
    declare virtual sub Line(as integer,as integer,as integer,as integer)
    declare virtual sub Ellipse(as integer,as integer,as integer,as integer)
    declare virtual sub Ellipse overload(R as Rect)
    declare virtual sub Rectangle(as integer,as integer,as integer,as integer)
    declare virtual sub Rectangle overload(as rect)
    declare virtual sub RoundRect overload(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nWidth as Integer,nHeight as Integer)
    declare virtual sub Polygon(Points as Point Ptr,Count as Integer)
    declare virtual sub RoundRect(R as Rect,nWidth as Integer,nHeight as Integer)
    declare virtual sub Chord(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    declare virtual sub Pie(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    declare virtual sub Arc(x as Integer,y as Integer,x1 as Integer,y1 as Integer,xStart as Integer, yStart as Integer,xEnd as Integer,yEnd as Integer)
    declare virtual sub ArcTo(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    declare virtual sub AngleArc(x as Integer,y as Integer,Radius as Integer,StartAngle as Single,SweepAngle as Single)
    declare virtual sub Polyline(Points as Point Ptr,Count as Integer)
    declare virtual sub Polyline(byref mPoint as Point,byref toPoint as Point)
    declare virtual sub PolylineTo(Points as Point Ptr,Count as Integer)
    declare virtual sub PolyBeizer(Points as Point Ptr,Count as Integer)
    declare virtual sub PolyBeizerTo(Points as Point Ptr,Count as Integer)
    declare virtual sub SetPixel(x as Integer,y as Integer,PixelColor as Integer)
    declare virtual function GetPixel(x as Integer,y as Integer) as Integer
    declare virtual sub TextOut(x as Integer,y as Integer,s as String,FG as Integer,BK as Integer)
    declare virtual sub DrawText(v as string,l as integer,r as rect,f as uint)
    declare virtual sub Draw(x as Integer,y as Integer,Image as Any Ptr)
    declare virtual sub StretchDraw(x as Integer,y as Integer,nWidth as Integer,nHeight as Integer,Image as Any Ptr)
    declare virtual sub CopyRect(Dest as Rect,Canvas as PCanvas,Source as Rect)
    declare virtual sub FloodFill(x as Integer,y as Integer,FillColor as Integer,FillStyle as QFillStyle)
    declare virtual sub FillRect(R as Rect,FillColor as Integer = -1)
    declare virtual sub DrawFocusRect(R as Rect)
    declare virtual function TextWidth(FText as String) as Integer
    declare virtual function TextHeight(FText as String) as Integer
    declare virtual sub GetDevice
    declare virtual sub ReleaseDevice
    declare property Pen as hpen
    declare property Pen (as hpen)
    declare property Bmp as hbitmap
    declare property Bmp (v as hbitmap)
    declare property Pixel(as point) as Integer
    declare property Pixel(as point,Value as Integer)
    declare property Cx as integer
    declare property Cx (as integer)
    declare property Cy as integer
    declare property Cy (as integer)
    declare property Handle as hdc
    declare property Handle (as hdc)
    declare property Color as colorref
    declare property Color (as colorref)
    declare property TextColor as colorref
    declare property TextColor (as colorref)
    declare property Brush as hbrush
    declare property Brush (as hbrush)
    declare property Frame as PFrame
    declare property Frame (as PFrame)
    declare property Font as hfont
    declare property Font (as hfont)
    declare operator cast as hdc
    declare operator cast as any ptr
    declare constructor
    declare destructor
    onPaint as QEvent
end type

type QAnchor
     as rect Bound
     as integer dx,dy
     as integer Left,Top,Right,Bottom
end type

type PRect as rect ptr
type QConstraints
     protected:
     as PFrame fControl
     as integer fMinHeight,fMaxHeight,fMinWidth,fMaxWidth
     public:
     declare property Control as PFrame
     declare property Control (as PFrame)
     declare property MinHeight as integer
     declare property MinHeight (as integer)
     declare property MaxHeight as integer
     declare property MaxHeight (as integer)
     declare property MinWidth as integer
     declare property MinWidth (as integer)
     declare property MaxWidth as integer
     declare property MaxWidth (as integer)
     declare operator cast as rect
     declare operator Let(as rect)
     declare constructor (as integer=0,as integer=0,as integer=0,as integer=0)
     declare constructor (as PRect=0)
end type

enum QAlignment
     taLeft,taCener,taRight
end enum

enum QAlign
    alNone=0, alLeft, alRight, alTop, alBottom, alClient, alCustom
end enum

enum QControlStyle
    csDefault,csAcceptChilds,csTransparent
end enum

type QFrame extends QClassObject
     private:
     as integer nextID=0    
     protected:
     as hcursor fCursor
     as hicon fIcon
     as wndproc fprevproc
     as integer fAlign, foldZ, fClientWidth, fClientHeight, fbordersize
     as QControlStyle fControlStyle
     as integer fControlCount
     as PFrame ptr fControls
     as PFrame fSelected
     as wndclassex wc
     declare virtual sub Create
     declare virtual sub RegisterProc(as wndproc)
     declare virtual sub CreateHandle
     declare virtual sub DestroyHandle
     declare virtual sub ReCreateHandle
     declare virtual sub Dispatch(byref as QMessage)
     declare virtual sub DefaultHandler(byref as QMessage)
     declare sub AddControl(as PFrame)
     declare sub RemoveControl(as PFrame)
     public:
     as hMenu PopupMenu
     as QConstraints Constraints
     as QAnchor Anchor
     as QCanvas Canvas
     declare virtual function ReadProperty(byref as string) as any ptr
     declare virtual function WriteProperty(byref as string,as any ptr) as boolean
     declare sub ForceHandle
     declare function Perform overload(as QMessage) as lresult
     declare function Perform overload(as uint,as wparam,as lparam) as lresult
     declare sub Click
     declare sub DblClick
     declare static function Register(as string="",as string="",as wndproc=@DefWindowProc) as integer
     declare property Proc as wndproc
     declare property Proc(as wndproc)
     declare property Clipped as boolean
     declare property Clipped (as boolean)
     declare property Text as string
     declare property Text (as string)
     declare property ControlStyle as integer
     declare property ControlStyle(as integer)
     declare property Cursor as hcursor
     declare property Cursor(as hcursor)
     declare property Align as integer
     declare property Align(as integer)
     declare property Parent as PFrame
     declare property Parent (as PFrame)
     declare property ParentWindow as hwnd
     declare property ParentWindow (as hwnd)
     declare property Style as integer
     declare property Style (as integer)
     declare property ExStyle as integer
     declare property ExStyle (as integer)
     declare property Id as integer
     declare property Id (as integer)
     declare property Left as integer
     declare property Left (as integer)
     declare property Top as integer
     declare property Top (as integer)
     declare property Width as integer
     declare property Width (as integer)
     declare property Height as integer
     declare property Height (as integer)
     declare property Enabled as boolean
     declare property Enabled (as boolean)
     declare property Visible as boolean
     declare property Visible (as boolean)
     declare property TabStop as boolean
     declare property TabStop (as boolean)
     declare property Grouped as boolean
     declare property Grouped (as boolean)
     declare property Control(as integer) as PFrame
     declare property Control(as integer,as PFrame)
     declare property ControlCount as integer
     declare property ControlCount( as integer)
     declare property ClientWidth as integer
     declare property ClientWidth( as integer)
     declare property ClientHeight as integer
     declare property ClientHeight( as integer)
     declare property ClientRect as rect
     declare property ClientRect( as rect)
     declare property WindowRect as rect
     declare property WindowRect(as rect)
     declare sub SetBounds overload(x as integer,y as integer,cx as integer,cy as integer)
     declare sub SetBounds(v as rect)
     declare virtual operator cast as any ptr
     declare constructor
     declare destructor
     declare function IndexOfControl(as PFrame) as integer
     declare sub InsertControl(value as PFrame)
     declare sub RequestAlign
     declare sub RequestAnchor
     declare sub BringToFront
     declare sub SendToBack
     declare sub SetFocus
     declare sub KillFocus
     declare sub Invalidate
     declare sub Repaint
     declare sub Refresh
     declare sub ClientToScreen(byref as point)
     declare sub ScreenToClient(byref as point)
     onCreate as QEvent
     onDestroy as QEvent
     onClick as QEvent
     onDblClick as QEvent
     onPaint as QEvent
     onMouseDown as QMouseDownEvent
     onMouseUp as QMouseUpEvent
     onMouseMove as QMouseMoveEvent
     onMouseWheelEvent as QMouseWheelEvent
     onKeyDown as QKeyDownEvent
     onKeyUp as QKeyUpEvent
     onKeyPress as QKeyPressEvent
     onCommand as QCommandEvent
     onMenu as QMenuEvent
     onAccel as QAccelEvent
     onMouseWheel as QMouseWheel
end type

type QCustomForm extends QFrame
    enum QFormStyle
         fsNormal, fsMDIForm, fsMDIChild, fsStayOnTop
    end enum
    protected:
    as integer fModalResult
    as string fMenuFromResource
    as QFormStyle fFormStyle
    declare virtual sub Dispatch(byref as QMessage)
    declare static function DlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
    public:
    as hmenu Menu
    declare sub Close
    declare function ShowModal as integer
    declare sub Show
    declare property MenuFromResource as string
    declare property MenuFromResource (as string)
    declare static function WindowProc as wndproc
    declare virtual operator cast as any ptr
    declare property FormStyle as QFormStyle
    declare property FormStyle (as QFormStyle)
    #ifdef IDesigner
      declare property DesignMode as boolean
      declare property DesignMode(as boolean)
      as QDesigner Designer
    #endif
    declare virtual function ReadProperty(byref p as string) as any ptr
    declare virtual function WriteProperty(byref p as string, v as any ptr) as boolean
    declare constructor
    declare destructor
    onClose as QCloseEvent
    onActivate as QEvent
    onDeActivate as QEvent
    onShow as QEvent
    onHide as QEvent
end type

type QApplication extends QCustomForm
     protected:
     as boolean fisModal
     declare static function EnumWindowsProc(as hwnd,as lparam) as boolean
     public:
     declare property isModal as boolean
     declare sub DoModal(as PFrame=0)
     declare sub Run
     declare sub Quit
     declare sub Terminate
     declare sub DoEvents
     declare virtual function ReadProperty(byref p as string) as any ptr
     declare virtual function WriteProperty(byref p as string, v as any ptr) as boolean
     declare operator cast as any ptr
     declare operator cast as hwnd
     declare operator cast as hinstance
     declare constructor
     declare Destructor
end type


'''Global 
common shared as integer ptr __hnd 
