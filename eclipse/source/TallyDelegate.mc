/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * This class handles the button presses/actions for the Tally widget.
 * 
 * Copyright (c) 2017, 2018 Ascending Edge, LLC.
 */
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Timer;


/** 
 * This class handles the button presses/actions for the Tally widget.
 *
 * There are two modes: viewing, and editing mode.  The viewing mode
 * shows the current count value.  The adjustment mode allows
 * adjustment of the counter.
 */
class TallyDelegate extends Ui.BehaviorDelegate 
{
     /// Easy access to the application instance.
	var m_app = null;

     /// This is used to check for a double-press of the start/stop button
     var m_pressCount = 0;

     /// This timer is used to detect double-taps of the start/stop button.
     var m_timer = null;

     /// This flag is used to prevent arming the timer when it is
     /// already active.
     var m_timerActive = false;


     function initialize() 
     {
          BehaviorDelegate.initialize();
          m_app = App.getApp();
          m_pressCount = 0;
          m_timer = new Timer.Timer();
          m_timerActive = false;
     }

     
     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment mode decrement the counter and return to viewing
      * mode.
      */
     function onNextPage() 
     {
          System.println("next page");
          if(m_app.getMode() == m_app.MODE_VIEW)
          {
               return false;
          }
          m_app.dec();
          m_app.setMode(m_app.MODE_VIEW);
          Ui.popView(Ui.SLIDE_IMMEDIATE);
          return true;
     }


     /** 
      * When in viewing mode pass the input on unhandled.  When in
      * adjustment mode increment the counter and return to viewing
      * mode.
      */
     function onPreviousPage() 
     {
          System.println("prev page");
		if(m_app.getMode() == m_app.MODE_VIEW)
		{
			return false;
		}
		m_app.inc();
		m_app.setMode(m_app.MODE_VIEW);
          Ui.popView(Ui.SLIDE_IMMEDIATE);
          return true;
     }


     /** 
      * This is called when the back/lap button is pressed.  If the
      * widget is in viewing mode it will exit by letting the system
      * handle the input.  When in adjustment mode this will reset the
      * counter to zero and return to viewing mode.
      */
     function onBack() 
     {
          System.println("back");
          if(m_app.getMode() == m_app.MODE_VIEW)
          {
               System.println("exiting");
               return false;
          }
          m_app.setMode(m_app.MODE_VIEW);
          // Reset the counter
          m_app.reset();
		Ui.popView(Ui.SLIDE_IMMEDIATE);
          return true;
     }

     function timerCallback()
     {
          System.println("timer callback");
          
          // reset the timer and press count
          var pressCount = m_pressCount;
          m_pressCount = 0;
          m_timerActive = false;
          
          // The timer should never be armed unless start/stop is
          // pressed.
          if(pressCount <= 0)
          {
               System.println("impossible condition!  Programmer error!");
               return;
          }
          
          // Has the start/stop button been pressed more than once
          // during the time period?  If so increase the counter by
          // the number of double-taps on the button.
          if(pressCount > 1)
          {
               m_app.incBy(pressCount / 2);
               Ui.requestUpdate();
               return;
          }

          // The start/stop button was pressed only one time.
          if(m_app.getMode() == m_app.MODE_ADJUST)
          {
               m_app.setMode(m_app.MODE_VIEW);
               Ui.popView(Ui.SLIDE_IMMEDIATE);
               return;
          }

          m_app.setMode(m_app.MODE_ADJUST);
          Ui.pushView(new TallyView(), self, Ui.SLIDE_IMMEDIATE);
     }     


     /** 
      * This is called when the start/stop button is pressed.  This
      * toggles the mode between adjustment and viewing modes.
      */
     function onSelect() 
     {
          System.println("select");

          // If the timer hasn't already been armed, arm it.  In the
          // callback we will determine if the button has been
          // double-tapped.  Yes, this introduces latency to a
          // single-tap but I think it's worth having the convenience
          // of a double-tap event.
          if(!m_timerActive)
          {
               // I wish I could query the m_timer to see if it is
               // active.
               m_timerActive = true;
               // 300 ms seems to be a reasonable amount of time for a
               // double-tap without adding too much latency to the
               // response for a single press.  This might need
               // adjustment.
               m_timer.start(method(:timerCallback), 300, false);
          }
          
          // Keep track of how many times the star/stop button is
          // pressed.  This will be reset in the timer callback.
          ++m_pressCount;          
          return true;
     }
}
