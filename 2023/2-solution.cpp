#include <fstream>
#include <iostream>
#include <vector>

#include "2-parse.h"
#include "utils.h"

using namespace std; 

int main(){
  vector<vector<vector<int>>> games;
  // string filename = "2-input-test.txt"; // test
  // string filename = "2-input.txt"; // test
  for (std::string line: read_lines(read_file("2-input.txt"))){
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
    // iterate over each draw, check if the draw is valid
    auto valid = true;
    for (int j = 0 ; j < game.size(); j++){
      auto draw = game[j];
      // if the draw is invalid break
      if (draw.at(0) > 12 || draw.at(1) > 13 || draw.at(2) > 14){
        valid = false;
      }
    }
    // if all good, sum the game id to the list. 
    if (valid) {
      // cout << "Game is valid: " << i + 1;
      // sum += game_id;
      sum += i + 1;
    }
    else
    {
      // cout << "Game is invalid: " << i + 1;
    }
    for (int j = 0; j < game.size(); j++)
    {
      auto draw = game[j];
      // if the draw is invalid break
      // cout << "\t draw " << draw.at(0) << " " << draw.at(1) << " " << draw.at(2);
    }
    // cout << endl;
  }
  // output = 8 test
  std::cout << "Valid games: " << sum << endl;
}