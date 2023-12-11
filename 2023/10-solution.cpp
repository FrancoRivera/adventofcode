#include "utils.h"
#include <cmath>
#include <cstdint>
#include <map>
#include <queue>

struct pipe {
  char c;
  int x;
  int y;
  pipe *parent;
  bool visited;
  int dist;
  int max;
  pipe *conn1;
  pipe *conn2;
  pipe(char _c) {
    c = _c;
    visited = false;
    dist = -1;
  }
};

std::map<char, std::vector<char>> compat_map;

bool pipe_compatible(pipe *p1, pipe *p2, std::string direction) {
  if (p1->c == '.' || p2->c == '.') {
    return false;
  };

  std::map<std::string, std::pair<char, char>> dir_map = {
      {"north", std::pair<char, char>('N', 'S')}, // north
      {"south", std::pair<char, char>('S', 'N')}, // south
      {"east", std::pair<char, char>('E', 'W')},  // east
      {"west", std::pair<char, char>('W', 'E')}   // west
  };

  // std::cout << "Direction " << direction << std::endl;
  auto dir = dir_map[direction];
  // std::cout << "dirs " << dir.first << " to " << dir.second << std::endl;
  // std::cout << "p1 " << p1->c << " to " << p2->c << std::endl;
  auto p1Entries = compat_map[p1->c];
  auto out_ok = false;
  for (auto e : p1Entries) {
    if (e == dir.first) {
      out_ok = true;
    };
  }
  if (p1->c == 'S') {
    out_ok = true;
  }
  auto in_ok = false;
  auto p2Entries = compat_map[p2->c];
  for (auto e : p2Entries) {
    if (e == dir.second) {
      in_ok = true;
    };
  }
  return in_ok && in_ok == out_ok;
}

// BFS
int MAX_BFS(int start_x, int start_y, std::vector<std::vector<pipe *>> pipe_matrix) {
  const bool DEBUG = false;
  // check current
  auto curr = pipe_matrix[start_y][start_x];
  curr->visited = true;
  curr->dist = 0;
  curr->parent = nullptr;

  std::queue<pipe *> rem = std::queue<pipe *>();
  rem.push(curr);

  while (!rem.empty()) {
    // remove u from queue
    auto u = rem.front();
    if(DEBUG){
      std::cout << "============" << std::endl;
      std::cout << "============" << std::endl;
      std::cout << "Current " << u->c << " (" << u->dist << ")"
                << "@" << u->x << "," << u->y << std::endl;
    }
    // get directions to try
    rem.pop();

    std::pair<int, int> north = std::pair<int, int>(-1, 0);
    std::pair<int, int> south = std::pair<int, int>(1, 0);
    std::pair<int, int> east = std::pair<int, int>(0, 1);
    std::pair<int, int> west = std::pair<int, int>(0, -1);

    std::vector<std::pair<int, int>> pairs = {north, south, east, west};
    std::string order[4] = {"north", "south", "east", "west"};

    int conn_count = 0;
    for (int i = 0; i < 4; i++) {
      auto p = pairs[i];
      if (u->y + p.first >= 0 && u->y + p.first < pipe_matrix.size() &&
          u->x + p.second >= 0 && u->x + p.second < pipe_matrix[0].size()) {

        auto v = pipe_matrix[u->y + p.first][u->x + p.second];
        if (DEBUG) {
          std::cout << "Trying " << order[i];
        }
        if (v->visited != false) {
          if (DEBUG) {
            std::cout << "-> visited already" << std::endl;
          }
        } else {
          if (pipe_compatible(u, v, order[i])) {
            if (DEBUG) {
              std::cout << "-> ok " << std::endl;
            }
            v->visited = true;
            v->dist = u->dist + 1;
            v->parent = u;
            conn_count++;
            rem.push(v);
          } else {
            // pipe not compatile
            if (DEBUG) {
              std::cout << "-> not compat " << u->c << " AND " << v->c
                        << std::endl;
            }
          }
        }
      }
    }
    if (conn_count > 2) {
      std::cout << conn_count << std::endl;
      exit(0);
    }
  }
  // get max dist instead
  //
  auto maxy = 0;

  for (int i = 0; i < pipe_matrix.size(); i++) {
    for (int j = 0; j < pipe_matrix[i].size(); j++) {
      if (pipe_matrix[i][j]->dist > maxy) {
        maxy = pipe_matrix[i][j]->dist;
      }
      // print the matrix
      // std::cout << pipe_matrix[i][j]->dist / 1000;
    }
    // std::cout << std::endl;
  }
  return maxy;
}

