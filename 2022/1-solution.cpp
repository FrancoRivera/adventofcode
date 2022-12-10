 #include <fstream>
#include <iostream>
#include <vector>
#include <utility>

int main() {
  std::string filename = "1-input.txt";
  std::ifstream input(filename);

  if (!input.is_open()) {
    std::cerr << "Couldn't read file: " << filename << "\n";
    return 1;
  }

  std::vector<std::string> lines;

  std::vector<int> elves;
  int biggest = 0;
  int curr = 0;
  for (std::string line; std::getline(input, line);) {
    if (line != "") {
      curr += stoi(line);
    } else{
      elves.push_back(curr);
      curr = 0;
    }
    // // Move the value of line into lines
    // lines.push_back(std::move(line));
  }

  std::cout << "Size of elves: " << elves.size() << "\n";
  // sort evles by calories
  sort(elves.begin(), elves.end(), std::greater<int>());

  // get the top three and add them up
  std::cout << "The elve with the most calories has: " <<  elves[0] << "\n";

  std::cout << "The sum of the three elves with the most calories has: " <<  elves[0] + elves[1] + elves[2] << "\n";
}