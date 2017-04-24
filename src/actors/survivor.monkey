Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.animator
Import graphics.assets
Import graphics.screen
Import system.time
Import world.train

Class Survivor Extends Actor

	Const BASE_HP:Float = 2.0
	Const SURVIVOR_DAMAGE:Float = 1.0
	
	Const BASE_LATERAL_SPEED:Float = 300.0
	Const JUMP_SPEED:Float = 250.0
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_SURVIVOR)
	
	Field animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)

	Method New()
		behavior = New Controllable(Self)
		hp = BASE_HP
		x = Screen.WIDTH / 2
		z = 0.0
		image = anim[0]
		Super.PostConstruct()
		
		y = GetHeightOnTopOfTrain()
	End Method
	
	Method Move:Void(worldState:WorldState)		
		If (hp > 0.0 And Not hurt)
			If (movingLeft)
				speedX = -BASE_LATERAL_SPEED
				directionX = -1.0
			ElseIf(movingRight)
				speedX = BASE_LATERAL_SPEED
				directionX = 1.0
			Else
				speedX = 0.0
			EndIf
			
			If (jumping And IsOnTrain())
				speedY = JUMP_SPEED
			EndIf
		Else If (hp > 0.0 And hurt)
			If (IsOnTrain())
				hurt = False
			Else If (IsOnGround())
				hp = 0.0
			End If
		Else
			' dead
			If (IsOnGround())
				speedX = -Train.TRAIN_SPEED
				speedY = Rnd(Ground.GROUND_REBOUND_SPEED_MIN, Ground.GROUND_REBOUND_SPEED_MAX)
			End If		
		End If
	End Method
	
	Method ReactToResults:Void()
		If (hp > 0.0 And punching)
			For Local actor:Actor = EachIn collidingActors
				actor.TakeDamage(SURVIVOR_DAMAGE, x)
			End For
		EndIf
	End Method
		
	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
		If (hp <= 0.0)
			animStatus = Animator.ANIM_SURVIVOR_DIE
		Else If (hurt)
			animStatus = Animator.ANIM_SURVIVOR_OUCH
		Else If (y <> GetHeightOnTopOfTrain())
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
	
	Method GetMainCollisionBox:CollisionBox()
		Return New CollisionBox([x - 3, y - 3],[x + boxWidth + 3, y + boxHeight + 3])
	End Method
	
End Class