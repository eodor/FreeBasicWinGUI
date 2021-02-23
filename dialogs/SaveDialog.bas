'''QSaveDialog
#include once "SaveDialog.bi"

function QSaveDialog.Hook(hDlg as HWND,Msg as UINT,wParam as WPARAM,lParam as LPARAM) as uinteger
    select case Msg
    case WM_INITDIALOG
        dim as PSaveDialog CommonDialog = cast(PSaveDialog,cast(any ptr,*cast(lpOpenFileName,lParam).lCustData))
        if CommonDialog then
            CommonDialog->Handle = hDlg
            SetWindowLong(hDlg,gwl_userdata,cint(cast(any ptr,CommonDialog)))
            SetWindowText(hDlg,CommonDialog->Caption)
        end if
        return 1
    case WM_NOTIFY
        dim as PSaveDialog CommonDialog = cast(PSaveDialog,cast(any ptr,GetWindowLong(hDlg,gwl_userdata)))
        dim as ofnotify ptr POF
        POF = cast(ofnotify ptr,lParam)
        select case POF->hdr.Code 
        case CDN_FILEOK
            SetWindowLong(GetParent(hDlg),DWL_MSGRESULT,1)
            return 1
        case CDN_SELCHANGE
            if CommonDialog then if CommonDialog->OnSelectionChange then CommonDialog->OnSelectionChange(*CommonDialog)
        case CDN_FOLDERCHANGE
            if CommonDialog then if CommonDialog->OnFolderChange then CommonDialog->OnFolderChange(*CommonDialog)
        case CDN_TYPECHANGE
            dim as integer Index
            Index = *cast(OPENFILENAME ptr,POF->lpOFN).nFilterIndex
            if CommonDialog then 
                CommonDialog->FilterIndex=Index
                if CommonDialog->OnTypeChange then CommonDialog->OnTypeChange(*CommonDialog,Index)
            end if
        case CDN_INITDONE 
            if CommonDialog then
                if CommonDialog->Center then 
                    dim as Rect R
                    dim as integer L,T,W,H
                    GetWindowRect(GetParent(hDlg),@R)
                    L = R.Left
                    T = R.Top
                    W = R.Right  - R.Left
                    H = R.Bottom - R.Top
                    L = (GetSysTemMetrics(SM_CXSCREEN) - W)\2
                    T = (GetSysTemMetrics(SM_CYSCREEN) - H)\2
                    SetWindowPos(GetParent(hDlg),0,L,T,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER)
                end if
            end if
        end select
    case WM_DESTROY 
        ''
    case else
        return 0
    end select
    return 1
end function

function QSaveDialog.Execute as integer
    dim as OPENFILENAME OPFN
    dim as string s = ""
    dim as string Fn
    if instr(Filter,"|") then
        for i as integer = 0 to Len(Filter)
            if Filter[i] = asc("|") then
               Filter[i] = 0
            end if
            s += chr(Filter[i])
        next i
        Filter = s + chr(0)
    end if
	with OPFN
         .lStructSize       = sizeof(OPENFILENAME)
         .hwndOwner         = iif(Owner,Owner->Handle,0)
         .hInstance         = GetModuleHandle(NULL)
         .lpstrFilter       = strptr(s)
         .lpstrCustomFilter = NULL
         .nMaxCustFilter    = 0
         .nFilterIndex      = FilterIndex
         Fn = string(MAX_PATH,0)
         .lpstrFile = strptr(Fn)
         .nMaxFile           = len(Fn)
         .lpstrFileTitle     = NULL
         .nMaxFileTitle      = 0
         if InitialDir = "" then 
            .lpstrInitialDir = strptr(InitialDir)
         else
            .lpstrInitialDir = strptr(".") 
         end if
         .lpstrTitle         = strptr(Caption)
         .Flags              = cast(integer,Options)
         .lpfnHook           = cast(LPOFNHOOKPROC,@Hook)
         .nFileOffset        = 0
         .nFileExtension     = 0
         .lpstrDefExt        = strptr(DefaultExt)
         .lCustData          = cast(dword,cast(any ptr,@this))
         .lpTemplateName     = NULL
	end with
	if GetSaveFileName(@OPFN) then
	    FileName = trim(Fn,chr(0))
        return 1
	end if
    return 0
end function

operator QSaveDialog.cast as any ptr
    return cast(any ptr,@this)
end Operator

constructor QSaveDialog
    Caption      = "Save File as..."
    FilterIndex  = 1
    Center       = 1
    Options.Include OFN_EXPLORER 
    Options.Include OFN_ENABLEHOOK
end constructor

destructor QSaveDialog
end destructor