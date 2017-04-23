Strict

Import actors.behaviors.behavior
Import actors.gravity
Import graphics.animator 
Import graphics.screen
Import lifecycleaware
Import mojo2
Import world.world

Class Actor Extends LifecycleAware

	Field behavior:Behavior
	Field animator:Animator = New Animator()

	' Attributes
	Field hp:Float = 1.0
	
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
	
	Method New()
	End Method
	
	Method PostConstruct:Void()
		boxWidth = image.Width()
		boxHeight = image.Height()
		xShift = image.HandleX * boxWidth
		yShift = image.HandleY * boxHeight
	End Method
	
	Method Update:Void(worldState:WorldState)
		behavior.Update()
		TryToMove(worldState)
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
	End Method
	
	Method IsOnGround:Bool()
		Return y = Screen.GroundHeight - boxHeight + yShift
	End Method

	Method IsOnTrain:Bool()
		Return y = Screen.TrainHeight - boxHeight + yShift And x > Screen.TrainStart And x <= Screen.TrainEnd
	End Method
	
	Method IsDirectlyAboveTrain:Bool()
		Return y < (Screen.TrainHeight - boxHeight + yShift) And x > Screen.TrainStart And x <= Screen.TrainEnd
	End Method

	Method IsDirectlyBelowTrain:Bool()
		Return y > (Screen.TrainHeight - boxHeight + yShift) And x > Screen.TrainStart And x <= Screen.TrainEnd
	End Method

End Class
