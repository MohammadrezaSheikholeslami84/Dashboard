//+------------------------------------------------------------------+
//|                                                    Dashboard.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#property description "> Developer       :  MohammadReza Sheikholeslami"
#property description " "
#property description "> Phone > WhatsApp > Telegram :  +98 920 322 8135"
#property version   "2.00"
input string             comment7         = "===================+ Profit Alarming +===============";//===================+ Profit Closing +=======================
extern bool  AlarmNotification = false;
extern double ProfittoAlarm = 350; // Profit to Alarm
extern int Delay = 5; // Delay In Minutes

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double profitlottarz = 0;
   double losslottarz = 0;
   double profitarz = 0;
   double lossarz = 0;

   Label(0,"A-Lots",0,10,30,CORNER_LEFT_LOWER,"A - Lots : "+DoubleToStr(LotsKoll(),0),"Arial",10,clrWhite);
   Label(0,"P-Lots",0,120,30,CORNER_LEFT_LOWER,"P - Lots : "+DoubleToStr(LotsProfit(),2)+"  |  "+DoubleToStr((ProfitProfit()/100),0)+ " $","Arial",10,clrGreenYellow);
   Label(0,"L-Lots",0,300,30,CORNER_LEFT_LOWER,"L - Lots : "+DoubleToStr(LotsLoss(),2)+"  |  "+DoubleToStr((LossLoss()/100),0)+ " $","Arial",10,clrLightSalmon);


   double temp_positive = 0;
   string temp_name_positive;
   double array_positive[100];
   string array_name_positive[100];
   double temp_negative = 0;
   string temp_name_negative;
   double array_negative[100];
   string array_name_negative[100];
   int total_positive = 0;
   int total_negative = 0;


   static datetime t1;
   if(t1 != iTime(NULL,Delay,0))
     {
      ProfitAlarm();
      t1 = iTime(NULL,Delay,0);
     }
   for(int i = 0 ; i < SymbolsTotal(True) ; i++)
     {
      if(ProfitOrders(SymbolName(i, True)) > 0)
        {
         profitlottarz += ProfitLotsArz(SymbolName(i,True));
         profitarz += ProfitOrders(SymbolName(i,True));
         array_positive[total_positive] = NormalizeDouble(ProfitOrders(SymbolName(i, True)),2);
         array_name_positive[total_positive] = SymbolName(i, true);
         total_positive ++;
        }
      if(ProfitOrders(SymbolName(i, True)) < 0)
        {
         losslottarz += ProfitLotsArz(SymbolName(i,True));
         lossarz += ProfitOrders(SymbolName(i,True));
         array_negative[total_negative] = NormalizeDouble(ProfitOrders(SymbolName(i, True)),2);
         array_name_negative[total_negative] = SymbolName(i, true);
         total_negative ++;
        }
     }
   for(int i = 0 ; i < total_positive ; i++)
     {
      for(int j = i + 1 ; j < total_positive ; j++)
        {
         if(array_positive[i] < array_positive[j])
           {
            temp_positive = array_positive[j];
            temp_name_positive = array_name_positive[j];
            array_positive[j] = array_positive[i];
            array_name_positive[j] = array_name_positive[i];
            array_positive[i] = temp_positive;
            array_name_positive[i] = temp_name_positive;
           }
        }
     }
   for(int i = 0 ; i < total_negative ; i++)
     {
      for(int j = i + 1 ; j < total_negative ; j++)
        {
         if(array_negative[i] > array_negative[j])
           {
            temp_negative = array_negative[j];
            temp_name_negative = array_name_negative[j];
            array_negative[j] = array_negative[i];
            array_name_negative[j] = array_name_negative[i];
            array_negative[i] = temp_negative;
            array_name_negative[i] = temp_name_negative;
           }
        }
     }
   int hnegative = 0;
   int mnegative = 0;
   int hpositive = 0;
   int mpositive = 0;
   int npositive = 0;
   for(int i = 0 ; i < total_positive ; i++)
     {
      Button(0, "btt/symbol/" + array_name_positive[i], 0, 120 + mpositive, 20 + hpositive, 90, 50, CORNER_LEFT_UPPER, DoubleToStr(array_positive[i],0)+" - "+ DoubleToStr(LotsOrder(array_name_positive[i]),2), "Arial", 9, clrGreenYellow, clrBlack, clrNONE);
      Button(0, "btt/symbol/NAME" + array_name_positive[i], 0, 30 + mpositive, 20 + hpositive, 80, 50, CORNER_LEFT_UPPER, array_name_positive[i], "Arial Bold", 8, clrWhite, clrGray, clrGray);
      hpositive += 60;
      if(hpositive > 700)
        {
         mpositive += 200;
         hpositive = 0;
        }
     }
   for(int i = 0 ; i < total_negative ; i++)
     {
      Button(0, "btt/symbol/" + array_name_negative[i], 0, 170 + mnegative, 20 + hnegative, 90, 50, CORNER_RIGHT_UPPER, DoubleToStr(array_negative[i],0)+" - "+ DoubleToStr(LotsOrder(array_name_negative[i]),2), "Arial", 9, clrLightSalmon, clrBlack, clrNONE);
      Button(0, "btt/symbol/NAME" + array_name_negative[i], 0, 80 + mnegative, 20 + hnegative, 80, 50, CORNER_RIGHT_UPPER, array_name_negative[i], "Arial Bold", 8, clrWhite, clrGray, clrGray);
      hnegative += 60;
      if(hnegative > 700)
        {
         mnegative += 190;
         hnegative = 0;
        }
     }


   Label(0,"PA-Lots",0,500,30,CORNER_LEFT_LOWER,"PA - Lots : "+DoubleToStr((profitlottarz),2)+"  |  "+DoubleToStr((profitarz/100),0)+ " $","Arial",10,clrGreenYellow);
   Label(0,"LA-Lots",0,700,30,CORNER_LEFT_LOWER,"LA - Lots : "+DoubleToStr((losslottarz),2)+"  |  "+DoubleToStr((lossarz/100),0)+ " $","Arial",10,clrLightSalmon);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && StringSubstr(sparam, 0, 15) == "btt/symbol/NAME" && ObjectGetInteger(0, sparam, OBJPROP_STATE) == true)
     {
      ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
      int    returncodechart = MessageBox("Do you want to Open the " + StringSubstr(sparam, 15, 6) + " Chart ", " Charts ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
      if(returncodechart == 6)
         ChartOpen(StringSubstr(sparam, 15, 6), PERIOD_CURRENT);
     }
   if(id == CHARTEVENT_OBJECT_CLICK && StringSubstr(sparam, 0, 11) == "btt/symbol/" && ObjectGetInteger(0, sparam, OBJPROP_STATE) == true)
     {
      ObjectSetInteger(0, sparam, OBJPROP_STATE, false);
      int    returncodeposition = MessageBox("Do you want to Close All " + StringSubstr(sparam, 11, 6) + " Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
      if(returncodeposition == 6)
         closeAll(StringSubstr(sparam, 11, 6));
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeAll(string symbol)
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == symbol)
            bool yccb = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), 0, clrGreen);
        }
     }
  }

