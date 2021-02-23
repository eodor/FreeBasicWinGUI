'kogaion_gui_comctrls.bas -library windows controls wrapper
'this file is part of Koganion(RqWork7) rad-ide
'and can't be redistributed without permission
'Copyright (c)2020 Vasile Eodor Nastasa
'mail: nastasa.eodor@gmail.com
'web:http://www.rqwork.de

#include once "kogaion_gui_comctrls.bi"

/' QImageList '/
Property QImageList.Frame As PFrame
    Return fFrame
End Property

Property QImageList.Frame(Value As PFrame)
    fFrame = Value
    NotifyControl
End Property

Property QImageList.Width As Integer
    Return FWidth
End Property

Property QImageList.Width(Value As Integer)
    FWidth = Value
    ImageList_SetIconSize(Handle,FWidth,FHeight)
    NotifyControl
End Property

Property QImageList.Height As Integer
    Return FHeight
End Property

Property QImageList.Height(Value As Integer)
    FHeight = Value
    ImageList_SetIconSize(Handle,FWidth,FHeight)
    NotifyControl
End Property

Property QImageList.BKColor As Integer
    FBKColor = ImageList_GetBKColor(Handle)
    Return FBKColor
End Property

Property QImageList.BKColor(Value As Integer)
    FBKColor = Value
    ImageList_SetBKColor(Handle,FBKColor)
    NotifyControl
End Property

Property QImageList.Count As Integer
    FCount = ImageList_GetImageCount(Handle)
    Return FCount
End Property

Sub QImageList.NotifyControl
    If fFrame Then
        If isWindow(fFrame->Handle) Then RedrawWindow(fFrame->Handle,0,0,RDW_ERASE OR RDW_INVALIDATE)
    End If
End Sub

Sub QImageList.Create
    If Handle Then ImageList_Destroy Handle
    Handle = ImageList_Create(FWidth,FHeight,ILC_MASK OR ILC_COLOR32,AllocBy,AllocBy)
End Sub

Sub QImageList.AddBitmap(Bitmap As HBitmap,Mask As HBitmap)
    ImageList_Add(Handle,Bitmap,Mask)
End Sub

Sub QImageList.AddIcon(Icon As HIcon)
    ImageList_AddIcon(Handle,Icon)
End Sub

Sub QImageList.AddCursor(Cursor As HCursor)
    ImageList_AddIcon(Handle,Cursor)
End Sub

Sub QImageList.AddMasked(Bitmap As HBitmap,MaskColor As Integer)
    ImageList_AddMasked(Handle,Bitmap,MaskColor)
    NotifyControl
End Sub

Sub QImageList.Remove(Index As Integer)
    ImageList_Remove(Handle,Index)
End Sub

Function QImageList.GetBitmap(Index As Integer) As HBitmap
    Dim As HBitmap BMP
    Dim IMIF As IMAGEINFO
    ImageList_GetImageInfo(Handle,Index,@IMIF)
    bmp=IMIF.hbmImage 
    Return BMP
End Function

Function QImageList.GetMask(Index As Integer) As HBitmap
    Dim IMIF As IMAGEINFO
    Dim As HBitmap BMP
    'BMP = qCALlocate(SizeOF(HBitmap))
    ImageList_GetImageInfo(Handle,Index,@IMIF)
    BMP = IMIF.hbmMask
    Return BMP
End Function

Function QImageList.GetIcon(Index As Integer) As HIcon
    Dim As hIcon ICO
    ICO = ImageList_GetIcon(Handle,Index,DrawingStyle OR ImageType)
    Return ICO
End Function

Function QImageList.GetCursor(Index As Integer) As HCursor
    Dim As hCursor CUR
    CUR = ImageList_GetIcon(Handle,Index,DrawingStyle OR ImageType)
    Return CUR
End Function

