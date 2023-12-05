#include <vector>
#include <iostream>
#include <fstream>


std::ifstream read_file(std::string filename);
std::vector<std::string> read_lines(std::ifstream input);
std::vector<std::string> split(const std::string &s, char delim);

std::string& trim(std::string& s, const char* t = " \t\n\r\f\v");