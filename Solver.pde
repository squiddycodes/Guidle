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
