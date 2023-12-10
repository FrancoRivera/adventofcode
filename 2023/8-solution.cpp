#include "utils.h"

struct node {
  std::string key;
  std::string left_key;
  std::string right_key;
  node *left;
  node *right;
};

int main() {
  // read the input
  // parse the input
  // first line is instructions (LRLRLRLR)
  // Then, after an empty line, it is a series of nodes in the format:
  // LLR
  //
  // AAA = (BBB, BBB)
  // BBB = (AAA, ZZZ)
  // ZZZ = (ZZZ, ZZZ)
  //
  //
  //

  std::vector<std::string> lines = read_lines(read_file("8-input.txt"));
  std::vector<node> nodes = std::vector<node>();
  std::string instructions = "";
  for (int i = 0; i < lines.size(); i++) {
    // instructions
    if (i == 0) {
      instructions = lines[i];
      continue;
    }
    std::string line = trim(lines[i]); // AAA = (BBB, CCC)
    if (line.size() == 0)
      continue;
    // create a new node
    node n = node();
    // std::cout << line << std::endl;
    n.key = trim(split(line, ' ')[0]);                  // AAA
    std::string connecting = trim(split(line, '=')[1]); // (BBB, CCC)
    std::string left = split(trim(split(connecting, ',')[0]), '(')[1];  // "BBB"
    std::string right = split(trim(split(connecting, ',')[1]), ')')[0]; // "CCC"

    n.left_key = left;
    n.right_key = right;
    nodes.push_back(n);
  }

  for (auto &n : nodes) {
    for (auto &v : nodes) {
      if (v.key == n.left_key) {
        n.left = &v;
      }
      if (v.key == n.right_key) {
        n.right = &v;
      }
    }
  }

  long count = 0;
  // To solve this (bruteforce)
  // repeat the "instructions", as long as needed to get to "ZZZ"

  node *curr;
  // Find node AAA
  for (auto &n : nodes) {
    if (n.key == "AAA") {
      curr = &n;
    }
  }

  while (true) {
    for (char c : instructions) {
      if (curr->key == "ZZZ") {
        // done
        // Output: how many steps are needed
        //
        // Test output: 6
        std::cout << "Steps taken: " << count << std::endl;
        exit(0);
        break;
      }
      if (c == 'L') {
        // go left
        curr = curr->left;
      } else {
        // go right
        curr = curr->right;
      }
      count++;
    }
    // if ((count / instructions.size()) % (1000 * 1000 * 1000) == 0) {
    //   std::cout << count << std::endl;
    // }
    // doesnt work for 31 thousand Million
  }
}
