;ANSI 32-bit
#SingleInstance,ignore
Menu,tray,Tip, Start My EXE
Menu,tray,NoStandard
Menu,Tray,Add,����,hide
Menu,Tray,Add,��ʾ,showall
Menu,Tray,Add,�˳�,guiclose
gosub listconfig
;�����������ļ����ֿ��԰����޸�
my_exe = kcptun.exe
log = ������������`n`n��exe����ͬ�ļ����£�������Ϊ%my_exe%��Ȼ��ѡ�����Ӱ�ť����������������֡���д����ѡ������ҵ����ã���������ҵĳ���`n`n
Gui,Add,ListBox,x5 y5 w150 h110 vconfigname gloadconfig,%configlist%
Gui,Add,Edit,x5 y120 w150 h140 ReadOnly WantCtrlA vlogwindow,%log%
Gui,Add,Button,Default x324 y235 w32 h25 gstop,ֹͣ
Gui,Add,Button,Default x284 y235 w32 h25 ghide,����
Gui,Add,Button,Default x244 y235 w32 h25 gstart,����
Gui,Add,Button,Default x204 y235 w32 h25 gsave,����
Gui,Add,Button,Default x164 y235 w32 h25 gadd,����
Gui,Add,Text,x165 y5 w190,������
Gui,Add,Edit,x165 y25 w190 h200 vparameter
Gui,Show, W365 H270 Center,Start My EXE
return
listconfig:
configlistraw =
Loop,*.ini,0,0
{
configlistraw = %configlistraw%|%A_LoopFileName%
}
StringTrimLeft,configlist,configlistraw,1
return
start:
if configname =
{
log = ����ӻ�ѡ��һ�������ļ���
GuiControl,,logwindow,%log%
return
}
IfNotExist %my_exe%
{
log = %my_exe%�����ڣ�
GuiControl,,logwindow,%log%
return
}
gosub closeallmyexe
Gui Submit,nohide
runmyexe = %my_exe% %parameter%
loop
{
if stopstart = 1
{
stopstart = 0
break
}
Process,Exist,%my_exe%
if ErrorLevel = 0
run, %runmyexe%
ControlSend,,y,%A_WorkingDir%\%my_exe%
ControlSend,,{enter},%A_WorkingDir%\%my_exe%
sleep 3000
}
return
stop:
stopstart = 1
gosub closeallmyexe
return
add:
addconfig = none
InputBox, addconfig , �������������ƣ�,,,300,120
if ErrorLevel
return
addconfig = %addconfig%.ini
IniWrite, none, %addconfig%, Section,parameter
gosub listconfig
GuiControl,,configname,%configlistraw%
return
save:
Gui Submit,nohide
if configname =
return
IniWrite, %parameter%, %configname%, Section,parameter
gosub loadconfig
return
loadconfig:
Gui Submit,nohide
IniRead, parameter, %configname%, Section, parameter
GuiControl,,parameter,%parameter%
return
guiclose:
gosub closeallmyexe
exitapp
closeallmyexe:
loop
{
Process,Close,%my_exe%
Process,Exist,%my_exe%
if ErrorLevel = 0
break
if a_index >= 10
break
sleep,500
}
return
GuiSize:
If A_EventInfo=1
{
gosub hide
}
Return
hide:
DetectHiddenWindows,Off
WinHide,Start My EXE
WinHide,%A_WorkingDir%\%my_exe%
return
showall:
WinShow,%A_WorkingDir%\%my_exe%
WinShow,Start My EXE
return