Sub QImageList.DrawEx(Index As Integer,DestDC As HDC,X As Integer,Y As Integer,iWidth As Integer,iHeight As Integer,FG As Integer,BK As Integer)
    ImageList_DrawEx(Handle,Index,DestDC,X,Y,iWidth,iHeight,FG,BK,DrawingStyle OR ImageType)
End Sub

Sub QImageList.Draw(Index As Integer,DestDC As HDC,X As Integer,Y As Integer)
     ImageList_Draw(Handle,Index,DestDC,X,Y,DrawingStyle OR ImageType)
End Sub

Sub QImageList.Clear
    Dim As Integer i
    For i = 0 To Count -1
        ImageList_Remove(Handle,i)
    Next i
End Sub

Operator QImageList.Cast As Any Ptr
    Return @This
End Operator

Constructor QImageList
    AllocBy = 4
    FWidth  = 16
    FHeight = 16
    Handle = ImageList_Create(FWidth,FHeight,ILC_MASK OR ILC_COLORDDB,AllocBy,AllocBy)
End Constructor

Destructor QImageList
    If Handle Then ImageList_Destroy(Handle)
End Destructor

/' QToolButton '/
property QToolButton.ToolBar byref as QToolBar
    return *fToolBar
end property

property QToolButton.ToolBar (byref v as QToolBar)
    fToolBar=v
    if fToolBar then
       SendMessage(fToolBar->Handle,tb_addbuttons,1,cint(@fTBBUtton))
       if fToolBar->indexOf(this)=-1 then fToolBar->Buttons->add(this)
    end if
end property

property QToolButton.Style as integer
    return fTBButton.fsStyle
end property

property QToolButton.Style (v as integer)
    fTBButton.fsStyle=v
    if v=tbstyle_Sep then
       fTBButton.idCommand=-1
    else
       fTBButton.idCommand=qCAL.AllocateCID
    end if
end property

property QToolButton.Caption as string
    return *cast(zstring ptr,fTBButton.iString)
end property

property QToolButton.Caption (v as string)
    fTBButton.iString=cint(strptr(v))
    if (fToolBar>0) and (fTBButton.idCommand>0) then
       dim as tbbuttoninfo tbif
       tbif.cbSize=sizeof(tbif)
       tbif.dwMask=tbif_text or tbif_command
       if SendMessage(fToolBar->Handle,tb_getbuttoninfo,fTBButton.idCommand,cint(@tbif)) then  :? "tb c=",tbif.idcommand
          tbif.pszText=strptr(v)
          tbif.cchText=len(v)
          if SendMessage(fToolBar->Handle,tb_setbuttoninfo,fTBButton.idCommand,cint(@tbif))=0 then
             messagedlg("Error. Can't set caption.","ToolBar",mb_iconerror)
          end if
       end if
    end if /''/
end property

property QToolButton.Enabled as boolean
    return fEnabled
end property

property QToolButton.Enabled (v as boolean)
    fEnabled=v
    fTBButton.fsState=iif(v,tbstate_enabled,0)
    if (fToolBar>0) and (fTBButton.idCommand>0) then
       dim as tbbuttoninfo tbif
       tbif.cbSize=sizeof(tbif)
       tbif.dwMask=tbif_state or tbif_command
       if SendMessage(fToolBar->Handle,tb_getbuttoninfo,fTBButton.idCommand,cint(@tbif)) then  :? "tb c=",tbif.idcommand
          tbif.fsState=v
          if SendMessage(fToolBar->Handle,tb_setbuttoninfo,fTBButton.idCommand,cint(@tbif))=0 then
             messagedlg("Error. Can't set button state.","ToolBar",mb_iconerror)
          end if
       end if
    end if
end property

property QToolButton.ImageIndex as integer
    return fImageIndex
end property

property QToolButton.ImageIndex(v as integer)
    fImageIndex=v
    if fToolBar then
       dim as TBADDBITMAP adbs
       ToolButton.iBitmap=v
       SendMessage(fToolBar->Handle,tb_changebitmap,ToolButton.idCommand,v)
       /'adbs.hinst=instance
       adbs.nId=v
       SendMessage(fToolBar->Handle,tb_addbitmap,index,cint(@adbs))'/
    end if
