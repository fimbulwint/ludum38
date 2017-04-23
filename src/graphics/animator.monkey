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

	Const ANIM_DEFAULT:Int = -1
	Const ANIM_SURVIVOR_IDLE:Int = 0
	Const ANIM_SURVIVOR_RUN:Int = 1
	Const ANIM_SURVIVOR_JUMP:Int = 2
	Const ANIM_SURVIVOR_PUNCH:Int = 3
	Const ANIM_SURVIVOR_DIE:Int = 4
	Const ANIM_MUTANT_IDLE:Int = 5
	Const ANIM_MUTANT_RUN:Int = 6
	Const ANIM_MUTANT_JUMP:Int = 7
	Const ANIM_MUTANT_PUNCH:Int = 8
	Const ANIM_MUTANT_DIE:Int = 9
	Const ANIM_MUTANT_SPRINT:Int = 10

	Global anims:AnimStep[11][]
	
	Function Initialize:Void()
		anims[ANIM_SURVIVOR_IDLE] =		[ New AnimStep(0, 500)]
		anims[ANIM_SURVIVOR_RUN] =		[ New AnimStep(3, 90), 		New AnimStep(4, 140)]
		anims[ANIM_SURVIVOR_JUMP] =		[ New AnimStep(7, 120)]
		anims[ANIM_SURVIVOR_PUNCH] =	[ New AnimStep(11, 120)]
		anims[ANIM_SURVIVOR_DIE] =		[ New AnimStep(14, 100)]
		anims[ANIM_MUTANT_IDLE] =		[ New AnimStep(0, 500)]
		anims[ANIM_MUTANT_RUN] =		[ New AnimStep(3, 90), 		New AnimStep(4, 140)]
		anims[ANIM_MUTANT_JUMP] =		[ New AnimStep(7, 120)]
		anims[ANIM_MUTANT_PUNCH] =		[ New AnimStep(11, 120)]
		anims[ANIM_MUTANT_DIE] =		[ New AnimStep(14, 100)]
		anims[ANIM_MUTANT_SPRINT] =		[ New AnimStep(3, 45), 		New AnimStep(4, 70)]
	End Function

	Field stepEnd:Float
	Field currentStep:Int = 0
	Field status:Int = ANIM_DEFAULT

	' Resulting graph is -1 to Assets.ANIMS_FRAMES-1
	' -1 = do not draw
	Method Animate:AnimResult(currentStatus:Int)	
		Local time:Float = Time.instance.actTime
		Local ended:Bool = False

		If (currentStatus = ANIM_DEFAULT)
			Return New AnimResult(-1, False)
		End If
				
		If (status <> currentStatus)
			currentStep = 0
			status = currentStatus
			stepEnd = time + (anims[status][currentStep].timeMs * Rnd(70, 130)) / 100 ' random component!
		Else If (time >= stepEnd)
			If (currentStep = anims[status].Length - 1)
				currentStep = 0
				ended = True
			Else
				currentStep += 1
			End If
			stepEnd = time + (anims[status][currentStep].timeMs * Rnd(70, 130)) / 100 ' random component!
		End If
		Local graph:Int = anims[status][currentStep].graph
		Return New AnimResult(graph, ended)
	End Method
	
End Class