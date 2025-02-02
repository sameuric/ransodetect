<#
    PowerShell RansoDetect 1.0
    --------------------------------------

    PowerShell script that aims to detect if user's files are being encrypted by a ransomware.
    Script written for learning purposes only. Use with precaution.

    Made with: PowerShell ISE 5.1.19041.5369
    © 2025 Sacha Meurice
#>

param([string] $param)


$taskName = "RansoDetectTask"
$fakeFile = "$HOME\document.txt"
$fakeContent = "DO NOT EDIT, DELETE OR RENAME THIS FILE!"



# First execution:
# Install the fake document file and a scheduled task to monitor it.

if ($param -eq "") {

    # The fake document file should remain unchanged.
    # Otherwise, a ransomware might be currently running.

    try {
        New-Item -Path $fakeFile -Type file -Value $fakeContent -force
    }
    catch {
        Write-Host "Operation aborted: Could not create $fakeFile (missing permissions?)"
        Break
    }



    # Create a scheduled task that recalls this script every 3 minutes

    $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -eq $taskName}
    if ($taskExists) {
        Write-Host "Task $taskName already installed. Updating task..."
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }

    $taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 3)
    $taskAction = New-ScheduledTaskAction -Execute "Powershell" -Argument "-ExecutionPolicy bypass -WindowStyle Hidden -File $PSCommandPath 1"
    Register-ScheduledTask $taskName -Action $taskAction -Trigger $taskTrigger

    Write-Host "RansoDetect successfully installed!"
    Break
}






# Execution from scheduled task (param = 1).
# Check whether the fake document file has been edited or renamed.
#
# If so, launch a new visible powershell window to alert the user.

if ($param -eq "1") {

    $fileExist = Test-Path -Path $fakeFile -PathType Leaf

    if (!$fileExist -or (Get-Item $fakeFile).Length -ne ($fakeContent).Length) {
        Invoke-Expression "PowerShell -ExecutionPolicy bypass -WindowStyle Normal -NoExit -File $PSCommandPath 2"
    }

    Break
}






# If the fake file has been edited or renamed...

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
$host.ui.RawUI.ForegroundColor = "Red"

Write-Host "ALERT: Potential ransomware running on this machine"
Write-Host "PLEASE INFORM THE CYBERSECURITY TEAM OF THIS ALERT"



# Try to alert the user by emitting a sound (asynchronously).

Start-Job -ScriptBlock {
    for ($i = 0; $i -lt 10; $i++) {
        Start-Sleep -Milliseconds 100
        [console]::beep(700, 500)
    }
} | out-null


# Send an email to alert the cybersecurity team.

$localhost = hostname

$email = @{
    From = 'POWERSHELL <powershell@example.local>'
    To = 'IT Team <alerts@example.local>'
    Subject = "NOTICE: Potential ransomware attack on $localhost"
    Body = "Security code: EA6D71F3BC"
}

for ($attempt = 0; $attempt -lt 5; $attempt++) {

    try {
        Send-MailMessage @email
        Write-Host "Successfully sent an email to the cybersecurity team."
        break
    }
    catch {
        Write-Host "NOTICE: Could not send an email to the cybersecurity team."
    }

    Start-Sleep -Milliseconds 3000
}
