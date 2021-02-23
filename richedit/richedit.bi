#define RichEdit_RegisterClasses "QRichEdit"

#include once "kogaion_gui.bas"
#include once "kogaion_gui_classes.bas"
#include once "win/richedit.bi"
#include once "qfont.bi"

#DEFINE Q_RichEdit(__ptr__) *cast(PRichEdit,__ptr__)
#DEFINE W_RichEdit(__dlg__) *cast(PRichEdit,GetWindowLong(__dlg__,GetClassLong(__dlg__,gcl_cbwndextra)-4)))

common shared as hmodule RichEdDll

type PRichEdit as QRichEdit ptr

Enum QNumberingStyle
    nsNone, nsBullet
End Enum

Enum QAlignment
    taLeft,taCenter,taRight
End Enum

type PParaAttributes as QParaAttributes ptr
Type QParaAttributes extends object
    Private:
    FAlignment   As QAlignment
    FFirstIndent As Integer
    FLeftIndent  As Integer
    FNumbering   As QNumberingStyle
    FRightIndent As Integer
    FTab         As Integer
    FTabCount    As Integer
    Declare Sub GetAttributes(BYREF P As PARAFORMAT)
    Declare Sub SetAttributes(BYREF P As PARAFORMAT)
    Public:
    RichEdit     As PRichEdit
    Paragraph    As PARAFORMAT
    Declare Property Alignment As QAlignment
    Declare Property Alignment(Value As QAlignment)
    Declare Property FirstIndent As Integer
    Declare Property FirstIndent(Value As Integer)
    Declare Property LeftIndent As Integer
    Declare Property LeftIndent(Value As Integer)
    Declare Property Numbering As QNumberingStyle
    Declare Property Numbering(Value As QNumberingStyle)
    Declare Property RightIndent As Integer
    Declare Property RightIndent(Value As Integer)
    Declare Property Tab(Index As Byte) As Integer
    Declare Property Tab(Index As Byte,Value As Integer)
    Declare Property TabCount As Integer
    Declare Property TabCount(Value As Integer)
    Declare Constructor
    Declare Destructor
End Type

type PTextAttributes as QTextAttributes ptr
Type QTextAttributes extends object
    Private:
    fFont      as hfont
    FName      As String
    FColor     As Integer
    FSize      As Integer
    FCharSet   As Integer
    FPitch     As Integer
    FBold      As Boolean
    FItalic    As Boolean
    FUnderLine As Boolean
    FStrikeOut As Boolean
    Declare Sub GetAttributes(BYREF CF As CHARFORMAT)
    Declare Sub SetAttributes(BYREF CF As CHARFORMAT)
    Public:
    RichEdit   As PRichEdit
    ChrFormat  as CHARFORMAT
    Style      As Integer
    Declare Property Color As Integer
    Declare Property Color(Value As Integer)
    Declare Property Name As String
    Declare Property Name(Value As String)
    Declare Property Size As Integer
    Declare Property Size(Value As Integer)
    Declare Property CharSet As Integer
    Declare Property CharSet(Value As Integer)
    Declare Property Bold As Boolean
    Declare Property Bold(Value As Boolean)
    Declare Property Italic As Boolean
    Declare Property Italic(Value As Boolean)
    Declare Property Underline As Boolean
    Declare Property Underline(Value As Boolean)
    Declare Property StrikeOut As Boolean
    Declare Property StrikeOut(Value As Boolean)
    Declare Operator Cast As QFont
    Declare Operator Let(Value As QFont)
    Declare Constructor
    Declare Destructor
End Type

