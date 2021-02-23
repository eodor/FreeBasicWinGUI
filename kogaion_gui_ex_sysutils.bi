#include once "windows.bi"

declare function twips2pix(v  as integer) as integer
declare function pix2twips(v  as integer) as integer
declare sub DUI2Win(Dlg as hwnd, lx as integer, ly as integer, cx as integer, cy as integer)
declare sub Win2DUI(Dlg as hwnd, lx as integer, ly as integer, cx as integer, cy as integer)
declare sub DUI2PIX(FWindow  as hwnd,  P  as Point)
declare sub PIX2DUI(FWindow  as hwnd,  P  as Point)

function twips2pix(v  as integer) as integer
    return v / 15
end function

function pix2twips(v  as integer) as integer
    return v * 15
end function

sub DUI2Win(Dlg as hwnd, lx as integer, ly as integer, cx as integer, cy as integer)
   dim as integer avgWidth, avgHeight
   dim size  as SIZE
   dim tm  as  TEXTMETRIC
   dim as hfont FontOld, SysFont
   dim dc  as hdc
   dim LF  as LogFont

    dc = GetDC(Dlg)
    SysFont = GetStockObject(DEFAULT_GUI_FONT)
    GetObject(SysFont, SizeOf( LF), @LF)
    SysFont = SendMessage( Dlg, WM_GETFONT, 0,0)
    FontOld = SelectObject(dc, SysFont)
    GetTextMetrics(dc,@tm)
    GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,@size)
    avgWidth = ((size.cx / 26)+1) / 2
    avgHeight = tm.tmHeight
    lx = (lx * avgWidth) / 4
    cx = (cx * avgWidth) / 4
    ly = (ly * avgHeight) / 8
    cy = (cy * avgHeight) / 8
    ReleaseDC(Dlg, dc)
    DeleteObject(FontOld)
end sub

sub Win2DUI(Dlg as hwnd, lx as integer, ly as integer, cx as integer, cy as integer)
   dim as integer avgWidth, avgHeight
   dim size  as SIZE
   dim tm  as  TEXTMETRIC
   dim as hfont FontOld, SysFont
   dim dc  as hdc
   dim LF  as LogFont

    dc = GetDC(Dlg)
    SysFont = GetStockObject(DEFAULT_GUI_FONT)
    GetObject(SysFont, SizeOf( LF), @LF)
    SysFont = SendMessage( Dlg, WM_GETFONT, 0,0)
    FontOld = SelectObject(dc, SysFont)
    GetTextMetrics(dc,@tm)
    GetTextExtentPoint32(dc,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",52,@size)
    avgWidth = ((size.cx / 26)+1) / 2
    avgHeight = tm.tmHeight
    lx = (4 * lx) / avgWidth
    cx = (4 * cx) / avgWidth
    ly = (8 * ly) / avgHeight
    cy = (8 * cy) / avgHeight
    ReleaseDC(Dlg, dc)
    DeleteObject(FontOld)
end sub

sub DUI2PIX(FWindow  as hwnd,  P  as Point)
   dim Dc as  hdc
   dim as integer AWidth,AHeight
   dim as hfont Font, FontOld
   dim s  as string
   dim TM  as TEXTMETRIC
   dim Sz  as  SIZE

    Dc = GetDC(FWindow)
    Font = cast(hFont,SendMessage(FWindow,wm_getfont,0,0))
    FontOld = SelectObject(Dc,Font)
    s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
    GetTextMetrics(Dc,@TM)
    GetTextExtentPoint32(Dc,s,Len(s),@Sz)
    SelectObject(DC,FontOld)
    ReleaseDc(FWindow,Dc)
    AWidth  = sz.cx / Len(s)
    AHeight = TM.tmHeight
    P.x = (P.x*AWidth) / 4
    P.y = (P.y*AHeight) / 8
end sub

sub PIX2DUI(FWindow  as hwnd,  P  as Point)
   dim Dc as  hdc
   dim as integer AWidth,AHeight
   dim as hfont Font, FontOld
   dim s  as string
   dim TM  as TEXTMETRIC
   dim Sz  as  SIZE

    Dc = GetDC(FWindow)
    Font = cast(hfont,SendMessage(FWindow,wm_getfont,0,0))
    FontOld = SelectObject(Dc,Font)
    s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
    GetTextMetrics(Dc,@TM)
    GetTextExtentPoint32(Dc,s,Len(s),@Sz)
    SelectObject(DC,FontOld)
    ReleaseDc(FWindow,Dc)
    AWidth  = sz.cx / Len(s)
    AHeight = TM.tmHeight
    P.x = (P.x*4) / AWidth
    P.y = (P.y*8) / AHeight
end sub