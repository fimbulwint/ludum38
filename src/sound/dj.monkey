Strict

Public

Import mojo2
Import system.time 

Class Dj
Public

	Const MUSIC_INGAME:String = "Small_World.mp3"

	Global instance:Dj = New Dj()
	
	Method New()
	End Method
	
	Method PlayInGameMusic:Void()
		PlayMusic(MUSIC_INGAME)
		SetMusicVolume(0.5)
	End Method
	
	Method StopInGameMusic:Void()
		StopMusic()
	End Method
	
	Method Play:Int(sound:Sound, loop:Bool = False)
		Local channel:Int = FindFreeChannel()
		If (loop)
			PlaySound(sound, channel, 1)
		Else	
			PlaySound(sound, channel)
		End If
		Return channel
	End Method
	
	Method PlayDelayed:Void(sound:Sound, minDelay:Int, maxDelay:Int)
		Local delay:Int = Rnd(minDelay, maxDelay + 1)
		queue.AddLast(New QueuedSound(sound, Time.instance.actTime + delay))
		queue.Sort()
	End Method
	
	Method Update:Void()
		While (Not queue.IsEmpty())
			Local sound:QueuedSound = queue.First()
			If (Time.instance.actTime >= sound.time)
				Play(sound.sound)
				queue.RemoveFirst()
			Else
				Return ' nothing else to do
			End If
		End While
	End Method
		
Private

	Field queue:Queue = New Queue()

	Method FindFreeChannel:Int()
		Local i:Int = 0
		Local channel:Int = -1
		While (channel = -1 And i < 32)
			If (ChannelState(i) = 0)
				channel = i
			End If
			i += 1
		End While
		
		If (channel = -1) Then Return 0 'reuse first one
		Return channel
	End Method

End Class

Private

Class QueuedSound
Public
	Field sound:Sound
	Field time:Int
	Method New(sound:Sound, time:Int)
		Self.sound = sound
		Self.time = time
	End Method
End Class

Class Queue Extends List<QueuedSound>
	Method Compare:Int(a:QueuedSound, b:QueuedSound)
		If (a.time < b.time) Then Return -1
		If (a.time > b.time) Then Return 1
		Return 0
	End Method
End Class