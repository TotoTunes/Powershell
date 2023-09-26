$UserName = $env:username 
$Filter = "(&(objectCategory=User)(samAccountName=$UserName))" 
$Searcher = New-Object System.DirectoryServices.DirectorySearcher 
$Searcher.Filter = $Filter 
$ADUserPath = $Searcher.FindOne() 
$ADUser = $ADUserPath.GetDirectoryEntry() 
$ADCompany = $ADUser.company
$ADDepartment = $ADUser.department
$ADGroup = $ADUser.memberOf
if ( $ADCompany -eq "BESIX Infra") {
	net use k: /d /y
	net use	K: \\hewbefs001.hbe.local\hb_algemeen$
	net use o: /d /y
	net use	O: \\hewbefs001.hbe.local\applicaties$
	net use p: /d /y
	net use	P: \\hewbefs001.hbe.local\apps
	net use r: /d /y
	net use	R: \\Hewbefs001.hbe.local\inf$\Afdelingen
	net use s: /d /y
	net use	S: \\Hewbefs001.hbe.local\inf$\Projecten
	net use t: /d /y
	net use	T: \\Hewbefs001.hbe.local\inf$\Algemeen
	net use u: /d /y
	net use u: \\Hewbefs001.hbe.local\inf$\homes\%username%
	net use w: /d /y
	net use	W: \\hewbefs002.hbe.local\archief$\Heijmans_infra
	if ( Test-Path "\\hewbefs002.hbe.local\pst$\%username%" -eq true) {
		net use V: /d /y
		net use V: \\hewbefs002.hbe.local\pst$\%username%
	}
    if ( $ADDepartment -eq "Management") {
        net use M: /d /y
        net use	M: \\hewbefs001.hbe.local\ssc$
    }
    if ( $ADGroup -eq "CN=SGG_INF_DAT_PRIJSAANVRAGEN,OU=Security Groups,OU=Heijmans Infra (INF),OU=_Heijmans Belgie NV,DC=HBE,DC=local") {
        net use L: /d /y
        net use	L: \\hewbefs001.hbe.local\inf$\Externen
    }
}
if ( $ADCompany -eq "BESIX Infra Support") {
	net use k: /d /y
	net use k: \\hewbefs001.hbe.local\hb_algemeen$
	net use o: /d /y
	net use o: \\hewbefs001.hbe.local\applicaties$
	net use p: /d /y
	net use p: \\hewbefs001.hbe.local\apps
	net use r: /d /y
	net use r: \\Hewbefs001.hbe.local\hld$\Afdelingen
	net use s: /d /y
	net use s: \\Hewbefs001.hbe.local\hld$\Projecten
	net use t: /d /y
	net use t: \\Hewbefs001.hbe.local\hld$\Algemeen
	net use M: /d /y
	net use	M: \\hewbefs001.hbe.local\ssc$
	net use u: /d /y
	net use u: \\Hewbefs001.hbe.local\hld$\homes\%username%
	net use w: /d /y
	net use w: \\hewbefs002.hbe.local\archief$\Shared_Services_Center
	if ( Test-Path "\\hewbefs002.hbe.local\pst$\%username%" -eq true) {
		net use V: /d /y
		net use V: \\hewbefs002.hbe.local\pst$\%username%
	}
    if ( $ADDepartment -eq "Human Resources") {
	    net use x: /d /y
	    net use	x: \\hewbefs001.hbe.local\Interface_eBlox
    }
	if ( $AUser -eq "hb-luhe") {
		net use r: /d /y
		net use	R: \\Hewbefs001.hbe.local\inf$\Afdelingen
		net use s: /d /y
		net use	S: \\Hewbefs001.hbe.local\inf$\Projecten
		net use t: /d /y
		net use	T: \\Hewbefs001.hbe.local\inf$\Algemeen
		net use u: /d /y
		net use u: \\Hewbefs001.hbe.local\inf$\homes\%username%
		net use w: /d /y
		net use	W: \\hewbefs002.hbe.local\archief$\Heijmans_infra
	}
	if ( $AUser -eq "hb-luve") {
		net use i: /d /y
		net use	I: \\Hewbefs001.hbe.local\inf$\
		net use v: /d /y
		net use	V: \\Hewbefs001.hbe.local\vdb$\
		net use w: /d /y
		net use	W: \\hewbefs002.hbe.local\archief$\ 
		net use u: /d /y
		net use u: \\Hewbefs001.hbe.local\hld$\homes\%username%
		net use f: /d /y
		net use f: \\hewbefs001.hbe.local\vdb$\Afdelingen\Calculatie\Offertes
		net use x: /d /y
		net use	X: \\Hewbefs001.hbe.local\inf$\Afdelingen
		net use y: /d /y
		net use	Y: \\Hewbefs001.hbe.local\inf$\Projecten
		net use z: /d /y
		net use	Z: \\Hewbefs001.hbe.local\inf$\Algemeen
	}
}
if ( $ADCompany -eq "Larabo") {
	net use L: /d /y
	net use	L: \\hewbefs001.hbe.local\hb_algemeen$
	net use N: /d /y
	net use	N: \\hewbefs001.hbe.local\applicaties$
	net use p: /d /y
	net use	P: \\hewbefs001.hbe.local\apps
	net use r: /d /y
	net use	R: \\hewbefs001.hbe.local\vdb$\Afdelingen\Projectuitvoering_vestiging_Schelle_IN
	net use t: /d /y
	net use	T: \\Hewbefs001.hbe.local\vdb$\Algemeen
	net use u: /d /y
	net use u: \\Hewbefs001.hbe.local\vdb$\homes\%username%
	net use w: /d /y
	net use	W: \\hewbefs002\archief$\Van_Den_Berg
	net use K: /d /y
	net use	K: \\192.168.200.91\data
	net use O: /d /y
	net use	O: "\\192.168.200.97\google drive"
}
if ( $ADCompany -eq "Van den Berg") {
	net use k: /d /y
	net use	K: \\hewbefs001.hbe.local\hb_algemeen$
	net use o: /d /y
	net use	O: \\hewbefs001.hbe.local\applicaties$
	net use p: /d /y
	net use	P: \\hewbefs001.hbe.local\apps
	net use r: /d /y
	net use	R: \\Hewbefs001.hbe.local\vdb$\Afdelingen
	net use t: /d /y
	net use	T: \\Hewbefs001.hbe.local\vdb$\Algemeen
	net use u: /d /y
	net use u: \\Hewbefs001.hbe.local\vdb$\homes\%username%
	net use w: /d /y
	net use	W: \\hewbefs002\archief$\Van_Den_Berg
	if ( Test-Path "\\hewbefs002.hbe.local\pst$\%username%" -eq true) {
		net use V: /d /y
		net use V: \\hewbefs002.hbe.local\pst$\%username%
	}
    if ( $ADDepartment -eq "Project Administration") {
	    net use M: /d /y
	    net use	M: \\hewbefs001.hbe.local\ssc$
    }
    if ( $ADDepartment -eq "Management") {
        net use M: /d /y
        net use	M: \\hewbefs001.hbe.local\ssc$
    }
}
if ( $ADCompany -eq "Belasco") {
	net use k: /d /y
	net use	K: \\hewbefs001.hbe.local\hb_algemeen$
	net use o: /d /y
	net use	O: \\hewbefs001.hbe.local\applicaties$
	net use p: /d /y
	net use	P: \\hewbefs001.hbe.local\apps
	net use r: /d /y
	net use	R: \\Hewbefs001.hbe.local\inf$\Afdelingen
	net use s: /d /y
	net use	S: \\Hewbefs001.hbe.local\inf$\Projecten
	net use t: /d /y
	net use	T: \\Hewbefs001.hbe.local\inf$\Algemeen
	net use u: /d /y
	net use u: \\Hewbefs001.hbe.local\bel$\homes\%username%
	net use w: /d /y
	net use	W: \\hewbefs002.hbe.local\archief$\Heijmans_infra
	if ( Test-Path "\\hewbefs002.hbe.local\pst$\%username%" -eq true) {
		net use V: /d /y
		net use V: \\hewbefs002.hbe.local\pst$\%username%
	}
}