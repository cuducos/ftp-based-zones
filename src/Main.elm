module Main exposing (main)

import Browser
import Model exposing (Model, createModel)
import Update exposing (Msg, update)
import View exposing (view)


init : Int -> ( Model, Cmd Msg )
init ftp =
    ( createModel ftp False 50 55 60 65 70 75 80 85 90 95
    , Cmd.none
    )




main : Program Int Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
