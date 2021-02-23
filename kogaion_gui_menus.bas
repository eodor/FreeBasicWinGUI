
#include once "kogaion_gui_menus.bi"

/' QMenuItem '/
sub QMenuItem.Create
end sub

sub QMenuItem.Free
end sub

operator QMenuItem.cast as any ptr
    return @this
end operator

constructor  QMenuItem
end constructor

/' QMainMenu '/
function QMainMenu.Register as integer
    dim as wndclassex wcls
    wcls.cbsize=sizeof(wcls)
    wcls.lpszclassname=@"QMainMenu"
    wcls.lpfnwndproc=@DefWindowProc
    wcls.hinstance=0
    wcls.cbwndextra+=4
    wcls.cbclsextra+=4
    return RegisterClassEx(@wcls)
end function

sub QMainMenu.Create
    Free
end sub

sub QMainMenu.Free
    if isMenu(this.fHandle)then
       DestroyMenu(this.fHandle)
       this.fHandle=0
    end if   
end sub

operator QMainMenu.cast as any ptr
    return @this
end operator

constructor QMainMenu
end constructor

/' QPopupMenu '/
property QPopupMenu.Window as hwnd
    return fWindow
end property

property QPopupMenu.Window (v as hwnd)
    fWindow=v
end property

function QPopupMenu.Register as integer
    dim as wndclassex wcls
    wcls.cbsize=sizeof(wcls)
    wcls.lpszclassname=@"QPopupMenu"
    wcls.lpfnwndproc=@DefWindowProc
    wcls.hinstance=0
    wcls.cbwndextra+=4
    wcls.cbclsextra+=4
    return RegisterClassEx(@wcls)
end function

sub QPopupMenu.AutoPopup(v as point)
    if isWindow(fWindow) then
       if fCount then TrackPopupMenu(fHandle,TPM_RETURNCMD,v.x,v.y,0,fWindow,0)
    end if
end sub

sub QPopupMenu.Create
    this.fHandle=CreatePopupMenu
end sub

sub QPopupMenu.Free
    if isMenu(this.fHandle)then
       DestroyMenu(this.fHandle)
       this.fHandle=0
    end if   
end sub

operator QPopupMenu.cast as any ptr
    return @this
end operator

operator QPopupMenu.cast as hMenu
    return fHandle
end operator

constructor QPopupMenu
end constructor