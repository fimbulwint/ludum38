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

Class Survivor Extends Actor

	Const BASE_HP:Float = 10.0
	Const SURVIVOR_DAMAGE:Float = 1.0
	
	Const BASE_LATERAL_SPEED:Float = 300.0
	Const JUMP_SPEED:Float = -300.0
	
	Const DEATH_TIME_DISTORTION:Float = 0.5
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_SURVIVOR)
	
	Field animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)
	
	Field punchTime:Float
	Field punchCooldown:Float
	Field holdingPunch:Bool

	Method New()
		behavior = New Controllable(Self)
		attributes.hp = BASE_HP
		x = Screen.WIDTH / 2
		z = 0.0
		image = anim[0]
		punchTime = 200.0
		punchCooldown = 0.0
		holdingPunch = False
		
		Super.PostConstruct()
		
		y = GetHeightOnTopOfTrain()
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
			If (punching And punchCooldown <= 0.0)
				If ( Not holdingPunch) Then Dj.instance.Play(Dj.SFX_SURVIVOR_PUNCH)
				holdingPunch = True
			EndIf
		
			If (holdingPunch)
				If (punchTime > 0.0)
					For Local actor:Actor = EachIn collidingActors
						Local enemyOnTheRight:Bool = (x - xShift) < actor.x - actor.xShift
						Local enemyOnTheLeft:Bool = (x - xShift) > actor.x - actor.xShift
						If ( (directionX > 0.0 And enemyOnTheRight) Or (directionX < 0.0 And enemyOnTheLeft))
							actor.TakeDamage(SURVIVOR_DAMAGE, x)
						EndIf
					End For
				EndIf
			
				punchTime -= Time.instance.lastFrame
				If (punchTime <= 0)
					punchCooldown = 200.0
					holdingPunch = False
				EndIf
			Else
				punchCooldown -= Time.instance.lastFrame
				If (punchCooldown <= 0.0)
					punchTime = 200.0
				EndIf
			EndIf
		EndIf
	End Method
		
	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
		If (IsDead())
			animStatus = Animator.ANIM_SURVIVOR_DIE
		Else If (attributes.state = State.HURT)
			animStatus = Animator.ANIM_SURVIVOR_OUCH
		Else If (holdingPunch And punchTime > 0.0)
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
