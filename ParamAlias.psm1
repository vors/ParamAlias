<#

.SYNOPSIS
Support for aliases with parameters binding. Check 'man Set-ParamAlias -Examples' for details.

.DESCRIPTION
Create functions from existing function with pre-binded parameter sets.

.EXAMPLE
Set-ParamAlias -Name l -Command ls -parametersBinding @{Recurse = '$true'; Force = '$true'}

.EXAMPLE
Set-ParamAlias -Name rmrf -Command rm -parametersBinding @{Recurse = '$true'; Force = '$true'}

.NOTES
To check source of the new function 'foo' use $function:foo

#>

function Set-ParamAlias {
    param 
    (
        [string]$Name,
        [string]$Command,
        [hashtable]$parametersBinding
    )

    function AddLine($ProxyCommand, $line) {
        $ProxyCommand -replace '(.*)(\$outBuffer = \$null)(.*)', "`$1`$2`n        $line`$3"
    }
    
    $metadata = New-Object System.Management.Automation.CommandMetaData (Get-Command $Command)
    foreach ($b in $parametersBinding.GetEnumerator())
    {
        $null = $metadata.Parameters.Remove($b.Name)
    }
    $ProxyCommand = [System.Management.Automation.ProxyCommand]::Create($metadata)
    foreach ($b in $parametersBinding.GetEnumerator())
    {
        $ProxyCommand = AddLine $ProxyCommand "`$PSBoundParameters['$($b.Name)'] = $($b.Value)"
    }

    iex "function global:$Name { $ProxyCommand }"
}

Export-ModuleMember -function Set-ParamAlias