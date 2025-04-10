if true then
	return {}
end
return {
	"snacks.nvim",
	priority = 1000,
	enabled = true,
	lazy = false,
	opts = {
		dashboard = {
			preset = {
				header = [[
         ,--.                                                                                       ,/   .`|                  
       ,--.'|                                                      ____               ,---,.      ,`   .'  :            .---. 
   ,--,:  : |                                    ,--,            ,'  , `.           ,'  .'  \   ;    ;     /           /. ./| 
,`--.'`|  ' :               ,---.              ,--.'|         ,-+-,.' _ |         ,---.' .' | .'___,/    ,'        .--'.  ' ; 
|   :  :  | |              '   ,'\       .---. |  |,       ,-+-. ;   , ||         |   |  |: | |    :     |        /__./ \ : | 
:   |   \ | :    ,---.    /   /   |    /.  ./| `--'_      ,--.'|'   |  ||         :   :  :  / ;    |.';  ;    .--'.  '   \' . 
|   : '  '; |   /     \  .   ; ,. :  .-' . ' | ,' ,'|    |   |  ,', |  |,         :   |    ;  `----'  |  |   /___/ \ |    ' ' 
'   ' ;.    ;  /    /  | '   | |: : /___/ \: | '  | |    |   | /  | |--'          |   :     \     '   :  ;   ;   \  \;      : 
|   | | \   | .    ' / | '   | .; : .   \  ' . |  | :    |   : |  | ,             |   |   . |     |   |  '    \   ;  `      | 
'   : |  ; .' '   ;   /| |   :    |  \   \   ' '  : |__  |   : |  |/              '   :  '; |     '   :  |     .   \    .\  ; 
|   | '`--'   '   |  / |  \   \  /    \   \    |  | '.'| |   | |`-'               |   |  | ;      ;   |.'       \   \   ' \ | 
'   : |       |   :    |   `----'      \   \ | ;  :    ; |   ;/                   |   :   /       '---'          :   '  |--"  
;   |.'        \   \  /                 '---"  |  ,   /  '---'                    |   | ,'                        \   \ ;     
'---'           `----'                          ---`-'                            `----'                           '---"      
                                                                                                                              
        ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
			},
		},
	},
}
