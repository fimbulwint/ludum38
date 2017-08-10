Strict

Import mojo2
Import actors.behaviors.controllable
Import actors.actor
Import graphics.animator
Import graphics.assets
Import graphics.screen
Import sprites.helmet
Import system.time
Import world.train
Import actors.timers
Import utils.timer
Import actors.collisions

Class Survivor Extends Actor

	Const BASE_HP:Float = 10.0
	Const PUNCH_DAMAGE:Float = 1.0
	Const KICK_DAMAGE:Float = 1.0
	
	Const BASE_LATERAL_SPEED:Float = 300.0
	Const JUMP_SPEED:Float = -300.0
	
	Const DEATH_TIME_DISTORTION:Float = 0.5
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_SURVIVOR)
	
	Field animStatus:Int = Animator.ANIM_SURVIVOR_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)
	
	Field world:World
	
	Field punchBox:HitBox
	Field kickBox:HitBox
	Field attackCoolingDown:Bool
	Field actorsPunched:List<Actor> = New List<Actor>()
	Field actorsKicked:List<Actor> = New List<Actor>()


	Method New(world:World)
		Self.world = world
		behavior = New Controllable(Self)
		attributes.hp = BASE_HP
		x = Screen.WIDTH / 2
		z = 0.0
		image = anim[0]
		punching = False
		kicking = False
		punchBox = Collisions.EMPTY_HIT_BOX
		kickBox = Collisions.EMPTY_HIT_BOX
		attackCoolingDown = False
		boxWidth = 52
		boxHeight = 64
		
		Super.PostConstruct()
		
		y = GetHeightOnTopOfTrain()
	End Method
	
	Method CalculateCollisions:Void(world:World)
		Super.CalculateCollisions(world)

		If (punching)
			punchBox = GetPunchBox()
		Else
			punchBox = Collisions.EMPTY_HIT_BOX
		End
		
		If (kicking)
			kickBox = GetKickBox()
		Else
			kickBox = Collisions.EMPTY_HIT_BOX
		End
		
		CheckImpacts(world.dynamicActors)
	End
	
	Method GetPunchBox:HitBox()
		If (crouching)
			Return GetPunchBox(5, 20, 0, 20)
		Else
			Return GetPunchBox(5, 20, 20, 20)
		End
	End
	
	Method GetPunchBox:HitBox(xShift:Float, xWidth:Float, yShift:Float, yWidth:Float)
		Local mainHitBox:HitBox = GetMainHitBox()
		Local boxX1:Float
		Local boxX2:Float
		
		If (directionX < 0.0)
			boxX1 = mainHitBox.upperLeft[0] - xWidth + xShift
			boxX2 = mainHitBox.upperLeft[0] + xShift
		Else
			boxX1 = mainHitBox.lowerRight[0] - xShift
			boxX2 = mainHitBox.lowerRight[0] + xWidth - xShift
		End
		Return New HitBox([boxX1, mainHitBox.upperLeft[1] + yShift],[boxX2, mainHitBox.upperLeft[1] + yShift + yWidth])
	End
	
	Method GetKickBox:HitBox()
		Local mainHitBox:HitBox = GetMainHitBox()
		Local mainMiddlePoint:Float = (mainHitBox.upperLeft[0] + mainHitBox.lowerRight[0]) / 2
		
		Return New HitBox([mainMiddlePoint - 10, mainHitBox.lowerRight[1]],[mainMiddlePoint + 10, mainHitBox.lowerRight[1] + 30])
	End
	
	Method CheckImpacts:Void(actors:List<Actor>)
		actorsPunched.Clear()
		actorsKicked.Clear()
		For Local other:Actor = EachIn actors
			If (other <> Self And Not other.IsDead())
				CheckImpacts(other)
			EndIf
		Next
	End
	
	Method CheckImpacts:Void(actor:Actor)
		If (CheckImpacts(actor, punchBox))
			actorsPunched.AddLast(actor)
		End
		
		If (CheckImpacts(actor, kickBox))
			actorsKicked.AddLast(actor)
		End
	End
	
	Method CheckImpacts:Bool(actor:Actor, attackHitBox:HitBox)
		For Local otherHitBox:HitBox = EachIn actor.hitBoxes
			If (Collisions.ThereIsCollision(attackHitBox, otherHitBox))
				Return True
			EndIf
		Next
		Return False
	End
	
	Method Move:Void(world:World)		
		If (IsOnGround())
			If (IsAlive()) 
				TakeDamage(BASE_HP + 1, 50000.0)
			EndIf
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
			If (Not attackCoolingDown)
				If (wantsToPunch)
					If (Not punching) Then Dj.instance.Play(Dj.SFX_SURVIVOR_PUNCH)
					punching = True
					Timer.addTimer(New DefaultPunchTimeout(Self))
				ElseIf(wantsToKick And IsOnTrain() And crouching)
					If (Not kicking) Then Dj.instance.Play(Dj.SFX_SURVIVOR_KICK)
					kicking = True
					Timer.addTimer(New DefaultKickTimeout(Self))
				EndIf
			EndIf
		
			For Local actor:Actor = EachIn actorsPunched
				actor.TakeDamage(PUNCH_DAMAGE, x)
			End For
			For Local actor:Actor = EachIn actorsKicked
				actor.TakeDamage(KICK_DAMAGE, x)
			End For
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
			canvas.DrawRect(kickBox.upperLeft[0], kickBox.upperLeft[1], kickBox.lowerRight[0] - kickBox.upperLeft[0], kickBox.lowerRight[1] - kickBox.upperLeft[1])
		#End
		
	End Method
	
	Method TakeDamage:Bool(damage:Int, fromX:Float)
		Local wasDead:Bool = IsDead()
		Local result:Bool = Super.TakeDamage(damage, fromX)
		If (IsDead() And Not wasDead)
			Dj.instance.Play(Dj.SFX_SURVIVOR_DIE)
			Time.instance.timeDistortion = DEATH_TIME_DISTORTION
			world.AddLifecycleAware(New Helmet(x, y - 48.0, speedX))
		ElseIf(result)
			Dj.instance.Play(Dj.SFX_SURVIVOR_OUCH)
		EndIf
		Return result
	End Method
	
Private 

	Method New()
	End Method

End Class
