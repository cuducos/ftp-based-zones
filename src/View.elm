module View exposing (view)

import Html exposing (Html, a, button, div, h1, h2, i, input, label, text)
import Html.Attributes exposing (attribute, checked, class, for, href, id, style, type_, value)
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


viewFTPSettings : Int -> Html Msg
viewFTPSettings ftp =
    let
        ftpLabel : String
        ftpLabel =
            if ftp == 0 then
                ""

            else
                String.fromInt ftp
    in
    div [ class "field" ]
        [ label [] [ text "FTP test result" ]
        , div [ class "ui fluid action left icon input" ]
            [ i [ class "bolt icon" ] []
            , input
                [ type_ "numeric"
                , value ftpLabel
                , onInput UpdateFTP
                ]
                []
            , button
                [ class "ui icon button"
                , onClick ToggleShowSettings
                , attribute "aria-label" "Settings"
                ]
                [ i [ class "cog icon" ] [] ]
            ]
        ]


viewWeightSetting : Int -> Unit -> Bool -> Html Msg
viewWeightSetting weight unit perKg =
    let
        weightLabel : String
        weightLabel =
            if weight == 0 then
                ""

            else
                String.fromInt weight

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
    div [ class "field" ]
        [ label [] [ text "Weight" ]
        , div [ class "ui stackable grid" ]
            [ div [ class "three column row" ]
                [ div [ class "column" ]
                    [ div [ class "ui fluid left icon input" ]
                        [ i [ class "weight icon" ] []
                        , input
                            [ type_ "numeric"
                            , value weightLabel
                            , onInput UpdateWeight
                            ]
                            []
                        ]
                    ]
                , div [ class "column" ]
                    [ div
                        [ style "display" "flex"
                        , style "align-items" "center"
                        , style "gap" "0.5em"
                        ]
                        [ input [ class "ui radio checkbox", id "kg", type_ "radio", checked isMetric, onClick SetMetric ] []
                        , label [ for "kg", style "margin" "0" ] [ text "kg" ]
                        , input [ class "ui radio checkbox", id "lbs", type_ "radio", checked isImperial, onClick SetImperial ] []
                        , label [ for "lbs", style "margin" "0" ] [ text "lbs" ]
                        ]
                    ]
                , div [ class "column" ]
                    [ div
                        [ style "display" "flex"
                        , style "align-items" "center"
                        , style "gap" "0.3em"
                        ]
                        [ input
                            [ type_ "checkbox"
                            , checked perKg
                            , onClick ToggleZoneInWPerKg
                            , id "perKg"
                            ]
                            []
                        , label [ for "perKg", style "margin" "0" ] [ text "Show zones in W/kg" ]
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
    div [ class "ui stackable two column grid" ]
        [ div [ class "column" ]
            [ div [ class "field" ]
                [ label [] [ text minLabel ]
                , div [ class "ui fluid left icon input" ]
                    [ i [ class "percent icon" ] []
                    , input
                        [ type_ "numeric"
                        , zone.minPercent |> String.fromInt |> value
                        , onInput (UpdateSettings zone Min)
                        ]
                        []
                    ]
                ]
            ]
        , div [ class "column" ]
            [ div [ class "field" ]
                [ label [] [ text maxLabel ]
                , div [ class "ui fluid left icon input" ]
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


viewWatts : Int -> Int -> Unit -> Bool -> String
viewWatts power weight unit perKg =
    if perKg then
        if weight == 0 then
            "0"

        else
            unit
                |> wattsPerKg power weight
                |> Round.round 1

    else
        String.fromInt power


viewZone : Zone -> Int -> Unit -> Bool -> Html Msg
viewZone zone weight unit perKg =
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
                        [ viewWatts zone.min weight unit perKg
                        , viewWatts zone.max weight unit perKg
                        ]
                    )
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    let
        zoneCards : Html Msg
        zoneCards =
            if model.showSettings then
                div [] []

            else
                div []
                    [ viewZone model.zone1 model.weight model.unit model.perKg
                    , viewZone model.zone2 model.weight model.unit model.perKg
                    , viewZone model.zone3 model.weight model.unit model.perKg
                    , viewZone model.zone4 model.weight model.unit model.perKg
                    , viewZone model.zone5 model.weight model.unit model.perKg
                    ]
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
                    [ viewFTPSettings model.ftp
                    , viewSettings model
                    ]
                ]
            , zoneCards
            , div
                [ class "ui message" ]
                [ a [ href "https://github.com/cuducos/ftp-based-zones" ]
                    [ i [ class "code icon" ] []
                    , text "Source code"
                    ]
                ]
            ]
        ]


viewSettings : Model -> Html Msg
viewSettings model =
    if model.showSettings then
        div []
            [ viewWeightSetting model.weight model.unit model.perKg
            , if model.weightWarning then
                div [ class "ui visible warning message" ]
                    [ text "Enter your weight to enable Show zones in W/kg." ]

              else
                div [] []
            , viewZoneSettings model.zone1
            , viewZoneSettings model.zone2
            , viewZoneSettings model.zone3
            , viewZoneSettings model.zone4
            , viewZoneSettings model.zone5
            , div
                [ style "margin-top" "1rem" ]
                [ button
                    [ class "ui fluid labeled icon button"
                    , onClick ResetSettings
                    ]
                    [ i [ class "undo icon" ] []
                    , text "Reset zone settings to default values"
                    ]
                ]
            ]

    else
        div [] []
