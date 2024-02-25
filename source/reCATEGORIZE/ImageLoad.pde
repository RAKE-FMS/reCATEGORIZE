//画像読み込みとサムネ作成

int nowLoading;//今どこを読み込んでいるか

//画像のリストに追加する(サブディレクトリも)
void addImagePaths(File folder,ArrayList<imgOperator>allimgs){
    File[]files=folder.listFiles();//フォルダ内のファイルとサブディレクトリを取得
    for(File file:files){
        if(file.isDirectory()){//サブディレクトリの場合
            addImagePaths(file,allimgs);//再帰的にサブディレクトリ内の画像のパスをリストに追加
        }else if(isImage(file)==1||isImage(file)==2){//画像ファイルの場合
            allimgs.add(new imgOperator(file,allimgs.size(),squareSize));//リストに画像の絶対パスを追加
        }
    }
}
//ファイル形式が画像かチェック(1:普通の画像,2:HEIC画像)
int isImage(File file){
    String[] imageExtensions={".jpg",".jpeg",".png",".gif"};//対応する画像ファイルの拡張子(HEIC以外)
    String fileName=file.getName().toLowerCase();//ファイル名を小文字に変換
    for(String extension:imageExtensions){
        if(fileName.endsWith(extension))return 1;//拡張子が一致したら画像ファイルだと判断
    }
    if(fileName.endsWith(".heic"))return 2;//HEICは個別に判断
    return 0;
}
//ファイル形式がjpg,jpegかチェック(0:その他,1:jpg画像)
int isJpg(int num){
    String[] imageExtensions={".jpg",".jpeg"}; // 対応する画像ファイルの拡張子(jpg,jpeg)
    String fileName=allimgs.get(num).getAbsolutePath().toLowerCase(); // ファイル名を小文字に変換
    for(String extension:imageExtensions){
        if(fileName.endsWith(extension))return 1; // 拡張子が一致したらjpgファイルだと判断
    }
    return 0;
}
//サムネイル作成
void makeThumbnails(){
    for(int i=0;i<allimgs.size();i++){
        allimgs.get(i).loadThumbnail();
        nowLoading++;
        println("サムネ完成:"+nowLoading);
    }
}