type PCustomRichEdit as QCustomRichEdit ptr
type QCustomRichEdit extends QFrame
   protected:
   FSelStart          As Integer
    FSelLength         As Integer
    FSelText           As String
    FCharCase          As Integer
    FMasked            As Boolean
    FMaskChar          As Byte
    FBorderStyle       As Integer
    FReadOnly          As Boolean
    FCtl3D             As Boolean
    FHideSelection     As Boolean
    FPlainText         As Boolean
    FMaxLength         As Integer
    FModified          As Boolean
    FCaretPos          As Point
    FHideScrollBars    As Boolean
    ACharCase(3)       As Integer
    ABorderExStyle(2)  As Integer
    ABorderStyle(2)    As Integer
    AHideSelection(2)  As Integer
    AHideScrollBars(2) As Integer
   as integer fCount
   declare static function DlgProc(as hwnd,as uint,as wparam,as lparam) as lresult
   declare virtual sub Dispatch(byref as QMessage)
   declare virtual sub CreateHandle
   declare static sub LinesChamge(byref as QStrings,as QStrings.QStringsAction)
   public:
   as QFont Font
   declare static function Register as integer
   as QStrings Lines
   as QParaAttributes Paragraph
   as QTextAttributes SelAttributes
   declare virtual operator cast as any ptr
   declare constructor
   declare destructor
    OnChange         As Sub(BYREF Sender As QCustomRichEdit)
    OnSelChange      As Sub(BYREF Sender As QCustomRichEdit)
    OnProtectChange  As Sub(BYREF Sender As QCustomRichEdit,SelStart As Integer,SelEnd As Integer,BYREF AllowChange As Boolean)
    OnResize         As Sub(BYREF Sender As QCustomRichEdit,R As Rect)
    OnSaveClipBoard  As Sub(BYREF Sender As QCustomRichEdit,Objects As Integer,Chars As Integer,BYREF AllowSave As Boolean)
    OnKeyPress       As Sub(BYREF Sender As QCustomRichEdit,Key As Byte)
    OnKeyDown        As Sub(BYREF Sender As QCustomRichEdit,Key As Integer,Shift As Integer)
    OnKeyUp          As Sub(BYREF Sender As QCustomRichEdit,Key As Integer,Shift As Integer)
end type

type QRichEdit extends QCustomRichEdit
    protected:
    declare virtual sub Dispatch(byref as QMessage)
    public:
    Declare Property Count As Integer
    Declare Property Count(Value As Integer)
    Declare Property Line(Index As Integer) As String
    Declare Property Line(Index As Integer,Value As String)
    Declare Sub AddLine(Item As String,obj as any ptr=0)
    Declare Sub InsertLine(Index As Integer,Item As String,obj as any ptr=0)
    Declare Sub DelLine(Index As Integer)
    Declare Sub Exchange(Index1 As Integer,Index2 As Integer)
    Declare Function IndexOF(Item As String) As Integer
    Declare Sub Clear
    Declare Sub LoadFromFile(File As String)
    Declare Sub SaveToFile(File As String)
    Declare Property Text As String
    Declare Property Text(Value As String)
    Declare Property BorderStyle As Integer
    Declare Property BorderStyle(Value As Integer)
    Declare Property ReadOnly As Boolean
    Declare Property ReadOnly(Value As Boolean)
    Declare Property Ctl3D As Boolean
    Declare Property Ctl3D(Value As Boolean)
    Declare Property HideSelection As Boolean
    Declare Property HideSelection(Value As Boolean)
    Declare Property PlainText As Boolean
    Declare Property PlainText(Value As Boolean)
    Declare Property MaxLength As Integer
    Declare Property MaxLength(Value As Integer)
    Declare Property Modified As Boolean
    Declare Property Modified(Value As Boolean)
    Declare Property CharCase As Integer
    Declare Property CharCase(Value As Integer)
    Declare Property SelStart As Integer
    Declare Property SelStart(Value As Integer)
    Declare Property SelLength As Integer
    Declare Property SelLength(Value As Integer)
    Declare Property SelText As String
    Declare Property SelText(Value As String)
    Declare Property CaretPos As Point
    Declare Property CaretPos(Value As Point)
    Declare Property HideScrollBars As Boolean
    Declare Property HideScrollBars(Value As Boolean)
    declare virtual operator cast as any ptr
    declare constructor
    declare destructor
end type

/' QParaAttributes '/
Sub QParaAttributes.GetAttributes(BYREF P As PARAFORMAT)
    FillMemory( @P,0,SizeOF(P) )
    Paragraph.cbSize = SizeOf(PARAFORMAT)
    If RichEdit Then If Q_RichEdit(RichEdit).Handle Then SendMessage(Q_RichEdit(RichEdit).Handle, EM_GETPARAFORMAT, 0, Cast(LPARAM,@Paragraph))
