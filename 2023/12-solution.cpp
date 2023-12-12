
// Problem: fint the amount of possible valid permuations of a string
// Input:
// ???.### 1,1,3
//
// By replacing the ? with either . or # make it so that the numbers match the groups of #

#include "utils.h"
#include <assert.h>


// Input: #.#.### 1,1,3
// output: valid
bool check_if_valid(std::string pattern, std::vector<int> group_broken_springs){
    std::vector<int> broken_groups;
    auto broken_count = 0;
    for (char c : pattern){
        if (c=='#'){
            broken_count++;
        }
        if (c=='.'){
            if (broken_count > 0){
                broken_groups.push_back(broken_count);
            }
            broken_count = 0;
        }
    }
    if (broken_count > 0) {
        broken_groups.push_back(broken_count);
    }

    if (broken_groups.size() != group_broken_springs.size()) {
        return false;
    }
    for (int i = 0; i < broken_groups.size(); i++){
        if (broken_groups[i] != group_broken_springs[i]){
            return false;
        }
    }
    return true;
}

// Input: ?#?#?#?#?#?#?#?
// Output: [
// .#.#.#.#.#.#.#.   // all dots
// .#.#.#.#.#.#.##
// .#.#.#.#.#.###.
// .#.#.#.#.###.#.
// .#.#.#.###.#.#.
// .#.#.###.#.#.#.
// .#.###.#.#.#.#.
// .###.#.#.#.#.#.
// ##.#.#.#.#.#.#.
// ...
// .#.#.#.#.#.#.#.
// ...256 results in total
// ]
std::vector<std::string> create_all_possible_patterns(std::string pattern){
    // for a given set of ?, we can convert it to a binary of length len(?)
    // then we can iterate from 0000 (len?) until 1111 length(?) and for each of those
    // get if the byte is set or not, and add it to the possible patterns list

    std::vector<std::string> possible_patterns;

    // get the amount of ? in the string
    auto unknown_count = 0;
    for (char c: pattern){
        if (c == '?') {
            unknown_count++;
        }
    }
    // 100000 - 1 = 11111
    // (1 << (unknown_count+1) - 1 )

    // std::cout << "Unknown count " <<  unknown_count << std::endl;
    // std::cout << "top int  " <<  (1 << (unknown_count)) - 1 << std::endl;

    for (int i = 0; i <= (1 << (unknown_count))- 1; i++){
        auto unknown_count_temp = 0;
        auto temp_pattern = pattern;
        for (int j = 0; j < pattern.size(); j++) {
            if (pattern[j] == '?'){
                // check if the bit is set at unknown_count - unknown_count_temp position or not
                if (i & ( 1 << (unknown_count - unknown_count_temp - 1) )){
                    // bit is set
                    temp_pattern[j] = '#';
                } else{
                    // bit is not set
                    temp_pattern[j] = '.';
                }
                unknown_count_temp++;
            }
        } // end of pattern for
        // std::cout << "Possible pattern " << temp_pattern << std::endl;
        possible_patterns.push_back(temp_pattern);
    } // end of for count
    return possible_patterns;
}


long part1(std::string filename){
    // parse the file into lines

    long arrangements = 0;

    // for each line find out possible permutations
    for (auto l: read_lines(read_file(filename))){
        auto pattern = split(l, ' ')[0];
        auto groups_of_broken_springs_str = split(split(l, ' ')[1], ',');
        std::vector<int> groups_of_broken_springs;

        for (auto g: groups_of_broken_springs_str){
            groups_of_broken_springs.push_back(stoi(g));
        }
        auto patterns = create_all_possible_patterns(pattern);
        for (auto p: patterns){
            if (check_if_valid(p, groups_of_broken_springs)){
                arrangements++;
            };
        }
    }

    // return num of arrangements
    return arrangements;
};

int main(int argc, char *argv[]) {
    assert(create_all_possible_patterns("?#?#?#?#?#?#?#?").size() == 256 );
    auto groups = std::vector<int>{1,1,3};
    assert(check_if_valid("#.#.###", groups));

    assert(part1("12-input-test.txt") == 21);
    std::cout << part1("12-input.txt") << std::endl;

    return 0;
}