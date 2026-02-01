if not game:IsLoaded() then game.Loaded:Wait(); end;

local cloneref = cloneref or function(i: Instance) return i; end;
local hui = cloneref((gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui"));

local code = function(n: string): string
    if crypt and crypt.base64encode then
        return crypt.base64encode(n);
    end;
    return n;
end;

local container = Instance.new("Folder", hui);
container.Name = code("Container");

local Players = cloneref(game:GetService("Players"));

local connections: {string: RBXScriptConnection} = {};

local setup = function(plr: Player, isCleaning: boolean)
    local id = tostring(plr.UserId);
    if isCleaning then
        if connections[id] then
            connections[id]:Disconnect();
            connections[id] = nil;
            container[code(id)]:Destroy();
        end;
    else
        local create = function(char: Model)
            if container:FindFirstChild(code(id)) then container[code(id)]:Destroy(); end;
            local hl = Instance.new("Highlight", container);
            hl.Name = code(id);
            hl.FillTransparency = 0.5;
            local colour = plr.TeamColor.Color;
            hl.OutlineColor = colour;
            hl.FillColor = colour;
            hl.Adornee = char;
        end
        create(plr.Character or plr.CharacterAdded:Wait());
        connections[id] = plr.CharacterAdded:Connect(create);
    end;
end;

for _, v in next, Players:GetPlayers() do
    if v == Players.LocalPlayer then continue; end;
    setup(v, false);
end;

Players.PlayerAdded:Connect(function(plr)
    setup(plr, false);
end);

Players.PlayerRemoving:Connect(function(plr)
    setup(plr, true);
end);
