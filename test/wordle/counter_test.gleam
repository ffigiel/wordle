import wordle/counter
import gleeunit/should
import gleam/map

pub fn from_string_test() {
  counter.from_string("apple")
  |> counter.to_map
  |> should.equal(map.from_list([#("a", 1), #("p", 2), #("l", 1), #("e", 1)]))
}

pub fn has_test() {
  let counter = counter.from_string("apple")
  counter.has(counter, "a")
  |> should.be_true
  counter.has(counter, "z")
  |> should.be_false
}

pub fn decrement_test() {
  counter.from_string("apple")
  |> counter.decrement("a")
  |> counter.decrement("p")
  |> counter.decrement("e")
  |> counter.to_map
  |> should.equal(map.from_list([#("a", 0), #("p", 1), #("l", 1), #("e", 0)]))
}
