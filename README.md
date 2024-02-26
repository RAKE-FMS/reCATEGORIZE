# reCATEGORIZE
## 概要
**ExifTool**と**ImageMagick**を用いたWindows向け画像分類アプリです。
現段階ではバグが多いため、ファイルの上書きや競合が不安なフォルダでは使用しないでください。

## 導入方法、注意事項
Processing、ImageMagickは事前にインストールが必要です。ImageMagickはコマンドプロンプトでmagick -convertコマンドが使用できることを確認してください。Processingのコードをexe化できればProcessingのインストールが不要になります。
ExifToolはsourceフォルダに内蔵されています。

## 分類方法
分類方法には、フォルダによる分類とタグによる分類の2種類があります。
reCAPTCHA認証をオマージュした分類画面で整理したのち、完了ボタンを押すことで分類できます。

## 検索モード
また、選択したフォルダ内の各画像のタグを閲覧、検索、編集できるモードを実装しています。

## 対応ファイル
png, jpg, jpeg, gif, HEIC
png, jpg, jpeg, gif(未検証)はProcessingが標準で対応しています。HEICにはImageMagickが対応していて、一度jpgに変換して使用しています。

## ExifToolの用途
ExifToolを用いて、画像のタグであるXPKeywords, Keywords, Subject, LastKeywordXMP, LastKeywordIPTCを編集することができます。これらはjpgでタグとして認識されます(?)が、png、HEIC画像には標準で存在しないタグです(多分)。今回、png、HEIC画像にも無理矢理これらのタグをつけているため、一部の画像でタグが反映されないことがあります。現時点では、pngファイルの一部でこのエラーが発生しています。
