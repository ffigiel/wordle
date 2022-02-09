import gleam/io
import gleam/erlang
import gleam/string
import gleam/int
import gleam/list
import gleam/set
import gleam/function
import gleam/result
import wordle/ansi
import wordle/word
import wordle/match

pub fn main() {
  let solution = choose_solution()
  let game = Game(solution: solution, guesses: [])
  io.println("Enter a 5-letter word")
  play(game)
}

fn choose_solution() -> word.Word {
  assert Ok(w) = word.new("gleam")
  w
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

type PromptGuessError {
  GetLineError(e: erlang.GetLineError)
  NewWordError(e: word.NewWordError)
}

fn prompt_guess() -> word.Word {
  let res = {
    try input =
      erlang.get_line("> ")
      |> result.map_error(GetLineError)
    try word =
      word.new(input)
      |> result.map_error(NewWordError)
    Ok(word)
  }
  case res {
    Ok(w) -> w
    Error(GetLineError(err)) -> {
      io.debug(err)
      prompt_guess()
    }
    Error(NewWordError(word.InvalidLengthError)) -> {
      io.println("The word needs to be five letters long.")
      prompt_guess()
    }
  }
}

fn show_guess(guess: word.Word, solution: word.Word) {
  match.guess(guess, solution)
  |> list.map(fn(t) {
    let #(match, letter) = t
    let color_fn = case match {
      match.Exact -> ansi.seq([ansi.bold, ansi.black, ansi.green_bg])
      match.Weak -> ansi.seq([ansi.bold, ansi.black, ansi.yellow_bg])
      match.None -> ansi.seq([ansi.bold, ansi.gray])
    }
    color_fn(string.concat([" ", letter, " "]))
  })
  |> string.concat
  |> io.println
}

fn game_solved() {
  io.println("Congratulations!")
}

fn game_over(solution: word.Word) {
  io.println("Game over!")
  io.println(string.concat(["The correct answer was ", word.reveal(solution)]))
}

pub type Game {
  Game(solution: word.Word, guesses: List(word.Word))
}
