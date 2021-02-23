#include once "kogaion_gui_additional.bi"

property QCustomPanel.BorderStyle as integer
    return fBorderStyle
end property

property QCustomPanel.BorderStyle(v as integer)
    if v<4 then
       fborderstyle=v
    else
       fborderstyle=0
    end if
    Repaint
end property

property QCustomPanel.ImageBackground as string
    return fImageBackground
end property

property QCustomPanel.ImageBackground(v as string)
    fImageBackground=v
    if FileExists(v) then
       dim as string ext=ExtractFileExt(v)
       select case ext
       case ".bmp",".BMP":
            fImageHandle=LoadImage(0,v,image_bitmap,0,0,lr_loadfromfile)
       case ".ico",".ICO":
            fImageHandle=LoadImage(0,v,image_icon,0,0,lr_loadfromfile)
       case ".cur",".CUR":
            fImageHandle=LoadImage(0,v,image_cursor,0,0,lr_loadfromfile)
       case ".png",".PNG":
            fImageHandle=LoadImage(0,v,image_enhmetafile,0,0,lr_loadfromfile)
       end select
       Repaint
    end if
end property

property QCustomPanel.TextAlignment as integer
    return ftextalignment
end property

property QCustomPanel.TextAlignment (v as integer)
    ftextalignment=v
    if v>5 then ftextalignment=0
end property

function QCustomPanel.dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
     dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QPanel
        if obj then
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function

sub QCustomPanel.Dispatch(byref m as QMessage)
    Base.Dispatch(m) '''not forgot to inherite from base class
    select case m.msg
    case cm_ctlcolor
         SetBKMode(cast(hdc,m.wparam),transparent)
         SetBKColor(cast(hdc,m.wparam),Canvas.color)
         SetTextColor(cast(hdc,m.wparam),Canvas.textcolor)
         SetBKMode(cast(hdc,m.wparam),opaque)
         m.result=cint(Canvas.brush)
         exit sub
    case wm_lbuttondown
         click
         m.result=0
    case wm_erasebkgnd
         FillRect(Canvas.Handle,@fclientrect,canvas.brush)
         if this.fBorderStyle=1 then
            ExStyle=ExStyle or ws_ex_clientedge
         elseif this.fBorderStyle=2 then
            ExStyle=Exstyle and not ws_ex_clientedge
            DrawEdge(Canvas.Handle,@fclientrect,EDGE_SUNKEN,BF_RECT )
         elseif this.fBorderStyle=3 then
   	    ExStyle=Exstyle and not ws_ex_clientedge
            DrawEdge(Canvas.Handle,@fclientrect,EDGE_RAISED,BF_RECT )
         elseif this.fBorderStyle=4 then
   	    ExStyle=Exstyle and not ws_ex_clientedge
            DrawEdge(Canvas.Handle,@fclientrect,EDGE_BUMP,BF_RECT )
         end if
         m.result=0
    case wm_paint
         dim as integer drStyle
         Select Case fTextAlignment
            Case 0
             drStyle = DT_SINGLELINE or DT_LEFT or DT_VCENTER
            Case 1
             drStyle = DT_SINGLELINE or DT_CENTER or DT_VCENTER
            Case 2
             drStyle = DT_SINGLELINE or DT_RIGHT  or DT_VCENTER
            Case 3
             drStyle = DT_EDITCONTROL or DT_LEFT or DT_VCENTER Or DT_WORDBREAK
            Case 4
             drStyle = DT_EDITCONTROL or DT_CENTER or DT_VCENTER Or DT_WORDBREAK
            Case 5
             drStyle = DT_EDITCONTROL or DT_RIGHT or DT_VCENTER Or DT_WORDBREAK
         End Select
         if fBorderStyle>0 then InflateRect(@fclientrect, 2, 2)
         DrawText(Canvas.Handle, Text, -1, @fclientrect, drStyle)
         m.result=0
    end select
end sub

operator QCustomPanel.cast as any ptr
    return @this
end operator

constructor QCustomPanel
    classname="QPanel"
end constructor

/' QPanel '/
function QPanel.Register as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    wc.lpszclassname=@"QPanel"
    wc.hinstance=instance
    wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
    wc.lpfnwndproc=@QCustomPanel.dlgproc
    wc.hcursor=LoadCursor(0,idc_arrow)
    wc.cbwndextra +=4
    return RegisterClassEx(@wc)
end function

operator QPanel.cast as any ptr
    return @this
end operator

operator QPanel.cast as hwnd
    return fHandle
end operator

constructor QPanel
    fstyle=ws_child
    fexstyle=ws_ex_controlparent
    fcx=115
    fcy=51
    ftextAlignment=4
    Text="Panel"
end constructor

property QPanel.BorderStyle as integer  '''publish property
    return Base.BorderStyle
end property

property QPanel.BorderStyle(v as integer)
    Base.BorderStyle=v
end property

