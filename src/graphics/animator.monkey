Strict

Import system.time

Class AnimStep
Public
	Field graph:Int
	Field timeMs:Int
	Method New(graph:Int, timeMs:Int)
		Self.graph = graph
		Self.timeMs = timeMs
	End Method
End Class

Class AnimResult
Public
	Field graph:Int
	Field ended:Bool
	Method New(graph:Int, ended:Bool)
		Self.graph = graph
		Self.ended = ended
	End Method
End Class

Class Animator
Public

	Const BLINK_RATE:Int = 100

	Const ANIM_DEFAULT:Int = -1
	
	Const ANIM_SURVIVOR_IDLE:Int = ANIM_DEFAULT + 1
	Const ANIM_SURVIVOR_RUN:Int = ANIM_SURVIVOR_IDLE + 1
	Const ANIM_SURVIVOR_JUMP:Int = ANIM_SURVIVOR_RUN + 1
	Const ANIM_SURVIVOR_PUNCH:Int = ANIM_SURVIVOR_JUMP + 1
	Const ANIM_SURVIVOR_CROUCH:Int = ANIM_SURVIVOR_PUNCH + 1
	
	Const ANIM_SURVIVOR_CROUCH_PUNCH:Int = ANIM_SURVIVOR_CROUCH + 1
	Const ANIM_SURVIVOR_OUCH:Int = ANIM_SURVIVOR_CROUCH_PUNCH + 1
	Const ANIM_SURVIVOR_DIE:Int = ANIM_SURVIVOR_OUCH + 1
	Const ANIM_MUTANT_IDLE:Int = ANIM_SURVIVOR_DIE + 1
	Const ANIM_MUTANT_RUN:Int = ANIM_MUTANT_IDLE + 1
	
	Const ANIM_MUTANT_JUMP:Int = ANIM_MUTANT_RUN + 1
	Const ANIM_MUTANT_PUNCH:Int = ANIM_MUTANT_JUMP + 1
	Const ANIM_MUTANT_DIE:Int = ANIM_MUTANT_PUNCH + 1
	Const ANIM_MUTANT_SPRINT:Int = ANIM_MUTANT_DIE + 1

	Global anims:AnimStep[14][]
	
	Function Initialize:Void()
		anims[ANIM_SURVIVOR_IDLE] =				[ New AnimStep(0, 500)								]
		anims[ANIM_SURVIVOR_RUN] =				[ New AnimStep(3, 90), 		New AnimStep(4, 140)	]
		anims[ANIM_SURVIVOR_JUMP] =				[ New AnimStep(7, 120)								]
		anims[ANIM_SURVIVOR_PUNCH] =			[ New AnimStep(11, 120)								]
		anims[ANIM_SURVIVOR_CROUCH] =			[ New AnimStep(16, 100)								]
		anims[ANIM_SURVIVOR_CROUCH_PUNCH] =		[ New AnimStep(18, 100)								]
		anims[ANIM_SURVIVOR_OUCH] =				[ New AnimStep(7, 100)								]
		anims[ANIM_SURVIVOR_DIE] =				[ New AnimStep(14, 100)								]
		anims[ANIM_MUTANT_IDLE] =				[ New AnimStep(0, 500)								]
		anims[ANIM_MUTANT_RUN] =				[ New AnimStep(3, 90), 		New AnimStep(4, 140)	]
		anims[ANIM_MUTANT_JUMP] =				[ New AnimStep(7, 120)								]
		anims[ANIM_MUTANT_PUNCH] =				[ New AnimStep(11, 120)								]
		anims[ANIM_MUTANT_DIE] =				[ New AnimStep(14, 100)								]
		anims[ANIM_MUTANT_SPRINT] =				[ New AnimStep(3, 25), 		New AnimStep(4, 40)		]
	End Function

	Field stepEnd:Float
	Field currentStep:Int = 0
	Field status:Int = ANIM_DEFAULT
	Field currentAnim:AnimStep[]

	' Resulting graph is -1 to Assets.ANIMS_FRAMES-1
	' -1 = do not draw
	Method Animate:AnimResult(currentStatus:Int, blinking:Bool = False)
		Local time:Float = Time.instance.actTime
		Local ended:Bool = False

		If (currentStatus = ANIM_DEFAULT)
			Return New AnimResult(-1, False)
		End If
				
		If (status <> currentStatus)
			currentStep = 0
			status = currentStatus
			currentAnim = anims[status]
			stepEnd = time + (currentAnim[currentStep].timeMs * Rnd(70, 130)) / 100 ' random component!
		Else If (time >= stepEnd)
			If (currentStep = currentAnim.Length - 1)
				currentStep = 0
				ended = True
			Else
				currentStep += 1
			End If
			stepEnd = time + (currentAnim[currentStep].timeMs * Rnd(70, 130)) / 100 ' random component!
		End If
		Local graph:Int = currentAnim[currentStep].graph
		If (blinking And (Floor(time / BLINK_RATE Mod 2) = 0)) Then graph = -1
		Return New AnimResult(graph, ended)
	End Method
	
End Class