int part_1_bfs() {
  // read the file
  std::vector<std::vector<pipe *>> pipe_matrix =
      std::vector<std::vector<pipe *>>();

  pipe *start;

  for (auto line : read_lines(read_file("10-input.txt"))) {
    // for each of the tokens, first create an array of pipes wxh
    std::vector<pipe *> aux;
    for (char c : line) {
      auto p = new pipe(c);
      aux.push_back(p);
      if (c == 'S') {
        start = p;
      }
    }
    pipe_matrix.push_back(aux);
  }

  std::cout << " Done reading" << std::endl;

  // std::vector<std::vector<bool>> visited;
  // std::vector<std::vector<int>> distances;
  int start_x, start_y;
  for (int i = 0; i < pipe_matrix.size(); i++) {
    auto row = pipe_matrix[i];
    // auto aux_row = std::vector<bool>();
    // auto aux_dist = std::vector<int>();
    for (int j = 0; j < row.size(); j++) {
      auto pipe = pipe_matrix[i][j];
      pipe->y = i;
      pipe->x = j;
      if (pipe->c == 'S') {
        start_x = j;
        start_y = i;
      }
      // aux_row.push_back(false);
      // aux_dist.push_back(INT16_MAX);
    }
    // visited.push_back(aux_row);
    // distances.push_back(aux_dist);
  }
  std::cout << "Starting at " << start_x << ", " << start_y << std::endl;
  std::cout << "Done parsing, starting BFS" << std::endl;
  return MAX_BFS(start_x, start_y, pipe_matrix);
}

