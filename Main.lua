local settings = {
    enabled = true; 
    circleTransparency = 1;
    radius = 360; 
    sides = 80; 
    rainbow = true; 
    color = Color3.fromRGB(255, 135, 255);
    offset = Vector2.new(0, 40); 
}
local runservice = game:GetService('RunService');
local camera = game.Workspace.CurrentCamera;
local tau = math.pi * 2;
local drawings = {};
for i = 1, settings.sides do
    drawings[i] = { Drawing.new('Line') }
    drawings[i][1].ZIndex = 2;
    drawings[i][1].Thickness = 2;
end
local mouse = game.Players.LocalPlayer:GetMouse()
runservice.RenderStepped:Connect(function()
    local pass = settings.enabled
    local mouseX, mouseY = mouse.X, mouse.Y
    for i = 1, #drawings do
        local line = drawings[i][1];
        if pass then
            local color = settings.rainbow and Color3.fromHSV((tick() % 5 / 5 - (i / #drawings)) % 1, 0.5, 1) or settings.color;
            local centerX, centerY = mouseX, mouseY;
            local pos = Vector2.new(centerX, centerY) + settings.offset;
            local last, next = (i / settings.sides) * tau, ((i + 1) / settings.sides) * tau;
            local lastX = pos.X + math.cos(last) * settings.radius;
            local lastY = pos.Y + math.sin(last) * settings.radius;
            local nextX = pos.X + math.cos(next) * settings.radius;
            local nextY = pos.Y + math.sin(next) * settings.radius;
            line.From = Vector2.new(lastX, lastY);
            line.To = Vector2.new(nextX, nextY);
            line.Color = color;
            line.Transparency = settings.circleTransparency;
            line.Visible = true;
        else
            line.Visible = false;
        end
    end
end)
