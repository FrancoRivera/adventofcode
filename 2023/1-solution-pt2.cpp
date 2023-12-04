#include <fstream>
#include <iostream>
#include <vector>
#include <utility>
#include <assert.h>

std::vector<int> find_in_string(std::string *line){
  auto vector = std::vector<int>();
  std::string numbers_in_letters[20] = {
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
    };
  bool found = false;

  // auto candidates_vector = std::vector<int>();
  // int candidate_pos = 999;
  int first = -1;
  int first_pos = 9999;
  int last = -1;
  int last_pos = -1;
  for(int i = 0; i < 20; i++){
    int pos =  line->find(numbers_in_letters[i]);
    int lpos =  line->rfind(numbers_in_letters[i]); // last position, in case they are repeated
    if (pos != std::string::npos){
      auto num = i % 10; // get what position is the value aka. "five" is 5 and "5" is also 5
      if (first == -1 || pos < first_pos)
      {
        first = num;
        first_pos = pos;
      }
      if (last == -1 || pos > last_pos || lpos > last_pos)
      {
        last = num;
        last_pos = std::max(lpos, pos);
      }
    }
  }
  vector.push_back(first);
  vector.push_back(last);
      // vector.push_back(i);
      // auto new_string = line->substr(pos + numbers_in_letters[i].length(), std::string::npos);
      // auto other = find_in_string(&new_string);
      // if (other.size() > 0){
      //   vector.push_back(other[0]);
      // }

  return vector;
}


int main(){
  // test input, should yield 281
  // std::string filename = "1-input-pt2-test.txt";
  // real input, should yield?
  std::string filename = "1-input.txt";
  std::ifstream input(filename);

  if (!input.is_open()){
    std::cerr << "Couldn't read file " << filename << "\n";
    return 1;
  }

  std::vector<std::string> lines;

  int sum = 0;

  // iterate over every line in the input
  for (std::string line;std::getline(input, line);){

    auto my_line = line;
    // // iterate over every character in the line
    auto nums = find_in_string(&my_line);

    int first = nums[0];
    int last = nums[1];

    std::cout << line << " \t " << first << ", " << last << " \n";
    if (first != -1 && last != -1){
      sum += first * 10 + last; // convert 2 separte digits like 1,2 to "12"
    }
  }

  // Out should be for test: 142
  std::cout << "Sum is: " << sum;
}