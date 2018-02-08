/**
 * @author Greg Rowe <greg.rowe@ascending-edge.com>
 *
 * Copyright (c) 2018 Ascending Edge, LLC.
 */
using Toybox.WatchUi;
using Toybox.System;

/**
 * This class simplifies handle double-press events (actually n-press
 * events) making things like double-pressing the start button simple
 * to handle.
 */
class MultiPressDelegate extends WatchUi.BehaviorDelegate 
{
     /**
      * These are the events that this can handle.
      */
     enum
     {
          EVENT_NONE = 0,
          EVENT_BACK,           
          EVENT_MENU,           
          EVENT_NEXT_MODE,      
          EVENT_NEXT_PAGE,      
          EVENT_PREVIOUS_MODE,  
          EVENT_PREVIOUS_PAGE,  
          EVENT_SELECT,
          EVENT_TAP,
          
          EVENT_LAST            /**< end marker for convenience, this
                                 * is not an event */
     }



     /// The last event that occurred
     protected var m_last;

     /// How many times the button has been press during the timer
     /// period.
     protected var m_pressCount;

     /// Timer instance
     protected var m_timer;

     /// Timer period
     protected var m_timeoutMs;
     

     function initialize(timeoutMs) 
     {
          BehaviorDelegate.initialize();
          m_timeoutMs = timeoutMs;
          m_timer = new Timer.Timer();
          reset();
     }

     
     /**
      * Resets the timer.
      */
     protected function reset()
     {
          // System.println("reset");
          m_last = EVENT_NONE;
          m_pressCount = 0;
          m_timer.stop();
     }


     /**
      * This starts the timer for an event
      *
      * @param event which event initiated the timer
      */
     protected function start(event)
     {
          // System.println("start");          
          m_last = event;
          m_pressCount = 1;
          // System.println("timeout ms: " + m_timeoutMs);
          m_timer.start(method(:timerCallback), m_timeoutMs, false);
     }


     /**
      * This branches out to call individual handler functions.
      *
      * @param event which event occured
      *
      * @param pressCount how many times the event occurred in the
      * timer period
      */
     protected function notify(event, pressCount)
     {
          // I don't really like using a switch here...maybe there is
          // a better way.  Can I do a jump table in Monkey C?
          // System.println("notify: " + pressCount);
          // System.println("event: " + event);
          switch(event)
          {
          case EVENT_BACK:
               onMultiBack(pressCount);
               break;
          case EVENT_MENU:
               onMultiMenu(pressCount);
               break;
          case EVENT_NEXT_MODE:
               onMultiNextMode(pressCount);
               break;
          case EVENT_NEXT_PAGE:
               onMultiNextPage(pressCount);
               break;
          case EVENT_PREVIOUS_MODE:
               onMultiPreviousMode(pressCount);
               break;
          case EVENT_PREVIOUS_PAGE:
               onMultiPreviousPage(pressCount);
               break;
          case EVENT_SELECT:
               onMultiSelect(pressCount);
               break;
          case EVENT_TAP:
               onMultiTap(pressCount);
               break;
               
          case EVENT_NONE:
          case EVENT_LAST:
          default:
               break;
          }
     }


     /**
      * This is called when the timer fires.
      */
     private function timerCallback()
     {
          // System.println("timer callback");
          var pressCount = m_pressCount;
          var last = m_last;
          reset();
          notify(last, pressCount);
     }


     /**
      * This is the event handler logic.  This manages the timer.
      *
      * @param event the event that happened.
      */
     protected function onPress(event)
     {
          // System.println("onPress"); The last event was not the
          // current one so send a notification for what we have so
          // far, reset, and continue processing.
          if(m_last != event)
          {
               notify(m_last, m_pressCount);
               reset();
          }
          
          if(m_pressCount == 0)
          {
               start(event);
               return;
          }
          ++m_pressCount;
     }


     function onBack()
     {
          // System.println("onBack");
          onPress(EVENT_BACK);
          return false;
     }

     
     function onMenu()
     {
          // System.println("onMenu");
          onPress(EVENT_MENU);
          return false;
     }

     
     function onNextMode()
     {
          // System.println("onNextMode");
          onPress(EVENT_NEXT_MODE);
          return false;
     }     

     
     function onNextPage()
     {
          // System.println("onNextPage");
          onPress(EVENT_NEXT_PAGE);
          return false;
     }

     
     function onPreviousMode()
     {
          // System.println("onPreviousMode");
          onPress(EVENT_PREVIOUS_MODE);
          return false;
     }

     
     function onPreviousPage()
     {
          // System.println("onPreviousPage");
          onPress(EVENT_PREVIOUS_PAGE);
          return false;
     }

     
     function onSelect()
     {
          // System.println("onSelect");
          onPress(EVENT_SELECT);
          return false;
     }


     function onTap()
     {
          // System.println("onTap");
          onPress(EVENT_TAP);
          return false;
     }


     function onMultiBack(pressCount)
     {
          // System.println("onMultiBack");
     }


     function onMultiMenu(pressCount)
     {
          // System.println("onMultiMenu");
     }


     function onMultiNextMode(pressCount)
     {
          // System.println("onMultiNextMode");
     }


     function onMultiNextPage(pressCount)
     {
          // System.println("onMultiNextPage");
     }


     function onMultiPreviousMode(pressCount)
     {
          // System.println("onMultiNextMode");
     }


     function onMultiPreviousPage(pressCount)
     {
          // System.println("onMultiPreviousPage");
     }


     function onMultiSelect(pressCount)
     {
           // System.println("onMultiSelect");
     }


     function onMultiTap(pressCount)
     {
          // System.println("onMultiTap");
     }
}
