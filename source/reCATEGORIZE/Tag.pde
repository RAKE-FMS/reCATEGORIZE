//タグの操作

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.FileWriter;
import java.io.OutputStreamWriter;
import java.io.FileOutputStream;
import java.io.BufferedWriter;

String exifToolPath,csvOutputPath,csvInputPath;
String csvBase="SourceFile,XPKeywords,Keywords,Subject,LastKeywordXMP,LastKeywordIPTC\n";//CSVファイルの最初の1行
String csvTxt="";//csvファイルの2行目以降(まとめて書き込むときに使う)
Table output;//出力csvファイル用

//タグの読み込み(CSVファイルにまとめてタグを書き出す)
void tagSetup(){
    try{//ExifToolでjpgタグの編集
        //-r:サブディレクトリもすべて網羅,-F:,-overwrite_original:コピーを作らない
        int start=millis();
        Process p=Runtime.getRuntime().exec("cmd /c cd "+folder.getAbsolutePath()+" && "+exifToolPath+" -r -XPKeywords -Keywords -Subject -LastKeywordXMP -LastKeywordIPTC -csv * > \""+csvOutputPath+"\"");
        p.waitFor();
        BufferedReader reader=new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line;
        while((line=reader.readLine())!=null)println(line);
        println("タグ読み込み完了"+(millis()-start));
    }catch(Exception e){
        e.printStackTrace();
    }
    output=loadTable("output.csv","header");//"header": 1行目を無視する
    //csvファイルから検索してtagTxtに代入
    int num=0;//今何行目か
    for(int i=0;i<allimgs.size();i++){
        println(num);
        num=allimgs.get(i).getTag(num);//numの値を更新する必要がある(同じ場所を何回も見なくていい)
    }
    println("タグセット完了");
}
//CSVファイルに情報を入れてjpgにタグ情報をまとめて書き込む
void writeCsvExif(){
    try{//CSVファイルの準備
        BufferedWriter writer=new BufferedWriter(new OutputStreamWriter(new FileOutputStream(csvInputPath), "UTF-8"));
        writer.write(csvBase+csvTxt);
        writer.close();
        println("csvファイルに書き込み完了");
    }catch(IOException e){
        e.printStackTrace();
    }
    try{//ExifToolでjpgタグの編集
        //-r:サブディレクトリもすべて網羅,-F:,-overwrite_original:コピーを作らない
        Process p=Runtime.getRuntime().exec("cmd /c cd "+folder.getAbsolutePath()+" && "+exifToolPath+" -r -F -sep \";\" -overwrite_original -csv=\""+csvInputPath+"\" -codedcharacterset=utf8 -charset iptc=latin2 .");
        p.waitFor();
        BufferedReader reader=new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line;
        while((line=reader.readLine())!=null)println(line);
        println("タグ付け完了");
    }catch(Exception e){
        e.printStackTrace();
    }
}