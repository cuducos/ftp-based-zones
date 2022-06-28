module Model exposing (Model, Zone, createModel, createZone)


type alias Zone =
    { name : String
    , color : String
    , minPercent : Int
    , maxPercent : Int
    , min : Int
    , max : Int
    }


createZone : Int -> String -> String -> Int -> Int -> Zone
createZone ftp name color min max =
    let
        percent : Int -> Int
        percent value =
            value
                |> toFloat
                |> (*) 0.01
                |> (*) (toFloat ftp)
                |> round
    in
    Zone name color min max (percent min) (percent max)


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
        (createZone ftp "1" "grey" minZone1 maxZone1)
        (createZone ftp "2" "blue" minZone2 maxZone2)
        (createZone ftp "3" "green" minZone3 maxZone3)
        (createZone ftp "4" "yellow" minZone4 maxZone4)
        (createZone ftp "5" "red" minZone5 maxZone5)
