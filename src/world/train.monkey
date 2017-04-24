Strict

Import actors.actor
Import graphics.assets
Import graphics.screen
Import sound.dj
Import world.ground

Class Train Extends Actor
	Const TRAIN_SPEED:Float = 800.0 ' used to determine object speed when touching ground

	Const TRAIN_HEIGHT:Float = Ground.GROUND_HEIGHT - 120.0
	Const TRAIN_START:Float = 80.0
	Const TRAIN_END:Float = 1170.0
	
	Method New()
		gravityBound = False
		behavior = New EmptyBehavior()
		
		x = 0.0
		y = Ground.GROUND_HEIGHT - 1.0
		z = 100.0
		
		image = Assets.instance.graphics.Get(Assets.GFX_TRAIN)
		Dj.instance.Play(Dj.SFX_TRAIN, True)
	End Method

End Class