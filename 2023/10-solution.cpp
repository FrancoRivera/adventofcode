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
  if (p1->c == 'S' || p2->c == 'S') {
    return true;
  };

  std::map<std::string, std::pair<char, char>> dir_map = {
      {"north", std::pair('N', 'S')}, // north
      {"south", std::pair('S', 'N')}, // south
      {"east", std::pair('E', 'W')},  // east
      {"west", std::pair('W', 'E')}   // west
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
int MAX_BFS(int start_x, int start_y,
            std::vector<std::vector<pipe *>> pipe_matrix) {
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
    std::cout << "============" << std::endl;
    std::cout << "============" << std::endl;
    std::cout << "Current " << u->c << " (" << u->dist << ")"
              << "@" << u->x << "," << u->y << std::endl;
    rem.pop();
    // size of thek
    if (u->y - 1 >= 0) {
      std::cout << "trying north";
      auto north_p = pipe_matrix[u->y - 1][u->x];
      if (north_p->visited == false && pipe_compatible(u, north_p, "north")) {
        std::cout << "-> ok " << std::endl;
        north_p->visited = true;
        north_p->dist = u->dist + 1;
        north_p->parent = u;
        rem.push(north_p);
      } else {
        // pipe not compatile
        std::cout << "-> not compat " << u->c << " AND " << north_p->c
                  << std::endl;
      }
    }
    // explor east
    if (u->x + 1 < pipe_matrix[0].size()) {
      std::cout << "trying east";
      auto east_p = pipe_matrix[u->y][u->x + 1];
      if (east_p->visited == false && pipe_compatible(u, east_p, "east")) {
        std::cout << "-> ok " << std::endl;
        east_p->visited = true;
        east_p->dist = u->dist + 1;
        east_p->parent = u;
        rem.push(east_p);
      } else {
        // pipe not compatile
        std::cout << "-> not compat " << u->c << " AND " << east_p->c
                  << std::endl;
      }
    }
    // explore south
    if (u->y + 1 < pipe_matrix.size()) {
      std::cout << "trying south";
      auto south_p = pipe_matrix[u->y + 1][u->x];
      if (south_p->visited == false && pipe_compatible(u, south_p, "south")) {
        std::cout << "-> ok " << std::endl;
        south_p->visited = true;
        south_p->dist = u->dist + 1;
        south_p->parent = u;
        rem.push(south_p);
      } else {
        // pipe not compatile
        std::cout << "-> not compat " << u->c << " AND " << south_p->c
                  << std::endl;
      }
    }
    // explore west
    if (u->x - 1 >= 0) {
      std::cout << "trying west";
      auto west_p = pipe_matrix[u->y][u->x - 1];
      if (west_p->visited == false && pipe_compatible(u, west_p, "west")) {
        std::cout << "-> ok " << std::endl;
        west_p->visited = true;
        west_p->dist = u->dist + 1;
        west_p->parent = u;
        rem.push(west_p);
      } else {
        // pipe not compatile
        std::cout << "-> not compat " << u->c << " AND " << west_p->c
                  << std::endl;
      }
    }
  }
  // get max dist instead
  //
  auto maxy = 0;

  for (int i = 0; i < pipe_matrix.size(); i++) {
    for (int j = 0; j < pipe_matrix[i].size(); j++) {
      if (pipe_matrix[j][i]->dist > maxy) {
        maxy = pipe_matrix[j][i]->dist;
      }
    }
  }
  return maxy;
}

