#include <fstream>
#include <iostream>
#include <vector>

using namespace std; 

int findNumberStartingAtPos(string str, int pos, vector<int> *visited){
  int pivot = -1;
  int direction = -1;
  vector<int> numbs = {str[pos] - '0'};
  (*visited)[pos] = 1;
  // check left
  while (true)
  {
    if (pos + pivot < 0 || (*visited)[pos + pivot] == 1)
    {
      break;
    };
    (*visited)[pos+pivot] = 1;
    auto num = str[pos+pivot] - '0';
    if (num >= 0 && num <= 9){
      numbs.insert(numbs.begin(), num);
    } else{
      break;
    }
    pivot--;
  }
  // check right
  pivot = 1;
  // check left
  while (true)
  {
    if (pos + pivot >=  (*visited).size() || (*visited)[pos + pivot] == 1)
    {
      break;
    };
     (*visited)[pos+pivot] = 1;
    auto num = str[pos+pivot] - '0';
    if (num >= 0 && num <= 9){
      numbs.push_back(num);
    } else{
      break;
    }
    pivot++;
  }

  // turn array of int, into a number like [1,3,4] into 134
  auto sum = 0;
  for (int i = 0; i < numbs.size(); i++){
    sum += numbs[i] * pow(10, numbs.size()-i-1);
  }
  cout << sum << endl;
  return sum;
}

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
        // not found a.k.a. its a symbol
        // look for all the numbers in the array, get their sum
        for (int k = -1; k <= 1; k++){
          for (int l = -1; l <= 1; l++)
          {
            auto row = i+k;
            auto col = j+l;
            // cout << k << ", " << l << "\t\t";
            // cout << row << ", " << col << endl;
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
                sum += numb;
                // it is a number explore left and right
              }
            }
          }
        }
      }
    }
  }

  // search for all the adjacent numbers
  // explore all not visited files left and right to the numbers
  // test output = 4361
  std::cout << "Sum of part numbers: " << sum << endl;
}