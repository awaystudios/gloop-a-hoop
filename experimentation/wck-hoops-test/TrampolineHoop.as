package
{

	import shapes.Box;

	/*
	* A hoop that makes gloop bounce normally.
	* NOTE: A restitution value greater than 0.5 can actually impulse the gloop artificially ( velocity gain ).
	* The final velocity is affected by the gloop's incident velocity.
	* */
	public class TrampolineHoop extends Box
	{
		public override function create():void {
			type = "Static";
			this.restitution = 1.25;
			super.create();
		}
	}
}
