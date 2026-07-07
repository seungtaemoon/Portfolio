Option Explicit

'=== SAP helpers =============================================================

' Generic SAP GUI element IDs (not real; arbitrary patterns)
Private Const SAP_MATERIAL_FIELD_ID As String = "wnd[0]/usr/ctxtTX_MATNR"
Private Const SAP_EXECUTE_BUTTON_ID As String = "wnd[0]/tbar[1]/btn[11]"
Private Const SAP_GRID_ID As String = "wnd[0]/usr/cntlALV_SHELL"
Private Const SAP_RIR_TAB_ID As String = _
    "wnd[0]/usr/subSA:ZF_RIR_TOOL:0100/subSA_ITEM:ZF_RIR_TOOL:0200/tabsTS/tabpTAB7"
Private Const SAP_RIR_ALV_ID As String = _
    "wnd[0]/usr/subSA:ZF_RIR_TOOL:0100/subSA_ITEM:ZF_RIR_TOOL:0200/tabsTS/tabpTAB7/" & _
    "ssubSA:ZF_RIR_TOOL:0270/cntlC_RIR_LIST/shellcont/shell"
Private Const SAP_RIR_LINK_BUTTON_ID As String = "wnd[0]/tbar[1]/btn[33]"
Private Const SAP_QVD_FIELD_ID As String = _
    "wnd[0]/usr/tabsTS/tabpTAB1/ssubSA_TS:ZQ_RIR_VIEW:9010/txtZQ_RIR-DOKNR"
Private Const SAP_PRINT_BUTTON_ID As String = "wnd[0]/tbar[0]/btn[88]"
Private Const SAP_PRINT_PRINTER_COMBO_ID As String = "wnd[1]/usr/cmbDEVTYPE"
Private Const SAP_PRINT_OK_BUTTON_ID As String = "wnd[1]/tbar[0]/btn[14]"
Private Const SAP_BACK_BUTTON_ID As String = "wnd[0]/tbar[0]/btn[15]"

' Column and status constants
Private Const STATUS_COL As String = "AB"
Private Const QVD_COL As String = "AC"
Private Const MATERIAL_COL As String = "AA"
Private Const FIRST_DATA_ROW As Long = 4

Private Const STATUS_YES As String = "Y"
Private Const STATUS_NO As String = "N"
Private Const STATUS_NA As String = "N/A"

Public Function GetSapSession() As Object
    Dim SapGuiAuto As Object
    Dim SAPApp As Object
    Dim SAPCon As Object
    
    On Error Resume Next
    Set SapGuiAuto = GetObject("SAPGUI")
    If Not SapGuiAuto Is Nothing Then
        Set SAPApp = SapGuiAuto.GetScriptingEngine
        If Not SAPApp Is Nothing Then
            Set SAPCon = SAPApp.Children(0)   ' Adjust if multiple connections
            If Not SAPCon Is Nothing Then
                Set GetSapSession = SAPCon.Children(0) ' Adjust if multiple sessions
            End If
        End If
    End If
    On Error GoTo 0
End Function

Public Function EnterMaterialAndCheckGrid(ByVal session As Object, _
                                          ByVal material As String, _
                                          ByRef grid As Object) As Boolean
    Dim popup As Object
    
    session.findById(SAP_MATERIAL_FIELD_ID).Text = material
    session.findById(SAP_EXECUTE_BUTTON_ID).Press
    
    On Error Resume Next
    Set popup = session.findById(SAP_GRID_ID)
    On Error GoTo 0
    
    If popup Is Nothing Then
        Debug.Print "Material " & material & " is not valid. Moving on."
        ' Try closing potential error popup if exists
        On Error Resume Next
        session.findById("wnd[1]/tbar[0]/btn[0]").Press
        On Error GoTo 0
        
        EnterMaterialAndCheckGrid = False
        Exit Function
    End If
    
    Set grid = popup
    EnterMaterialAndCheckGrid = True
End Function

Public Function NavigateToDocumentViewGrid(ByVal session As Object, _
                                           ByRef grid As Object) As Boolean
    On Error GoTo ErrHandler
    
    session.findById(SAP_GRID_ID).currentCellColumn = "MATNR"
    session.findById(SAP_GRID_ID).doubleClickCurrentCell
    
    session.findById(SAP_RIR_TAB_ID).Select
    session.findById(SAP_RIR_ALV_ID).currentCellColumn = "PRUEFLOS"
    
    Set grid = session.findById(SAP_RIR_ALV_ID)
    
    NavigateToDocumentViewGrid = True
    Exit Function
    
ErrHandler:
    NavigateToDocumentViewGrid = False
End Function

Public Sub ScanGridRowsForDocumentLink(ByVal grid As Object, ByVal rowCount As Long)
    Dim j As Long
    
    For j = 0 To rowCount - 1
        On Error Resume Next
        grid.currentCellRow = j
        grid.doubleClickCurrentCell
        If Err.Number <> 0 Then
            Err.Clear
        End If
        On Error GoTo 0
    Next j
End Sub

Public Sub GoBackToMaterialSelection(ByVal session As Object, ByVal times As Long)
    Dim n As Long
    For n = 1 To times
        On Error Resume Next
        session.findById(SAP_BACK_BUTTON_ID).Press
        On Error GoTo 0
    Next n
End Sub

Public Sub ClearMaterialField(ByVal session As Object)
    With session.findById(SAP_MATERIAL_FIELD_ID)
        .Text = ""
        .SetFocus
        .caretPosition = 0
    End With
End Sub

Public Sub ExitSubCleanSap(ByRef session As Object)
    Dim SAPCon As Object
    Dim SAPApp As Object
    Dim SapGuiAuto As Object
    
    On Error Resume Next
    Set SAPCon = Nothing
    Set SAPApp = Nothing
    Set SapGuiAuto = Nothing
    Set session = Nothing
    On Error GoTo 0
End Sub

Public Function PrintDocumentToPdf(ByVal session As Object, _
                                   ByVal material As String) As Boolean
    session.findById(SAP_PRINT_BUTTON_ID).Press
    
    session.findById(SAP_PRINT_PRINTER_COMBO_ID).Key = "Virtual PDF Printer"
    session.findById(SAP_PRINT_PRINTER_COMBO_ID).SetFocus
    session.findById(SAP_PRINT_OK_BUTTON_ID).Press
    
    PrintDocumentToPdf = AutomateSaveAsDialog(material)
End Function