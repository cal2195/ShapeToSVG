Here's where most of the work is done.

> {-# LANGUAGE OverloadedStrings #-}
> module BlzSvg where
> import qualified Text.Blaze.Svg11 as S
> import qualified Text.Blaze.Svg11.Attributes as A
> import Text.Blaze.Svg.Renderer.String (renderSvg)
> import Data.Matrix
> import Shapes

An example Circle with the default style.

> ball = [(Translate (Vector 500 50), Default, Circle)]

An example function to just print out the svg to stdout.

> runExample = do
>   let a = renderSvg (convertToSvg ball)
>   putStrLn a

Here we take in a Drawing parsed from a string by Read, and we convert it to the svg string.

> generateSvg :: Drawing -> String
> generateSvg drawing = renderSvg (convertToSvg drawing)

First off, we must add the svg header, and then parse each shape we're given.

> convertToSvg :: Drawing -> S.Svg
> convertToSvg drawing = S.docTypeSvg S.! A.version "1.1" S.! A.width "1000" S.! A.height "1000" $
>     stringShapes (convertShapes drawing)

Here we sequence each shape to be converted. I'm sure there's a prelude function for this,
but everything I tried didn't work so I made my own! :)

> stringShapes (x:[]) = x
> stringShapes (x:xs) = x >> stringShapes xs

Now we convert each shape to an svg.

> convertShapes :: Drawing -> [S.Svg]
> convertShapes x = map convertShape x

This function converts an individual shape to an svg.

> convertShape :: (Transform, Style, Shape) -> S.Svg
> convertShape (trans, style, Square) = S.rect S.! A.width "100" S.! A.height "100" S.! A.stroke "black" S.! (getStroke style) S.! (getFill style) S.! convertMatToAttr (convertTransToMat trans)
> convertShape (trans, style, Circle) = S.circle S.! A.cx "0" S.! A.cy "0" S.! A.r "50" S.! A.stroke "black" S.! (getStroke style) S.! (getFill style) S.! convertMatToAttr (convertTransToMat trans)

These two functions get the Stroke size and Fill color, or uses the default.

> getStroke :: Style -> S.Attribute
> getStroke (Stroke size) = A.strokeWidth (S.toValue size)
> getStroke (StrokeFill size _) = A.strokeWidth (S.toValue size)
> getStroke _ = A.strokeWidth "2"

> getFill :: Style -> S.Attribute
> getFill (Fill color) = A.fill (S.toValue color)
> getFill (StrokeFill _ color) = A.fill (S.toValue color)
> getFill _ = A.fill "#666666"

This function converts the transformations into a matrix, so that we can apply them all at once.

> convertTransToMat :: Transform -> Data.Matrix.Matrix Double
> convertTransToMat Identity = Data.Matrix.fromList 3 3 [1,0,0,0,1,0,0,0,1]
> convertTransToMat (Translate (Vector tx ty))  = Data.Matrix.fromList 3 3 [1,0,tx,0,1,ty,0,0,1]
> convertTransToMat (Scale (Vector sx sy)) = Data.Matrix.fromList 3 3 [sx,0.0,0.0,0.0,sy,0.0,0.0,0.0,1.0]
> convertTransToMat (Rotate a) = Data.Matrix.fromList 3 3 [cos(a),-sin(a),0,sin(a),cos(a),0,0,0,1]
> convertTransToMat (Compose trans1 trans2) = Data.Matrix.multStd (convertTransToMat trans1) (convertTransToMat trans2)

And finally, this function converts our matrix into the svg syntax for a matrix transformation.

> convertMatToAttr :: Data.Matrix.Matrix Double -> S.Attribute
> convertMatToAttr mat = A.transform (S.toValue ("matrix(" ++ (show (getElem 1 1 mat)) ++ "," ++ (show (getElem 2 1 mat)) ++ "," ++ (show (getElem 1 2 mat)) ++ "," ++ (show (getElem 2 2 mat)) ++ "," ++ (show (getElem 1 3 mat)) ++ "," ++ (show (getElem 2 3 mat)) ++ ")"))
