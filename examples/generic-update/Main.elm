module Main exposing (..)

import Html exposing (div, input, text, label, Html)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onCheck)
import Html.Attributes exposing (type', checked)
import Dict exposing (Dict)


{-| This is a custom infix operator I use as a helper for creating Tuples.

   Instead of (a, b) I can use a => b, which looks much better in Dictionaries.
-}
(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )


main : Program Never
main =
    beginnerProgram { model = init, view = view, update = update }



-- MODEL


type alias Checkbox =
    { name : String
    , checked : Bool
    }


type alias Model =
    { name : String
    , checkboxes : Dict String Checkbox
    }


init : Model
init =
    { name = ""
    , checkboxes =
        -- We store the the state for components in a Dictionary
        Dict.fromList
            [ "advertising"
                => { name = "Advertising"
                   , checked = False
                   }
            , "travel"
                => { name = "Travel"
                   , checked = False
                   }
            , "utilities"
                => { name = "Utilities"
                   , checked = False
                   }
            ]
    }



-- UPDATE


type Msg
    = Check String Bool


update msg model =
    case msg of
        Check checkboxId checked ->
            let
                updateRecord =
                    Maybe.map (\checkboxData -> { checkboxData | checked = checked })

                {- Update a single value inside of a dictionary,
                   using updateRecord function.

                   Since we don't know if value with a key checkboxId
                   is present in the Dictionary,
                   the updateRecord function is applied to a Maybe value.
                -}
                checkboxesUpdated =
                    Dict.update checkboxId
                        updateRecord
                        model.checkboxes
            in
                { model | checkboxes = checkboxesUpdated }



-- VIEW


view : Model -> Html Msg
view model =
    let
        checkbox ( key, data ) =
            label []
                [ text data.name
                , input
                    [ type' "checkbox"
                    , checked data.checked
                      -- Pass the key for accesing the state as a Message payload.
                    , onCheck (Check key)
                    ]
                    []
                ]
    in
        div []
            (model.checkboxes
                |> Dict.toList
                |> List.map checkbox
            )
