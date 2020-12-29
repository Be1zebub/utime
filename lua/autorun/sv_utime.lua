-- Written by Team Ulysses, http://ulyssesmod.net/

if not sql.TableExists("utime") then
	sql.Query("CREATE TABLE IF NOT EXISTS utime (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, player INTEGER NOT NULL, totaltime INTEGER NOT NULL, lastvisit INTEGER NOT NULL);")
	sql.Query("CREATE INDEX IDX_UTIME_PLAYER ON utime (player DESC);")
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SetUTime(num)
	self:SetNWFloat("TotalUTime", num)
end

function PLAYER:SetUTimeStart(num)
	self:SetNWFloat("UTimeStart", num)
end

local function onJoin(ply)
	local uid = ply:SteamID64()
	local row = sql.QueryRow("SELECT totaltime, lastvisit FROM utime WHERE player = ".. uid ..";")
	local time = 0 

	if row then
		sql.Query("UPDATE utime SET lastvisit = " .. os.time() .. " WHERE player = ".. uid ..";")
		time = row.totaltime
	else
		sql.Query("INSERT into utime ( player, totaltime, lastvisit ) VALUES ( ".. uid ..", 0, ".. os.time() .." );")
	end
	ply:SetUTime( time )
	ply:SetUTimeStart(CurTime())
end


local function updatePlayer(ply)
	sql.Query("UPDATE utime SET totaltime = ".. math.floor(ply:GetUTimeTotalTime()) .." WHERE player = ".. ply:SteamID64() ..";")
end

local function updateAll()
	local players = player.GetHumans()

	for _, ply in ipairs(players) do
		if ply and ply:IsConnected() then
			updatePlayer(ply)
		end
	end
end

timer.Create("UTimeTimer", 67, 0, updateAll)
hook.Add("PlayerDisconnected", "UTimeDisconnect", updatePlayer)
hook.Add("PlayerInitialSpawn", "UTimeInitialSpawn", onJoin)
