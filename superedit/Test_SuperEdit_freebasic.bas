#include once "superedit.inc"

type QSuperEdit extends QFrame
    protected:
    fModule as hmodule
    CreateEdit as function stdcall(p as hwnd,x as integer,y as integer,cx as integer,cy as integer) as hwnd
    declare virtual sub CreateHandle
    public:
    FreeAll as sub stdcall()
    declare operator cast as any ptr
    declare constructor
    declare destructor
end type

sub QSuperEdit.CreateHandle
    if CreateEdit then fHandle=CreateEdit(ParentWindow,fx,fy,fcx,fcy)
end sub

operator QSuperEdit.cast as any ptr
    return @this
end operator

constructor QSuperEdit
    fModule=dylibload("superedit.dll")
    if fModule then
       CreateEdit=dylibsymbol(fModule,"Editor_Create")
       FreeAll=dylibsymbol(fModule,"FreeAll")
    end if
    fcx=220
    fcy=120
end constructor

destructor QSuperEdit
    if fModule then dylibfree(fmodule)
end destructor

type QForm1 extends QForm
    as QSuperEdit Edit
    declare virtual sub Dispatch(byref as QMessage)
    public:
    declare operator cast as any ptr
    declare constructor
    declare destructor
end type

var Form1=QForm1

sub QForm1.Dispatch(byref m as QMessage)
    Base.Dispatch(m)
    if m.msg=wm_close then
       if Edit.FreeAll then Edit.FreeAll()
       ExitProcess(1)
    end if
end sub

operator QForm1.cast as any ptr
   return @this
end operator

constructor QForm1
    this.Name="Form1"
    this.Text="Form1"
    this.SetBounds(627,218,554,352)
    this.Parent=0
    Edit.Parent=this
    Edit.Align=alClient
'    #ifdef IDesigner
'         this.DesignMode=true
'         this.ptrDesigner->ClassName="QButton"
'    #endif
end constructor

destructor QForm1
end destructor
