Strict

Import actors.behaviors.behavior
Import actors.collisions
Import graphics.animator
Import graphics.screen
Import lifecycleaware
Import mojo2
Import world.gravity
Import world.world
Import system.time

Class Actor Extends LifecycleAware

	Const HURT_LATERAL_SPEED:Float = 150.0
	Const HURT_JUMP_SPEED:Float = -100.0
	
	Field behavior:Behavior
	Field animator:Animator = New Animator()

	' Attributes
	Field attributes:Attributes = New Attributes()
	
	' Drawing parameters
	Field blend:Int = BlendMode.Alpha
	Field alpha:Float = 1.0
	Field x:Float, y:Float
	Field r:Float = 1.0
	Field g:Float = 1.0
	Field b:Float = 1.0
	Field angle:Float
	Field sizeX:Float = 1.0
	Field sizeY:Float = 1.0
	Field image:Image = Null
	
	' Controls
	Field movingLeft:Bool
	Field movingRight:Bool
	Field jumping:Bool
	Field crouching:Bool
	Field wantsToPunch:Bool
	Field punching:Bool
	Field wantsToKick:Bool
	Field kicking:Bool
	
	' Movement	
	Field directionX:Float = 1.0
	Field speedX:Float
	Field speedY:Float
	Field gravityBound:Bool = True
	Field boxLeft:Float
	Field boxRight:Float
	Field boxUp:Float
	Field boxDown:Float
	Field hitBoxes:List<HitBox> = New List<HitBox>()
	Field collidingActors:List<Actor> = New List<Actor>()
	
	Method Update:Void(world:World)
		behavior.Update()
		
		Move(world)
		Gravity.applyTo(Self)
		
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
		x += speedX * deltaInSecs
		
		Local wasAboveTrain:Bool = IsDirectlyAboveTrain()
		y += speedY * deltaInSecs
		If (CanStandOnTopOfTrain() And wasAboveTrain And IsDirectlyBelowTrain()) ' collide to train roof, first rushed version
			y = GetHeightOnTopOfTrain()
			speedY = 0.0
		End If
		
		hitBoxes.Clear()
		hitBoxes.AddLast(GetMainHitBox())
		CalculateCollisions(world)
		ReactToResults(world)
	End Method
	
	Method CalculateCollisions:Void(world:World)
		collidingActors.Clear()
		CheckCollisionsWith(world.mainSurvivor)
		CheckCollisionsWith(world.dynamicActors)
	End
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		If (image <> Null)
			canvas.SetBlendMode(blend)
			canvas.SetAlpha(alpha)
			canvas.SetColor(r, g, b)
			canvas.DrawImage(image, x, y, angle, sizeX, sizeY)
		End If
		Local hitBox:HitBox = GetMainHitBox()
		If (hitBox <> Null)
			#If CONFIG="debug"
			canvas.SetAlpha(0.15)
			canvas.SetColor(1.0, 0.0, 0.0)
			canvas.DrawRect(hitBox.upperLeft[0], hitBox.upperLeft[1], hitBox.lowerRight[0] - hitBox.upperLeft[0], hitBox.lowerRight[1] - hitBox.upperLeft[1])
			#End
		End If
		canvas.PopMatrix()
	End Method
	
	Method Move:Void(world:World)
	End Method
	
	Method ReactToResults:Void(world:World)
	End Method
	
	Method GetBoxWidth:Float()
		Return boxLeft + 1 + boxRight
	End Method

	Method GetBoxHeight:Float()
		Return boxUp + 1 + boxDown
	End Method
	
	Method GetBoxCenter:Float[] ()
		Return[ (2 * x - boxLeft + boxRight) / 2, (2 * y - boxUp + boxDown) / 2]
	End Method

	Method IsOnGround:Bool()
		Return y = GetHeightOnTopOfGround()
	End Method
	
	Method IsAboveGround:Bool()
		Return y < GetHeightOnTopOfGround()
	End Method

	Method IsOnTrain:Bool()
		Return y = GetHeightOnTopOfTrain() And x > Train.TRAIN_START And x <= Train.TRAIN_END
	End Method
	
	Method IsDirectlyAboveTrain:Bool()
		Return y < GetHeightOnTopOfTrain() And x > Train.TRAIN_START And x <= Train.TRAIN_END
	End Method

	Method IsDirectlyBelowTrain:Bool()
		Return y > GetHeightOnTopOfTrain() And x > Train.TRAIN_START And x <= Train.TRAIN_END
	End Method
	
	Method CanStandOnTopOfTrain:Bool()
		Return IsAlive()
	End Method
	
	Method GetHeightOnTopOfGround:Float()
		Return Ground.GROUND_HEIGHT - GetBoxHeight() + boxUp
	End Method
	
	Method GetHeightOnTopOfTrain:Float()
		Return Train.TRAIN_HEIGHT - GetBoxHeight() + boxUp
	End Method
	
	Method TakeDamage:Bool(damage:Int, fromX:Float)
		If (Not IsInvulnerable())
			attributes.hp -= damage
			If (IsDead()) Then attributes.hp = 0.0
			y -= 0.001 'HACK :D
			attributes.state = State.HURT
			speedX = HURT_LATERAL_SPEED
			speedY = HURT_JUMP_SPEED
			If (fromX - x > 0.0) ' from the right
				speedX = -speedX
			End If
			Return True
		End If
		Return False
	End Method

	Method GetMainHitBox:HitBox()
		Local boxWidth:Float = GetBoxWidth()
		Local boxHeight:Float = GetBoxHeight()
		If (crouching And IsOnTrain())
			Return New HitBox([x - boxLeft, y - boxUp + (boxHeight / 2)],[x - boxLeft + boxWidth, y - boxUp + boxHeight])
		Else
			Return New HitBox([x - boxLeft, y - boxUp],[x - boxLeft + boxWidth, y - boxUp + boxHeight])
		EndIf
	End Method
	
	Method CheckCollisionsWith:Void(actors:List<Actor>)
		For Local other:Actor = EachIn actors
			If (other <> Self)
				CheckCollisionsWith(other)
			EndIf
		Next
	End
	
	Method CheckCollisionsWith:Void(actor:Actor)
		For Local hitBox:HitBox = EachIn Self.hitBoxes
			For Local otherHitBox:HitBox = EachIn actor.hitBoxes
				If (Collisions.ThereIsCollision(hitBox, otherHitBox))
					collidingActors.AddLast(actor)
				EndIf
			Next
		Next
	End
	
	Method IsAlive:Bool()
		Return attributes.hp > 0.0
	End Method
	
	Method IsDead:Bool()
		Return Not IsAlive()
	End Method
	
	Method IsInvulnerable:Bool()
		Return IsDead() Or attributes.state = State.HURT Or attributes.state = State.RECOVERING
	End Method
	
	Method IsBlinking:Bool()
		Return IsAlive() And (attributes.state = State.HURT Or attributes.state = State.RECOVERING)
	End Method
	
	Method IsControllable:Bool()
		Return IsAlive() And Not attributes.beingPushed And (attributes.state = State.DEFAULT_STATE Or attributes.state = State.RECOVERING)
	End Method


End Class

Class Attributes

	Field hp:Float = 1.0
	Field state:Int = State.DEFAULT_STATE
	Field beingPushed:Bool = False

End Class

Class State
	Const DEFAULT_STATE:Int = 0
	Const HURT:Int = DEFAULT_STATE + 1
	Const RECOVERING:Int = HURT + 1
End Class
