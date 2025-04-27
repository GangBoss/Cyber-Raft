extends CanonBase

var current_target : Node3D
var has_target:bool= false
var delay_before_shoot: float = 1
var can_shoot:bool=true


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("found target"+str(body.global_position) +str(body.name))
	current_target=body
	has_target = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("exited target"+str(body.global_position)+str(body.name))
	has_target = false

func _process(delta: float):
	super(delta)
	if is_shooting == false && has_target==true && can_shoot==true :
		print("is_shooting" + str(is_shooting))
		print("has_target" + str(has_target))
		print("can_shoot" + str(can_shoot))
		var random= randi()%200 -2
		random=0
		shoot(current_target.global_position+ Vector3(0,0,random))
		

func _on_shooted() -> void:
	if can_shoot ==true :
		print("signal")
		can_shoot=false
		await get_tree().create_timer(delay_before_shoot).timeout
		can_shoot=true
