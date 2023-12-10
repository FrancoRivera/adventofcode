#include "utils.h"
#include <algorithm>
#include <set>

struct node {
  std::string key;
  std::string left_key;
  std::string right_key;
  node *left;
  node *right;
  int recurrence;
};

std::vector<int> get_primes_until(int max_prime) {
  std::vector<int> primes = std::vector<int>();
  for (int i = 1; i < max_prime; i++) {
    bool is_prime = true;
    for (int j = 1; j < i / 2; j++) {
      if (i % j == 0 && i != j && j > 1) {
        is_prime = false;
      }
    }
    if (is_prime) {
      primes.push_back(i);
    }
  }
  return primes;
}

std::vector<int> prime_decomp(int number, std::vector<int> primes) {
  std::vector<int> decomp = std::vector<int>();
  for (auto &p : primes) {
    if (number % p == 0) {
      decomp.push_back(p);
    }
  }
  return decomp;
};

int find_recurrence(node *n, std::string instructions) {
  long steps = 0;
  bool DEBUG = false;
  while (true) {
    for (char c : instructions) {
      if (DEBUG)
        std::cout << "Step ===== " << steps << std::endl;
      if (DEBUG)
        std::cout << n->key << " -> ";
      if (n->key[2] == 'Z') {
        if (DEBUG) {
          std::cout << "FOUND" << std::endl;
          std::cout << n->key << " -> ";
          // record steps needed for this node, remove the node
          std::cout << n->key << " Rec " << steps << std::endl;
        }
        return steps;
      } else {
      }
      if (c == 'L') {
        // go left
        *n = *n->left;
      } else {
        // go right
        *n = *n->right;
      }
      if (DEBUG)
        std::cout << n->key << std::endl;
      // if (steps % 10000000 == 0) {
      //   std::cout << "Steps taken: " << steps << std::endl;
      // }
      steps++;
    };
  }
  return 0;
}

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

  // To solve this (bruteforce)
  // repeat the "instructions", as long as needed to get to "ZZZ"

  std::vector<node *> starting_nodes = std::vector<node *>();
  // Find all nodes with XXA
  for (auto &n : nodes) {
    if (n.key[2] == 'A') {
      starting_nodes.push_back(&n);
    }
  }

  const bool DEBUG = false;
  long prod = 1;
  std::vector<long> mcm = std::vector<long>();
  for (auto &n : starting_nodes) {
    mcm.push_back(find_recurrence(n, instructions));
  }
  std::sort(begin(mcm), end(mcm));
  std::cout << "We need to find the MCM of: ";
  for (auto &n : mcm) {
    std::cout << n << ", ";
  }
  std::cout << std::endl;

  auto primes = get_primes_until(20000);
  // std::cout << "Primes less than 20_000" << join(primes, ' ')
  //<< std::endl;

  std::set<int> prime_set;
  for (auto &n : mcm) {
    std::cout << "Primes decomp is " << n << std::endl;
    std::cout << join(prime_decomp(n, primes), ' ') << std::endl;
    // add to set
    for (auto &p : prime_decomp(n, primes)) {
      prime_set.insert(p);
    }
  }
  for (auto &p : prime_set) {
    std::cout << p << ' ';
    prod *= p;
  }
  std::cout << std::endl;
  std::cout << "Steps needed: " << prod << std::endl;
}
