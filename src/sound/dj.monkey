Strict

Public

Import mojo2
Import system.time 

Class Dj
Public

	Const MUSIC_INGAME:String = "Small_World.mp3"
	
	Const SFX_MUTANT_CALL:String = "mutant_call.mp3"
	Const SFX_MUTANT_DIE:String = "mutant_die.mp3"
	Const SFX_MUTANT_JUMP:String = "mutant_jump.mp3"
	Const SFX_SURVIVOR_DIE:String = "player_die.mp3"
	Const SFX_SURVIVOR_JUMP:String = "survivor_jump.mp3"
	Const SFX_SURVIVOR_OUCH:String = "survivor_ouch.mp3"
	Const SFX_SURVIVOR_PUNCH:String = "survivor_punch.mp3"
	Const SFX_TRAIN:String = "train.mp3"
	

	Global instance:Dj = New Dj()
	
	Field sfx:Map<String, Sound> = New StringMap<Sound>
	
	Method Init:Void()
		sfx.Add(SFX_MUTANT_CALL, LoadSound(SFX_MUTANT_CALL))
		sfx.Add(SFX_MUTANT_DIE, LoadSound(SFX_MUTANT_DIE))
		sfx.Add(SFX_MUTANT_JUMP, LoadSound(SFX_MUTANT_JUMP))
		sfx.Add(SFX_SURVIVOR_DIE, LoadSound(SFX_SURVIVOR_DIE))
		sfx.Add(SFX_SURVIVOR_JUMP, LoadSound(SFX_SURVIVOR_JUMP))
		sfx.Add(SFX_SURVIVOR_OUCH, LoadSound(SFX_SURVIVOR_OUCH))
		sfx.Add(SFX_SURVIVOR_PUNCH, LoadSound(SFX_SURVIVOR_PUNCH))
		sfx.Add(SFX_TRAIN, LoadSound(SFX_TRAIN))
	End Method
	
	Method PlayMusic:Void(music:String)
		mojo2.PlayMusic(music)
		SetMusicVolume(0.3)
	End Method
	
	Method StopMusic:Void()
		mojo2.StopMusic()
	End Method
	
	Method Play:Int(sfx:String, loop:Bool = False)
		Return Play(Self.sfx.Get(sfx), loop)
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
		Local i:Int = 1
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