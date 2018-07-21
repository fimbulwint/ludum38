Strict

Import actors.actor
Import graphics.assets
Import graphics.screen
Import sound.dj
Import world.ground
Import world.railroad

Class Train Extends Actor
	Const TRAIN_SPEED:Float = 800.0 ' used to determine object speed when touching ground

	Const TRAIN_HEIGHT:Float = Ground.GROUND_HEIGHT - 125.0
	Const TRAIN_START:Float = 100.0
	Const TRAIN_END:Float = 1060.0
	
	Method New()
		gravityBound = False
		behavior = New EmptyBehavior()
		
		x = 0.0
		y = Ground.GROUND_HEIGHT - 1.0
		z = Railroad.DEPTH
		
		image = Assets.instance.graphics.Get(Assets.GFX_TRAIN)
		Dj.instance.Play(Dj.SFX_TRAIN, True)
	End Method

End Class