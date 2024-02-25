//背景とスタート画面

File currentFolder;//選択したフォルダが変更されたか確認する

//タイトルシーンのセットアップ
void titleSetup(){
    UIs.add(new button(0.5,-320,0.5,-60,640,370,20));//0:設定のUIのベース
    UIs.get(UIs.size()-1).setActive(false);
    UIs.get(UIs.size()-1).setFillColor(color(255,150),color(0));
    UIs.add(new button(0.5,-300,0.5,120,75,50,5,"フォルダ"));//1:分類方法フォルダ
    UIs.get(UIs.size()-1).setActive(false);
    UIs.add(new button(0.5,-225,0.5,120,75,50,5,"タグ"));//2:分類方法タグ
    UIs.get(UIs.size()-1).setActive(false);
    UIs.get(UIs.size()-1).setAlways(true);
    UIs.add(new button(0.5,-300,0.5,0,160,50,10,"フォルダを選択..."));//3:フォルダ選択ボタン
    UIs.add(new button(0.5,-300,0.5,220,160,50,10,"タグの閲覧と検索"));//4:TagViewへ移動するボタン
    UIs.add(new button(0.5,-300,0.5,-250,600,150,10));//5:タイトル兼分類開始ボタン
    UIs.get(UIs.size()-1).setFillColor(color(255),color(0));
    UIs.get(UIs.size()-1).setActive(false);
    UIs.add(new button(0.5,-280,0.5,-200,50,50,5));//6:タイトルボックス用
    UIs.get(UIs.size()-1).changeInteractionMode(1);
    UIs.add(new button(0.5,-100,0.5,60,120,30,5,"分類を追加..."));//7:分類追加ボタン
    startUIs=UIs.size();//ここまでがテキストボックスとdeleteボタン以外の数
    UIs.add(new textBox(0.5,-100,0.5,0,120,30,false));//8:テキストボックス1
    UIs.add(new circleButton(0.5,50,0.5,15,20,"X"));//9:deleteボタン1
}
//タイトルシーン
void drawTitleScene(){
    int num_textbox=(UIs.size()-startUIs)/2;
    for(int i=0;i<UIs.size();i++){
        //分類方法が2つ以上あるときはdeleteボタンを表示する
        if(i<startUIs||!(num_textbox==1&&i==startUIs+1))UIs.get(i).display();
    }
    image(logo,width/2+200,height/2-225);
    fill(0);
    textAlign(LEFT);
    textSize(40);
    text("私は整理が下手ではありません",width/2-220,height/2-215,420,200);
    textSize(15);
    text("reCATEGORIZE",width/2+185,height/2-125);
    textSize(20);
}
//分類の追加と削除(テキストボックスの操作)
void startOperate(){
    //分類方法の選択
    if(UIs.get(1).mouseOver()||UIs.get(2).mouseOver()){
        if(rule.equals("folder")){
            rule="tag";
            UIs.get(1).setAlways(false);
            UIs.get(2).setAlways(true);
        }else if(rule.equals("tag")){
            rule="folder";
            UIs.get(1).setAlways(true);
            UIs.get(2).setAlways(false);
        }
        //タグとフォルダで禁止文字が違うので適用する
        for(int i=startUIs;i<UIs.size();i+=2)if(isInvalid(UIs.get(i).label))UIs.get(i).setLabel("");
    }
    //フォルダ選択ボタン
    if(UIs.get(3).mouseOver())selectFolder("Select a folder to process:","folderSelected");
    if(UIs.get(4).mouseOver()){//タグ閲覧と検索ボタン
        println(UIs.size());
        while(UIs.size()>0){
            UIs.get(0).delete();//テキストボックスを全削除
            UIs.remove(0);//UIの要素も削除
        }
        scene=3;//TagViewへ移動
        UIs.add(new textBox(0,0,0,0,squareSize,43,true));//0:タグ編集テキストボックス(毎回移動する)
        UIs.add(new searchTextBox(0,50,0,125,200,40));//1:検索ボックス
        UIs.add(new button(0,50,0,50,160,50,10,"フォルダを選択..."));//2:フォルダ選択ボタン
        UIs.add(new button(0,250,0,50,-300,50,10));//3:ディレクトリ表示ボックス
        UIs.get(UIs.size()-1).setLabelAlign('l');//左揃えに変更
        UIs.get(UIs.size()-1).setWidthRate(1);
        UIs.get(UIs.size()-1).setActive(false);
        if(folder!=null)UIs.get(UIs.size()-1).setLabel(folder.getAbsolutePath());
        UIs.add(new button(0,0,0,0,40,40,5,"←"));//4:スタート画面に戻るボタン
        return;
    }
    //10種類なければ分類追加可能(UIsの0~7までの8つが最初からあって8~28までテキストボックスとdeleteボタン)
    //テキストボックスが1つより多ければ削除も可能
    int num_textbox=(UIs.size()-startUIs)/2;//テキストボックスの数
    for(int i=startUIs+1;i<UIs.size();i+=2){
        //println(i+num_textbox*2);
        if(UIs.get(i).mouseOver()&&num_textbox>1){
            //消すところのラベルテキストを前に詰める
            for(int j=i-1;j<UIs.size()-2;j+=2){
                println(j+"→"+j+2);
                UIs.get(j).setLabel(UIs.get(j+2).label);
            }
            UIs.remove(UIs.size()-1);
            UIs.get(UIs.size()-1).delete();
            UIs.remove(UIs.size()-1);
            num_textbox=(UIs.size()-startUIs)/2;
            //println("テキストボックス数: "+num_textbox);
            if(num_textbox<5)UIs.get(7).move(0.5,-100,0.5,60*num_textbox);
            else if(num_textbox<10)UIs.get(7).move(0.5,100,0.5,60*(num_textbox-5));
            return;
        }
    }
    if(UIs.get(7).mouseOver()==true&&num_textbox<10){
        if(num_textbox<5){
            UIs.add(new textBox(0.5,-100,0.5,60*num_textbox,120,30,false));
            UIs.add(new circleButton(0.5,50,0.5,60*num_textbox+15,20,"X"));
        }else{
            UIs.add(new textBox(0.5,100,0.5,60*(num_textbox-5),120,30,false));
            UIs.add(new circleButton(0.5,250,0.5,60*(num_textbox-5)+15,20,"X"));
        }
        //分類を追加するボタンを移動(10種類埋まれば非表示)
        num_textbox=(UIs.size()-startUIs)/2;
        if(num_textbox<5)UIs.get(7).move(0.5,-100,0.5,60*num_textbox);
        else if(num_textbox<10)UIs.get(7).move(0.5,100,0.5,60*(num_textbox-5));
    }
    //分類開始ボタン押されて準備完了してたらscene=1に変更
    //println("分類可能: "+ready2categolize()+"分類開始ボタン: "+UIs.get(5).mouseOver());
    if(UIs.get(5).mouseOver()&&ready2categolize()){
        loadGrid();
        for(int i=startUIs;i<UIs.size();i+=2){
            categoryTxt.add(UIs.get(i).label);//ラベルを分類用のテキストとして保存
            UIs.get(i).delete();//テキストボックスを削除
        }
        while(UIs.size()>0)UIs.remove(0);
        scene=1;
        PImage refreshIcon=loadImage(sketchPath()+"\\LoopArrow(sozai_cman_jp).png");
        refreshIcon.resize(30,30);
        UIs.add(new button(0.5,-size/2-30,0.5,-size/2-150,size+60,size+300,15));//0:真ん中の下地
        UIs.get(UIs.size()-1).setFillColor(color(255,150),color(0));
        UIs.get(UIs.size()-1).setActive(false);
        UIs.add(new button(0.5,-size/2+10,0.5,-size/2-115,size-20,165,0));//1:上のタイトル
        UIs.get(UIs.size()-1).setFillColor(color(74,144,226),color(0));
        UIs.get(UIs.size()-1).setActive(false);
        UIs.add(new button(0.5,size/2+50,0.5,60-size/2,150,475,15));//2:分類表示用サイドパネル
        UIs.get(UIs.size()-1).setFillColor(color(100,150),color(0));
        UIs.get(UIs.size()-1).setActive(false);
        UIs.add(new button(0.5,size/2-135,0.5,size/2+60,125,50,0,"確認"));//3:終了ボタン
        UIs.get(UIs.size()-1).setFillColor(color(74,144,226),color(204,232,255));
        UIs.add(new circleButton(0.5,-size/2+30,0.5,size/2+80,40,refreshIcon,-15,-15));//4:リフレッシュボタン
        UIs.get(UIs.size()-1).setFillColor(color(0,1),color(150));
        startUIs=UIs.size();
        for(int i=0;i<categoryTxt.size();i++){//カテゴリーの選択ボタン
            UIs.add(new button(0.5,size/2+60,0.5,75-size/2+i*45,125,40,10,(i+1)+": "+categoryTxt.get(i)));//5~14:カテゴリー選択ボタン
            UIs.get(UIs.size()-1).setLabelAlign('l');
            UIs.get(UIs.size()-1).setFillColor(color(225),c[i]);
            UIs.get(UIs.size()-1).setLabelColor(c[i],color(255));
            UIs.get(UIs.size()-1).changeInteractionMode(2);//ホバー時はフレーム、選択中は塗りつぶし
            UIs.get(UIs.size()-1).changeTextSize(25);
            if(i==0)UIs.get(UIs.size()-1).setAlways(true);//最初は1つ目の分類を選択中
        }
        return;
    }
}
//フォルダ選択ダイアログ用
void folderSelected(File selection){
  if(selection==null){
    println("Window was closed or the user hit cancel.");
  }else if(selection!=currentFolder){//前に選択したフォルダと違うとき
    println("User selected "+selection.getAbsolutePath());
    folder=selection;
    currentFolder=selection;
    nowLoading=0;
    allimgs=new ArrayList<imgOperator>();//フォルダ選択が変更されると画像のリストも初期化
    addImagePaths(folder,allimgs);
    if(scene==0){
        UIs.get(3).changeTextSize(15);
        if(folder.getAbsolutePath().length()<=20){
            UIs.get(3).setLabel(folder.getAbsolutePath());
        }else{
            UIs.get(3).setLabel(folder.getAbsolutePath().substring(0,18)+"...");
        }
    }else if(scene==3)UIs.get(3).setLabel(folder.getAbsolutePath());
    thread("makeThumbnails");//同じ関数のthreadを複数個所で呼び出すとバグるかも
    thread("tagSetup");
  }
}
//分類する準備ができているか
boolean ready2categolize(){
    if(folder!=null){
        for(int i=startUIs;i<UIs.size();i+=2){
            if(UIs.get(i).label.equals(""))return false;
        }
        return true; //分類に名前がついていて、フォルダが選択されているとき
    }
    return false;
}
//実行結果ウィンドウのFrameを取得する
Frame getFrame(){
    PSurfaceAWT.SmoothCanvas canvas;
    canvas=(PSurfaceAWT.SmoothCanvas)getSurface().getNative();
    return(canvas.getFrame());
}
//縁取り文字を描く(Chat GPT 3)
void outlinedText(String text,int x,int y,int w,int h,int thickness,color outlineColor,color textColor){
  fill(outlineColor);//Outline color
  for(int i=-thickness;i<=thickness;i++)for(int j=-thickness;j<=thickness;j++)text(text,x+i,y+j,w+i,h+j);
  fill(textColor);//Text color
  text(text,x,y,w,h);
}