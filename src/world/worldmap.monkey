Strict

Import graphics.assets

Class WorldMap
	Const ZONE_MOUNTAINS:String = "MOUNTAINS"
	Const ZONE_DESERT:String = "DESERT"
	
	Field zoneTypes:Map<String, ZoneType> = New StringMap<ZoneType> ' for each zonetype, its backdrops definition
	Field map:List<ZoneDefinition> = New List<ZoneDefinition> ' list of zone definitions with a zonetype and integer list (backdrops)
	
	Method New()
		InitializeZoneTypes()
		InitMap()
	End Method
	
	Method InitializeZoneTypes:Void()
		zoneTypes.Add(ZONE_MOUNTAINS, New ZoneType(
			[Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0101),
			Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0102),
			Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0103),
			Assets.instance.graphics.Get(Assets.GFX_BD_MOUNTAINS_0104)]))
		
		zoneTypes.Add(ZONE_DESERT, New ZoneType(
			[Assets.instance.graphics.Get(Assets.GFX_BD_DESERT_0201),
			Assets.instance.graphics.Get(Assets.GFX_BD_DESERT_0201)]))
	End Method

	Method InitMap:Void()
		map.AddLast(New ZoneDefinition(zoneTypes.Get(ZONE_MOUNTAINS), New IntList(
			[1, 2, 3, 4, 3, 2, -3, -4, -2, 4, 3, -2, -3, 4, 3, -1])))
		map.AddLast(New ZoneDefinition(zoneTypes.Get(ZONE_DESERT), New IntList(
			[1, 2, 2, 2, 2, 2, 2, -1])))
		map.AddLast(New ZoneDefinition(zoneTypes.Get(ZONE_MOUNTAINS), New IntList(
			[1, 2, 3, -1])))
		map.AddLast(New ZoneDefinition(zoneTypes.Get(ZONE_DESERT), New IntList(
			[1, 2, -1])))
			
	End Method
End Class


Class ZoneType
	Field backdrops:Map<Int, Image> = New IntMap<Image>
	
	Method New(images:Image[]) ' ordered from image 1 to image n
		For Local i:Int = 1 To images.Length
			backdrops.Add(i, images[i - 1])
		End For
	End Method
End Class

Class ZoneDefinition
	Field type:ZoneType 
	Field content:List<Int>
	
	Method New(type:ZoneType, content:List<Int>)
		Self.type = type
		Self.content = content
	End Method
End Class