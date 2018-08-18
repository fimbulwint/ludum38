Strict

Import sprites.sprite
Import graphics.assets
Import graphics.screen
Import sound.dj
Import world.effects.screenShake
Import world.ground
Import world.railroad
Import world.train
Import system.time
Import sprites.railroadSmallRock
Import actors.actorEffects
Import world

Class RailroadRock Extends Sprite

	Const SHAKE_FORCE:Float = 10.0

	Method New()
		x = Screen.WIDTH
		y = Ground.GROUND_HEIGHT
		z = Railroad.DEPTH

		image = Assets.instance.graphics.Get(Assets.GFX_RAILROAD_ROCK)
	End Method
	
	Method Move:Void(world:World)
		x -= Train.TRAIN_SPEED * Time.instance.getDeltaInSecs()
	End Method
	
	Method CorrectMovement:Void(world:World)
		y = Ground.GROUND_HEIGHT
		If (x <= Train.TRAIN_END)
			Crash(world)
		End
	End Method
	
Private

	Method Crash:Void(world:World)
		Dj.instance.Play(Dj.SFX_RAILROAD_ROCK)
		SpawnDebris(world)
		PushActorsForward(world)
		world.AddWorldEffect(New ScreenShake(world, SHAKE_FORCE))
		world.RemoveLifecycleAware(Self)
	End Method
	
	Method SpawnDebris:Void(world:World)
		Local rockCenter:Float[] = [x + (image.Width() / 2), y - (image.Height() / 2)]
	
		Local smallRock1:RailroadSmallRock = New RailroadSmallRock(rockCenter[0], rockCenter[1] + 10, -Train.TRAIN_SPEED * 0.7)
		Local smallRock2:RailroadSmallRock = New RailroadSmallRock(rockCenter[0], rockCenter[1] + 10, -Train.TRAIN_SPEED * 0.5)
		Local smallRock3:RailroadSmallRock = New RailroadSmallRock(rockCenter[0], rockCenter[1] - 10, -Train.TRAIN_SPEED * 0.7)
		Local smallRock4:RailroadSmallRock = New RailroadSmallRock(rockCenter[0], rockCenter[1] - 10, -Train.TRAIN_SPEED * 0.5)
		world.AddLifecycleAware(smallRock1)
		world.AddLifecycleAware(smallRock2)
		world.AddLifecycleAware(smallRock3)
		world.AddLifecycleAware(smallRock4)
	End Method
	
	Method PushActorsForward:Void(world:World)
		For Local actor:Actor = EachIn world.GetAllActors()
			ActorEffects.PushActorForward(actor, Train.TRAIN_SPEED * 0.3)
		Next
	End Method
End