
// Problem: fint the amount of possible valid permuations of a string
// Input:
// ???.### 1,1,3
//
// By replacing the ? with either . or # make it so that the numbers match the groups of #

#include "utils.h"
#include <assert.h>
#include <functional>
// Input: #.#.### 1,1,3
// output: true
bool check_if_valid_fast(std::string pattern, std::vector<int> group_broken_springs){
    std::vector<int> broken_groups;
    auto broken_count = 0;
    auto broken_group_count = 0;
    for (char c : pattern){
        if (c=='#'){
            broken_count++;
        }
        if (c=='.'){
            if (broken_count > 0){
                broken_groups.push_back(broken_count);
                if (broken_count != group_broken_springs[broken_group_count]){
                    // std::cout << pattern << " - false ici" << std::endl;
                    return false;
                }
                broken_group_count++;
            }
            broken_count = 0;
        }
    }
    if (broken_count > 0) {
        broken_groups.push_back(broken_count);
        if (broken_count != group_broken_springs[broken_group_count]) {
            // std::cout << pattern << " - false" << std::endl;
            return false;
        }
    }
    if (broken_groups.size() != group_broken_springs.size()) {
        // std::cout << pattern << " - false here" << std::endl;
        return false;
    }

    for (int i = 0; i < broken_groups.size(); i++){
        if (broken_groups[i] != group_broken_springs[i]){
            return false;
        }
    }
    return true;
}

bool check_if_valid(std::string pattern, std::vector<int> group_broken_springs){
    std::vector<int> broken_groups;
    auto broken_count = 0;
    auto broken_group_count = 0;
    for (char c : pattern){
        if (c=='#'){
            broken_count++;
        }
        if (c=='.'){
            if (broken_count > 0){
                broken_groups.push_back(broken_count);
                // if (broken_count != group_broken_springs[broken_group_count]){
                //     // std::cout << pattern << " - false ici" << std::endl;
                //     return false;
                // }
                // broken_group_count++;
            }
            broken_count = 0;
        }
    }
    if (broken_count > 0) {
        broken_groups.push_back(broken_count);
        // if (broken_count != group_broken_springs[broken_group_count]) {
        //     // std::cout << pattern << " - false" << std::endl;
        //     return false;
        // }
    }
    if (broken_groups.size() != group_broken_springs.size()) {
        // std::cout << pattern << " - false here" << std::endl;
        return false;
    }

    for (int i = 0; i < broken_groups.size(); i++){
        if (broken_groups[i] != group_broken_springs[i]){
            return false;
        }
    }
    return true;
}


long create_and_check_patterns(std::string pattern, std::vector<int> group_broken_springs){
    // for a given set of ?, we can convert it to a binary of length len(?)
    // then we can iterate from 0000 (len?) until 1111 length(?) and for each of those
    // get if the byte is set or not, and add it to the possible patterns list

    long valid_patterns = 0;

    // get the amount of ? in the string
    uint64_t unknown_count = 0;
    for (char c: pattern){
        if (c == '?') {
            unknown_count++;
        }
    }
    // 100000 - 1 = 11111
    // (1 << (unknown_count+1) - 1 )

    std::cout << "Unknown count " <<  unknown_count << std::endl;
    std::cout << "types of patterns " <<  (1 << (unknown_count)) - 1 << std::endl;
    exit(0);

    for (uint64_t i = 0; i <= (1 << (unknown_count))- 1; i++){
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
        std::cout << i << " pos patt " << temp_pattern;
        auto is_valid_fast = check_if_valid_fast(temp_pattern, group_broken_springs);
        auto is_valid = check_if_valid(temp_pattern, group_broken_springs);
        if (is_valid != is_valid_fast){
            std::cout << "- fails on this sample "<< std::endl;
            exit(0);
        }
        if (is_valid){
           valid_patterns++;
        } else{
            std::cout << "- not valid "<< std::endl;
        }
    } // end of for count
    // std::cout << " - " << valid_patterns << std::endl;
    return valid_patterns;
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
    // std::cout << "types of patterns " <<  (1 << (unknown_count)) - 1 << std::endl;

    for (uint i = 0; i <= (1 << (unknown_count))- 1; i++){
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
            auto is_valid =  check_if_valid_fast(p, groups_of_broken_springs);
            if (is_valid){
                arrangements++;
            };
        }
    }

    // return num of arrangements
    return arrangements;
};

int part2(std::string filename){
    // parse the file into lines

    long arrangements = 0;

    // for each line find out possible permutations
    for (auto l: read_lines(read_file(filename))){
        auto pattern = split(l, ' ')[0];
        auto broken_springs = split(l, ' ')[1];

        // lets try the bruteforcy way, it doesnt work xd
        pattern = pattern + "?" + pattern + "?" + pattern + "?" + pattern +
                  "?" + pattern;
        broken_springs = broken_springs + "," + broken_springs + "," +
                         broken_springs + "," + broken_springs + "," +
                         broken_springs;

        std::vector<int> groups_of_broken_springs;
        auto groups_of_broken_springs_str = split(broken_springs, ',');

        for (auto g : groups_of_broken_springs_str) {
            groups_of_broken_springs.push_back(stoi(g));
        }
        std::cout << pattern << " - " << broken_springs << std::endl;
        arrangements += create_and_check_patterns(pattern, groups_of_broken_springs);

        // this creates a shitton of patterns, change it to be an iterator of some sorts
        // if this was go program i would create a channel to pass hte info to the
        // "checker" worker
        // auto patterns = create_all_possible_patterns(pattern);

        // std::cout << "Possible patterns: " << patterns.size() << std::endl;
        // // this takes an awful amount of time, we need to do some divide and conquer stuff
        // for (auto p: patterns){
        //     if (check_if_valid(p, groups_of_broken_springs)){
        //         arrangements++;
        //     };
        // }
        // std::cout << "." << std::endl;
    }

    // return num of arrangements
    return arrangements;
}

int main(int argc, char *argv[]) {
    // sanity checks
    assert(create_all_possible_patterns("?#?#?#?#?#?#?#?").size() == 256 );
    auto groups = std::vector<int>{1,1,3};
    assert(check_if_valid_fast("#.#.###", groups));

    auto groups2 = std::vector<int>{3,2,1};
    assert(check_if_valid_fast(".###.##.#...", groups2));

    // Part 1
    // std::cout << part1("12-input-test.txt") << std::endl;
    assert(part1("12-input-test.txt") == 21);
    std::cout << part1("12-input.txt") << std::endl;

    // Part 2
    auto groups3 = std::vector<int>{1,3,1,6, 1,3,1,6, 1,3,1,6, 1,3,1,6, 1,3,1,6};
    assert((create_and_check_patterns("?#?#?#?#?#?#?#???#?#?#?#?#?#?#???#?#?#?#?#?#?#???#?#?#?#?#?#?#???#?#?#?#?#?#?#?", groups3)) == 1);
    assert(part2("12-input-test.txt") == 525152);
    std::cout << " Done with test" << std::endl;
    std::cout << part2("12-input.txt") << std::endl;

    return 0;
}