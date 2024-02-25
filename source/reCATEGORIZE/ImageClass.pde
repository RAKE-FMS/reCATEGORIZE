// 画像の表示、当たり判定などを行う

class imgOperator{
    File original;//元のファイルパスを保存
    PImage img;//サムネイル
    int x,y,num,squareSize;
    String category="hidden";
    String initialTagTxt;//最初のタグ全体のテキスト
    String tagTxt;//タグ全体のテキスト(変更するときはこっち)
    boolean allCategorized=false;//全てのタグが付いているかフォルダに分類されている場合
    
    imgOperator(File original,int num,int squareSize){
        this.original=original;
        this.num=num;
        this.squareSize=squareSize;
    }
    //pushMatrix, translate, popMatrixを使って好きな場所に移動する
    void display(int x,int y){
        this.x=x;
        this.y=y;
        pushMatrix();
        translate(x,y);
        if(scene==3){
            noStroke();
            fill(255,150);
            rect(-5,-5,squareSize+10,squareSize+93,5);
            fill(0);
            text(getName(),0,squareSize+10,squareSize,50);
            if(tagTxt==null){
                fill(100);
                text("Loading...",0,squareSize+50,squareSize,50);
            }else if(tagTxt.equals("-")){
                fill(100);
                text("タグを追加...",0,squareSize+50,squareSize,50);
            }
            else text(tagTxt,0,squareSize+50,squareSize,50);
        }
        if(mouseOver()==0){//写真の上にマウスがあるときは枠を表示
            stroke(0);
            rect(-1,-1,squareSize+1,squareSize+1);
        }
        if(img==null){
            fill(100);
            noStroke();
            rect(0,0,squareSize,squareSize);
            fill(200,0,0);
            circle(squareSize/2,squareSize/2,50);
            if(num<nowLoading)loadThumbnail();
        }else image(img,0,0);
        int a=0;
        //タグ分類する時は選択中のタグを色のついた円で表す
        for(int i=0;i<categoryTxt.size();i++)if(category.indexOf(str(i))!=-1){
            noStroke();
            fill(c[i]);
            circle(10+a*7,10,10);
            a++;
        }
        popMatrix();
    }

    int mouseOver(){
        if(x<=mouseX&&mouseX<=x+squareSize&&y<=mouseY&&mouseY<=y+squareSize)return 0;//写真の上
        else if(x<=mouseX&&mouseX<=x+squareSize&&y+squareSize+50<=mouseY&&mouseY<=y+squareSize+93)return 1;//タグの上
        return -1;//被ってない
    }

