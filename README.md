ParamAlias
==========

Aliases with param binding in powershell.

Create functions from existing function with pre-binded parameter sets.
To check source of the new function `foo` use `$function:foo`

##.Examples

Create alias `l` for `ls -Recurse -Force`

    Set-ParamAlias -Name l -Command ls -parametersBinding @{Recurse = '$true'; Force = '$true'}`

Create alias `rmrf` for `rm -Recurse -Force`

    Set-ParamAlias -Name rmrf -Command rm -parametersBinding @{Recurse = '$true'; Force = '$true'}


## .References
Inspired by [Jeffery Hicks' post](http://jdhitsolutions.com/blog/2014/09/making-the-shell-work-for-you-revisited/).
