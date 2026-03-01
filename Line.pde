class Line{
  Space[] spaces = new Space[5];
  
  public Line(float y){
    spaces[0] = new Space(210 * gameSize,y);//210
    spaces[1] = new Space(330 * gameSize,y);
    spaces[2] = new Space(450 * gameSize,y);
    spaces[3] = new Space(570 * gameSize,y);
    spaces[4] = new Space(690 * gameSize,y);
  }
  
  void Draw(){
    for(Space space : spaces)
      space.Draw();
  }
  
  boolean performingAnim(){
    for(Space s : spaces)
      if(s.origX != -1)
        return true;
    return false;
  }
  
  String getWord(){
    String word = "";
    for(Space s : spaces)
      word += s.letter;
    return word;
  }
}
