package accelerometer
{

	import shapes.Box;

	public class Wall extends Box
	{
		public function Wall() {
			var size:Number = 100;
			this.graphics.beginFill( 0x0000FF, 1.0 );
			this.graphics.drawRect( -size / 2, -size / 2, size, size );
			this.graphics.endFill();
			super();
		}

		override public function create():void {
			type = "Static";
			restitution = 0.33;
			super.create();
		}
	}
}
