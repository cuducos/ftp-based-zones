module Update exposing (Msg(..), update)

import Model exposing (Model, Zone, createModel, createZone)


toInt : Int -> String -> Int
toInt default value =
    if value == "" then
        0

    else
        value
            |> String.toInt
            |> Maybe.withDefault default


type UpdateZoneMsg
    = Min Int Zone String
    | Max Int Zone String


updateZone : UpdateZoneMsg -> Zone
updateZone msg =
    case msg of
        Max ftp zone value ->
            value
                |> toInt zone.maxPercent
                |> createZone ftp zone.name zone.color zone.minPercent

        Min ftp zone value ->
            createZone ftp zone.name zone.color (toInt zone.minPercent value) zone.maxPercent


updateZoneMin : Int -> Zone -> String -> Zone
updateZoneMin ftp zone value =
    updateZone (Min ftp zone value)


updateZoneMax : Int -> Zone -> String -> Zone
updateZoneMax ftp zone value =
    updateZone (Max ftp zone value)


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


type Msg
    = ToggleShowSettings
    | UpdateFTP String
    | UpdateZone1Min String
    | UpdateZone1Max String
    | UpdateZone2Min String
    | UpdateZone2Max String
    | UpdateZone3Min String
    | UpdateZone3Max String
    | UpdateZone4Min String
    | UpdateZone4Max String
    | UpdateZone5Min String
    | UpdateZone5Max String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleShowSettings ->
            { model | showSettings = not model.showSettings }

        UpdateFTP value ->
            recalculateModel { model | ftp = toInt model.ftp value }

        UpdateZone1Min value ->
            { model | zone1 = updateZoneMin model.ftp model.zone1 value }

        UpdateZone1Max value ->
            { model | zone1 = updateZoneMax model.ftp model.zone1 value }

        UpdateZone2Min value ->
            { model | zone2 = updateZoneMin model.ftp model.zone2 value }

        UpdateZone2Max value ->
            { model | zone2 = updateZoneMax model.ftp model.zone2 value }

        UpdateZone3Min value ->
            { model | zone3 = updateZoneMin model.ftp model.zone3 value }

        UpdateZone3Max value ->
            { model | zone3 = updateZoneMax model.ftp model.zone3 value }

        UpdateZone4Min value ->
            { model | zone4 = updateZoneMin model.ftp model.zone4 value }

        UpdateZone4Max value ->
            { model | zone4 = updateZoneMax model.ftp model.zone4 value }

        UpdateZone5Min value ->
            { model | zone5 = updateZoneMin model.ftp model.zone5 value }

        UpdateZone5Max value ->
            { model | zone5 = updateZoneMax model.ftp model.zone5 value }
