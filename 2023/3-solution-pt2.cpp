#include <fstream>
#include <iostream>
#include <vector>

#include "3-utils.h"

using namespace std; 

int main(){
  // test input, should yield 281
  // string filename = "3-input-test.txt"; // test
  string filename = "3-input.txt"; // test
  std::ifstream input(filename);

  if (!input.is_open()){
    std::cerr << "Couldn't read file " << filename << "\n";
    return 1;
  }

  vector<string> lines;
  vector<string> char_mat;
  vector<vector<int>> visited;
  for (string line;getline(input, line);){
    // read the data into a 2x2 matrix
    char_mat.push_back(line);
    auto v = new vector<int>();
    for (auto & ch: line){
      v->push_back(0);
    }
    visited.push_back(*v);
  }
  auto sum = 0;
  // get all the symbols
  for(int i = 0; i < char_mat.size(); i++) {
    auto str = char_mat[i];
    for (int j = 0; j < str.size(); j++) {
      auto character = str[j];
      char symbol_chars[11] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'};
      auto found = find(begin(symbol_chars), end(symbol_chars), character);
      // cout << i << " " << j << " " << character << " " << found << endl;
      if (found != end(symbol_chars))
      {
        // found
      }
      else
      {
        if (character != '*'){
          // if its not a star just keep on going
          continue;
        }
        // not found a.k.a. its a symbol
        // look for all the numbers in the array, get their sum
        auto foundNumbers = vector<int>();
        for (int k = -1; k <= 1; k++){
          for (int l = -1; l <= 1; l++)
          {
            auto row = i+k;
            auto col = j+l;
            // see if it is out of bounds
            if (row >= 0 && row < char_mat.size() && col >= 0 && col < char_mat[row].size()){
              if (visited[row][col] == 1) continue;
              auto charToCheck = char_mat[row][col];
              // cout << "checking " << charToCheck << endl;
              auto numb = charToCheck - '0';
              if (numb >= 0 && numb <= 9)
              {
                // cout << "number: " << numb << endl;
                vector<int> number = {numb};

                auto numb = findNumberStartingAtPos(char_mat[row], col, &visited[row]);
                foundNumbers.push_back(numb);
              }
            }
          }
        }
        if (foundNumbers.size() == 2){
          // if there are exactly 2 values found for the star, then multiply them and add to sum
          sum += foundNumbers[0] * foundNumbers[1];
        }
      }
    }
  }

  // search for all the adjacent numbers
  // explore all not visited files left and right to the numbers
  // test output = 467835
  std::cout << "Sum of product gear ratios: " << sum << endl;
}