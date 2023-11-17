<#
.SYNOPSIS
Create a new Run ID.

.DESCRIPTION
This function uses the current Datetime to create IDs.
The minimum time between calling times is 0.1ms.
Format: yyyyMMddHHmmssffff{counter} with counter is a decimal number in range [0, 9].

.INPUTS
 None. You can't pipe objects to New-RunId.

.OUTPUTS
System.long. New-RunId returns a long integer.

.EXAMPLE

#>
function New-RunId {
  [CmdletBinding()]
  [OutputType([long])]
  param()

  begin {
    # Initialize PL_NewRunId_Prev variable.
    if($null -eq $PL_NewRunId_Prev){
      [long]$global:PL_NewRunId_Prev = 0
    }
  }

  process {
    # Generate the ID
    [long] $CurrentTimeSlot = (Get-Date -Format "yyyyMMddHHmmssffff")
    [long] $PrevTimeSlot = $PL_NewRunId_Prev/10
    [long] $NewRunId = $CurrentTimeSlot * 10

    # If the call rate is too fast (<1ms). Increase the Id.
    if ($PrevTimeSlot -eq $CurrentTimeSlot) {
      $NewRunId = $PL_NewRunId_Prev + 1
    }

    $global:PL_NewRunId_Prev = $NewRunId

    # Return the new run ID.
    return $NewRunId
  }

  end {}
}