End Sub

Sub QParaAttributes.SetAttributes(BYREF P As PARAFORMAT)
    FillMemory( @P,0,SizeOF(P))
    Paragraph.cbSize = SizeOf(PARAFORMAT)
    If RichEdit Then
        If Q_RichEdit(RichEdit).Handle Then
            If Paragraph.wAlignment = PFA_LEFT then
               Paragraph.wAlignment = PFA_RIGHT
            ElseIf Paragraph.wAlignment = PFA_RIGHT then
               Paragraph.wAlignment = PFA_LEFT
            End If
            SendMessage(Q_RichEdit(RichEdit).Handle, EM_SETPARAFORMAT, 0, Cast(LPARAM,@Paragraph))
        End If
    End If
End Sub

Property QParaAttributes.Alignment As QAlignment
    If RichEdit Then
        If Q_RichEdit(RichEdit).Handle Then
            FAlignment = Cast(QAlignment,Paragraph.wAlignment - 1)
        End If
    End If
    Return FAlignment
End Property

Property QParaAttributes.Alignment(Value As QAlignment)
    GetAttributes(Paragraph)
    FAlignment = Value
    If RichEdit Then
        If Q_RichEdit(RichEdit).Handle Then
            With Paragraph
               .dwMask = PFM_ALIGNMENT
               .wAlignment = Value + 1
            End With
            SetAttributes(Paragraph)
        End If
    End If
End Property

Property QParaAttributes.FirstIndent As Integer
    GetAttributes(Paragraph)
    FFirstIndent = Paragraph.dxStartIndent \ 20
    Return FFirstIndent
End Property

Property QParaAttributes.FirstIndent(Value As Integer)
    FFirstIndent = Value
    FillMemory( @Paragraph,0,SizeOF(Paragraph))
    Paragraph.cbSize = SizeOf(PARAFORMAT)
    With Paragraph
       .dwMask = PFM_STARTINDENT
       .dxStartIndent = Value * 20
    End With
    SetAttributes(Paragraph)
End Property

Property QParaAttributes.LeftIndent As Integer
    GetAttributes(Paragraph)
    FLeftIndent = Paragraph.dxOffset / 20
    Return FLeftIndent
End Property

Property QParaAttributes.LeftIndent(Value As Integer)
    FLeftIndent = Value
    FillMemory( @Paragraph,0,SizeOF(Paragraph))
    Paragraph.cbSize = SizeOf(PARAFORMAT)
    With Paragraph
       .dwMask = PFM_OFFSET
       .dxOffset = Value * 20
    End With
    SetAttributes(Paragraph)
End Property

Property QParaAttributes.Numbering As QNumberingStyle
    GetAttributes(Paragraph)
    FNumbering = Paragraph.wNumbering
    Return FNumbering
End Property

Property QParaAttributes.Numbering(Value As QNumberingStyle)
    FNumbering = Value
    Select Case Value
    Case nsBullet
        If LeftIndent < 10 Then LeftIndent = 10
    Case nsNone
        LeftIndent = 0
    End Select
    FillMemory( @Paragraph,0,SizeOF(Paragraph))
    Paragraph.cbSize = SizeOf(PARAFORMAT)
    with Paragraph
       .dwMask = PFM_NUMBERING
       .wNumbering = Value
    End With
    SetAttributes(Paragraph)
End Property

Property QParaAttributes.RightIndent As Integer
    GetAttributes(Paragraph)
    FRightIndent = Paragraph.dxRightIndent \ 20
    Return FRightIndent
End Property

Property QParaAttributes.RightIndent(Value As Integer)
    FRightIndent = Value
    FillMemory( @Paragraph,0,SizeOF(Paragraph))
    Paragraph.cbSize = SizeOf(PARAFORMAT)
    With Paragraph
       .dwMask = PFM_RIGHTINDENT
       .dxRightIndent = Value * 20
    End With
    SetAttributes(Paragraph)
End Property

Property QParaAttributes.Tab(Index As Byte) As Integer
    GetAttributes(Paragraph)
    FTab = Paragraph.rgxTabs(Index) \ 20
    Return FTab
