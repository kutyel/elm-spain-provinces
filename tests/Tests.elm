module Tests exposing (all)

import Expect
import List.Zipper as Zipper exposing (Zipper)
import Main exposing (GameItem, Status(..), getItemStatus)
import Test exposing (Test, describe, test)


alicante : GameItem
alicante =
    { name = "Alicante", id = 2, status = NotAsked }


madrid : GameItem
madrid =
    { name = "Madrid", id = 1, status = Correct }


valencia : GameItem
valencia =
    { name = "Valencia", id = 3, status = Failed }


all : Test
all =
    describe "getItemStatus tests"
        [ test "current item is focused -> Focused" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.singleton alicante
                in
                Expect.equal Focused (getItemStatus False 2 zipper)
        , test "item not yet asked -> NotAsked" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.singleton alicante
                in
                Expect.equal NotAsked (getItemStatus False 1 zipper)
        , test "item asked and answered correctly -> Correct" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.from [ madrid ] alicante [ valencia ]
                in
                Expect.equal Correct (getItemStatus False 1 zipper)
        , test "item asked and answered incorrectly -> Failed" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.from [ madrid, valencia ] alicante []
                in
                Expect.equal Failed (getItemStatus False 3 zipper)
        ]
