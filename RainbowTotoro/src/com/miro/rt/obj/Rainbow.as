package com.miro.rt.obj 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import citrus.objects.platformer.box2d.Hills;

	
	public class Rainbow extends Hills
	{
		private var _initHillPlatform:Boolean;
		private var _amplitude:Number;
		
		public function Rainbow(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override protected function _prepareSlices():void {
			
			if (view)
				(view as HillsTexture).init(sliceWidth, sliceHeight);
			
			super._prepareSlices();
		}
		
		override protected function _pushHill():void {
			if (view)
				(view as HillsTexture).createSlice(body, _nextYPoint * _box2D.scale, _currentYPoint * _box2D.scale);
			
			super._pushHill();
		}
		
		override protected function _deleteHill(index:uint):void {
			
			if(view)
				(view as HillsTexture).deleteHill(index);
			
			super._deleteHill(index);
		}
		
		
		override protected function _createSlice():void {
			// Every time a new hill has to be created this algorithm predicts where the slices will be positioned
			if (_indexSliceInCurrentHill >= _slicesInCurrentHill) {
				hillStartY += _randomHeight;
				
				if(roundFactor == 0) ++roundFactor;			
				
				_amplitude = 0;
				
				var hillWidth:Number = sliceWidth * roundFactor + Math.ceil(Math.random() * (roundFactor / 2) + roundFactor / 2) * sliceWidth;
				
				_slicesInCurrentHill = hillWidth / sliceWidth;
				if(_slicesInCurrentHill % 2 != 0) ++_slicesInCurrentHill;
				
				_indexSliceInCurrentHill = 0;
				
				if (_realWidth > 0)
				{
					while (true)
					{
						_amplitude =  Math.random() * hillWidth / 7.5;
						if(Math.abs(_realHeight  + _amplitude) <= 550 && _amplitude > 50)
						{
							break;
						}
					}
					
				} else {
					_amplitude = 0;
				}
				
				_realWidth += hillWidth;
				
				_randomHeight = _amplitude;
				_realHeight += _amplitude;
				_realHeight -= _amplitude;
				hillStartY -= _randomHeight;
			}
			
			
			if (_indexSliceInCurrentHill == _slicesInCurrentHill / 2)
			{
				hillStartY -= _amplitude;
				_randomHeight = _amplitude;	
				hillStartY += _randomHeight;
			}
			
			
			// Calculate the position slice
			_currentYPoint = _sliceVectorConstructor[0].y = (hillStartY + _randomHeight *  Math.cos(2 * Math.PI / _slicesInCurrentHill * _indexSliceInCurrentHill)) / _box2D.scale;
			_nextYPoint =_sliceVectorConstructor[1].y = (hillStartY + _randomHeight *  Math.cos(2 * Math.PI / _slicesInCurrentHill * (_indexSliceInCurrentHill+1))) / _box2D.scale;
//			trace(hillStartY,_randomHeight,_indexSliceInCurrentHill, _slicesInCurrentHill, "[", _currentYPoint, _nextYPoint, "]");
			
			var slicePolygon:b2PolygonShape = new b2PolygonShape();
			slicePolygon.SetAsVector(_sliceVectorConstructor, 2);
			
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set(_slicesCreated * sliceWidth/_box2D.scale, 0);
			
			var sliceFixture:b2FixtureDef = new b2FixtureDef();
			sliceFixture.shape = slicePolygon;
			
			_body = _box2D.world.CreateBody(_bodyDef);
			_body.SetUserData(this);
			_body.CreateFixture(sliceFixture);
			_pushHill();
		}
	}
}