#include <fstream>
#include <iostream>
#include <vector>
#include <utility>

#include "utils.h"

int main(){
  int sum = 0;

  // iterate over every line in the input
  for (std::string line: read_lines(read_file("1-input.txt"))){
    int first = -1;
    int last = -1;
    // iterate over every character in the line
    for (int i = 0; i < line.length(); i++)
    {
      int numb = line[i] - '0'; // get the number of the char
      if (numb > 0 && numb < 10){
        if (first == -1){
          first = numb;
          last = numb;
        } else {
          last = numb;
        }
      }
    }
    // std::cout << line << " " << first << ", " << last << " \n";
    if (first != -1 && last != -1){
      sum += first * 10 + last; // convert 2 separate digits like 1,2 to "12"
    }
  }

  // Out should be for test: 142
  std::cout << "Sum is: " << sum << endl;
}