end property

property QToolButton.Visible as boolean
    return fVisible
end property

property QToolButton.Visible (v as boolean)
    fVisible=v
    fTBButton.fsState=iif(v,0,tbstate_hidden)
end property

property QToolButton.Hint as string
    return fHint
end property

property QToolButton.Hint (v as string)
    fHint=v
end property

property QToolButton.ShowHint as boolean
    return fShowHint
end property

property QToolButton.ShowHint (v as boolean)
    fShowHint=v
end property

property QToolButton.ToolButton byref as TBBUTTON
    return fTBButton
end property

operator QToolButton.cast as any ptr
    return @this
end operator

operator QToolButton.cast as integer
    return fTBButton.idCommand
end operator

operator QToolButton.cast as TBBUTTON
    return fTBButton
end operator

constructor QToolButton
    classname="QToolButton"
    fVisible=true
    fEnabled=true
    index=-1
    fTBButton.iBitmap=-1
    fTBButton.idCommand=0
end constructor

destructor QToolButton
end destructor

/' QCustomToolBar '/
sub QCustomToolBar.Customize
    Perform(tb_customize,0,0)
end sub

sub QCustomToolBar.Click
    if onClick then onClick(this)
end sub

sub QCustomToolBar.DblClick
    if onDblClick then onDblClick(this)
end sub

sub QCustomToolBar.Change
    if onChange then onChange(this)
end sub

function QCustomToolBar.indexOf(v as PToolButton) as integer
    return fButtons.IndexOf(v)
end function

function QCustomToolBar.dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
     dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QToolBar
        if obj then
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function

sub QCustomToolBar.CreateHandle
    Base.CreateHandle
    if IsWindow(fHandle) then
       SendMessage(fhandle,tb_setimagelist,0,cint(fImages))
       dim as integer comVersion=SendMessage(fHandle,ccm_getversion,0,0)
       if comversion=0 then SendMessage(fHandle,ccm_setversion,cast(wparam,5),0)
       SendMessage(fHandle,tb_buttonstructsize,sizeof(tbbutton),0)
       SendMessage(fhandle,tb_setextendedstyle,0,tbstyle_ex_drawddarrows or iif(fDoublebuffered,tbstyle_ex_doublebuffer,0))
       SendMessage(fhandle,tb_setbuttonwidth,0,makelong(23,123))
       SendMessage(fhandle,tb_setbuttonsize,0,makelong(23,22))
    end if
end sub

