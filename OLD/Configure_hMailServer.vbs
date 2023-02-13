Sub Main()
    'MsgBox("Hello, World!") ' Display message on computer screen.
    Dim obApp
    Set obApp = CreateObject("hMailServer.Application")

    ' Authenticate. Without doing this, we won't have permission
    ' to change any server settings or add any objects to the
    ' installation.   
    Call obApp.Authenticate("Administrator", "Start123")
    
    ' Locate the domain we want to add the account to
    Dim obDomain
    Set obDomain = obApp.Domains.ItemByName("windows.lab")
    
    Dim obAccount
    Set obAccount = obDomain.Accounts.Add
    
    ' Set the account properties
    obAccount.Address = "administrator@windows.lab"
    obAccount.Password = "Start123"
    obAccount.AdminLevel = 0 ' 0 - User 1 - Domain 2 - Server
    obAccount.Active = True
    obAccount.MaxSize = 100 ' Allow max 100 megabytes
    
    obAccount.Save
End Sub

Main()

