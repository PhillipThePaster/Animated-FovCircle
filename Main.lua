local settings = {
    enabled = true,
    circleTransparency = 1,
    radius = 360,
    sides = 80,
    rainbow = true,
    color = Color3.fromRGB(255, 135, 255),
    offset = Vector2.new(0, 40),
    outline = true,
    dynamic = true, 
}

local runservice = game:GetService('RunService');
local camera = game.Workspace.CurrentCamera;
local tau = math.pi * 2;
local drawings = {};
for i = 1, settings.sides do
    drawings[i] = { Drawing.new('Line'), Drawing.new('Line') }
    drawings[i][1].ZIndex = 1;
    drawings[i][1].Thickness = 4;
    drawings[i][2].ZIndex = 2;
    drawings[i][2].Thickness = 2;
end
local mouse = game.Players.LocalPlayer:GetMouse()
runservice.RenderStepped:Connect(function()
    local pass = settings.enabled
    local mouseX, mouseY = mouse.X, mouse.Y
    local radius = settings.radius
    if settings.dynamic then
        local fovScalingFactor = 1 / math.tan(math.rad(camera.FieldOfView / 2))
        radius = fovScalingFactor * settings.radius
    end
    for i = 1, #drawings do
		local backLine = drawings[i][1];
        local line = drawings[i][2];
        if pass then
            local color = settings.rainbow and Color3.fromHSV((tick() % 5 / 5 - (i / #drawings)) % 1, 0.5, 1) or settings.color;
            local centerX, centerY = mouseX, mouseY;
            local pos = Vector2.new(centerX, centerY) + settings.offset;
            local last, next = (i / settings.sides) * tau, ((i + 1) / settings.sides) * tau;
            local lastX = pos.X + math.cos(last) * radius;
            local lastY = pos.Y + math.sin(last) * radius;
            local nextX = pos.X + math.cos(next) * radius;
            local nextY = pos.Y + math.sin(next) * radius;
           if settings.outline then
            backLine.From = Vector2.new(lastX, lastY);
            backLine.To = Vector2.new(nextX, nextY);
            backLine.Color = Color3.new(0, 0, 0);
            backLine.Transparency = settings.circleTransparency;
            backLine.Visible = true;
          else
            backLine.Visible = false;
          end
           line.From = Vector2.new(lastX, lastY);
           line.To = Vector2.new(nextX, nextY);
           line.Color = color;
           line.Transparency = settings.circleTransparency;
           line.Visible = true;
          else 
           line.Visible = false;
           backLine.Visible = false;
        end
    end
end)
