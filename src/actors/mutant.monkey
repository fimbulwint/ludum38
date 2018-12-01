Strict

Import actors.actor
Import actors.survivor
Import actors.behaviors.mutantbrain
Import graphics.screen
Import sound.dj

Class Mutant Extends Actor

	Const MOUNTANTS:String = "MOUNTANTS"
	Const ORANGUSAND:String = "ORANGUSAND"

	Const BASE_HP:Float = 1.0
	Const MUTANT_DAMAGE:Float = 1.0
	
	Const BASE_LATERAL_SPEED:Float = 200.0
	Const GROUND_LATERAL_SPEED:Float = 100.0
	Const INITIAL_JUMP_LATERAL_SPEED_MIN:Float = 400.0
	Const INITIAL_JUMP_LATERAL_SPEED_MAX:Float = 600.0
	Const INITIAL_JUMP_SPEED_MIN:Float = -200.0
	Const INITIAL_JUMP_SPEED_MAX:Float = -250.0
	Const JUMP_LATERAL_SPEED_MIN:Float = 300.0
	Const JUMP_LATERAL_SPEED_MAX:Float = 400.0
	Const GROUND_JUMP_SPEED_MIN:Float = -300.0
	Const GROUND_JUMP_SPEED_MAX:Float = -350.0
	Const JUMP_SPEED_MIN:Float = -100.0
	Const JUMP_SPEED_MAX:Float = -150.0
	
	Const GROUND_JUMP_SPEED_MIN_ORANGUSAND:Float = -400.0
	Const GROUND_JUMP_SPEED_MAX_ORANGUSAND:Float = -500.0

	
	Field world:World 
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_MUTANT)
	
	Field animStatus:Int = Animator.ANIM_MUTANT_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)
	
	Field type:String
	
	Field isPlunging:Bool = False
	Field plungeSpeed:Float[] = []
	
	Method New(type:String, world:World)
		Self.world = world
		Self.type = type
		attributes.hp = BASE_HP
		behavior = New MutantBrain(Self,[world.mainSurvivor])
		z = 50.0
		image = anim[0]
		boxLeft = 26
		boxRight = 33
		boxUp = 27
		boxDown = 17
		
		Local colorShift:Float
		Select(type)
			Case MOUNTANTS
				colorShift = Rnd(-0.2, 0.2)
				r = 0.5 + colorShift
				g = 0.5 + colorShift
				b = 0.5 + colorShift
			Case ORANGUSAND
				colorShift = Rnd(-0.1, 0.1)
				r = 0.8 + colorShift
				g = 0.6 + colorShift
				b = 0.1
		End Select
		
		SetRandomInitialPosition()
	End Method

	Method Update:Void(world:World)
		Super.Update(world)
		If (IsDead() And x < - GetBoxWidth())
			world.RemoveLifecycleAware(Self)
		End If
	End Method
	
	Method CalculateCollisions:Void(world:World)
		collidingActors.Clear()
		CheckCollisionsWith(world.mainSurvivor)
	End
	
	Method Move:Void(world:World)
		If (IsControllable())
			If (isPlunging)
				speedX = plungeSpeed[0]
				speedY = plungeSpeed[1]
			Else If (jumping)
				If (IsOnTrain())
					If (movingLeft) Then directionX = -1.0 Else directionX = 1.0
					speedX = Rnd(JUMP_LATERAL_SPEED_MIN, JUMP_LATERAL_SPEED_MAX) * directionX
					speedY = Rnd(JUMP_SPEED_MIN, JUMP_SPEED_MAX)
				Else If (IsOnGround())	
					speedX = -GROUND_LATERAL_SPEED
					If (type = ORANGUSAND)
						speedY = Rnd(GROUND_JUMP_SPEED_MIN_ORANGUSAND, GROUND_JUMP_SPEED_MAX_ORANGUSAND)
					Else
						speedY = Rnd(GROUND_JUMP_SPEED_MIN, GROUND_JUMP_SPEED_MAX)
					End If
				End If
			Else If (movingLeft)
				If (IsOnTrain())
					speedX = -BASE_LATERAL_SPEED
					directionX = -1.0
				Else If (IsOnGround())
					speedX = -GROUND_LATERAL_SPEED
					directionX = 1.0
				End If
			Else If (movingRight)
				If (IsOnTrain())
					speedX = BASE_LATERAL_SPEED
					directionX = 1.0
				Else If (IsOnGround())
					speedX = GROUND_LATERAL_SPEED
					directionX = 1.0
				End If
			Else If (IsOnTrain()) 
				speedX = 0.0 ' why stop? should never happen
			Else If (IsOnGround()) 
				speedX = -Train.TRAIN_SPEED ' ciao!
			End If
		Else If (Not IsAlive() And IsOnGround())
			speedX = -Train.TRAIN_SPEED
			speedY = Rnd(Ground.GROUND_REBOUND_SPEED_MIN, Ground.GROUND_REBOUND_SPEED_MAX)
		End If
		
	End Method
	
	Method ReactToResults:Void(world:World)
		If (IsAlive() And Not IsOnGround() And Not IsOnTrain())
			DamageSurvivors()
		End If
		
		If (jumping)
			Dj.instance.Play(Dj.SFX_MUTANT_JUMP)
		End If
		
		If (IsOnGround() And isPlunging)
			TakeDamage(attributes.hp + 1, 50000.0)
		End If
		
	End Method
	
	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_MUTANT_IDLE
		If (IsDead())
			animStatus = Animator.ANIM_MUTANT_DIE
		Else If (isPlunging)
			animStatus = Animator.ANIM_MUTANT_PLUNGE
		Else If (speedY <> 0.0 And Not IsOnGround() And Not IsOnTrain())
			animStatus = Animator.ANIM_MUTANT_JUMP
		Else If (speedX <> 0.0 And speedX <> -Train.TRAIN_SPEED)
			If (y = Ground.GROUND_HEIGHT)
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
	
	Method TakeDamage:Bool(damage:Int, fromX:Float)
		Local result:Bool = Super.TakeDamage(damage, fromX)
		If (IsDead())
			Dj.instance.Play(Dj.SFX_MUTANT_DIE)
		EndIf
		Return result
	End Method
	
	Method CanStandOnTopOfTrain:Bool()
		Return IsAlive() And Not isPlunging
	End Method
	
