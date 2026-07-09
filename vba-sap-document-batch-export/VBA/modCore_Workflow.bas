Option Explicit

' Re‑declare keys needed here (or put constants in a separate modConsts.bas)
Private Const STATUS_COL As String = "C"
Private Const DOC_COL As String = "D"
Private Const MATERIAL_COL As String = "B"
Private Const FIRST_DATA_ROW As Long = 2

Private Const STATUS_YES As String = "Y"
Private Const STATUS_NO As String = "N"
Private Const STATUS_NA As String = "N/A"

Private Const SAP_RIR_LINK_BUTTON_ID As String = "wnd[0]/tbar[1]/btn[33]"
Private Const SAP_DOC_FIELD_ID As String = _
    "wnd[0]/usr/tabsTS/tabpTAB1/ssubSA_TS:ZQ_RIR_VIEW:9010/txtZQ_RIR-DOKNR"
Private Const SAP_BACK_BUTTON_ID As String = "wnd[0]/tbar[0]/btn[15]"

' Excel sheet module‑level reference
Public ws As Worksheet

'=== Core handlers ============================================================

Public Sub HandleMaterialWithoutFile(ByVal rowIndex As Long, _
                                     ByVal material As String, _
                                     ByVal fullFilePath As String)
    Dim session As Object
    Dim grid As Object
    Dim rowCount As Long
    Dim docLink As Object
    Dim docId As String
    
    Debug.Print fullFilePath & " not created yet (status 'N')."
    
    Set session = GetSapSession()
    If session Is Nothing Then
        Debug.Print "Unable to get SAP session. Aborting row " & rowIndex
        Exit Sub
    End If
    
    If Not EnterMaterialAndCheckGrid(session, material, grid) Then
        ws.Cells(rowIndex, STATUS_COL).Value = STATUS_NA
        ws.Cells(rowIndex, DOC_COL).Value = STATUS_NA
        ExitSubCleanSap session
        Exit Sub
    End If
    
    ' Navigate to document view and ALV grid
    If Not NavigateToDocumentViewGrid(session, grid) Then
        Debug.Print "Failed to navigate to document view grid."
        ws.Cells(rowIndex, STATUS_COL).Value = STATUS_NA
        ExitSubCleanSap session
        Exit Sub
    End If
    
    rowCount = grid.rowCount
    
    ' Try double‑clicking each row to activate potential document link
    ScanGridRowsForDocumentLink grid, rowCount
    
    ' If no valid link in the column, attempt to use the generic document‑open button
    Set docLink = session.findById(SAP_RIR_LINK_BUTTON_ID, False)
    
    If docLink Is Nothing Then
        Debug.Print "No document found. Returning to the initial screen, setting status to 'N/A'."
        ws.Cells(rowIndex, STATUS_COL).Value = STATUS_NA
        GoBackToMaterialSelection session, 2
        ExitSubCleanSap session
        Exit Sub
    End If
    
    ' Document is available
    Debug.Print "Document located."
    
    docId = session.findById(SAP_DOC_FIELD_ID).Text
    Debug.Print "Document ID value: " & docId
    ws.Cells(rowIndex, DOC_COL).Value = docId

    docLink.Press
    
    ' Print and save as PDF
    If Not PrintDocumentToPdf(session, material) Then
        Debug.Print "Program interrupted during Save As. Exiting macro."
        ExitSubCleanSap session
        Exit Sub
    End If
    
    ws.Cells(rowIndex, STATUS_COL).Value = STATUS_YES
    Debug.Print "Created file: " & fullFilePath & " (status 'Y')."
    
    ' Return to initial material selection screen
    GoBackToMaterialSelection session, 4
    ClearMaterialField session
    
    ExitSubCleanSap session
End Sub

Public Function CleanMaterialText(ByVal rawText As String, _
                                  ByVal regex As Object) As String
    Dim result As String
    
    rawText = CStr(rawText)
    
    If regex.Test(rawText) Then
        result = regex.Replace(rawText, "")
    Else
        result = Trim$(rawText)
    End If
    
    CleanMaterialText = result
End Function
