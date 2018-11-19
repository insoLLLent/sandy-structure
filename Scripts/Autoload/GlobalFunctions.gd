extends Node

func exists_node(node):
	if node == null:
		return false
	
	var wr = weakref(node)
	
	if wr.get_ref() == null:
		return false
	else:
		return true

