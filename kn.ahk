/*
    kn.ahk v0.982 (for Kuin 0.98)
        Kuinをコマンドプロンプトからコンパイルするツールです。
        Last Modified: 2013/09/15 08:14:46.
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
Sample.knのコンパイルに成功した場合、作成されたexeを実行する。
)
        exit 1 ; 引数が正しくなかったため、終了
    }

    if (RegExMatch(kn_filename, "(^[\\])|:")) {
        ; 引数にコロン(:)が含まれるため、フルパスが渡されていると仮定する。
        filename_fullpath = %kn_filename%
    } else {
        filename_fullpath = %A_WorkingDir%\%kn_filename%
    }
    ControlSetText, WindowsForms10.EDIT.app.0.378734a3, %filename_fullpath%, Kuin, ソースファイル
}

exe_filename := RegExReplace(kn_filename, ".kn$", "_dbg.exe")
exe_fullpath = %A_WorkingDir%\%exe_filename%

; 念のため、古いファイルは削除しておく。
if 0 > 1 ; 引数の個数が2以上
{
    if 2 = run ; 第二引数が "run"
    {
        FileDelete, %exe_fullpath%
    }
}

if 0 > 1 ; 引数の個数が2以上
{
    if 2 = run ; 第二引数が "run"
    {
        ; [コンパイル＆実行]をクリック
        ControlSend, コンパイル, {SPACE}, Kuin, ソースファイル
    }
} else {
    ; [文法チェック]をクリック
    ControlSend, 文法チェック, {SPACE}, Kuin, ソースファイル
}
Sleep 50
if ErrorLevel > 0
{
    msgbox コンパイルエラー？ kn.ahkの影響かもしれないので@tatt61880に問合わせてください。
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
    RegExMatch(KuinText, "意味解析完了: .*", compileTime)
    compileTime := RegExReplace(compileTime, ": (00:)*0?", ": ")
    ToolTip %compileTime%

    Sleep 1000
    Exit, 0
}

