Option Explicit

Public Function GetSapSession() As Object
    Dim SapGuiAuto As Object
    Dim SapApp As Object
    Dim SapConnection As Object
    Dim SapSession As Object

    On Error Resume Next
    Set SapGuiAuto = GetObject("SAPGUI")
    Set SapApp = SapGuiAuto.GetScriptingEngine
    Set SapConnection = SapApp.Children(0)
    Set SapSession = SapConnection.Children(0)
    On Error GoTo 0

    If SapSession Is Nothing Then
        Err.Raise vbObjectError + 1000, , "SAP session not found"
    End If

    Set GetSapSession = SapSession
End Function