// DFS
int MAX_DFS(int start_x, int start_y,
            std::vector<std::vector<pipe *>> pipe_matrix,
            std::vector<std::vector<bool>> *visited) {

  // check current
  auto curr = pipe_matrix[start_y][start_x];
  // mark current as visited

  std::cout << "Curr: " << curr->c << std::endl;
  if ((*visited)[start_y][start_x]) {
    // already visited
    //
    std::cout << "Already visited, explore other" << std::endl;
    return 0;
  };

  (*visited)[start_y][start_x] = true;

  // find out which pipes connect to current

  int north = 0;
  int south = 0;
  int west = 0;
  int east = 0;

  // check north
  if (start_y - 1 >= 0) {
    std::cout << "trying north";
    auto north_p = pipe_matrix[start_y - 1][start_x];
    if (pipe_compatible(curr, north_p, "north")) {
      std::cout << "-> ok " << std::endl;
      north = 1 + MAX_DFS(start_x, start_y - 1, pipe_matrix, visited);
    } else {
      // pipe not compatile
      std::cout << "-> not compat " << curr->c << " AND " << north_p->c
                << std::endl;
    }
  }
  // explor east
  if (start_x + 1 < pipe_matrix[0].size()) {
    std::cout << "trying east";
    auto east_p = pipe_matrix[start_y][start_x + 1];
    if (pipe_compatible(curr, east_p, "east")) {
      std::cout << "-> ok " << std::endl;
      east = 1 + MAX_DFS(start_x + 1, start_y, pipe_matrix, visited);
    } else {
      // pipe not compatile
      std::cout << "-> not compat " << curr->c << " AND " << east_p->c
                << std::endl;
    }
  }
  // explore south
  if (start_y + 1 < pipe_matrix.size()) {
    std::cout << "trying south";
    auto south_p = pipe_matrix[start_y + 1][start_x];
    if (pipe_compatible(curr, south_p, "south")) {
      std::cout << "-> ok " << std::endl;
      south = 1 + MAX_DFS(start_x, start_y + 1, pipe_matrix, visited);
    } else {
      // pipe not compatile
      std::cout << "-> not compat " << curr->c << " AND " << south_p->c
                << std::endl;
    }
  }
  // explore west
  if (start_x - 1 >= 0) {
    std::cout << "trying west";
    auto west_p = pipe_matrix[start_y][start_x - 1];
    if (pipe_compatible(curr, west_p, "west")) {
      std::cout << "-> ok " << std::endl;
      west = 1 + MAX_DFS(start_x - 1, start_y, pipe_matrix, visited);
    } else {
      // pipe not compatile
      std::cout << "-> not compat " << curr->c << " AND " << west_p->c
                << std::endl;
    }
  }
  // check which way is larger
  auto ns = std::max(south, north);
  auto we = std::max(west, east);

  auto mx = std::max(ns, we);

  std::cout << "popping out max" << mx << std::endl;
  curr->max = mx;
  return mx;
}

