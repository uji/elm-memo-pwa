module BackLog exposing (..)

type alias BackLog =
    { backLogItems : List BackLogItem
    , nextId : Int
    }

type alias BackLogItem =
    { id : Int
    , title : String
    , description : String
    , storyPoint : Int
    }

emptyBackLog : BackLog
emptyBackLog =
  BackLog [] 1

registerBackLogItem : BackLog -> String -> String -> Int -> BackLog
registerBackLogItem backLog title description storyPoint =
  { backLogItems =
    [ BackLogItem backLog.nextId title description storyPoint ]
    |> List.append backLog.backLogItems
  , nextId = backLog.nextId + 1
  }
