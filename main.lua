local cards = require "cards"

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local function spairs(tab, ...)
	local keys,vals,idx = {},{},0
	for k in pairs(tab) do
		keys[#keys+1] = k
	end
	table.sort(keys, ...)
	for i=1,#keys do
		vals[i]=tab[keys[i]]
	end
	return function()
		idx = idx + 1
		return keys[idx], vals[idx]
	end
end

love.window.setMode(1024, 768)
love.window.setTitle("Kemet")

function love.load()
	math.randomseed(os.time())
end

local picks_lookup = {
	[2] = {3, 3, 2, 2},
	[3] = {3, 3, 3, 3},
	[4] = {4, 4, 3, 3},
	[5] = {4, 4, 4, 4},
}

local function picks_table(players)
	return picks_lookup[players]
end

local function used_colors()
-- 3 out of 4 colors
	local colors = {"red", "blue", "white", "black"}
	local del = math.random(1, 4)
	table.remove(colors, del)
	return colors
end

local function all_cards(...) -- put expansions into the varargs
-- returns a database of all cards including expansions
	local c = deepcopy(cards)
	local args = {...}

	-- insert expansion cards
	for i = 1, #args do
		for tier, colors_table in pairs(c[ args[i] ]) do
			for color, toinsert in pairs(colors_table) do
				for j = 1, #toinsert do
					table.insert(c.base[tier][color], toinsert[j])
				end
			end
		end
	end

	return c.base
end

local function chosen_cards(players, ...)
-- returns the picks for the current game
	local colors = used_colors()
	local picks = picks_table(players)
	local c = all_cards(...)
	local ret = {}
	for i = 1, 4 do	ret["tier" .. i] = {} end
	for i = 1, #colors do
		ret["tier" .. i][ colors[i] ] = {}
	end

	for i = 1, #colors do
		for j = 1, #picks do
			local tier = c["tier" .. j]
			local selection = tier[ colors[i] ]
			local ret_cards = {}
			local already_chosen = {}
			for k = 1, picks[j] do
				local choose = math.random(#selection)
				while table.contains(already_chosen, choose) do
					choose = math.random(#selection)
				end
				table.insert(already_chosen, choose)
				table.insert(ret_cards, selection[choose])
			end	

			ret["tier" .. j][ colors[i] ] = ret_cards
		end
	end

	return ret
end

local current_picks = chosen_cards(2)
local players = 2 
local expansions = {
	greek_legends = false,
	ta_seti_goodies = false,
}

local draw_locs = {
	colors_x = function(i) return 200 * i end,
	colors_y = function(i) return 200 end,
	tiers_x = function(i) return 100 end,
	tiers_y = function(i) return 200 + i * 100 end,
}

function love.draw()
	love.graphics.clear()

	-- Instructions
	love.graphics.printf("KEMET RANDOMIZER", 0, 30, 1024, "center")
	love.graphics.printf("Press number keys 2, 3, 4, 5 to select number of players", 0, 50, 1024, "center")
	love.graphics.printf("Press keys a, s to toggle expansions", 0, 70, 1024, "center")
	love.graphics.printf("Press space bar to randomize", 0, 90, 1024, "center")
	love.graphics.printf("Players: " .. players, 20, 50, 300, "left")
	love.graphics.printf("Expansions:", 20, 70, 1024, "left")
	love.graphics.printf("Greek Legends: " .. tostring(expansions.greek_legends), 40, 90, 1024, "left")
	love.graphics.printf("Ta-Seti Goodies: " .. tostring(expansions.ta_seti_goodies), 40, 110, 1024, "left")

	-- Column headers (colors)
	local idx = 1
	for color, cardlist in spairs(current_picks.tier1) do
		love.graphics.printf(color, draw_locs.colors_x(idx), draw_locs.colors_y(idx), 300, "center")
		idx = idx + 1
	end

	-- Row headers (tiers)
	for i = 1, 4 do
		love.graphics.printf("Tier ".. i, draw_locs.tiers_x(i), draw_locs.tiers_y(i), 300, "left")
	end

	-- Table contents
	for i = 1, 4 do
		local bath = 1
		for color, cardlist in spairs(current_picks["tier"..i]) do
			for j = 1, #cardlist do
				local todraw = current_picks["tier"..i][color][j]
				local y = draw_locs.tiers_y(i) - 40 + j * 20
				love.graphics.printf(todraw, draw_locs.colors_x(bath), y, 300, "center")
			end
			bath = bath + 1
		end
	end
end

function love.update(dt)
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "2" then players = 2 end
	if key == "3" then players = 3 end
	if key == "4" then players = 4 end
	if key == "5" then players = 5 end

	if key == "a" then expansions.greek_legends = not expansions.greek_legends end
	if key == "s" then expansions.ta_seti_goodies = not expansions.ta_seti_goodies end

	if key == "space" then 
		local exp = {}
		for str, use in pairs(expansions) do
			if use then exp[#exp+1] = str end
		end
		current_picks = chosen_cards(players, unpack(exp))
	end
end

