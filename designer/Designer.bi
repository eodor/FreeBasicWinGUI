/'
  Simple Designer. 
  (c)2013 Vasile Eodor Nastasa
  nastasa.eodor@gmail.com
  http://rqwork.de
  rewrite it for kogaion ide
'/

#include once "windows.bi"

#ifndef instance
     #define instance GetModuleHandle(0)
#endif

#ifndef IDesigner
     #define IDesigner &HFFFFFF
#ENDIF

type PDesigner as QDesigner ptr

type QWindowList
    Count  as integer
    Child  as HWND ptr
end type

type QDesigner extends Object
    private:
      declare static function HookChildProc(hDlg as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
      declare static function HookDialogProc(hDlg as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
      declare static function DotWndProc(hDlg as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
      FPopupMenu     as HMENU
      FActive        as boolean'integer
      FStepX         as integer
      FStepY         as integer
      FShowGrid      as Boolean
      FChilds        as QWindowList
      FDialog        as HWND
      FClass         as string
      FGridBrush     as HBRUSH
      FDotColor      as integer
      FDotBrush      as HBRUSH
      FSnapToGrid    as Boolean
      FDown          as Boolean
      FCanInsert     as Boolean
      FCanMove       as Boolean
      FCanSize       as Boolean
      FBeginX        as integer
      FBeginY        as integer
      FNewX          as integer
      FNewY          as integer
      FEndX          as integer
      FEndY          as integer
      FLeft          as integer
      FTop           as integer
      FWidth         as integer
      FHeight        as integer
      FSelControl    as HWND
      FOverControl   as HWND
      FDotIndex      as integer
      FDots(7)       as HWND
      FStyleEx       as integer
      FStyle         as integer
      FID            as integer
    protected:
      declare static function EnumChildsProc(hDlg as HWND, lParam as LPARAM) as Boolean
      declare        function IsDot(hDlg as HWND) as integer
      declare        sub RegisterDotClass
      declare        sub CreateDots(Parent as HWND)
      declare        sub DestroyDots
      declare        sub HideDots
      declare        sub MoveDots(Control as HWND)
      declare        sub CreateControl(AClassName as string, AName as string, AText as string, AParent as HWND, x as integer,y as integer, cx as integer, cy as integer)
      declare        function ControlAt(Parent as HWND,X as integer,Y as integer) as HWND
      declare        sub DrawGrid(DC as HDC, R as RECT)
      declare static function HookChilds(Dlg as hwnd,lParam as lparam) as boolean
      declare static function UnHookChilds(Dlg as hwnd,lParam as lparam) as boolean
      declare        sub Hook
      declare        sub UnHook
      declare        sub GetChilds(Parent as HWND = 0)
      declare        sub UpdateGrid
      declare        sub PaintGrid
      declare        sub ClipCursor(hDlg as HWND)
      declare        sub DrawBox(R as RECT)
      declare        sub DrawBoxs(R() as RECT)
      declare        sub DeleteControl(hDlg as HWND)
      declare        sub Clear
      declare        function GetClassAcceptControls(AClassName as string) as Boolean
      crArrow        as HCURSOR = LoadCursor(0, IDC_ARROW)
      crHandPoint    as HCURSOR = LoadCursor(0, IDC_HAND)
      crCross        as HCURSOR = LoadCursor(0, IDC_CROSS)
      crSize         as HCURSOR = LoadCursor(0, IDC_SIZEALL)
      crSizeNESW     as HCURSOR = LoadCursor(0, IDC_SIZENESW)
      crSizeNS       as HCURSOR = LoadCursor(0, IDC_SIZENS)
      crSizeNWSE     as HCURSOR = LoadCursor(0, IDC_SIZENWSE)
      crSizeWE       as HCURSOR = LoadCursor(0, IDC_SIZEWE)
    public:
      OnChangeSelection  as sub(ByRef Sender as QDesigner, Control as HWND)
      OnDeleteControl    as sub(ByRef Sender as QDesigner, Control as HWND)
      OnModified         as sub(ByRef Sender as QDesigner, Control as HWND)
      OnInsertControl    as sub(ByRef Sender as QDesigner, Control as HWND)
      OnInsertingControl as sub(ByRef Sender as QDesigner, ByRef AClass as string, ByRef AStyleEx as integer, AStyle as integer, ByRef AID as integer)
      OnMouseMove        as sub(ByRef Sender as QDesigner, X as integer, Y as integer, ByRef Over as HWND)
      declare            function ClassExists() as Boolean
      declare static     function GetClassName(hDlg as HWND) as string
      declare            sub HookControl(Control as HWND)
      declare            sub UnHookControl(Control as HWND)
      declare        sub MouseDown(X as integer, Y as Integer, Shift as integer)
      declare        sub MouseUp(X as integer, Y as Integer, Shift as integer)
      declare        sub MouseMove(X as integer, Y as Integer, Shift as integer)
      declare        sub KeyDown(Key as word, Shift as integer)

      declare property Dialog as HWND
      declare property Dialog(value as HWND)
      declare property Active as Boolean
      declare property Active(value as Boolean)
      declare property ChildCount as integer
      declare property ChildCount(value as integer)
      declare property Child(index as integer) as HWND
      declare property Child(index as integer,value as HWND)
      declare property StepX as integer
      declare property StepX(value as integer)
      declare property StepY as integer
      declare property StepY(value as integer)
      declare property DotColor as integer
      declare property DotColor(value as integer)
      declare property SnapToGrid as Boolean
      declare property SnapToGrid(value as Boolean)
      declare property ShowGrid as Boolean
      declare property ShowGrid(value as Boolean)
      declare property ClassName as string
      declare property ClassName(value as string)
      declare property SelControl as hwnd
      declare property SelControl (as hwnd)
      declare operator cast as any ptr
      declare constructor(hDlg as HWND=0)
      declare destructor
end type

function QDesigner.EnumChildsProc(hDlg as HWND, lParam as LPARAM) as Boolean
    if lParam then
        with *cast(QWindowList ptr, lParam)
            .Count = .Count + 1
            .Child = reallocate(.Child, .Count * sizeof(HWND))
            .Child[.Count-1] = hDlg
        end with
    end if   
    return true
end function

sub QDesigner.GetChilds(Parent as HWND = 0)
    FChilds.Count = 0
    FChilds.Child = callocate(0)
    EnumChildWindows(iif(Parent, Parent, FDialog), cast(WNDENUMPROC, @EnumChildsProc), cint(@FChilds))
end sub

sub QDesigner.ClipCursor(hDlg as HWND)
     dim as RECT R
     if IsWindow(hDlg) then
         GetClientRect(hDlg, @R)
         MapWindowPoints(hDlg, 0,cast(POINT ptr, @R), 2)
         .ClipCursor(@R)
     else
         .ClipCursor(0)
     end if
end sub

sub QDesigner.DrawBox(R as RECT)
     dim as HDC Dc = GetDCEx(FDialog, 0, DCX_PARENTCLIP or DCX_CACHE or DCX_CLIPSIBLINGS)
     dim as HBRUSH Brush = GetStockObject(NULL_BRUSH)
     dim as HBRUSH PrevBrush = SelectObject(Dc, Brush)
     SetROP2(Dc, R2_NOT)
     Rectangle(Dc, R.Left, R.Top, R.Right, R.Bottom)
     SelectObject(Dc, PrevBrush)
     ReleaseDc(FDialog, Dc)
end sub

sub QDesigner.DrawBoxs(R() as RECT)
    '''for future implementation of multiselect suport
    for i as integer = 0 to ubound(R)
        DrawBox(R(i))
    next   
end sub

function QDesigner.GetClassAcceptControls(AClassName as string) as Boolean
    '''for future implementation of classbag struct
    return false
end function

sub QDesigner.Clear
    GetChilds
    for i as integer = FChilds.Count -1 to 0 step -1
        DestroyWindow(FChilds.Child[i])
    next
    HideDots
end sub

function QDesigner.ClassExists() as Boolean
    dim as WNDCLASSEX wcls
    wcls.cbSize = sizeof(wcls)
    return (FClass <> "") and (GetClassInfoEx(0, FClass, @wcls) or GetClassInfoEx(instance, FClass, @wcls))
end function

function QDesigner.GetClassName(hDlg as HWND) as string
    dim as string s = space(255)
    dim as integer L = .GetClassName(hDlg, s, Len(s))
    return trim(Left(s, L))
end function   

function QDesigner.ControlAt(Parent as HWND,X as integer,Y as integer) as HWND
    dim as RECT R
    GetChilds(Parent)
    for i as integer = 0 to FChilds.Count -1
        if IsWindowVisible(FChilds.Child[i]) then
           GetWindowRect(FChilds.Child[i], @R)
           MapWindowPoints(0, Parent, cast(POINT ptr, @R) ,2)
           if (X > R.Left and X < R.Right) and (Y > R.Top and Y < R.Bottom) then
              return FChilds.Child[i]
           end If
        end if
    next i
    return Parent
end function

sub QDesigner.CreateDots(Parent as HWND)
    for i as integer = 0 to 7
        FDots(i) = CreateWindowEx(WS_EX_TOPMOST, "DOT", "",WS_POPUP or WS_CHILD or WS_CLIPSIBLINGS or WS_CLIPCHILDREN, 0, 0, 6, 6, Parent, 0, instance, 0)
        if IsWindow(FDots(i)) then 
            SetWindowLong(FDots(i), 0, cint(@this))
        end if   
    next i
end sub

sub QDesigner.DestroyDots
    for i as integer = 7 to 0 step -1
        DestroyWindow(FDots(i))
    next i
end sub

sub QDesigner.HideDots
    for i as integer = 0 to 7
        ShowWindow(FDots(i), SW_HIDE)
    next i
end sub

sub QDesigner.MoveDots(Control as HWND)
    dim as RECT R
    dim as POINT P
    dim as integer iWidth, iHeight
    if IsWindow(Control) then
       if Control <> FDialog then
           GetWindowRect(Control, @R)
           iWidth  = R.Right  - R.Left
           iHeight = R.Bottom - R.Top
           P.x     = R.Left
           P.y     = R.Top
           ScreenToClient(GetParent(Control), @P)
           for i as integer = 0 to 7
               SetParent(FDots(i), GetParent(Control))
               SetProp(FDots(i),"@@@Control", Control)
           next i
           SetWindowPos(FDots(0), HWND_TOP, P.X-3, P.Y-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(1), HWND_TOP, P.X+iWidth/2-3, P.Y-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(2), HWND_TOP, P.X+iWidth-3, P.Y-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(3), HWND_TOP, P.X+iWidth-3, P.Y + iHeight/2-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(4), HWND_TOP, P.X+iWidth-3, P.Y + iHeight-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(5), HWND_TOP, P.X+iWidth/2-3, P.Y + iHeight-3,0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(6), HWND_TOP, P.X-3, P.Y + iHeight-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
           SetWindowPos(FDots(7), HWND_TOP, P.X-3, P.Y + iHeight/2-3, 0, 0, SWP_NOSIZE OR SWP_SHOWWINDOW)
       else
          HideDots
       end If
    else
       HideDots
    end if
end sub

function QDesigner.IsDot(hDlg as HWND) as integer
     dim as string s
     s = GetClassName(hDlg)
     if UCase(s) = "DOT" then
        for i as integer = 0 to 7
           if FDots(i) = hDlg then return i
        next i
    end If
    return -1
end function

sub QDesigner.MouseDown(X as integer, Y as Integer, Shift as integer)
    dim as POINT P
    dim as RECT R
    FDown   = true
    FBeginX = iif(FSnapToGrid,(X\FStepX)*FStepX,X)
    FBeginy = iif(FSnapToGrid,(Y\FStepY)*FStepY,y)
    FEndX   = FBeginX
    FEndY   = FBeginY
    FNewX   = FBeginX
    FNewY   = FBeginY
    HideDots
    ClipCursor(FDialog)
    FSelControl = ControlAt(FDialog, X, Y)
    FDotIndex   = IsDot(FOverControl)
    if FDotIndex <> -1 then
        FCanInsert  = false
        FCanMove    = false
        FCanSize    = true
        if not IsWindow(FSelControl) then
            FSelControl = GetProp(FDots(FDotIndex),"@@@Control")
        end if   
        BringWindowToTop(FSelControl)
        GetWindowRect(FSelControl, @R)
        P.X     = R.Left
        P.Y     = R.Top
        FWidth  = R.Right - R.Left
        FHeight = R.Bottom - R.Top
        ScreenToClient(GetParent(FSelControl), @P) 
        FLeft   = P.X
        FTop    = P.Y
        select case FDotIndex
        case 0: SetCursor(crSizeNWSE)
        case 1: SetCursor(crSizeNS)
        case 2: SetCursor(crSizeNESW)
        case 3: SetCursor(crSizeWE)
        case 4: SetCursor(crSizeNWSE)
        case 5: SetCursor(crSizeNS)
        case 6: SetCursor(crSizeNESW)
        case 7: SetCursor(crSizeWE)
        end select
        SetCapture(FDialog)
   else
        if FSelControl <> FDialog then
           BringWindowToTop(FSelControl)
           if ClassExists then
               FCanInsert = true
               FCanMove   = false
               FCanSize   = false
               SetCursor(crCross)
           else
               FCanInsert = false
               FCanMove   = true
               FCanSize   = false
               SetCursor(crSize) :SetCapture(FDialog)
               if OnChangeSelection then OnChangeSelection(this, FSelControl)
               GetWindowRect(FSelControl, @R)
               P.X     = R.Left
               P.Y     = R.Top
               FWidth  = R.Right - R.Left
               FHeight = R.Bottom - R.Top
               ScreenToClient(GetParent(FSelControl), @P)
               FLeft   = P.X
               FTop    = P.Y
           end if
        else
           HideDots
           FCanInsert = iif(ClassExists, true, false)
           FCanMove   = 0
           FCanSize   = 0
           if FCanInsert then
               SetCursor(crCross)
           else
              if OnChangeSelection then OnChangeSelection(this, FSelControl)
           end if
       end if
    end if   
end sub

sub QDesigner.MouseMove(X as integer, Y as Integer, Shift as integer)
    dim as POINT P
    FNewX = iif(FSnapToGrid,(X\FStepX)*FStepX,X)
    FNewY = iif(FSnapToGrid,(Y\FStepY)*FStepY,Y)
    if FDown then
       if FCanInsert then
           SetCursor(crCross)
           DrawBox(type<RECT>(FBeginX, FBeginY, FNewX, FNewY))
           DrawBox(type<RECT>(FBeginX, FBeginY, FEndX, FEndY))
       end if
       if FCanSize then
          select case FDotIndex
          case 0: MoveWindow(FSelControl, FLeft + (FNewX - FBeginX), FTop + (FNewY - FBeginY), FWidth - (FNewX - FBeginX), FHeight - (FNewY - FBeginY), true)
          case 1: MoveWindow(FSelControl, FLeft, FTop + (FNewY - FBeginY),FWidth ,FHeight - (FNewY - FBeginY), true)
          case 2: MoveWindow(FSelControl, FLeft, FTop + (FNewY - FBeginY),FWidth + (FNewX - FBeginX) , FHeight - (FNewY - FBeginY), true)
          case 3: MoveWindow(FSelControl, FLeft, FTop, FWidth + (FNewX - FBeginX), FHeight, true)
          case 4: MoveWindow(FSelControl, FLeft, FTop, FWidth + (FNewX - FBeginX), FHeight + (FNewY - FBeginY), true)
          case 5: MoveWindow(FSelControl, FLeft, FTop, FWidth ,FHeight + (FNewY - FBeginY), true)
          case 6: MoveWindow(FSelControl, FLeft + (FNewX - FBeginX), FTop, FWidth - (FNewX - FBeginX), FHeight + (FNewY - FBeginY), true)
          case 7: MoveWindow(FSelControl, FLeft - (FBeginX - FNewX), FTop, FWidth + (FBeginX - FNewX), FHeight, true)
          end Select
       end If
       if FCanMove then
          if FBeginX <> FEndX Or FBeginY <> FEndY then
              MoveWindow(FSelControl, FLeft + (FNewX - FBeginX), FTop + (FNewY - FBeginY), FWidth, FHeight, true)
          end if
       end if
    else
       P = type(X, Y)
       FOverControl = ChildWindowFromPoint(FDialog, P)
       if OnMouseMove then OnMouseMove(this, X, Y, FOverControl)
       dim as integer Id = IsDot(FOverControl)
       if Id <> -1 then
          select case Id
          case 0 : SetCursor(crSizeNWSE)
          case 1 : SetCursor(crSizeNS)
          case 2 : SetCursor(crSizeNESW)
          case 3 : SetCursor(crSizeWE)
          case 4 : SetCursor(crSizeNWSE)
          case 5 : SetCursor(crSizeNS)
          case 6 : SetCursor(crSizeNESW)
          case 7 : SetCursor(crSizeWE)
          end select
       else
          if GetAncestor(FOverControl,GA_ROOTOWNER) <> FDialog then
              ReleaseCapture
          end if   
          SetCursor(crArrow)
          ClipCursor(0)
       end if
    end if
    FEndX = FNewX
    FEndY = FNewY
end sub

sub QDesigner.MouseUp(X as integer, Y as Integer, Shift as integer)
    dim as RECT R
    if FDown then
        FDown = false
        if FCanInsert then
           if (FBeginX > FEndX and FBeginY > FEndY) then
               swap FBeginX, FNewX
               swap FBeginY, FNewY
           end if
           if (FBeginX > FEndX and FBeginY < FEndY) then
               swap FBeginX, FNewX
           end if
           if (FBeginX < FEndX and FBeginY > FEndY) then
               swap FBeginY, FNewY
           end if
           DrawBox(Type<RECT>(FBeginX, FBeginY, FNewX, FNewY))
           if GetClassAcceptControls(GetClassName(FSelControl)) Then
               R.Left   = FBeginX
               R.Top    = FBeginY
               R.Right  = FNewX
               R.Bottom = FNewY
               MapWindowPoints(FDialog, FSelControl, cast(POINT ptr, @R), 2)
               if OnInsertingControl then
                   OnInsertingControl(this, FClass, FStyleEx, FStyle, FID)
               end if
               if CompareText(FClass,"QCheckBox"+chr(0)) then
                  FStyle=bs_autocheckbox
               elseif CompareText(FClass,"QGroupBox") then
                  FStyle=bs_groupbox
               elseif CompareText(FClass,"QRadioButton") then
                  FStyle=bs_autoradiobutton
               end if  :? "style=",fstyle
               CreateControl(FClass, "", "", FSelControl, R.Left, R.Top, R.Right -R.Left, R.Bottom -R.Top)
           else
               if OnInsertingControl then
                   OnInsertingControl(this, FClass, FStyleEx, FStyle, FID)
               end if
               if CompareText(FClass,"QCheckBox") then
                  FStyle=bs_autocheckbox
               elseif CompareText(FClass,"QGroupBox") then
                  FStyle=bs_groupbox
                  FStyleEx=ws_ex_transparent
               elseif CompareText(FClass,"QRadioButton") then
                  FStyle=bs_autoradiobutton
               end if   :? "style=",fstyle
               CreateControl(FClass, "", "", FDialog, FBeginX, FBeginY, FNewX -FBeginX, FNewY -FBeginY)
           end If
        end if
        if FCanSize then
            MoveDots(FSelControl)
            FCanSize = false
            if OnModified then OnModified(this, FSelControl)
        end If
        if FCanMove then
            MoveDots(FSelControl)
            FCanMove = false
            if OnModified then OnModified(this, FSelControl)
        end if
        FBeginX = FEndX
        FBeginY = FEndY
        FNewX   = FBeginX
        FNewY   = FBeginY
        ClipCursor(0)
        ReleaseCapture
    else
        ClipCursor(0)
    end if
end sub

sub QDesigner.DeleteControl(hDlg as HWND)
    if IsWindow(hDlg) then
        if hDlg <> FDialog then
           if OnDeleteControl then OnDeleteControl(this, hDlg)
           DestroyWindow(hDlg)
           if OnModified then OnModified(this, hDlg)
           HideDots
           FSelControl = FDialog
       end if
    end if
end sub

function QDesigner.HookChilds(Dlg as hwnd,lParam as lparam) as boolean
    if IsWindow(Dlg) then
       if GetWindowLongPtr(Dlg, GWL_WNDPROC) <> @HookChildProc then
          SetProp(Dlg, "@@@Proc", cast(WNDPROC, SetWindowLongPtr(Dlg, GWL_WNDPROC, cint(@HookChildProc))))
       end if
     end if 
    return true     
end function

function QDesigner.UnHookChilds(Dlg as hwnd,lParam as lparam) as boolean
    if IsWindow(Dlg) then
       if GetWindowLongPtr(Dlg, GWL_WNDPROC) = @HookChildProc then
          SetWindowLongPtr(Dlg, GWL_WNDPROC, cint(GetProp(Dlg, "@@@Proc")))
          RemoveProp(Dlg, "@@@Proc")
       end if
    end if
    return true
end function

sub QDesigner.UnHookControl(Control as HWND)
    if IsWindow(Control) then
        if GetWindowLongPtr(Control, GWL_WNDPROC) = @HookChildProc then
            SetWindowLongPtr(Control, GWL_WNDPROC, cint(GetProp(Control, "@@@Proc")))
            RemoveProp(Control, "@@@Proc")
            EnumChildWindows(Control,cast(any ptr,@unHookChilds),0)
        end if
    end if   
end sub

sub QDesigner.HookControl(Control as HWND)
    if IsWindow(Control) then
        if GetWindowLongPtr(Control, GWL_WNDPROC) <> @HookChildProc then
          SetProp(Control, "@@@Proc", cast(WNDPROC, SetWindowLongPtr(Control, GWL_WNDPROC, cint(@HookChildProc))))
          EnumChildWindows(Control,cast(any ptr,@HookChilds),0)
        end if
    end if   
end sub

sub QDesigner.CreateControl(AClassName as string, AName as string, AText as string, AParent as HWND, x as integer,y as integer, cx as integer, cy as integer)
    FSelControl = CreateWindowEx(FStyleEx,_
                                 AClassName,_
                                 AText,_
                                 FStyle or WS_VISIBLE or WS_CHILD or WS_CLIPCHILDREN or WS_CLIPSIBLINGS,_
                                 x,_
                                 y,_
                                 iif(cx, cx, 50),_
                                 iif(cy, cy, 50),_
                                 AParent,_
                                 cast(HMENU, FID),_
                                 instance,_
                                 0)
    if IsWindow(FSelControl) then
        HookControl(FSelControl)
        'AName = iif(AName="", AName = AClassName & ...)
        'SetProp(Control, "Name", ...)
        'possibly ussing in propertylist inspector
        FClass = ""
                  BringWindowToTop(FSelControl)
                  MoveDots(FSelControl)
                  ? "onins=",OnInsertControl
                  if OnInsertControl then
                     ? "insert"
                     OnInsertControl(this, FSelControl)
                  end if
        FCanInsert = false
    end if
end sub

sub QDesigner.UpdateGrid
    InvalidateRect(FDialog, 0, true)
end sub

sub QDesigner.DrawGrid(DC as HDC, R as RECT)
    dim as HDC mDc
    dim as HBITMAP mBMP, pBMP
    dim as RECT BrushRect = type(0, 0, FStepX, FStepY)
    if FGridBrush then
        DeleteObject(FGridBrush)
    end if   
    mDc   = CreateCompatibleDc(DC)
    mBMP  = CreateCompatibleBitmap(DC, FStepX, FStepY)
    pBMP  = SelectObject(mDc, mBMP)
    FillRect(mDc, @BrushRect, cast(HBRUSH, 16))
    SetPixel(mDc, 1, 1, 0)
    'for lines use MoveTo and LineTo or Rectangle function or whatever...
    FGridBrush = CreatePatternBrush(mBMP)
    FillRect(DC, @R, FGridBrush)
    SelectObject(mDc, pBMP)
    DeleteObject(mBMP)
    DeleteDc(mDc)
end sub

function QDesigner.HookChildProc(hDlg as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
    select case uMsg
    case WM_MOUSEFIRST to WM_MOUSELAST
        return true
    case WM_NCHITTEST
        return HTTRANSPARENT
    case WM_KEYFIRST to WM_KEYLAST
        return 0
    end select
    return CallWindowProc(GetProp(hDlg, "@@@Proc"), hDlg, uMsg, wParam, lParam)
end function

function QDesigner.HookDialogProc(hDlg as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
    dim as PDesigner Designer = GetProp(hDlg, "@@@Designer")
    if Designer then
        with *Designer
          select case uMsg
          case WM_ERASEBKGND
              dim as RECT R
              GetClientRect(hDlg, @R)
              if .FShowGrid then
                  .DrawGrid(cast(HDC, wParam), R)
              else
                  FillRect(cast(HDC, wParam), @R, cast(HBRUSH, 16))
              end if   
              return 1
          case WM_LBUTTONDOWN
              .MouseDown(loWord(lParam), hiWord(lParam),wParam and &HFFFF )
              return 0
          case WM_LBUTTONUP
              .MouseUp(loWord(lParam), hiWord(lParam),wParam and &HFFFF )
              return 0
          case WM_MOUSEMOVE
              .MouseMove(loword(lParam), hiword(lParam),wParam and &HFFFF )
              return 0
          case WM_RBUTTONUP
              if .FSelControl <> .FDialog then
                  dim as POINT P
                  P.x = loWord(lParam)
                  P.y = hiWord(lParam)
                  ClientToScreen(hDlg, @P)
                  TrackPopupMenu(.FPopupMenu, 0, P.x, P.y, 0, hDlg, 0)
              end if
              return 0
          case WM_COMMAND
              if IsWindow(cast(HWND, lParam)) then
              else
                 if hiWord(wParam) = 0 then
                     select case loWord(wParam)
                     case 10: if .FSelControl<> .FDialog then .DeleteControl(.FSelControl)
                     case 11: MessageBox(.FDialog, "Not implemented yet.","Designer", 0)
                     case 12: MessageBox(.FDialog, "Not implemented yet.","Designer", 0)
                     case 13: MessageBox(.FDialog, "Not implemented yet.","Designer", 0)
                     case 15: MessageBox(.FDialog, "Not implemented yet.","Designer", 0)
                     end select
                 end if
              end if '
              ''''Call and execute the based commands of dialogue.
              return CallWindowProc(GetProp(hDlg, "@@@Proc"), hDlg, uMsg, wParam, lParam)
              '''if don't want to call
              'return 0
          end select
       end with
    end if
    return CallWindowProc(GetProp(hDlg, "@@@Proc"), hDlg, uMsg, wParam, lParam)
end function

sub QDesigner.Hook
    if IsWindow(FDialog) then
        SetProp(FDialog, "@@@Designer", this)
        if GetWindowLongPtr(FDialog, GWLP_WNDPROC) <> @HookDialogProc then
           SetProp(FDialog, "@@@Proc", cast(any ptr, SetWindowLongPtr(FDialog, GWLP_WNDPROC, cint(@HookDialogProc))))
        end if
        GetChilds
        for i as integer = 0 to FChilds.Count-1
            HookControl(FChilds.Child[i])
        next
    end if
end sub

sub QDesigner.UnHook
    if isWindow(fDialog) then
       SetWindowLongPtr(FDialog, GWL_WNDPROC, cint(GetProp(FDialog, "@@@Proc")))
       RemoveProp(FDialog, "@@@Designer")
       RemoveProp(FDialog, "@@@Proc")
       GetChilds
       for i as integer = FChilds.Count-1 to 0 step-1
           UnHookControl(FChilds.Child[i])
        next
    end if
end sub

function QDesigner.DotWndProc(hDlg as HWND, uMsg as UINT, wParam as WPARAM, lParam as LPARAM) as LRESULT
    dim as PDesigner Designer = cast(PDesigner, GetWindowLong(hDlg, 0))
    select case uMsg
    case WM_PAINT
        dim as PAINTSTRUCT Ps
        dim as HDC Dc
        Dc = BeginPaint(hDlg, @Ps)
        FillRect(Dc, @Ps.rcPaint, iif(Designer, Designer->FDotBrush, cast(HBRUSH, GetStockObject(BLACK_BRUSH))))
        EndPaint(hDlg, @Ps)
        return 0
        'or use WM_ERASEBKGND message
    case WM_LBUTTONDOWN
        return 0
    case WM_NCHITTEST
        return HTTRANSPARENT
    case WM_DESTROY
        RemoveProp(hDlg,"@@@Control")
        return 0
    end select
    return DefWindowProc(hDlg, uMsg, wParam, lParam)
end function     

sub QDesigner.RegisterDotClass
   dim as WNDCLASSEX wcls
   wcls.cbSize        = sizeof(wcls)
   wcls.lpszClassName = @"Dot"
   wcls.lpfnWndProc   = @DotWndProc
   wcls.cbWndExtra   += 4
   wcls.hInstance     = instance
   RegisterClassEx(@wcls)
end sub

property QDesigner.Dialog as HWND
    return FDialog
end property

property QDesigner.Dialog(value as HWND)
    FDialog = value
    if isWindow(value) then
        UnHook
        if FActive then Hook else Unhook
        InvalidateRect(FDialog, 0, true)
    end if   
end property

property QDesigner.Active as Boolean
    return FActive
end property

property QDesigner.Active(value as Boolean)
    FActive = value
    if fDialog=0 then exit property
    if value then
       Hook
    else
       UnHook
       HideDots
    end if
    InvalidateRect(FDialog, 0, true)
end property

property QDesigner.SelControl as hwnd
    return fSelControl
end property

property QDesigner.SelControl (v as hwnd)
end property

property QDesigner.ChildCount as integer
    GetChilds
    return FChilds.Count
end property

property QDesigner.ChildCount(value as integer)
end property

property QDesigner.Child(index as integer) as HWND
    if index > -1 and index < FChilds.Count then
        return FChilds.Child[index]
    end if
    return 0
end property

property QDesigner.Child(index as integer,value as HWND)
    if index>-1 and index<FChilds.Count then
        fChilds.Child[index]=value
    end if
end property

property QDesigner.StepX as integer
    return FStepX
end property

property QDesigner.StepX(value as integer)
    if value <> FStepX then
       FStepX = value
       UpdateGrid
    end if   
end property

property QDesigner.StepY as integer
    return FStepY
end property

property QDesigner.StepY(value as integer)
    if value <> FStepY then
       FStepY = value
       UpdateGrid
   end if
end property

property QDesigner.DotColor as integer
    dim as LOGBRUSH LB
    if GetObject(FDotBrush, sizeof(LB), @LB) then
        FDotColor = LB.lbColor
    end if
    return FDotColor
end property

property QDesigner.DotColor(value as integer)
    if value <> FDotColor then
        FDotColor = value
        if FDotBrush then DeleteObject(FDotBrush)
        FDotBrush = CreateSolidBrush(FDotColor)
        for i as integer = 0 to ubound(FDots)'-1
            InvalidateRect(FDots(i), 0, true)
        next
    end if
end property

property QDesigner.SnapToGrid as Boolean
    return FSnapToGrid
end property

property QDesigner.SnapToGrid(value as Boolean)
    FSnapToGrid = value
end property

property QDesigner.ShowGrid as Boolean
    return FShowGrid
end property

property QDesigner.ShowGrid(value as Boolean)
    FShowGrid = value
    if IsWindow(FDialog) then InvalidateRect(FDialog, 0, true)
end property

property QDesigner.ClassName as string
    return FClass
end property

property QDesigner.ClassName(value as string)
    FClass = rtrim(value)
end property

operator QDesigner.cast as any ptr
    return @this
end operator

constructor QDesigner(hDlg as HWND)
    Dialog      = hDlg
    FStepX      = 6
    FStepY      = 6
    FShowGrid   = true
    FActive     = true
    FSnapToGrid = 1
    FDotBrush   = CreateSolidBrush(FDotColor)
    RegisterDotClass
    CreateDots(hDlg)
    FPopupMenu  = CreatePopupMenu
    AppendMenu(FPopupMenu, MF_STRING, 10, @"Delete")
    AppendMenu(FPopupMenu, MF_SEPARATOR, -1, @"-")
    AppendMenu(FPopupMenu, MF_STRING, 12, @"Copy")
    AppendMenu(FPopupMenu, MF_STRING, 13, @"Cut")
    AppendMenu(FPopupMenu, MF_STRING, 14, @"Paste")
    AppendMenu(FPopupMenu, MF_SEPARATOR, -1, @"-")
    AppendMenu(FPopupMenu, MF_STRING, 15, @"Properties")
end constructor

destructor QDesigner
    UnHook
    DeleteObject(FDotBrush)
    DeleteObject(FGridBrush)
    DestroyMenu(FPopupMenu)
    DestroyDots
    UnregisterClass("Dot", instance)
end destructor