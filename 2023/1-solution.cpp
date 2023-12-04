#include <fstream>
#include <iostream>
#include <vector>
#include <utility>
#include <assert.h>

int main(){
  std::string filename = "1-input.txt";
  std::ifstream input(filename);

  if (!input.is_open()){
    std::cerr << "Could'nt read file " << filename << "\n";
    return 1;
  }

  std::vector<std::string> lines;

  int sum = 0;

  // iterate over every line in the input
  for (std::string line;std::getline(input, line);){
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
      sum += first * 10 + last; // convert 2 separte digits like 1,2 to "12"
    }
  }

  // Out should be for test: 142
  std::cout << "Sum is: " << sum;
}
