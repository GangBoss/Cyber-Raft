extends CanonBase

var current_target : Node3D
var has_target:bool= false
var delay_before_shoot: float = 2
var can_shoot:bool=true


func _on_area_3d_body_entered(body: Node3D) -> void:
	current_target=body
	has_target = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	has_target = false

func _process(delta: float):
	super(delta)
	if is_shooting == false && has_target==true && can_shoot==true :
		print("is_shooting" + str(is_shooting))
		print("has_target" + str(has_target))
		print("can_shoot" + str(can_shoot))
		shoot(current_target.position)
		

func _on_shooted() -> void:
	if can_shoot ==true :
		print("signal")
		can_shoot=false
		await get_tree().create_timer(delay_before_shoot).timeout
		can_shoot=true
