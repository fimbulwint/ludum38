Strict

Import actors.actor
Import graphics.screen
Import lifecycleaware
Import mojo2
Import world.world

Class Ground Extends LifecycleAware
	Const GROUND_HEIGHT:Float = Screen.HEIGHT - 165.0
	Const GROUND_REBOUND_SPEED_MIN:Float = 50.0
	Const GROUND_REBOUND_SPEED_MAX:Float = 100.0

	Method New()
		z = 300.0
	End Method
	
	Method Update:Void(worldState:WorldState)
		'empty for now
	End Method

	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(0.0, 0.6, 0.0)
		canvas.DrawRect(0.0, Ground.GROUND_HEIGHT, Screen.WIDTH, Screen.HEIGHT - Ground.GROUND_HEIGHT)
		canvas.PopMatrix()
	End Method

End Class
