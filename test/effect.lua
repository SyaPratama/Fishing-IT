    ReplicatedStorage = game:GetService("ReplicatedStorage")
    Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild(
        "net")
    DestroyEffect = Net:WaitForChild("RE/DestroyEffect")
    BlackScreen = Net:WaitForChild("RE/BlackoutScreen")

    DestroyEffect:FireServer()
    BlackScreen:FireServer(true)

    print(BlackScreen)