End Property

Property QParaAttributes.Tab(Index As Byte,Value As Integer)
    FTab = Value
    GetAttributes(Paragraph)
    With Paragraph
       .rgxTabs(Index) = Value * 20
       .dwMask = PFM_TABSTOPS
       If .cTabCount < Index then .cTabCount = Index
       SetAttributes(Paragraph)
    End With
End Property

Property QParaAttributes.TabCount As Integer
    GetAttributes(Paragraph)
    FTabCount = Paragraph.cTabCount
    Return FTabCount
End Property

Property QParaAttributes.TabCount(Value As Integer)
    FTabCount = Value
    GetAttributes(Paragraph)
    With Paragraph
       .dwMask = PFM_TABSTOPS
       .cTabCount = Value
       SetAttributes(Paragraph)
    End With
End Property

Constructor QParaAttributes
    Paragraph.cbSize = SizeOf(PARAFORMAT)
End Constructor

Destructor QParaAttributes
End Destructor

/' QTextAttributes '/
Sub QTextAttributes.GetAttributes(BYREF CF As CHARFORMAT)
    FillMemory( @CF,0,SizeOF(CF))
    ChrFormat.cbSize = SizeOf(CharFormat)
    If RichEdit Then If Q_RichEdit(RichEdit).Handle Then SendMessage(Q_RichEdit(RichEdit).Handle,EM_GETCHARFORMAT,Style, Cast(LPARAM,@ChrFormat))
End Sub

Sub QTextAttributes.SetAttributes(BYREF CF As CHARFORMAT)
    If RichEdit Then If Q_RichEdit(RichEdit).Handle Then SendMessage(Q_RichEdit(RichEdit).Handle,EM_SETCHARFORMAT,Style, Cast(LPARAM,@ChrFormat))
End Sub

Property QTextAttributes.Name As String
    GetAttributes(ChrFormat)
    FName = ChrFormat.szFaceName
    Return FName
End Property

Property QTextAttributes.Name(Value As String)
    FName = Value
    FillMemory( @ChrFormat,0,SizeOF(ChrFormat))
    ChrFormat.cbSize = SizeOf(CharFormat)
    with ChrFormat
       .dwMask = CFM_FACE
       .szFaceName = Value
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.Color As Integer
    FillMemory( @ChrFormat,0,SizeOF(ChrFormat))
    ChrFormat.cbSize = SizeOf(CharFormat)
    ChrFormat.dwMask = CFM_COLOR
    If RichEdit Then
        If Q_RichEdit(RichEdit).Handle Then
           SendMessage(Q_RichEdit(RichEdit).Handle, EM_GETCHARFORMAT,Style, Cast(LPARAM,@ChrFormat))
        End If
    End If
    Return FColor
End Property

Property QTextAttributes.Color(Value As Integer)
    FColor = Value
    FillMemory( @ChrFormat,0,SizeOF(ChrFormat))
    ChrFormat.cbSize = SizeOf(CharFormat)
    With ChrFormat
       .dwMask = CFM_COLOR
       'If Value = clWindowText Then .dwEffects = CFE_AUTOCOLOR Else  .crTextColor = Value
       .crTextColor = Value
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.Size As Integer
    GetAttributes(ChrFormat)
    FSize = ChrFormat.yHeight \ 20
    Return FSize
End Property

Property QTextAttributes.Size(Value As Integer)
    FSize = Value
    FillMemory( @ChrFormat,0,SizeOF(ChrFormat))
    ChrFormat.cbSize = SizeOf(CharFormat)
    With ChrFormat
       .dwMask = CFM_SIZE
       .yHeight = Value * 20
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.CharSet As Integer
    GetAttributes(ChrFormat)
    FCharSet = ChrFormat.bCharset
    Return FCharSet
End Property

Property QTextAttributes.CharSet(Value As Integer)
    FCharSet = Value
    FillMemory( @ChrFormat,0,SizeOF(ChrFormat))
    ChrFormat.cbSize = SizeOf(CharFormat)
    With ChrFormat
       .dwMask = CFM_CHARSET
       .bCharSet = Value
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.Bold As Boolean
    GetAttributes(ChrFormat)
    with ChrFormat
       If (.dwEffects and CFE_BOLD) <> 0 Then FBold = True Else FBold = False
    End With
    Return FBold
