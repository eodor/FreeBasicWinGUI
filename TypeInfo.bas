#include once "typeinfo.bi"

Operator TType.Cast As Any Ptr
    Return ClassType
End Operator

Operator TType.Let(Value As Any Ptr)
    ClassType = Value
End Operator

common Shared As TType ptr ptr TypeList
common Shared As integer TypeCount

function newClassInfo(v as PType=0) byref as TType
    typecount+=1
    typelist=reallocate(typelist,sizeof(ptype)*typecount)
    typelist[typecount-1]=iif(v,v,new TType)
    return *typelist[typecount-1]
end function
