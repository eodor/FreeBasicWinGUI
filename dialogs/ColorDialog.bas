#include once "ColorDialog.bi"

Function QColorDialog.Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
    Static As HBrush Brush
    Select Case Msg
    Case wm_initdialog 
        Dim As QColorDialog Ptr CommonDialog = Cast(QColorDialog Ptr,*Cast(lpChooseColor,lParam).lCustData)
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
        Dim As QColorDialog Ptr CommonDialog = Cast(QColorDialog Ptr,GetWindowLong(FWindow,gwl_userdata))
        If CommonDialog Then
            With *CommonDialog
                SetBkMode(Cast(HDc,wParam),Transparent)
                SetBkColor(Cast(HDc,wParam),.BackColor)
                SetBkMode(Cast(HDc,wParam),Opaque)
                Return CInt(Brush)
            End With
        End If     
    Case wm_erasebkgnd
        Dim As QColorDialog Ptr CommonDialog = Cast(QColorDialog Ptr,GetWindowLong(FWindow,gwl_userdata))
        If CommonDialog Then
            With *CommonDialog
                Dim As HDC Dc = Cast(HDC,wParam)
                Dim As Rect R
                GetClientRect(FWindow,@R)
                FillRect(Dc,@R,Brush)
                Return True
            End With
        End If
    Case Else
        Return False
    End Select
    Return True
End Function

Function QColorDialog.Execute As Integer
    Dim As ChooseColorA CC
    CC.lStructSize  = SizeOf(CC)
    CC.lpCustColors = @Colors(0)
    CC.hWndOwner    = IIf(Parent,Parent->Handle,0)
    CC.RGBResult    = Color
    CC.Flags        = CC_RGBINIT
    CC.Flags        = CC.Flags or CC_ENABLEHOOK
    Select Case Style
    Case 0
        CC.Flags    = CC.Flags or CC_FULLOPEN 
    Case 1
        CC.Flags    = CC.Flags or CC_PREVENTFULLOPEN
    End Select
    CC.lpfnHook     = @Hook
    CC.lCustData    = Cast(lParam,@This)
    If ChooseColor(@CC) Then
       Color = CC.RGBResult
       Return True
    End If
    Return False
End Function

Operator QColorDialog.Cast as any ptr
    return @This
end Operator

Constructor QColorDialog
    Caption = "Choose Color..."
    BackColor = GetSysColor(color_btnface)
End Constructor

Destructor QColorDialog
End Destructor
