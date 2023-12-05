#include <fstream>
#include <iostream>
#include <vector>
#include <utility>

#include "utils.h"

using namespace std;

struct range
{
  long start;
  long dest;
  long length;
  range(long _start, long _dest, long _length)
  {
    start = _start;
    dest = _dest;
    length = _length;
  };
};

const bool DEBUG = false;

int main()
{
  long minLoc = LONG_MAX; // a very big number

  vector<long> seeds = {};
  vector<vector<range>> filters = {};
  auto next_map_title = false;
  auto aux_filter_vector = vector<range>();
  // iterate over every line in the input
  for (std::string line : read_lines(read_file("5-input.txt")))
  {
    // get map for each of the categories
    // first line are our seeds
    // seeds: 79 14 55 13
    if (seeds.size() == 0)
    {
      line = split(line, ':')[1];
      trim(line);
      auto seedStrings = split(line, ' ');
      for (auto &s : seedStrings)
      {
        seeds.push_back(stol(s));
      }
      continue;
      // cout << "finished parsing seeds"  << endl;
    }
    if (next_map_title)
    {
      next_map_title = false;
      // create a new vector
      aux_filter_vector = vector<range>();
      continue;
    }
    // get the first map
    if (line == "")
    {
      if (aux_filter_vector.size())
      {
        filters.push_back(aux_filter_vector);
      }
      next_map_title = true;
      continue;
    }
    // extract the ranges
    auto params = split(line, ' ');
    auto r = range(stol(params[1]), stol(params[0]), stol(params[2]));
    aux_filter_vector.push_back(r);
  }

  // push whatever it was left if its not empty
  if (aux_filter_vector.size())
  {
    filters.push_back(aux_filter_vector);
  }

  // create the seed ranges from the seed line
  vector<range> seed_ranges = vector<range>();
  range aux = range(0, 0, 0);
  for (auto &seed : seeds)
  {
    if (aux.start == 0)
    {
      aux.start = seed;
      continue;
    }
    else
    {
      aux.length = seed;
      seed_ranges.push_back(aux);
      aux = range(0, 0, 0);
    }
  }

  // iterate over every map of filters
  for (auto &filter : filters)
  {
    if (DEBUG)
      cout << ">>>>>> Filter" << endl;
    auto aux_seed_ranges = vector<range>();
    // create a stack of ranges to apply filters to.
    while (seed_ranges.size())
    {
      if (DEBUG)
        cout << "(" << seed_ranges.size() << ")" << endl;
      range seed_range = seed_ranges.back();
      seed_ranges.pop_back();

      if (DEBUG)
        cout << "=========================" << endl;
      if (DEBUG)
        cout << seed_range.start << " " << seed_range.length << endl;
      auto noOverlap = true;

      // There are several kinds of range overlaps that can occur:
      // 1. Type: Seed right of filter, only partial overlap
      // Seed:        [     ]
      // Filter:   [     ]
      //
      // 2. Type: Seed right of filter, fully overlapped (contained)
      // Seed:        [  ]
      // Filter:   [     ]
      //
      // 3. Type: Seed left of filter, partially overlapped
      // Seed:   [    ]
      // Filter:   [     ]
      //
      // 4. Type: Seed left of filter, filter fully overlapped (contained)
      // Seed:    [     ]
      // Filter:   [   ]
      for (auto &filter_range : filter)
      {
        if (DEBUG)
          cout << " " << filter_range.start << " " << filter_range.length << " " << filter_range.dest << endl;
        auto frange_end = filter_range.start + filter_range.length;
        auto seed_end = seed_range.start + seed_range.length;
        // Types 1 and 2
        if (seed_range.start >= filter_range.start && frange_end > seed_range.start)
        {
          if (DEBUG)
            cout << "  -------" << endl;
          if (DEBUG)
            cout << "  overlap 1" << endl;
          noOverlap = false;
          // Type 1: partially enclosed
          if (frange_end < seed_end)
          {
            if (DEBUG)
              cout << " partial" << endl;
            auto nlength = frange_end - seed_range.start;
            auto overlap = range(seed_range.start, 0, nlength);
            // shift overlap according to filter
            overlap.start = filter_range.dest + overlap.start - filter_range.start;
            aux_seed_ranges.push_back(overlap);
            auto nstart = seed_range.start + nlength;
            if (seed_end > nstart)
            {
              auto nrange2 = range(nstart, 0, seed_end - nstart);
              if (DEBUG)
                cout << "    bit after " << nrange2.start << " " << nrange2.length << endl;
              seed_ranges.push_back(nrange2);
            }
          }
          // Type 2: fully enclosed
          if (frange_end >= seed_end)
          {
            if (DEBUG)
              cout << " fully" << endl;
            // everything is an overlap
            auto overlap = seed_range;
            overlap.start = filter_range.dest + overlap.start - filter_range.start;

            aux_seed_ranges.push_back(overlap);
          }
        }
        // Types 3 and 4
        if (seed_range.start < filter_range.start && filter_range.start < seed_end)
        {
          if (DEBUG)
            cout << "  overlap 2" << endl;
          noOverlap = false;
          // Type 3: partially enclosed
          if (frange_end > seed_end)
          {
            if (DEBUG)
              cout << "   partial" << endl;
            auto nlength = seed_end - filter_range.start;
            auto overlap = range(filter_range.dest, 0, nlength);
            aux_seed_ranges.push_back(overlap);
            // not overlapped
            auto not_overlapped = range(seed_range.start, 0.0, filter_range.start - seed_range.start);
            seed_ranges.push_back(not_overlapped);
          }
          // Type 4: fully enclosed
          if (seed_end >= frange_end)
          {
            if (DEBUG)
              cout << "   fully" << endl;
            auto overlap = range(filter_range.dest, 0, filter_range.length);
            aux_seed_ranges.push_back(overlap);
            // get bit before
            if (filter_range.start > seed_range.start)
            {
              auto prev = range(seed_range.start, 0.0, filter_range.start - seed_range.start);
              if (DEBUG)
                cout << "   bit before " << prev.start << " " << prev.length << endl;
              seed_ranges.push_back(prev);
            }
            // get bit after
            if (seed_end > frange_end)
            {
              auto next = range(frange_end, 0.0, seed_end - frange_end);
              if (DEBUG)
                cout << "   bit after " << next.start << " " << next.length << endl;
              seed_ranges.push_back(next);
            }
          }
        }
      }

      if (noOverlap)
      {
        aux_seed_ranges.push_back(seed_range);
      }
    }
    seed_ranges = aux_seed_ranges;
  }
  if (DEBUG)
    cout << "=============" << endl;
  for (auto &seed : seed_ranges)
  {
    if (DEBUG)
      cout << seed.start << " " << seed.length << endl;
    minLoc = min(seed.start, minLoc);
  }
  if (DEBUG)
    cout << endl;

  // Out should be for test: 46
  std::cout << "Min. Location is: " << minLoc << endl;
}
