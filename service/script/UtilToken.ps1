
param ($tokenfile, 
       $sectionName,
       $working_path,
       $rename)
       
Write-Output "tokenfile: $tokenfile"
Write-Output "sectionName: $sectionName"
Write-Output "working_path: $working_path"
Write-Output "rename: $rename"

function readIniFile {
  param (
    $path,
    $sectionName
  )

  $inSection = "false"
  $content = get-content $path
  $props=@{}
  foreach ($line in $content) {
    if ($line[0] -eq "#") {
    } elseif ($line[0] -eq "[") {
       $segment = $line.replace("[","").replace("]","")
       if ($segment -eq $sectionName) {
         $inSection = "true"
       } else {
         $inSection = "false"
       }
    } elseif ($inSection -eq "false") {
    } elseif ($line -like "*=*") {
      $key,$value = $line -split "=",2
      $props["$key"]= "$value"
    }
  }
  $props
}
  
function replaceToken {
  param (
    $path,
    $tokenName,
    $tokenValue
  )
  
  $tokenKey = (-join('%\[', $tokenName, '\]%'))
  (Get-Content $path) | Foreach-Object {
     $_ -replace $tokenKey, $tokenValue
  } | Out-File -Encoding "UTF8" $path
}

function replaceTokens {
  param (
    $tokenProps, 
    $path
  )
  
  $outputPath = (-join($path, ".tmp"))
  if (Test-Path -Path $outputPath) {
    Remove-Item -Path $outputPath
  }
  Copy-Item $path -Destination $outputPath  
  
  foreach ($key in $tokenProps.Keys) {
    $value = $($tokenProps[$key])
    Write-Output "replace replaceTokens: $key, $value"
    replaceToken $outputPath $key $value
  }

  Copy-Item $outputPath -Destination $path
  Remove-Item -Path $outputPath
}

function replaceTokenBlock {
  param (
    $tokenProps, 
    $path
  )
  
  $outputPath = (-join($path, ".tmp"))
  if (Test-Path -Path $outputPath) {
    Remove-Item -Path $outputPath
  }
  
  $inBlock = "false"
  $block = ""
  foreach($line in Get-Content $path) {
    if ($line -eq "%%[END]%%") {
      Write-Output $block
      foreach ($key in $tokenProps.Keys) {
        $value = $($tokenProps[$key])
        $curr = $block.replace("%[NAME]%", $key)
        $curr = $curr.replace("%[VALUE]%", $value)
        $curr | Out-File -FilePath $outputPath -Append
      }
      $inBlock = "false"
      $block = ""
    } elseif ($inBlock -eq "true") {
        if ($block -ne "") {
          $block = $block + "`r`n"
        }
        $block = $block + $line
        
    } elseif ($line -eq "%%[START]%%") {
      $inBlock = "true"
    } else {
      $line | Out-File -FilePath $outputPath -Append
    }
  }
  
  Copy-Item $outputPath -Destination $path
  Remove-Item -Path $outputPath
}

function replaceTokenFile {
  param (
    $tokenProps, 
    $path
  )
  Write-Output "Token File replace: $path"
  
  replaceTokenBlock $tokenProps $path
  replaceTokens $tokenProps $path
}


$tokenProps = (readIniFile $tokenfile $sectionName)
    
if (Test-Path -Path $working_path) {
  get-childitem $working_path -recurse | where {$_.extension -eq ".template"} | % {
    replaceTokenFile $tokenProps $_.FullName
    (Get-Content -Raw $_.FullName) -replace "`r`n","`n" | Set-Content $_.FullName -NoNewline
    if ($rename -eq "true") {
      $npath = (-join($_.DirectoryName, "\", $_.Basename))
      Move-Item -Path $_.FullName -Destination $npath -Force
    }
  } 
} else {
  Write-Output "working_path: $working_path does not exist"
}