Private
	Method SetRandomInitialPosition:Void()
		Local side:Float = 1.0
		If (Rnd(1000.0) < 500.0) Then side = -1.0	' left or right
		x = (Screen.WIDTH / 2.0) + side * ((Screen.WIDTH / 2.0) + 100.0) + Rnd(0.0, 100.0) * side
		If (Rnd(1000.0) < 500.0)
			' jumping
			y = Train.TRAIN_HEIGHT - GetBoxHeight() + boxUp + Rnd(-50.0, 50.0)
			directionX = -side
			speedX = Rnd(INITIAL_JUMP_LATERAL_SPEED_MIN, INITIAL_JUMP_LATERAL_SPEED_MAX) * -side
			speedY = Rnd(INITIAL_JUMP_SPEED_MIN, INITIAL_JUMP_SPEED_MAX)
		Else
			' running on ground
			y = Ground.GROUND_HEIGHT - GetBoxHeight() + boxUp
			speedX = GROUND_LATERAL_SPEED * -side
			movingLeft = side = 1.0 ' HACK for now
			movingRight = Not movingLeft
		End If
	End Method

	Method DamageSurvivors:Void()
		For Local actor:Actor = EachIn collidingActors
			Local survivor:Survivor = Survivor(actor)
			If (survivor <> Null And survivor.IsAlive() And Not survivor.actorsPunched.Contains(Self))
				survivor.TakeDamage(MUTANT_DAMAGE, x)
			End If
		End For
	End Method
	
End Class