package com.miro.rt.data
{
	public class PatternPath
	{
		private static var _heartPos:Vector.<Array>;
		
		public static function get heartPos():Vector.<Array>
		{
			if(!_heartPos)
			{
				const HEART:String = "3,3|3,4|3,5|3,6|4,2|4,3|4,6|4,7|5,2|5,7|5,8|6,2|6,8|6,9|7,2|7,3|7,9|7,10|8,3|8,4|8,10|8,11|9,4|9,5|9,11|9,12|10,3|10,4|10,10|10,11|11,2|11,3|11,9|11,10|12,2|12,8|12,9|13,2|13,7|13,8|14,2|14,3|14,6|14,7|15,3|15,4|15,5|15,6";
				_heartPos = new Vector.<Array>();
				var heartArr:Array = HEART.split("|");
				for(var i:int = 0; i < heartArr.length; i++)
				{
					var heartPosArr:Array = heartArr[i].split(",");
					_heartPos.push(heartPosArr);
				}
			}
			
			return _heartPos;
		}
	}
}