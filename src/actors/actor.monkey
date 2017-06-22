Strict

Import actors.behaviors.behavior
Import actors.gravity
Import actors.collisions
Import graphics.animator 
Import graphics.screen
Import lifecycleaware
Import mojo2
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
	Field xShift:Float = 0.0
	Field yShift:Float = 0.0
	
	' Movement
	Field movingLeft:Bool
	Field movingRight:Bool
	Field jumping:Bool
	Field wantsToPunch:Bool
	Field directionX:Float = 1.0
	Field speedX:Float
	Field speedY:Float
	Field gravityBound:Bool = True
	Field boxWidth:Float
	Field boxHeight:Float
	Field hitBoxes:List<HitBox> = New List<HitBox>()
	Field collidingActors:List<Actor> = New List<Actor>()
	
	Method PostConstruct:Void()
		xShift = image.HandleX * boxWidth
		yShift = image.HandleY * boxHeight
	End Method
	
	Method Update:Void(worldState:WorldState)
		behavior.Update()
		
		Move(worldState)
		Gravity.applyTo(Self)
		
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
		x += speedX * deltaInSecs
		
		Local wasAboveTrain:Bool = IsDirectlyAboveTrain()
		y += speedY * deltaInSecs
		If (IsAlive() And wasAboveTrain And IsDirectlyBelowTrain()) ' collide to train roof, first rushed version
			y = GetHeightOnTopOfTrain()
			speedY = 0.0
		End If
		
		hitBoxes.Clear()
		hitBoxes.AddLast(GetMainHitBox())
		CalculateCollisions(worldState)
		ReactToResults()
	End Method
	
	Method CalculateCollisions:Void(worldState:WorldState)
		collidingActors.Clear()
		CheckCollisionsWith(worldState.mainSurvivor)
		CheckCollisionsWith(worldState.dynamicActors)
	End
	
	Method Draw:Void(canvas:Canvas)
		If (image <> Null)
			canvas.PushMatrix()
			canvas.SetBlendMode(blend)
			canvas.SetAlpha(alpha)
			canvas.SetColor(r, g, b)
			canvas.DrawImage(image, x, y, angle, sizeX, sizeY)
			
			Local hitBox:HitBox = GetMainHitBox()
			#If CONFIG="debug"
			canvas.SetAlpha(0.15)
			canvas.SetColor(1.0, 0.0, 0.0)
			canvas.DrawRect(hitBox.upperLeft[0], hitBox.upperLeft[1], hitBox.lowerRight[0] - hitBox.upperLeft[0], hitBox.lowerRight[1] - hitBox.upperLeft[1])
			#End

			canvas.PopMatrix()
		End If
	End Method
	
	Method Move:Void(worldState:WorldState)
	End Method
	
	Method ReactToResults:Void()
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
	
	Method GetHeightOnTopOfGround:Float()
		Return Ground.GROUND_HEIGHT - boxHeight + yShift
	End Method
	
	Method GetHeightOnTopOfTrain:Float()
		Return Train.TRAIN_HEIGHT - boxHeight + yShift
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
			directionX = -(speedX / speedX)
			Return True
		End If
		Return False
	End Method

	Method GetMainHitBox:HitBox()
		Return New HitBox([x - xShift, y - yShift],[x - xShift + boxWidth, y - yShift + boxHeight])
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
		Return IsAlive() And (attributes.state = State.DEFAULT_STATE Or attributes.state = State.RECOVERING)
	End Method


End Class

Class Attributes

	Field hp:Float = 1.0
	Field state:Int = State.DEFAULT_STATE

End Class

Class State
	Const DEFAULT_STATE:Int = 0
	Const HURT:Int = 1
	Const RECOVERING:Int = 2
End Class
