local function get_cell(is_note, lines, line_index, column_index)
  return (is_note and lines[line_index].note_columns[column_index])  or lines[line_index].effect_columns[column_index]
end

local function jump_to_next_note(increment)
  assert(increment ~= 0)
  local is_note = renoise.song().selected_note_column ~= nil
  local column_index = (is_note and renoise.song().selected_note_column_index) or renoise.song().selected_effect_column_index

  local pattern_length = renoise.song().selected_pattern.number_of_lines
  local line_index = renoise.song().selected_line_index + increment
  local out_of_bounds_index = (increment > 0 and pattern_length + 1 ) or 0
  local lines = renoise.song().selected_pattern_track.lines

  local cell = get_cell(is_note, lines, line_index, column_index)

  while line_index ~= out_of_bounds_index and cell.is_empty do 
    line_index = line_index + increment
    cell = line_index ~= out_of_bounds_index and get_cell(is_note, lines, line_index, column_index)
  end

  if line_index ~= out_of_bounds_index then renoise.song().selected_line_index = line_index end

end


renoise.tool():add_keybinding({
   name="Pattern Editor:Selection:Jump To Next Note",
   invoke=function() jump_to_next_note(1) end
})

renoise.tool():add_keybinding({
   name="Pattern Editor:Selection:Jump To Previous Note",
   invoke=function() jump_to_next_note(-1) end
})
