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

Class DefaultAttackTimeout Extends Timer Implements Callback

	Field survivor:Survivor
	
	Method New(survivor:Survivor)
		Super.New(200, Self)
		Self.survivor = survivor
	End
	
	Method Call:Void()
		survivor.attackCoolingDown = True
		Timer.addTimer(New DefaultAttackCooldown(survivor))
	End
	
End

Class DefaultPunchTimeout Extends DefaultAttackTimeout
	
	Method New(survivor:Survivor)
		Super.New(survivor)
	End
	
	Method Call:Void()
		Super.Call()
		survivor.punching = False
	End
	
End

Class DefaultKickTimeout Extends DefaultAttackTimeout
	
	Method New(survivor:Survivor)
		Super.New(survivor)
	End
	
	Method Call:Void()
		Super.Call()
		survivor.kicking = False
	End
	
End

Class DefaultAttackCooldown Extends Timer Implements Callback

	Field survivor:Survivor
	
	Method New(survivor:Survivor)
		Super.New(200, Self)
		Self.survivor = survivor
	End
	
	Method Call:Void()
		survivor.attackCoolingDown = False
	End
	
End