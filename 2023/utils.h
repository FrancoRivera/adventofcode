#include <vector>
#include <iostream>
#include <fstream>

using namespace std;

ifstream read_file(string filename);
vector<string> read_lines(ifstream input);
vector<string> split(const string &s, char delim);

std::string& trim(std::string& s, const char* t = " \t\n\r\f\v");