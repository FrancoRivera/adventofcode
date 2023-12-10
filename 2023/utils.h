#include <vector>
#include <iostream>
#include <fstream>


// read files into a ifstream, tip: use it in conj with read_lines
std::ifstream read_file(std::string filename);

// given a stream of data return it a list of strings.
// we do not parse at all the input, so careful with empty chars
std::vector<std::string> read_lines(std::ifstream input);

// split a string by a char delimiter
std::vector<std::string> split(const std::string &s, char delim);

// trim any unwanted characters, by default, it is empty spaces
std::string& trim(std::string& s, const char* t = " \t\n\r\f\v");
