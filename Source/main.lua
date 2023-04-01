local currentTime <const> = playdate.sound.getCurrentTime
local snd = playdate.sound
local gfx = playdate.graphics

-- iterations per second
playdate.display.setRefreshRate(2)

local activeSynths = {}

function newsynth()
	local s = snd.synth.new(snd.kWaveSawtooth)
	s:setVolume(0.2)
	s:setAttack(0)
	s:setDecay(0.15)
	s:setSustain(0.2)
	s:setRelease(0)
	return s
end

function newinst()
	local synth = newsynth()
	local inst = snd.instrument.new()
	inst:addVoice(synth)
	return inst, synth
end


local iterations = 0

function playdate.update()
	s = snd.sequence.new('giveyouup.mid')

	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	local iterationText = currentTime() .. " iteration " .. iterations .. " synths: " .. #activeSynths
	gfx.drawText(iterationText,100, 100)
	print(iterationText)
	playdate.drawFPS()
	iterations = iterations + 1

	-- cleanup sequence
	for i=1, s:getTrackCount() do
		s:getTrackAtIndex(i):clearNotes()
	end
	s = nil
	print("garbage collect", collectgarbage("collect"))
	print("garbage count", collectgarbage("count"))
end
