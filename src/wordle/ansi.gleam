import gleam/string
import gleam/int

const green_seq = 32

const yellow_seq = 33

const bg_seq = 10

pub fn green_bg(s) {
  color(green_seq + bg_seq)(s)
}

pub fn yellow_bg(s) {
  color(yellow_seq + bg_seq)(s)
}

fn color(color_seq: Int) -> fn(String) -> String {
  fn(s) { string.concat(["\e[1;", int.to_string(color_seq), "m", s, "\e[0m"]) }
}
