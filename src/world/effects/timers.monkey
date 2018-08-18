Strict

Import utils.timer
Import world.effects.worldEffect

Class EffectRemovalTimer Extends Timer Implements Callback

	Field effect:WorldEffect
	Field world:World 
	
	Method New(millisecs:Int, effect:WorldEffect, world:World)
		Super.New(millisecs, Self)
		Self.effect = effect
		Self.world = world
	End
	
	Method Call:Void()
		world.RemoveWorldEffect(effect)
	End
	
End Class