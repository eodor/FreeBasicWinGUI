function formatStr cdecl(ByRef formatstring As String, ...) as string
    '' Get the pointer to the first var-arg
    Dim As Any Ptr arg = va_first()
    dim as string result=""
    '' For each char in format string...
    Dim As UByte Ptr p = StrPtr(formatstring)
    Dim As Integer todo = Len(formatstring)
    While (todo > 0)
        Dim As Integer char = *p
        p += 1
        todo -= 1

        If (char = Asc("%")) Then
            If (todo = 0) Then Exit While
            char = *p
            p += 1
            todo -= 1

            Select Case char
            Case Asc("d")
                result =result & Str(va_arg(arg, Integer))
                arg = va_next(arg, Integer)

            Case Asc("l")
                result =result & Str(va_arg(arg, LongInt))

            Case Asc( "f" ), Asc( "r" )
                result =result & Str(va_arg(arg, Double))
                arg = va_next(arg, Double)

            Case Asc("s")
                result =result & *va_arg(arg, ZString Ptr)
                arg = va_next(arg, ZString Ptr)
                
            end select
        Else
            result=result & chr(char)
        End If
    Wend
    return result
end function