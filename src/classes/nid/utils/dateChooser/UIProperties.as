package nid.utils.dateChooser
{
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;

	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class UIProperties extends MovieClip
	{
//		[Embed(source = "./asset/icon.png")]
//			private var icon:Class;
		
		public var isHidden				:Boolean;
		public var calendarIcon			:iconSprite;
		public var dateField			:DateField;
		public var myMenu			 	:ContextMenu;
		public var oldHit		 		:* = undefined;
		public var font					:String = FontLibrary.FUTURA_MEDIUM_FORMAT;
		public var embedFonts			:Boolean = false;
		public var letterSpacing		:Number = 13;
		public var MonthAndYearFontSize	:Number = 12;
		public var WeekNameFontSize		:Number = 12;
		public var DayFontSize			:Number = 10;
		public var Days					:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		public var Months				:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		
		protected var Calendar			:MovieClip;
		protected var _icon				:Bitmap;
		protected var inited			:Boolean	=	false;
		protected var isHitted			:Object;
		protected var cellArray			:Array;
		protected var isToday			:Boolean	=	false;
		protected var DaysinMonth		:Array;
		protected var prevDate			:Number;
		protected var today				:Date;
		protected var todaysday			:Number;
		protected var currentyear		:Number;
		protected var currentmonth		:Number;
		protected var currentDateLabel	:TextField;
		protected var selectedDate		:String;
		protected var day_bg			:MovieClip;
		protected var hit				:Sprite;
		protected var day_txt			:TextField;
		protected var _startDay			:String = "sunday";
		protected var _startID			:int = 1;

		/*
		 * COLOR VARIABLES
		 */		
		protected var backgroundColor			:Array	=	[0x910005,0xba292e];
		protected var backgroundStrokeColor		:int	=	0x78020f;
		protected var labelColor				:int	=	0xffffff;
		protected var buttonColor				:int	=	0xffffff;
		protected var DesabledCellColor			:int	=	0x78020f;
		protected var EnabledCellColor			:int	=	0x910005;
		protected var TodayCellColor			:int	=	0xFF0000;
		protected var mouseOverCellColor		:int	=	0xb6252a;
		protected var entryTextColor			:int	=	0xffffff;

		/*
		 *	CALENDAR DIAMENSIONS VARIABLES		 
		 */		
		protected var calendarWidth			:Number		= 165;
		protected var calendarHeight		:Number		= 178;
		protected var cellWidth				:Number		= 20
		protected var cellHeight			:Number		= 20
		protected var labelWidth			:Number		= 8;
		
		public function UIProperties() 
		{
			//_icon = new icon();
		}
		
	}

}