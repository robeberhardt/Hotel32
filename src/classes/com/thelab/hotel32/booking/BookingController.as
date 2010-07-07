package com.thelab.hotel32.booking
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.CalendarBackground;
	import com.thelab.hotel32.CalendarBackgroundDoubleWide;
	import com.thelab.hotel32.CloseBox;
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.helpers.BasicButton;
	import com.thelab.hotel32.helpers.BasicTextTag;
	import com.thelab.hotel32.helpers.CloseX;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.AppStage;
	import com.thelab.hotel32.views.ViewController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import nid.events.calendarEvent;
	import nid.utils.dateChooser.DateChooser;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	public class BookingController extends Sprite
	{
		private var holder							: Sprite;
		private var doubleHolder					: Sprite;
		private var shield							: BookingShield;
		private var bookButton						: BookingButton;
		private var ratesButton						: CheckRatesButton;
		private var calendar						: DateChooser;
		private var title							: BasicTextTag;
		private var closeBox						: CloseX;
		private var closeBox2						: CloseX;
		private var doubleMode						: Boolean = true;
		
		public var activated						: Signal;
		
		private var _active							: Boolean = false;
		
		public function BookingController()
		{
			activated = new Signal(Boolean);
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// hook up with view controller so we can pause video, etc
			ViewController.getInstance().registerBookingController(activated);
			
			shield = new BookingShield();
			addChild(shield);
			shield.clickedSender.add(closeBookingScreen);
			
			bookButton = new BookingButton("booking");
			addChild(bookButton);
			bookButton.show();
			bookButton.clickedSender.add(openBookingScreen);
			
			// calendar module
			holder = new Sprite();
			holder.addChild(new CalendarBackground());
			holder.x = AppStage.getInstance().center.x - Math.round(holder.width * .5);
			holder.y = AppStage.getInstance().center.y - Math.round(holder.height * .5) + 80;
			holder.visible = false;
			holder.alpha = 0;
			addChild(holder);
			
			//holder.addEventListener(MouseEvent.CLICK, onHolderClick);
			
			closeBox = new CloseX();
			closeBox.x = holder.width + 38;
			closeBox.y =  - 1;
			closeBox.alpha = 1;
			closeBox.show();
			holder.addChild(closeBox);
			closeBox.clickedSender.add(closeBookingScreen);
			
			calendar = new DateChooser();
			calendar.scaleX = calendar.scaleY = 1.5;
			
			calendar.x = 18;
			calendar.y = -26;
			calendar.embedFonts = true;
//			calendar.font = FontLibrary.ARIAL_BOLD_FORMAT;			
			calendar.WeekStart = "sunday";
			calendar.dateField.fieldColor = 0xcccccc;
			calendar.Months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			holder.addChild(calendar);
//			calendar.addEventListener(calendarEvent.CHANGE, getdate);
			
			ratesButton = new CheckRatesButton("rates");
			ratesButton.x = 320;
			ratesButton.y = 320;
			holder.addChild(ratesButton);
			ratesButton.show();
			ratesButton.clickedSender.add(checkRates);
			
			title = new BasicTextTag("SELECT YOUR ARRIVAL DATE:");
			title.x = 42;
			title.y = -22;
//			title.visible = false;
//			title.alpha = 0;
			holder.addChild(title);
			
			makeDouble();
			
		}
		
		private function onHolderClick(e:MouseEvent=null):void
		{
			TweenMax.to(holder, .25, { autoAlpha: 0 } );
			TweenMax.to(doubleHolder, .5, { autoAlpha: 1 } );
			closeBox.show();
		}
				
		private function makeDouble():void
		{
			doubleHolder = new Sprite();
			doubleHolder.addChild(new CalendarBackgroundDoubleWide());
			doubleHolder.x = AppStage.getInstance().center.x - Math.round(doubleHolder.width * .5);
			doubleHolder.y = AppStage.getInstance().center.y - Math.round(doubleHolder.height * .5) + 80;
			doubleHolder.visible = false;
			doubleHolder.alpha = 0;
			addChild(doubleHolder);
			
			var calendar1:DateChooser = new DateChooser();
			calendar1.scaleX = calendar1.scaleY = 1.5;
			
			calendar1.x = 23;
			calendar1.y = -26;
			calendar1.embedFonts = true;
			calendar1.WeekStart = "sunday";
			calendar1.dateField.fieldColor = 0xcccccc;
			calendar1.Months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			doubleHolder.addChild(calendar1);
			
			var calendar2:DateChooser = new DateChooser();
			calendar2.scaleX = calendar2.scaleY = 1.5;
			
			calendar2.x = 343;
			calendar2.y = -26;
			calendar2.embedFonts = true;
			calendar2.WeekStart = "sunday";
			calendar2.dateField.fieldColor = 0xcccccc;
			calendar2.Months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			doubleHolder.addChild(calendar2);
			
			var title1 : BasicTextTag = new BasicTextTag("SELECT YOUR ARRIVAL DATE:");
			title1.x = 42;
			title1.y = -22;
			doubleHolder.addChild(title1);
			
			var title2 : BasicTextTag = new BasicTextTag("SELECT YOUR DEPARTURE DATE:");
			title2.x = 360;
			title2.y = -22;
			doubleHolder.addChild(title2);
			
			var ratesButton2 = new CheckRatesButton("rates");
			ratesButton2.x = 642;
			ratesButton2.y = 320;
			doubleHolder.addChild(ratesButton2);
			ratesButton2.show();
			ratesButton.clickedSender.add(checkRates);
			
			closeBox2 = new CloseX();
			closeBox2.x = 698;
			closeBox2.y =  - 1;
			closeBox2.alpha = 1;
			closeBox2.show();
			doubleHolder.addChild(closeBox2);
			closeBox2.clickedSender.add(closeBookingScreen);
			
			//doubleHolder.addEventListener(MouseEvent.CLICK, onDoubleClick);

		}
		
		private function toggleHolderDemo():void
		{
			if (holder.visible)
			{
				doubleMode = true;
				onHolderClick();
			}
			else
			{
				doubleMode = false;
				onDoubleClick();
			}
		}
		
		private function onDoubleClick(e:MouseEvent=null):void
		{
			TweenMax.to(doubleHolder, .25, { autoAlpha: 0 } );
			TweenMax.to(holder, .5, { autoAlpha: 1 } );
			closeBox2.show();
		}
		
		private function initWide(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// hook up with view controller so we can pause video, etc
			ViewController.getInstance().registerBookingController(activated);
			
			shield = new BookingShield();
			addChild(shield);
			shield.clickedSender.add(closeBookingScreen);
			
			bookButton = new BookingButton("booking");
			addChild(bookButton);
			bookButton.show();
			bookButton.clickedSender.add(openBookingScreen);
			
			// calendar module
			holder = new Sprite();
			holder.addChild(new CalendarBackgroundDoubleWide());
			holder.x = AppStage.getInstance().center.x - Math.round(holder.width * .5);
			holder.y = AppStage.getInstance().center.y - Math.round(holder.height * .5) + 80;
//			holder.visible = false;
//			holder.alpha = 0;
			addChild(holder);
		}
		
		public function closeBookingScreen():void
		{
			shield.active = false;
			bookButton.active = true;
			closeBox.hide();
			TweenMax.to(holder, .25, { autoAlpha: 0 } );
			TweenMax.to(doubleHolder, .25, { autoAlpha: 0 } );
			activated.dispatch(false);
			keyboardOff();
			active = false;
		}
		
		public function openBookingScreen(theButton:BasicButton):void
		{
//			Logger.log("You clicked the booking button!");
			shield.active = true;
			bookButton.active = false;
			
			if (doubleMode)
			{
				TweenMax.to(doubleHolder, .25, { autoAlpha: 1 } );
				closeBox2.show();
			}
			else
			{
				TweenMax.to(holder, .25, { autoAlpha: 1 } );
				closeBox.show();
			}
			
			activated.dispatch(true);
			active = true;
			keyboardOn();
			
//			TweenMax.to(holder, .25, { autoAlpha: 1 } );
//			closeBox.show();
//			TweenMax.to(title, .25, { autoAlpha: 1 } );
			//TweenMax.to(closeBox, .25, { autoAlpha: 1 } );
			
		}
		
		private function checkRates(theButton:BasicButton):void
		{
			Logger.log("running off to check rates");
		}
		
		private function keyboardOn():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
		}
		
		private function keyboardOff():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32) // space
			{
				toggleHolderDemo();
			}
		}


		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

	}
}