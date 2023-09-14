module Model exposing (Cached, Model, Zone, ZoneId(..), createModel, createZone, recalculateModel)


type ZoneId
    = One
    | Two
    | Three
    | Four
    | Five


type alias Zone =
    { id : ZoneId
    , minPercent : Int
    , maxPercent : Int
    , min : Int
    , max : Int
    }


createZone : ZoneId -> Int -> Int -> Int -> Zone
createZone id ftp min max =
    let
        percent : Int -> Int
        percent value =
            value
                |> toFloat
                |> (*) 0.01
                |> (*) (toFloat ftp)
                |> round
    in
    Zone id min max (percent min) (percent max)


type alias Model =
    { ftp : Int
    , showSettings : Bool
    , zone1 : Zone
    , zone2 : Zone
    , zone3 : Zone
    , zone4 : Zone
    , zone5 : Zone
    }


createModel : Int -> Bool -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Model
createModel ftp showSettings minZone1 maxZone1 minZone2 maxZone2 minZone3 maxZone3 minZone4 maxZone4 minZone5 maxZone5 =
    Model
        ftp
        showSettings
        (createZone One ftp minZone1 maxZone1)
        (createZone Two ftp minZone2 maxZone2)
        (createZone Three ftp minZone3 maxZone3)
        (createZone Four ftp minZone4 maxZone4)
        (createZone Five ftp minZone5 maxZone5)


recalculateModel : Model -> Model
recalculateModel model =
    createModel
        model.ftp
        model.showSettings
        model.zone1.minPercent
        model.zone1.maxPercent
        model.zone2.minPercent
        model.zone2.maxPercent
        model.zone3.minPercent
        model.zone3.maxPercent
        model.zone4.minPercent
        model.zone4.maxPercent
        model.zone5.minPercent
        model.zone5.maxPercent


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
