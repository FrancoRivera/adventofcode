#include <fstream>
#include <iostream>

#include "utils.h"

using namespace std;

//Input:  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Output [[4,3,0],[1,2,6],[0,2,0]] 
vector<vector<int>> getDrawsFromString(string str){
  auto draws = vector<vector<int>>();
  str = split(str, ':')[1];
  string drawsString = str.substr(1, string::npos); // 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  vector<string> drawArray = split(drawsString, ';'); // ["3 blue, 4 red", "1 red, 2 green", "2 green"]
  for (auto &draw : drawArray){
    auto colorDraw = split(draw, ','); // ["3 blue"," 4 red"]
    auto drawArr = vector<int>{0,0,0}; // R, G, B
    for (auto &color : colorDraw)
    {
      trim(color); // remove whitespace
      auto count = split(color, ' ')[0]; // 3 
      auto colorStr = split(color, ' ')[1]; // blue
      int number = stoi(count);
      string order = "rgb";
      int index = order.find(colorStr[0]);
      drawArr[index] = number;
    }
    draws.push_back(drawArr);
  }
  return draws;
}
