'Small_gui_additional.bi -library windows controls wrapper
'this file is part of Koganion(RqWork7) rad-ide
'and can't be redistributed without permission
'Copyright (c)2020 Vasile Eodor Nastasa
'mail: nastasa.eodor@gmail.com
'web:http://www.rqwork.de

#include once "kogaion_gui.bi"
#include once "kogaion_gui_classes.bi"
#include once "kogaion_gui_sysutils.bi"

''register classes to ide
#Define Additional_RegisterClasses "QPanel,QSplitter"

#Define Q_CustomPanel(__ptr__) *cast(QCustomPanel ptr, @__ptr__)
#Define W_CustomPanel(__hwnd__) *cast(QCustomPanel ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))
#Define Q_Panel(__ptr__) *cast(QPanel ptr, @__ptr__)
#Define W_Panel(__hwnd__) *cast(QPanel ptr, GetWindowLong(__hwnd__,GetClassLong(__hwnd__,gcl_cbwndextra)-4))

type QCustomPanel extends QFrame
    private:
        as handle fImageHandle
    protected:
        as integer fBorderStyle,fTextAlignment
        as string fImageBackground
        declare virtual sub Dispatch(byref m as QMessage) 
        declare static function dlgProc(Dlg as hwnd,Msg as uint,wparam as wparam,lparam as lparam) as lresult
        declare property BorderStyle as integer
        declare property BorderStyle(as integer)
        declare property ImageBackground as string
        declare property ImageBackground(as string)
        declare property TextAlignment as integer
        declare property TextAlignment (as integer)
    public: 
        declare virtual operator cast as any ptr
    declare constructor
end type

type QPanel extends QCustomPanel
    declare static function Register as integer
    declare virtual property BorderStyle as integer  '''publish property
    declare virtual property BorderStyle(as integer)
    declare virtual property Alignment as integer  '''publish property
    declare virtual property Alignment(as integer)
    declare virtual property ImageBackground as string
    declare virtual property ImageBackground(as string)
    declare virtual operator cast as any ptr
    declare operator cast as hwnd
    declare constructor
end type

type QCustomSplitter extends QFrame
    private:
    as integer x1,y1,x,y,x2,y2,down
    protected:
     declare virtual sub Dispatch(byref m as QMessage)
     declare static function dlgProc(as hwnd,as uint,as wparam,as lparam) as lresult
     declare sub DrawTrackSplit(as Integer,as Integer)
    public:
     declare virtual property Align as integer
     declare virtual property Align(as integer)
     declare virtual operator cast as any ptr
     declare constructor
     onMoved as QEvent
end type

type QSplitter extends QCustomSplitter
    declare static function Register as integer

    declare virtual operator cast as any ptr
    declare operator cast as hwnd
end type

