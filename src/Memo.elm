module Memo exposing (..)


type alias Memo =
    { id : Int
    , title : String
    , content : String
    }


emptyMemo : Memo
emptyMemo =
    { id = 0, title = "", content = "" }


createMemo : List Memo -> Memo -> List Memo
createMemo memos memo =
    List.append memos [ memo ]
