extends Node2D

var last_customer = null

func _ready() -> void:
	Global.customer_leave.connect(call_customer)
	start()

func start():
	call_customer()

func call_customer():
	var customers = get_children()
	if last_customer != null:
		customers.erase(last_customer)
	var customer: Customer = customers.pop_at(randi_range(0, len(customers) - 1))
	last_customer = customer
	customer.go_buy_ice_cream()