End Property

Property QTextAttributes.Bold(Value As Boolean)
    FBold = Value
    With ChrFormat
       .dwMask = CFM_BOLD
       If FBold  Then .dwEffects = .dwEffects or CFE_BOLD
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.Italic As Boolean
    GetAttributes(ChrFormat)
    with ChrFormat
       If (.dwEffects and CFE_ITALIC) <> 0 Then FItalic = True Else FItalic = False
    End With
    Return FItalic
End Property

Property QTextAttributes.Italic(Value As Boolean)
    FItalic = Value
    With ChrFormat
       .dwMask = CFM_ITALIC
       If FItalic Then .dwEffects = .dwEffects or CFE_ITALIC
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.Underline As Boolean
    GetAttributes(ChrFormat)
    with ChrFormat
       If (.dwEffects and CFE_UNDERLINE) <> 0 Then FUnderLine = True Else FUnderLine = False
    End With
    Return FUnderline
End Property

Property QTextAttributes.Underline(Value As Boolean)
    FUnderline = Value
    With ChrFormat
       .dwMask = CFM_UNDERLINE
       If FUnderline Then .dwEffects = .dwEffects or CFE_UNDERLINE
    End With
    SetAttributes(ChrFormat)
End Property

Property QTextAttributes.StrikeOut As Boolean
   GetAttributes(ChrFormat)
    with ChrFormat
       If (.dwEffects and CFE_STRIKEOUT) <> 0 Then FStrikeOut = True Else FStrikeOut = False
    End With
    Return FStrikeOut
End Property

Property QTextAttributes.StrikeOut(Value As Boolean)
    FStrikeOut = Value
    With ChrFormat
       .dwMask = CFM_STRIKEOUT
       If FStrikeOut Then .dwEffects = .dwEffects or CFE_STRIKEOUT
    End With
    SetAttributes(ChrFormat)
End Property

Operator QTextAttributes.Cast As QFont
    Dim As QFont Font
    Font.CharSet = FCharSet
    Font.Size = FSize
    Font.Bold = FBold
    Font.Italic = FItalic
    Font.UnderLine = FUnderLine
    Font.StrikeOut = FStrikeOut
    Return Font
End Operator

Operator QTextAttributes.Let(Value As QFont)
    Color = Value.Color
    CharSet = Value.CharSet
    Size = Value.Size
    Bold = Value.Bold
    Italic = Value.Italic
    UnderLine = Value.UnderLine
    StrikeOut = Value.StrikeOut
End Operator

Constructor QTextAttributes
    ChrFormat.cbSize = SizeOf(CharFormat)
End Constructor

Destructor QTextAttributes
End Destructor

/' QCustomRichEdit '/
sub QCustomRichEdit.LinesChamge(byref Sender as QStrings,Action as QStrings.QStringsAction)
    select case Action
    case QStrings.acNone
    case QStrings.acError
    case QStrings.acAdd
    case QStrings.acInsert
    case QStrings.acRemove
    case QStrings.acClear
    case QStrings.acLoadFromFile
    case QStrings.acSaveToFile
    end select
end sub

function QCustomRichEdit.Register as integer
    dim as wndclassex wc
    wc.cbsize=sizeof(wc)
    if (GetClassInfoEx(0,"RichEdit20A",@wc)>0) /'or (GetClassInfoEx(instance,sClassAncestor,@wc)>0)'/ then
       wc.style=wc.style or cs_dblclks or cs_owndc or cs_globalclass
       wc.lpszclassname=@"QRichEdit"
       wc.hinstance=instance
       wc.lpfnwndproc=@QCustomRichEdit.dlgproc
       wc.cbwndextra+=4
       return RegisterClassEx(@wc)
    end if
    return 0
end function'

