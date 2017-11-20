I decided to trim back everything to just the Shapes EDSL so it would be nice and clean! :)

I first export all the data constructors so we can pattern match for them.

> module Shapes(
>   Shape(..), Vector(..), Transform(..), Style(..), Drawing) where

> -- Utilities
> data Vector = Vector Double Double
>               deriving (Show, Read)

I didn't need the matrix, as I was using another matrix module instead.

I also made everything also derive read so we could parse string input.

> -- Shapes
> data Shape = Empty
>            | Circle
>            | Square
>              deriving (Show, Read)

> -- Transformations
> data Transform = Identity
>            | Translate Vector
>            | Scale Vector
>            | Compose Transform Transform
>            | Rotate Double
>              deriving (Show, Read)

Here I added in my two new styles. I didn't think these we're in the same category as transformations
so I made their own data type and changed the type of Drawing.

There is also a default style if you don't want to add one.

> data Style = Stroke Double
>            | Fill String
>            | StrokeFill Double String
>            | Default
>              deriving (Show, Read)

Here we include styles in drawing.

> -- Drawings
> type Drawing = [(Transform,Style,Shape)]
