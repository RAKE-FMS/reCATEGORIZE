//UI用のクラス群

//基底クラス
class UI{
    float x1,y1,y;//画面のどの割合の位置に表示するか
    int x2,y2,w,h,imgX,imgY;
    float wr=0;//widthとの比率(rate)
    float hr=0;//heightとの比率(rate)
    int textSize=20;
    boolean active=true;//マウスが上にあるときに表示を変えるか
    boolean alwaysOn=false;//常に選択状態か
    color fillNormal=color(200);
    color fillActive=color(204,232,255);
    int interactionMode=0;//0:ノーマル(ホバーで色変わるだけ)　1:フレームの色が変わる　2:ホバーでフレームが付き、クリックで色が変わる
    String label="";
    color labelNormal=color(0);
    color labelActive=color(0);
    char align='c';//ラベルは初期設定でc:中央揃え、l:左揃え、r:右揃え
    PImage img;

    UI(float x1,int x2,float y1,int y2,int w,int h){
        this.x1=x1;
        this.x2=x2;
        this.y1=y1;
        this.y2=y2;
        this.w=w;
        this.h=h;
    }
    //ラベルを設定するとき用
    UI(float x1,int x2,float y1,int y2,int w,int h,String label){
        this.x1=x1;
        this.x2=x2;
        this.y1=y1;
        this.y2=y2;
        this.w=w;
        this.h=h;
        this.label=label;
    }
    //画像を設定するとき用
    UI(float x1,int x2,float y1,int y2,int w,int h,PImage img,int imgX,int imgY){
        this.x1=x1;
        this.x2=x2;
        this.y1=y1;
        this.y2=y2;
        this.w=w;
        this.h=h;
        this.img=img;
        this.imgX=imgX;
        this.imgY=imgY;
    }
    void display(){

    }

    void move(float x1,int x2,float y1,int y2){
        this.x1=x1;
        this.x2=x2;
        this.y1=y1;
        this.y2=y2;
    }

    void move(float x1,int x2,float y1,int y2,imgOperator img){
        this.x1=x1;
        this.x2=x2;
        this.y1=y1;
        this.y2=y2;
    }

    void delete(){

    }
    //削除したものを復活させる
    void set(){

    }

    boolean mouseOver(){
        if(x1*width+x2<=mouseX&&mouseX<=x1*width+x2+w&&y1*height+y2<=mouseY&&mouseY<=y1*height+y2+h)return true;
        return false;
    }
    
    void setWidthRate(float wr){
        this.wr=wr;
    }

    void setHeightRate(float hr){
        this.hr=hr;
    }
    //オーバーラップしてるときの表示の変更をオフにする
    void setActive(boolean active){
        this.active=active;
    }
    //常にオン状態にするか
    void setAlways(boolean alwaysOn){
        this.alwaysOn=alwaysOn;
    }
    //色の変更(ボタン用)
    void setFillColor(color normal,color active){
        fillNormal=normal;
        fillActive=active;
    }
    //フレームの見た目を変えるか塗りつぶす色を変えるか
    void changeInteractionMode(int interactionMode){
        this.interactionMode=interactionMode;
    }
    //ラベルの書き換え
    void setLabel(String txt){
        label=txt;
    }
    //ラベルの色の変更
    void setLabelColor(color normal,color active){
        labelNormal=normal;
        labelActive=active;
    }
    //ラベルを中央揃え以外にする場合に使う
    void setLabelAlign(char align){
        if(align=='c'||align=='l'||align=='r')this.align=align;
    }
    
    void changeTextSize(int textSize){
        this.textSize=textSize;
    }
    //テキストボックスにフォーカスする用
    void requestFocusInWindow(){

    }
}

class button extends UI{
    int c;//角の丸め具合

    button(float x1,int x2,float y1,int y2,int w,int h,int c){
        super(x1,x2,y1,y2,w,h);
        this.c=c;
    }
    //ラベルを表示したいとき
    button(float x1,int x2,float y1,int y2,int w,int h,int c,String label){
        super(x1,x2,y1,y2,w,h,label);
        this.c=c;
    }

