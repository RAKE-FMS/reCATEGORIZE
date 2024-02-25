// 分類したタグを検索、削除、追加

int offset,yMax;//offset:スクロール用,yMax:一覧の一番下

// タグ検索と画像一覧
void drawTagView(){
    PImage screen=createImage(width,height,RGB);
    int x=50;
    int y=200-offset;
    textAlign(CENTER);
    textSize(15);
    for(int i=0;i<allimgs.size();i++){
        if(-squareSize-100<y&&y<height+3){
            if(UIs.get(1).label.equals("")||(allimgs.get(i).tagTxt!=null&&searchTag(UIs.get(1).label,allimgs.get(i).tagTxt))){
                allimgs.get(i).display(x,y);
                x+=squareSize+15;
                if(x+squareSize>=width-50){
                    x=50;
                    y+=squareSize+100;
                }
            }
        }
    }
    yMax=y-200;
    loadPixels();
    arrayCopy(pixels,screen.pixels);//キャンバス全体をPImageにコピー
    screen.updatePixels();
    PImage fade=screen.get(0,0,width,min(175,height));//PImageの一部分(y座標が100未満の部分)にブラー
    fade.filter(BLUR,5);
    image(fade,0,0);
    //スクロールバー
    fill(255,150);
    rect(width-30,200,30,height-235);
    fill(200);
    int sl=int(float(height-235)/(yMax+offset)*(height-435));//height-235:表示領域,yMax+offset:全体,height-435:スクロールバーの長さ
    int sy=int(200+offset/float(yMax+offset)*(height-sl-35));//200:スクロールバーの一番上,offset/(yMax+offset):今の位置の割合,height-sl-35:バーが動ける幅
    rect(width-28,sy,26,sl);
    for(int i=0;i<UIs.size();i++)UIs.get(i).display();
}
//タグを検索(srcの中にtxtが存在するか) 今は&検索しかできない
boolean searchTag(String txt,String src){
    String[]txts=splitTokens(txt,"　 ");//半角または全角スペースで区切る
    for(String word:txts)if(src.indexOf(word)==-1)return false; // 全ての検索ワードと一致すればtrue
    return true;
}
//ボタン制御
void TagViewOperate(){
    int x=50;
    int y=200-offset;
    for(int i=0;i<allimgs.size();i++){
        if(allimgs.get(i).mouseOver()==0)openFile(allimgs.get(i).original);//写真をクリックしたらアプリで開く
        else if(allimgs.get(i).mouseOver()==1){//タグの場所をクリックしたとき
            UIs.get(0).move(0,x,0,y+squareSize+45,allimgs.get(i));
            UIs.get(0).set();//テキストボックスを再表示
            UIs.get(0).requestFocusInWindow();
        }
        x+=squareSize+15;
        if(x+squareSize>=width-50){
            x=50;
            y+=squareSize+100;
        }
    }
    if(UIs.get(2).mouseOver())selectFolder("Select a folder to process:","folderSelected");
    if(UIs.get(4).mouseOver()){
        while(UIs.size()>0){
            UIs.get(0).delete();
            UIs.remove(0);
        }
        scene=0;
        titleSetup();
    }
}
//ファイルをアプリで開く
void openFile(File file){
  try{
    if(Desktop.isDesktopSupported()){
      Desktop.getDesktop().open(file);
    }
  }catch(Exception e){
    e.printStackTrace();
  }
}