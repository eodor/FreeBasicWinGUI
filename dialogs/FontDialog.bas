#include once "FontDialog.bi"

Function QFontDialog.Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
    Static As HBrush Brush
    Select Case Msg
    Case wm_initdialog 
        Dim As QFontDialog Ptr CommonDialog = Cast(QFontDialog Ptr,*Cast(lpChooseFont,lParam).lCustData)
        If CommonDialog Then
            CommonDialog->Handle = FWindow
            SetWindowLong(FWindow,gwl_userdata,Cint(CommonDialog))
            SetWindowText(FWindow,CommonDialog->Caption)
            If CommonDialog->Center Then 
               Dim As Rect R,Wr
               GetWindowRect(FWindow,@Wr)
               SystemParametersInfo(spi_getworkarea,0,@R,0)
               MoveWindow(FWindow,(R.Right  - (Wr.Right - Wr.Left))/2,(R.Bottom - (Wr.Bottom - Wr.Top))/2,Wr.Right - Wr.Left,Wr.Bottom - Wr.Top,1)
            End If
            Brush = CreateSolidBrush(CommonDialog->BackColor)
        End If
        Return True
    Case wm_ctlcolordlg To wm_ctlcolorstatic
        Dim As QFontDialog Ptr CommonDialog = Cast(QFontDialog Ptr,GetWindowLong(FWindow,gwl_userdata))
        If CommonDialog Then
            With *CommonDialog
                SetBkMode(Cast(HDc,wParam),Transparent)
                SetBkColor(Cast(HDc,wParam),.BackColor)
                SetBkMode(Cast(HDc,wParam),Opaque)
                Return CInt(Brush)
            End With
        End If
    Case wm_destroy 
        If Brush Then DeleteObject(Brush)
    Case Else
        Return False
    End Select     
    Return True
End Function

Function QFontDialog.Execute As Integer
    Static As Integer FWidth(0 to 1)=>{400,700}
    Dim As CHOOSEFONT CF
    Dim As LOGFONTA LGF
    Dim As HDC Dc = GetDC(0)
    dim as integer LogPx = GetDeviceCaps(Dc,logpixelsy)
    LGF.lfItalic      = Font.Italic
    LGF.lfUnderLine   = Font.UnderLine
    LGF.lfStrikeOut   = Font.StrikeOut
    LGF.lfHeight      = -MulDiv(Font.Size,LogPx,72)
    LGF.lfWeight      = FWidth(Font.Bold)
    LGF.lfFaceName    = Font.Name
    CF.lStructSize    = SizeOf(CHOOSEFONTA)
    CF.hwndOwner      = IIf(Parent,Parent->Handle,0)
    CF.HDC            = Dc
    CF.Flags          = CF_BOTH or CF_EFFECTS or CF_INITTOLOGFONTSTRUCT or CF_ENABLEHOOK
    CF.rgbColors      = Font.Color
    CF.lpLogFont      = @LGF
    CF.lpfnHook       = @Hook
    CF.lCustData      = Cast(dword,@This)
    ReleaseDC(0,Dc)
    If ChooseFont(@CF) <> 0 then
       Font.Name      = LGF.lfFaceName
       Font.Italic    = LGF.lfItalic
       Font.UnderLine = LGF.lfUnderLine
       Font.StrikeOut = LGF.lfStrikeOut
       Font.Color     = CF.rgbColors
       Font.Size      = -1*(LGF.lfHeight*72)/LogPx
       Font.Bold      = IIf(LGF.lfWeight = 700,True,False)
       Return True
    Else
       Return False
    End If
End Function

Operator QFontDialog.Cast as any ptr
    return @This
end Operator

Constructor QFontDialog
    Caption = "Choose Font..."
    BackColor = GetSysColor(color_btnface)
End Constructor

Destructor QFontDialog
End Destructor

