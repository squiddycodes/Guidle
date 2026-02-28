public class onScreenKey extends Space{
  public onScreenKey(float x, float y, char c){
    this.x = x;
    this.y = y;
    this.letter = c;
  }
  
  @Override
  public void Draw(){
    if(spaceColor == 0){//0 == untouched light gray, 1 == not in word dark gray, 2 == yellow, 3 == green
      stroke(129, 131, 132);
      fill(129, 131, 132);
    }else if(spaceColor == 1){
      stroke(58, 58, 60);
      fill(58, 58, 60);
    }else if(spaceColor == 2){
      stroke(181, 159, 59);
      fill(181, 159, 59);
    }else if(spaceColor == 3){
      stroke(83, 141, 78);
      fill(83, 141, 78);
    }else
      stroke(255,255,255);//error exception
    
    textSize(28 * gameSize);
    
    if(letter != '[' && letter != ']'){
      rect(x,y,70 * gameSize,90 * gameSize,10 * gameSize);
      fill(215, 218, 220);
      text(letter,x + 35 * gameSize,y + 55 * gameSize);
    }else if(letter == '['){
      rect(x,y,115 * gameSize,90 * gameSize,10 * gameSize);
      fill(215, 218, 220);
      text("ENTER",x + 55 * gameSize,y + 55 * gameSize);
    }else{//backspace
      rect(x,y ,115 * gameSize,90 * gameSize,10 * gameSize);
      fill(215, 218, 220);
      text("<  ",x + 55 * gameSize,y + 55 * gameSize);
      text("- ",x + 52 * gameSize,y + 53 * gameSize);
      text("- ",x + 60 * gameSize,y + 53 * gameSize);
      text("- ",x + 68 * gameSize,y + 53 * gameSize);
      text("- ",x + 76 * gameSize,y + 53 * gameSize);
    }
  }
  
  public void Update(){
    if(letter != ']' && letter != '[' && currentSpace[1] != 5){//if adding regular letter
      lines[currentSpace[0]].spaces[currentSpace[1]].letter = letter;
      lines[currentSpace[0]].spaces[currentSpace[1]].Draw();
      lines[currentSpace[0]].spaces[currentSpace[1]].anim1Frame = 2;
      currentSpace[1] += 1;
    }else if(letter == '['){//enter
      playerMove();
    }else if(letter == ']' && currentSpace[1] != 0){//backspace
      currentSpace[1] -= 1;
      lines[currentSpace[0]].spaces[currentSpace[1]].letter = ' ';
      lines[currentSpace[0]].spaces[currentSpace[1]].Draw();
    }  
  }
  
  public boolean isPressed(){
    boolean pressed = false;
    if(letter != '[' && letter != ']'){
      if(mouseX >= x && mouseX <= x + 70 * gameSize && mouseY >= y && mouseY <= y + 90 * gameSize)
        pressed = true;
    }else{
      if(mouseX >= x && mouseX <= x + 115 * gameSize && mouseY >= y && mouseY <= y + 90 * gameSize)
        pressed = true;
    }
    return pressed;
  }
  
}
