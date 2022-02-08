import gleam/io
import gleam/erlang
import gleam/string
import gleam/int
import gleam/list
import gleam/set
import gleam/function
import wordle/ansi

pub fn main() {
  let game = Game(solution: Guess("GLEAM"), guesses: [])
  io.println("Enter a 5-letter word")
  play(game)
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

fn prompt_guess() -> Guess {
  case erlang.get_line("> ") {
    Ok(word) -> {
      let word = string.trim(word)
      case string.length(word) {
        5 ->
          word
          |> string.uppercase
          |> Guess
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

fn show_guess(guess: Guess, solution: Guess) {
  match_guess(guess, solution)
  |> list.map(fn(t) {
    let #(match, letter) = t
    let color_fn = case match {
      ExactMatch -> ansi.seq([ansi.bold, ansi.black, ansi.green_bg])
      LooseMatch -> ansi.seq([ansi.bold, ansi.black, ansi.yellow_bg])
      NoMatch -> ansi.seq([ansi.gray])
    }
    color_fn(string.concat([" ", letter, " "]))
  })
  |> string.concat
  |> io.println
}

fn match_guess(guess: Guess, solution: Guess) -> List(#(LetterMatch, String)) {
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

fn game_over(solution: Guess) {
  io.println("Game over!")
  io.println(string.concat(["The correct answer was ", solution.word]))
}

pub type Game {
  Game(solution: Guess, guesses: List(Guess))
}

pub type Guess {
  Guess(word: String)
}
