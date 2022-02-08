import gleam/string
import gleam/int
import gleam/list

pub const bold = 1

pub const black = 30

pub const green = 32

pub const green_bg = 42

pub const yellow = 33

pub const yellow_bg = 43

const bg = 10

pub fn seq(codes: List(Int)) -> fn(String) -> String {
  let start_sequence =
    codes
    |> list.map(int.to_string)
    |> string.join(";")
  fn(s) { string.concat(["\e[", start_sequence, "m", s, "\e[0m"]) }
}
