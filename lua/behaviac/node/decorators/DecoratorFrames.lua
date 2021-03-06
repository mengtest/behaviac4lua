--- Behaviac lib Component: time decorator node.
-- @module DecoratorFrames.lua
-- @author n.lee
-- @copyright 2016
-- @license MIT/X11

-- Localize
local ppdir = (...):gsub('%.[^%.]+%.[^%.]+%.[^%.]+$', '') .. "."
local cwd = (...):gsub('%.[^%.]+$', '') .. "."
local enums = require(ppdir .. "enums")
local common = require(ppdir .. "common")

local EBTStatus                 = enums.EBTStatus
local ENodePhase                = enums.ENodePhase
local EPreDecoratorPhase        = enums.EPreDecoratorPhase
local TriggerMode               = enums.TriggerMode
local EOperatorType             = enums.EOperatorType

local constSupportedVersion     = enums.constSupportedVersion
local constInvalidChildIndex    = enums.constInvalidChildIndex
local constBaseKeyStrDef        = enums.constBaseKeyStrDef
local constPropertyValueType    = enums.constPropertyValueType

local Logging                   = common.d_log
local StringUtils               = common.StringUtils

-- Class
local Decorator = require(ppdir .. "core.Decorator")
local DecoratorFrames = class("DecoratorFrames", Decorator)
_G.ADD_BEHAVIAC_DYNAMIC_TYPE("DecoratorFrames", DecoratorFrames)
_G.BEHAVIAC_DECLARE_DYNAMIC_TYPE("DecoratorFrames", "Decorator")
local _M = DecoratorFrames

local NodeParser = require(ppdir .. "parser.NodeParser")

--------------------------------------------------------------------------------
-- Initialize
--------------------------------------------------------------------------------

-- ctor
function _M:ctor()
    _M.super.ctor(self)
    
    self.m_frames_p = false
end

function _M:release()
    _M.super.release(self)

    self.m_frames_p = false
end

function _M:onLoading(version, agentType, properties)
    _M.super.onLoading(self, version, agentType, properties)

    local nameStr, valueStr
    for _, p in ipairs(properties) do
        nameStr = p[1]
        valueStr = p[2]

        if nameStr == "Frames" then
            local pParenthesis = string.find(valueStr, '%(')
            if not pParenthesis then
                self.m_frames_p = NodeParser.parseProperty(valueStr)
            else
                self.m_frames_p = NodeParser.parseMethod(valueStr)
            end
        end
    end
end

function _M:getFramesP(agent, tick)
    return self.m_frames_p and self.m_frames_p:getValue(agent, tick) or 0
end

function _M:isDecoratorFrames()
    return true
end

--------------------------------------------------------------------------------
-- Blackboard:
--------------------------------------------------------------------------------

function _M:init(tick)
    _M.super.init(self, tick)

    self:setStart(tick, 0)
    self:setFrames(tick, 0)
end

function _M:onEnter(agent, tick)
    self:setStart(tick, common.getFrames())
    self:setFrames(tick, self:getFramesP(agent, tick) or 0)

    return self:getFrames() > 0
end

function _M:decorate(status, tick)
    local frames = common.getFrames()
    if frames - self:getStart(tick) + 1 >= self:getFrames(tick) then
        return EBTStatus.BT_SUCCESS
    end

    return EBTStatus.BT_RUNNING
end

function _M:setStart(tick, n)
    tick:setNodeMem("start", n, self)
end

function _M:getStart(tick)
    return tick:getNodeMem("start", self)
end

function _M:setFrames(tick, n)
    tick:setNodeMem("frames", n, self)
end

function _M:getFrames(tick)
    return tick:getNodeMem("frames", self)
end

return _M