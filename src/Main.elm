module Main exposing (..)

import BackLog exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as E
import List.Extra exposing (..)
import String exposing (..)



---- MODEL ----


type alias Model =
    { mode : Mode
    , backLog : BackLog
    , backLogItemParam : BackLogItem
    }


type Mode
    = View
    | Create
    | Edit


init : ( Model, Cmd Msg )
init =
    ( Model View emptyBackLog emptyBackLogItem
    , readBackLogCmd ()
    )



---- UPDATE ----


type Msg
    = PressCreate
    | CreateBackLogItem
    | PressEdit BackLogItem
    | EditBackLogItem
    | PressDelete BackLogItem
    | Title String
    | Description String
    | ReadStore String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PressCreate ->
            case model.mode of
                View ->
                    ( { model | mode = Create }, Cmd.none )

                Create ->
                    ( model, Cmd.none )

                Edit ->
                    ( Model Create model.backLog emptyBackLogItem, Cmd.none )

        CreateBackLogItem ->
            let
                newBackLog =
                    createBackLogItem model.backLog model.backLogItemParam
            in
            ( Model View newBackLog emptyBackLogItem, saveBackLog newBackLog )

        PressEdit backLogItem ->
            ( model, Cmd.none )

        EditBackLogItem ->
            ( model, Cmd.none )

        PressDelete backLogItem ->
            let
                backLogItems =
                    remove backLogItem model.backLog.backLogItems

                backLog =
                    BackLog backLogItems model.backLog.nextId
            in
            ( { model | backLog = backLog }, Cmd.none )

        Title title ->
            let
                old =
                    model.backLogItemParam

                new =
                    { old | title = title }
            in
            ( { model | backLogItemParam = new }, Cmd.none )

        Description description ->
            let
                old =
                    model.backLogItemParam

                new =
                    { old | description = description }
            in
            ( { model | backLogItemParam = new }, Cmd.none )

        ReadStore backLogJson ->
            ( { model | backLog = decodeBackLog backLogJson }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ header [] [ text "Elm Memo PWA" ]
        , nav []
            [ ul []
                [ li [] [ button [ onClick PressCreate ] [ text "Create" ] ]
                ]
            ]
        , backLogItemList model.backLog.backLogItems |> section []
        , case model.mode of
            View ->
                section [] []

            Create ->
                section [] (backLogItemForm model.backLogItemParam "Create")

            Edit ->
                section [] []
        ]


backLogItemList : List BackLogItem -> List (Html Msg)
backLogItemList backLogItem =
    List.map backLogItemArticle backLogItem


backLogItemArticle : BackLogItem -> Html Msg
backLogItemArticle backLogItem =
    article []
        [ div []
            [ -- p [] [ text (fromInt memo.id) ]
              h1 [] [ text backLogItem.title ]
            , p [] [ text backLogItem.description ]
            ]

        -- , button
        --     [ onClick (PressEdit backLogItem) ]
        --     [ text "Edit" ]
        , button
            [ onClick (PressDelete backLogItem) ]
            [ text "Delete" ]
        ]


backLogItemForm : BackLogItem -> String -> List (Html Msg)
backLogItemForm backLogItem buttonText =
    [ viewInput "text" "title" backLogItem.title Title
    , viewInput "text" "description" backLogItem.description Description
    , button [ onClick CreateBackLogItem ] [ text buttonText ]
    ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, class p, placeholder p, value v, onInput toMsg ] []



---- SUBSCRIPTION ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ readBackLogSub ReadStore ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
