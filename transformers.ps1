[CmdletBinding()]
  Param	(
    [Parameter(Mandatory=$True , Position=0 , ValueFromPipeline = $True)]
    [String]$FileName,

    [Parameter(Mandatory=$False , Position=1 )]
    [String]$Varible = "var",

    [Parameter(Mandatory=$False , Position=2 )]
    [int]$Blocks = 8
  )

Begin {

  $AllTheThings           = @()
  $Count                  = 0

} Process {

  # > > > > > > F > A > S > T > > > > F > O > R > W > A > R > D > > > > > > > >

  Get-Content $FileName          | Foreach-object {

    $LastChar                    = $NULL

    $_.ToCharArray()             | Foreach-object {

      $CurrentChar               = $_

      If ( $CurrentChar -eq $LastChar ) {

        $TheThing.Quant          ++

      } Else {

        If ( $LastChar )         { $AllTheThings += $TheThing }
        $TheThing                = "" | Select Char, Quant
        $TheThing.Char           = [byte][char]$CurrentChar
        $TheThing.Quant          = 1

      }

      $LastChar                  = $CurrentChar

    }

    $AllTheThings               += $TheThing
    $AllTheThings               += "" | Select-Object @{ Expression={ 10 } ; Label="Char" } , @{ Expression={ 1 } ; Label="Quant" }
    $AllTheThings               += "" | Select-Object @{ Expression={ 13 } ; Label="Char" } , @{ Expression={ 1 } ; Label="Quant" }

  }

  # < < < < < < R < E < W < I < N < D < < < < < < < < < < < < < < < < < < < < <

  $senil                         = @()
  $enil                          = ""
  $senil                        += "`$$Varible = ( ``"
  $enil                         += $( " " * ( $Varible.Length + 4 + 2 )  )
  $AllTheThings                  | Foreach-object {

    If ( $count -eq $Blocks )    {

      $count                     = -1
      $enil                     += "( $($($_.Char).tostring().padleft(3,"0")) , $($($_.Quant).tostring().padleft(2,"0")) ) , ``"
      $senil                    += $enil
      $enil                      = $( " " * ( $Varible.Length + 4 + 2 )  )

    } Else {

      $enil                     += "( $($($_.Char).tostring().padleft(3,"0")) , $($($_.Quant).tostring().padleft(2,"0")) ) , "

    }

    $count                      ++

  }

  $senil                        += ( " " * ($Varible.Length + 4 + 2 ) + "( 03 , 00 ) ``" )
  $senil                        += ( " " * ($Varible.Length + 4) + ")" )
  $senil                        += "`$$Varible | % `{ Write-Host (`"`$([char]`$_[0])`" * [char]`$_[1]) -NoNewLine `} `; Write-Host `"`" "
  $AllTheThings | ? { $($_.Char) -ne 10 } |  Select-Object -Unique @{ Expression={ $_.Char } ; Label="Code" }  , @{ Expression={ [char]$_.Char } ; Label="Character" } | Foreach-Object {

    $senil                      += "# Code : $($($_.Code).tostring().padleft(3," "))  | Character: $($_.Character)"

  }

  # ! ! ! ! ! ! P ! R ! E ! S ! S ! ! ! P ! L ! A ! Y ! ! ! ! ! ! ! ! ! ! ! ! !

  $emanelif                      = "$( $env:temp )\$( [guid]::NewGuid() ).ps1"
  $senil                         | Out-File $emanelif    -Encoding ascii
  Invoke-Expression              $emanelif
  Get-Content                    $emanelif
  Remove-Item                    $emanelif | out-null

} End {

  Write-Host
  Write-Host
  Write-Host
  Write-Host   "You Can pipe this output to the clipboard with"   -NoNewLine
  Write-Host   " | clip.exe "                                     -NoNewLine -ForegroundColor Yellow
  Write-Host   " Or to a file with"                               -NoNewLine
  Write-Host   " | Out-File c:\temp\testtrans.txt "               -NoNewLine -ForegroundColor Yellow
  Write-Host
  Write-Host

}
