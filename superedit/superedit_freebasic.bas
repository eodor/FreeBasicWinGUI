/'
   was builded with Kogaion(RqWork7)
'/

#define isProjectProject1 true
#define Project1Compiler "C:\Program Files (x86)\freebasic\fbc.exe"
#define Project1Switch -i "C:\Users\nasta\Desktop\IDE7\gui" -i "C:\Users\nasta\Desktop\IDE7\fcl\extra" -i "C:\Users\nasta\Desktop\IDE7\package" -i "C:\Users\nasta\Desktop\IDE7\gui\dialogs" -i "C:\Users\nasta\Desktop\IDE7\gui\richedit" -i "C:\Users\nasta\Desktop\IDE7\fcl\User" -i "C:\Users\nasta\Desktop\IDE7\DelphiClasses" -i "C:\Users\nasta\Desktop\IDE7\fcl\Delphi" C:\Users\nasta\Desktop\rqwork7_basic\rqwork7.rc  -include "C:\Users\nasta\Desktop\IDE7\gui\core.bi"

#include once "C:\Users\nasta\Desktop\IDE7\gui\core.bi"

#if defined(module)=0
    common shared as hmodule module
#endif

 /'Form1'/ #include once "C:\Users\nasta\Desktop\Test_SuperEdit_freebasic.bas"

Application.Run
