Key:
 - `.` Empty Space
 - `0` Valid Target
 - `X` Forced Target
 - `o` Enemy
 - `=` Player
 - `-` Chained enemies (all together in line)
 - `|` Chained enemies (all together in line)

# Single

## Any
Any one target on board
```
.00
..0
000
...
..0
```

## In-Lane
Any single target in line with heroes
```
= | .00
. | ..o
= | 000
. | ...
. | ..o
```

## Front
Any single target at the front of its line
```
= | .0o
. | ..0
= | 0oo
. | ...
. | ..0
```

## In-Lane Front
Any single targetet in the front of hero-occupied lanes
```
= | .0o
. | ..o
= | 0oo
. | ...
. | ..o
```

# Lane

## Any
Any single entire lane
```
.--
..-
---
...
..-
```

## In-Lane
And whole hero-occupied lane
```
= | .--
. | ..o
= | ---
. | ...
. | ..o
```

## Front
And whole lane with the furthest forward enemy.
On tie, player choice
```
= | .oo
. | ..o
= | XXX
. | ...
. | ..o
```

## In-Lane Front
And whole hero-occupied lane with the furthest forward enemy.
On tie, player choice
```
= | .XX
. | ..o
= | ..o
. | ooo
. | ..o
```

# Column

## Any
Any single entire column
```
..|
.||
|||
..|
...
```

## In-Lane
Any column accessible from any hero-occupied lane
```
. | ..|
. | ..|
. | o||
= | .||
= | ...
```
Forward column is not an option since the hero-occupied lanes do not have enemies spanning the forward column


## Front
All columns spanned by the furthest-forward enemies in each lane
```
= | .Xo
. | .Xo
= | XXo
. | .Xo
. | ...
```

## In-Lane Front
All columns spanned by the furthest forward enemies in hero-occupied lanes
```
= | .Xo
. | .Xo
= | .Xo
. | oXo
. | ..o
```

# All

## ~Any~
All enemies
```
..X
.XX
XXX
..X
...
```

## In-Lane
All enemies in hero-occupied lanes
```
. | ..o
. | ..o
. | ooo
= | .XX
= | ...
```


## Front
All front-most enemies
```
= | .Xo
. | .Xo
= | Xoo
. | .Xo
. | ..X
```

## In-Lane Front
All front-most enemies in hero-spanned lanes
```
= | .Xo
. | .oo
= | .Xo
. | ooo
. | ..o
```