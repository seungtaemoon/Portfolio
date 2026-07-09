#If VBA7 Then
Private Declare PtrSafe Function ChangeWindowMessageFilter Lib "user32" _
    (ByVal msg As Long, ByVal dwFlag As Long) As Long
#End If

Private Const MSGFLT_ADD As Long = 1
Private Const MSGFLT_REMOVE As Long = 2
Private Const OLE_DIALOG_MSG As Long = &H15B4

Private mOleFilterActive As Boolean

Public Sub BlockOLEDialog()

    On Error Resume Next

    ChangeWindowMessageFilter OLE_DIALOG_MSG, MSGFLT_ADD

    mOleFilterActive = True

    On Error GoTo 0

End Sub

Public Sub RestoreOLEDialog()

    On Error Resume Next

    If mOleFilterActive Then

        ChangeWindowMessageFilter OLE_DIALOG_MSG, MSGFLT_REMOVE

        mOleFilterActive = False

    End If

    On Error GoTo 0

End Sub