'Small_gui.bi -library windows controls wrapper
'Copyright (c)2020 Vasile Eodor Nastasa
'mail: nastasa.eodor@gmail.com
'web:http://www.rqwork.de

#include once "vbcompat.bi"
#include once "kogaion_gui.bi"

#DEFINE Q_List(__Ptr__) *Cast(QList Ptr,__Ptr__)
#DEFINE Q_Strings(__Ptr__) *Cast(QStrings Ptr,__Ptr__)

Type PList As QList Ptr
Type QList extends QObject
    Private:
    FCount As Integer
    Public:
    Items  As Any Ptr Ptr
    Declare Property Count As Integer
    Declare Property Count(Value As Integer)
    Declare Sub Add(Item As Any Ptr)
    Declare Sub Insert(Index As Integer,Item As Any Ptr)
    Declare Sub Remove Overload(Item As Any Ptr)
    Declare Sub Remove(Index As Integer)
    Declare Sub Exchange(Index1 As Integer,Index2 As Integer)
    Declare Function IndexOf(Item As Any Ptr) As Integer
    Declare Sub Clear
    Declare Operator Cast As Any Ptr
    Declare Operator Cast As Any Ptr ptr
    Declare Constructor
    Declare Destructor
End Type

type PStrings as QStrings ptr
type QStrings extends QObject
    enum QStringsAction
        acNone=0
        acError
        acAdd
        acInsert
        acRemove
        acClear
        acLoadFromFile
        acSaveToFile
    end enum
    protected:
    as QStringsAction fAction
    as zstring ptr ptr fItems
    as integer fCount, fCapacity
    as string fText
    as any ptr ptr fObjects
    as boolean fAllowDuplicates
    as string fFileName 
    as PObject fOwner
    public:
    declare sub Change
    declare function Occurencies(as string) as integer
    declare function IndexOf(as string) as integer
    declare function IndexOfObject(as any ptr) as integer
    declare function Add(v as string="",as any ptr=0) as integer
    Declare Sub Insert(as Integer,as String,as Any Ptr = 0)
    Declare Sub Exchange(as Integer,as Integer)
    declare sub Remove overload(as string)
    declare sub Remove overload(as integer)
    declare sub Clear
    declare sub LoadFromFile(as string)
    declare sub SaveToFile(as string)
    declare property Owner as PObject
    declare property Owner(as PObject)
    declare property Items as zstring ptr ptr
    declare property Items (as zstring ptr ptr)
    declare property Item(as integer) as string
    declare property Item(as integer,as string)
    declare property Count as integer
    declare property Count (as integer)
    declare property Capacity as integer
    declare property Capacity (as integer)
    declare property Text as string
    declare property Text(as string)
    declare operator cast as zstring ptr ptr
    declare operator cast as any ptr
    declare operator cast as string
    declare operator let (as string)
    declare constructor( as zstring ptr ptr=0)
    declare destructor
    onChange as sub(byref as QStrings,as QStringsAction)
end type

