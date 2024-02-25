// 分類する時のグリッド表示、サイドパネル表示

import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;

ArrayList<imgOperator>allimgs=new ArrayList<imgOperator>();//画像を格納するリスト
ArrayList<String>categoryTxt=new ArrayList<String>();//分類する種類リスト
String rule="tag";//分類方法
int[]gridNum;//グリッドに表示されている写真がallimgsの何番目か(-1でリストの範囲外)
int gridSize=4;//グリッド1辺あたりの写真枚数
int squareSize=100;//サムネサイズ
int size=gridSize*squareSize+10*(gridSize+1);//グリッドそのもののサイズ
int selector;//今選択しているカテゴリーの設定
//色:赤、緑、青、紫、オレンジ、黄色、水色、ピンク、黄緑、茶色
color[]c={color(255,59,48),color(52,199,89),color(0,122,255),color(175,82,222),color(255,149,0),color(255,204,0),color(2,168,242),color(240,0,130),color(158,199,0),color(148,86,42)};

//写真の初回ロード(カテゴリーが非表示から表示(未選択)に変わっちゃうから、サイズ変更用の関数は別で用意)
void loadGrid(){
    gridNum=new int[int(sq(gridSize))];
    for(int i=0;i<gridNum.length;i++)loadNewImg(i);//写真読み込み(1枚ずつ)
}
//写真をグリッド表示(スクエア)
void drawClassify(){
    for(int j=0;j<UIs.size();j++)UIs.get(j).display();
    textSize(20);
    fill(255);
    textAlign(LEFT);
    text("の画像をすべて選択してください",width/2-size/2+25,height/2-size/2);
    textSize(40);
    text(categoryTxt.get(selector),width/2-size/2+25,height/2-size/2-30);
    for(int i=0;i<gridNum.length;i++){
        int x=width/2+(squareSize+10)*(i%gridSize)-size/2+10;
        int y=height/2+(squareSize+10)*(i/gridSize)-size/2+60;
        if(gridNum[i]==-1){//画像がないときは四角形を表示
            noStroke();
            fill(100);
            rect(x,y,squareSize,squareSize);
        }else allimgs.get(gridNum[i]).display(x,y);
    }
}
//クリックされたとき
void ClassifyOperate(){
    //画像が押されたとき
    for(int i=0;i<gridNum.length;i++)if(gridNum[i]!=-1){
        if(allimgs.get(gridNum[i]).mouseOver()==0){
            allimgs.get(gridNum[i]).categolize(str(selector));
            if(rule=="folder"||allimgs.get(gridNum[i]).allCategorized)loadNewImg(i);//フォルダの場合は分類した所、タグの場合は全タグつけたものだけ新しく画像を読み込む
        }
    }
    //確認ボタンが押されたとき
    if(UIs.get(3).mouseOver()){
        if(rule.equals("folder"))for(int i=0;i<categoryTxt.size();i++){
            // 分類ごとにフォルダを作成
            File dir=new File(folder,categoryTxt.get(i));
            dir.mkdir();
            for(int j=0;j<allimgs.size();j++)if(allimgs.get(j).category.equals(str(i)))allimgs.get(j).renameTo(new File(dir,allimgs.get(j).getName()));
        }else if(rule.equals("tag")){
            csvTxt="";//csvテキストをリセット
            for(int i=0;i<allimgs.size();i++){//タグの時はcategoryに数字が含まれていたら追加
                for(int j=0;j<categoryTxt.size();j++)if(allimgs.get(i).category.indexOf(str(j))!=-1)allimgs.get(i).addTag(categoryTxt.get(j));//i番目の画像にj個目のタグを追加
                allimgs.get(i).setCSV();//タグに変更があればcsvTxtに追加
            }
            writeCsvExif();//最後にまとめてExifToolで書き込み
        }
    }
    //リフレッシュボタンが押されたとき
    if(UIs.get(4).mouseOver()){
        println("refresh");
        for(int i=0;i<gridNum.length;i++){
            loadNewImg(i);//全グリッドを変更
        }
    }
    for(int i=startUIs;i<UIs.size();i++)if(UIs.get(i).mouseOver()){
        selector=i-startUIs;
        UIs.get(i).setAlways(true);
        for(int j=startUIs;j<UIs.size();j++)if(i!=j)UIs.get(j).setAlways(false);//他のボタンはオフに
    }
}
//分類した所(グリッドのnum番目)に新しく画像を読み込む(全画像を読み込み終わったらnullで更新する)
void loadNewImg(int num){
    int i=0;//リストのi番目を読み込む
    // iがリストの範囲に入ればi番目を表示　範囲外なら読み込まない
    while(!allimgs.get(i).category.equals("hidden")){//未表示か選択しなかった場合
        i++;
        if(i==allimgs.size())break;//リスト範囲外に出たら繰り返さない
    }
    if(i==allimgs.size()){//リストの最後まで来たとき
        gridNum[num]=-1;//このグリッドは空(intにnullは入らない)
        println("リストの外だよ");
    }else{
        allimgs.get(i).category="unselected";//表示状態に変更
        gridNum[num]=i;//gridNumを更新
    }
}
//番号の入力で分類するものを数字キーで決定(分類に含まれないボタンを押しても反応しない)
void select(){
    int num=(key-39)%10;
    if(48<=key&&key<=58&&0<=num&&num<categoryTxt.size()){
        selector=(key-39)%10;//0~9までのリストなら1~0の順で選択できる(キーボードの順番)
        for(int i=startUIs;i<UIs.size();i++)if(i==startUIs+selector)UIs.get(i).setAlways(true);
        else UIs.get(i).setAlways(false);
    }
}