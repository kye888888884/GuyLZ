/// @description

with(objOGPlayerStart)
	start()

for (var i = 0; i < instance_number(objOGLines); i++) {
	var ins = instance_find(objOGLines, i)
	var other_lines = ins.get_lines()
	show_debug_message(array_length(other_lines))
	lines = array_concat(lines, other_lines)
}

instance_destroy(objOGLines)

update()