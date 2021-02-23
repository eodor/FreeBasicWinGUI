'#######################
'#  QOpenDialogOptions #
'#######################

#include once "OpenDialogOptions.bi"

Sub QOpenDialogOptions.Include(Value As Integer)
    Count += 1
    Options = ReAllocate(Options,Count*SizeOF(Integer))
    Options[Count-1] = Value
End Sub

Sub QOpenDialogOptions.Exclude(Value As Integer)
    Dim As Integer Idx
    For i As Integer = 0 To Count -1
        If Options[i] = Value Then Idx  = 1 
    Next i
    If Idx < Count Then
       Count -= 1
       For i As Integer = Idx To Count-1
            Options[i] = Options[i + 1]
       Next i                               
    End If
    Options = ReAllocate(Options,SizeOf(Integer) * Count)
End Sub

Operator QOpenDialogOptions.Cast As Integer
    Dim As Integer DlgOptions
    For i As Integer = 0 To Count -1
        DlgOptions or= Options[i]
    Next i
    Return DlgOptions
End Operator

