extends Node
class_name Inventory

var items={} #amount of items

func add_item(item_name:String,amount:float):
	if not items.has(item_name):
		items[item_name]=0.0		
	items[item_name]+=amount


func remove_item(item_name:String,amount:float):
	if not items.has(item_name):
		return
	items[item_name]-=amount
	if items[item_name]<0:
		items[item_name]=0
