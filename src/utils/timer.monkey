Strict

Import mojo2
Import system.time

Class Timer

	Global timers:List<Timer> = New List<Timer>()

	Field timeout:Int
	Field callback:Callback
	
	Function addTimer:Void(timer:Timer)
		timers.AddLast(timer)
	End
	
	Function TickTimers:Void()
		For Local timer:Timer = EachIn timers
			timer.Tick()
		Next
	End
	
	Method New(timeout:Int, callback:Callback)
		Self.timeout = timeout
		Self.callback = callback
	End
	
	Method Tick:Void()
		timeout -= Time.instance.lastFrame
		If (timeout <= 0)
			callback.Call()
			timers.RemoveEach(Self)
		End
	End
	
End

Interface Callback
	Method Call:Void()
End