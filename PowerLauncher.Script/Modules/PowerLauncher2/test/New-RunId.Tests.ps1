# BeforeAll{
#   Import-Module $PSScriptRoot\..\PowerLauncher2 -Force
# }

# Describe "New-RunId" {
#   Context "When calling New-RunId" {
#       It "Should return a long value" {
#           $result = New-RunId
#           $result | Should -BeOfType [long]
#       }

#       It "Should return a unique Run ID" {
#           $result1 = New-RunId
#           $result2 = New-RunId

#           $result1 | Should -Not -Be $result2
#       }

#       It "Should handle fast calls by increasing the ID" {
#           # Mock Get-Date to return the same timestamp for two consecutive calls
#           Mock Get-Date { [datetime]'2022-01-01T00:00:00' }

#           $result1 = New-RunId
#           $result2 = New-RunId

#           $result1 | Should -Not -Be $result2
#       }
#   }
# }
