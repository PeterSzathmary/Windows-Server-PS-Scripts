# *.ps1 10 3 2022 Z
# *.ps1 day month year M|Z

if ($args.Length -eq 4) {
    if ($args[0] -ge 1 -and $args[0] -le 31) {
        if ($args[1] -ge 1 -and $args[1] -le 12) {
            if ($args[2] -ge 1900 -and $args[2] -le (Get-Date).Year) {
                if ($args[3] -eq 'M' -or $args[3] -eq 'Z') {
                    $day    = $args[0]
                    $month  = $args[1]
                    $year   = $args[2] % 100
                    $gender = $args[3]

                    if ($gender -eq 'Z') {
                        $month += 50
                    }

                    if ($year -lt 10) {
                        $year = "0" + $year
                    }

                    if ($month -lt 10) {
                        $month = "0" + $month
                    }

                    if ($day -lt 10) {
                        $day = "0" + $day
                    }

                    $bn = "$year" + "$month" + "$day"

                    for ($i = 0; $i -lt 9999; $i++) {
                        if (($bn + $i.ToString().PadLeft(4, '0')) % 11 -eq 0) {
                            Write-Host "$($bn + "/" + $i.ToString().PadLeft(4, '0'))`t" -NoNewline
                            # Print as many birth numbers in row as possible.
                            # Get the width of the console and divide it with the total length of the birth number + `t, which is 16 characters.
                            if ($i % [Math]::Floor([decimal]($Host.UI.RawUI.WindowSize.Width/16)) -eq 0) {
                                Write-Host
                            }
                        }
                    }
                } else {
                    Write-Host "Incorrect gender!"
                }
            } else {
                Write-Host "Incorrect year!"
            }
        } else {
            Write-Host "Incorrect month!"
        }
    } else {
        Write-Host "Incorrect day!"
    }
} else {
    Write-Host "Incorrect number of arguments!"
}