Option Explicit

Public ws As Worksheet

'=== Public entry point =======================================================

' Batch PDF generation macro name (generic, no internal abbreviations)
Public Sub CreateFilesInGroupFolders_Document_Batch_PDF()

    Dim lastRow As Long
    Dim i As Long
    Dim cellValue As String
    Dim txt() As String
    Dim k As Long
    Dim splitTxt As String
    Dim fileStatus As String
    Dim fullFilePath As String
    Dim regex As Object

    Dim oldScreenUpdating As Boolean
    Dim oldEnableEvents As Boolean
    Dim oldDisplayAlerts As Boolean
    
    oldScreenUpdating = Application.ScreenUpdating
    oldEnableEvents = Application.EnableEvents
    oldDisplayAlerts = Application.DisplayAlerts

    On Error GoTo FailSafe
    
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    Application.DisplayAlerts = False

    ' Enable runtime OLE protection during long-running SAP automation.
    BlockOLEDialog
    
    Set ws = ThisWorkbook.ActiveSheet
    
    EnsureFolderExists BASE_FOLDER_PATH
    
    lastRow = ws.Cells(ws.Rows.Count, MATERIAL_COL).End(xlUp).Row
    
    Set regex = CreateObject("VBScript.RegExp")
    regex.Pattern = "\s*\([^)]*\)$"    ' trailing space + (anything)
    regex.Global = False
    
    For i = FIRST_DATA_ROW To lastRow
        Debug.Print "Row:", i
        
        If IsError(ws.Cells(i, MATERIAL_COL).Value) Then
            Debug.Print "Invalid material code (Error) in row " & i & ". Skipping."
            GoTo NextRow
        End If
        
        cellValue = CStr(ws.Cells(i, MATERIAL_COL).Value)
        Debug.Print "Target value: " & cellValue
        
        txt = Split(cellValue, vbLf)
        
        For k = LBound(txt) To UBound(txt)
        
            splitTxt = CleanMaterialText(txt(k), regex)
            If splitTxt = "" Then GoTo NextMaterialInCell
            
            If splitTxt = STATUS_NA Then
                Debug.Print "The cell value is " & STATUS_NA & ", skipping to the next row."
                GoTo NextRow
            End If
            
            Debug.Print "Processing material: " & splitTxt
            
            fileStatus = CStr(ws.Cells(i, STATUS_COL).Value)
            fullFilePath = GetFullFilePath(splitTxt)
            
            Select Case fileStatus
            Case "", STATUS_NO
                If Not FileExists(fullFilePath) Then
                    HandleMaterialWithoutFile i, splitTxt, fullFilePath
                Else
                    ws.Cells(i, STATUS_COL).Value = STATUS_YES
                    Debug.Print "File exists, status updated: " & fullFilePath & " (status is 'Y')."
                End If
                
            Case STATUS_NA
                Debug.Print "Skipping row " & i & " as no document can be found (status 'N/A')."
                
            Case Else
                Debug.Print "Skipping row " & i & " (status already " & fileStatus & ")."
            End Select
            
NextMaterialInCell:
        Next k
        
NextRow:
    Next i

GoTo CleanExit

CleanExit:

' Restore the original Windows message filter.
RestoreOLEDialog

Application.ScreenUpdating = oldScreenUpdating
Application.EnableEvents = oldEnableEvents
Application.DisplayAlerts = oldDisplayAlerts

MsgBox "File creation in group folders complete.", vbInformation
Exit Sub

FailSafe:

' Restore the original Windows message filter.
RestoreOLEDialog

Application.ScreenUpdating = oldScreenUpdating
Application.EnableEvents = oldEnableEvents
Application.DisplayAlerts = oldDisplayAlerts

MsgBox "Error " & Err.Number & vbCrLf & Err.Description, vbExclamation

End Sub
