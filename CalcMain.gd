extends Control

enum OPERATION {NONE, ADD, SUBTRACT, DIVIDE, MULTIPLY}

var accumulator = 0
var inputbuf = ""
var opdisplaybuf = ""
var operation = OPERATION.NONE
var resultflag = false

func updatedisplay():
	if inputbuf.left(2) != "0.": inputbuf = inputbuf.lstrip( "0" )
	if inputbuf.is_empty(): inputbuf = "0"
	find_child("Display").set_text( inputbuf )

func updateopdisplay():
	find_child("OpDisplay").set_text( opdisplaybuf )

func setop( op ):
	accumulator = inputbuf.to_float()
	inputbuf = ""
	operation = op
	resultflag = false
	
	opdisplaybuf = str(accumulator)
	opdisplaybuf += " "

	var opchar
	match operation:
		OPERATION.ADD:      opdisplaybuf += "+"
		OPERATION.SUBTRACT: opdisplaybuf += "-"
		OPERATION.DIVIDE:   opdisplaybuf += "÷"
		OPERATION.MULTIPLY: opdisplaybuf += "×"
	
	updateopdisplay()
	updatedisplay()

# Called when the node enters the scene tree for the first time.
func _ready():
	updatedisplay()
	updateopdisplay()

func performdelaction():
	inputbuf = inputbuf.left( inputbuf.length() - 1 )
	resultflag = false
	if inputbuf == "-": inputbuf = ""
	if operation == OPERATION.NONE:
		opdisplaybuf = ""
		updateopdisplay()
	updatedisplay()

func performclearentry():
	inputbuf = ""
	if operation == OPERATION.NONE:
		opdisplaybuf = ""
		updateopdisplay()
	updatedisplay()

func performdecimalaction():
	if inputbuf.find( "." ) != -1: return
	if inputbuf.is_empty(): inputbuf += "0"
	inputbuf += "."
	updatedisplay()
	
func performcalculation():
	var x = inputbuf.to_float()
	var result = 0
	match operation:
		OPERATION.NONE:
			return
		OPERATION.ADD:
			result = accumulator + x
		OPERATION.SUBTRACT:
			result = accumulator - x
		OPERATION.DIVIDE:
			result = accumulator / x
		OPERATION.MULTIPLY:
			result = accumulator * x
	
	opdisplaybuf += " "
	opdisplaybuf += inputbuf
	opdisplaybuf += " ="
	
	inputbuf = str( result )
	operation = OPERATION.NONE
	accumulator = 0
	
	resultflag = true
	
	updatedisplay()
	updateopdisplay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Zero"): numeralinput(0)
	if Input.is_action_just_pressed("One"): numeralinput(1)
	if Input.is_action_just_pressed("Two"): numeralinput(2)
	if Input.is_action_just_pressed("Three"): numeralinput(3)
	if Input.is_action_just_pressed("Four"): numeralinput(4)
	if Input.is_action_just_pressed("Five"): numeralinput(5)
	if Input.is_action_just_pressed("Six"): numeralinput(6)
	if Input.is_action_just_pressed("Seven"): numeralinput(7)
	if Input.is_action_just_pressed("Eight"): numeralinput(8)
	if Input.is_action_just_pressed("Nine"): numeralinput(9)
	if Input.is_action_just_pressed("Add"): setop( OPERATION.ADD )
	if Input.is_action_just_pressed("Sub"): setop( OPERATION.SUBTRACT )
	if Input.is_action_just_pressed("Mul"): setop( OPERATION.MULTIPLY )
	if Input.is_action_just_pressed("Div"): setop( OPERATION.DIVIDE )
	if Input.is_action_just_pressed("Decimal"): performdecimalaction()
	if Input.is_action_just_pressed("Backsp"): performdelaction()
	if Input.is_action_just_pressed("Clear"): performclearentry()
	if Input.is_action_just_pressed("Eq"): performcalculation()

func numeralinput( num ):
	if resultflag:
		inputbuf = ""
		opdisplaybuf = ""
		operation = OPERATION.NONE
		resultflag = false
		updateopdisplay()
	inputbuf += str( num )
	updatedisplay()

func _on_btn_ce_pressed():
	performclearentry()

func _on_btn_1_pressed(): numeralinput( 1 )
func _on_btn_2_pressed(): numeralinput( 2 )
func _on_btn_3_pressed(): numeralinput( 3 )
func _on_btn_4_pressed(): numeralinput( 4 )
func _on_btn_5_pressed(): numeralinput( 5 )
func _on_btn_6_pressed(): numeralinput( 6 )
func _on_btn_7_pressed(): numeralinput( 7 )
func _on_btn_8_pressed(): numeralinput( 8 )
func _on_btn_9_pressed(): numeralinput( 9 )
func _on_btn_0_pressed(): numeralinput( 0 )

func _on_btn_del_pressed():
	performdelaction()

func _on_btn_mul_pressed():   setop( OPERATION.MULTIPLY )
func _on_btn_div_pressed():   setop( OPERATION.DIVIDE )
func _on_btn_minus_pressed(): setop( OPERATION.SUBTRACT )
func _on_btn_ad_pressed():    setop( OPERATION.ADD )

func _on_btn_eq_pressed():
	performcalculation()

func _on_btn_c_pressed():
	inputbuf = ""
	opdisplaybuf = ""
	accumulator = 0
	operation = OPERATION.NONE
	resultflag = false
	updatedisplay()
	updateopdisplay()

func _on_btn_sign_pressed():
	if inputbuf.is_empty(): return
	if inputbuf[0] == "-":
		inputbuf = inputbuf.right( inputbuf.length() - 1 )
	else:
		inputbuf = "-" + inputbuf
	updatedisplay()

func _on_btn_decimal_pressed():
	performdecimalaction()