    void display(){
        if(interactionMode==0){//塗りつぶしのみ変える
            noStroke();
            if((mouseOver()&&active)||alwaysOn)fill(fillActive);
            else fill(fillNormal);
        }else if(interactionMode==1){//フレームのみ変える
            fill(255);
            if((mouseOver()&&active)||alwaysOn){
                strokeWeight(2);
                if(ready2categolize())stroke(0);
                else stroke(200,0,0);
            }else{
                strokeWeight(1);
                stroke(100);
            }
        }else{//選択中は塗りつぶしの色、ホバー中はフレームを変える
            strokeWeight(1);
            if(mouseOver())stroke(0);
            else noStroke();
            if(alwaysOn)fill(fillActive);
            else fill(fillNormal);
        }
        rect(x1*width+x2,y1*height+y2,wr*width+w,hr*height+h,c);
        textSize(textSize);
        if(alwaysOn)fill(labelActive);
        else fill(labelNormal);
        if(align=='c'){
            textAlign(CENTER,CENTER);
            text(label,x1*width+x2,y1*height+y2,wr*width+w,hr*height+h);
        }else if(align=='l'){
            textAlign(LEFT,CENTER);
            if(alwaysOn)text(label,x1*width+x2+c,y1*height+y2,wr*width+w-c,hr*height+h);
            else outlinedText(label,int(x1*width)+x2+c,int(y1*height)+y2,int(wr*width)+w-c,int(hr*height)+h,2,color(200),labelNormal);
        }else{
            textAlign(RIGHT,CENTER);
            text(label,x1*width+x2,y1*height+y2,wr*width+w-c,hr*height+h);
        }
    }
}

//円のボタン(deleteボタン)
class circleButton extends UI{
    circleButton(float x1,int x2,float y1,int y2,int r){
        super(x1,x2,y1,y2,r,r);
        fillNormal=color(0,1);//カラー変数にalpha0を入れるとちゃんと反映されないのであえて1
        fillActive=color(200,0,0);
    }

    circleButton(float x1,int x2,float y1,int y2,int r,String label){
        super(x1,x2,y1,y2,r,r,label);
        fillNormal=color(0,1);//カラー変数にalpha0を入れるとちゃんと反映されないのであえて1
        fillActive=color(200,0,0);
    }

    circleButton(float x1,int x2,float y1,int y2,int r,PImage img,int imgX,int imgY){
        super(x1,x2,y1,y2,r,r,img,imgX,imgY);
        fillNormal=color(0,1);//カラー変数にalpha0を入れるとちゃんと反映されないのであえて1
        fillActive=color(200,0,0);
    }

    void display(){
        textSize(textSize);
        textAlign(CENTER,CENTER);
        if(interactionMode==0){
            if((mouseOver()&&active)||alwaysOn){//塗りつぶしのみ変える
                fill(fillActive);
                circle(x1*width+x2,y1*height+y2,w);
                fill(255);
                text(label,x1*width+x2,y1*height+y2-1);
            }else{
                fill(fillNormal);
                circle(x1*width+x2,y1*height+y2,w);
                fill(0);
                text(label,x1*width+x2,y1*height+y2-1);
            }
        }else if(interactionMode==1){//フレームのみ変える
            noFill();
            if((mouseOver()&&active)||alwaysOn){
                strokeWeight(1);
                stroke(0);
            }else noStroke();
            circle(x1*width+x2,y1*height+y2,w);
        }
        if(img!=null)image(img,x1*width+x2+imgX,y1*height+y2+imgY);
    }

    boolean mouseOver(){
        if(dist(x1*width+x2,y1*height+y2,mouseX,mouseY)<=w/2)return true;
        return false;
    }
}

class scrollbar extends UI{
    int range;//スクロール可能な範囲
    int now=0;//範囲の中でどこにいるか
    int clickPos=0;//クリックした位置
    boolean dragging=false;//マウスドラッグしているか

    scrollbar(float x1,int x2,float y1,int y2,int w,int h,int range){
        super(x1,x2,y1,y2,w,h);
        this.range=range;
    }

    void display(){
        noStroke();
        fill(fillNormal);
        rect(x1*width+x2,y1*height+y2,w,h);
        if(mouseOver())fill(fillActive);
        else fill(fillNormal);
        rect(x1*width+x2,now,w,int(h/float(range)));
    }

    boolean mouseOver(){
        return false;
    }

    void mousePressed(){
        clickPos=mouseY;
    }
    
    void mouseReleased(){
        now=mouseY-clickPos;
    }
}

class textBox extends UI{
    JTextField txtField;
    boolean tagMode=false;//タグ編集かどうか
    imgOperator img;//タグ編集をするときはあらかじめここに画像ファイルを渡しておく

