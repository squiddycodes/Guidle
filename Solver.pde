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

ArrayList<String> wordArrayList = new ArrayList<String>();
ArrayList<Character> blackListedLetters = new ArrayList<Character>();
int[] correctIndexes = {0,0,0,0,0}; //will set each to 1 if correct, to ignore for filter down (save mem)

void smartMove(){
  if(!gameDone){
    if(floor(totalTests/testsPerWord) > startingWords.length - 1)
      return;
    
    if(currentSpace[0] == 0){
      enterWord(startingWords[floor(totalTests/testsPerWord)]);
      wordArrayList = setWordArrayList();
    }
    else{//refine words list and pick word to enter
      refineOnGreens();
      refineOnGrays();
      refineOnYellows();//should go after refining greens bc uses correctIndexes
      String word = pickWordFromList();
      enterWord(word);
      //enterWord(wordArrayList.get(0));
      wordArrayList.remove(0);
    }
    playerMove();
  }else{//if game is over
    blackListedLetters.clear();
    correctIndexes = new int[]{0,0,0,0,0};
    totalTests++;
    println("Test " + totalTests + "  ================================================================\n" + evalEndGameState());
    if(wordStats.size() % testsPerWord == 0){//switch words every testsPerWord words
      float[] stats = evalWordStats();
      println("Starting Word:" + startingWords[floor((totalTests - 1)/testsPerWord)] + "\nWins:" + stats[0] + "\nLosses:" + stats[1] + "\nWinrate:" + stats[2] + "\nAvg Winning Line:" + stats[3] + "\n");
      wordStats.clear();
    }
    setup();
    gameDone = false;
  }
}

String pickWordFromList(){//so far, just picks non-duplicate letter words (better for probing)
  for(String w : wordArrayList){
    boolean hasDupe = false;
    for(int i = 0; i < 5; i++)
      for(int j = i + 1; j < 5; j++)
        if(w.charAt(i) == w.charAt(j))
          hasDupe = true;
    if(!hasDupe)
      return w;
  }
  return wordArrayList.get(0);
}

void refineOnYellows(){//for each yellow, can NOT be in that position, must be in str at position where green isn't
  for(int s = 0; s < 5; s++){//for space in last row
    Space sObj = lines[currentSpace[0] - 1].spaces[s];
    if(sObj.spaceColor == 2){//if yellow
      ArrayList<Integer> possibleIndexes = new ArrayList<Integer>();
      for(int i = 0; i < 5; i++)//again for space in last row
        if(correctIndexes[i] == 0 && s != i)//if not at current space index or green space
          possibleIndexes.add(i);

      //remove all from wordArrayList that don't have sObj.letter in any possibleIndex
      for(int j = wordArrayList.size() - 1; j >= 0; j--){//iterate through wordarraylist
        boolean remove = true;
        for(int index : possibleIndexes){
          final int x = index;
          if(sObj.letter == wordArrayList.get(j).charAt(index))//if yellow letter appears in string in a possible index
            remove = false;
        }
        if(remove)
          wordArrayList.remove(j);
      }
    }
  }
}

void refineOnGreens(){
  for(int s = 0; s < 5; s++){
    if(correctIndexes[s] == 0){//if haven't filtered by this index before
      Space sObj = lines[currentSpace[0] - 1].spaces[s];
      if(sObj.spaceColor == 3){//if in correct pos
        final int sIndex = s;
        wordArrayList.removeIf(word -> word.charAt(sIndex) != sObj.letter);
        correctIndexes[s] = 1;
      }
    }
  }
}

void refineOnGrays(){//removes if fully gray (used nowhere in string)
  for(onScreenKey k : keys)
    if(k.spaceColor == 1 && !blackListedLetters.contains(k.letter)){
      blackListedLetters.add(k.letter);
      wordArrayList.removeIf(word -> word.indexOf(k.letter) != -1);
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
