#include once "windows.bi"
#include once "kogaion_gui_classes.bi"
#include once "kogaion_gui_sysutils.bi"

/' QList '/
Property QList.Count As Integer
    Return FCount
End Property

Property QList.Count(Value As Integer)
    Clear
    for i as integer=0 to value-1
        Add(0)'''add empty item
    next
End Property

Sub QList.Add(Item As Any Ptr)
    If Item Then
        FCount += 1
        Items = ReAllocate(Items,SizeOf(Any Ptr)*FCount)
        Items[FCount -1] = Item
    End If
End Sub

Sub QList.Insert(Index As Integer,Item As Any Ptr)
    If (Index > -1) And (Index < Count) Then
       FCount += 1
       Items = ReAllocate(Items, SizeOf(Any Ptr)*Count)
       For i As Integer = Count To Index+1 Step -1
           Items[i] = Items[i-1]
       Next i
       Items[Index] = Item
    End If
End Sub

Sub QList.Remove(Item As Any Ptr)
    Dim As Integer Index
    Index = IndexOf(Item)
    If (Index > -1) And (Index < Count) Then
       FCount -= 1
       If Index < Count Then
          For i As Integer = Index To Count-1
              Items[i] = Items[i +1]
          Next i                               
       End If
       Items = ReAllocate(Items,SizeOf(Any Ptr)*Count)
    End If
End Sub

Sub QList.Remove(Index As Integer)
    If (Index > -1) And (Index < Count) Then
       FCount -= 1
       If Index < Count Then
          For i As Integer = Index To Count-1
              Items[i] = Items[i +1]
          Next i                               
       End If
       Items = ReAllocate(Items,SizeOf(Any Ptr)*Count)
    End If
End Sub

Sub QList.Exchange(Index1 As Integer,Index2 As Integer)
    If Index1 <> Index2 Then
       If ((Index1 >= 0) And (Index1 < Count)) And ((Index2 >= 0) And (Index2 < Count)) Then
           Swap Items[Index1], Items[Index2]
       End If
    End If
End Sub

Function QList.IndexOf(Item As Any Ptr) As Integer
    Dim i As Integer
    For i = 0 To Count -1 
        If Items[i] = Item Then Return i
    Next i
    Return -1
End Function

Sub QList.Clear
    FCount = 0
    if items then
       deallocate Items
       items=0
    end if
End Sub

Operator QList.Cast As Any Ptr
    Return @This
End Operator

Operator QList.Cast As Any Ptr ptr
    Return items
End Operator

Constructor QList
    FCount = 0
End Constructor

Destructor QList
    If Items Then DeAllocate Items
End Destructor

/' QStrings '/
function QStrings.Occurencies(v as string) as integer
    dim as integer o=0
    if v="" or fcount=0 then exit function
    for i as integer=0 to fCount-1
        if lcase(v)=lcase(*fItems[i]) then o+=1
    next
    return o
end function

function QStrings.IndexOf(v as string) as integer
    for i as integer=0 to fCount-1
        if lcase(v)=lcase(*fItems[i]) then return i
    next
    return -1
end function

function QStrings.IndexOfObject(v as any ptr) as integer
    for i as integer=0 to fCount-1
        if v=fObjects[i] then return i
    next
    return 0
end function

sub QStrings.Change
    if onChange then onChange(this,fAction)
end sub

function QStrings.Add(v as string="",o as any ptr=0) as integer
    if fAllowDuplicates then
       fCount+=1
       fItems=reallocate(fItems,sizeof(zstring ptr)*fCount)
       fItems[fCount-1]=allocate(len(v)+1)
       *fItems[fCount-1]=v
       fObjects=reallocate(fObjects,sizeof(any ptr)*fCount)
       fObjects[fCount-1]=o
       fAction=acAdd
       Change
    else
       if v<>"" then
          if IndexOf(v)=-1 then
             fCount+=1
             fItems=reallocate(fItems,sizeof(zstring ptr)*fCount)
             fItems[fCount-1]=allocate(len(v)+1)
             *fItems[fCount-1]=v
             fObjects=reallocate(fObjects,sizeof(any ptr)*fCount)
             fObjects[fCount-1]=o
             fAction=acAdd
             Change
          end if
       else
          fCount+=1
          fItems=reallocate(fItems,sizeof(zstring ptr)*fCount)
          fItems[fCount-1]=allocate(len(v)+1)
          *fItems[fCount-1]=v
          fObjects=reallocate(fObjects,sizeof(any ptr)*fCount)
          fObjects[fCount-1]=o
          fAction=acAdd
          Change
       end if
    end if
    return fCount
end function

sub QStrings.Remove (v as string)
    dim as integer i=IndexOf(v)
    if i>-1 then this.Remove(i)
end sub

sub QStrings.Remove (v as integer)
    if v>-1 and v<fCount then
       fItems[v]=callocate(0)
       for i as integer=v+1 to fCount-1
           fItems[i-1]=allocate(len(*fItems[i])+1)
           *fItems[i-1]=*fItems[i]
       next
       for i as integer=v+1 to fCount-1
           fObjects[i-1]=fObjects[i]
       next
       fCount -=1
       fItems=reallocate(fItems,sizeof(zstring ptr)*fCount)
       fObjects=reallocate(fObjects,sizeof(any ptr)*fCount)
       fAction=acRemove
       Change
    else
       messageBox(0,"Invalid string index -1.","QStrings",mb_applmodal or mb_topmost)
    end if
end sub

sub QStrings.Clear
    for i as integer=fCount-1 to 0 step -1
        fItems[i]=callocate(0)
        fObjects[i]=0
    next
    fCount=0
    fItems=callocate(0)
    fText=""
    fAction=acClear
    Change
end sub

Sub QStrings.Insert(index as Integer,v as string,obj as Any Ptr=0)
    Dim As zstring Ptr Ptr Temp
    dim as any ptr ptr TempObj
    Dim As Integer i
    If Index >= 0 And Index <= fCount -1 Then
       Temp = cAllocate((fCount+1)*SizeOf(zstring Ptr))
       TempObj = cAllocate((fCount+1)*SizeOf(any Ptr))
       For i = 0 to Index
           Temp[i] = fItems[i]
           TempObj[i]=fObjects[i]
       Next i
       Temp[Index] =callocate(len(v))
       *Temp[Index] = v
       TempObj[index]=obj
       For i = Index to fCount -1
           Temp[i +1] = fItems[i]
           TempObj[i+1]=fObjects[i]
       Next i
       fCount += 1
       fItems = cAllocate(fCount*SizeOf(zstring Ptr))
       fObjects= cAllocate(fCount*SizeOf(any Ptr))
       For i = 0 to fCount -1
           fItems[i] = Temp[i]
           fObjects[i]=TempObj[i]
       Next i
       DeAllocate Temp
       deallocate TempObj
    End If
End Sub

Sub QStrings.Exchange(Index1 As Integer,Index2 As Integer)
    Dim As zstring Ptr P
    dim as any ptr Po
    If ((Index1 >= 0 And Index1 <= Count -1) And (Index2 >= 0 And Index2 <= Count -1)) Then
       Po=fObjects[index1]
       fObjects[index1]=fObjects[index2]
       fObjects[index2]=Po
       P = fItems[Index1]
       fItems[Index1] = fItems[Index2]
       fItems[Index2] = P
    End If
End Sub

sub QStrings.LoadFromFile(v as string)
    dim as string s=""
    fFileName=v
    this.Clear
    if FileExists(v) then
       if open(fFileName for binary access read as #1)=0 then
          while not EOF(1)
              line input #1,s  
              Add(s)
          wend
          close #1
          fAction=acLoadFromFile
          Change
       end if
    else
       fAction=acError
       messageBox(0,"File not found.","QStrings",mb_applmodal or mb_topmost)
    end if
end sub

sub QStrings.SaveToFile(v as string)
    dim as integer i=0
    fFileName=v
    if open(fFileName for binary access write as #1)=0 then
       do
              print #1,*fItems[i]
              i+=1
       loop until i>fCount-1
       close #1
       fAction=acSaveToFile
       Change
    else
       fAction=acError
       messageBox(0,"Can't save. Bad file.","QStrings",mb_applmodal or mb_topmost)
    end if
end sub

property QStrings.Owner as PObject
    return fOwner
end property

property QStrings.Owner(v as PObject)
    fowner=v
    if v then
       v->AddObject(this)
    end if
end property

property QStrings.Text as string
    ftext=""
    for i as integer=0 to fCount-1
        if i<fcount-1 then 
           ftext=ftext+*fitems[i]+chr(10)
        else
           ftext=ftext+*fitems[i]+chr(0)
        end if      
    next
    return ftext
end property

property QStrings.Text(v as string)
    dim as string t=""
    ftext=v
    if v="" then 
       this.clear
       exit property
    end if
    for i as integer=0 to len(v)
        t=t+chr(v[i])
        if v[i]=asc(chr(10)) then
           Add(mid(t,1,len(t)-1)) 
           t=""
        end if
    next       
end property

property QStrings.Items as zstring ptr ptr
    return fItems
end property

property QStrings.Items (v as zstring ptr ptr)
    fItems=v
end property

property QStrings.Item(i as integer) as string
    if i>-1 and i<fCount then return *fItems[i]
end property

property QStrings.Item(i as integer,v as string)
    if i>-1 and i<fCount then *fItems[i]=v
end property

property QStrings.Count as integer
    return fCount
end property

property QStrings.Count (v as integer)
    fCount=v
    if v=0 then this.Clear
    for i as integer=0 to v
        Add
    next    
end property

property QStrings.Capacity as integer
    return fCapacity
end property

property QStrings.Capacity (v as integer)
    if (v mod (sizeof(zstring ptr))) then
       MessageDlg("Wrong capacity value.","QStrings",mb_iconerror)
       exit property
    end if   
    fCapacity=v
    if v then
       fItems=reallocate(fItems,sizeof(zstring ptr)*v)
       fcount=fcapacity\sizeof(zstring ptr)
    else
       this.Clear
    end if   
end property

operator QStrings.let (v as string)
    if v="" then this.Clear
    dim as string s=""
    for i as integer=0 to len(v)
        s=s+chr(v[i])
        if chr(v[i])="," or i=len(v) then
           Add(s)
           s=""
        end if
    next
end operator

operator QStrings.cast as zstring ptr ptr
    return fItems
end operator

operator QStrings.cast as any ptr
    return @this
end operator

operator QStrings.cast as string
    dim as string s=""
    dim as integer i=0
    do
          if s="" then s=*fItems[i] else s=s+" "+*fItems[i]
          i+=1
    loop until i>fCount-1
    return s
end operator

constructor QStrings(A as zstring ptr ptr=0)
    fItems=A
    fAllowDuplicates=true
end constructor

destructor QStrings
    if fOwner then fOwner->RemoveObject(this)
end destructor
