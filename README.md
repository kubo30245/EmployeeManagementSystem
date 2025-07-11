# 社員管理アプリ

## 概要
1万人以上の社員情報を管理するためのアプリです。

主な機能:
- 社員情報の追加、編集、削除
- 社員リストの表示
- 社員情報の追加、編集時に必須項目が入力されているか検証
- 社員情報の追加、編集時に正しい形式のメールアドレスが入力されているか検証
- 社員リストでのページ移動

その他:
- 以下の機能があるテスト用ボタン
  - 社員情報を100人追加
  - 社員情報を10000人追加
  - 社員情報を全て削除

## インストール方法
1. Xcodeのインストール
2. 本プロジェクトのリポジトリをクローン
```
git clone https://github.com/kubo30245/EmployeeManagementSystem.git
```
3. EmployeeManagementSystem.xcodeprojをXcodeで開き、実機もしくはシミュレーターを選択しビルド

## 開発内容
使用技術/ライブラリ: 
- Realm\
社員情報を端末に保存するためのデータベースとして使用。\
Swift Package Managerでインポート

設計/アーキテクチャ:
- MVVM\
SwiftUIにて一般的に広く使用されているため採用

工夫点:
- 社員情報が1万以上あり、バックエンドからの取得に時間がかかることを考慮し、各ページごとに表示に必要な社員情報のみ取得するようにした
- 社員リスト画面のページバーの表示を選択しているページに合わせていい感じに変えるようにした
- コード量を減らし可読性を上げるために、共通で使用可能なViewを作成(InputTextViewやPageButtonなど)
- UIの表示や入力フォームをiPhoneの設定画面などを参考にユーザーにとって馴染みのあるものにした

未対応:
- 社員の検索/フィルター機能
- 社員の画像を追加できる機能
