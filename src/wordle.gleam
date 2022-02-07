import gleam/io
import gleam/erlang
import gleam/string
import gleam/int

pub fn main() {
  io.println("Hello from wordle!")
  let word = prompt_word()
  io.println(string.concat(["Your word is ", word]))
}

fn prompt_word() -> String {
  io.println("Enter a 5-letter word")
  case erlang.get_line("> ") {
    Ok(word) -> {
      let word = string.trim(word)
      case string.length(word) {
        5 -> word
        0 -> prompt_word()
        n -> {
          io.println(string.concat([
            "This word has ",
            int.to_string(n),
            " letters",
          ]))
          prompt_word()
        }
      }
    }
    Error(err) -> {
      io.debug(err)
      prompt_word()
    }
  }
}