function QCustomRichEdit.DlgProc(dlg as hwnd,msg as uint,wparam as wparam,lparam as lparam) as lresult
     dim as PClassObject obj=iif(creationdata,creationdata,cast(PClassObject,GetWindowLong(Dlg,GetClassLong(Dlg,gcl_cbwndextra)-4)))
     dim as QMessage m=type(dlg,msg,wparam,lparam,0,obj,0)
     if obj then
        obj->Handle=dlg
        obj->Dispatch(m)
        return m.result
     else
        obj=new QRichEdit
        if obj then
           obj->Handle=dlg
           obj->Dispatch(m)
           return m.result
        end if
     end if
     return m.result
end function

sub QCustomRichEdit.Dispatch(byref m as QMessage)
    Base.Dispatch(m)
    Select Case m.Msg
    Case WM_PAINT
        Dim As Rect R,R1,CR
        GetClientRect(m.dlg,@CR)
        If GetUpdateRect(fHandle, @R, True) Then
           With CR
              R1 = Type(.Right - 3, .Top, .Right, .Bottom)
           End With
        If IntersectRect(@R, @CR, @R1) Then InvalidateRect(m.dlg, @R1, True)
        End If  ''
        m.result=0
    Case CM_CTLCOLOR
        Static As HDC Dc
        Dc = Cast(HDC,m.wParam)
        SetBKMode(Dc, TRANSPARENT)
        SetTextColor(Dc,Canvas.TextColor)
        SetBKColor(Dc,Canvas.Color)
        SetBKMode(Dc,OPAQUE)
        m.result=cast(lresult,Canvas.Brush)
        exit sub
    Case CM_COMMAND
        If HiWord(m.wParam) = EN_CHANGE Then
           If OnChange Then OnChange(This)
        End If
    Case CM_NOTIFY
        Dim As LPNMHDR NM
        NM = Cast(LPNMHDR,m.lParam)
        If NM Then
           Select Case NM->Code
           Case EN_SELCHANGE
              If OnSelChange Then OnSelChange(This)
           Case EN_REQUESTRESIZE
              If OnResize Then OnResize(This,Cast(REQRESIZE Ptr,m.lParam)->rc)
           Case EN_SAVECLIPBOARD
             With *Cast(ENSAVECLIPBOARD Ptr,m.lParam)
                 Static As Boolean AllowSave = 1
                 If OnSaveClipboard Then
                     OnSaveClipboard(This,.cObjectCount,.cch,AllowSave)
                     If NOT AllowSave Then m.Result = 1
                 End If
             End With
           Case EN_PROTECTED
              Static As Boolean AllowChange  = 1
              With *Cast(ENPROTECTED ptr,m.lParam).chrg
                  If OnProtectChange Then
                     OnProtectChange(This,.cpMin,.cpMax,AllowChange)
                     If NOT AllowChange Then m.Result = 1
                  End If
              End With
           End Select
        End If
    Case WM_CHAR
        If OnKeyPress Then OnKeyPress(This,LoByte(m.WParam))
    Case WM_KEYDOWN
        If OnKeyDown Then OnKeyDown(This,m.WParam,m.lParam And &HFFFF)
    Case WM_KEYUP
        If OnKeyUp Then OnKeyUp(This,m.WParam,m.lParam And &HFFFF)
    End Select
end sub

sub QCustomRichEdit.CreateHandle
    Base.CreateHandle
    SendMessage(fhandle,EM_SETEVENTMASK,0,ENM_KEYEVENTS)
    Font.Parent=fHandle
end sub

operator QCustomRichEdit.cast as any ptr
    return @this
end operator

constructor QCustomRichEdit
     Lines.Owner=this
     Paragraph.RichEdit=this
     SelAttributes.RichEdit=this
end constructor

destructor QCustomRichEdit
end destructor

/' QRichEdit '/
operator QRichEdit.cast as any ptr
    return @this 
end operator

sub QRichEdit.Dispatch(byref m as QMessage)
    Base.Dispatch(m)
end sub

Property QRichEdit.Count As Integer
    Return Lines.Count
End Property

Property QRichEdit.Count(Value As Integer)
End Property

Property QRichEdit.Line(Index As Integer) As String
    Return Lines.Item(Index)
End Property

Property QRichEdit.Line(Index As Integer,Value As String)
     Lines.Item(Index) = Value
     If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
     End If
