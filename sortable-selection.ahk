#Requires AutoHotkey v2
#Include <WebView2\WebView2>

A_AppDir := A_AppData "\sortable-selection"
DirCreate(A_AppDir "\deps\WebView2\32bit")
DirCreate(A_AppDir "\deps\WebView2\64bit")

FileInstall ".\deps\WebView2\32bit\WebView2Loader.dll", A_AppDir "\deps\WebView2\32bit\WebView2Loader.dll", 1
FileInstall ".\deps\WebView2\64bit\WebView2Loader.dll", A_AppDir "\deps\WebView2\64bit\WebView2Loader.dll", 1
FileInstall ".\frontend.html", A_AppData "\sortable-selection\frontend.html", 1
FileInstall ".\icon.ico", A_AppData "\sortable-selection\icon.ico", 1

TraySetIcon(A_AppDir "/icon.ico")
HtmlSite := A_AppDir "/frontend.html"

OpenGui()
{
  main := Gui('+Resize')

  onClose() {
    wvc := wv := 0
    main.Destroy()
  }
  confirm(lines) {
    wvc := wv := 0
    main.Destroy()
    A_Clipboard := lines
    Send("^v")
  }
  main.OnEvent('Close', (*) => onClose())

  Send("^c")
  ClipWait
  main.Show(Format('w{} h{}', A_ScreenWidth * 0.6, A_ScreenHeight * 0.6))
  wvc := WebView2.create(main.Hwnd, , , , , , A_AppDir "\deps\WebView2\" A_PtrSize * 8 "bit\WebView2Loader.dll")
  wv := wvc.CoreWebView2

  wv.AddHostObjectToScript("ahk", { lines: A_Clipboard, confirm: confirm })
  wv.Navigate(HtmlSite)
}

!+o:: OpenGui()