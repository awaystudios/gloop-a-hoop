package
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	public class PbTest extends Sprite
	{
		[Embed(source="ScrambleKernel.pbj", mimeType="application/octet-stream")]
		private var ShaderAsset:Class;

		[Embed(source="landscape.jpg")]
		private var ImageAsset:Class;

		private var _bmp:Bitmap;

		public function PbTest() {
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( MouseEvent.MOUSE_DOWN, stageMouseDownHandler );
			_bmp = new ImageAsset();
			addChild( _bmp );
			trace( "test ready, click anywhere to run a pixel bender shader on the image..." );
		}

		private function stageMouseDownHandler( event:MouseEvent ):void {
			trace( "running test..." );
			var shader:Shader = new Shader( new ShaderAsset() as ByteArray );
			shader.data.inputImage.input = _bmp.bitmapData;
			var output:BitmapData = new BitmapData( _bmp.bitmapData.width, _bmp.bitmapData.height, false, 0 );
			var job:ShaderJob = new ShaderJob( shader, output );
			job.start( true );
			_bmp.bitmapData = output;
			trace( "test completed." );
		}
	}
}
