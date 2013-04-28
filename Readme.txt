/*
    kn.exe v0.02 (for Kuin 0.023)
        Kuinをコマンドプロンプトからコンパイルするツールです。
        Last Modified: 2013/04/29 01:38:16.
        Created by @tatt61880
            https://twitter.com/tatt61880
            https://github.com/tatt61880
*/

【概要】
    kn.exeは、コマンドプロンプトからKuin.exeの[コンパイル]ボタンのクリックを発生させるツールです。
    ※Kuin.exeはくいなちゃん(@kuina_tesso)が作成した、Kuinの処理系です。

    AutoHotkeyを持っていない人のために、バイナリ(kn.exe)を公開しています。
    （ソースコード(kn.ahk)も公開しています）

【免責事項】
    作者は、このツールにより生じたいかなる損害の責任も負わないものとします。

【使用方法】
    1. kn.exeをKuin.exeと同じフォルダにおいてください。
    2. Kuin.exeをアクティブ状態にした時に、[コンパイル]ボタンが画面に入るようにしてください。
       （[コンパイル]ボタンが画面外にあると、コンパイル結果が更新されません。）
    3. コマンドプロンプトから実行します。kn.exe [sourcefile.kn [run]]
       sourcefile.knは、kn.exeの置いてあるフォルダからの相対パスで入力してください。
        例1: kn.exe
            Kuin.exeのソースファイル欄が空欄だろうがなんだろうが、とにかくコンパイル。
        例2: kn.exe dir\test.kn
            dirフォルダのtest.knをコンパイル。
        例3: kn.exe dir\test.kn run
            dirフォルダのtest.knのコンパイル。
                →コンパイルに成功した場合: test_dbg.exeを実行する。
                ※この時の作業フォルダはdirフォルダです。

【不具合を発見された場合】
    @tatt61880にご連絡頂けると幸いです。
        https://twitter.com/tatt61880
    interviews経由で匿名で指摘頂いても構いません。
        http://theinterviews.jp/tatt61880/interview

    不具合でなくても、改善案があれば、是非教えてください。
    【既知の不具合】
        [コンパイル]ボタンが画面外にある場合にコンパイルできない。この時、前回の結果が再度表示される。

【更新履歴】
    v0.02 (2013/04/29)
        [変更] AutoHotkeyの64bit版でexe化するようにしたため、64bit Windowsのみで利用可能です。
        [修正] runコマンドでexeを実行時に、作業フォルダがkn.exeの置いてある場所になってしまっていたのを修正しました。
               .knファイルの置いてある場所で実行します。
    v0.01 (2012/09/01)
        [初公開] Kuin 0.023用です。

【その他】
    このツールの作成にあたり、「AutoHotkeyを流行らせるページ」の情報にお世話になりました。
        AutoHotkeyを流行らせるページ
        http://ahk.xrea.jp/

