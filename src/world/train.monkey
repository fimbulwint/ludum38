Strict

Import actors.actor
Import actors.collisions
Import graphics.assets
Import graphics.screen

Class Train Extends Actor
	Const TRAIN_SPEED:Float = 1000.0 ' used to determine object speed when touching ground

	Field trainFloor:CollisionBox ' A one pixel high collision box to simulate the roof

	Method New()
		behavior = New EmptyBehavior()
		
		x = 0.0
		y = Screen.GroundHeight - 1.0
		z = 100.0
		
		image = Assets.instance.graphics.Get(Assets.GFX_TRAIN)
		trainFloor = New CollisionBox()
		trainFloor.upperLeft =[x, y]
		trainFloor.lowerRight =[x + boxWidth, y + 1]
	End Method

End Class