End Property

Property QRichEdit.Text As String
    Return Lines.Text
End Property

Property QRichEdit.Text(Value As String)
    Lines.Text = Value
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
    End If
End Property

Sub QRichEdit.AddLine(Item As String,obj as any ptr=0)
     Lines.Add(Item,obj)
     If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
     End If
End Sub

Sub QRichEdit.InsertLine(Index As Integer,Item As String,obj as any ptr=0)
    Lines.Insert(Index,Item,obj)
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
    End If
End Sub

Sub QRichEdit.DelLine(Index As Integer)
    Lines.Remove(Index)
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
    End If
End Sub

Sub QRichEdit.Exchange(Index1 As Integer,Index2 As Integer)
    Lines.Exchange(Index1,Index2)
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
    End If
End Sub

Function QRichEdit.IndexOF(Item As String) As Integer
    Return Lines.IndexOF(Item)
End Function

Sub QRichEdit.Clear
    Lines.Clear
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,"")
    End If
End Sub

Sub QRichEdit.LoadFromFile(File As String)
    Lines.LoadFromFile File
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
    End If
End Sub

Sub QRichEdit.SaveToFile(File As String)
    Lines.SaveToFile File
    If *Lines.Owner is QRichEdit Then
        SetWindowText(Q_RichEdit(Lines.Owner).Handle,Lines.Text)
    End If
End Sub

Property QRichEdit.BorderStyle As Integer
    Return FBorderStyle
End Property

Property QRichEdit.BorderStyle(Value As Integer)
    If Value <> FBorderStyle Then
       FBorderStyle = Value
       Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR ES_MULTILINE OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL OR ACharCase(FCharCase) OR AHideSelection(FHideSelection) OR AHideScrollBars(FHideScrollBars)
    End If
End Property

Property QRichEdit.ReadOnly As Boolean
    Return FReadOnly
End Property

Property QRichEdit.ReadOnly(Value As Boolean)
    FReadOnly = Value
    If Handle Then Perform(EM_SETREADONLY,FReadOnly,0)
End Property

Property QRichEdit.Ctl3D As Boolean
    Return FCtl3D
End Property

Property QRichEdit.Ctl3D(Value As Boolean)
    If Value <> FCtl3D Then
        FCtl3D = Value
        Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR ES_MULTILINE OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL OR ACharCase(FCharCase) OR AHideSelection(FHideSelection) OR AHideScrollBars(FHideScrollBars)
    End If
End Property

Property QRichEdit.HideScrollBars As Boolean
    Return FHideScrollBars
End Property

Property QRichEdit.HideScrollBars(Value As Boolean)
    FHideScrollBars = Value
    Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR ES_MULTILINE OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL OR ACharCase(FCharCase) OR AHideSelection(FHideSelection) OR AHideScrollBars(FHideScrollBars)
End Property

Property QRichEdit.HideSelection As Boolean
    Return FHideSelection
End Property

Property QRichEdit.HideSelection(Value As Boolean)
    If Value <> FHideSelection Then
        FHideSelection = Value
        Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR ES_MULTILINE OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL OR ACharCase(FCharCase) OR AHideSelection(FHideSelection) OR AHideScrollBars(FHideScrollBars)
    End If
End Property

Property QRichEdit.PlainText As Boolean
    Return FPlainText
End Property

Property QRichEdit.PlainText(Value As Boolean)
    If Value <> FPlainText Then
        FPlainText = Value
    End If
End Property

Property QRichEdit.CharCase As Integer
    Return FCharCase
End Property

Property QRichEdit.CharCase(Value As Integer)
    If FCharCase <> Value Then
        FCharCase = Value
        Style = WS_CHILD OR WS_HSCROLL OR WS_VSCROLL OR ES_MULTILINE OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL OR ACharCase(FCharCase) OR AHideSelection(FHideSelection) OR AHideScrollBars(FHideScrollBars)
    End If
End Property

Property QRichEdit.SelStart As Integer
    Dim As CharRange ChrRange
    SendMessage(Handle, EM_EXGETSEL, 0, cint(@ChrRange))
    FSelStart = ChrRange.cpMin
    Return FSelStart
End Property

