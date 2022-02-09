import gleam/string

pub opaque type Word {
  Word(word: String)
}

pub type NewWordError {
  InvalidLengthError
}

pub fn new(s: String) -> Result(Word, NewWordError) {
  let s = string.trim(s)
  case string.length(s) {
    5 ->
      string.lowercase(s)
      |> Word
      |> Ok
    _ -> Error(InvalidLengthError)
  }
}

pub fn reveal(w: Word) -> String {
  w.word
}
