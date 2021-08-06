local component = require("component")
local term = require("term")
local computer = require("computer")
local k = require("keyboard")
local shell = require("shell")
local sides = require("sides")
local rs = component.redstone

local td = component.tape_drive
local g = component.gpu

i = 1
td.getSize()

repeat
    td.seek(-td.getSize())
    td.play()
    os.sleep(1)
    td.stop()
    print(td.getPosition())
    i = i+1
until i == 20


