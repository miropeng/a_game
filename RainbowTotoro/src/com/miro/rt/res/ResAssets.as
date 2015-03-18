

package  com.miro.rt.res
{
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * This class holds all embedded textures, fonts and sounds and other embedded files.  
	 * By using static access methods, only one instance of the asset file is instantiated. This 
	 * means that all Image types that use the same bitmap will use the same Texture on the video card.
	 * 
	 * @author hsharma
	 * 
	 */
	public class ResAssets
	{
		/**
		 * Texture Atlas 
		 */
		[Embed(source="/../embed/mySpritesheet.png")]
		public static const AtlasTextureGame0:Class;
		
		[Embed(source="/../embed/mySpritesheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame1:Class;
		
		/**
		 * Texture Atlas 
		 */
		[Embed(source="/../embed/atlas0.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="/../embed/atlas0.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		
		[Embed(source="/../embed/g0.png")]
		public static const RainbowClip:Class;
		
		/**
		 * Texture Cache 
		 */
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance (there is only oneinstance per app)
		 */
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas=new TextureAtlas(texture, xml);
			}
			
			return gameTextureAtlas;
		}
		
		/**
		 * Returns a texture from this class based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new ResAssets[name]();
				gameTextures[name]=Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
		
		
	}
}


