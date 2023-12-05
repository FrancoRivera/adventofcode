#include <fstream>
#include <iostream>
#include <vector>
#include <utility>

#include "utils.h"

struct range {       
  long start;   
  long dest;   
  long length;
  range(long _start, long _dest, long _length){
    start = _start;
    dest = _dest;
    length = _length;
  };
};      

int main(){
  long minLoc = LONG_MAX; // a very big number


  vector<long> seeds = {};
  vector<vector<range>> filters = {};
  auto next_map_title = false;
  auto aux_filter_vector = vector<range>();
  // iterate over every line in the input
  for (std::string line: read_lines(read_file("5-input.txt"))){
    // get map for each of the categories
    // first line are our seeds
    // seeds: 79 14 55 13
    if (seeds.size() == 0){
        line = split(line, ':')[1];
        trim(line);
        auto seedStrings = split(line, ' ');
        for(auto &s : seedStrings){
            seeds.push_back(stol(s));
        }
        continue;
        // cout << "finished parsing seeds"  << endl;
    }  
    if (next_map_title){
        next_map_title = false;
        // create a new vector
        aux_filter_vector = vector<range>();
        continue;
    }
    // get the first map
    if (line == ""){
        filters.push_back(aux_filter_vector);
        next_map_title = true;
        continue;
    }
    // extract the ranges
    auto params = split(line, ' ');
    auto r = range(stol(params[1]), stol(params[0]), stol(params[2]));
    aux_filter_vector.push_back(r);
  }

  // push whatever it was left if its not empty
  if (aux_filter_vector.size()){
    filters.push_back(aux_filter_vector);
  }


  // get the min of the location numbers

  // for each seed, map to each of the filters until we get the locations
 for (auto &filter : filters)
  {

        auto og_seeds = seeds;
      for (auto &range : filter)
      {
        // visited seeds map 
        // debugging for filters
       cout << "Filter " << range.start << " " << range.dest << " " << range.length << " " << endl;
        for (int i = 0; i < seeds.size(); i++){
            // if seed is "55" and range is s:52 d:50 l:48 it should come out as 57
            if (og_seeds[i] >= range.start && og_seeds[i] < range.start + range.length){
                cout << " seed " << seeds[i] << endl;
                seeds[i] -= range.start - range.dest;
                cout << " new seed " << seeds[i] << endl;
            }
        }
      }
    cout << "***";
      for (auto &seed : seeds)
      {
          cout << seed << " ";
      }
    cout << endl;
  }
  cout << "=============" << endl;
  for (auto &seed : seeds)
  {
      cout << seed << " ";
      minLoc = min(seed, minLoc);
  }
  cout << endl;

  // Out should be for test: 35
  std::cout << "Min. Location is: " << minLoc << endl;
}
