import gleam/io
import gleam/erlang
import gleam/string
import gleam/int
import gleam/list
import gleam/set
import gleam/function
import wordle/ansi

pub fn main() {
  let solution = choose_solution()
  let game = Game(solution: solution, guesses: [])
  io.println("Enter a 5-letter word")
  play(game)
}

fn choose_solution() -> Word {
  Word("GLEAM")
}

fn play(game: Game) {
  let guess = prompt_guess()
  show_guess(guess, game.solution)
  let new_game = Game(..game, guesses: [guess, ..game.guesses])
  case guess == game.solution {
    True -> game_solved()
    False ->
      case list.length(new_game.guesses) {
        5 -> game_over(new_game.solution)
        _ -> play(new_game)
      }
  }
}

fn prompt_guess() -> Word {
  case erlang.get_line("> ") {
    Ok(input) -> {
      let input = string.trim(input)
      case string.length(input) {
        5 ->
          input
          |> string.uppercase
          |> Word
        0 -> prompt_guess()
        n -> {
          io.println(string.concat([
            "This word has ",
            int.to_string(n),
            " letters",
          ]))
          prompt_guess()
        }
      }
    }
    Error(err) -> {
      io.debug(err)
      prompt_guess()
    }
  }
}

fn show_guess(guess: Word, solution: Word) {
  match_guess(guess, solution)
  |> list.map(fn(t) {
    let #(match, letter) = t
    let color_fn = case match {
      ExactMatch -> ansi.seq([ansi.bold, ansi.black, ansi.green_bg])
      LooseMatch -> ansi.seq([ansi.bold, ansi.black, ansi.yellow_bg])
      NoMatch -> ansi.seq([ansi.bold, ansi.gray])
    }
    color_fn(string.concat([" ", letter, " "]))
  })
  |> string.concat
  |> io.println
}

fn match_guess(guess: Word, solution: Word) -> List(#(LetterMatch, String)) {
  // TODO: count matched letters, so that match_guess(EEEEE, APPLE) returns only one match
  // currently it returns 4 LooseMatches and 1 ExactMatch
  let solution_letters = string.to_graphemes(solution.word)
  let solution_letters_set = set.from_list(solution_letters)
  guess.word
  |> string.to_graphemes()
  |> list.index_map(fn(i, letter) {
    let match = case list.at(solution_letters, i) == Ok(letter) {
      True -> ExactMatch
      False ->
        case set.contains(solution_letters_set, letter) {
          True -> LooseMatch
          False -> NoMatch
        }
    }
    #(match, letter)
  })
}

type LetterMatch {
  ExactMatch
  LooseMatch
  NoMatch
}

fn game_solved() {
  io.println("Congratulations!")
}

fn game_over(solution: Word) {
  io.println("Game over!")
  io.println(string.concat(["The correct answer was ", solution.word]))
}

pub type Game {
  Game(solution: Word, guesses: List(Word))
}

pub type Word {
  Word(word: String)
}
