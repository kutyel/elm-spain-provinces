module Tests exposing (all)

import Expect
import List.Zipper as Zipper exposing (Zipper)
import Main exposing (Province, Status(..), getProvinceStatus)
import Test exposing (Test, describe, test)


alicante : Province
alicante =
    { name = "Alicante", id = 2, status = NotAsked }


madrid : Province
madrid =
    { name = "Madrid", id = 1, status = Correct }


valencia : Province
valencia =
    { name = "Valencia", id = 3, status = Failed }


all : Test
all =
    describe "getProvinceStatus tests"
        [ test "current province is focused -> Focused" <|
            \_ ->
                let
                    zipper : Zipper Province
                    zipper =
                        Zipper.singleton alicante
                in
                Expect.equal Focused (getProvinceStatus 2 zipper)
        , test "province not yet asked -> NotAsked" <|
            \_ ->
                let
                    zipper : Zipper Province
                    zipper =
                        Zipper.singleton alicante
                in
                Expect.equal NotAsked (getProvinceStatus 1 zipper)
        , test "province asked and answered correctly -> Correct" <|
            \_ ->
                let
                    zipper : Zipper Province
                    zipper =
                        Zipper.from [ madrid ] alicante [ valencia ]
                in
                Expect.equal Correct (getProvinceStatus 1 zipper)
        , test "province asked and answered incorrectly -> Failed" <|
            \_ ->
                let
                    zipper : Zipper Province
                    zipper =
                        Zipper.from [ madrid, valencia ] alicante []
                in
                Expect.equal Failed (getProvinceStatus 3 zipper)
        ]
