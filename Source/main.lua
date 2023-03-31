local currentTime <const> = playdate.sound.getCurrentTime
local snd = playdate.sound
local gfx = playdate.graphics

-- iterations per second
playdate.display.setRefreshRate(2)

local activeSynths = {}
s = snd.sequence.new('giveyouup.mid')

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

local ntracks = s:getTrackCount()

local iterations = 0

function playdate.update()
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	
	for i=1,ntracks do
		local track = s:getTrackAtIndex(i)
		local newInst, newSynth = newinst()
		print("newSynth", newSynth)
		table.insert(activeSynths, newSynth) -- add it as last element
		track:setInstrument(newInst)
		s:play()
	end

	local iterationText = currentTime() .. " iteration " .. iterations .. " synths: " .. #activeSynths
	gfx.drawText(iterationText,100, 100)
	print(iterationText)
	playdate.drawFPS()
	iterations = iterations + 1

	if #activeSynths > ntracks*2 then
		for _ = 1, ntracks do
			table.remove(activeSynths, 1) -- delete oldest synth
		end
	end
end
