package com.bcldb.util;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

public abstract class CommonHelper {
    
	public static Date dateAddDays(Date baseDate, int days) throws Exception{
        Calendar c = new GregorianCalendar();
        c.setTime(baseDate);
        c.add(Calendar.DAY_OF_MONTH, days);
        return c.getTime();
    }
    

    public static XMLGregorianCalendar date2Gregorian(Date d) throws Exception{
        XMLGregorianCalendar xd = null;
        if (d != null){            
            GregorianCalendar c = new GregorianCalendar();
            c.setTime(d);
            xd = DatatypeFactory.newInstance().newXMLGregorianCalendar(c);
        }
        return xd;
    }
    
    public static Calendar date2Calendar(Date d) throws Exception{
        Calendar xd = null;
        if (d != null){            
            xd = Calendar.getInstance();
            xd.setTime(d);
        }
        return xd;
    }
    
    public static XMLGregorianCalendar getTimestamp(){
        XMLGregorianCalendar timestamp = null;
        try{
            timestamp = DatatypeFactory.newInstance().newXMLGregorianCalendar(new GregorianCalendar());
        }catch(DatatypeConfigurationException e){
        }
        return timestamp;
    }

}
