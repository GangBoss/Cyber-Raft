extends CanonBase

var current_target : Node3D
var has_target:bool= false
var delay_before_shoot: float = 1
var can_shoot:bool=true


func _on_area_3d_body_entered(body: Node3D) -> void:
	current_target=body
	has_target = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	has_target = false

func _process(delta: float):
	super(delta)
	if is_shooting == false && has_target==true && can_shoot==true :
		var random= randi()%200 -2
		random=0
		shoot(current_target.global_position+ Vector3(0,0,random))
		

func _on_shooted() -> void:
	if can_shoot ==true :
		can_shoot=false
		await get_tree().create_timer(delay_before_shoot).timeout
		can_shoot=true