sub QCustomToolBar.Dispatch(byref m as QMessage)
    Base.Dispatch(m) '''not forgot to inherite from base class
    select case m.msg
    case cm_notify
         dim as lpnmhdr nm=cast(lpnmhdr,m.lparam)
         if nm then
            select case nm->code
            case NM_CHAR '(toolbar)
            case NM_CLICK '(toolbar)
                 Click
            case NM_CUSTOMDRAW '(toolbar)
            case NM_DBLCLK '(toolbar)
                 DblClick
            case NM_KEYDOWN '(toolbar)
            case NM_LDOWN
            case NM_RCLICK '(toolbar)
            case NM_RDBLCLK '(toolbar)
            case NM_RELEASEDCAPTURE '(toolbar)
            case NM_TOOLTIPSCREATED '(toolbar)
            case TBN_BEGINADJUST
            case TBN_BEGINDRAG
            case TBN_CUSTHELP
            case TBN_DELETINGBUTTON
            case TBN_DRAGOUT
            case TBN_DRAGOVER
            case TBN_DROPDOWN
            case TBN_DUPACCELERATOR
            case TBN_ENDADJUST
            case TBN_ENDDRAG
            case TBN_GETBUTTONINFO
            case TBN_GETDISPINFO
                 dim as lptooltiptext tt=cast(lptooltiptext,m.lparam)
                 dim as integer bi=tt->hdr.idFrom
                 ? "button=",bi
                 m.result=0
            case TBN_GETINFOTIP
                 dim as LPNMTBGETINFOTIP nm=cast(LPNMTBGETINFOTIP,m.lparam)
                 dim as string s=Button(nm->iitem)->Hint+chr(0)
                 dim as lpstr lps=sadd(s)
                 nm->pszText=lps
                 nm->cchTextMax=len(*lps)
                 m.result=0
            case TBN_GETOBJECT
            case TBN_HOTITEMCHANGE
            case TBN_INITCUSTOMIZE
                 m.result=1
                 exit select
            case TBN_MAPACCELERATOR
            case TBN_QUERYDELETE
            case TBN_QUERYINSERT
                 M.RESULT=1
            case TBN_RESET
            case TBN_RESTORE
            case TBN_SAVE
            case TBN_TOOLBARCHANGE
                 Change
            case TBN_WRAPACCELERATOR
            case TBN_WRAPHOTITEM
            end select
         else
            m.result=0
         end if
    end select/''/
end sub

property QCustomToolBar.Images as PImageList
    return fimages
end property

property QCustomToolBar.Images (v as PImageList)
    fimages=v
    if isWindow(fhandle) then SendMessage(fhandle,tb_setimagelist,0,cint(fimages))
end property

property QCustomToolBar.Flat as boolean
    if isWindow(fhandle) then
       if Style and tbstyle_flat then fFlat=true else fFlat=false
    end if
    return fStyle
end property

property QCustomToolBar.Flat (v as boolean)
    fFlat=v
    if isWindow(fHandle) then
       if v then
          if Style and tbstyle_flat=0 then Style=Style or tbstyle_flat
       else
          if Style and tbstyle_flat then Style=Style and not tbstyle_flat
       end if
    end if
end property

property QCustomToolBar.Adjustable as boolean
    if isWindow(fhandle) then
       if Style and ccs_adjustable then fAdjustable=true else fAdjustable=false
    end if
    return fAdjustable
end property

property QCustomToolBar.Adjustable (v as boolean)
    fAdjustable=v
    if isWindow(fHandle) then
       if v then
          if Style and ccs_adjustable=0 then Style=Style or ccs_adjustable
       else
          if Style and ccs_adjustable then Style=Style and not ccs_adjustable
       end if
    end if
end property

property QCustomToolBar.Transparent as boolean
    if isWindow(fhandle) then
       if Style and tbstyle_transparent then fTransparent=true else fTransparent=false
    end if
    return fTransparent
end property

property QCustomToolBar.Transparent (v as boolean)
    fTransparent=v
    if isWindow(fHandle) then
       if v then
          if Style and tbstyle_transparent=0 then Style=Style or tbstyle_transparent
       else
          if Style and tbstyle_transparent then Style=Style and not tbstyle_transparent
       end if
    end if
end property

property QCustomToolBar.ButtonCount as integer
    if isWindow(fhandle) then
       return SendMessage(fhandle,tb_buttoncount,0,0)
    end if
    return fButtons.Count
end property

property QCustomToolBar.ButtonCount (v as integer)
    fButtons.Count=v
    for i as integer=0 to v-1
        Add
    next
end property

property QCustomToolBar.Buttons as PList
    return fButtons
end property

property QCustomToolBar.Buttons (v as PList)
    Clear
    fButtons=*v
    for i as integer=0 to v->count-1
        this.Add(cast(PToolButton,v->items[i]))
    next
end property

property QCustomToolBar.Button(index as integer) as PToolButton
    if index>-1 and index<fbuttons.count then return cast(PToolButton,fButtons.Items[index])
end property

property QCustomToolBar.Button(index as integer,v as PToolButton)
    if index>-1 and index<fButtons.count then fButtons.items[index]=v
end property

property QCustomToolBar.ButtonWidth as integer
    if isWindow(fhandle) then
       dim as integer lsz=SendMessage(fHandle,tb_getbuttonsize,0,0)
       fButtonWidth=loword(lsz)
    end if
    return fButtonWidth
end property

property QCustomToolBar.ButtonWidth (v as integer)
    fButtonWidth=v
    if isWindow(fhandle) then
       dim as integer lsz=makelong(v,fButtonHeight)
       SendMessage(fHandle,tb_setbuttonsize,0,lsz)
    end if
end property

property QCustomToolBar.ButtonHeight as integer
    if isWindow(fhandle) then
       dim as integer lsz=SendMessage(fHandle,tb_getbuttonsize,0,0)
       fButtonHeight=hiword(lsz)
    end if
    return fButtonHeight
end property

property QCustomToolBar.ButtonHeight (v as integer)
    fButtonHeight=v
    if isWindow(fhandle) then
       dim as integer lsz=makelong(fButtonWidth,v)
       SendMessage(fHandle,tb_setbuttonsize,0,lsz)
       if fStyle and tb_autosize then Height=v+2+2
    end if
end property

property QCustomToolBar.ShowHints as boolean
    if isWindow(fhandle) then
       fShowHints=fstyle and tbstyle_tooltips
    end if
    return fShowHints
end property

property QCustomToolBar.ShowHints (v as boolean)
    fShowHints=v
    if v then
       if fstyle and tbstyle_tooltips=0 then Style=fStyle or tbstyle_tooltips
    end if
end property

function QCustomToolBar.Add(c as string ="",s as integer=tbstyle_button) as PToolButton
    dim as PToolButton B=new QToolButton
    fButtons.Add(B)
    B->ToolButton.fsState=iif(fEnabled,tbstate_enabled,0) or iif(fvisible,0,tbstate_hidden)
    B->ToolButton.fsStyle=s
    B->ToolButton.idCommand=qCAL.AllocateCID
    B->ToolButton.iString=cint(strptr(c))
    B->ToolButton.dwData=cint(fButtons.items[fButtons.Count-1])
    B->ToolButton.iBitmap=-1
    B->index=fButtons.Count-1
    B->ShowHint=iif(B->hint="",false,ShowHints)
    B->ToolBar=Q_ToolBar(this)
    SendMessage(fhandle,tb_setbuttonsize,0,makelong(fbuttonwidth,fbuttonheight))
    return B
end function

sub QCustomToolBar.Remove(v as integer)
    if v>-1 and v<fbuttons.count then
      if isWindow(fhandle) then
         SendMessage(fhandle,tb_deletebutton,v,0)
      end if
      fButtons.remove(v) :? buttoncount,fbuttons.count
    end if
end sub

sub QCustomToolBar.Add overload(v as PToolButton)
    if v then
       Add
       Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.fsStyle=v->ToolButton.fsStyle
       Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.fsState=v->ToolButton.fsState
       Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.iString=v->ToolButton.iString
       Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.iBitmap=v->ToolButton.iBitmap
       Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.idCommand=v->ToolButton.idCommand
       if Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.idCommand=0 then Q_ToolButton(fButtons.items[fButtons.count-1]).ToolButton.idCommand=qCAL.AllocateCID
       Q_ToolButton(fButtons.items[fButtons.count-1]).Hint=v->Hint
       Q_ToolButton(fButtons.items[fButtons.count-1]).ShowHint=v->ShowHint
    end if
end sub

function QCustomToolBar.Insert(i as integer,c as string="",s as integer=tbstyle_button) as PToolButton
    dim as PToolButton B=new QToolButton
    fButtons.Insert(i,B)
    B->ToolButton.fsState=iif(fEnabled,tbstate_enabled,0) or iif(fvisible,0,tbstate_hidden)
    B->ToolButton.fsStyle=s
    B->ToolButton.idCommand=qCAL.AllocateCID
    B->ToolButton.iString=cint(strptr(c))
    B->ToolButton.dwData=cint(fButtons.items[fButtons.Count-1])
    B->ToolButton.iBitmap=-1
    B->index=fButtons.Count-1
    SendMessage(fhandle,tb_setbuttonsize,0,makelong(fbuttonwidth,fbuttonheight))
    SendMessage(fhandle,tb_insertbutton,i,cint(@B->ToolButton))
    return B
end function

sub QCustomToolBar.Insert overload(i as integer,b as PToolButton)
    fButtons.Insert(i,B)
    SendMessage(fhandle,tb_setbuttonsize,0,makelong(fbuttonwidth,fbuttonheight))
    SendMessage(fhandle,tb_insertbutton,i,cint(@B))
end sub

sub QCustomToolBar.Remove overload(v as PToolButton)
    dim as integer i=fButtons.indexof(v)
    Remove(i)
end sub

sub QCustomToolBar.Clear
    for i as integer=fButtons.Count-1 to 0 step-1
        Remove(i)
    next
end sub

operator QCustomToolBar.cast as any ptr
    return @this
end operator

constructor QCustomToolBar
    classname="QToolBar"
    classancestor="ToolBarWindow32"
    fButtonWidth=23
    fButtonHeight=22
    fImages=new QImageList
end constructor

destructor QCustomToolBar
    delete fIMages
    fIMages=0
end destructor

/' QToolBar '/
function QToolBar.Register as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    if (GetClassInfoEx(0,"ToolBarWindow32",@wc)>0) /'or (GetClassInfoEx(instance,sClassAncestor,@wc)>0)'/ then
       wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
       wc.lpszclassname=@"QToolBar"
       wc.hinstance=instance
       wc.lpfnwndproc=@QCustomToolBar.dlgproc
       wc.cbwndextra +=4
    end if
    return RegisterClassEx(@wc)
end function

operator QToolBar.cast as any ptr
    return @this
end operator

operator QToolBar.cast as hwnd
    return fHandle
end operator

constructor QToolBar
    fexstyle=ws_ex_controlparent
    fcx=215
    fcy=28
    fStyle=ws_child or ccs_noparentalign or ccs_noresize or ccs_adjustable or tbstyle_altdrag or tbstyle_tooltips or tbstyle_autosize
end constructor

/' QStatusPanel '/
property QStatusPanel.Width as integer
    return fcx
end property

property QStatusPanel.width (v as integer)
    fcx=v
    if fStatusBar then
       fStatusBar->Panels[index]->Width=v
    end if
end property

property QStatusPanel.Alignment as QAlignment
    return fAlignment
end property

property QStatusPanel.Alignment (v as QAlignment)
    fAlignment=v
end property

property QStatusPanel.Text as string
    return fText
end property

property QStatusPanel.Text (v as string)
    fText=v
end property

property QStatusPanel.StatusBar byref as QStatusBar
    return *fStatusBar
end property

property QStatusPanel.StatusBar (byref v as QStatusBar)
    fStatusBar=v :? v.classname
    if fStatusBar then
       fStatusBar->Add
    end if
end property

operator QStatusPanel.cast as any ptr
    return @this
end operator

operator QStatusPanel.cast as integer
    return fcx
end operator

constructor QStatusPanel
    classname="QStatusPanel"
    fcx=50
end constructor

/' QCustomStatusBar '/
sub QCustomStatusBar.Click
    if onClick then onClick(this)
end sub

function QCustomStatusBar.Add as PStatusPanel
    fCount+=1
    fPanels=reallocate(fPanels,sizeof(PStatusPanel)*fCount)
    fPanels[fcount-1]=new QStatusPanel
    fPanels[fcount-1]->index=fCount-1
    redim preserve P(fCount) as integer
    for i as integer=0 to fCount-1
        if i=0 then
           P(i)=*fPanels[i] :? P(i)
        else
           P(i)=*fPanels[i]+*fPanels[i-1] :? P(i)
        end if
    next
    ? "len=",ubound(p)
    SendMessage(fHandle,sb_setparts,fcount,cint(@P(0)))
    return fPanels[fCount-1]
end function

sub QCustomStatusBar.Clear
    SendMessage(fHandle,sb_simple,1,0)
    delete[] fPanels
    fcount=0
    fPanels=0
    SendMessage(fHandle,sb_simple,0,0)
end sub

function QCustomStatusBar.dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
     dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QStatusBar
        if obj then
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function

sub QCustomStatusBar.CreateHandle
    Base.CreateHandle
    if IsWindow(fHandle) then  SendMessage(fHandle,tb_buttonstructsize,sizeof(tbbutton),0)
end sub

sub QCustomStatusBar.Dispatch(byref m as QMessage)
    Base.Dispatch(m) '''not forgot to inherite from base class
