--- === HammerspoonShiftIt ===
---
--- Manages windows and positions in MacOS with key binding from ShiftIt.
---
--- Download: [https://github.com/peterkljin/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftIt.spoon.zip](https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftIt.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "HammerspoonShiftIt"
obj.version = "1.0"
obj.author = "Peter Klijn"
obj.homepage = "https://github.com/peterklijn/hammerspoon-shiftit"
obj.license = ""

obj.mash = { 'ctrl', 'shift' }
obj.mapping = {
  left = { obj.mash, 'j' },
  right = { obj.mash, 'l' },
  up = { obj.mash, 'i' },
  down = { obj.mash, ',' },
  upleft = { obj.mash, 'u' },
  upright = { obj.mash, 'o' },
  botleft = { obj.mash, 'm' },
  botright = { obj.mash, '.' },
  maximum = { obj.mash, 'k' },
  toggleFullScreen = { obj.mash, 'f' },
  toggleZoom = { obj.mash, 'a' },
  move_center = { obj.mash, 'x' },
  move_left= { obj.mash, 'z' },
  move_right = { obj.mash, 'c' },
  nextScreen = { obj.mash, 'n' },
  previousScreen = { obj.mash, 'p' },
  resizeOut = { obj.mash, '=' },
  resizeIn = { obj.mash, '-' }
}

local splitRatio = defaultSplitRatio or 0.60

local units = {
  right50       = { x = splitRatio, y = 0.00, w = (1.00 - splitRatio), h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = splitRatio, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  
  upleft50      = { x = 0.00, y = 0.00, w = splitRatio, h = 0.50 },
  upright50     = { x = splitRatio, y = 0.00, w = 1.00 - splitRatio, h = 0.50 },
  botleft50     = { x = 0.00, y = 0.50, w = splitRatio, h = 0.50 },
  botright50    = { x = splitRatio, y = 0.50, w = 1.00 - splitRatio, h = 0.50 },
  
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
}

function move(unit) hs.window.focusedWindow():move(unit, nil, true, 0) end

function resizeWindowInSteps(increment)
  screen = hs.window.focusedWindow():screen():frame()
  window = hs.window.focusedWindow():frame()
  wStep = math.floor(screen.w / 12)
  hStep = math.floor(screen.h / 12)
  x = window.x
  y = window.y
  w = window.w
  h = window.h
  if increment then
    xu = math.max(screen.x, x - wStep)
    w = w + (x-xu)
    x=xu
    yu = math.max(screen.y, y - hStep)
    h = h + (y - yu)
    y = yu
    w = math.min(screen.w - x + screen.x, w + wStep)
    h = math.min(screen.h - y + screen.y, h + hStep)
  else
    noChange = true
    notMinWidth = w > wStep * 3
    notMinHeight = h > hStep * 3
    
    snapLeft = x <= screen.x
    snapTop = y <= screen.y
    -- add one pixel in case of odd number of pixels
    snapRight = (x + w + 1) >= (screen.x + screen.w)
    snapBottom = (y + h + 1) >= (screen.y + screen.h)

    b2n = { [true]=1, [false]=0 }
    totalSnaps = b2n[snapLeft] + b2n[snapRight] + b2n[snapTop] + b2n[snapBottom]

    if notMinWidth and (totalSnaps <= 1 or not snapLeft) then
      x = x + wStep
      w = w - wStep
      noChange = false
    end
    if notMinHeight and (totalSnaps <= 1 or not snapTop) then
      y = y + hStep
      h = h - hStep
      noChange = false
    end
    if notMinWidth and (totalSnaps <= 1 or not snapRight) then
      w = w - wStep
      noChange = false
    end
    if notMinHeight and (totalSnaps <= 1 or not snapBottom) then
      h = h - hStep
      noChange = false
    end
    if noChange then
      x = notMinWidth and x + wStep or x
      y = notMinHeight and y + hStep or y
      w = notMinWidth and w - wStep * 2 or w
      h = notMinHeight and h - hStep * 2 or h
    end
  end
  -- hs.window.focusedWindow():move({x=x, y=y, w=w, h=h}, nil, true, 0)
  hs.window.focusedWindow():move({x=x, y=y, w=w, h=window.h}, nil, true, 0)
end

function obj:left() move(units.left50, nil, true, 0) end
function obj:right() move(units.right50, nil, true, 0) end
function obj:up() move(units.top50, nil, true, 0) end
function obj:down() move(units.bot50, nil, true, 0) end
function obj:upleft() move(units.upleft50, nil, true, 0) end
function obj:upright() move(units.upright50, nil, true, 0) end
function obj:botleft() move(units.botleft50, nil, true, 0) end
function obj:botright() move(units.botright50, nil, true, 0) end

function obj:maximum() move(units.maximum, nil, true, 0) end

function obj:toggleFullScreen() hs.window.focusedWindow():toggleFullScreen() end
function obj:toggleZoom() hs.window.focusedWindow():toggleZoom() end

function obj:center() hs.window.focusedWindow():centerOnScreen(nil, true, 0) end
function obj:move_left() hs.window.focusedWindow():setTopLeft({x=0, y=0}, nil, true, 0) end
function obj:move_right() hs.window.focusedWindow():setTopLeft({x=hs.window.focusedWindow():screen():frame().w - hs.window.focusedWindow():frame().w, y=0}, nil, true, 0) end

function obj:nextScreen() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():next(),false, true, 0) end
function obj:previousScreen() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():previous(),false, true, 0) end

