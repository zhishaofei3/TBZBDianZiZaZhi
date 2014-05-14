package utils.common.util {

	import com.adobe.images.JPGEncoder;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class PhotoGraphyUtil extends Sprite {
		public function PhotoGraphyUtil():void {
		}

		public static function copyToJPG(sp:Sprite):ByteArray {
			var _encoder:JPGEncoder = new JPGEncoder(100);
			var bitmapData:BitmapData = new BitmapData(140, 226);
			bitmapData.draw(sp);
			var ba:ByteArray = _encoder.encode(bitmapData);
			return ba;
		}

		public static function bitmapToByteArray(sp:Sprite):ByteArray {
			var bmd:BitmapData = new BitmapData(140, 226, true, 0xFFFFFF);
			bmd.draw(sp, null, null, null, null, false);
			var rect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
			var bytes:ByteArray = new ByteArray();
			bytes.writeUnsignedInt(bmd.width);
			bytes.writeBytes(bmd.getPixels(rect));
			bytes.compress();
			return bytes;
		}

		/*
		 测试用
		 public static function bitmapToByteArray(st:Stage):ByteArray {
		 var bmd:BitmapData = new BitmapData(100, 160, true, 0xFFFFFF);
		 var matrix:Matrix = new Matrix();
		 matrix.scale(100 / Main.st.stageWidth, 160 / Main.st.stageHeight);
		 bmd.draw(st, matrix, null, null, null, false);
		 var rect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
		 var bytes:ByteArray = new ByteArray();
		 bytes.writeUnsignedInt(bmd.width);
		 bytes.writeBytes(bmd.getPixels(rect));
		 bytes.compress();
		 return bytes;
		 }
		 */
		public static function byteArrayToBitmap(ba:ByteArray):Bitmap {
			ba.uncompress();
			var width:int = ba.readUnsignedInt();
			var height:int = ((ba.length - 4) / 4) / width;
			var bmd:BitmapData = new BitmapData(width, height, true, 0);
			bmd.setPixels(bmd.rect, ba);
			var bm:Bitmap = new Bitmap(bmd);
			return bm;
		}
	}
}
