#include once "BrowseDialog.bi"

Function QBrowseDialog.Hook(FWindow As HWND,uMsg As uINT,lParam AS LPARAM,lpData As LPARAM) As Integer
    Dim As qBrowseDialog Ptr BrowseDialog
    Dim R As Rect
    If uMsg = BFFM_INITIALIZED then
        BrowseDialog = cast(PBrowseDialog,lpData)
        if BrowseDialog then BrowseDialog->Handle = FWindow
        GetWindowRect(FWindow, @R)
        If BrowseDialog->Center Then
            MoveWindow(FWindow,_
                       (GetSystemMetrics(SM_CXSCREEN)-(R.Right-R.Left))/2,_
                       (GetSystemMetrics(SM_CYSCREEN)-(R.Bottom-R.Top))/2,_
                       (R.Right-R.Left),(R.Bottom-R.Top),_
                       1)
        End If
        SendMessage(FWindow,BFFM_SETSELECTIONA,1,CUint(lpData))
        If Len(BrowseDialog->Caption) then
           SetWindowText(FWindow, BrowseDialog->Caption)
        End If
    End If
    Return False
End Function

Function QBrowseDialog.Execute As Boolean
    Dim BI    As BROWSEINFO
    Dim pidl  As Any Ptr
    Dim sPath AS String
    Dim xPath AS String 
    sPath = String(MAX_PATH,0)
    xPath = String(MAX_PATH,0)                             '
    InitialDir        = InitialDir + Chr(0)
    BI.hWndOwner      = MainWindow
    BI.pszDisplayName = iif(FileExists(xPath),StrPtr(xPath),strPtr(initialDir))
    BI.lpszTitle      = StrPtr(Title)
    BI.lpfn           = @QBrowseDialog.Hook
    BI.lParam         = Cast(LPARAM,@this)
    pidl = SHBrowseForFolder(@BI)
    If pidl then
       Directory = "" 
       If SHGetPathFromIDList(pidl, sPath) Then
          For i As Integer = 0 To Len(sPath)  
              If sPath[i] <> 0 Then Directory += Chr(sPath[i])
          Next i
          Directory = RTrim(Directory)
       Else
          For i As Integer = 0 To Len(sPath)  
              If xPath[i] <> 0 Then Directory += Chr(xPath[i])
          Next i
          Directory = RTrim(Directory)
       End If
       CoTaskMemFree(pidl)
       Return true
    Else
       Return false
    End If
End Function

Constructor QBrowseDialog
    Title = "Please select a Folder :"
End Constructor

Destructor QBrowseDialog
End Destructor

