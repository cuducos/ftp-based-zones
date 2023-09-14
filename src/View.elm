module View exposing (view)

import Html exposing (Html, a, div, form, h1, h2, i, input, label, text)
import Html.Attributes exposing (class, href, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, Zone, ZoneId(..))
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


viewZone : Zone -> Html Msg
viewZone zone =
    div
        [ class "ui inverted segment"
        , class (zoneColor zone)
        ]
        [ h2
            []
            [ text (zoneName zone)
            , div [ class "h2" ] [ text (String.join " — " [ String.fromInt zone.min, String.fromInt zone.max ]) ]
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
                        [ style "margin-bottom" "1rem"
                        , style "cursor" "pointer"
                        , onClick ResetSettings
                        ]
                        [ i [ class "undo icon" ] []
                        , text "Reset zone settings to default values"
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
            , form [ class "ui large form" ]
                [ div [ class "ui stacked segment" ]
                    [ viewFTPSettings model.ftp
                    , div
                        [ style "margin-bottom" "1rem"
                        , style "cursor" "pointer"
                        , onClick ToggleShowSettings
                        ]
                        [ i [ class "cog icon" ] []
                        , text zoneSettingsLabel
                        ]
                    , zoneSettings
                    ]
                ]
            , viewZone model.zone1
            , viewZone model.zone2
            , viewZone model.zone3
            , viewZone model.zone4
            , viewZone model.zone5
            , div
                [ class "ui message" ]
                [ a [ href "https://github.com/cuducos/ftp-based-zones" ]
                    [ i [ class "code icon" ] []
                    , text "Source code"
                    ]
                ]
            ]
        ]
