using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;
/* 時間處理 */
public class Cls_Date
{
    string YYYY = "";
    string MM = "";
    string dd = "";
    string hh = "";
    string mm = "";
    string ss = "";
    public string[] DateTimeList = {  
              "yyyyMMddhhmmss",                
              "yyyyMMdd",
              "yyyy/M/d tt hh:mm:ss",   
              "yyyy/MM/dd tt hh:mm:ss",   
              "yyyy/MM/dd HH:mm:ss",   
              "yyyy/M/d HH:mm:ss",   
              "yyyy/M/d",   
              "yyyy/MM/dd"   
              };
    public Cls_Date()
	{
		
	}


    /* 日期格式化 */
    public DateTime  SetTimeFormat(string TimeString)
    {

        DateTime DataTime1 = DateTime.ParseExact(TimeString, DateTimeList, CultureInfo.InvariantCulture, DateTimeStyles.AllowWhiteSpaces);
        return DataTime1;
    }
    /* 字串轉換datetime */
    public DateTime SetStringToDatetime(string TimeString,string Tyep)
    {
        IFormatProvider cultureStyle = new System.Globalization.CultureInfo("zh-TW", true);
        DateTime DataTime1 = DateTime.ParseExact(TimeString, Tyep, cultureStyle);        
        return DataTime1;
    }

    /* 2時間差距計算 */
    /*  TimeSpan Equal =  oDate.DateDiff("20130105", "20130111");
        RSP.Text = Equal.Days.ToString();
        RSP.Text = Equal.Hours.ToString();
        RSP.Text = Equal.Minutes.ToString();
        RSP.Text = Equal.Seconds.ToString();   */
    public TimeSpan  DateDiff(string TimeString1 , string TimeString2) {
        DateTime Time1 = SetTimeFormat(TimeString1);
        DateTime Time2 = SetTimeFormat(TimeString2);
        long elapsedTicks = Time1.Ticks - Time2.Ticks;
        TimeSpan EqualTime = new TimeSpan(elapsedTicks);

        return EqualTime;
    }
    /* DateTime 轉換為14碼日期字串 Type  D =YYYYMMDD / T =hhmmss / A =YYYYMMDDhhmmss */
    public string DateTimeToTimeString(DateTime sDataTime,string Type) {
        string pReturn="";
        string IND, INT, INA;
        IND = sDataTime.Year.ToString() + sDataTime.Month.ToString().PadLeft(2, '0') + sDataTime.Day.ToString().PadLeft(2, '0');
        INT = sDataTime.Hour.ToString().PadLeft(2, '0') + sDataTime.Minute.ToString().PadLeft(2, '0') + sDataTime.Second.ToString().PadLeft(2, '0');
        INA = IND.Trim() + INT.Trim();
        switch (Type)
        {
            case "D":              pReturn = IND.Trim();
                break;
            case "T":              pReturn = INT.Trim();
                break;
            case "A":              pReturn = INA.Trim();
                break;
            default:             
                break;
        }
        return pReturn;
    }
    /* DateTime 加減時間後回傳 Type = YMDhmss */
    public DateTime DateAdd(DateTime sDataTime,string Type, int time) {
        switch (Type)
        {
            case "Y": sDataTime = sDataTime.AddYears(time);
                break;
            case "M": sDataTime = sDataTime.AddMonths(time);
                break;
            case "D": sDataTime = sDataTime.AddDays(time);
                break;
            case "h": sDataTime = sDataTime.AddHours(time);
                break;
            case "m": sDataTime = sDataTime.AddMinutes(time);
                break;
            case "s": sDataTime = sDataTime.AddSeconds(time);
                break;
            default:
                break;
        }
        return sDataTime;
    }
    /* 時間早晚比較  inClude = 是否包含等於
       1. 小於零  代表 t1 時間 小於 t2 時間
       2. 等於零  代表 t1 時間 等於 t2 時間
       3. 大於零  代表 t1 時間 大於 t2 時間
     */
    public bool DateCompare(DateTime sDataTime1, DateTime sDataTime2,bool inClude){
        int compareValue;
        compareValue = sDataTime1.CompareTo(sDataTime2);
        if (compareValue > 0) {
            return true;
        }
        else if (compareValue == 0 && inClude == true)
        {
            return true;
        }
        else {
            return false;
        }
    }
    /* 格林威治總秒數轉換 */
    public DateTime UtcSecondToDatetime(long sec) {        
        DateTime oTime = new DateTime(1970, 1, 1, 0, 0, 0, 0).AddSeconds(sec);
        return oTime;
    }
    /* 記錄目前時間 */
    public void RecordNow()
    {
        DateTime oTime = new DateTime();
        oTime = System.DateTime.Now;
        YYYY = oTime.Year.ToString();
        MM = oTime.Month.ToString();
        dd = oTime.Day.ToString();
        MM = MM.PadLeft(2, '0');
        dd = dd.PadLeft(2, '0');

        hh = oTime.Hour.ToString();
        mm = oTime.Minute.ToString();
        ss = oTime.Second.ToString();
        hh = hh.PadLeft(2, '0');
        mm = mm.PadLeft(2, '0');
        ss = ss.PadLeft(2, '0');

    }
   
