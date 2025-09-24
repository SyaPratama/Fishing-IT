Players = game:GetService("Players")
ReplicatedStorage = game:GetService("ReplicatedStorage")
CurrentPlayer = Players.LocalPlayer
Character = CurrentPlayer.Character or CurrentPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid", 10)
RodIdle = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("FishingRodReelIdle")
RodReel = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("EasyFishReelStart")
RodShake = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild(
    "CastFromFullChargePosition1Hand")
Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
CancelInput = Net:WaitForChild("RF/CancelFishingInputs")

CancelInput:FireServer()
-- safely Load Animations
function SafeLoadAnimation(animator, animation)
    if not animation then
        warn("⚠️ Animation is nil")
        return nil
    end
    if not animation.AnimationId or animation.AnimationId == "" then
        warn("⚠️ AnimationId is missing for: " .. animation.Name)
        return nil
    end
    local track = animator:LoadAnimation(animation)
    if not track then
        warn("⚠️ Failed to load animation track for: " .. animation.Name)
    end
    return track
end

-- Load Animations Safely
RodAnimIdle = SafeLoadAnimation(Animator, RodIdle)
RodAnimShake = SafeLoadAnimation(Animator, RodShake)
RodAnimReel = SafeLoadAnimation(Animator, RodReel)

ReplicatedStorage = game:GetService("ReplicatedStorage")
Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild(
        "net")
FishComplete = Net:WaitForChild("RE/FishingCompleted")
FishCaught = Net:WaitForChild("RE/FishCaught")
FishStopped = Net:WaitForChild("RE/FishingStopped")

if Humanoid then
    for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
    Humanoid.WalkSpeed = 16
    Humanoid.JumpPower = 50
end
