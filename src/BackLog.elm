port module BackLog exposing (..)

import Json.Decode exposing (Decoder, field, int, map2, map5, string)
import Json.Encode as E


type alias BackLog =
    { backLogItems : List BackLogItem
    , nextId : Int
    }


type alias BackLogItem =
    { id : Int
    , rank : Int
    , title : String
    , description : String
    , storyPoint : Int
    }


emptyBackLog : BackLog
emptyBackLog =
    BackLog [] 1


emptyBackLogItem : BackLogItem
emptyBackLogItem =
    BackLogItem 0 0 "" "" 0


createBackLogItem : BackLog -> BackLogItem -> BackLog
createBackLogItem backLog backLogItem =
    { backLogItems =
        [ BackLogItem backLog.nextId backLog.nextId backLogItem.title backLogItem.description backLogItem.storyPoint ]
            |> List.append backLog.backLogItems
    , nextId = backLog.nextId + 1
    }


backLogItemListDecoder : Decoder (List BackLogItem)
backLogItemListDecoder =
    map5 BackLogItem
        (field "id" int)
        (field "rank" int)
        (field "title" string)
        (field "description" string)
        (field "storyPoint" int)
        |> Json.Decode.list


backLogDecoder : Decoder BackLog
backLogDecoder =
    map2 BackLog
        (field "backLogItems" backLogItemListDecoder)
        (field "nextId" int)


decodeBackLog : String -> BackLog
decodeBackLog json =
    case Json.Decode.decodeString backLogDecoder json of
        Ok decoded ->
            decoded

        Err _ ->
            emptyBackLog


port saveBackLog : BackLog -> Cmd msg


port readBackLogCmd : () -> Cmd msg


port readBackLogSub : (String -> msg) -> Sub msg
