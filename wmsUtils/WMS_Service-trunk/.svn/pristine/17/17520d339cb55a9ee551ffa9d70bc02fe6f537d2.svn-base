package com.bcldb.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

public class DateUtility {
	
	public static final String dateTimeFormat = "yyyy.MM.dd.HH.mm.ss";
	public static final String dateFormat = "yyyy-MM-dd";
	
    /*
     * Converts java.util.Date to XMLGregorianCalendar 
     */
	public static XMLGregorianCalendar toXMLGregorianCalendar(Date dateToConvert) throws DatatypeConfigurationException {
		GregorianCalendar cal = new GregorianCalendar();
		cal.setTime(dateToConvert);
		return DatatypeFactory.newInstance().newXMLGregorianCalendar(cal);
	}
	
	public static XMLGregorianCalendar toXMLGregorianCalendar(String buildTime) throws DatatypeConfigurationException, ParseException {
       	Date date = new SimpleDateFormat(dateFormat).parse(buildTime);
        return toXMLGregorianCalendar(date);
    }	
	
    /*
     * Converts XMLGregorianCalendar to java.util.Date in Java
     */
    public static Date toDate(XMLGregorianCalendar calendar, int offset){
        if(calendar == null) {
            return null;
        }
        Calendar cal = calendar.toGregorianCalendar();
        cal.add(Calendar.DATE, offset);
        return cal.getTime();
    }
    
    /*
     * Format Date to provided Format and returns as a String  
     */
	public static String getFormattedDate(Date aDate) {
		return new SimpleDateFormat(dateTimeFormat).format(aDate);
	}    
}