// Part 2
//
int part_2(std::string filename) {
  // find out what nodes form the loop
  //
  // read the file
  std::vector<std::vector<pipe *>> pipe_matrix =
      std::vector<std::vector<pipe *>>();

  pipe *start;

  for (auto line : read_lines(read_file(filename))) {
    // for each of the tokens, first create an array of pipes wxh
    std::vector<pipe *> aux;
    for (char c : line) {
      auto p = new pipe(c);
      aux.push_back(p);
      if (c == 'S') {
        start = p;
      }
    }
    pipe_matrix.push_back(aux);
  }

  std::cout << " Done reading" << std::endl;

  int start_x, start_y;
  for (int i = 0; i < pipe_matrix.size(); i++) {
    auto row = pipe_matrix[i];
    for (int j = 0; j < row.size(); j++) {
      auto pipe = pipe_matrix[i][j];
      pipe->y = i;
      pipe->x = j;
      if (pipe->c == 'S') {
        start_x = j;
        start_y = i;
      }
    }
  }
  std::cout << "Starting at " << start_x << ", " << start_y << std::endl;
  std::cout << "Done parsing, starting BFS" << std::endl;

  // RUN BFS
  // do BFS get the last node (min dist)
  MAX_BFS(start_x, start_y, pipe_matrix);

  pipe *last;
  for (int i = 0; i < pipe_matrix.size(); i++) {
    for (int j = 0; j < pipe_matrix[i].size(); j++) {
      if (pipe_matrix[i][j]->dist >= last->dist) {
        // std::cout << "Setting last to be: " << last->dist;
        last = pipe_matrix[i][j];
        // std::cout << " - " << last->dist  << " - "  << last->x << ", " << last->y << std::endl;
      }
    }
  }

  // after that, check for neighboring nodes to find out where is the
  // continuation
  std::pair<int, int> north = std::pair<int, int>(-1, 0);
  std::pair<int, int> south = std::pair<int, int>(1, 0);
  std::pair<int, int> east = std::pair<int, int>(0, 1);
  std::pair<int, int> west = std::pair<int, int>(0, -1);

  std::vector<std::pair<int, int>> pairs = {north, south, east, west};
  std::string order[4] = {"north", "south", "east", "west"};

  std::vector<pipe *> loop;
  int conn_count = 0;
  for (int i = 0; i < 4; i++) {
    auto p = pairs[i];
    if (last->y + p.first >= 0 && last->y + p.first < pipe_matrix.size() &&
        last->x + p.second >= 0 && last->x + p.second < pipe_matrix[0].size()) {
      auto v = pipe_matrix[last->y + p.first][last->x + p.second];
      std::cout << "Trying " << order[i];
      if (pipe_compatible(last, v, order[i]) && last->parent != v) {
        std::cout << "-> ok " << std::endl;
        loop.push_back(v);
      } else {
        // pipe not compatile
        std::cout << "-> not compat " << last->c << " AND " << v->c
                  << std::endl;
      }
    }
  }

  // // add all pipes parents until reaching S
  pipe *curr = loop.back();
  while (curr != start) {
    curr = curr->parent;
    loop.push_back(curr);
  }

  curr = last;
  while (curr != start) {
    curr = curr->parent;
    if (curr == start) continue;
    loop.push_back(curr);
  }

  for (auto p : loop) {
    std::cout << "pipe: " << p->x << ", " << p->y << "-" << p->c << std::endl;
  }

  // replace S with proper pipe in order to know which pipe it is
  // check all sides of S and see which of them have pipes, then replace S with appropiate tyep of pipe
  std::vector<char> out_of_s;
  bool has_north, has_south, has_east, has_west = false;
  for (auto p : loop) {
    if (start->y - 1 > 0 && pipe_matrix[start->y - 1][start->x] == p) {
      has_north = true;
    }
    if (start->y + 1 < pipe_matrix.size() && pipe_matrix[start->y + 1][start->x] == p) {
      has_south = true;
    }
    if (start->x + 1 < pipe_matrix[0].size() && pipe_matrix[start->y][start->x+1] == p) {
      has_east = true;
    }
    if (start->x -1 > 0 && pipe_matrix[start->y][start->x-1] == p) {
      has_west = true;
    }
  }

  if (has_north && has_south){
    start->c = '|';
  }
  if (has_north && has_west){
    start->c = 'J';
  }
  if (has_north && has_east){
    start->c = 'L';
  }
  if (has_south && has_west){
    start->c = '7';
  }
  if (has_south && has_east){
    start->c = 'F';
  }
  std::cout << "Start should be" << start->c << std::endl;

  std::cout << "Loop consists of " << loop.size() << " pipes" << std::endl;
  // To get if the point is bounded or not
  // for every point (a,b) in the matrix
  auto inside = 0;
  for (int i = 0; i < pipe_matrix.size(); i++){
    for (int j = 0; j < pipe_matrix[0].size(); j++) {
      std::cout << " @ " << i << ", " << j << " " << pipe_matrix[i][j]->c << " - " << std::endl;
      float count_n = 0.0;
      float count_e = 0.0;
      float count_s = 0.0;
      float count_w = 0.0;
      bool is_pipe = false;
      for (auto p : loop) {
        if (p->x == j && p->y == i) {
          is_pipe = true;
        }
        // check north
        if (p->x == j && p->y < i) {
          if (p->c == '-') {
            count_n++;
          }
          if (p->c == '7' || p->c == 'L') {
            count_n += 0.5;
          }
          if (p->c == 'F' || p->c == 'J') {
            count_n -= 0.5;
          }
        }
        // check south
        if (p->x == j && p->y > i ) {
          if (p->c == '-') {
            count_s++;
          }
          if (p->c == '7' || p->c == 'L') {
            count_s += 0.5;
          }
          if (p->c == 'F' || p->c == 'J') {
            count_s -= 0.5;
          }
        }
        // check east
        if (p->y == i && p->x > j) {
          if (pipe_matrix[i][j]->c == 'I'){
            std::cout << p->c << " " << std::endl;
          }
          if (p->c == '|') {
            count_e++;
          }
          if (p->c == '7' || p->c == 'L') {
            count_e += 0.5;
          }
          if (p->c == 'F' || p->c == 'J') {
            count_e -= 0.5;
          }
        }

        // check west
        if (p->y == i && p->x < j) {
          if (p->c == '|') {
            count_w++;
          }
          if (p->c == '7' || p->c == 'L') {
            count_w += 0.5;
          }
          if (p->c == 'F' || p->c == 'J') {
            count_w -= 0.5;
          }
        }
      }
      std::cout << count_n << ", " << count_e << ", " << count_s << ", " << count_w << std::endl;

      // if all the counts are odd, it is withi, if not it is without
      if (
        is_pipe == false &&
        int(count_n) % 2 != 0 &&
        int(count_s) % 2 != 0 &&
        int(count_e) % 2 != 0 &&
        int(count_w) % 2 != 0){
        std::cout << "yeah @ " << i << ", " << j << " " << pipe_matrix[i][j]->c << std::endl;
        inside++;
      }
    }
  }
  std::cout << inside << std::endl;
  exit(0);
  return inside;
}

int main() {

  compat_map = {
      {'|', {'N', 'S'}}, {'-', {'E', 'W'}}, {'L', {'N', 'E'}},
      {'J', {'N', 'W'}}, {'7', {'S', 'W'}}, {'F', {'S', 'E'}},
  };

  auto part1 = part_1_bfs();
  // output should be 8 for test
  std::cout << "solution for part 1: " << part1 << std::endl;
  std:: cout << part_2("10-input.txt") << std::endl;

  return 1;
}