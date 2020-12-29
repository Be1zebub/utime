-- Written by Team Ulysses, http://ulyssesmod.net/

local PLAYER = FindMetaTable("Player")

function PLAYER:GetUTime()
	return self:GetNWFloat("TotalUTime")
end

function PLAYER:GetUTimeStart()
	return self:GetNWFloat( "UTimeStart" )
end

function PLAYER:GetUTimeSessionTime()
	return CurTime() - self:GetUTimeStart()
end

function PLAYER:GetUTimeTotalTime()
	return self:GetUTime() + CurTime() - self:GetUTimeStart()
end
