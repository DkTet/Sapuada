extends Area2D
class_name MathBall

signal ball_destroyed(value: int, ball_node: MathBall)
signal reached_end  # usado só para "acerto/erro" ao ser atingida

var ball_value: int = 0
var movement_speed: float = 80.0
var path_follow: PathFollow2D
var _float_time: float = 0.0
var _original_label_pos: Vector2

@onready var label: Label = $numero
@onready var sprite = $AnimatedSprite2D
@onready var colisao = $CollisionShape2D
	
func _ready():
	add_to_group("bolas")
	if ball_value != 0:
		label.text = str(ball_value)
	sprite.play("voando")

	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "position:y", label.position.y - 20, 0.75)
	tween.tween_property(label, "position:y", label.position.y, 0.75)

func _process(delta):
	if path_follow:
		path_follow.progress += movement_speed * delta
		global_position = path_follow.global_position
		var pos_relativa_ao_centro = path_follow.position
		if pos_relativa_ao_centro.x > 5: 
			sprite.flip_h = true
		elif pos_relativa_ao_centro.x < -5:
			sprite.flip_h = false
		if path_follow.progress_ratio >= 1.0:
			reached_end.emit() 
			_clean_and_free()

func setup(path_follow_node: PathFollow2D, value: int, speed: float):
	path_follow = path_follow_node
	ball_value = value
	movement_speed = speed
	if label:
		label.text = str(ball_value)

# <<< IMPORTANTE: NÃO emitir sinal aqui >>>
func destroy():
	# 1. Parar tudo
	movement_speed = 0.0        # Para de se mover no _process
	remove_from_group("bolas")  # Para de ser contada como uma bola válida
	label.hide()                # Esconde o número
	colisao.set_deferred("disabled", true) # Desliga a colisão para não ser atingida de novo
	
	# 2. Tocar a animação de morte
	#    (Troque "morte" pelo nome real da sua animação)
	sprite.play("morte") 
	
	# 3. ESPERAR a animação terminar
	#    O 'await' pausa a execução DESTA FUNÇÃO aqui
	await sprite.animation_finished
	
	# 4. Só agora, DEPOIS que a animação tocou, nós limpamos
	_clean_and_free()

func _clean_and_free():
	if is_instance_valid(path_follow):
		path_follow.queue_free()
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("lingua"):
		# avisa a fase que a bola foi atingida
		
		ball_destroyed.emit(ball_value, self)
		
		# a língua deve desaparecer sempre, independente se acertou ou não
		area.queue_free()
