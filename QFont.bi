'###############################################################################
'#  QFont.bi                                                                   #
'#  This file is part of FreeBasic Windows GUI ToolKit                         #
'#  Copyright (c) 2020 Vasile Eodor Nastasa                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#DEFINE Q_Font(__Ptr__) *Cast(QFont Ptr,__Ptr__)
#DEFINE W_Font(dlg) cast(hfont,SendMessage(dlg,wm_getfont,0,0))

Type QFont extends object
    Private:
    FName      As String
    FBold      As Boolean
    FItalic    As Boolean
    FUnderline As Boolean
    FStrikeOut As Boolean
    FSize      As Integer
    FColor     As Integer
    FCharSet   As Integer 
    FParent    As HWND
    FBolds(2)  As Integer
    FCyPixels  As Integer
    Declare Sub Create
    Public:
    Handle As HFONT
    Declare Property Parent As HWND
    Declare Property Parent(Value As HWND)
    Declare Property Name As String
    Declare Property Name(Value As String)
    Declare Property Color As Integer
    Declare Property Color(Value As Integer)
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
    Declare Operator Cast As Any Ptr
    Declare Operator Cast As HFont
    Declare Operator Let(Value As QFont)
    Declare Operator Let(Value As HFont)
    Declare Constructor
    Declare Destructor
End Type

Sub QFont.Create
    If Handle Then DeleteObject(Handle) 
    Handle = CreateFont(-MulDiv(FSize,FcyPixels,72),0,0,0,FBolds(FBold),FItalic,FUnderline,FStrikeout,FCharSet,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,FName)
    If Handle Then
       If FParent Then
          SendMessage(FParent ,WM_SETFONT,CUInt(Handle),True)
          InvalidateRect FParent,0,True 
       End If
    End If
End Sub

Property QFont.Parent As HWND
    Return FParent
End Property

Property QFont.Parent(Value As HWND)
    FParent = value
    Create
End Property

Property QFont.Name As String
    Return FName 
End Property

Property QFont.Name(Value As String)
    FName = value
    Create
End Property

Property QFont.Color As Integer
    Return FColor
End Property

Property QFont.Color(Value As Integer)
    FColor = value
    Create
End Property

Property QFont.CharSet As Integer
    Return FCharSet
End Property

Property QFont.CharSet(Value As Integer)
     FCharSet = value
     Create
End Property

Property QFont.Size As Integer
     Return FSize
End Property

Property QFont.Size(Value As Integer)
    FSize = value
    Create
End Property

Property QFont.Bold As Boolean
    Return FBold
End Property

Property QFont.Bold(Value As Boolean)
    FBold = value
    Create
End Property

Property QFont.Italic As Boolean
     Return FItalic
End Property

Property QFont.Italic(Value As Boolean)
    FItalic = value
    Create
End Property

Property QFont.Underline As Boolean
    Return FUnderline
End Property

Property QFont.Underline(Value As Boolean)
    FUnderline = value
    Create
End Property

Property QFont.StrikeOut As Boolean
   Return FStrikeout
End Property

Property QFont.StrikeOut(Value As Boolean)
   FStrikeout = value
   Create
End Property

Operator QFont.Cast As Any Ptr
    Return @This
End Operator

Operator QFont.Cast As HFont
    Return Handle
End Operator

Operator QFont.Let(Value As QFont)
    With Value
        FName      = .Name
        FBold      = .Bold
        FItalic    = .Italic
        FUnderline = .Underline
        FStrikeOut = .StrikeOut
        FSize      = .Size
        FColor     = .Color
        FCharSet   = .CharSet
    End With
    Create
End Operator

Operator QFont.Let(Value As HFont)
    dim as logfont lf
    if GetObject(value,sizeof(lf),@lf) then
       if Handle then DeleteObject(Handle)
       Handle=CreateFontIndirect(@lf)
    end if
End Operator

Constructor QFont
    Dim As HDC Dc
    Dc = GetDC(HWND_DESKTOP)
    FCyPixels = GetDeviceCaps(DC, LOGPIXELSY)
    ReleaseDC(HWND_DESKTOP,DC)
    FBolds(0) = 400
    FBolds(1) = 700
    FName     = "TAHOMA" 
    FSize     = 8
    FCharSet  = DEFAULT_CHARSET
    Create
End Constructor

Destructor QFont
    If Handle Then DeleteObject(Handle)
End Destructor