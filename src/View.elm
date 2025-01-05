module View exposing (view)

import Html exposing (Html, a, button, div, h1, h2, i, input, label, text)
import Html.Attributes exposing (checked, class, for, href, id, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, Unit(..), Zone, ZoneId(..))
import Round
import Update exposing (Msg(..), ZoneEdge(..))


zoneName : Zone -> String
zoneName zone =
    let
        number : String
        number =
            case zone.id of
                One ->
                    "1"

                Two ->
                    "2"

                Three ->
                    "3"

                Four ->
                    "4"

                Five ->
                    "5"
    in
    "Zone " ++ number


zoneColor : Zone -> String
zoneColor zone =
    case zone.id of
        One ->
            "grey"

        Two ->
            "blue"

        Three ->
            "green"

        Four ->
            "yellow"

        Five ->
            "red"


viewFTPSettings : Int -> Int -> Unit -> Html Msg
viewFTPSettings ftp weight unit =
    let
        toStr : Int -> String
        toStr n =
            if n == 0 then
                ""

            else
                String.fromInt n

        ftpLabel : String
        ftpLabel =
            toStr ftp

        weightLabel : String
        weightLabel =
            toStr weight

        isMetric : Bool
        isMetric =
            case unit of
                Metric ->
                    True

                Imperial ->
                    False

        isImperial : Bool
        isImperial =
            not isMetric
    in
    div [ class "fields" ]
        [ div [ class "eight wide field" ]
            [ label [] [ text "FTP test result" ]
            , div [ class "ui left icon input" ]
                [ i [ class "bolt icon" ] []
                , input
                    [ type_ "numeric"
                    , value ftpLabel
                    , onInput UpdateFTP
                    ]
                    []
                ]
            ]
        , div [ class "eight wide field" ]
            [ label [] [ text "Weight (zones in W/kg)" ]
            , div [ class "two fields" ]
                [ div [ class "field" ]
                    [ div [ class "ui left icon input" ]
                        [ i [ class "weight icon" ] []
                        , input
                            [ type_ "numeric"
                            , value weightLabel
                            , onInput UpdateWeight
                            ]
                            []
                        ]
                    ]
                , div [ class "inline fields" ]
                    [ div [ class "field" ]
                        [ input [ class "ui radio checkbox", id "kg", type_ "radio", checked isMetric, onClick SetMetric ] []
                        , label [ for "kg" ] [ text " kg" ]
                        ]
                    , div [ class "field" ]
                        [ input [ class "ui radio checkbox", id "lbs", type_ "radio", checked isImperial, onClick SetImperial ] []
                        , label [ for "lbs" ] [ text " lbs" ]
                        ]
                    ]
                ]
            ]
        ]


viewZoneSettings : Zone -> Html Msg
viewZoneSettings zone =
    let
        minLabel : String
        minLabel =
            "Minimum for " ++ zoneName zone

        maxLabel : String
        maxLabel =
            "Maximum for " ++ zoneName zone
    in
    div
        [ class "fields" ]
        [ div [ class "eight wide field" ]
            [ label [] [ text minLabel ]
            , div [ class "ui left icon input" ]
                [ i [ class "percent icon" ] []
                , input
                    [ type_ "numeric"
                    , zone.minPercent |> String.fromInt |> value
                    , onInput (UpdateSettings zone Min)
                    ]
                    []
                ]
            ]
        , div [ class "eight wide field" ]
            [ label [] [ text maxLabel ]
            , div [ class "ui left icon input" ]
                [ i [ class "percent icon" ] []
                , input
                    [ type_ "numeric"
                    , zone.maxPercent |> String.fromInt |> value
                    , onInput (UpdateSettings zone Max)
                    ]
                    []
                ]
            ]
        ]


wattsPerKg : Int -> Int -> Unit -> Float
wattsPerKg watts weight unit =
    let
        kg : Float
        kg =
            case unit of
                Metric ->
                    toFloat weight

                Imperial ->
                    weight |> toFloat |> (*) 0.453592
    in
    toFloat watts / kg


viewWatts : Int -> Int -> Unit -> String
viewWatts power weight unit =
    if weight == 0 then
        String.fromInt power

    else
        unit
            |> wattsPerKg power weight
            |> Round.round 1


viewZone : Zone -> Int -> Unit -> Html Msg
viewZone zone weight unit =
    div
        [ class "ui inverted segment"
        , class (zoneColor zone)
        ]
        [ h2
            []
            [ text (zoneName zone)
            , div [ class "h2" ]
                [ text
                    (String.join " — "
                        [ viewWatts zone.min weight unit
                        , viewWatts zone.max weight unit
                        ]
                    )
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    let
        zoneSettingsLabel : String
        zoneSettingsLabel =
            if model.showSettings then
                "Hide zone settings"

            else
                "Show zone settings"

        zoneSettings : Html Msg
        zoneSettings =
            if model.showSettings then
                div
                    []
                    [ viewZoneSettings model.zone1
                    , viewZoneSettings model.zone2
                    , viewZoneSettings model.zone3
                    , viewZoneSettings model.zone4
                    , viewZoneSettings model.zone5
                    , div
                        [ style "margin-top" "1rem" ]
                        [ button
                            [ class "ui compact labeled icon button"
                            , onClick ResetSettings
                            ]
                            [ i [ class "undo icon" ] []
                            , text "Reset zone settings to default values"
                            ]
                        ]
                    ]

            else
                div [] []
    in
    div
        [ class "ui middle aligned center aligned grid"
        , style "height" "100%"
        ]
        [ div
            [ class "column"
            , style "max-width" "95vw"
            ]
            [ h1 [ class "ui pink image header" ]
                [ div [ class "content" ] [ text "FTP-based Zones" ]
                ]
            , div [ class "ui large form" ]
                [ div [ class "ui stacked segment" ]
                    [ div
                        [ style "margin-bottom" "1rem"
                        , style "text-align" "right"
                        ]
                        [ button
                            [ class "ui compact labeled icon button"
                            , onClick ToggleShowSettings
                            ]
                            [ i [ class "cog icon" ] []
                            , text zoneSettingsLabel
                            ]
                        ]
                    , viewFTPSettings model.ftp model.weight model.unit
                    , zoneSettings
                    ]
                ]
            , viewZone model.zone1 model.weight model.unit
            , viewZone model.zone2 model.weight model.unit
            , viewZone model.zone3 model.weight model.unit
            , viewZone model.zone4 model.weight model.unit
            , viewZone model.zone5 model.weight model.unit
            , div
                [ class "ui message" ]
                [ a [ href "https://github.com/cuducos/ftp-based-zones" ]
                    [ i [ class "code icon" ] []
                    , text "Source code"
                    ]
                ]
            ]
        ]
