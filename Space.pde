public class Space{
  float x;
  float y;
  char letter = ' ';
  int spaceColor = 0;//0 == grayedout, 1 == gray of moves solidified, 2 == yellow, 3 == green
  int anim1Frame = 0;
  int shakeFrame = 0;//36 frames = .5 sec animation, swings are 6 frames long
  float shakeSize = 5 * gameSize;//number of swings, multiplies by 5 to go for bigger swings 
  int numOfSwings = 0;
  float origX = -1;//when = x, performing check animation, returns to -1 when animation isn't happening
  
  public Space(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public Space(){
    
  }
  
  public void Draw(){
    if(spaceColor == 0){
      if(letter == ' ')
        stroke(45, 45, 47);
      else
        stroke(69, 69, 70);
      fill(18, 18, 19);
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
      
    strokeWeight(4 * gameSize);
    textSize(48 * gameSize);
    if(origX != -1){//if checking
      canPlay = false;
      x += 5 + abs((x - origX)/8);
      if(x >= 1000 * gameSize){
        x = origX - 2000 * gameSize;
      }else if(x < origX && origX - x < 5){//done with animation
        x = origX;
        origX = -1;
        canPlay = true;
      }
    }
    if(shakeFrame == 0){//if not shaking
      rect(x - (anim1Frame * 5),y - (anim1Frame * 5),100 * gameSize + (anim1Frame * 10),100 * gameSize + (anim1Frame * 10));
      fill(215, 218, 220);
      text(letter,x + 50 * gameSize,y + 70 * gameSize);
    }else if(shakeFrame % 6 == 0){//if on a last frame of swing
      shakeSize += 2;//magnitude of shake
      rect(x,y,100 * gameSize,100 * gameSize);//show normal pos
      fill(215, 218, 220);
      text(letter,x + 50 * gameSize,y + 70 * gameSize);
      shakeFrame++;
      numOfSwings++;
      if(numOfSwings == 2){//if anim done - set whatever
        shakeFrame = 0;
        shakeSize = 5;
        numOfSwings = 0;
        stroke(18, 18, 19);
        fill(18, 18, 19);
        rect(730,10,240 * gameSize,100 * gameSize);
      }
    }else if(shakeFrame % 5 == 0){//if on a second to last frame of swing
      rect(x+shakeSize,y,100 * gameSize,100 * gameSize);//s
      fill(215, 218, 220);
      text(letter,x + 50 * gameSize + shakeSize,y + 70 * gameSize);
      shakeFrame++;
    }else if(shakeFrame % 4 == 0){//if on a 4th frame of swing
      rect(x+(shakeSize/2),y,100 * gameSize,100 * gameSize);//.5s
      fill(215, 218, 220);
      text(letter,x + 50  * gameSize + (shakeSize/2),y + 70 * gameSize);
      shakeFrame++;
    }else if(shakeFrame % 3 == 0){//if on a 3rd frame of swing
      rect(x-(shakeSize/2),y,100 * gameSize,100 * gameSize);//-.5s
      fill(215, 218, 220);
      text(letter,x + 50 * gameSize - (shakeSize/2),y + 70 * gameSize);
      shakeFrame++;
    }else if(shakeFrame % 2 == 0){//if on a 2nd frame of swing
      rect(x-shakeSize,y,100 * gameSize,100 * gameSize);//-s
      fill(215, 218, 220);
      text(letter,x + 50 * gameSize - shakeSize,y + 70 * gameSize);
      shakeFrame++;
    }else{//if on a first frame of swing
      rect(x-(shakeSize/2),y,100 * gameSize,100 * gameSize);//-.5s
      fill(215, 218, 220);
      text(letter,x + 50 * gameSize - (shakeSize/2),y + 70 * gameSize);
      shakeFrame++;
      fill(255);//START OF MESSAGE
      strokeWeight(0);
      rect(750,30,200 * gameSize,75 * gameSize,10 * gameSize);
      fill(18, 18, 19);
      textSize(20 * gameSize);
      text(reasonForShake,850 * gameSize,75 * gameSize);//END OF MESSAGE
    }
  } 
}
