Strict

Import actors.actor
Import actors.behaviors.mutantbrain
Import graphics.screen 

Class Mutant Extends Actor
	Const TYPE_ROCKY:String ="ROCKY_MUTANT"

	Const BASE_LATERAL_SPEED:Float = 300.0
	Const GROUND_LATERAL_SPEED:Float = 100.0
	Const JUMP_LATERAL_SPEED_MIN:Float = 400.0
	Const JUMP_LATERAL_SPEED_MAX:Float = 400.0
	Const JUMP_SPEED_MIN:Float = 200.0
	Const JUMP_SPEED_MAX:Float = 300.0
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_MUTANT)
	
	Field animStatus:Int = Animator.ANIM_MUTANT_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)
	
	Field mutantType:String

	Method New(type:String)
		behavior = New MutantBrain(type, Self)
		z = -10.0
		image = anim[0]
		
		Local colorShift:Float = Rnd(-0.2, 0.2)
		Select(type)
			Case TYPE_ROCKY
				r = 0.5 + colorShift
				g = 0.5 + colorShift
				b = 0.5 + colorShift
		End Select
		
		Super.PostConstruct()

		SetRandomInitialPosition()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_MUTANT_IDLE
		If (speedY <> 0.0 And (y <> Screen.GroundHeight - boxHeight + yShift) And (y <> Screen.TrainHeight - boxHeight + yShift))
			animStatus = Animator.ANIM_MUTANT_JUMP
		Else If (speedX <> 0.0)
			If (y = Screen.GroundHeight)
				animStatus = Animator.ANIM_MUTANT_SPRINT
			Else
				animStatus = Animator.ANIM_MUTANT_RUN
			End If
		End If
		Local animResult:AnimResult = animator.Animate(animStatus)
		If (animResult.graph = -1)
			image = Null
		Else 
			image = anim[animResult.graph]
		End If
		sizeX = directionX
		Super.Draw(canvas)
	End Method
	
	Method TryToMove:Void(worldState:WorldState)
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
	
		'if all goes well (no collisions and stuff), move
		x += speedX * deltaInSecs
		y -= speedY * deltaInSecs
	End Method

		
Private
	Method SetRandomInitialPosition:Void()
		Local side:Float = 1.0
		If (Rnd(1000.0) < 500.0) Then side = -1.0	' left or right
		x = (Screen.Width / 2.0) + side * ((Screen.Width / 2.0) + 100.0)
		'If (Rnd(1000.0) < 500.0)
			' jumping
			y = Screen.TrainHeight - boxHeight + yShift + Rnd(-50.0, 50.0)
			directionX = -side
			speedX = Rnd(JUMP_LATERAL_SPEED_MIN, JUMP_LATERAL_SPEED_MAX) * -side
			speedY = Rnd(JUMP_SPEED_MIN, JUMP_SPEED_MAX)
		'Else
			' running on ground
		'	y = Screen.GroundHeight
		'End If
	End Method

End Class