end sub

property QCustomStatusBar.Count as integer
    return fcount
end property

property QCustomStatusBar.Panels as PStatusPanel ptr
    return fPanels
end property

property QCustomStatusBar.Panels (v as PStatusPanel ptr)
    fPanels=v
end property

property QCustomStatusBar.Panel (index as integer) byref as TStatusPanel
    if index>-1 and index<fcount then return *fPanels[index]
end property

operator QCustomStatusBar.cast as any ptr
    return @this
end operator

constructor QCustomStatusBar
    classname="QStatusBar"
    classancestor="msctls_StatusBar32"
end constructor

/' QStatusBar '/
function QStatusBar.Register as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    if (GetClassInfoEx(0,"msctls_StatusBar32",@wc)>0) /'or (GetClassInfoEx(instance,sClassAncestor,@wc)>0)'/ then
       wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
       wc.lpszclassname=@"QStatusBar"
       wc.hinstance=instance
       wc.lpfnwndproc=@QCustomStatusBar.dlgproc
       wc.cbwndextra +=4
    end if
    return RegisterClassEx(@wc)
end function

operator QStatusBar.cast as any ptr
    return @this
end operator

operator QStatusBar.cast as hwnd
    return fHandle
end operator

constructor QStatusBar
    fexstyle=ws_ex_controlparent
    fcx=215
    fcy=17
    fStyle=ws_child or sbars_sizegrip or ccs_noparentalign or ccs_noresize
