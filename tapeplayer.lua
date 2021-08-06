local component = require("component")
local term = require("term")
local computer = require("computer")
local k = require("keyboard")
local shell = require("shell")
local sides = require("sides")
local rs = component.redstone

local td = component.tape_drive
local g = component.gpu

local function c(x)
    return tonumber(x:sub(2), 16)
end
function sb(BGC)
    g.setBackground(BGC)
end
function sf(FGC)
    g.setForeground(FGC)
end

readfail = 0
tapesize2 = 0
tapesize3 = 0
tapesize4 = 0
tapesize5 = 0
tapesize6 = 0

term.clear()
X1,Y1 = g.maxResolution()
X = (X1/2)+1 Y = (Y1/2)+1
g.setResolution(X1/2,Y1/2)
sf(c("#55FF88"))

tapelabel = td.getLabel()
tapesize = td.getSize()
td.seek(-tapesize)
tapelength = td.seek(tapesize)
term.clear()
repeat
    td.seek(-8192)
    tapesize2 = tapesize2 + 8192
    read = td.read()
    if read > 0 then
        readfail = readfail+1
    end
    print(tapesize2,"/",tapesize,read)
until readfail > 0 or tapesize2 > tapesize

td.seek(tapesize)
td.seek(-(tapesize2-8192))
readfail = 0
term.clear()
repeat
    td.seek(-512)
    tapesize3 = tapesize3 + 512
    read = td.read()
    if read > 0 then
        readfail = readfail+1
    end
    print(tapesize3,"/",tapesize,read)
until readfail > 0 or tapesize3 > tapesize

td.seek(tapesize)
td.seek(-(tapesize2-8192))
td.seek(-(tapesize3-512))
readfail = 0
term.clear()
repeat
    td.seek(-4)
    tapesize4 = tapesize4 + 4
    read = td.read()
    if read > 0 then
        readfail = readfail+1
    end
    print(tapesize4,"/",tapesize,read)
until readfail > 0 or tapesize4 > tapesize

td.seek(tapesize)
td.seek(-(tapesize2-8192))
td.seek(-(tapesize3-512))
td.seek(-(tapesize4-4))
readfail = 0
term.clear()
repeat
    td.seek(-2)
    tapesize5 = tapesize5 + 2
    read = td.read()
    if read > 0 then
        readfail = readfail+1
    end
    print(tapesize5,"/",tapesize,read)
until readfail > 0 or tapesize5 > tapesize

td.seek(tapesize)
td.seek(-(tapesize2-8192))
td.seek(-(tapesize3-512))
td.seek(-(tapesize4-4))
td.seek(-(tapesize5-2))
readfail = 0
term.clear()
repeat
    td.seek(-1)
    tapesize6 = tapesize6 + 1
    read = td.read()
    if read > 0 then
        readfail = readfail+1
    end
    print(tapesize6,"/",tapesize,read)
until readfail > 0 or tapesize6 > tapesize

tapesizeF = tapesize-((((tapesize2-tapesize3)-tapesize4)-tapesize5)-tapesize6)

wbox = c("#efeff1")
wtitle = c("#dedee3")
wline = c("#bababf")
wred = c("#FF0000")
wtext1 = c("#555555")
wtext2 = c("#888888")
wtext3 = c("#AAAAAA")
wblue = c("#7070e1")
wblue1 = c("#9292e2")

if tapesizeF > tapesize-(tapesize/64) then
    wtitle = c("#e3cece")
end

sb(wbox)
g.fill(0,0,X,Y," ")
sb(wtitle)
g.fill(0,0,X,4," ")
sf(wline)
g.fill(0,3,X,1,"_")

sf(wred)
term.setCursor(X-3,2)
term.write("X")
term.setCursor(3,2)
print(X1,Y1)

sb(wbox)
term.setCursor(4,5)
sf(wblue)
term.write("●───╢ ")
sf(wtext2)
term.write("Tape Title: ")
sf(wtext1)
term.write(tapelabel)
sf(wblue)
term.write(" ╟───●")

term.setCursor(5,7)
sf(wblue1)
term.write("● ")
sf(wtext3)
term.write("Tape Data: ")
sf(wtext2)
term.write(tapesizeF)
term.write(" / ")
term.write(tapesize)

XT, YT = term.getCursor()
sb(c("#8aeb75"))
sf(c("#b3eda6"))
g.fill(XT+5,YT, 37, 1,"═")

tapelength1 = tapesizeF/tapesize

sb(c("#eb7575"))
sf(c("#eda6a6"))

g.fill(XT+5,YT, 37*tapelength1, 1,"═")

term.setCursor((XT+5)+37*tapelength1,YT)
term.write("]")
sb(c("#8aeb75"))
sf(c("#b3eda6"))
term.write("[")

sb(wbox)
sf(wtext3)

XT, YT = term.getCursor()
term.setCursor(XT-2,YT+1)
term.write(string.format("%.0f", tapelength1*100))
term.write("%")