--OS Info
Version = "BETA 0.1.1"



--General Functions

--Splits string with specified character
function Split(string1, char1)
    local stringInsert = ""
    local splitString = {}
    for char in string1:gmatch"." do
        if char == char1 then
            table.insert(splitString, stringInsert)
            stringInsert = ""
        else
            stringInsert = stringInsert .. char
        end
    end
    table.insert(splitString, stringInsert)
    return splitString
end

--Formats messages to be 30 chars long.
--Adds spaces between messages
--Returns string added with spaces
function Format(string1, string2, numSpaces)
    local spaces = ""
    if #string1 + #string2 < numSpaces then
        local neededSpaces = numSpaces - (#string1 + #string2)
        for addSpaces = 1, neededSpaces do
            spaces = spaces .. " "
        end
    end
    return string1 .. spaces .. string2
end

--OS Functions

--Restarts the OS **NOT THE TURTLE**
function Restart()
    shell.run("clear")
    shell.run("TurtleOS")
end

--Check if OS Version file is updated.
function CheckForUpdate()
    local gitVersion = pcall(fs.open("Version","r"))
    if gitVersion == true then
        gitVersion.delete("Version")
        gitVersion.close()
    end
    local download = http.get("https://raw.githubusercontent.com/goldminer127/TurtleOS/master/Version")
    local turtleOS = download.readAll()
    download.close()
    local file = fs.open("Version","w")
    file.write(turtleOS)
    file.close()
    
    --Returns true if there is no update. Returns false if there is an update
    local versionFile = fs.open("Version", "r")
    local isUpToDate = versionFile.readAll() == Version
    versionFile.close()
    return isUpToDate
end

--Store initial version or store new version after update
function UpdateVersion()
    local osVersion = pcall(fs.open("OSVersion","r"))
    if osVersion == true then
        osVersion.delete("OSVersion")
        osVersion.close()
    end
    local versionFile = fs.open("OSVersion","w")
    versionFile.write(Version)
    versionFile.close()
    --pcall(osVersion.close())
end

--Make directories for OS
function MakeDirectories()
    fs.makeDir("modules")
end

--Update TurtleOS
function Update()
    print("Downloading files...")
    local osDownload = http.get("https://raw.githubusercontent.com/goldminer127/TurtleOS/master/TurtleOS.lua")
    local downloadFile = osDownload.readAll()
    osDownload.close()

    --Install new version
    print("Installing files...")
    local turtleOS = fs.open("TurtleOS","w")
    turtleOS.write(downloadFile)
    turtleOS.close()
    print("Finalizing...")
    sleep(5)
end

function TurtleHelp()
    print(Format("help", "reinstall [-r]", 20))
    print(Format("info", "restart", 20))
    print(Format("install [-i]", "shutdown", 20))
    print(Format("modules [-m] [-rm]", "update [-u]", 20))
end

function SubHelp()
    print(Format("-dp <program>", "-version optional<module>", 20))
end

--Removes specified module. Returns result as status message.
function RemoveModule(module)
    local modules = fs.list("modules")
    local result = ""
    for _, m in ipairs(modules) do
        if m == module then
            fs.delete("modules/" .. m)
            result = "Module " .. m .. " successfully uninstalled."
            break
        end
    end
    if result == "" then
        result = "Module " .. m .. " not found."
    end
    return result
end

--List all modules
function ListModules()
    local modules = fs.list("modules")
    local list = ""
    for _, m in ipairs(modules) do
        list = list .. m .. "\n"
    end
    if list == "" then
        list = "No modules installed."
    end
    return list
end

--Turtle Commands

function Listener()
    while true do
        term.write("> ")
        local input = Split(read(),' ')
        local prefix = input[1]
        table.remove(input, 1)
        --Default turtle commands
        if prefix == "turtle" then
            Turtle(input)
        end
    end
end


function Turtle(input)
    if input[1] == nil then
        print("Use 'turtle help' to view available commands. Use 'turtle help <command> to read about a specific command.")
    elseif input[1] == "help" then
        if input[2] == nil then
            TurtleHelp()
        elseif (input[2] == "subcommands") or (input[2] == "sub") then
            SubHelp()
        end
    elseif (input[1] == "modules") or (input[1] == "-m") then
        if input[2] == "list" then
            print(ListModules())
        elseif input[2] == "-rm" then
            RemoveModule(input[3])
        end
    elseif input[1] == "update" then
        --True = no update, False = new update available
        if CheckForUpdate() == true then
            print("OS is up to date")
        else
            local newVersionFile = fs.open("Version","r")
            local newVersionNum = newVersionFile.readAll()
            newVersionFile.close()
            print("OS", newVersionNum, "is available.\nUpdate will require a restart.\nReady to update? (y/n)")
            local response = read()
            if response == "y" then
                Update()
                Restart()
            else
                print("Update postponed")
            end
        end
    elseif input[1] == "restart" then
        Restart()
    end
end

--Startup stuff

function Startup()
    UpdateVersion()
    MakeDirectories()
    --Display arbutrary messages for fun. It indicated nothing
    --Loading messages
    print(Format("Loading OS", "[ OK ]", 36))
    sleep(0.25)
    print(Format("Loading IP", "[ OK ]", 36))
    sleep(0.25)
    print(Format("Loading emotions", "[ FAILED ]", 36))
    print("Starting systems...\n")
    --Starting messages
    sleep(2)
    print(Format("Starting kernal", "[ OK ]", 36))
    sleep(0.25)
    print(Format("Starting modules", "[ OK ]", 36))
    sleep(0.25)
    print(Format("Starting interface", "[ OK ]", 36))
    sleep(0.25)
    print(Format("Starting other services", "[ OK ]", 36))
    sleep(0.25)
    print(Format("Starting emotions", "[ FAILED ]", 36))
    print("\n\nWelcome to TurtleOS", Version, ". Loading...")
    sleep(5)
    shell.run("clear")
    Listener()
end

--Main
Startup()
--shell.run("pastebin","get","1F1cR1LH","turtle")
--shell.run("pastebin get 1F1cR1LH turtle")
