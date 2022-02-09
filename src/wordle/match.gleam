import wordle/word
import gleam/string
import gleam/set
import gleam/list

pub fn guess(
  guess: word.Word,
  solution: word.Word,
) -> List(#(Match, String)) {
  // TODO: count matched letters, so that match_guess(EEEEE, APPLE) returns only one match
  // currently it returns 4 LooseMatches and 1 ExactMatch
  let solution_letters =
    word.reveal(solution)
    |> string.to_graphemes
  let solution_letters_set = set.from_list(solution_letters)
  word.reveal(guess)
  |> string.to_graphemes()
  |> list.index_map(fn(i, letter) {
    let match = case list.at(solution_letters, i) == Ok(letter) {
      True -> Exact
      False ->
        case set.contains(solution_letters_set, letter) {
          True -> Weak
          False -> None
        }
    }
    #(match, letter)
  })
}

pub type Match {
  Exact
  Weak
  None
}
