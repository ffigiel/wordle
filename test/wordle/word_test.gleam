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

  // simple case
  word.new("plant")
  |> result.map(word.reveal)
  |> should.equal(Ok("plant"))

  // always lowercase
  word.new("MANGO")
  |> result.map(word.reveal)
  |> should.equal(Ok("mango"))

  // trim spaces
  word.new(" drone\t\n")
  |> result.map(word.reveal)
  |> should.equal(Ok("drone"))
}
