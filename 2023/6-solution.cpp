#include <fstream>
#include <iostream>
#include <vector>
#include <utility>

#include "utils.h"

struct race
{
  long time; // record in ms
  long dist; // record in mm 
  race(long _time, long _dist)
  {
    time = _time;
    dist = _dist;
  };

};

// say time = 7 and distance = 9, lets begin bruteforce our way in?
// IDK but seems that:
// first of all the problem is symmetric so we need only to find time/2
int all_possible_winning_ways(race r){
  auto possible_winning_ways = 0;
  // acceleration is always 1mm/ms
  auto acc = 1;
  // budget is time
  for (int count = 0; count < r.time; count++){
    int time_revving = count;
    int time_remaining = r.time - count;
    // max time we can rev up is time, but certainly this is not best strat
    int dist_travelled = time_revving * time_remaining;
    if (dist_travelled > r.dist) {
      possible_winning_ways++;
    }
  }
  return possible_winning_ways;
}


const bool DEBUG = false;

int main()
{
  long prod = 1; // a very big number
  // iterate over every line in the input

  // Time:      7  15   30
  // Distance:  9  40  200
  std::vector<std::string> lines = read_lines(read_file("6-input.txt"));

  // ===
  // PARSING
  // ===
  std::vector<std::string> time_line = split(trim(split(lines[0], ':')[1]), ' ');
  std::vector<std::string> dist_line = split(trim(split(lines[1], ':')[1]), ' ');

  std::vector<race> races = std::vector<race>();

  std::vector<std::string> c_time_line = std::vector<std::string>(); // clean
  std::vector<std::string> c_dist_line = std::vector<std::string>(); // clean

  for(int i = 0; i < time_line.size(); i++){
    trim(time_line[i]);
    trim(dist_line[i]);
    if (time_line[i].size() != 0){
      c_time_line.push_back(time_line[i]);
    };
    if (dist_line[i].size() != 0){
      c_dist_line.push_back(dist_line[i]);
    };
  }
  for (int i = 0; i < c_time_line.size(); i++)
  {
    auto time = stoi(trim(c_time_line[i]));
    auto dist = stoi(trim(c_dist_line[i]));
    races.push_back(race(time, dist));
  }

  // ===
  // Solving
  // ===
   for(auto &r: races){
    // print each race for debugging
    std::cout << r.time << " - " << r.dist << std::endl;
    // max ways
    prod *= all_possible_winning_ways(r);
   }
  // Out should be for test: 288
  std::cout << "Product of ways is: " << prod << std::endl;
}
