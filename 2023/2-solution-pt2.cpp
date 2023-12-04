#include <fstream>
#include <iostream>
#include <vector>
#include <utility>
#include <assert.h>

#include "2-parse.h"

using namespace std; 

int main(){
  // test input, should yield 281
  // string filename = "2-input-test.txt"; // test
  string filename = "2-input.txt"; // test
  std::ifstream input(filename);

  if (!input.is_open()){
    std::cerr << "Couldn't read file " << filename << "\n";
    return 1;
  }

  std::vector<std::string> lines;

  vector<vector<vector<int>>> games;

  for (std::string line;std::getline(input, line);){
  // parse each line, create an 2d vector with each of the games,
  // and each of the draws per game
  // each draw has [0..3] amount of cubes, that contain either "red", "green" or "blue" cubes, + a number.
  // example:
  // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  // ordered in RGB
  // [ [4,3,0],[1,2,6],[0,2,0]] // for easier comparison, we could also use binary ig.
  // only 12 red cubes, 13 green cubes, and 14 blue cubes
    auto gameDraws = getDrawsFromString(line);
    games.push_back(gameDraws);
  }

  // if one of the games has N[color] > Max_color, then it is not possible, and should be discarded
  auto sum = 0;
  // iterate over each game
  for (int i = 0; i < games.size(); i++){
    auto game = games[i];
    // iterate over each draw, get the maximum of each color needed
    auto maxR = 0;
    auto maxG = 0;
    auto maxB = 0;
    for (int j = 0 ; j < game.size(); j++){
      auto draw = game[j];
      maxR = max(draw.at(0), maxR);
      maxG = max(draw.at(1), maxG);
      maxB = max(draw.at(2), maxB);
    }
    auto power = maxR * maxG * maxB;
    sum += power;
  }
  // output = 2286 test
  std::cout << "Power of all games: " << sum << endl;
}