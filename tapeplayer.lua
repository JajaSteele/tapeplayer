local component = require("component")
local term = require("term")
local computer = require("computer")
local k = require("keyboard")
local shell = require("shell")
local sides = require("sides")
local filesystem = require("filesystem")
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

jjs = 0

term.clear()
X1,Y1 = g.maxResolution()
X = (X1/2)+1 Y = (Y1/2)+1
g.setResolution(X1/2,Y1/2)
sf(c("#55FF88"))
sb(c("#000000"))

term.setCursor(3,2)
term.write("Hello! please insert a cassette tape..")

repeat
    tapeready = td.isReady()
    os.sleep(0.25)
until tapeready
repeat
    
    reloadtape = false
    toggleloop = false
    readfail = 0
    tapesize2 = 0
    tapesize3 = 0
    tapesize4 = 0
    tapesize5 = 0
    tapesize6 = 0
    term.setCursorBlink(false)

    term.clear()
    td.stop()
    X1,Y1 = g.maxResolution()
    X = (X1/2)+1 Y = (Y1/2)+1
    g.setResolution(X1/2,Y1/2)
    sf(c("#55FF88"))
    sb(c("#000000"))

    tapelabel = td.getLabel()
    tapesize = td.getSize()
    td.seek(-tapesize)
    tapelength = td.seek(tapesize)
    term.clear()
    repeat
        td.seek(-(8192*3))
        tapesize2 = tapesize2 + (8192*3)
        read = td.read()
        if read > 0 then
            readfail = readfail+1
        end
        term.clear()
        term.setCursor(0,0)
        print(tapesize2,"/",tapesize,read)
    until readfail > 0 or tapesize2 > tapesize

    td.seek(tapesize)
    td.seek(-(tapesize2-(8192*3)))
    readfail = 0
    term.clear()
    repeat
        td.seek(-512)
        tapesize3 = tapesize3 + 512
        read = td.read()
        if read > 0 then
            readfail = readfail+1
        end
        term.clear()
        term.setCursor(0,0)
        print(tapesize3,"/",tapesize,read)
    until readfail > 0 or tapesize3 > tapesize

    td.seek(tapesize)
    td.seek(-(tapesize2-(8192*3)))
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
        term.clear()
        term.setCursor(0,0)
        print(tapesize4,"/",tapesize,read)
    until readfail > 0 or tapesize4 > tapesize
    if not filesystem.exists("/home/darkconfig.txt") then
        darkconfig = io.open("/home/darkconfig.txt", "w")
        darkconfig:write(tostring(false))
        darkconfig:close()
    end
    tapesizeF = tapesize-((((tapesize2-tapesize3)-tapesize4)-tapesize5)-tapesize6)
    darkconfig1 = io.open("/home/darkconfig.txt", "r")
    toggledark1 = darkconfig1:read("*a")
    if toggledark1 == "true" then
        toggledark = true
    else
        toggledark = false
    end
    darkconfig1:close()

    if toggledark then
        wbox = c("#444444")
        wtitle = c("#333333")
        wline = c("#25b2f8")
        wred = c("#FF4444")
        wtext1 = c("#AAAAAA")
        wtext2 = c("#DDDDDD")
        wtext3 = c("#EEEEEE")
        wblue = c("#7070e1")
        wblue1 = c("#9292e2")
    else
        wbox = c("#efeff1")
        wtitle = c("#dedee3")
        wline = c("#bababf")
        wred = c("#FF0000")
        wtext1 = c("#555555")
        wtext2 = c("#888888")
        wtext3 = c("#AAAAAA")
        wblue = c("#7070e1")
        wblue1 = c("#9292e2")
    end

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
    sf(wblue1)
    term.write("●JJS-Tech Tape Player●")

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
    term.setCursor(XT-2,YT-1)
    term.write(string.format("%.0f", tapelength1*100))
    term.write("%")

    td.seek(-tapelength)

    term.setCursor(5,8)
    sf(wblue1)
    term.write("● ")
    sf(wtext3)
    term.write("Play Speed: ")
    sf(wred)
    term.write("Input number between 0.1 and 2: ")
    playspeed = term.read()
    g.fill(18,8,X1,1, " ")
    td.setSpeed(tonumber(playspeed))

    term.setCursor(19,8)
    sf(wtext2)
    term.write(tonumber(playspeed))

    term.setCursor(4,16)
    sf(wblue)
    term.write("●───╢ ")
    sf(wtext2)
    term.write("Tape Status: ")
    term.write("          ")
    sf(wtext3)
    term.setCursor(5,24)
    term.write("L = Loop, P = Play, S = Stop, R = Rewind, T = Change Label, ")
    sf(c("#ff8a8a"))
    term.write("Q = Quit")
    td.play()
    i = 1
    repeat
        sb(wbox)
        tapepos1 = td.getPosition() / tapesizeF
        state = td.getState()
        term.setCursor(23,16)
        sf(wtext1)
        term.write(state)
        sf(wblue)
        term.write(" ╟───●     ")

        term.setCursor(5,18)
        sf(wblue1)
        term.write("● ")
        sf(wtext3)
        term.write("Time: ")
        readtime = (tapesizeF / (48000*playspeed))*8
        fulltime = (tapelength / (48000*playspeed))*8
        readedtime = readtime*tapepos1
        sf(wtext2)
        term.write(string.format("%.0f", readedtime))
        term.write(" / ")
        term.write(string.format("%.0f", readtime))
        term.write("s     ")

        term.setCursor(5,19)
        sf(wblue1)
        term.write("● ")
        sf(wtext3)
        term.write("Total tape time: ")
        sf(wtext2)
        term.write(string.format("%.0fs", fulltime))
        sf(wtext3)
        term.write(" (Includes empty end section.)")

        term.setCursor(5,21)
        sf(wblue1)
        term.write("●─╢")
        sb(c("#5c5c5c"))
        sf(c("#828282"))
        g.fill(8,21,66,1, "─")
        term.setCursor(9+(66*tapepos1),21)
        term.write("[")
        term.setCursor(74,21)
        sf(wblue1)
        sb(wbox)
        term.write("╟─●")
        sb(c("#8aeb75"))
        sf(c("#b3eda6"))
        g.fill(8,21,66*tapepos1,1, "─")
        term.setCursor(8+(66*tapepos1),21)
        term.write("]")

        local keyloop = k.isKeyDown("l")
        if toggleloop == nil then toggleloop = false end -- safety check

        if keyloop and not t then
            toggleloop = not toggleloop
        end
        t = keyloop

        local keystop = k.isKeyDown("s")

        if keystop and not t1 then
            td.stop()
        end
        t1 = keystop

        local keyplay = k.isKeyDown("p")

        if keyplay and not t2 then
            td.play()
        end
        t2 = keyplay

        local keyrewind = k.isKeyDown("r")

        if keyrewind and not t3 then
            td.seek(-tapelength)
        end
        t3 = keyrewind

        local keyquit = k.isKeyDown("q")

        if keyquit and not t4 then
            computer.beep(200,0.5)
            os.sleep(0.5)
            jjs = 1
            td.stop()
            td.seek(-tapelength)
            break
        end
        t4 = keyquit

        local keylabel = k.isKeyDown("t")

        if keylabel and not t5 then
            computer.beep(500,0.25)
            os.sleep(0.5)
            term.setCursorBlink(true)
            sb(wbox)
            term.setCursor(4,5)
            sf(wblue)
            term.write("●───╢ ")
            sf(wtext2)
            term.write("Tape Title: ")
            g.fill(22,5,80,1, " ")
            sf(wtext1)
            newtapelabel = term.read()
            newtapelabel1 = string.sub(newtapelabel, 1, string.len(newtapelabel)-1)
            td.setLabel(newtapelabel1)
            break
        end
        t5 = keylabel

        local keydark = k.isKeyDown("d")
        if toggledark == nil then toggledark = false end -- safety check

        if keydark and not t6 then
            if keydark and not t then
                darkconfig1 = io.open("/home/darkconfig.txt", "r")
                toggledark1 = darkconfig1:read("*a")
                if toggledark1 == "true" then
                    toggledark = true
                else
                    toggledark = false
                end
                toggledark = not toggledark
                if filesystem.exists("/home/darkconfig.txt") then
                    filesystem.remove("/home/darkconfig.txt")
                end
                darkconfig = io.open("/home/darkconfig.txt", "w")
                darkconfig:write(tostring(toggledark))
                darkconfig:close()
                darkconfig2 = io.open("/home/darkconfig.txt", "r")
                print(darkconfig2:read("*a"))
                break
            end
        end
        t6 = keydark
        
        if not td.isReady() then
            os.sleep(1)
            reloadtape = true
            computer.beep(300,0.1)
            sb(wbox)
            sf(wred)
            term.setCursor(5,10)
            term.write("Please insert cassette tape!")   
            term.setCursor(5,11)
            term.write("Please insert cassette tape!")
            term.setCursor(5,12)
            term.write("Please insert cassette tape!")
            term.setCursor(5,13)
            term.write("Please insert cassette tape!")
            term.setCursor(5,14)
            term.write("Please insert cassette tape!")
        end
        if reloadtape then
            os.sleep(1)
            if td.isReady() and reloadtape then
                break
            end
        end


        if td.getPosition() > tapesizeF then
            if toggleloop then
                td.stop()
                td.seek(-tapelength)
                os.sleep(0.5)
                td.play()
            else
                td.stop()
            end
        end

        if toggleloop then
            sf(wblue)
        else
            sf(wred)
        end
        sb(wbox)
        term.setCursor(9,24)
        term.write("Loop")




        os.sleep(0.25)
    until i == 0
until jjs == 1

sb(c("#000000"))
sf(c("#FFFFFF"))
term.clear()
term.setCursor(0,0)
shell.execute("reboot")