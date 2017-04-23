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

Field bla:String

	Field behavior:Behavior
	Field animator:Animator = New Animator()
	
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
	Field directionX:Float = 1.0
	Field speedX:Float
	Field speedY:Float
	Field boxWidth:Float
	Field boxHeight:Float
	Field collisionBoxes:List<CollisionBox> = New List<CollisionBox>()
	Field collidingActors:List<Actor> = New List<Actor>()
	
	Method PostConstruct:Void()
		boxWidth = image.Width()
		boxHeight = image.Height()
		xShift = image.HandleX * boxWidth
		yShift = image.HandleY * boxHeight
		collisionBoxes.AddLast(New CollisionBox([x, y],[x + boxWidth, y + boxHeight]))
	End Method
	
	Method Update:Void(worldState:WorldState)
		behavior.Update()
		TryToMove(worldState)
		collidingActors.Clear()
		Gravity.applyTo(Self)
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
	
	Method TryToMove:Void(worldState:WorldState)
		For Local other:Actor = EachIn worldState.actors
			If (other <> Self)
				For Local colBox:CollisionBox = EachIn Self.collisionBoxes
					For Local otherColBox:CollisionBox = EachIn other.collisionBoxes
						If (Collisions.ThereIsCollision(colBox, otherColBox))
'							collidingActors.AddLast(other)
'							
'							Print(other.bla)
'							Print(Time.instance.realActTime)
						EndIf
					Next
				Next
			EndIf
		Next
	End Method

End Class
