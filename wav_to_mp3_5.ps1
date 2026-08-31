cls

# ffmpeg -i file.wav -vol 1024 -vol 2048 out.mp3

# test command "mpv"
$c1 ="ffmpeg" # mpv.exe nekde v ceste PATH ( viz. screenshoty "scr\*" )
if (-not (Get-Command $c1 -ErrorAction SilentlyContinue )) {
Write-Warning "prikaz $c1 nenalezen"
sleep 5
exit 1
}

$files = @() # definuje napred prazne pole, vnuceni dotoveho tipu funkci Get-ChildItem !
$files += @(Get-ChildItem -Include "*.wav" -Name)

$d_files = $files.Length
#echo $d_files

if ( $d_files -eq 0 ) {
Write-Warning "nenalezeny zadene soubory *.wav"
echo "konec programu"
sleep 5
Exit
}


$poc = 1
# nastaveni hodnoty verbose u vystupu ffmpeg, viz scrennshoty
$pole_lvl = @("quiet", "panic", "fatal", "error", "warning", "info", "verbose", "debug", "trace")
#                0        1        2        3        4          5        6         7        8
$lvl = $pole_lvl[3] # 4 bude asi optimalni (default=5)


for ( $aa = 0; $aa -le $d_files -1; $aa++) {
write-host -ForegroundColor red "$poc/$d_files  " -NoNewline
$poc++
#echo $aa
#echo $files[$aa]
$soubor = $files[$aa]
#echo $soubor
$soubor_2 = $soubor.Substring(0,$soubor.Length -4)

$soubor_3 = $soubor_2 + "_up_1024.mp3"
$soubor_4 = $soubor_2 + "_up_2048.mp3"

$soubor_2 += ".mp3"
write-host "$soubor --> $soubor_3" # -NoNewline
#Write-host -ForegroundColor Red " ; " -NoNewline
write-host "     $soubor --> $soubor_4" 
#echo $soubor_3


& ffmpeg -loglevel $lvl -i $soubor -vol 1024 $soubor_3 -y # -y prepisuje je potlacenej dotaz pres -loglevel $lvl
sleep -Milliseconds 500
& ffmpeg -loglevel $lvl -i $soubor -vol 2048 $soubor_4 -y
sleep -Milliseconds 500


if ( $args[0] -like "-delete" ) { # bude po prevodu mazat puvodni "wav" soubory
write-host -ForegroundColor Yellow "     delete " -NoNewline
write-host $soubor
Remove-Item $soubor -Force
sleep -Milliseconds 500
}

}

echo "HOTOVO"
sleep 10
