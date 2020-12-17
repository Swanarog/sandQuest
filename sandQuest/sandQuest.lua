local sandCastle = LibStub("AceAddon-3.0"):GetAddon("sandCastle")
if not sandCastle then return end

local AddonName, sandCastle_Quest = ...

function sandCastle_Quest:IsEnabled()
	-- if self.sets.disabled == true then
		-- self:Hide()
	-- else
		-- self:Show()
	-- end
	
	self:SetShown(not self.sets.disabled)
	
end

function sandCastle_Quest:Layout()
	self.frame:SetHeight(self.sets.height or 250)
	self:Rescale()
	self:IsEnabled()
end

function sandCastle_Quest:Rescale(newScale)
	local scale = newScale or self.sets.scale or 1

	--self.frame:SetScale(1)

	sandCastle.FlyPaper.SetScale(self.frame, scale)
	
	if self.updateScale then
		self.updateScale(scale)
	end
	
	sandCastle.SaveFramePosition(self)
end

function sandCastle_Quest.updateScale(scale)
	ObjectiveTrackerFrame.BlocksFrame:SetScale(scale)
end

local options = {
	{
		"Basics",
		{
			{
				"checkButton",
				"Disable",
				function(parent) --getter
					return parent.sets.disabled
				end,
				function(parent, value) --setter
					parent.sets.disabled = value
					parent:IsEnabled()
				end,
			},
			{
				"slider",
				"Scale",
				function(parent) --getter
					return (parent.sets.scale or 1) * 100
				end,
				function(parent, value, ...) --setter
					parent.sets.scale = value/100
					parent:Rescale()
				end,
				{25, 250, 1, 10, 100}, --min, max, step, stepOnShiftKeyDown
			},
			{
				"slider",
				"Height",
				function(parent) --getter
					return parent.sets.height
				end,
				function(parent, value, ...) --setter
					parent.sets.height = value
				
					parent.frame:SetHeight(parent.sets.height or 250)
				
					sandCastle.SaveFramePosition(parent)
				end,
				{25, 2000, 1, 10, 1}, --min, max, step, stepOnShiftKeyDown
			},
		},
	},
	{
		"Advanced",
		{

		},
	},
}

local defaults = {
	position = {
		point = "Center",
		x = 0,
		y = -200
	},
	scale = 1,
	height = 250,
}

local frames = {ObjectiveTrackerFrame.BlocksFrame}

sandCastle.New(function()
	local testFrame = CreateFrame("Frame", "test2", sandCastle.frame)
	
	testFrame.wrapper = CreateFrame("ScrollFrame", nil, testFrame)
	
	testFrame.wrapper.ScrollChild = CreateFrame("Frame", nil, testFrame.wrapper)
	
	testFrame.wrapper:SetScrollChild(testFrame.wrapper.ScrollChild)
	testFrame.wrapper.ScrollChild:SetAllPoints(testFrame.wrapper)
	testFrame.wrapper:SetPoint("BottomRight", 0, 0)
	testFrame.wrapper:SetPoint("TopLeft", -275, 0)
	
	testFrame.displayID = "quest"
	testFrame:SetWidth(275)
	 
	for i , frame in pairs(frames) do
		frame.ignoreFramePositionManager = true
		frame:ClearAllPoints()
		frame:SetPoint('TopLeft', testFrame, 35, 0)
		frame:SetPoint('BottomRight', testFrame, 35, 0)
		frame:SetParent(testFrame.wrapper.ScrollChild)
	end

	sandCastle:Register("sandCastle", testFrame, sandCastle_Quest, defaults, options)
	testFrame:Layout()
end)