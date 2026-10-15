

```local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteFolder = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Stage")
local stageFinishedRF = remoteFolder:WaitForChild("StageFinishedRF")
local getEnhantStoneRE = remoteFolder:WaitForChild("GetEnhantStoneRE")

local rewardQueue = {}

for _ = 1, 5 do
    task.spawn(function()
        while true do
            task.spawn(function()
                local success, response = pcall(function()
                    return stageFinishedRF:InvokeServer("Stage_27")
                end)
               
                if success and type(response) == "table" then
                    for tokenKey, rewardData in pairs(response) do
                        if type(rewardData) == "table" then
                            table.insert(rewardQueue, {
                                tokenKey = tokenKey,
                                ID = rewardData.ID,
                                Type = rewardData.Type,
                                Number = rewardData.Number
                            })
                        end
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end

for i = 1, 15 do
    task.spawn(function()
        while true do
            if #rewardQueue > 0 then
                local data = table.remove(rewardQueue, 1)
                if data then
                    for _ = 1, 10 do
                        getEnhantStoneRE:FireServer(data.tokenKey, data.ID, data.Type, data.Number)
                    end
                end
            else
                task.wait(0.001)
            end
        end
    end)
end```
