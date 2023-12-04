#include <fstream>
#include <iostream>

using namespace std;

//Input:  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Output [[4,3,0],[1,2,6],[0,2,0]] 
vector<vector<int>> getDrawsFromString(string str){
  auto draws = new vector<vector<int>>();
  int pos = str.find(":");
  if (pos != string::npos){
    string drawsString = str.substr(pos + 2, string::npos); // 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    while (drawsString.length()){
      // iterate over the string, split at , and at ;
      auto semiColonPos = drawsString.find(";");
      auto commaPos = drawsString.find(",");
      cout << "====================" << endl;
      cout << drawsString << endl;
      string drawString = drawsString.substr(0, semiColonPos); // 3 blue, 4 red;
      // im sure this is not the best way to do this init
      auto draw = new vector<int>;
      draw->push_back(0); // red 
      draw->push_back(0); // green
      draw->push_back(0); // blue
      while (drawString.length()){
        auto commaPos = drawString.find(",");
        string singleDrawStr  = drawString.substr(0, commaPos); // 3 blue
        int spacePos = singleDrawStr.find(" ");
        string colorStr = singleDrawStr.substr(spacePos+1, string::npos); // blue
        cout << drawString << endl;
        int number = stoi(singleDrawStr.substr(0, spacePos));
        // get what color draw this is
        switch(colorStr[0]){
          case 'r':
          draw->at(0) =  number;
          break;
          case 'g':
          draw->at(1) = number;
          break;
          case 'b':
          draw->at(2) = number;
          break;
        }
        // remove from the string the draw we just took out ", "
        if (commaPos != string::npos){
          drawString = drawString.substr(commaPos + 2, string::npos);
        } else {
          drawString.clear();
        }
      }
      if (semiColonPos == string::npos){
        drawsString.clear();
      } else {
        drawsString = drawsString.substr(semiColonPos+2, string::npos); // remove the semi-colon
      }
      draws->push_back(*draw);
      // add the current draw to the draws and create a new one
      draw = new vector<int>;
      draw->push_back(0); // red 
      draw->push_back(0); // green
      draw->push_back(0); // blue
    }
  }
  return *draws;
}
