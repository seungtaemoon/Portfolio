Option Explicit

' ============================================================
' Module: AutomationController
' Purpose: Orchestrates unattended SAP GUI automation
' Design: Excel-driven task queue + defensive execution
' ============================================================

Private Const INPUT_SHEET As String = "TaskQueue"
Private Const LOG_SHEET As String = "ExecutionLog"

Private gSession As Object

' ------------------------------------------------------------
' Entry Point
' ------------------------------------------------------------
Public Sub RunUnattendedAutomation()

    Dim startTime As Double
    startTime = Timer
    
    On Error GoTo FatalError
    
    InitializeEnvironment
    InitializeSapSession
    
    ProcessTaskQueue
    
    CleanupEnvironment
    
    LogMessage "Automation completed successfully in " & _
               Format(Timer - startTime, "0.00") & " seconds.", "INFO"
    
    Exit Sub

FatalError:
    LogMessage "Fatal error: " & Err.Description, "ERROR"
    CleanupEnvironment

End Sub


' ------------------------------------------------------------
' Environment Setup
' ------------------------------------------------------------
Private Sub InitializeEnvironment()

    SuppressAlerts
    
    Application.ScreenUpdating = False
    Application.DisplayStatusBar = True
    Application.StatusBar = "Initializing automation..."
    
    EnsureLogSheetExists
    LogMessage "Environment initialized.", "INFO"

End Sub


Private Sub CleanupEnvironment()

    RestoreAlerts
    
    Application.ScreenUpdating = True
    Application.StatusBar = False
    
    LogMessage "Environment restored.", "INFO"

End Sub


' ------------------------------------------------------------
' SAP Session Initialization
' ------------------------------------------------------------
Private Sub InitializeSapSession()

    Set gSession = GetSapSession()
    
    If gSession Is Nothing Then
        Err.Raise vbObjectError + 2000, , "SAP session could not be initialized."
    End If
    
    LogMessage "SAP session initialized.", "INFO"

End Sub

' ------------------------------------------------------------
' Task Queue Processing
' ------------------------------------------------------------
Private Sub ProcessTaskQueue()

    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets(INPUT_SHEET)
    
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    
    Dim i As Long
    
    For i = 2 To lastRow
        
        Dim materialNumber As String
        materialNumber = Trim(ws.Cells(i, 1).Value)
        
        If materialNumber <> "" Then
            
            Application.StatusBar = "Processing: " & materialNumber
            
            On Error GoTo TaskError
            
            ProcessSingleMaterial materialNumber, i
            
            ws.Cells(i, 2).Value = "SUCCESS"
            LogMessage "Processed: " & materialNumber, "INFO"
            
        End If
        
ContinueLoop:
        DoEvents
        On Error GoTo 0
        
    Next i
    
    Exit Sub

TaskError:
    ws.Cells(i, 2).Value = "FAILED"
    LogMessage "Error processing " & materialNumber & ": " & _
               Err.Description, "ERROR"
    Resume ContinueLoop

End Sub


' ------------------------------------------------------------
' Single Task Execution
' ------------------------------------------------------------
Private Sub ProcessSingleMaterial(ByVal materialNumber As String, _
                                  ByVal rowIndex As Long)

    ' Navigate to transaction (example)
    gSession.FindById("wnd[0]/tbar[0]/okcd").Text = "/nMM03"
    gSession.FindById("wnd[0]").SendVKey 0
    
    ' Input material number
    gSession.FindById("wnd[0]/usr/ctxtRMMG1-MATNR").Text = materialNumber
    gSession.FindById("wnd[0]").SendVKey 0
    
    ' Extract sample fields
    Dim materialDesc As String
    materialDesc = ReadMaterialField(gSession, _
                    "wnd[0]/usr/txtMAKT-MAKTX")
    
    Dim plantStatus As String
    plantStatus = ReadMaterialField(gSession, _
                    "wnd[0]/usr/txtMARC-MMSTA")
    
    ' Write back to Excel
    With ThisWorkbook.Sheets(INPUT_SHEET)
        .Cells(rowIndex, 3).Value = materialDesc
        .Cells(rowIndex, 4).Value = plantStatus
    End With
    
    ' Example file validation logic
    ValidateOutput rowIndex

End Sub


' ------------------------------------------------------------
' Output Validation
' ------------------------------------------------------------
Private Sub ValidateOutput(ByVal rowIndex As Long)

    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets(INPUT_SHEET)
    
    If ws.Cells(rowIndex, 3).Value = "" Then
        Err.Raise vbObjectError + 3000, , _
            "Material description missing."
    End If
    
End Sub


' ------------------------------------------------------------
' Logging System
' ------------------------------------------------------------
Private Sub EnsureLogSheetExists()

    On Error Resume Next
    
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets(LOG_SHEET)
    
    If ws Is Nothing Then
        Set ws = ThisWorkbook.Sheets.Add
        ws.Name = LOG_SHEET
        ws.Range("A1:C1").Value = Array("Timestamp", "Level", "Message")
    End If
    
    On Error GoTo 0

End Sub


Private Sub LogMessage(ByVal message As String, _
                       ByVal level As String)

    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets(LOG_SHEET)
    
    Dim nextRow As Long
    nextRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row + 1
    
    ws.Cells(nextRow, 1).Value = Now
    ws.Cells(nextRow, 2).Value = level
    ws.Cells(nextRow, 3).Value = message

End Sub