property QPanel.Alignment as integer  '''publish property
    return Base.TextAlignment
end property

property QPanel.Alignment(v as integer)
    Base.TextAlignment=v
end property

property QPanel.ImageBackground as string
    return Base.ImageBackground
end property

property QPanel.ImageBackground(v as string)
    Base.ImageBackground=v
end property

/' QCustomSplitter '/

Sub QCustomSplitter.DrawTrackSplit(x As Integer,y As Integer)
    Static As Word DotBits(7) =>{&H5555,&HAAAA,&H5555,&HAAAA,&H5555,&HAAAA,&H5555,&HAAAA}
    Dim As HBRUSH hbr
    Dim As HBITMAP Bmp
    dim as hdc Dc=GetDCEx(fParent->fHandle,0,dcx_cache or dcx_clipsiblings or dcx_lockwindowupdate)
    Bmp = CreateBitmap(8,8,1,1,@DotBits(0))
    hbr = SelectObject(Dc,CreatePatternBrush(Bmp))
    DeleteObject(Bmp)
    GetWindowRect(fHandle,@fclientrect)
    PatBlt(Dc,x,y,ClientWidth,ClientHeight,patinvert)
    DeleteObject(SelectObject(Dc,hbr))
    ReleaseDC(Parent->Handle,Dc)
End Sub

sub QCustomSplitter.Dispatch(byref m as QMessage)
    Base.Dispatch(m)
    select case m.msg
    case wm_create
         RequestAlign
    case wm_move
         fParent->RequestAlign
    case wm_lbuttondown
         ? "down"
         if fParent then fParent->Captured=this
         SetCapture(GetParent(fHandle))
         m.result=0
    case cm_mousemove
         x=loword(m.lparam)
         y=hiword(m.lparam)
         x2=this.Left
         y2=Top
         if down then
            select case Align
            case alLeft,alRight
                DrawTrackSplit(x,y)
                DrawTrackSplit(x1,y2)
            case alTop,alBottom
                DrawTrackSplit(x2,y)
                DrawTrackSplit(x2,y1)
            end select
         end if
         x1=loword(m.lparam)
         y1=hiword(m.lparam)
         m.result=0
    case cm_lbuttonup
         dim as integer i
         x=loword(m.lParam)
         y=hiword(m.lParam)
         if Down then Down=0
         select case Align
            case 1,2
                 DrawTrackSplit(x1,y2)
            case 3,4
                 DrawTrackSplit(x2,y1)
         end select
         this.left=x
         if fParent then fParent->Captured=0
         ReleaseCapture

         /'i=Parent->IndexOfControl(this)
         if i>-1 and Parent->ControlCount Then
               if Align = 1 Then
                  this.Left = x-this.Left
                  if i > 0 then Parent->Control(i-1)->Width = Parent->Control(i-1)->Width + this.Left
               elseif Align = 2 Then
                  this.Left = this.Left-x
                  if i > 0 then Parent->Control(i+1)->Width = Parent->Control(i+1)->Width + this.Left
               elseif Align = 3 then
                  Top=y-Top
                  if i > 0 then Parent->Control(i-1)->Height = Parent->Control(i-1)->Height + Top
               elseif Align = 4 then
                  Top=Top-y
                  if i > 0 then Parent->Control(i+1)->Height = Parent->Control(i+1)->Height + Top
               end if
               Parent->RequestAlign
               if onMoved then onMoved(This)
         else
               messageDlg("Splitter","Can't move controls.",mb_iconerror)
         end if'/
         m.result=0
    end select
end sub

function QCustomSplitter.dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
    dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QSplitter
        if obj then
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function


property QCustomSplitter.Align as integer
    return Base.Align
end property

property QCustomSplitter.Align(v as integer)
       :? "align=",v
    select case v
    case alLeft,alRight
        cursor=crSizeWE
        this.Width = 3
    case alTop,alBottom
        cursor=crSizeNS
        this.Height = 3
    case else
        cursor=crArrow
    end select
    Base.Align=v
end property

operator QCustomSplitter.cast as any ptr
    return @this
end operator

constructor QCustomSplitter
    ClassName="QSplitter"
    fCx=4
    fcy=221
    fStyle=ws_child or ws_visible
    'fExStyle=ws_ex_transparent
    fAlign=alLeft
end constructor

/' QSplitter '/
function QSplitter.Register as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    wc.lpszclassname=@"QSplitter"
    wc.hinstance=instance
    wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
    wc.lpfnwndproc=@QCustomSplitter.dlgproc
    wc.hcursor=LoadCursor(0,idc_arrow)
    wc.cbwndextra +=4
    return RegisterClassEx(@wc)
end function

operator QSplitter.cast as any ptr
    return @this
end operator

operator QSplitter.cast as hwnd
    return fHandle
end operator

''module initialization
sub Additional_initialization constructor
    QPanel.Register
    QSplitter.Register
end sub

sub Additional_finalization destructor
    unRegisterClass("QPanel",instance)
    unRegisterClass("QSplitter",instance)
end sub