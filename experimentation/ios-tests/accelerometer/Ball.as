package accelerometer
{

	import shapes.Circle;

	public class Ball extends Circle
	{
		public function Ball( radius:Number ) {
			this.graphics.beginFill( 0xFF0000 );
			this.graphics.drawCircle( 0, 0, radius );
			this.graphics.endFill();
			super();
		}
	}
}
