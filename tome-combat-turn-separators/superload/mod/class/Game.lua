local _M = loadPrevious(...)

local base_tick = _M.tick

_M.ct_inCombat = false
_M.ct_combatTurnCount = 0
_M.ct_prevplayerHasEnoughEnergy = false
_M.ct_playerTurnReady = false

function _M:tick(...)

	-- Check before base_tick in case the turn is already available.
	self:ct_checkPlayerTurnReady()

	base_tick(self, ...)

	-- Check again, in case the turn was taken during the tick.
	self:ct_checkPlayerTurnReady()

	if self.ct_playerTurnReady then

		-- Combat start
		if not self.ct_inCombat and game.player.in_combat ~= nil then
			local msg = string.format("#WHITE#---------- #GOLD#Combat started #WHITE#----------")
            self.log(msg)
			self.ct_combatTurnCount = 1
			self.ct_inCombat = true
		end

		-- Combat end
		if self.ct_inCombat and game.player.in_combat == nil then
			local msg = string.format("#WHITE#---------- #GOLD#Combat ended after %d turn(s) #WHITE#----------", self.ct_combatTurnCount)
            self.log(msg)
			self.ct_combatTurnCount = 0
			self.ct_inCombat = false
		end

		-- Combat turn
		if self.ct_inCombat and self.ct_combatTurnCount > 0 then
			local msg = string.format("#WHITE#---------- #GOLD#Turn %d #WHITE#----------", self.ct_combatTurnCount)
            self.log(msg)
			self.ct_combatTurnCount = self.ct_combatTurnCount + 1
		end

		self.ct_playerTurnReady = false

	end

end

function _M:ct_checkPlayerTurnReady()
	local playerHasEnoughEnergy = self:getPlayer() and self:getPlayer():enoughEnergy()
	if not self.ct_prevPlayerHasEnoughEnergy and playerHasEnoughEnergy then
		self.ct_playerTurnReady = true
	end
	self.ct_prevPlayerHasEnoughEnergy = playerHasEnoughEnergy
end