end constructor

/' QCustomTabControl '/
sub QCustomTabControl.Change
end sub

sub QCustomTabControl.CreateHandle
    Base.CreateHandle
end sub

sub QCustomTabControl.Dispatch(byref m as QMessage)
    Base.Dispatch(m) 
end sub

function QCustomTabControl.dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
     dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QTabControl
        if obj then
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function 

operator QCustomTabControl.cast as any ptr
    return @this
end operator

constructor QCustomTabControl
    classname="QTabControl"
    classancestor="sysTabControl32"
    fstyle=ws_child
end constructor

/' QTabControl '/
function QTabControl.Register as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    if (GetClassInfoEx(0,"sysTabControl32",@wc)>0) /'or (GetClassInfoEx(instance,sClassAncestor,@wc)>0)'/ then
       wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
       wc.lpszclassname=@"QTabControl"
       wc.hinstance=instance
       wc.lpfnwndproc=@QCustomTabControl.dlgproc
       wc.cbwndextra +=4
    end if
    return RegisterClassEx(@wc) 
end function

operator QTabControl.cast as any ptr
    return @this
end operator

operator QTabControl.cast as hwnd
    return fhandle
end operator

constructor QTabControl
    fcx=220
    fcy=120
end constructor

''module initialization
sub ComCtrls_initialization constructor
    InitCommonControls
    QToolBar.Register
    QStatusBar.Register
    QTabControl.Register
end sub

sub ComCtrls_finalization destructor
    unRegisterClass("QToolBar",instance)
end sub