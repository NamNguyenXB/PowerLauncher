function Get-PixelText{
  param(
    $ColorFg,
    $ColorBg
  )

  "$([char]27)[38;2;{0};{1};{2}m$([char]27)[48;2;{3};{4};{5}m" -f $ColorFg.r, $ColorFg.g, $ColorFg.b, $ColorBg.r, $ColorBg.g, $ColorBg.b + [char]9600 + "$([char]27)[0m"
}