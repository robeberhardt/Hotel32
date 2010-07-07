package nid.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class calendarEvent extends Event 
	{
		public static const CHANGE:String = "change";
		public static const LOADED:String = "loaded";
		
		private var date:String;
		
		public function get selectedDate():String { return date;}
		
		public function calendarEvent(type:String,data:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			date = data;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("calendarEvents", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}