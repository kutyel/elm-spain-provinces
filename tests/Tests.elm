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


galicia : GameItem
galicia =
    -- Galicia's provinces ids are: 1, 31, 36, 38
    { name = "Galicia", id = 10, status = NotAsked }


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
        , test "community mode: current item is focused -> Focused" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.singleton galicia
                in
                Expect.equal Focused (getItemStatus True 1 zipper)
        , test "community mode: current item is not part of the CCAA -> NotAsked" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.singleton galicia
                in
                -- Province id 2 is Álava
                Expect.equal NotAsked (getItemStatus True 2 zipper)
        , test "community mode: item asked and answered correctly -> Correct" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.from
                            [ { galicia | status = Correct } ]
                            { name = "La Rioja", id = 12, status = NotAsked }
                            []
                in
                Expect.equal Correct (getItemStatus True 1 zipper)
        , test "community mode: item asked and answered incorrectly -> Failed" <|
            \_ ->
                let
                    zipper : Zipper GameItem
                    zipper =
                        Zipper.from
                            [ { galicia | status = Failed } ]
                            { name = "La Rioja", id = 12, status = NotAsked }
                            []
                in
                Expect.equal Failed (getItemStatus True 1 zipper)
        ]
