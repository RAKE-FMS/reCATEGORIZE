// テキストボックス

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

JLayeredPane pane;
ArrayList<String>txtInput=new ArrayList<String>();//複数のテキストボックスに対応
String[]invalidFileCharacters={"\\","/",":","*","?","\"","<",">","|"};
String[]reservedFileNames={"con","prn","aux","nul","com1","com2","com3","com4","com5","com6","com7","com8","com9","lpt1","lpt2","lpt3","lpt4","lpt5","lpt6","lpt7","lpt8","lpt9",};
String[]invalidTagCharacters={",",";"," ","　"};//CSVファイルの都合上コロンで勝手に区切られてしまう
String reservedTagName="-";//タグが何もないときも-を返すので、-のみのタグ名は禁止(今は-とりあえず完全禁止中)

// システム予約文字(Windows)か、.で始まる名前(Mac)を避ける
boolean isInvalid(String txtInput){
    txtInput=txtInput.toLowerCase();
    if(scene==0){ // 初期画面
        if(rule=="folder"){
            if(txtInput.startsWith("."))return true; // .で始まるファイル名はダメ(Mac)
            for(int i=0;i<reservedFileNames.length;i++)if(txtInput.equals(reservedFileNames[i]))return true;
            // 文字列を1文字ずつ調べる
            for (int j=0;j<txtInput.length();j++){
                String c=txtInput.substring(j,j+1); // 文字列のj番目の文字を取得
                // 文字列のi番目の文字が禁則文字と一致する場合
                for(int k=0;k<invalidFileCharacters.length;k++)if(c.equals(invalidFileCharacters[k]))return true;
            }
        }else{ // タグの時
            if(txtInput.equals(reservedTagName))return true;
            for(int j=0;j<txtInput.length();j++){
                String c=txtInput.substring(j,j+1); // 文字列のj番目の文字を取得
                for(int k=0;k<invalidTagCharacters.length;k++)if(c.equals(invalidTagCharacters[k]))return true;
            }
        }
    }else if(scene==3){ // タグ編集画面
        for(int i=0;i<txtInput.length();i++){
            String c=txtInput.substring(i,i+1);
            if(c.equals(",")||c.equals("-"))return true;
        }
    }
    return false;
}