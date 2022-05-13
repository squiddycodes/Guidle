import java.awt.*; //for clipboard
import java.awt.datatransfer.*; //for clipboard
Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();//init clipboard

String word;
Line[] lines = new Line[6];
onScreenKey[] keys = new onScreenKey[28];//28
int[] currentSpace = {0,0};//line, space
boolean canPlay = true;
String[] winMessages = {"+WHAT+HOW+HACKING", "SHEESH ur cracked", "very niiice", "nice JOB 8.5/10", "nice job, uhhh 7.5/10", "LETS GOOOOO CLUTCH"};
String reasonForShake;//"Not enough letters" or "Not in word list"
boolean gameDone = false;
final float gameSize = .5;//compared to 1000, 1300
void setup(){
  currentSpace[0] = 0;
  currentSpace[1] = 0;
  size(500,650);//1000, 1300 at gameSize = 1
  frameRate(30);
  background(18, 18, 19);//grayish
  stroke(43 * gameSize, 43 * gameSize, 44 * gameSize);
  strokeWeight(2 * gameSize);
  PFont f = createFont("font.otf",72);//import font
  textFont(f);//set font
  textSize(72 * gameSize);
  fill(215, 218, 220);
  textAlign(CENTER);
  text("GUIDLE",500 * gameSize,80 * gameSize);
  line(310 * gameSize,100 * gameSize,700 * gameSize,100 * gameSize);//line below guidle
  setWord();//set first word
  initLines();
  drawLines();
  initKeys();
  drawKeys();
  println("Word: " + word);
}

void draw(){
  drawBackground();
  checkAnims();
  drawSpaces();
  drawKeys();
  strokeWeight(1);
}

void mousePressed(){//stuff only happens when stuff is pressed, draw() is only used for animations
  if(canPlay){
    for(onScreenKey k : keys)
      if(k.isPressed())
        k.Update();
  }
}

void keyPressed() {
  if(gameDone && canPlay){//start new game
    setup();
    gameDone = false;
  }else{
    if(canPlay){
    if (keyPressed) {
      if(key != BACKSPACE && key != ENTER){
        for(onScreenKey k : keys){
          String kstr1 = String.valueOf(k.letter);
          String kstr2 = String.valueOf(key).toUpperCase();
          if(kstr1.equals(kstr2))
            k.Update();
        }
      }else if(key == ENTER){
        keys[19].Update();//playerMove();
      }else//backsp
        keys[27].Update();
    }
  }
  }
}

void playerMove(){
  String enteredWord = String.valueOf(lines[currentSpace[0]].spaces[0].letter) + String.valueOf(lines[currentSpace[0]].spaces[1].letter) + 
  String.valueOf(lines[currentSpace[0]].spaces[2].letter) + String.valueOf(lines[currentSpace[0]].spaces[3].letter) + String.valueOf(lines[currentSpace[0]].spaces[4].letter);//get word from line
  if(enteredWord.equals(word)){//if guessed word
    canPlay = false;
    for(Space space : lines[currentSpace[0]].spaces)
        space.origX = space.x;
  }else{//if does not guess word
    if(lines[currentSpace[0]].spaces[4].letter != ' ' && wordExists(enteredWord)){//if line is full and word exists
      for(Space space : lines[currentSpace[0]].spaces)
        space.origX = space.x;
        //updateSpaceColors();
    }else{//word dne or line isn't full
      for(Space space : lines[currentSpace[0]].spaces)
        space.shakeFrame = 1;//start shake
      if(lines[currentSpace[0]].spaces[4].letter == ' ')
        reasonForShake = "Not enough letters";
      else
        reasonForShake = "Not in word list";
    }
    
  }
}

