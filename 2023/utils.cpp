#include <array>
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>

using namespace std;

ifstream read_file(string filename) {
  ifstream input(filename);

  if (!input.is_open()) {
    cerr << "Could'nt read file " << filename << "\n";
    exit(1);
  }
  return input;
}

vector<string> read_lines(ifstream input) {
  vector<string> lines;
  for (string line; getline(input, line);) {
    lines.push_back(line);
  };
  return lines;
}

vector<string> split(const string &s, char delim) {
  vector<string> result;
  stringstream ss(s);
  string item;

  while (getline(ss, item, delim)) {
    result.push_back(item);
  }

  return result;
}
/**
 * Remove surrounding whitespace from a std::string.
 * @param s The string to be modified.
 * @param t The set of characters to delete from each end
 * of the string.
 * @return The same string passed in as a parameter reference.
 */
std::string &trim(std::string &s, const char *t = " \t\n\r\f\v") {
  s.erase(0, s.find_first_not_of(t));
  s.erase(s.find_last_not_of(t) + 1);
  return s;
}

// join a vector into a string
std::string join(const std::vector<int> &s, char delim) {
  std::string aux = "";
  for (auto &i : s) {
    aux += std::to_string(i) + ", ";
  }
  return aux;
}