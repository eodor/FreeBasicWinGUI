#include once "richedit.bi"

dim shared as qform form
dim shared as qrichedit re

form.parent=0

re.visible = 1
re.parent = form
re.font.name = "lucida console"
re.font.size = 10
re.Align = 5

re.loadfromfile "testrichedit.bas"
re.savetofile "###.txt"

Function IsKeyword(s As String) As Integer
    Dim As String Syntaxes(24) =>{"SUB","FUNCTION","END","IF","THEN","ELSE","FOR","NEXT","SELECT","CASE","WHILE","WEND","WITH","DO","LOOP","UNTIL","RETURN","INTEGER","STRING","BYTE","SINGLE","DOUBLE","AS","IS"}
    Dim As Integer i
    For i = 0 To UBound(Syntaxes) -1
        If UCase(s) = UCase(Syntaxes(i)) Then Return i 
    Next i
    Return -1
End Function

Sub HiLight(RichEdit As QRichEdit)
    Dim As Integer i,k
    Dim As String t,Tk,s,p
    s =  RichEdit.Text
    'Adjust line breaks
    For i = 0 To Len(s)
        If s[i] <> 13 Then t = t + Chr(s[i])
    Next i
    s = t
    t =  ""
    For i = 0 To Len(s)
        t = t + Chr(s[i])
        If s[i] = 32 OR s[i] = 10 Then
            Tk = Mid(t,1,Len(t)-1)
            If IsKeyword(Tk) <> -1 Then 
               RichEdit.SelStart = i - Len(Tk)
               RichEdit.SelLength = Len(Tk)
               RichEdit.SelAttributes.Color = &hff0000'clBlue
            Else
               RichEdit.SelLength = 0 
               RichEdit.SelAttributes.Color = 0 
            End If
            t = "" 
        End If
    Next i
End Sub

HiLight(re)

form.parent=0

application.run