void enterWord(String word){
   onScreenKey[] keysToEnter = getKeysFromStr(word);
   for(onScreenKey k : keysToEnter){
     k.Update();
   }
}

onScreenKey[] getKeysFromStr(String word){
  onScreenKey[] keysOut = new onScreenKey[word.length()];
  for(int i = 0; i < word.length(); i++){
    char c = word.charAt(i);
    for(onScreenKey k : keys)
      if(k.letter == c)
        keysOut[i] = k;
  }
  return keysOut;
}


String[] startingWords = {"CRANE", "SLATE", "TRACE", "RAISE", "STARE", "TALES", "AEROS", "SOARE", "AROSE", "REIAS", "SERAI", "ARISE", "AESIR", "ALOES", "LARES", "SHADE"};
ArrayList<Integer> wordStats = new ArrayList<Integer>();// each element is a game, won on X line, or 0 if lost - num games = wordStats.size()
int testsPerWord = 5;
int totalTests = 0;

void smartMove(){
  if(!gameDone){
    if(floor(totalTests/testsPerWord) > startingWords.length - 1)
      return;
    enterWord(startingWords[floor(totalTests/testsPerWord)]);
    playerMove();
  }else{//if game is over
    totalTests++;
    println("Test " + totalTests + "  =============================================================================================\n" + evalEndGameState());
    if(wordStats.size() % testsPerWord == 0){//switch words every testsPerWord words
      float[] stats = evalWordStats();
      println("Starting Word:" + startingWords[floor((totalTests - 1)/testsPerWord)] + "\nWins:" + stats[0] + "\nLosses:" + stats[1] + "\nWinrate:" + stats[2] + "\nAvg Winning Line:" + stats[3] + "\n");
      wordStats.clear();
    }
    setup();
    gameDone = false;
  }
}

String evalEndGameState(){//TODO TRACK STATS FOR STARTING WORDS
  String startingWord = lines[0].getWord();
  if(lines[currentSpace[0]].getWord().equals(word)){
    wordStats.add((currentSpace[0] + 1));
    return "Starting word:" + startingWord + "\nWon on line " + (currentSpace[0] + 1) + "  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
  }
  wordStats.add(0);
  return "Starting word:" + startingWord + "\nLOSE  ------------------------------------------------------------------\n";
}

float[] evalWordStats(){//index 0=wins, 1=losses, 2=winrate (wins/losses), 3=avg line won on
  int wins = 0;
  float avgWonOn = 0;
  for(int game : wordStats){
    if(game != 0){//if a win
      if(wins == 0)//if first win
        avgWonOn = game;
      else
        avgWonOn += game;
      wins++;
    }
  }
  if(wins == 0)
    return new float[] {0, wordStats.size(), 0, 0};
  return new float[] {wins, wordStats.size() - wins, (float) wins/wordStats.size(), avgWonOn/wins};
}
