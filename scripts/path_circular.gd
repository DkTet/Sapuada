@tool
extends Path2D

## O raio máximo da LARGURA (eixo X)
@export var max_width_radius: float = 1200.0

## O raio máximo da ALTURA (eixo Y)
@export var max_height_radius: float = 800.0

## O número de voltas completas que a espiral dará
@export var num_revolutions: float = 3.0

## Quantos pontos usar por volta (mais pontos = mais suave)
@export var points_per_revolution: int = 32

## Marque esta caixa para (re)gerar a espiral
@export var generate_spiral: bool = false:
	set(value):
		if value:
			_generate_spiral()
			# Reseta a variável para poder ser pressionada de novo
			set_deferred("generate_spiral", false) 

func _generate_spiral():
	# Garante que temos uma curva para trabalhar
	if curve == null:
		curve = Curve2D.new()
		
	# Limpa pontos antigos
	curve.clear_points()
	
	# Cálculos totais
	var total_points = int(num_revolutions * points_per_revolution)
	var total_angle = num_revolutions * 2 * PI # 2*PI = 360 graus em radianos
	
	print("Gerando espiral oval com %d pontos..." % total_points)

	# Nós vamos construir a espiral de FORA para DENTRO
	# O Loop vai de 'i' = 0 até total_points
	for i in range(total_points + 1):
		
		# 'fraction' vai de 0.0 (início) até 1.0 (fim)
		var fraction = float(i) / total_points
		
		# Nós queremos que o raio e o ângulo diminuam, então invertemos a fração
		var inward_fraction = 1.0 - fraction
		
		# Calcula os raios X e Y atuais separadamente
		var current_radius_x = inward_fraction * max_width_radius
		var current_radius_y = inward_fraction * max_height_radius
		
		# O ângulo atual diminui de total_angle até 0
		var current_angle = inward_fraction * total_angle
		
		# Calcula a posição (X, Y) usando a fórmula da elipse
		# x = radius_x * cos(angle)
		# y = radius_y * sin(angle)
		var point_pos = Vector2()
		point_pos.x = current_radius_x * cos(current_angle)
		point_pos.y = current_radius_y * sin(current_angle)
		
		# Adiciona o ponto à curva
		curve.add_point(point_pos)

	# Notifica o editor que a curva mudou
	notify_property_list_changed()
	print("Espiral oval gerada!")
