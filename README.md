# New_16pu_firmware

# Memo for Vivado with WSL2 (Ubuntu 20.04)

Windows 11でVivadoを使っていると、たまに原因不明のエラーで、正常にコンパイルが出来なくなる場合がある。おそらく、正確でもないし正解かどうかも知らないが、Windows側で最新のCPUに最適化されたスレッド管理を導入したらしいが、それとVivado側のコンパイルプロセスと相性が合わないような気がする。とは言っても、ほとんどのサンプルコードや簡単な自作コードはすべて正常に動いてくれる。しかし、たまに詰まるとこがあるのは確かなので、ここを自力で何とかするしかない。

一番手っ取り早いのは、Windows 10に乗り換えること。もちろん、Vivado専用のPCだったり、買ったばかりのPCなら、この方法で即解決する問題だが、もうWindows 11から逃れない人生だったら、100個の中で動かない1個のコードをVivadoが処理してくれないからといって、Vivado様のために自分のPCをdowngradeするのは、少し負担が大きい（少なくとも私はそうだった）。

そこで、Windows上でLinuxカーネルが使えるWSLを使う方法を考え、無事合成からプログラムまで成功した。ここには途中詰まったところと、どう解決したかについてメモを残す。

## General
- まず、WSLのデフォルト状態はdisk spaceが256ギガになっているはず。しかし、Vivadoのインストーラーは2022.1バージョン基準、約70ギガであり、解凍されてインストールされたVivado・Vitis・Vitis_HLSはおよそ200ギガに至る。だから、普通にインストールしようとすると、ホスト側のディスクは十分空きがあるのにも関わらず空がないと怒られる。WSLのデフォルトサイズを増やすのも方法だが、個人的にVivadoのためにそこまでやってあげるのはなんかちょっと嫌なので、インストーラーはホストPCに解凍して、インストールはWSLの`/mnt`から入って行うようにした。
- WSLは基本GUIを表示してくれると思うが、もしダメだったら、X11 forwardを使うしかない。ググったら色々出てくるので、詳細は省略。
- Vivado公式文書のインストール手順を追えば多分インストール自体は問題なくできると思う。必要なライブラリの自動インストールもスクリプトとして一緒に入っているので、便利。
- 最後にVivado・Vitis・Vitis_HSLそれぞれのフォルダにある環境変数の`source`も忘れずに。
- petalinuxは特に触ってない。

## License
- VivadoはPCのMACアドレスをライセンス認証に使う。一回で終わるのではなく、毎回合成の段階でボードのライセンス認証をトライし、bitstream生成時にimportされている各IPに対する認証を行う（IPのライセンスによってはシミュレーションまでできてbitstream生成はできない場合があるので）。なので、WSLのMAC addressをライセンス登録に使ったアドレスに変更する必要がある。`sudo ip link set`コマンドを使う。
- MACアドレス変更は毎回WSLを起動するたびにやってあげないといけないので、initするときに変更コマンドが起動するようにしてあげれば便利。嫌だったら毎回変更コマンドを打ってからVivadoを使う。

## JTAG
- 一番驚いた瞬間がここ。Windows 11ではできなかったソースのbitstream生成が無事できて、勝ち組になった気分でボードを繋いだらデバイスリストに何も出てこない状態。しかも、Windows 11側のデバイスマネージャーにも何も出てこない。ググってみたら、みんなただ「ケーブルがおかしいですね」か「ボードが壊れてますね」だけ。
- めちゃめちゃもやもやしながら、WSLをshutdownしてみたら、なんとWindows 11側でデバイスが認識できるようになった。おそらく、WSL自体がUSBデバイス接続をデフォルト状態ではやってくれないので、Vivadoが使うポートがWindowsとWSLがお互いにつながっている？みたい。
- WSL usbip インストールとググったら色々出てきて、それに従って対処したら普通にできるようになった。この場合、もともとWindows側にポートがつながったJTAGが今度はWSLに行ってしまうので、Windows側のVivadoにはデバイスが認識されなくなる。一方が使えない状態で、両方持っているとVivadoだけでほぼ400ギガなので、この時点でWindows上のVivadoを削除した。
