package
{

	import shapes.Oval;

	/*
	* Physics representation of our main character.
	* */
	public class Gloop extends Oval
	{
		public override function create():void {
			density = 2;
			super.create();
		}
	}
}
