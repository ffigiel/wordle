import gleam/map
import gleam/list
import gleam/string
import gleam/result
import gleam/option

pub opaque type Counter(k) {
  Counter(map: map.Map(k, Int))
}

pub fn new() -> Counter(k) {
  Counter(map.new())
}

pub fn from_string(s: String) -> Counter(String) {
  string.to_graphemes(s)
  |> list.fold(
    map.new(),
    fn(counter, char) {
      counter
      |> map.update(char, fn(value) { option.unwrap(value, 0) + 1 })
    },
  )
  |> Counter
}

pub fn to_map(c: Counter(k)) -> map.Map(k, Int) {
  c.map
}

pub fn has(c: Counter(k), k: k) -> Bool {
  map.get(c.map, k)
  |> result.unwrap(0)
  |> fn(n) { n > 0 }
}

pub fn decrement(c: Counter(k), k: k) -> Counter(k) {
  map.update(c.map, k, fn(v) { option.unwrap(v, 0) - 1 })
  |> Counter
}
