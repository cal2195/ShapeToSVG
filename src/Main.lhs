Cal Martin - 14310822

Using OverloadedStrings so I don't have to pack everything!

> {-# LANGUAGE OverloadedStrings #-}
> module Main where
> import BlzSvg
> import Web.Scotty
> import Data.Text.Lazy
> import Shapes

The index page redirects to an example shape DSL.

> main = scotty 3000 $ do
>     get "/" $ do
>         redirect "/drawing.svg?info=[(Compose (Translate (Vector 20 20)) (Scale (Vector 5 5)), StrokeFill 5 \"purple\", Square),(Translate (Vector 500 200), (Fill \"cyan\"), Circle),(Compose (Translate (Vector 200 200)) (Rotate 1), Fill \"red\", Square),(Compose (Scale (Vector 2 2)) (Translate (Vector 350 150)), StrokeFill 5 \"yellow\", Circle)]"

The drawing page does the actually svg drawing, and also shows an input box for quick editing.

>     get "/drawing.svg" $ do

We grab the given shape language from the info parameter.

>         info <- param "info"

And turn in into an svg.

>         html $ pack ("<form action='/drawing.svg' method='get'><input type='text' name='info' value='" ++ info ++ "' style='width:100%'><br/><input type='submit' value='Submit'></form><br/>" ++ (generateSvg (read info)))

