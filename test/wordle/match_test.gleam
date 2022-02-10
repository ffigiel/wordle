import gleeunit
import gleeunit/should
import wordle/word
import wordle/match
import gleam/set

pub fn main() {
  gleeunit.main()
}

fn should_match_like(g, s, expected) {
  assert Ok(guess) = word.new(g)
  assert Ok(solution) = word.new(s)
  match.guess(guess, solution)
  |> should.equal(expected)
}

pub fn match_watch_test() {
  should_match_like(
    "watch",
    "cheat",
    [match.None, match.Weak, match.Weak, match.Weak, match.Weak],
  )
}

pub fn match_apple_test() {
  should_match_like(
    "plead",
    "apple",
    [match.Weak, match.Weak, match.Weak, match.Weak, match.None],
  )
}

pub fn match_niece_test() {
  should_match_like(
    "niece",
    "beefy",
    [match.None, match.None, match.Exact, match.None, match.Weak],
  )
}
