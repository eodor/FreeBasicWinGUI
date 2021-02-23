#include once "windows.bi"
#include once "win/commctrl.bi"

type QXPManifest extends QStrings
    protected:
     as string fFileName
     declare sub Writer
    public:
     declare sub Execute
     declare virtual operator cast as any ptr
     declare constructor
end type

sub QXPManifest.Writer
    Add("<?xml version=""1.0"" encoding=""UTF-8"" standalone=""yes""?>")
    Add("<assembly xmlns=""urn:schemas-microsoft-com:asm.v1"" manifestVersion=""1.0"">")
    Add("<assemblyIdentity")
    Add("version = ""1.0.0.0""")
    Add("processorArchitecture = ""X86""")
    Add("name = ""[].[].[]""")
    Add("type=""win32""")
    Add("/>")
    Add("<description></description>")
    Add("<dependency>")
    Add("<dependentAssembly>")
    Add("<assemblyIdentity")
    Add("type=""win32""")
    Add("name = ""Microsoft.Windows.Common-Controls""")
    Add("version = ""6.0.0.0""")
    Add("processorArchitecture = ""X86""")
    Add("publicKeyToken = ""6595b64144ccf1df""")
    Add("language = ""*""")
    Add("/> ")
    Add("</dependentAssembly>")
    Add("</dependency>")
    Add("</assembly>")
end sub

sub QXPManifest.Execute
    fFileName=Command(0)+".manifest"
    Writer
    SaveToFile(fFileName)
end sub

operator QXPManifest.cast as any ptr
    return @this
end operator

constructor QXPManifest
    classname="QXPManifest"
    InitCommonControls
end constructor

'''globals
#IFNDEF XP
#define XP *(new QXPManifest)
        XP.Execute
#ENDIF