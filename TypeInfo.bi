#define typinfo &hfffff0

#DEFINE TClassType(__Ptr__) *Cast(TType Ptr,__Ptr__)

#Macro Application_newForm(__Type__)
     (new __type__)->Parent=W_Form(mainwindow)
#EndMacro

#Macro Application_newFrame(__Type__,__parent__)
     (new __type__)->Parent=__parent__
#EndMacro

type PType as TType ptr
Type TType
    ClassName As String
    ClassType As Any ptr
    Declare Operator Cast As Any Ptr
    Declare Operator Let(Value As Any Ptr)
End Type