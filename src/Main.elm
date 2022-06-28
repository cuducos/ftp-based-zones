module Main exposing (main)

import Browser
import Model exposing (Model, createModel)
import Update exposing (Msg, update)
import View exposing (view)


init : Model
init =
    createModel 185 False 50 55 60 65 70 75 80 85 90 95


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
