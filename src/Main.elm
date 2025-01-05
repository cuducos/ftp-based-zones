module Main exposing (main)

import Browser
import Model exposing (Cached, Model, Unit(..), createModel)
import Update exposing (Msg(..), loadAppData, update)
import View exposing (view)


init : Cached -> ( Model, Cmd Msg )
init cached =
    let
        unit : Unit
        unit =
            if cached.isMetric == 1 then

                Metric
            else
                Imperial
    in
    ( createModel
        cached.ftp
        cached.weight
        unit
        False
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    loadAppData LoadAppData


main : Program Cached Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
