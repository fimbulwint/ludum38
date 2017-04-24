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

	Field behavior:Behavior
	Field animator:Animator = New Animator()

	' Attributes
	Field hp:Float = 1.0
	Field hurt:Bool = False ' used to notify hp has been externally modified
	
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
	Field punching:Bool
	Field directionX:Float = 1.0
	Field speedX:Float
	Field speedY:Float
	Field gravityBound:Bool = True
	Field boxWidth:Float
	Field boxHeight:Float
	Field collisionBoxes:List<CollisionBox> = New List<CollisionBox>()
	Field collidingActors:List<Actor> = New List<Actor>()
	
	Method PostConstruct:Void()
		boxWidth = image.Width()
		boxHeight = image.Height()
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
		y -= speedY * deltaInSecs
		If (wasAboveTrain And IsDirectlyBelowTrain()) ' collide to train roof, first rushed version
			y = GetHeightOnTopOfTrain()
			speedY = 0.0
		End If
		
		collidingActors.Clear()
		collisionBoxes.Clear()
		collisionBoxes.AddLast(GetMainCollisionBox())
		CheckCollisionsWith(worldState.mainActors)
		CheckCollisionsWith(worldState.dynamicActors)
		
		ReactToResults()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		If (image <> Null)
			canvas.PushMatrix()
			canvas.SetBlendMode(blend)
			canvas.SetAlpha(alpha)
			canvas.SetColor(r, g, b)
			canvas.DrawImage(image, x, y, angle, sizeX, sizeY)
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
	
Private

	Method GetMainCollisionBox:CollisionBox()
		Return New CollisionBox([x, y],[x + boxWidth, y + boxHeight])
	End Method
	
	Method CheckCollisionsWith:Void(actors:List<Actor>)
		For Local other:Actor = EachIn actors
			If (other <> Self)
				For Local colBox:CollisionBox = EachIn Self.collisionBoxes
					For Local otherColBox:CollisionBox = EachIn other.collisionBoxes
						If (Collisions.ThereIsCollision(colBox, otherColBox))
							collidingActors.AddLast(other)
						EndIf
					Next
				Next
			EndIf
		Next
	End Method

End Class
