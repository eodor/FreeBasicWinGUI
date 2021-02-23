'################
'#  QOpenDialog #
'################

#include once "OpenDialog.bi"

Function QOpenDialog.Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
    Select Case Msg
    Case wm_initdialog
        Dim As pOpenDialog CommonDialog = Cast(QOpenDialog Ptr,*Cast(lpOpenFileName,lParam).lCustData)
        If CommonDialog Then
            CommonDialog->Handle = FWindow
            SetWindowLong(FWindow,gwl_userdata,Cint(CommonDialog))
            SetWindowText(FWindow,CommonDialog->Caption)
        End If
        Return True
    Case wm_notify
        Dim As QOpenDialog Ptr CommonDialog = Cast(QOpenDialog Ptr,GetWindowLong(FWindow,gwl_userdata))
        Dim As OFNOTIFY Ptr POF
        POF = Cast(OFNOTIFY Ptr,lParam)
        Select Case POF->hdr.Code 
        Case CDN_FILEOK
            SetWindowLong(GetParent(FWindow),DWL_MSGRESULT,True)
            Return True
        Case CDN_SELCHANGE
            If CommonDialog Then If CommonDialog->OnSelectionChange Then CommonDialog->OnSelectionChange(*CommonDialog)
        Case CDN_FOLDERCHANGE
            If CommonDialog Then If CommonDialog->OnFolderChange Then CommonDialog->OnFolderChange(*CommonDialog)
        Case CDN_TYPECHANGE
            Dim As Integer Index
            Index = *Cast(OPENFILENAME Ptr,POF->lpOFN).nFilterIndex
            If CommonDialog Then 
                CommonDialog->FilterIndex = Index
                If CommonDialog->OnTypeChange Then CommonDialog->OnTypeChange(*CommonDialog,Index)
            End If
        Case CDN_INITDONE 
            If CommonDialog Then
                If CommonDialog->Center Then 
                    Dim As Rect R
                    Dim As Integer L,T,W,H
                    GetWindowRect(GetParent(FWindow),@R)
                    L = R.Left
                    T = R.Top
                    W = R.Right  - R.Left
                    H = R.Bottom - R.Top
                    L = (GetSysTemMetrics(SM_CXSCREEN) - W)\2
                    T = (GetSysTemMetrics(SM_CYSCREEN) - H)\2
                    SetWindowPos(GetParent(FWindow),0,L,T,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER)
                End If
            End If
        End Select
    Case wm_destroy 
    Case Else
        Return False
    End Select
    Return True
End Function

Function QOpenDialog.Execute As Integer
    Dim As OPENFILENAME OPFN
    Dim As String s = ""
    Dim As String Fn
    If InStr(Filter,"|") Then
        For i As Integer = 0 To Len(Filter)
            If Filter[i] = Asc("|") Then
               Filter[i] = 0
            End If
            s += Chr(Filter[i])
        Next i
        Filter = s + Chr(0)
    End If
	With OPFN
         .lStructSize        = SizeOF(OPENFILENAME)
         .hwndOwner          = IIf(Parent,Parent->Handle,0)
         .hInstance          = GetModuleHandle(NULL)
         .lpstrFilter        = StrPtr(s)
         .lpstrCustomFilter  = NULL
         .nMaxCustFilter     = 0
         .nFilterIndex       = FilterIndex
         Fn = String(MAX_PATH,0)
         .lpstrFile = StrPtr(Fn)
         .nMaxFile  = Len(Fn)
         If (Options And ofAllowMultiSelect) = ofAllowMultiSelect Then
             Fn = String(65535 -16,0)
             .lpstrFile = StrPtr(Fn)
             .nMaxFile  = Len(Fn)
         End If
         .lpstrFileTitle     = NULL
         .nMaxFileTitle      = 0
         If InitialDir = "" Then 
            .lpstrInitialDir = StrPtr(InitialDir)
         Else
            .lpstrInitialDir = StrPtr(".") 
         End If
         .lpstrTitle         = StrPtr(Caption)
         .Flags              = Options
         .lpfnHook           = Cast(LPOFNHOOKPROC,@Hook)
         .nFileOffset        = 0
         .nFileExtension	 = 0
         .lpstrDefExt        = StrPtr(DefaultExt)
         .lCustData          = Cast(dword,@This)
         .lpTemplateName     = NULL
	End With
	If GetOpenFileName(@OPFN) Then
	   FileName = Trim(Fn,Chr(0))
           Return True
	End If
    Return False
End Function

Operator QOpenDialog.Cast As Any Ptr
    Return @This
End Operator

Constructor QOpenDialog
    Caption       = "Open File..."
    FilterIndex   = 1
    Center        = True
    Options.Include OFN_FILEMUSTEXIST 
    Options.Include OFN_PATHMUSTEXIST 
    Options.Include OFN_EXPLORER 
    Options.Include OFN_ENABLEHOOK
End Constructor

Destructor QOpenDialog
End Destructor

