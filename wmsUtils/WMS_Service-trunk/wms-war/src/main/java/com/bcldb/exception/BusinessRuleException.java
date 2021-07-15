package com.bcldb.exception;

import javax.ejb.EJBException;

public class BusinessRuleException extends EJBException {
    
	private static final long serialVersionUID = 6328439798350899856L;
  
    public BusinessRuleException(String string) {
        super(string);
    }
  
}
