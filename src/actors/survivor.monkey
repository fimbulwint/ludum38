Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.animator
Import graphics.assets
Import graphics.screen
Import system.time
Import world.train
Import actors.timers
Import utils.timer
Import actors.collisions

Class Survivor Extends Actor

	Const BASE_HP:Float = 10.0
	Const SURVIVOR_DAMAGE:Float = 1.0
	
	Const BASE_LATERAL_SPEED:Float = 300.0
	Const JUMP_SPEED:Float = -300.0
	
	Const DEATH_TIME_DISTORTION:Float = 0.5
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_SURVIVOR)
	
	Field animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)
	
	Field punching:Bool
	Field punchCoolingDown:Bool
	Field punchBox:HitBox
	Field actorsPunched:List<Actor> = New List<Actor>()

	Method New()
		behavior = New Controllable(Self)
		attributes.hp = BASE_HP
		x = Screen.WIDTH / 2
		z = 0.0
		image = anim[0]
		punching = False
		punchCoolingDown = False
		punchBox = Collisions.EMPTY_HIT_BOX
		boxWidth = 52
		boxHeight = 64
		
		Super.PostConstruct()
		
		y = GetHeightOnTopOfTrain()
	End Method
	
	Method CalculateCollisions:Void(worldState:WorldState)
		Super.CalculateCollisions(worldState)

		If (punching)
			punchBox = GetPunchBox()
			CheckPunchImpacts(worldState.mainActors)
			CheckPunchImpacts(worldState.dynamicActors)
		Else
			punchBox = Collisions.EMPTY_HIT_BOX
		End
	End
	
	Method GetPunchBox:HitBox()
		Local mainHitBox:HitBox = GetMainHitBox()
		Local boxX1:Float
		Local boxX2:Float
		
		If (directionX < 0.0)
			boxX1 = mainHitBox.upperLeft[0] - 15
			boxX2 = mainHitBox.upperLeft[0] + 5
		Else
			boxX1 = mainHitBox.lowerRight[0] - 5
			boxX2 = mainHitBox.lowerRight[0] + 15
		End
		Return New HitBox([boxX1, mainHitBox.upperLeft[1] + 20],[boxX2, mainHitBox.upperLeft[1] + 40])
	End
	
	Method CheckPunchImpacts:Void(actors:List<Actor>)
		For Local other:Actor = EachIn actors
			If (other <> Self)
				For Local otherHitBox:HitBox = EachIn other.hitBoxes
					If (Collisions.ThereIsCollision(punchBox, otherHitBox))
						actorsPunched.AddLast(other)
						Exit
					EndIf
				Next
			EndIf
		Next
	End Method
	
	Method Move:Void(worldState:WorldState)		
		If (IsOnGround())
			If (IsAlive()) 
				Dj.instance.Play(Dj.SFX_SURVIVOR_DIE)
				Time.instance.timeDistortion = DEATH_TIME_DISTORTION
			EndIf
			attributes.hp = 0.0 ' above all
		EndIf

		If (IsAlive())
			If (IsControllable())
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
					Dj.instance.Play(Dj.SFX_SURVIVOR_JUMP)
				EndIf
			Else
				If (IsOnTrain())
					attributes.state = State.RECOVERING
					Timer.addTimer(New DefaultRecoveringTimeout(Self))
				Else If (IsOnGround())
					attributes.hp = 0.0
				End If
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
		If (IsControllable())
			If (wantsToPunch And Not punchCoolingDown)
				If (Not punching) Then Dj.instance.Play(Dj.SFX_SURVIVOR_PUNCH)
				punching = True
				Timer.addTimer(New DefaultPunchTimeout(Self))
			EndIf
		
			If (punching)
				For Local actor:Actor = EachIn actorsPunched
					actor.TakeDamage(SURVIVOR_DAMAGE, x)
				End For
			EndIf
		EndIf
	End Method
		
	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
		If (IsDead())
			animStatus = Animator.ANIM_SURVIVOR_DIE
		Else If (attributes.state = State.HURT)
			animStatus = Animator.ANIM_SURVIVOR_OUCH
		Else If (punching)
			animStatus = Animator.ANIM_SURVIVOR_PUNCH
		Else If (y <> GetHeightOnTopOfTrain())
			animStatus = Animator.ANIM_SURVIVOR_JUMP
		Else If (speedX <> 0.0)
			animStatus = Animator.ANIM_SURVIVOR_RUN
		End If
		Local animResult:AnimResult = animator.Animate(animStatus, IsBlinking())
		If (animResult.graph = -1)
			image = Null
		Else 
			image = anim[animResult.graph]
		End If
		sizeX = directionX
		Super.Draw(canvas)
		
		#If CONFIG="debug"
			canvas.SetAlpha(0.15)
			canvas.SetColor(1.0, 0.0, 0.0)
			canvas.DrawRect(punchBox.upperLeft[0], punchBox.upperLeft[1], punchBox.lowerRight[0] - punchBox.upperLeft[0], punchBox.lowerRight[1] - punchBox.upperLeft[1])
		#End
		
	End Method
	
	Method TakeDamage:Bool(damage:Int, fromX:Float)
		Local result:Bool = Super.TakeDamage(damage, fromX)
		If (IsDead())
			Dj.instance.Play(Dj.SFX_SURVIVOR_DIE)
			Time.instance.timeDistortion = DEATH_TIME_DISTORTION
		ElseIf(result)
			Dj.instance.Play(Dj.SFX_SURVIVOR_OUCH)
		EndIf
		Return result
	End Method
	
End Class