    public void RecordByDatetime(DateTime Datetime1)
    {
        DateTime oTime = new DateTime();
        oTime = Datetime1;
        YYYY = oTime.Year.ToString();
        MM = oTime.Month.ToString();
        dd = oTime.Day.ToString();
        MM = MM.PadLeft(2, '0');
        dd = dd.PadLeft(2, '0');

        hh = oTime.Hour.ToString();
        mm = oTime.Minute.ToString();
        ss = oTime.Second.ToString();
        hh = hh.PadLeft(2, '0');
        mm = mm.PadLeft(2, '0');
        ss = ss.PadLeft(2, '0');

    }

    /* 回傳日期 */
    public string IND { get { return YYYY + MM + dd; } }
    /* 回傳時間 */
    public string INT { get { return hh + mm + ss; } }
    /* 回傳日期時間 */
    public string INA { get { return YYYY + MM + dd + hh + mm + ss; } }
}

/*------------------------------------------------------  我是分格線------------------------------------------------------------------------------ */
/* 農曆換算  DataTime1 = 已進行日期格式化後之DataTime1
        Cls_chinaDate oChina = new Cls_chinaDate(DataTime1);
        RSP.Text = oChina.cDate();
 */
public class Cls_chinaDate
{
    DateTime solarDT;
    public Cls_chinaDate(DateTime solarDT)
    {
        //dt = new DateTime(2006, 1, 29);//農曆2006年大年初一（測試用）
        this.solarDT = solarDT;
    }
    public string cDate()
    {
        ChineseLunisolarCalendar l = new ChineseLunisolarCalendar();

        string sYear = "", sYearArab = "", sMonth = "", sDay = "", sDay10 = "",
               sDay1 = "", sLuniSolarDate = "", sBirthpet = "";

        int iYear, iMonth, iDay;
        iYear = l.GetYear(solarDT);
        iMonth = l.GetMonth(solarDT);
        iDay = l.GetDayOfMonth(solarDT);

        //Format Year
        sYearArab = iYear.ToString();
        for (int i = 0; i < sYearArab.Length; i++)
        {
            sYear += (aDigi)int.Parse(sYearArab.Substring(i, 1));
        }

        //Format Month
        int iLeapMonth = l.GetLeapMonth(iYear);//獲取閏月

        /* 閏月可以出現在一年的任何月份之後。
         * 例如，GetMonth 方法返回一個介於 1 到 13 之間的數字來表示與指定日期關聯的月份。
         * 如果在一年的八月和九月之間有一個閏月，則 GetMonth 方法為八月返回 8，為閏八月返回 9，為九月返回 10。
         */
        if (iLeapMonth > 0 && iMonth <= iLeapMonth)
        {
            string mMonth = "閏" + (aMonth)(iLeapMonth - 1);
            if (iMonth == iLeapMonth)
                sMonth = mMonth;
            else
                sMonth = ((aMonth)iMonth).ToString();
        }
        else if (iLeapMonth > 0 && iMonth > iLeapMonth)
            sMonth = ((aMonth)(iMonth - 1)).ToString();
        else
            sMonth = ((aMonth)(iMonth)).ToString();


        //Format Day
        sDay10 = ((a10)(iDay / 10)).ToString();
        sDay1 = ((aDigi)(iDay % 10)).ToString();
        sDay = sDay10 + sDay1;

        if (iDay == 10) sDay = "初十";
        if (iDay == 20) sDay = "二十";
        if (iDay == 30) sDay = "三十";

        //生肖
        int iBirthYear = l.GetSexagenaryYear(solarDT);
        int iBirthpet = l.GetTerrestrialBranch(iBirthYear);
        sBirthpet = ((birthpet)iBirthpet).ToString();

        //Format Lunar Date
        sLuniSolarDate = string.Format("農曆:{0}年 {1}{2} {3}", sYear, sMonth, sDay, sBirthpet);
        return sLuniSolarDate;
    }

}
public enum birthpet
{
    鼠 = 1, 牛, 虎, 兔, 龍, 蛇, 馬, 羊, 猴, 雞, 狗, 豬
}
public enum aMonth
{
    正月 = 1, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 臘月, 臘月月
}
public enum a10
{
    初, 十, 廿, 卅
}
public enum aDigi
{
    Ｏ, 一, 二, 三, 四, 五, 六, 七, 八, 九
}