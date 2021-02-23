'koganion_gui.bas -library windows controls wrapper
'this file is part of Koganion(RqWork7) rad-ide
'and can't be redistributed without permission
'Copyright (c)2020 Vasile Eodor Nastasa
'mail: nastasa.eodor@gmail.com
'web:http://www.rqwork.de

#include once "typeinfo.bas"

#include once "kogaion_gui.bi"
#include once "kogaion_gui_sysutils.bi"

/' QCommandAllocator'/
constructor QCommandAllocator
end constructor

operator QCommandAllocator.cast as integer
    return Count
end operator

function QCommandAllocator.Allocatecid as integer
    this.count=this.count+1
    return this.count
end function

'''globals
private function EnumThreadWindowsProc(Dlg as hwnd,lParam as lparam) as boolean
    if GetWindowLong(dlg,gwl_exstyle) and ws_ex_appwindow=ws_ex_appwindow then
       *cast(integer ptr,lparam)=cint(dlg)
       exit function
    end if
    return false
end function

function MainWindow as hwnd export
    EnumThreadWindows(GetCurrentThreadId,cast(enumwindowsproc,@EnumThreadWindowsProc),cint(__hnd))
    return cast(hwnd,*__hnd)
end function

sub ShowMessage(v as string) export
    dim as string s=string(256,0)
    GetModuleFileName(GetModuleHandle(0),s,256)
    MessageBox(MainWindow,v,ExtractFileName(s),mb_applmodal or mb_topmost)
end sub

function MessageDlg(v as string,c as string,b as integer=mb_ok) as integer export
    return MessageBox(MainWindow,v,c,b or mb_applmodal or mb_topmost)
end function

Function SysErrorMessage(v as integer=GetLastError) As String export
     Dim As zString*256 Buffer
     FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, v, LANG_NEUTRAL, @Buffer, 200, 0)
     Return RTrim(Buffer)
End Function

function ClassNameIs(dlg as hwnd) as string export
    Dim As zString*256 Buffer
    dim as integer l=GetClassName(dlg,Buffer,256)
    return left(Buffer,l)
end function

sub Debug(v as string) export
    ? v
end sub

'''QObject
function QObject.FindObject(v as PObject) as integer
    for i as integer=0 to fObjectCount-1
        if fObjects[i]=v then return i
    next    
    return -1
end function

sub QObject.AddObject(v as PObject)
    dim as integer i=FindObject(v)
    if i>-1 then
       fObjectCount+=1
       fObjects=reallocate(fObjects,sizeof(PObject)*fObjectCount)
       fObjects[fObjectCount-1]=v
    end if   
end sub

sub QObject.RemoveObject(v as PObject)
    dim as integer i=FindObject(v)
    if i <>-1 then
        fobjects[i]=null
        for i as integer = i+1 to fobjectcount-1
            fobjects[i-1] = fobjects[i+1]
        next
        fobjectcount -= 1
        fobjects = reallocate(fobjects,sizeof(PObject)*fobjectcount)
    end if
end sub

property QObject.Name as string
    return fName
end property

property QObject.Name(v as string)
    fName=v
    if onNameChanged then onNameChanged(this)
end property
    
operator QObject.cast as any ptr
    return @this
end operator

'''QClassObject
property QClassObject.Handle as hwnd
    return fHandle
end property

property QClassObject.Handle (v as hwnd)
    fHandle=v
end property

'''QCanvas
property QCanvas.Font as hfont
    if fFrame then
       if isWindow(fFrame->handle) then
          fFont=cast(hfont,SendMessage(*fFrame,wm_getfont,0,0))
       end if
    end if
    return fFont
end property

property QCanvas.Font (v as hfont)
    dim as logfont lf
    if GetObject(v,sizeof(lf),@lf) then
       fFont=CreateFontIndirect(@lf)
       if fFrame then
          if isWindow(fFrame->handle) then
             SendMessage(*fFrame,wm_setfont,cint(fFont),true)
          end if
       end if
    end if
end property

property QCanvas.Handle as hdc
    return fHandle
end property

property QCanvas.Handle (v as hdc)
    fHandle=v
    if v>0 then
       DeleteObject(SelectObject(v,fFont))
       DeleteObject(SelectObject(v,fBrush))
       DeleteObject(SelectObject(v,fPen))
       DeleteObject(SelectObject(v,fBmp))
    end if
end property

property QCanvas.Pixel(xy as point) As Integer
    GetDevice
    Property = .GetPixel(Handle,xy.x,xy.y)
    ReleaseDevice
End property

property QCanvas.Pixel(xy as point,Value as Integer)
    GetDevice
    .SetPixel(Handle,xy.x,xy.y,Value)
    ReleaseDevice
End property

property QCanvas.Cx as integer
    if fBmp then
       dim as BITMAP B
       if GetObject(fBmp,sizeof(B),@B) then
          fCx=B.bmWidth
       end if
    end if
    return fCx
end property

property QCanvas.Cx (v as integer)
end property

property QCanvas.Cy as integer
    if fBmp then
       dim as BITMAP B
       if GetObject(fBmp,sizeof(B),@B) then
          fCy=B.bmHeight
       end if
    end if
    return fCy
end property

property QCanvas.Cy (v as integer)
end property

sub QCanvas.GetDevice
    if frame then
       if frame->Handle then
           if fClip then
              fHandle = GetDcEx(frame->Handle,0,DCX_PARENTCLIP OR DCX_CACHE)
           else
              fHandle = GetDc(frame->Handle)
           end if
           SelectObject(fHandle,fFont)
           SelectObject(fHandle,fPen)
           SelectObject(fHandle,fBrush)
           SelectObject(fHandle,fBmp)
           SetROP2(fHandle,fPenMode)
       end if
    end if
end sub

sub QCanvas.ReleaseDevice
    If fFrame Then If Handle Then ReleaseDc fFrame->Handle,Handle
end sub

sub QCanvas.MoveTo(x as Integer,y as Integer)
    GetDevice
    .MoveToEx Handle,x,y,0
    ReleaseDevice
end sub

sub QCanvas.LineTo(x as Integer,y as Integer)
    GetDevice
    .LineTo Handle,x,y
    ReleaseDevice
end sub

sub QCanvas.Line(x as Integer,y as Integer,x1 as Integer,y1 as Integer)
    GetDevice
    .MoveToEx Handle,x,y,0
    .LineTo Handle,x1,y1
    ReleaseDevice
end sub

sub QCanvas.Rectangle overload(x as Integer,y as Integer,x1 as Integer,y1 as Integer)
    GetDevice
    .Rectangle Handle,x,y,x1,y1
    ReleaseDevice
end sub

sub QCanvas.Rectangle(R as Rect)
    GetDevice
    .Rectangle Handle,R.Left,R.Top,R.Right,R.Bottom
    ReleaseDevice
end sub

sub QCanvas.Ellipse overload(x as Integer,y as Integer,x1 as Integer,y1 as Integer)
    GetDevice
    .Ellipse Handle,x,y,x1,y1
    ReleaseDevice
end sub

sub QCanvas.Ellipse(R as Rect)
    GetDevice
    .Rectangle Handle,R.Left,R.Top,R.Right,R.Bottom
    ReleaseDevice
end sub

sub QCanvas.RoundRect overload(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nWidth as Integer,nHeight as Integer)
    GetDevice
    .RoundRect Handle,x,y,x1,y1,nWidth,nHeight
    ReleaseDevice
end sub

sub QCanvas.Polygon(Points as Point Ptr,Count as Integer)
    GetDevice
    .Polygon Handle, Points, Count
    ReleaseDevice
end sub

sub QCanvas.RoundRect(R as Rect,nWidth as Integer,nHeight as Integer)
    GetDevice
    .RoundRect Handle,R.Left,R.Top,R.Right,R.Bottom,nWidth,nHeight
    ReleaseDevice