    //元のファイルパスを返す
    String getAbsolutePath(){
        return original.getAbsolutePath();
    }
    //ファイル名を返す
    String getName(){
        return original.getName();
    }
    //ファイルの移動
    void renameTo(File file){
        original.renameTo(file);
    }
    //サムネイル作成とロード
    void loadThumbnail(){
        File thumbnail=new File(ThumbnailPath());
        if(thumbnail.exists())img=loadImage(thumbnail.getAbsolutePath());
        else{
            if(isImage()==2){
                heic2jpg();
                img=loadImage(thumbnail.getAbsolutePath()+"heic2.jpg");
            }else img=loadImage(original.getAbsolutePath());
            int w=img.width;
            int h=img.height;
            int imgSize=min(w,h);//正方形のサイズを決定する
            int x=(w-imgSize)/2;
            int y=(h-imgSize)/2;
            img=img.get(x,y,imgSize,imgSize);//正方形に切り抜く
            img.resize(squareSize,squareSize);//画像をリサイズ
            img.save(thumbnail.getAbsolutePath());//サムネとして保存
            println("リストの"+num+"番目サムネ完成");
        }
    }
    //ファイル形式が画像かチェック(1:普通の画像,2:HEIC画像)
    int isImage(){
        String[]imageExtensions={".jpg",".jpeg",".png",".gif"}; // 対応する画像ファイルの拡張子(HEIC以外)
        String fileName=original.getName().toLowerCase();//ファイル名を小文字に変換
        for(String extension:imageExtensions){
            if(fileName.endsWith(extension))return 1;//拡張子が一致したら画像ファイルだと判断
        }
        if(fileName.endsWith(".heic"))return 2;//HEICは個別に判断
        return 0;
    }
    //HEIC→jpg
    void heic2jpg(){
        try{
            //入力画像の絶対パス
            String inputPath=original.getAbsolutePath();
            //ファイルの拡張子を除去
            String outputPath=ThumbnailPath()+"heic2.jpg";
            //ImageMagickのconvertコマンドを使用して、HEIC画像をJPG画像に変換
            Process process=Runtime.getRuntime().exec("cmd /c magick convert "+inputPath+" "+outputPath);
            BufferedReader reader=new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while((line=reader.readLine())!=null){
                println(line);
            }
        }catch (IOException e){
            e.printStackTrace();
        }
    }
    //サムネのパスを取得
    String ThumbnailPath(){
        String shortInput=original.getName();
        int dotIndex=shortInput.lastIndexOf('.');
        if(dotIndex!=-1)shortInput=shortInput.substring(0,dotIndex); // 拡張子削除
        //出力画像のパス(別のフォルダに同じ名前のファイルがあったとき用にリストの番号を追加する)
        return sketchPath()+"\\Thumbnails\\"+shortInput+num+"_"+squareSize+".jpg";
    }
    //分類する
    void categolize(String c){
        //フォルダの時か未選択のときはcategoryを置き換える
        if(rule=="folder"||category.equals("unselected"))category=c;
        //タグの場合は選択したものすべて追加できる(同じタグは1度だけ)
        else if(rule=="tag"&&category.indexOf(c)==-1)category+=c;
        // //categoryTxtに含まれるタグがあればcategory="hidden1"(1の分類は済んでいるみたいにする)
        // if(tagTxt!=null){//tagTxtにcategoryTxtと一致するタグがあれば分類済みとする
        //     String[]tags=tagTxt.split(";");
        //     for(int i=0;i<categoryTxt.size();i++)for(String tt:tags)if(categoryTxt.get(i).equals(tt)&&category.indexOf(str(i))==-1)category+=i;
        // }
        allCategorized=true;
        for(int i=0;i<categoryTxt.size();i++)if(category.indexOf(str(i))==-1)allCategorized=false;
        if(allCategorized)println("allCategorized=true");
    }
    //タグの入手
    int getTag(int num){
        String relativePath=original.getAbsolutePath().replace(folder.getAbsolutePath()+"\\","").replace("\\","/");//相対パスをcsvファイルに入ってる形式に変換
        println(relativePath);
        while(!output.getString(num,0).equals(relativePath))num++;
        tagTxt=output.getString(num,1);
        if(tagTxt.equals(""))tagTxt="-";//空欄の時""と"-"の2種類があるので、タグ書き込みで使う"-"に統一
        initialTagTxt=tagTxt;
        num++;
        return num;//次のものに引き渡す
    }
    //タグを編集(毎回csv、ExifToolを使用)
    void setTag(String tagTxt){
        if(tagTxt.equals(""))tagTxt="-";
        this.tagTxt=tagTxt;
        println("このタグをセット:"+tagTxt);
        //csvファイルを使ってExifToolを動かすとき、ハイフンでないと空欄として判定してくれない
        csvTxt=original.getAbsolutePath()+","+tagTxt+","+tagTxt+","+tagTxt+","+tagTxt+","+tagTxt+"\n";
        writeCsvExif();
    }
    //タグの追加(ここではcsvに書き込まない)
    void addTag(String tag){
        String[]tags=tagTxt.split(";");
        for(int i=0;i<tags.length;i++)if(tags[i].equals(tag))return;//全く同じタグがあれば終了
        if(tagTxt.equals("-"))tagTxt=tag;//ハイフンのとき、そのまま代入していい
        else{
            tagTxt+=";";//元のタグがあればセミコロンで区切る
            tagTxt+=tag;//今までのタグを繋げる
        }
        //csvTxt+=original.getAbsolutePath()+","+tagTxt+","+tagTxt+","+tagTxt+","+tagTxt+","+tagTxt+"\n";
        //writeCsvExif();//1回1回タグの書き込みしてみる
    }
    //タグの削除(不要?)
    void deleteTag(String tag){
        String[]tags=tagTxt.split(";");//indexOfだとtagTxt={"a","ab"}とかの時aだけをうまく消せない
        tagTxt="";
        for(int i=0;i<tags.length;i++)if(!tags[i].equals(tag)){
            if(!tagTxt.equals(""))tagTxt+=";";//tagTxtが空じゃなければ;で区切る
            tagTxt+=tags[i];
        }
        if(tagTxt.equals(""))tagTxt="-";//空欄だとタグ書き込みができないからハイフンを入れる
    }
    //tagTxtが変更されていたらcsvTxtに追加
    void setCSV(){
        if(!initialTagTxt.equals(tagTxt))csvTxt+=original.getAbsolutePath()+","+tagTxt+","+tagTxt+","+tagTxt+","+tagTxt+","+tagTxt+"\n";
    }
}