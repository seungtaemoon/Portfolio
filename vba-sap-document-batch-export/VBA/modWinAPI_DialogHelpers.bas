Option Explicit

#If VBA7 Then
Private Declare PtrSafe Function FindWindow Lib "user32" Alias "FindWindowA" _
    (ByVal lpClassName As String, ByVal lpWindowName As String) As LongPtr

Private Declare PtrSafe Function FindWindowEx Lib "user32" Alias "FindWindowExA" _
    (ByVal hWndParent As LongPtr, ByVal hWndChildAfter As LongPtr, _
     ByVal lpClassName As String, ByVal lpWindowName As String) As LongPtr

Private Declare PtrSafe Function SetForegroundWindow Lib "user32" _
    (ByVal hWnd As LongPtr) As Long
#End If

'=== Dialog & file helpers ====================================================

' Korean caption: "다른 이름으로 PDF 저장"
Private Const SAVE_PDF_DIALOG_CAPTION As String = _
    "다른 이름으로 PDF 저장"

' Generic output folder
Private Const BASE_FOLDER_PATH As String = _
    "C:\Users\Developer\Documents\Document_Batch_Output\"

Public Sub EnsureFolderExists(ByVal folderPath As String)
    If Len(folderPath) = 0 Then Exit Sub
    If Dir(folderPath, vbDirectory) = "" Then
        MkDir folderPath
    End If
End Sub

Public Function GetFullFilePath(ByVal material As String) As String
    GetFullFilePath = BASE_FOLDER_PATH & material & "_Document.pdf"
End Function

Public Function FileExists(ByVal fullPath As String) As Boolean
    FileExists = (Dir(fullPath) <> "")
End Function

Public Function AutomateSaveAsDialog(ByVal TargetName As String) As Boolean
    Dim hWnd As LongPtr
    Dim fileName As String
    Dim filePath As String
    Dim Success As Long
    Dim startTime As Date
    Dim timeoutSeconds As Long
    
    fileName = TargetName & "_Document.pdf"
    EnsureFolderExists BASE_FOLDER_PATH
    filePath = BASE_FOLDER_PATH & fileName

    ' Allow the PDF printer time to create the native Save As dialog.
    Application.Wait Now + TimeValue("0:00:02")   ' give a head start

    ' Wait‑loop for the Save As window (max 10 seconds)
    timeoutSeconds = 10
    startTime = Now

    ' Poll until the Save As dialog becomes available (maximum 10 seconds).
    Do
        hWnd = FindWindow(vbNullString, SAVE_PDF_DIALOG_CAPTION)
        If hWnd <> 0 Then Exit Do

        ' Don't burn CPU
        DoEvents
        Application.Wait Now + TimeValue("0:00:01")
    Loop While (Now - startTime) * 86400 < timeoutSeconds   ' * 86400 → seconds

    If hWnd = 0 Then
        MsgBox "Save As window not found within " & timeoutSeconds & " seconds."
        AutomateSaveAsDialog = False
        Exit Function
    End If

    Success = SetForegroundWindow(hWnd)
    If Success = 0 Then
        MsgBox "Failed to activate Save As window."
        AutomateSaveAsDialog = False
        Exit Function
    End If


    Application.Wait Now + TimeValue("0:00:02")
    Application.SendKeys filePath, True

    Application.Wait Now + TimeValue("0:00:02")
    Application.SendKeys "{ENTER}", True

    Application.Wait Now + TimeValue("0:00:02")
    Application.SendKeys "{ENTER}", True

    AutomateSaveAsDialog = True
End Function
