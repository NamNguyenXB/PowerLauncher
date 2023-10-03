if($null -eq (Get-Command Get-LatestMsBuildPath -EA SilentlyContinue))
{
    function Get-LatestMsBuildPath([switch] $Use32BitMsBuild)
    {
        [string] $programFilesDirectory = Get-Item 'Env:\ProgramFiles(x86)' | Select-Object -ExpandProperty Value
        if ([string]::IsNullOrEmpty($programFilesDirectory)) {
            $programFilesDirectory = 'C:\Program Files (x86)'
        }

        [string] $visualStudioDirectoryPath = Join-Path -Path $programFilesDirectory -ChildPath 'Microsoft Visual Studio'

        [bool] $visualStudioDirectoryPathExists = (Test-Path -Path $visualStudioDirectoryPath -PathType Container)
        if (!$visualStudioDirectoryPathExists) {
            return $null
        }

        # First search for MsBuild in the expected 32 and 64 bit locations (faster).
        $expected32bitPathWithWildcards = "$visualStudioDirectoryPath\*\*\MsBuild\*\Bin\MsBuild.exe"
        $expected64bitPathWithWildcards = "$visualStudioDirectoryPath\*\*\MsBuild\*\Bin\amd64\MsBuild.exe"
        $msBuildPathObjects = Get-Item -Path $expected32bitPathWithWildcards, $expected64bitPathWithWildcards

        [bool] $msBuildWasNotFound = ($msBuildPathObjects -eq $null) -or ($msBuildPathObjects.Length -eq 0)
        if ($msBuildWasNotFound) {
            # Recurisvely search the entire Microsoft Visual Studio directory for MsBuild (slower, but will still work if MS changes folder structure).
            Write-Verbose "MsBuild.exe was not found at an expected location. Searching more locations, but this will be a little slow."
            $msBuildPathObjects = Get-ChildItem -Path $visualStudioDirectoryPath -Recurse | Where-Object { $_.Name -ieq 'MsBuild.exe' }
        }

        $msBuildPathObjectsSortedWithNewestVersionsFirst = $msBuildPathObjects | Sort-Object -Property FullName -Descending

        $newest32BitMsBuildPath = $msBuildPathObjectsSortedWithNewestVersionsFirst | Where-Object { $_.Directory.Name -ine 'amd64' } | Select-Object -ExpandProperty FullName -First 1
        $newest64BitMsBuildPath = $msBuildPathObjectsSortedWithNewestVersionsFirst | Where-Object { $_.Directory.Name -ieq 'amd64' } | Select-Object -ExpandProperty FullName -First 1

        [string] $msBuildPath = $null
        if ($Use32BitMsBuild) {
            $msBuildPath = $newest32BitMsBuildPath
        } else {
            $msBuildPath = $newest64BitMsBuildPath
        }

        [bool] $msBuildPathWasNotFound = [string]::IsNullOrEmpty($msBuildPath)
        if ($msBuildPathWasNotFound)
        {
            throw 'Could not determine where to find MsBuild.exe.'
        }

        [bool] $msBuildExistsAtThePathFound = (Test-Path $msBuildPath -PathType Leaf)
        if(!$msBuildExistsAtThePathFound)
        {
            throw "MsBuild.exe does not exist at the expected path, '$msBuildPath'."
        }

        return $msBuildPath
    }
}