end sub

sub QCanvas.Chord(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    GetDevice
    .Chord(Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2)
    ReleaseDevice
end sub

sub QCanvas.Pie(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
   GetDevice
   .Pie(Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2)
   ReleaseDevice
end sub

sub QCanvas.Arc(x as Integer,y as Integer,x1 as Integer,y1 as Integer,xStart as Integer, yStart as Integer,xEnd as Integer,yEnd as Integer)
    GetDevice
    .Arc(Handle,x,y,x1,y1,xStart, yStart,xEnd,yEnd)
    ReleaseDevice
end sub

sub QCanvas.ArcTo(x as Integer,y as Integer,x1 as Integer,y1 as Integer,nXRadial1 as Integer,nYRadial1 as Integer,nXRadial2 as Integer,nYRadial2 as Integer)
    GetDevice
    .ArcTo Handle,x,y,x1,y1,nXRadial1,nYRadial1,nXRadial2,nYRadial2
    ReleaseDevice
end sub

sub QCanvas.AngleArc(x as Integer,y as Integer,Radius as Integer,StartAngle as Single,SweepAngle as Single)
    GetDevice
    .AngleArc Handle,x,y,Radius,StartAngle,SweepAngle
    ReleaseDevice
end sub

sub QCanvas.Polyline(Points as Point Ptr,Count as Integer)
   GetDevice
   .Polyline Handle,Points,Count
   ReleaseDevice
end sub

sub QCanvas.Polyline(byref mPoint as Point,byref toPoint as Point)
   GetDevice
   PolylineTo(@mPoint,1)
   Polyline(@toPoint,1)
   ReleaseDevice
end sub

sub QCanvas.PolylineTo(Points as Point Ptr,Count as Integer)
    GetDevice
    .PolylineTo Handle,Points,Count
    ReleaseDevice
end sub

sub QCanvas.PolyBeizer(Points as Point Ptr,Count as Integer)
    GetDevice
    .PolyBezier Handle,Points,Count
    ReleaseDevice
end sub

sub QCanvas.PolyBeizerTo(Points as Point Ptr,Count as Integer)
    GetDevice
    .PolyBezierTo Handle,Points,Count
    ReleaseDevice
end sub

sub QCanvas.SetPixel(x as Integer,y as Integer,PixelColor as Integer)
    GetDevice
    .SetPixel Handle,x,y,PixelColor
    ReleaseDevice
end sub

function QCanvas.GetPixel(x as Integer,y as Integer) as Integer
    GetDevice
    Return .GetPixel(Handle,x,y)
    ReleaseDevice
end function

sub QCanvas.TextOut(x as Integer,y as Integer,s as String)
    this.TextOut(x,y,s,TextColor,-1)
end sub

sub QCanvas.TextOut(x as Integer,y as Integer,s as String,FG as Integer,BK as Integer)
    GetDevice
    If BK = -1 then
       SetBKMode(Handle,TRANSPARENT)
       SetTextColor(Handle,FG)
       .TextOut(Handle,X,Y,s,Len(s)-1)
       SetBKMode(Handle,OPAQUE)
    Else
       SetBKColor(Handle,BK)
       SetTextColor(Handle,FG)
       .TextOut(Handle,X,Y,s,Len(s)-1)
    end If
    ReleaseDevice
end sub

sub QCanvas.DrawText(v as string,l as integer,r as rect,f as uint)
     GetDevice
     .DrawText(Handle,v,l,@r,f)
     ReleaseDevice
end sub

sub QCanvas.Draw(x as Integer,y as Integer,Image as Any Ptr)
     GetDevice
       dim as hdc dc=CreateCompatibleDC(fHandle)
       DeleteObject(SelectObject(dc,image))
       BitBlt(fhandle,x,y,cx,cy,dc,0,0,srccopy)
       DeleteObject(DC)
     ReleaseDevice
end sub

sub QCanvas.StretchDraw(x as Integer,y as Integer,nWidth as Integer,nHeight as Integer,Image as Any Ptr)
    GetDevice
    dim as hdc dc=CreateCompatibleDC(0)
    DeleteObject(SelectObject(dc,image))
    StretchBlt(fhandle,x,y,cx,cy,dc,0,0,nWidth,nHeight,srccopy)
    ReleaseDevice
end sub

sub QCanvas.CopyRect(Dest as Rect,Canvas as PCanvas,Source as Rect)
    GetDevice
    StretchBlt(fhandle,dest.left,dest.top,dest.right,dest.bottom,Canvas->handle,source.left,source.top,source.right,source.bottom,srccopy)
    ReleaseDevice
end sub

sub QCanvas.FloodFill(x as Integer,y as Integer,FillColor as Integer,FillStyle as QFillStyle)
    GetDevice
    .ExtFloodFill Handle,x,y,FillColor,FillStyle
    ReleaseDevice
end sub

sub QCanvas.FillRect(R as Rect,FillColor as Integer = -1)
    Static as HBRUSH B
    GetDevice
    If B then DeleteObject B
    If FillColor <> -1 then
       B = CreateSolidBrush(FillColor)
       .FillRect Handle,@R,B
    Else
       .FillRect(Handle,@R,FBrush)
    end If
    ReleaseDevice
end sub

sub QCanvas.DrawFocusRect(R as Rect)
    GetDevice
    .DrawFocusRect Handle,@R
    ReleaseDevice
end sub

function QCanvas.TextWidth(FText as String) as Integer
    dim Sz as SIZE
    GetDevice
    GetTextExtentPoint32(Handle,FText,Len(FText),@Sz)
    ReleaseDevice
    Return Sz.cX
end function

function QCanvas.TextHeight(FText as String) as Integer
    dim Sz as SIZE
    GetDevice
    GetTextExtentPoint32(Handle,FText,Len(FText),@Sz)
    ReleaseDevice
    Return Sz.cY
end function

sub QCanvas.Paint(byref m as QMessage)
    ''do what you want to do here in paint event
    SetBKMode(fHandle,TRANSPARENT)
    SetBKColor(fHandle,fColor)
    SetTextColor(fHandle,fTextColor)
    SetBKMode(fHandle,OPAQUE)/''/
    if onPaint then onPaint(*fFrame)
end sub

property QCanvas.Bmp as hbitmap
    return fBmp
end property

property QCanvas.Bmp (v as hbitmap)
    dim as bitmap B
    if GetObject(v,sizeof(B),@B) then
       dim as hdc dc=CreateCompatibleDC(0)
       fBmp=CreateCompatibleBitmap(dc,B.bmWidth,B.bmHeight)
       DeleteObject(SelectObject(dc,v))
       
       this.draw(0,0,v)
       
       DeleteObject(SelectObject(fhandle,fbmp))
       DeleteObject(DC)
    end if
end property

property QCanvas.Color as colorref
    if fHandle then fColor=GetDCBrushColor(fHandle)
    return fColor
end property

property QCanvas.Color (v as colorref)
    fColor=v
    if fBrush then DeleteObject(fBrush)
    fBrush=CreateSolidBrush(v)
    DeleteObject(SelectObject(fHandle,fBrush))
    if fFrame then
       if isWindow(fFrame->Handle) then
          RedrawWindow(fFrame->Handle,0,0,rdw_erase or rdw_invalidate)
          UpdateWindow(fFrame->Handle)
       end if
    end if
    '''or SetDCBrushColor(fHandle,fColor), but we still need the brush...
end property

property QCanvas.TextColor as colorref
    return fTextColor
end property

property QCanvas.TextColor (v as colorref)
    fTextColor=v
    if fFrame then
       if isWindow(fFrame->Handle) then
          RedrawWindow(fFrame->Handle,0,0,rdw_erase or rdw_invalidate)
          UpdateWindow(fFrame->Handle)
       end if
    end if
end property

property QCanvas.Brush as hbrush
    return fBrush
end property

property QCanvas.Brush (v as hbrush)
    dim as logbrush lb
    if fBrush then DeleteObject(fBrush)
    if GetObject(v,sizeof(logbrush),@lb) then
       fBrush=CreateBrushIndirect(@lb)
       fColor=lb.lbColor
       if fFrame then
          if isWindow(fFrame->Handle) then
             RedrawWindow(fFrame->Handle,0,0,rdw_erase or rdw_invalidate)
             UpdateWindow(fFrame->Handle)
          end if
       end if
    end if
end property

property QCanvas.Pen as hpen
    return fPen
end property

property QCanvas.Pen (v as hpen)
    dim as logpen lp
    if GetObject(v,sizeof(lp),@lp) then
       fpen=CreatePenIndirect(@lp)
       if fFrame then
          if isWindow(fFrame->Handle) then
             RedrawWindow(fFrame->Handle,0,0,rdw_erase or rdw_invalidate)
             UpdateWindow(fFrame->Handle)
          end if
       end if
    end if
end property

property QCanvas.Frame as PFrame
    return fFrame
end property

property QCanvas.Frame (v as PFrame)
    fFrame=v
    if v then
       if isWindow(v->Handle) then
          Font=cast(hfont,SendMessage(fFrame->Handle,wm_getfont,0,0))
          RedrawWindow(v->Handle,0,0,rdw_erase or rdw_invalidate)
          UpdateWindow(v->Handle)
       end if
    end if
end property

operator QCanvas.cast as hdc
    return fHandle
end operator

operator QCanvas.cast as any ptr
    return @this
end operator

constructor QCanvas
    TextColor=0
end constructor

destructor QCanvas
end destructor

'''QConstraints
property QConstraints.Control as PFrame
    return fControl
end property

property QConstraints.Control (v as PFrame)
    fControl=v
    if v then v->Repaint
end property

property QConstraints.MinHeight as integer
    return fminheight
end property

property QConstraints.MinHeight (v as integer)
    fminheight=v
    if fControl then fControl->repaint
end property

property QConstraints.MaxHeight as integer
    return fmaxheight
end property

property QConstraints.MaxHeight (v as integer)
    fmaxheight=v
    if fControl then fControl->repaint
end property

property QConstraints.MinWidth as integer
    return fminwidth
end property

property QConstraints.MinWidth (v as integer)
    fminwidth=v
    if fControl then fControl->repaint
end property

property QConstraints.MaxWidth as integer
    return fmaxwidth
end property

property QConstraints.MaxWidth (v as integer)
    fmaxwidth=v
    if fControl then fControl->repaint
end property

operator QConstraints.cast as rect
    return type<rect>(fMinWidth,fMinHeight,fMaxWidth,fMaxHeight)
end operator

operator QConstraints.Let(v as rect)
    fMinWidth=v.left
    fMinHeight=v.top
    fMaxWidth=v.right
    fMaxHeight=v.top
    if fControl then fControl->Repaint
end operator

constructor QConstraints(x as integer=0,y as integer=0,cx as integer=0,cy as integer=0)
    fMinWidth=x
    fMinHeight=y
    fMaxWidth=cx
    fMaxHeight=cy
end constructor

constructor QConstraints(v as PRect=0)
    if v then
       fMinWidth=v->left
       fMinHeight=v->top
       fMaxWidth=v->right
       fMaxHeight=v->top
    end if
end constructor

'''QFrame
constructor QFrame
    fenabled=true
    fvisible=true
    Canvas.Frame=@this
    Canvas.Color=GetSysColor(color_window)
    Constraints.Control=this
    Clipped=true
end constructor

destructor QFrame
    if fParent then fParent->RemoveControl(this)
    for i as integer=0 to fControlCount-1
         if isWindow(fControls[i]->handle) then fControls[i]->DestroyHandle
    next
    if isWindow(fHandle) then DestroyHandle
    fhandle=0
end destructor

function QFrame.ReadProperty(byref p as string) as any ptr
    select case lcase(p)
    case "proc"
         return this.fPrevProc
    case "text"
         return cast(zstring ptr,strptr(fText))
    case "controlstyle"
         return cast(any ptr,fControlStyle)
    case "cursor"
         return fCursor
    case "align"
         return cast(any ptr,fAlign)
    case "parent"
         return cast(any ptr,fParent)
    case "parentwidow"
         return cast(any ptr,fParentwindow)
    case "style"
         return cast(any ptr,fstyle)
    case "exstyle"
         return cast(any ptr,fexstyle)
    case "id"
         return cast(any ptr,fid)
    case "left"
         return cast(any ptr,@fx)
    case "top"
         return cast(any ptr,@fy)
    case "width"
         return cast(any ptr,@fcx)
    case "height"
         return cast(any ptr,@fcy)
    case "enabled"
         return cast(any ptr,@fenabled)
    case "visible"
         return cast(any ptr,@fvisible)
    case "clipping"
         return cast(any ptr,@fClipped)
    case "tabstop"
         return cast(any ptr,@ftabstop)
    case "grouped"
         return cast(any ptr,@fgrouped)
    'case "control"

    case "controlcount"
         return cast(any ptr,fcontrolcount)
    case "clientwidth"
         return cast(any ptr,fclientwidth)
    case "clientheight"
         return cast(any ptr,fclientheight)
    case "clientrect"
         return cast(any ptr,@fclientrect)
    case "windowrect"
         return cast(any ptr,@fwindowrect)
    case else
         messageDlg("No such kind of property.","QFrame",mb_iconexclamation)
    end select
end function

function QFrame.WriteProperty(byref p as string, v as any ptr) as boolean
    select case lcase(p)
    case "proc"
         this.proc=v
    case "text"
         this.text=*cast(zstring ptr,v)
    case "controlstyle"
         this.controlstyle=cast(QControlStyle,v)
    case "cursor"
         this.cursor=cast(hcursor,v)
    case "align"
         this.align=cast(QAlign,v)
    case "parent"
         this.parent=v
    case "parentwidow"
         this.parentwindow=cast(hwnd,v)
    case "style"
         this.style=*cast(integer ptr,v)
    case "exstyle"
         this.exstyle=*cast(integer ptr,v)
    case "id"
         this.id=*cast(integer ptr,v)
    case "left"
         this.left=*cast(integer ptr,v)
    case "top"
         this.top=*cast(integer ptr,v)
    case "width"
         this.width=*cast(integer ptr,v)
    case "height"
         this.height=*cast(integer ptr,v)
    case "enabled"
         this.enabled=*cast(boolean ptr,v)
    case "visible"
         this.visible=*cast(boolean ptr,v)
    case "clipping"
         this.clipped=*cast(boolean ptr,v)
    case "tabstop"
         this.tabstop=*cast(boolean ptr,v)
    case "grouped"
         this.grouped=*cast(boolean ptr,v)
    case "control"
    case "controlcount"
    case "clientwidth"
         this.clientwidth=*cast(integer ptr,v)
    case "clientheight"
         this.clientheight=*cast(integer ptr,v)
    case "clientrect"
         this.clientrect=*cast(rect ptr,v)
    case "windowrect"
         this.windowrect=*cast(rect ptr,v)
    case else
         messageDlg("No such property.","QFrame",mb_iconexclamation)
         return false
    end select
    return true
end function

function QFrame.Perform (m as QMessage) as lresult
    return SendMessage(m.dlg,m.msg,m.wparam,m.lparam)
end function

function QFrame.Perform (msg as uint,wparam as wparam,lparam as lparam) as lresult
    return SendMessage(fHandle,msg,wparam,lparam)
end function

sub QFrame.Click
    if onclick then onclick(this)
end sub

sub QFrame.DblClick
    if onDblclick then onDblclick(this)
end sub

sub QFrame.Create
    ' do nothing
end sub

function QFrame.Register(sClassName as string="",sClassAncestor as string="",wproc as wndproc=@DefWindowProc) as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    if sClassName="" and sClassAncestor="" then exit function
    if sClassName="" and sClassAncestor<>"" then exit function
    if (GetClassInfoEx(0,sClassAncestor,@wc)>0) /'or (GetClassInfoEx(instance,sClassAncestor,@wc)>0)'/ then
       wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
       wc.lpszclassname=strptr(sClassName)
       wc.hinstance=instance
       wc.lpfnwndproc=wproc
       wc.cbwndextra +=4
    end if
    return RegisterClassEx(@wc)
end function'

sub QFrame.SetBounds(x as integer,y as integer,cx as integer,cy as integer)
    fx=x
    fy=y
    fcx=cx
    fcy=cy
    if isWindow(fHandle) then MoveWindow(fHandle,fx,fy,fcx,fcy,1)
end sub

sub QFrame.SetBounds(v as rect)
    fx=v.left
    fy=v.top
    fcx=v.right
    fcy=v.bottom
    if isWindow(fHandle) then MoveWindow(fHandle,fx,fy,fcx,fcy,1)
end sub

sub QFrame.AddControl(value as PFrame)
    if indexOfControl(value) = -1 then
        fcontrolcount += 1
        fcontrols = reallocate(fcontrols,sizeof(PFrame)*fcontrolcount)
        fcontrols[fcontrolcount-1] = value
    end if
end sub

sub QFrame.RemoveControl(value as PFrame)
    dim as integer i = IndexOfControl(value)
    if i <>-1 then
        fcontrols[i] = null
        for i as integer = i+1 to fcontrolcount-1
            fcontrols[i-1] = fcontrols[i+1]
        next
        fcontrolcount -= 1
        fcontrols = reallocate(fcontrols,sizeof(PFrame)*fcontrolcount)
    end if
end sub

function QFrame.IndexOfControl(value as PFrame) as integer
    for i as integer = 0 to fcontrolcount-1
        if fcontrols[i] = value then return i
    next
    return -1
end function

sub QFrame.InsertControl(value as PFrame)
    AddControl(value)
    if value then if value->fparent then value->fparent->requestAlign
end sub

sub QFrame.RequestAnchor
    if anchor.left then
       left=left+anchor.dx
       Width=Width-anchor.dx
    end if
    if anchor.top then
       top=top+anchor.dy
       height=height-anchor.dy
    end if
    if anchor.right then
       width=width-anchor.dx
    end if
    if anchor.bottom then
       height=height-anchor.dy
    end if
end sub

sub QFrame.RequestAlign
     dim as PFrame ptr ListLeft, ListRight, Listtop, ListBottom, ListClient
     dim as integer i,LeftCount = 0, RightCount = 0, topCount = 0, BottomCount = 0, ClientCount = 0
     dim as integer ttop, btop, lLeft, rLeft
     dim as integer aLeft, atop, aWidth, aHeight
     if ControlCount = 0 then exit sub
     lLeft = 0
     rLeft = ClientWidth
     ttop  = 0
     btop  = ClientHeight
     for i = 0 to fControlCount -1
         aleft = fcontrols[i]->left
         atop = fcontrols[i]->top
         awidth = fcontrols[i]->width
         aheight = fcontrols[i]->height
         select case fcontrols[i]->Align
                case 1'alLeft
                    LeftCount += 1
                    ListLeft = reallocate(ListLeft,sizeof(PFrame)*LeftCount)
                    ListLeft[LeftCount -1] = fcontrols[i]
                case 2'alRight
                    RightCount += 1
                    ListRight = reallocate(ListRight,sizeof(PFrame)*RightCount)
                    ListRight[RightCount -1] = fcontrols[i]
                case 3'altop
                    topCount += 1
                    Listtop = reallocate(Listtop,sizeof(PFrame)*topCount)
                    Listtop[topCount -1] = fcontrols[i]
                case 4'alBottom
                    BottomCount += 1
                    ListBottom = reallocate(ListBottom,sizeof(PFrame)*BottomCount)
                    ListBottom[BottomCount -1] = fcontrols[i]
                case 5'alClient
                    ClientCount += 1
                    ListClient = reallocate(ListClient,sizeof(PFrame)*ClientCount)
                    ListClient[ClientCount -1] = fcontrols[i]
          end select
     next i

   for i = 0 to topCount -1
      with *Listtop[i]
         if .fvisible then
            ttop += .Height
            .SetBounds(0,ttop - .Height,rLeft,.Height)
                if .anchor.left then .SetBounds(aleft,ttop - .Height,rLeft,.Height)
                if .anchor.right then .SetBounds(aleft,ttop - .Height,rLeft,aheight)
         end if
      end with
   next i
   'btop = ClientHeight
   for i = 0 to BottomCount -1
      with *ListBottom[i]
         if .fvisible then
            btop -= .Height
            .SetBounds(0,btop,rLeft,.Height)
         end if
      end with
   next i
   'lLeft = 0
   for i = 0 to LeftCount -1
      with *ListLeft[i]
         if .fvisible then
            lLeft += .Width
            .SetBounds(lLeft - .Width, ttop, .Width, btop - ttop)
         end if
      end with
   next i
   'rLeft = ClientWidth
   for i = 0 to RightCount -1
      with *ListRight[i]
         if .fvisible then
            rLeft -= .Width
            .SetBounds(rLeft, ttop, .Width, btop - ttop)
         end if
      end with
   next i
   for i = 0 to ClientCount -1
      with *ListClient[i]
         if .fvisible then
            .SetBounds(lLeft,ttop,rLeft - lLeft,btop - ttop)
         end if
      end with
   next i
    if ListLeft   then deallocate ListLeft
    if ListRight  then deallocate ListRight
    if Listtop    then deallocate Listtop
    if ListBottom then deallocate ListBottom
    if ListClient then deallocate ListClient
end sub

sub QFrame.BringToFront
    if IsWindow(fhandle) then
        'dim as HWND Dlg = GetTopWindow(fhandle)
        'while ( Dlg )
        '    foldz += 1
        '    GetnextWindow( Dlg, GW_HWNDnext)
        'wend
        foldZ = IndexOfControl(@this)
        BringWindowToTop(fhandle)
    end if
end sub

sub QFrame.SendToBack
    if IsWindow(fhandle) then
        SetWindowPos(fhandle,fcontrols[foldz]->handle, 0, 0 ,0 ,0, SWP_NOMOVE or SWP_NOACTIVATE or SWP_NOSIZE)
    end if
end sub

sub QFrame.SetFocus
    if IsWindow(fhandle) then .SetFocus(fhandle)
end sub

sub QFrame.KillFocus
    if IsWindow(fhandle) then Perform(WM_KILLFOCUS, 0, 0)
end sub

sub QFrame.Invalidate
    if IsWindow(fhandle) then InvalidateRect(fhandle, 0, 0)
end sub

sub QFrame.Repaint
    if IsWindow(fhandle) then RedrawWindow(fhandle, 0, 0, RDW_INTERNALPAINT)
end sub

sub QFrame.Refresh
    if IsWindow(fhandle) then RedrawWindow(fhandle, 0, 0, RDW_ERASE or RDW_INVALIDATE)
end sub

sub QFrame.ClientToScreen(byref p as point)
    if IsWindow(fhandle) then .ClientToScreen(fhandle,@p)
end sub

sub QFrame.ScreenToClient(byref p as point)
    if IsWindow(fhandle) then .ScreenToClient(fhandle,@p)
end sub

property QFrame.Clipped as boolean
    if isWindow(fHandle) then
       fClipped=GetWindowLong(fHandle,gwl_style) and (ws_clipchildren or ws_clipsiblings)
    end if
    return fClipped
end property

property QFrame.Clipped (v as boolean)
    fClipped=v
    if v then
       if fStyle and (ws_clipsiblings or ws_clipchildren)=0 then Style=Style or (ws_clipsiblings or ws_clipchildren)
    end if
    if not v then
       if fStyle and (ws_clipsiblings or ws_clipchildren)>0 then Style=Style and not (ws_clipsiblings or ws_clipchildren)
    end if
end property

property QFrame.ControlStyle as integer
    return fControlStyle
end property

property QFrame.ControlStyle(v as integer)
    if v<3 then
       fControlStyle=v
    else
       fControlStyle=0
    end if
    if csTransparent and v=csTransparent then 
       if isWindow(fHandle) then
          ExStyle=ExStyle or ws_ex_transparent
       end if 
    end if            
end property

property QFrame.Id as integer
    if isWindow(fHandle) then
       fid=GetWindowLong(fHandle,gwl_id)
    end if
    return fid
end property

property QFrame.Id (v as integer)
    fid=v
    if isWindow(fhandle) then SetWindowLong(fhandle,gwl_id,fid)
end property

property QFrame.ClientWidth as integer
    if isWindow(fHandle) then
       GetClientRect(fHandle,@fClientRect)
       fClientWidth=fClientRect.Right
    end if
    return fclientwidth
end property

property QFrame.ClientWidth(value as integer)
end property

property QFrame.ClientHeight as integer
    if isWindow(fHandle) then
       GetClientRect(fHandle,@fClientRect)
       fClientHeight=fClientRect.Bottom
    end if
    return fclientheight
end property

property QFrame.ClientHeight(value as integer)
end property

property QFrame.ClientRect as rect
    if isWindow(fHandle) then GetClientRect(fHandle,@fclientrect)
    return fclientrect
end property

property QFrame.ClientRect(value as rect)
end property

property QFrame.WindowRect as rect
    if isWindow(fHandle) then GetWindowRect(fHandle,@fwindowrect)
    return fwindowrect
end property

property QFrame.WindowRect(v as rect)
end property

property QFrame.Proc as wndproc
    if isWindow(fhandle) then
       fdlgproc=cast(wndproc,GetWindowLong(fHandle,gwl_wndproc))
    else
        dim as wndclassex wcls
        wcls.cbsize=sizeof(wcls)
        if GetClassInfoEx(instance,ClassName,@wcls) then
           fdlgproc=wcls.lpfnwndproc
        end if
    end if
    return fdlgproc
end property

property QFrame.Proc(v as wndproc)
    if v<>GetWindowLong(fHandle,gwl_wndproc) then
       fdlgproc=v
       fprevproc=cast(wndproc,SetWindowLong(fHandle,gwl_wndproc,cint(v)))
    end if
end property

property QFrame.Align as integer
    return falign
end Property

property QFrame.Align(value as integer)
    falign = value
    if fparent then
       fparent->RequestAlign
       fParent->Repaint
    end if
end Property

property QFrame.ControlCount as integer
    return fcontrolcount
end property

property QFrame.ControlCount(value as integer)
    '''do nothing
end property

property QFrame.Control(index as integer) as PFrame
    if index>-1 and index<fControlCount then
       return fcontrols[index]
    end if
    return null
end property

property QFrame.Control(index as integer,value as PFrame)
    ''' do nothing
end property

property QFrame.Text as string
    if isWindow(fHandle) then
       dim as integer i=GetWiNdowTextLength(fHandle)
       fText=space(i)+chr(0)
       GetWindowText(fHandle,fText,len(fText))
    end if
    return fText
end property

property QFrame.Text (v as string)
    fText=v
    if isWindow(fHandle) then SetWindowText(fHandle,fText)
end property

property QFrame.Parent as PFrame
    if IsWindow(fhandle) then
       fparent = W_Frame(fhandle).fParent
    end if
    return fParent
end property

property QFrame.Parent (v as PFrame)
    if fParent then fParentWindow=fParent->fHandle
    dim as PFrame saveParent=fParent
    fParent=v
    if v then fParentWindow=v->fhandle
    if IsWindow(fHandle) then
       SetParent(fHandle,fParentWindow)
       if SaveParent then SaveParent->RemoveControl(this)
       if fParent then fParent->AddControl(this)
    else
       if fParent then fParent->AddControl(this)
       CreateHandle  :? fhandle, syserrormessage
    end if
end property

property QFrame.ParentWindow as hwnd
    if isWindow(fHandle) then
       fParentWindow=GetParent(fHandle)
       if isWindow(fParentWindow) then fParent=W_Frame(fParentWindow)
    end if
    return fParentWindow
end property

property QFrame.ParentWindow (v as hwnd)
    fParentWindow=v
    if isWindow(fParentWindow) then fParent=W_Frame(fParentWindow)
    SetParent(fHandle,v)
end property

operator QFrame.cast as any ptr
    return @this
end operator

sub QFrame.ForceHandle
    CreateHandle
end sub

sub QFrame.RegisterProc(dlgproc as wndproc)
    wc.cbsize=sizeof(wc)
    wc.style=cs_dblclks or cs_owndc or cs_globalclass
    if GetClassInfoEx(0,ClassAncestor,@wc)=0 then
       wc.hcursor=crDefault
       'wc.hbrbackground=cast(hbrush,16)
    end if
    wc.lpszclassname=strptr(ClassName)
    wc.hinstance=instance
    wc.lpfnwndproc=dlgproc
    wc.cbwndextra +=4
    RegisterClassEx(@wc)
end sub

sub QFrame.ReCreateHandle
    DestroyHandle
    CreateHandle
end sub

sub QFrame.CreateHandle
    wc.cbsize=sizeof(wc)
    if GetClassInfoEx(instance,ClassName,@wc) then
       CreationData=this
       if CompareText(classname,"qcheckbox") then
          fStyle=ws_child or bs_autocheckbox
       elseif CompareText(classname,"qradiobutton") then
          fStyle=ws_child or bs_autoradiobutton
       elseif CompareText(classname,"qgroupbox") then
          fStyle=ws_child or bs_groupbox
       end if
       CreateWindowEx(fExStyle,ClassName,fText,fStyle or ws_clipchildren or ws_clipsiblings,fx,fy,fcx,fcy,fParentWindow,0,instance,0)
       if isWindow(fHandle) then
          if Cursor=0 then Cursor=cast(hcursor,GetClassLong(fHandle,gcl_hcursor))
          if fParent then fParent->ReQuestAlign
          EnableWindow(fHandle,fEnabled)
          ShowWindow(fHandle,iif(fvisible,sw_show,sw_hide))
          SetWindowLong(fHandle,gwl_id,fid)
          UpdateWindow(fHandle)
       end if
    else
       MessageBox(fParentWindow,"Can''t find the class.",ClassName,mb_applmodal or mb_topmost)
    end if
end sub

sub QFrame.DestroyHandle
    if IsWindow(fHandle) then
       DestroyWindow(fHandle)
       fHandle=0
    end if
end sub

sub QFrame.Dispatch(byref message as QMessage)
    dim as integer dx,dy,x,y,nx,ny,lx,ly
    select case message.msg
    case rtti_set
         message.result=0
         CreationParams=cast(PCreationParams,message.lparam)
         if CreationParams then
            this.ClassName=Q_CreationParams(CreationParams).ClassName
            this.ClassAncestor=Q_CreationParams(CreationParams).ClassAncestor
            this.ExStyle=Q_CreationParams(CreationParams).ExStyle
            this.Style=Q_CreationParams(CreationParams).Style
            this.width=Q_CreationParams(CreationParams).cx
            this.height=Q_CreationParams(CreationParams).cy
            this.Proc=Q_CreationParams(CreationParams).Proc
            message.result=len(*CreationParams)
         end if
    case rtti_get
         message.result=0
         CreationParams=cast(PCreationParams,message.lparam)
         if CreationParams then
            Q_CreationParams(CreationParams).ClassName=this.ClassName
            Q_CreationParams(CreationParams).ClassAncestor=this.ClassAncestor
            Q_CreationParams(CreationParams).ExStyle=this.ExStyle
            Q_CreationParams(CreationParams).Style=this.Style
            Q_CreationParams(CreationParams).cx=this.width
            Q_CreationParams(CreationParams).cy=this.height
            Q_CreationParams(CreationParams).Proc=this.Proc
            message.result=len(*CreationParams)
         end if /''/
    case wm_erasebkgnd
         if ClassAncestor="" then
            GetClientRect(fHandle,@fClientRect)
            FillRect(cast(hdc,message.wparam),@fclientrect,Canvas.Brush)
         end if
         message.result=0
    case wm_paint
         dim as QCanvasMessage cm
         Canvas.Handle=GetDC(fHandle)
         cm.Handle=Canvas.Handle
         message.Painted=@cm
         Canvas.Paint(message)
         if onPaint then onPaint(this)
         message.result=0
    case wm_ctlcolordlg to wm_ctlcolorstatic
         message.result=SendMessage(cast(hwnd,message.lparam),cm_ctlcolor,message.wparam,message.wparam)
         exit sub
    case wm_nccreate:
         dim as zstring*255 s
         dim as integer l = getclassname(fhandle,s,255)
         classname = .left(s,l)
         SetWindowLongPtr(fhandle,GetClassLong(fhandle,gcl_cbwndextra)-4,cint(@this))
         GetWindowRect(fHandle,@fwindowrect)
         GetClientRect(fHandle,@fclientrect)
         fstyle = GetwindowLong(fhandle,GWL_STYLE)
         fexstyle = GetwindowLong(fhandle,GWL_EXSTYLE)
         GetWindowRect(fHandle,@fwindowrect)
         GetClientRect(fHandle,@fclientrect)
         MapWindowPoints(fHandle,GetParent(fHandle),cast(point ptr,@fwindowrect),2)
         fx=fwindowrect.left
         fy=fwindowrect.top
         fcx=fwindowrect.right-fwindowrect.left
         fcy=fwindowrect.bottom-fwindowrect.top
         fclientwidth=fclientrect.right'
         fclientheight=fclientrect.bottom
         fbordersize=makelong(GetSystemMetrics(sm_cxborder),GetSystemMetrics(sm_cyborder))
         CreationData=0
         message.result = 0
    case wm_create
         for i as integer=0 to fControlCount-1
             if isWindow(fControls[i]->fHandle)=0 then fControls[i]->Parent=this
         next
         if onCreate then onCreate(this)
         message.result=0
    case wm_destroy
         if Canvas.Handle then
            ReleaseDC(fHandle,Canvas.Handle)
         end if
         if onDestroy then onDestroy(this)
         fHandle=0
         message.result=message.wparam
    case wm_entersizemove
         dx=ClientWidth
         dy=ClientHeight
         message.result = 0
    case wm_exitsizemove
         'ReleaseCapture
         message.result = 0
    case wm_size
         fclientrect = type<rect>(0,0,loword(message.lparam),hiword(message.lparam))
         anchor.dx=ClientWidth-dx
         anchor.dy=ClientHeight-dy
         /''/if (fcontrolcount>0) then
            RequestAlign
            RequestAnchor
         end if
         message.result = 0
    case wm_getminmaxinfo
         dim as lpminmaxinfo mif=cast(lpminmaxinfo,message.lparam)
         if mif then
               if Constraints.MinWidth>0 then mif->ptMaxTrackSize.x=Constraints.MinWidth
               if Constraints.MinHeight>0 then mif->ptMaxTrackSize.y=Constraints.MinHeight
               if Constraints.MaxWidth>0 then mif->ptMaxTrackSize.x=Constraints.MaxWidth
               if Constraints.MaxHeight>0 then mif->ptMaxTrackSize.y=Constraints.MaxHeight
               GetWindowRect(fHandle,@fwindowrect)
               GetWindowRect(fHandle,@fclientrect)
            message.result=0
         end if
         message.result=0
    case wm_windowposchanging
         dim as lpwindowpos wp
         wp=cast(lpwindowpos,message.lparam)
         if wp then
            if Constraints.MaxWidth>0 then wp->cx=Constraints.MaxWidth
            if Constraints.MaxHeight>0 then wp->cy=Constraints.MaxHeight
            GetWindowRect(fHandle,@fwindowrect)
            GetWindowRect(fHandle,@fclientrect)
         end if
         message.result=0
    case wm_settext
         fText=*cast(zstring ptr,message.lparam)
         message.result=0
    case wm_stylechanged
         message.result=0
    case wm_close
         if this is QCustomForm then
             dim as integer CloseAction=1
             if Q_CustomForm(this).onClose then Q_CustomForm(this).onClose(this,closeAction)
             select case CloseAction
             case 0 : message.result=1: exit sub
             case 1 : ShowWindow(fhandle,sw_hide): fvisible=false: exit sub
             case 2 : ShowWindow(fHandle,sw_minimize): exit sub
             case 3 : ShowWindow(fHandle,sw_maximize): exit sub
             case 4 : DestroyWindow(fhandle): fvisible=false: message.result=0
             case else
                  message.result=1 : exit sub
             end select
         end if
    case wm_hscroll
         if isWindow(cast(hwnd,message.lparam)) then
            message.result=SendMessage(cast(hwnd,message.lparam),cm_hscroll,message.wparam,cint(fhandle))
         end if
         message.result=0
    case wm_vscroll
         if isWindow(cast(hwnd,message.lparam)) then
            message.result=SendMessage(cast(hwnd,message.lparam),cm_vscroll,message.wparam,cint(fhandle))
         end if
         message.result=0
    case wm_command
         fid=loword(message.wparam)
         dim as integer code=hiword(message.wparam)
         if isWindow(cast(hwnd,message.lparam)) then
             message.result=SendMessage(cast(hwnd,message.lparam),cm_command,makelong(fid,message.lparam),code)
             exit select
         end if
         if message.lparam=0 then
             if onMenu then onMenu(this,fid,code)
             message.result=0
         elseif message.lparam=1 then
             if onAccel then onAccel(this,fid,code)
             message.result=0
         end if
    case cm_command
         fid=loword(message.wparam)
         dim as integer code=message.lparam
         if onCommand then onCommand(this,code,fid,cast(hwnd,hiword(message.wparam)))
         message.result=0
    case wm_notify
         dim as lpnmhdr nm=cast(lpnmhdr,message.lparam)
         if nm then
            message.result=SendMessage(nm->hwndFrom,cm_notify,0,message.lparam)
         else
            message.result=0
         end if
    case cm_notify
         dim as lpnmhdr nm=cast(lpnmhdr,message.lparam)
         if (nm>0) then
            select case message.msg
            case nm_click
                 Click
                 message.result=0
            case nm_dblclk
                 DblClick
                 message.result=0
            end select
         else
            message.result=0
         end if
    case wm_parentnotify
         select case loword(message.wparam)
         case wm_create
              message.result=0
         case wm_destroy
              message.result=0
         case wm_lbuttondown
              message.result=0
         case wm_mbuttondown
              message.result=0
         case wm_rbuttondown
              message.result=0
         case wm_xbuttondown
              message.result=0
         end select
         message.result=0
    case wm_cancelmode
        if GetCapture = message.dlg then
            ReleaseCapture
            SendMessage(message.dlg,WM_LBUTTONUP,0,&HFFFFFFFF)
        end if
        Message.Result = 0
    case wm_setfocus
         if fParent then
            fParent->fSelected=this
         end if
         message.result=0
    case wm_killfocus
         if fParent then if this=fParent->fSelected then fParent->fSelected=0
         message.result=0
    case wm_keydown
         if message.wparam=vk_tab then
            if fParent then
               nextID=fParent->indexOfControl(this)+1
               if nextID>fParent->fControlCount-1 then nextID=0
               Perform(wm_nextdlgctl,nextID,cint(fParent->fControls[nextID]))
            end if
         end if
         if onKeyDown then onKeyDown(This,cast(word,message.wparam),message.wparam and &hffff)
         message.result=0
    case wm_keyup
         if onKeyUp then onKeyUp(This,cast(word,message.wparam),message.wparam and &hffff)
         message.result=0
    case wm_char
         if onKeyPress then onKeyPress(This,cast(byte,message.wparam))
         message.result=0
    case wm_getdlgcode
         message.result=dlgc_wantallkeys
    case wm_nextdlgctl
         dim as PFrame nextCtrl=cast(PFrame,message.lparam)
         if nextCtrl then nextCtrl->SetFocus
         message.result = 0
    case wm_lbuttondblclk
         if onDblClick then onDblClick(this)
         message.result=0
    case wm_lbuttondown
         if classancestor="" then if onClick then onClick(this)
         if message.Captured then
            x=Q_Frame(captured).left
            y=Q_Frame(captured).top
            SendMessage(Captured->Handle,cm_mousemove,message.wparam,message.lparam)  :? "down"
         end if
         if onMouseDown then onMouseDown(this,1,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_lbuttonup
         if Captured then
            lx=loword(message.lparam)
            ly=hiword(message.lparam)
            SendMessage(Captured->Handle,cm_mousemove,message.wparam,message.lparam)
            Q_Frame(captured).left=x-lx
            RequestAlign
            Captured=0 :? "up"
            ReleaseCapture
         end if
         if onMouseUp then onMouseUp(this,1,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_mbuttondown
         if onMouseDown then onMouseDown(this,2,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_mbuttonup
         if onMouseUp then onMouseUp(this,2,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_rbuttondown
         if onMouseDown then onMouseDown(this,3,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_rbuttonup
         if onMouseUp then onMouseUp(this,3,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_mousemove
         if Captured then
            nx=loword(message.lparam)
            ny=hiword(message.lparam)
            SendMessage(Captured->Handle,cm_mousemove,message.wparam,message.lparam)
         end if
         if onMouseMove then onMouseMove(this,loword(message.lparam),hiword(message.lparam),message.wparam and &hFFFFF)
         message.result=0
    case wm_mousewheel
         If OnMouseWheel Then OnMouseWheel(This,Sgn(Message.wParam),loword(Message.lParam),hiword(Message.lParam),Message.wParam AND &HFFFF)
         message.result=0
    case wm_ctlcolormsgbox to wm_ctlcolorstatic
         message.result=SendMessage(cast(hwnd,message.lparam),cm_ctlcolor,message.wparam,0)
         exit sub
    case wm_setcursor
        if message.wparam = FHandle then
           dim as PFrame Ctrl=W_ClassObject(message.dlg) : ? "ctrl cursor=",Ctrl->Cursor,crArrow  :? "ctrl hit=",loword(message.lparam),htclient
           if loword(message.lparam)=htclient then
              SetCursor(Ctrl->Cursor)
              message.result=1
              exit select
           else
              message.result=0
           end if
        end if
        message.result=false
    case wm_mousefirst to wm_mouselast
        if (fstyle and ws_child) then
            if fdesignmode then
               message.result=1
               exit sub
            end if
        else
            message.result=0
        end if
    case wm_nchittest
        if (fstyle and ws_child) then
            if fdesignmode then
               message.result = HTTRANSPARENT
               exit sub
            end if
        else
           message.result = HTCLIENT
        end if
    end select
    DefaultHandler(message)
end sub

sub QFrame.DefaultHandler(byref message as QMessage)
    wc.cbsize=sizeof(wc)
    if ClassAncestor<>"" then
       if GetClassInfoEx(0,ClassAncestor,@wc) then
          message.result=CallWindowProc(wc.lpfnwndproc,fhandle,message.msg,message.wparam,message.lparam)
       else
          message.result=0
       end if
    else
       message.result=DefWindowProc(fhandle,message.msg,message.wparam,message.lparam)
    end if
end sub

property QFrame.Cursor as hcursor
    return fCursor
end property

property QFrame.Cursor(v as hcursor)
    fCursor=v  ':? "set cursor=", v,crdefault
    Invalidate
end property

property QFrame.Style as integer
    if isWindow(fHandle) then fStyle=GetWindowLong(fHandle,gwl_style)
    return fStyle
end property

property QFrame.Style (v as integer)
    fStyle=v
    if isWindow(fHandle) then
       if RecreateOnStyleApply then
          RecreateHandle
       else
       SetWindowLong(fHandle,gwl_style,v)
       SetWindowPos(fHandle,0,0,0,0,0,swp_nosize or swp_nomove or swp_noactivate or swp_nozorder or swp_framechanged)
       UpdateWindow(fHandle)
       end if
    end if
end property

property QFrame.ExStyle as integer
    if isWindow(fHandle) then fStyle=GetWindowLong(fHandle,gwl_exstyle)
    return fExStyle
end property

property QFrame.ExStyle (v as integer)
    fExStyle=v
    if isWindow(fHandle) then
       if RecreateOnStyleApply then
          RecreateHandle
       else
       SetWindowLong(fHandle,gwl_exstyle,v)
       SetWindowPos(fHandle,0,0,0,0,0,swp_nosize or swp_nomove or swp_noactivate or swp_nozorder or swp_framechanged)
       UpdateWindow(fHandle)
       end if
    end if
end property

property QFrame.Left as integer
    if isWindow(fHandle) then
       GetWindowRect(fHandle,@fclientrect)
       MapWindowPoints(0,GetParent(fHandle),cast(point ptr,@fclientrect),2)
       fx=fclientrect.Left
    end if
    return fx
end property

property QFrame.Left (v as integer)
    fx=v
    if isWindow(fHandle) then
       MoveWindow(fHandle,fx,fy,fcx,fcy,1)
       if fParent then fParent->RequestAlign
    end if
end property

property QFrame.Top as integer
    if isWindow(fHandle) then
       GetWindowRect(fHandle,@fclientrect)
       MapWindowPoints(0,GetParent(fHandle),cast(point ptr,@fclientrect),2)
       fy=fclientrect.Top
    end if
    return fy
end property

property QFrame.Top (v as integer)
    fy=v
    if isWindow(fHandle) then
       MoveWindow(fHandle,fx,fy,fcx,fcy,1)
       if fParent then fParent->RequestAlign
    end if
end property

property QFrame.Width as integer
    if isWindow(fHandle) then
       GetWindowRect(fHandle,@fclientrect)
       MapWindowPoints(0,GetParent(fHandle),cast(point ptr,@fclientrect),2)
       fcx=fclientrect.Right-fclientrect.Left
    end if
    return fcx
end property

property QFrame.Width (v as integer)
    fcx=v
    if isWindow(fHandle) then
       MoveWindow(fHandle,fx,fy,fcx,fcy,1)
       if fParent then fParent->RequestAlign
    end if
end property

property QFrame.Height as integer
    if isWindow(fHandle) then
       GetWindowRect(fHandle,@fclientrect)
       MapWindowPoints(0,GetParent(fHandle),cast(point ptr,@fclientrect),2)
       fcy=fclientrect.Bottom-fclientrect.Top
    end if
    return fcy
end property

property QFrame.Height (v as integer)
    fcy=v
    if isWindow(fHandle) then
       MoveWindow(fHandle,fx,fy,fcx,fcy,1)
       if fParent then fParent->RequestAlign
    end if
end property

property QFrame.Enabled as boolean
     if isWindow(fHandle) then fEnabled=IsWindowEnabled(fHandle)
     return fEnabled
end property

property QFrame.Enabled (v as boolean)
    fEnabled=v
    if isWindow(fHandle) then EnableWindow(fHandle,fEnabled)
end property

property QFrame.Visible as boolean
    if isWindow(fHandle) then fVisible=IsWindowVisible(fHandle)
    return fVisible
end property

property QFrame.Visible (v as boolean)
    fVisible=v
    if isWindow(fHandle) then  ShowWindow(fHandle,iif(v,sw_show,sw_hide))
end property

property QFrame.TabStop as boolean
    if isWindow(fHandle) then
       fTabStop=GetWindowLong(fHandle,gwl_style) and ws_tabstop
    end if
    return fTabStop
end property

property QFrame.TabStop (v as boolean)
    fTabStop=v
    if v then
       if fStyle and ws_tabstop=0 then fStyle or= ws_tabstop
    else
       if fStyle and ws_tabstop=ws_tabstop then fStyle = fStyle and not ws_tabstop
    end if
    if isWindow(fHandle) then SetWindowLong(fHandle,gwl_style,fStyle)
end property

property QFrame.Grouped as boolean
    if isWindow(fHandle) then
       fGrouped=GetWindowLong(fHandle,gwl_style) and ws_group
    end if
    return fGrouped
end property

property QFrame.Grouped (v as boolean)
    fGrouped=v
    if v then
       if fStyle and ws_group=0 then fStyle or= ws_group
    else
       if fStyle and ws_group=ws_group then fStyle = fStyle and not ws_group
    end if
    if isWindow(fHandle) then SetWindowLong(fHandle,gwl_style,fStyle)
end property

'''QCustomForm
function QCustomForm.ReadProperty(byref p as string) as any ptr
    return Base.ReadProperty(p)
end function

function QCustomForm.WriteProperty(byref p as string, v as any ptr) as boolean
    return Base.WriteProperty(p,v)
end function

function QCustomForm.WindowProc as wndproc
    return @QCustomForm.dlgProc
end function

function QCustomForm.dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
     dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QCustomForm
        dim as zstring*256 s
        dim as integer c=GetClassName(dlg,s,255)
        if obj then
           obj->classname=.left(s,c)
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function

sub QCustomForm.Dispatch(byref m as QMessage)
    Base.Dispatch(m)
    select case m.msg
    case wm_showwindow,wm_initdialog
         if onShow then onShow(this)
         m.result=0
    case wm_activate
         if hiword(m.wparam)=0 then
            select case loword(m.wparam)
            case wa_active,wa_clickactive
                 if onActivate then onActivate(this)
            case wa_inactive
                 if onDeActivate then onDeActivate(this)
            end select
         end if
    end select
end sub

property QCustomForm.MenuFromResource as string
    return fMenuFromResource
end property

property QCustomForm.MenuFromResource (v as string)
    fMenuFromResource=v
    if FindResource(instance,v,rt_menu) then
       Menu=LoadMenu(instance,v)
       SetMenu(fHandle,Menu)
       DrawMenuBar(fHandle)
    end if
end property

property QCustomForm.FormStyle as QFormStyle
    return fFormStyle
end property

property QCustomForm.FormStyle (v as QFormStyle)
    fFormStyle=v
    select case v
    case fsMDIChild
         if ExStyle and ws_ex_mdichild<>ws_ex_mdichild then ExStyle=ExStyle or ws_ex_mdichild
    case fsStayOnTop
         if ExStyle and ws_ex_topmost<>ws_ex_topmost then ExStyle=ExStyle or ws_ex_topmost
    case fsNormal
         if ExStyle and ws_ex_mdichild=ws_ex_mdichild then ExStyle=ExStyle and not ws_ex_mdichild
         if ExStyle and ws_ex_topmost=ws_ex_topmost then ExStyle=ExStyle and not ws_ex_topmost
    end select
end property

#ifdef IDesigner
      property QCustomForm.DesignMode as boolean
          return Designer.Active
      end property
      
      property QCustomForm.DesignMode(v as boolean)
          if Designer.Dialog=0 then Designer.Dialog=fHandle
          Designer.Active=v
      end property
#endif

sub QCustomForm.Close
    dim as integer Closeaction=4
    if application.isModal then application.domodal(0)
    if onClose then onclose(this,closeaction)
end sub

function QCustomForm.ShowModal as integer
    if not isWindow(fHandle) then
       this.parentwindow=mainwindow
       this.CreateHandle
       if isWindow(fHandle) then
          application.domodal(this)
          do
               application.doevents
          loop until fhandle=0
          application.domodal
       end if
    end if
    return fModalResult
end function

sub QCustomForm.Show
    if not isWindow(fHandle) then
       this.parentwindow=mainwindow
       this.CreateHandle
    end if
end sub

operator QCustomForm.cast as any ptr
    return @this
end operator

constructor QCustomForm
    fcx=450
    fcy=250
    fStyle=ws_overlappedwindow
    Canvas.Frame=@this
    Canvas.Color=GetSysColor(color_btnface)
end constructor

destructor QCustomForm
    this.DestroyHandle
end destructor


'''QApplication
IApplication=new QApplication

function QApplication.ReadProperty(byref p as string) as any ptr
end function

function QApplication.WriteProperty(byref p as string, v as any ptr) as boolean
end function

function QApplication.EnumWindowsProc(dlg as hwnd,lparam as lparam) as boolean
    dim as PCustomForm F
    dim as hwnd exclude=0
    if lparam then
       F=cast(PCustomForm,lparam)
       if F then exclude=F->Handle
       if dlg<>exclude then EnableWindow(dlg,false)
       application.fismodal=true
    else
       EnableWindow(dlg,true)
       application.fismodal=false
    end if
    return false
end function

property QApplication.isModal as boolean
    return fisModal
end property

sub QApplication.DoModal(v as PFrame=0)
    EnumThreadWindows(GetCurrentThreadId,cast(wndenumproc,@EnumWindowsProc),cast(lparam,v))
end sub

sub QApplication.Run
    dim as msg m
          'dim as string cn=classnameis(m.hwnd)
          'if cn="#32770" and not isDialogMessage(m.hwnd,@m) then
          'end if
    while GetMessage(@m,0,0,0)>0
          TranslateMessage(@m)
          DispatchMessage(@m)
    wend
end sub

sub QApplication.Quit
    PostQuitMessage(0)
end sub

sub QApplication.Terminate
    ExitProcess(0)
end sub

sub QApplication.DoEvents
    dim as MSG M
    if PeekMessage(@M, 0, 0, 0, PM_REMOVE) then
       if M.Message <> WM_QUIT then
           TranslateMessage @M
           DispatchMessage @M
       else
           if (GetWindowLong(M.hWnd,GWL_EXSTYLE) AND WS_EX_APPWINDOW) = WS_EX_APPWINDOW then end -1
       end if
    end If
end sub

operator QApplication.cast as any ptr
    return @this
end operator

operator QApplication.cast as hwnd
    return fHandle
end operator

operator QApplication.cast as hinstance
    return GetModuleHandle(0)
end operator

constructor QApplication
end constructor

destructor QApplication
end destructor


''module initialization
sub koganion_gui_initialization constructor
    __hnd=allocate(4)
end sub

sub koganion_gui_finalization destructor
    deallocate(__hnd)
end sub
