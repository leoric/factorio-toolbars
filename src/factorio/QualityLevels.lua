import("Cache")

---@class QualityLevels : Object
---@field private __instance QualityLevels
---@field private _qualityLevels Cache
QualityLevels = Object:extendAs("factorio.QualityLevels")

---@public
---@return QualityLevels
function QualityLevels.new()
    local this = QualityLevels:super(Object.new())
    this._qualityLevels = Cache.new(function(name)
        return prototypes.quality[name].level
    end)
    return this
end

---@public
---@return QualityLevels
function QualityLevels.instance()
    return QualityLevels.__instance
end
QualityLevels.__instance = QualityLevels.new()

---@public
---@param name string
---@return number
function QualityLevels:getQualityLevel(name)
    return self._qualityLevels:get(name)
end