//+------------------------------------------------------------------+
int NumberOrder(string symbol)
  {
   int num = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == symbol)
           {
            num++;
           }
        }
     }
   return(num);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitOrders(string symbol)
  {
   double profitOrders = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == symbol)
            profitOrders += OrderProfit();
        }
     }
   return(profitOrders);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsKoll()
  {
   double LotsKoll = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {

         LotsKoll += OrderLots();
        }
     }
   return(LotsKoll);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitLotsArz(string symbol)
  {
   double ProfitLotsArz = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == symbol)
            ProfitLotsArz += OrderLots();
        }
     }
   return(ProfitLotsArz);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Button(const long                    chart_ID = 0,             // ای دی چارت
            const string            name = "Button",          // اسم
            const int               sub_window = 0,           // شماره پنجره
            const int               x = 0,                    // X فاصله محور
            const int               y = 0,                    // Y فاصله محور
            const int               width = 50,               // عرض دکمه
            const int               height = 18,              // ارتفاع دکمه
            const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // انتخاب گوشه چارت
            const string            text = "Button",          // نوشته درون دکمه
            const string            font = "Arial",           // فونت
            const int               font_size = 10,           // سایز فونت
            const color             clr = clrBlack,           // رنگ نوشته
            const color             back_clr = C'236,233,216', // رنگ دکمه
            const color             border_clr = clrNONE,     // رنگ کادر دکمه
            const bool              state = false,            // حالت دکمه ،کلیک شده / کلیک نشده
            const bool              back = false,             // قرار گرفتن در پشت
            const bool              selection = false,        // قابلیت حرکت
            const bool              hidden = true,            // مخفی شدن از لیست
            const long              z_order = 0)              // اولویت برای کلیک ماوس
  {
   ResetLastError();
   if(ObjectFind(name) == sub_window) // در صورت وجود داشتن ابجیکت
     {
      ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
      ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
      ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
      ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
      ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
      ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
      ChartRedraw();
      return(true);
     }
   else
     {
      if(ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window, 0, 0))
        {
         ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
         ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
         ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
         ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
         ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
         ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
         ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
         ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
         ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
         ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
         ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
         ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
         ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
         ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
         ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
         ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
         ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
         ChartRedraw();
         return(true);
        }
      else
        {
         Print(__FUNCTION__,
               ": failed to create => ", name, " object! Error code = ", GetLastError());
         return(false);
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void ProfitAlarm()
  {
   int counter  = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() >= ProfittoAlarm)
           {
            if(AlarmNotification == True)
              {
               string profit = DoubleToStr(NormalizeDouble(OrderProfit(),0),0);
               SendNotification(OrderSymbol() + " " + DoubleToStr(OrderLots(),2)+" is More than " + DoubleToStr(ProfittoAlarm,0) + " $ Profit : " + profit);
               Alert(OrderSymbol() + " " + DoubleToStr(OrderLots(),2)+ " is More than " + DoubleToStr(ProfittoAlarm,0) + " $  Profit : " +   profit);
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AlertDelay()
  {
   static datetime last_time;
   if(TimeCurrent() - last_time < Delay * 60)
     {
      return(false);
     }
   else
     {
      last_time = TimeCurrent();
      return(true);
     }
  }
///+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitProfit()
  {
   double profitprofit = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() > 0)
            profitprofit += OrderProfit();
        }
     }
   return(profitprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LossLoss()
  {
   double lossloss = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() < 0)
            lossloss += OrderProfit();
        }
     }
   return(lossloss);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsProfit()
  {
   double LotsProfit = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() > 0)
           {
            LotsProfit += OrderLots();
           }
        }
     }
   return(LotsProfit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsLoss()
  {
   double LotsLoss = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() <= 0)
           {
            LotsLoss += OrderLots();
           }
        }
     }
   return(LotsLoss);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsOrder(string symbol)
  {

   double Lotsize = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()== symbol)

           {
            Lotsize += OrderLots();

           }

        }
     }
   return(Lotsize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Label(const char              chart_ID = 0, // ای دی چارت
           const string            name = "Label",           // اسم
           const char               sub_window = 0,           // شماره پنجره
           const short               x = 0,                    // X فاصله محور
           const short               y = 0,                    // Y فاصله محور
           const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // انتخاب گوشه چارت
           const string            text = "Label",           // متن
           const string            font = "Arial",           // فونت
           const char               font_size = 10,           // اندازه فونت
           const color             clr = clrRed,             // رنگ
           const double            angle = 0.0,              // زاویه نوشته
           const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // نقطه اتکا نوشته
           const bool              back = false,             // قرار گرفتن در پشت
           const bool              selection = false,        // قابلیت حرکت
           const bool              hidden = true,            // مخفی شدن از لیست
           const char              z_order = 0)              // اولویت برای کلیک ماوس
  {
   ResetLastError();
   if(ObjectFind(name) == sub_window) // در صورت وجود داشتن ابجیکت
     {
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ChartRedraw();
      return(true);
     }
   else
     {
      if(ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
        {
         ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
         ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
         ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
         ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
         ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
         ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
         ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
         ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
         ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
         ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
         ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
         ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
         ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
         ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
         ChartRedraw();
         return(true);
        }
      else
        {
         Print(__FUNCTION__,
               ": failed to create => ",name," object! Error code = ",GetLastError());
         return(false);
        }
     }
  }
//+------------------------------------------------------------------+
