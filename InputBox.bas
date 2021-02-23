#define Q_InputBox(__ptr__) *cast(PInputBox,__ptr__)

type PInputBox as QInputBox ptr
type QInputBox extends QForm
    as QLabel Prompt
    as QEdit Edit
    as QButton OK
    as QButton Cancel
    declare static sub OKClick(sender as QObject)
    declare static sub CancelClick(sender as QObject)
    public:
    as integer ModalResult
    declare operator cast as any ptr
    declare constructor
end type

sub QInputBox.OKClick(sender as QObject)
    dim as PButton B=Q_Button(sender)
    dim as PInputBox IB=Q_InputBox(B->Parent)
    IB->ModalResult=idok
    IB->DestroyHandle
end sub

sub QInputBox.CancelClick(sender as QObject)
    dim as PButton B=Q_Button(sender)
    dim as PInputBox IB=Q_InputBox(B->Parent)
    IB->ModalResult=idcancel
    IB->Edit.Text=""
    IB->DestroyHandle
end sub

operator QInputBox.cast as any ptr
   return @this
end operator

constructor QInputBox
    this.exstyle=ws_ex_dlgmodalframe
    this.Style=ws_caption or ws_sysmenu
    this.Name="InputBox"
    this.Text="InputBox"
    this.SetBounds(448,195,480,154)
    Prompt.Text="Prompt"
    Prompt.Align=0
    Prompt.Canvas.Color=clBtnFace
    Prompt.Name="Prompt"
    Prompt.SetBounds(8,8,243,18)
    Prompt.Parent=this
    Edit.Text=""
    Edit.Align=0
    Edit.Canvas.Color=clBtnFace
    Edit.Name="Edit"
    Edit.SetBounds(8,32,441,25)
    Edit.Parent=this
    OK.Text="OK"
    OK.Align=0
    OK.Name="OK"
    OK.SetBounds(152,72,75,27)
    OK.Parent=this
    Cancel.Text="Cancel"
    Cancel.Align=0
    Cancel.Name="Cancel"
    Cancel.SetBounds(240,72,75,27)
    Cancel.Parent=this
    Ok.OnClick=@OKClick
    Cancel.OnClick=@CancelClick
end constructor

common shared as PInputBox inpBox

function inputBox( c as string,p as string,i as string) as string
    inpBox=new QInputBox
    inpbox->prompt.text=p
    inpbox->text=c
    inpbox->edit.text=i
    inpbox->showmodal
    return inpbox->edit.text
end function