void updateSpaceColors(){
  String enteredWord = String.valueOf(lines[currentSpace[0]].spaces[0].letter) + String.valueOf(lines[currentSpace[0]].spaces[1].letter) + String.valueOf(lines[currentSpace[0]].spaces[2].letter)
  + String.valueOf(lines[currentSpace[0]].spaces[3].letter) + String.valueOf(lines[currentSpace[0]].spaces[4].letter);//get word from line
  if(enteredWord.equals(word)){//if guesses word
    for(Space space : lines[currentSpace[0]].spaces)
      space.spaceColor = 3;
    for(onScreenKey k : keys)
      for(int letter = 0; letter < 5; letter++)
        if(word.charAt(letter) == k.letter)
          k.spaceColor = 3;
    fill(255);//START OF MESSAGE
    strokeWeight(0);
    rect(50 * gameSize,30 * gameSize,200 * gameSize,75 * gameSize,10 * gameSize);
    rect(750 * gameSize,30 * gameSize,200 * gameSize,75 * gameSize,10 * gameSize);//right for "play again" message
    fill(18, 18, 19);
    textSize(20 * gameSize);
    if(currentSpace[0] == 0 || currentSpace[0] == 4 || currentSpace[0] == 5)
      textSize(16 * gameSize);
    text(winMessages[currentSpace[0]],150 * gameSize,75 * gameSize);//END OF MESSAGE
    textSize(25 * gameSize);
    text("Press any key\nto play again!",850 * gameSize,60 * gameSize);
    StringSelection data = new StringSelection("Guidle \"" + word + "\" " + (currentSpace[0] + 1) + "/6\n\n" + gameToEmojis());
    try{
    clipboard.setContents(data,data);
    }catch(Exception e){print(e);}
    gameDone = true;
  }else{
    for(int charEntered = 0; charEntered < 5; charEntered++){//for space in line
      for(int charWord = 0; charWord < 5; charWord++){//second iteration for checking what position matches
        if(charEntered == charWord && enteredWord.charAt(charEntered) == word.charAt(charWord)){
          lines[currentSpace[0]].spaces[charEntered].spaceColor = 3;
          for(onScreenKey key1 : keys)
            if(key1.letter == word.charAt(charEntered)){
              boolean existsSomewhereElse = false;
              for(int i = 0; i < 5; i++){
                if(key1.letter == word.charAt(i) && charEntered != i && lines[currentSpace[0]].spaces[i].spaceColor != 3)
                  existsSomewhereElse = true;
              }
              if(!existsSomewhereElse)
                key1.spaceColor = 3;
              else{
                if(key1.spaceColor != 3){
                  key1.spaceColor = 2;
                }
              }
            }
        break;
        }else if(charEntered != charWord && enteredWord.charAt(charEntered) == word.charAt(charWord)
        && enteredWord.charAt(charEntered) !=  word.charAt(charEntered) && word.charAt(charWord) != enteredWord.charAt(charWord)){//if they match somewhere and they didn't already guess that letter in that position
          int enteredDupes = 0;
          int wordDupes = 0;
          for(int i = 0; i < charEntered; i++)
            if(enteredWord.charAt(i) == enteredWord.charAt(charEntered))
              enteredDupes++;
          for(int i = 0; i < 5; i++)
            if(word.charAt(i) == enteredWord.charAt(charEntered))
              wordDupes++; 
          if(enteredDupes < wordDupes)
            lines[currentSpace[0]].spaces[charEntered].spaceColor = 2;
          else
            lines[currentSpace[0]].spaces[charEntered].spaceColor = 1;
          println("poop");
          for(onScreenKey key1 : keys)
            if(key1.letter == enteredWord.charAt(charEntered))
              if(key1.spaceColor != 3){
                  key1.spaceColor = 2;
                  //print("woo");
              }
          break;
        }else{
          lines[currentSpace[0]].spaces[charEntered].spaceColor = 1;
          for(onScreenKey key1 : keys)
            if(key1.letter == enteredWord.charAt(charEntered) && key1.spaceColor != 3)
              key1.spaceColor = 1;
        }
      }
    }
  }
if(currentSpace[0] != 5)
  currentSpace[0] += 1;//new line
else
  if(!word.equals(enteredWord)){
    playerLose();//LOSERRR
  }
  currentSpace[1] = 0;
}

void checkAnims(){
  for(Line line : lines)
    for(Space space : line.spaces)
      if(space.anim1Frame > 0){
        space.anim1Frame -= 1;
      }
}

void setWord(){
  int wordIndex = int(random(wordList.length()/5));
  word = String.valueOf(wordList.charAt(wordIndex * 5)) + String.valueOf(wordList.charAt(wordIndex * 5 + 1))
  + String.valueOf(wordList.charAt(wordIndex * 5 + 2)) + String.valueOf(wordList.charAt(wordIndex * 5 + 3)) + String.valueOf(wordList.charAt(wordIndex * 5 + 4));//gets chosen word
  //word = "SUSSY";
}

