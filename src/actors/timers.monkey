Strict

Import mojo2
Import utils.timer
Import actors.actor
Import actors.survivor

Class DefaultRecoveringTimeout Extends Timer Implements Callback

	Field actor:Actor
	
	Method New(actor:Actor)
		Super.New(500, Self)
		Self.actor = actor
	End
	
	Method Call:Void()
		actor.attributes.state = State.DEFAULT_STATE
	End

End

Class DefaultPunchTimeout Extends Timer Implements Callback

	Field survivor:Survivor
	
	Method New(survivor:Survivor)
		Super.New(200, Self)
		Self.survivor = survivor
	End
	
	Method Call:Void()
		survivor.punching = False
		survivor.punchCoolingDown = True
		Timer.addTimer(New DefaultPunchCooldown(survivor))
	End
	
End

Class DefaultPunchCooldown Extends Timer Implements Callback

	Field survivor:Survivor
	
	Method New(survivor:Survivor)
		Super.New(200, Self)
		Self.survivor = survivor
	End
	
	Method Call:Void()
		survivor.punchCoolingDown = False
	End
	
End