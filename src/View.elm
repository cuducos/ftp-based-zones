module View exposing (view)

import Html exposing (Html, a, div, form, h1, h2, i, input, label, text)
import Html.Attributes exposing (class, href, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, Zone)
import Update exposing (Msg(..))


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


viewZoneSettings : Zone -> (String -> Msg) -> (String -> Msg) -> Html Msg
viewZoneSettings zone minMsg maxMsg =
    let
        title : String
        title =
            "Zone " ++ zone.name

        minLabel : String
        minLabel =
            "Minimum for Zone " ++ zone.name

        maxLabel : String
        maxLabel =
            "Maximum for Zone " ++ zone.name
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
                    , onInput minMsg
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
                    , onInput maxMsg
                    ]
                    []
                ]
            ]
        ]


viewZone : Zone -> Html Msg
viewZone zone =
    div
        [ class "ui inverted segment"
        , class zone.color
        ]
        [ h2
            []
            [ text ("Zone " ++ zone.name)
            , div [ class "h2" ] [ text (String.join " — " [ String.fromInt zone.min, String.fromInt zone.max ]) ]
            ]
        ]


view : Model -> Html Msg
view model =
    let
        zoneSettings : Html Msg
        zoneSettings =
            if model.showSettings then
                div
                    []
                    [ viewZoneSettings model.zone1 Update.UpdateZone1Min Update.UpdateZone1Max
                    , viewZoneSettings model.zone2 Update.UpdateZone2Min Update.UpdateZone2Max
                    , viewZoneSettings model.zone3 Update.UpdateZone3Min Update.UpdateZone3Max
                    , viewZoneSettings model.zone4 Update.UpdateZone4Min Update.UpdateZone4Max
                    , viewZoneSettings model.zone5 Update.UpdateZone5Min Update.UpdateZone5Max
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
                        , text "Show zone settings"
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
