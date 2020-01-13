module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra exposing (..)
import String exposing (..)



---- MODEL ----


type alias Model =
    { page : Page
    , memos : List Memo
    , memo : Memo
    }


type alias Memo =
    { id : Int, title : String, content : String }


type Page
    = Home
    | Create
    | Edit


init : ( Model, Cmd Msg )
init =
    ( { page = Home, memos = [], memo = { id = 2, title = "", content = "" } }, Cmd.none )



---- UPDATE ----


type Msg
    = PressCreate
    | PressHome
    | CreateMemo
    | DeleteMemo Memo
    | Title String
    | Content String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PressCreate ->
            ( { model | page = Create }, Cmd.none )

        PressHome ->
            ( { model | page = Home }, Cmd.none )

        CreateMemo ->
            ( { page = Home, memos = List.append model.memos [ model.memo ], memo = { id = 1, title = "", content = "" } }, Cmd.none )

        DeleteMemo memo ->
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
            [ button [ onClick PressHome ] [ text "Home" ]
            , button [ onClick PressCreate ] [ text "Create" ]
            ]
        , case model.page of
            Home ->
                section [] (memolist model.memos)

            Create ->
                section []
                    [ viewInput "text" "title" model.memo.title Title
                    , viewInput "text" "content" model.memo.content Content
                    , button [ onClick CreateMemo ] [ text "Create" ]
                    ]

            Edit ->
                section [] []
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


memolist : List Memo -> List (Html Msg)
memolist memos =
    List.map memoarticle memos


memoarticle : Memo -> Html Msg
memoarticle memo =
    article []
        [ div []
            [ -- p [] [ text (fromInt memo.id) ]
              h1 [] [ text memo.title ]
            , p [] [ text memo.content ]
            ]
        , button
            []
            [ text "Edit" ]
        , button
            [ onClick (DeleteMemo memo) ]
            [ text "Delete" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
