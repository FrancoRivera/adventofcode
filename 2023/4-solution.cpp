#include <fstream>
#include <iostream>
#include <vector>

using namespace std; 

int get_number_from_int_vector(vector<int> array){
  auto sum = 0;
  for (int i = 0; i < array.size(); i++)
  {
    sum += array[i] * pow(10, array.size() - i - 1);
  }
  return sum;
}

// given a string like  " 1 48 83 86 17" it returns [1, 48, 83, 86, 17]
vector<int> get_all_numbers_in_string(string str){
  auto numbers = vector<int>();
  auto aux = vector<int>();
  for (auto & ch: str){
    auto chInt = ch - '0';
    if (chInt >= 0 && chInt <= 9){
      aux.push_back(chInt);
    } else{ 
      if (aux.size() == 0){ continue; };
      // it is not a number, hence 
      // flush the stack and add to numbers 
      numbers.push_back(get_number_from_int_vector(aux));
      aux = vector<int>();
    }
  }
  // catch any remaining numbers
  if (aux.size() > 0){
      numbers.push_back(get_number_from_int_vector(aux));
  };
  return numbers;
}

int main(){
  // string filename = "4-input-test.txt"; // test
  string filename = "4-input.txt"; // test
  std::ifstream input(filename);

  if (!input.is_open()){
    std::cerr << "Couldn't read file " << filename << "\n";
    return 1;
  }
  vector<string> lines;
  vector<vector<int>> winning;
  vector<vector<int>> our;

  // Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  for (string line;getline(input, line);){
    auto pipePos = line.find("|");
    auto colonPos = line.find(":");
    // parse winning numbers
    auto winningNums = get_all_numbers_in_string(line.substr(colonPos+1, pipePos-colonPos-1));
    // parse our numbers
    auto ourNums = get_all_numbers_in_string(line.substr(pipePos+1)); // get the rest

    winning.push_back(winningNums);
    our.push_back(ourNums);
  }
  auto sum = 0;
  // for each of our numbers check how many numbers we have.
  // debug
  for (int i = 0; i < our.size(); i++)
  {
    cout << "ours: [";
    for (auto &num : our[i])
    {
      cout << num << ", ";
    }
    cout << "] - [";
    for (auto &winningNum : winning[i])
    {
      cout << winningNum << ", ";
    }
    cout << "]" << endl;
  }


  for (int i = 0; i < our.size(); i++)
  {
    auto coincidences = 0;
    for (auto &num : our[i])
    {
      for (auto &winningNum : winning[i])
      {
        if (winningNum == num)
        {
          // cout << winningNum << " " << endl;
          coincidences++;
        }
      }
    }
    if (coincidences > 0)
    {
      // cout << coincidences << endl;
      sum += pow(2, coincidences-1);
    }
  }

  // get 2**coincidences
  // sum that to the incrementor
  // test output = 13
  std::cout << "Sum of all wining cards: " << sum << endl;
}