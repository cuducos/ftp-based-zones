module Model exposing (Model, Zone, ZoneId(..), createModel, createZone, recalculateModel)


type ZoneId
    = One
    | Two
    | Three
    | Four
    | Five


type alias Zone =
    { name : String
    , color : String
    , minPercent : Int
    , maxPercent : Int
    , min : Int
    , max : Int
    , id : ZoneId
    }


createZone : ZoneId -> Int -> String -> String -> Int -> Int -> Zone
createZone id ftp name color min max =
    let
        percent : Int -> Int
        percent value =
            value
                |> toFloat
                |> (*) 0.01
                |> (*) (toFloat ftp)
                |> round
    in
    Zone name color min max (percent min) (percent max) id


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
        (createZone One ftp "1" "grey" minZone1 maxZone1)
        (createZone Two ftp "2" "blue" minZone2 maxZone2)
        (createZone Three ftp "3" "green" minZone3 maxZone3)
        (createZone Four ftp "4" "yellow" minZone4 maxZone4)
        (createZone Five ftp "5" "red" minZone5 maxZone5)


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
