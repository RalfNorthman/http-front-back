module Main exposing (..)

import Html exposing (Html)
import Http exposing (..)
import Element exposing (..)
import Element.Input as Input
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipe


---- JSON ----


type alias Payload =
    { someText : String
    , someNumber : Int
    }


decodePayload : Decode.Decoder Payload
decodePayload =
    DecodePipe.decode Payload
        |> DecodePipe.required "someText" (Decode.string)
        |> DecodePipe.required "someNumber" (Decode.int)


encodePayload : Payload -> Encode.Value
encodePayload record =
    Encode.object
        [ ( "someText", Encode.string <| record.someText )
        , ( "someNumber", Encode.int <| record.someNumber )
        ]



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
    | Return (Result Http.Error Payload)


sendString txt =
    let
        url =
            "http://elm.spectrogon.com:8081/"

        body =
            jsonBody <| encodePayload <| Payload txt 1
    in
        send Return <| post url body decodePayload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewText aString ->
            ( { model | boxText = aString }, sendString aString )

        Return (Ok payload) ->
            { model | outputText = payload.someText } ! []

        Return (Err message) ->
            { model | outputText = toString message } ! []



---- VIEW ----


view : Model -> Html Msg
view model =
    layout [] <|
        column [ spacing 5 ]
            [ Input.text []
                { onChange = Just (\x -> NewText x)
                , text = model.boxText
                , placeholder = Nothing
                , label =
                    Input.labelLeft [ moveDown 10 ] <|
                        text "Skriv något:"
                }
            , el [ moveRight 121 ] <| text model.outputText
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
