module Main exposing (..)

import Html exposing (Html)
import Http exposing (..)
import Element exposing (..)
import Element.Input as Input


---- MODEL ----


type alias Model =
    { boxText : String
    , outputText : String
    }


init : ( Model, Cmd Msg )
init =
    ( { boxText = "", outputText = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = NewText String
    | Return (Result Http.Error String)


myGetString url =
    request
        { method = "GET"
        , headers = []
        , url = url
        , body = emptyBody
        , expect = expectString
        , timeout = Nothing
        , withCredentials = False
        }


sendString txt =
    let
        url =
            "http://elm.spectrogon.com:8080/" ++ txt
    in
        send Return <| myGetString url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewText aString ->
            ( { model | boxText = aString }, sendString aString )

        Return (Ok aString) ->
            { model | outputText = aString } ! []

        Return (Err message) ->
            { model | outputText = toString message } ! []



---- VIEW ----


view : Model -> Html Msg
view model =
    layout [] <|
        column []
            [ Input.text []
                { onChange = Just (\x -> NewText x)
                , text = model.boxText
                , placeholder = Nothing
                , label =
                    Input.labelLeft [ moveDown 10 ] <|
                        text "Skriv något:"
                }
            , text model.outputText
            ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
