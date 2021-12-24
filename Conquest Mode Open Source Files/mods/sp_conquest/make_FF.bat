del mod.ff

xcopy ui ..\..\raw\ui /SYI
xcopy ui_mp ..\..\raw\ui_mp /SYI
xcopy english ..\..\raw\english /SYI
copy /Y mod.csv ..\..\zone_source
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\sp_conquest
copy ..\..\zone\english\mod.ff

pause