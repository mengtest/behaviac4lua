
package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua;./lua/protobuf/?.lua;./lua/proto_pb/?.lua"
package.cpath = package.cpath .. ";./?.dll;./clibs/?.dll"

local b = require "behaviac"
--local p = require "presstest"
--local msg_dispatcher = require ("presstest.MessageDispatcher")
--local pressTestManager = require ("presstest.PressTestManager")--p.PressTestManager
local EBTStatus = b.enums.EBTStatus
local AgentMeta = b.AgentMeta
local BehaviorTreeFactory = b.BehaviorTreeFactory

local MyRobotClass = class("Robot", b.BaseAgent)

function MyRobotClass:ctor(unit)
    MyRobotClass.super.ctor(self)
    self.unit = unit
    self.count = 0
end

function MyRobotClass:doLogin()
    print("Do Login ...")
    msg_dispatcher.registerMessageCb()
    pressTestManager.startTest(1)--(testNumMax)
    return EBTStatus.BT_RUNNING
end

function MyRobotClass:doFarm()
    print("Do Farm ...")
    --msg_dispatcher.sendUserDungeonService(self.unit, {cmd = 1, dungeon_id = 0})
    --msg_dispatcher.sendUserNavigationService(self.unit, {cmd = 1})
    return EBTStatus.BT_SUCCESS
    -- return p.MessageDispatcher.state
end

function MyRobotClass:doNext()
    print("Do Next ...")
    return EBTStatus.BT_SUCCESS
end

function MyRobotClass:doLinger()
    return EBTStatus.BT_RUNNING
end

function MyRobotClass:SayHello(msg)
    print("SayHello: ")
    print(msg)
end

function MyRobotClass:Say(msg)
    print("Say: ")
    print(msg)
end

function MyRobotClass:getDungeonPreTask()
    return 123456
end


function MyRobotClass:doTask(taskId)
    self.count = self.count + 1
    if self.count >= 2 then
        print("doTask...success")
        self.count = 0
        return EBTStatus.BT_SUCCESS
    else
        print("doTask...running")
        return EBTStatus.BT_RUNNING
    end
end

function MyRobotClass:doUnlockMapArea(taskId)
    self.count = self.count + 1
    if self.count >= 2 then
        print("doTask...success")
        self.count = 0
        return EBTStatus.BT_SUCCESS
    else
        print("doTask...running")
        return EBTStatus.BT_RUNNING
    end
end

function MyRobotClass:doLogPlayerInfo(param1, param2)
    print("doLogPlayerInfo...")
    return EBTStatus.BT_SUCCESS
end

function MyRobotClass:GetP1s1()
    return tonumber(self.p1.s1)
end

function MyRobotClass:Start(a, b, c)
    self.count = 0
end

function MyRobotClass:Wait()
    self.count = self.count + 1

	print("p1 =", p1)

	if self.count == 10000 then
		return EBTStatus.BT_SUCCESS
    end

	return EBTStatus.BT_RUNNING
end

assert(nil == _M)
----------------------------------------------------------------
local myRobot = MyRobotClass.new()
AgentMeta.setBehaviorTreeFolder("./lua/data/")
--local path = AgentMeta.getBehaviorTreePath("PressTest")
local path = AgentMeta.getBehaviorTreePath("LoopBT")
--local path = AgentMeta.getBehaviorTreePath("SelectBT")
--local path = AgentMeta.getBehaviorTreePath("SequenceBT")
--local path = AgentMeta.getBehaviorTreePath("InstanceBT")
--local path = AgentMeta.getBehaviorTreePath("ParentBT")
local path_maintree = AgentMeta.getBehaviorTreePath("maintree.bson.bytes")
local path_subtree = AgentMeta.getBehaviorTreePath("subtree")
local path_maintree_task = AgentMeta.getBehaviorTreePath("maintree_task.bson.bytes")
local path_subtree_task = AgentMeta.getBehaviorTreePath("subtree_task")
local path_LoopBattleBT = AgentMeta.getBehaviorTreePath("LoopBattleBT")
local path_demo = AgentMeta.getBehaviorTreePath("demo")
local path_StructBT = AgentMeta.getBehaviorTreePath("StructBT")
local path_EnumBT = AgentMeta.getBehaviorTreePath("EnumBT.bson.bytes")

local path_islandBattle = AgentMeta.getBehaviorTreePath("islandBattle")
local path_task = AgentMeta.getBehaviorTreePath("task")

local path_demo = AgentMeta.getBehaviorTreePath("demo")

-- force load
BehaviorTreeFactory.loadBehaviorTree(path_demo .. ".json")

AgentMeta.registerEnumType("FirstEnum", { e1 = 0, e2 = 1 })
--myRobot:btSetCurrent(path_islandBattle)
myRobot:btSetCurrent(path_demo)

local loopCount = 3
--for i= 1, loopCount do
local frame = 1
while true do

    print('-----------------------start-----------------------', frame)
    myRobot:btExec()
    print('end', '----------------------------------------------', frame)

    frame = frame + 1
end

print('---- ---- fire event... ---- ----')
--myRobot:fireEvent("event_task", 2)
--myRobot:btExec()