function obj:resizeOut() resizeWindowInSteps(true) end
function obj:resizeIn() resizeWindowInSteps(false) end

--- HammerspoonShiftIt:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for HammerspoonShiftIt
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details (everything is optional) for the following items:
---   * left
---   * right
---   * up
---   * down
---   * upleft
---   * upright
---   * botleft
---   * botright
---   * maximum
---   * toggleFullScreen
---   * toggleZoom
---   * center
---   * nextScreen
---   * previousScreen
---   * resizeOut
---   * resizeIn
function obj:bindHotkeys(mapping)

  if (mapping) then
    for k,v in pairs(mapping) do self.mapping[k] = v end
  end

  hs.hotkey.bind(self.mapping.left[1], self.mapping.left[2], function() self:left() end)
  hs.hotkey.bind(self.mapping.right[1], self.mapping.right[2], function() self:right() end)
  hs.hotkey.bind(self.mapping.up[1], self.mapping.up[2], function() self:up() end)
  hs.hotkey.bind(self.mapping.down[1], self.mapping.down[2], function() self:down() end)
  hs.hotkey.bind(self.mapping.upleft[1], self.mapping.upleft[2], function() self:upleft() end)
  hs.hotkey.bind(self.mapping.upright[1], self.mapping.upright[2], function() self:upright() end)
  hs.hotkey.bind(self.mapping.botleft[1], self.mapping.botleft[2], function() self:botleft() end)
  hs.hotkey.bind(self.mapping.botright[1], self.mapping.botright[2], function() self:botright() end)
  hs.hotkey.bind(self.mapping.maximum[1], self.mapping.maximum[2], function() self:maximum() end)
  --hs.hotkey.bind(self.mapping.toggleFullScreen[1], self.mapping.toggleFullScreen[2], function() self:toggleFullScreen() end)
  --hs.hotkey.bind(self.mapping.toggleZoom[1], self.mapping.toggleZoom[2], function() self:toggleZoom() end)
  hs.hotkey.bind(self.mapping.move_center[1], self.mapping.move_center[2], function() self:center() end)
  hs.hotkey.bind(self.mapping.move_left[1], self.mapping.move_left[2], function() self:move_left() end)
  hs.hotkey.bind(self.mapping.move_right[1], self.mapping.move_right[2], function() self:move_right() end)
  --hs.hotkey.bind(self.mapping.nextScreen[1], self.mapping.nextScreen[2], function() self:nextScreen() end)
  --hs.hotkey.bind(self.mapping.previousScreen[1], self.mapping.previousScreen[2], function() self:previousScreen() end)
  hs.hotkey.bind(self.mapping.resizeOut[1], self.mapping.resizeOut[2], function() self:resizeOut() end)
  hs.hotkey.bind(self.mapping.resizeIn[1], self.mapping.resizeIn[2], function() self:resizeIn() end)

  return self
end

return obj
