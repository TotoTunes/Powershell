. $PSScriptRoot/Add-Numbers.ps1

Describe -Tags "Example" "Add-Numbers" {

    It "adds positive numbers" {
        Add-Numbers 2 3 | Should -Be 5
    }

    It "adds negative numbers" {
        Add-Numbers (-2) (-2) | Should -Be (-4)
    }

    It "adds one negative number to positive number" {
        Add-Numbers (-2) 2 | Should -Be 0
    }

    It "concatenates strings if given strings" {
        Add-Numbers two three | Should -Be "twothree"
    }

    It "does not return 0 when adding two non-zero numbers" {
        Add-Numbers 2 3 | Should -Not -Be 0
    }
}