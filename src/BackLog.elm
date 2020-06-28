port module BackLog exposing (..)

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

emptyBackLogItem : BackLogItem
emptyBackLogItem =
  BackLogItem 0 "" "" 0

createBackLogItem : BackLog -> BackLogItem -> BackLog
createBackLogItem backLog backLogItem =
  { backLogItems =
    [ BackLogItem backLog.nextId backLogItem.title backLogItem.description backLogItem.storyPoint ]
    |> List.append backLog.backLogItems
  , nextId = backLog.nextId + 1
  }

port saveBackLogItem : BackLogItem -> Cmd msg