void playerLose(){
  gameDone = true;
  fill(255);//START OF MESSAGE
  strokeWeight(0);
  rect(50 * gameSize,30 * gameSize,200 * gameSize,75 * gameSize,10 * gameSize);
  rect(750 * gameSize,30 * gameSize,200 * gameSize,75 * gameSize,10 * gameSize);//right for "play again" message
  fill(18, 18, 19);
  textSize(21 * gameSize);
  text("You Lose!\nWord was\n" + word,150 * gameSize,50 * gameSize);//END OF MESSAGE
  textSize(25 * gameSize);
  text("Press any key\nto play again!",850 * gameSize,60 * gameSize);
}

String gameToEmojis(){
  String output = "";
  for(int line = 0; line < currentSpace[0] + 1; line++,output+="\n"){
    for(int space = 0; space < 5; space++){
      if(lines[line].spaces[space].spaceColor == 1)//grayed out
        output += "⬛";
      else if(lines[line].spaces[space].spaceColor == 2)//yellow
        output += "🟨";
      else
        output += "🟩";
    }
  }
  return output;
}

void drawBackground(){
  stroke(18, 18, 19);
  fill(18, 18, 19);
  rect(0,130 * gameSize,1000 * gameSize,750 * gameSize);
}

void drawLines(){
  for(Line line : lines)
    line.Draw();
}

void drawSpaces(){
  for(Line line : lines)
    for(Space space : line.spaces)
      space.Draw();
  if(lines[currentSpace[0]].spaces[0].x < 0)
    updateSpaceColors();
}

void drawKeys(){
  for(onScreenKey k : keys)
    k.Draw();
}

void initLines(){
  lines[0] = new Line(150 * gameSize);
  lines[1] = new Line(270 * gameSize);
  lines[2] = new Line(390 * gameSize);
  lines[3] = new Line(510 * gameSize);
  lines[4] = new Line(630 * gameSize);
  lines[5] = new Line(750 * gameSize);
}

void initKeys(){
  keys[0] = new onScreenKey(60 * gameSize,900 * gameSize,'Q');//row 1
  keys[1] = new onScreenKey(150 * gameSize,900 * gameSize,'W');
  keys[2] = new onScreenKey(240 * gameSize,900 * gameSize,'E');
  keys[3] = new onScreenKey(330 * gameSize,900 * gameSize,'R');
  keys[4] = new onScreenKey(420 * gameSize,900 * gameSize,'T');
  keys[5] = new onScreenKey(510 * gameSize,900 * gameSize,'Y');
  keys[6] = new onScreenKey(600 * gameSize,900 * gameSize,'U');
  keys[7] = new onScreenKey(690 * gameSize,900 * gameSize,'I');
  keys[8] = new onScreenKey(780 * gameSize,900 * gameSize,'O');
  keys[9] = new onScreenKey(870 * gameSize,900 * gameSize,'P');
  
  keys[10] = new onScreenKey(105 * gameSize,1010 * gameSize,'A');//row 2
  keys[11] = new onScreenKey(195 * gameSize,1010 * gameSize,'S');
  keys[12] = new onScreenKey(285 * gameSize,1010 * gameSize,'D');
  keys[13] = new onScreenKey(375 * gameSize,1010 * gameSize,'F');
  keys[14] = new onScreenKey(465 * gameSize,1010 * gameSize,'G');
  keys[15] = new onScreenKey(555 * gameSize,1010 * gameSize,'H');
  keys[16] = new onScreenKey(645 * gameSize,1010 * gameSize,'J');
  keys[17] = new onScreenKey(735 * gameSize,1010 * gameSize,'K');
  keys[18] = new onScreenKey(825 * gameSize,1010 * gameSize,'L');
  
  keys[19] = new onScreenKey(60 * gameSize,1120 * gameSize,'[');//row 3
  keys[20] = new onScreenKey(195 * gameSize,1120 * gameSize,'Z');
  keys[21] = new onScreenKey(285 * gameSize,1120 * gameSize,'X');
  keys[22] = new onScreenKey(375 * gameSize,1120 * gameSize,'C');
  keys[23] = new onScreenKey(465 * gameSize,1120 * gameSize,'V');
  keys[24] = new onScreenKey(555 * gameSize,1120 * gameSize,'B');
  keys[25] = new onScreenKey(645 * gameSize,1120 * gameSize,'N');
  keys[26] = new onScreenKey(735 * gameSize,1120 * gameSize,'M');
  keys[27] = new onScreenKey(825 * gameSize,1120 * gameSize,']');
}
