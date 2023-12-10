#include "utils.h"

int get_next_value_in_sequence(std::vector<int> sequence) {
  // find the difference between each of the values in the array
  auto diff = std::vector<int>();

  // check if its all zeroes
  bool all_zeros = true;
  for (int i = 0; i < sequence.size(); i++) {
    if (sequence[i] != 0) {
      all_zeros = false;
    }
  }
  // when all the values are 0 then we can do the process of climbing back up
  if (all_zeros) {
    std::cout << "all zeroes bitch" << std::endl;
    return 0;
  }

  for (int i = 0; i < sequence.size() - 1; i++) {
    diff.push_back(sequence[i + 1] - sequence[i]);
  }
  std::cout << "last in diff " << sequence[sequence.size() - 1] << std::endl;
  return sequence[sequence.size() - 1] + get_next_value_in_sequence(diff);
}

int main() {
  // read the input
  // parse the input
  // 0 3 6 9 12 15
  // 1 3 6 10 15 21
  // 10 13 16 21 30 45
  std::vector<std::string> lines = read_lines(read_file("9-input.txt"));
  int sum = 0;
  for (auto l : lines) {
    // for each line we need to split at the space, trim it and then convert it
    // to integers
    auto line_arr = split(l, ' ');
    std::vector<int> line_ints = std::vector<int>();
    for (auto el : line_arr) {
      trim(el);
      line_ints.push_back(stoi(el));
    }
    sum += get_next_value_in_sequence(line_ints);
  }

  // test should be 114
  std::cout << "sum of etrapolated: " << sum << std::endl;
}