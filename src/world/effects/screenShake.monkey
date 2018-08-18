Strict

Import mojo2
Import system.time
Import utils.timers
Import world.effects.timers
Import world.world

Class ScreenShake Extends WorldEffect

	Const DECAY_TIME:Float = 2500.0
	
	Field t0:Float
	Field endTime:Float
	Field initialForce:Float
		
	Field force:Float
	Field deathValue:Float = 0.01

	Method New(world:World, force:Float)
		t0 = Time.instance.actTime
		endTime = t0 + DECAY_TIME
		initialForce = force
		Timer.addTimer(New EffectRemovalTimer(DECAY_TIME, Self, world))
	End Method
	
	Method ApplyTo:Void(canvas:Canvas)
		canvas.Translate(Rnd(-force, force), Rnd(-force, force))
	End Method
	
	Method Update:Void(world:World)
		Local time:Float = Time.instance.actTime
		If (time > endTime)
			force = 0.0
		Else
			Local ti:Float = (time - t0) / DECAY_TIME
			force = GetY(ti) * initialForce
		End If
	End Method
	
Private

	Method GetY:Float(x:Float)
		' apply a function between 0.0-1.0 which graph starts at 1.0 and 
		' deccelerates fast to 0.0 at the beginning but slow at the end
		' f(x) = sqrt ( (1-x)^5 )
		Return Sqrt(Pow(1.0 - x, 5.0))
	End Method
	
End Class
