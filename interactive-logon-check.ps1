$usernamesFile = "PATH TO TEXT FILE WITH ONE USER ACCOUNT PER LINE DOMAIN\USERNAME FORMAT"
$outputFile = "PATH TO Output.txt"
$usernames = Get-Content $usernamesFile
$output = @()

foreach ($username in $usernames) {
    $user = Get-ADUser -Identity $username -Properties UserAccountControl
    if ($user) {
        $flags = [System.Convert]::ToInt32($user.UserAccountControl, 10)
        if (($flags -band 0x10000) -eq 0) {
            $result = "Interactive logon is enabled for user: $username"
        } else {
            $result = "Interactive logon is disabled for user: $username"
        }
    } else {
        $result = "User not found: $username"
    }
    # Add the result to the output array
    $output += $result
}

$output | Out-File -FilePath $outputFile
