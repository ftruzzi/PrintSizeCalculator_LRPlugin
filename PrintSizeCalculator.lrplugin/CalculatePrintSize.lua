local LrLogger = import 'LrLogger'
local LrStringUtils = import 'LrStringUtils'
local LrTasks = import 'LrTasks'
local LrApplication = import 'LrApplication'
local LrFunctionContext = import 'LrFunctionContext'
local LrPrefs = import 'LrPrefs'

local _PLUGIN = _PLUGIN

local INCHES_TO_CM = 2.54
local TARGET_PPI = 300
local POLLING_INTERVAL_SECONDS = 1

local logger = LrLogger('PrintSizeLogger')
logger:enable('logfile')

logger:trace('PrintSizeCalculator plugin starting up')

-- Function to calculate max print size at given PPI
local function calculatePrintSize(photo, ppi, unit)
    if not photo then
        logger:trace('No photo selected')
        return nil
    end

    local dimensions = photo:getRawMetadata("croppedDimensions")
    
    if not dimensions then
        logger:trace('Dimensions metadata not found')
        return nil
    end
    
    local width = dimensions.width
    local height = dimensions.height
    
    if not width or not height then
        logger:trace('Width or height is nil')
        return nil
    end
    
    local printWidth, printHeight

    if unit == "cm" then
        printWidth = (width / ppi) * INCHES_TO_CM
        printHeight = (height / ppi) * INCHES_TO_CM
    elseif unit == "in" then
        printWidth = width / ppi
        printHeight = height / ppi
    else
        logger:trace('Invalid unit: ' .. unit)
        return nil
    end
    
    return printWidth, printHeight
end

-- Function to format print size dimensions
local function formatPrintSize(width, height, ppi, unit)
    if not width or not height then
        return "Dimensions unavailable"
    end
    
    local formattedWidth = LrStringUtils.numberToString(width, 1)
    local formattedHeight = LrStringUtils.numberToString(height, 1)
    
    return formattedWidth .. " × " .. formattedHeight .. " " .. unit .. " @ " .. ppi .. " PPI"
end

local function observerCallback()
    local catalog = LrApplication.activeCatalog()

    if not catalog then
        return
    end

    local photo = catalog:getTargetPhoto()

    if not photo then
        return
    end

    local prefs = LrPrefs.prefsForPlugin( _PLUGIN )
    local width, height = calculatePrintSize(photo, TARGET_PPI, prefs.unit)
    local formattedPrintSize = formatPrintSize(width, height, TARGET_PPI, prefs.unit)
    local previousFormattedPrintSize = photo:getPropertyForPlugin(_PLUGIN, 'recommendedPrintSize')

    if formattedPrintSize ~= previousFormattedPrintSize then
        catalog:withPrivateWriteAccessDo(function()
            photo:setPropertyForPlugin(_PLUGIN, 'recommendedPrintSize', formattedPrintSize)
        end)
    end
end


-- This task updates the print size when the active photo changes
LrFunctionContext.postAsyncTaskWithContext("PrintSizePhotoChangeObserver", function(context)
    LrApplication.addActivePhotoChangeObserver(context, "PrintSizePhotoChangeObserver", function()
        LrTasks.startAsyncTask(observerCallback)
    end)

    while true do
        LrTasks.sleep(1)
    end
end)


-- This task updates the print size every POLLING_INTERVAL_SECONDS, so that crop changes are reflected immediately
LrTasks.startAsyncTaskWithoutErrorHandler(function()
    logger:trace('PrintSize plugin task started. Will update the print size every ' .. POLLING_INTERVAL_SECONDS .. ' seconds.')

    while true do
        observerCallback()
        LrTasks.sleep(POLLING_INTERVAL_SECONDS)
    end
end)
