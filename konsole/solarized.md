# Konsole Dark Color Profile for Consistent Vim Colors
Usual color profiles primarily set the background and foreground colors
to a dark/light variant, and keep the colors 0 - 8 essentially unchanged.
This works well for most programs.
However, solarized vim profiles explicitly use the black (color0) and white (color7)
as foreground/background. Hence, changing the solarized light/dark terminal profile
does not have any impact on the way vim looks like.

This profile fixes this issue in a very hacky way: We start with the solarized light theme,
use the solarized dark foreground/background, and swap a few colors (see below).
Now, black (color0) leads to the solarized white color, and so on.

Using this profile together with the standard light solarized theme,
one can always use the solarized colorscheme with `background=light` in vim,
and changing between the two terminal profiles will lead to consistent dark/light
themes also in vim.

Note that this only works as long as the vim profile only uses colors 0 - 15, and
not 256 colors.

This does *not* give a color-perfect emulation of solarized dark vim, but is good enough for me
and satisfies my main requirement that the terminal should define color profiles,
and all apps should use symbolic color names from the profile instead of hardcoded rgb values.

## Notes on implementation

Needed swaps:
 - These two swap black and white (std and bright):
    0  7
    8 15
 - These two I do not fully understand...
   11 12
   10 14

To find out, use `solarized` colorscheme in vim, toggle `set bg=light` / `set bg=dark`,
and dump colors with `hi!`.

Std light colors:
0  #073642                    8   #002b36
1  #dc322f                    9   #cb4b16
2  #859900                    10  #586e75
3  #b58900                    11  #657b83
4  #268bd2                    12  #839496
5  #d33682                    13  #6c71c4
6  #2aa198                    14  #93a1a1
7  #2aa198                    15  #fdf6e3
