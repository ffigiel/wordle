import gleeunit/should
import wordle/word
import gleam/result

pub fn new_test() {
  // too short
  word.new("hurk")
  |> should.equal(Error(word.InvalidLengthError))

  // too long
  word.new("poncho")
  |> should.equal(Error(word.InvalidLengthError))

  // uppercase
  word.new("mango")
  |> result.map(word.reveal)
  |> should.equal(Ok("MANGO"))

  // trim spaces
  word.new(" drone\t\n")
  |> result.map(word.reveal)
  |> should.equal(Ok("DRONE"))
}
