Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.animator
Import graphics.assets
Import graphics.screen
Import system.time

Class Survivor Extends Actor

	Const BASE_LATERAL_SPEED:Float = 300.0
	Const JUMP_SPEED:Float = 250.0
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_SURVIVOR)
	
	Field animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)

	Method New()
		behavior = New Controllable(Self)
		x = Screen.WIDTH / 2
		z = 0.0
		image = anim[0]
		
		Super.PostConstruct()
		
		y = Ground.GROUND_HEIGHT - boxHeight
	End Method
	
	Method TryToMove:Void(worldState:WorldState)
		Super.TryToMove(worldState)
	
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
		
		If (hp > 0.0)
			If (movingLeft)
				speedX = -BASE_LATERAL_SPEED
				directionX = -1.0
			ElseIf(movingRight)
				speedX = BASE_LATERAL_SPEED
				directionX = 1.0
			Else
				speedX = 0.0
			EndIf
		End If
		
		x += speedX * deltaInSecs
		If (OverflowingLeft())
			x = -xShift
		ElseIf(OverflowingRight())
			x = Screen.WIDTH - boxWidth + xShift
		EndIf

		If (jumping And y = Ground.GROUND_HEIGHT - boxHeight + yShift)
			speedY = JUMP_SPEED
		EndIf

		y -= speedY * deltaInSecs
		
	End Method
	
	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
		If (hp < 0.0)
			animStatus = Animator.ANIM_SURVIVOR_DIE
		Else If (y <> Ground.GROUND_HEIGHT - boxHeight + yShift)
			animStatus = Animator.ANIM_SURVIVOR_JUMP
		Else If (speedX <> 0.0)
			animStatus = Animator.ANIM_SURVIVOR_RUN
		Else If (punching)
			animStatus = Animator.ANIM_MUTANT_PUNCH
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
	
Private
	Method OverflowingLeft:Bool()
		Return x - xShift < 0
	End Method
	
	Method OverflowingRight:Bool()
		Return x + boxWidth - xShift > Screen.WIDTH
	End Method

End Class