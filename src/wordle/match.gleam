import wordle/word
import gleam/string
import gleam/set
import gleam/list
import gleam/map
import gleam/option
import wordle/counter

pub fn guess(guess: word.Word, solution: word.Word) -> List(Match) {
  // TODO: cleanup
  let solution_letters =
    word.reveal(solution)
    |> string.to_graphemes
  let guess_letters =
    word.reveal(guess)
    |> string.to_graphemes
  let solution_letters_counter =
    word.reveal(solution)
    |> counter.from_string

  // find exact matches first
  let #(matches, solution_letters_counter) =
    list.zip(guess_letters, solution_letters)
    |> list.fold(
      #([], solution_letters_counter),
      fn(acc: #(List(Match), counter.Counter(String)), item: #(String, String)) {
        let #(matches, counter) = acc
        let #(guess_char, solution_char) = item
        let #(match, new_counter) = case guess_char == solution_char {
          True -> #(Exact, counter.decrement(counter, solution_char))
          False -> #(None, counter)
        }
        #([match, ..matches], new_counter)
      },
    )
  let matches = list.reverse(matches)

  // find remaining weak matches
  let #(matches, _) =
    list.zip(guess_letters, matches)
    |> list.fold(
      #([], solution_letters_counter),
      fn(acc: #(List(Match), counter.Counter(String)), item: #(String, Match)) {
        let #(matches, counter) = acc
        let #(guess_char, match) = item
        let #(match, new_counter) = case match, counter.has(counter, guess_char) {
          None, True -> #(Weak, counter.decrement(counter, guess_char))
          _, _ -> #(match, counter)
        }
        #([match, ..matches], new_counter)
      },
    )
  let matches = list.reverse(matches)
  matches
}

pub type Match {
  Exact
  Weak
  None
}
