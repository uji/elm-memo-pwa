module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra exposing (..)
import Memo exposing (..)
import String exposing (..)



---- MODEL ----


type alias Model =
    { page : Page
    , memos : List Memo
    , memo : Memo
    }


type Page
    = Home
    | Create
    | Edit


init : ( Model, Cmd Msg )
init =
    ( { page = Home, memos = [], memo = emptyMemo }, Cmd.none )



---- UPDATE ----


type Msg
    = PressCreate
    | PressHome
    | CreateMemo
    | PressEdit Memo
    | EditMemo
    | PressDelete Memo
    | Title String
    | Content String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PressCreate ->
            case model.page of
                Home ->
                    ( { model | page = Create }, Cmd.none )

                Create ->
                    ( model, Cmd.none )

                Edit ->
                    ( { model | page = Create, memo = emptyMemo, memos = model.memos |> List.append [ model.memo ] }, Cmd.none )

        PressHome ->
            case model.page of
                Home ->
                    ( model, Cmd.none )

                Create ->
                    ( { model | page = Home }, Cmd.none )

                Edit ->
                    ( { model | page = Home, memos = model.memos |> List.append [ model.memo ] }, Cmd.none )

        CreateMemo ->
            ( { page = Home, memos = createMemo model.memos model.memo, memo = emptyMemo }, Cmd.none )

        PressEdit memo ->
            ( { model | page = Edit, memo = memo, memos = remove memo model.memos }, Cmd.none )

        EditMemo ->
            ( { page = Home, memos = createMemo model.memos model.memo, memo = emptyMemo }, Cmd.none )

        PressDelete memo ->
            ( { model | memos = remove memo model.memos }, Cmd.none )

        Title title ->
            ( { model | memo = { id = model.memo.id, title = title, content = model.memo.content } }, Cmd.none )

        Content content ->
            ( { model | memo = { id = model.memo.id, title = model.memo.title, content = content } }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ header [] [ text "Elm Memo PWA" ]
        , nav []
            [ ul []
                [ li [] [ button [ onClick PressHome ] [ text "Home" ] ]
                , li [] [ button [ onClick PressCreate ] [ text "Create" ] ]
                ]
            ]
        , case model.page of
            Home ->
                section [] (memoList model.memos)

            Create ->
                section [] (memoForm model.memo "Create")

            Edit ->
                section [] (memoForm model.memo "Update")
        ]


memoList : List Memo -> List (Html Msg)
memoList memos =
    List.map memoArticle memos


memoArticle : Memo -> Html Msg
memoArticle memo =
    article []
        [ div []
            [ -- p [] [ text (fromInt memo.id) ]
              h1 [] [ text memo.title ]
            , p [] [ text memo.content ]
            ]
        , button
            [ onClick (PressEdit memo) ]
            [ text "Edit" ]
        , button
            [ onClick (PressDelete memo) ]
            [ text "Delete" ]
        ]


memoForm : Memo -> String -> List (Html Msg)
memoForm memo buttonText =
    [ viewInput "text" "title" memo.title Title
    , viewInput "text" "content" memo.content Content
    , button [ onClick CreateMemo ] [ text buttonText ]
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
