//reCAPTCHA風画像分類アプリ
//ユーザ向け使い方→ImageMagickをインストール、ExifToolをこのフォルダ内にインストール
//ExifToolのリンクとPerlライセンスとか貼る(Image Magickは?)

//やること
//一部のpngファイルにタグ付けができないバグの修正
//テキストがラッピングによって見切れることがある問題の修正(特に分類の種類表示の所)

//初期画面
//前回やその前に選択したフォルダをフォルダ選択ボタンにカーソル合わせたら下に出てきて選択できるように(フォルダが存在するとき)する→少し優先
//毎回最初にサムネ削除すれば混同しなくて済む?
//同名のフォルダやタグを作れないようにする

//Classify
//フォルダ分類が同名ファイルのとき片方たぶん消滅するから直したい
//タグ分類やフォルダ分類がクラス化してからもちゃんとできてるか確認
//C:/users/admin/test.jpgみたいなパスだったらC!%users%%admin%%test_thumnail.jpgとか命名法則作って2回目検索しやすく
//分類中のサイドパネル表示(やり直しきく)→微妙
//サムネイルサイズの大中小
//選択フォルダの別々のサブディレクトリ内に同名、同拡張子のファイルがあったら競合してどっちか消えるかも→優先
//フォルダに画像が16枚以下のとき配列の外にはみ出す問題を直す!
//読み込まれたとこから分類できるように
//分類方法の選択時に、マウスホバー時にフレームが付くようにしたい(塗りつぶしの色は変えずに)
//UIクラスのframeChangeをint hoverModeとかにして複数のモードを扱いたい

//Tag
//ExifToolフォルダ内にあるけど他の人がダウンロードするときどうなる

//TagView
//arrayCopyでぼかし入れてるところがウィンドウサイズ変えたときにエラー起こすからdrawで使いたくない

//プラスα
//分類の順番変更
//見た目の改善(写真選択するときのアニメーション、ボタン押したときのアニメーション)
//ボタン押したときのアニメーションはmousePressedでUI小さくして、mouseReleasedでボタンが押された判定にするとか
//ウィンドウサイズの下限を設けて見た目が破綻しないように(下回ったら最小サイズに変更するとか)

import java.awt.Frame;
import java.awt.image.BufferedImage;
import processing.awt.PSurfaceAWT;

PImage backgroundImg;
PImage logo;
PFont myFont;
File folder;
int scene;//0:タイトル+フォルダなど選択画面,1:分類場面,2:終了画面,3:タグの閲覧、検索画面
int startUIs;
ArrayList<UI>UIs=new ArrayList<UI>();

void setup(){
    surface.setLocation(-300,-300);//スクショに映りこまないように画面外へ
    surface.setVisible(false);
    try{
        Robot robot=new Robot();
        //スクリーンキャプチャを取得
        Rectangle screenRect=new Rectangle(java.awt.Toolkit.getDefaultToolkit().getScreenSize());
        BufferedImage capture=robot.createScreenCapture(screenRect);
        backgroundImg=new PImage(capture.getWidth(),capture.getHeight(),RGB);
        capture.getRGB(0,0,backgroundImg.width,backgroundImg.height,backgroundImg.pixels,0,backgroundImg.width);
        backgroundImg.updatePixels();
        backgroundImg.filter(BLUR,10);
    }
    catch(AWTException e){
        e.printStackTrace();
    }
    surface.setSize(1000,800);
    surface.setLocation((displayWidth-width)/2,(displayHeight-height)/2);
    surface.setVisible(true);
    surface.setResizable(true);//ウィンドウサイズを可変に
    logo=loadImage(sketchPath()+"\\Logo(BingImageCreator).jpg");
    logo.resize(70,70);
    surface.setIcon(loadImage(sketchPath()+"\\Icon(BingImageCreator).jpg")); // アイコン変更
    surface.setTitle("reCATEGORIZE");//タイトル変更
    Canvas canvas=(Canvas)surface.getNative();//キャンバス取得(テキストボックス用)
    pane=(JLayeredPane)canvas.getParent().getParent();
    myFont=createFont("Yu Gothic UI",20);
    textFont(myFont);
    exifToolPath=sketchPath()+"\\exiftool.exe";//sketchPathは関数の中じゃないとProcessing本体のパス返す
    csvOutputPath=sketchPath()+"\\output.csv";
    csvInputPath=sketchPath()+"\\input.csv";
    titleSetup();
}

void draw(){
    int winX=getFrame().getX();
    int winY=getFrame().getY();
    image(backgroundImg,-winX-11,-winY-45);
    noStroke();
    fill(230,150);
    rect(0,0,width,height);//全画面じゃないときの背景
    if(scene==0)drawTitleScene();
    if(scene==1)drawClassify();
    if(scene==3)drawTagView();
}

void mousePressed(){
    if(scene==0){
        startOperate();
    }else if(scene==1){
        ClassifyOperate();
    }else if(scene==2){
        // 分類完了のログ
    }else{
        TagViewOperate();
    }
}

void mouseWheel(processing.event.MouseEvent event){
    float e=event.getCount();
    if(scene==3){
        offset+=15*e;
        if(offset<0)offset=0;
        else if(offset>yMax)offset=yMax;
    }
}

void keyPressed(){
    if(scene==1)select();
}