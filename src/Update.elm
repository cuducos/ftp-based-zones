port module Update exposing (Msg(..), ZoneEdge(..), update)

import Model exposing (Model, Zone, ZoneId(..), createZone, recalculateModel)


port cacheFTP : Int -> Cmd msg


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


updateZone : Zone -> Int -> ZoneEdge -> String -> Zone
updateZone zone ftp edge threshold =
    case edge of
        Max ->
            threshold
                |> toInt zone.maxPercent
                |> createZone zone.id ftp zone.name zone.color zone.minPercent

        Min ->
            createZone zone.id ftp zone.name zone.color (toInt zone.minPercent threshold) zone.maxPercent


updateSettings : Model -> Zone -> ZoneEdge -> String -> Model
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
            in
            ( recalculateModel { model | ftp = newFTP }, cacheFTP newFTP )

        UpdateSettings zone edge value ->
            ( recalculateModel (updateSettings model zone edge value), Cmd.none )
