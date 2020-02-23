extends Control

var arraydata
var parentnodearray 
var target_node
var target_function

func get_drag_data(position):
	set_drag_preview(self.duplicate())
	return arraydata

func can_drop_data(position, data):
	#print(data)
	return true

func drop_data(position, data):
	if str(data) == str(arraydata):
		return
	var order1 = parentnodearray.find(data)
	var order2 = parentnodearray.find(arraydata)
	
	parentnodearray.erase(data)
	parentnodearray.insert(order2, data)
	target_node.call(target_function)
	#get_parent().get_parent().get_parent().get_parent().change_order()
