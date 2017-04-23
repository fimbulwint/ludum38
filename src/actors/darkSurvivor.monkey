Strict

Import mojo2
Import actors.survivor

Class DarkSurvivor Extends Survivor

	Method New()
		Super.New()
		
		bla = "DS"
		
		behavior = New EmptyBehavior
	End

End Class