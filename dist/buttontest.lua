local ffi = require 'ffi'
local bit = require 'bit'
local system = require 'ffi.ogc.system'
local video = require 'ffi.ogc.video'
local consol = require 'ffi.ogc.consol'
local wpad = require 'ffi.wiiuse.wpad'
local C = require 'ffi.C'

-- ogc/system.h
function system.MEM_K0_TO_K1(x)
	return ffi.cast('void*', ffi.cast('u32', x) + (ffi.cast('u64', system.SYS_BASE_UNCACHED) - ffi.cast('u64', system.SYS_BASE_CACHED)))
end

-- [[ typical console init ...
video.VIDEO_Init()
wpad.WPAD_Init()
local rmode = video.VIDEO_GetPreferredMode(nil)
local xfbK0 = system.SYS_AllocateFramebuffer(rmode)
local xfb = system.MEM_K0_TO_K1(xfbK0)
consol.CON_Init(xfb, 20, 20, rmode[0].fbWidth, rmode[0].xfbHeight, rmode[0].fbWidth * video.VI_DISPLAY_PIX_SZ)
video.VIDEO_Configure(rmode)
video.VIDEO_SetNextFramebuffer(xfb)
video.VIDEO_SetBlack(0)
video.VIDEO_Flush()
video.VIDEO_WaitVSync()
if bit.band(rmode[0].viTVMode, video.VI_NON_INTERLACE) ~= 0 then 
	video.VIDEO_WaitVSync()
end
C.printf('\027[2;0H')
--]]

-- [[ debugging
print('rmode', rmode)
print('rmode->fbWidth', rmode[0].fbWidth)
print('rmode->xfbHeight', rmode[0].xfbHeight)
print('rmode->efbHeight', rmode[0].efbHeight)
print('rmode->viWidth', rmode[0].viWidth)
print('rmode->viHeight', rmode[0].viHeight)
print('VI_DISPLAY_PIX_SZ', video.VI_DISPLAY_PIX_SZ)
print('VI_NON_INTERLACE', video.VI_NON_INTERLACE)
print('xfbK0', xfbK0)
print('xfb',xfb)
print('xfbAlt',xfb)
--]]

local t = os.time()
local lastPressed
while os.time() < t + 60 do
	wpad.WPAD_ScanPads()
	local pressed = wpad.WPAD_ButtonsDown(0)
	if bit.band(pressed, wpad.WPAD_BUTTON_HOME) ~= 0 then
		print("Goodbye")
		break
	else
		if pressed ~= lastPressed then
			print('buttons down: '..pressed)
			lastPressed = pressed
		end
	end
	video.VIDEO_WaitVSync()
end

