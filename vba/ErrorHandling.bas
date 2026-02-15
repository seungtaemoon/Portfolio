Option Explicit

Public Sub SuppressAlerts()
    Application.DisplayAlerts = False
    Application.EnableEvents = False
End Sub

Public Sub RestoreAlerts()
    Application.DisplayAlerts = True
    Application.EnableEvents = True
End Sub
