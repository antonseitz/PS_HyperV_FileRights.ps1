
param(
[string]$path_with_vhd ,
[string]$vm_name ,
#[string]$passwort,
#[string]$testping,
#[string]$hostip,
#[bool]$killold,
[bool]$debug
)


if( -not $path_with_vhd ){
	
"USAGE: " + $0  + "-path_with_my_vhd C:\VMS\MY_VM -vm_name name_of_vm [-debug `$true] }"
	exit

}

if($debug){
Set-PSDebug -Trace 1}
else
{Set-PSDebug -Trace 0}



if( -not $vm_name ){
	
	"USAGE: " + $0  + "-PATH_with_my_VHDS C:\VMS\MY_VM -vm_name name_of_vm [-debug `$true] }"
	"VM Name not given: Select one from this list: "
get-vm | select name,VMid

exit
} else {
	
	
	$vmid= (get-vm $vm_name).id.guid
	#$vmid=[string]$vmid
	
	
}

icacls.exe $path_with_vhd


icacls.exe $path_with_vhd /remove "VORDEFINIERT\Administratoren"
icacls.exe $path_with_vhd /grant:r "VORDEFINIERT\Administratoren:(CI)(OI)(F)"

icacls.exe $path_with_vhd /remove "VORDEFINIERT\Hyper-v-Administratoren"
icacls.exe $path_with_vhd /grant:r "VORDEFINIERT\Hyper-v-Administratoren:(CI)(OI)(F)"

icacls.exe $path_with_vhd /remove "NT-AUTORIT�T\SYSTEM"
icacls.exe $path_with_vhd /grant:r "NT-AUTORIT�T\SYSTEM:(CI)(OI)(F)"



icacls.exe $path_with_vhd  /remove "*S-1-15-3-1024-2268835264-3721307629-241982045-173645152-1490879176-104643441-2915960892-1612460704"
icacls.exe $path_with_vhd /grant:r "*S-1-15-3-1024-2268835264-3721307629-241982045-173645152-1490879176-104643441-2915960892-1612460704:(OI)(CI)(F)"




$rights="NT VIRTUAL MACHINE\" + $vmid + ":(CI)(OI)(F)"

icacls.exe $path_with_vhd /remove $rights
icacls.exe $path_with_vhd /grant:r $rights


takeown /f $path_with_vhd/*

icacls.exe $path_with_vhd/* /reset

icacls.exe $path_with_vhd
exit



#S-1-15-3-1024-2268835264-3721307629-241982045-173645152-1490879176-104643441-2915960892-1612460704:(R,W)
#NT VIRTUAL MACHINE\4D793154-0D32-476E-B88D-EC8B7FC18512:(R,W)
#VORDEFINIERT\Administratoren:(I)(F)
#VORDEFINIERT\Hyper-V-Administratoren:(I)(F)
#NT-AUTORITÄT\SYSTEM:(I)(F)


#icacls "E:\VMs\VMName\" /grant:r "*S-1-15-3-1024-2268835264-3721307629-241982045-173645152-1490879176-104643441-2915960892-1612460704":(OI,CI)(F)

# ACHTUNG: vor der SID geht ein * STERNCHEN, sonst kommt der Fehler: 
# "Zuordnungen von Kontennamen und Sicherheitskennungen wurden nicht durchgeführt."
# Diese SID steht für den Hyper SCSI Bus und ist global, d.h. bei allen VMs gleich.


# Vererbung auf Dateien aktivieren
#icacls E:\VMs\VMName\* /inheritance:e




get-vm | select name,VMid
 

 

Am besten auf ganzen Ordner mit Vererbung setzen:


#Auf ganzen Ordner setzen:
#icacls E:\VMs\VMName\ /inheritance:e /grant:r "NT VIRTUAL MACHINE\5FC5C385-BD98-451F-B3F3-1E50E06EE663":(CI)(OI),(F)

# Vererbung auf Dateien aktivieren
icacls E:\VMs\VMName\* /inheritance:e