int part_1_bfs() {
  // read the file
  std::vector<std::vector<pipe *>> pipe_matrix =
      std::vector<std::vector<pipe *>>();

  pipe *start;

  for (auto line : read_lines(read_file("10-input-test-2.txt"))) {
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

  std::vector<std::vector<bool>> visited;
  std::vector<std::vector<int>> distances;
  int start_x, start_y;
  for (int i = 0; i < pipe_matrix.size(); i++) {
    auto row = pipe_matrix[i];
    auto aux_row = std::vector<bool>();
    auto aux_dist = std::vector<int>();
    for (int j = 0; j < row.size(); j++) {
      auto pipe = pipe_matrix[i][j];
      pipe->y = i;
      pipe->x = j;
      if (pipe->c == 'S') {
        start_x = j;
        start_y = i;
      }
      aux_row.push_back(false);
      aux_dist.push_back(INT16_MAX);
    }
    visited.push_back(aux_row);
    distances.push_back(aux_dist);
  }
  std::cout << visited.size() << " x " << visited[0].size() << std::endl;
  std::cout << "Starting at " << start_x << ", " << start_y << std::endl;
  std::cout << "Done parsing, starting DFS" << std::endl;
  return MAX_BFS(start_x, start_y, pipe_matrix);
}

int part_1_dfs() {
  // read the file
  std::vector<std::vector<pipe *>> pipe_matrix =
      std::vector<std::vector<pipe *>>();

  pipe *start;

  for (auto line : read_lines(read_file("10-input-test.txt"))) {
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

  std::vector<std::vector<bool>> visited;
  std::vector<std::vector<int>> distances;
  int start_x, start_y;
  for (int i = 0; i < pipe_matrix.size(); i++) {
    auto row = pipe_matrix[i];
    auto aux_row = std::vector<bool>();
    auto aux_dist = std::vector<int>();
    for (int j = 0; j < row.size(); j++) {
      auto pipe = pipe_matrix[i][j];
      if (pipe->c == 'S') {
        start_x = j;
        start_y = i;
      }
      aux_row.push_back(false);
      aux_dist.push_back(INT16_MAX);
    }
    visited.push_back(aux_row);
    distances.push_back(aux_dist);
  }
  std::cout << visited.size() << " x " << visited[0].size() << std::endl;
  std::cout << "Starting at " << start_x << ", " << start_y << std::endl;
  std::cout << "Done parsing, starting DFS" << std::endl;
  return MAX_DFS(start_x, start_y, pipe_matrix, &visited);
}

int part_1_not() {
  // read the file
  std::vector<std::vector<pipe *>> pipe_matrix =
      std::vector<std::vector<pipe *>>();
  for (auto line : read_lines(read_file("10-input-test.txt"))) {
    // for each of the tokens, first create an array of pipes wxh
    std::vector<pipe *> aux;
    for (char c : line) {
      auto p = pipe(c);
      aux.push_back(&p);
    }
    pipe_matrix.push_back(aux);

    // aux = std::vector<pipe *>();
  }

  pipe *start;
  int start_y, start_x;
  // find the single loop starting at S
  // the loop is not trivial as it contains pipes that are not connected
  // to the main loop
  //
  // | is a vertical pipe connecting north and south.
  // - is a horizontal pipe connecting east and west.
  // L is a 90-degree bend connecting north and east.
  // J is a 90-degree bend connecting north and west.
  // 7 is a 90-degree bend connecting south and west.
  // F is a 90-degree bend connecting south and east.
  // . is ground; there is no pipe in this tile.
  // S is the starting position of the animal; there is a pipe on this tile, but
  // your sketch doesn't show what shape the pipe has.

  for (int i = 0; i < pipe_matrix.size(); i++) {
    auto row = pipe_matrix[i];
    for (int j = 0; j < row.size(); j++) {
      auto pipe = row[i];
      if (pipe != nullptr) {
        if ((*pipe).c == '|') {
          if (i - 1 >= 0) {
            auto north = pipe_matrix[i - 1][j];
            // check if the pipe has a south entrance
            if (north->c == '|' || north->c == 'F' || north->c == '7') {
              (*pipe).conn1 = north;
            }
          }
          if (i + 1 < pipe_matrix.size()) {
            auto south = pipe_matrix[i + 1][j];
            // check if the pipe has a north entrance
            if (south->c == '|' || south->c == 'L' || south->c == 'J') {
              (*pipe).conn2 = south;
            }
          }
        }
        if ((*pipe).c == '-') {
          if (j - 1 >= 0)
            (*pipe).conn1 = pipe_matrix[i][j - 1];
          if (j + 1 < row.size())
            (*pipe).conn2 = pipe_matrix[i][j + 1];
        }
        if ((*pipe).c == 'L') {
          if (i - 1 >= 0)
            (*pipe).conn1 = pipe_matrix[i - 1][j];
          if (j + 1 < row.size())
            (*pipe).conn2 = pipe_matrix[i][j + 1];
        }
        if ((*pipe).c == 'J') {
          if (i - 1 >= 0)
            (*pipe).conn1 = pipe_matrix[i - 1][j];
          if (j - 1 >= 0)
            (*pipe).conn2 = pipe_matrix[i][j - 1];
        }
        if ((*pipe).c == '7') {
          if (i + 1 < pipe_matrix.size())
            (*pipe).conn1 = pipe_matrix[i + 1][j];
          if (j - 1 >= 0)
            (*pipe).conn2 = pipe_matrix[i][j - 1];
        }
        if ((*pipe).c == 'F') {
          if (i + 1 < pipe_matrix.size())
            (*pipe).conn1 = pipe_matrix[i + 1][j];
          if (j - 1 >= 0)
            (*pipe).conn2 = pipe_matrix[i][j - 1];
        }
        if ((*pipe).c == '.') {
        }
        if ((*pipe).c == 'S') {
          start = pipe;
          start_x = j;
          start_y = i;
        }
      }
    }
  }

  // S is the starting position of the animal; there is a pipe on this tile, but
  // your sketch doesn't show what shape the pipe has.
  // find out the connections on S
  if (start) {
    // check left
    if ((*pipe_matrix[start_y][start_x - 1]).c == 'F' ||
        (*pipe_matrix[start_y][start_x - 1]).c == 'L' ||
        (*pipe_matrix[start_y][start_x - 1]).c == '-') {
      // (*start).conn1 =
    }
    if (pipe_matrix[start_y][start_x - 1]) {
    }
    if (pipe_matrix[start_y][start_x - 1]) {
    }
    if (pipe_matrix[start_y][start_x - 1]) {
    }
  }

  // create a graph of that loop
  // do floyd warshall to get the furthest point
  // return highest point in loop
  //
  // output for test  is 8
  return 0;
}

int main() {

  compat_map = {
      {'|', {'N', 'S'}}, {'-', {'E', 'W'}}, {'L', {'N', 'E'}},
      {'J', {'N', 'W'}}, {'7', {'S', 'W'}}, {'F', {'S', 'E'}},
  };

  auto part1 = part_1_bfs();
  // output should be 8 for test
  std::cout << "solution for part 1: " << part1 << std::endl;
  // part_2();
}