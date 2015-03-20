package com.miro.rt.obj 
{

	import com.miro.rt.res.ResAssets;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Dynamics.b2Body;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * @author Aymeric
	 */
	public class RainbowDrawer extends Sprite {
		
		[Embed(source="/../embed/g0.png")]
		private var Ground:Class;
		
		private var _fullTexture:Bitmap;
		
		private var _groundTextures:Vector.<Texture>;
		
		private var _sliceWidth:uint;
		private var _sliceHeight:uint;
		
		private var _images:Vector.<Image>;
		
		private var _flagAdded:Boolean = false;
		
		private var _textureIndex:int = 0;
		private var _scale:Number;
		
		public function RainbowDrawer(scale:Number) {
			_scale = scale;
		}
		
		public function init(sliceWidth:uint, sliceHeight:uint):void {
			
			_sliceWidth = sliceWidth;
			_sliceHeight = sliceHeight;
			
			_groundTextures = new Vector.<Texture>();
			
			_fullTexture = new ResAssets.RainbowClip() as Bitmap;
			var bd:BitmapData = _fullTexture.bitmapData;
			
			for (var i:uint = 0; i < 10; i++)
			{
				var draw:BitmapData = new BitmapData(_sliceWidth, sliceHeight, false, 0x000000);
				draw.copyPixels(bd, new Rectangle(i*_sliceWidth, 0, _sliceWidth, sliceHeight), new Point(0,0));
				_groundTextures.push(Texture.fromBitmapData(draw, true, true));	
			}
			
			_images = new Vector.<Image>();
			
			addEventListener(Event.ADDED, _added);
		}
		
		private function _added(evt:Event):void {
			
			_flagAdded = true;
			removeEventListener(Event.ADDED_TO_STAGE, _added);
		}
		
		public function update():void 
		{
			 //we don't want to move the parent like StarlingArt does!
			if (_flagAdded)
			{
				this.parent.x = this.parent.y = 0;
			}
		}
		
		public function createSlice(body:b2Body, nextYPoint:Number, currentYPoint:Number):void 
		{
			var image:Image = new Image(_groundTextures[_textureIndex]);
			addChild(image);                                                                                                    
			_images.push(image);
			
			var matrix:Matrix = image.transformationMatrix;
//			matrix.translate(body.GetPosition().x * 30, currentYPoint);  // body.GetPosition().x * _box2D.scale
			matrix.translate(body.GetPosition().x * _scale, currentYPoint); 
			matrix.a = 1.04;
			matrix.b = (nextYPoint - currentYPoint)  / _sliceWidth;
			image.transformationMatrix.copyFrom(matrix); 
			
			_textureIndex = (_textureIndex == _groundTextures.length-1) ? 0 : ++_textureIndex;
			
		}
		
		public function deleteHill(index:uint):void {
			removeChild(_images[index], true);
			_images[index] = null;
			_images.splice(index, 1);
		}
		
		public function destroy():void
		{
			 Ground = null;
			
			if(_fullTexture)
			{
				_fullTexture.bitmapData.dispose();
				_fullTexture= null;
			}
			
			for each(var t:Texture in _groundTextures)
			{
				t.dispose();
			}
			_groundTextures = null;
			
			for each(var i:Image in _images)
			{
				i.dispose();
			}
			_images = null;
		}
	}
}