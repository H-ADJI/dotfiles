local M = {}
function M.Flatten_table(tbl)
  local flat_table = {}
  for i, inner_table in ipairs(tbl) do
    for j, value in ipairs(inner_table) do
      table.insert(flat_table, value)
    end
  end
  return flat_table
end
return M
