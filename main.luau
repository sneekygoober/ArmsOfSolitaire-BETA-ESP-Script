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

local connections: {[string]: RBXScriptConnection} = {}

local function setup(plr: Player, isCleaning: boolean?)
    if plr == Players.LocalPlayer then return; end;

    local id = tostring(plr.UserId);
    local n = code(id);

    if isCleaning then
        if connections[id] then
            connections[id]:Disconnect();
            connections[id] = nil;
        end;

        local existing = container:FindFirstChild(n);
        if existing then
            existing:Destroy();
        end;

        return;
    end;

    local create = function(char: Model)
        if not char or not char.Parent then return; end;

        local existing = container:FindFirstChild(n);
        if existing then
            existing:Destroy();
        end;

        local colour = plr.TeamColor.Color;

        local hl = Instance.new("Highlight");
        hl.Name = n;
        hl.FillTransparency = 0.5;
        hl.FillColor = colour;
        hl.OutlineColor = colour;
        hl.Adornee = char;
        hl.Parent = container;
    end;

    if connections[id] then
        connections[id]:Disconnect();
    end;

    connections[id] = plr.CharacterAdded:Connect(create);

    if plr.Character and plr.Character.Parent then
        create(plr.Character);
    end;
end;

for _, plr in Players:GetPlayers() do
    setup(plr);
end;

Players.PlayerAdded:Connect(setup);

Players.PlayerRemoving:Connect(function(plr)
    setup(plr, true);
end);

SG["success"]("ESP successfully executed!\nIf you have any issues press F9 or type /console in chat and then send me a screenshot of the console.");
