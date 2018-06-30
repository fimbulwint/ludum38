Strict

Import actors.actor
Import graphics.assets
Import graphics.screen
Import sound.dj
Import world.ground
Import world.railroad
Import world.train
Import system.time

Class RailroadRock Extends Actor

	Method New()
		gravityBound = False
		behavior = New EmptyBehavior()
		
		boxLeft = 0
        boxRight = 60
        boxUp = 80
        boxDown = 0
		x = Screen.WIDTH
		z = Railroad.DEPTH

		image = Assets.instance.graphics.Get(Assets.GFX_RAILROAD_ROCK)
'		Dj.instance.Play(Dj.SFX_RAILROAD_ROCK, True)
	Super.PostConstruct()
	' After PostConstruct since GetHeightOnTopOfGround relies on it.
	' Line should be moved up to x/z assignments again once we get rid of PostConstruct
	y = GetHeightOnTopOfGround()
	End Method
	
	Method Move:Void(world:World)
		x -= Train.TRAIN_SPEED * Time.instance.getDeltaInSecs()
		If (x < Train.TRAIN_END - (Train.TRAIN_END - Train.TRAIN_START) / 6)
			world.RemoveLifecycleAware(Self)
		End
	End
End