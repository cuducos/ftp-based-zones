port module Update exposing (Msg(..), ZoneEdge(..), loadAppData, update)

import Model exposing (Cached, Model, Zone, ZoneId(..), createModel, createZone, recalculateModel)


type alias Cache =
    { key : String
    , value : Int
    }


cacheKey : Zone -> ZoneEdge -> String
cacheKey zone edge =
    let
        suffix : String
        suffix =
            case edge of
                Min ->
                    "Min"

                Max ->
                    "Max"
    in
    case zone.id of
        One ->
            "zone1" ++ suffix

        Two ->
            "zone2" ++ suffix

        Three ->
            "zone3" ++ suffix

        Four ->
            "zone4" ++ suffix

        Five ->
            "zone5" ++ suffix


port setCache : Cache -> Cmd msg


port resetSettings : () -> Cmd msg


port loadAppData : (Cached -> msg) -> Sub msg


toInt : Int -> String -> Int
toInt default value =
    if value == "" then
        0

    else
        value
            |> String.toInt
            |> Maybe.withDefault default


type ZoneEdge
    = Min
    | Max


updateZone : Zone -> Int -> ZoneEdge -> Int -> Zone
updateZone zone ftp edge value =
    case edge of
        Max ->
            createZone zone.id ftp zone.name zone.color zone.minPercent value

        Min ->
            createZone zone.id ftp zone.name zone.color value zone.maxPercent


updateSettings : Model -> Zone -> ZoneEdge -> Int -> Model
updateSettings model zone edge value =
    case zone.id of
        One ->
            { model | zone1 = updateZone model.zone1 model.ftp edge value }

        Two ->
            { model | zone2 = updateZone model.zone2 model.ftp edge value }

        Three ->
            { model | zone3 = updateZone model.zone3 model.ftp edge value }

        Four ->
            { model | zone4 = updateZone model.zone4 model.ftp edge value }

        Five ->
            { model | zone5 = updateZone model.zone5 model.ftp edge value }


type Msg
    = ToggleShowSettings
    | UpdateFTP String
    | UpdateSettings Zone ZoneEdge String
    | LoadAppData Cached
    | ResetSettings


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleShowSettings ->
            ( { model | showSettings = not model.showSettings }, Cmd.none )

        UpdateFTP value ->
            let
                newFTP : Int
                newFTP =
                    toInt model.ftp value

                cache : Cache
                cache =
                    Cache "ftp" newFTP
            in
            ( recalculateModel { model | ftp = newFTP }, setCache cache )

        UpdateSettings zone edge value ->
            let
                newValue : Int
                newValue =
                    case edge of
                        Min ->
                            toInt zone.min value

                        Max ->
                            toInt zone.max value

                cache : Cache
                cache =
                    Cache (cacheKey zone edge) newValue
            in
            ( recalculateModel (updateSettings model zone edge newValue), setCache cache )

        LoadAppData cached ->
            ( createModel
                model.ftp
                model.showSettings
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

        ResetSettings ->
            ( model, resetSettings () )
