if not game:IsLoaded() then game.Loaded:Wait(); end;

local cloneref = cloneref or function(i: Instance) return i; end;
local hui = cloneref((gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui"));
local SG = loadstring(game:HttpGet("https://raw.githubusercontent.com/sneekygoober/sneeky-s-notifications/refs/heads/main/main.luau"))();

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
    elseif not (isCleaning and connections[id]) then
        local create = function(char: Model)
            if container:FindFirstChild(code(id)) then container[code(id)]:Destroy(); end;
            local hl = Instance.new("Highlight", container);
            hl.Name = code(id);
            hl.FillTransparency = 0.5;
            local colour = plr.TeamColor.Color;
            hl.OutlineColor = colour;
            hl.FillColor = colour;
            hl.Adornee = char;
        end;
        create(plr.Character or plr.CharacterAdded:Wait());
        connections[id] = plr.CharacterAdded:Connect(create);
    end;
end;

task.spawn(function()
    for _, v in next, Players:GetPlayers() do
        if v == Players.LocalPlayer then continue; end;
        setup(v, false);
    end;
end);

Players.PlayerAdded:Connect(function(plr)
    setup(plr, false);
end);

Players.PlayerRemoving:Connect(function(plr)
    setup(plr, true);
end);

SG["success"]("ESP successfully executed!\n\nIf you have any issues press F9 or type /console in chat and then send me a screenshot of the console.\n\nDO NOT EXECUTE MORE THAN ONCE IN A SERVER!");
