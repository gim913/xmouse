local ffi = require('ffi')
ffi.cdef[[
int32_t SystemParametersInfoW(uint32_t uiAction, uint32_t uiParam, void* pvParam, uint32_t fWinIni);
]]

local Spi = {
	Get_Active_Window_Tracking   = 0x1000
	, Set_Active_Window_Tracking = 0x1001
	, Get_Active_Wnd_Trk_ZOrder  = 0x100c
	, Set_Active_Wnd_Trk_ZOrder  = 0x100d
	, Get_Active_Wnd_Trk_Timeout = 0x2002
	, Set_Active_Wnd_Trk_Timeout = 0x2003
}

local SpiFlags = {
	Update_Ini_File       = 0x0001
	, Send_Win_Ini_Change = 0x0002
	, Send_Change         = 0x0002
}

local function printSettings()
	-- BOOL
	local temp = ffi.new("uint32_t[1]", 0)
	ffi.C.SystemParametersInfoW(Spi.Get_Active_Window_Tracking, 0, temp, 0)
	print("\tActive Window tracking state   :", temp[0])

	ffi.C.SystemParametersInfoW(Spi.Get_Active_Wnd_Trk_ZOrder, 0, temp, 0)
	print("\tActive Window tracking zorder  :", temp[0])

	-- DWORD
	local timeOut = ffi.new("uint32_t[1]", 0)
	ffi.C.SystemParametersInfoW(Spi.Get_Active_Wnd_Trk_Timeout, 0, timeOut, 0)
	print ("\tActive Window tracking timeout :", timeOut[0])
end

local function changeSettings(act, zord, timeOut)
	local actVal = act and 1 or 0
	ffi.C.SystemParametersInfoW(Spi.Set_Active_Window_Tracking, 0, ffi.cast("void*", actVal), SpiFlags.Update_Ini_File + SpiFlags.Send_Change)
	ffi.C.SystemParametersInfoW(Spi.Set_Active_Wnd_Trk_ZOrder,  0, ffi.cast("void*", zord), SpiFlags.Update_Ini_File + SpiFlags.Send_Change)
	ffi.C.SystemParametersInfoW(Spi.Set_Active_Wnd_Trk_Timeout, 0, ffi.cast("void*", timeOut), SpiFlags.Update_Ini_File + SpiFlags.Send_Change)
end

local function main()
	print("current settings:")
	printSettings()

	-- if you want to get back to defaults:
	-- changeSettings(false, 0, 0)
	changeSettings(true, 0, 100)

	print ("new settings:")
	printSettings()
end

main()
