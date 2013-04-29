/*
    kn.ahk v0.04 (for Kuin 0.023)
        Kuinをコマンドプロンプトからコンパイルするツールです。
        Last Modified: 2013/04/30 00:53:32.
        Created by @tatt61880
            https://twitter.com/tatt61880
            https://github.com/tatt61880
*/

; タイトルの一致を正規表現モードにする。
SetTitleMatchMode,RegEx

;現在アクティブなウィンドウのpidを取得。
WinGet, currentPID, PID, A

IfWinNotExist, Kuin, ソースファイル
{
    Run, Kuin.exe
}

WinWait, Kuin, ソースファイル, 3
WinGet, kuinPID, PID, A ;Kuin.exeのpidを取得。

; スクリプトに引数有りの場合、ソースファイルを指定
if 0 > 0 ; 引数の個数が1以上
{
    kn_filename = %1% ; 第一引数：フォルダを除いたファイル名
    if RegExMatch(kn_filename, ".kn$") = 0 ; 引数が 「～.kn」でなかった場合
    {
        msgbox,
(
【使用方法】kn.exe Sample.kn [run]

例1: kn.exe Sample.kn
Sample.knをコンパイル。

例2: kn.exe Sample.kn run
Sample.knのコンパイルに成功した場合、Sample_dbg.exeを実行する。
)
        exit 1 ; 引数が正しくなかったため、終了
    }

    filename_fullpath = %A_WorkingDir%\%kn_filename%
    ControlSetText, WindowsForms10.EDIT.app.0.378734a4, %filename_fullpath%, Kuin, ソースファイル
}

; [コンパイル(&C)]をクリック
ControlSend, コンパイル, {SPACE}, Kuin, ソースファイル
if ErrorLevel > 0
{
    msgbox コンパイルエラー？ (@tatt61880)
    exit 1
}

; アクティブウィンドウを元に戻す
if(currentPID <> kuinPID){
    ;WinMinimize, Kuin, ソースファイル
    WinActivate, ahk_pid %currentPID%
}

; コンパイル結果の解析開始
WinGetText, KuinText, Kuin, ソースファイル
if (RegExMatch(KuinText, "(Error.*)", KuinErrorMessage1) <> 0) {
    /*
    ;エラーをクリップボードに格納（「Kuinのコンパイルエラー一覧(非公式)」を作成する際に活用していました。）
    cliptext := KuinErrorMessage1
    cliptext := RegExReplace(cliptext, "^Error: (E\d+ )", "$1`t")
    cliptext := RegExReplace(cliptext, "\[.*?\]$", "")
    clipboard = %cliptext%
    */

    KuinErrorMessage1 := RegExReplace(KuinErrorMessage1, "(Error: E\d+ )", "$1`n")
    KuinErrorMessage1 := RegExReplace(KuinErrorMessage1, "`t", "`n")
    KuinErrorMessage1 := RegExReplace(KuinErrorMessage1, "。", "。`n")
    msgbox, %KuinErrorMessage1%
    Exit, 1
} else {
    RegExMatch(KuinText, "(コンパイル時間: .*)", compileTime)
    compileTime := RegExReplace(compileTime, ": (00:)*0?", ": ")
    ToolTip %compileTime%

    if 0 > 1 ; 引数の個数が2以上
    {
        if 2 = run ; 第二引数が "run"
        {
            exe_filename := RegExReplace(kn_filename, ".kn$", "_dbg.exe")
            exe_fullpath = %A_WorkingDir%\%exe_filename%
            if (RegExMatch(kn_filename, "\\") = 0) {
                ; 引数にディレクトリが含まれない場合
                Run, %exe_fullpath%, %A_WorkingDir%
            } else {
                ; 引数にディレクトリが含まれる場合
                dir := RegExReplace(kn_filename, "\\[^\\]*$", "")
                ; 作業ディレクトリとして、.knファイルの置いてあるフォルダを指定して実行
                Run, %exe_fullpath%, %A_WorkingDir%\%dir%
            }
        }
    }
    Sleep 1000
    Exit, 0
}

