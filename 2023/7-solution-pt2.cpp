#include <fstream>
#include <iostream>
#include <vector>
#include <utility>

#include "utils.h"

const bool DEBUG = false;

struct hand{
    char cards[5]; // record in ms
    int bet;

    hand(char _cards[5], int _bet){
      // hard
      bet = _bet;
      for (int i = 0; i < 5; i++)
      {
        cards[i] = _cards[i];
      }
    }

    int strength(){
      // strength order: 
      int strength_order[13] = {'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'};

      // first, sort the cards by letter

      char aux[5];
      std::copy(std::begin(cards), std::end(cards), std::begin(aux));
      std::sort(cards, cards + 5);

      char current = ' ';
      int count = 0;
      int max = 0;
      std::vector<std::string> groups = std::vector<std::string>();
      for(int i = 0; i < 5; i++){
        if (cards[i] == current){
          count++;
        } else{
          if (count == 1){
          }
          if (count == 2){
            groups.push_back("pair");
          }
          if (count == 3){
            groups.push_back("tok");
          }
          if (count == 4){
            groups.push_back("poker");
          }
          current = cards[i];
          count = 1;
        }
      }
      if (count == 2)
      {
        groups.push_back("pair");
      }
      if (count == 3)
      {
        groups.push_back("tok");
      }
      if (count == 4)
      {
        groups.push_back("poker");
      }
      if (count == 5)
      {
        groups.push_back("five");
      }

    std::copy(std::begin(aux), std::end(aux), std::begin(cards));
     
    // std::sort(arr, arr + n);
      // High card:       0000001
      // One pair:        0000010
      // Two pairs:       0000100
      // Three of a kind: 0001000
      // Full house:      0010000
      // poker:           0100000
      // Five of a kind   1000000

      // high card
      if(groups.size() == 0){
        // it is nothing, maybe high card
        for (int j = 0; j < 13; j++)
        {
          if (cards[0] == strength_order[j] && max <= j)
          {
            max = j;
          };
        }
        return 13-max;
      }
      if (groups.size() == 1){
        if (groups[0] == "pair"){
          return 20;
        }
        if (groups[0] == "tok"){
          return 2000;
        }
        if (groups[0] == "poker"){
          return 2000000;
        }
        if (groups[0] == "five"){
          return 20000000;
        }
      }
      if (groups.size() == 2){
        if (
          (groups[0] == "pair" && groups[1] == "tok") ||
          (groups[0] == "tok" && groups[1] == "pair")
        ){
          // full house
          return 200000;
        }
        if (groups[0] == "pair" && groups[1] == "pair"){
          return 200;
        }
      }
    }
};

int main()
{
  // iterate over every line in the input
  std::vector<std::string> lines = read_lines(read_file("7-input.txt"));
  std::vector<hand> hands = std::vector<hand>();

  // ===
  // PARSING
  // ===

  for(auto &line: lines){
    // for each line split it on the space
    auto hand_array = split(line, ' ');
    hands.push_back(hand(hand_array[0].data(), stoi(hand_array[1])));
  }

  // ===
  // Solving
  // ===
  auto max = 0;
   for(auto &h: hands){
    // print each race for debugging
    int s = h.strength();
    std::cout  
    << h.cards[0] <<
    h.cards[1] << h.cards[2] << h.cards[3] << h.cards[4]  << " " 
    << h.bet << " strength " << s << std::endl;
    if (s > max){
      max = s;
    }
   }
   std::sort(begin(hands), end(hands), [](hand a, hand b){ 
    auto diff = a.strength() - b.strength();
    if (diff == 0){
      // its the same, compare letter by letter
      // std::cout << " it is the same guys" << std::endl;
      for (int i = 0; i < 5; i++){
        if (a.cards[i] != b.cards[i]){
          // check which is higher
          // strength order:
          int strength_order[13] = {'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'};
          int maxA = 0;
          for (int j = 0; j < 13; j++)
          {
            if (a.cards[i] == strength_order[j] && maxA < j)
            {
              maxA = j;
            };
          }
          int maxB = 0;
          for (int j = 0; j < 13; j++)
          {
            if (b.cards[i] == strength_order[j] && maxB < j)
            {
              maxB = j;
            };
          }

          return maxA > maxB;
        }
      }
    }
    return a.strength() < b.strength();
  });

  long prod = 0; // a very big number
  for (int i = 0; i < hands.size(); i++){
    std::cout  
    << hands[i].cards[0] <<
    hands[i].cards[1] << hands[i].cards[2] << hands[i].cards[3] << hands[i].cards[4]  << " " 
    << hands[i].bet << " \t" << hands[i].strength() << std::endl;
    prod += hands[i].bet * (i + 1);
  }
  // Out should be for test: 6440
  std::cout << "Product of ways is: " << prod << std::endl;
}