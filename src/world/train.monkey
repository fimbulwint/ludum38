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
	
	Private 
	Const BIG_LOCOWHEEL_X:Float = 821.0
	Const BIG_LOCOWHEEL_Y:Float = 169.0 - 200.0
	Const SMALL_LOCOWHEEL1_X:Float = 875.0
	Const SMALL_LOCOWHEEL1_Y:Float = 181.0 - 200.0
	Const SMALL_LOCOWHEEL2_X:Float = 914.0
	Const SMALL_LOCOWHEEL2_Y:Float = 181.0 - 200.0
	Const SMALL_LOCOWHEEL3_X:Float = 953.0
	Const SMALL_LOCOWHEEL3_Y:Float = 181.0 - 200.0
	Const WHEEL_ASPEED:Float = 360.0 * 3.0
	
	Field wheels:List<Wheel> = New List<Wheel>()
	
	Public
	
	Method New()
		gravityBound = False
		behavior = New EmptyBehavior()
		
		x = 0.0
		y = Ground.GROUND_HEIGHT - 1.0
		z = Railroad.DEPTH
		
		wheels.AddLast(New Wheel(BIG_LOCOWHEEL_X, y + BIG_LOCOWHEEL_Y, Assets.instance.graphics.Get(Assets.GFX_LOCOWHEEL_BIG)))
		wheels.AddLast(New Wheel(SMALL_LOCOWHEEL1_X, y + SMALL_LOCOWHEEL1_Y, Assets.instance.graphics.Get(Assets.GFX_LOCOWHEEL_SMALL)))
		wheels.AddLast(New Wheel(SMALL_LOCOWHEEL2_X, y + SMALL_LOCOWHEEL2_Y, Assets.instance.graphics.Get(Assets.GFX_LOCOWHEEL_SMALL)))
		wheels.AddLast(New Wheel(SMALL_LOCOWHEEL3_X, y + SMALL_LOCOWHEEL3_Y, Assets.instance.graphics.Get(Assets.GFX_LOCOWHEEL_SMALL)))
		
		image = Assets.instance.graphics.Get(Assets.GFX_TRAIN)
		Dj.instance.Play(Dj.SFX_TRAIN, True)
	End Method

	Method Update:Void(world:World)
		Super.Update(world)
		For Local actor:Actor = EachIn wheels
			actor.Update(world)
		End For
	End Method

	Method Draw:Void(canvas:Canvas)
		Super.Draw(canvas)
		For Local actor:Actor = EachIn wheels
			actor.Draw(canvas)
		End For
	End Method 
	
End Class

Private

Class Wheel Extends Actor
	
	Method New(x:Float, y:Float, image:Image)
		Self.x = x
		Self.y = y
		Self.image = image
		z = Railroad.DEPTH - 5
		angle = Rnd(0.0, 360.0)
		gravityBound = False
		behavior = New EmptyBehavior()
	End Method
	
	Method Update:Void(world:World)
		Local deltaInSecs:Float = Time.instance.getDeltaInSecs()
		angle -= deltaInSecs * Train.WHEEL_ASPEED
		Super.Update(world)
	End Method
End Class