    textBox(float x1,int x2,float y1,int y2,int w,int h,boolean tagMode){
        super(x1,x2,y1,y2,w,h);
        txtField=new JTextField();
        txtField.setFont(new Font("Yu Gothic UI",Font.PLAIN,20));
        txtField.setBounds(int(x1*width+x2),int(y1*height+y2),w,h);
        pane.add(txtField);
        txtField.addKeyListener(new KeyAdapter(){
            public void keyTyped(java.awt.event.KeyEvent e){
                char c=e.getKeyChar();
                if(isInvalid(str(c))){
                    e.consume();
                    if(rule.equals("folder"))println("ファイル名には次の文字は使えません:\\ / : * ? \" < > |");
                    else println("タグ名には次の文字は使えません:, ;(半角,全角) スペース(半角,全角)");//今はハイフンもコピペでしか打てない
                }
            }
            public void keyPressed(java.awt.event.KeyEvent e){
                if(tagMode){
                    if(e.getKeyCode()==java.awt.event.KeyEvent.VK_ENTER){
                        if(isInvalid(txtField.getText())){
                            println("\"-\"のみのタグ名は使用できません");
                            txtField.setText(label);
                        }else{
                            println(txtField.getText());
                            label=txtField.getText();//テキストボックスのテキストをlabelに代入
                            img.setTag(label);
                            //csvTxt="SourceFile,XPKeywords,Keywords,Subject,LastKeywordXMP,LastKeywordIPTC\n"+allimgs.get(num).getAbsolutePath()+","+tagTxtField.getText()+","+tagTxtField.getText()+","+tagTxtField.getText()+","+tagTxtField.getText()+","+tagTxtField.getText()+"\n";
                            //writeCsvExif();
                        }
                        delete();
                    }else if(e.getKeyCode()==java.awt.event.KeyEvent.VK_ESCAPE)delete();//Escを押したらtagTxtは元のまま
                }
            }
        });
        //テキストボックスにフォーカスしなくなったらlabelを更新
        txtField.addFocusListener(new FocusAdapter(){
            void focusLost(FocusEvent e){
                if(tagMode)delete();//タグ編集では編集を保存せずにテキストボックスを削除
                else if(isInvalid(txtField.getText())){
                    if(rule.equals("folder"))println("システム予約文字および.で始まるファイル名は使用できません");
                    else println("\"-\"のみのタグ名は使用できません");
                    txtField.setText(label);
                }else{
                    println(txtField.getText());
                    label=txtField.getText();//テキストボックスのテキストをlabelに代入
                }
            }
        });
        //タグ編集テキストボックスにアクションリスナーを追加
        txtField.addActionListener(new ActionListener(){
            void actionPerformed(ActionEvent e){
                if(isInvalid(txtField.getText())&&tagMode){
                    println("\"-\"のみのタグ名は使用できません");
                    txtField.setText(label);//元に戻す
                }else if(tagMode){
                    println("タグに"+txtField.getText());
                    label=txtField.getText();//テキストボックスのテキストをinputに代入
                }
            }
        });
        txtField.requestFocusInWindow();//テキストボックス作成と同時にフォーカス
    }
    //移動のみでok
    void display(){
        txtField.setBounds(int(x1*width+x2),int(y1*height+y2),w,h);
    }
    //タグ編集のときは移動と同時にタグ編集する画像ファイルを渡す
    void move(float x1,int x2,float y1,int y2,imgOperator img){
        move(x1,x2,y1,y2);
        this.img=img;
        if(img.tagTxt==null||img.tagTxt.equals("-"))setLabel("");
        else setLabel(img.tagTxt);//タグのテキストをあらかじめ表示
    }

    void delete(){
        pane.remove(txtField);
    }

    void set(){
        if(img.tagTxt!=null)pane.add(txtField);
    }

    void setLabel(String label){
        txtField.setText(label);
        this.label=label;//キーが押されたわけではないので手動で変更する必要がある
    }
    //フォーカスする
    void requestFocusInWindow(){
        txtField.requestFocusInWindow();
    }
}

class searchTextBox extends UI{
    JTextField txtField;

    searchTextBox(float x1,int x2,float y1,int y2,int w,int h){
        super(x1,x2,y1,y2,w,h);
        txtField=new JTextField();
        txtField.setFont(new Font("Yu Gothic UI",Font.PLAIN,20));
        txtField.setBounds(int(x1*width+x2),int(y1*height+y2),w,h);
        pane.add(txtField);
        txtField.requestFocusInWindow();//テキストボックス作成と同時にフォーカス
    }
    //移動のみでok
    void display(){
        txtField.setBounds(int(x1*width+x2),int(y1*height+y2),w,h);
        label=txtField.getText();
        // println("検索ボックス:"+label);
    }

    void delete(){
        pane.remove(txtField);
    }

    void set(){
        pane.add(txtField);
    }

    void setLabel(String label){
        txtField.setText(label);
        this.label=label;//キーが押されたわけではないので手動で変更する必要がある
    }
    //フォーカスする
    void requestFocusInWindow(){
        txtField.requestFocusInWindow();
    }
}