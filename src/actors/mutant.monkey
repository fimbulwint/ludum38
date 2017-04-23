Strict

Import actors.actor
Import actors.survivor
Import actors.behaviors.mutantbrain
Import graphics.screen 

Class Mutant Extends Actor

	Const TYPE_ROCKY:String ="ROCKY_MUTANT"

	Const BASE_HP:Float = 1.0
	Const BASE_LATERAL_SPEED:Float = 300.0
	Const GROUND_LATERAL_SPEED:Float = 100.0
	Const JUMP_LATERAL_SPEED_MIN:Float = 400.0
	Const JUMP_LATERAL_SPEED_MAX:Float = 400.0
	Const JUMP_SPEED_MIN:Float = 200.0
	Const JUMP_SPEED_MAX:Float = 300.0
	
	Field world:World 
	
	Field anim:Image[] = Assets.instance.anims.Get(Assets.GFX_ANIM_MUTANT)
	
	Field animStatus:Int = Animator.ANIM_MUTANT_IDLE
	Field lastAnimResult:AnimResult = New AnimResult(-1, False)
	
	Field mutantType:String

	Method New(type:String, world:World)
		Self.world = world
		hp = BASE_HP
		behavior = New MutantBrain(type, Self, world.survivors)
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

	Method Update:Void(worldState:WorldState)
		Super.Update(worldState)
		If (hp < 0.0 And y > Screen.HEIGHT + boxHeight)
			world.RemoveLifecycleAware(Self)
		End If
	End Method
	
	Method TryToMove:Void(worldState:WorldState)
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
	
		'if all goes well (no collisions and stuff), move
		
		If (hp > 0.0)
			If (movingLeft)
				If (IsOnTrain())
				Else If (IsOnGround())
				End If
			Else If (movingRight)
				If (IsOnTrain())
				Else If (IsOnGround())
				End If
			Else If (IsOnGround()) ' and not wanting to do anything particular
				speedX = -Train.TRAIN_SPEED ' ciao!
			End If
		End If
		
		x += speedX * deltaInSecs
		
		Local wasAboveTrain:Bool = IsDirectlyAboveTrain()
		y -= speedY * deltaInSecs
		If (wasAboveTrain And IsDirectlyBelowTrain()) ' collide to train roof, first rushed version
			y = Train.TRAIN_HEIGHT - boxHeight + yShift
			speedY = 0.0
		End If
	End Method

	Method Draw:Void(canvas:Canvas)
		Local animStatus:Int = Animator.ANIM_MUTANT_IDLE
		If (hp < 0.0)
			animStatus = Animator.ANIM_MUTANT_DIE
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
	
	
Private
	Method SetRandomInitialPosition:Void()
		Local side:Float = 1.0
		If (Rnd(1000.0) < 500.0) Then side = -1.0	' left or right
		x = (Screen.WIDTH / 2.0) + side * ((Screen.WIDTH / 2.0) + 100.0)
		If (Rnd(1000.0) < 500.0)
			' jumping
			y = Train.TRAIN_HEIGHT - boxHeight + yShift + Rnd(-50.0, 50.0)
			directionX = -side
			speedX = Rnd(JUMP_LATERAL_SPEED_MIN, JUMP_LATERAL_SPEED_MAX) * -side
			speedY = Rnd(JUMP_SPEED_MIN, JUMP_SPEED_MAX)
		Else
			' running on ground
			y = Ground.GROUND_HEIGHT - boxHeight + yShift
			speedX = GROUND_LATERAL_SPEED * -side
			movingLeft = side = 1.0 ' HACK for now
			movingRight = Not movingLeft
		End If
	End Method

End Class