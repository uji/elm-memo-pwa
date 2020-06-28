module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra exposing (..)
import BackLog exposing (..)
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
    , Cmd.none )



---- UPDATE ----


type Msg
    = PressCreate
    | CreateBackLogItem
    | PressEdit BackLogItem
    | EditBackLogItem
    | PressDelete BackLogItem
    | Title String
    | Description String


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
              newBackLog = createBackLogItem model.backLog model.backLogItemParam
            in
              ( Model View newBackLog emptyBackLogItem, Cmd.none )

        PressEdit backLogItem ->
            ( model, Cmd.none )

        EditBackLogItem ->
            ( model, Cmd.none )

        PressDelete backLogItem ->
            ( model, Cmd.none )

        Title title ->
            let
              a = model.backLogItemParam
              b = { a | title = title }
            in
              ( { model | backLogItemParam = b  }, Cmd.none )

        Description description ->
            let
              a = model.backLogItemParam
              b = { a | description = description }
            in
              ( { model | backLogItemParam = b  }, Cmd.none )



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
        , case model.mode of
            View ->
                backLogItemList model.backLog.backLogItems |> section []

            Create ->
                section [] (backLogItemForm model.backLogItemParam "Create")

            Edit ->
                section [] (backLogItemForm model.backLogItemParam "Update")
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
        , button
            [ onClick (PressEdit backLogItem) ]
            [ text "Edit" ]
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



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
