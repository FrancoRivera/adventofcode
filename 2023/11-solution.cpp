#include <algorithm>
#include <cmath>
#include <cstdint>

#include "utils.h"

std::vector<std::vector<char>> expand_universe(std::vector<std::vector<char>> universe){
    std::vector<std::vector<char>> expanded;

    std::string l;

    // expand first rows
    for (int i = 0; i < universe.size(); i++){
      bool no_galaxies = true;
      for (auto c : universe[i]) {
          if (c == '#'){
              no_galaxies = false;
          }
      }
      if (no_galaxies){
          expanded.insert(expanded.begin()+expanded.size(), universe[i]);
          expanded.insert(expanded.begin()+expanded.size(), universe[i]);
      } else {
          expanded.insert(expanded.begin()+expanded.size(), universe[i]);
      }
    }

    std::vector<std::vector<char>> expanded_cols;
    // Expand columns
    // auto rs = expanded.size();
    for (int j = 0; j < expanded[0].size(); j++) { // iterate over columns
      bool no_galaxies = true;
      for (int i = 0; i < expanded.size(); i++) { // iterate over rows
          if (expanded[i][j] == '#') {
              no_galaxies = false;
          }
      }
      if (no_galaxies) {
          l.push_back('.');
          for (int i = 0; i < expanded.size(); i++) {
              if (expanded_cols.size() <= i) {
                expanded_cols.push_back(std::vector<char>());
              }
              expanded_cols[i].push_back(expanded[i][j]);
          }
      } else{
          l.push_back('#');
      }
      for (int i = 0; i < expanded.size(); i++) {
          if (expanded_cols.size() <= i){
              expanded_cols.push_back(std::vector<char>());
          }
          expanded_cols[i].push_back(expanded[i][j]);
      }
    }

    // std::cout << "----------" << std::endl;
    // std::cout << l << std::endl;
    // std::cout << "----------" << std::endl;

    return expanded_cols;
}

void print_matrix(std::vector<std::vector<char>> matrix){
    for (auto row: matrix){
        for (auto c : row){
            std::cout << c;
        }
        std::cout << std::endl;
    }
}


int part1(std::string filename){
  // read the file
  std::vector<std::pair<int, int>> galaxies;
  std::vector<std::string> lines = read_lines(read_file(filename));

  std::vector<std::vector<char>> universe;
  for (int i = 0; i < lines.size(); i++) {
    // for each of the tokens, first create an array of pipes wxh
    auto row_universe = std::vector<char>();
    for (int j = 0; j < lines[i].size(); j++) {
        row_universe.push_back(lines[i][j]);
    }
    universe.push_back(row_universe);
  };
  // Expand the universe
  universe = expand_universe(universe);
  // print_matrix(universe);

  for (int i = 0; i < universe.size(); i++) {
    // for each of the tokens, first create an array of pipes wxh
    auto row_universe = std::vector<char>();
    for (int j = 0; j < universe[i].size(); j++) {
        if (universe[i][j] == '#') {
            galaxies.push_back(std::pair<int, int>(j, i));
        }
    }
  };
  auto sum = 0;
  // measure the distance between each galaxy
  // this is the manhattan distance, only need to take end and start
  for (int i = 0; i < galaxies.size(); i++){
    for (int j = i; j < galaxies.size(); j++) {
        auto dx = galaxies[j].first - galaxies[i].first;
        auto dy = galaxies[j].second - galaxies[i].second;
        sum += abs(dx)+abs(dy);
    }
  }
  //
  return sum;
}

long part2(std::string filename){
  // read the file
  std::vector<std::string> lines = read_lines(read_file(filename));

  std::vector<std::vector<char>> universe;
  for (int i = 0; i < lines.size(); i++) {
    // for each of the tokens, first create an array of pipes wxh
    auto row_universe = std::vector<char>();
    for (int j = 0; j < lines[i].size(); j++) {
        row_universe.push_back(lines[i][j]);
    }
    universe.push_back(row_universe);
  };

  // original universe
  std::vector<std::pair<int, int>> galaxies;
  for (int i = 0; i < universe.size(); i++) {
    auto row_universe = std::vector<char>();
    for (int j = 0; j < universe[i].size(); j++) {
        if (universe[i][j] == '#') {
            galaxies.push_back(std::pair<int, int>(j, i));
        }
    }
  };

  // Expand the universe
  auto expanded_universe = expand_universe(universe);
  std::vector<std::pair<int, int>> expanded_galaxies;
  for (int i = 0; i < expanded_universe.size(); i++) {
    auto row_universe = std::vector<char>();
    for (int j = 0; j < expanded_universe[i].size(); j++) {
        if (expanded_universe[i][j] == '#') {
            expanded_galaxies.push_back(std::pair<int, int>(j, i));
        }
    }
  };
  // print_matrix(universe);
  // print_matrix(expanded_universe);
  long long sum = 0;
  // for (int i = 0; i < galaxies.size(); i++){
  //   for (int j = i; j < galaxies.size(); j++) {
  //       auto dx = galaxies[j].first - galaxies[i].first;
  //       auto dy = galaxies[j].second - galaxies[i].second;
  //       sum += abs(dx)+abs(dy);
  //   }
  // }
  // sum = 0;
  const long long multiplier = 1000*1000;
  // check by how much the galaxies expanded when expansion = 2
  // measure the distance between each galaxy
  // this is the manhattan distance, only need to take end and start
  // std::cout << galaxies.size() << std::endl;
  for (int i = 0; i < galaxies.size(); i++){
    auto a = galaxies[i];
    auto a_prime = expanded_galaxies[i];
    for (int j = i; j < galaxies.size(); j++) {
        auto b = galaxies[j];
        auto b_prime = expanded_galaxies[j];

        long long exp_x = abs(b_prime.first-a_prime.first)-abs(b.first - a.first);
        long long exp_y = abs(b_prime.second-a_prime.second)-abs(b.second - a.second);

        long long dx = abs(b.first - a.first) + (exp_x * (multiplier-1));
        long long dy = abs(b.second - a.second) + (exp_y * (multiplier-1));

        sum += abs(dx)+abs(dy);
        if (sum == 0){
            // std::cout << a_prime.first << ", " << a_prime.second << " - ";
            // std::cout << b_prime.first << ", " << b_prime.second;
        }
    }
  }

  return sum;
}

int main(){
    // test output should be 374
    std::cout << "Part 1: Sum of distances is: " << part1("11-input-test.txt") << std::endl;
    std::cout << "Part 2: Sum of distances is: " << part2("11-input.txt") << std::endl;
    return 0;
}