Property QRichEdit.SelStart(Value As Integer)
    Dim As CharRange ChrRange
    FSelStart = Value
    If Handle Then
       ChrRange.cpMin = Value
       ChrRange.cpMax = Value
       SendMessage(Handle, EM_EXSETSEL, 0, cint(@ChrRange))
    End If
End Property

Property QRichEdit.SelLength As Integer
    If Handle Then
       Dim As CharRange ChrRange
       SendMessage(Handle, EM_EXGETSEL, 0, cint(@ChrRange))
       FSelLength = ChrRange.cpMax - ChrRange.cpMin
    End If
    Return FSelLength
End Property

Property QRichEdit.SelLength(Value As Integer)
    Dim As CharRange ChrRange
    FSelLength = Value
    If Handle Then
       SendMessage(Handle, EM_EXGETSEL, 0, cint(@ChrRange))
       ChrRange.cpMax = ChrRange.cpMin + Value
       SendMessage(Handle, EM_EXSETSEL, 0, cint(@ChrRange))
       SendMessage(Handle, EM_SCROLLCARET, 0, 0)
    End If
End Property

Property QRichEdit.SelText As String
    If Handle Then
       Dim As Integer Length
       FSelText = String(SelLength + 1, 0)
       Length = SendMessage(Handle, EM_GETSELTEXT, 0, cint(StrPtr(FSelText)))
       FSelText = .Left(FSelText,Length)
    End If
    Return FSelText
End Property

Property QRichEdit.SelText(Value As String)
    FSelText = Value
    If Handle Then SendMessage(Handle, EM_REPLACESEL, 0, CInt(StrPtr(Value)))
End Property

Property QRichEdit.MaxLength As Integer
    Return FMaxLength
End Property

Property QRichEdit.MaxLength(Value As Integer)
    FMaxLength = Value
    If Handle Then Perform(EM_LIMITTEXT, Value, 0)
End Property

Property QRichEdit.Modified As Boolean
    If Handle Then
       FModified = (Perform(EM_GETMODIFY, 0, 0) <> 0)
    End If
    Return FModified
End Property

Property QRichEdit.Modified(Value As Boolean)
    If Handle Then
       Perform(EM_SETMODIFY, Cast(Byte,Value), 0)
    Else
       FModified = Value
    End If
End Property

Property QRichEdit.CaretPos As Point
    If Handle Then
        Dim As CharRange ChrRange
        SendMessage(Handle, EM_EXGETSEL, 0, cInt(@ChrRange))
        FCaretPos.X = ChrRange.cpMax
        FCaretPos.Y = SendMessage(Handle, EM_EXLINEFROMCHAR, 0, FCaretPos.X)
        FCaretPos.X = FCaretPos.X - SendMessage(Handle, EM_LINEINDEX, -1, 0)
    End If
    Return FCaretPos
End Property

Property QRichEdit.CaretPos(Value As Point)
End Property

constructor QRichEdit
    fExStyle=ws_ex_clientedge or ws_ex_controlparent and not ws_ex_noparentnotify
    fStyle=ws_child or es_multiline or es_autohscroll or es_autovscroll or ws_hscroll or ws_vscroll
    ClassName="QRichEdit"
    ClassAncestor="RichEdit20A"
    fx=400
    fy=200
    Lines.Owner=this
    SelAttributes.Style = SCF_SELECTION
end constructor

destructor QRichEdit
    'your code here
end destructor

sub QRichEdit_initialization constructor
    InitCommonControls
    RichEddll = LoadLibrary("RichEd20")
    If Not RichEddll Then RichEddll = LoadLibrary("RichEd32")
    #ifdef Debug
           print "RichEdit Owner Dll=",richeddll
    #endif
    dim as integer ret= QCustomRichEdit.Register
    #ifdef debug
           print "QRichEdit register=", ret,"Last error was ",getlasterror
    #endif
    QCustomRichEdit.Register
end sub

sub QRichEdit_finalization destructor
    If RichEddll Then
       dylibfree(RichEddll)
       RichEdDll=0
    end if
    #ifdef debug
           print "RichEdit Owner Dll=",richeddll
    #endif
end sub
