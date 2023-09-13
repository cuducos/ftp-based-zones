module Main exposing (main)

import Browser
import Model exposing (Model, createModel)
import Update exposing (Msg, update)
import View exposing (view)


type alias Cached =
    { ftp : Int
    , zone1Min : Int
    , zone1Max : Int
    , zone2Min : Int
    , zone2Max : Int
    , zone3Min : Int
    , zone3Max : Int
    , zone4Min : Int
    , zone4Max : Int
    , zone5Min : Int
    , zone5Max : Int
    }


init : Cached -> ( Model, Cmd Msg )
init cached =
    ( createModel cached.ftp False 
   cached.zone1Min
   cached.zone1Max
   cached.zone2Min
   cached.zone2Max
   cached.zone3Min
   cached.zone3Max
   cached.zone4Min
   cached.zone4Max
   cached.zone5Min
   cached.zone5Max
    , Cmd.none
    )


main : Program Cached Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
