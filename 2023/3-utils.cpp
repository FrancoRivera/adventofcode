#include <fstream>
#include <iostream>

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