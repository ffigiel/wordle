import gleam/io
import gleam/erlang
import gleam/string
import gleam/int
import gleam/list

pub fn main() {
  let game = Game(solution: Guess("GLEAM"), guesses: [])
  play(game)
}

fn play(game: Game) -> Game {
  let guess = prompt_guess()
  let new_game = Game(..game, guesses: [guess, ..game.guesses])
  case list.length(new_game.guesses) {
    5 -> game_over(new_game)
    _ -> play(new_game)
  }
}

fn prompt_guess() -> Guess {
  io.println("Enter a 5-letter word")
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

fn game_over(game: Game) -> Game {
  todo
}

pub type Game {
  Game(solution: Guess, guesses: List(Guess))
}

pub type Guess {
  Guess(word: String)
}
